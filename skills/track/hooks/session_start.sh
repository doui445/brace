#!/usr/bin/env bash
# BRACE track -- session_start. Called by dispatch/run.sh (tool-neutral:
# the adapters parse each tool's JSON). Decides whether the session opened
# in a tracked project, moves a project still on docs/project-tracker/ to
# docs/brace/ (unless BRACE_SWAPPED=1: a plugin swap is pending or an old
# plugin may still be loaded -- the move then waits, silently), and prints
# plain text for the agent. All business logic lives in SKILL.md.
# Bash 3.2 compatible.
set -uo pipefail
[ -f "${BRACE_PLUGIN_ROOT:-}/dispatch/lib.sh" ] || exit 0
. "$BRACE_PLUGIN_ROOT/dispatch/lib.sh"

CWD="${BRACE_CWD:-}"
[ "$CWD" = "/" ] || CWD="${CWD%/}"
[ -n "$CWD" ] || exit 0
SCOPE_ROOT="$(brace_scope_root "$CWD")"
[ -n "$SCOPE_ROOT" ] || exit 0
brace_is_ignored "$CWD" && exit 0

CFG="$(brace_config_dir)"
if [ "${BRACE_TOOL:-claude}" = "antigravity" ]; then
  SKILL="track"; ASK="the ask_question tool"
else
  SKILL="brace:track"; ASK="AskUserQuestion"
fi

ROOT="$(brace_find_project "$CWD" "$SCOPE_ROOT")"

if [ -z "$ROOT" ]; then
  echo "[BRACE] UNTRACKED project in this folder ($CWD) — scope $SCOPE_ROOT."
  echo "This is the session's opening move. Before anything else, invoke the $SKILL skill and ask the user — as a selectable multiple-choice question ($ASK), not prose — whether to track this project:"
  echo "  - \"Yes, set it up\"      -> run the bootstrap questions, then create the standard files."
  echo "  - \"No, don't ask again\" -> add \"$CWD\" as a line in $CFG/trackignore.txt (create the file if needed). Stop."
  echo "  - \"Not now\"             -> do nothing; this prompt returns next session in this folder."
  echo "Do not wait for the user to bring it up — the question is asked automatically."
  exit 0
fi

NOTE=""
if [ -d "$ROOT/docs/project-tracker" ]; then
  if [ -d "$ROOT/docs/brace" ]; then
    NOTE="[BRACE] Both docs/brace/ and docs/project-tracker/ exist in $ROOT. Do not merge them automatically: show the user what each contains and ask how to reconcile them (same rule as a collision between sessions)."
  elif [ "${BRACE_SWAPPED:-0}" = "1" ]; then
    NOTE="[BRACE] This project still uses docs/project-tracker/; it will be moved to docs/brace/ at the next session, once the old plugin is gone. Keep reading and writing docs/project-tracker/ meanwhile; nothing to tell the user about it."
  else
    M_OUT="$(bash "$BRACE_PLUGIN_ROOT/skills/track/scripts/migrate_project.sh" "$ROOT" 2>/dev/null)"
    if [ $? -eq 0 ]; then
      NOTE="[BRACE] Tracking files moved for this project: $M_OUT. Tell the user in one line, then offer a commit (e.g. \"chore: move tracking files to docs/brace (BRACE 1.0)\") under the usual rule — never commit without confirmation."
    fi
  fi
fi

STATUS_FILE="$ROOT/$(brace_tracking_dir "$ROOT")/STATUS.md"
FM="$(awk '/^---$/{count++} {print} count==2{exit}' "$STATUS_FILE" 2>/dev/null || true)"
MISSING=""
printf '%s\n' "$FM" | grep -q '^reminders_list:' || MISSING="$MISSING reminders_list"
printf '%s\n' "$FM" | grep -q '^backlog_model:'  || MISSING="$MISSING backlog_model"
printf '%s\n' "$FM" | grep -q '^category:'       || MISSING="$MISSING category"
[ -f "$CFG/portfolio.txt" ] || MISSING="$MISSING portfolio.txt(global)"

[ -n "$NOTE" ] && echo "$NOTE"
echo "[BRACE] Session opened in a tracked project ($ROOT)."
[ -n "$MISSING" ] && echo "Not yet configured -> invoke the $SKILL skill and ask about:$MISSING"
echo "Automatic, not optional: do this now, alongside whatever the user asked for, without asking permission and without waiting for them to bring it up. Invoke the $SKILL skill and compare last_updated (frontmatter below) with the last real activity (latest git commit if uses_git=true, otherwise file modification dates). If the files are current, stay silent. If they are stale, make the update proposal in your first reply. Do not write anything without checking the current state of the files first."
echo "--- STATUS.md frontmatter ---"
printf '%s\n' "$FM" | head -c 4000
echo
exit 0
