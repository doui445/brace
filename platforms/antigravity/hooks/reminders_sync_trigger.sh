#!/usr/bin/env bash
# project-tracker Antigravity PostToolUse hook — reminders_sync_trigger.sh
#
# Fires on write_to_file | replace_file_content touching STATUS.md or ROADMAP.md
# of a tracked project linked to a Reminders list.
# Bash 3.2 compatible (macOS default).
set -euo pipefail

INPUT="$(cat)"

PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(1)
tool_call = data.get("toolCall", {}) or {}
tool_name = tool_call.get("name", "")
args = tool_call.get("args", {}) or {}
target_file = args.get("TargetFile") or args.get("file_path") or ""
conv_id = data.get("conversationId", "")
print(tool_name)
print(target_file)
print(conv_id)
' 2>/dev/null)" || { echo "{}"; exit 0; }

TOOL_NAME="$(printf '%s\n' "$PARSED" | sed -n '1p')"
FILE_PATH="$(printf '%s\n' "$PARSED" | sed -n '2p')"
CONV_ID="$(printf '%s\n' "$PARSED" | sed -n '3p')"

case "$TOOL_NAME" in
  write_to_file|replace_file_content) ;;
  *) echo "{}"; exit 0 ;;
esac

[ -n "$FILE_PATH" ] || { echo "{}"; exit 0; }
[ -n "$CONV_ID" ] || { echo "{}"; exit 0; }

case "$FILE_PATH" in
  */docs/project-tracker/STATUS.md|*/docs/project-tracker/ROADMAP.md) ;;
  *) echo "{}"; exit 0 ;;
esac

PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$FILE_PATH")")")"

# Find scopes file
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
  case "$PROJECT_ROOT" in
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
      [ "$PROJECT_ROOT" = "$entry" ] && { echo "{}"; exit 0; }
    else
      case "$PROJECT_ROOT" in
        "$entry"|"$entry"/*) { echo "{}"; exit 0; } ;;
      esac
    fi
  done < "$IGNORE_FILE"
fi

STATUS_FILE="$PROJECT_ROOT/docs/project-tracker/STATUS.md"
[ -f "$STATUS_FILE" ] || { echo "{}"; exit 0; }

REMINDERS_LINE="$(awk '/^---$/{count++} count==1 && /^reminders_list:/{print} count==2{exit}' "$STATUS_FILE" 2>/dev/null || true)"
[ -n "$REMINDERS_LINE" ] || { echo "{}"; exit 0; }

REMINDERS_VAL="$(printf '%s' "$REMINDERS_LINE" | sed 's/^reminders_list:[[:space:]]*//; s/^["'\'']//; s/["'\'']$//' | tr -d '\r\n')"

case "$REMINDERS_VAL" in
  ""|"non") echo "{}"; exit 0 ;;
esac

PROJECT_NAME="$(basename "$PROJECT_ROOT")"
MARKER_DIR="${TMPDIR:-/tmp}/project-tracker-reminders-sync"
mkdir -p "$MARKER_DIR" 2>/dev/null || { echo "{}"; exit 0; }
MARKER="$MARKER_DIR/${CONV_ID}_${PROJECT_NAME}"

if [ -f "$MARKER" ]; then
  echo "{}"
  exit 0
fi

touch "$MARKER" 2>/dev/null || true

# PostToolUse only accepts {} — context injection is not supported here.
# The skill itself handles Reminders sync when it reads the frontmatter.
echo "{}"
exit 0
