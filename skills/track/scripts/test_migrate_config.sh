#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

export HOME="$TEST_DIR"
mkdir -p "$HOME/.claude/project-tracker"
echo "/test/code" > "$HOME/.claude/project-tracker/scopes.txt"
echo "fr" > "$HOME/.claude/project-tracker/language.txt"

# Run migration
bash skills/track/scripts/migrate_config.sh

# Verify target physical dir
[ -d "$HOME/.project-tracker" ] || { echo "FAIL: ~/.project-tracker missing"; exit 1; }
[ -f "$HOME/.project-tracker/scopes.txt" ] || { echo "FAIL: scopes.txt missing in target"; exit 1; }
[ -L "$HOME/.claude/project-tracker" ] || { echo "FAIL: ~/.claude/project-tracker not a symlink"; exit 1; }
[ -L "$HOME/.gemini/project-tracker" ] || { echo "FAIL: ~/.gemini/project-tracker not a symlink"; exit 1; }

# Verify transparency
read_scopes="$(cat "$HOME/.claude/project-tracker/scopes.txt")"
[ "$read_scopes" = "/test/code" ] || { echo "FAIL: content mismatch via claude symlink"; exit 1; }
read_gemini="$(cat "$HOME/.gemini/project-tracker/scopes.txt")"
[ "$read_gemini" = "/test/code" ] || { echo "FAIL: content mismatch via gemini symlink"; exit 1; }

# Idempotence check
bash skills/track/scripts/migrate_config.sh
[ -L "$HOME/.claude/project-tracker" ] || { echo "FAIL: idempotence broke claude symlink"; exit 1; }

echo "PASS: config migration and symlinks verified"
