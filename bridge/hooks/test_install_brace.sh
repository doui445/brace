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
json.dump(d, open(p, "w"))' "$HOME/.claude/plugins/installed_plugins.json"
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
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ -e "$TMPDIR/brace-swap-backoff" ]' "failed install -> exit 0, silent, backoff set"

setup '"project-tracker@project-tracker": []'
OUT="$(STUB_MODE=nowrite run)"; RC=$?
ok 'grep -q "plugin install brace" "$LOG"' "nowrite: install attempted"
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ -e "$TMPDIR/brace-swap-backoff" ]' "install exits 0 but no brace key -> silent, backoff set"

setup '"project-tracker@project-tracker": []'
START=$(date +%s)
OUT="$(BRACE_CLI_TIMEOUT=2 STUB_MODE=slow run)"; RC=$?
ELAPSED=$(( $(date +%s) - START ))
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ "$ELAPSED" -le 6 ]' "slow install -> returns within budget (${ELAPSED}s), silent"
ok '[ -e "$TMPDIR/brace-swap-backoff" ]' "slow install -> backoff set"
: > "$LOG"
OUT="$(STUB_MODE=good run)"; RC=$?
ok '[ $RC -eq 0 ] && [ -z "$OUT" ] && [ ! -s "$LOG" ]' "second run in backoff -> no CLI call, silent"

exit $FAIL
