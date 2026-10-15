#!/usr/bin/env bash
# BRACE hook dispatcher: one entry point per event, called by the per-tool
# adapters (dispatch/claude/, dispatch/antigravity/). At session start it
# first runs the machine-level checks, then every skill's
# hooks/<event>.sh — a skill other than track only in projects where
# docs/brace/<skill>/ exists — and prints their merged plain-text output.
# Never fails: a broken skill script is skipped. Bash 3.2 compatible.
set -uo pipefail

EVENT="${1:-}"
DISPATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DISPATCH_DIR/lib.sh"

: "${BRACE_PLUGIN_ROOT:=$(dirname "$DISPATCH_DIR")}"
: "${BRACE_TOOL:=claude}"
: "${BRACE_CWD:=}"
: "${BRACE_FILE:=}"
: "${BRACE_SESSION:=}"
BRACE_EVENT="$EVENT"
BRACE_SWAPPED=0
export BRACE_PLUGIN_ROOT BRACE_TOOL BRACE_CWD BRACE_FILE BRACE_SESSION BRACE_EVENT BRACE_SWAPPED

OUT=""
append() {
  [ -n "$1" ] || return 0
  if [ -n "$OUT" ]; then
    OUT="$OUT

$1"
  else
    OUT="$1"
  fi
}

if [ "$EVENT" = "session_start" ]; then
  MACHINE="${BRACE_MACHINE_SCRIPT:-$DISPATCH_DIR/machine.sh}"
  M_OUT="$(bash "$MACHINE" 2>/dev/null </dev/null)"
  M_RC=$?
  if [ "$M_RC" -eq 10 ]; then
    BRACE_SWAPPED=1
  fi
  export BRACE_SWAPPED
  # Keep the machine output only on rc 0 (nothing swapped) or 10 (swapped).
  if [ "$M_RC" -eq 0 ] || [ "$M_RC" -eq 10 ]; then
    append "$M_OUT"
  fi
fi

PROJECT=""
case "$EVENT" in
  session_start)
    if [ -n "$BRACE_CWD" ]; then
      SCOPE="$(brace_scope_root "$BRACE_CWD")"
      [ -n "$SCOPE" ] && PROJECT="$(brace_find_project "$BRACE_CWD" "$SCOPE")"
    fi
    ;;
  post_tool_use)
    if [ -n "$BRACE_FILE" ]; then
      SCOPE="$(brace_scope_root "$BRACE_FILE")"
      [ -n "$SCOPE" ] && PROJECT="$(brace_find_project "$(dirname "$BRACE_FILE")" "$SCOPE")"
    fi
    ;;
esac
BRACE_PROJECT_ROOT="$PROJECT"
export BRACE_PROJECT_ROOT

for script in "$BRACE_PLUGIN_ROOT"/skills/*/hooks/"$EVENT".sh; do
  [ -f "$script" ] || continue
  skill="$(basename "$(dirname "$(dirname "$script")")")"
  if [ "$skill" != "track" ]; then
    [ -n "$PROJECT" ] && [ -d "$PROJECT/docs/brace/$skill" ] || continue
  fi
  S_OUT="$(bash "$script" 2>/dev/null </dev/null)" || S_OUT=""
  append "$S_OUT"
done

[ -n "$OUT" ] && printf '%s\n' "$OUT"
exit 0
