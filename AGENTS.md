# AGENTS.md — BRACE

Instructions for AI coding agents (Antigravity, Claude Code, Codex) working in this repo.
`CLAUDE.md` is a symlink to this file for Anthropic tooling compatibility.
This repo **is** the BRACE plugin (formerly project-tracker); it also tracks itself (see `docs/brace/`).

## What this is

A multi-platform AI assistant plugin (Antigravity & Claude Code) that bootstraps and maintains
nine standard Markdown tracking files for projects under configured scope roots, manages GitHub repo
creation, and regenerates a unified `PORTFOLIO.html`. Behaviour spec:
`skills/track/SKILL.md`.

## Layout

- `skills/track/` — `SKILL.md` (the full behaviour specification, source of
  truth for how the skill acts); `references/` (`backlog-phases.md`,
  `reminders-sync.md`, `subprojects.md`, `writing-tracking-files.md`,
  `skills-contract.md`, platform notes, and `i18n/{en,fr}.md`, the
  output-language catalogue); `hooks/session_start.sh` and
  `hooks/post_tool_use.sh` (neutral skill scripts, + their `test_*.sh`;
  **self-relative**, never hardcode `~/.claude/...` paths);
  `scripts/generate_portfolio.py` (stdlib only, no deps) and
  `scripts/migrate_project.sh` (+ their tests).
- `dispatch/` — the dispatcher `run.sh`, `lib.sh`, `machine.sh`,
  `migrate_plugins.sh`, `migrate_config.sh`, and the per-tool adapters
  `claude/` and `antigravity/` (+ tests).
- Manifests: `.claude-plugin/{plugin,marketplace}.json` and
  `claude-hooks.json` (Claude Code); `plugin.json` + `hooks.json` at the repo
  root (Antigravity). **Never recreate `hooks/hooks.json`** — Antigravity
  would merge it and no hook would fire any more.
  `test_plugin_manifest.py` at the root validates them.
- `bridge/` — the `project-tracker` 0.14.0 bridge plugin that installs
  BRACE; do not touch it once released. It shares the backoff marker name
  (`$TMPDIR/brace-swap-backoff`) and the `installed_plugins.json` key format
  with `dispatch/migrate_plugins.sh` — never rename either.
- `commands/config.md` — the `/brace:config` command.
- `docs/superpowers/` — gitignored local specs, plans and research notes;
  keep French, do not ship.

## Conventions

- **Shipped strings are English.** Prose, comments, messages, generated HTML.
  Keep test fixtures ASCII/English. This is a review discipline (a "French
  sweep" you run by eye), not an automated in-repo gate.
- **No real names or personal data anywhere in the repo** — including the
  self-tracking files under `docs/brace/`, which are committed and
  public. When a note needs to refer to one of the user's other projects,
  use a generic placeholder ("a dogfood project", "an external project", "a
  git sub-repo"), never the actual name, folder path, or Reminders-list name.
  `doui445` (the GitHub handle in the manifests and URLs) is the sole
  exception. Run this "names sweep" by eye alongside the French sweep before
  every commit.
- Deliberate French exceptions, whitelisted by any "is the shipped skill
  all-English" review:
  - `skills/track/references/i18n/` except `en.md` (the `fr.md`
    catalogue and any future non-English catalogue);
  - the `STRINGS["fr"]` table in
    `skills/track/scripts/generate_portfolio.py` (the portfolio's
    French UI strings);
  - the French assertions in
    `skills/track/scripts/test_generate_portfolio.py` (they check
    the `fr` rendering).
- **Never translate machine values**: frontmatter keys and enum values
  (`active`, `"non"`, `"adopté"`, `"leger"`, `"superpowers"`, …), standard
  file names, hook names, `#tracker-sync`.
- **Never guess.** If a needed fact is missing, ask — a section stays marked
  "to fill in" rather than filled by assumption. This is the skill's own first
  principle; hold to it when editing the skill too.
- **Propose or impose — think twice.** Too much choice kills choice. Whenever
  a design asks "offer the user a choice, or just do it?", weigh it against
  the context: impose when the choice brings the user nothing (e.g. the
  BRACE folder migration); offer only when the options genuinely differ for
  them. See `DECISIONS.md` (2026-10-05).
- Version lives in `.claude-plugin/plugin.json`, the `brace` entry of
  `.claude-plugin/marketplace.json` and the root `plugin.json` — keep them
  equal (a test enforces it). Bump on every release.

## Build / test

```bash
bash run_tests.sh
```

Before a release, also test locally in a throwaway config:
`claude --plugin-dir .` and `agy plugin install "$PWD"`.

## Git / GitHub

- `uses_git: true`, remote `origin` → `github.com/doui445/brace`,
  default branch `main`.
- Never commit or push without explicit confirmation. Conventional-commit
  style messages (`skill:`, `hooks:`, `portfolio:`, `plugin:`, `docs:`,
  `test:`, `release:`).

## Releasing

**Version scheme** — *product-style* (decided 2026-10-05, applies from the
BRACE 1.0 launch; `0.x` was the `project-tracker` pre-history):

- **major** (`N.0.0`) — a new generation, launched and announced (BRACE 1.0 =
  the launch).
- **minor** (`N.M.0`) — a new skill, command, hook, config knob or standard
  file, or any change to how the plugin behaves.
- **patch** (`N.M.P`) — fixes, doc and guidance changes, refactors with no
  behaviour change.
- **Zero breakage, whatever the bump**: a release never breaks an existing
  project. The old project folder `docs/project-tracker/`
  stays recognised for good; the old config paths are symlinks to
  `~/.brace/`.

**Routine** (every release):

1. Bump `version` in `.claude-plugin/plugin.json`, the `brace` entry of
   `.claude-plugin/marketplace.json` and the root `plugin.json` — kept equal,
   `test_plugin_manifest.py` enforces it.
2. In `docs/brace/CHANGELOG.md`: rename `[Unreleased]` to
   `[X.Y.Z] — YYYY-MM-DD`, add a fresh empty `[Unreleased]` above it.
   Update `STATUS.md` (version, next actions), append to `JOURNAL.md`, move
   any completed `BACKLOG.md` items, add a `DECISIONS.md` entry if the
   release settled a structural choice.
3. Run the tests (see Build / test).
4. Commit `release: vX.Y.Z — <summary>`, then
   `git tag -a vX.Y.Z -m "<summary>"`, then
   `git push origin main --follow-tags`.

## Phases

`phase_model: "superpowers"` — this repo uses the spec → plan flow. Specs and
plans live in `docs/superpowers/{specs,plans}/` (the skill's default path),
kept **gitignored** and in French; research notes sit alongside in
`docs/superpowers/research/`. Only the shipped tracking files under
`docs/brace/` are committed.

## Dogfooding note

This repo tracks itself. After a significant change, update
`docs/brace/STATUS.md` (+ `JOURNAL.md`, and `CHANGELOG.md` /
`DECISIONS.md` / `ERRORS.md` where relevant) like any other tracked project.
