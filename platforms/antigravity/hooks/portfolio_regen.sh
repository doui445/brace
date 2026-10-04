#!/usr/bin/env bash
# project-tracker Antigravity PostToolUse hook — portfolio_regen.sh
#
# Fires on write_to_file | replace_file_content touching a tracked project's STATUS.md:
# regenerates the unified PORTFOLIO.html by shelling out to generate_portfolio.py.
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
  */docs/project-tracker/STATUS.md) ;;
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

# Find portfolio file
PORTFOLIO_FILE=""
for candidate in "$HOME/.project-tracker/portfolio.txt" "$HOME/.gemini/project-tracker/portfolio.txt" "$HOME/.claude/project-tracker/portfolio.txt"; do
  if [ -f "$candidate" ]; then
    PORTFOLIO_FILE="$candidate"
    break
  fi
done

MARKER_DIR="${TMPDIR:-/tmp}/project-tracker-portfolio-regen"

if [ -z "$PORTFOLIO_FILE" ]; then
  mkdir -p "$MARKER_DIR" 2>/dev/null || { echo "{}"; exit 0; }
  MARKER="$MARKER_DIR/${CONV_ID}"
  [ -f "$MARKER" ] && { echo "{}"; exit 0; }
  touch "$MARKER" 2>/dev/null || true
  python3 -c '
import json
print(json.dumps({"injectSteps": [{"ephemeralMessage": "project-tracker: portfolio output location not configured - invoke the track skill and propose an output folder to the user."}]}))
'
  exit 0
fi

# Throttle: at most one regeneration every 10 seconds.
mkdir -p "$MARKER_DIR" 2>/dev/null || { echo "{}"; exit 0; }
THROTTLE="$MARKER_DIR/last"
if [ -f "$THROTTLE" ]; then
  NOW="$(date +%s)"
  LAST="$(date -r "$THROTTLE" +%s 2>/dev/null || echo 0)"
  [ "$((NOW - LAST))" -lt 10 ] && { echo "{}"; exit 0; }
fi
touch "$THROTTLE" 2>/dev/null || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEN=""
for candidate in "$SCRIPT_DIR/../../../skills/track/scripts/generate_portfolio.py" "$SCRIPT_DIR/../skills/track/scripts/generate_portfolio.py" "$HOME/.gemini/config/plugins/project-tracker/skills/track/scripts/generate_portfolio.py"; do
  if [ -f "$candidate" ]; then
    GEN="$candidate"
    break
  fi
done

if [ -n "$GEN" ]; then
  python3 "$GEN" --changed "$PROJECT_ROOT" >/dev/null 2>&1 || true
fi

echo "{}"
exit 0
