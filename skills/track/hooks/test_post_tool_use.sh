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
SCOPE="$TMP/scope"; SCOPE_FILE_PATH="$HOME/.brace/scopes.txt"; echo "$SCOPE" > "$SCOPE_FILE_PATH"
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

# --- Fix round 1: hook-level coverage restored ---
THR="$TMPDIR/brace-portfolio-regen"
mtime() { date -r "$1" +%s 2>/dev/null || echo 0; }
set_mtime_ago() { python3 -c 'import os,sys,time; t=time.time()-float(sys.argv[2]); os.utime(sys.argv[1],(t,t))' "$1" "$2"; }

# Throttle: two STATUS.md writes in a row -> the generator runs once.
rm -rf "$THR" "$OUTDIR"; mkdir -p "$OUTDIR"
run "$P/docs/brace/STATUS.md" th1 >/dev/null
[ -f "$OUTDIR/PORTFOLIO.html" ] && echo "PASS: throttle -> first STATUS write regenerates" || { echo "FAIL: throttle -> first STATUS write regenerates (known red until Task 11)"; FAIL=1; }
rm -f "$OUTDIR/PORTFOLIO.html"
run "$P/docs/brace/STATUS.md" th2 >/dev/null
[ ! -e "$OUTDIR/PORTFOLIO.html" ] && echo "PASS: throttle -> second STATUS write within 10 s skipped" || { echo "FAIL: throttle -> second STATUS write within 10 s skipped"; FAIL=1; }
# Throttle observed on the marker mtime: a run inside the window must not touch it.
set_mtime_ago "$THR/last" 3; BEFORE="$(mtime "$THR/last")"
run "$P/docs/brace/STATUS.md" th3 >/dev/null
AFTER="$(mtime "$THR/last")"
[ "$AFTER" = "$BEFORE" ] && echo "PASS: throttle -> run inside 10 s window leaves the marker alone" || { echo "FAIL: throttle -> marker touched inside window"; FAIL=1; }
set_mtime_ago "$THR/last" 30; BEFORE="$(mtime "$THR/last")"
run "$P/docs/brace/STATUS.md" th4 >/dev/null
AFTER="$(mtime "$THR/last")"
[ "$AFTER" -gt "$BEFORE" ] && echo "PASS: throttle -> run after 10 s window refreshes the marker" || { echo "FAIL: throttle -> run after window did not refresh marker"; FAIL=1; }

# ROADMAP.md write never regenerates the portfolio.
rm -rf "$THR"; rm -f "$OUTDIR/PORTFOLIO.html"
run "$P/docs/brace/ROADMAP.md" rm1 >/dev/null
[ ! -e "$THR/last" ] && [ ! -e "$OUTDIR/PORTFOLIO.html" ] && echo "PASS: ROADMAP.md write -> no portfolio regeneration" || { echo "FAIL: ROADMAP.md write regenerated the portfolio"; FAIL=1; }

# trackignore.txt: an ignored project is silent and not regenerated.
IGN="$SCOPE/ignored"; proj "$IGN/docs/brace"
echo "$IGN" > "$HOME/.brace/trackignore.txt"
rm -rf "$THR"; rm -f "$OUTDIR/PORTFOLIO.html"
OUT="$(run "$IGN/docs/brace/STATUS.md" ig1)"
empty "$OUT" "trackignore -> ignored project silent"
[ ! -e "$THR/last" ] && [ ! -e "$OUTDIR/PORTFOLIO.html" ] && echo "PASS: trackignore -> ignored project not regenerated" || { echo "FAIL: trackignore -> ignored project regenerated"; FAIL=1; }

# trackignore.txt entry = scope root: only the exact root is ignored, projects inside are still handled.
echo "$SCOPE" > "$HOME/.brace/trackignore.txt"
rm -rf "$THR"
OUT="$(run "$IGN/docs/brace/STATUS.md" ig2)"
empty "$OUT" "scope-root entry -> project inside silent (no note, portfolio configured)"
[ -e "$THR/last" ] && echo "PASS: scope-root entry -> project inside still handled (regeneration attempted)" || { echo "FAIL: scope-root entry -> project inside skipped"; FAIL=1; }
rm -f "$HOME/.brace/trackignore.txt"

# portfolio.txt with comments only: the hook treats the file as configured (no note),
# runs the generation path (throttle marker `last` is written), and the generator
# itself must write nothing. The no-output observation is NOT asserted here: until
# Task 11 the generator never reads ~/.brace, so it is trivially silent; Task 11
# owns that check (test_generate_portfolio.py covers comment-only configs).
printf '# not set\n' > "$HOME/.brace/portfolio.txt"
rm -rf "$THR"
OUT="$(run "$P/docs/brace/STATUS.md" cm1)"
empty "$OUT" "comment-only portfolio.txt -> no 'not configured' note"
[ -e "$THR/last" ] && echo "PASS: comment-only portfolio.txt -> configured path taken (throttle marker written)" || { echo "FAIL: comment-only portfolio.txt -> configured path not taken"; FAIL=1; }
echo "$OUTDIR" > "$HOME/.brace/portfolio.txt"

