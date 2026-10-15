#!/usr/bin/env bash
# Tests for skills/track/hooks/session_start.sh (tool-neutral skill script).
# Run: bash skills/track/hooks/test_session_start.sh
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/session_start.sh"
PLUGIN_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2]"; FAIL=1 ;; esac; }
hasnt() { case "$1" in *"$2"*) echo "FAIL: $3 — unexpected [$2]"; FAIL=1 ;; *) echo "PASS: $3" ;; esac; }
empty() { [ -z "$1" ] && echo "PASS: $2" || { echo "FAIL: $2 — got [$1]"; FAIL=1; }; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"; mkdir -p "$HOME/.brace"
SCOPE="$TMP/my scope"; mkdir -p "$SCOPE"
echo "$SCOPE" > "$HOME/.brace/scopes.txt"
run() {  # $1 cwd, $2 tool (default claude), $3 swapped (default 0)
  BRACE_CWD="$1" BRACE_TOOL="${2:-claude}" BRACE_SWAPPED="${3:-0}" BRACE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$HOOK"
}
status() { mkdir -p "$1"; printf -- '---\nproject: %s\nstatus: active\nuses_git: false\nlast_updated: 2026-01-01\n%s---\nBody\n' "$(basename "$(dirname "$(dirname "$1")")")" "${2:-}" > "$1/STATUS.md"; }

empty "$(run /outside)" "outside any scope -> silence"

T="$SCOPE/tracked"; status "$T/docs/brace"
OUT="$(run "$T")"
has "$OUT" "Session opened in a tracked project ($T)" "tracked (docs/brace)"
has "$OUT" "project: tracked" "frontmatter included"
has "$OUT" "Not yet configured" "missing keys listed"
has "$OUT" "reminders_list" "reminders_list missing"
has "$OUT" "portfolio.txt" "global portfolio.txt missing"
has "$OUT" "brace:track" "Claude wording names brace:track"

mkdir -p "$T/a/b"; has "$(run "$T/a/b")" "($T)" "deep subfolder -> project root"

touch "$HOME/.brace/portfolio.txt"; status "$T/docs/brace" $'reminders_list: "non"\nbacklog_model: "adopté"\ncategory: "non"\n'
hasnt "$(run "$T")" "Not yet configured" "fully configured -> no missing list"

N="$SCOPE/new"; mkdir -p "$N"
OUT="$(run "$N")"
has "$OUT" "UNTRACKED project" "untracked flag"
has "$OUT" "AskUserQuestion" "Claude question tool"
has "$OUT" "Yes, set it up" "yes option"; has "$OUT" "No, don't ask again" "no option"; has "$OUT" "Not now" "not-now option"
has "$OUT" "$HOME/.brace/trackignore.txt" "ignore file path is under ~/.brace"
OUT="$(run "$N" antigravity)"
has "$OUT" "ask_question" "Antigravity question tool"
hasnt "$OUT" "brace:track" "Antigravity wording names the skill 'track'"

echo "$N" > "$HOME/.brace/trackignore.txt"
empty "$(run "$N")" "ignored folder -> silence"
: > "$HOME/.brace/trackignore.txt"

# Legacy project, opened from a deep subfolder: the ROOT migrates
L="$SCOPE/legacy"; status "$L/docs/project-tracker"; mkdir -p "$L/src/deep"
echo "docs/project-tracker/" > "$L/AGENTS.md"
OUT="$(run "$L/src/deep")"
has "$OUT" "Tracking files moved" "legacy project migrated"
has "$OUT" "offer a commit" "commit offered, not done"
[ -f "$L/docs/brace/STATUS.md" ] && [ ! -e "$L/src/deep/docs" ] && echo "PASS: root migrated, not the subfolder" || { echo "FAIL: migration location"; FAIL=1; }
has "$OUT" "Session opened in a tracked project ($L)" "then the normal flow on docs/brace"

# Legacy project while a plugin swap happened this session: no move yet
W="$SCOPE/wait"; status "$W/docs/project-tracker"
OUT="$(run "$W" claude 1)"
has "$OUT" "will be moved to docs/brace/ at the next session" "swap -> migration postponed"
[ -d "$W/docs/project-tracker" ] && [ ! -e "$W/docs/brace" ] && echo "PASS: nothing moved during a swap session" || { echo "FAIL: moved during swap"; FAIL=1; }
has "$OUT" "Session opened in a tracked project ($W)" "legacy still tracked meanwhile"

# Both folders
B="$SCOPE/both"; status "$B/docs/project-tracker"; status "$B/docs/brace"
OUT="$(run "$B")"
has "$OUT" "Both docs/brace/ and docs/project-tracker/ exist" "both -> ask the user"
[ -d "$B/docs/project-tracker" ] && echo "PASS: both untouched" || { echo "FAIL: both touched"; FAIL=1; }
exit $FAIL
