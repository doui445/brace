# Backstage

Read by `SKILL.md` when the team works (`brand_stage: backstage`). The
agents run in the background; the user is free meanwhile.

## The briefs

Each agent sees nothing of the conversation: give each one a complete
brief. Always: "asked by brand", what the result is for, the project root
(or "not tracked"), the paths of `BRIEF.md` and of the reports it should
read.

1. **`analyst`**, depth full for a first brand project (never asked).
   Subjects: **competitors** (with their messaging and tone, not only their
   features) and **audience** (what people actually say, in their exact
   words). Add **name availability** when the brief says a name is needed.
2. **`strategist`**, once the analyst has reported: two or three routes
   that really differ, and the internal creative brief. Give it the
   analyst's report paths and the user's tastes and rejections.
3. **`copywriter`**, once the routes are in: the words of each route
   (voice, tagline, one-liner, launch post, the text of each mockup, names
   when needed). Give it the routes, the creative brief, the list of
   mockups, and the language of the texts.
4. **`analyst`** again, a **references** mission: for each route, real
   brands that made a comparable choice. Quick depth.
5. **`brand`** assembles the presentation as `presentations/draft.html`
   (`references/presentation.md`).
6. **`creative-director`** reviews the routes, the words, the references
   and the rendered draft.

Run what does not depend on the previous step in parallel (the references
mission can start with the copywriter).

## The rendered draft

Before the review, render the draft to PDF in the creative director's
folder, with a headless Chrome or Edge when one is installed:

```bash
"<browser>" --headless=new --no-pdf-header-footer \
  --print-to-pdf="<root>/docs/brace/agents/creative-director/<YYYY-MM-DD>-draft.pdf" \
  "file://<root>/docs/brace/brand/presentations/draft.html"
```

On macOS the browser is
`/Applications/Google Chrome.app/Contents/MacOS/Google Chrome` or
`/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge`. No
browser: brief the creative director without a PDF; it writes "rendering
not checked".

## The review

- `pass`: go on.
- `send back`: send each send-back to the agent it names (or fix the
  presentation yourself when it names `brand`), **once**. Then show the
  presentation anyway, and say what was not fixed.

## Resuming

The session closed before the end: the next session starts by finishing
the work. Read `docs/brace/agents/`: a report already filed is reused,
never redone; only the missing steps run. Then "here is where we are".

## When an agent cannot write

The agent returns its report in its final message: save it yourself as
`docs/brace/agents/<agent>/<YYYY-MM-DD>-<subject>.md`. That is the planned
path where the platform does not let agents write, not an error.

## When it is ready

1. Write the final presentation (`references/presentation.md`, the file
   name). On macOS, BRACE sends its own notification when it is written.
2. Say it in the conversation: "We have made progress on your brand. Shall
   we look?"
3. Append an entry to `SESSIONS.md`. Say it is saved.
4. Set `brand_stage: presentation`.
