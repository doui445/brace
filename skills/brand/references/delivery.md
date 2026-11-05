# Delivery

Read by `SKILL.md` at meeting 4 (`brand_stage: delivery`). The agency
hands over the brand.

## The meeting

1. Open it as a meeting: the brand in five lines (purpose, positioning,
   emotion, tagline, one-liner), then the **client space**
   (`docs/brace/brand/index.html`): every document and deck of the
   mission, by meeting. It is theirs from now on.
2. The test with real people (below).
3. The tagline and the one-liner (below).
4. Close the mission (below).

## The test with real people

Explain it before asking anything, in three short parts:

- **What it is**: show the two or three finalists (taglines, positioning
  statements, names) to **5 to 10 people** from the target, with three
  questions: "Which one makes you most want to know more, and why?",
  "What does it promise, in your view?", "Explain to me in one sentence
  what this does."
- **What it takes**: an evening; the agency prepares the page or the form,
  the client shares it (people close to them, their target, or a paid
  panel), the agency reads the answers.
- **What it brings**: knowing whether the promise is understood before
  publishing it, from the people it is for.

Then the options, each for what it is:

1. **The real test** (the agency's recommendation): the strategist's
   `test-plan` document, the page or the form ready to share. It is the
   only one that validates.
2. **Checked personas**: the agency writes personas from its research, the
   client adjusts them, the agency confronts the finalists with them. They
   point the way, they validate nothing: write "hypothesis, not tested" in
   `docs/brace/brand/DECISIONS.md`.
3. **Not now**: write "not tested yet" in `DECISIONS.md`.

Write any real result in `DECISIONS.md`. Never simulate a result, never
present a guess as a test. Offer the interview guide again
(`references/workshop.md`) if the client has not run it.

## The tagline and the one-liner

Show them in place (the project's front page as it would read), and ask:
"Do you approve the tagline and the one-liner?" Never name the file.

### How it is applied

Yes: put them at the top of the project's front page (the `README.md` of
a code repository; for another project, its main page or the file that
plays that role; none, then nothing), keeping everything else as it is.
Save (`SKILL.md`, `## Saving`): with `auto_publish: yes`, commit and push
without a question.

## Closing the mission

1. The last minutes, in `SESSIONS.md`, rendered.
2. Set `brand_stage: done` and `brand_reviewed` to today.
3. Render the client space a last time
   (`render.py space "<root>"`), then save.
4. Say what the brand files are for from now on: the voice is checked on
   the touchpoints, and the agency comes back for a review in six months or
   at the next big event (`references/revision.md`).
