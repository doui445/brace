# Review: BRACE rebrand, delivery documents (2026-11-07)
Asked by: brand (Alice), backstage before meeting 4. Reviewer: Emma.

Read against FOUNDATIONS, STRATEGY ("What we say in public"), VOICE (rules and five questions), DECISIONS, minutes 3, `delivery.md`, my BRIEF. Rendering not checked (Markdown sources only).

## Verdicts
- Document names-check-4 (Bruno): pass, with one fix to make before the client reads it (small)
- Document test-plan (Chloé): send back
- Document transition (Chloé): send back
- Document announcement (David): send back

## Consistency across the four
- Tagline: same everywhere ("Finally on the same page." / "Enfin sur la même longueur d'onde."). Pass.
- Description: verbatim from VOICE in the announcement (release note, README news, EN and FR). Transition and test plan reuse it (the test plan shortens it with an ellipsis in a table, see below). Pass.
- Antigravity always second, an AI agent needed on the machine: held in the announcement (all three texts), the transition (README line 99, topics) and the test plan. Pass.
- Nothing about design to come, skills to come, agency, "honnête", privacy beyond the limit: clean in all four (the only "honnête" and "agence" are in David's "what this does not say" list). No em dash, no exclamation mark, no simulated result. Pass.
- Version: David assumes 1.1 (supported by STATUS "next_milestone: BRACE 1.1" and the VOICE announcement example). Chloé leaves the number "à compléter". Not aligned, see send-back 7.
- "Formerly project-tracker": the announcement and the transition contradict each other, see send-back 5.

## Send-backs

Test plan (Chloé / David)
1. **David**: the French text of the "d'avant" presentation (tagline FR, description FR) is the blocker of the recommended option, and it is left "À compléter (David)" in a document delivered at meeting 4. Write it now as a proposal, so the client validates it at the meeting instead of discovering a blocker. Faithful translation of the 22 October texts, no new wording.
2. **Chloé**: the end of the form collects a way to contact people, but the page promises "Tes réponses restent sans ton nom" and never says where the contact goes. The repo is public. Add one sentence in the page text, word for word: the contact is kept apart from the answers, read only by the client, and never written in the repo.
3. **Chloé**: question 4 exists in three wordings (the questions table, screen 5, the EN/FR table: "Tu le reconnais encore ?"). Keep one FR wording and its EN, identical everywhere. Also, the table gives the "nouvelle" description cut with "…": say that the page carries the full text of the charter, so nobody tests a truncated version.

Transition (Chloé / David)
4. **Chloé**: section 2 writes "Ravi (Bruno aujourd'hui) vérifie" and the whole document says new first names enter last, after the mission. Write "Bruno" (the old name) everywhere before delivery; the new names only appear in section 4. Also, Bruno's check is now done (names-check-4, minor doubt, nothing blocking): replace "Bruno vérifie ... seule condition" by its outcome and a link to the note.
5. **Chloé, with David**: the transition says the README keeps one "Formerly project-tracker." (line 20), alone. David's README news paragraph says "formerly project-tracker" again. The rule is one mention, README only (STRATEGY, last row). Decide on the line 20 only and make David drop it from the news paragraph (see 9).
6. **Chloé**: the README and manifests get a lot of text changes ("le texte exact, David l'écrit") but the client sees none of it, whereas `delivery.md` asks to show the tagline and one-liner in place. Ask David for the README top as it would read (opening situation, tagline, description, supporting line, the rewritten requirement line) and the marketplace line 6, then link it from the transition. Without it the client approves a table of intentions.
7. **Chloé**: "le numéro de la prochaine version : à compléter" while the announcement writes 1.1. Write "1.1 (hypothèse, à confirmer à la sortie)" in both documents, same words.

Announcement (David)
8. **David**: the check table points to `docs/brace/brand/archive/` as support for "il l'archive d'abord", but this folder does not exist in the repo. The claim has no checkable support today. Either point to what exists (the spec of `brace:brand` and the CHANGELOG entry), or drop the row until the archive exists. Do not leave a "à confirmer" in a table titled "Ce que tu peux vérifier".
9. **David**: remove "formerly project-tracker / anciennement project-tracker" from the README news paragraph (EN and FR), see 5. Also "now has a voice of its own" / "a maintenant sa propre voix" is an adjective, not a gesture (question 1 of the five). Open the paragraph with what `brace:brand` does.
10. **David**: unexplained jargon for a reader who is not a developer: "commits", "pushes" (release note, EN and FR). Say it once in plain words ("never saves to GitHub / ne publie jamais sur GitHub sans ta confirmation") as VOICE asks for first uses. The same page already says "publie".

## Notes (not send-backs)
- Names-check-4, fix before the client reads (Bruno): the summary says "article arXiv" and gives the long form of the acronym, but no row links the article; the only link is the repo. Add the source or remove the expansion. Also relabel "Clair (lecture mince)" for the community marketplaces as "non concluant": a wiki with "aucune mention" is not a reading. The global verdict "doute mineur" is acceptable because the limits (Antigravity, VS Code, domains, trademarks) are listed honestly. A glossary half-line for npm, PyPI, Homebrew, cask would help a reader outside the trade.
- Transition reads like the repo (key names `brand.team.*`, line numbers, `gh repo edit`). Acceptable for an owner who built the repo, but section 4 "Où ils vivent" would be better as a closing annex so the client's words come first.
- Test plan comparison changes several things at once (tagline FR, supporting line, description, promise). It tests a package, not a single variable. The plan says so implicitly; one sentence would make it explicit.
- The announcement is only publishable after the merge of `feat/brand` and the release: the transition says so, the announcement could say it in its "À compléter".
- "BRACE 1.1: Enfin sur..." in French: capital after the colon is fine for a title.

## Checked and clean
No invented figure or quote; no reference without source in the test plan and the announcement; all thresholds in the test plan set before any answer; no result simulated; the three options of `delivery.md` (real test, checked personas, not now) are all present with the recommendation; no open question without a proposal.
