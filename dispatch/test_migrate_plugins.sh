#!/usr/bin/env bash
# Tests for dispatch/migrate_plugins.sh with stub claude/agy CLIs.
# Run: bash dispatch/test_migrate_plugins.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
ok() { if eval "$1"; then echo "PASS: $2"; else echo "FAIL: $2"; FAIL=1; fi; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
BIN="$TMP/bin"; PYBIN="$TMP/pybin"; mkdir -p "$BIN" "$PYBIN"; LOG="$TMP/calls.log"
ln -s "$(command -v python3)" "$PYBIN/python3"
export STUB_LOG="$LOG" STUB_RC=0 STUB_WRITE=1 STUB_SLEEP=0 STUB_MSLEEP=0
P_RUN="$BIN:$PYBIN:/usr/bin:/bin"
P_NOCLI="$PYBIN:/usr/bin:/bin"

# Stub claude: install writes a brace@ key when STUB_WRITE=1; uninstall drops the key.
cat > "$BIN/claude" <<'EOS'
#!/usr/bin/env bash
echo "claude $*" >> "$STUB_LOG"
F="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/installed_plugins.json"
case "$*" in
  "plugin marketplace update"*) sleep "$STUB_MSLEEP" ;;
  "plugin install"*)
    sleep "$STUB_SLEEP"
    [ "$STUB_RC" -eq 0 ] && [ "$STUB_WRITE" = 1 ] && python3 -c 'import json,sys;p=sys.argv[1];d=json.load(open(p));d["plugins"]["brace@x"]=[];json.dump(d,open(p,"w"))' "$F"
    exit "$STUB_RC" ;;
  "plugin uninstall "*)
    python3 -c 'import json,sys;p=sys.argv[1];d=json.load(open(p));d["plugins"].pop(sys.argv[2],None);json.dump(d,open(p,"w"))' "$F" "$3" ;;
esac
exit 0
EOS
cat > "$BIN/agy" <<'EOS'
#!/usr/bin/env bash
echo "agy $*" >> "$STUB_LOG"
case "$*" in
  "plugin install"*) sleep "$STUB_SLEEP"; [ "$STUB_RC" -eq 0 ] && mkdir -p "$HOME/.gemini/config/plugins/brace"; exit "$STUB_RC" ;;
  "plugin uninstall project-tracker") rm -rf "$HOME/.gemini/config/plugins/project-tracker" ;;
esac
exit 0
EOS
chmod +x "$BIN/claude" "$BIN/agy"

# Guard: the real CLIs must be unreachable under the test PATHs.
if [ "$(PATH="$P_RUN" command -v claude)" != "$BIN/claude" ] || [ "$(PATH="$P_RUN" command -v agy)" != "$BIN/agy" ] \
   || PATH="$P_NOCLI" command -v claude >/dev/null 2>&1 || PATH="$P_NOCLI" command -v agy >/dev/null 2>&1; then
  echo "ABORT: real claude/agy reachable from test PATH"; exit 1
fi

fresh() {
  rm -rf "$TMP/h" "$TMP/t" "$LOG"; mkdir -p "$TMP/h" "$TMP/t"
  export HOME="$TMP/h" TMPDIR="$TMP/t"; unset CLAUDE_CONFIG_DIR BRACE_CLI_TIMEOUT BRACE_BACKOFF_SECS
  STUB_RC=0; STUB_WRITE=1; STUB_SLEEP=0; STUB_MSLEEP=0; : > "$LOG"
}
installed() { mkdir -p "$1/plugins"; printf '{"version": 2, "plugins": {%s}}' "$2" > "$1/plugins/installed_plugins.json"; }
run() { PATH="$P_RUN" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh"; }

# A: Claude Code has the old plugin -> update marketplace, install brace, uninstall old
fresh; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ]' "A: exit 10"
ok 'grep -q "claude plugin marketplace update project-tracker" "$LOG"' "A: marketplace refreshed"
ok 'grep -q "claude plugin install brace" "$LOG"' "A: brace installed by bare name"
ok 'grep -q "claude plugin uninstall project-tracker@project-tracker" "$LOG"' "A: old plugin uninstalled"
case "$OUT" in *"Restart"*|*"restart"*) echo "PASS: A: restart message" ;; *) echo "FAIL: A: message [$OUT]"; FAIL=1 ;; esac

