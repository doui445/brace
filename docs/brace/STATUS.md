---
project: project-tracker
status: active
uses_git: true
repo: https://github.com/doui445/project-tracker
stack: [Bash, Python, Markdown]
last_updated: 2026-10-14
next_milestone: "BRACE 1.0 — launch + multi-skill foundation (spec in review)"
reminders_list: "Project tracker"
category: "Skill Claude"
backlog_model: "adopté"
phase_model: "superpowers"
language: en
nested_model: "non"
---

# STATUS — project-tracker

## Where it stands

`project-tracker` is a published plugin at **v0.13.0** (released 2026-10-04),
running natively on both Claude Code and Antigravity (AGY):

- **Antigravity plugin** built and installed (`platforms/antigravity/`):
  `PreInvocation` hook for session detection, `PostToolUse` hooks for portfolio
  regen and Reminders sync — all producing valid Antigravity JSON.
- **Unified configuration** in `~/.project-tracker/` with transparent symlinks
  from `~/.claude/project-tracker` and `~/.gemini/project-tracker`.
- **`AGENTS.md` as the canonical root instructions file** across all tracked
  projects; `CLAUDE.md` becomes a symlink for Anthropic tooling compatibility.
  `AGENTS.md` is natively read by Antigravity, Codex, Cursor, Copilot and others.
- **`generate_portfolio.py` updated** to find `~/.project-tracker` first, then
  fall back to `~/.claude` and `~/.gemini`.
- **Platform references** added: `references/platform-claude.md` and
  `references/platform-antigravity.md` isolate tool-specific conventions so
  `SKILL.md` stays universally neutral.
- **`superpowers` suite installed for AGY**: 15 skills symlinked into
  `~/.gemini/config/skills/` via `skills.json`.
- Full non-regression: 8 manifest tests + 151 portfolio tests + all Claude hook
  shell tests + 5 Antigravity session_start tests + 5 portfolio_regen tests.

### Known gaps

- The `reminders_sync_trigger.sh` Antigravity hook is intentionally silent
  (`{}`): `PostToolUse` does not support `injectSteps`, so the Reminders nudge
  is handled by the skill itself when it reads the frontmatter. Works correctly.

## Next 3 actions

**v0.13.0 released** (dual-platform Antigravity support). **Antigravity is
on standby** (2026-10-13, token budget too tight there). **BRACE 1.0 spec
completed (2026-10-14)**: skills on demand, one hook dispatcher per event,
prefixed frontmatter keys, migration logic living in BRACE for good plus a
minimal `project-tracker` 0.14.0 bridge (see `DECISIONS.md`, 2026-10-14).
Spec in the gitignored `docs/superpowers/specs/2026-10-05-brace-1.0-design.md`.

1. **Review the BRACE 1.0 spec** (user), then write the implementation plan
   — checking scripted plugin install per tool and whether the marketplace
   can be renamed.
2. **Resume the DA brainstorm** (BRACE's own visual identity) — unblocked,
   can run in parallel; the `{ }` motif feeds it.
3. **Before the 1.1 spec**: settle whether `design` and `brand` are one
   skill or two (open, see `BACKLOG.md`).
