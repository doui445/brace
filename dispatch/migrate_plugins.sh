#!/usr/bin/env bash
# Replaces the old project-tracker plugin by brace in every tool found on
# this machine (Claude Code, Antigravity). Zero breakage: the old plugin is
# only removed once brace is installed in that tool. Exit 10 (and one
# message) when something was replaced, 0 and silence otherwise.
# Bash 3.2 compatible; JSON via python3.
set -uo pipefail

ROOT="${BRACE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SWAPPED=""

# --- Claude Code -----------------------------------------------------------
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
INSTALLED="$CLAUDE_DIR/plugins/installed_plugins.json"
if command -v claude >/dev/null 2>&1 && [ -f "$INSTALLED" ]; then
  KEYS="$(python3 -c '
import json, sys
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
old = [k for k in plugins if k.startswith("project-tracker@")]
new = [k for k in plugins if k.startswith("brace@")]
print(old[0] if old else "")
print("1" if new else "0")
' "$INSTALLED" 2>/dev/null)"
  OLD_KEY="$(printf '%s\n' "$KEYS" | sed -n '1p')"
  HAS_BRACE="$(printf '%s\n' "$KEYS" | sed -n '2p')"
  if [ -n "$OLD_KEY" ]; then
    if [ "$HAS_BRACE" != "1" ]; then
      claude plugin marketplace update "${OLD_KEY#project-tracker@}" >/dev/null 2>&1 || true
      claude plugin install brace >/dev/null 2>&1 && HAS_BRACE=1
    fi
    if [ "$HAS_BRACE" = "1" ]; then
      claude plugin uninstall "$OLD_KEY" >/dev/null 2>&1 || true
      SWAPPED="Claude Code"
    fi
  fi
fi

# --- Antigravity -------------------------------------------------------------
AGY_PLUGINS="$HOME/.gemini/config/plugins"
if [ -d "$AGY_PLUGINS/project-tracker" ] && command -v agy >/dev/null 2>&1; then
  [ -d "$AGY_PLUGINS/brace" ] || agy plugin install "$ROOT" >/dev/null 2>&1 || true
  if [ -d "$AGY_PLUGINS/brace" ]; then
    agy plugin uninstall project-tracker >/dev/null 2>&1 || true
    # rm -rf removes symlinks themselves, never what they point to.
    [ -e "$AGY_PLUGINS/project-tracker" ] && rm -rf "$AGY_PLUGINS/project-tracker"
    [ -L "$HOME/.gemini/config/skills/track" ] && rm -f "$HOME/.gemini/config/skills/track"
    SWAPPED="${SWAPPED:+$SWAPPED and }Antigravity"
  fi
fi

if [ -n "$SWAPPED" ]; then
  echo "[BRACE] The old project-tracker plugin was replaced by BRACE in $SWAPPED. Tell the user now, in one line: restart Claude Code (and Antigravity) and close every other open session so they all run BRACE."
  exit 10
fi
exit 0
