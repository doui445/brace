#!/usr/bin/env bash
# BRACE brand -- post_tool_use. Called by dispatch/run.sh after a file
# write or a shell command, only in projects where docs/brace/brand/
# exists. Each time, sends a macOS notification when a final brand
# presentation (docs/brace/brand/presentations/*.html, never draft.html)
# appeared that this session has not seen yet, whatever wrote it (an
# editor write or a cp); prints nothing for it. Then, when the written file
# is listed in the Touchpoints section of docs/brace/brand/STRATEGY.md
# (see touchpoints.sh), reminds the agent to check it against VOICE.md,
# once per file and session. Claude Code only in practice: the Antigravity
# adapter cannot inject after a write, so session_start.sh lists the
# touchpoints there instead. Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0

FILE="${BRACE_FILE:-}"
SESSION="${BRACE_SESSION:-}"
ROOT="${BRACE_PROJECT_ROOT:-}"
[ -n "$SESSION" ] && [ -n "$ROOT" ] || exit 0
. "$BRACE_PLUGIN_ROOT/skills/brand/hooks/decks.sh"

# brand_mark <dir>: exit 1 if this file was already handled this session.
# Session id kept flat, file path hashed: no collision between similar
# names, and no name too long for a deep path.
brand_mark() {
  local dir="${TMPDIR:-/tmp}/$1" mark
  mkdir -p "$dir" 2>/dev/null || true
  mark="$dir/$(printf '%s' "$SESSION" | tr '/ .' '___')__$(printf '%s' "$FILE" | cksum | awk '{print $1 "-" $2}')"
  [ -f "$mark" ] && return 1
  touch "$mark" 2>/dev/null || true
  return 0
}

# brand_lang <file> <pattern>: a two-letter code read with the sed pattern, or nothing.
brand_lang() {
  local code
  code="$(sed -n "$2" "$1" 2>/dev/null | head -1)"
  case "$code" in [a-z][a-z]) printf '%s' "$code" ;; esac
}

# New final decks -> one notification (macOS only).
if [ "${BRACE_UNAME:-$(uname -s 2>/dev/null)}" = "Darwin" ]; then
  SEEN="$(brand_seen_file "$SESSION")"
  mkdir -p "$(dirname "$SEEN")" 2>/dev/null || true
  NEW=""
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    grep -qxF -- "$f" "$SEEN" 2>/dev/null && continue
    printf '%s\n' "$f" >> "$SEEN" 2>/dev/null || continue
    NEW="$f"
  done <<DECKS
$(brand_final_decks "$ROOT")
DECKS
  if [ -n "$NEW" ]; then
    LANG_CODE="$(brand_lang "$NEW" 's/.*<html[^>]*[[:blank:]]lang="\([a-z][a-z]\)[^"]*".*/\1/p')"
    [ -n "$LANG_CODE" ] || LANG_CODE="$(brand_lang "$ROOT/docs/brace/STATUS.md" '1,/^---$/{s/^language:[[:blank:]]*"\{0,1\}\([a-z][a-z]\)"\{0,1\}[[:blank:]]*$/\1/p;}')"
    if [ -z "$LANG_CODE" ]; then
      LANG_CODE="$(grep -v '^[[:space:]]*#' "$HOME/.brace/language.txt" 2>/dev/null | tr -d ' \t\r' | grep -m1 . || true)"
      case "$LANG_CODE" in [a-z][a-z]) ;; *) LANG_CODE="" ;; esac
    fi
    CAT="$BRACE_PLUGIN_ROOT/skills/track/references/i18n/${LANG_CODE:-en}.md"
    [ -f "$CAT" ] || CAT="$BRACE_PLUGIN_ROOT/skills/track/references/i18n/en.md"
    TITLE="$(sed -n 's/^- brand\.notify\.title: //p' "$CAT" | head -1)"
    MSG="$(sed -n 's/^- brand\.notify\.ready: //p' "$CAT" | head -1)"
    if [ -n "$TITLE" ] && [ -n "$MSG" ]; then
      if [ -n "${BRACE_NOTIFY_CMD:-}" ]; then
        "$BRACE_NOTIFY_CMD" "$TITLE" "$MSG" >/dev/null 2>&1 || true
      else
        MSG="$(printf '%s' "$MSG" | tr -d '"\\')"; TITLE="$(printf '%s' "$TITLE" | tr -d '"\\')"
        osascript -e "display notification \"$MSG\" with title \"$TITLE\"" >/dev/null 2>&1 &
      fi
    fi
  fi
fi

[ -n "$FILE" ] || exit 0
case "$FILE" in
  "$ROOT"/*) REL="${FILE#"$ROOT"/}" ;;
  *) exit 0 ;;
esac
case "$REL" in docs/brace/brand/presentations/*) exit 0 ;; esac

STRATEGY="$ROOT/docs/brace/brand/STRATEGY.md"
[ -f "$STRATEGY" ] || exit 0
case "$REL" in docs/brace/*|docs/project-tracker/*) exit 0 ;; esac

. "$BRACE_PLUGIN_ROOT/skills/brand/hooks/touchpoints.sh"
LISTED="$(brand_touchpoints "$STRATEGY" "$BRACE_PLUGIN_ROOT")"
printf '%s\n' "$LISTED" | grep -qxF -- "$REL" || exit 0

brand_mark brace-brand-voice || exit 0

if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then SKILL="brand"; else SKILL="brace:brand"; fi
echo "[BRACE] $REL is a brand touchpoint. Check it against docs/brace/brand/VOICE.md (invoke the $SKILL skill, see references/voice.md): flag any drift in one line with a proposed rewrite; the user keeps theirs or takes it."
exit 0
