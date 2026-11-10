# The client's tools for the look

Read at the first contact (`references/contact.md`, your tools) and by
whoever briefs the art director and the designer. Checked 2026-11-10:
this landscape moves fast, review it at each release. "Official" means
the vendor publishes the connector; "community" means a third party does,
untested by BRACE.

**What is offered depends on the host tool** (the columns below) and on
what is actually plugged in, read from the session's tools, never
assumed. Nothing ever blocks: the code mode works everywhere.

## By need

| Need | Tools | Claude Code | Antigravity |
|---|---|---|---|
| Finding inspiration | Pinterest, Milanote, Are.na | community (Pinterest, Milanote), none for Are.na | not checked |
| Imagining visuals (mood, logo sketches) | Canva, Recraft (draws vectors), Ideogram (good with letters), Kittl, Firefly, Gemini image models | Canva, Recraft, Kittl, Adobe: official; Gemini: community | Nano Banana (Google's image model) said to be built in, not checked; Canva, Recraft, Kittl by their connector address, not checked |
| Drawing the logo and supports | Figma, Penpot (free), Affinity (free, by Canva), Illustrator, Inkscape (free), Canva, Kittl | Figma: official, writes (a paid seat writes outside drafts); Penpot: official; Affinity: community bridge (official for the Claude desktop app); Illustrator: Adobe official connector; Inkscape: community | Figma: read only; others not checked |
| Photos and retouching | Affinity, Pixelmator Pro, Photoshop, GIMP (free), Photopea | Affinity, Photoshop as above; Pixelmator Pro, GIMP: community | not checked |
| Mockups | Canva, Kittl (ready mockups), Figma, Smartmockups, Placeit | Canva, Kittl, Figma: official; Smartmockups, Placeit: none | not checked |
| Creating a typeface | Glyphs (the client knows it), FontForge (free), Calligraphr (from handwriting), FontCrafter (free) | Glyphs: community; others: the client does, we direct | the client does, we direct |
| Turning an image into a vector | vtracer, potrace (free), Recraft | several local servers; Recraft official | not checked |
| None of these | the agency, in code (SVG, CSS) | always | always |

Cost: say it for each tool the client picks (credits, a subscription, a
paid seat), never a guessed figure.

## Fonts with clear licences

Google Fonts (OFL: download and host them), Fontshare (free, commercial
use included), Velvetyne (a free foundry), Font Squirrel (fonts checked
for commercial use). Font Meme is for inspiration and identifying a font
only: its fonts mix licences, many are personal use only. Calligraphr
turns handwriting into a font (free about 75 characters, paid 600 with
ligatures; check its terms for commercial use): good for a personal or
craft brand's signature, never a text face.

## The three modes

- **We drive your tool**: the agents call the connector; the source file
  stays in the client's account (Figma, Canva, Penpot, Kittl) or in
  `brand/sources/` (a local app).
- **You do it, we direct**: the designer writes the client clear steps in
  their tool; the client sends back an export.
- **In code**: SVG and CSS, made by the designer; clean, simpler.
