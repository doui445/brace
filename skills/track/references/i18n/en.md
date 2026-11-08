# i18n catalogue — English (`en`)

Canonical key list for the tracking-file headings and template phrases the
`brace:track` and `brace:brand` skills write. `fr.md` (and any future
`<code>.md`) mirrors this file: **same keys, same order**. A guard test enforces it.

**This file is the source of truth for the wording.** `SKILL.md`,
`references/writing-tracking-files.md` and `references/backlog-phases.md`
describe the *structure* of each file; wherever they name a heading, that
text must match a value here. When either side changes, reconcile the other.
`generate_portfolio.py` keeps its own `STRINGS` table (portfolio UI only) —
that one is not derived from this file.

**Never translated** (not listed here, kept verbatim in every language):
frontmatter keys and their enum values (`status: active|paused|blocked|archived`,
`"non"`, `"adopté"`, `"leger"`, `"superpowers"`), standard file names, hook
names, the tag `#tracker-sync`, language codes.

## STATUS.md

- status.title: STATUS — {project}
- status.intro: Snapshot of the current state. Fully rewritten each session.
- status.heading.where_it_stands: Where it stands
- status.heading.what_works: What works
- status.heading.known_gaps: Known gaps
- status.heading.next_actions: Next 3 actions

## ROADMAP.md

Structure is phase-dependent (see `references/backlog-phases.md`): with no
phase started, `current_focus` holds a simple prioritised list; once a phase
is running, `in_progress` and `after` replace it.

- roadmap.title: ROADMAP — {project}
- roadmap.intro: Prioritised synthesis. Raw detail lives in BACKLOG.md.
- roadmap.heading.done: Done
- roadmap.heading.current_focus: Current focus
- roadmap.heading.in_progress: Phase {n} — in progress
- roadmap.heading.after: After Phase {n}
- roadmap.heading.unprioritised: Unprioritised ideas

## JOURNAL.md

- journal.title: JOURNAL — {project}
- journal.intro: Dated chronological log. Append-only.
- journal.entry_heading: {date} — {topic}

## CHANGELOG.md

- changelog.title: Changelog — {project}
- changelog.intro: Format based on Keep a Changelog.
- changelog.heading.unreleased: Unreleased
- changelog.group.added: Added
- changelog.group.changed: Changed
- changelog.group.fixed: Fixed
- changelog.group.removed: Removed

## DECISIONS.md

- decisions.title: DECISIONS — {project}
- decisions.intro: Why each structural choice, and what was rejected. Append-only.
- decisions.label.context: Context
- decisions.label.decision: Chosen
- decisions.label.rejected: Rejected
- decisions.label.downside: Accepted downside

## ERRORS.md

- errors.title: ERRORS — {project}
- errors.intro: Bug then cause then fix, searchable. Append-only.
- errors.empty: No entries yet.
- errors.label.symptom: Symptom
- errors.label.cause: Root cause
- errors.label.fix: Fix
- errors.label.recognise: Recognise it again

## BACKLOG.md

- backlog.title: BACKLOG — {project}
- backlog.intro: Raw reservoir of every idea. Never purged, only archived.
- backlog.heading.high: High priority
- backlog.heading.medium: Medium priority
- backlog.heading.low: Low priority
- backlog.heading.completed: Completed
- backlog.heading.how_to_use: How to use this backlog
- backlog.none_open: (nothing open)

## GLOSSARY.md

Optional, created on first need (no fixed headings — a flat list or grouped
by theme).

- glossary.title: GLOSSARY — {project}
- glossary.intro: Terms specific to this project, and what they mean here.

## SUBPROJECTS.md

Optional, created on first need (one prose section per sub-project, no fixed
headings beyond the sub-project names).

- subprojects.title: SUBPROJECTS — {project}
- subprojects.intro: The sub-projects attached to this project: why each one exists, where it stands, and where its own files live.

## brand/BRIEF.md

The client brief: pre-filled by `brace:brand` from what the project already
says, validated with the user at the workshop.

- brand.brief.title: BRAND BRIEF — {project}
- brand.brief.intro: What the agency was asked for. Pre-filled from the project, checked with you at the workshop.
- brand.brief.heading.project: The project
- brand.brief.heading.objectives: What the brand must achieve
- brand.brief.heading.audience: Who it is for
- brand.brief.heading.competitors: Competitors you know
- brand.brief.heading.name: Name
- brand.brief.heading.taste: What you like
- brand.brief.heading.emotion: The feeling to leave
- brand.brief.heading.never: What you never want
- brand.brief.heading.languages: Languages (working, brand)
- brand.brief.heading.assumptions: Assumptions to check

## brand/SESSIONS.md

Append-only, one entry per session.

