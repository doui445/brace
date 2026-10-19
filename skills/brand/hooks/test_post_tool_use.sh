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

N="$TMP/scope/n"; mkdir -p "$N/docs/brace/brand"
empty "$(run "$N" "$N/README.md")" "no STRATEGY.md -> silent"
strategy "$N" '## Positioning

Nothing.'
empty "$(run "$N" "$N/README.md")" "no Touchpoints section -> silent"
empty "$(run "" "$P/README.md")" "no project root -> silent"
empty "$(BRACE_FILE="$P/README.md" BRACE_PROJECT_ROOT="$P" BRACE_PLUGIN_ROOT="$PLUGIN_ROOT" bash "$HOOK")" "no session id -> silent"

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
