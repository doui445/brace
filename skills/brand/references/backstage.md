# Backstage

Read by `SKILL.md` whenever the team works between two meetings. The
agents run in the background; the client is free meanwhile. Everything
was settled at the meeting that just ended (minutes, appointment): no
question to the client while the team works.

## The three backstages

| After | Stage while it runs | The team prepares | For |
|---|---|---|---|
| the workshop | `brand_stage: backstage` | benchmark, personas, routes, their words and references, the deck | meeting 2 |
| the recommendation | `adjustments` | brand platform, editorial guide, manifesto | meeting 3 |
| the platform | `delivery` | the test plan, the client space complete | meeting 4 |

Which backstage is due is read from the stage and from the files already
in `docs/brace/agents/` and `docs/brace/brand/documents/`: a document
already there is reused, never redone.

## The briefs

Each agent sees nothing of the conversation: give each one a complete
brief (`SKILL.md`, `## Working with the team`), with the client
documents it owes, their meeting number, and its first name and role
from the catalogue.

**After the workshop:**

1. **`analyst`**, depth full for a first brand project (never asked).
   Subjects: **competitors** (with their messaging and tone, not only their
   features) and **audience** (what people actually say, in their exact
   words). Add **name availability** when the brief says a name is needed.
   It also writes the client document `benchmark`.
2. **`strategist`**, once the analyst has reported: two or three routes
   that really differ, the internal creative brief, and the client
   documents `personas` and `routes`. Give it the analyst's report paths
   and the client's tastes and rejections.
3. **`copywriter`**, once the routes are in: the words of each route
   (voice, tagline, one-liner, launch post, the text of each mockup, names
   when needed). Give it the routes, the creative brief, the list of
   mockups, and the brand's language for the texts.
4. **`analyst`** again, a **references** mission: for each route, real
   brands that made a comparable choice. Quick depth. It can start with
   the copywriter.
5. **`brand`** writes the deck's Markdown and renders it as
   `presentations/draft.html` (`references/presentation.md`).
6. **`creative-director`** reviews the routes, the words, the references,
   the documents and the screenshots of the draft.

**After the recommendation:** `strategist` writes `platform` from the
chosen route; `copywriter` writes `editorial-guide` and `manifesto`; in
parallel. Then `creative-director` reviews the three.

**After the platform:** `strategist` writes `test-plan`
(`references/delivery.md`, the test). Then `creative-director` reviews it.

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
- `rendering not checked`: go on, and tell the client in one line at the
  meeting that the layout was not checked (no browser to render it).

## When an agent cannot write

The agent returns its report or document in its final message: save it
yourself as `docs/brace/agents/<agent>/<YYYY-MM-DD>-<subject>.md`. That is
the planned path where the platform does not let agents write, not an
error.

## Closing the backstage, in this order

The notification means "everything is ready": it only goes once the
client space is rendered, so the order matters.

1. **Render every deliverable**: each validated-for-review document into
   `docs/brace/brand/documents/` (`references/documents.md`), and the final
   deck when there is one (`references/presentation.md`, the file name).
2. **Update every tracking file**: the `SESSIONS.md` entry (what the team
   did), the brand files it feeds once validated, `brand_stage` for the
   next meeting (after the workshop: `brand_stage: presentation`), and the
   project's own tracking (`STATUS.md`, `JOURNAL.md`, as `track` does).
3. **Render the client space last**
   (`render.py space "<root>"`). On macOS, BRACE sends its notification
   then.
4. Save (`SKILL.md`, `## Saving`).
5. Tell the client: "It is ready. Type `/clear` and we carry on now, or
   `/exit` and we meet again <the appointment>."
