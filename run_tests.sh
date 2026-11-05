#!/usr/bin/env bash
# Runs the whole BRACE test suite from the repo root. Exit 1 on any failure.
set -uo pipefail
cd "$(dirname "$0")"
FAIL=0
run() { echo "== $*"; "$@" || FAIL=1; }
run python3 -m unittest test_plugin_manifest
run python3 -m unittest discover -s skills/track/scripts -p 'test_*.py'
run python3 -m unittest discover -s skills/brand -p 'test_*.py'
run python3 -m unittest discover -s skills/brand/scripts -p 'test_*.py'
for t in dispatch/test_*.sh skills/*/hooks/test_*.sh skills/*/scripts/test_*.sh bridge/hooks/test_*.sh; do
  [ -f "$t" ] || continue
  run bash "$t"
done
[ "$FAIL" -eq 0 ] && echo "ALL TESTS PASSED" || echo "SOME TESTS FAILED"
exit $FAIL
