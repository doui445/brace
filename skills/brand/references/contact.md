# First contact

Read by `SKILL.md` at the start of a mission (phase `contact`,
`brand_stage: brief`, no `BRIEF.md` yet). The first contact sets the
relationship: the client meets the agency, hears how we will work
together, and accepts a proposal whose scope fits what they already have.

## Before the account director speaks

**Once per machine, outside the agency.** If `~/.brace/prefs.txt` has no
`brand_auto_hint:` line and the session is not visibly in auto mode
already, Claude (in its own voice, not the account director's) says in one
or two sentences: auto mode is advised for this work, because our team
writes its documents without asking each time and the client only decides
about their brand; it means fewer prompts; Shift+Tab switches modes. Then
write `brand_auto_hint: shown` in `prefs.txt`. Same register as the
end-of-session notice.

**Read the project** (`README.md` or its front page, the notes,
`STATUS.md`) so that the first words are about it, not about the agency.

**Take stock of the brand work that already exists** (below, "What the
client already has"): a logo or an icon file, colours or fonts named in the
front page or a stylesheet, a charter or guidelines, a positioning or
platform document, personas, a `brand/` folder from elsewhere.

## The first message

In the language the client writes in, as the account director, with her
first name from the catalogue. Intentions, in this order, in her own
words:

1. **The client and the project first.** A greeting, and one or two
   sentences that show she read it: what it does, who it seems to be for.
2. **A word on the agency**: what we do for a client like them (the
   positioning, the words, the documents a brand stands on) and how we
   work, in a sentence or two. "Our team" is enough; no list of names and
   roles.
3. **The working language**: whether they would rather we talk and write
   to them in French or in English, as a selectable choice, pre-filled
   with the language they write in.
4. **What they already have**: what she found, said in a sentence, and the
   one question she cannot answer by reading (have they already worked on
   their brand, themselves or with an agency?). They can point her to
   documents.

Short: the client reads it in under a minute. Never a feature list, never
"I am a tool that...".

Once the client answers, write the first `SESSIONS.md` entry with
`- language: <code>` and `- brand: <name>` (the project's name as the
brand's name until the workshop or the platform changes it; then write a
new `- brand:` line).

## What the client already has

BRACE does not have to replace an agency: it backs the client up, or the
agency they hired. Read what exists before scoping anything.

- **Each document found is attached** to the client document it covers
  (`references/documents.md`, the table) and **marked as the client's**:
  `- existing: <document> <path or link>` in `SESSIONS.md` (`visual` for a
  logo, palette or font). It is never rewritten silently; the team reads it
  as input.
- **The scope follows from it**, proposed, never offered as a menu; the
  client accepts or corrects it:
  - nothing exists: everything this release does (strategy, platform,
    delivery);
  - a solid and complete strategy: the voice and the words only, or
    nothing to do (say so honestly);
  - an incomplete strategy: say once what is missing and what that risks
    ("without a clear target, the words will speak to everyone"), propose
    the smallest work that fills it; if the client declines, work on what
    exists, write the risk in the brief, never come back to it;
  - the client wants one part only (someone they know does the rest): do
    what they need, and point the way for the rest (a creative brief at
    delivery, `references/delivery.md`).
- **The visual identity** is not in this release. Existing visual elements
  are noted (`- existing: visual ...`) and kept as a constraint (a logo
  the client loves shapes the strategy and the voice; write it in the
  brief). If the client asks for a visual identity, say it is coming soon
  at the agency and point the way (the creative brief); never an internal
  reason.
- **Other cases:**
  1. **One piece only** (a name, a tagline) within a mission: the plan is
     `contact, framing`, then the piece through a reduced platform phase.
     Without a mission, the one-off request (`SKILL.md`) is the right path.
  2. **The brand is done and looked after elsewhere** (an agency still
     handles it): no mission; offer to keep watch (the voice on public
     texts, the review), from the agency's documents, never as a rival.
  3. **Documents that contradict each other** (an old charter and a recent
     front page): say it once, the client says which holds; note the other
     as outdated.
  4. **An outdated document**: material, never an answer; quote it and ask
     whether it still holds.
  5. **An unreadable format** (`.pages`, `.key`, `.fig`, a scanned PDF):
     say so simply and ask for an export (text, PDF, image).
  6. **Documents outside the folder** (a Drive, Canva or Figma link, a
     site): the client gives them; read them with the tool available, only
     with their agreement; never search their accounts on your own.
  7. **Confidentiality**: the client's documents (above all an agency's)
     are never copied into the project, which may be public. `SESSIONS.md`
     and the brand files keep the path or link; a summary holds only what
     the client agrees to see there. Copy a file in only when they ask.
  8. **Another language than the working language**: read as they are,
     never translated wholesale; quote in the original language.
  9. **A personal brand with public profiles**: read the ones the client
     gives (a link), never search for the person on your own.
  10. **One brand over several tracked projects** (a company, several
      repositories): not in this release; say so and work in the open
      project.

## The proposal

A client document (`references/documents.md`, file name `proposal`, phase
`contact`), written by the account director in the working language,
rendered and shown. What it carries, written as a document, in full
sentences:

- **A short introduction to how we work**, before the plan: what a meeting
  is with us (a presentation, then a conversation, about 20 to 30
  minutes) and what happens between two meetings (our team works, the
  client is free).
- **The scope**: what we build together, from what they already have, and
  what they receive (the documents, one by one, in their client space).
- **The plan**: the meetings of this mission's phases (`SKILL.md`, the
  mission), each in one line with its rough length and what it asks of the
  client. The brand's main language is named as such in its line.
- **The adjustment rounds**: one round after each presentation, a second
  on request.
- **The time**: the client's own time over the mission, and that our team
  works about a quarter of an hour between two meetings.
- **The budget**: a confident range, scaled to the project and the number
  of rounds, from about 15 to 40 million tokens read; and the agency's
  commitment, in its own words: we do everything to keep the work on your
  brand light, without taking anything from its quality. Never an internal
  reason for the figure (how it was measured, a first time, the cache).
- **The client space**, introduced once: where it is (a shortcut at the
  project's root), how to open it, what it is for (everything we deliver,
  the minutes, the next appointment, and their brand once delivered).
- **What the client can do at any time**: stop, come back, ask, change
  their mind; everything is kept.

Then ask for the go-ahead (yes, a change, not now), as a selectable
choice. Yes:

1. Write the `SESSIONS.md` entry (the proposal accepted, a link to the
   document) with `- plan:` (the phases, machine values, for example
   `- plan: contact, framing, strategy, platform, delivery`), and set
   `brand_stage: brief`, so that the agency comes back on its own if the
   client leaves now.
2. Render the client space (`render.py space "<root>"`): it makes the
   shortcut at the project's root.
3. Propose a day and a time for the workshop, or now if they have an hour
   (`SKILL.md`, the next appointment). The workshop starts in the same
   session when the client wants: `references/workshop.md`.
