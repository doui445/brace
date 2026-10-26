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
- Machine setting in `~/.brace/prefs.txt`: `console_view: chat` or `chat-local`.
- If `chat-local`: configure `{"defaultView": "chat"}` in `.claude/settings.local.json` at the project root.
- If `everywhere`: configure `{"defaultView": "chat"}` in `~/.claude/settings.json`.

## 4. Lifecycle Hooks

Claude Code hooks are declared in `claude-hooks.json` at the plugin root and all call the dispatcher `dispatch/run.sh` through the adapter in `dispatch/claude/`, which runs the scripts of each skill:
- `SessionStart`: runs each skill's `hooks/session_start.sh` (`track` always; another skill only where its `docs/brace/<skill>/` exists).
- `PreToolUse` with matcher `Edit|Write`: lets a BRACE agent (`agent_type` `brace:<agent>`) write in its own `docs/brace/agents/<agent>/` folder of a tracked project without a permission prompt (`dispatch/agent_write.sh`). Anything else gets no decision: the user's permission settings apply.
- `PostToolUse` with matcher `Edit|Write`: runs each skill's `hooks/post_tool_use.sh` (for `track`: portfolio regeneration and Reminders sync trigger; for `brand`: the voice reminder on touchpoint files, and a macOS notification when a brand presentation is ready).

## 5. Agents

BRACE agents load from the file `.claude-plugin/plugin.json` lists under
`agents` (`agents/claude/<agent>.md`). Launch one with the Agent tool,
`subagent_type: "brace:<agent>"`, in the background; it does not see the
conversation, so pass a complete brief. Its result arrives as a message
when it finishes; the conversation stays free meanwhile.

An agent writes in its own folder without a prompt (the `PreToolUse` hook
above), and only there. Background agents keep the MCP tools (the
`analyst` may use Claude in Chrome when it is connected). Claude Code's
own notification shows only in some terminals; BRACE sends its own macOS
notification when a brand presentation is ready.
