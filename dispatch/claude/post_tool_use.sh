#!/usr/bin/env bash
# BRACE adapter -- Claude Code PostToolUse (Edit|Write). Runs the
# dispatcher and wraps any text as hookSpecificOutput.additionalContext
# (raw PostToolUse stdout is not shown to Claude).
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("tool_name", "")); print((d.get("tool_input") or {}).get("file_path", "")); print(d.get("session_id", ""))
' 2>/dev/null)" || exit 0
case "$(printf '%s\n' "$PARSED" | sed -n '1p')" in Edit|Write) ;; *) exit 0 ;; esac
OUT="$(BRACE_TOOL=claude \
  BRACE_PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$DIR/../.." && pwd)}" \
  BRACE_FILE="$(printf '%s\n' "$PARSED" | sed -n '2p')" \
  BRACE_SESSION="$(printf '%s\n' "$PARSED" | sed -n '3p')" \
  bash "$DIR/../run.sh" post_tool_use 2>/dev/null)"
[ -n "$OUT" ] || exit 0
python3 -c '
import json, sys
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": sys.argv[1]}}))
' "$OUT"
exit 0
