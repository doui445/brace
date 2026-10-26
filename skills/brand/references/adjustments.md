# Adjustments

Read by `SKILL.md` once a route is chosen (`brand_stage: adjustments`).
The chosen route is refined into the final documents.

## Document by document

The documents of the brand platform, in this order:

1. **Foundations**: `FOUNDATIONS.md`, content in `references/foundations.md`.
2. **Strategy**: `STRATEGY.md`, content in `references/strategy.md`.
3. **Voice**: `VOICE.md`, content in `references/voice.md`.
4. **Name**, only when one is needed (no name yet, a working name, a
   rebrand): `references/name.md`.

For each document:

1. Draft it from the chosen route, the brief and the agents' reports. Ask
   the strategist or the copywriter for a part that is theirs (a sharper
   positioning, a tagline that holds, names) rather than writing it
   yourself.
2. Show it **rendered**, never as Markdown: a `slide doc` page in
   `presentations/draft.html` (`references/presentation.md`), one document
   at a time.
3. The user keeps it, changes a line, or says what is missing. A line they
   cannot answer stays "to fill in".
4. Once they say yes, write the Markdown file, the project's memory that
   the skills read. Say it is saved and they can stop here.

A personal brand adds the parts listed in `references/personal.md`.

## Resumed from 1.0

A project started on BRACE 1.0 (an old stage mapped here by the
`legacy:` line in `SKILL.md`) has no chosen route, no `BRIEF.md` and no
`SESSIONS.md`. Then:

- The brand files already written stand in for the chosen route. A
  document the user already validated is kept and never redrafted;
  propose a change only if they ask.
- Start at the first missing document, in the order above.
- Create `SESSIONS.md` with a first entry saying where the work resumed.
- Offer to pre-fill `BRIEF.md` from the existing files; if the user
  declines, leave it out. Never invent a route or a brief.

## Closing the adjustments

1. Write the final version of the rendered documents as
   `presentations/<YYYY-MM-DD>-adjustments.html`.
2. Append an entry to `SESSIONS.md`.
3. Set `brand_stage: delivery`.
