#!/usr/bin/env bash
# Replaces the old project-tracker plugin by brace in every tool found on
# this machine (Claude Code, Antigravity). Zero breakage: the old plugin is
# only removed once brace is installed in that tool. Exit codes:
#   10  something was replaced this run (one restart message printed);
#   11  an old plugin is still installed after this run (CLI missing, failed
#       or backed-off install, uninstall that did not take) -- projects must
#       not be moved while it can still be loaded. The user is told how to
#       remove it by hand, at most once a day;
#   0   no old plugin anywhere (silent).
# A project or local entry is replaced in place: brace is installed with the
# same scope in that project before the old entry goes, so a project's
# shared .claude/settings.json switches to brace for the whole team (the
# user is offered a commit). One whose project folder is gone is ignored:
# no session can load it any more.
# All CLI calls share one total wall-clock budget; a failed install backs
# off for hours. The swap helpers (budget, backoff marker, key format) live
# in bridge/hooks/swap_lib.sh, shared with the frozen project-tracker 0.14.0
# bridge. Bash 3.2 compatible; JSON via python3.
set -uo pipefail

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${BRACE_PLUGIN_ROOT:-$(dirname "$SELF_DIR")}"
. "$SELF_DIR/../bridge/hooks/swap_lib.sh" 2>/dev/null || exit 0
HOME_DIR="${HOME:-}"
WARN_FILE="${TMPDIR:-/tmp}/brace-swap-warned"
WARN_SECS="${BRACE_WARN_SECS:-86400}"
SWAPPED=""
SHARED=""
LEFT_IN=""
HOWTO=""

# --- Claude Code -----------------------------------------------------------
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME_DIR/.claude}"
INSTALLED="$CLAUDE_DIR/plugins/installed_plugins.json"

# old_entries: one line per old entry a session can still load:
# key<TAB>scope<TAB>projectPath (scope defaults to user; projectPath is empty
# for a user-scope entry). Project and local entries whose folder is gone
# are left out.
old_entries() {
  [ -f "$INSTALLED" ] || return 0
  python3 -c '
import json, os, sys
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
for k, v in plugins.items():
    if not k.startswith("project-tracker@"):
        continue
    entries = v if isinstance(v, list) and v else [{}]
    for e in entries:
        e = e if isinstance(e, dict) else {}
        scope = str(e.get("scope") or "user")
        path = str(e.get("projectPath") or "")
        if "\t" in k + scope + path or "\n" in k + scope + path:
            continue
        if scope != "user" and not (path and os.path.isdir(path)):
            continue
        print("%s\t%s\t%s" % (k, scope, path))
' "$INSTALLED" 2>/dev/null
}

# brace_at SCOPE PATH: true when brace is installed with that scope (and,
# for project/local, in that project).
brace_at() {
  python3 -c '
import json, sys
scope, path = sys.argv[2], sys.argv[3]
try:
    plugins = json.load(open(sys.argv[1])).get("plugins", {}) or {}
except Exception:
    plugins = {}
for k, v in plugins.items():
    if not k.startswith("brace@"):
        continue
    for e in (v if isinstance(v, list) and v else [{}]):
        e = e if isinstance(e, dict) else {}
        if str(e.get("scope") or "user") == scope and (scope == "user" or str(e.get("projectPath") or "") == path):
            sys.exit(0)
sys.exit(1)
' "$INSTALLED" "$1" "$2" 2>/dev/null
}

# in_dir DIR CMD...: run CMD from DIR (project/local scopes act on the
# project the CLI is started in).
in_dir() { local d="$1"; shift; cd "$d" 2>/dev/null && "$@"; }

ENTRIES="$(old_entries)"
if [ -n "$ENTRIES" ]; then
  OLD_KEY="$(printf '%s\n' "$ENTRIES" | sed -n '1p' | cut -f1)"
  HAS_BRACE="$(swap_keys "$INSTALLED" | sed -n '2p')"
  if command -v claude >/dev/null 2>&1; then
    if [ "$HAS_BRACE" != "1" ] && ! in_backoff; then
      bounded claude plugin marketplace update "${OLD_KEY#project-tracker@}" || true
      if bounded claude plugin install brace; then
        HAS_BRACE="$(swap_keys "$INSTALLED" | sed -n '2p')"
        [ "$HAS_BRACE" = "1" ] && clear_backoff || set_backoff
      else
        HAS_BRACE=0
        set_backoff
      fi
    fi
    if [ "$HAS_BRACE" = "1" ]; then
      TAB="$(printf '\t')"
      while IFS="$TAB" read -r key scope ppath; do
        [ -n "$key" ] || continue
        case "$scope" in
          user) bounded claude plugin uninstall "$key" --scope user || true ;;
          project|local)
            brace_at "$scope" "$ppath" || bounded in_dir "$ppath" claude plugin install brace --scope "$scope" || true
            brace_at "$scope" "$ppath" \
              && { bounded in_dir "$ppath" claude plugin uninstall "$key" --scope "$scope" || true; } ;;
        esac
      done <<EOT
