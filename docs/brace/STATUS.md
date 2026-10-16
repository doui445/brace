---
project: project-tracker
status: active
uses_git: true
repo: https://github.com/doui445/brace
stack: [Bash, Python, Markdown]
last_updated: 2026-10-16
next_milestone: "BRACE 1.1: brace:design"
reminders_list: "Project tracker"
category: "Skill Claude"
backlog_model: "adopté"
phase_model: "superpowers"
language: en
nested_model: "non"
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

1. **Before the 1.1 spec**: settle whether `design` and `brand` are one
   skill or two (open, see `BACKLOG.md`).
2. **Resume the DA brainstorm** (BRACE's own visual identity), in
   parallel, no plugin release needed.
3. **Write the `brace:design` spec** (BRACE 1.1). This machine now runs
   the published plugin from GitHub: test branches with
   `claude --plugin-dir .`.
