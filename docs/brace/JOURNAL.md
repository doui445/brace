# JOURNAL — project-tracker

Dated chronological log. Append-only.

## 2026-10-04 — Dual-platform port to Antigravity (AGY)

### Design decisions settled
- **`~/.project-tracker/` as canonical config dir** with transparent symlinks from
  `~/.claude/project-tracker` and `~/.gemini/project-tracker`. Both platforms write
  and read the same files without knowing they are using a shared location.
- **`AGENTS.md` replaces `CLAUDE.md` as the root instructions file** for all tracked
  projects. `CLAUDE.md` becomes a symlink to `AGENTS.md` for Anthropic tooling
  compatibility. `AGENTS.md` is natively read by Antigravity, Codex, Cursor,
  Copilot and other agents — the open standard.
- **Symmetric platform structure**: `platforms/antigravity/` mirrors the Claude
  plugin path; no "adapter" layer — each platform gets a clean, native
  implementation. Platform-specific rules extracted to
  `references/platform-claude.md` and `references/platform-antigravity.md`.
- **`PostToolUse` hooks are silent (`{}`)**: the Antigravity hook format does not
  support `injectSteps` for `PostToolUse` (only `PreInvocation` can inject
  steps). Reminders and portfolio-regen context is surfaced by the skill itself
  when it reads the frontmatter, not by the hook.

### Work done
- `AGENTS.md` created (`git mv CLAUDE.md AGENTS.md`); `CLAUDE.md` symlinked back.
- `AGENTS.md` header updated to list Antigravity, Claude Code, Codex as audience.
- `skills/track/SKILL.md` updated throughout: `~/.project-tracker/`, `AGENTS.md`
  canonical, Asking-questions section references platform files, concurrent-session
  wording neutral.
- `generate_portfolio.py` `_config_dir()` updated: checks `~/.project-tracker`
  first, then `~/.claude/project-tracker`, then `~/.gemini/project-tracker`.
- `references/platform-claude.md` + `references/platform-antigravity.md` created.
- `platforms/antigravity/hooks/`: `session_start.sh`, `portfolio_regen.sh`,
  `reminders_sync_trigger.sh` + their `test_*.sh` suites (all green).
- `platforms/antigravity/plugin.json` + `hooks.json` plugin manifests.
- `install-antigravity.sh` one-shot installer at repo root.
- `skills/track/scripts/migrate_config.sh` + `test_migrate_config.sh`.
- `superpowers` suite installed globally for AGY (15 skills).
- Full non-regression: 8 manifest + 151 portfolio + all Claude shell tests +
  5 Antigravity session_start + 5 portfolio_regen — all green.
- Committed to `main` (`2d4d3be`). Local testing in progress before formal
  `v0.13.0` release.

## 2026-08-30 — Self-tracking bootstrap

- Removed this repo's own path from
  `~/.claude/project-tracker/trackignore.txt` — the tool now tracks its own
  repo as a real project (auto-detection on, not manual-only).
- Bootstrapped the nine standard files in `docs/project-tracker/` + optional
  `GLOSSARY.md`. `README.md` kept as-is (English, already good); `CLAUDE.md`
  created at the root.
- Tracking-file language chosen: **English** (consistent with the repo and
  README). Reminders list **"Project tracker"** created and linked.
  Category: **Skill Claude**.
- Recorded the four completed build workstreams (C1–C4) and the v0.3.0 state
  in `STATUS.md` / `ROADMAP.md` / `CHANGELOG.md` / `DECISIONS.md`, grounded in
  git history and the local `_dev-history/` specs.
- Logged the requested improvement in `BACKLOG.md`: a user-selectable output
  language (English / French) for the tracking files and the portfolio.
- Decided: tracking files are committed, not gitignored (see `DECISIONS.md`).
  Added a backlog item to make `SKILL.md` say so explicitly.
- Created three Reminders in "Project tracker" from the `STATUS.md` next
  actions (backfill at linking).
- README gap fixed: `superpowers` was an undocumented optional dependency
  (phase plans via `writing-plans`). Added it to Requirements and a
  "Backlog & phases" bullet to "What it does".
- Full README audit against `SKILL.md` / `hooks.json` / `config.md`. Added:
  retrofit path, no-git mode, optional `ARCHITECTURE`/`GLOSSARY`, follow-up
  questions on tracked projects, concurrent-session handling, `~`/`$VAR`
  expansion, a `STATUS.md` frontmatter example. Fixed two `SKILL.md` issues
  (step 6 → 7; the `title:` line of `portfolio.txt` was undocumented in its
  own § Portfolio). Installer regenerated; manifest tests pass.
- README restructured for a first-time reader: the audit had turned it into a
  spec. Now opens with a plain hook + Quick start; "What you get" trimmed to
  the file table + four capabilities; edge cases (no-git, retrofit, concurrent
  sessions, optional files, frontmatter) collected under a "Details" section.
  Same substance, reordered.
- New `references/writing-tracking-files.md`: per-file writing guidance for all
  nine standard files + `ARCHITECTURE.md` / `GLOSSARY.md`. README and CLAUDE.md
  get good/poor contrasts; STATUS a belongs/doesn't-belong list; the
  append-only files get structure templates; ROADMAP/BACKLOG defer to
  `backlog-phases.md` for structure and only add prose notes; ARCHITECTURE
  also carries a lens for judging the architecture itself; GLOSSARY is framed
  as a real project dictionary (project meaning + usage context per entry).
  `SKILL.md` points to it from "The standard files".
- Fixed a latent bug found on the way: `build_installer.sh` had a hardcoded
  reference-file list — now globs `references/*.md`.
- Cleared the three low-priority items and cut **v0.3.1**:
  - `SKILL.md` now states the tracking files are committed (narrow
    sensitive-content exception).
  - Retroactive git tags `v0.1.0` / `v0.2.0` / `v0.3.0` at the last commit of
    each version line; `v0.3.1` tagged on this release.
  - Dogfood friction captured: the `build_installer.sh` bug is written up in
    `ERRORS.md`; the bootstrap itself and the hook chain (portfolio regen +
    reminders trigger firing on every `STATUS.md` write during a heavy dev
    session) worked as intended, just chatty by design.
  - `plugin.json` / `marketplace.json` → `0.3.1`, installer regenerated,
    `CHANGELOG` `[0.3.1]` dated.
- Versioning policy written down (decided against a dedicated file): the
  scheme lives in the `CHANGELOG.md` header, the step-by-step release routine
  in `CLAUDE.md` § Releasing. `writing-tracking-files.md` now points future
  projects to those two homes. Sits in `CHANGELOG [Unreleased]` — rides the
  next real release rather than triggering a 0.3.2 for two lines.
- Dogfooding review. The machinery worked; the frictions were doc gaps, and
  all the ones that were fixable are now fixed this session: `build_installer.sh`
  hardcoded list, the `title:` line missing from SKILL.md § Portfolio, the
  step 6→7 cross-reference, the silence on committing tracking files, the
  README drifting into spec. Two remaining threads logged to `BACKLOG.md`:
  `GLOSSARY.md` lazy creation + enrichment loop (medium), and offering to
  un-exclude a `trackignore.txt` folder when the user asks to track it (low).
- Correction to the entry above: the "hook chattiness / chatty by design"
  note was wrong. Checked the hooks — `portfolio_regen.sh` throttles to one
  run per 10s and injects no context (bar the once-per-session
  unconfigured-portfolio note); `reminders_sync_trigger.sh` fires once per
  session per project. Not a friction; the BACKLOG item was dropped. The
  `GLOSSARY.md` trigger list also gained "Claude spots a domain vocabulary
  while reading the code/docs → proposes the glossary then".
- New BACKLOG item (medium): a "fresh eyes" readability pass — after a
  substantial rewrite of README / ARCHITECTURE / GLOSSARY / CLAUDE, a
  subagent (fallback inline) reviews it against the reader definition and
  `writing-tracking-files.md`, advisory only. Prompted by this session's
  three README passes.

## 2026-08-30 — Output-language feature: design

- Brainstormed the user-selectable output language (EN/FR) and wrote the
  design spec at `_dev-history/specs/2026-08-30-output-language-design.md`
  (gitignored, French, per the project's `_dev-history/` convention).
- Key decisions: `language.txt` global default + `language:` overrides in
  `STATUS.md` frontmatter (per project) and `portfolio.txt` (portfolio only);
  reminders always follow the global; chat follows the conversation. Full
  localisation of the tracking files via a per-language catalogue
  `references/i18n/{en,fr}.md`; `generate_portfolio.py` gets its own `STRINGS`
  table. Language change → proposed full retranslation (append-only entries
  included, dates preserved) with an autonomous subagent review loop.
- Set `phase_model: "superpowers"` (records the de-facto workflow; specs/plans
  stay in `_dev-history/`, no migration). Targets v0.4.0.
- Next: user reviews the spec, then `writing-plans`.

## 2026-08-30 — Output-language feature shipped (v0.4.0)

- Implemented per `_dev-history/plans/2026-08-30-output-language.md`:
  `language.txt` + `language:` overrides, `references/i18n/{en,fr}.md`
  catalogue, localized `generate_portfolio.py`, retranslation + subagent
  review loop, `/project-tracker:config` language action.
- `phase_model: "superpowers"` recorded; specs/plans stay in `_dev-history/`.

## 2026-08-30 — Output-language feature landed on main (v0.4.0)

- Executed `_dev-history/plans/2026-08-30-output-language.md` via
  subagent-driven development in an isolated worktree: 10 tasks, one
  fresh implementer + task review each, an opus whole-branch review, one
  fix wave (2 Critical + 5 Important + minors) and a scoped re-review.
- The worst bug the whole-branch review caught: `load_portfolio_target()`
  ignored the new `language:` reserved key, so a `language:` line above the
  path in `portfolio.txt` silently redirected `PORTFOLIO.html` into a bogus
  directory. Fixed with a shared `_RESERVED_PORTFOLIO_PREFIXES` + a
  regression test writing the `language:` line first.
- Fast-forwarded to `main`, tagged `v0.4.0`, pushed. 87 portfolio tests +
  8 manifest + 3 hook suites green on the merged result.
- `BACKLOG.md`: the output-language item moved to Completed.
  `DECISIONS.md`: added the D1–D15 rationale entry.

## 2026-08-30 — Post-v0.4.0 residual cleanup

- Final-review residuals cleared: `generate_portfolio.py` now routes every
  HTML escape through `_attr()` / `_txt()` helpers picked by context, so
  adding a locale can't get attribute-vs-text escaping wrong (new
  `test_escaping_convention_text_vs_attribute` guards it). The vestigial
  "French repo → French tracking files" heuristic in
  `writing-tracking-files.md` — dead since the resolution cascade always
  resolves — is reframed as a hint for the first-run question only.
