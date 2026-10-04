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
  `.claude-plugin/` manifests not yet bumped — pending the release commit.
- `install-project-tracker.sh` (Claude install path) not yet regenerated with
  `build_installer.sh` — pending final tests and release commit.

## Next 3 actions

**Dual-platform Antigravity support** implemented in this session (2026-10-04):
`AGENTS.md` pivot, `~/.project-tracker` unified config, platform references,
Antigravity hooks + installer, `generate_portfolio.py` config fallback.
All test suites green. Pending release commit.

1. **Version bump and release commit** (`v0.13.0`): bump `version` in both
   `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` and in
   `platforms/antigravity/plugin.json`; regenerate `install-project-tracker.sh`
   via `build_installer.sh`; update `CHANGELOG.md`, add `DECISIONS.md` entry;
   then commit + tag + push.
2. **Resolve the plugin naming question** (paused since 2026-09-22): should the
   plugin stay `project-tracker` or become an umbrella name (candidate:
   **"Steward"**)? Now more pressing because the Antigravity plugin ships under
   the same name — consistency across two published platforms.
3. **Resume the DA spec** once the name is settled (colour, typography,
   logo), per `docs/superpowers/research/2026-09-02-design-branding-SYNTHESE.md`.
