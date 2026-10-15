#!/usr/bin/env bash
# Runs the whole BRACE test suite from the repo root. Exit 1 on any failure.
set -uo pipefail
cd "$(dirname "$0")"
FAIL=0
run() { echo "== $*"; "$@" || FAIL=1; }
run python3 -m unittest test_plugin_manifest
run python3 -m unittest discover -s skills/track/scripts -p 'test_*.py'
for t in dispatch/test_*.sh skills/track/hooks/test_*.sh skills/track/scripts/test_*.sh bridge/hooks/test_*.sh; do
  run bash "$t"
done
[ "$FAIL" -eq 0 ] && echo "ALL TESTS PASSED" || echo "SOME TESTS FAILED"
exit $FAIL
