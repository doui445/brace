# VOICE — BRACE

How the brand speaks. Public texts are checked against it.

Updated 2026-11-07 from the validated [editorial guide](documents/2026-11-07-editorial-guide.html).

## Voice first

Who speaks: a discreet, competent assistant with a touch of wit. Jarvis for the behaviour, Apple for the feel. It shows gestures (a question asked, a "to fill in", a decision written down), not adjectives.

Words BRACE would never say (French in brackets):

- "honest" (honnête), to describe itself: an adjective, not a proof. Show the gesture. "Check before claiming" stays as an internal compass; the public text shows the act.
- "magic, magical" (magique): never to promise. Allowed once to deny: "It's not magic."
- "guaranteed", "100% safe" (garanti, 100 % sûr): it promises only what it has checked
- "revolutionary", "boost", "10x" (révolutionnaire, boostez): one-upping, growth jargon
- "easy!" with an exclamation mark (facile !): show it is simple, never shout it
- "sorry for the inconvenience" (désolé pour la gêne occasionnée): stock phrases
- "just", "simply", "obviously" (juste, simplement, évidemment): what is simple for it may not be for you
- "you should", "you must" (tu devrais, tu dois) when nothing requires it: it advises, you decide
- unexplained jargon ("frontmatter", "hook", "remote") when talking to someone who is not a developer. The first use of a technical term is explained in a few words.

Words it would use all the time, even overuse:

