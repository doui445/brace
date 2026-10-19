# Strategy

Read by `SKILL.md` at the strategy step (`brand_stage: strategy`). Writes
`STRATEGY.md`, one section at a time, each approved before it is written.

## The research first

Wait for the analyst's report. Show its table and let the user correct it:
a competitor to drop, one to add, a source not to trust. Append those
corrections to `docs/brace/agents/analyst/BRIEF.md` (the analyst never sees
the conversation). Only then does anything go into `STRATEGY.md`.

## The sections

- **Objectives**: what the brand must achieve (visibility, partners,
  hiring, leads, users). No vanity metric.
- **Personas**: one or two well defined people rather than "everyone":
  demographics, psychographics, where they are, their values, and their
  **emotional starting state**. Built from the audience research and from
  the real interviews the user ran; aim at the majority of the target, not
  a niche of it.
- **Competitive landscape**: the summary the user approved, with a link to
  the dated report in `docs/brace/agents/analyst/`. Never the raw report.
- **Differentiators**: what this brand does that the others do not.
  Different is better than better.
- **Positioning**: a map on two axes that matter to the personas, down to
  one place nobody holds, then a one-sentence positioning statement.
- **Mechanism**: why this works where the alternatives failed.
- **Proof points**: the reasons to believe the promise. A useful
  testimonial is a precise result from a real person; in the repo's files
  that person is named by their role, never by their name.
- **Indicator**: one indicator chosen with the user, the one that says
  whether the brand works. "None" is a valid answer and is written as such.
- **Touchpoints**: every place the brand speaks. Repo files in backticks,
  one per line (a hook reads this section):

  ```
  - `README.md`: first contact on GitHub
  - `docs/site/index.html`: the site
  ```

  Places outside the repo (a profile, a store page) in plain words.
- **Brand architecture**: only when the project has sub-projects
  (`subprojects:` in `STATUS.md`) or sub-brands. Choose and justify one
  model: a single brand, endorsed brands, sub-brands, or a house of
  brands.
- **Non-goals**: what the brand will not do or be.

For a personal brand, add packaging, channels and cadence
(`references/personal.md`).

When the strategy is written, set `brand_stage: voice`.
