#!/usr/bin/env bash
# Tests for skills/brand/scripts/shoot_deck.sh with a stub browser.
# Run: bash skills/brand/scripts/test_shoot_deck.sh
set -uo pipefail
SCRIPT="$(cd "$(dirname "$0")" && pwd)/shoot_deck.sh"
FAIL=0
eq() { if [ "$1" = "$2" ]; then echo "PASS: $3"; else echo "FAIL: $3: expected [$2], got [$1]"; FAIL=1; fi; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# The stub writes the screenshot file and keeps a copy of the page it was given.
STUB="$TMP/browser"
cat > "$STUB" <<'STUBEOF'
#!/usr/bin/env bash
for a in "$@"; do
  case "$a" in
    --screenshot=*) OUT="${a#--screenshot=}" ;;
    file://*) PAGE="${a#file://}" ;;
  esac
done
cp "$PAGE" "$OUT.page"
printf 'PNG' > "$OUT"
STUBEOF
chmod +x "$STUB"

D="$TMP/my deck"; mkdir -p "$D"
cat > "$D/draft.html" <<'HTML'
<!DOCTYPE html><html lang="en"><head><link rel="stylesheet" href="deck.css"></head><body>
<section class="slide cover">one</section>
<section class="slide route">two</section>
<section class="note">not a slide</section>
<section class="slide reco">three</section>
<script>var x = 1;</script>
</body></html>
HTML
OUT="$TMP/shots"
BRACE_BROWSER="$STUB" bash "$SCRIPT" "$D/draft.html" "$OUT"; eq "$?" 0 "three slides -> exit 0"
eq "$(cd "$OUT" && ls *.png | tr '\n' ' ')" "01.png 02.png 03.png " "one PNG per slide, numbered"
grep -q 'data-shot' "$OUT/02.png.page" && grep -q 'class="slide route" data-shot' "$OUT/02.png.page" && echo "PASS: slide 2 page marks the second slide" || { echo "FAIL: slide 2 not marked"; FAIL=1; }
eq "$(grep -o '" data-shot' "$OUT/03.png.page" | wc -l | tr -d ' ')" 1 "one slide shown per page"
grep -q 'class="slide reco" data-shot' "$OUT/03.png.page" && echo "PASS: a non-slide section is not counted" || { echo "FAIL: third slide wrong"; FAIL=1; }
eq "$(ls -A "$D" | tr '\n' ' ')" "draft.html " "temporary page removed, deck untouched"

rm -rf "$OUT"
BRACE_BROWSER="$STUB" bash "$SCRIPT" "$D/draft.html" "$OUT" --only 3,1; eq "$?" 0 "--only -> exit 0"
eq "$(cd "$OUT" && ls *.png | tr '\n' ' ')" "01.png 03.png " "--only shoots the named slides only"

BRACE_BROWSER="$TMP/none" bash "$SCRIPT" "$D/draft.html" "$OUT" >/dev/null 2>&1; eq "$?" 2 "browser missing -> exit 2"
BRACE_BROWSER="$STUB" bash "$SCRIPT" "$TMP/missing.html" "$OUT" >/dev/null 2>&1; eq "$?" 1 "deck missing -> exit 1"
printf '<html><body>nothing</body></html>' > "$TMP/empty.html"
BRACE_BROWSER="$STUB" bash "$SCRIPT" "$TMP/empty.html" "$OUT" >/dev/null 2>&1; eq "$?" 1 "no slide -> exit 1"
BRACE_BROWSER="$STUB" bash "$SCRIPT" "$D/draft.html" "$OUT" --only x >/dev/null 2>&1; eq "$?" 1 "bad --only -> exit 1"

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
