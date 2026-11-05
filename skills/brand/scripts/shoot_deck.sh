#!/usr/bin/env bash
# BRACE brand -- one PNG screenshot per slide of a presentation, for the
# creative director's review (it reads images, not PDFs).
# Usage: shoot_deck.sh <deck.html> <out_dir> [--only 3,7]
# Writes <out_dir>/01.png, 02.png... (1440x900) with a headless Chrome or
# Edge (BRACE_BROWSER forces one). Each slide is shot from a temporary copy
# of the deck, next to it so deck.css and fonts/ still load, showing only
# that slide; the copy is removed. Exit 0 done, 1 bad input, 2 no browser.
# Bash 3.2 compatible, python3 stdlib only.
set -uo pipefail
DECK="${1:-}"; OUT="${2:-}"; ONLY=""
[ "${3:-}" = "--only" ] && ONLY="${4:-}"
[ -f "$DECK" ] && [ -n "$OUT" ] || { echo "usage: shoot_deck.sh <deck.html> <out_dir> [--only 3,7]" >&2; exit 1; }
case "$ONLY" in *[!0-9,]*) echo "--only takes slide numbers, e.g. 3,7" >&2; exit 1 ;; esac
[ "${3:-}" = "--only" ] && [ -z "$ONLY" ] && { echo "--only takes slide numbers, e.g. 3,7" >&2; exit 1; }

BROWSER="${BRACE_BROWSER:-}"
if [ -z "$BROWSER" ]; then
  for b in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
           "$(command -v google-chrome 2>/dev/null)" "$(command -v chromium 2>/dev/null)"; do
    [ -n "$b" ] && [ -x "$b" ] && { BROWSER="$b"; break; }
  done
fi
[ -n "$BROWSER" ] && [ -x "$BROWSER" ] || { echo "no Chrome or Edge found: rendering not checked" >&2; exit 2; }

DECK_DIR="$(cd "$(dirname "$DECK")" && pwd)"
COUNT="$(python3 - "$DECK" <<'PY'
import re, sys
html = open(sys.argv[1], encoding="utf-8").read()
print(len(re.findall(r'<section\b[^>]*\bclass="(?:[^"]*\s)?slide(?:\s[^"]*)?"', html)))
PY
)" || exit 1
[ "${COUNT:-0}" -gt 0 ] 2>/dev/null || { echo "no slide found in $DECK" >&2; exit 1; }

mkdir -p "$OUT" || exit 1
TMPPAGE="$DECK_DIR/.shot-$$.html"
trap 'rm -f "$TMPPAGE"' EXIT
n=1
while [ "$n" -le "$COUNT" ]; do
  if [ -z "$ONLY" ] || printf ',%s,' "$ONLY" | grep -q ",$n,"; then
    python3 - "$DECK" "$TMPPAGE" "$n" <<'PY' || exit 1
import re, sys
src, dst, n = sys.argv[1], sys.argv[2], int(sys.argv[3])
html = open(src, encoding="utf-8").read()
pat = re.compile(r'(<section\b[^>]*\bclass="(?:[^"]*\s)?slide(?:\s[^"]*)?")')
count = [0]
def mark(m):
    count[0] += 1
    return m.group(1) + (' data-shot' if count[0] == n else '')
html = pat.sub(mark, html)
style = ('<style>html{scroll-snap-type:none!important}'
         '.slide{display:none!important}.slide[data-shot]{display:flex!important}</style>')
html = html.replace('</head>', style + '</head>', 1) if '</head>' in html else style + html
open(dst, "w", encoding="utf-8").write(html)
PY
    "$BROWSER" --headless=new --hide-scrollbars --virtual-time-budget=3000 \
      --window-size=1440,900 --screenshot="$OUT/$(printf '%02d' "$n").png" \
      "file://$TMPPAGE" >/dev/null 2>&1 || true
  fi
  n=$((n + 1))
done
exit 0