# B: install fails -> old kept, no message, exit 0
fresh; STUB_RC=1; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ]' "B: failed install -> exit 0, silent"
ok '! grep -q "uninstall" "$LOG"' "B: old plugin NOT uninstalled"

# C: brace already installed next to the old one -> only uninstall
fresh; installed "$HOME/.claude" '"project-tracker@pt": [], "brace@pt": []'
run >/dev/null; RC=$?
ok '[ $RC -eq 10 ] && ! grep -q "plugin install" "$LOG" && grep -q "uninstall project-tracker@pt" "$LOG"' "C: only uninstall"

# D: custom CLAUDE_CONFIG_DIR is honoured
fresh; installed "$TMP/h/custom" '"project-tracker@m": []'
CLAUDE_CONFIG_DIR="$TMP/h/custom" PATH="$P_RUN" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh" >/dev/null; RC=$?
ok '[ $RC -eq 10 ] && grep -q "uninstall project-tracker@m" "$LOG"' "D: reads CLAUDE_CONFIG_DIR"

# E: Antigravity, old install made of symlinks into a repo
fresh
REPO="$TMP/repo"; mkdir -p "$REPO/skills/track"; echo keep > "$REPO/skills/track/SKILL.md"
OLD="$HOME/.gemini/config/plugins/project-tracker"; mkdir -p "$OLD/skills" "$HOME/.gemini/config/skills"
ln -s "$REPO/skills/track" "$OLD/skills/track"; ln -s "$REPO/skills/track" "$HOME/.gemini/config/skills/track"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ]' "E: exit 10"
ok 'grep -q "agy plugin install $TMP/brace-root" "$LOG"' "E: brace installed from the plugin root"
ok '[ ! -e "$OLD" ]' "E: old folder removed"
ok '! grep -q "agy plugin uninstall" "$LOG"' "E: agy uninstall NOT called on a symlinked install"
ok '[ -f "$REPO/skills/track/SKILL.md" ]' "E: symlink targets untouched"
ok '[ ! -e "$HOME/.gemini/config/skills/track" ]' "E: stray skills/track link removed"

# E2: plain (no symlink) old folder -> agy uninstall is used
fresh; mkdir -p "$HOME/.gemini/config/plugins/project-tracker"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ] && grep -q "agy plugin uninstall project-tracker" "$LOG" && [ ! -e "$HOME/.gemini/config/plugins/project-tracker" ]' "E2: plain folder uninstalled"

# F: nothing old anywhere -> silent, no calls
fresh
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ ! -s "$LOG" ]' "F: nothing to do"

# G: CLIs missing -> nothing attempted, exit 0
fresh; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(PATH="$P_NOCLI" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh")"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ]' "G: no CLI -> silent"

# H: install exits 0 but brace never shows up -> old NOT uninstalled
fresh; STUB_WRITE=0; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && ! grep -q "uninstall" "$LOG"' "H: unverified install -> old kept, silent"

# I: agy install fails -> old folder kept, no uninstall
fresh; STUB_RC=1; mkdir -p "$HOME/.gemini/config/plugins/project-tracker"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ -d "$HOME/.gemini/config/plugins/project-tracker" ] && ! grep -q "uninstall" "$LOG"' "I: agy install fails -> old kept"

# J: install hangs -> bounded, old kept, silent; then backoff blocks a retry
fresh; STUB_SLEEP=6; export BRACE_CLI_TIMEOUT=1; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
S=$SECONDS; OUT="$(run)"; RC=$?; EL=$((SECONDS - S))
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ $EL -le 4 ] && ! grep -q "uninstall" "$LOG"' "J: hung install bounded (${EL}s), old kept"
: > "$LOG"; STUB_SLEEP=0
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && ! grep -q "plugin install" "$LOG"' "J: backoff -> no new install call"

# K: total budget shared by all calls: slow marketplace update + slow install
fresh; STUB_MSLEEP=6; STUB_SLEEP=6; export BRACE_CLI_TIMEOUT=2; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
S=$SECONDS; OUT="$(run)"; RC=$?; EL=$((SECONDS - S))
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ $EL -le 4 ] && ! grep -q "uninstall" "$LOG"' "K: total budget respected (${EL}s)"
ok '! grep -q "plugin install" "$LOG"' "K: no call started past the deadline"
exit $FAIL
