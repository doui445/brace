#!/usr/bin/env bash
# BRACE brand -- session_start. Called by dispatch/run.sh only in projects
# where docs/brace/brand/ exists. First marks the deliverables already
# there as seen this session (decks.sh), so the notification fires only
# for new ones. A mission in progress (brand_stage set, not done) prints
# one line asking to resume the agency, with the next meeting when the
# client came back before it (the last "- meeting:" line of SESSIONS.md).
# Otherwise prints one line when the brand strategy
# was last reviewed more than 6 months ago (brand_reviewed in STATUS.md),
# unless the user postponed the review in the last 30 days. Silent
# otherwise, and on any error. Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0
. "$BRACE_PLUGIN_ROOT/dispatch/lib.sh"

ROOT="${BRACE_PROJECT_ROOT:-}"
[ -n "$ROOT" ] && [ -d "$ROOT/docs/brace/brand" ] || exit 0
if [ -n "${BRACE_SESSION:-}" ]; then
  . "$BRACE_PLUGIN_ROOT/skills/brand/hooks/decks.sh"
  brand_seed_seen "$ROOT" "$BRACE_SESSION"
fi
case "${BRACE_SOURCE:-}" in compact|resume) exit 0 ;; esac
if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then SKILL="brand"; else SKILL="brace:brand"; fi
STATUS="$ROOT/docs/brace/STATUS.md"

# brand_front <key>: a value of STATUS.md's frontmatter, unquoted.
brand_front() {
  awk -v key="$1" '
    { gsub(/\r/, "") }
    /^---$/ { c++; next }
    c == 1 && index($0, key ":") == 1 {
      sub(/^[^:]*:[ \t]*/, ""); sub(/[ \t]*#.*$/, ""); gsub(/["'\'' \t]/, ""); print; exit
    }
    c >= 2 { exit }
  ' "$STATUS" 2>/dev/null || true
}

# A mission in progress: the agency takes the client back (startup, /clear).
STAGE="$(brand_front brand_stage)"
case "$STAGE" in
  ""|done) ;;
  *[!a-z_-]*) exit 0 ;;
  *)
    LINE="[BRACE] A brand mission is in progress (stage $STAGE). In your first reply, resume the agency (invoke the $SKILL skill): greet the client, say where we are and what the team did."
    MEETING="$(sed -n 's/^- meeting: \([0-9]\{4\}-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]\)[[:blank:]]*$/\1/p' "$ROOT/docs/brace/brand/SESSIONS.md" 2>/dev/null | tail -1)"
    if [ -n "$MEETING" ] && python3 -c 'import sys,datetime; sys.exit(0 if datetime.datetime.strptime(sys.argv[1], "%Y-%m-%d %H:%M") > datetime.datetime.now() else 1)' "$MEETING" 2>/dev/null; then
      LINE="$LINE The next meeting is $MEETING; the client came back early: ask whether to move on now, ask a question, or change something from the last meeting."
    fi
    echo "$LINE"
    exit 0 ;;
esac

# Antigravity cannot receive the post-write voice reminder: list the
# touchpoints once here so the agent checks them itself when it writes one.
if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then
  . "$BRACE_PLUGIN_ROOT/skills/brand/hooks/touchpoints.sh"
  TP="$(brand_touchpoints "$ROOT/docs/brace/brand/STRATEGY.md" "$BRACE_PLUGIN_ROOT" | awk 'NF { printf "%s%s", (n++ ? ", " : ""), $0 }')"
  [ -n "$TP" ] && echo "[BRACE] Brand touchpoints in this project: $TP. When you write one of them, check it against docs/brace/brand/VOICE.md (the $SKILL skill, references/voice.md): flag any drift in one line with a proposed rewrite."
fi

REVIEWED="$(awk '
  { gsub(/\r/, "") }
  /^---$/ { c++; next }
  c == 1 && /^brand_reviewed:/ {
    sub(/^brand_reviewed:[ \t]*/, ""); sub(/[ \t]*#.*$/, ""); gsub(/["'\'' \t]/, ""); print; exit
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
