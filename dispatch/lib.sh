#!/usr/bin/env bash
# BRACE shared hook helpers. Sourced by the dispatcher and the skills'
# hook scripts, never executed directly. Bash 3.2 compatible.

brace_config_dir() { printf '%s\n' "$HOME/.brace"; }

# Strips a trailing slash and expands a leading ~.
brace__expand() {
  local p="$1"
  [ "$p" = "/" ] || p="${p%/}"
  case "$p" in
    "~"|"~/"*) p="${HOME}${p#\~}" ;;
  esac
  printf '%s\n' "$p"
}

# Prints the scope root (from scopes.txt) containing $1, or nothing.
brace_scope_root() {
  local path scopes line
  path="$(brace__expand "$1")"
  scopes="$(brace_config_dir)/scopes.txt"
  [ -f "$scopes" ] || return 0
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in ""|"#"*) continue ;; esac
    line="$(brace__expand "$line")"
    case "$path" in
      "$line"|"$line"/*) printf '%s\n' "$line"; return 0 ;;
    esac
  done < "$scopes"
  return 0
}

# Returns 0 when $1 is excluded by trackignore.txt. An entry equal to a
# scope root excludes only that exact folder, not the projects inside it.
brace_is_ignored() {
  local path cfg ignore scopes entry scope is_root
  path="$(brace__expand "$1")"
  cfg="$(brace_config_dir)"
  ignore="$cfg/trackignore.txt"
  scopes="$cfg/scopes.txt"
  [ -f "$ignore" ] || return 1
  while IFS= read -r entry || [ -n "$entry" ]; do
    case "$entry" in ""|"#"*) continue ;; esac
    entry="$(brace__expand "$entry")"
    is_root=0
    if [ -f "$scopes" ]; then
      while IFS= read -r scope || [ -n "$scope" ]; do
        case "$scope" in ""|"#"*) continue ;; esac
        if [ "$(brace__expand "$scope")" = "$entry" ]; then is_root=1; break; fi
      done < "$scopes"
    fi
    if [ "$is_root" -eq 1 ]; then
      [ "$path" = "$entry" ] && return 0
    else
      case "$path" in "$entry"|"$entry"/*) return 0 ;; esac
    fi
  done < "$ignore"
  return 1
}

# Prints the project's tracking folder, relative to its root: docs/brace,
# else the legacy docs/project-tracker (recognised for good), else nothing.
brace_tracking_dir() {
  if [ -f "$1/docs/brace/STATUS.md" ]; then
    printf 'docs/brace\n'
  elif [ -f "$1/docs/project-tracker/STATUS.md" ]; then
    printf 'docs/project-tracker\n'
  fi
  return 0
}

# Walks up from $1 to $2 (inclusive, or /) and prints the first folder
# that has a tracking folder, or nothing.
brace_find_project() {
  local dir stop parent
  dir="$(brace__expand "$1")"
  stop="$(brace__expand "$2")"
  [ -n "$dir" ] || return 0
  while :; do
    if [ -n "$(brace_tracking_dir "$dir")" ]; then
      printf '%s\n' "$dir"
      return 0
    fi
    [ "$dir" = "$stop" ] && return 0
    parent="$(dirname "$dir")"
    # dirname stops changing at "/" and at "." (relative paths): stop there.
    [ "$parent" = "$dir" ] && return 0
    dir="$parent"
  done
}
