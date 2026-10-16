# ROADMAP — BRACE

Prioritised synthesis. Raw detail (effort, value, technical notes) lives in
[`BACKLOG.md`](BACKLOG.md).

## Done

Extraction and packaging (v0.1.0 – v0.3.1):

- **C1 — Standalone public repo** (2026-08-28): extracted from a private
  `~/.claude` skill into `github.com/doui445/project-tracker`.
- **C2 — English translation** (2026-08-29): every shipped string translated;
  machine values left untouched.
- **C3 — Portfolio rework** (2026-08-30): single unified `PORTFOLIO.html`,
  category sections, configurable location (`portfolio.txt`) and title,
  deterministic hook-driven regeneration.
- **C4 — Plugin wiring** (2026-08-30): shipped as a Claude Code plugin
  (`hooks/hooks.json`), install-script path kept in parallel,
  `/project-tracker:config` command, `project:` pinned to the folder name.
- **v0.3.1**: retroactive git tags, `SKILL.md` states tracking files are
  committed, `build_installer.sh` globs the reference files.

Features (v0.4.0 – v0.7.0):

- **v0.4.0 — User-selectable output language (EN/FR)**: `language.txt`
  machine default + `language:` overrides in `STATUS.md` frontmatter and
  `portfolio.txt`; per-language catalogue `references/i18n/{en,fr}.md`;
  localised `PORTFOLIO.html`; retranslation flow with a subagent review loop.
- **v0.4.1**: post-release cleanup — context-picked HTML escaping helpers,
  `en.md` as wording source of truth, spec-aligned language aliases.
- **v0.5.0 — Lazy `GLOSSARY.md`**: no longer asked at bootstrap; created on
  first need (proactive check + in-session triggers). New `glossary`
  frontmatter key.
- **v0.6.0 — Fresh-eyes readability pass**: after a substantial onboarding-file
  write/rewrite, a subagent (inline fallback) reviews it against the file's
  reader definition. Advisory.
- **v0.7.0 — Un-exclude on request**: an excluded folder the user asks to
  track is offered an un-exclude + bootstrap.
- **v0.7.1**: repo audit — genericised a home path in `JOURNAL.md`, unstaled
  `ROADMAP.md` / `CLAUDE.md`, tidied `README.md`.

Refinement from real dogfooding (v0.8.0 – v0.11.0):

- **v0.8.0 — Proactive tracking prompt**: on an untracked folder the
  `SessionStart` hook now instructs Claude to open with a Yes / No / Not now
  question, not a passive note.
- **v0.9.0 — Skill renamed `track`** (`project-tracker:track`), dropping the
  redundant `project-tracker:project-tracker`.
- **v0.10.0 — Console-view preference**: asked once per machine (`prefs.txt`
  `console_view:`), three scopes, to fold the transcript's edit-diff noise.
- **v0.11.0 — Plain-language questions**: `## Asking questions` principle;
  every prompt reworded for a non-power-user.
- **v0.11.x housekeeping**: names-sweep convention + a git-history scrub of a
  leaked folder name; `_dev-history/` moved to a gitignored `docs/superpowers/`.

Nested tracking and dual platform (v0.12.0 – v0.13.0):

- **v0.12.x — Nested tracking**: umbrella projects with sub-projects,
  reusable re-prompt infra, portfolio detail sub-pages, discussions logged.
- **v0.13.0 — Native Antigravity support**: Antigravity hooks and installer,
  unified `~/.project-tracker/` config, `AGENTS.md` as the canonical
  instructions file.

BRACE (1.0.0):

- **1.0.0 — Launch + multi-skill foundation** (2026-10-16): renamed BRACE
  (plugin `brace`, skill `brace:track`, repo `doui445/brace`), config in
  `~/.brace/`, projects in `docs/brace/`, one hook dispatcher per event
  with per-tool adapters, skills that plug in by dropping a hook script,
  automatic move from project-tracker (0.14.0 bridge + migration in BRACE),
  official installs only.

Detail for each: [`CHANGELOG.md`](CHANGELOG.md), [`DECISIONS.md`](DECISIONS.md).

## Current focus

**BRACE 1.1: `brace:design`**: track a project's design / brand direction
under `docs/brace/design/`. File model already frozen in `BACKLOG.md`;
first question for the spec: `design` and `brand`, one skill or two.

## Next

- In parallel, no plugin release: **BRACE's own visual identity** (DA,
  unblocked by the naming), then the **public website**.
- Later, undated: portfolio graph view; pressure-testing three skill rules.

## Unprioritised ideas

None recorded — add to [`BACKLOG.md`](BACKLOG.md) as they come up.
