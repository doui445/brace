# STRATEGY — BRACE

Where we play and against whom. Revised over time.

Updated 2026-11-07 from the validated
[brand platform](documents/2026-11-07-platform.html) (rebrand, route
"Nothing without you"). What we put first: trust, then order (all your
projects on one page).

## Objectives

In order:

1. **Adoption by word of mouth**: users who adopt BRACE and recommend it
   on their own.
2. **A reputation for trust** in the world of AI agents.
3. **Revenue, one day**: a paid version, donations or consulting. No model
   chosen yet.

## Personas
The audience: **anyone with several concrete projects to run,
entrepreneurs included**, with a stable version for Claude Code first.
Provisional: six questionnaire answers from the owner's circle (not a
sample) and the public's voices found by the analyst; no interview yet,
the guide is ready. Detail: [personas](documents/2026-11-06-personas.html).

1. **The pilot** (first): runs several projects with Claude and Claude
   Code, checks everything, and fears silent drift. Judges the promise:
   everything written is readable. Well supported by the data.
2. **The entrepreneur with several hats** (next): "a brilliant consultant
   who gets amnesia every Monday morning". The least supported persona.
   *Assumption*: uses an AI on their machine.
3. **The resourceful one** (tomorrow): mostly on web apps. Still no way
   in, since BRACE needs an agent on the machine: no promise to them until
   one exists (a product question, noted for later).

What they share: several projects, the same thing repeated to the AI,
checking every result, a taste for simple and sober. Their starting state
(*assumption* until the interviews): tired of starting from zero, and
wary after being burned by a stale fact.

## Competitive landscape
Summary approved 2026-10-19, level 4 added 2026-11-06. Reports, with
sources: `docs/brace/agents/analyst/2026-10-19-competitors.md` and the
[benchmark](documents/2026-11-06-benchmark.html).

- **Level 1, alternatives**: AI chat apps and sites, IDEs, the native
  memory of Claude Code and Antigravity; since November, Claude Design and
  Anthropic's marketing plugin, next door on "on-brand".
- **Level 2, direct competitors**: superpowers, ECC, claude-mem, Spec Kit,
  BMAD, Taskmaster. Each covers one piece, none the whole. Their tone is
  dense and one-upping.
- **Level 3, a similar promise**: OpenClaw, Hermes, Meta Muse, Tab, Notion
  AI, Manus. They sell outcomes. Tab bets on trust (not rechecked).
- **Level 4, AI branding tools and AI "agencies"**: logo and brand kits
  (Looka, Brandmark), platforms shouting numbers and claiming to replace
  the agency (MarkGrid, MarkBase). Tailor Brands comes near the calm
  register, for starting a US business.
- **Nobody holds**: calm instead of numbers, a project record you can
  read, and the user deciding.

## Differentiators
Different, not better. Three, no more.

1. **It does not guess what it cannot know.** It asks, marks "to fill in"
   and dares to disagree. The public fears exactly the silent error: "the
   failure mode isn't 'tool forgot', it's 'tool remembers a stale fact'".
2. **What is decided is written down, in readable files you can edit, in
   your project.** Not a database. In texts, say what BRACE does, without
   comparing (the gap with claude-mem was not rechecked).
3. **Calm instead of numbers.** The AI "agencies" shout figures; BRACE
   does the opposite.

Counts without being a difference on its own: the brand as a living
folder in the project, read back by the AI. Not claimed as exclusive.
No longer an argument: "shared across agents" (claude-mem claims it, and
the ambition is Claude Code first).

## Positioning
Two axes: **what you buy** (one piece for one task ↔ help across all your
projects) and **what is promised** (results, numbers, noise ↔ trust, calm,
checkable).

|  | Results, numbers, noise | Trust, calm, checkable |
|---|---|---|
| **Help across all projects** | MarkGrid, MarkBase, ECC | **BRACE** (nearly free; Tailor Brands, Tab nearby) |
| **One piece for one task** | superpowers, claude-mem, Spec Kit, BMAD, Looka, Brandmark | Little occupied; Claude Design sells visuals, enthusiastically |

Our reading of tone and discourse, not a measure.

> For people who run several projects with an AI on their machine and
> check what they get back, BRACE is the AI you are on the same page with:
> it reads what it can, asks what it cannot know, writes down what you
> decide. Unlike tools that remember for the AI or promise a result in
> minutes, it keeps everything readable, editable and yours.

The words are the strategist's; the editorial guide refines them.

## Mechanism
1. **The memory is the project itself**: standard files (status,
   decisions, journal, backlog) in the project, read at the start of each
   session, so it starts where you left off.
2. **It reads before asking**: it only asks what it cannot read. That is
   what keeps it Jarvis: ahead of you, never in your place.
3. **It writes down what is decided, and why**: nobody has to keep the
   notes by hand ("Giant paste-docs died because I never updated them").
4. **You validate before it saves or publishes**: and it asks once before
   doing it on its own.
5. **No telemetry**: no usage statistics sent. The privacy limit is in the
   foundations, value 6.
6. **The brand is made like the rest**: meetings and documents validated
   one by one, kept in the project; public texts are then checked against
   the voice. This rebrand was made that way.

**The first visible gesture: all your projects on one page** (the
portfolio). The promise stays "nothing without you"; order is its first
proof, not a competing promise.

## Proof points
No outside testimonial, no token figure: none exists.

- **BRACE tracks itself** in public from day one (`docs/brace/`).
- **"Never guess" is written down** and can be checked in the repo.
- **This rebrand**: meetings, readable documents, validated one by one,
  public in the repo.
- **The portfolio**: all projects on one page.
- **Installable the official way** on Claude Code (also on Antigravity).
  Free and open source (MIT).
- **A full test suite** (`run_tests.sh`).
- **Never commits or pushes to GitHub without confirmation.**
- **The founder's experience**, presented as such, never as an
  independent review.

Missing: testimonials from other people, a measure of "light", the first
interview voices.

## What we say in public

No public promise on what is not shipped.

| Topic | State | In a public text |
|---|---|---|
| Tracking, written decisions, portfolio | Exists | Yes, with facts |
| Brand made through validated meetings and documents | Exists | Yes |
| Keeping the project true to the brand | Partly (public texts checked against the voice) | Only what is checked |
| Coming design work and skills | Does not exist | Nothing |
| Privacy | Limit settled and checked (foundations, value 6) | That limit, word for word |
| Taking over documents made by you or an agency | Idea for later | Nothing until shipped and checked |
| Other agents than Claude Code | A direction | Antigravity cited as a fact, always second: "for Claude Code, also works with Antigravity" |
| "Replaces your agency" | Against the line | Never |
| Former name project-tracker | To clean up | One "formerly project-tracker", in the README only |

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
- Never present BRACE as an agency to the public: it is how we work, not
  what people get.
