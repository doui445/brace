#!/usr/bin/env bash
# Tests for dispatch/migrate_plugins.sh with stub claude/agy CLIs.
# Run: bash dispatch/test_migrate_plugins.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
ok() { if eval "$1"; then echo "PASS: $2"; else echo "FAIL: $2"; FAIL=1; fi; }
# warned: the run told the user how to remove the old plugin by hand.
warned() { case "$OUT" in *"could not remove it automatically"*) return 0 ;; esac; return 1; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
BIN="$TMP/bin"; PYBIN="$TMP/pybin"; mkdir -p "$BIN" "$PYBIN"; LOG="$TMP/calls.log"
ln -s "$(command -v python3)" "$PYBIN/python3"
export STUB_LOG="$LOG" STUB_RC=0 STUB_WRITE=1 STUB_SLEEP=0 STUB_MSLEEP=0 STUB_FAIL_SCOPE=""
P_RUN="$BIN:$PYBIN:/usr/bin:/bin"
P_NOCLI="$PYBIN:/usr/bin:/bin"

# Stub claude: install writes a brace@ key when STUB_WRITE=1; uninstall drops the key.
cat > "$BIN/claude" <<'EOS'
#!/usr/bin/env bash
echo "claude $* [cwd=$PWD]" >> "$STUB_LOG"
F="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/installed_plugins.json"
case "$*" in
  "plugin marketplace update"*) sleep "$STUB_MSLEEP" ;;
  "plugin install"*)
    sleep "$STUB_SLEEP"
    # Adds a brace@x entry with the given scope (default user; project and
    # local ones record the folder the CLI runs in).
    S=user; [ "${4:-}" = "--scope" ] && S="$5"
    [ "$STUB_RC" -eq 0 ] && [ "$STUB_WRITE" = 1 ] && [ "$S" != "${STUB_FAIL_SCOPE:-}" ] && python3 -c '
import json, sys
p, s, cwd = sys.argv[1:4]
d = json.load(open(p)); e = {"scope": s}
if s != "user": e["projectPath"] = cwd
d["plugins"].setdefault("brace@x", []).append(e)
json.dump(d, open(p, "w"))' "$F" "$S" "$PWD"
    exit "$STUB_RC" ;;
  "plugin uninstall "*)
    # Drops the entries of the given scope (default user) for the folder the
    # CLI runs in; the key goes when none is left.
    S=user; [ "${4:-}" = "--scope" ] && S="$5"
    python3 -c '
import json, sys
p, k, s, cwd = sys.argv[1:5]
d = json.load(open(p)); v = d["plugins"].get(k)
if v is not None:
    v = [e for e in v if (e.get("scope") or "user") != s or e.get("projectPath", cwd) != cwd]
    if v: d["plugins"][k] = v
    else: d["plugins"].pop(k)
json.dump(d, open(p, "w"))' "$F" "$3" "$S" "$PWD" ;;
esac
exit 0
EOS
cat > "$BIN/agy" <<'EOS'
#!/usr/bin/env bash
echo "agy $*" >> "$STUB_LOG"
case "$*" in
  "plugin install"*) sleep "$STUB_SLEEP"; mkdir -p "$HOME/.gemini/config/plugins/brace"; [ "$STUB_RC" -eq 0 ] && : > "$HOME/.gemini/config/plugins/brace/plugin.json"; exit "$STUB_RC" ;;
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
  export HOME="$TMP/h" TMPDIR="$TMP/t"; unset CLAUDE_CONFIG_DIR BRACE_CLI_TIMEOUT BRACE_BACKOFF_SECS BRACE_WARN_SECS
  STUB_RC=0; STUB_WRITE=1; STUB_SLEEP=0; STUB_MSLEEP=0; STUB_FAIL_SCOPE=""; : > "$LOG"
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

# B: install fails -> old kept, exit 11, the user is told how to do it by hand
fresh; STUB_RC=1; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && warned' "B: failed install -> exit 11 (old still there), manual steps given"
case "$OUT" in *"in Claude Code, run /plugin install brace if it is missing, then /plugin uninstall project-tracker"*) echo "PASS: B: Claude Code steps" ;; *) echo "FAIL: B: steps [$OUT]"; FAIL=1 ;; esac
case "$OUT" in *"Antigravity"*) echo "FAIL: B: Antigravity named for a Claude-only leftover"; FAIL=1 ;; *) echo "PASS: B: only Claude Code named" ;; esac
ok '! grep -q "uninstall" "$LOG"' "B: old plugin NOT uninstalled"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && [ -z "$OUT" ]' "B: told at most once a day -> next run silent"
OUT="$(BRACE_WARN_SECS=0 run)"; RC=$?
ok '[ $RC -eq 11 ] && warned' "B: told again once the day is over"

