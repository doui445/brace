#!/usr/bin/env bash
# BRACE brand -- post_tool_use. Called by dispatch/run.sh after a file
# write, only in projects where docs/brace/brand/ exists. When the written
# file is listed in the Touchpoints section of docs/brace/brand/STRATEGY.md
# (repo-relative paths in backticks; the heading is read from the i18n
# catalogues, any language), reminds the agent to check it against
# VOICE.md, once per file and session. Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0

FILE="${BRACE_FILE:-}"
SESSION="${BRACE_SESSION:-}"
ROOT="${BRACE_PROJECT_ROOT:-}"
[ -n "$FILE" ] && [ -n "$SESSION" ] && [ -n "$ROOT" ] || exit 0
STRATEGY="$ROOT/docs/brace/brand/STRATEGY.md"
[ -f "$STRATEGY" ] || exit 0

case "$FILE" in
  "$ROOT"/*) REL="${FILE#"$ROOT"/}" ;;
  *) exit 0 ;;
esac
case "$REL" in docs/brace/*|docs/project-tracker/*) exit 0 ;; esac

I18N="$BRACE_PLUGIN_ROOT/skills/track/references/i18n"
HEADINGS="$(sed -n 's/^- brand\.strategy\.heading\.touchpoints: //p' "$I18N"/*.md 2>/dev/null)"
[ -n "$HEADINGS" ] || exit 0

LISTED="$(HS="$HEADINGS" awk '
  BEGIN { n = split(ENVIRON["HS"], H, "\n") }
  { gsub(/\r/, "") }
  /^## / {
    t = substr($0, 4); sub(/[ \t]+$/, "", t); insec = 0
    for (i = 1; i <= n; i++) if (t == H[i]) insec = 1
    next
  }
  insec {
    s = $0
    while (match(s, /`[^`]+`/)) {
      p = substr(s, RSTART + 1, RLENGTH - 2); sub(/^\.\//, "", p); print p
      s = substr(s, RSTART + RLENGTH)
    }
  }
' "$STRATEGY" 2>/dev/null)"
printf '%s\n' "$LISTED" | grep -qxF -- "$REL" || exit 0

MARK_DIR="${TMPDIR:-/tmp}/brace-brand-voice"
mkdir -p "$MARK_DIR" 2>/dev/null || true
MARK="$MARK_DIR/$(printf '%s__%s' "$SESSION" "$FILE" | tr '/ .' '___')"
[ -f "$MARK" ] && exit 0
touch "$MARK" 2>/dev/null || true

if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then SKILL="brand"; else SKILL="brace:brand"; fi
echo "[BRACE] $REL is a brand touchpoint. Check it against docs/brace/brand/VOICE.md (invoke the $SKILL skill, see references/voice.md): flag any drift in one line with a proposed rewrite; the user keeps theirs or takes it."
exit 0
