# The look: the craft, and `VISUAL.md`

Read by `SKILL.md` whenever the agency makes or checks something visual,
and at the delivery to write `VISUAL.md`. The art director and the
designer carry these rules in their own instructions; this file is for
the account director, who briefs them and talks to the client.

## The craft

- **Logo**: simple, memorable, timeless, works in one colour, holds at
  16 px, right for the brand. Tests: redraw it from memory; see it at
  16 px; see it in black and white. The family: main logo (colour, one
  colour, reversed), secondary, small mark (often a monogram), symbol,
  favicon; graphic elements (patterns, illustrations) when the route has
  them. A sketch from an image generator is redrawn as a clean vector,
  never traced and shipped.
- **Colour**: one main colour, one or two accents, neutrals, with lighter
  and darker tints. Spread roughly 60 / 30 / 10 (main and neutrals,
  secondary, accent): a guideline, not a law; on a screen the accent stays
  rare. Harmonies (complementary, split complementary, analogous,
  monochrome, triad, tetrad), saturation and lightness. Contrast: 4.5:1
  for text, 3:1 for large text and interface elements (WCAG). Screen codes
  (HEX, RGB) always; print codes (CMYK, Pantone) when the brand is
  printed.
- **Explaining a colour to the client**: by what it does for this brand
  (its link to the platform, how it stands apart from the competitors,
  its fit with the category and the audience, its use). Never by a
  universal symbolism ("blue means trust"): it does not hold, and it
  depends on the culture.
- **Type**: two or three typefaces at most, a pair built on contrast,
  chosen to serve the route's adjective (serif classic, sans modern,
  script human, display strong, mono technical); a clear hierarchy; lines
  of 45 to 75 characters; line height 1.4 to 1.6 for text, 1.1 to 1.3 for
  titles.
- **Fonts**: an OFL licence, or one that clearly allows commercial use;
  else suggest buying one (a budget question). Hosted with the brand when
  the licence allows it (no third-party font server: privacy, and it
  works offline), else linked. Sources with clear licences:
  `references/tools.md`.
- **Images**: third-party references are text and a link, never a copied
  image. Generated images are for exploring, never delivered, kept in
  `brand/sources/` (out of git).

## The checks

`scripts/check_visual.py brand "<folder>"` lists what fails: `logo.svg`
missing, an SVG unsafe or without `viewBox`, a font without its licence
next to it, a text pair declared in `brand.css` below its contrast, and
for `favicon.svg` what will not read at 16 px (a stroke or a shape under
one pixel once scaled, text, more than twelve shapes, a colour under 3:1
against its own background or a light tab). `check_visual.py contrast
<fg> <bg>` gives one ratio. Lou judges the rest on the rendered slides:
the twelve criteria, and the `favicon` slide (the symbol at 16, 32 and
48 px, on light and dark tabs) for the final say on legibility.

## `VISUAL.md`

In `docs/brace/brand/`, written at the delivery once the client
validated the look; the visual counterpart of `VOICE.md`, read by any
later work before making anything visual (`brace:design` included).
Sections, headings from the catalogue when they exist, else plain
English:

1. **Palette and use**: each colour, its codes, its role, the 60 / 30 / 10
   spread, the text pairs and their contrast.
2. **Type**: the fonts, their roles, the hierarchy, where they come from
   and their licence.
3. **Logo rules**: the versions and when to use each, clear space,
   minimum sizes, what never to do.
4. **Images**: the style (photo, illustration, icons), if the route has
   one.
5. **Files**: the inventory: each file in `brand/` and in
   `brand/sources/`, or the link to a source file in an online tool, with
   the tool, the date and the licence.
