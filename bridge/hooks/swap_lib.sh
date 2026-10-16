#!/usr/bin/env bash
# Plugin swap helpers, shared by the project-tracker 0.14.0 bridge
# (install_brace.sh, next to this file) and BRACE's
# dispatch/migrate_plugins.sh. One copy, so the backoff marker
# ($TMPDIR/brace-swap-backoff) and the installed_plugins.json key format
# (project-tracker@<marketplace>, brace@<marketplace>) can never drift apart.
# Frozen with the bridge once released: BRACE may stop sourcing it, never
# change it. Sourced, never executed. Bash 3.2 compatible; JSON via python3.

# Total wall-clock budget for all CLI calls; the hook's host timeout is 90 s.
SWAP_DEADLINE=$((SECONDS + ${BRACE_CLI_TIMEOUT:-35}))
SWAP_BACKOFF_SECS="${BRACE_BACKOFF_SECS:-21600}"
SWAP_BACKOFF_FILE="${TMPDIR:-/tmp}/brace-swap-backoff"

# bounded CMD...: run with what is left of the total budget, checked
# against the wall clock (no `timeout` binary on macOS). Past the deadline
# no call is started.
bounded() {
  [ "$SECONDS" -lt "$SWAP_DEADLINE" ] || return 124
  "$@" >/dev/null 2>&1 </dev/null &
  local kids pid=$!
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$SECONDS" -ge "$SWAP_DEADLINE" ]; then
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

# swap_fresh FILE SECS: true when FILE exists and is younger than SECS.
swap_fresh() {
  [ -f "$1" ] || return 1
  [ "$(python3 -c '
import os, sys, time
try:
    print(1 if time.time() - os.path.getmtime(sys.argv[1]) < float(sys.argv[2]) else 0)
except Exception:
    print(0)
' "$1" "$2" 2>/dev/null)" = "1" ]
}
in_backoff() { swap_fresh "$SWAP_BACKOFF_FILE" "$SWAP_BACKOFF_SECS"; }
set_backoff() { : > "$SWAP_BACKOFF_FILE" 2>/dev/null || true; }
clear_backoff() { rm -f "$SWAP_BACKOFF_FILE" 2>/dev/null || true; }

# swap_keys FILE: prints the first project-tracker@ key of an
# installed_plugins.json (or an empty line), then 1/0 for a brace@ key.
swap_keys() {
  python3 -c '
import json, sys
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
old = [k for k in plugins if k.startswith("project-tracker@")]
print(old[0] if old else "")
print("1" if any(k.startswith("brace@") for k in plugins) else "0")
' "$1" 2>/dev/null
}
