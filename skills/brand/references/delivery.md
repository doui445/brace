# Delivery

Read by `SKILL.md` at the phase `delivery` (`brand_stage: delivery`). The
agency hands over the brand. A handover meeting holds only because there
is something to hand over: our team prepared it in the backstage
(`references/backstage.md`).

## The handover deck

One deck, by sections (the account director builds it; the creative
director reviews it):

1. **Your brand at a glance**: purpose, positioning, emotion, tagline,
   one-liner.
2. **In place**: the project's front page before and after, with the
   tagline and the one-liner where they would sit (`compare` and
   `context` slides).
3. **The transition** (a rebrand): what changes, in what order, who does
   what (the `transition` document is in the client space for the
   detail).
4. **The announcement** (a rebrand): the text, ready to publish when the
   client wants.
5. **The test kit**: the option the client chose at the platform meeting,
   ready (below).
6. **For whoever does the visual** (when the scope leaves it to someone
   else): what the creative brief holds.
7. *Your identity in place*: reserved for the visual identity (a later
   release).

The deck ends on the decisions to take.

## The meeting

The five parts of `SKILL.md` (a meeting):

1. **Welcome and a short recap.**
2. **The presentation**: open the handover deck, say how to read it.
   Nothing restated in the console.
3. **The discussion and the decisions**, as selectable choices: approve
   the tagline and the one-liner in place (never name the file), start the
   test, and for a rebrand the folder (`references/rebrand.md`, the folder,
   last).
4. **The close of the mission** (below), then goodbye.

## The test with real people

The client chose the option at the platform meeting (it takes their
time). Explain it there in full sentences, never as labelled fragments:
what it is (the two or three finalists, taglines, positioning statements
or names, shown to **5 to 10 people** from the target with three
questions: which one makes you most want to know more and why, what does
it promise in your view, explain in one sentence what this does), what it
takes (an evening: the agency prepares the page or the form, the client
shares it, the agency reads the answers), and what it brings (knowing
whether the promise is understood before publishing it, from the people
it is for).

The options:

1. **The real test** (the agency's recommendation): the strategist's
   `test-plan` document, the page or the form ready to share. It is the
   only one that validates.
2. **Checked personas**: the agency writes personas from its research, the
   client adjusts them, the agency confronts the finalists with them. They
   point the way, they validate nothing. The document says so once, in its
   opening lines (for example: these personas come from our research and
   have not met real people yet, hence the test we suggest), never as tags
   in the text; write "hypothesis, not tested" in
   `docs/brace/brand/DECISIONS.md`.
3. **Not now**: write "not tested yet" in `DECISIONS.md`.

Write any real result in `DECISIONS.md`. Never simulate a result, never
present a guess as a test. Mention the interview guide again
(`references/workshop.md`) if the client has not run it.

## The tagline and the one-liner

Shown in place in the deck. On the client's yes, put them at the top of
the project's front page (the `README.md` of a code repository; for
another project, its main page or the file that plays that role; none,
then nothing), keeping everything else as it is. Save (`SKILL.md`,
`## Saving`): with `auto_publish: yes`, commit and push without a
question.

## The creative brief

When the scope left the visual identity to someone else (the client, a
designer they know, an agency), the strategist's `creative-brief` is a
read document in the client space: what the brand must convey, its
words, the references, what to avoid. Tell the client it is the document
to hand to whoever does the visual.

## Closing the mission

1. The last minutes, filed in the client space (`SKILL.md`, closing a
   meeting), never opened.
2. Set `brand_stage: done` and `brand_reviewed` to today.
3. Render the client space a last time (`render.py space "<root>"`): its
   "My brand" tab becomes the home, the mission's tabs stay as an archive,
   and the shortcut at the project's root is removed. Then save.
4. Open the client space once and say, in her words, that the agency's
   work is done, the space is theirs, and what the brand files are for from
   now on: the voice is checked on the touchpoints, and the agency comes
   back for a review in six months or at the next big event
   (`references/revision.md`). The portfolio page links the space from the
   project's card.
5. For a rebrand whose folder is renamed: that is the very last action
   (`references/rebrand.md`).
