# The BRACE skill contract

How a skill other than `track` plugs into BRACE. `track` owns the
project's memory; every other skill adds to it under these rules, so that
adding a skill never requires changing the base.

## Starting
- A skill starts **on demand**: from its description, when the
  conversation touches its topic, or explicitly as `/brace:<skill>`.
- No activation question, nothing at every session.

## Files
- In a project: `docs/brace/<skill>/`, **created on first use** (like
  `GLOSSARY.md`). Its presence means "this skill is used here": the
  skill's hooks and one-time questions apply only in such projects.
- On the machine: `~/.brace/<skill>/` for the skill's own settings and
  files. Shared settings (`scopes.txt`, `language.txt`, `portfolio.txt`,
  `prefs.txt`, `trackignore.txt`) stay at the root of `~/.brace/`.

## STATUS.md frontmatter
- Flat keys prefixed with the skill name: `design_stage: "moodboard"`.
  `track`'s keys stay unprefixed.
- **The header is an index, never content**: 3–4 short keys per skill at
  most, only what a hook or the portfolio needs at a glance. The session
  hook pastes the frontmatter into every session, so every line costs
  tokens everywhere. Content goes in `docs/brace/<skill>/`.
- A key asked once follows `## Retroactive frontmatter questions` in
  `SKILL.md` exactly.

## Hooks
- Drop a script at `skills/<skill>/hooks/<event>.sh` (`session_start` or
  `post_tool_use`). The dispatcher (`dispatch/run.sh`) calls it — only in
  projects where `docs/brace/<skill>/` exists — with these variables:
  `BRACE_TOOL` (`claude` | `antigravity`), `BRACE_PLUGIN_ROOT`,
  `BRACE_EVENT`, `BRACE_CWD`, `BRACE_FILE`, `BRACE_SESSION`,
  `BRACE_PROJECT_ROOT`.
- Print plain text for the agent (or nothing). Never print tool-specific
  JSON: the adapters do that. A failing script is ignored.
- No declaration file to edit.

## Portfolio
- A used skill gets a section on the project's detail page: its prefixed
  keys and a link to its folder. Cards on `PORTFOLIO.html` never change.

## Settings
- `/brace:config` shows one section per installed skill, read from and
  written to `~/.brace/<skill>/`.
