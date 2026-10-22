# VOICE — BRACE

How the brand speaks. Public texts are checked against it.

## Voice first

Words BRACE would never say (French in brackets, as first written):

- "revolutionary" (révolutionnaire): no one-upping
- "magic, magical" (magique): no promise that cannot be checked
- "guaranteed", "100% safe" (garanti, 100 % sûr): it promises only what it
  has checked
- "easy!" with an exclamation mark (facile !): show it is simple, never
  shout it
- "boost", "10x" (boostez): growth jargon
- "sorry for the inconvenience" (désolé pour la gêne occasionnée): stock
  phrases
- unexplained jargon ("frontmatter", "hook", "remote") when talking to
  someone who is not a developer

Words it would use all the time, even overuse:

- "your project" (ton projet): the user is the hero
- "up to date" (à jour)
- "I check", "checked" (je vérifie, vérifié)
- "I suggest" (je te propose)
- "let's pick up" (on reprend), where you left off
- "to fill in" (à compléter): it does not guess
- "done" (c'est fait): the short report when a task is finished

Compared with the reference figures: BRACE takes Apple's plain words,
"you" and active voice, and Jarvis's calm reports and frank warnings. It
leaves out Apple's emphasis ("magical and revolutionary").

Short post introducing the brand (written in French first, approved
2026-10-21):

> Tu utilises l'IA sur ta machine, et à chaque session tu lui réexpliques
> ton projet.
>
> BRACE règle ça. C'est un plugin pour Claude Code et Antigravity qui tient
> la mémoire de ton projet dans des fichiers que tu peux lire : où tu en
> es, ce qui a été décidé, ce qui vient ensuite. Il les garde à jour, il te
> propose les bons outils quand c'est utile, et il te dit quand il ne sait
> pas.
>
> Tu reprends là où tu t'étais arrêté. Ton projet reste propre. Et tu peux
> suivre un résumé de tous tes projets sur une seule page.
>
> C'est gratuit et open source.

## Voice attributes

From the personality (Jarvis, Apple), the values and the core emotion
(serenity).

| Attribute | It is | It is not |
|---|---|---|
| **Calm** | composed; it announces even a problem without drama | cold, or alarmist |
| **Clear** | plain words, short sentences, the essential first | simplistic, or full of jargon |
| **Frank** | tells the truth, disagrees when needed, admits what it does not know | blunt, or preachy |
| **Warm, with a touch of wit** | close, human, a light joke now and then | over-familiar, jokey, or syrupy |

## Tone by context

One voice everywhere; only the tone shifts.

| Context | Tone | Example |
|---|---|---|
| **README, site** | composed and clear: the pain, then what BRACE does, then how to install it | "Your AI forgets your project between sessions. BRACE keeps its memory in files you can read." |
| **Plugin message during a session** | very short, factual, Jarvis-like: what is happening, and what you can do | "Your tracking files are 3 commits behind. Update them now?" |
| **Error** | calm, no apology, no drama: what happened, then how to fix it | "The portfolio could not be written: the folder is missing. Create it, or pick another one with /brace:config." |
| **Announcement, release notes** | sober, concrete: what changes for you, not a list of technical feats | "BRACE 1.1 adds brand: your project's voice and strategy, kept like the rest of its memory." |
| **Reply to a user** (issue, message) | warm and frank: thanks, the truth, what comes next | "Thanks, you're right: that's a bug. It's fixed in the next release." |

The plugin-message row is the rule for hook messages and fixed questions
(not listed as touchpoints, see `STRATEGY.md`); checked by hand at reviews
until they live in one file.

## Lexicon

| Say | Avoid | Why |
|---|---|---|
| **project memory**, **organised memory** | "memory" alone, "context" | what matters is the organisation |
| **your AI**, **AI agent** | "AI coding assistant" | the target goes beyond developers |
| **tracking files** (explained the first time) | "docs", "metadata" | concrete words |
| **portfolio**, "a summary of all your projects" | | |
| **you**, **your project** | "the user", "users" | the user is the hero |
| **I suggest**, **I recommend**, **I'd advise** | "you must", "you have to", "you should" when nothing requires it | it advises; you decide |
| (nothing) | "just", "simply", "obviously" | what is simple for it may not be for you |

When something is truly required (a prerequisite, a risk), it says so
plainly: that is frankness, not imposing.

Note: the current one-liner in the README and manifests says "project
memory for AI coding assistants", narrower than this lexicon. Replaced
2026-10-22 by the one under Tagline and boilerplate.

## Writing rules

- **Language**: English by default for anything public and lasting
  (README, site, descriptions, release notes), to reach wider. French when
  the audience is French-speaking (a post for the owner's circle, a French
  community). A text may carry both as separate blocks, one language then
  its translation below; never mixed inside a sentence or a paragraph.
- **The name**: always **BRACE**, in capitals. Skills are written as
  typed: `brace:brand`.
- **Capitals**: only at the start of headings and sentences ("Tone by
  context", not "Tone By Context").
- **Punctuation**: no long dash (the em dash); no exclamation mark (the
  voice is calm); in prose, no slash, no semicolon and no vertical bar
  (tables, code and paths excepted, or where truly needed); in French, a
  space before `:` `?` `!`.
- **Emoji**: none in the plugin, the README or the docs. On social
  networks, one at most, and only when it carries meaning.
- **Numbers**: digits for quantities ("3 commits behind"), and only real,
  checked numbers, never inflated or rounded up.

## Message pillars

1. **A project memory that stays true**: how BRACE remembers, keeps itself
   current, and does not guess. The core.
2. **AI without the hassle**: working with an agent on your machine
   without friction, without re-explaining, without wasting tokens. Advice
   and ways of working.
3. **Projects done right**: clean, complete, professional. Tracking,
   brand, soon design.
4. **Trust in AI**: what AI can and cannot do, honesty, privacy and its
   limits.

Off topic (it dilutes the brand, it is not forbidden):

- AI news for the buzz. News is welcome when it touches a pillar (a new
  memory feature: what it changes for your project).
- Generic productivity ("10 tips to be more efficient"). The subject is
  working with AI on your project.
- Aggressive comparison with competitors. A factual, honest comparison
  stays possible.

## Tagline and boilerplate

- **Tagline** (gives life): "Finally on the same page."
- **One-liner** (describes): "BRACE turns your AI into a real assistant
  for your projects: it remembers, keeps them clean and professional, and
  follows them all." Always shown with the platforms next to it ("for
  Claude Code and Antigravity"): BRACE works only with an AI on your
  machine, and the one-liner alone must not mislead someone on a web app.
  The skills are not named in it, so it does not age with each new skill.
- **Presentation text** (opens the README or the site):

  > Your AI forgets your project between sessions, and you explain it
  > again. Every time.
  >
  > BRACE turns your AI into a real assistant for your projects. It's a
  > free, open-source plugin for Claude Code and Antigravity. It keeps your
  > project's memory in files you can read: where you stand, what was
  > decided, what comes next. It keeps them up to date, suggests the right
  > tools when they help, and tells you when it doesn't know.
  >
  > Its skills share that memory. Track follows your projects, brand gives
  > them a voice and a strategy, and design is on its way.
  >
  > Pick up where you left off. Keep your project clean. Follow a summary
  > of all your projects on a single page.

- **Signature** (where the name is explained: an "About the name" line in
  the README, the site's footer): "Barely Remarkable, Admittedly Capable
  Engine". The comma before "Admittedly" is deliberate (`DECISIONS.md`,
  2026-10-04). Never the tagline, never the one-liner.
