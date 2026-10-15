#!/usr/bin/env bash
# BRACE machine-level checks, run by dispatch/run.sh at every session start
# before the skills: (1) replace any old project-tracker plugin, (2) move
# the config to ~/.brace (once), (3) the one-time "you're on BRACE"
# notice. Silent when there is nothing to do.
# Exit 10 when a plugin was replaced this run (restart message), 11 when
# project folders must wait anyway (silent): an old plugin is still
# installed, or a swap is pending and this is not a fresh start -- /clear,
# /compact or /resume re-fire SessionStart in a process that may still run
# the old plugin's hooks. ~/.brace/.swap-pending records a swap until a
# genuine fresh start (BRACE_SOURCE=startup) finds no old plugin left.
# Bash 3.2 compatible.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

P_OUT="$(bash "${BRACE_PLUGINS_SCRIPT:-$DIR/migrate_plugins.sh}" 2>/dev/null)"
P_RC=$?
bash "$DIR/migrate_config.sh" >/dev/null 2>&1 || true

[ -n "$P_OUT" ] && printf '%s\n' "$P_OUT"

DEFER=0
case "$P_RC" in 10|11) DEFER=1 ;; esac
if [ -n "${HOME:-}" ]; then
  PENDING="$HOME/.brace/.swap-pending"
  if [ "$P_RC" -eq 10 ]; then
    mkdir -p "$HOME/.brace" 2>/dev/null && : > "$PENDING" 2>/dev/null
  elif [ -f "$PENDING" ]; then
    if [ "${BRACE_SOURCE:-}" = "startup" ] && [ "$P_RC" -eq 0 ]; then
      rm -f "$PENDING"
    else
      DEFER=1
    fi
  fi
fi

# The notice is skipped when HOME is unset (never touch "/.brace").
if [ -n "${HOME:-}" ]; then
  FLAG="$HOME/.brace/.from-project-tracker"
  if [ -f "$FLAG" ]; then
    # A plugin just swapped: the new commands only work after the restart.
    SUFFIX=""
    [ "$P_RC" -eq 10 ] && SUFFIX=" (after the restart)"
    echo "[BRACE] Tell the user once, in one line: project-tracker is now BRACE, and its commands changed — /project-tracker:config is now /brace:config, and the skill is brace:track${SUFFIX}."
    rm -f "$FLAG"
  fi
fi

[ "$P_RC" -eq 10 ] && exit 10
[ "$DEFER" -eq 1 ] && exit 11
exit 0
