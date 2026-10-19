#!/usr/bin/env bash
# BRACE brand -- post_tool_use. Called by dispatch/run.sh after a file
# write, only in projects where docs/brace/brand/ exists. When the written
# file is listed in the Touchpoints section of docs/brace/brand/STRATEGY.md
# (see touchpoints.sh), reminds the agent to check it against
# VOICE.md, once per file and session. Claude Code only in practice: the
# Antigravity adapter cannot inject after a write, so session_start.sh
# lists the touchpoints there instead. Bash 3.2 compatible.
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

. "$BRACE_PLUGIN_ROOT/skills/brand/hooks/touchpoints.sh"
LISTED="$(brand_touchpoints "$STRATEGY" "$BRACE_PLUGIN_ROOT")"
printf '%s\n' "$LISTED" | grep -qxF -- "$REL" || exit 0

MARK_DIR="${TMPDIR:-/tmp}/brace-brand-voice"
mkdir -p "$MARK_DIR" 2>/dev/null || true
MARK="$MARK_DIR/$(printf '%s__%s' "$SESSION" "$FILE" | tr '/ .' '___')"
[ -f "$MARK" ] && exit 0
touch "$MARK" 2>/dev/null || true

if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then SKILL="brand"; else SKILL="brace:brand"; fi
echo "[BRACE] $REL is a brand touchpoint. Check it against docs/brace/brand/VOICE.md (invoke the $SKILL skill, see references/voice.md): flag any drift in one line with a proposed rewrite; the user keeps theirs or takes it."
exit 0
