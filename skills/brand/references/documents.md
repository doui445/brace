# The client documents

Read by `SKILL.md` and by every meeting that produces a document. A 1.1
mission keeps `references/legacy-1.1/documents.md` (its documents stay
flat in `documents/`). The
documents are what the agency actually delivers; the decks rest on them,
and the client can open any of them from their client space. The client
never has to read one to move on: the meeting shows what matters, the
document is there for whoever wants to dig.

## Who writes what

| Document | File name | Author | Phase | Form |
|---|---|---|---|---|
| Proposal | `proposal` | account director (`brand`) | `contact` | read |
| Brief (the workshop's minutes) | `brief` | account director (`brand`) | `framing` | read |
| Minutes of each meeting | `minutes-<n>` | account director (`brand`) | each meeting | read |
| Competitive benchmark | `benchmark` | `analyst` | `strategy` | read |
| Personas | `personas` | `strategist` | `strategy` | presented |
| Territories and recommendation | `routes` | `strategist` | `strategy` | presented |
| Brand audit (a rebrand) | `audit` | `strategist` | `strategy` | presented |
| Brand platform, the manifesto as its last page | `platform` | `strategist`, `copywriter` | `strategy` | read |
| Names screening (when a name is needed) | `names-check` | `analyst` | `naming` | read |
| Editorial guide | `editorial-guide` | `copywriter` | `delivery` | read |
| Brand guidelines (when the visual is in scope) | `guidelines` | `designer` | `delivery` | read |
| Brand board (when the visual is in scope) | `brand-board` | `designer` | `delivery` | read |
| Manifesto (1.1 missions only) | `manifesto` | `copywriter` | `platform` | presented |
| Test plan | `test-plan` | `strategist` | `delivery` | read |
| Transition plan (a rebrand) | `transition` | `strategist` | `delivery` | read |
| Announcement (a rebrand) | `announcement` | `copywriter` | `delivery` | read |
| Creative brief (only when the scope leaves the visual to someone else) | `creative-brief` | `strategist` | `delivery` | read |

**Only these are client documents.** Everything else the team writes
(agent reports, checks and screenings, intermediate rounds, the creative
director's review notes, raw interview notes, a names proposal) is
internal work: it feeds a client document or a slide, stays Markdown in
the agents' folders, is never rendered or opened for the client, and the
client can read it on request. An extra need (the team's first names, say)
goes into a client document or the deck as one consolidated
recommendation, never as a new document.

**One form per document.** `presented`: its content goes into the deck of
its meeting (the Markdown stays the source the deck is built from), never
also rendered as a page. `read`: rendered as a vertical page, read in the
client space. A deck presents; a read document details; never both for
the same content.

**Three levels for the client.** The decks are **presented** in a
meeting. Some read documents are **pointed out** by the account director
because they need the client's reading (the proposal, the brief, the
platform, and at the delivery the guidelines, the brand board and the
editorial guide). The others are **for reference** in the space (the
minutes, the benchmark, the names screening, the test plan, and the
rebrand's transition plan and announcement): one sentence says they are
there.

**The shape.** A deck is horizontal (16:9). A read document is a vertical
page (it scrolls, it prints on A4 portrait), except the brand guidelines,
horizontal like an agency's guidelines (`layout: landscape`), and the
brand board, one single page (`layout: board`).

An agent writes its documents in its own folder
(`docs/brace/agents/<agent>/<YYYY-MM-DD>-<file name>.md`); the account
director writes hers in `docs/brace/agents/brand/`. The creative director
reviews each one before the client sees it. Once the client validates a
document, its content goes into the brand file it feeds
(`FOUNDATIONS.md`, `STRATEGY.md`, `VOICE.md`, `DECISIONS.md`), with a link
to the document.

## Writing a client document

- **A read document is written as a document**: the care and the voice of
  its author, in a document's style, not speech. It opens with a few lines
  that say what it is and how it is built (it is read later, alone, from
  the client space; the manifesto of the first trial is the model). Then
  real sentences, verbs, the active voice. No semicolons, no label
  fragments ("Measured on...", "About an hour..."), no "(pre-filled)" in a
  title.
- **A deck speaks like the agency**: no intro page beyond the cover; verbs
  and the active voice ("We keep", never a bare "Kept"); the team's short
  signed notes (`note:`) on a few slides, never repeating the slide.
- **Never internal metadata** shown to the client: who asked, the research
  depth, "read on", a scale, a review verdict.
- **One open at a time.** The account director opens one document or deck,
  one tab, and never two that disagree. What she opens, she is ready to
  present and defend.
- **Honest caveats in one sentence.** When a deliverable rests on what is
  not tested yet (personas from research, say), its opening lines say so
  once, with what to do about it; never as tags in the text.

## The Markdown

Every document starts with its front matter, then the text:

```
---
title: Competitive benchmark
author: <first name, from brand.team.<agent>.name>
role: <role, from brand.team.<agent>.role>
lang: <working language code>
doc: benchmark
phase: strategy
meeting: 2
date: 2026-11-05
---

## What we looked at
...
```

`doc:` is its file name from the table (the client space lists only those,
the latest version of each), `phase:` the phase it belongs to, `meeting:`
the meeting's number in this mission's plan. Optional: `layout:`
(`portrait` by default, `landscape`, `board`) and `theme:` (the brand's
`brand.css`, relative to the Markdown: the guidelines and the brand board
wear the client's identity).

The subset `render.py` renders: headings `#` to `###`, paragraphs, `-` and
`1.` lists (a wrapped line joins its item; items indented by two spaces
form one nested level, deeper ones go back to the first level), `---` alone on its
line (a rule), tables (a header row, a `|---|` line, rows), `>` quotes,
`[links](file.html)`, `**bold**`, `*italic*`, `` `code` ``. Anything else
shows as plain text. Never repeat the title as a `#` heading: the page
shows it already. Links to other documents are relative
(`2026-11-05-routes.html`).

## Rendering

```bash
python3 "<skill>/scripts/render.py" doc \
  "<root>/docs/brace/agents/<agent>/<YYYY-MM-DD>-<file name>.md" \
  "<root>/docs/brace/brand/documents/<NN-phase>/<YYYY-MM-DD>-<file name>.html"
```

Documents and decks are sorted **by meeting**: `01-contact`,
`02-framing`, `03-strategy`, `04-naming`, `05-creation`, `06-refinement`,
`07-delivery` (fixed numbers: a skipped meeting leaves its number
unused). The minutes go in the folder of their meeting; the client space
follows the same order.

`<skill>` is this skill's folder. The script copies the house stylesheets
and fonts next to the output the first time. Exit code 1 means the
Markdown is wrong (the message says where): fix it, never hand-write the
HTML instead.

The client space, after everything else (`references/backstage.md`, the
closing order):

```bash
python3 "<skill>/scripts/render.py" space "<root>"
```

## The house style

Documents and decks carry the agency's house style (`assets/doc.css`,
`assets/deck.css`), the way a real agency delivers on its own letterhead.
What is the client's own wears their identity once it is chosen (`theme:`):
the refinement and handover decks, the guidelines, the brand board.

## What each document holds

- **Proposal** (ten pages at most): what we understood (the project, its
  goals), how we work, the scope, the plan (the meetings, what each asks
  of the client), the tools and their modes, the rounds, the time, the
  budget, the client space, what the client can do at any time
  (`references/contact.md`).
- **Brief**: the workshop's answers, the success criteria included
  (`references/workshop.md`).
- **Minutes**: who was there, what was decided (not necessarily in the
  order it was said), the actions (who, what, when), the next
  appointment.
- **Benchmark**: two parts, the landscape then "so what?"; direct,
  indirect and aspirational competitors; their look described with a
  link, never copied.
- **Personas**: three at most; a name, a situation, goals, brakes,
  channels, a quote, the experience in their own words.
- **Audit** (a rebrand): a summary, the inventory (the current look
  included), where the brand stands, findings, recommendations.
- **Territories and recommendation** (`routes`): the stance of each, for
  whom, against whom, the risk, our pick and why.
- **Platform**: purpose, personality, positioning, promise, proofs, the
  compass (five to seven questions the brand asks itself before each
  choice); the manifesto as its last page (what is wrong in the world,
  the conviction, the future, the call; or three to five principles; 100
  to 600 words).
- **Names screening**: per name kept, what was checked and found.
- **Editorial guide** (readable in twenty minutes): three to five traits,
  each with what to do and what not to do; the fixed voice and the tone
  per channel; a lexicon; before and after examples.
- **Brand guidelines** (horizontal): the foundations in short (a link to
  the platform); the logos and their rules (versions, clear space,
  minimum sizes, what never to do); colour (codes, use, contrast); type
  (fonts, hierarchy, where to get them, licence); images (style, when the
  route has one); the voice (a link to the editorial guide); the
  applications; the files and who to ask; who keeps it up to date.
- **Brand board** (one page): the logos (main, secondary, small mark), the
  palette with its codes, the two fonts with a sample, three images in
  context, the three adjectives of the brand. To send to a printer or a
  freelancer, or to keep in sight.
- **Test plan**, **transition plan** (a rebrand: each support marked
  launch day, gradual or kept as it is; the internal launch first; an
  owner per support), **announcement** (a rebrand).
- **Creative brief** (one page, six sharp parts): context, audience,
  objective, message and tone, deliverables, must-haves.
