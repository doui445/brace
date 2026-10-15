#!/usr/bin/env bash
# Moves the machine config to ~/.brace (the only place BRACE reads) and
# turns every older location into a symlink to it, so anything still
# using an old path keeps working. Idempotent; never overwrites a file
# already in ~/.brace. Leaves ~/.brace/.from-project-tracker when it moved
# something (read once by machine.sh for the "you're on BRACE" notice).
# Bash 3.2 compatible.
set -euo pipefail

REAL="$HOME/.brace"
OLD_PATHS="$HOME/.project-tracker $HOME/.claude/project-tracker $HOME/.gemini/project-tracker"
moved=0

for old in $OLD_PATHS; do
  if [ -d "$old" ] && [ ! -L "$old" ]; then
    if [ ! -e "$REAL" ]; then
      mv "$old" "$REAL"
    else
      cp -Rn "$old/." "$REAL/" 2>/dev/null || true
      # cp -n exits non-zero when it skips existing files, so judge by
      # content: remove the legacy copy only once every entry is in ~/.brace.
      complete=1
      while IFS= read -r -d '' rel; do
        [ -e "$REAL/$rel" ] || [ -L "$REAL/$rel" ] || complete=0
      done < <(cd "$old" && find . -mindepth 1 -print0)
      if [ "$complete" -eq 1 ]; then rm -rf "$old"; fi
    fi
    moved=1
  fi
done

mkdir -p "$REAL"

for link in $OLD_PATHS; do
  [ -d "$(dirname "$link")" ] || continue
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$REAL" ] || ln -sfn "$REAL" "$link"
  elif [ ! -e "$link" ]; then
    ln -s "$REAL" "$link"
  fi
done

[ "$moved" -eq 1 ] && touch "$REAL/.from-project-tracker"
exit 0
