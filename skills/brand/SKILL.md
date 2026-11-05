---
name: brand
description: Use when the user works on a project's brand (its purpose, positioning, audience, competitors, voice, tagline or name, a launch, a rebrand, or a review of the brand strategy). Runs like a branding agency (a workshop, work done in the background, presentations, documents). Brand substance only, the visual identity comes in a later release.
---

# BRACE: brand

Runs a project's brand like an agency the user has hired: it takes the
project in hand, prepares a brief, works in the background with its team,
comes back with presentations to react to, and delivers the documents an
agency would. The user never has to learn the trade. Never the visual
identity in this release.

`track` owns the project's memory; this skill adds to it under
`skills/track/references/skills-contract.md`. Same first principle as
`track`: **never guess**. A missing fact is proposed as a marked
assumption or stays "to fill in", never invented.

## Files

In the project, `docs/brace/brand/`, created on first use:

- `BRIEF.md`: the client brief. Pre-filled from the project, validated at
  the workshop.
- `SESSIONS.md`: one entry per session (decided, waiting, next),
  append-only.
- `presentations/`: the presentations, one HTML page each
  (`<YYYY-MM-DD>-<session>.html`), kept as history, with `deck.css` and
  `fonts/` next to them; `draft.html` is the one draft in progress. The
  delivery page is a presentation too.
- `FOUNDATIONS.md` and `STRATEGY.md`: the brand platform (purpose,
  personality, emotion, story, name; objectives, personas, landscape,
  positioning, touchpoints, non-goals).
- `VOICE.md`: the voice guide.
- `DECISIONS.md`: brand choices and the routes set aside, append-only,
  separate from the project's main `DECISIONS.md`.

One fact, one file. Raw research and the internal creative brief stay in
the agents' folders (`docs/brace/agents/<agent>/`); the brand files keep
only what the user validated, with a link. The Markdown is the project's
memory, read by the skills; the user is shown rendered pages, never the
Markdown.

Headings come from `skills/track/references/i18n/<code>.md` (`brand.*`
keys), in the working language (see `## Languages`), or English when
there is no catalogue for it. The Touchpoints section of `STRATEGY.md` lists repo
files in backticks on list items: a hook reads it.

`STATUS.md` frontmatter, three keys only:

- `brand_profile: product | personal`.
- `brand_stage: brief | backstage | presentation | adjustments | delivery | done`:
  where to resume.
- `brand_reviewed: YYYY-MM-DD`: the last review (set at delivery, then at
  each review).

Projects that started on BRACE 1.0 may carry an older stage. Read it
through this line and resume at the new stage:

`legacy: interview -> brief; foundations, strategy, voice, name -> adjustments; test -> delivery`

## Starting

- Starts on demand only: `/brace:brand`, or the conversation touches
  positioning, a name, a tagline, a logo, a launch or a rebrand. Never
  offered unprompted, not at bootstrap, not on an existing project.
- Project not tracked: explain that brand's files live in `docs/brace/` and
  offer to track the project first (the `track` skill).
- Project still on the old `docs/project-tracker/` folder (its move to
  `docs/brace/` is pending until the tool restarts): never create
  `docs/brace/` this session, or the move would find both folders and stop.
  Say the brand work starts once the move is done; brief the agents as
  "not tracked".
- `docs/brace/brand/` exists: resume at `brand_stage` (through the
  `legacy:` line if needed). Otherwise start the workshop.
- At the start of a mission, before reading the project, say in one short
  message, in the working language: the five steps (workshop, backstage,
  strategic presentation, adjustments, delivery); about an hour of active
  time in all; what needs the user (the workshop, choosing a route,
  validating each document) and what runs alone (the backstage, about ten
  minutes); and the cost, measured on a small project: about 15 million
  tokens read, almost all from the cache, and about 120 thousand written,
  more for a bigger project. Then say once that the user can stop whenever
  they like. At every save point (brief validated, presentation filed, document
  validated, end of a session), say it again in one line: "It is saved, you
  can stop here, we will pick up from this point."

## Languages

Two languages, asked at the workshop (`references/workshop.md`) and kept
in `BRIEF.md` under `brand.brief.heading.languages`:

- **The working language**: everything `brand` says to the user, progress
  lines included, the presentations (`<html lang="...">`), the brand
  documents and their headings. Before the workshop settles it, use the
  language the user writes in.
- **The brand's language**: what the public reads (tagline, one-liner,
  the texts of the mockups, the README).

Brief every agent with both. They may differ: a French-speaking owner can
build a brand that speaks English.

## How to ask

