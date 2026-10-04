#!/usr/bin/env bash
# project-tracker Antigravity PreInvocation hook (session_start).
# Fires at the start of an Antigravity invocation.
# Filters for invocationNum == 1, checks scopes.txt, and injects context via injectSteps.
# Bash 3.2 compatible (macOS default).
set -euo pipefail

INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(1)
inv = data.get("invocationNum", 1)
print(inv)
paths = data.get("workspacePaths", [])
print(paths[0] if paths else "")
' 2>/dev/null)" || { echo "{}"; exit 0; }

INVOCATION_NUM="$(printf '%s\n' "$PARSED" | sed -n '1p')"
CWD="$(printf '%s\n' "$PARSED" | sed -n '2p')"
CWD="${CWD%/}"

# Only fire on the first invocation of the session
if [ "$INVOCATION_NUM" -gt 1 ]; then
  echo "{}"
  exit 0
fi

[ -n "$CWD" ] || { echo "{}"; exit 0; }

# Find scopes file (unified, gemini or claude symlink)
SCOPES_FILE=""
for candidate in "$HOME/.project-tracker/scopes.txt" "$HOME/.gemini/project-tracker/scopes.txt" "$HOME/.claude/project-tracker/scopes.txt"; do
  if [ -f "$candidate" ]; then
    SCOPES_FILE="$candidate"
    break
  fi
done

[ -n "$SCOPES_FILE" ] || { echo "{}"; exit 0; }

SCOPE_ROOT=""
while IFS= read -r line || [ -n "$line" ]; do
  line="${line%/}"
  case "$line" in
    ""|"#"*) continue ;;
    "~"|"~/"*) line="${HOME}${line#\~}" ;;
  esac
  case "$CWD" in
    "$line"|"$line"/*) SCOPE_ROOT="$line"; break ;;
  esac
done < "$SCOPES_FILE"

[ -n "$SCOPE_ROOT" ] || { echo "{}"; exit 0; }

# Find trackignore file
IGNORE_FILE=""
for candidate in "$HOME/.project-tracker/trackignore.txt" "$HOME/.gemini/project-tracker/trackignore.txt" "$HOME/.claude/project-tracker/trackignore.txt"; do
  if [ -f "$candidate" ]; then
    IGNORE_FILE="$candidate"
    break
  fi
done

if [ -n "$IGNORE_FILE" ]; then
  while IFS= read -r entry || [ -n "$entry" ]; do
    entry="${entry%/}"
    case "$entry" in
      ""|"#"*) continue ;;
      "~"|"~/"*) entry="${HOME}${entry#\~}" ;;
    esac
    entry_is_scope_root=0
    while IFS= read -r scope || [ -n "$scope" ]; do
      scope="${scope%/}"
      case "$scope" in
        ""|"#"*) continue ;;
        "~"|"~/"*) scope="${HOME}${scope#\~}" ;;
      esac
      if [ "$scope" = "$entry" ]; then
        entry_is_scope_root=1
        break
      fi
    done < "$SCOPES_FILE"
    if [ "$entry_is_scope_root" -eq 1 ]; then
      [ "$CWD" = "$entry" ] && { echo "{}"; exit 0; }
    else
      case "$CWD" in
        "$entry"|"$entry"/*) { echo "{}"; exit 0; } ;;
      esac
    fi
  done < "$IGNORE_FILE"
fi

ROOT="$CWD"
STATUS_FILE=""
while :; do
  if [ -f "$ROOT/docs/project-tracker/STATUS.md" ]; then
    STATUS_FILE="$ROOT/docs/project-tracker/STATUS.md"
    break
  fi
  [ "$ROOT" = "$SCOPE_ROOT" ] && break
  ROOT="$(dirname "$ROOT")"
done

PORTFOLIO_FILE=""
for candidate in "$HOME/.project-tracker/portfolio.txt" "$HOME/.gemini/project-tracker/portfolio.txt" "$HOME/.claude/project-tracker/portfolio.txt"; do
  if [ -f "$candidate" ]; then
    PORTFOLIO_FILE="$candidate"
    break
  fi
done

if [ -n "$STATUS_FILE" ]; then
  FM="$(awk '/^---$/{count++} {print} count==2{exit}' "$STATUS_FILE" 2>/dev/null || true)"
  MISSING=""
  printf '%s\n' "$FM" | grep -q '^reminders_list:' || MISSING="$MISSING reminders_list"
  printf '%s\n' "$FM" | grep -q '^backlog_model:'  || MISSING="$MISSING backlog_model"
  printf '%s\n' "$FM" | grep -q '^category:'       || MISSING="$MISSING category"
  [ -n "$PORTFOLIO_FILE" ] || MISSING="$MISSING portfolio.txt(global)"

  MSG="[project-tracker] Session opened in a tracked project ($ROOT)."
  [ -n "$MISSING" ] && MSG="$MSG\nNot yet configured -> invoke the track skill and ask about:$MISSING"
  MSG="$MSG\nAutomatic, not optional: do this now, alongside whatever the user asked for, without asking permission and without waiting for them to bring it up. Invoke the track skill and compare last_updated (frontmatter below) with the last real activity (latest git commit if uses_git=true, otherwise file modification dates). If the files are current, stay silent. If they are stale, make the update proposal in your first reply. Do not write anything without checking the current state of the files first.\n--- STATUS.md frontmatter ---\n$FM"

  python3 -c '
import json, sys
msg = sys.argv[1]
print(json.dumps({"injectSteps": [{"ephemeralMessage": msg}]}))
' "$MSG"
  exit 0
fi

MSG="[project-tracker] UNTRACKED project in this folder ($CWD) — scope $SCOPE_ROOT.\nThis is the session opening move. Before anything else, invoke the track skill and ask the user — using the ask_question tool, not prose — whether to track this project:\n  - \"Yes, set it up\" (Recommended) -> run the bootstrap questions, then create the standard files.\n  - \"No, don'\''t ask again\" -> add \"$CWD\" as a line in $IGNORE_FILE. Stop.\n  - \"Not now\" -> do nothing; this prompt returns next session in this folder.\nDo not wait for the user to bring it up — the question is asked automatically."

python3 -c '
import json, sys
msg = sys.argv[1]
print(json.dumps({"injectSteps": [{"ephemeralMessage": msg}]}))
' "$MSG"
exit 0
