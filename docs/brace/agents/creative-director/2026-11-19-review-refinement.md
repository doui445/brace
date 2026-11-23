# Review: BRACE, refinement deck (2026-11-19)
Asked by: brand (Julie), before meeting 5 (Friday 20 November 2026, 17:00).

Rendering checked on the 13 screenshots in `2026-11-19-draft/`. Inputs read: deck Markdown, designer report and files, minutes 4.

## Verdicts
- Presentation: send back
- Both directions treated equally: send back
- Logo set in its font: pass on the files, to verify on the deck render (see 6)
- Favicon slides (5, 6): send back (legibility)
- Document, words: pass with notes

## Send-backs
1. Brand (slide 10, palette): the grid overflows the page. The second row of cards runs over the footer and out of the slide. The Pétrole card is shorter than the others, and the team note with the contrast figures (Isabelle) is not visible. Each swatch also shows two ratios ("7.38:1 / 2.85:1") that are not explained and contradict the note and the designer's report: ink 17.58 vs 15.6, grey 6.76 vs 6.0, pétrole 7.38 vs 6.5 on paper. A client outside the trade cannot read them. Fix the layout (two rows of four, or drop to fewer swatches), show only the ratio on the paper, and make the figures match the designer's.
2. Brand (slides 3, 4, 13, equal treatment): the two directions do not get the same words. Pointe en haut gets a negative ("se lit comme un accent circonflexe, dit moins la suite"). Pointe en bas gets the positive reading (arrow, "invite à lire"), and our moustache reserve is only in a small team note, with the "flèche" defence. The recommendation slide then tips one way ("plus compacte et plus sûre en moyenne taille"). The brief says we do not push a direction. Give each slide the same three things: what it says, what it costs, what we saw small. State the moustache reserve once, in the same place and tone for both, and drop "plus sûre".
3. Brand and designer (slides 7, 8, 9): the three versions are shown pointe en haut only. The files exist in both directions (sheet.png shows them). The client picks a direction and a version at the same meeting: show each version in both directions, side by side, so that neither direction is the default. Slide 5 and 6 should also be paired (or shown together on one slide) since the point is to compare.
4. Brand (slides 5, 6, favicon): the 16 px icons are shown at 16 px on a 1440 px slide, so nobody can judge them. Our decision turns on this (arrow or moustache). Add the designer's `favicon-16-zoom.png` (enlarged, up and down together), label the sizes (16, 32, 48) and the tabs (light, dark). The two strips leave the right two thirds of the slide empty. The dark tab is a cold grey that is not a brand colour.
5. Brand and designer (slide 12, applications): the mockups do not show the new brand at all. The README mock has a plain "BRACE" heading and no logo, the post has a black "B" avatar (the set-aside Écrit B), and the bottom halves of the laptop and the phone are empty. The designer made real applications (`applications/readme*.png`, `post*.png`) with the logo in both directions on light and dark: use them, one per direction. The slide's copy ("habillées de ta marque") is untrue as rendered. The post text also says "BRACE has a new face" as if published: the caption says "à publier", so keep the text conditional or clearly a draft.
6. Designer (slides 3, 7, 8, 9, to verify): on the slides, the logo letters look like a generic Helvetica or Arial (angled terminals on the C, wide R), while the slide 12 heading and the designer's own post PNG look like Schibsted Grotesk. The report says the letters are vectorised from Schibsted. Please confirm the SVGs are from the Schibsted outlines and that the deck is not rendering a fallback. If they are Schibsted, no change.
7. Brand (slide 1 and slide 2, consistency): "Ce que tu vois est le logo final" (slide 2) contradicts the closing slide, where the version and the direction are still open and Isabelle draws the whole family afterwards. Say "la forme définitive des lettres" or similar. Slide 2 and slide 13 also introduce a warmer ink (#1A1916) and two new tints for approval. The minutes only decided the paper and the dark. The meeting is meant to be short and to show nothing new: either present these as our proposal in one line, with a reason for each, or leave them out and keep the decided colours (and the two near-identical blacks, #1A1916 and #171614, need a one-line reason).

## Notes
- Slide 11 (typography) is nearly empty: no specimen of either font, a greyed heading, and "grotesque" and "police de code" unexplained for a client outside the trade. A short specimen line in each font would do the job. Not a send-back, but the slide says "tu les vois composées" and does not show them.
- Slide 2 uses a pure white card on a deeper beige page. Neither is a brand colour, and the right of the card is empty. Taste.
- Footer and meta greys look under 4.5:1 on the paper (small text). Check with `check_visual.py`; the contrast figures for the main texts are fine.
- Words: French, no em dash, no semicolon seen. "Graisse" is explained, "demi-gras", "pointe", "chevron" and "moustache" are not (moustache needs one line, since the client has not seen the reserve written down). Present tense is used for what exists (the lettering, the files), except the post text above.
- The designer left terminal, portfolio, charter and sheet undone: fine for this meeting, say so nowhere in the deck.
- Strengths: the cover and the recommendation slide are clean, the palette and the type are coherent with Rassemblé plus the Écrit paper, and the logo, in both directions, is well drawn.

Presentation verdict: send back, items 1 to 5 and 7 to brand, items 3, 5 and 6 also to designer.

## Second look (2026-11-19, screenshots in `2026-11-19-draft2/`)

Verdict: send back on the rendering, words fixed. No new round, the rest goes to the client.

Resolved:
- 1 (palette): six swatches on one row, no overflow, ratios on paper in the intro. The two ratios per card remain (known, renderer).
- 2 (equal treatment): slides 3 and 4 have the same structure, "Notre réserve" in both, "plus sûre" gone. Slide 13 neutral.
- 7: "Les lettres définitives" replaces "logo final"; the warm ink is a one-line proposal. Slide 2 and 13 consistent.
- Slide 10 type: terms explained. Still no specimen and a greyed heading (note).

Not resolved (rendering, to brand and designer):
- Slides 5, 6, 7, 8, 9, 11, 12: every image sits in a 400 px square tile that crops it. Slides 6 to 8 show only "RAC" with the brace cut at both sides, and the placeholder "Image d'exploration, non publiée" is printed across the letters. Slide 5 shows the 16 px zoom cut off at the right, and the sheet cropped and unreadable. Slide 11 (README) cuts the text at both edges. Slide 12 cuts the top of the logo. The right 40 % of each slide stays empty. The client cannot judge a version or a direction on these. Fix: show the images whole (contain, not cover), larger, without the exploration placeholder.
- Point 6 (fonts): on slides 3 and 4 the letters still look like Arial or Helvetica (angled C terminals, wide R), unlike the Schibsted text on slide 12. Not confirmed by the render: designer to check the deck does not use a fallback or older outlines.
- Slide 9 and 10: Pétrole clair swatch shows 2.28:1 on white, fine as a swatch, but explain it is for the dark only (the card says so).
