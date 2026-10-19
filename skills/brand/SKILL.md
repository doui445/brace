---
name: brand
description: Use when the user works on a project's brand (its purpose, positioning, audience, competitors, voice, tagline or name, a launch, a rebrand, or a review of the brand strategy). Brand substance only, the brand's visual identity comes in a later release.
---

# BRACE: brand

Builds and keeps alive the substance of a project's brand: why it exists,
for whom, against whom, how it speaks, what it is called. Never the visual
identity in this release.

`track` owns the project's memory; this skill adds to it under
`skills/track/references/skills-contract.md`. Same first principle as
`track`: **never guess**. A missing fact is asked; a section with no answer
stays marked "to fill in".

## Files

In the project, created on first use:

- `docs/brace/brand/FOUNDATIONS.md`: purpose (why, how, what), personality,
  values, vision, core emotion, brand story, the chosen name. Durable.
- `docs/brace/brand/STRATEGY.md`: objectives, personas, competitive
  landscape, differentiators, positioning, mechanism, proof points, one
  indicator, touchpoints, brand architecture when needed, non-goals.
  Revised over time.
- `docs/brace/brand/VOICE.md`: how the brand speaks.
- `docs/brace/brand/DECISIONS.md`: brand choices (tried, why set aside,
  kept), append-only, separate from the project's main `DECISIONS.md`.

One fact, one file: the why in `FOUNDATIONS`, where and against whom in
`STRATEGY`, how we speak in `VOICE`. Raw research stays with the analyst;
`STRATEGY` keeps only the summary the user checked, with a link.

Headings come from `skills/track/references/i18n/<code>.md` (`brand.*`
keys), in the project's effective language (see `track`'s
`## Output language`). The Touchpoints section lists repo files in
backticks: a hook reads it.

`STATUS.md` frontmatter, three keys only:

- `brand_profile: product | personal`: asked once, at the start.
- `brand_stage: interview | strategy | voice | name | test | done`: where to
  resume.
- `brand_reviewed: YYYY-MM-DD`: the last review (set when the first session
  ends, then at each review).

## Starting

- Starts on demand: `/brace:brand`, or the conversation touches positioning,
  naming, a launch or a rebrand. No activation question, nothing at every
  session.
- Project not tracked: explain that brand's files live in `docs/brace/` and
  offer to track the project first (the `track` skill).
- Project still on the old `docs/project-tracker/` folder (its move to
  `docs/brace/` is pending until the tool restarts): never create
  `docs/brace/` this session, or the move would find both folders and stop.
  Say the brand work starts once the move is done; brief the analyst as
  "not tracked".
- `docs/brace/brand/` exists: resume at `brand_stage`. Otherwise ask one
  question: product brand or personal brand, with a recommendation drawn
  from the context.
- What already exists (README, a bio, site copy) is material, never an
  answer: quote it and ask whether it still holds.

## How to ask

One question at a time, open questions, reuse the user's own words, never
steer them towards an answer. Nothing is written before the user approves
that part: show it, get a yes, then write it. Follow `track`'s
`## Asking questions` and the platform notes
(`skills/track/references/platform-claude.md`,
`skills/track/references/platform-antigravity.md`).

## The first session

1. **Interview** (`interview`): read `references/interview.md`. Ends by
   launching the analyst in the background (see below).
2. **Foundations**: while the analyst works. `references/interview.md`,
   second half. Writes `FOUNDATIONS.md`.
3. **Strategy** (`strategy`): `references/strategy.md`. Writes
   `STRATEGY.md`.
4. **Voice** (`voice`): `references/voice.md`. Writes `VOICE.md`.
5. **Name** (`name`), only when one is needed (no name yet, a working name,
   a rebrand): `references/name.md`.
6. **Test** (`test`): `references/test.md`.
7. **Presentation**: the brand in five lines, a few targeted questions
   (never "do you like it?"), and an invitation to sleep on it. Then set
   `brand_stage: done` and `brand_reviewed` to today, and offer to carry the
   tagline into the README.

For a personal brand, read `references/personal.md` as well: it adds to
steps 1 to 3.

**Pausing.** The user may stop at any step: keep `brand_stage` where it is
and add "finish the brand (<stage> step)" to the next actions in
`STATUS.md`. No reminder at every session: resume when the topic returns or
the user asks.

## The analyst

Research goes to the `analyst` agent, never done inline.

- Before each mission, ask the user for the depth: **quick** (5 to 8
  entries, one line and one source each) or **full** (the whole
  landscape). Recommend one from the context (first brand session: full;
  a passing "who else does this?": quick; a review: the depth used last
  time).
- Launch it in the background with a complete brief (it does not see the
  conversation): subject, depth, "asked by brand" and what for, the project
  context, what the user already knows, the project root.
  - Claude Code: the Agent tool with `subagent_type: "brace:analyst"`, in
    the background.
  - Antigravity: `invoke_subagent` with the type `analyst`.
- Carry on with the interview while it works.
- When it reports, show its table and let the user correct it before
  anything goes into `STRATEGY.md`. Append the user's corrections (a
  competitor to drop, a source not to trust) to
  `docs/brace/agents/analyst/BRIEF.md`: you write that file for the user,
  since the analyst never sees the conversation.

## After the first session

- **Review** (calendar and events) and **rebrand**:
  `references/revision.md`.
- **Voice drift** on public texts: `references/voice.md`, second half.

## Never

- Never write the visual identity (logo, colours, type) in this release.
- Never present unverified research as fact, or an availability check as
  legal advice.
- Never replace a real test with real people by a simulated one.
