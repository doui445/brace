#!/usr/bin/env bash
# BRACE brand -- the final presentations and the per-session list of the
# ones already seen. Sourced by session_start.sh (seeds the list) and
# post_tool_use.sh (notifies the new ones). Bash 3.2 compatible.

# brand_final_decks <root>: one absolute path per line, final decks only
# (presentations/*.html, never draft.html; hidden files are not matched).
brand_final_decks() {
  local f
  for f in "$1"/docs/brace/brand/presentations/*.html; do
    [ -f "$f" ] || continue
    [ "$(basename "$f")" = "draft.html" ] && continue
    printf '%s\n' "$f"
  done
}

# brand_seen_file <session>: the list of decks already seen this session.
brand_seen_file() {
  printf '%s/brace-brand-notify/%s.seen' "${TMPDIR:-/tmp}" "$(printf '%s' "$1" | tr '/ .' '___')"
}

# brand_seed_seen <root> <session>: mark the decks already there as seen.
brand_seed_seen() {
  local seen
  seen="$(brand_seen_file "$2")"
  mkdir -p "$(dirname "$seen")" 2>/dev/null || return 0
  touch "$seen" 2>/dev/null || return 0
  brand_final_decks "$1" | while IFS= read -r f; do
    grep -qxF -- "$f" "$seen" 2>/dev/null || printf '%s\n' "$f" >> "$seen"
  done
}
