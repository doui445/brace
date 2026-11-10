# Backstage

Read by `SKILL.md` whenever our team works between two meetings. The
agents run in the background; the client is free meanwhile. Everything
was settled at the meeting that just ended (the questions for this phase,
the minutes, the appointment): no question to the client while the team
works, and no word to them either until the work is done.

## The backstages, by phase

A 1.1 mission (its plan has `platform`, or no `- plan:` line) follows
`references/legacy-1.1/backstage.md` instead.

| Before the meeting | Stage while it runs | The team prepares | Asked before the team works |
|---|---|---|---|
| `strategy` | `backstage` | benchmark, personas, territories, the strategy deck (and the audit, for a rebrand) | the tastes and rejections, the competitors to add or drop, the success criteria (at the workshop) |
| `naming` | `backstage` | the naming brief, many names, the analyst's screening, the names deck | anything the name must or must not evoke, the markets and languages it must work in |
| `creation` | `backstage` | the routes (words and look together), the mood, palette, type and logo of each, the creative deck | what the chosen territory keeps from the others, any limit on what the brand promises, and, for the delivery, the test choice (real test, checked personas, not now) |
| `refinement` | `adjustments` | two or three versions of the chosen logo, the settled palette and type, two applications, the refinement deck in the client's colours | what the client keeps or changes from the routes (at the creative meeting) |
| `delivery` | `delivery` | the logo family and files, the guidelines, the brand board, the editorial guide, the test kit, the transition plan and announcement (a rebrand), the creative brief (when the look goes to someone else), the handover deck in the client's colours | nothing new: everything was asked before |

The platform and the manifesto are not a backstage: they are written at
the end of the strategy meeting and validated there
(`references/presentation.md`).

Which backstage is due is read from the stage, the `- plan:` line and the
files already in `docs/brace/agents/` and `docs/brace/brand/documents/`: a
document already there is reused, never redone. A meeting that is not in
the plan is skipped. Agents run in parallel only where it serves the
result (routes worked independently differ more); time is never the
reason.

## The briefs

Each agent sees nothing of the conversation: give each one a complete
brief (`SKILL.md`, `## Working with the team`), with the client documents
it owes, their `doc:` and `phase:`, the meeting number, its first name and
role from the catalogue, and the tool modes
for the look. A brief that carries the client's feedback gives the
intent, the constraints and where it lands, never the client's raw words
to paste (`references/adjustments.md`).

**Before the strategy:**

1. **`analyst`**, depth full for a first brand project (never asked).
   Subjects: **competitors** (with their messaging, tone and look, not only
   their features) and **audience** (what people actually say, in their
   exact words). It also writes the client document `benchmark`.
2. **`strategist`**, once the analyst has reported: two or three
   **territories** that really differ (no tagline: that is creative work),
   and the client documents `personas` and `routes` (and `audit` for a
   rebrand, the current look included). Give it the analyst's report
   paths, the client's tastes and rejections, the success criteria and
   the client's own documents (`- existing:`).
3. **`brand`** writes the deck's Markdown and renders it as
   `presentations/draft.html` (`references/presentation.md`).
4. **`creative-director`** reviews the territories, the documents and the
   screenshots of the draft.

**Before the name** (`references/name.md`): `strategist` writes the naming
brief; `copywriter` generates names widely; `analyst` screens them;
`copywriter` keeps six to twelve that passed and writes the names deck's
words; `brand` builds the deck; `creative-director` reviews.

**Before the creation** (`references/creation.md`): `art-director` and
`copywriter` work the routes together, from the validated platform, the
name and the success criteria (the art director explores wide and keeps
two or three); `designer` makes each route's logo sketch and palette
files when the mode needs files; `brand` builds the creative deck;
`creative-director` reviews the whole, look included.

**Before the refinement** (`references/refinement.md`): `designer` makes
two or three versions of the chosen logo and settles the system
(`brand.css`); `brand` builds the refinement deck in the client's colours;
`creative-director` reviews. Meanwhile `copywriter` writes the
`editorial-guide` (the tone was found with the look).

**Before the delivery** (`references/delivery.md`): `designer` makes the
logo family, the files and the Markdown of `guidelines` and
`brand-board`; `strategist` writes `test-plan` for the option the client
chose, and for a rebrand `transition` (with the folder rule of
`references/rebrand.md`); `copywriter` writes `announcement` (a rebrand);
`strategist` writes `creative-brief` when the look goes to someone else.
Then `brand` builds the handover deck in the client's colours, and
`creative-director` reviews everything.

## Internal work stays internal

Only the documents in the table of `references/documents.md` are client
documents. Everything else (the agents' reports, checks, screenings,
intermediate rounds, review notes, a names proposal) is internal: it
stays Markdown in the agents' folders, is never rendered or opened for the
client, and feeds a client document or a slide. Before anything is shown,
the account director consolidates the internal work into **one** assured
recommendation, with checked facts only: two documents that contradict
each other are never shown, and a candidate the analyst ruled out never
reaches the client.

## The rendered draft

Before the deck's review, shoot one PNG per slide into the creative
director's folder (`<skill>` is this skill's folder):

```bash
bash "<skill>/scripts/shoot_deck.sh" \
  "<root>/docs/brace/brand/presentations/draft.html" \
  "<root>/docs/brace/agents/creative-director/<YYYY-MM-DD>-draft"
```

It uses a headless Chrome or Edge. Give the creative director the folder
of screenshots; **never read them yourself** (`SKILL.md`, `## Keeping the
conversation light`). Exit code 2 means no browser: brief the creative
director without screenshots; it writes "rendering not checked".

## The review

- `pass`: go on.
- `send back`: send each send-back to the agent it names (or fix the
  deck's Markdown yourself when it names `brand`, from the text of the
  send-back), **once**. A rendering send-back: once fixed, re-render, shoot
  only the slides concerned (`--only 3,7`) and give them back to the
  creative director for one short look. Then go on anyway, and tell the
  client at the meeting what was not fixed.
- `rendering not checked`: go on, and tell the client in one sentence at
  the meeting that the layout was not checked (no browser to render it).

## When an agent cannot write

The agent returns its report or document in its final message: save it
yourself as `docs/brace/agents/<agent>/<YYYY-MM-DD>-<subject>.md`. That is
the planned path where the platform does not let agents write, not an
error. Either way, check the file is on disk before relying on it.

## Closing the backstage, in this order

The notification means "everything is ready": it only goes once the
client space is rendered, so the order matters.

1. **Render every client deliverable**: each `read` client document into
   `docs/brace/brand/documents/` (`references/documents.md`), and the final
   deck (`references/presentation.md`, the file name). Internal work is
   never rendered.
2. **Update every tracking file**: the `SESSIONS.md` entry (what the team
   did), the brand files it feeds once validated, `brand_stage` for the
   next meeting (after the workshop's backstage:
   `brand_stage: presentation`), and the project's own tracking
   (`STATUS.md`, `JOURNAL.md`, as `track` does).
3. **Render the client space last** (`render.py space "<root>"`). On macOS,
   BRACE sends its notification then.
4. Save (`SKILL.md`, `## Saving`).
5. The end-of-session notice, **outside the agency** (`SKILL.md`, when the
   work is done): it is ready, `/clear` to carry on now or `/exit` until
   the appointment. No recap, no credits: the recap opens the next meeting.

Never a progress line between the goodbye and that notice.
