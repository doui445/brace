# Changelog — BRACE

All notable changes to this project. Format based on
[Keep a Changelog](https://keepachangelog.com/).

**Versioning.** Product-style from the BRACE 1.0 launch (decided
2026-10-05; `0.x` = the `project-tracker` pre-history). `major` = a new
generation, launched and announced. `minor` = a new skill, command, hook,
config knob or standard file, or any change to how the plugin behaves.
`patch` = fixes, docs and guidance, no-behaviour-change refactors. Whatever
the bump, a release never breaks an existing project. The version lives in
`plugin.json` / `marketplace.json` (kept equal); the release routine is in
`AGENTS.md` § Releasing.

## [Unreleased]

## [1.1.0] — 2026-11-08

### Added
- `brace:brand`: builds and keeps alive a brand's substance in
  `docs/brace/brand/` (`FOUNDATIONS`, `STRATEGY`, `VOICE`, `DECISIONS`), for
  product and personal brands; review reminder after 6 months; voice checks
  on the touchpoint files.
- The `analyst` agent, BRACE's first agent: background research
  (competitors, market, audience, name availability), sourced, learning
  each project from `docs/brace/agents/analyst/`.
- The agents rules in `references/skills-contract.md`.
- `brace:brand` works as an agency: a workshop on a pre-filled brief, the
  team working in the background, a strategic presentation with two or
  three routes, adjustments validated one document at a time (shown
  rendered), and a delivery page with a preference and comprehension test
  to run with real people. New brand files `BRIEF.md` and `SESSIONS.md`.
- The client space is a tabbed portal (home, meetings with their minutes,
  documents, presentations, and "My brand", the brand at a glance, which
  becomes its home once delivered), with a shortcut at the project's root
  during the mission and a "Brand" link on the portfolio card. Dates
  read in words, in the working language; it prints whole.
- Decks carry short notes signed by the teammate who would present each
  slide (screen only).
- A mission's scope is proposed from the brand work the client already
  has (theirs or an agency's), never offered as a menu; the client's
  documents are attached and kept as theirs. A creative brief for whoever
  does the visual when the scope leaves it out.

### Changed
- The front page and the install descriptions carry BRACE's new
  positioning ("an assistant you can agree with"), from its own rebrand.
- The agency's team is now Julie, Ravi, Constance, Ben and Lou.
- Three new agents: `strategist` (positioning routes, creative brief),
  `copywriter` (the words of each route), `creative-director` (internal
  review of the routes and of the rendered presentation).
- Brand presentations: local HTML pages that read as a deck and print to
  PDF one slide per page, from a template shipped in
  `skills/brand/assets/` with free fonts (Fraunces, Inter, OFL).
- A macOS notification when a brand presentation is ready, in the
  presentation's language, however the file was written.
- The brand workshop asks for two languages: the working language
  (conversation, presentations, documents) and the brand's language (what
  the public reads).
- A brand mission opens with its five steps, about an hour of active
  time, what needs the user and what runs alone, and its measured cost.
- `skills/brand/scripts/shoot_deck.sh`: one screenshot per slide, so the
  creative director sees the rendered presentation without a PDF reader.
- The agency works like a real one: a named team (provisional names, from
  the catalogue), a first contact with a proposal (scope, meetings, time,
  budget), five meetings that each end with minutes and the next
  appointment (in the calendar when possible), the documents an agency
  writes (benchmark, personas, routes, brand platform, editorial guide,
  manifesto, test plan), and a client space listing them.
- `skills/brand/scripts/render.py`: renders documents, decks and the
  client space from Markdown in the house style (`assets/doc.css`, the
  deck model in `assets/example.md`).
- A brand mission in progress brings the agency back at session start and
  after `/clear`, with the next meeting when the client comes back early.
- A rebrand runs as a real agency mission: "why now" first, the current
  brand archived, an audit and the extent as the client's decision, a
  before and after for each route (a new `compare` slide), the brand
  documents never made produced along the way, a test with current users,
  a transition plan and an announcement, and the folder renamed as the
  session's very last action when the name changes.
- A client who comes back to a delivered brand without a precise request
  is asked what brings them back: a review, a rebrand or a one-off
  request, with the agency's recommendation.
- A `PreToolUse` hook on Claude Code: a BRACE agent writes in its own
  `docs/brace/agents/<agent>/` folder without a permission prompt, and
  only there.

### Changed
- The portfolio detail page ignores `docs/brace/agents/`.
- `run_tests.sh` runs every skill's tests.
- The `analyst` takes its research depth from the caller (never asks the
  user), can read refused pages with a browser when one is available, and
  finds references (brands that made a comparable choice).
- The Claude Code `PostToolUse` hook also runs after shell commands.
- `brand` no longer reads presentation screenshots itself (the creative
  director does, in its own context): a lighter main conversation.
- A new fact on a settled brand choice is reported, never asked again.
- The brand notification now means the work is ready: it waits for the
  client space, rendered last after every tracking file.
- The agents write the client documents; the creative director reviews
  them too.
- The tagline is approved in the client's words, then applied and saved
  (commit and push without a question once allowed).

- The account director speaks like a person (full sentences, "our team",
  no credits, no menus about the process, a meeting named by its subject)
  and runs the agency's process herself; the client decides the brand,
  the scope and their own time.
- A mission is a plan of phases built from the scope, with a slot kept
  for the visual identity of a later release. Each meeting runs in five
  parts; the questions for the next phase are asked in one batch before
  the team works; silence while it works, then a short end-of-session
  notice outside the agency.
- Only client documents are rendered and shown, one at a time, each in
  one form (presented in a deck or read as a page) and written as a
  document; the team's internal work stays internal. The minutes are
  filed, never shown or validated. Feedback is rethought as an intent.
- The delivery is a real handover deck; the test option is chosen at the
  platform meeting.
- The working language is asked at the first contact; the workshop asks
  the brand's main and secondary languages.
- On Claude Code, the main conversation writes in the agency's folders
  (`docs/brace/brand/`, `docs/brace/agents/brand/`) without a prompt.
- The analyst's quick research is capped at about six searches per
  subject; tabs opened in the client's browser are closed.
- The house stylesheets are refreshed in a project when the shipped ones
  change.

### Fixed
- Brand touchpoints are read from the list items of the section only: a
  file named in a note there is no longer a touchpoint.
- Background agents' writes to their own folder were denied; they now
  land without a prompt.
- An agent can no longer write into a project nested in an agents folder.
- The brand notification checks the language code, reads a `language:`
  line after a tab, and strips backslashes from its text.
- The renderer never loops on a stray pipe or an indented quote, keeps
  links intact, reads tracking files with a bad byte, and says when a
  source is not UTF-8. The client space shows the mission, links the
  minutes, and hides a past meeting; one copy of the fonts per project.
- The mission resume reads a `SESSIONS.md` with Windows line ends and
  ignores an older meeting when the newest line is malformed; the first
  contact sets the stage; Antigravity keeps its touchpoint list during a
  mission.
- The renderer keeps wrapped list items in their item, renders one
  nested list level and `---` rules, and drops a title repeated as a
  heading. The client space follows the mission's working language and
  the brand's name, shows a real mission line, lists only the meetings
  and the client documents (latest version), and no longer shows a meeting
  already started as the next one.
- The folder rename is recommended whenever the brand's name differs from
  the folder's, after a repositioning too.

## [1.0.0] — 2026-10-16

### Added
- BRACE 1.0 foundation: one hook per event acting as a dispatcher
  (`dispatch/run.sh`) with per-tool adapters; skills plug in by dropping
  `skills/<skill>/hooks/<event>.sh`; per-skill sections on a project's
  portfolio detail page; `references/skills-contract.md`.
- Automatic, permanent move from project-tracker: old plugin replaced in
  Claude Code and Antigravity, config moved to `~/.brace/`, each project's
  `docs/project-tracker/` moved to `docs/brace/` at its first session after
  a real restart of the tool (detected from when the tool's process
  started, so a `/clear` or a new Antigravity conversation in a running app
  does not count).
- A plugin installed for one project is replaced in place: that project's
  shared `.claude/settings.json` switches to brace, and a commit is offered.
- When the old plugin cannot be removed automatically, the user is told how
  to do it by hand (at most once a day).
- `project-tracker` 0.14.0 bridge that installs brace; it shares its swap
  helpers (`bridge/hooks/swap_lib.sh`) with BRACE's own migration.

### Fixed
- Antigravity: the session start now runs on the first model call of each
  conversation (Antigravity 1.3 numbers calls from 0, so it used to wait
  for the second call, or never ran in a one-turn conversation).

### Changed
- Renamed to **BRACE**: plugin `brace`, skill `brace:track`, command
  `/brace:config`, repo `doui445/brace`.
- The repo root installs as-is in Antigravity (`agy plugin install
  https://github.com/doui445/brace`).

### Removed
- Home-made installers (`install-project-tracker.sh`,
  `install-antigravity.sh`, `build_installer.sh`): official installs only.
- `platforms/antigravity/` (merged into the repo root).

## [0.13.0] — 2026-10-04

### Added
- **Native Antigravity (AGY) support:**
  - `platforms/antigravity/plugin.json` and `platforms/antigravity/hooks.json` manifests.
  - `platforms/antigravity/hooks/session_start.sh` (`PreInvocation` hook for scope & tracking detection).
  - `platforms/antigravity/hooks/portfolio_regen.sh` (`PostToolUse` hook on file edit/write).
  - `platforms/antigravity/hooks/reminders_sync_trigger.sh` (`PostToolUse` hook).
  - Complete test suites for Antigravity hooks (`test_agy_session_start.sh`, `test_agy_portfolio_regen.sh`).
  - `install-antigravity.sh` one-shot installer for Antigravity plugin.
- **Unified config directory:**
  - Canonical config moved to `~/.project-tracker/` with symlinks from `~/.claude/project-tracker` and `~/.gemini/project-tracker`.
  - Migration script `skills/track/scripts/migrate_config.sh` and its test suite `test_migrate_config.sh`.
- **Platform reference guides:**
  - `skills/track/references/platform-claude.md` (Claude-specific tooling: `AskUserQuestion`, hooks format, console views).
  - `skills/track/references/platform-antigravity.md` (Antigravity-specific tooling: `ask_question`, hooks protocol, silent `PostToolUse`).

### Changed
- **`AGENTS.md` pivot:** `AGENTS.md` is now the canonical root instructions file for all tracked projects (compatible with Antigravity, OpenAI Codex, Copilot, Cursor). `CLAUDE.md` is preserved as a symlink pointing to `AGENTS.md` for Anthropic tooling compatibility.
- **`generate_portfolio.py` config resolution:** looks up `~/.project-tracker` first, then falls back to `~/.claude/project-tracker` or `~/.gemini/project-tracker`.
- **`SKILL.md` neutralisation:** platform-agnostic wording, references `AGENTS.md` and links to platform-specific references for tool invocation details.

## [0.12.2] — 2026-09-19

### Changed
- **`SKILL.md` slimmed down (no behaviour change).** The `## Sub-projects`
  subsystem moved to `references/subprojects.md` (same pattern as
  `backlog-phases.md`), leaving a short pointer and the in-session attach
  trigger in `SKILL.md` (386 → 335 lines). The frontmatter `description`
  now states trigger conditions only instead of listing the nine tracked
  files.

## [0.12.1] — 2026-09-19

### Fixed
- **Session-start check no longer deferred.** The `SessionStart` hook said
  "propose an update if needed", which Claude could read as optional and
  postpone (asking the user first) when the session opened on an unrelated
  request. The hook message and `SKILL.md` now state the check is automatic
  and runs in the first reply, alongside the user's request.

## [0.12.0] — 2026-09-19

### Added
- **Nested tracking.** A tracked project can now chaperone **sub-projects**:
  sub-folders that each hold a genuine project of their own, detected via a
  nested `.git` and attached through the same 3-way choice used for
  top-level projects. An attached sub-project is either just listed
  (`tracked: false`) or given its own small file set — `README.md`,
  `CHANGELOG.md`, `DECISIONS.md`, `ERRORS.md` always, plus optional
  `ARCHITECTURE.md`, all flat at its own root — recorded in the parent's new
  `subprojects:` frontmatter list. A new `SUBPROJECTS.md` (created on first
  need, like `GLOSSARY.md`) gives one section per sub-project; the parent's
  own `STATUS.md`/`JOURNAL.md`/`ROADMAP.md` stay global rather than
  duplicating sub-project detail. A one-time `nested_model` migration check
  scans already-tracked projects for pre-existing git sub-repos to offer for
  attachment. Opening a session inside a `tracked: true` sub-project now
  loads its files as extra context alongside the parent's; each active,
  `tracked: true` sub-project gets its own commit-offer / freshness check,
  independent of the parent's own `uses_git`.
- **Substantive discussions are always logged.** A design or scoping
  discussion is now itself a trackable event: `SKILL.md` logs it to
  `JOURNAL.md` (plus `BACKLOG.md` for anything actionable) at its natural
  conclusion, even when no decision was reached or the idea was later
  dropped — independent of the existing "significant change" trigger.
- **Portfolio: a detail sub-page per project.** Each project's card in
  `PORTFOLIO.html` now links to its own `portfolio/<project>.html`,
  rendering its `STATUS.md` state and next actions, current `ROADMAP.md`
  phase, recent `JOURNAL.md` activity, latest `CHANGELOG.md` version, and a
  direct GitHub link. `portfolio_regen.sh` regenerates only the changed
  project's sub-page on a `STATUS.md` write; a manual/config-triggered run
  regenerates all of them, with orphaned sub-pages cleaned up.

### Changed
- **The skill stays quiet when there's nothing to report.** New
  `## Staying in the background` principle in `SKILL.md`: the session-opening
  staleness check no longer announces "tracking files are up to date" —
  silence is the default, and the skill speaks up only for an actual
  proposal, question, or something the user needs to see.

## [0.11.0] — 2026-09-01

### Changed
- **Every question the skill asks is now written for a non-technical user.**
  New `## Asking questions` principle in `SKILL.md` (plain language; one line
  per option on what it changes; a context-based **(recommended)** hint). The
  bootstrap questions (git handling, Reminders, category, `ARCHITECTURE.md`),
  the first-run config questions (portfolio location, language, console
  view), the phase / `superpowers` / backlog-model prompts, retranslation and
  the un-exclude prompt are all reworded to match.

## [0.10.0] — 2026-09-01

### Added
- **Console-view preference.** The skill rewrites several files a session,
  filling the transcript with edit diffs. It now asks once per machine
  whether to fold Claude Code's view to the condensed "chat" mode —
  **Everywhere** (`~/.claude/settings.json`), **Only in tracked projects**
  (each project's `.claude/settings.local.json`, gitignored), or **No**. The
  answer lives in `~/.claude/project-tracker/prefs.txt` (`console_view:`),
  changeable via `/project-tracker:config`.

## [0.9.0] — 2026-08-31

### Changed
- **The skill is renamed `track`** — invoked `project-tracker:track` instead
  of the redundant `project-tracker:project-tracker`. `skills/project-tracker/`
  → `skills/track/`; `hooks.json`, the installer and the doc paths follow.
  The plugin name (`project-tracker`), the `/project-tracker:config` command,
  the `~/.claude/project-tracker/` config dir and the `docs/project-tracker/`
  output folder are all unchanged. If you ever typed
  `/project-tracker:project-tracker`, use `/project-tracker:track` now.

## [0.8.0] — 2026-08-31

### Changed
- **Untracked project → the tracking question is asked automatically.** The
  `SessionStart` hook on a new folder now instructs Claude to open the
  session with a selectable **Yes / No, don't ask again / Not now** prompt
  (`AskUserQuestion`), instead of a passive "not tracked" note the user had
  to act on. "No" adds the folder to `trackignore.txt`; "Not now" writes
  nothing and the prompt returns next session. Excluded folders are
  unchanged — silent unless the user raises it.

## [0.7.1] — 2026-08-31

### Fixed
- `docs/project-tracker/JOURNAL.md` carried an absolute home path in the
  first bootstrap entry — genericised.
- `ROADMAP.md` was four releases stale (stuck at the v0.3.0 era) — rewritten
  to cover v0.4.0–v0.7.0.
- `CLAUDE.md` layout section listed only two reference files — added
  `writing-tracking-files.md` and `references/i18n/`; fixed the
  `test_generate_portfolio` command; the release routine now names the
  tracking-file updates.

### Changed
- `README.md` tidied: the install commands are no longer printed twice, the
  `STATUS.md` frontmatter example shows every key, and the fresh-eyes pass /
  un-exclude behaviours are listed.

## [0.7.0] — 2026-08-30

### Changed
- An **excluded** folder (in `trackignore.txt`) that the user asks to track
  is now offered an un-exclude + bootstrap, instead of leaving a manual
  `trackignore.txt` edit. If it is an *ancestor* that is ignored, Claude
  explains that un-ignoring the whole subtree is the only option and asks.
  Bringing the folder up for anything else is unchanged.

## [0.6.0] — 2026-08-30

### Added
- **Fresh-eyes readability pass.** After substantially writing or rewriting
  an onboarding file (`README.md` / `CLAUDE.md` / `ARCHITECTURE.md` /
  `GLOSSARY.md`), Claude runs a review pass — a subagent (inline fallback)
  checks it against the file's reader definition for a clear hook, a
  reachable quick start, jargon introduced before use, drift from the
  file's purpose, concreteness, and over-long sections. Advisory, never a
  gate; runs at bootstrap and on later rewrites. See
  `references/writing-tracking-files.md`.

## [0.5.0] — 2026-08-30

### Changed
- `GLOSSARY.md` is no longer asked at bootstrap. It is created on first
  need: a proactive check on the first session (Claude glances at the code
  / `README`, proposes the file with the terms it spotted if the project
  has a real vocabulary), plus in-session triggers — the user asks what a
  project-specific term means, or a term keeps coming up undefined. A
  single term is added and announced without a question; the proactive
  batch is proposed. New `glossary` frontmatter key (`"non"` = proactive
  scan declined; absent = not yet checked). `ARCHITECTURE.md` is still
  offered at bootstrap.

## [0.4.1] — 2026-08-30

### Changed
- `generate_portfolio.py` HTML escaping goes through `_attr()` / `_txt()`
  helpers chosen by context (attribute vs element text), so a future
  locale's apostrophes and quotes can't break an attribute or clutter a
  text node. No change to the rendered output for `en` / `fr`.
- `writing-tracking-files.md`: the stale "French repo → French tracking
  files" heuristic is replaced — the language is resolved from the
  settings, and a French repo is only a hint for the first-run question.
- `references/i18n/en.md` is stated as the source of truth for heading
  wording, its ROADMAP keys reconciled with `backlog-phases.md`
  (`in_progress` / `after` added, phase-dependence noted).
- `_normalise_lang` drops the off-spec `eng` / `fra` aliases; the accepted
  set is exactly the spec's (`en`/`english`/`anglais`,
  `fr`/`french`/`francais`/`français`), now covered by a test.

## [0.4.0] — 2026-08-30

### Added
- **User-selectable output language (English / French).**
  `~/.claude/project-tracker/language.txt` sets the machine default for the
  tracking files, the portfolio and the reminders; `language:` in a
  `STATUS.md` frontmatter overrides it for that project's files; a `language:`
  line in `portfolio.txt` overrides it for the portfolio. Per-language string
  catalogue `references/i18n/{en,fr}.md`; `generate_portfolio.py` renders its
  chrome (status labels, freshness, empty state, search, `<html lang>`) in the
  resolved language. Changing a project's language proposes a full
  retranslation (past append-only entries included, dates preserved) with an
  autonomous subagent review loop. Asked once at first bootstrap. `/project-tracker:config`
  gains a "Change the language" action. Default and fallback: `en`.
- Versioning policy written down: the scheme in this file's header, the
  release routine in `CLAUDE.md` § Releasing. `writing-tracking-files.md`
  points future projects to the same two homes (no dedicated file).

## [0.3.1] — 2026-08-30

### Added
- `references/writing-tracking-files.md` — per-file guidance on how to write
  each of the nine standard files (plus `ARCHITECTURE.md` / `GLOSSARY.md`):
  who the reader is, structure, what belongs and what doesn't, worked
  good/poor examples, and — for `ARCHITECTURE.md` — a lens for judging the
  architecture itself. `SKILL.md` points to it from "The standard files".
- `SKILL.md` now states that the tracking files are committed like any other
  source (with the narrow sensitive-content exception).
- Retroactive git tags `v0.1.0` / `v0.2.0` / `v0.3.0` (last commit of each
  version line); tagging is now part of the release routine.

### Fixed
- `SKILL.md` referenced "bootstrap step 6" for the optional
  `ARCHITECTURE.md` / `GLOSSARY.md` files — it is step 7.
- `build_installer.sh` had a hardcoded reference-file list; it now globs
  `references/*.md` so a new one is always bundled (see `ERRORS.md`).

### Changed
- README restructured for first-time readers: plain-language hook, a
  Quick start section up top, a tight "What you get", and the edge-case
  material (no-git mode, retrofit, concurrent sessions, optional files,
  frontmatter) moved into a "Details" section.
- README also documents `~`/`$VAR` expansion in the config files.
- `SKILL.md` § Portfolio now documents the `title:` line and the `.html`
  explicit-path tolerance of `portfolio.txt`.

## [0.3.0] — 2026-08-30

### Added
- `/project-tracker:config` command to view and change configuration
  (scopes, ignored paths, portfolio location/title, a project's category).
- Configurable portfolio title (`title:` line in `portfolio.txt`).

### Changed
- `project:` frontmatter is always the folder's own name — never asked.
- Skill no longer requests an `allowed-tools` grant.
- Audit fixes across the skill and hooks; installer regenerated.

## [0.2.0] — 2026-08-30

### Added
- Portfolio groups projects into sections by the `category` frontmatter
  field; bootstrap asks for a category.
- Portfolio location asked once at first bootstrap
  (`~/.claude/project-tracker/portfolio.txt`).

## [0.1.0] — 2026-08-30

### Added
- First Claude Code **plugin** release: `.claude-plugin/{plugin,marketplace}.json`
  + `hooks/hooks.json` bundle the skill and its three hooks (`SessionStart`,
  two `PostToolUse`). `install-project-tracker.sh` kept as a parallel path.
- Unified `PORTFOLIO.html` aggregating all tracked projects across every
  scope, regenerated by a deterministic `PostToolUse` hook.
- Self-relative hook scripts (work in plugin / skills-dir / script modes).
- `test_plugin_manifest.py`.

### Earlier

- 2026-08-29 — Full English translation of the shipped skill, hooks,
  portfolio generator and generated HTML.
- 2026-08-28 — Initial public release: extracted into the standalone repo
  `github.com/doui445/project-tracker`.
