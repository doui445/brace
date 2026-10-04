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

- Antigravity accesses the unified configuration through `~/.gemini/project-tracker/` (which is a symlink to `~/.project-tracker/`).
- `scopes.txt`, `trackignore.txt`, `portfolio.txt`, and `language.txt` are fully shared with Claude Code.

## 4. Lifecycle Hooks

Antigravity lifecycle hooks are configured via `hooks.json` in the plugin directory:
- `PreInvocation`: runs `session_start.sh`.
  - Only executes on initial turn (`invocationNum == 1`).
  - Outputs an ephemeral message in `injectSteps` when opening a tracked or untracked project under scope.
  - Outputs `{}` for subsequent turns (`invocationNum > 1`).
- `PostToolUse` with matcher `write_to_file|replace_file_content`:
  - Triggers `portfolio_regen.sh` whenever `STATUS.md` is updated.
  - Triggers `reminders_sync_trigger.sh` if Apple Reminders is configured.
