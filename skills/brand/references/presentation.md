# Presentation

Read by `SKILL.md` to build a presentation, and at the strategic
presentation (`brand_stage: presentation`).

## The files

- The template ships with this skill: `assets/deck.css`, `assets/fonts/`,
  and `assets/example.html`, the model to follow (one `section` per slide,
  the slide and mockup classes it uses).
- At the first presentation in a project, copy the stylesheet and the
  fonts next to the presentations, in one command:

  ```bash
  mkdir -p "<root>/docs/brace/brand/presentations" && \
    cp -R "<skill>/assets/deck.css" "<skill>/assets/fonts" "<root>/docs/brace/brand/presentations/"
  ```

  `<skill>` is this skill's folder. Each presentation links
  `<link rel="stylesheet" href="deck.css">`.
- Work in `presentations/draft.html`. After the creative director's
  review, write the final version as
  `presentations/<YYYY-MM-DD>-<session>.html` (`strategy`, `adjustments`,
  `delivery`): that write sends the notification. Keep every final
  version; overwrite only the draft.

## Two layers

- The frame (cover, brief, recommendation, documents) is in the BRACE
  agency's house style, `deck.css` as it is.
- Each route shows its own identity through the frame variables on its
  sections (`--accent`, `--serif`, `--sans`). In this release, without
  visual identity, keep the frame's values; the mockups show the route's
  words on real supports (README, post, home page, profile) in a neutral
  layout.

## The strategic presentation

Order of slides, one route at a time:

1. `cover`: the user's own sentence from the brief, and the routes to
   come.
2. For each route: `route` (positioning, who it is for, against whom, the
   risk, the tagline and the one-liner), `context` (two mockups:
   `laptop` with `readme` or `hero`, `phone` with `post` or `profile`),
   `refs` (the analyst's references).
3. `reco`: the agency's recommendation, and the weighing of the user's
   tastes against the target, said plainly ("You like loud brands; your
   target trusts calm ones. We recommend calm, and here is what we kept
   from your taste.").

**References**: text and link only, no third-party image or logo. Each
says what we take from it and what we leave, and comes from the analyst's
report, with its source.

## Showing it

1. Give the user the file path to open in a browser (arrows move between
   slides; it prints to PDF one slide per page).
2. Walk through it one route at a time in the conversation, in a few lines
   each.
3. Ask targeted questions, never "do you like it?": "What does this route
   promise?", "Which one feels like your product?", "Anything you would
   not want to see said?".
4. The user picks one route, combines elements of several, or asks for
   another round (back to `references/backstage.md` with what they said).
5. Write the routes set aside, and why, in `docs/brace/brand/DECISIONS.md`.
   Append an entry to `SESSIONS.md`. Say it is saved.
6. Set `brand_stage: adjustments`.
