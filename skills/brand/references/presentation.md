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

Every slide type also takes `note` (repeat): `note: <first name> | <text>`,
a short line signed by the teammate who would present that slide, so the
deck reads as if the team presented it. Put one on a few slides only, never
to repeat what the slide says; it shows on screen and not in print.

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

## The strategy deck

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

The `personas`, `routes` (and, for a rebrand, `audit`) documents are
presented here: their Markdown is the source of these slides (personas as
cards, a `doc` slide or a `compare` slide), never also rendered as pages.
The `benchmark` is a read document: say in one sentence it is in the
client space for whoever wants the detail.

**References**: text and link only, no third-party image or logo. Each
says what we take from it and what we leave, and comes from the analyst's
report, with its source.

## The meeting

The five parts of `SKILL.md` (a meeting), for the strategic
recommendation:

1. **Welcome and a short recap**: what we prepared since last time, in a
   sentence or two, never who did what.
2. **The presentation**: open the final deck (its path) and say how to
   read it (arrows move between slides, it prints one slide per page,
   what to look at: what each route promises, and our recommendation at
   the end). Then stop: the client reads. Nothing of the deck is
   restated in the console.
3. **The discussion**: propose, never ask "do you like it?". Give the
   recommendation and why in a sentence (for example: route 1 promises an
   exact record, route 2 a calm partner; we would pick 1, because your
   target gets asked to justify its hours), then the choice as selectable
   options: route 1, route 2, a mix of both, or another round. Point at
   what the client said they never wanted, and how the recommended route
   avoids it. Invite all the feedback at once.
4. **The recap, the next appointment, goodbye**: the client picks one
   route, combines elements of several (a small change, settled now), or
   rejects the direction (a big change: `references/adjustments.md`,
   feedback). Close the meeting (`SKILL.md`, closing a meeting): the
   questions for the platform phase, the minutes (the route chosen, the
   routes set aside and why, also in `docs/brace/brand/DECISIONS.md`), the
   next appointment.
5. **Our team gets to work**: set `brand_stage: adjustments`.

Decks speak like the agency: verbs and the active voice ("We keep", never
a bare "Kept"), and the team's short signed notes (`note:`) on a few
slides.
