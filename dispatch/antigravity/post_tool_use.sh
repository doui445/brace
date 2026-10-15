#!/usr/bin/env bash
# BRACE adapter -- Antigravity PostToolUse (write_to_file |
# replace_file_content). Runs the dispatcher for its side effects
# (portfolio regeneration); Antigravity does not accept injectSteps here,
# so the output is always {}.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
call = d.get("toolCall") or {}
args = call.get("args") or {}
print(call.get("name", "")); print(args.get("TargetFile") or args.get("file_path") or ""); print(d.get("conversationId", ""))
' 2>/dev/null)" || { echo "{}"; exit 0; }
case "$(printf '%s\n' "$PARSED" | sed -n '1p')" in
  write_to_file|replace_file_content)
    BRACE_TOOL=antigravity \
    BRACE_PLUGIN_ROOT="$(cd "$DIR/../.." && pwd)" \
    BRACE_FILE="$(printf '%s\n' "$PARSED" | sed -n '2p')" \
    BRACE_SESSION="$(printf '%s\n' "$PARSED" | sed -n '3p')" \
    bash "$DIR/../run.sh" post_tool_use >/dev/null 2>&1 || true
    ;;
esac
echo "{}"
exit 0
