#!/usr/bin/env bash
# Moves the machine config to ~/.brace (the only place BRACE reads) and
# turns every older location into a symlink to it, so anything still
# using an old path keeps working. Idempotent; never overwrites a file
# already in ~/.brace. A legacy file whose name clashes with a different
# file in ~/.brace is kept under ~/.brace/.legacy-conflicts/<tag>/.
# A legacy folder that cannot be fully read or removed is left in place
# (never fatal). Leaves ~/.brace/.from-project-tracker only when a legacy
# folder was actually moved or removed (read once by machine.sh for the
# "you're on BRACE" notice). Bash 3.2 compatible.
set -euo pipefail

REAL="$HOME/.brace"
moved=0

# migrate_one OLD TAG: move or merge the real folder OLD into $REAL.
migrate_one() {
  local old="$1" tag="$2" rel complete=1 dest
  if [ ! -d "$old" ] || [ -L "$old" ]; then
    return 0
  fi
  if [ ! -e "$REAL" ]; then
    if mv "$old" "$REAL" 2>/dev/null; then moved=1; fi
    return 0
  fi
  # cp -n exits non-zero when it skips existing files, so the copy's status
  # is ignored and the outcome is judged entry by entry below.
  cp -Rn "$old/." "$REAL/" 2>/dev/null || true
  # Any find failure (unlistable subfolder, failing cd) means incomplete.
  if ! (cd "$old" && find . -mindepth 1 >/dev/null) 2>/dev/null; then
    complete=0
  fi
  while IFS= read -r -d '' rel; do
    rel="${rel#./}"
    if [ -e "$REAL/$rel" ] || [ -L "$REAL/$rel" ]; then
      if [ -f "$old/$rel" ] && ! cmp -s "$old/$rel" "$REAL/$rel"; then
        dest="$REAL/.legacy-conflicts/$tag/$rel"
        if ! { mkdir -p "$(dirname "$dest")" && cp -p "$old/$rel" "$dest"; } 2>/dev/null; then
          complete=0
        fi
      fi
    else
      complete=0
    fi
  done < <(cd "$old" && find . -mindepth 1 -print0 2>/dev/null)
  if [ "$complete" -eq 1 ] && rm -rf "$old" 2>/dev/null; then
    moved=1
  fi
}

# link_one LINK: point an old path at $REAL when its parent exists and the
# path is free or already a link. Never fatal.
link_one() {
  local link="$1"
  [ -d "$(dirname "$link")" ] || return 0
  if [ -L "$link" ]; then
    [ "$(readlink "$link")" = "$REAL" ] || ln -sfn "$REAL" "$link" 2>/dev/null || true
  elif [ ! -e "$link" ]; then
    ln -s "$REAL" "$link" 2>/dev/null || true
  fi
}

migrate_one "$HOME/.project-tracker" "project-tracker"
migrate_one "$HOME/.claude/project-tracker" "claude-project-tracker"
migrate_one "$HOME/.gemini/project-tracker" "gemini-project-tracker"

mkdir -p "$REAL"

link_one "$HOME/.project-tracker"
link_one "$HOME/.claude/project-tracker"
link_one "$HOME/.gemini/project-tracker"

if [ "$moved" -eq 1 ]; then touch "$REAL/.from-project-tracker"; fi
exit 0
