# BRACE

*Barely Remarkable, Admittedly Capable Engine* — formerly project-tracker.

Open a Claude Code session in one of your projects and it keeps a small set of
Markdown files — `STATUS.md`, `ROADMAP.md`, `JOURNAL.md`, `CHANGELOG.md`,
`DECISIONS.md` and a few more — current as you work, so you and Claude always
have the project's context in one predictable place. It also builds a single
`PORTFOLIO.html` across every project you track.

It's a plugin for Claude Code and Antigravity (a skill + a hook dispatcher). It never guesses: anything it
doesn't know, it asks.

## Quick start

**Claude Code**

```
/plugin install brace --marketplace doui445/brace
```

(On Claude Code older than 2.1.275, run `/plugin marketplace add
doui445/brace` first, then `/plugin install brace`.)

**Antigravity**

```
agy plugin install https://github.com/doui445/brace
```

Restart, then tell it which folders to watch — either run `/brace:config`, or
edit `~/.brace/scopes.txt` directly (one path per line, e.g. `~/code`).

Now open a session in any project under one of those folders. If it's new,
Claude opens with a **yes / no / not-now** prompt to track it (then a handful of
questions — goal, stack, git); if it's already tracked, Claude picks up where
the files left off.

### Coming from project-tracker

Update the marketplace and the plugin once — third-party marketplaces may not
update on their own: `claude plugin marketplace update`, then
`claude plugin update project-tracker` (or the same from `/plugin`). That last
project-tracker release installs BRACE, and BRACE moves your config to
`~/.brace/` and each project's `docs/project-tracker/` to `docs/brace/` the
first time you open it after a restart (you confirm the commit). Restart and
close your other sessions when asked. If BRACE could not be installed
automatically, you'll be told: run `/plugin install brace`. If you only use
Antigravity with an older manual install, reinstall once with the
command above — BRACE removes the old one.

## What you get

| File | Purpose |
|---|---|
| `README.md` *(project root)* | What, why, stack, install/run, links |
| `CLAUDE.md` *(project root)* | Instructions for Claude: conventions, build/test commands, pitfalls |
| `docs/brace/STATUS.md` | Snapshot of the current state + next actions. Rewritten every session |
| `docs/brace/ROADMAP.md` | Prioritised synthesis: what's done, the current focus, what's anticipated |
| `docs/brace/JOURNAL.md` | Dated log of what was done and why. Append-only |
| `docs/brace/CHANGELOG.md` | Keep a Changelog format |
| `docs/brace/DECISIONS.md` | Why each structural choice, alternatives rejected. Append-only |
| `docs/brace/ERRORS.md` | Bug → cause → fix, searchable. Append-only |
| `docs/brace/BACKLOG.md` | Raw reservoir of every envisaged idea. Append-only |

Plus, on top of the files:

- **A unified portfolio** — one `PORTFOLIO.html` aggregating every tracked
  project across all your scope roots, grouped by category, regenerated
  automatically whenever a `STATUS.md` changes.
- **Optional GitHub automation** — creates a private repo or grafts onto an
  existing one, on request. Never commits or pushes without confirmation.
- **Optional Apple Reminders sync** (macOS) — links a project to a Reminders
  list and keeps its next actions in sync both ways.
- **User-selectable EN/FR output** — the tracking files and the portfolio can
  be written in English or French, set once and overridable per portfolio or
  per project.
- **A readability pass** — after Claude substantially rewrites an onboarding
  file (`README` / `CLAUDE.md` / …), a fresh-eyes review checks it still reads
  well for a newcomer.

## Requirements

- **Claude Code** or **Antigravity** — that's the only hard requirement.
- **Python 3** — standard library only, no dependencies (bundled, used by the
  portfolio generator).
- **The `gh` CLI** — only for the optional GitHub repo automation.
- **macOS + the `apple-reminders` MCP server** — only for the optional
  Reminders sync.
- **The `superpowers` plugin** — only if you want roadmap-phase plans written
  via its `writing-plans` skill; without it, phases use a lightweight
  `PHASE_N_SPEC.md` instead.

## Install

Use the commands from **Quick start**, then restart. The plugin bundles the
skill and its hooks (`SessionStart` + `PostToolUse`) — no manual
`settings.json` edit.

Third-party marketplaces don't auto-update by default. To pick up a new
version in Claude Code: `/plugin marketplace update brace` then
`/plugin update brace` (or set `FORCE_AUTOUPDATE_PLUGINS=1`).

## Configuration

Up to five files in `~/.brace/`. The plugin creates
`scopes.txt` and `trackignore.txt`; `portfolio.txt`, `language.txt` and
`prefs.txt` each appear the first time the matching question is asked. In all
of them, `~` and `$VAR` are expanded and `#` comments are ignored.

- **`scopes.txt`** — one path per line. Everything under these roots gets
  auto-detection.
- **`trackignore.txt`** — one path per line, to skip. An entry equal to a scope
  root ignores only that exact folder, not the projects inside it.
- **`portfolio.txt`** — the folder where `PORTFOLIO.html` is written; an
  optional `title:` line sets its heading (default, locale-dependent: "My
  projects" / "Mes projets"), and an optional `language:` line (`en`/`fr`)
  overrides the output language for the portfolio only.
- **`language.txt`** — the machine-global output language for the tracking
  files and portfolio: `en` or `fr`, default `en`, asked once at first
  bootstrap.
- **`prefs.txt`** — machine preferences. Today just `console_view:` — since
  the skill rewrites several files per session, it offers once to fold Claude
  Code's transcript to the condensed "chat" view (everywhere, only in tracked
  projects, or not at all).

`/brace:config` views and changes all of this
in plain language.

## Details

- **Works without git.** Pick "no git" at setup (`uses_git: false`) and
  everything still works — staleness is detected from file timestamps instead
  of `git log`.
- **Retrofit.** A project that already has ad-hoc tracking files (an existing
  `CLAUDE.md` / `JOURNAL.md`, `.pages` docs, a home-grown `BACKLOG.md`) is
  adopted by reusing what's there.
- **Concurrent sessions.** Before rewriting `STATUS.md`, it checks for an
  out-of-session change (via `git`, or the file's mtime) and asks rather than
  overwriting. The append-only files are only ever appended to.
- **Optional files.** `ARCHITECTURE.md` is offered at setup for a complex
  project. `GLOSSARY.md` is created later, the first time the project's own
  jargon calls for it — Claude proposes it when it spots a domain vocabulary,
  or adds a term when you ask what one means.
- **Excluded folders.** A folder in `trackignore.txt` is left alone — but if
  you ask to track it, Claude offers to un-exclude it and set it up.
- **`STATUS.md` frontmatter.** The one structured block; the portfolio reads
  `project`, `status`, `last_updated`, `stack`, `repo` and `category` from it:

  ```yaml
  ---
  project: my-app          # always the folder name
  status: active           # active | paused | blocked | archived
  uses_git: true
  repo: https://github.com/you/my-app
  stack: [Python, FastAPI]
  last_updated: 2026-08-30
  next_milestone: "Ship the import flow"
  reminders_list: "My app"   # or "non"
  category: "Work"           # or "non"
  backlog_model: "adopté"
  phase_model: "superpowers" # or "leger"; absent until a phase is proposed
  language: fr               # en | fr ; absent = inherit language.txt
  glossary: "non"            # "non" = proactive glossary scan declined
  ---
  ```

The full behaviour specification lives in
[`skills/track/SKILL.md`](skills/track/SKILL.md).

## License

MIT — see [`LICENSE`](LICENSE).
