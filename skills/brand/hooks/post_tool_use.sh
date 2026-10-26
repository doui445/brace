#!/usr/bin/env bash
# BRACE brand -- post_tool_use. Called by dispatch/run.sh after a file
# write, only in projects where docs/brace/brand/ exists. When the written
# file is listed in the Touchpoints section of docs/brace/brand/STRATEGY.md
# (see touchpoints.sh), reminds the agent to check it against
# VOICE.md, once per file and session. When the written file is a final
# brand presentation (docs/brace/brand/presentations/*.html, never
# draft.html), sends a macOS notification instead, once per file and
# session, and prints nothing. Claude Code only in practice: the
# Antigravity adapter cannot inject after a write, so session_start.sh
# lists the touchpoints there instead. Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0

FILE="${BRACE_FILE:-}"
SESSION="${BRACE_SESSION:-}"
ROOT="${BRACE_PROJECT_ROOT:-}"
[ -n "$FILE" ] && [ -n "$SESSION" ] && [ -n "$ROOT" ] || exit 0
case "$FILE" in
  "$ROOT"/*) REL="${FILE#"$ROOT"/}" ;;
  *) exit 0 ;;
esac

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

case "$REL" in
  docs/brace/brand/presentations/draft.html) exit 0 ;;
  docs/brace/brand/presentations/*.html)
    [ "${BRACE_UNAME:-$(uname -s 2>/dev/null)}" = "Darwin" ] || exit 0
    brand_mark brace-brand-notify || exit 0
    LANG_CODE="$(sed -n '1,/^---$/{s/^language:[ \t]*"\{0,1\}\([a-z][a-z]\)"\{0,1\}[ \t]*$/\1/p;}' "$ROOT/docs/brace/STATUS.md" 2>/dev/null | head -1)"
    [ -n "$LANG_CODE" ] || LANG_CODE="$(grep -v '^[[:space:]]*#' "$HOME/.brace/language.txt" 2>/dev/null | tr -d ' \t\r' | grep -m1 . || true)"
    CAT="$BRACE_PLUGIN_ROOT/skills/track/references/i18n/${LANG_CODE:-en}.md"
    [ -f "$CAT" ] || CAT="$BRACE_PLUGIN_ROOT/skills/track/references/i18n/en.md"
    TITLE="$(sed -n 's/^- brand\.notify\.title: //p' "$CAT" | head -1)"
    MSG="$(sed -n 's/^- brand\.notify\.ready: //p' "$CAT" | head -1)"
    [ -n "$TITLE" ] && [ -n "$MSG" ] || exit 0
    if [ -n "${BRACE_NOTIFY_CMD:-}" ]; then
      "$BRACE_NOTIFY_CMD" "$TITLE" "$MSG" >/dev/null 2>&1 || true
    else
      MSG="${MSG//\"/}"; TITLE="${TITLE//\"/}"
      osascript -e "display notification \"$MSG\" with title \"$TITLE\"" >/dev/null 2>&1 &
    fi
    exit 0 ;;
esac

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
