# Platform Reference: Antigravity (AGY)

This reference details the conventions and behaviors specific to **Google Antigravity (AGY)**.
General tracking rules and file specifications live in the parent [SKILL.md](../SKILL.md).

## 1. Interactive Questions

When asking bootstrap or tracking choices with options:
- Use Antigravity's native `ask_question` tool.
- Prefix the recommended option with `(Recommended)`.
- Provide concise, plain-language descriptions of the consequences for each option.

## 2. Root Conventions File (`AGENTS.md`)

- Antigravity automatically discovers and loads `AGENTS.md` (and `GEMINI.md`) at the repository root and subdirectories.
- The canonical instructions file is **`AGENTS.md`**.
- Keep `CLAUDE.md` as a symbolic link (`CLAUDE.md -> AGENTS.md`) so that Claude Code continues to access the exact same conventions without duplication.

## 3. Configuration Access

- Antigravity accesses the unified configuration through `~/.brace/` (the old `~/.gemini/project-tracker/` is a symlink to it).
- `scopes.txt`, `trackignore.txt`, `portfolio.txt`, and `language.txt` are fully shared with Claude Code.

## 4. Installation and Lifecycle Hooks

Installed with `agy plugin install https://github.com/doui445/brace` (the repo root carries the Antigravity `plugin.json` and `hooks.json`). The hooks declared in the root `hooks.json` call the dispatcher `dispatch/run.sh` through the adapter in `dispatch/antigravity/`, which runs the scripts of each skill (`skills/track/hooks/session_start.sh`, `post_tool_use.sh`):
- `PreInvocation`: runs the `session_start` event.
  - Only executes on initial turn (`invocationNum == 1`).
  - Outputs an ephemeral message in `injectSteps` when opening a tracked or untracked project under scope.
  - Outputs `{}` for subsequent turns (`invocationNum > 1`).
- `PostToolUse` with matcher `write_to_file|replace_file_content`:
  - Runs the `post_tool_use` event (`skills/track/hooks/post_tool_use.sh`): regenerates the portfolio whenever `STATUS.md` is updated, and triggers the Reminders sync if Apple Reminders is configured.
