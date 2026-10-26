#!/usr/bin/env bash
# Tests for skills/brand/hooks/post_tool_use.sh. Run: bash skills/brand/hooks/test_post_tool_use.sh
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/post_tool_use.sh"
PLUGIN_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3: missing [$2] in [$1]"; FAIL=1 ;; esac; }
empty() { [ -z "$1" ] && echo "PASS: $2" || { echo "FAIL: $2: got [$1]"; FAIL=1; }; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home" TMPDIR="$TMP/tmp"; mkdir -p "$HOME/.brace" "$TMPDIR"
run() { BRACE_FILE="$2" BRACE_SESSION="${3:-s1}" BRACE_PROJECT_ROOT="$1" BRACE_TOOL="${4:-claude}" BRACE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$HOOK"; }
strategy() { mkdir -p "$1/docs/brace/brand"; printf '%s\n' "$2" > "$1/docs/brace/brand/STRATEGY.md"; }

P="$TMP/scope/p"
strategy "$P" '# STRATEGY - p

## Positioning

Mentions `NOT_A_TOUCHPOINT.md` here.

## Touchpoints

Checked against `docs/brace/brand/VOICE.md` at each review, and `NOTE_IN_SECTION.md` too.

- `README.md`: first contact
- `docs/site/index.html` and `./CHANGELOG.md`
- `site/about us.md`

## Non-goals

- `LATER.md`'

OUT="$(run "$P" "$P/README.md")"
has "$OUT" "README.md is a brand touchpoint" "listed file -> reminder"
has "$OUT" "VOICE.md" "reminder points to VOICE.md"
has "$OUT" "brace:brand" "claude names brace:brand"
empty "$(run "$P" "$P/README.md")" "same file, same session -> once"
has "$(run "$P" "$P/README.md" s2)" "touchpoint" "new session -> again"
has "$(run "$P" "$P/docs/site/index.html")" "touchpoint" "second path on a line"
has "$(run "$P" "$P/CHANGELOG.md")" "touchpoint" "./ prefix normalised"
has "$(run "$P" "$P/site/about us.md")" "touchpoint" "path with a space"
has "$(run "$P" "$P/README.md" s3 antigravity)" "invoke the brand skill" "antigravity names brand"
empty "$(run "$P" "$P/NOT_A_TOUCHPOINT.md")" "backticks outside the section -> silent"
empty "$(run "$P" "$P/LATER.md")" "next section not read"
empty "$(run "$P" "$P/NOTE_IN_SECTION.md")" "prose in the section -> silent"
empty "$(run "$P" "$P/src/main.py")" "unlisted file -> silent"
empty "$(run "$P" "$P/docs/brace/brand/STRATEGY.md")" "brand files themselves -> silent"
empty "$(run "$P" "/elsewhere/README.md")" "file outside the project -> silent"

F="$TMP/scope/f"
strategy "$F" '## Points de contact

- `README.md`'
has "$(run "$F" "$F/README.md")" "touchpoint" "French heading is found"

# Heading variants an AI may write: numbered, level 3, extra words, extra spaces, other case.
for H in "## 9. Touchpoints" "### Touchpoints" "## Touchpoints (where we speak)" "##  Touchpoints" "## touchpoints"; do
  V="$TMP/scope/v$RANDOM"
  strategy "$V" "$H

- \`README.md\`

## Next"
  has "$(run "$V" "$V/README.md")" "touchpoint" "heading variant [$H] is found"
done
S2="$TMP/scope/sub"
strategy "$S2" '## Touchpoints

### In the repo

- `README.md`

## Non-goals

- `LATER.md`'
has "$(run "$S2" "$S2/README.md")" "touchpoint" "sub-heading inside the section keeps it open"
empty "$(run "$S2" "$S2/LATER.md")" "next level-2 heading closes the section"

# Session markers: two different files must never share one, and a deep path still works.
C="$TMP/scope/collide"
DEEP="d/$(printf 'very-long-folder-name-%s/' 1 2 3 4 5 6 7 8 9 10 11 12)page.md"
strategy "$C" "## Touchpoints

- \`a b.md\`
- \`a_b.md\`
- \`$DEEP\`"
has "$(run "$C" "$C/a b.md" sx)" "touchpoint" "first of two similar names"
has "$(run "$C" "$C/a_b.md" sx)" "touchpoint" "second similar name gets its own marker"
has "$(run "$C" "$C/$DEEP" sx)" "touchpoint" "deep path -> reminder"
empty "$(run "$C" "$C/$DEEP" sx)" "deep path -> once per session"

N="$TMP/scope/n"; mkdir -p "$N/docs/brace/brand"
empty "$(run "$N" "$N/README.md")" "no STRATEGY.md -> silent"
strategy "$N" '## Positioning

Nothing.'
empty "$(run "$N" "$N/README.md")" "no Touchpoints section -> silent"
empty "$(run "" "$P/README.md")" "no project root -> silent"
empty "$(BRACE_FILE="$P/README.md" BRACE_PROJECT_ROOT="$P" BRACE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$HOOK")" "no session id -> silent"

# Presentation ready -> macOS notification (stubbed), once per file and session.
NOTE="$TMP/notified"; STUB="$TMP/notify_stub.sh"
printf '#!/usr/bin/env bash\nprintf "%%s|%%s\\n" "$1" "$2" >> "%s"\n' "$NOTE" > "$STUB"; chmod +x "$STUB"
nrun() { BRACE_NOTIFY_CMD="$STUB" BRACE_UNAME="${5:-Darwin}" run "$1" "$2" "${3:-n1}" "${4:-claude}"; }
calls() { [ -f "$NOTE" ] && wc -l < "$NOTE" | tr -d ' ' || echo 0; }
D="$TMP/scope/d"; mkdir -p "$D/docs/brace/brand/presentations"
DECK="$D/docs/brace/brand/presentations/2026-10-26-strategy.html"
empty "$(nrun "$D" "$DECK")" "presentation -> no text output"
has "$(cat "$NOTE" 2>/dev/null)" "BRACE|Your brand presentation is ready." "presentation -> notification"
nrun "$D" "$DECK" >/dev/null
[ "$(calls)" = 1 ] && echo "PASS: same deck, same session -> once" || { echo "FAIL: same deck, same session -> once: $(calls) calls"; FAIL=1; }
nrun "$D" "$DECK" n2 >/dev/null
[ "$(calls)" = 2 ] && echo "PASS: new session -> notified again" || { echo "FAIL: new session -> notified again: $(calls) calls"; FAIL=1; }
nrun "$D" "$D/docs/brace/brand/presentations/draft.html" n3 >/dev/null
[ "$(calls)" = 2 ] && echo "PASS: draft.html -> never notified" || { echo "FAIL: draft.html -> never notified: $(calls) calls"; FAIL=1; }
nrun "$D" "$D/docs/brace/brand/presentations/notes.md" n3 >/dev/null
[ "$(calls)" = 2 ] && echo "PASS: non-html file -> not notified" || { echo "FAIL: non-html file -> not notified: $(calls) calls"; FAIL=1; }
empty "$(nrun "$D" "$DECK" n4 claude Linux)" "not macOS -> no output"
[ "$(calls)" = 2 ] && echo "PASS: not macOS -> not notified" || { echo "FAIL: not macOS -> not notified: $(calls) calls"; FAIL=1; }
F="$TMP/scope/f"; mkdir -p "$F/docs/brace/brand/presentations"
printf -- '---\nproject: f\nlanguage: fr\n---\n' > "$F/docs/brace/STATUS.md"
nrun "$F" "$F/docs/brace/brand/presentations/a.html" >/dev/null
has "$(tail -1 "$NOTE" 2>/dev/null)" "BRACE|Ta présentation de marque est prête." "language fr -> French message"
G="$TMP/scope/g"; mkdir -p "$G/docs/brace/brand/presentations"; echo fr > "$HOME/.brace/language.txt"
nrun "$G" "$G/docs/brace/brand/presentations/a.html" >/dev/null
has "$(tail -1 "$NOTE" 2>/dev/null)" "prête" "language.txt fr -> French message"
rm -f "$HOME/.brace/language.txt"

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
