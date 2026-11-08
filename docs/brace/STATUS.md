---
project: brace
status: active
uses_git: true
repo: https://github.com/doui445/brace
stack: [Bash, Python, Markdown]
last_updated: 2026-11-08
next_milestone: "BRACE 1.2: the brand's face in brace:brand"
reminders_list: "Project tracker"
category: "Skill Claude"
backlog_model: "adopté"
phase_model: "superpowers"
language: en
nested_model: "non"
brand_profile: product
brand_stage: done
brand_reviewed: 2026-11-08
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

**BRACE 1.1.0** (2026-11-08): `brace:brand` runs as an agency. A named
team of four agents (`analyst`, `strategist`, `copywriter`,
`creative-director`) behind an account director; a proposal whose scope
follows from the brand work the client already has; meetings in five
parts with minutes and appointments; client documents and decks rendered
by a script; a tabbed client space with a root shortcut during the
mission and a "Brand" link on the portfolio card. Tried for real on
BRACE's own rebrand (delivered 2026-11-08, review 2027-05-10), then a fix
pass from that trial, reviewed and checked in a headless browser.

### Known gaps

- A tool session left open since before the swap keeps the old plugin
  loaded; the restart message asks to close them, and the "both folders"
  guard covers a miss.

## Next 3 actions

1. **Publish 1.1.0** (owner's yes): push `main` and the tag, then set the
   GitHub description and topics and publish the announcement.
2. **Next real trial** on a dogfood project, on 1.1.0: check in auto mode
   that a write in `brand/` no longer prompts, the agency's voice and
   five-part meetings, the scope from existing documents; measure the
   quota with `/usage` before and after.
3. **1.2: the brand's face in `brand`** (visual routes, logo, palette,
   type, `art-director` and `designer`): spec first. Then 1.3 =
   `brace:design`; the Antigravity copy update and the `AGENTS.md` tidy
   come after it.
