#!/usr/bin/env bash
# Test suite for Antigravity portfolio_regen.sh hook
set -euo pipefail

TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="$SCRIPT_DIR/portfolio_regen.sh"

export HOME="$TEST_DIR"
export TMPDIR="$TEST_DIR/tmp"
mkdir -p "$TMPDIR"
mkdir -p "$HOME/.project-tracker"

# Setup dummy scope and tracked project
mkdir -p "$TEST_DIR/code/my-app/docs/project-tracker"
cat << 'EOF' > "$TEST_DIR/code/my-app/docs/project-tracker/STATUS.md"
---
project: my-app
status: active
uses_git: false
last_updated: 2026-10-04
---
EOF

mkdir -p "$TEST_DIR/out"
echo "$TEST_DIR/code" > "$HOME/.project-tracker/scopes.txt"
echo "$TEST_DIR/out" > "$HOME/.project-tracker/portfolio.txt"

STATUS_PATH="$TEST_DIR/code/my-app/docs/project-tracker/STATUS.md"

# Test 1: Non-matching tool -> silence ({})
OUTPUT="$(echo '{"toolCall": {"name": "run_command", "args": {"CommandLine": "ls"}}, "conversationId": "c1"}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: non-matching tool did not output {} (got: $OUTPUT)"; exit 1; }
echo "PASS: non-matching tool -> silence"

# Test 2: Unrelated file -> silence ({})
OUTPUT="$(echo '{"toolCall": {"name": "write_to_file", "args": {"TargetFile": "'"$TEST_DIR/code/my-app/README.md"'"}}, "conversationId": "c1"}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: unrelated file did not output {} (got: $OUTPUT)"; exit 1; }
echo "PASS: unrelated file -> silence"

# Test 3: write_to_file on STATUS.md -> regenerates portfolio and outputs {}
OUTPUT="$(echo '{"toolCall": {"name": "write_to_file", "args": {"TargetFile": "'"$STATUS_PATH"'"}}, "conversationId": "c1"}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: STATUS.md edit did not output {} (got: $OUTPUT)"; exit 1; }
[ -f "$TEST_DIR/out/PORTFOLIO.html" ] || { echo "FAIL: PORTFOLIO.html was not generated"; exit 1; }
grep -q "my-app" "$TEST_DIR/out/PORTFOLIO.html" || { echo "FAIL: my-app not in PORTFOLIO.html"; exit 1; }
echo "PASS: write_to_file on STATUS.md -> PORTFOLIO.html generated"

# Test 4: replace_file_content on STATUS.md (after clearing throttle)
rm -f "$TMPDIR/project-tracker-portfolio-regen/last"
OUTPUT="$(echo '{"toolCall": {"name": "replace_file_content", "args": {"TargetFile": "'"$STATUS_PATH"'"}}, "conversationId": "c1"}' | bash "$HOOK")"
[ "$OUTPUT" = "{}" ] || { echo "FAIL: replace_file_content on STATUS.md did not output {}"; exit 1; }
echo "PASS: replace_file_content on STATUS.md -> success"

# Test 5: portfolio.txt missing -> injects guidance message
rm -f "$HOME/.project-tracker/portfolio.txt"
OUTPUT="$(echo '{"toolCall": {"name": "write_to_file", "args": {"TargetFile": "'"$STATUS_PATH"'"}}, "conversationId": "fresh_conv"}' | bash "$HOOK")"
printf '%s' "$OUTPUT" | python3 -c '
import json, sys
data = json.load(sys.stdin)
assert "injectSteps" in data, "missing injectSteps when portfolio.txt missing"
msg = data["injectSteps"][0]["ephemeralMessage"]
assert "portfolio output location not configured" in msg
'
echo "PASS: portfolio.txt missing -> injectSteps notice"

echo "All Antigravity portfolio_regen tests passed."
