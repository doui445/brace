#!/usr/bin/env bash
# BRACE adapter -- Claude Code PreToolUse (Edit|Write). Lets a BRACE agent
# (agent_type brace:<name>) write in its own docs/brace/agents/<name>/
# folder, and the main conversation in the agency's folders
# (docs/brace/brand/, docs/brace/agents/brand/), without a permission
# prompt (see dispatch/agent_write.sh). Anything else gets no decision:
# the normal permission flow applies.
# Never fails.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARSED="$(python3 -c '
import json, sys
d = json.load(sys.stdin)
f = [d.get("tool_name", ""), d.get("agent_type", ""), (d.get("tool_input") or {}).get("file_path", "")]
# One value per line: a value holding a line break would be cut short.
if not all(isinstance(v, str) for v in f) or any(c in v for v in f for c in "\n\r\0"): sys.exit(1)
print("\n".join(f))
' 2>/dev/null)" || exit 0
case "$(printf '%s\n' "$PARSED" | sed -n '1p')" in Edit|Write) ;; *) exit 0 ;; esac
BRACE_PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$DIR/../.." && pwd)}" \
  bash "$DIR/../agent_write.sh" "$(printf '%s\n' "$PARSED" | sed -n '2p')" "$(printf '%s\n' "$PARSED" | sed -n '3p')" || exit 0
printf '%s\n' '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "allow", "permissionDecisionReason": "BRACE agency writing in its own folder"}}'
exit 0
