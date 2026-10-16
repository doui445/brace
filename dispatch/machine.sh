#!/usr/bin/env bash
# BRACE machine-level checks, run by dispatch/run.sh at every session start
# before the skills: (1) replace any old project-tracker plugin, (2) move
# the config to ~/.brace (once), (3) the one-time "you're on BRACE"
# notice. Silent when there is nothing to do.
# Exit 10 when a plugin was replaced this run (restart message), 11 when
# project folders must wait anyway: an old plugin is still installed, or a
# swap is pending and the tool was not restarted since -- /clear, /compact,
# /resume or a new Antigravity conversation run in a process that may still
# hold the old plugin. ~/.brace/.swap-pending records the swap (its mtime)
# until a session whose host process (the tool running the hook) started
# after it finds no old plugin left. Without a readable host process, a
# fresh start (BRACE_SOURCE=startup) counts instead; a week-old swap is
# settled anyway. Bash 3.2 compatible.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

P_OUT="$(bash "${BRACE_PLUGINS_SCRIPT:-$DIR/migrate_plugins.sh}" 2>/dev/null)"
P_RC=$?
bash "$DIR/migrate_config.sh" >/dev/null 2>&1 || true

[ -n "$P_OUT" ] && printf '%s\n' "$P_OUT"

# swap_settled MARKER: true when the swap MARKER records can no longer be
# loaded by the process running this hook. The host is the first ancestor
# that is not a shell; BRACE_HOST_START (epoch seconds) overrides it.
swap_settled() {
  python3 -c '
import os, subprocess, sys, time
marker, pid, source = sys.argv[1], int(sys.argv[2]), sys.argv[3]
max_age = float(os.environ.get("BRACE_PENDING_MAX_SECS") or 604800)
try:
    swapped = os.path.getmtime(marker)
except OSError:
    sys.exit(0)
if time.time() - swapped > max_age:
    sys.exit(0)

def etime(s):
    days, _, s = s.rpartition("-")
    parts = [int(x) for x in s.split(":")]
    while len(parts) < 3:
        parts.insert(0, 0)
    return int(days or 0) * 86400 + parts[0] * 3600 + parts[1] * 60 + parts[2]

start = os.environ.get("BRACE_HOST_START")
if not start:
    try:
        out = subprocess.run(["ps", "-A", "-o", "pid=,ppid=,etime=,comm="],
                             capture_output=True, text=True, timeout=5).stdout
        procs = {}
        for line in out.splitlines():
            f = line.split(None, 3)
            if len(f) == 4:
                procs[int(f[0])] = (int(f[1]), f[2], f[3])
        shells = {"bash", "sh", "zsh", "dash", "ksh", "fish", "env"}
        for _ in range(50):
            if pid not in procs:
                break
            ppid, et, comm = procs[pid]
            if os.path.basename(comm.strip()).lstrip("-") not in shells:
                start = time.time() - etime(et)
                break
            pid = ppid
    except Exception:
        start = None
if start:
    sys.exit(0 if float(start) > swapped + 2 else 1)
sys.exit(0 if source == "startup" else 1)
' "$1" "$$" "${BRACE_SOURCE:-}" 2>/dev/null
}

DEFER=0
case "$P_RC" in 10|11) DEFER=1 ;; esac
if [ -n "${HOME:-}" ]; then
  PENDING="$HOME/.brace/.swap-pending"
  if [ "$P_RC" -eq 10 ]; then
    mkdir -p "$HOME/.brace" 2>/dev/null && : > "$PENDING" 2>/dev/null
  elif [ -f "$PENDING" ]; then
    if [ "$P_RC" -eq 0 ] && swap_settled "$PENDING"; then
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
    echo "[BRACE] Tell the user once, in one line: project-tracker is now BRACE, and its commands changed: /project-tracker:config is now /brace:config, and the skill is brace:track${SUFFIX}."
    rm -f "$FLAG"
  fi
fi

[ "$P_RC" -eq 10 ] && exit 10
[ "$DEFER" -eq 1 ] && exit 11
exit 0
