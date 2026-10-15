#!/usr/bin/env bash
# End-to-end tests of the per-tool adapters on a fixture HOME.
# Run: bash dispatch/test_adapters.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2] in [$1]"; FAIL=1 ;; esac; }
PY="$(command -v python3)" || { echo "FAIL: python3 not found"; exit 1; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/h" TMPDIR="$TMP/tmp"; unset CLAUDE_CONFIG_DIR CLAUDE_PLUGIN_ROOT
mkdir -p "$HOME/.brace" "$TMPDIR" "$TMP/bin"
# Safety: the adapters run the real machine.sh -> migrate_plugins.sh. Keep only
# python3 on PATH so the real claude/agy CLIs can never be reached.
ln -s "$PY" "$TMP/bin/python3"
export PATH="$TMP/bin:/usr/bin:/bin"
if command -v claude >/dev/null 2>&1 || command -v agy >/dev/null 2>&1; then
  echo "ABORT: claude or agy resolvable under the sandbox PATH"; exit 1
fi
SCOPE="$TMP/scope"; P="$SCOPE/p"; mkdir -p "$P/docs/brace"
printf -- '---\nproject: p\nstatus: active\nlast_updated: 2026-01-01\nreminders_list: "L"\n---\n' > "$P/docs/brace/STATUS.md"
echo "$SCOPE" > "$HOME/.brace/scopes.txt"; echo "$TMP/out" > "$HOME/.brace/portfolio.txt"

OUT="$(printf '{"cwd": "%s", "session_id": "s1", "hook_event_name": "SessionStart"}' "$P" | bash "$DIR/claude/session_start.sh")"
has "$OUT" "Session opened in a tracked project" "Claude SessionStart -> raw text"

OUT="$(printf '{"tool_name": "Write", "tool_input": {"file_path": "%s"}, "session_id": "s1"}' "$P/docs/brace/STATUS.md" | bash "$DIR/claude/post_tool_use.sh")"
has "$OUT" '"additionalContext"' "Claude PostToolUse -> JSON additionalContext"
[ -f "$TMP/out/PORTFOLIO.html" ] && echo "PASS: portfolio regenerated via Claude adapter" || { echo "FAIL: no portfolio"; FAIL=1; }

OUT="$(printf '{"tool_name": "Read", "tool_input": {"file_path": "%s"}, "session_id": "s1"}' "$P/docs/brace/STATUS.md" | bash "$DIR/claude/post_tool_use.sh")"
[ -z "$OUT" ] && echo "PASS: non-write tool ignored" || { echo "FAIL: Read produced [$OUT]"; FAIL=1; }

OUT="$(printf '{"invocationNum": 2, "workspacePaths": ["%s"], "conversationId": "c1"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
[ "$OUT" = "{}" ] && echo "PASS: Antigravity later invocation -> {}" || { echo "FAIL: got [$OUT]"; FAIL=1; }

OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c1"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
has "$OUT" '"injectSteps"' "Antigravity first invocation -> injectSteps"
N="$SCOPE/new"; mkdir -p "$N"
OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c1"}' "$N" | bash "$DIR/antigravity/session_start.sh")"
has "$OUT" "ask_question" "Antigravity wording for an untracked folder"

rm -f "$TMP/out/PORTFOLIO.html"; rm -rf "$TMPDIR/brace-portfolio-regen"
OUT="$(printf '{"toolCall": {"name": "write_to_file", "args": {"TargetFile": "%s"}}, "conversationId": "c2"}' "$P/docs/brace/STATUS.md" | bash "$DIR/antigravity/post_tool_use.sh")"
[ "$OUT" = "{}" ] && echo "PASS: Antigravity PostToolUse -> {}" || { echo "FAIL: got [$OUT]"; FAIL=1; }
[ -f "$TMP/out/PORTFOLIO.html" ] && echo "PASS: portfolio regenerated via Antigravity adapter" || { echo "FAIL: no portfolio (AGY)"; FAIL=1; }

OUT="$(echo 'not json' | bash "$DIR/claude/session_start.sh")"; RC=$?
[ $RC -eq 0 ] && echo "PASS: garbage input never fails the tool" || { echo "FAIL: rc $RC"; FAIL=1; }
exit $FAIL