# Session id "last" in a not-configured run: the note marker is s-last, and the
# throttle file `last` is neither created nor touched by it.
rm -f "$HOME/.brace/portfolio.txt"; rm -rf "$THR"
OUT="$(run "$P/docs/brace/STATUS.md" last)"
has "$OUT" "portfolio output location not configured" "session 'last' not-configured -> note emitted"
[ -e "$THR/s-last" ] && echo "PASS: session 'last' -> s-last marker created" || { echo "FAIL: session 'last' -> s-last marker missing"; FAIL=1; }
[ ! -e "$THR/last" ] && echo "PASS: session 'last' -> throttle file 'last' not created" || { echo "FAIL: session 'last' -> throttle file 'last' created"; FAIL=1; }
echo "$OUTDIR" > "$HOME/.brace/portfolio.txt"

# reminders_list absent -> no nudge.
NL="$SCOPE/nolist"; proj "$NL/docs/brace"
OUT="$(run "$NL/docs/brace/ROADMAP.md" nl1)"; RC=$?
empty "$OUT" "reminders_list absent -> no nudge"
[ "$RC" -eq 0 ] && echo "PASS: reminders_list absent -> exit 0" || { echo "FAIL: reminders_list absent -> exit $RC"; FAIL=1; }

# STATUS.md missing next to ROADMAP.md -> no nudge, exit 0.
NS="$SCOPE/nostatus"; mkdir -p "$NS/docs/brace"; : > "$NS/docs/brace/ROADMAP.md"
OUT="$(run "$NS/docs/brace/ROADMAP.md" ns1)"; RC=$?
empty "$OUT" "STATUS.md absent next to ROADMAP.md -> no nudge"
[ "$RC" -eq 0 ] && echo "PASS: STATUS.md absent -> exit 0" || { echo "FAIL: STATUS.md absent -> exit $RC"; FAIL=1; }

# Scope path containing a space still gets the nudge.
SPC="$TMP/my scope"; echo "$SPC" >> "$SCOPE_FILE_PATH"
proj "$SPC/proj one/docs/brace" 'reminders_list: "L"
'
OUT="$(run "$SPC/proj one/docs/brace/ROADMAP.md" sp1)"
has "$OUT" "Reminders" "scope path with a space -> nudge emitted"

# Session id with "/" : markers stay flat, no stray directory, nudge still works.
SL="$SCOPE/slash"; proj "$SL/docs/brace" 'reminders_list: "L"
'
rm -rf "$TMPDIR/brace-reminders-sync" "$TMPDIR/brace-portfolio-regen"
OUT="$(run "$SL/docs/brace/ROADMAP.md" "a/b")"
has "$OUT" "Reminders" "session id a/b -> nudge emitted"
ls "$TMPDIR/brace-reminders-sync"/s-a_b__* >/dev/null 2>&1 && echo "PASS: session id a/b -> sanitised marker s-a_b__* exists" || { echo "FAIL: session id a/b -> s-a_b__* marker missing"; FAIL=1; }
[ ! -e "$TMPDIR/brace-reminders-sync/a" ] && [ ! -e "$TMPDIR/brace-portfolio-regen/a" ] && echo "PASS: session id a/b -> no stray directory" || { echo "FAIL: session id a/b created a stray directory"; FAIL=1; }
empty "$(run "$SL/docs/brace/ROADMAP.md" "a/b")" "session id a/b -> nudge once per session"

# Source guard: missing plugin root -> exit 0, empty stdout, no crash
RC=0
ERR_FILE="$TMP/guard.err"
OUT="$(BRACE_FILE="$P/docs/brace/STATUS.md" BRACE_SESSION=s6 BRACE_TOOL=claude BRACE_PLUGIN_ROOT="$TMP/no-such-root" bash "$HOOK" 2>"$ERR_FILE")" || RC=$?
[ "$RC" -eq 0 ] && echo "PASS: missing BRACE_PLUGIN_ROOT -> exit 0" || { echo "FAIL: missing BRACE_PLUGIN_ROOT -> exit $RC"; FAIL=1; }
empty "$OUT" "missing BRACE_PLUGIN_ROOT -> empty stdout"
empty "$(cat "$ERR_FILE")" "missing BRACE_PLUGIN_ROOT -> no stderr noise"
exit $FAIL
