#!/usr/bin/env bash
# BRACE brand -- session_start. Called by dispatch/run.sh only in projects
# where docs/brace/brand/ exists. Prints one line when the brand strategy
# was last reviewed more than 6 months ago (brand_reviewed in STATUS.md),
# unless the user postponed the review in the last 30 days. Silent
# otherwise, and on any error. Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0
. "$BRACE_PLUGIN_ROOT/dispatch/lib.sh"

ROOT="${BRACE_PROJECT_ROOT:-}"
[ -n "$ROOT" ] && [ -d "$ROOT/docs/brace/brand" ] || exit 0
case "${BRACE_SOURCE:-}" in compact|resume) exit 0 ;; esac
if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then SKILL="brand"; else SKILL="brace:brand"; fi

# Antigravity cannot receive the post-write voice reminder: list the
# touchpoints once here so the agent checks them itself when it writes one.
if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then
  . "$BRACE_PLUGIN_ROOT/skills/brand/hooks/touchpoints.sh"
  TP="$(brand_touchpoints "$ROOT/docs/brace/brand/STRATEGY.md" "$BRACE_PLUGIN_ROOT" | awk 'NF { printf "%s%s", (n++ ? ", " : ""), $0 }')"
  [ -n "$TP" ] && echo "[BRACE] Brand touchpoints in this project: $TP. When you write one of them, check it against docs/brace/brand/VOICE.md (the $SKILL skill, references/voice.md): flag any drift in one line with a proposed rewrite."
fi

STATUS="$ROOT/docs/brace/STATUS.md"
REVIEWED="$(awk '
  { gsub(/\r/, "") }
  /^---$/ { c++; next }
  c == 1 && /^brand_reviewed:/ {
    sub(/^brand_reviewed:[ \t]*/, ""); gsub(/["'\'' \t]/, ""); print; exit
  }
  c >= 2 { exit }
' "$STATUS" 2>/dev/null || true)"
[ -n "$REVIEWED" ] || exit 0

AGE="$(python3 -c 'import sys,datetime; print((datetime.date.today()-datetime.date.fromisoformat(sys.argv[1])).days)' "$REVIEWED" 2>/dev/null || true)"
case "$AGE" in ""|*[!0-9]*) exit 0 ;; esac   # empty, unreadable or negative (future date)
[ "$AGE" -gt 183 ] || exit 0

SAFE_ROOT="$(printf '%s' "$ROOT" | tr '/ ' '__')"
SNOOZE="$(brace_config_dir)/brand/snooze/$SAFE_ROOT"
if [ -f "$SNOOZE" ]; then
  NOW="$(date +%s)"
  THEN="$(date -r "$SNOOZE" +%s 2>/dev/null || echo 0)"
  [ $((NOW - THEN)) -lt 2592000 ] && exit 0
fi

echo "[BRACE] The brand strategy of $(basename "$ROOT") was last reviewed on $REVIEWED. In your first reply, offer a review in one line (invoke the $SKILL skill, see references/revision.md). If the user says later, run: mkdir -p \"$(dirname "$SNOOZE")\" && touch \"$SNOOZE\" (silences this for 30 days)."
exit 0
