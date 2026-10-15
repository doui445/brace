#!/usr/bin/env bash
# Tests for dispatch/machine.sh. Run: bash dispatch/test_machine.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3 — missing [$2] in [$1]"; FAIL=1 ;; esac; }
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/h"; mkdir -p "$HOME/.project-tracker"; echo "/c" > "$HOME/.project-tracker/scopes.txt"
STUB="$TMP/plugins.sh"; printf '#!/usr/bin/env bash\nexit 0\n' > "$STUB"
# Safe PATH: only a python3 symlink plus the system dirs, so no real claude or
# agy binary on the user's PATH can be reached even by mistake.
PY="$(command -v python3)"
if [ -z "$PY" ]; then echo "FAIL: python3 not found, cannot build the safe PATH"; exit 1; fi
SAFE_BIN="$TMP/safebin"; mkdir -p "$SAFE_BIN"
ln -s "$PY" "$SAFE_BIN/python3"
run() { PATH="$SAFE_BIN:/usr/bin:/bin" BRACE_PLUGINS_SCRIPT="$STUB" /bin/bash "$DIR/machine.sh"; }

OUT="$(run)"; RC=$?
[ $RC -eq 0 ] && echo "PASS: exit 0 without swap" || { echo "FAIL: rc $RC"; FAIL=1; }
[ -f "$HOME/.brace/scopes.txt" ] && echo "PASS: config migrated" || { echo "FAIL: config"; FAIL=1; }
has "$OUT" "/brace:config" "one-time notice names the new command"
has "$OUT" "now BRACE" "one-time notice says the plugin is now BRACE"
[ ! -f "$HOME/.brace/.from-project-tracker" ] && echo "PASS: notice flag removed after the notice" || { echo "FAIL: flag still there"; FAIL=1; }
OUT="$(run)"; [ -z "$OUT" ] && echo "PASS: notice shown only once" || { echo "FAIL: shown twice [$OUT]"; FAIL=1; }

# Brand-new user: no legacy config at all, so no notice.
FRESH="$TMP/fresh"; mkdir -p "$FRESH"
OUT="$(HOME="$FRESH" run)"; RC=$?
[ $RC -eq 0 ] && [ -z "$OUT" ] && echo "PASS: brand-new user -> no notice, exit 0" || { echo "FAIL: brand-new user rc $RC out [$OUT]"; FAIL=1; }

printf '#!/usr/bin/env bash\necho "SWAPPED-MSG"\nexit 10\n' > "$STUB"
OUT="$(run)"; RC=$?
[ $RC -eq 10 ] && echo "PASS: exit 10 propagated" || { echo "FAIL: rc $RC"; FAIL=1; }
has "$OUT" "SWAPPED-MSG" "swap message printed"

# Swap with a pending notice: swap message first, then the notice saying the
# new command works after the restart.
PEND="$TMP/pending"; mkdir -p "$PEND/.brace"; touch "$PEND/.brace/.from-project-tracker"
OUT="$(HOME="$PEND" run)"; RC=$?
[ $RC -eq 10 ] && echo "PASS: swap + notice -> exit 10" || { echo "FAIL: swap+notice rc $RC"; FAIL=1; }
has "$OUT" "after the restart" "notice says it works after the restart on a swap"
case "$OUT" in "SWAPPED-MSG"*) echo "PASS: swap message comes first" ;; *) echo "FAIL: order [$OUT]"; FAIL=1 ;; esac
[ ! -f "$PEND/.brace/.from-project-tracker" ] && echo "PASS: flag removed after swap notice" || { echo "FAIL: flag kept after swap notice"; FAIL=1; }

exit $FAIL
