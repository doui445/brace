# Strategic recommendation

Read by `SKILL.md` to build a deck, and at meeting 2 (`brand_stage:
presentation`).

## The deck: Markdown, rendered

Never write a deck's HTML: write its Markdown and render it.

```bash
python3 "<skill>/scripts/render.py" deck \
  "<root>/docs/brace/agents/brand/<YYYY-MM-DD>-<meeting>.md" \
  "<root>/docs/brace/brand/presentations/draft.html"
```

The model is `assets/example.md` (its rendering is `assets/example.html`):
read it before writing a deck. Work on `draft.html`; after the creative
director's review, render the final version as
`presentations/<YYYY-MM-DD>-<meeting>.html` (`strategy`, `adjustments`,
`delivery`). Keep every final version; overwrite only the draft.

**The syntax.** A front matter (`title`, `lang` the working language,
`footer`), then one slide per `::: <type>` line, then `field: value` lines.
Inside a slide, its own fields come before the first `@` block (a field
after a block belongs to that block). In every value, ` | ` separates two parts (a label and a text, or two
lines of a title). Inline `**bold**`, `*italic*` and `` `code` `` work
everywhere.

| Type | Fields | Blocks |
|---|---|---|
| `cover` | `meta`, `eyebrow`, `title`, `text`, `routes` (separated by the pipe), `on` (the route shown first), `foot` | |
| `route` | `meta`, `eyebrow`, `title`, `lede`, `why` (repeat: label, pipe, text), `tagline` (label, pipe, quote), `sub`, `foot` | |
| `compare` | `meta`, `title`, `intro`, `head` (the two column labels, pipe-separated; default: today and tomorrow, from the catalogue), `row` (repeat: label, pipe, before, pipe, after), `foot` | |
| `context` | `meta`, `title`, `intro`, `foot` | `@laptop hero`, `@laptop readme`, `@phone post`, `@phone profile` |
| `refs` | `meta`, `title`, `intro`, `foot` | `@ref` (`mark`, `title`, `text`, `take`, `src`) |
| `reco` | `meta`, `eyebrow`, `title`, `lede`, `item` (repeat), `next` (label, pipe, text), `foot` | |
| `doc` | `meta`, `title`, `intro`, `ask`, `foot`, then free Markdown | |

Mockup fields: `@laptop hero` (`bar`, `brand`, `title`, `text`, `cta`,
`caption`), `@laptop readme` (`bar`, `file`, `name`, `tag`, `text`
repeated, `caption`), `@phone post` (`name`, `handle`, `text` repeated,
`card`, `url`, `caption`), `@phone profile` (`banner`, `name`, `handle`,
`bio`, `stats`, `caption`). `foot` is ` left | middle` or just the middle
(the left is then the front matter's `footer`); the page number is added.
An unknown type or field stops the render with exit code 1 and the line:
fix the Markdown.

## Two layers

- The frame (cover, recommendation, documents) is in the agency's house
  style, `deck.css` as it is.
- The mockups show each route's words on real supports (project page,
  post, home page, profile) in a neutral layout; the route's own visual
  identity comes in a later release.

## The deck of meeting 2

Order of slides, one route at a time:

1. `cover`: the client's own sentence from the brief, and the routes to
   come.
2. For each route: `route` (positioning, who it is for, against whom, the
   risk, the tagline and the one-liner), `context` (two mockups:
   `laptop` with `readme` or `hero`, `phone` with `post` or `profile`),
   `refs` (the analyst's references).
3. `reco`: the agency's recommendation, and the weighing of the client's
   tastes against the target, said plainly ("You like loud brands; your
   target trusts calm ones. We recommend calm, and here is what we kept
   from your taste.").

It rests on the documents of the backstage (`benchmark`, `personas`,
`routes`): mention them, the client can open them from their space.

**References**: text and link only, no third-party image or logo. Each
says what we take from it and what we leave, and comes from the analyst's
report, with its source.

## The meeting

1. Open it as a meeting: what the team did since last time, in two lines,
   then the deck (its path, opened in the browser; arrows move between
   slides; it prints one slide per page).
2. Walk through it one route at a time, in a few lines each.
3. Propose, never ask "do you like it?". Say what each route promises in
   one line, give the recommendation and why ("Route 1 promises an exact
   record, route 2 a calm partner; we would pick 1, because your target
   gets asked to justify its hours"), then offer the choices: route 1,
   route 2, a mix of both, or another round. Point at what the client said
   they never wanted, and say how each route avoids it.
4. The client picks one route, combines elements of several, or asks for
   another round (back to `references/backstage.md` with what they said).
5. Close the meeting (`SKILL.md`): the minutes (the route chosen, the
   routes set aside and why, also in `docs/brace/brand/DECISIONS.md`), the
   next appointment, then the team writes the platform. Set
   `brand_stage: adjustments`.