# C: brace already installed next to the old one -> only uninstall
fresh; installed "$HOME/.claude" '"project-tracker@pt": [], "brace@pt": []'
run >/dev/null; RC=$?
ok '[ $RC -eq 10 ] && ! grep -q "plugin install" "$LOG" && grep -q "uninstall project-tracker@pt" "$LOG"' "C: only uninstall"
ok 'grep -q "uninstall project-tracker@pt --scope user" "$LOG"' "C: user-scope entry uninstalled with --scope user"

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
ok '[ $RC -eq 11 ] && warned' "G: no CLI -> exit 11, manual steps given"

# H: install exits 0 but brace never shows up -> old NOT uninstalled
fresh; STUB_WRITE=0; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && warned && ! grep -q "uninstall" "$LOG"' "H: unverified install -> old kept, exit 11"

# I: agy install fails -> old folder kept, no uninstall
fresh; STUB_RC=1; mkdir -p "$HOME/.gemini/config/plugins/project-tracker"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && warned && [ -d "$HOME/.gemini/config/plugins/project-tracker" ] && ! grep -q "uninstall" "$LOG"' "I: agy install fails -> old kept, exit 11"
case "$OUT" in *"agy plugin uninstall project-tracker"*) echo "PASS: I: Antigravity steps" ;; *) echo "FAIL: I: steps [$OUT]"; FAIL=1 ;; esac

# I2: agy install creates a partial brace folder then fails -> old kept, folder left
fresh; STUB_RC=1; mkdir -p "$HOME/.gemini/config/plugins/project-tracker"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && warned && [ -d "$HOME/.gemini/config/plugins/project-tracker" ] && [ -d "$HOME/.gemini/config/plugins/brace" ] && ! grep -q "uninstall" "$LOG"' "I2: partial brace folder -> old kept, no uninstall"

# I3: after I2 (partial folder + backoff): (a) next run in backoff leaves the old plugin alone
STUB_RC=0
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && [ -z "$OUT" ] && [ -d "$HOME/.gemini/config/plugins/project-tracker" ] && ! grep -q "uninstall" "$LOG"' "I3a: partial folder + backoff -> old kept"
ok '[ "$(grep -c "agy plugin install" "$LOG")" = 1 ]' "I3a: no new install call during backoff"
# (b) backoff expired + succeeding install -> brace complete, old removed
OUT="$(BRACE_BACKOFF_SECS=0 run)"; RC=$?
ok '[ $RC -eq 10 ] && [ -f "$HOME/.gemini/config/plugins/brace/plugin.json" ] && [ ! -e "$HOME/.gemini/config/plugins/project-tracker" ]' "I3b: backoff expired -> installed, old removed"

# I4: partial brace folder present before the run, no backoff, install succeeds -> proceeds
fresh; mkdir -p "$HOME/.gemini/config/plugins/project-tracker" "$HOME/.gemini/config/plugins/brace"
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ] && grep -q "agy plugin install" "$LOG" && [ -f "$HOME/.gemini/config/plugins/brace/plugin.json" ] && [ ! -e "$HOME/.gemini/config/plugins/project-tracker" ]' "I4: pre-existing partial folder -> install, then old removed"

# J: install hangs -> bounded, old kept, silent; then backoff blocks a retry
fresh; STUB_SLEEP=6; export BRACE_CLI_TIMEOUT=1; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
S=$SECONDS; OUT="$(run)"; RC=$?; EL=$((SECONDS - S))
ok '[ $RC -eq 11 ] && warned && [ $EL -le 4 ] && ! grep -q "uninstall" "$LOG"' "J: hung install bounded (${EL}s), old kept"
: > "$LOG"; STUB_SLEEP=0
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && [ -z "$OUT" ] && ! grep -q "plugin install" "$LOG"' "J: backoff -> no new install call"

# K: total budget shared by all calls: slow marketplace update + slow install
fresh; STUB_MSLEEP=6; STUB_SLEEP=6; export BRACE_CLI_TIMEOUT=2; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
S=$SECONDS; OUT="$(run)"; RC=$?; EL=$((SECONDS - S))
ok '[ $RC -eq 11 ] && warned && [ $EL -le 4 ] && ! grep -q "uninstall" "$LOG"' "K: total budget respected (${EL}s)"
ok '! grep -q "plugin install" "$LOG"' "K: no call started past the deadline"

