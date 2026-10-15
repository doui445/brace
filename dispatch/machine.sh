#!/usr/bin/env bash
# BRACE machine-level checks, run by dispatch/run.sh at every session start
# before the skills: (1) replace any old project-tracker plugin, (2) move
# the config to ~/.brace (once), (3) the one-time "you're on BRACE"
# notice. Silent when there is nothing to do. Exit 10 when a plugin was
# replaced this session (project folders then wait for the next session).
# Bash 3.2 compatible.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

P_OUT="$(bash "${BRACE_PLUGINS_SCRIPT:-$DIR/migrate_plugins.sh}" 2>/dev/null)"
P_RC=$?
bash "$DIR/migrate_config.sh" >/dev/null 2>&1 || true

[ -n "$P_OUT" ] && printf '%s\n' "$P_OUT"

FLAG="$HOME/.brace/.from-project-tracker"
if [ -f "$FLAG" ]; then
  echo "[BRACE] Tell the user once, in one line: project-tracker is now BRACE, and its commands changed — /project-tracker:config is now /brace:config, and the skill is brace:track."
  rm -f "$FLAG"
fi

[ "$P_RC" -eq 10 ] && exit 10
exit 0
