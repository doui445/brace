#!/usr/bin/env bash
# Installer script for project-tracker under Google Antigravity (AGY).
# Sets up ~/.project-tracker, links ~/.gemini/config/plugins/project-tracker,
# registers lifecycle hooks, and verifies everything with the test suites.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing project-tracker for Antigravity ==="

# 1. Unify configuration
echo "1. Unifying configuration in ~/.project-tracker..."
bash "$REPO_DIR/skills/track/scripts/migrate_config.sh"

# 2. Setup Antigravity plugin directory
AGY_PLUGIN_DIR="$HOME/.gemini/config/plugins/project-tracker"
echo "2. Setting up plugin in $AGY_PLUGIN_DIR..."
mkdir -p "$AGY_PLUGIN_DIR"
mkdir -p "$AGY_PLUGIN_DIR/skills"
mkdir -p "$HOME/.gemini/config/skills"

# Symlink manifests and hooks
ln -sf "$REPO_DIR/platforms/antigravity/plugin.json" "$AGY_PLUGIN_DIR/plugin.json"
ln -sf "$REPO_DIR/platforms/antigravity/hooks.json" "$AGY_PLUGIN_DIR/hooks.json"
ln -sfn "$REPO_DIR/platforms/antigravity/hooks" "$AGY_PLUGIN_DIR/hooks"
ln -sfn "$REPO_DIR/skills/track" "$AGY_PLUGIN_DIR/skills/track"

# Also symlink skill directly into ~/.gemini/config/skills/track for universal discovery
ln -sfn "$REPO_DIR/skills/track" "$HOME/.gemini/config/skills/track"

# 3. Ensure executable permissions
chmod +x "$REPO_DIR/platforms/antigravity/hooks/"*.sh

# 4. Run test suites
echo "3. Running verification test suites..."
python3 -m unittest test_plugin_manifest
python3 -m unittest discover -s "$REPO_DIR/skills/track/scripts" -p 'test_*.py'
bash "$REPO_DIR/skills/track/hooks/test_session_start.sh"
bash "$REPO_DIR/skills/track/hooks/test_portfolio_regen.sh"
bash "$REPO_DIR/skills/track/hooks/test_reminders_sync_trigger.sh"
bash "$REPO_DIR/platforms/antigravity/hooks/test_agy_session_start.sh"
bash "$REPO_DIR/platforms/antigravity/hooks/test_agy_portfolio_regen.sh"

echo "=== project-tracker successfully installed and verified for Antigravity! ==="
