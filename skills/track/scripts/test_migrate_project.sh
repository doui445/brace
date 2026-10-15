#!/usr/bin/env bash
# Tests for migrate_project.sh. Run: bash skills/track/scripts/test_migrate_project.sh
set -uo pipefail
SCRIPT="$(cd "$(dirname "$0")" && pwd)/migrate_project.sh"
FAIL=0
ok() { if eval "$1"; then echo "PASS: $2"; else echo "FAIL: $2"; FAIL=1; fi; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t

mkproj() {  # $1 dir, $2 uses_git value
  mkdir -p "$1/docs/project-tracker"
  printf -- '---\nproject: p\nstatus: active\nuses_git: %s\nlast_updated: 2026-01-01\n---\nSee docs/project-tracker/ROADMAP.md\n' "$2" > "$1/docs/project-tracker/STATUS.md"
  echo "History mentions docs/project-tracker/ on purpose." > "$1/docs/project-tracker/JOURNAL.md"
  echo "Tracking files live in docs/project-tracker/." > "$1/AGENTS.md"
  echo "See docs/project-tracker/STATUS.md" > "$1/README.md"
  ln -s AGENTS.md "$1/CLAUDE.md"
}

# A: git project, with an uncommitted change and an untracked file
P="$TMP/with space/gitproj"; mkproj "$P" true
git -C "$P" init -q && git -C "$P" add -A && git -C "$P" commit -qm init
echo "dirty" >> "$P/docs/project-tracker/JOURNAL.md"
echo "new" > "$P/docs/project-tracker/NOTES.md"
OUT="$(bash "$SCRIPT" "$P")"; RC=$?
ok '[ $RC -eq 0 ]' "A: exit 0"
ok '[ ! -e "$P/docs/project-tracker" ] && [ -f "$P/docs/brace/STATUS.md" ]' "A: folder moved"
ok 'grep -q dirty "$P/docs/brace/JOURNAL.md"' "A: uncommitted change kept"
ok '[ -f "$P/docs/brace/NOTES.md" ]' "A: untracked file moved too"
ok 'git -C "$P" status --porcelain | grep -q "^R. docs/project-tracker/STATUS.md -> docs/brace/STATUS.md"' "A: git sees a rename"
ok 'grep -q "docs/brace/" "$P/AGENTS.md" && ! grep -q "docs/project-tracker" "$P/AGENTS.md"' "A: AGENTS.md rewritten"
ok 'grep -q "docs/brace/STATUS.md" "$P/README.md"' "A: README.md rewritten"
ok 'grep -q "docs/brace/ROADMAP.md" "$P/docs/brace/STATUS.md"' "A: STATUS.md rewritten"
ok 'grep -q "docs/project-tracker/" "$P/docs/brace/JOURNAL.md"' "A: history file untouched"
ok '[ -L "$P/CLAUDE.md" ]' "A: CLAUDE.md symlink left as a symlink"
ok '[ -z "$(git -C "$P" log --oneline | sed -n 2p)" ]' "A: nothing committed"
case "$OUT" in *"docs/brace"*) echo "PASS: A: summary line" ;; *) echo "FAIL: A: summary [$OUT]"; FAIL=1 ;; esac

# B: project without git
P="$TMP/nogit"; mkproj "$P" false
bash "$SCRIPT" "$P" >/dev/null; RC=$?
ok '[ $RC -eq 0 ] && [ -f "$P/docs/brace/STATUS.md" ]' "B: plain mv without git"

# C: real CLAUDE.md (not a link) is rewritten
P="$TMP/realclaude"; mkproj "$P" false; rm "$P/CLAUDE.md"; echo "docs/project-tracker/" > "$P/CLAUDE.md"
bash "$SCRIPT" "$P" >/dev/null
ok 'grep -q "docs/brace/" "$P/CLAUDE.md"' "C: real CLAUDE.md rewritten"

# D: both folders -> exit 3, nothing touched
P="$TMP/both"; mkproj "$P" false; mkdir -p "$P/docs/brace"; echo x > "$P/docs/brace/STATUS.md"
OUT="$(bash "$SCRIPT" "$P")"; RC=$?
ok '[ $RC -eq 3 ] && [ "$OUT" = "both" ]' "D: exit 3 + 'both'"
ok '[ -f "$P/docs/project-tracker/STATUS.md" ] && grep -q project-tracker "$P/AGENTS.md"' "D: nothing touched"

# E: nothing to migrate -> exit 1
mkdir -p "$TMP/empty"; bash "$SCRIPT" "$TMP/empty" >/dev/null; RC=$?
ok '[ $RC -eq 1 ]' "E: exit 1 when there is no docs/project-tracker"
exit $FAIL
