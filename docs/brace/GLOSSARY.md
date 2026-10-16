# GLOSSARY — BRACE

Domain terms used across the skill, its references and these tracking files.

| Term | Meaning |
|---|---|
| **scope / scope root** | An absolute path in `~/.brace/scopes.txt`. Everything under it gets `SessionStart` auto-detection. |
| **trackignore** | `~/.brace/trackignore.txt`: absolute paths where the skill stays silent. An entry equal to a scope root ignores only that exact folder, not the projects inside it. |
| **tracked / new / excluded** | The three detection states of a project root: has `docs/brace/STATUS.md` (or the old `docs/project-tracker/STATUS.md`) / has neither / listed in `trackignore.txt`. |
| **bootstrap** | The first-time setup flow: a sequence of questions, then creation of the nine standard files from the answers — never guessed. |
| **retrofit** | Adopting the model for a project that already has non-standard tracking files; reuse what exists instead of asking from scratch. |
| **the nine standard files** | `README.md`, `CLAUDE.md` (root) + `ROADMAP`, `STATUS`, `JOURNAL`, `CHANGELOG`, `DECISIONS`, `ERRORS`, `BACKLOG` (in `docs/brace/`). |
| **snapshot** | What `STATUS.md` is — the current state, fully rewritten each time, never accumulated. |
| **reservoir** | What `BACKLOG.md` is — every idea ever envisaged, archived on closure, never purged. |
| **frontmatter** | The YAML block at the top of `STATUS.md` — the only strictly structured part; what `generate_portfolio.py` consumes. |
| **`backlog_model`** | Frontmatter key. `"adopté"` = the backlog/roadmap/phases model is in use (automatic at bootstrap). `"non"` only via a declined retrofit. Absent = a project tracked before the feature, not yet retrofitted. |
| **`phase_model`** | Frontmatter key. `"superpowers"` (plan via the `writing-plans` skill in `docs/superpowers/plans/`) or `"leger"` (a `docs/brace/phases/PHASE_N_SPEC.md` written directly). Absent until a phase is actually proposed. |
| **phase** | A coherent batch of backlog items grouped and worked as a unit. Proposed by Claude's judgment, never automatic. |
| **`#tracker-sync`** | The tag put on Reminders items the skill creates, so the sync can tell its own items apart. |
| **portfolio** | The single unified `PORTFOLIO.html` aggregating every tracked project across all scopes, written to the folder in `portfolio.txt`. |
| **chantier (C1–C4)** | The four build workstreams: C1 standalone repo, C2 English translation, C3 portfolio rework, C4 plugin wiring. |
| **install paths** | Claude Code: the plugin from the `doui445/brace` marketplace. Antigravity: `agy plugin install` of the same repo. `claude --plugin-dir` for a one-shot local test. Hook scripts are self-relative to work in all of them. |
| **dispatcher / adapter** | `dispatch/run.sh` runs one event (`session_start`, `post_tool_use`) for every skill; a per-tool adapter (`dispatch/claude/`, `dispatch/antigravity/`) turns the tool's JSON into its variables and its output back into the tool's format. |
| **bridge** | `project-tracker` 0.14.0, the last release under the old name: it only installs brace. Frozen once released. |
| **swap** | Replacing the old `project-tracker` plugin by `brace` in a tool. A swap stays *pending* (`~/.brace/.swap-pending`) until the tool has really restarted; project folders move only then. |
