# Fichiers : BRACE, logo final (2026-11-27)
Demandé par : brand (Julie), réunion 7, remise en séance.

## Made (dossier `docs/brace/agents/designer/files/delivery-2/`)
- Logo principal = variante b, le A en pétrole (B R C E en encre ; sur sombre, A pétrole clair, lettres papier) : `logo.svg`, `logos/logo-{color,dark}.svg`. Mono et mono inversé : mêmes fichiers qu'avant (une couleur), régénérés en contours.
- Historique, le B en pétrole : `logos/variant-b-petrol/logo-{color,dark}.svg` (l'ancien dossier `variant-a-petrol/` est supprimé : son contenu est devenu le principal).
- Nouveau, nom seul sans accolade, B en pétrole, A en encre : `logos/wordmark/wordmark-{color,dark,mono,mono-reversed}.svg`. Taille minimale 64 px de large (18 mm), vide d'une demi-hauteur de lettre.
- Contours remplis : lettres et accolade ne sont plus des traits (plus aucun `stroke`, plus de clipPath, base coupée en géométrie), dans les logos, le nom seul, `symbol/`, `small-mark/` et `favicon.svg`. Fait avec shapely (aplatissement fin des courbes : chemins en segments très courts, pas en courbes de Bézier). Écart au rendu avec les traits : 325 pixels sur 2,5 millions, de l'anticrénelage, regardé à l'œil et au calque.
- Régénérés : `applications/github-readme.png`, `applications/terminal.png`, `og.png`, `brand-board.png`, `brand-board-fr.png` (hauteur de la planche passée de 3000 à 3400 px max, nouvelle rangée « nom seul » avec la règle de couleur).
- Documents : `2026-11-27-guidelines.md` et `2026-11-27-brand-board.md` mis à jour (couleurs du nom, pointe sur le A, contrastes, règle avec ou sans accolade, ne pas faire, tailles, fichiers). `BRIEF.md` complété (deux choix du client).
- Générateurs : `sources/make_delivery_2.py` (outline, wordmark, planche), `sources/make_variants.py` (relance tout, avec Python + shapely). `make_variants_board.py` est périmé (il pointe l'ancien dossier).

## Checks
`check_visual.py brand files/delivery-2` : aucune alerte (sortie vide, code 0). Rendus regardés : mockup README, terminal, planche, nom seul à 96, 72, 56 et 400 px (lisible à 64, un peu serré à 56).

## Remarques
- Les icônes PNG (favicon, avatar) n'ont pas été refaites : le B est inchangé, les SVG outlinés sont identiques au pixel près.
- Les rendus HTML de `docs/brace/brand/documents/` ne sont pas régénérés (hors de mon dossier) : à faire par le skill.
- Le B pétrole du nom seul et l'icône forment la même couleur ; avec l'accolade, la couleur de la lettre (A) diffère de celle de l'icône : écrit dans la charte.

## For the client
none

## Retouches après la revue de Lou
- Planche FR : les libellés de la tuile d'avatar sont traduits (nouveau `applications/avatar-in-lists-fr.png`, utilisé par `brand-board-fr.png` ; la version anglaise est inchangée).
- Règle des tailles (charte et planche) : « Le logo complet à partir de 96 pixels de large, le nom seul de 64 à 96 pixels, le B (petite marque) en dessous de 64 pixels. »
- Rôle du pétrole : accolade, A du logo, B du nom seul (tableau de la charte, texte et image de la planche).
- Tableau des polices : parenthèse sur les lettres du logo retirée.
- check_visual : aucune alerte.
