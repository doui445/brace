#!/usr/bin/env bash
# Tests for dispatch/lib.sh. Run: bash dispatch/test_lib.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
eq() { if [ "$1" = "$2" ]; then echo "PASS: $3"; else echo "FAIL: $3 — expected [$2], got [$1]"; FAIL=1; fi; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"; mkdir -p "$HOME/.brace"
. "$DIR/lib.sh"

SCOPE="$TMP/my scope"            # space on purpose
mkdir -p "$SCOPE/proj/docs/brace" "$SCOPE/old/docs/project-tracker" "$SCOPE/old/a/b" "$SCOPE/both/docs/brace" "$SCOPE/both/docs/project-tracker" "$SCOPE/skipme/x"
touch "$SCOPE/proj/docs/brace/STATUS.md" "$SCOPE/old/docs/project-tracker/STATUS.md" "$SCOPE/both/docs/brace/STATUS.md" "$SCOPE/both/docs/project-tracker/STATUS.md"
printf '# comment\n\n%s/\n' "$SCOPE" > "$HOME/.brace/scopes.txt"
printf '%s/skipme\n%s\n' "$SCOPE" "$SCOPE" > "$HOME/.brace/trackignore.txt"

eq "$(brace_config_dir)" "$HOME/.brace" "config dir is ~/.brace"
eq "$(brace_scope_root "$SCOPE/proj")" "$SCOPE" "scope root found (path with space, trailing slash in file)"
eq "$(brace_scope_root "/elsewhere")" "" "outside any scope -> empty"
brace_is_ignored "$SCOPE/skipme/x" && r=0 || r=1; eq "$r" "0" "descendant of an ignored folder is ignored"
brace_is_ignored "$SCOPE" && r=0 || r=1; eq "$r" "0" "scope root listed -> that exact folder ignored"
brace_is_ignored "$SCOPE/proj" && r=0 || r=1; eq "$r" "1" "scope root listed -> projects inside NOT ignored"
eq "$(brace_tracking_dir "$SCOPE/proj")" "docs/brace" "new layout"
eq "$(brace_tracking_dir "$SCOPE/old")" "docs/project-tracker" "legacy layout"
eq "$(brace_tracking_dir "$SCOPE/both")" "docs/brace" "both -> docs/brace wins"
eq "$(brace_tracking_dir "$SCOPE")" "" "no tracking dir"
eq "$(brace_find_project "$SCOPE/old/a/b" "$SCOPE")" "$SCOPE/old" "walks up to a legacy project root"
eq "$(brace_find_project "$SCOPE/proj" "$SCOPE")" "$SCOPE/proj" "project root itself"
eq "$(brace_find_project "$SCOPE/skipme/x" "$SCOPE")" "" "nothing up to the stop dir"
eq "$(brace_find_project "$SCOPE/proj/docs/brace" /)" "$SCOPE/proj" "stop at / works"
# Relative start paths must terminate (dirname of "." is "." forever).
# cd happens in the parent shell so eq's FAIL=1 reaches the exit status.
here="$PWD"
cd "$TMP" || exit 1
eq "$(brace_find_project "rel/path" /)" "" "relative start path terminates, empty"
eq "$(brace_find_project "" /)" "" "empty start path terminates, empty"
cd "$here" || exit 1

rm "$HOME/.brace/scopes.txt"
eq "$(brace_scope_root "$SCOPE/proj")" "" "no scopes.txt -> empty"
exit $FAIL
