#!/usr/bin/env bash
# Tests for dispatch/migrate_config.sh. Run: bash dispatch/test_migrate_config.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
ok() { if eval "$1"; then echo "PASS: $2"; else echo "FAIL: $2"; FAIL=1; fi; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
fresh() { rm -rf "$TMP/h"; mkdir -p "$TMP/h"; export HOME="$TMP/h"; }
run() { bash "$DIR/migrate_config.sh"; }

# A: v0.13 layout — real ~/.project-tracker, links from .claude and .gemini
fresh; mkdir -p "$HOME/.project-tracker" "$HOME/.claude" "$HOME/.gemini"
echo "/code" > "$HOME/.project-tracker/scopes.txt"
ln -s "$HOME/.project-tracker" "$HOME/.claude/project-tracker"
ln -s "$HOME/.project-tracker" "$HOME/.gemini/project-tracker"
run
ok '[ -d "$HOME/.brace" ] && [ ! -L "$HOME/.brace" ]' "A: ~/.brace is a real folder"
ok '[ "$(cat "$HOME/.brace/scopes.txt")" = "/code" ]' "A: content moved"
for l in "$HOME/.project-tracker" "$HOME/.claude/project-tracker" "$HOME/.gemini/project-tracker"; do
  ok '[ -L "'"$l"'" ] && [ "$(readlink "'"$l"'")" = "$HOME/.brace" ]' "A: $l -> ~/.brace"
done
ok '[ "$(cat "$HOME/.claude/project-tracker/scopes.txt")" = "/code" ]' "A: old path still reads the config"
ok '[ -f "$HOME/.brace/.from-project-tracker" ]' "A: migration flag set"

# B: idempotent — second run moves nothing, no new flag
rm "$HOME/.brace/.from-project-tracker"; run
ok '[ ! -f "$HOME/.brace/.from-project-tracker" ]' "B: second run sets no flag"
ok '[ "$(cat "$HOME/.brace/scopes.txt")" = "/code" ]' "B: content intact"

# C: brand-new user — no legacy anywhere, no ~/.claude or ~/.gemini
fresh; run
ok '[ -d "$HOME/.brace" ]' "C: ~/.brace created"
ok '[ ! -f "$HOME/.brace/.from-project-tracker" ]' "C: no flag for a new user"
ok '[ ! -e "$HOME/.claude" ] && [ ! -e "$HOME/.gemini" ]' "C: no ~/.claude or ~/.gemini created"
ok '[ -L "$HOME/.project-tracker" ]' "C: ~/.project-tracker link created (parent is HOME)"

# D: oldest layout — real ~/.claude/project-tracker only
fresh; mkdir -p "$HOME/.claude/project-tracker"; echo "fr" > "$HOME/.claude/project-tracker/language.txt"
run
ok '[ "$(cat "$HOME/.brace/language.txt")" = "fr" ]' "D: oldest layout moved"
ok '[ -L "$HOME/.claude/project-tracker" ]' "D: replaced by a link"

# E: both exist — merge without overwriting ~/.brace
fresh; mkdir -p "$HOME/.brace" "$HOME/.project-tracker"
echo "new" > "$HOME/.brace/scopes.txt"; echo "old" > "$HOME/.project-tracker/scopes.txt"; echo "en" > "$HOME/.project-tracker/language.txt"
run
ok '[ "$(cat "$HOME/.brace/scopes.txt")" = "new" ]' "E: existing ~/.brace file not overwritten"
ok '[ "$(cat "$HOME/.brace/language.txt")" = "en" ]' "E: missing file merged in"
ok '[ -L "$HOME/.project-tracker" ]' "E: legacy folder replaced by a link"

# F: a legacy file that cannot be copied keeps its legacy folder (no data loss)
fresh; mkdir -p "$HOME/.brace" "$HOME/.project-tracker"
echo "secret" > "$HOME/.project-tracker/locked.txt"; chmod 000 "$HOME/.project-tracker/locked.txt"
if [ -r "$HOME/.project-tracker/locked.txt" ]; then
  echo "SKIP: F (running as root, chmod 000 is not enforced)"
else
  run
  ok '[ -f "$HOME/.project-tracker/locked.txt" ] && [ ! -L "$HOME/.project-tracker" ]' "F: uncopied file keeps the legacy folder"
fi
exit $FAIL