# L: entries in several scopes -> each uninstalled with its scope, project
# scopes from their project folder
fresh; PP="$TMP/h/my proj"; mkdir -p "$PP"
installed "$HOME/.claude" '"project-tracker@pt": [{"scope": "user"}, {"scope": "project", "projectPath": "'"$PP"'"}, {"scope": "local", "projectPath": "'"$PP"'"}], "brace@pt": [{"scope": "user"}]'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ]' "L: all scopes removed -> exit 10"
ok 'grep -q "uninstall project-tracker@pt --scope user" "$LOG"' "L: --scope user"
ok 'grep -q "uninstall project-tracker@pt --scope project \[cwd=$PP\]" "$LOG"' "L: --scope project run from the project folder"
ok 'grep -q "uninstall project-tracker@pt --scope local \[cwd=$PP\]" "$LOG"' "L: --scope local run from the project folder"
ok 'grep -q "install brace --scope project \[cwd=$PP\]" "$LOG" && grep -q "install brace --scope local \[cwd=$PP\]" "$LOG"' "L: brace installed with the same scope in that project first"
case "$OUT" in *"shared .claude/settings.json"*"$PP"*) echo "PASS: L: commit of the shared settings offered" ;; *) echo "FAIL: L: no shared-settings note [$OUT]"; FAIL=1 ;; esac

# L2: brace cannot be installed at project scope -> that old entry stays
# (the team would lose the plugin), exit 10 for the user scope, no note
fresh; STUB_FAIL_SCOPE=project; PP="$TMP/h/team proj"; mkdir -p "$PP"
installed "$HOME/.claude" '"project-tracker@pt": [{"scope": "user"}, {"scope": "project", "projectPath": "'"$PP"'"}], "brace@pt": [{"scope": "user"}]'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ] && ! grep -q "uninstall project-tracker@pt --scope project" "$LOG"' "L2: old project entry kept when brace is not there"
case "$OUT" in *"shared .claude/settings.json"*) echo "FAIL: L2: shared note without a switch"; FAIL=1 ;; *) echo "PASS: L2: no shared note" ;; esac
OUT="$(run)"; RC=$?
ok '[ $RC -eq 11 ] && warned' "L2: next run -> exit 11, manual steps given"

# M: a project-scope entry whose folder is gone can never be loaded: it is
# ignored, so the user scope swap completes and later runs exit 0
fresh
installed "$HOME/.claude" '"project-tracker@pt": [{"scope": "user"}, {"scope": "project", "projectPath": "'"$TMP/gone"'"}, {"scope": "local"}], "brace@pt": [{"scope": "user"}]'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 10 ] && [ -n "$OUT" ]' "M: user entry removed -> exit 10 with the restart message"
ok '! grep -q -- "--scope project" "$LOG" && ! grep -q -- "--scope local" "$LOG"' "M: dead entries never passed to the CLI"
: > "$LOG"; OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ ! -s "$LOG" ]' "M: only dead entries left -> exit 0, silent, no call"

# M2: nothing but a dead project entry, no brace -> nothing to do at all
fresh; installed "$HOME/.claude" '"project-tracker@pt": [{"scope": "project", "projectPath": "'"$TMP/gone"'"}]'
OUT="$(run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ ! -s "$LOG" ]' "M2: dead entry only -> exit 0, no install attempted"

# N: Antigravity without agy on PATH, brace already complete -> old removed
fresh; mkdir -p "$HOME/.gemini/config/plugins/project-tracker" "$HOME/.gemini/config/plugins/brace"
: > "$HOME/.gemini/config/plugins/brace/plugin.json"
OUT="$(PATH="$P_NOCLI" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh")"; RC=$?
ok '[ $RC -eq 10 ] && [ ! -e "$HOME/.gemini/config/plugins/project-tracker" ] && [ -f "$HOME/.gemini/config/plugins/brace/plugin.json" ]' "N: no agy, brace complete -> old folder removed"

# O: Antigravity without agy and without brace -> nothing touched, exit 11
fresh; mkdir -p "$HOME/.gemini/config/plugins/project-tracker"
OUT="$(PATH="$P_NOCLI" BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh")"; RC=$?
ok '[ $RC -eq 11 ] && warned && [ -d "$HOME/.gemini/config/plugins/project-tracker" ]' "O: no agy, no brace -> old kept, exit 11"

# P: the budget is wall-clock, not a count of polls: a slow `sleep 0.2`
# (1 s each) must not stretch it
SLOWBIN="$TMP/slowbin"; mkdir -p "$SLOWBIN"
printf '#!/bin/sh\n[ "$1" = 0.2 ] && exec /bin/sleep 1\nexec /bin/sleep "$@"\n' > "$SLOWBIN/sleep"; chmod +x "$SLOWBIN/sleep"
fresh; STUB_SLEEP=20; installed "$HOME/.claude" '"project-tracker@project-tracker": []'
S=$SECONDS; OUT="$(PATH="$SLOWBIN:$P_RUN" BRACE_CLI_TIMEOUT=2 BRACE_PLUGIN_ROOT="$TMP/brace-root" bash "$DIR/migrate_plugins.sh")"; RC=$?; EL=$((SECONDS - S))
ok '[ $RC -eq 11 ] && [ $EL -le 6 ]' "P: wall-clock budget with slow polling (${EL}s)"
exit $FAIL
