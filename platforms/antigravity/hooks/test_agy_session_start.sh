#!/usr/bin/env bash
# Test suite for Antigravity session_start.sh hook
set -euo pipefail

TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="$SCRIPT_DIR/session_start.sh"

export HOME="$TEST_DIR"
mkdir -p "$HOME/.project-tracker"

# Setup dummy scope and projects
mkdir -p "$TEST_DIR/code/tracked/docs/project-tracker"
cat << 'EOF' > "$TEST_DIR/code/tracked/docs/project-tracker/STATUS.md"
---
project: tracked
status: active
uses_git: false
last_updated: 2026-10-04
reminders_list: "non"
category: "Test"
backlog_model: "adopté"
---
# STATUS
EOF

mkdir -p "$TEST_DIR/code/untracked"
mkdir -p "$TEST_DIR/outside"

echo "$TEST_DIR/code" > "$HOME/.project-tracker/scopes.txt"

# Test 1: invocationNum > 1 -> silence ({})
OUTPUT="$(echo '{"invocationNum": 2, "workspacePaths": ["'"$TEST_DIR/code/tracked"'"]}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: invocationNum > 1 did not output {} (got: $OUTPUT)"; exit 1; }
echo "PASS: invocationNum > 1 -> silence"

# Test 2: outside scope -> silence ({})
OUTPUT="$(echo '{"invocationNum": 1, "workspacePaths": ["'"$TEST_DIR/outside"'"]}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: outside scope did not output {} (got: $OUTPUT)"; exit 1; }
echo "PASS: outside scope -> silence"

# Test 3: tracked project -> valid JSON with injectSteps and STATUS.md frontmatter
OUTPUT="$(echo '{"invocationNum": 1, "workspacePaths": ["'"$TEST_DIR/code/tracked"'"]}' | bash "$HOOK")"
printf '%s' "$OUTPUT" | python3 -c '
import json, sys
data = json.load(sys.stdin)
assert "injectSteps" in data, "missing injectSteps"
msg = data["injectSteps"][0]["ephemeralMessage"]
assert "[project-tracker] Session opened in a tracked project" in msg, "missing project banner"
assert "project: tracked" in msg, "missing frontmatter content"
'
echo "PASS: tracked project -> injectSteps ephemeralMessage"

# Test 4: untracked project -> valid JSON with bootstrap prompt
OUTPUT="$(echo '{"invocationNum": 1, "workspacePaths": ["'"$TEST_DIR/code/untracked"'"]}' | bash "$HOOK")"
printf '%s' "$OUTPUT" | python3 -c '
import json, sys
data = json.load(sys.stdin)
assert "injectSteps" in data, "missing injectSteps"
msg = data["injectSteps"][0]["ephemeralMessage"]
assert "UNTRACKED project" in msg, "missing untracked banner"
assert "ask_question" in msg, "missing ask_question reference"
'
echo "PASS: untracked project -> bootstrap prompt"

# Test 5: ignored project -> silence ({})
echo "$TEST_DIR/code/untracked" > "$HOME/.project-tracker/trackignore.txt"
OUTPUT="$(echo '{"invocationNum": 1, "workspacePaths": ["'"$TEST_DIR/code/untracked"'"]}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: ignored project did not output {} (got: $OUTPUT)"; exit 1; }
echo "PASS: ignored project -> silence"

echo "All Antigravity session_start tests passed."
