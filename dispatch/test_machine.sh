#!/usr/bin/env bash
# Tests for dispatch/machine.sh. Run: bash dispatch/test_machine.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
has() { case "$1" in *"$2"*) echo "PASS: $3" ;; *) echo "FAIL: $3: missing [$2] in [$1]"; FAIL=1 ;; esac; }
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


# Swap pending: written on a swap, honoured until a session whose host
# process started after the swap finds no old plugin left.
age() { python3 -c 'import os, sys, time; t = time.time() - float(sys.argv[2]); os.utime(sys.argv[1], (t, t))' "$1" "$2"; }
NOW="$(python3 -c 'import time; print(int(time.time()))')"
SP="$TMP/sp"; mkdir -p "$SP"
OUT="$(HOME="$SP" run)"; RC=$?
[ $RC -eq 10 ] && [ -f "$SP/.brace/.swap-pending" ] && echo "PASS: swap -> .swap-pending written (~/.brace created)" || { echo "FAIL: pending not written rc $RC"; FAIL=1; }
printf '#!/usr/bin/env bash\nexit 0\n' > "$STUB"
age "$SP/.brace/.swap-pending" 600
for SRC in startup clear compact resume ""; do
  OUT="$(HOME="$SP" BRACE_SOURCE="$SRC" BRACE_HOST_START=$((NOW - 3600)) run)"; RC=$?
  [ $RC -eq 11 ] && [ -z "$OUT" ] && [ -f "$SP/.brace/.swap-pending" ] && echo "PASS: host older than the swap, source [$SRC] -> exit 11, silent, kept" || { echo "FAIL: old host source [$SRC] rc $RC out [$OUT]"; FAIL=1; }
done
printf '#!/usr/bin/env bash\nexit 11\n' > "$STUB"
OUT="$(HOME="$SP" BRACE_HOST_START="$NOW" run)"; RC=$?
[ $RC -eq 11 ] && [ -z "$OUT" ] && [ -f "$SP/.brace/.swap-pending" ] && echo "PASS: restarted host but old plugin left -> exit 11, pending kept" || { echo "FAIL: restarted+11 rc $RC"; FAIL=1; }
printf '#!/usr/bin/env bash\nexit 0\n' > "$STUB"
OUT="$(HOME="$SP" BRACE_SOURCE=clear BRACE_HOST_START="$NOW" run)"; RC=$?
[ $RC -eq 0 ] && [ ! -f "$SP/.brace/.swap-pending" ] && echo "PASS: host started after the swap, nothing old -> exit 0, pending cleared (whatever the source)" || { echo "FAIL: restarted host clear rc $RC"; FAIL=1; }
OUT="$(HOME="$SP" BRACE_SOURCE=clear run)"; RC=$?
[ $RC -eq 0 ] && echo "PASS: no pending -> /clear exits 0" || { echo "FAIL: clear without pending rc $RC"; FAIL=1; }

# Real host lookup: python3 stands in for the tool. Started after the swap
# -> settled; the same host for a swap made after it started -> kept.
host_run() { PATH="$SAFE_BIN:/usr/bin:/bin" HOME="$1" BRACE_PLUGINS_SCRIPT="$STUB" python3 -c 'import subprocess, sys; sys.exit(subprocess.call(["/bin/bash", sys.argv[1]]))' "$DIR/machine.sh"; }
mkdir -p "$SP/.brace"; : > "$SP/.brace/.swap-pending"; age "$SP/.brace/.swap-pending" 60
OUT="$(host_run "$SP")"; RC=$?
[ $RC -eq 0 ] && [ ! -f "$SP/.brace/.swap-pending" ] && echo "PASS: real lookup, host newer than the swap -> cleared" || { echo "FAIL: real lookup newer rc $RC"; FAIL=1; }
: > "$SP/.brace/.swap-pending"; touch -t 203001010000 "$SP/.brace/.swap-pending"
OUT="$(host_run "$SP")"; RC=$?
[ $RC -eq 11 ] && [ -f "$SP/.brace/.swap-pending" ] && echo "PASS: real lookup, host older than the swap -> kept" || { echo "FAIL: real lookup older rc $RC"; FAIL=1; }

# No readable process list: a fresh start (BRACE_SOURCE=startup) counts.
NOPS="$TMP/nops"; mkdir -p "$NOPS"; ln -s "$PY" "$NOPS/python3"
printf '#!/bin/sh\nexit 1\n' > "$NOPS/ps"; chmod +x "$NOPS/ps"
: > "$SP/.brace/.swap-pending"; age "$SP/.brace/.swap-pending" 60
OUT="$(PATH="$NOPS:/usr/bin:/bin" HOME="$SP" BRACE_SOURCE=clear BRACE_PLUGINS_SCRIPT="$STUB" /bin/bash "$DIR/machine.sh")"; RC=$?
[ $RC -eq 11 ] && [ -f "$SP/.brace/.swap-pending" ] && echo "PASS: no ps, /clear -> kept" || { echo "FAIL: no ps clear rc $RC"; FAIL=1; }
OUT="$(PATH="$NOPS:/usr/bin:/bin" HOME="$SP" BRACE_SOURCE=startup BRACE_PLUGINS_SCRIPT="$STUB" /bin/bash "$DIR/machine.sh")"; RC=$?
[ $RC -eq 0 ] && [ ! -f "$SP/.brace/.swap-pending" ] && echo "PASS: no ps, startup -> cleared" || { echo "FAIL: no ps startup rc $RC"; FAIL=1; }

# A week-old swap is settled even if the host looks older.
: > "$SP/.brace/.swap-pending"; age "$SP/.brace/.swap-pending" 700000
OUT="$(HOME="$SP" BRACE_HOST_START=$((NOW - 800000)) run)"; RC=$?
[ $RC -eq 0 ] && [ ! -f "$SP/.brace/.swap-pending" ] && echo "PASS: week-old swap -> cleared" || { echo "FAIL: week-old rc $RC"; FAIL=1; }

# Old plugin still installed, no swap: silent exit 11, no pending written.
NP="$TMP/np"; mkdir -p "$NP"
printf '#!/usr/bin/env bash\nexit 11\n' > "$STUB"
OUT="$(HOME="$NP" BRACE_SOURCE=startup run)"; RC=$?
[ $RC -eq 11 ] && [ -z "$OUT" ] && [ ! -e "$NP/.brace/.swap-pending" ] && echo "PASS: old plugin left -> exit 11, silent, no pending" || { echo "FAIL: rc $RC out [$OUT]"; FAIL=1; }

exit $FAIL
