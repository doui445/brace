#!/usr/bin/env bash
set -euo pipefail

REAL_DIR="$HOME/.project-tracker"
CLAUDE_DIR="$HOME/.claude/project-tracker"
GEMINI_DIR="$HOME/.gemini/project-tracker"

mkdir -p "$HOME/.gemini"

if [ -d "$CLAUDE_DIR" ] && [ ! -L "$CLAUDE_DIR" ]; then
  if [ ! -d "$REAL_DIR" ]; then
    mv "$CLAUDE_DIR" "$REAL_DIR"
  else
    cp -Rn "$CLAUDE_DIR/"* "$REAL_DIR/" 2>/dev/null || true
    rm -rf "$CLAUDE_DIR"
  fi
fi

mkdir -p "$REAL_DIR"

if [ ! -e "$CLAUDE_DIR" ]; then
  mkdir -p "$HOME/.claude"
  ln -sf "$REAL_DIR" "$CLAUDE_DIR"
elif [ ! -L "$CLAUDE_DIR" ]; then
  mv "$CLAUDE_DIR" "$REAL_DIR.backup.$(date +%s)"
  ln -sf "$REAL_DIR" "$CLAUDE_DIR"
fi

if [ ! -L "$GEMINI_DIR" ]; then
  [ -d "$GEMINI_DIR" ] && mv "$GEMINI_DIR" "$REAL_DIR.gemini.backup.$(date +%s)"
  ln -sf "$REAL_DIR" "$GEMINI_DIR"
fi

echo "Configuration unified in $REAL_DIR"
