#!/usr/bin/env bash
# Tests for the project-tracker 0.14.0 bridge hook. Run: bash bridge/hooks/test_install_brace.sh
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/install_brace.sh"
FAIL=0
ok() { if eval "$1"; then echo "PASS: $2"; else echo "FAIL: $2"; FAIL=1; fi; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
BIN="$TMP/bin"; PYD="$TMP/py"; mkdir -p "$BIN" "$PYD"; LOG="$TMP/log"
PY3="$(command -v python3)" || { echo "FAIL: python3 missing"; exit 1; }
ln -s "$PY3" "$PYD/python3"
SAFE="$PYD:/usr/bin:/bin"
# Never run against a real claude CLI.
if PATH="$SAFE" command -v claude >/dev/null 2>&1; then echo "ABORT: a real claude resolves on the test PATH"; exit 1; fi

# Stub claude; STUB_MODE: good (installs brace key) | nowrite (exit 0, no key) | slow | fail
cat > "$BIN/claude" <<'STUB'
#!/usr/bin/env bash
echo "claude $*" >> "$STUB_LOG"
case "${STUB_MODE:-good}" in
  good)
    if [ "${1:-} ${2:-}" = "plugin install" ]; then
      python3 -c '
import json, sys
p = sys.argv[1]; d = json.load(open(p)); d["plugins"]["brace@project-tracker"] = []
json.dump(d, open(p, "w"))' "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/installed_plugins.json"
    fi
    exit 0 ;;
  nowrite) exit 0 ;;
  slow) sleep 30; exit 0 ;;
  fail) exit 1 ;;
esac
STUB
chmod +x "$BIN/claude"

setup() { rm -rf "$TMP/h" "$TMP/t"; mkdir -p "$TMP/h/.claude/plugins" "$TMP/t"
  export HOME="$TMP/h" TMPDIR="$TMP/t" STUB_LOG="$LOG"; unset CLAUDE_CONFIG_DIR BRACE_CLI_TIMEOUT BRACE_BACKOFF_SECS; : > "$LOG"
  printf '{"version": 2, "plugins": {%s}}' "$1" > "$HOME/.claude/plugins/installed_plugins.json"; }
run() { echo '{}' | PATH="$BIN:$SAFE" bash "$HOOK"; }

export STUB_MODE=good
setup '"project-tracker@project-tracker": []'
OUT="$(run)"
ok 'grep -q "claude plugin marketplace update project-tracker" "$LOG"' "marketplace refreshed (old local name)"
ok 'grep -q "claude plugin install brace" "$LOG"' "brace installed by bare name"
ok '! grep -q uninstall "$LOG"' "bridge never uninstalls"
case "$OUT" in *"BRACE"*"estart"*) echo "PASS: restart message" ;; *) echo "FAIL: message [$OUT]"; FAIL=1 ;; esac
ok '[ ! -e "$TMPDIR/brace-swap-backoff" ]' "no backoff after success"

setup '"project-tracker@project-tracker": [], "brace@project-tracker": []'
OUT="$(run)"
ok '[ -z "$OUT" ] && [ ! -s "$LOG" ]' "brace already there -> silent, no call"

setup '"project-tracker@project-tracker": []'
OUT="$(echo '{}' | PATH="$SAFE" bash "$HOOK")"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ]' "no claude CLI -> exit 0, silent"

STUB_MODE=fail setup '"project-tracker@project-tracker": []'
OUT="$(STUB_MODE=fail run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -e "$TMPDIR/brace-swap-backoff" ]' "failed install -> exit 0, backoff set"
case "$OUT" in *"could not be installed"*"/plugin install brace"*) echo "PASS: failed install -> one-line manual-install message" ;; *) echo "FAIL: failed install message [$OUT]"; FAIL=1 ;; esac
ok '[ "$(printf "%s\n" "$OUT" | grep -c .)" -eq 1 ]' "failed install -> exactly one line"
OUT="$(STUB_MODE=fail run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ]' "failed install, same backoff window -> silent (message at most once)"
OUT="$(BRACE_BACKOFF_SECS=0 STUB_MODE=fail run)"; RC=$?
case "$OUT" in *"could not be installed"*) echo "PASS: backoff expired, fails again -> message again" ;; *) echo "FAIL: no message after backoff [$OUT]"; FAIL=1 ;; esac

