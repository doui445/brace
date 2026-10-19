# Voice, and voice drift

Read by `SKILL.md` at the voice step (`brand_stage: voice`), and whenever a
public text is checked against the voice.

## Writing the voice (`VOICE.md`)

Start with the exercise, before any rule:

1. Five words the brand would never say.
2. Five words it would overuse.
3. One short post that introduces the brand.

Then, one section at a time, each approved before it is written:

- **Voice attributes**: derived from the personality and the core emotion
  in `FOUNDATIONS.md`, never invented apart from them.
- **Tone by context**: how the same voice sounds in a README, an error
  message, an announcement, a reply to a user.
- **Lexicon**: words used, words avoided.
- **Writing rules**: capitals, punctuation, emoji, numbers.
- **Message pillars**: the few subjects the brand speaks about. A subject
  outside the pillars is off topic.
- **Tagline and boilerplate**: the tagline gives life, the one-liner
  describes; keep them distinct. Add a short presentation text.

When the voice is written, set `brand_stage: name` if a name is needed
(`references/name.md`), otherwise `brand_stage: test`.

## Voice drift

Triggered by the hook line "… is a brand touchpoint", or when the user
shows a public text from outside the repo (a bio, a post).

- Compare the text with `VOICE.md`.
- No drift: say nothing.
- A drift: flag it in one line, with a proposed rewrite. The user keeps
  theirs or takes yours.
- A drift the user keeps is a decision: extend `VOICE.md` to cover it and
  add an entry to `docs/brace/brand/DECISIONS.md`.
- Never check code, tracking files or private notes.
