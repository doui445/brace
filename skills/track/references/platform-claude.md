# Platform Reference: Claude Code

This reference details the conventions and behaviors specific to **Claude Code**.
General tracking rules and file specifications live in the parent [SKILL.md](../SKILL.md).

## 1. Interactive Questions

When asking bootstrap or tracking choices with options:
- Use Claude Code's native `AskUserQuestion` tool (or selectable multiple-choice format).
- Always recommend one option based on context (e.g. existing git remote, language detected).

## 2. Root Conventions File (`CLAUDE.md` / `AGENTS.md`)

- Claude Code automatically discovers `CLAUDE.md` at the project root.
- To maintain multi-platform compatibility:
  - The canonical file is **`AGENTS.md`**.
  - `CLAUDE.md` is a symbolic link: `CLAUDE.md -> AGENTS.md`.
  - When creating or updating instructions, write to `AGENTS.md` (or through the symlink `CLAUDE.md`).
  - If adopting an existing project that already has `CLAUDE.md` but no `AGENTS.md`: migrate it via `mv CLAUDE.md AGENTS.md && ln -s AGENTS.md CLAUDE.md`.

## 3. Console View Preference (`prefs.txt`)

Claude Code displays edit diffs in full by default.
- Machine setting in `~/.project-tracker/prefs.txt`: `console_view: chat` or `chat-local`.
- If `chat-local`: configure `{"defaultView": "chat"}` in `.claude/settings.local.json` at the project root.
- If `everywhere`: configure `{"defaultView": "chat"}` in `~/.claude/settings.json`.

## 4. Lifecycle Hooks

Claude Code hooks are registered via `.claude-plugin/` or `~/.claude/settings.json`:
- `SessionStart`: runs `skills/track/hooks/session_start.sh`.
- `PostToolUse` with matcher `Edit|Write`: runs `skills/track/hooks/portfolio_regen.sh` and `reminders_sync_trigger.sh`.
