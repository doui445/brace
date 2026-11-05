#!/usr/bin/env bash
# BRACE adapter -- Claude Code PostToolUse (Edit|Write|Bash). Runs the
# dispatcher and wraps any text as hookSpecificOutput.additionalContext
# (raw PostToolUse stdout is not shown to Claude). A write passes its file;
# a shell command passes no file, only its working folder.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("tool_name", "")); print((d.get("tool_input") or {}).get("file_path", "")); print(d.get("session_id", "")); print(d.get("cwd", ""))
' 2>/dev/null)" || exit 0
TOOL="$(printf '%s\n' "$PARSED" | sed -n '1p')"
case "$TOOL" in Edit|Write) CWD="" ;; Bash) CWD="$(printf '%s\n' "$PARSED" | sed -n '4p')" ;; *) exit 0 ;; esac
OUT="$(BRACE_TOOL=claude \
  BRACE_PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$DIR/../.." && pwd)}" \
  BRACE_FILE="$([ "$TOOL" = Bash ] || printf '%s\n' "$PARSED" | sed -n '2p')" \
  BRACE_CWD="$CWD" \
  BRACE_SESSION="$(printf '%s\n' "$PARSED" | sed -n '3p')" \
  bash "$DIR/../run.sh" post_tool_use 2>/dev/null)"
[ -n "$OUT" ] || exit 0
python3 -c '
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": sys.argv[1]}}))
' "$OUT"
exit 0