- 88 portfolio tests + 8 manifest + hook suites green; installer regenerated.

## 2026-08-30 — Last two low-priority residuals cleared

- `_normalise_lang`: removed the off-spec `eng`/`fra` aliases (ISO 639-2);
  the tolerance list now matches the spec exactly, with a test.
- `references/i18n/en.md`: declared the source of truth for heading wording
  (structure still owned by `SKILL.md` / `writing-tracking-files.md` /
  `backlog-phases.md`); its ROADMAP keys reconciled with `backlog-phases.md`
  — added `roadmap.heading.in_progress` and `.after` (was a bare `.next`),
  noted that headings 2–3 depend on whether a phase has started. `fr.md`
  follows; parity guard green (89 portfolio tests).

## 2026-08-30 — v0.4.1 released

- Patch release: the four post-v0.4.0 cleanup entries from `[Unreleased]`
  (escaping helpers, French-repo heuristic, `en.md` source of truth,
  `_normalise_lang` spec alignment). No behaviour change. `v0.4.1` tagged
  and pushed; 89 portfolio + 8 manifest + hook suites green.

## 2026-08-30 — v0.5.0: GLOSSARY.md lazy creation

- `GLOSSARY.md` no longer asked at bootstrap. Created on first need:
  proactive first-session check (Claude glances at code/README, proposes it
  with spotted terms) + in-session triggers (user asks a term's meaning, or
  a term recurs undefined). Single term → created + announced, no question;
  proactive batch → proposed. New `glossary` frontmatter key
  (`"non"` = scan declined, absent = not checked, unset once the file
  exists). `ARCHITECTURE.md` keeps its bootstrap question.
- Touched `SKILL.md` (detection bullet, bootstrap step 7, frontmatter,
  Continuous updates), `writing-tracking-files.md`, `references/i18n/{en,fr}.md`
  (glossary.title/intro), `README.md`. `DECISIONS.md` entry added.
- 89 portfolio + 8 manifest + hook suites green; installer regenerated.

## 2026-08-30 — v0.6.0: fresh-eyes readability pass

- After a substantial write/rewrite of an onboarding file (README /
  CLAUDE.md / ARCHITECTURE.md / GLOSSARY.md), Claude runs a readability
  pass: a subagent (inline fallback) checks it against the file's reader
  definition — clear hook, reachable quick start, jargon-before-intro,
  drift from purpose, concreteness, over-long sections. Advisory, never a
  gate. Runs at bootstrap and on later rewrites; STATUS.md is excluded.
- New `## The fresh-eyes readability pass` section in
  `writing-tracking-files.md`; `SKILL.md` points to it from the bootstrap
  flow and `## Continuous updates`. `DECISIONS.md` records the
  subagent-not-inline / advisory-not-gate choices.
- 89 portfolio + 8 manifest + hook suites green; installer regenerated.
- Backlog reservoir is now down to one Low item (trackignore un-exclude).

## 2026-08-30 — v0.7.0: un-exclude on request

- The **Excluded** state now acts when the user asks to track the folder:
  if its own path is the `trackignore.txt` line, Claude offers to remove it
  and bootstrap (symmetric with bootstrap step 1); if an ancestor is the
  ignored line, Claude explains that un-ignoring the whole subtree is the
  only option and asks. Bringing the folder up for anything else is
  unchanged. `SKILL.md` only; no test, no i18n.
- **Backlog reservoir is now empty** — every item planned this session
  (v0.4.0 output language, v0.4.1 cleanup, v0.5.0 lazy glossary, v0.6.0
  fresh-eyes pass, v0.7.0 un-exclude) has shipped. Next themes will come
  from real use.

## 2026-08-30 — Full repo audit (clean-up pass)

- Personal-info sweep: one absolute home path in `JOURNAL.md`'s first entry,
  genericised. Nothing else — no emails, no other-project names, no session
  URLs, no secrets in tracked files (installer base64 blobs decoded and
  checked too).
- `ROADMAP.md` was four releases stale — full rewrite (v0.1–v0.3 grouped,
  v0.4.0–v0.7.0 listed, current focus = empty backlog).
- `CLAUDE.md`: reference-file list completed (`writing-tracking-files.md`,
  `i18n/`), `test_generate_portfolio` command fixed, release routine now
  names the STATUS/JOURNAL/BACKLOG/DECISIONS updates.
- `README.md`: install commands were printed twice → deduped; frontmatter
  example completed (all 12 keys); fresh-eyes + un-exclude behaviours added;
  ROADMAP row reworded. Ran the fresh-eyes pass inline — otherwise clean.
- Version consistency verified: `plugin.json` == `marketplace.json` == tag
  `v0.7.0` == `CHANGELOG` top == `STATUS`. Installer regeneration produces no
  diff. All suites green (8 + 89 + 3 hooks).

## 2026-08-31 — v0.7.1 released

- The repo-audit fixes from `[Unreleased]` shipped as a patch: `JOURNAL.md`
  home-path genericised, `ROADMAP.md` / `CLAUDE.md` unstaled, `README.md`
  tidied. No behaviour change. `v0.7.1` tagged and pushed.

## 2026-08-31 — v0.8.0: proactive tracking prompt

- First real dogfood attempt on another project surfaced this: on an
  untracked folder the `SessionStart` hook only injected a passive "not
  tracked" note — Claude didn't open with the question, and asked in prose
  when it did.
- Fix: the hook's new-project message is now an explicit opening-move
  instruction — invoke the skill and ask, before anything else, via
  `AskUserQuestion`: **Yes, set it up** / **No, don't ask again**
  (→ `trackignore.txt`) / **Not now** (→ nothing, re-asked next session).
  `SKILL.md § Bootstrapping` step 1 and `test_session_start.sh` updated;
  `README.md` Quick start reworded. `DECISIONS.md` records the choice.
- Plugin updated to v0.7.1 on this machine before the test; v0.8.0 tagged.
- 8 manifest + 89 portfolio + 3 hook suites green; installer regenerated.

## 2026-08-31 — v0.9.0: skill renamed to `track`

- Prompted by the ugly `project-tracker:project-tracker` invocation. The
  single skill is now `track` → `project-tracker:track`.
  `skills/project-tracker/` → `skills/track/` (git mv), `SKILL.md`
  `name: track`, `hooks.json` / `build_installer.sh` / `test_plugin_manifest.py`
  / `CLAUDE.md` / `README.md` / `commands/config.md` path refs updated, hook
  messages name `project-tracker:track` precisely.
- Considered and rejected splitting the plugin into multiple skills — it is
  one coherent workflow (see `DECISIONS.md`).
- Unchanged: plugin name, `/project-tracker:config`, `~/.claude/project-tracker/`
  config dir, `docs/project-tracker/` output namespace. Historical
  `DECISIONS.md` entries keep the old `skills/project-tracker/` path.
- 8 manifest + 89 portfolio + 3 hook suites green; installer regenerated.

## 2026-09-01 — v0.10.0: console-view preference

- The transcript diff-noise from the skill's per-session file writes: it now
  asks once per machine to fold Claude Code's view to "chat" —
  Everywhere / Only in tracked projects / No — recorded in `prefs.txt`
  (`console_view:`). New `## Console view preference` section in `SKILL.md`;
  bootstrap + detection wired; `/project-tracker:config` gains the action;
  `DECISIONS.md` records the settings-file-writing choice.
- Also updated the "don't over-edit tracking files" habit (memory) — this
  release batched the doc updates into one pass.
- 8 manifest + 89 portfolio + 3 hook suites green; installer regenerated.

## 2026-09-01 — v0.11.0: plain-language questions

- `SKILL.md` gains `## Asking questions` (assume the answerer isn't a power
  user: plain wording, one line per option on what it changes, a
  context-based **(recommended)** hint). Every question reworded to match:
  bootstrap git/Reminders/category/ARCHITECTURE, first-run portfolio/language/
  console-view, the phase + superpowers + backlog-model prompts (in
  `backlog-phases.md`), retranslation (`writing-tracking-files.md`), the
  un-exclude prompt.
- 8 manifest + 89 portfolio + 3 hook suites green; installer regenerated.

## 2026-09-01 — First external dogfood run: nested-tracking gap

First real dogfood of the v0.11.0 plugin, on an external project.

