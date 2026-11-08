# Competitors, multi-tool memory: BRACE (2026-10-19)
Asked by: the brand skill (first brand session). Depth: quick.

## Summary
- ECC does share one project memory across agents, so "two agents, one memory" is not unique to BRACE. Its Memory Vault is a shared Markdown format in `.ecc/memory/` (project) and `~/.ecc/memory/` (user), with explicit cross-harness handoff commands.
- What still differs:
  - ECC's sharing runs through an `ecc` CLI. Its README says skill-only, minimal, manual and Claude plugin installs do not put that runtime on `PATH`.
  - The vault holds memories, not a project record (status, decisions, changelog).
  - ECC's hook session data is kept separate per harness by default.
- claude-mem is partly shared (one store, filtered per harness by default). superpowers is not shared. Spec Kit and BMAD keep files in the repo, but I could not confirm cross-agent sharing. AGENTS.md shares instructions, not memory.
- "Shared across agents" on its own is not a safe differentiator. A safer one is a shared plain project record that any agent reads with no extra runtime.

## Findings
| Name | Shared across agents? | One line | Source | Checked |
|---|---|---|---|---|
| ECC (Everything Claude Code) | Yes for the Memory Vault; partly for hook session data | Under "Share context between harnesses", the vault gives "Claude, Codex, Hermes, OpenClaw, Kimi, and other harnesses one local, inspectable Markdown format". Project and team memories sit in `.ecc/memory/`, user memories in `~/.ecc/memory/`. The page shows `ecc memory handoff --from hermes --target codex` and recall from another harness. Cursor and OpenCode are not named in the vault section. Hook session data uses a root that defaults to `~/.claude`. Cursor gets `~/.cursor/ecc` unless you opt in with `ECC_AGENT_DATA_HOME=~/.claude`. "Continuous learning v2 instincts remain separate". | [github.com/affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | 2026-10-19 |
| superpowers (obra) | No | "Installation differs by harness. If you use more than one, install Superpowers separately for each one." The page names no memory store and no path for plans. | [github.com/obra/superpowers](https://github.com/obra/superpowers) | 2026-10-19 |
| GitHub Spec Kit | Not confirmed | Specs live in the repo under `.specify/` (for example `.specify/bugs/&lt;slug&gt;/`). It lists "Connect to or switch between coding agents", but the README does not say agents read each other's records. It also says other agents "may use different invocation syntax". | [github.com/github/spec-kit](https://github.com/github/spec-kit) | 2026-10-19 |
| BMAD-METHOD | Not confirmed | The README names Claude Code and Codex plugins, plus a Skills CLI that "asks which coding tools to install to". It does not say where artifacts live or whether tools share them. | [github.com/bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) | 2026-10-19 |
| claude-mem | Partly | "Works with Claude Code, OpenClaw, Codex, Gemini, Hermes, Copilot, OpenCode + More." The default "limits startup context to the current harness". An opt-in setting includes "observations from every harness", described for Claude Code and Codex only. Storage is SQLite, not readable project files. | [github.com/thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) | 2026-10-19 |
| AGENTS.md convention | Yes for instructions, no memory | One plain Markdown file read by Codex, Jules, Aider, Cursor, Devin, Copilot's coding agent, Gemini CLI, Windsurf and VS Code. Agents "automatically read the nearest file". The page does not mention memory or agents writing to it. "Treat AGENTS.md as living documentation" is advice to maintainers. | [agents.md](https://agents.md) | 2026-10-19 |

## Added beyond the brief
Nothing. This was a quick follow-up.

## Open spaces
- ECC holds "one memory format across harnesses". I found nobody offering one readable project record (status, decisions, changelog, backlog) that every agent reads and writes with no runtime or CLI to install.
- Two hosts (Claude Code and Antigravity) is a narrower claim than ECC's. In the parts of the ECC README I read, Antigravity is not named. That is unverified for the unread part.

## Unverified
- I read ECC's README only to character 100,000 of 138,358. A re-read from character 100,000 returned nothing on the vault, so any further vault detail there is unchecked.
- The ECC page does not say which harness reads or writes the vault. The Hermes-to-Codex handoff is an example, and reading it as a rule is my inference.
- Whether Cursor and OpenCode read the vault: not stated in what I read.
- Whether ECC, claude-mem, Spec Kit or BMAD support Antigravity: not confirmed.
- Spec Kit and BMAD: no statement on cross-agent sharing. I did not read their docs sites or the files a project gets after install. `.specify/memory` appears in the Spec Kit repo listing, but its content and role are not stated.
- claude-mem's database path is not given on the page. Only the settings file, `~/.claude-mem/settings.json`, is named.
- All claims come from README text read through a summarising fetch tool. I did not run any of the tools.
