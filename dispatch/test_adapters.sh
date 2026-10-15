#!/usr/bin/env bash
# End-to-end tests of the per-tool adapters on a fixture HOME.
# Run: bash dispatch/test_adapters.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2] in [$1]"; FAIL=1 ;; esac; }
PY="$(command -v python3)" || { echo "FAIL: python3 not found"; exit 1; }
PROJ=adapterproj
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP" "${TMP2:-}" "${TMP3:-}"' EXIT
# Build a sandbox (temp HOME, python3-only PATH) rooted at $1.
# Safety: the adapters run the real machine.sh -> migrate_plugins.sh.
setup_env() {
  local T="$1"
  export HOME="$T/h" TMPDIR="$T/tmp"; unset CLAUDE_CONFIG_DIR CLAUDE_PLUGIN_ROOT
  mkdir -p "$HOME/.brace" "$TMPDIR" "$T/bin"
  ln -sf "$PY" "$T/bin/python3"
  export PATH="$T/bin:/usr/bin:/bin"
  if command -v claude >/dev/null 2>&1 || command -v agy >/dev/null 2>&1; then
    echo "ABORT: claude or agy resolvable under the sandbox PATH"; exit 1
  fi
  SCOPE="$T/scope"; P="$SCOPE/$PROJ"; mkdir -p "$P/docs/brace"
  printf -- '---\nproject: %s\nstatus: active\nlast_updated: 2026-01-01\nreminders_list: "L"\n---\n' "$PROJ" > "$P/docs/brace/STATUS.md"
  echo "$SCOPE" > "$HOME/.brace/scopes.txt"; echo "$T/out" > "$HOME/.brace/portfolio.txt"
}
setup_env "$TMP"

OUT="$(printf '{"cwd": "%s", "session_id": "s1", "hook_event_name": "SessionStart"}' "$P" | bash "$DIR/claude/session_start.sh")"
has "$OUT" "Session opened in a tracked project" "Claude SessionStart -> raw text"

OUT="$(printf '{"tool_name": "Write", "tool_input": {"file_path": "%s"}, "session_id": "s1"}' "$P/docs/brace/STATUS.md" | bash "$DIR/claude/post_tool_use.sh")"
has "$OUT" '"additionalContext"' "Claude PostToolUse -> JSON additionalContext"
grep -q "$PROJ" "$TMP/out/PORTFOLIO.html" 2>/dev/null && echo "PASS: portfolio regenerated via Claude adapter" || { echo "FAIL: portfolio missing $PROJ (known red until Task 11)"; FAIL=1; }

OUT="$(printf '{"tool_name": "Read", "tool_input": {"file_path": "%s"}, "session_id": "s1"}' "$P/docs/brace/STATUS.md" | bash "$DIR/claude/post_tool_use.sh")"
[ -z "$OUT" ] && echo "PASS: non-write tool ignored" || { echo "FAIL: Read produced [$OUT]"; FAIL=1; }

OUT="$(printf '{"invocationNum": 2, "workspacePaths": ["%s"], "conversationId": "c1"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
[ "$OUT" = "{}" ] && echo "PASS: Antigravity later invocation -> {}" || { echo "FAIL: got [$OUT]"; FAIL=1; }

OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c1"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
printf '%s' "$OUT" | python3 -c 'import json,sys; m=json.load(sys.stdin)["injectSteps"][0]["ephemeralMessage"]; sys.exit(0 if "Session opened in a tracked project" in m else 1)' \
  && echo "PASS: Antigravity first invocation -> injectSteps JSON with expected text" || { echo "FAIL: bad injectSteps [$OUT]"; FAIL=1; }
N="$SCOPE/new"; mkdir -p "$N"
OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c1"}' "$N" | bash "$DIR/antigravity/session_start.sh")"
has "$OUT" "ask_question" "Antigravity wording for an untracked folder"

# Non-write Antigravity tool: {} and no regeneration.
rm -rf "$TMP/out"
OUT="$(printf '{"toolCall": {"name": "view_file", "args": {"TargetFile": "%s"}}, "conversationId": "c2"}' "$P/docs/brace/STATUS.md" | bash "$DIR/antigravity/post_tool_use.sh")"
[ "$OUT" = "{}" ] && [ ! -e "$TMP/out/PORTFOLIO.html" ] && echo "PASS: Antigravity non-write tool -> {} and no regeneration" || { echo "FAIL: view_file got [$OUT]"; FAIL=1; }

# Independent fresh sandbox: no earlier session_start has run here.
TMP2="$(mktemp -d)"; setup_env "$TMP2"
OUT="$(printf '{"toolCall": {"name": "write_to_file", "args": {"TargetFile": "%s"}}, "conversationId": "c2"}' "$P/docs/brace/STATUS.md" | bash "$DIR/antigravity/post_tool_use.sh")"
[ "$OUT" = "{}" ] && echo "PASS: Antigravity PostToolUse -> {}" || { echo "FAIL: got [$OUT]"; FAIL=1; }
grep -q "$PROJ" "$TMP2/out/PORTFOLIO.html" 2>/dev/null && echo "PASS: portfolio regenerated via Antigravity adapter" || { echo "FAIL: portfolio missing $PROJ (AGY; known red until Task 11)"; FAIL=1; }

# Swap pending: Claude's `source` and Antigravity's first invocation reach
# machine.sh. A /clear keeps the legacy project folder where it is; a fresh
# start clears the marker and moves it.
TMP3="$(mktemp -d)"; setup_env "$TMP3"
L="$SCOPE/legacy"; mkdir -p "$L/docs/project-tracker"
printf -- '---\nproject: legacy\nstatus: active\nlast_updated: 2026-01-01\n---\n' > "$L/docs/project-tracker/STATUS.md"
: > "$HOME/.brace/.swap-pending"
OUT="$(printf '{"cwd": "%s", "session_id": "s3", "source": "clear"}' "$L" | bash "$DIR/claude/session_start.sh")"
[ -f "$HOME/.brace/.swap-pending" ] && [ -d "$L/docs/project-tracker" ] && [ ! -e "$L/docs/brace" ] \
  && echo "PASS: Claude source=clear with a pending swap -> project not moved" || { echo "FAIL: clear moved or cleared [$OUT]"; FAIL=1; }
has "$OUT" "Keep reading and writing docs/project-tracker/" "deferred project keeps using the legacy folder"
OUT="$(printf '{"cwd": "%s", "session_id": "s3", "source": "startup"}' "$L" | bash "$DIR/claude/session_start.sh")"
[ ! -e "$HOME/.brace/.swap-pending" ] && [ -f "$L/docs/brace/STATUS.md" ] \
  && echo "PASS: Claude source=startup -> pending cleared, project moved" || { echo "FAIL: startup [$OUT]"; FAIL=1; }
: > "$HOME/.brace/.swap-pending"
OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c3"}' "$L" | bash "$DIR/antigravity/session_start.sh")"
[ ! -e "$HOME/.brace/.swap-pending" ] && echo "PASS: Antigravity first invocation counts as a fresh start" || { echo "FAIL: AGY pending kept"; FAIL=1; }

# Garbage input never fails a tool.
for A in claude/session_start claude/post_tool_use antigravity/session_start antigravity/post_tool_use; do
  OUT="$(echo 'not json' | bash "$DIR/$A.sh")"; RC=$?
  case "$A" in antigravity/*) WANT="{}" ;; *) WANT="" ;; esac
  [ $RC -eq 0 ] && [ "$OUT" = "$WANT" ] && echo "PASS: garbage input -> $A" || { echo "FAIL: $A rc=$RC out=[$OUT]"; FAIL=1; }
done
exit $FAIL
