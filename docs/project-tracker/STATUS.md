---
project: project-tracker
status: active
uses_git: true
repo: https://github.com/doui445/project-tracker
stack: [Bash, Python, Markdown]
last_updated: 2026-10-04
next_milestone: "v0.13.0 — Antigravity dual-platform support release (bump versions, regenerate installer, update CHANGELOG/DECISIONS/BACKLOG)"
reminders_list: "Project tracker"
category: "Skill Claude"
backlog_model: "adopté"
phase_model: "superpowers"
language: en
nested_model: "non"
---

# STATUS — project-tracker

## Where it stands

`project-tracker` is a published Claude Code plugin at **v0.12.2**, now in active
development toward **v0.13.0** which adds native Antigravity (AGY) support:

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
- Version numbers in `platforms/antigravity/plugin.json` and the two
  `.claude-plugin/` manifests are still at 0.12.2 — pending the formal release
  bump to 0.13.0 (local testing done).

## Next 3 actions

**Dual-platform Antigravity support** committed to `main` (commit `2d4d3be`)
and **validated in live Antigravity sessions** (2026-10-04): session-start
detection, untracked-project prompt and portfolio regeneration all behave as
expected. One fix found along the way: the `session_start.sh` message carried
literal `\n` instead of real newlines (now fixed, with a test).

1. **Version bump and release routine** (`v0.13.0`): bump `version` in
   `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, and
   `platforms/antigravity/plugin.json`; regenerate `install-project-tracker.sh`;
   convert `[Unreleased]` in `CHANGELOG.md` to `[0.13.0] — <release date>`;
   commit, tag `v0.13.0`, and push with `--follow-tags`.
2. **Resolve the plugin naming question** (paused since 2026-09-22): should the
   plugin stay `project-tracker` or become an umbrella name (candidates:
   **"Steward"** or **"BRACE"**)? Now more pressing because the Antigravity
   plugin ships under the same name — consistency across two platforms.
3. **Resume the design-skill (DA) brainstorm** once the naming is settled —
   it is blocked on that decision (see `BACKLOG.md`).
