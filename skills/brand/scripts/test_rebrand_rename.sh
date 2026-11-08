#!/usr/bin/env bash
# Runs the folder rename command shipped in references/rebrand.md (the
# fenced bash block), in a temporary HOME. Run: bash skills/brand/scripts/test_rebrand_rename.sh
set -uo pipefail
REF="$(cd "$(dirname "$0")/.." && pwd)/references/rebrand.md"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3: missing [$2] in [$1]"; FAIL=1 ;; esac; }
hasnt() { case "$1" in *"$2"*) echo "FAIL: $3: unexpected [$2] in [$1]"; FAIL=1 ;; *) echo "PASS: $3" ;; esac; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
BLOCK="$(python3 -c 'import re,sys; print(re.search(r"```bash\n(.*?)```", open(sys.argv[1]).read(), re.S).group(1))' "$REF")"
key() { printf '%s' "$1" | sed 's/[^A-Za-z0-9]/-/g'; }
# shoot <old> <new>: run the block with the two paths filled in.
shoot() {
  local cmd
  cmd="$(printf '%s' "$BLOCK" | python3 -c 'import sys; t=sys.stdin.read(); print(t.replace("<old absolute path>", sys.argv[1]).replace("<new absolute path>", sys.argv[2]))' "$1" "$2")"
  HOME="$TMP/home" bash -c "$cmd" 2>&1
}
mkdir -p "$TMP/home/.claude/projects"

O="$TMP/My Code/old proj"; N="$TMP/My Code/new proj"; mkdir -p "$O"
mkdir -p "$TMP/home/.claude/projects/$(key "$O")"; touch "$TMP/home/.claude/projects/$(key "$O")/MEMORY.md"
OUT="$(shoot "$O" "$N")"
has "$OUT" "folder renamed" "spaces in the paths -> folder renamed"
[ -d "$N" ] && [ ! -e "$O" ] && echo "PASS: folder moved" || { echo "FAIL: folder not moved"; FAIL=1; }
[ -f "$TMP/home/.claude/projects/$(key "$N")/MEMORY.md" ] && echo "PASS: memory copied to the new key" || { echo "FAIL: memory not at the new key"; FAIL=1; }
[ -d "$TMP/home/.claude/projects/$(key "$O")" ] && echo "PASS: old memory kept as a backup" || { echo "FAIL: old memory gone"; FAIL=1; }

mkdir -p "$TMP/a" "$TMP/b"
OUT="$(shoot "$TMP/a" "$TMP/b")"
has "$OUT" "already exists" "new path exists -> nothing renamed"
[ -d "$TMP/a" ] && echo "PASS: old folder untouched" || { echo "FAIL: old folder moved"; FAIL=1; }

mkdir -p "$TMP/c"
OUT="$(shoot "$TMP/c" "$TMP/d")"
has "$OUT" "folder renamed" "no memory folder -> folder still renamed"
has "$OUT" "no memory folder" "no memory folder -> said so"

mkdir -p "$TMP/e"; mkdir -p "$TMP/home/.claude/projects/$(key "$TMP/e")"
OUT="$(shoot "$TMP/e" "$TMP/missing parent/f")"
has "$OUT" "not renamed" "mv fails -> said so"
hasnt "$OUT" "memory copied" "mv fails -> memory untouched"
[ ! -e "$TMP/home/.claude/projects/$(key "$TMP/missing parent/f")" ] && echo "PASS: no memory at the new key" || { echo "FAIL: memory moved after a failed rename"; FAIL=1; }

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