setup '"project-tracker@project-tracker": []'
OUT="$(STUB_MODE=nowrite run)"; RC=$?
ok 'grep -q "plugin install brace" "$LOG"' "nowrite: install attempted"
ok '[ $RC -eq 0 ] && [ -e "$TMPDIR/brace-swap-backoff" ]' "install exits 0 but no brace key -> backoff set"
case "$OUT" in *"could not be installed"*) echo "PASS: no brace key -> manual-install message" ;; *) echo "FAIL: nowrite message [$OUT]"; FAIL=1 ;; esac

setup '"project-tracker@project-tracker": []'
START=$(date +%s)
OUT="$(BRACE_CLI_TIMEOUT=2 STUB_MODE=slow run)"; RC=$?
ELAPSED=$(( $(date +%s) - START ))
ok '[ $RC -eq 0 ] && [ "$ELAPSED" -le 6 ]' "slow install -> returns within budget (${ELAPSED}s)"
case "$OUT" in *"could not be installed"*) echo "PASS: timed-out install -> manual-install message" ;; *) echo "FAIL: timeout message [$OUT]"; FAIL=1 ;; esac
ok '[ -e "$TMPDIR/brace-swap-backoff" ]' "slow install -> backoff set"
: > "$LOG"
OUT="$(STUB_MODE=good run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ ! -s "$LOG" ]' "second run in backoff -> no CLI call, silent"


# Custom CLAUDE_CONFIG_DIR: its installed_plugins.json is the one read.
setup '"other@x": []'
CUSTOM="$TMP/h/custom cfg"; mkdir -p "$CUSTOM/plugins"
printf '{"version": 2, "plugins": {"project-tracker@pt": []}}' > "$CUSTOM/plugins/installed_plugins.json"
OUT="$(CLAUDE_CONFIG_DIR="$CUSTOM" STUB_MODE=good run)"; RC=$?
ok 'grep -q "claude plugin marketplace update pt" "$LOG" && grep -q "claude plugin install brace" "$LOG"' "CLAUDE_CONFIG_DIR: old key read from the custom dir"
case "$OUT" in *"BRACE has just been installed"*) echo "PASS: CLAUDE_CONFIG_DIR: install verified in the custom dir" ;; *) echo "FAIL: custom dir [$OUT]"; FAIL=1 ;; esac
setup '"project-tracker@pt": []'
mkdir -p "$CUSTOM/plugins"; printf '{"version": 2, "plugins": {"brace@pt": []}}' > "$CUSTOM/plugins/installed_plugins.json"
OUT="$(CLAUDE_CONFIG_DIR="$CUSTOM" STUB_MODE=good run)"
ok '[ -z "$OUT" ] && [ ! -s "$LOG" ]' "CLAUDE_CONFIG_DIR with brace -> silent, the default dir is ignored"

# HOME containing a space.
SP="$TMP/home with space"; rm -rf "$SP"; mkdir -p "$SP/.claude/plugins" "$TMP/t"; : > "$LOG"
printf '{"version": 2, "plugins": {"project-tracker@project-tracker": []}}' > "$SP/.claude/plugins/installed_plugins.json"
rm -f "$TMP/t/brace-swap-backoff"
OUT="$(HOME="$SP" STUB_MODE=good run)"; RC=$?
case "$OUT" in *"BRACE has just been installed"*) echo "PASS: HOME with a space -> installed and verified" ;; *) echo "FAIL: space HOME rc $RC [$OUT]"; FAIL=1 ;; esac

# The budget is wall-clock, not a count of polls: a slow `sleep 0.2`
# (1 s each) must not stretch it.
SLOWBIN="$TMP/slowbin"; mkdir -p "$SLOWBIN"
printf '#!/bin/sh\n[ "$1" = 0.2 ] && exec /bin/sleep 1\nexec /bin/sleep "$@"\n' > "$SLOWBIN/sleep"; chmod +x "$SLOWBIN/sleep"
setup '"project-tracker@project-tracker": []'
START=$SECONDS
OUT="$(echo '{}' | PATH="$SLOWBIN:$BIN:$SAFE" BRACE_CLI_TIMEOUT=2 STUB_MODE=slow bash "$HOOK")"; RC=$?
ELAPSED=$((SECONDS - START))
ok '[ $RC -eq 0 ] && [ "$ELAPSED" -le 6 ]' "wall-clock budget with slow polling (${ELAPSED}s)"
exit $FAIL
