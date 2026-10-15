#!/usr/bin/env bash
# BRACE adapter -- Claude Code SessionStart. Parses Claude's JSON, runs the
# dispatcher, prints its text as-is (Claude injects SessionStart stdout).
# Passes Claude's `source` (startup | resume | clear | compact) as
# BRACE_SOURCE: only "startup" is a fresh process.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("cwd", "")); print(d.get("session_id", "")); print(d.get("source", ""))
' 2>/dev/null)" || exit 0
BRACE_TOOL=claude \
BRACE_PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$DIR/../.." && pwd)}" \
BRACE_CWD="$(printf '%s\n' "$PARSED" | sed -n '1p')" \
BRACE_SESSION="$(printf '%s\n' "$PARSED" | sed -n '2p')" \
BRACE_SOURCE="$(printf '%s\n' "$PARSED" | sed -n '3p')" \
bash "$DIR/../run.sh" session_start 2>/dev/null
exit 0
