# Review: BRACE, check-up meeting (2026-11-17)
Asked by: brand (Julie), before the client sees it, tonight 19:00.

## Verdicts
- Deck "Le bilan de la marque" (7 slides): send back
  - Slides 01 to 03: pass on rendering, content fixes below
  - Slides 04 to 07: send back, broken rendering
- Document benchmark (analyst, client space): send back (small)

## Send-backs

1. **brand, slides 04, 05, 06, 07 (rendering, blocking).** Every `reco` slide is broken. The left column (title, lede, "À toi" or "Ensuite", team note) does not show at all. Each list item splits: the bold lead sits on a line, then the rest of the sentence collapses into a one-word-wide column starting with a stray ":" or ",", which runs through the footer and off the bottom of the page (04: "Une boussole" shows its sentence one word per line, the other three items are cut; 05: items 2 and 3 are lost; 06: items 3 and 4 are lost; 07: items 3 to 5 are lost). The client would see none of the 11 corrections nor the visual direction. Fix: the `reco` item style in `deck.css` (the bold lead in the `<li>`) or restructure the items as in `example.md` (plain sentences, no `**lead** : text`), then re-render, re-shoot and send slides 04 to 07 back to me. Check that the title, lede, "À toi" and the team notes appear.

2. **brand, slide 02, overclaims against the audit.**
   - Title "Personne n'est venu sur ta place." and the intro say it flatly. The audit and benchmark say "pas trouvé", not "n'existe pas", because the search was limited (no browser, no Reddit, partial Hacker News). Write "Nous n'avons trouvé personne sur ta place" and keep one short reserve line.
   - "plus encombré que jamais": the audit says "plus qu'avant", resting on one undated Hacker News comment. Use "plus qu'avant".
   - "Les mêmes, tous en croissance": BMAD is "stable" and Taskmaster has not moved. Write "Les mêmes, la plupart en croissance. BMAD stable, Taskmaster sans mise à jour depuis avril."
   - "Un nouveau, BrandingStudio.ai": the audit says it appeared in our survey, with a launch in March 2026 from a third-party directory. Write "Nouveau dans notre relevé".
   - The whole "Le 6 novembre" column ("Des kits de logo... qui crient des chiffres", "Recommencer de zéro, vérifier chaque résultat") is not in any of the three files I was given for 17 November. Brand must confirm it comes from the 6 November benchmark, otherwise remove it.

3. **brand, slide 03.**
   - Constance's note says personas are "la seule réserve de tout le bilan". The audit has others (limited search, "place libre" is a reading, indicator not measured as a zero). Say "la principale réserve".
   - "Le pilote a souvent déjà sa méthode": the audit has two voices, not "souvent". Write "Deux voix de novembre disent que le pilote a déjà sa méthode".
   - "des « just »": the audit finds one. Write "un « just »".

4. **brand, slide 04, indicator.** "2 étoiles le 17 novembre, aucune mention spontanée trouvée" drops the audit's reserve. Add "(recherche limitée à GitHub et Hacker News, ce n'est pas encore un zéro mesuré)".

5. **brand, slides 04 and 05, the client cannot see the audit.** "Les mots exacts sont dans l'audit" and "les lignes exactes de l'audit": the audit is presented in the deck, not delivered as a document. Replace with "Nous te montrons les mots exacts avant de les poser" or equivalent.

6. **brand, slide 06.** The title "Des règles qu'on peut tenir" covers only 2 of the 4 items (contact list and 1.2 release are not rules). Retitle on what it covers. Also soften "la règle tombe" for 1.2: the audit does not propose the change until Julie confirms 1.2 is released and checked, so say "quand la 1.2 sera sortie et vérifiée".

7. **brand, slide 07, readings presented as decisions.** The audit separates what the client asked from Constance's reading, and says the single accent "n'est pas une décision, c'est une direction qu'une piste peut tester". The slide states all five items alike. Mark the ones that are readings or directions to test (single accent like Things, no lock/shield/tick, the accolade, no terracotta). Also the lede ("le plus grand de tes voisins est déjà calme par absence", "il se confondra") is a reading drawn from README text, not from screens, which the audit itself says. Add "d'après leurs textes, nous n'avons pas encore vu les écrans".

8. **analyst, benchmark (client document).**
   - Taskmaster "à l'arrêt depuis environ six mois" is an inference from the last update date. Write "sans mise à jour depuis le 28 avril 2026".
   - Remove internal workflow lines the client should not read: "Deux ajustements de discours à retenir pour le bilan", "Pour la suite" (asking the next step of the team) and "Les citations de Hacker News passent par un outil de lecture". The honest limits (no rendered pages, third-party colours, quotes to reopen) can stay in plain words.
   - Table "Le look de chacun", Apple row: empty last cell. Fill it with "non vérifié".

## Notes
- Voice on the deck: agency "nous" and active verbs hold, no semicolons, no long dashes, no internal metadata. Notes from Ravi, Constance and Ben are short and signed. Ben's note ("ce qu'un pilote méfiant cherche avant d'installer") states as fact something no source in the audit supports. Write "ce que cherchent les voix de novembre qui parlent d'opacité" or drop it.
- The deck numbers 11 items across the three correction slides, the audit has 10 (correction 7 holds two rules). Fine as is, but do not say "dix" in speech without noting it.
- Cover and slides 01 to 03 render cleanly: no overflow, contrast fine. Slide 03 has a lot of empty space under the table, acceptable.
- Benchmark otherwise passes: figures dated, quotes verbatim with role and link, second-hand sources (Snyk, third-party colour guides, Anthropic figures) labelled as such. The audit quotes a 17 November voice ("kept forgetting different numbers...") that is not in the benchmark, so check it sits in the check-up file.
- Rendering of the benchmark itself not checked (only the Markdown was read).

## Second look (slides 02 to 07 re-shot)
Deck: pass. Slides 04 to 07 now render with title, lede, six-to-four numbered items, "À toi" or "Ensuite" band and notes, no overflow. Slides 02 and 03: overclaims fixed, 6 November column labelled as the benchmark, reserve on the limited search added. Slide 04: indicator reserve present. Slide 06 retitled and the 1.2 condition stated. Slide 07: readings marked as direction to test, "d'après leurs pages" added. One taste note, not a send-back: "Reddit nous est fermé" on slide 02 is a tooling detail, "notre recherche a ses limites" would be enough. The analyst send-back on the benchmark (item 8) is not covered by this second look and stays open until the analyst confirms.
