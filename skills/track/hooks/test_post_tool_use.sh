#!/usr/bin/env bash
# Tests for skills/track/hooks/post_tool_use.sh. Run: bash skills/track/hooks/test_post_tool_use.sh
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/post_tool_use.sh"
PLUGIN_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2] in [$1]"; FAIL=1 ;; esac; }
empty() { [ -z "$1" ] && echo "PASS: $2" || { echo "FAIL: $2 — got [$1]"; FAIL=1; }; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home" TMPDIR="$TMP/tmp"; mkdir -p "$HOME/.brace" "$TMPDIR"
SCOPE="$TMP/scope"; echo "$SCOPE" > "$HOME/.brace/scopes.txt"
run() { BRACE_FILE="$1" BRACE_SESSION="${2:-s1}" BRACE_TOOL=claude BRACE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$HOOK"; }
proj() { mkdir -p "$1"; printf -- '---\nproject: %s\nstatus: active\nlast_updated: 2026-01-01\n%s---\n' "$(basename "$(dirname "$(dirname "$1")")")" "${2:-}" > "$1/STATUS.md"; }

P="$SCOPE/p"; proj "$P/docs/brace"
empty "$(run "$P/src/main.py")" "unrelated file -> silence"
empty "$(run "/outside/docs/brace/STATUS.md")" "outside scopes -> silence"

OUT="$(run "$P/docs/brace/STATUS.md")"
has "$OUT" "portfolio output location not configured" "no portfolio.txt -> note once"
empty "$(run "$P/docs/brace/STATUS.md")" "note not repeated in the same session"

OUTDIR="$TMP/out"; echo "$OUTDIR" > "$HOME/.brace/portfolio.txt"
run "$P/docs/brace/STATUS.md" s2 >/dev/null
[ -f "$OUTDIR/PORTFOLIO.html" ] && echo "PASS: portfolio regenerated" || { echo "FAIL: no PORTFOLIO.html"; FAIL=1; }

L="$SCOPE/legacy"; proj "$L/docs/project-tracker"; rm -rf "$TMPDIR/brace-portfolio-regen"
run "$L/docs/project-tracker/STATUS.md" s3 >/dev/null
grep -q "legacy" "$OUTDIR/PORTFOLIO.html" && echo "PASS: legacy STATUS.md write also regenerates" || { echo "FAIL: legacy not in portfolio"; FAIL=1; }

R="$SCOPE/r"; proj "$R/docs/brace" 'reminders_list: "My list"
'
OUT="$(run "$R/docs/brace/ROADMAP.md" s4)"
has "$OUT" "Reminders" "linked list + ROADMAP write -> reminders nudge"
has "$OUT" "brace:track" "nudge names brace:track"
empty "$(run "$R/docs/brace/STATUS.md" s4 | grep Reminders)" "nudge once per session and project"

N="$SCOPE/n"; proj "$N/docs/brace" 'reminders_list: "non"
'
OUT="$(run "$N/docs/brace/ROADMAP.md" s5)"
case "$OUT" in *Reminders*) echo "FAIL: declined list nudged"; FAIL=1 ;; *) echo "PASS: \"non\" -> no nudge" ;; esac

# Source guard: missing plugin root -> exit 0, empty stdout, no crash
RC=0
ERR_FILE="$TMP/guard.err"
OUT="$(BRACE_FILE="$P/docs/brace/STATUS.md" BRACE_SESSION=s6 BRACE_TOOL=claude BRACE_PLUGIN_ROOT="$TMP/no-such-root" bash "$HOOK" 2>"$ERR_FILE")" || RC=$?
[ "$RC" -eq 0 ] && echo "PASS: missing BRACE_PLUGIN_ROOT -> exit 0" || { echo "FAIL: missing BRACE_PLUGIN_ROOT -> exit $RC"; FAIL=1; }
empty "$OUT" "missing BRACE_PLUGIN_ROOT -> empty stdout"
empty "$(cat "$ERR_FILE")" "missing BRACE_PLUGIN_ROOT -> no stderr noise"
exit $FAIL