- Bootstrap ran on a **parent** folder (user's deliberate choice), French, a
  category, a linked Reminders list, `uses_git: false`. Nine standard files
  created.
- The proactive prompts (tracking, console-view, language) fired as designed;
  no friction reported on the bootstrap flow itself.
- **Gap surfaced:** the parent is *one* project, but the shipped code lives in
  a git sub-repo that is what gets pushed to GitHub. The skill has no model
  for micro-tracking such a sub-repo (repo-facing `README`, optional
  `ARCHITECTURE.md`, `CHANGELOG.md`) while the parent chaperones it and
  reports its progress. The git hooks only ever look at the tracked root, so
  with the parent at `uses_git: false` the collision diff / commit offer /
  staleness checks don't reach the sub-repo. Captured in `BACKLOG.md` (Open),
  to be brainstormed before building.

## 2026-09-01 — Planning: two more backlog items

Discussion off that run. Added to `BACKLOG.md` (Open):
- **Portfolio detail sub-page per project** — click through from
  `PORTFOLIO.html` to a per-project page (STATUS + current ROADMAP phase +
  recent JOURNAL + latest CHANGELOG + a GitHub link with the mark), instead
  of jumping to GitHub.
- Note on the nested-tracking item: a second project is an intended user of
  that model; the migration/re-prompt path for already-tracked projects is
  part of the item's scope.

Decision: hold the next release until 3–4 solid items have accumulated, then
ship one larger update with a single migration pass for tracked projects.

## 2026-09-01 — Repo privacy: names sweep + history scrub

- New `CLAUDE.md` convention: **no real project names or personal data
  anywhere in the repo**, self-tracking files included — generic placeholders
  only (`doui445` in the manifests is the sole exception). Run this "names
  sweep" by eye alongside the French sweep before every commit.
- One pre-existing leak (a project folder name in `STATUS.md`, present across
  the v0.8.0–v0.11.0 line) scrubbed from **all git history** with
  `git-filter-repo`, then force-pushed. `main` + tags v0.8.0/v0.9.0/v0.10.0/
  v0.11.0 were rewritten. A pre-rewrite backup bundle was kept.

## 2026-09-02 — Discussion: a public website for the plugin

Brainstorm only — nothing built, no design validated. Outcome captured as two
linked `BACKLOG.md` items (Open): **Brand / visual identity ("DA")** and
**Public website**, the DA to be spec'd first.

- Agreed shape: an Astro site with bespoke design in a `site/` sub-folder of
  this repo (own `package.json`; the plugin root stays dependency-free — the
  "no deps" rule scopes to the shipped plugin, to be recorded in
  `DECISIONS.md` when built). Host: Cloudflare Pages, free,
  `project-tracker.pages.dev` to start. Goal: marketing + docs.
- User's firm constraints: visually striking (at least as clean as
  `impeccable.style`) and 100% free for now. Nothing else fixed.
- Visual direction left open (leaning technical/terminal and/or
  marketing/lively), to settle during the DA spec. i18n via a languages
  dropdown (en + fr, extensible). Analytics: Cloudflare Web Analytics
  (free, cookieless) or none — decide in the spec.
- Two process notes from the user, to fold into the skill's behaviour:
  every discussion should be logged even when the idea is later dropped
  (a backlog item to make that explicit in `SKILL.md`); and this session
  made a second avoidable edit to `BACKLOG.md` — batch tracking-file writes.

## 2026-09-02 — Discussion: design as a tracked dimension

Brainstorm only — nothing built. A third spec-worthy item alongside the two
website ones. Full detail in `BACKLOG.md` (**Design as a tracked dimension**).

- **Two tiers.** N1: one light always-on `IDENTITY.md` (name, one-liner,
  audience, tone, active tier, pointers), filled passively during normal
  sessions, owned by `track`. N2: a **new skill `project-tracker:design`**
  under `docs/project-tracker/design/` (`PRODUCT.md` + `DESIGN.md`,
  `VOICE.md` at brand tier, `logo.md` / `applications.md` for the brand
  layer). Triggered by explicit request, a UI being built (the portfolio
  counts), or "this is a brand" declared at bootstrap.
- Brand layer = **superset** of the product DA, progressive ladder.
- `track` keeps N1 + detection + hand-off. New `DECISIONS.md` entry —
  revisits the 2026-08-31 "one coherent workflow": one workflow to track,
  a new entry point to create.
- **Tool integration** (delegate creative work to installed design skills,
  like phase plans go to `superpowers`): per-category prefs
  (`design_skills_<category>:`, 2 max), asked lazily per category, curated
  suggestion catalogue, install-on-yes. A/B = both on the first task →
  favourite → alternative on request; favourite is per project.
- **Assets**: binaries in `brand/` at the repo root; light inventory in
  `design/assets.md`; version SVG/favicon/OG, fonts only if the licence
  allows, no heavy sources.
- **Parked**: exact per-file content inventory (user is researching first).
  **Open**: whether the standard files move under
  `docs/project-tracker/track/` (recommendation: no); i18n; migration of
  tracked projects; portfolio surfacing a project's DA.
- Also raised, its own small task: move `_dev-history/` to a gitignored
  `docs/superpowers/` (the `superpowers` default path). Backlog item added.

## 2026-09-02 — Design/branding research pass (23 videos)

Research only — nothing built. The user fed 23 YouTube videos on brand strategy,
logo design, visual identity, personal branding, marketing, product psychology,
design thinking, layout, and presentation. Broken down one by one into
`_dev-history/research/2026-09-02-design-branding-videos.md` (gitignored, FR,
detail + source per video), then distilled into
`_dev-history/research/2026-09-02-design-branding-SYNTHESE.md` (context-free
rules, multi-validated points ranked by convergence, contradictions with
resolutions, and concrete implications for the three specs).

- Feeds the **Brand / visual identity (DA)** and **Design as a tracked
  dimension** backlog items (and the website spec).
- Cardinal finding: the whole corpus independently converges on
  project-tracker's own thesis — *a strategy/identity that isn't written down
  doesn't exist*. Strongest single takeaway: **differentiation / anti-conformity
  is the core** (~11 videos).
- The "logo shouldn't please you" vs the planned A/B mechanic **tension is
  resolved**: options are framed by the strategy and evaluated against an
  adjective rubric signed *before* seeing the work, plus targeted questions —
  never "which do you prefer?".
- Design-skill N2 workflow and the website "Why" page structure are sketched
  in the synthèse; to formalise when the DA spec starts.
- Follow-up same day: the **N2 file model is now frozen** — `FOUNDATIONS.md`
  (durable character sheet) + `STRATEGY.md` (revisable map) split out along
  the strategy-vs-branding line, `DESIGN.md`, a **separate**
  `design/DECISIONS.md`, and `VOICE.md` / `logo.md` / `applications.md` /
  `assets.md` at brand tier. Detail in SYNTHÈSE § 5; BACKLOG item updated.

## 2026-09-03 — Decisions round: the open items closed

Nothing built. A Q&A pass closed the items parked over the last two days.

- **`_dev-history/` → gitignored `docs/superpowers/`** — done (`git mv`,
  `.gitignore` comment, `CLAUDE.md` § Phases, `DECISIONS.md`). The research
  notes + synthèse now live at `docs/superpowers/research/`.
