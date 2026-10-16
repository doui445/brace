#!/usr/bin/env bash
# project-tracker 0.14.0 -- the bridge. project-tracker is now BRACE; this
# hook only installs brace, then tells the user to restart. BRACE itself
# removes this plugin at its first start. Bash 3.2 compatible.
# CLI calls share one total wall-clock budget; a failed install backs off
# for hours and says so once (same marker as BRACE's own migration, so the
# two never double up). Frozen once released, with swap_lib.sh, which
# BRACE's dispatch/migrate_plugins.sh sources too.
set -uo pipefail
cat >/dev/null
command -v claude >/dev/null 2>&1 || exit 0
command -v python3 >/dev/null 2>&1 || exit 0
INSTALLED="${CLAUDE_CONFIG_DIR:-${HOME:-}/.claude}/plugins/installed_plugins.json"
[ -f "$INSTALLED" ] || exit 0

# Shared with BRACE's own migration (backoff marker, key format, budget).
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/swap_lib.sh" 2>/dev/null || exit 0

KEYS="$(swap_keys "$INSTALLED")"
OLD_KEY="$(printf '%s\n' "$KEYS" | sed -n '1p')"
[ "$(printf '%s\n' "$KEYS" | sed -n '2p')" = "1" ] && exit 0
in_backoff && exit 0
[ -n "$OLD_KEY" ] && { bounded claude plugin marketplace update "${OLD_KEY#project-tracker@}" || true; }
if bounded claude plugin install brace \
   && [ "$(swap_keys "$INSTALLED" | sed -n '2p')" = "1" ]; then
  clear_backoff
  echo "[project-tracker] project-tracker is now BRACE, and BRACE has just been installed. Tell the user now, in one line: restart Claude Code and close every other open session to start using BRACE."
else
  # Printed only on a run that tried: the backoff keeps the next runs silent.
  set_backoff
  echo "[project-tracker] project-tracker is now BRACE, but BRACE could not be installed automatically. Tell the user now, in one line: run /plugin install brace to install it (or it will be retried automatically in a few hours)."
fi
exit 0
