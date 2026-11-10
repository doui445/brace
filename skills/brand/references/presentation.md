# Strategic recommendation

Read by `SKILL.md` to build any deck (the syntax below), and at the
strategy meeting (`brand_stage: presentation`). A 1.1 mission follows
`references/legacy-1.1/presentation.md` for the meeting itself.

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
`presentations/<NN-phase>/<YYYY-MM-DD>-<meeting>.html`, in the folder of
its meeting (`03-strategy`, `04-naming`, `05-creation`, `06-refinement`,
`07-delivery`; `references/documents.md`). Keep every final version;
overwrite only the draft.

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
| `palette` | `meta`, `title`, `intro`, `swatch` (repeat: hex, pipe, name, pipe, role: `main`, `accent` or `neutral`), `foot` | |
| `type` | `meta`, `title`, `pair` (display font, pipe, text font), `sample`, `why`, `foot` | |
| `logo` | `meta`, `title`, `svg` (a path, relative to the deck's Markdown), `why`, `foot` | |
| `mood` | `meta`, `title`, `intro`, `foot` | `@ref`, `@image` (`src`, `caption`) |

The `palette` slide prints each colour's code and its contrast on white
and on black. The `logo` slide inlines the SVG; an unsafe or invalid SVG
stops the render (fix it with the designer). An `@image` is an
exploration image (`brand/sources/`, out of git; `src:` relative to the deck's Markdown, like `svg:`): where it is missing (a
clone), the slide shows a neutral placeholder instead. A front matter
`theme:` (a path to the brand's `brand.css`, relative to the Markdown)
dresses the deck in the client's identity, after the agency's style.

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
- The mockups show the words on real supports (project page, post, home
  page, profile). In the creative deck, each route's look dresses them
  (`references/creation.md`).

## The strategy deck

The market, the audience and the territories, then our recommendation;
one or two slides per section:

1. `cover`: the client's own sentence from the brief, and the territories
   to come.
2. The category and the competitors, in short (the benchmark's essentials;
   a `doc` or `compare` slide), then the audience (the personas as cards).
   For a rebrand, the audit first (`references/rebrand.md`).
3. For each territory: `route` (the stance, who it is for, against whom,
   the risk; no tagline: words and look come at the creative meeting),
   `refs` (the analyst's references, when they help).
4. `reco`: the agency's recommendation, and the weighing of the client's
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
4. **The recap, the platform, the next appointment, goodbye**: the client
   picks one territory, combines elements of several (a small change,
   settled now), or rejects the direction (a big change:
   `references/adjustments.md`, a new proposal). Then, in this order:
   - **The platform, written now.** While you recap what was decided and
     ask the questions for the next phase (`references/backstage.md`),
     `strategist` writes the `platform` (purpose, personality,
     positioning, promise, proofs, and the compass: five to seven
     questions the brand asks itself before each choice) and
     `copywriter` its last page, the manifesto, in parallel. Everything in
     it was just decided: nothing is reopened. Render it (a read document,
     phase `strategy`), open it, and get a yes **before the client leaves**:
     the creative work is built on it. A word to change is changed on the
     spot. A client who leaves before saying yes finds it first at their
     next session.
   - On the yes, write `FOUNDATIONS.md` and `STRATEGY.md` from it
     (`references/foundations.md`, `references/strategy.md`), with a link.
   - Close the meeting (`SKILL.md`, closing a meeting): the minutes (the
     territory chosen, the ones set aside and why, also in
     `docs/brace/brand/DECISIONS.md`), the next appointment (`naming` when
     a name is needed, else `creation`).
5. **Our team gets to work**: set `brand_stage: backstage`.

Decks speak like the agency: verbs and the active voice ("We keep", never
a bare "Kept"), and the team's short signed notes (`note:`) on a few
slides.