- **DA decisions** (for project-tracker's own identity): keep the name
  **`project-tracker`**; the **"reduce" visual pole** (Muji / Apple); a
  **tool brand with a light personal touch**; **re-skin `PORTFOLIO.html`** as
  part of the DA work; portfolio surfacing a project's DA is **v2**.
- **Design capability**: `kind: tool | app | library | brand`; the core
  tracking files **stay at the `docs/project-tracker/` root** (no `track/`
  subfolder); new design files get the **same headings-only i18n** as the
  standard ones; N2 workflow still to spec.
- **Release plan**: not one big batch, not `1.0`. **v0.12.0** = nested
  tracking + reusable re-prompt infra + portfolio sub-pages + the small
  "log every discussion" rider; **v0.13.0** = the `design` skill, reusing
  that infra; **v1.0.0** later, deliberate. DA + website run in parallel,
  no plugin bump. Recorded in `DECISIONS.md`.
- **Site analytics**: Cloudflare Web Analytics.
- `STATUS.md` next-actions, `ROADMAP.md` (v0.8–v0.11 backfilled + current
  focus) updated. Two new Reminders created for the release-scope decision
  (now settled) and the DA spec.

## 2026-09-14 — Discussion: Obsidian integration

Brainstorm only — nothing built, no decision. The user asked what Obsidian
is/does/a vault means, and whether it could fit project-tracker.

- Obsidian = local-first Markdown note app; a **vault** is just a plain
  folder of `.md` files it manages (plus a `.obsidian/` config subfolder).
  No proprietary format, no cloud lock-in — the standard tracking files are
  already vault-compatible as-is, zero changes needed. Confirmed
  `https://obsidian.md` is the real site.
- Assessed as a complement, not a replacement: project-tracker automates
  generation/upkeep of the tracking files plus the GitHub/portfolio side,
  none of which Obsidian does. Obsidian would only add an optional
  reading/linking/graph layer on top.
- Integration angles raised, none decided: (a) zero-effort — just document
  the vault-compatibility; (b) ship an optional, gitignored `.obsidian/`
  config template so a scope root opens cleanly as a vault (opt-in, never a
  dependency); (c) cross-link tracking files with `[[wikilinks]]` for the
  graph/backlinks — flagged as in tension with the plain-Markdown/
  no-lock-in ethos, since wikilinks aren't standard Markdown and don't
  render as links on GitHub. Leaning against (c) unless a strong case
  emerges. Captured in `BACKLOG.md` (Open) for a future real brainstorm.
- Process note: from this session on, discussion logging to JOURNAL/BACKLOG
  is automatic (no permission asked), batched to one entry per concluded
  topic rather than per exchange — recorded in memory.

## 2026-09-15 — Skill stays quiet when there's nothing to report

The user noticed a chatter pattern: at session start Claude was announcing
"tracking files are up to date" every time, even when there was nothing to
act on. Broader ask: the skill's own bookkeeping should run as
transparently as possible, so the conversation stays focused on the user's
real topic — file edits can't be hidden, but spoken narration around
nothing-to-report checks can.

- Agreed and implemented directly (small, low-risk doc change, no need for a
  separate spec/plan). New `## Staying in the background` section in
  `SKILL.md`: the session-opening staleness check is silent when files are
  current; the skill speaks up only for an actual proposal, question, or
  something the user needs to see or decide — everything already spec'd
  elsewhere (proposed updates, bootstrap/detection questions, commit offers,
  collisions, glossary additions) is unaffected.
- `CHANGELOG.md` `[Unreleased]` entry added (this is a behaviour change, so
  it rides the next minor release — no version bump today).

## 2026-09-16 — Nested tracking shipped

Built per the spec/plan at
`docs/superpowers/{specs,plans}/2026-09-16-nested-tracking*.md`, across seven
tasks, all committed and reviewed clean:

- `subprojects:` / `nested_model:` frontmatter keys, plus a general
  `## Retroactive frontmatter questions` principle covering every frontmatter
  key that follows this absent → signal-detected → resolved-once shape
  (`backlog_model`, `phase_model`, `category`, `glossary`, and now
  `nested_model`).
- The new `## Sub-projects` section: what a sub-project is, its two states
  (`tracked: false` / `tracked: true`), the fixed flat file set for a tracked
  one (`README.md`, `CHANGELOG.md`, `DECISIONS.md`, `ERRORS.md` always, plus
  optional `ARCHITECTURE.md`), and the new `SUBPROJECTS.md` as a third
  optional file, created on first need.
- Detection/attachment reusing the existing 3-way bootstrap choice, plus the
  one-time `nested_model` migration check for projects tracked before this
  feature existed.
- Dual-context loading for a session opened inside a tracked sub-project, a
  git/freshness check matrix per active sub-project (with and without its
  own git), and an anti-duplication principle keeping the parent's
  `STATUS.md`/`JOURNAL.md`/`ROADMAP.md` global once sub-projects exist.
- `references/writing-tracking-files.md` guidance for `SUBPROJECTS.md` and
  sub-project-scoped files.
- Along the way, a real bug surfaced and got fixed in
  `generate_portfolio.py`'s `parse_frontmatter`: it read the new nested
  `subprojects:` YAML list line-by-line as if it were flat top-level
  frontmatter, so an indented `status: archived` inside a sub-project entry
  could silently override the project's own top-level `status:`. Fixed
  (skip indented lines) with two regression tests; full suite now 91/91.
- Full verification sweep (all five test suites, names/French sweep) green;
  installer regenerated and committed. This entry plus the matching
  `CHANGELOG.md`/`BACKLOG.md`/`STATUS.md` updates close out the feature.
  Not yet released — bundled into v0.12.0 alongside the still-open portfolio
  sub-page item and the "log every discussion" rider.

## 2026-09-17 — Self-audit of `SKILL.md`

Prompted by an external video on skill engineering (framework: name/trigger,
outputs, tools, step-by-step process, accumulated rules, continuous
correction). Cross-checked that framework, plus the `superpowers:writing-skills`
size/SDO guidance, against the actual `SKILL.md` (not just the video's
generic claims). Findings, all verified rather than assumed:

- The "log every discussion" behaviour (open backlog item since 2026-09-02)
  is confirmed still absent from `SKILL.md` — grepped, no trace.
- `SKILL.md` is 382 lines / ~45k chars, all loaded on every trigger; `##
  Sub-projects` (~57 lines) is the largest still-inline subsystem, a natural
  extraction candidate (same pattern as `backlog-phases.md`).
- No dangling references — every `references/*.md` cited in `SKILL.md`
  exists, i18n included.
- No centralized "lessons learned" section — corrections are woven into the
  relevant section instead of collected in one place; open question, not a
  clear defect.
- Frontmatter description reads as a workflow summary (lists all nine file
  names) rather than a pure trigger — the documented SDO anti-pattern.
- No behavioural test coverage: hooks/portfolio/manifest are tested, but the
  skill's own prose rules (never guess, stay quiet, ask once) have never
  been pressure-tested with subagents per the writing-skills RED/GREEN method.

Four items added to `BACKLOG.md` (Open) for later: extract `##
Sub-projects`, lighten the frontmatter description, consider a lessons-
learned section, pressure-test the behavioural rules. None actioned yet.

## 2026-09-17 — "Log every discussion" rider shipped

Implemented the backlog item surfaced 2026-09-02: new bold paragraph in
`SKILL.md`'s `## Continuous updates`, right after the "significant change"
trigger clarification. A substantive design/scoping discussion is now
logged independently of that trigger — one `JOURNAL.md` entry per
*concluded* topic (never mid-discussion), plus a `BACKLOG.md` item for
anything actionable, written automatically with no permission asked first.
`BACKLOG.md` item moved to Completed; `CHANGELOG.md` `[Unreleased]` entry
added. Rides v0.12.0 alongside nested tracking and the still-open portfolio
sub-page item.

## 2026-09-17 — Portfolio detail sub-pages shipped

Implemented the last open v0.12.0 item across an 11-task plan (spec/plan
under `docs/superpowers/{specs,plans}/2026-09-17-portfolio-detail-subpages*.md`).
`generate_portfolio.py` gained a dependency-free Markdown→HTML fragment
renderer and `build_subpage()`, writing each tracked project's own
`portfolio/<project>.html` (state, next actions, current roadmap phase,
recent journal entries, latest changelog version, a direct GitHub link)
linked from its card in `PORTFOLIO.html`; a new `--changed <project_root>`
flag lets a targeted run regenerate only one project's sub-page, with
orphan sub-pages cleaned up on every run. `portfolio_regen.sh` now passes
`--changed "$PROJECT_ROOT"` so an ordinary `STATUS.md` edit regenerates
only that project's sub-page; a manual/config-triggered run still
regenerates all of them. `SKILL.md` `## Portfolio` documents the new
behaviour. Full verification sweep (all five test suites, names/French
sweep) green. `STATUS.md`/`CHANGELOG.md`/`BACKLOG.md` updated; all three
v0.12.0 code items are now done — only the release routine remains.

## 2026-09-19 — v0.12.0 released

Closed out the portfolio sub-pages work and cut the release:

- Final whole-branch review (opus) on the sub-pages branch found and fixed
  4 more Important issues beyond the per-task reviews: a back-link
  hardcoded to `PORTFOLIO.html` (broke custom `portfolio.txt` filenames),
  a `SKILL.md` paragraph left stale by the sub-projects work, unsafe
  orphan cleanup (now marker-based — never deletes a file it didn't
  generate), and intraword `_` mangling `snake_case` prose. Merged to
  `main` (142/142 + 8 + 3 hook suites green on the merged result).
- Went through the final review's 7 deferred Minor findings one by one
  with the user rather than batch-deciding: fixed all 7 — a vacuous test
  assertion, a missing defensive fallback, a missing `aria-label`, a
  `.strip()` inconsistency, equal card height in a grid row, sub-page
  filename sanitisation (path-traversal-safe, `render_card` now reuses
  the same sanitiser so a card's link can never diverge from the file
  written), and 6 new tests for edge cases already traced as safe but
  left uncovered. 151/151 scripts tests green.
- **Released v0.12.0**: `plugin.json`/`marketplace.json` bumped, installer
  regenerated, `CHANGELOG.md` `[Unreleased]` rolled into a dated entry.

## 2026-09-19 — Session-start check was being deferred

- A dogfood session opened on an unrelated request ("run the app"); Claude
  finished that task, then only *mentioned* the hook's staleness check and
  asked whether to run it. Cause: the hook wording ("propose an update if
  needed") read as optional, and nothing said to do it alongside the
  user's request.
- Fixed the hook message and added an explicit "instruction, not a
  suggestion" paragraph in `SKILL.md` (`## Detecting a project's root`).
  Unreleased; no version bump yet.
- **Released v0.12.1**: manifests bumped, installer regenerated,
  `CHANGELOG.md` `[Unreleased]` rolled into a dated entry.

## 2026-09-19 — Self-audit cleanups on SKILL.md

- Extracted `## Sub-projects` into `references/subprojects.md` and trimmed
  the frontmatter `description` to trigger conditions (the two small
  self-audit items). `SKILL.md` keeps a stub with the in-session attach
  trigger so the behaviour still fires without loading the reference.
  Cross-references inside the moved text now say "in `SKILL.md`". The
  installer globs `references/*.md`, so it picked the new file up
  automatically. Unreleased (patch-level, no behaviour change).
- **Released v0.12.2**: manifests bumped, installer regenerated,
  `CHANGELOG.md` `[Unreleased]` rolled into a dated entry.

## 2026-09-19 — Open backlog items discussed while the DA waits

- Went through the open items not blocked on the DA, one at a time.
  Nothing built.
- **Centralized "lessons learned" section**: abandoned. A rule sits best
  in the section where it applies; a central list would duplicate them, and
  the history of corrections is already in `DECISIONS.md` / `ERRORS.md`.
- **Pressure-testing the prose rules with subagents**: kept but scoped
  down to 3 rules (session-start check not deferred, silence when up to
  date, retroactive question asked once); on demand, no CI, no date.
- **Obsidian integration**: abandoned entirely (never used; already works
  as a vault; wikilinks break GitHub rendering).
- New idea captured: a graph / overview views in the portfolio, to be
  discussed during the DA work — needs a decision on which relationship it
  would show. Still open: the DA spec and the `project-tracker:design` skill.

## 2026-09-21 — Design/branding research corpus: purpose clarified, 24th video added

- Nothing built. Session opened on "what next?"; the tracking files were
  current. Wrote `nested_model: "non"` into `STATUS.md` (one-time check, no
  sub-repos found). Reminders synced: two shipped items ticked (portfolio
  detail sub-pages, v0.12.0), one created for the `project-tracker:design`
  spec.
- Re-read the research synthesis (`docs/superpowers/research/`, gitignored)
  and added a 24th video, a personal-branding audit of a coach's YouTube +
  Instagram account (from a pasted transcript). Little that is new for the
  project's own brand (it mostly confirms the corpus: foundation before
  aesthetics, two type families, one clear metric); one new tension noted
  (palette taken from the real environment vs. a colour rare in the sector),
  to settle in the DA's `DESIGN.md`.
- **Purpose clarified by the user:** the corpus exists to teach the future
  `project-tracker:design` skill to do design and branding for **any
  tracked project**; project-tracker's own DA is only the first test case.
  Rules are therefore kept by generality, not by fit to this project — a
  "personal brand" profile (account packaging, ICP close to the founder,
  numeric goals, content cadence) is now recorded instead of discarded.
- Still open: whether `kind:` needs a fifth value (`person`) for personal
  brands, or `brand` covers it; the DA spec (strategy first: foundations,
  then strategy, then visuals); the skill's workflow, tool-integration
  categories and skills catalogue.

## 2026-09-22 — DA brainstorming session: FOUNDATIONS/STRATEGY settled, DESIGN.md started, paused on a naming question

- Committed the pending tracking-file updates from the previous session,
  then started the brand/visual identity (DA) brainstorm via
  `superpowers:brainstorming` (architectural path). Spec draft:
  `docs/superpowers/specs/2026-09-22-brand-visual-identity-design.md`
  (now marked **paused**, nothing acted — see below).
- **FOUNDATIONS worked through with the user, in depth**: the real WHY
  turned out broader than "track projects" — fluidify, simplify and
  humanize working with AI in general (the Mac/iPhone analogy: count on
  it, no friction, think only about the goal). Personality anchored on
  **Jarvis** (discreet but a real personality, serious with a touch of
  humor, warm, reassuring, minimal on the surface/rich underneath,
  proactive, doesn't hesitate to correct or disagree). Core emotion:
  serenity, with trust as its base.
- **STRATEGY worked through**: no numeric objective (accessible to
  anyone → users → community, in that order, by consequence, not by
  design); persona defined by need, not by tool already used ("anyone
  with projects who wants to count on AI reliably, without re-explaining
  or re-checking everything" — deliberately not "already uses Claude
  Code", so as not to exclude people the tool could bring to Claude Code);
  starting state = worry + distrust; positioning landed on "project-tracker
  is what lets the AI remember in your place, so you can use it reliably,
  without effort," after several rounds of wording.
- **DESIGN.md started**: explored a warm "Feutré" (paper/wood) direction,
  rejected in favor of refining the existing `PORTFOLIO.html` look instead
  of replacing it; several accent-colour families tried (terracotta,
  blue/teal — both rejected, one as trend-fatigued, one as too corporate);
  used the `ui-ux-pro-max` skill's colour database to break out of that
  loop, converged on a near-black/white palette with a single ochre/gold
  accent (`#A16207` light / `#E0A526` dark), both light and dark modes
  planned. Typography: decided against system-default fonts (a deliberate
  choice fits "rich underneath" better); same skill's font-pairing search
  led to Karla (text) + Space Mono (technical bits), replacing the
  system-font stack used today.
- **Paused before the logo**: asking for an opinion on the name (still
  `project-tracker`, decided 2026-09-03) led to reconsidering it — not
  reopening "explicit vs abstract" (already re-confirmed once), but a
  structural question: should the plugin become a persona/umbrella
  (candidate name: "Steward") hosting several skills
  (`steward:track`, `steward:design`, future ones not about tracking at
  all), since the real WHY settled above is broader than tracking and
  `project-tracker:design` (the planned v0.13.0 skill) already reads
  oddly for exactly that reason. Real costs flagged (renaming a published
  plugin, repo, marketplace listing, install script, existing users'
  muscle memory); not decided. **Nothing in this session is acted** — the
  colour/typography picks are provisional, to revalidate once the naming
  question is resolved, not assumed. See `BACKLOG.md` (DA item, marked
  blocking) for the full framing; resume in a fresh session, naming first.

## 2026-10-03 — Second naming candidate for the blocking rename question

- While exploring a Jarvis-flavoured name/acronym for the persona, landed
  on **"BRACE" — Barely Remarkable, Admittedly Capable Engine**. The
  comma before "Admittedly" was deliberately kept (a no-comma variant was
  tried and rejected): "Admittedly" carries the self-deprecating,
  confession-like tone that makes the Jarvis reference land ("rather very
  intelligent," not just "intelligent"); "Always Capable" read smoother
  but flattened into a generic marketing line and lost that wink.
- Recorded as a second candidate alongside **"Steward"** for the blocking
  naming decision in `BACKLOG.md` (DA item) — nothing decided yet, still
  to resolve in the dedicated naming session per that item.

## 2026-10-04 — Antigravity integration validated locally

- Checked the installed Antigravity plugin (symlinked from this repo into
  `~/.gemini/config/plugins/project-tracker`): AGY loads both named hooks.
  Replayed the hooks by hand against the real config — session-start context
  on the first invocation only, silence outside scope, portfolio and
  per-project sub-page regenerated.
- Found and fixed a bug in `platforms/antigravity/hooks/session_start.sh`:
  the injected `ephemeralMessage` contained literal `\n` sequences instead of
  newlines. Added an assertion to `test_agy_session_start.sh` (seen failing
  first), then fixed the two message-building calls.
- The user then ran live Antigravity sessions and validated the integration.
  Next: the v0.13.0 release routine.

## 2026-10-04 — Release v0.13.0

- Cut v0.13.0 (dual-platform Antigravity support): versions bumped to
  `0.13.0` in `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`
  and `platforms/antigravity/plugin.json`; installer regenerated;
  `[Unreleased]` turned into `[0.13.0] — 2026-10-04` in `CHANGELOG.md`.
  DECISIONS (AGENTS.md pivot, unified config root) and BACKLOG were already
  up to date. All suites green (8 manifest, 151 portfolio, Claude hooks,
  Antigravity hooks, config migration).

## 2026-10-04 — Naming settled: BRACE

- Checked the candidates' availability with a few targeted searches.
  **Steward** is crowded (at least four Claude Code plugins, one with a
  near-identical "durable memory" positioning). **`project-tracker`** is
  crowded too (another Claude Code plugin with the exact same name),
  though this repo ranks first. **BRACE** is free in the Claude Code /
  AI-agent space.
- Explored acronyms ending in "PT" to keep the project-tracker lineage
  (JAPT, JADEPT, JARIPT, then non-J ones: ALEPT, ADEPT, KADEPT, MODEPT);
  ALEPT was the best of them. The user preferred BRACE, seeing its
  searchability weakness as something to exploit (curly-brace logo, "holds
  things together", "support").
- **Decided: rename to BRACE** (see `DECISIONS.md`). The DA item is
  unblocked; a rename item was added to `BACKLOG.md` with its open
  questions (repo name, `docs/project-tracker/` path, config dir, version
  bump). Nothing renamed yet.

## 2026-10-05 — BRACE 1.0 scoping (brainstorm paused)

- Started the spec for the rename. Measured the name's footprint (~50
  brand occurrences, 104 references to `docs/project-tracker`, ~100 to the
  config path), then settled, one question at a time: rename brand **and**
  config **and** per-project folder (`docs/brace/`, chosen once it was clear
  the design skill's files must fit the same logic), repo `doui445/brace`.
- Versioning discussion: semver vs. CalVer vs. Apple-style product numbers.
  The user preferred product-style; combined with a **zero-breakage** rule
  (old paths recognised forever) it has no downside. The rename becomes
  **BRACE 1.0**, a launch that lays a multi-skill foundation designed ahead
  for 1.1 (`brace:design`) — "like Apple, several versions ahead".
- The user ruled that the folder migration is **imposed, not proposed**,
  and asked to record the general principle: *propose or impose — think
  twice, depending on context*. Recorded in `DECISIONS.md` and `AGENTS.md`;
  versioning rule updated in `AGENTS.md` and the CHANGELOG header.
- Paused here by the user. Next: detail the 8 scope points, starting with
  how the imposed migration runs. Nothing implemented.

## 2026-10-13/14 — BRACE 1.0 spec completed

- Antigravity put **on standby** by the user (token budget there is too
  tight); watching its first real sessions is dropped from next actions.
- Resumed the paused brainstorm and settled every scope point, one question
  at a time: how the imposed migration runs, per-skill config, frontmatter
  keys, how a skill plugs in (on demand, hook dispatcher, portfolio detail
  section), and how installs switch from `project-tracker` to `brace`
  (logic in BRACE for good + a minimal 0.14.0 bridge). Detail in
  `DECISIONS.md` (2026-10-14).
- The user raised the multi-tool requirement (whichever tool migrates, all
  follow) and the on-demand skill model; both shaped the design.
- Open for the 1.1 spec, nothing decided: are `design` and `brand` one
  skill (the ladder frozen 2026-09-02) or two? The user notes they are not
  the same thing; the foundation accommodates either.
- Final spec written (gitignored), awaiting the user's review; then the
  implementation plan. Nothing implemented.

## 2026-10-14 — BRACE 1.0: install paths verified

- Claude Code (sandboxed config, local test marketplace): scripted
  `claude plugin install brace` / `uninstall` work, bare name included.
  Native `renames` works locally but is ruled out (per the docs, GitHub-added
  marketplaces need a manual reinstall); a bridge via `dependencies` fails
  (the update doesn't install the new dependency and the old plugin stops
  loading). Renaming the marketplace is safe if scripts use the bare name.
- Antigravity (dummy plugins, config backed up and restored): installing
  from the repo root picks up Claude-format hooks that never fire; a
  self-contained `platforms/antigravity/` folder (skills symlinked) installs
  and its hooks fire. Detail in the spec's section 9.
- The user ruled out any dev/normal install distinction: one clean,
  official install everywhere (GitHub marketplace for Claude Code,
  `agy plugin install` for Antigravity), including the author's machine.
  The home-made installers go in 1.0. See `DECISIONS.md` (2026-10-14).

## 2026-10-15 — BRACE 1.0 spec: review fixes

- From the user's review: skills also callable as `/brace:<skill>`; after a
  plugin swap BRACE tells the user to restart and close other sessions; a
  one-time "you're on BRACE, commands changed" notice; no read fallback for
  the old config paths (migrated first, old paths become links) — the old
  project folder stays recognised (portfolio + migration detection).
- Antigravity-only users had no official install path (installing the repo
  root picked up Claude-format hooks). Fixed and tested: Claude hooks
  declared via `"hooks": "./claude-hooks.json"` in the Claude manifest, the
  repo root carrying Antigravity's `hooks.json` / `plugin.json` — both tools
  install the same root and both fire their hooks.

## 2026-10-15/16 — BRACE 1.0: built, verified for real, released

- Implemented from the plan, one task at a time with a review after each,
  then a whole-branch review and a final fix wave; full suite green.
- The author's machine switched to BRACE before the release: its Claude
  Code installs the plugin from the repo folder (a directory marketplace
  that auto-updates), and the branch was checked out there. The bridge
  installed brace, then BRACE replaced the old plugin in both tools and
  moved the config. Nothing broke, and it served as a first real run.
- The user asked to fix the three limits left after the review rather than
  ship them: a pending swap is now settled by the tool's real restart (its
  process start time), not by the kind of session; a plugin installed for
  one project is replaced in place, its shared settings switching to brace
  with a commit offered; an old plugin BRACE cannot remove brings manual
  steps once a day, and dead project entries are ignored. The swap helpers
  now live once, in the bridge, sourced by both.
- Real checks (isolated Claude Code config, then Antigravity on this
  machine) found an Antigravity bug that dates back to 0.13.0: calls are
  numbered from 0, so the session start waited for the second call. Fixed
  (once per conversation id).
- The user wants no long dashes in any message (hooks, tests, commits).
- Published: the GitHub repo is renamed `doui445/brace`, `v1.0.0` tagged and
  pushed. Before that, an update from a local stand-in for GitHub was run end
  to end in an isolated config (bridge install, swap, deferred then completed
  project move).
- This machine now runs the published plugin: Claude Code from the GitHub
  marketplace `doui445/brace` (auto-update on), Antigravity reinstalled from
  GitHub. The repo folder is no longer live here.

## 2026-10-16 — `design` and `brand` split settled

- Brainstorm on the one-skill-or-two question left open for the 1.1 spec.
  The user drew the line on two axes at once: substance vs form, and brand
  projects vs any project with an interface.
- Settled: two skills; `design` owns everything visual, logo included,
  and reads `brand/` when it exists; `IDENTITY.md` stays in `track`;
  `kind:` loses its `brand` value; `design` is 1.1, `brand` 1.2. Detail in
  `DECISIONS.md`. Nothing built; the `brace:design` spec comes next.
- Also scoped a user capture from Reminders (2026-10-10): tidying a bloated
  `AGENTS.md` becomes a `track` capability for 1.1 (on request, plus a
  one-time proposal past a size threshold), not a separate skill; the global
  `~/.claude/CLAUDE.md` stays out of BRACE. Backlogged.
- The Reminders writes (tick the naming decision, retitle the design spec
  reminder, add the Antigravity-copy one) were refused: the server needs a
  confirmation form this session cannot show. Left to the user or the next
  session.

## 2026-10-17 — First `brace:design` choices, then the order swapped

- Started the `brace:design` spec brainstorm and settled its first
  choices (detail in the `BACKLOG.md` design item): three roles in one
  loop (guide, route, record); a creation path that depends on `kind:`;
  one question at the first UI work; seeding `DESIGN.md` from existing
  code for non-brand projects only; drift flagged and decided by the user.
- The user's rule that a brand does its identity first raised the "brand
  project without brand in 1.1" gap. Asked why design came first; the
  answer showed the reasons no longer held, and the order was swapped:
  `brand` is 1.1, `design` 1.2 (`DECISIONS.md`). Nothing built; the
  `brace:brand` spec comes next.

## 2026-10-18 — `brace:brand` scoping, and what a BRACE agent is

- Brainstorm on the `brace:brand` spec: profiles, research, voice,
  revision, rebrand and structure settled (detail in the `BACKLOG.md`
  brand item).
- The user wanted the research done by a real, fully specified agent
  launched whenever competitive research comes up, then asked what
  really separates a skill from an agent, compared with the per-trade
  project agents of an external project (a main agent set in its
  settings, plus specialists in `.claude/agents/`), and raised the
  freelancer vs in-house hire question. Settled the rule for every future
  agent (`DECISIONS.md`): BRACE agents in the plugin, each learning a
  project from `docs/brace/agents/<agent>/`; project agents stay the
  project's own. The folder layout is the user's call. Nothing built.

## 2026-10-19 — `brace:brand` spec written

- The user asked whether the brand method matched real practice. A web
  check (agency process, roles, customer interviews, message testing,
  brand architecture, brand health) and a pass over the video corpus
  confirmed it and added seven points (`BACKLOG.md` brand item); customer
  interviews are the corpus's real gap, brand architecture comes from the
  web only.
- Other trades reviewed for BRACE agents: `reader` (fresh eyes) and
  `auditor` backlogged; `analyst` stays the only agent in 1.1.
- Spec written in `docs/superpowers/specs/` (gitignored), awaiting the
  user's review; then the implementation plan. Nothing built.
- Before approving the spec, the user asked whether the logo belongs to
  the brand rather than to design. It does (`DECISIONS.md`): a brand's
  face moves to `brand`, shipped in 1.2 with `design`; the 1.1 spec only
  gains that framing.

## 2026-10-19 — `brace:brand` and the `analyst` agent built (branch `feat/brand`)

- Plan executed inline: the reserved `docs/brace/agents/` folder, brand
  i18n headings, test discovery for every skill, the review reminder and
  voice-drift hooks, the `analyst` agent (one file per tool, same body),
  the brand skill and its seven references, the agents contract and docs.
- Checked for real (headless Claude Code, `--plugin-dir`): `brace:analyst`
  loads once and `brace:brand` is listed; a quick mission in a tracked
  test project wrote only its brief and dated report, in the agreed
  format; outside a tracked project it wrote nothing.
- A fresh whole-branch review found no critical issue; fixed three: the
  voice reminder never reached Antigravity (its adapter drops post-write
  output; the touchpoints are now listed at session start), a project
  still on the legacy folder could get a second one, and the Touchpoints
  heading had to match exactly. Six minors deferred.
- Not done yet: an interactive brand session and the Antigravity install
  check (it would overwrite the published copy on this machine). Not
  merged, nothing pushed.
- The user asked to fix the six deferred minors too, all done with tests:
  the voice marker hashes the file path (no collision, no over-long
  name); a review date followed by a comment is read; the foundations get
  their own `brand_stage: foundations`, and a resumed session skips what
  is written and reuses a filed report; the analyst writes one report per
  subject; a guard test keeps the Claude agent copies invisible to
  Antigravity; the platform notes say every skill's hooks run.
- Antigravity check (branch installed in place of the published copy,
  backed up, then the published 1.0.0 reinstalled from GitHub): `agy plugin
  validate` and the install both load exactly one agent (the Claude copy in
  `agents/claude/` is ignored); the user started the analyst from the app
  and it runs. The `agy` command line is not logged in on this machine, so
  no headless mission was run there.

## 2026-10-20 — First real brand session, on BRACE itself

- `/brace:brand` run on BRACE, following the branch's skill literally,
  product profile. Foundations and strategy written in
  `docs/brace/brand/`: purpose, Jarvis-like personality with Apple as the
  second reference figure, six values (privacy among them, its limits to
  discuss), the Sage with a touch of the Magician, serenity resting on
  trust, friction as the enemy; objectives, two provisional personas,
  landscape, six differentiators, positioning, mechanism, proof points,
  spontaneous recommendations as the indicator, touchpoints, non-goals.
  Voice and test still to do.
- The real analyst ran four missions (competitors and audience full,
  an Apple benchmark and a multi-agent memory check quick). Findings that
  changed the strategy: "never forgets" alone is common now; ECC already
  shares a memory across harnesses, so the differentiator is a readable
  project record, not sharing itself.
- A questionnaire page was shared with six people from the owner's
  circle; their raw answers stay in the gitignored research folder, only
  anonymised personas are committed. Token limits came up three times; 4
  of 6 use AI in web apps, which BRACE does not reach today.
- The session found three defects (in `BACKLOG.md`, blocking the merge):
  the analyst's writes are denied because it runs in the background; it
  cannot use a browser for pages its fetch tool is refused; the
  touchpoints helper takes any backticked name in the section. Plus a new
  idea: all session messages in one file.

## 2026-10-22 — BRACE brand finished (test deferred)

- Voice written in `docs/brace/brand/VOICE.md`: the word lists, an
  introduction post (French), four attributes, tone by context (its
  plugin-message row is the rule for hook messages), lexicon, writing
  rules (no long dash, no exclamation mark, no slash, semicolon or vertical
  bar in prose), four message pillars, the tagline "Finally on the same
  page.", the one-liner, the presentation text, the acronym as signature.
  Choices and what was set aside in `docs/brace/brand/DECISIONS.md`.
- The name stage was skipped (BRACE settled 2026-10-04). A five-second
  test page is ready; the owner chose to run it later, recorded as not
  tested yet. Brand set to `done`, reviewed 2026-10-22.
- Tagline, one-liner and presentation carried into the README (with an
  "About the name" section) and the three manifests; suite green. Fed the
  README edit to the branch's post-write hook by hand: it flags the
  touchpoint as expected. The voice check it asks for finds the rest of the
  README drifting (26 long dashes, slashes in prose); left as is for now.
- New ideas logged: a writing skill; all session messages in one file.
  The owner also noted small issues in how the skill runs, to collect next
  session. Not merged, nothing pushed.

## 2026-10-26 — The BRACE agency: vision discussed (nothing built)

- Started from the owner's "small issues" note on the brand session: the
  real point is that `brand` should feel like a full agency taking over
  whenever a project is meant to be shown or sold, not a list of brand
  questions. Read an exported AI chat about how branding agencies work
  (roles, phases, documents) and checked it on the web: strategy before
  design, two or three routes then one refined, internal reviews before
  the client sees anything all hold; its price range was low (a 2026
  French barometer gives a 10,000 EUR median).
- Agreed shape: skills are domains named by a short verb (`track`,
  `brand`, `design`, `market`); agents are real agency trades
  (`analyst`, `strategist`, `art-director`, `designer`, `copywriter`,
  `creative-director`, `researcher`), hired only when a domain needs one,
  each with its own margin. The agency is a shared method (one
  interlocutor, examples and references, two or three routes, an explicit
  call between the owner's taste and the audience, an internal review)
  plus handoffs between domains, followed by `track`.
- `brand` keeps the brand's face (logo, palette, goodies, ads); `design`
  covers the product (an app, or an object up to the maker's brief, no
  technical drawings); a person is a personal brand. `market` prepares
  everything and publishes only on an explicit yes, item by item, and
  never spends money. For an app: brand, design, development (outside the
  agency), market, with pre-launch work during development.
- The agency offers itself once per project, right after the owner
  describes it, if it is meant to be shown or sold; the answer is kept.
- Permission defect: proposed a BRACE hook letting each agent write only
  in its own `docs/brace/agents/<agent>/` folder (plugin agents ignore
  `permissionMode`, hooks do fire inside them). To test for real first.
- Still open: the order of the work and how it maps to releases; renaming
  the repo folder to `brace`. Nothing built, nothing committed.

## 2026-10-26 — The brand agency built (feat/brand)

- Wrote the design and the plan, then built it on `feat/brand`: the
  agents' write hook, the touchpoints fix, the presentation notification,
  the analyst's changes, three new agents, the presentation template, the
  skill rewritten in sessions, and the docs.
- Real test of the write hook in a non-interactive Claude Code run: the
  `analyst` in the background wrote its file in its own folder; the same
  run from a copy of the plugin without the hook was blocked. A write to
  the brand folder was never attempted (the agent refused it by its own
  rule); the hook gives no decision there, as its tests check.
- Left: a real trial with the owner on Claude Code and Antigravity, then
  the release.
- Final review of the whole branch: one critical finding (a newline in
  the file path let the write hook allow a path outside the agent's
  folder) and three important ones (a dangling symlink in the agent's
  folder, no way to resume a brand started on 1.0, open questions left in
  the presentation step). All fixed with a test that failed first; suite
  green. Five minor findings kept for later (`BACKLOG.md`).
- The real trial is postponed by the owner, still the next step before
  the release.

## 2026-11-01 — Real trial of the brand agency (Claude Code)

- Full mission on a throwaway project with `claude --plugin-dir .`:
  tracking, workshop, backstage, strategic presentation, adjustments,
  delivery, `brand_stage: done`. About an hour of active time.
- Held: no permission prompt during the background work (the agents'
  write hook works); the owner found the presentation and the workshop
  questions "straight to the point".
- Measured from the transcript: about 14 to 15 M tokens read (98% from
  cache) and 115 k written for the mission; the main conversation is 95%
  of it, the four agents 5%. The lever is the main conversation, not the
  agents' model.
- Gaps, all in `BACKLOG.md`: no notification (the final deck was filed
  with `cp` in Bash, the hook only sees `Write`/`Edit`), decks in English
  for a French-speaking owner, no word up front on the steps and the
  cost, the creative director blind to the render without `pdftoppm`, a
  settled name reopened as a question. Also logged: redo the deck frame
  once BRACE has its own visual identity.
- Left before 1.1.0: fix these gaps, then the same trial on Antigravity.

## 2026-11-02 — The trial fixes (feat/brand)

- The owner asked to start without questions; my calls are marked in the
  spec (local, `docs/superpowers/specs/2026-11-02-brand-trial-fixes-design.md`).
- Notification: the Claude Code `PostToolUse` hook now also runs after
  shell commands, and the brand hook scans the final decks instead of
  watching the written file: a deck filed with `cp` is notified, once per
  session, in its own language. Decks already there at session start are
  marked seen. Checked by hand: the hook run on the trial deck showed the
  notification.
- Two languages asked at the workshop (working, brand), kept in
  `BRIEF.md`; an opening message with the steps, time and measured cost;
  a new fact never reopens a settled choice.
- Lighter main conversation: `brand` no longer reads screenshots; a new
  `shoot_deck.sh` gives the creative director one PNG per slide (checked
  with the real Chrome on the trial deck). The deck assembly by an agent
  waits for the next measure (`BACKLOG.md`).
- The five minor review findings fixed. Suite green.

## 2026-11-05 — Where the agency and the welcome should go

- The owner wants BRACE to feel like someone, and the agency like a real
  agency: its vocabulary, named team members, a commercial proposal with
  the budget, the real documents an agency writes (rendered by a shipped
  script in BRACE's house style), a client space, minutes after each
  meeting, meetings in the calendar, the tagline approved rather than
  "the README". Line kept: never posing as humans.
- Tracking gets a welcome: nickname, what tracking is, the global
  language once, questions that fit projects without code, the durable
  commit and push authorization asked with the backup question, a
  "what's new" after an update.
- Asked whether the agent can end its own session: no, and background
  agents die with the session; the agency instead says when the work is
  done and invites the user to close, and the next session resumes.
- Order: the trial fixes committed; the agency next (before 1.1.0) with
  test names, then the agency run on BRACE itself to name its team; the
  welcome right after. Both in `BACKLOG.md`.

## 2026-11-05 — The real agency built (feat/brand)

- Spec and plan written and approved, then built inline in seven tasks,
  each test first: catalogue (team, lexicon, client space), `render.py`
  (documents, decks, client space), hooks (the client space as the ready
  signal, the mission resuming at startup and after `/clear`), agents
  writing the client documents, the skill rewritten meeting by meeting
  (`contact.md` and `documents.md` new).
- The deck example is now Markdown rendered by the script; the visible
  rendering is unchanged (checked by screenshot).
- Next: a real trial of the agency on BRACE itself, which also names the
  team.

## 2026-11-05 — The real agency reviewed

- Whole-branch review by a fresh reviewer: one critical finding (the
  Markdown renderer looped forever on a stray pipe or an indented quote),
  three important ones (the first contact set no stage, so no resume at
  the workshop appointment; Antigravity lost its touchpoint list during a
  mission; emphasis broke links), nine minor ones. The owner asked to fix
  them all: each with a test that failed first; suite green.

## 2026-11-05 — The rebrand, settled

- The trial on BRACE itself becomes a rebrand (its brand dates from 1.0).
  The agency's rebrand path predates the real agency, so it gets its own
  work first: archive, audit, extent, before and after, missing documents
  made, transition plan, announcement, folder rename proposed as a
  command for after `/exit`. In `BACKLOG.md`; the spec is written.

## 2026-11-05 — The rebrand built (feat/brand)

- Spec and plan approved, built inline in four tasks, each test first: a
  `compare` slide (today next to tomorrow), the rebrand documents in the
  agents (audit, transition plan, announcement; the analyst checks a new
  name's availability, never as legal advice), and `references/rebrand.md`
  meeting by meeting.
- The folder rename, settled with the owner: the agency does it itself as
  the session's very last action (folder and Claude Code memory in one
  command, tested with spaces in the paths), the GitHub rename under a
  separate confirmation.
- Next: the agency rebrands BRACE in this repo.

## 2026-11-05 — The rebrand reviewed

- Fresh review: no critical finding, three important ones (the rename
  command moved the memory even when the folder rename failed; the
  rebrand marker relied on the first `SESSIONS.md` entry; renaming the
  folder the plugin runs from breaks its own hooks), eight minor ones.
  All fixed: the command now runs from a real test (spaces, existing
  target, no memory, failed move) and copies the memory instead of moving
  it; the session start names a rebrand from the last `- mission:` line;
  with `--plugin-dir` inside the folder the agency gives the command for
  after `/exit`; the table and the slide no longer share a class (the
  real cause of the earlier offset); the columns default to today and
  tomorrow; the archive is taken before the proposal.

## 2026-11-05 — A returning client, and the trial set for tonight

- Gap found by tracing the path: on a delivered brand with no precise
  request, the skill had nothing to resume and would improvise. Now the
  account director asks what brings the client back and offers a review,
  a rebrand or a one-off request, with a recommendation from the signs she
  sees. Tested; suite green.
- The trial is set for tonight: `/brace:brand` on BRACE without saying
  "rebrand", to check that the agency proposes it itself.

## 2026-11-06 — The rebrand trial, up to meeting 2

- `/brace:brand` on a delivered brand: the agency asked what brings the
  client back and recommended the rebrand from the signs it saw. Archive,
  proposal, framing workshop, then the team's backstage (benchmark, audit,
  personas, three routes, words, references, deck, two reviews), all
  in one session.
- Found on the way: auto mode's classifier gave no verdict on the
  agency's writes twice (the client had to leave auto mode); the macOS
  calendar tool had write-only access, so no event could be created; a
  `reco` item starting with bold text and " : " breaks the slide into
  narrow columns; French guillemets need non-breaking spaces in decks.
- The client widened the target (anyone with several concrete projects),
  kept the tagline (its first meaning, "agreed", ties all the skills),
  asked for a short explanation of the signature in English and French,
  and for the team's real first names, now proposed.

## 2026-11-07 — The rebrand trial, meeting 2 held

- Meeting 2 ran early (the client came back before the appointment).
  Repositioning chosen. None of the three routes convinced at first: asked
  "what is BRACE?", the client answered "your projects, up to date, but
  above all projects that look like you"; the team wrote a fourth route
  from it, then the client settled on route 3 with that phrase as the
  colour of the texts. French tagline: "Enfin sur la même longueur
  d'onde." (the calque "sur la même page" checked by the analyst).
- The team's names were hired from three rounds of checked candidates
  (Julie, Ravi, Constance, Ben, Lou); they take effect at delivery.
- Then the backstage for meeting 3: platform, editorial guide, manifesto,
  one review round. Next appointment 2026-11-07 14:00.
- Found on the way: the client wants to choose among candidates rather
  than accept one set; and does not want the chat to repeat what an
  opened document says. Auto mode's classifier again blocked the
  agency's closing writes without a reason. A product idea logged in
  `BACKLOG.md`: brand work alongside an existing agency's documents.

## 2026-11-07 — The rebrand trial, meeting 3 held

- The client came early and started meeting 3 at once. Platform, editorial
  guide and manifesto validated one by one, each with small changes: value
  3 renamed "Check before claiming"; the privacy limit settled and checked
  in the code first (BRACE sends nothing itself; GitHub and Reminders are
  the user's call); the description now says it reads the project first
  and only asks what it cannot know; the manifesto adds that BRACE
  suggests ways of working and tools, and offers to install them.
- The brand files (`FOUNDATIONS.md`, `STRATEGY.md`, `VOICE.md`, brand
  `DECISIONS.md`) carry the validated platform; `VOICE.md` is now English
  from the French guide.
- Product idea logged in `BACKLOG.md`: help the user get the most out of
  their AI (tools presented with pros and cons from fresh research and
  feedback, and one catalogue of every tool BRACE can propose).
- Then the delivery backstage: name check among plugins (minor doubt,
  nothing blocking), test plan, transition plan, announcement, the texts
  in place; one review round. Meeting 4 set 2026-11-09 14:00, in the
  client's calendar (the agency asked which calendar once, kept in
  `~/.brace/prefs.txt`).
- Found on the way: auto mode's classifier again refused writes without a
  verdict (a subagent's and then brand's own), cleared by leaving auto
  mode; a subagent first reported "written" for a file that was not on
  disk, so the agency checks its agents' files before relying on them.

## 2026-11-08 — The rebrand trial, delivered

- The client came back a day early and took the delivery at once. Test:
  checked personas, not real people (hypothesis, not tested; the
  entrepreneur's door unsupported, the "agreed" reading of the tagline
  fragile). Tagline and description validated in place; README top and
  the three install descriptions now carry the editorial guide's text.
  Transition and announcement validated (the announcement waits for 1.1).
- The client overrode the agency on one point: the folder becomes `brace`
  now (`project: brace`). BRACE runs from this folder (`--plugin-dir .`),
  so the rename is the command to run after `/exit`.
- Mission closed: `brand_stage: done`, review 2027-05-10 in the client's
  calendar (meeting 4's event moved), heritage kept and dropped in the
  brand `DECISIONS.md`, team renamed in both catalogues (Julie, Ravi,
  Constance, Ben, Lou).


## 2026-11-08 — The rebrand trial, read live by the owner

- The owner ran the trial in one session and reported each point in a
  second one as it happened; every point is kept in the local notes
  (`docs/superpowers/research/2026-11-06-rebrand-trial-feedback.md`) and
  drives the fix pass (`STATUS.md`, action 1).
- What worked: the proposal's clarity, the brief's substance, the agency
  resuming on its own at the right meeting, the interview offer, the
  manifesto introduced at its top, the calendar once given full access.
- What did not: the console does not yet sound like a person (labels,
  numbered meetings, menus about the process, a credits list of first
  names, documents restated); internal working documents shown, two of
  them contradicting each other; feedback pasted into a text instead of
  rethought; the team producing while the client waits; an empty delivery
  meeting; chatter while the team works; the client space never introduced,
  in the wrong language, listing internal files.
- Settled with the owner: the agency imposes the process and proposes the
  brand (accepting the proposal and the client's agenda stay the client's
  call); documents are written as documents, decks carry the team's voice
  through short signed annotations; present horizontally, read vertically,
  one form per document; minutes filed, not shown nor validated; the
  working language asked at first contact, the brand's main and secondary
  languages at the workshop; auto mode advised by Claude itself, out of the
  agency frame; tokens kept low by design, a point BRACE can put forward.
- The owner questioned the visual identity sitting in `brand` (1.2, decided
  2026-10-19): not reopened; the new meeting flow keeps a slot for a visual
  phase, the decision is revisited at the 1.2 spec.

## 2026-11-08 — The fix pass scoped, and the version order changed

- Read the rebrand trial's transcripts: about 30 M tokens read from cache
  on Opus (the conversation) against 10 M on Sonnet (the team); the cost
  sits in rereading the main conversation. The 17-minute work batch was
  mostly the write, review, fix chain (3 minutes of permission waits);
  two name rounds took 33 and 46 minutes on 16 to 21 quick searches. The
  agency advised against the folder rename because the strategist read
  the rule as applying only when the brand's name changes.
- Settled with the owner: four pieces of work (the renderer and the
  client space, the account director writing without prompts, the
  agency's voice and flow, a light intake of the brand work the client
  already has), then 1.1. Version order changed: 1.2 = the brand's face
  in `brand`, 1.3 = `design` (see `DECISIONS.md`). The scope is proposed
  from what the client already has; the client stays in charge of it.
- Budget in the proposal: a token range from the two real measures, with a
  frugality commitment; the weekly quota share to measure at the next
  trial (`/usage` before and after).
- Spec written (local, gitignored) and checked by a builder review; the
  plan comes next.

## 2026-11-08 — The trial fix pass built

- Built the fix pass from the rebrand trial on `feat/brand`, task by task
  with tests: the renderer (wrapped and nested lists, rules, no repeated
  title, signed deck notes), the client documents table with a phase and
  a form, a client space that reads the mission's language, name, meetings
  and client documents only, in tabs with the brand at a glance and a
  shortcut at the project's root, a "Brand" link in the portfolio, and
  the main conversation allowed to write in the agency's folders.
- Rewrote the skill's prose: how the agency speaks, process and brand, the
  mission as phases (a slot kept for the visual of 1.2), the five-part
  meeting, the first contact with the client's existing brand work and a
  proposed scope, the workshop's languages, the backstage questions asked
  in one batch, feedback as an intent, the handover, and the agents.
- Found on the way: an existing space kept its old stylesheet (the house
  stylesheets are now refreshed), BRACE's own mission needed fallbacks for
  its language and name, and a meeting already started still showed as
  the next one at session start.

## 2026-11-08 — The fix pass reviewed

- A whole-branch review found no critical issue. Fixed: a mission begun
  before this pass kept its earlier meetings at its first held line; two
  meetings of one phase keep their own minutes; the shortcut's exclude
  line is escaped for git; `rebrand.md` no longer says to validate
  documents one by one; the resume line no longer invites a who-did-what
  recap.
- Then its four minors: the client space's home shows what we need from
  the client (`- ask:` lines), a long brand name is capped in the
  shortcut, a `.git` file (worktree, submodule) gets its exclude through
  `gitdir:`, and a third list level goes back to the first.
- The real auto-mode check moves to the next trial (owner's call).

## 2026-11-08 — BRACE 1.1.0

- Checked the client space in a headless Chrome: tabs by click and arrow
  keys, the root shortcut, the portfolio's "Brand" link. Fixed what it
  showed: panel titles missing on paper, Home and End keys in the tabs,
  the portfolio's two card links stacked on two full-width lines; and the
  space now writes dates in words in the working language.
- The two 1.1 riders (keep the Antigravity copy up to date, tidy a
  bloated `AGENTS.md`) move after `brace:design`: unrelated to `brand`,
  each needs its own small spec. BRACE's own mission keeps its documents
  signed with the team's former first names, as its archive.
- Released 1.1.0: `feat/brand` merged into `main`.

## 2026-11-09 — 1.1.0 published

- `main` and the `v1.1.0` tag pushed; the repo's GitHub description and
  topics now carry the new positioning.
- The copywriter's announcement, brought up to the 1.1.0 that shipped
  (the client space, the real meeting flow, the update commands), is the
  GitHub release; a short "New in 1.1" paragraph sits under the README's
  opening.
- BRACE has no social account yet: the announcement's short post waits,
  noted in the backlog to discuss later.
