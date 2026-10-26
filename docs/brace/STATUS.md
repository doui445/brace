---
project: project-tracker
status: active
uses_git: true
repo: https://github.com/doui445/brace
stack: [Bash, Python, Markdown]
last_updated: 2026-10-26
next_milestone: "BRACE 1.1: brace:brand"
reminders_list: "Project tracker"
category: "Skill Claude"
backlog_model: "adopté"
phase_model: "superpowers"
language: en
nested_model: "non"
brand_profile: product
brand_stage: done
brand_reviewed: 2026-10-22
---

# STATUS — BRACE

## Where it stands

**BRACE 1.0.0** (2026-10-16, published): `project-tracker` renamed BRACE, with the
foundation later skills plug into. One plugin for Claude Code and
Antigravity, installed the official way in both (the repo root carries
both manifests).

- **Hooks**: one dispatcher per event (`dispatch/run.sh`) behind a thin
  adapter per tool; each skill drops `skills/<skill>/hooks/<event>.sh`.
- **Config** in `~/.brace/`; projects in `docs/brace/` (the old
  `docs/project-tracker/` stays recognised for good).
- **Automatic move from project-tracker**: the 0.14.0 bridge installs
  brace; BRACE then replaces the old plugin in every tool, moves the
  config, and moves each project's folder at its first session after a
  real restart of the tool (detected from the tool process's start time).
  A plugin installed for one project is replaced in place (commit offered);
  an old plugin that cannot be removed brings manual steps, once a day.
- **Verified for real**: install from the repo in an isolated Claude Code
  config; the hook firing in a real Claude Code session; the bridge end to
  end (install, swap, deferred then completed project move); a
  project-scope swap with the real CLI; Antigravity 1.3 on this machine.
- Full suite green (`bash run_tests.sh`).

**On `feat/brand`, not merged (BRACE 1.1)**: `brace:brand` runs as an
agency. A workshop on a brief BRACE pre-fills, four agents working in the
background (`analyst`, `strategist`, `copywriter`, `creative-director`),
a strategic presentation as a local HTML deck, adjustments validated one
rendered document at a time, a delivery page. Agents write in their own
folder without a prompt (a hook, tested for real on Claude Code); a macOS
notification says when a presentation is ready. Whole-branch review
done, its critical and important findings fixed; suite green.

### Known gaps

- A tool session left open since before the swap keeps the old plugin
  loaded; the restart message asks to close them, and the "both folders"
  guard covers a miss.

## Next 3 actions

1. **Real trial of the brand agency** (postponed by the owner) on `feat/brand`: a
   throwaway project, `claude --plugin-dir .`, one mission up to the
   strategic presentation. Check: no permission prompt during the
   background work, the notification arrives, the presentation reads
   well, how many questions the workshop asks. Then the same on
   Antigravity (`agy plugin install "$PWD"` in a throwaway config). Gaps
   become tasks before the release.
2. **Merge and release 1.1.0**, with the 1.1 riders if they fit (keep the
   Antigravity copy up to date, tidy a bloated `AGENTS.md`, both in
   `BACKLOG.md`). 1.2 brings the brand's face (logo, palette, type) in
   `brand` plus `brace:design` (see `DECISIONS.md`).
3. **BRACE's own brand** (`docs/brace/brand/`, written 2026-10-22, kept as
   is): run the preference and comprehension test with real people, the
   results go to `docs/brace/brand/DECISIONS.md`. The README still drifts
   from the voice (long dashes, slashes in prose): left as is by the
   owner, to revisit. Rename the repo folder to `brace` with every tool
   closed (`BACKLOG.md`).
