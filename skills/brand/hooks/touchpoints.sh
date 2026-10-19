#!/usr/bin/env bash
# BRACE brand -- shared helper, sourced by the brand hooks, never run
# directly. Bash 3.2 compatible.

# brand_touchpoints <STRATEGY.md> <plugin root>
# Prints the repo-relative paths written in backticks under the Touchpoints
# section of STRATEGY.md, one per line ("./" stripped). The heading text is
# read from the i18n catalogues (any language), and matched leniently: any
# heading level from 2, an optional "9." number, extra spaces, any case,
# and a trailing "(...)" are accepted. The section runs until the next
# heading of the same or a higher level. Prints nothing on any error.
brand_touchpoints() {
  local strategy="$1" root="$2" headings
  [ -f "$strategy" ] || return 0
  headings="$(sed -n 's/^- brand\.strategy\.heading\.touchpoints: //p' "$root"/skills/track/references/i18n/*.md 2>/dev/null)"
  [ -n "$headings" ] || return 0
  HS="$headings" awk '
    function norm(t) {
      t = tolower(t)
      sub(/^[ \t]+/, "", t); sub(/[ \t]+$/, "", t)
      sub(/^[0-9]+[.)][ \t]*/, "", t)
      sub(/[ \t]*\(.*\)$/, "", t)
      gsub(/[ \t]+/, " ", t)
      return t
    }
    BEGIN { n = split(ENVIRON["HS"], H, "\n"); for (i = 1; i <= n; i++) H[i] = norm(H[i]) }
    { gsub(/\r/, "") }
    /^#+[ \t]/ {
      lvl = match($0, /[^#]/) - 1
      if (insec && lvl <= seclvl) insec = 0
      if (!insec && lvl >= 2) {
        t = norm(substr($0, lvl + 1))
        for (i = 1; i <= n; i++) if (t == H[i]) { insec = 1; seclvl = lvl }
      }
      next
    }
    insec {
      s = $0
      while (match(s, /`[^`]+`/)) {
        p = substr(s, RSTART + 1, RLENGTH - 2); sub(/^\.\//, "", p); print p
        s = substr(s, RSTART + RLENGTH)
      }
    }
  ' "$strategy" 2>/dev/null
  return 0
}
