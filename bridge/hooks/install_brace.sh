#!/usr/bin/env bash
# project-tracker 0.14.0 -- the bridge. project-tracker is now BRACE; this
# hook only installs brace, then tells the user to restart. BRACE itself
# removes this plugin at its first start. Bash 3.2 compatible.
# CLI calls share one total wall-clock budget; a failed install backs off
# for hours and says so once (same marker as BRACE's own migration, so the
# two never double up). Frozen once released: BRACE's
# dispatch/migrate_plugins.sh must keep this backoff marker name
# ($TMPDIR/brace-swap-backoff) and the installed_plugins.json key format
# (project-tracker@<marketplace>, brace@<marketplace>) in sync with it.
set -uo pipefail
cat >/dev/null
command -v claude >/dev/null 2>&1 || exit 0
command -v python3 >/dev/null 2>&1 || exit 0
INSTALLED="${CLAUDE_CONFIG_DIR:-${HOME:-}/.claude}/plugins/installed_plugins.json"
[ -f "$INSTALLED" ] || exit 0

# Total wall-clock budget for all CLI calls; the hook's host timeout is 90 s.
CLI_TIMEOUT="${BRACE_CLI_TIMEOUT:-35}"
DEADLINE=$((SECONDS + CLI_TIMEOUT))
BACKOFF_SECS="${BRACE_BACKOFF_SECS:-21600}"
BACKOFF_FILE="${TMPDIR:-/tmp}/brace-swap-backoff"

# bounded CMD...: run with what is left of the total budget, checked
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
  # Printed only on a run that tried: the backoff keeps the next runs silent.
  set_backoff
  echo "[project-tracker] project-tracker is now BRACE, but BRACE could not be installed automatically. Tell the user now, in one line: run /plugin install brace to install it (or it will be retried automatically in a few hours)."
fi
exit 0
