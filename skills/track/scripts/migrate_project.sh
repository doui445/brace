#!/usr/bin/env bash
# Moves a project's tracking files from docs/project-tracker/ to
# docs/brace/ (git mv when the project uses git, plain mv otherwise) and
# rewrites the path in the living files only: AGENTS.md, README.md, a
# real (non-symlink) CLAUDE.md and docs/brace/STATUS.md. History files
# keep the old path -- it was true at their date. Never commits.
# Exit: 0 moved (prints one summary line), 1 nothing to do,
# 3 both folders exist (prints "both", touches nothing).
# Bash 3.2 compatible.
set -euo pipefail

ROOT="${1%/}"
OLD="$ROOT/docs/project-tracker"
NEW="$ROOT/docs/brace"

[ -d "$OLD" ] || exit 1
if [ -e "$NEW" ]; then
  echo "both"
  exit 3
fi

USES_GIT="$(awk '/^---$/{c++; next} c==1 && /^uses_git:/{sub(/^uses_git:[ ]*/, ""); print; exit} c>=2{exit}' "$OLD/STATUS.md" 2>/dev/null || true)"

if [ "$USES_GIT" = "true" ] \
   && git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
   && [ -n "$(git -C "$ROOT" ls-files -- docs/project-tracker | head -1)" ]; then
  if ! git -C "$ROOT" mv docs/project-tracker docs/brace 2>/dev/null; then
    # git refused (index state): nothing moved yet, so a plain mv is safe.
    [ -d "$OLD" ] && [ ! -e "$NEW" ] && mv "$OLD" "$NEW"
  fi
  # Anything git left behind (untracked files) follows the folder.
  # mv -n never overwrites: a clashing leftover stays in the old folder,
  # which then keeps the project in the "both" state instead of losing it.
  if [ -d "$OLD" ]; then
    for item in "$OLD"/* "$OLD"/.[!.]*; do
      [ -e "$item" ] || continue
      if [ -e "$NEW/$(basename "$item")" ]; then
        echo "warning: kept $(basename "$item") in docs/project-tracker/ (name clash)" >&2
        continue
      fi
      mv "$item" "$NEW/" || echo "warning: could not move $(basename "$item")" >&2
    done
    rmdir "$OLD" 2>/dev/null || true
  fi
else
  mv "$OLD" "$NEW"
fi

CHANGED=""
for f in "$ROOT/AGENTS.md" "$ROOT/CLAUDE.md" "$ROOT/README.md" "$NEW/STATUS.md"; do
  [ -f "$f" ] || continue
  [ -L "$f" ] && continue
  grep -q 'docs/project-tracker' "$f" || continue
  if python3 -c '
import sys, pathlib
p = pathlib.Path(sys.argv[1])
p.write_text(p.read_text(encoding="utf-8").replace("docs/project-tracker", "docs/brace"), encoding="utf-8")
' "$f" 2>/dev/null; then
    CHANGED="$CHANGED ${f#$ROOT/}"
  else
    echo "warning: could not rewrite ${f#$ROOT/}" >&2
  fi
done

echo "moved docs/project-tracker/ -> docs/brace/; living files updated:${CHANGED:- none}"
exit 0
