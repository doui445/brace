#!/usr/bin/env bash
# Replaces the old project-tracker plugin by brace in every tool found on
# this machine (Claude Code, Antigravity). Zero breakage: the old plugin is
# only removed once brace is installed in that tool. Exit 10 (and one
# message) when something was replaced, 0 and silence otherwise.
# All CLI calls share one total time budget; a failed install backs off for hours.
# Bash 3.2 compatible; JSON via python3.
set -uo pipefail

ROOT="${BRACE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
HOME_DIR="${HOME:-}"
# Total budget for all CLI calls: the host kills the hook at ~60 s.
CLI_TIMEOUT="${BRACE_CLI_TIMEOUT:-45}"
DEADLINE=$(($(date +%s) + CLI_TIMEOUT))
BACKOFF_SECS="${BRACE_BACKOFF_SECS:-21600}"
BACKOFF_FILE="${TMPDIR:-/tmp}/brace-swap-backoff"
SWAPPED=""

# bounded CMD...: run with what is left of the total time budget (no
# `timeout` binary on macOS). Past the deadline no call is started.
bounded() {
  local left=$((DEADLINE - $(date +%s)))
  [ "$left" -gt 0 ] || return 124
  "$@" >/dev/null 2>&1 &
  local kids pid=$! i=0 max=$((left * 5))
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$i" -ge "$max" ]; then
      kids="$(pgrep -P "$pid" 2>/dev/null)"
      kill "$pid" 2>/dev/null
      [ -n "$kids" ] && kill $kids 2>/dev/null
      wait "$pid" 2>/dev/null
      return 124
    fi
    sleep 0.2
    i=$((i + 1))
  done
  wait "$pid"
}

in_backoff() {
  [ -f "$BACKOFF_FILE" ] || return 1
  [ "$(python3 -c '
import os, sys, time
try:
    print(1 if time.time() - os.path.getmtime(sys.argv[1]) < float(sys.argv[2]) else 0)
except Exception:
    print(0)
' "$BACKOFF_FILE" "$BACKOFF_SECS" 2>/dev/null)" = "1" ]
}
set_backoff() { : > "$BACKOFF_FILE" 2>/dev/null || true; }
clear_backoff() { rm -f "$BACKOFF_FILE" 2>/dev/null || true; }

# --- Claude Code -----------------------------------------------------------
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME_DIR/.claude}"
INSTALLED="$CLAUDE_DIR/plugins/installed_plugins.json"

# claude_keys: prints old key (or empty) then 1/0 for a brace@ key.
claude_keys() {
  python3 -c '
import json, sys
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
old = [k for k in plugins if k.startswith("project-tracker@")]
new = [k for k in plugins if k.startswith("brace@")]
print(old[0] if old else "")
print("1" if new else "0")
' "$INSTALLED" 2>/dev/null
}

if command -v claude >/dev/null 2>&1 && [ -f "$INSTALLED" ]; then
  KEYS="$(claude_keys)"
  OLD_KEY="$(printf '%s\n' "$KEYS" | sed -n '1p')"
  HAS_BRACE="$(printf '%s\n' "$KEYS" | sed -n '2p')"
  if [ -n "$OLD_KEY" ]; then
    if [ "$HAS_BRACE" != "1" ] && ! in_backoff; then
      bounded claude plugin marketplace update "${OLD_KEY#project-tracker@}" || true
      if bounded claude plugin install brace; then
        HAS_BRACE="$(claude_keys | sed -n '2p')"
        [ "$HAS_BRACE" = "1" ] && clear_backoff || set_backoff
      else
        HAS_BRACE=0
        set_backoff
      fi
    fi
    if [ "$HAS_BRACE" = "1" ]; then
      bounded claude plugin uninstall "$OLD_KEY" || true
      [ -z "$(claude_keys | sed -n '1p')" ] && SWAPPED="Claude Code"
    fi
  fi
fi

# --- Antigravity -------------------------------------------------------------
AGY_PLUGINS="$HOME_DIR/.gemini/config/plugins"
OLD_AGY="$AGY_PLUGINS/project-tracker"
if [ -n "$HOME_DIR" ] && { [ -d "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; } && command -v agy >/dev/null 2>&1; then
  AGY_READY=0
  if [ -d "$AGY_PLUGINS/brace" ]; then
    AGY_READY=1   # already there before this run
  elif ! in_backoff; then
    # A partial folder left by a failed install is never trusted.
    if bounded agy plugin install "$ROOT" \
       && [ -n "$(find "$AGY_PLUGINS/brace" -maxdepth 2 -name plugin.json 2>/dev/null | head -1)" ]; then
      AGY_READY=1
      clear_backoff
    else
      set_backoff
    fi
  fi
  if [ "$AGY_READY" = "1" ]; then
    # Never let agy uninstall walk into symlinks pointing at a repo.
    if [ ! -L "$OLD_AGY" ] && [ -z "$(find "$OLD_AGY" -type l 2>/dev/null | head -1)" ]; then
      bounded agy plugin uninstall project-tracker || true
    fi
    # rm -rf removes symlinks themselves, never what they point to.
    { [ -e "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; } && rm -rf "$OLD_AGY"
    [ -L "$HOME_DIR/.gemini/config/skills/track" ] && rm -f "$HOME_DIR/.gemini/config/skills/track"
    if [ ! -e "$OLD_AGY" ] && [ ! -L "$OLD_AGY" ]; then
      SWAPPED="${SWAPPED:+$SWAPPED and }Antigravity"
    fi
  fi
fi

if [ -n "$SWAPPED" ]; then
  echo "[BRACE] The old project-tracker plugin was replaced by BRACE in $SWAPPED. Tell the user now, in one line: restart Claude Code (and Antigravity) and close every other open session so they all run BRACE."
  exit 10
fi
exit 0
