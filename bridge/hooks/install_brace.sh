#!/usr/bin/env bash
# project-tracker 0.14.0 -- the bridge. project-tracker is now BRACE; this
# hook only installs brace, then tells the user to restart. BRACE itself
# removes this plugin at its first start. Bash 3.2 compatible.
# CLI calls share one total time budget; a failed install backs off for hours
# (same marker as BRACE's own migration, so the two never double up).
set -uo pipefail
cat >/dev/null
command -v claude >/dev/null 2>&1 || exit 0
command -v python3 >/dev/null 2>&1 || exit 0
INSTALLED="${CLAUDE_CONFIG_DIR:-${HOME:-}/.claude}/plugins/installed_plugins.json"
[ -f "$INSTALLED" ] || exit 0

CLI_TIMEOUT="${BRACE_CLI_TIMEOUT:-45}"
DEADLINE=$(($(date +%s) + CLI_TIMEOUT))
BACKOFF_SECS="${BRACE_BACKOFF_SECS:-21600}"
BACKOFF_FILE="${TMPDIR:-/tmp}/brace-swap-backoff"

# bounded CMD...: run with what is left of the total budget (no `timeout`
# binary on macOS). Past the deadline no call is started.
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

# keys: prints the old project-tracker@ key (or empty), then 1/0 for a brace@ key.
keys() {
  python3 -c '
import json, sys
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
old = [k for k in plugins if k.startswith("project-tracker@")]
print(old[0] if old else "")
print("1" if any(k.startswith("brace@") for k in plugins) else "0")
' "$INSTALLED" 2>/dev/null
}

KEYS="$(keys)"
OLD_KEY="$(printf '%s\n' "$KEYS" | sed -n '1p')"
[ "$(printf '%s\n' "$KEYS" | sed -n '2p')" = "1" ] && exit 0
in_backoff && exit 0
[ -n "$OLD_KEY" ] && { bounded claude plugin marketplace update "${OLD_KEY#project-tracker@}" || true; }
if bounded claude plugin install brace \
   && [ "$(keys | sed -n '2p')" = "1" ]; then
  clear_backoff
  echo "[project-tracker] project-tracker is now BRACE, and BRACE has just been installed. Tell the user now, in one line: restart Claude Code and close every other open session to start using BRACE."
else
  set_backoff
fi
exit 0
