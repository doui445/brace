# Refinement

Read by `SKILL.md` before and at the refinement meeting (`refinement`,
`brand_stage: adjustments`), only when the look is in scope. A short
meeting, about fifteen minutes: the logo and the visual system are
settled, so that the delivery shows nothing new.

## Before the meeting (backstage)

1. **`designer`**: two or three versions of the chosen logo (weight,
   proportions, the mark alone or with the name), the palette and type
   settled in `brand.css` (CSS variables, the text pairs declared for the
   checks), the favicon (`favicon.svg`, a symbol, never the name), two
   applications on the client's real supports. It works in
   its own folder (`docs/brace/agents/designer/files/`) and runs the checks
   when it can (`scripts/check_visual.py brand <folder>`); else `brand`
   runs them.
2. **`brand`** builds the refinement deck **in the client's colours**: its
   front matter carries `theme:` pointing at the designer's `brand.css`
   (`references/presentation.md`, the syntax), with a `favicon` slide. The client sees their brand
   live in a real document.
3. **`creative-director`** reviews.

## The meeting

Not the full ritual: a short welcome, the deck (the logo versions, the
system, the two applications), the choice, the goodbye.

- **Retouch live.** "Thinner", "with the other green": the designer
  changes it during the meeting, the slide is rendered again, the client
  looks again. A second round, at a distance, on request.
- **The choice** goes through a selectable question (version 1, 2, 3, a
  mix), our recommendation first.

Close: short minutes (the version validated), the next appointment, set
`brand_stage: delivery`. Meanwhile the designer makes the whole family
and the files, and the documents of the delivery are prepared
(`references/backstage.md`).
