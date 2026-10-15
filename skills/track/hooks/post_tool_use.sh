#!/usr/bin/env bash
# BRACE track -- post_tool_use. Called by dispatch/run.sh after a file
# write (tool-neutral). On a tracked project's STATUS.md: regenerates the
# portfolio (or, if its location is not configured, asks the agent to
# raise it -- once per session). On STATUS.md or ROADMAP.md of a project
# linked to a Reminders list: nudges the agent to check the sync, once per
# session and project. Prints plain text; the adapter formats it.
# Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0
. "$BRACE_PLUGIN_ROOT/dispatch/lib.sh"

FILE="${BRACE_FILE:-}"
SESSION="${BRACE_SESSION:-}"
[ -n "$FILE" ] && [ -n "$SESSION" ] || exit 0

case "$FILE" in
  */docs/brace/STATUS.md|*/docs/project-tracker/STATUS.md) KIND=status ;;
  */docs/brace/ROADMAP.md|*/docs/project-tracker/ROADMAP.md) KIND=roadmap ;;
  *) exit 0 ;;
esac

ROOT="$(dirname "$(dirname "$(dirname "$FILE")")")"
[ -n "$(brace_scope_root "$ROOT")" ] || exit 0
brace_is_ignored "$ROOT" && exit 0

CFG="$(brace_config_dir)"
SKILL_DIR="$BRACE_PLUGIN_ROOT/skills/track"
if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then SKILL="track"; else SKILL="brace:track"; fi
TMPROOT="${TMPDIR:-/tmp}"
OUT=""
say() { if [ -n "$OUT" ]; then OUT="$OUT
$1"; else OUT="$1"; fi; }

if [ "$KIND" = "status" ]; then
  MARKER_DIR="$TMPROOT/brace-portfolio-regen"
  mkdir -p "$MARKER_DIR" 2>/dev/null || true
  if [ ! -f "$CFG/portfolio.txt" ]; then
    if [ ! -f "$MARKER_DIR/$SESSION" ]; then
      touch "$MARKER_DIR/$SESSION" 2>/dev/null || true
      say "BRACE: portfolio output location not configured - invoke the $SKILL skill and propose an output folder to the user (see SKILL.md ## Portfolio)."
    fi
  else
    THROTTLE="$MARKER_DIR/last"
    RUN=1
    if [ -f "$THROTTLE" ]; then
      NOW="$(date +%s)"
      LAST="$(date -r "$THROTTLE" +%s 2>/dev/null || echo 0)"
      [ "$((NOW - LAST))" -lt 10 ] && RUN=0
    fi
    if [ "$RUN" -eq 1 ]; then
      touch "$THROTTLE" 2>/dev/null || true
      python3 "$SKILL_DIR/scripts/generate_portfolio.py" --changed "$ROOT" >/dev/null 2>&1 || true
    fi
  fi
fi

STATUS_FILE="$(dirname "$FILE")/STATUS.md"
LIST_LINE="$(awk '/^---$/{c++; next} c==1 && /^reminders_list:/{print; exit} c>=2{exit}' "$STATUS_FILE" 2>/dev/null || true)"
case "$LIST_LINE" in
  ""|*'"non"'*) ;;
  *)
    R_DIR="$TMPROOT/brace-reminders-sync"
    mkdir -p "$R_DIR" 2>/dev/null || true
    SAFE_ROOT="$(printf '%s' "$ROOT" | tr '/ ' '__')"
    R_MARK="$R_DIR/${SESSION}__${SAFE_ROOT}"
    if [ ! -f "$R_MARK" ]; then
      touch "$R_MARK" 2>/dev/null || true
      say "STATUS.md/ROADMAP.md for $(basename "$ROOT") was just modified - invoke the $SKILL skill (if not already done this session) then check the Reminders sync (full diff, see $SKILL_DIR/references/reminders-sync.md) before ending this turn."
    fi
    ;;
esac

[ -n "$OUT" ] && printf '%s\n' "$OUT"
exit 0