- "it asks" (il demande): "it only asks what it can't know"
- "it's written down" (c'est écrit): "what you decide is written down"
- "you decide" (tu décides): the last word is yours
- "I check", "checked" (je vérifie, vérifié): only when it really checked
- "to fill in" (à compléter): what it does not know stays marked, never filled by guesswork
- "your project" (ton projet): you are the hero, it is the guide
- "up to date", "let's pick up" (à jour, on reprend): where you left off
- "done" (c'est fait): the short report when a task is finished

The test before publishing: "Would Jarvis or Apple say this?" Jarvis reports calmly and warns frankly. Apple uses plain words in the active voice, without emphasis.

## Gestures, not promises

The rule that changes most from the earlier voice. BRACE does not say it is reliable, it shows what it does.

| Avoid | Write |
|---|---|
| "BRACE is honest with you." | "When it doesn't know, it asks." |
| "You can trust it." | "Everything is written in files you can read." |
| "Nothing is ever forgotten." | "What you note is written down." |
| "It understands your projects." | "It reads your files every session." |

A gesture can be checked, an adjective cannot. A sentence with no gesture behind it does not pass.

## Voice attributes

From the personality (Jarvis, Apple), the values and the core emotion (serenity).

| Attribute | It is | It is not |
|---|---|---|
| **Calm** | composed; it announces even a problem without drama | cold, or alarmist |
| **Clear** | plain words, short sentences, the essential first | simplistic, or full of jargon |
| **Frank** | says what it thinks, disagrees when needed, admits what it does not know | blunt, or preachy |
| **Warm, with a touch of wit** | close, human, a light joke now and then | over-familiar, jokey, or syrupy |

## Tone by context

One voice everywhere; only the tone shifts.

| Context | Tone | Example |
|---|---|---|
| **README, site** | composed and clear: the situation, what BRACE does, then how to install it | "Monday morning. You paste in the same instructions as last week, and you are not sure which of your notes is still true." (FR: "Lundi matin. Tu recolles les mêmes consignes que la semaine dernière, et tu ne sais plus laquelle de tes notes est encore vraie.") |
| **Plugin message during a session** | very short, factual, Jarvis-like: what is happening, and what you can do | "Your tracking files are 3 commits behind. Update them now?" (FR: "Tes fichiers de suivi ont 3 commits de retard. Je les mets à jour ?") |
| **A question from BRACE** | one question at a time, with a proposal to confirm | "I suggest "calm and direct" for your voice. Keep it, or change it?" (FR: "Je te propose « calme et direct » pour ta voix. Tu la gardes, ou tu la changes ?") |
| **Disagreement** | once, calmly, with the reason, then you decide | "I would not publish this yet: the page says the feature is ready and it is not. Your call." (FR: "Je ne publierais pas encore : la page annonce une fonction qui n'est pas prête. C'est toi qui décides.") |
| **What it does not know** | it says so and marks the gap | "I don't know your launch date. Marked "to fill in"." (FR: "Je ne connais pas ta date de lancement. Marqué « à compléter ».") |
| **Error** | calm, no apology, no drama: what happened, then how to fix it | "The portfolio could not be written: the folder is missing. Create it, or pick another one with /brace:config." (FR: "Le portfolio n'a pas pu être écrit : le dossier n'existe pas. Crée-le, ou choisis-en un autre avec /brace:config.") |
| **Announcement, release notes** | sober, concrete: what changes for you, not technical feats | "BRACE 1.1 adds brand: your project's voice and strategy, written down like the rest of its memory." |
| **Reply to a user** (issue, message) | warm and frank: thanks, the truth, what comes next | "Thanks, you're right: that's a bug. It's fixed in the next release." (FR: "Merci, tu as raison : c'est un bug. Il est corrigé dans la prochaine version.") |

The plugin-message row is the rule for hook messages and fixed questions (not listed as touchpoints, see `STRATEGY.md`); checked by hand at reviews.

## Lexicon

| Say | Avoid | Why |
|---|---|---|
| **your project**, **your projects** (tes projets) | "the user", "users" | you are the hero |
| **your AI agent** (ton agent IA) | "AI coding assistant" | the target goes beyond developers |
| **tracking files** (fichiers de suivi), explained the first time | "docs", "metadata" | concrete words |
| **project memory** (mémoire du projet) | "memory" alone, "context" | memory is a mechanism (the project itself, written in its files), never the promise. Not used in a title or a hook |
| **I suggest**, **I recommend** (je te propose, je recommande) | "you must", "you have to" | it advises; you decide |
| **it asks**, **it writes**, **you decide** (il demande, il écrit, tu décides) | "it understands", "it knows", "it guesses" | BRACE guesses nothing |
| **a plugin for your AI agent** (un plugin pour ton agent IA) | "an app", "a service" | an AI agent on your machine is required |

When something is truly required (a prerequisite, a risk), it says so plainly: that is frankness, not authority.

## Writing rules

- **Language**: English first for anything public and lasting (README, site, descriptions, release notes). French when the audience is French-speaking. A text may carry both as two separate blocks, the language then its translation; never mixed inside a sentence or a paragraph.
- **French is not a calque**: do not translate word for word, look for the expression that exists. That is why "Finally on the same page." becomes "Enfin sur la même longueur d'onde."
- **The name**: always **BRACE**, in capitals. Skills are written as typed: `brace:brand`.
- **Capitals**: only at the start of headings and sentences ("Tone by context", not "Tone By Context").
- **Punctuation**: no long dash (the em dash); no exclamation mark (the voice is calm); in prose, no slash, no semicolon and no vertical bar (tables, code and paths excepted); in French, a space before `:` and `?`.
- **Emoji**: none in the plugin, the README or the docs. On social networks, one at most, and only when it carries meaning.
- **Numbers**: digits for quantities ("3 commits behind"), and only real, checked numbers, never inflated or rounded up.
- **Sentences**: short. The essential first. One message per sentence.
- **Questions**: never in a burst. One question at a time, with a proposal.
- **"You"**: in French texts BRACE uses "tu". In English, "you".

## What the brand talks about

Four subjects, and what is outside them.

1. **An agent you agree with**: it asks instead of guessing, it writes down what you decide, you can reread everything. The core.
2. **AI without the hassle**: working with an agent on your machine without re-explaining every session. Advice and ways of working.
3. **Projects done right**: clean, complete, professional. Tracking and brand.
4. **Trust in AI**: what it can and cannot do, with proofs rather than promises.

Off topic (it dilutes the brand, it is not forbidden):

- AI news for the buzz. News is welcome when it touches one of the subjects.
- Generic productivity ("10 tips").
- Aggressive comparison with other tools. A factual comparison stays possible.

## What is not said yet

Three subjects stay out of public texts until delivered and checked. This is a rule, not an oversight.

| Subject | What is written for now |
|---|---|
| Upcoming design and other upcoming skills | nothing. No "soon", no "on its way" |
| Privacy | the limit validated at meeting 3, word for word, nothing more: "BRACE sends nothing itself. What your agent reads goes to the model provider, as with any agent. What goes to GitHub or to your Reminders is your call." (FR: "BRACE n'envoie rien lui-même. Ce que ton agent lit part chez le fournisseur du modèle, comme pour tout agent. Ce qui va sur GitHub ou dans tes Rappels, c'est toi qui le décides.") And what can be checked: the files are in your project, you can read, correct or delete them |
| Taking over documents made by you or by an agency | nothing. The idea is noted for later |

Other limits that stay:

- No promise about other AI agents.
- Antigravity is always said the same way: "for Claude Code, also works with Antigravity" (FR: "pour Claude Code, fonctionne aussi avec Antigravity"). Never on par with Claude Code, never first.
- The word "agency" does not appear in public texts: it suggests humans.
- A public text always says an AI agent is needed on your machine.

## Tagline and boilerplate

The line, the supporting line and the description are three distinct things. The line gives life, the supporting line shows the gestures, the description explains.

| | English | French |
|---|---|---|
| **Tagline** (gives life) | **Finally on the same page.** | **Enfin sur la même longueur d'onde.** |
| **Supporting line** (shows) | **It asks. It writes it down. You decide.** | **Il demande. Il écrit. Tu décides.** |
| **Description** (explains) | BRACE turns your AI agent into an assistant you can agree with: it reads your project first, asks only what it can't know, writes down what you decide in files you can read, and keeps all your projects on one page. A free plugin for Claude Code, it also works with Antigravity. | BRACE fait de ton agent IA un assistant avec qui tu es d'accord : il lit d'abord ton projet, ne demande que ce qu'il ne peut pas savoir, écrit ce que tu décides dans des fichiers que tu peux relire, et garde tous tes projets sur une seule page. Un plugin libre et gratuit pour Claude Code, il fonctionne aussi avec Antigravity. |

**How to read the tagline.** "Finally on the same page." first means "agreed, aligned". It keeps its other senses: on the same page of the project, and one page for all your projects. In French, "longueur d'onde" keeps the agreement and loses the play on the single page. The description catches it, saying "sur une seule page".

**The colour of the texts.** "Projects true to you" (des projets qui te ressemblent) is the colour of the texts, never the promise. It says what you get at the end, always with what makes it true: the project is made of what you decided, written where you can check it.

| Good | Not good |
|---|---|
| "In the end, a project made of what you decided." (FR: "Au bout, un projet fait de ce que tu as décidé.") | "BRACE knows you." (FR: "BRACE te connaît.") |
| "Projects true to you, because you decided them." (FR: "Des projets qui te ressemblent, parce que tu les as décidés.") | "Tailor-made projects, effortlessly." (FR: "Des projets sur mesure, sans effort.") |

In English the colour is said "true to you", never "looks like you" or "look like you". The trap: "look" says appearance, so design, which is not delivered. "True to you" is checked against what is written: the project is faithful to what you decided.

**Signature.** "Barely Remarkable, Admittedly Capable Engine" explains the name, and only the name: an "About the name" line, the site's footer. Never the tagline, never the description. The comma before "Admittedly" is deliberate (`DECISIONS.md`, 2026-10-04).

## Before publishing: five questions

1. Does the text show a gesture, or only an adjective?
2. Can each claim be checked? If not, it is removed or marked "to fill in".
3. Does it talk about upcoming design, taking over documents, or privacy beyond the validated limit? Then it does not go out.
4. Does it say an AI agent is needed on the machine?
5. Would Jarvis or Apple say it?

## Earlier texts (before the rebrand)

These two texts predate the rebrand. They were approved under the earlier voice and are kept as a record, not as models: both are being superseded by the tagline and description above.

Short post introducing the brand (written in French first, approved 2026-10-21):

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

Presentation text (opened the README or the site):

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
