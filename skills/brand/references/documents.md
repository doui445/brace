# The client documents

Read by `SKILL.md` and by every meeting that produces a document. The
documents are what the agency actually delivers; the decks rest on them,
and the client can open any of them from their client space. The client
never has to read one to move on: the meeting shows what matters, the
document is there for whoever wants to dig.

## Who writes what

| Document | File name | Author | Meeting |
|---|---|---|---|
| Proposal | `proposal` | account director (`brand`) | 0 |
| Brief (the workshop's minutes) | `brief` | account director (`brand`) | 1 |
| Minutes of each meeting | `minutes-<n>` | account director (`brand`) | each |
| Competitive benchmark | `benchmark` | `analyst` | 2 |
| Personas | `personas` | `strategist` | 2 |
| Routes and recommendation | `routes` | `strategist` | 2 |
| Brand platform | `platform` | `strategist` | 3 |
| Editorial guide | `editorial-guide` | `copywriter` | 3 |
| Manifesto | `manifesto` | `copywriter` | 3 |
| Test plan | `test-plan` | `strategist` | 4 |

An agent writes its documents in its own folder
(`docs/brace/agents/<agent>/<YYYY-MM-DD>-<file name>.md`); the account
director writes hers in `docs/brace/agents/brand/`. The creative director
reviews each one before the client sees it. Once the client validates a
document, its content goes into the brand file it feeds
(`FOUNDATIONS.md`, `STRATEGY.md`, `VOICE.md`, `DECISIONS.md`), with a link
to the document.

## The Markdown

Every document starts with its front matter, then the text:

```
---
title: Competitive benchmark
author: <first name, from brand.team.<agent>.name>
role: <role, from brand.team.<agent>.role>
lang: <working language code>
meeting: 2
date: 2026-11-05
---

## What we looked at
...
```

The subset `render.py` renders: headings `#` to `###`, paragraphs, `-` and
`1.` lists, tables (a header row, a `|---|` line, rows), `>` quotes,
`[links](file.html)`, `**bold**`, `*italic*`, `` `code` ``. Anything else
shows as plain text. Links to other documents are relative
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
