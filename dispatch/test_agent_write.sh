#!/usr/bin/env bash
# Tests for dispatch/agent_write.sh. Run: bash dispatch/test_agent_write.sh
set -uo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
FAIL=0
eq() { if [ "$1" = "$2" ]; then echo "PASS: $3"; else echo "FAIL: $3: expected [$2], got [$1]"; FAIL=1; fi; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"; mkdir -p "$HOME/.brace"
TMP="$(cd "$TMP" && pwd -P)"   # macOS /var -> /private/var

P="$TMP/my proj"                 # space on purpose
mkdir -p "$P/docs/brace/agents/analyst" "$P/docs/brace/agents/strategist" "$P/docs/brace/brand" "$TMP/elsewhere"
touch "$P/docs/brace/STATUS.md"
ln -s "$TMP/elsewhere" "$P/docs/brace/agents/analyst/out"
ln -s "$TMP/elsewhere" "$P/docs/brace/brand/out"
ln -s "$TMP/elsewhere/planted.plist" "$P/docs/brace/agents/analyst/dangling.md"
U="$TMP/untracked"; mkdir -p "$U/docs/brace/agents/analyst" "$U/docs/brace/brand"

check() { bash "$DIR/agent_write.sh" "$1" "$2" >"$TMP/out" 2>&1 && r=0 || r=1; eq "$r" "$3" "$4"; }

check brace:analyst "$P/docs/brace/agents/analyst/r.md" 0 "own folder -> allowed"
check brace:analyst "$P/docs/brace/agents/analyst/new/sub/r.md" 0 "subfolder not yet created -> allowed"
check brace:analyst "$P/docs/brace/agents/strategist/r.md" 1 "another agent's folder -> not allowed"
check brace:analyst "$P/docs/brace/brand/STRATEGY.md" 1 "brand file -> not allowed"
check brace:analyst "$P/docs/brace/agents/analyst/../../brand/x.md" 1 "dot-dot escape -> not allowed"
check brace:analyst "$P/docs/brace/agents/analyst/out/x.md" 1 "symlink out of the folder -> not allowed"
check brace:analyst "$P/docs/brace/agents/analyst" 1 "the folder itself -> not allowed"
check brace:analyst "$P/docs/brace/agents/analyst/dangling.md" 1 "dangling symlink out of the folder -> not allowed"
check brace:nobody "$P/docs/brace/agents/nobody/r.md" 1 "unknown BRACE agent -> not allowed"
check analyst "$P/docs/brace/agents/analyst/r.md" 1 "no brace: prefix -> not allowed"
check Explore "$P/docs/brace/agents/analyst/r.md" 1 "other agent type -> not allowed"
check "" "$P/docs/brace/agents/analyst/r.md" 1 "main conversation, an agent's folder -> not allowed"
check "" "$P/docs/brace/brand/SESSIONS.md" 0 "main conversation, brand folder -> allowed"
check "" "$P/docs/brace/brand/documents/2026-11-08-x.html" 0 "main conversation, brand subfolder -> allowed"
check "" "$P/docs/brace/agents/brand/2026-11-08-proposal.md" 0 "main conversation, agency folder -> allowed"
check "" "$P/docs/brace/STATUS.md" 1 "main conversation, tracking file -> not allowed"
check "" "$P/docs/brace/brand" 1 "main conversation, the folder itself -> not allowed"
check "" "$P/docs/brace/brand/out/x.md" 1 "main conversation, symlink out of brand -> not allowed"
check "" "$P/docs/brace/brand/../STATUS.md" 1 "main conversation, dot-dot out of brand -> not allowed"
check "" "$U/docs/brace/brand/x.md" 1 "main conversation, untracked project -> not allowed"
check "" "docs/brace/brand/x.md" 1 "main conversation, relative path -> not allowed"
check "" "$P/docs/brace/agents/strategist/fake/docs/brace/brand/x.md" 1 "main conversation, brand folder nested in an agent's folder -> not allowed"
check brace:analyst "$P/docs/brace/brand/x.md" 1 "an agent in the brand folder -> still not allowed"
check Explore "$P/docs/brace/brand/x.md" 1 "other agent type in brand -> not allowed"
check brace:analyst "$U/docs/brace/agents/analyst/r.md" 1 "untracked project -> not allowed"
check brace:analyst "docs/brace/agents/analyst/r.md" 1 "relative path -> not allowed"
# A fake tracked project nested in another agent's folder: the marker twice.
N="$P/docs/brace/agents/strategist/fake"; mkdir -p "$N/docs/brace/agents/analyst"; touch "$N/docs/brace/STATUS.md"
check brace:analyst "$N/docs/brace/agents/analyst/r.md" 1 "project nested in another agent's folder -> not allowed"
M="$P/docs/brace/agents/analyst/fake"; mkdir -p "$M/docs/brace/agents/analyst"; touch "$M/docs/brace/STATUS.md"
check brace:analyst "$M/docs/brace/agents/analyst/r.md" 1 "own marker twice in the path -> not allowed"
eq "$(cat "$TMP/out")" "" "prints nothing"

[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit $FAIL
