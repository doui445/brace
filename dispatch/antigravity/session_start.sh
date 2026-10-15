#!/usr/bin/env bash
# BRACE adapter -- Antigravity PreInvocation. Only the first invocation of a
# conversation counts. Prints {"injectSteps": [...]} or {}.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
paths = d.get("workspacePaths") or []
print(d.get("invocationNum", 1)); print(paths[0] if paths else ""); print(d.get("conversationId", ""))
' 2>/dev/null)" || { echo "{}"; exit 0; }
[ "$(printf '%s\n' "$PARSED" | sed -n '1p')" = "1" ] || { echo "{}"; exit 0; }
OUT="$(BRACE_TOOL=antigravity \
  BRACE_PLUGIN_ROOT="$(cd "$DIR/../.." && pwd)" \
  BRACE_CWD="$(printf '%s\n' "$PARSED" | sed -n '2p')" \
  BRACE_SESSION="$(printf '%s\n' "$PARSED" | sed -n '3p')" \
  bash "$DIR/../run.sh" session_start)"
if [ -z "$OUT" ]; then echo "{}"; exit 0; fi
python3 -c '
import json, sys
print(json.dumps({"injectSteps": [{"ephemeralMessage": sys.argv[1]}]}))
' "$OUT"
exit 0
