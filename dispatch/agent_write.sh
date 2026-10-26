#!/usr/bin/env bash
# BRACE -- may this agent write this file without a permission prompt?
# Usage: agent_write.sh <agent_type> <file_path>
# Exit 0 only when agent_type is brace:<name>, agents/<name>.md ships in
# the plugin, and the resolved path sits inside
# <project>/docs/brace/agents/<name>/ of a tracked project (one with
# docs/brace/STATUS.md). Exit 1 otherwise, and on any error. Prints
# nothing. Used by the Claude Code PreToolUse adapter. Bash 3.2 compatible.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${BRACE_PLUGIN_ROOT:=$(dirname "$DIR")}"

TYPE="${1:-}"
FILE="${2:-}"
case "$TYPE" in brace:*) NAME="${TYPE#brace:}" ;; *) exit 1 ;; esac
case "$NAME" in ""|*[!a-z-]*|-*) exit 1 ;; esac
[ -f "$BRACE_PLUGIN_ROOT/agents/$NAME.md" ] || exit 1
case "$FILE" in /*) ;; *) exit 1 ;; esac

python3 - "$NAME" "$FILE" <<'EOF' >/dev/null 2>&1
import os, sys
name, path = sys.argv[1], sys.argv[2]
if any(c in path for c in "\n\r\0") or any(part == ".." for part in path.split("/")):
    sys.exit(1)
# Follows every symlink, dangling ones included; missing parts are kept.
real = os.path.realpath(path)
marker = "/docs/brace/agents/" + name + "/"
i = real.rfind(marker)
if i <= 0 or real.endswith("/") or len(real) == i + len(marker):
    sys.exit(1)
root = real[:i]
if not os.path.isfile(os.path.join(root, "docs", "brace", "STATUS.md")):
    sys.exit(1)
sys.exit(0)
EOF