$ENTRIES
EOT
      AFTER="$(old_entries)"
      while IFS="$TAB" read -r key scope ppath; do
        [ "$scope" = "project" ] || continue
        printf '%s\n' "$AFTER" | grep -qxF "$key$TAB$scope$TAB$ppath" && continue
        SHARED="${SHARED:+$SHARED, }$ppath"
      done <<EOT
$ENTRIES
EOT
      # Any entry removed counts as a swap (restart message); an entry that
      # stayed makes the run end with 11.
      [ "$(old_entries | grep -c .)" -lt "$(printf '%s\n' "$ENTRIES" | grep -c .)" ] && SWAPPED="Claude Code"
    fi
  fi
  if [ -n "$(old_entries)" ]; then
    LEFT_IN="Claude Code"
    HOWTO="in Claude Code, run /plugin install brace if it is missing, then /plugin uninstall project-tracker"
  fi
fi

# --- Antigravity -------------------------------------------------------------
AGY_PLUGINS="$HOME_DIR/.gemini/config/plugins"
OLD_AGY="$AGY_PLUGINS/project-tracker"
if [ -n "$HOME_DIR" ] && { [ -d "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; }; then
  AGY_READY=0
  if [ -f "$AGY_PLUGINS/brace/plugin.json" ]; then
    AGY_READY=1   # complete install already there: removal needs no agy
  elif command -v agy >/dev/null 2>&1 && ! in_backoff; then
    # A partial folder left by a failed install is never trusted.
    if bounded agy plugin install "$ROOT" \
       && [ -f "$AGY_PLUGINS/brace/plugin.json" ]; then
      AGY_READY=1
      clear_backoff
    else
      set_backoff
    fi
  fi
  if [ "$AGY_READY" = "1" ]; then
    # Never let agy uninstall walk into symlinks pointing at a repo.
    if command -v agy >/dev/null 2>&1 && [ ! -L "$OLD_AGY" ] \
       && [ -z "$(find "$OLD_AGY" -type l 2>/dev/null | head -1)" ]; then
      bounded agy plugin uninstall project-tracker || true
    fi
    # rm -rf removes symlinks themselves, never what they point to.
    { [ -e "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; } && rm -rf "$OLD_AGY"
    [ -L "$HOME_DIR/.gemini/config/skills/track" ] && rm -f "$HOME_DIR/.gemini/config/skills/track"
    if [ ! -e "$OLD_AGY" ] && [ ! -L "$OLD_AGY" ]; then
      SWAPPED="${SWAPPED:+$SWAPPED and }Antigravity"
    fi
  fi
  if [ -e "$OLD_AGY" ] || [ -L "$OLD_AGY" ]; then
    LEFT_IN="${LEFT_IN:+$LEFT_IN and }Antigravity"
    HOWTO="${HOWTO:+$HOWTO; }in a terminal, run agy plugin install https://github.com/doui445/brace if brace is missing from Antigravity, then agy plugin uninstall project-tracker"
  fi
fi

# A swap this run wins over 11: the restart message matters most, and the
# caller defers project moves on 10 as well.
if [ -n "$SWAPPED" ]; then
  echo "[BRACE] The old project-tracker plugin was replaced by BRACE in $SWAPPED. Tell the user now, in one line: restart Claude Code (and Antigravity) and close every other open session so they all run BRACE."
  [ -n "$SHARED" ] && echo "[BRACE] The shared .claude/settings.json of these projects now enables brace instead of project-tracker: $SHARED. Tell the user, and offer a commit in each (e.g. \"chore: switch the project plugin to brace\") under the usual rule: never commit without confirmation."
  exit 10
fi
if [ -n "$LEFT_IN" ]; then
  if ! swap_fresh "$WARN_FILE" "$WARN_SECS"; then
    : > "$WARN_FILE" 2>/dev/null || true
    echo "[BRACE] The old project-tracker plugin is still installed in $LEFT_IN, and BRACE could not remove it automatically (it retries every few hours). Tell the user now, in one or two lines, how to do it by hand: $HOWTO; then restart. Until then their projects stay on docs/project-tracker/, which keeps working."
  fi
  exit 11
fi
exit 0
