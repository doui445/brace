---
project: project-tracker
status: active
uses_git: true
repo: https://github.com/doui445/brace
stack: [Bash, Python, Markdown]
last_updated: 2026-10-20
next_milestone: "BRACE 1.1: brace:brand"
reminders_list: "Project tracker"
category: "Skill Claude"
backlog_model: "adopté"
phase_model: "superpowers"
language: en
nested_model: "non"
brand_profile: product
brand_stage: test
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

### Known gaps

- A tool session left open since before the swap keeps the old plugin
  loaded; the restart message asks to close them, and the "both folders"
  guard covers a miss.

## Next 3 actions

1. **Finish checking `feat/brand`** (`brace:brand` + the `analyst` agent,
   built and reviewed 2026-10-19, suite green, not merged; Antigravity
   check done: one agent loaded, it starts). The first real session (on
   BRACE itself, 2026-10-20) found three defects to fix first (top of
   `BACKLOG.md`). Then merge. 1.2 brings the brand's face (logo, palette, type) in
   `brand` plus `brace:design` (see `DECISIONS.md`). Test branches with
   `claude --plugin-dir .`.
2. **1.1 riders**, each with a mini-spec: keep the Antigravity copy up to
   date; tidy a bloated `AGENTS.md` (both in `BACKLOG.md`). Then release
   1.1.0.
3. **Finish `/brace:brand` on BRACE itself**: foundations and strategy
   written (`docs/brace/brand/`); voice and test left.
