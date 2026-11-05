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

# Presentation ready -> macOS notification (stubbed). The hook scans the
# final decks after any write or command, and notifies each one once per
# session, however it was written (an editor write or a cp).
NOTE="$TMP/notified"; STUB="$TMP/notify_stub.sh"
printf '#!/usr/bin/env bash\nprintf "%%s|%%s\\n" "$1" "$2" >> "%s"\n' "$NOTE" > "$STUB"; chmod +x "$STUB"
nrun() { BRACE_NOTIFY_CMD="$STUB" BRACE_UNAME="${5:-Darwin}" run "$1" "$2" "${3:-n1}" "${4:-claude}"; }
calls() { [ -f "$NOTE" ] && wc -l < "$NOTE" | tr -d ' ' || echo 0; }
ncount() { [ "$(calls)" = "$1" ] && echo "PASS: $2" || { echo "FAIL: $2: $(calls) calls, expected $1"; FAIL=1; }; }
D="$TMP/scope/d"; PR="$D/docs/brace/brand/presentations"; mkdir -p "$PR"
DECK="$PR/2026-10-26-strategy.html"
echo '<html lang="en">' > "$PR/draft.html"
nrun "$D" "$PR/draft.html" >/dev/null
ncount 0 "draft.html -> never notified"
echo '<html lang="en">' > "$DECK"
empty "$(nrun "$D" "$DECK")" "presentation -> no text output"
has "$(cat "$NOTE" 2>/dev/null)" "BRACE|The agency's work is ready." "presentation -> notification"
nrun "$D" "$DECK" >/dev/null
ncount 1 "same deck, same session -> once"
nrun "$D" "" >/dev/null
ncount 1 "a later command, deck already seen -> silent"
cp "$DECK" "$PR/2026-10-27-adjustments.html"
nrun "$D" "" >/dev/null
ncount 2 "deck copied by a command (no file) -> notified"
nrun "$D" "$D/src/x.py" >/dev/null
ncount 2 "unrelated write, nothing new -> silent"
echo '<html lang="en">' > "$PR/.shot.html"
nrun "$D" "" >/dev/null
ncount 2 "hidden temporary deck -> not notified"
echo 'x' > "$PR/notes.md"
nrun "$D" "$PR/notes.md" >/dev/null
ncount 2 "non-html file -> not notified"
nrun "$D" "" n2 >/dev/null
ncount 3 "new session, no seen list -> the final decks are new (one notification)"
empty "$(nrun "$D" "" n4 claude Linux)" "not macOS -> no output"
ncount 3 "not macOS -> not notified"

# The seen list seeded by session_start: decks already there stay quiet.
H="$TMP/scope/h"; HP="$H/docs/brace/brand/presentations"; mkdir -p "$HP"
echo '<html lang="en">' > "$HP/2026-09-01-strategy.html"
mkdir -p "$TMPDIR/brace-brand-notify"; printf '%s\n' "$HP/2026-09-01-strategy.html" > "$TMPDIR/brace-brand-notify/seeded.seen"
nrun "$H" "" seeded >/dev/null
ncount 3 "deck in the seeded list -> not notified"

# Language: the deck's own lang first, then the project, then language.txt.
F="$TMP/scope/f"; FP="$F/docs/brace/brand/presentations"; mkdir -p "$FP"
printf -- '---\nproject: f\nlanguage: en\n---\n' > "$F/docs/brace/STATUS.md"
echo '<!DOCTYPE html><html lang="fr">' > "$FP/a.html"
nrun "$F" "$FP/a.html" >/dev/null
has "$(tail -1 "$NOTE" 2>/dev/null)" "BRACE|Le travail de l'agence est prêt." "deck lang fr -> French message"
printf -- '---\nproject: f\nlanguage:\tfr\n---\n' > "$F/docs/brace/STATUS.md"
echo '<html>' > "$FP/b.html"
nrun "$F" "$FP/b.html" >/dev/null
has "$(tail -1 "$NOTE" 2>/dev/null)" "prêt" "no deck lang, language after a tab -> French message"
G="$TMP/scope/g"; GP="$G/docs/brace/brand/presentations"; mkdir -p "$GP"; echo fr > "$HOME/.brace/language.txt"
echo '<html>' > "$GP/a.html"
nrun "$G" "$GP/a.html" >/dev/null
has "$(tail -1 "$NOTE" 2>/dev/null)" "prêt" "language.txt fr -> French message"
echo '../../x' > "$HOME/.brace/language.txt"
echo '<html>' > "$GP/b.html"
nrun "$G" "$GP/b.html" >/dev/null
has "$(tail -1 "$NOTE" 2>/dev/null)" "BRACE|The agency's work is ready." "invalid language code -> English message"
rm -f "$HOME/.brace/language.txt"

# The real AppleScript path never gets a backslash or a double quote.
OSA="$TMP/bin"; mkdir -p "$OSA"; printf '#!/usr/bin/env bash\nprintf "%%s" "$2" > "%s/osa_arg"\n' "$TMP" > "$OSA/osascript"; chmod +x "$OSA/osascript"
FAKE="$TMP/fakeplugin"; mkdir -p "$FAKE/dispatch" "$FAKE/skills/track/references/i18n" "$FAKE/skills/brand/hooks"
cp "$PLUGIN_ROOT/dispatch/lib.sh" "$FAKE/dispatch/"; cp "$PLUGIN_ROOT"/skills/brand/hooks/*.sh "$FAKE/skills/brand/hooks/"
printf -- '- brand.notify.title: BR"ACE\\\n- brand.notify.ready: Ready \\" now.\n' > "$FAKE/skills/track/references/i18n/en.md"
Q="$TMP/scope/q"; QP="$Q/docs/brace/brand/presentations"; mkdir -p "$QP"; echo '<html lang="en">' > "$QP/a.html"
PATH="$OSA:$PATH" BRACE_UNAME=Darwin BRACE_FILE="$QP/a.html" BRACE_SESSION=q1 BRACE_PROJECT_ROOT="$Q" BRACE_PLUGIN_ROOT="$FAKE" bash "$FAKE/skills/brand/hooks/post_tool_use.sh"
sleep 1
ARG="$(cat "$TMP/osa_arg" 2>/dev/null)"
case "$ARG" in *'\'*) echo "FAIL: backslash reached AppleScript: [$ARG]"; FAIL=1 ;; *'display notification'*) echo "PASS: no backslash in the AppleScript" ;; *) echo "FAIL: osascript not called: [$ARG]"; FAIL=1 ;; esac
case "$ARG" in *'BR"ACE'*|*'Ready "'*) echo "FAIL: double quote reached AppleScript: [$ARG]"; FAIL=1 ;; *) echo "PASS: no double quote in the texts" ;; esac

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
