#!/usr/bin/env bash
# Tests for dispatch/machine.sh. Run: bash dispatch/test_machine.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2] in [$1]"; FAIL=1 ;; esac; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/h"; mkdir -p "$HOME/.project-tracker"; echo "/c" > "$HOME/.project-tracker/scopes.txt"
STUB="$TMP/plugins.sh"; printf '#!/usr/bin/env bash\nexit 0\n' > "$STUB"
# Safe PATH: only a python3 symlink plus the system dirs, so no real claude/agy
# (/Users/manu/.local/bin) can be reached even by mistake.
SAFE_BIN="$TMP/safebin"; mkdir -p "$SAFE_BIN"
ln -s /Library/Frameworks/Python.framework/Versions/3.12/bin/python3 "$SAFE_BIN/python3"
run() { PATH="$SAFE_BIN:/usr/bin:/bin" BRACE_PLUGINS_SCRIPT="$STUB" /bin/bash "$DIR/machine.sh"; }

OUT="$(run)"; RC=$?
[ $RC -eq 0 ] && echo "PASS: exit 0 without swap" || { echo "FAIL: rc $RC"; FAIL=1; }
[ -f "$HOME/.brace/scopes.txt" ] && echo "PASS: config migrated" || { echo "FAIL: config"; FAIL=1; }
has "$OUT" "/brace:config" "one-time notice names the new command"
has "$OUT" "now BRACE" "one-time notice says the plugin is now BRACE"
OUT="$(run)"; [ -z "$OUT" ] && echo "PASS: notice shown only once" || { echo "FAIL: shown twice [$OUT]"; FAIL=1; }

printf '#!/usr/bin/env bash\necho "SWAPPED-MSG"\nexit 10\n' > "$STUB"
OUT="$(run)"; RC=$?
[ $RC -eq 10 ] && echo "PASS: exit 10 propagated" || { echo "FAIL: rc $RC"; FAIL=1; }
has "$OUT" "SWAPPED-MSG" "swap message printed"
exit $FAIL
