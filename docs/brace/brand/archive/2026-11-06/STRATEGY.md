# STRATEGY — BRACE

Where we play and against whom. Revised over time.

## Objectives

In order:

1. **Adoption by word of mouth**: users who adopt BRACE and recommend it
   on their own.
2. **A reputation for trust** in the world of AI agents.
3. **Revenue, one day**: a paid version, donations or consulting. No model
   chosen yet.

## Personas

Provisional: built 2026-10-20 from six questionnaire answers (people from
the owner's circle, not a sample) and the analyst's audience report
(`docs/brace/agents/analyst/2026-10-19-audience.md`). Quotes are the
respondents' own words, translated from French.

1. **The pilot** (today's target): runs a business or several projects at
   once (an agency, analysis, accounting, an app) with Claude and Claude
   Code. Files work in one folder per project and checks everything
   personally.
   - **Before BRACE**: "I manage pretty well", "a boss with assistants",
     but "a lot of reiteration", and the AI "answers beside the point".
   - **Wants**: agents that guess what is needed before it is fully said.
2. **The resourceful one** (tomorrow's target): a student, a creative, or
   someone starting a business, mostly on web apps, with several AIs at
   once. Many projects, few finished.
   - **Before BRACE**: hits token and credit limits, the AI "drowns" and
     "cannot find the right elements", "you have to think about how to talk
     to it", feels "watched, distant".
   - **Wants**: an AI that organises itself and makes a detailed plan they
     can edit.

What the answers confirm: token or credit limits (3 of 6), relevance more
than forgetting, one folder per project already (5 of 6), no trust in the
result without checking, several AIs and so no shared journal.

Open point: 4 of 6 use AI in a web app, and BRACE needs an agent on the
machine today. The resourceful one needs a way in; nothing decided yet.

## Competitive landscape

Summary approved 2026-10-19. Full report, with sources:
`docs/brace/agents/analyst/2026-10-19-competitors.md`.

- **Level 1, alternatives**: AI chat apps and sites (ChatGPT, the Claude
  app, Claude Cowork), IDEs (Cursor, Copilot), and the native memory of
  Claude Code and Antigravity. Memory is everywhere, but it is notes or
  opaque, and nothing keeps the project in order.
- **Level 2, direct competitors**: superpowers (a working method), ECC,
  Everything Claude Code (performance, and a loose memory vault),
  claude-mem (memory in a database), Spec Kit, BMAD, Taskmaster. Each
  covers one piece, none the whole. Their tone is dense and one-upping.
- **Level 3, a similar promise**: OpenClaw, Hermes, Meta Muse, Tab, Notion
  AI, Manus. They sell outcomes ("it does things"), not project quality.
  Tab bets on trust.
- **Nobody holds**: organised memory you can read, a project that stays
  clean, a view of all your projects with real follow-up, a calm tone, and
  tools proposed only when useful.

## Differentiators

Different, not better.

1. **The whole system, not one more piece**: memory, tracking, portfolio,
   reminders and skills in one plugin, working together.
2. **Organised, relevant memory you can read**: real files in your project
   (status, decisions, journal...), kept current. Not a database, not loose
   notes.
3. **The project stays clean**: BRACE does not only remember, it keeps the
   project in order, complete and professional.
4. **All your projects at a glance**, with real-life follow-up (reminders,
   calendar).
5. **It proposes, it does not impose**: tools and choices come only when
   justified, and it stays light on tokens.
6. **Honest enough to disagree**: it never guesses, it asks, and it tells
   you when you are wrong.

Direction, not yet a differentiator: BRACE is built to extend to more
agents over time (two today, Claude Code and Antigravity). "Shared across
agents" alone does not set it apart: ECC shares a memory vault across
harnesses through its CLI
(`docs/brace/agents/analyst/2026-10-19-competitors-multi-tool-memory.md`).
What may: one readable project record that every agent reads and writes,
with no extra runtime.

## Positioning

Two axes: **one piece to assemble ↔ a complete system** (horizontal) and
**hidden or loose memory ↔ organised memory you can read** (vertical).

```
                 organised memory you can read
                              |
      Spec Kit, BMAD          |           * BRACE
      (specs in Git)          |
                              |
  one piece ------------------+------------------ complete system
                              |
      claude-mem, CLAUDE.md   |        ECC (vast, loose memory vault)
      superpowers (no         |        AI apps, Muse, OpenClaw
      memory)                 |        (opaque memory)
                              |
                  hidden or loose memory
```

The free place: a complete system with organised, readable memory.

> For people who want the full power of AI on their machine without the
> hassle, BRACE is the system that gives the AI an organised memory and
> keeps every project clean and followed. Unlike tools you must assemble
> yourself, it is complete from install, it proposes without imposing, and
> it tells you the truth.

## Mechanism

1. **The memory is the project itself**: standard files (status,
   decisions, journal, backlog...) inside the project. The AI reads them
   at the start of each session, so it starts where you left off, with
   nothing to re-explain.
2. **It keeps itself current**: at each session and after each significant
   change, BRACE checks whether the files are behind and proposes the
   update. Hand-written CLAUDE.md files go stale; this does not.
3. **It stays true**: BRACE never guesses. What it does not know, it asks,
   or marks "to fill in". The memory holds no inventions.
4. **One folder for all**: every skill (tracking, brand, soon design) and
   every agent reads and writes the same place. That makes a system, not
   separate pieces.

Most memory on offer is about the user (Claude, ChatGPT, Muse). Project
context exists too (Claude and ChatGPT projects, CLAUDE.md, ECC's project
vault), but as files, notes or instructions, not as a project record kept
current: where it stands, what was decided and why, what comes next.

## Proof points

- **BRACE tracks itself**: its own tracking files are public in the repo
  (`docs/brace/`), from day one.
- **Published and installable** the official way on Claude Code and
  Antigravity.
- **A full test suite** (`run_tests.sh`).
- **The founder's experience** (presented as such, not as an independent
  review): more productive with AI, moves faster on projects, never has to
  re-explain, rarely has to remind the AI of something it forgot.

Missing: testimonials from other people (one questionnaire respondent
already uses project-tracker but declined to be contacted), and a measure
of "light on tokens".

## Indicator

**Spontaneous recommendations**: how many times someone mentions or
recommends BRACE without being asked (a post, a comment, an issue from a
stranger, a friend installing it for someone else). Counted by hand, from
time to time; no telemetry. Few are expected at first; to be adjusted or
changed later if needed.

## Touchpoints

In the repo (checked against the voice when written):

- `README.md`: first contact on GitHub
- `.claude-plugin/plugin.json`: the description shown at install (Claude Code)
- `plugin.json`: the description shown at install (Antigravity)
- `.claude-plugin/marketplace.json`: the description in the marketplace

Outside the repo: the GitHub repo description and topics; GitHub release
notes; posts and messages presenting BRACE; social networks, now and
then; the site (planned; add its files here once they exist).

Not listed: the messages BRACE shows during a session (hooks, questions).
They are the voice too, but scattered in the code; the voice file gets a rule
for them instead, checked by hand at reviews.

## Non-goals

- No engagement or addiction mechanics.
- Real end states: BRACE does not try to hold your attention.
- No dark patterns.
- No one-upping with numbers ("300 skills, 70 agents"): restraint is the
  brand.
- No promise that cannot be checked: no "magic", no "your data never
  leaves your machine".
- No imposed tool: everything proposed stays optional.
- No telemetry: no statistics sent without your knowledge.
