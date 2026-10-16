#!/usr/bin/env bash
# BRACE adapter -- Antigravity PreInvocation. The hook fires before every
# model call; only the first one of each conversation runs the dispatcher
# (remembered by conversation id: invocationNum starts at 0 in Antigravity
# 1.3, at 1 in older notes, so the number alone is not trusted). That call
# is passed on as BRACE_SOURCE=startup (a new conversation; machine.sh only
# falls back on it when it cannot read when Antigravity itself started).
# Prints {"injectSteps": [...]} or {}.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$(cat)"
PARSED="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
d = json.load(sys.stdin)
paths = d.get("workspacePaths") or []
print(d.get("invocationNum", 0)); print(paths[0] if paths else ""); print(d.get("conversationId", ""))
' 2>/dev/null)" || { echo "{}"; exit 0; }
NUM="$(printf '%s\n' "$PARSED" | sed -n '1p')"
CONV="$(printf '%s\n' "$PARSED" | sed -n '3p')"
case "$CONV" in
  ""|*[!A-Za-z0-9._-]*|.*)
    # No usable id: fall back on the number (0 or 1 is a first call).
    case "$NUM" in 0|1) ;; *) echo "{}"; exit 0 ;; esac ;;
  *)
    SEEN="${TMPDIR:-/tmp}/brace-agy-conversations"
    mkdir -p "$SEEN" 2>/dev/null
    [ -e "$SEEN/$CONV" ] && { echo "{}"; exit 0; }
    : > "$SEEN/$CONV" 2>/dev/null ;;
esac
OUT="$(BRACE_TOOL=antigravity \
  BRACE_PLUGIN_ROOT="$(cd "$DIR/../.." && pwd)" \
  BRACE_CWD="$(printf '%s\n' "$PARSED" | sed -n '2p')" \
  BRACE_SESSION="$(printf '%s\n' "$PARSED" | sed -n '3p')" \
  BRACE_SOURCE=startup \
  bash "$DIR/../run.sh" session_start 2>/dev/null)"
if [ -z "$OUT" ]; then echo "{}"; exit 0; fi
python3 -c '
import json, sys
print(json.dumps({"injectSteps": [{"ephemeralMessage": sys.argv[1]}]}))
' "$OUT"
exit 0
