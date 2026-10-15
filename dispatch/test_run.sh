#!/usr/bin/env bash
# Tests for dispatch/run.sh with a fake plugin root. Run: bash dispatch/test_run.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2] in [$1]"; FAIL=1 ;; esac; }
hasnt() { case "$1" in *"$2"*) echo "FAIL: $3 — unexpected [$2]"; FAIL=1 ;; *) echo "PASS: $3" ;; esac; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"; mkdir -p "$HOME/.brace"
ROOT="$TMP/plugin"
mk() { mkdir -p "$ROOT/skills/$1/hooks"; printf '#!/usr/bin/env bash\n%s\n' "$3" > "$ROOT/skills/$1/hooks/$2.sh"; }
mk track session_start 'echo "TRACK swapped=$BRACE_SWAPPED project=$BRACE_PROJECT_ROOT event=$BRACE_EVENT"'
mk design session_start 'echo "DESIGN"'
mk broken session_start 'echo "PARTIAL"; exit 1'
mk track post_tool_use 'echo "TRACK-POST $BRACE_FILE"'
mk design post_tool_use 'echo "DESIGN-POST"'
MACHINE="$TMP/machine.sh"

SCOPE="$TMP/scope"; P="$SCOPE/p"
mkdir -p "$P/docs/brace/design" "$P/docs/brace/broken" "$P/src"; touch "$P/docs/brace/STATUS.md"
echo "$SCOPE" > "$HOME/.brace/scopes.txt"
run() { BRACE_PLUGIN_ROOT="$ROOT" BRACE_MACHINE_SCRIPT="$MACHINE" bash "$DIR/run.sh" "$@"; }

printf '#!/usr/bin/env bash\necho "MACHINE"\nexit 0\n' > "$MACHINE"
OUT="$(BRACE_CWD="$P/src" run session_start)"
has "$OUT" "MACHINE" "machine output first"
has "$OUT" "TRACK swapped=0 project=$P event=session_start" "track always runs, gets project root"
has "$OUT" "DESIGN" "design runs where docs/brace/design exists"
hasnt "$OUT" "PARTIAL" "failing script output discarded"
case "$OUT" in "MACHINE"*) echo "PASS: machine output comes first" ;; *) echo "FAIL: order"; FAIL=1 ;; esac

rm -rf "$P/docs/brace/design"
OUT="$(BRACE_CWD="$P" run session_start)"
hasnt "$OUT" "DESIGN" "design skipped when its folder is absent"

printf '#!/usr/bin/env bash\necho "SWAP"\nexit 10\n' > "$MACHINE"
OUT="$(BRACE_CWD="$P" run session_start)"
has "$OUT" "TRACK swapped=1" "exit 10 from machine -> BRACE_SWAPPED=1"

printf '#!/usr/bin/env bash\nexit 0\n' > "$MACHINE"
OUT="$(BRACE_CWD="/outside" run session_start)"
has "$OUT" "TRACK swapped=0 project= event" "outside scopes -> empty project root"

mkdir -p "$P/docs/brace/design"
OUT="$(BRACE_FILE="$P/docs/brace/design/DESIGN.md" run post_tool_use)"
has "$OUT" "TRACK-POST $P/docs/brace/design/DESIGN.md" "post_tool_use passes the file"
has "$OUT" "DESIGN-POST" "post_tool_use finds the project from the file"
hasnt "$OUT" "MACHINE" "machine checks only at session start"

rm -rf "$ROOT/skills"; mkdir -p "$ROOT/skills"
OUT="$(BRACE_CWD="$P" run session_start)"
[ -z "$OUT" ] && echo "PASS: nothing to say -> no output" || { echo "FAIL: expected silence, got [$OUT]"; FAIL=1; }
exit $FAIL
