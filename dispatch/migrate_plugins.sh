#!/usr/bin/env bash
# Replaces the old project-tracker plugin by brace in every tool found on
# this machine (Claude Code, Antigravity). Zero breakage: the old plugin is
# only removed once brace is installed in that tool. Exit codes, all but 10
# silent:
#   10  something was replaced this run (one restart message printed);
#   11  an old plugin is still installed after this run (CLI missing, failed
#       or backed-off install, uninstall that did not take) -- projects must
#       not be moved while it can still be loaded;
#   0   no old plugin anywhere.
# All CLI calls share one total wall-clock budget; a failed install backs
# off for hours.
# Kept in sync with the frozen project-tracker 0.14.0 bridge
# (bridge/hooks/install_brace.sh): it relies on the backoff marker name
# ($TMPDIR/brace-swap-backoff) and on the installed_plugins.json key format
# (project-tracker@<marketplace>, brace@<marketplace>). Never rename either.
# Bash 3.2 compatible; JSON via python3.
set -uo pipefail

ROOT="${BRACE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
HOME_DIR="${HOME:-}"
# Total wall-clock budget for all CLI calls; the hook's host timeout is 90 s.
CLI_TIMEOUT="${BRACE_CLI_TIMEOUT:-35}"
DEADLINE=$((SECONDS + CLI_TIMEOUT))
BACKOFF_SECS="${BRACE_BACKOFF_SECS:-21600}"
BACKOFF_FILE="${TMPDIR:-/tmp}/brace-swap-backoff"
SWAPPED=""
OLD_LEFT=0

# bounded CMD...: run with what is left of the total time budget, checked
# against the wall clock (no `timeout` binary on macOS). Past the deadline
# no call is started.
bounded() {
  [ "$SECONDS" -lt "$DEADLINE" ] || return 124
  "$@" >/dev/null 2>&1 </dev/null &
  local kids pid=$!
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$SECONDS" -ge "$DEADLINE" ]; then
      kids="$(pgrep -P "$pid" 2>/dev/null)"
      kill "$pid" 2>/dev/null
      [ -n "$kids" ] && kill $kids 2>/dev/null
      wait "$pid" 2>/dev/null
      return 124
    fi
    sleep 0.2
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

# old_entries: one line per installed old entry: key<TAB>scope<TAB>projectPath
# (scope defaults to user; projectPath is empty for a user-scope entry).
old_entries() {
  python3 -c '
import json, sys
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
for k, v in plugins.items():
    if not k.startswith("project-tracker@"):
        continue
    entries = v if isinstance(v, list) and v else [{}]
    for e in entries:
        e = e if isinstance(e, dict) else {}
        scope = str(e.get("scope") or "user")
        path = str(e.get("projectPath") or "")
        if "\t" in k + scope + path or "\n" in k + scope + path:
            continue
        print("%s\t%s\t%s" % (k, scope, path))
' "$INSTALLED" 2>/dev/null
}

# in_dir DIR CMD...: run CMD from DIR (project/local scopes act on the
# project the CLI is started in).
in_dir() { local d="$1"; shift; cd "$d" 2>/dev/null && "$@"; }

if [ -f "$INSTALLED" ]; then
  KEYS="$(claude_keys)"
  OLD_KEY="$(printf '%s\n' "$KEYS" | sed -n '1p')"
  HAS_BRACE="$(printf '%s\n' "$KEYS" | sed -n '2p')"
  if [ -n "$OLD_KEY" ] && command -v claude >/dev/null 2>&1; then
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
      TAB="$(printf '\t')"
      ENTRIES="$(old_entries)"
      while IFS="$TAB" read -r key scope ppath; do
        [ -n "$key" ] || continue
        case "$scope" in
          user) bounded claude plugin uninstall "$key" --scope user || true ;;
          project|local)
            # Without its project folder the entry cannot be removed: it stays,
            # and the run ends with 11.
            [ -n "$ppath" ] && [ -d "$ppath" ] \
              && { bounded in_dir "$ppath" claude plugin uninstall "$key" --scope "$scope" || true; } ;;
        esac
      done <<EOT
$ENTRIES
EOT
      # Any entry removed counts as a swap (restart message); an entry that
      # stayed makes the later runs end with 11.
      N_AFTER="$(old_entries | grep -c .)"
      [ "$N_AFTER" -lt "$(printf '%s\n' "$ENTRIES" | grep -c .)" ] && SWAPPED="Claude Code"
    fi
  fi
  [ -n "$(claude_keys | sed -n '1p')" ] && OLD_LEFT=1
fi

# --- Antigravity -------------------------------------------------------------
AGY_PLUGINS="$HOME_DIR/.gemini/config/plugins"
OLD_AGY="$AGY_PLUGINS/project-tracker"
if [ -n "$HOME_DIR" ] && { [ -d "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; }; then
  AGY_READY=0
  if [ -f "$AGY_PLUGINS/brace/plugin.json" ]; then
    AGY_READY=1   # complete install already there: removal needs no agy
  elif command -v agy >/dev/null 2>&1 && ! in_backoff; then
    # A partial folder left by a failed install is never trusted.
    if bounded agy plugin install "$ROOT" \
       && [ -f "$AGY_PLUGINS/brace/plugin.json" ]; then
      AGY_READY=1
      clear_backoff
    else
      set_backoff
    fi
  fi
  if [ "$AGY_READY" = "1" ]; then
    # Never let agy uninstall walk into symlinks pointing at a repo.
    if command -v agy >/dev/null 2>&1 && [ ! -L "$OLD_AGY" ] \
       && [ -z "$(find "$OLD_AGY" -type l 2>/dev/null | head -1)" ]; then
      bounded agy plugin uninstall project-tracker || true
    fi
    # rm -rf removes symlinks themselves, never what they point to.
    { [ -e "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; } && rm -rf "$OLD_AGY"
    [ -L "$HOME_DIR/.gemini/config/skills/track" ] && rm -f "$HOME_DIR/.gemini/config/skills/track"
    if [ ! -e "$OLD_AGY" ] && [ ! -L "$OLD_AGY" ]; then
      SWAPPED="${SWAPPED:+$SWAPPED and }Antigravity"
    fi
  fi
  { [ -e "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; } && OLD_LEFT=1
fi

# A swap this run wins over 11: the restart message matters most, and the
# caller defers project moves on 10 as well.
if [ -n "$SWAPPED" ]; then
  echo "[BRACE] The old project-tracker plugin was replaced by BRACE in $SWAPPED. Tell the user now, in one line: restart Claude Code (and Antigravity) and close every other open session so they all run BRACE."
  exit 10
fi
[ "$OLD_LEFT" = "1" ] && exit 11
exit 0
