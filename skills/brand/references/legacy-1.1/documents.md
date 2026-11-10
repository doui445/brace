# The client documents

Read by `SKILL.md` and by every meeting that produces a document. The
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
| Routes and recommendation | `routes` | `strategist` | `strategy` | presented |
| Brand audit (a rebrand) | `audit` | `strategist` | `strategy` | presented |
| Brand platform | `platform` | `strategist` | `platform` | presented |
| Editorial guide | `editorial-guide` | `copywriter` | `platform` | read |
| Manifesto | `manifesto` | `copywriter` | `platform` | presented |
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
the same content. The visual identity's documents join this table in a
later release (visual routes and the identity in place, presented; the
brand guidelines, read).

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
the meeting's number in this mission's plan.

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
  "<root>/docs/brace/brand/documents/<YYYY-MM-DD>-<file name>.html"
```

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
The client's own identity will apply to what is theirs (mockups, brand
book) once the visual identity exists (a later release).
