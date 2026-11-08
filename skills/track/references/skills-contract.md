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
  `BRACE_PROJECT_ROOT`, `BRACE_SWAPPED` (`1` when an old project-tracker
  plugin may still be loaded this session — swapped this run, swap pending,
  or still installed: never move or rewrite project folders then) and
  `BRACE_SOURCE` (how the session started: Claude's `startup` | `resume` |
  `clear` | `compact`; `startup` for a new Antigravity conversation; empty
  after a write).
- A project excluded by `~/.brace/trackignore.txt` gets no hook from any
  skill other than `track`.
- Print plain text for the agent (or nothing). Never print tool-specific
  JSON: the adapters do that. A failing script is ignored.
- No declaration file to edit.

## Agents
- A **skill** is know-how loaded into the current conversation, named with
  a short English verb for its domain (`track`, `brand`). An **agent** is a separate worker with its
  own instructions, a blank context and a brief, who reports one result,
  named after a trade (`analyst`). An agent is never a slash command: an
  AI delegates to it, or the user asks for it in plain words.
- **BRACE agents**: a trade any project can use and a BRACE skill depends
  on. They ship in the plugin (`agents/<agent>.md` for Antigravity,
  `agents/claude/<agent>.md` listed in `.claude-plugin/plugin.json` for
  Claude Code, same body in both) and update with it.
- They learn a project at every mission from `docs/brace/agents/<agent>/`:
  a `BRIEF.md` (priorities, instructions, sources, the user's past
  corrections; created at the first mission, enriched afterwards, the
  calling skill adding what the user said) next to their past work. One
  folder per project, whatever skill launched them.
- An agent never assumes who it works for: the caller gives the mission.
  One report format for every caller. It writes only in its own folder;
  the skill integrates the result after the user checks it. On Claude
  Code, a BRACE agent writes in its own folder without a prompt (a
  `PreToolUse` hook); elsewhere, where it cannot write, it reports in its
  message and the skill saves the report there. Outside a
  tracked project it writes no file and reports in its message.
- **Project agents** (a trade only one project needs) stay in that
  project's `.claude/agents/`, owned by the user; their instructions point
  to `docs/brace/` files rather than copying facts.
- `agents` is reserved under `docs/brace/`: no skill may take that name.

## Portfolio
- A used skill gets a section on the project's detail page: its prefixed
  keys and a link to its folder (reserved folders such as `agents/` get
  none). Cards on `PORTFOLIO.html` never change.

## Settings
- `/brace:config` shows one section per installed skill: it reads that
  skill's settings from `~/.brace/<skill>/` and writes changes back there.