- brand.sessions.title: BRAND SESSIONS — {project}
- brand.sessions.intro: One entry per session with the agency: what was decided, what is waiting, what comes next.
- brand.sessions.decided: Decided
- brand.sessions.waiting: Waiting
- brand.sessions.next: Next
- brand.sessions.meeting: Next meeting

## brand/FOUNDATIONS.md

Written by `brace:brand` (see `skills/brand/references/`). `journey` only for
a personal brand.

- brand.foundations.title: FOUNDATIONS — {project}
- brand.foundations.intro: Who we are and why. The durable base every other brand choice is judged against.
- brand.foundations.heading.purpose: Purpose
- brand.foundations.heading.personality: Personality
- brand.foundations.heading.emotion: Core emotion
- brand.foundations.heading.story: Brand story
- brand.foundations.heading.journey: Journey
- brand.foundations.heading.name: Name

## brand/STRATEGY.md

`architecture` only when the project has sub-brands or sub-projects;
`packaging` and `channels` only for a personal brand. The `touchpoints`
section lists repo files in backticks: a hook reads it.

- brand.strategy.title: STRATEGY — {project}
- brand.strategy.intro: Where we play and against whom. Revised over time.
- brand.strategy.heading.objectives: Objectives
- brand.strategy.heading.personas: Personas
- brand.strategy.heading.landscape: Competitive landscape
- brand.strategy.heading.differentiators: Differentiators
- brand.strategy.heading.positioning: Positioning
- brand.strategy.heading.mechanism: Mechanism
- brand.strategy.heading.proof: Proof points
- brand.strategy.heading.indicator: Indicator
- brand.strategy.heading.touchpoints: Touchpoints
- brand.strategy.heading.architecture: Brand architecture
- brand.strategy.heading.packaging: Packaging
- brand.strategy.heading.channels: Channels and cadence
- brand.strategy.heading.non_goals: Non-goals

## brand/VOICE.md

- brand.voice.title: VOICE — {project}
- brand.voice.intro: How the brand speaks. Public texts are checked against it.
- brand.voice.heading.exercise: Voice first
- brand.voice.heading.attributes: Voice attributes
- brand.voice.heading.tone: Tone by context
- brand.voice.heading.lexicon: Lexicon
- brand.voice.heading.mechanics: Writing rules
- brand.voice.heading.pillars: Message pillars
- brand.voice.heading.tagline: Tagline and boilerplate

## brand/DECISIONS.md

Append-only, separate from the project's main `DECISIONS.md`.

- brand.decisions.title: BRAND DECISIONS — {project}
- brand.decisions.intro: Brand choices: what was tried, why it was set aside, what was kept.

## Brand notifications

The macOS notification sent when a brand presentation is ready.

- brand.team.brand.name: Julie
- brand.team.brand.role: account director
- brand.team.analyst.name: Ravi
- brand.team.analyst.role: research analyst
- brand.team.strategist.name: Constance
- brand.team.strategist.role: brand strategist
- brand.team.copywriter.name: Ben
- brand.team.copywriter.role: copywriter
- brand.team.creative_director.name: Lou
- brand.team.creative_director.role: creative director
- brand.lex.contact: first contact
- brand.lex.proposal: proposal
- brand.lex.kickoff: kickoff meeting
- brand.lex.workshop: framing workshop
- brand.lex.minutes: minutes
- brand.lex.meeting: meeting
- brand.lex.recommendation: strategic recommendation
- brand.lex.routes: routes
- brand.lex.platform: brand platform
- brand.lex.editorial_guide: editorial guide
- brand.lex.manifesto: manifesto
- brand.lex.delivery: delivery
- brand.lex.client_space: client space
- brand.lex.test_plan: test plan
- brand.lex.benchmark: competitive benchmark
- brand.lex.personas: personas
- brand.lex.rebrand: rebrand
- brand.lex.audit: brand audit
- brand.lex.transition: transition plan
- brand.lex.announcement: announcement
- brand.lex.before: today
- brand.lex.after: tomorrow
- brand.lex.archive: archive
- brand.space.title: Your brand, {project}
- brand.space.meetings: Our meetings
- brand.space.documents: Your documents
- brand.space.next: Next meeting
- brand.space.none: Nothing here yet.
- brand.phase.contact: First contact and proposal
- brand.phase.framing: Framing workshop
- brand.phase.strategy: Strategic recommendation
- brand.phase.platform: Brand platform
- brand.phase.visual: Visual identity
- brand.phase.delivery: Delivery
- brand.doc.by: {name}, {role}
- brand.notify.title: BRACE
- brand.notify.ready: The agency's work is ready.

## Shared

- shared.to_fill_in: to fill in
- shared.none_yet: No entries yet.
