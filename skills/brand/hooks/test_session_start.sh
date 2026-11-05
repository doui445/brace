#!/usr/bin/env bash
# Tests for skills/brand/hooks/session_start.sh. Run: bash skills/brand/hooks/test_session_start.sh
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/session_start.sh"
PLUGIN_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3: missing [$2] in [$1]"; FAIL=1 ;; esac; }
empty() { [ -z "$1" ] && echo "PASS: $2" || { echo "FAIL: $2: got [$1]"; FAIL=1; }; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home" TMPDIR="$TMP/tmp"; mkdir -p "$HOME/.brace" "$TMPDIR"
ago() { python3 -c 'import sys,datetime; print(datetime.date.today()-datetime.timedelta(days=int(sys.argv[1])))' "$1"; }
proj() { mkdir -p "$1/docs/brace/brand"; printf -- '---\nproject: p\nstatus: active\nlast_updated: 2026-01-01\n%s---\n' "${2:-}" > "$1/docs/brace/STATUS.md"; }
run() { BRACE_PROJECT_ROOT="$1" BRACE_TOOL="${2:-claude}" BRACE_SOURCE="${3:-startup}" BRACE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$HOOK"; }

P="$TMP/scope/p"
proj "$P" "brand_reviewed: $(ago 10)
"
empty "$(run "$P")" "recent review -> silent"

proj "$P" "brand_reviewed: $(ago 200)
"
OUT="$(run "$P")"
has "$OUT" "last reviewed on $(ago 200)" "old review -> one line with the date"
has "$OUT" "brace:brand" "claude names brace:brand"
has "$OUT" "touch" "line gives the snooze command"
has "$(run "$P" antigravity)" "invoke the brand skill" "antigravity names brand"
empty "$(run "$P" claude compact)" "compact -> silent"
empty "$(run "$P" claude resume)" "resume -> silent"

proj "$P" "brand_reviewed: \"$(ago 200)\"
"
has "$(run "$P")" "last reviewed on" "quoted date is read"
printf -- '---\nproject: p\nbrand_reviewed: %s\r\n---\n' "$(ago 200)" > "$P/docs/brace/STATUS.md"
has "$(run "$P")" "last reviewed on" "CRLF date is read"

SNOOZE="$HOME/.brace/brand/snooze/$(printf '%s' "$P" | tr '/ ' '__')"
mkdir -p "$(dirname "$SNOOZE")"; touch "$SNOOZE"
empty "$(run "$P")" "snoozed less than 30 days ago -> silent"
python3 -c 'import os,sys,time; t=time.time()-31*86400; os.utime(sys.argv[1],(t,t))' "$SNOOZE"
has "$(run "$P")" "last reviewed on" "snooze older than 30 days -> line again"
rm -f "$SNOOZE"

proj "$P" "brand_reviewed: $(ago 200) # last full review
"
has "$(run "$P")" "last reviewed on $(ago 200)." "date followed by a comment is read"
proj "$P" "brand_stage: voice
"
empty "$(run "$P")" "no brand_reviewed (brand in progress) -> silent"
proj "$P" "brand_reviewed: someday
"
empty "$(run "$P")" "unreadable date -> silent"
proj "$P" "brand_reviewed: 2999-01-01
"
empty "$(run "$P")" "future date -> silent"
rm -rf "$P/docs/brace/brand"
proj_nobrand="$P"; printf -- '---\nbrand_reviewed: %s\n---\n' "$(ago 200)" > "$P/docs/brace/STATUS.md"
empty "$(run "$proj_nobrand")" "no brand folder -> silent"
empty "$(run "")" "no project root -> silent"

# Antigravity cannot receive the post-write reminder: the session start lists the touchpoints.
A="$TMP/scope/agy"
proj "$A" "brand_reviewed: $(ago 10)
"
printf '## Touchpoints\n\n- `README.md`\n- `docs/site/index.html`\n' > "$A/docs/brace/brand/STRATEGY.md"
OUT="$(run "$A" antigravity)"
has "$OUT" "README.md, docs/site/index.html" "antigravity -> touchpoints listed at session start"
has "$OUT" "VOICE.md" "antigravity touchpoint line points to VOICE.md"
empty "$(run "$A" claude)" "claude -> no touchpoint line (the post-write hook covers it)"
rm -f "$A/docs/brace/brand/STRATEGY.md"
empty "$(run "$A" antigravity)" "antigravity without STRATEGY.md -> silent"

# The decks already there are marked seen: the notification stays for new ones.
K="$TMP/scope/k"
proj "$K" "brand_reviewed: $(ago 10)
"
mkdir -p "$K/docs/brace/brand/presentations"
touch "$K/docs/brace/brand/presentations/2026-09-01-strategy.html" "$K/docs/brace/brand/presentations/draft.html"
for SRC in startup resume; do
  SEEN="$TMPDIR/brace-brand-notify/k-$SRC.seen"
  empty "$(BRACE_SESSION="k-$SRC" run "$K" claude "$SRC")" "seeding prints nothing ($SRC)"
  grep -qxF "$K/docs/brace/brand/presentations/2026-09-01-strategy.html" "$SEEN" 2>/dev/null && echo "PASS: existing deck seeded ($SRC)" || { echo "FAIL: existing deck not seeded ($SRC)"; FAIL=1; }
  grep -q "draft.html" "$SEEN" 2>/dev/null && { echo "FAIL: draft seeded ($SRC)"; FAIL=1; } || echo "PASS: draft not seeded ($SRC)"
done
BRACE_SESSION="k-startup" run "$K" >/dev/null
[ "$(wc -l < "$TMPDIR/brace-brand-notify/k-startup.seen" | tr -d ' ')" = 1 ] && echo "PASS: seeding twice adds no duplicate" || { echo "FAIL: duplicate in seen list"; FAIL=1; }

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
