#!/usr/bin/env bash
# Tests for dispatch/migrate_plugins.sh with stub claude/agy CLIs.
# Run: bash dispatch/test_migrate_plugins.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
ok() { if eval "$1"; then echo "PASS: $2"; else echo "FAIL: $2"; FAIL=1; fi; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
BIN="$TMP/bin"; mkdir -p "$BIN"; LOG="$TMP/calls.log"

stubs() {  # $1 = exit code for "install" calls
  cat > "$BIN/claude" <<EOF
#!/usr/bin/env bash
echo "claude \$*" >> "$LOG"
case "\$*" in "plugin install"*) exit $1 ;; esac
exit 0
EOF
  cat > "$BIN/agy" <<EOF
#!/usr/bin/env bash
echo "agy \$*" >> "$LOG"
case "\$*" in
  "plugin install"*) [ $1 -eq 0 ] && mkdir -p "\$HOME/.gemini/config/plugins/brace"; exit $1 ;;
  "plugin uninstall project-tracker") rm -rf "\$HOME/.gemini/config/plugins/project-tracker" ;;
esac
exit 0
EOF
  chmod +x "$BIN/claude" "$BIN/agy"
}
fresh() { rm -rf "$TMP/h" "$LOG"; mkdir -p "$TMP/h"; export HOME="$TMP/h"; unset CLAUDE_CONFIG_DIR; : > "$LOG"; }
installed() { mkdir -p "$1/plugins"; printf '{"version": 2, "plugins": {%s}}' "$2" > "$1/plugins/installed_plugins.json"; }
PYDIR="$(dirname "$(command -v python3)")"
run() { PATH="$BIN:$PYDIR:/usr/bin:/bin" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh"; }

# A: Claude Code has the old plugin -> update marketplace, install brace, uninstall old
stubs 0; fresh; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ]' "A: exit 10"
ok 'grep -q "claude plugin marketplace update project-tracker" "$LOG"' "A: marketplace refreshed"
ok 'grep -q "claude plugin install brace" "$LOG"' "A: brace installed by bare name"
ok 'grep -q "claude plugin uninstall project-tracker@project-tracker" "$LOG"' "A: old plugin uninstalled"
case "$OUT" in *"Restart"*|*"restart"*) echo "PASS: A: restart message" ;; *) echo "FAIL: A: message [$OUT]"; FAIL=1 ;; esac

# B: install fails -> old kept, no message, exit 0  (Review Focus 3)
stubs 1; fresh; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ]' "B: failed install -> exit 0, silent"
ok '! grep -q "uninstall" "$LOG"' "B: old plugin NOT uninstalled"

# C: brace already installed next to the old one -> only uninstall
stubs 0; fresh; installed "$HOME/.claude" '"project-tracker@pt": [], "brace@pt": []'
run >/dev/null; RC=$?
ok '[ $RC -eq 10 ] && ! grep -q "plugin install" "$LOG" && grep -q "uninstall project-tracker@pt" "$LOG"' "C: only uninstall"

# D: custom CLAUDE_CONFIG_DIR is honoured (Review Focus 5)
stubs 0; fresh; installed "$TMP/h/custom" '"project-tracker@m": []'
CLAUDE_CONFIG_DIR="$TMP/h/custom" PATH="$BIN:$PYDIR:/usr/bin:/bin" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh" >/dev/null; RC=$?
ok '[ $RC -eq 10 ] && grep -q "uninstall project-tracker@m" "$LOG"' "D: reads CLAUDE_CONFIG_DIR"

# E: Antigravity, old install made of symlinks into a repo (Review Focus 2)
stubs 0; fresh
REPO="$TMP/repo"; mkdir -p "$REPO/skills/track"; echo keep > "$REPO/skills/track/SKILL.md"
OLD="$HOME/.gemini/config/plugins/project-tracker"; mkdir -p "$OLD/skills" "$HOME/.gemini/config/skills"
ln -s "$REPO/skills/track" "$OLD/skills/track"; ln -s "$REPO/skills/track" "$HOME/.gemini/config/skills/track"
cat > "$BIN/agy" <<EOF
#!/usr/bin/env bash
echo "agy \$*" >> "$LOG"
case "\$*" in "plugin install"*) mkdir -p "\$HOME/.gemini/config/plugins/brace" ;; esac
exit 0
EOF
chmod +x "$BIN/agy"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ]' "E: exit 10"
ok 'grep -q "agy plugin install $TMP/brace-root" "$LOG"' "E: brace installed from the plugin root"
ok '[ ! -e "$OLD" ]' "E: old folder removed even if agy uninstall left it"
ok '[ -f "$REPO/skills/track/SKILL.md" ]' "E: symlink targets untouched"
ok '[ ! -e "$HOME/.gemini/config/skills/track" ]' "E: stray skills/track link removed"

# F: nothing old anywhere -> silent, no calls
stubs 0; fresh
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ ! -s "$LOG" ]' "F: nothing to do"

# G: CLIs missing -> nothing attempted, exit 0
fresh; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
PY_ONLY="$(dirname "$(command -v python3)"):/usr/bin:/bin"
OUT="$(PATH="$PY_ONLY" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh")"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ]' "G: no CLI -> silent"
exit $FAIL
