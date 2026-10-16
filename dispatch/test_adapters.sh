#!/usr/bin/env bash
# End-to-end tests of the per-tool adapters on a fixture HOME.
# Run: bash dispatch/test_adapters.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3: missing [$2] in [$1]"; FAIL=1 ;; esac; }
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

# Antigravity 1.3 numbers model calls from 0: the first call of each
# conversation runs, whatever its number; later calls get {}.
OUT="$(printf '{"invocationNum": 0, "workspacePaths": ["%s"], "conversationId": "c1"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
printf '%s' "$OUT" | python3 -c 'import json,sys; m=json.load(sys.stdin)["injectSteps"][0]["ephemeralMessage"]; sys.exit(0 if "Session opened in a tracked project" in m else 1)' \
  && echo "PASS: Antigravity first invocation (0) -> injectSteps JSON with expected text" || { echo "FAIL: bad injectSteps [$OUT]"; FAIL=1; }
for NUM in 1 2; do
  OUT="$(printf '{"invocationNum": %s, "workspacePaths": ["%s"], "conversationId": "c1"}' "$NUM" "$P" | bash "$DIR/antigravity/session_start.sh")"
  [ "$OUT" = "{}" ] && echo "PASS: Antigravity later invocation ($NUM) -> {}" || { echo "FAIL: later invocation $NUM got [$OUT]"; FAIL=1; }
done
OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c-old"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
has "$OUT" "Session opened in a tracked project" "Antigravity numbering from 1 -> its first call runs too"
OUT="$(printf '{"invocationNum": 0, "workspacePaths": ["%s"]}' "$P" | bash "$DIR/antigravity/session_start.sh")"
has "$OUT" "Session opened in a tracked project" "no conversation id, call 0 -> runs"
OUT="$(printf '{"invocationNum": 2, "workspacePaths": ["%s"], "conversationId": "../x"}' "$P" | bash "$DIR/antigravity/session_start.sh")"
[ "$OUT" = "{}" ] && [ ! -e "$TMPDIR/x" ] && echo "PASS: unsafe conversation id -> number fallback, no file written outside" || { echo "FAIL: unsafe id got [$OUT]"; FAIL=1; }
N="$SCOPE/new"; mkdir -p "$N"
OUT="$(printf '{"invocationNum": 0, "workspacePaths": ["%s"], "conversationId": "c2"}' "$N" | bash "$DIR/antigravity/session_start.sh")"
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

# Swap pending: what settles it is the tool process having started after
# the swap (BRACE_HOST_START stands in for it), not the kind of session.
TMP3="$(mktemp -d)"; setup_env "$TMP3"
L="$SCOPE/legacy"; mkdir -p "$L/docs/project-tracker"
printf -- '---\nproject: legacy\nstatus: active\nlast_updated: 2026-01-01\n---\n' > "$L/docs/project-tracker/STATUS.md"
NOW="$(python3 -c 'import time; print(int(time.time()))')"
pending() { : > "$HOME/.brace/.swap-pending"; python3 -c 'import os, sys, time; t = time.time() - 60; os.utime(sys.argv[1], (t, t))' "$HOME/.brace/.swap-pending"; }
pending
for SRC in clear startup; do
  OUT="$(printf '{"cwd": "%s", "session_id": "s3", "source": "%s"}' "$L" "$SRC" | BRACE_HOST_START=$((NOW - 3600)) bash "$DIR/claude/session_start.sh")"
  [ -f "$HOME/.brace/.swap-pending" ] && [ -d "$L/docs/project-tracker" ] && [ ! -e "$L/docs/brace" ] \
    && echo "PASS: Claude source=$SRC, process older than the swap -> project not moved" || { echo "FAIL: $SRC moved or cleared [$OUT]"; FAIL=1; }
done
has "$OUT" "Keep reading and writing docs/project-tracker/" "deferred project keeps using the legacy folder"
OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c3"}' "$L" | BRACE_HOST_START=$((NOW - 3600)) bash "$DIR/antigravity/session_start.sh")"
[ -f "$HOME/.brace/.swap-pending" ] && [ -d "$L/docs/project-tracker" ] \
  && echo "PASS: new Antigravity conversation in a running app -> project not moved" || { echo "FAIL: AGY new conversation moved [$OUT]"; FAIL=1; }
OUT="$(printf '{"invocationNum": 1, "workspacePaths": ["%s"], "conversationId": "c4"}' "$L" | BRACE_HOST_START="$NOW" bash "$DIR/antigravity/session_start.sh")"
[ ! -e "$HOME/.brace/.swap-pending" ] && [ -f "$L/docs/brace/STATUS.md" ] \
  && echo "PASS: Antigravity restarted after the swap -> pending cleared, project moved" || { echo "FAIL: AGY restarted [$OUT]"; FAIL=1; }
L2="$SCOPE/legacy2"; mkdir -p "$L2/docs/project-tracker"
printf -- '---\nproject: legacy2\nstatus: active\nlast_updated: 2026-01-01\n---\n' > "$L2/docs/project-tracker/STATUS.md"
pending
OUT="$(printf '{"cwd": "%s", "session_id": "s5", "source": "startup"}' "$L2" | BRACE_HOST_START="$NOW" bash "$DIR/claude/session_start.sh")"
[ ! -e "$HOME/.brace/.swap-pending" ] && [ -f "$L2/docs/brace/STATUS.md" ] \
  && echo "PASS: Claude restarted after the swap -> pending cleared, project moved" || { echo "FAIL: Claude restarted [$OUT]"; FAIL=1; }

# Garbage input never fails a tool.
for A in claude/session_start claude/post_tool_use antigravity/session_start antigravity/post_tool_use; do
  OUT="$(echo 'not json' | bash "$DIR/$A.sh")"; RC=$?
  case "$A" in antigravity/*) WANT="{}" ;; *) WANT="" ;; esac
  [ $RC -eq 0 ] && [ "$OUT" = "$WANT" ] && echo "PASS: garbage input -> $A" || { echo "FAIL: $A rc=$RC out=[$OUT]"; FAIL=1; }
done
exit $FAIL