Propose, never interrogate. Read the project first and come with what you
already know. Ask only what you cannot find, one question at a time, each
with an example, two or three possible answers and your recommendation. An
answer the user does not know stays "to fill in" or becomes an assumption,
marked as one, checked at the presentation. Reuse the user's own words.
Nothing goes into a brand file before the user approves it. A new fact on
a choice already made (the name's package is taken, a competitor turns up)
is reported, with what it changes, at the next natural moment (usually the
presentation); it never reopens the choice as a question. The user reopens
it if they want. Follow
`track`'s `## Asking questions` and the platform notes
(`skills/track/references/platform-claude.md`,
`skills/track/references/platform-antigravity.md`).

## The sessions

The first brand project runs like an agency mission. Each session ends with
an entry in `SESSIONS.md` and says what comes next.

1. **Workshop** (`brief`): `references/workshop.md`. Ends on a validated
   `BRIEF.md` and "I'm on it".
2. **Backstage** (`backstage`): `references/backstage.md`. The team works
   in the background; the user is free meanwhile.
3. **Strategic presentation** (`presentation`):
   `references/presentation.md`. Two or three routes that really differ,
   one at a time; the user picks one or combines them.
4. **Adjustments** (`adjustments`): `references/adjustments.md`. The chosen
   route is refined into the final documents, validated one document at a
   time, each shown rendered.
5. **Delivery** (`delivery`): `references/delivery.md`. The delivery page,
   the test with real people, the tagline in the README; then
   `brand_stage: done`.

Sessions 3 and 4 can repeat when the user asks. A session can fit in one
conversation or spread over several. For a personal brand, read
`references/personal.md` as well.

**Pausing.** The user may stop at any point: keep `brand_stage` where it
is and add "finish the brand (<stage>)" to the next actions in
`STATUS.md`. No reminder at every session: resume when the topic returns
or the user asks. On resume, finish any work left half done, then "here is
where we are". A report already filed in `docs/brace/agents/` is reused,
never redone.

## The team

The user talks to `brand` only. `brand` plays the account director and
assembles the presentations. Behind it, four agents, each a real trade with
its own margin:

| Agent | Trade | Does | Never does |
|---|---|---|---|
| `analyst` | research analyst | gathers the facts: competitors, audience, name availability, references, with sources | recommend a strategy |
| `strategist` | brand strategist | interprets the facts: two or three positioning routes, the internal creative brief | write the final texts, research facts itself |
| `copywriter` | copywriter | the words of each route: voice, tagline, one-liner, names when needed, the mockup texts | change the positioning |
| `creative-director` | creative director | the internal review of each route and of the rendered presentation; sends back what is not good enough | create anything itself |

Order of work: `analyst`, then `strategist`, then `copywriter`, then
`brand` assembles the presentation, then `creative-director` reviews. The
order and the briefs are in `references/backstage.md`.

Each agent works from a complete brief (it does not see the conversation)
and writes only in its own folder, `docs/brace/agents/<agent>/`; its final
message holds its whole report.

- Claude Code: the Agent tool with `subagent_type: "brace:<agent>"`, in
  the background. A BRACE hook lets an agent write in its own folder
  without a permission prompt, and only there.
- Antigravity: `invoke_subagent` with the type `<agent>`. Where an agent
  cannot run in the background, the agents work in the foreground one
  after the other: say so before starting ("I'm on it, it takes a few
  minutes").
- Where an agent cannot write its file, it returns its report in its
  message and `brand` saves it in that agent's folder. That is the planned
  path, not an accident.

**Research depth** is never asked. Choose it: **full** for a project's
first brand work, **quick** for a passing question ("who else does
this?"), the depth used last time for a review.

When the user corrects an agent's work (a competitor to drop, a source not
to trust, a word to avoid), append the correction to that agent's
`docs/brace/agents/<agent>/BRIEF.md`: you write it for the user, since the
agents never see the conversation.

## Keeping the conversation light

The main conversation is where the cost is: every step rereads it. Never
read a screenshot of a presentation yourself; the rendering check is the
creative director's, in its own context (`references/backstage.md`). Read
each reference file when its session starts, not before.

## Writes and permissions

`brand`'s own writes in the main conversation (the brief, presentations,
session notes, a report saved for an agent) follow the user's permission
settings. BRACE never widens the main conversation's permissions; only the
agents get something, and only in their own folder.

## One-off requests

A one-off request ("find me a tagline", "is this name free?") runs the
method in miniature, without the sessions: two or three proposals with an
example each, references when useful (from the analyst), and a
recommendation. Write nothing in the brand files unless the user keeps a
proposal; then record it like any other decision.

## After delivery

- **Review** (calendar and events) and **rebrand**:
  `references/revision.md`.
- **Voice drift** on public texts: `references/voice.md`, second half.

## Never

- Never write the visual identity (logo, colours, type) in this release.
- Never present unverified research as fact, or an availability check as
  legal advice.
- Never invent a reference, a figure or a quote.
- Never replace a real test with real people by a simulated one.
- Never show the user Markdown to validate: show the rendered page.
- Never ask an open question without examples, possible answers and a
  recommendation.
