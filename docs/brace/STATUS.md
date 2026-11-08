---
project: brace
status: active
uses_git: true
repo: https://github.com/doui445/brace
stack: [Bash, Python, Markdown]
last_updated: 2026-11-08
next_milestone: "BRACE 1.1: brace:brand"
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

**On `feat/brand`, not merged (BRACE 1.1)**: `brace:brand` runs as an
agency. A workshop on a brief BRACE pre-fills, four agents working in the
background (`analyst`, `strategist`, `copywriter`, `creative-director`),
a strategic presentation as a local HTML deck, adjustments validated one
rendered document at a time, a delivery page. Agents write in their own
folder without a prompt (a hook, tested for real on Claude Code); a macOS
notification says when a presentation is ready. Whole-branch review
done, its findings fixed. First real trial on Claude Code done
(2026-11-01) and its gaps fixed (2026-11-02). Since 2026-11-05 it works
like a real agency: a named team, a proposal, meetings with minutes and
appointments, the documents rendered by a script, a client space, the
agency resuming on its own; suite green.
The real rebrand trial of BRACE itself is done (delivered 2026-11-08):
new front page and install descriptions, team renamed, brand review set
for 2027-05-10.

### Known gaps

- A tool session left open since before the swap keeps the old plugin
  loaded; the restart message asks to close them, and the "both folders"
  guard covers a miss.

## Next 3 actions

1. **Fix pass from the rebrand trial feedback** (2026-11-06 to 11-08, owner's
   notes collected live; full list in the local, gitignored
   `docs/superpowers/research/2026-11-06-rebrand-trial-feedback.md`): spec
   written 2026-11-08 (local, `2026-11-08-brand-trial-2-fixes-design.md`),
   plan next. It also lays the frame for the 1.2 visual phase and a light
   intake of the client's existing brand work (the scope follows it).
   Acceptance test for every console line: "would the account director
   really say this?". Main points: the agency takes charge of the
   process and the client decides only on the brand; questions anticipated
   in one batch before the team works; a meeting only to present (5 parts:
   welcome, presentation in the browser, discussion, recap and next
   appointment, the team at work), silence while the team works; only
   client documents are shown, never internal ones, never restated in the
   console; feedback rethought as an intent, not pasted; delivery becomes a
   real handover; a tabbed client space (shortcut at the root during the
   mission, brand book after); `render.py` bugs (wrapped and nested list
   items, `---`, space language and name); the account director may write
   without a prompt (auto mode refused writes); token frugality as a design
   rule. Also: measure the tokens and the 17-minute work batch from the
   session ids (done 2026-11-08, see `JOURNAL.md`).
2. **Merge and release 1.1.0**, with the 1.1 riders if they fit (keep the
   Antigravity copy up to date, tidy a bloated `AGENTS.md`, both in
   `BACKLOG.md`). Then 1.2 = the brand's face in `brand` (two new agents),
   1.3 = `brace:design` (order changed 2026-11-08, see `DECISIONS.md`).
3. **BRACE's own brand** (delivered 2026-11-08, review 2027-05-10): at
   the 1.1 release, set the GitHub description and topics (owner's yes)
   and publish the announcement; the test with real people stays ready
   (add the first-language question).
