#!/usr/bin/env bash
# BRACE -- may this agent write this file without a permission prompt?
# Usage: agent_write.sh <agent_type> <file_path>
# Exit 0 only when the resolved path sits in a tracked project (one with
# docs/brace/STATUS.md) and either:
#  - agent_type is brace:<name>, agents/<name>.md ships in the plugin, and
#    the path is inside <project>/docs/brace/agents/<name>/; or
#  - agent_type is empty (the main conversation, where the brand skill's
#    account director speaks) and the path is inside
#    <project>/docs/brace/brand/ or <project>/docs/brace/agents/brand/,
#    the agency's own folders, which nothing else writes.
# Exit 1 otherwise, and on any error. Prints nothing. Used by the Claude
# Code PreToolUse adapter. Bash 3.2 compatible.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${BRACE_PLUGIN_ROOT:=$(dirname "$DIR")}"

TYPE="${1:-}"
FILE="${2:-}"
case "$TYPE" in
  "") NAME="" ;;
  brace:*) NAME="${TYPE#brace:}"
    case "$NAME" in ""|*[!a-z-]*|-*) exit 1 ;; esac
    [ -f "$BRACE_PLUGIN_ROOT/agents/$NAME.md" ] || exit 1 ;;
  *) exit 1 ;;
esac
case "$FILE" in /*) ;; *) exit 1 ;; esac

python3 - "$NAME" "$FILE" <<'EOF' >/dev/null 2>&1
import os, sys
name, path = sys.argv[1], sys.argv[2]
if any(c in path for c in "\n\r\0") or any(part == ".." for part in path.split("/")):
    sys.exit(1)
# Follows every symlink, dangling ones included; missing parts are kept.
real = os.path.realpath(path)
# The main conversation (no name) writes in the agency's folders; an agent
# only in its own.
markers = ["/docs/brace/brand/", "/docs/brace/agents/brand/"] if not name else ["/docs/brace/agents/" + name + "/"]
# One docs/brace folder in the path, never a project nested inside another.
if real.count("/docs/brace/") != 1:
    sys.exit(1)
for marker in markers:
    i = real.find(marker)
    if i > 0 and not real.endswith("/") and len(real) > i + len(marker):
        break
else:
    sys.exit(1)
root = real[:i]
if not os.path.isfile(os.path.join(root, "docs", "brace", "STATUS.md")):
    sys.exit(1)
sys.exit(0)
EOF
