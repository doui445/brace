# Fichiers : BRACE, tour de retouches (2026-11-20)
Demandé par : brand (Julie), pour la suite de l'affinage, lundi 23 novembre 2026 à 17 h.

Dossier : `docs/brace/agents/designer/files/retouches/` (`raffinement/` intact). Générateurs : `files/make_retouches.py` (SVG), `files/make_retouches_pages.py` (HTML puis PNG par Chrome headless). Tous les PNG font 1200 x 675, entiers, aucun recadrage. Encre de ces fichiers : #171614 (encre unique recommandée par Olivier).

## Polices (paquets officiels, google/fonts, SIL OFL 1.1, OFL.txt à côté de chaque police)
Noms de famille lus dans les fichiers : Schibsted Grotesk 1.100 ; Bricolage Grotesque 1.001 (axes opsz 12-96, wdth 75-100, wght 200-800 ; fixé à opsz 24, wdth 100 pour le logo, soit la taille optique basse, plus calme) ; Atkinson Hyperlegible Next 2.001 (wght 200-800, copyright "The Atkinson Hyperlegible Next Project Authors", dépôt googlefonts) ; Figtree 2.002 (wght 300-900). Commit Mono copié du dossier précédent.
- `retouches/fonts/{schibsted-grotesk,bricolage-grotesque,atkinson-hyperlegible-next,figtree,commit-mono}/` : fichiers de police et licences.
- `retouches/polices/specimen-A-schibsted-grotesk.png` : A, témoin, dessin actuel ; accolade sous le nom, pointe vers le mot à gauche, vers le bas à droite ; exemple README (titre et texte, étalon).
- `retouches/polices/specimen-B-bricolage-grotesque.png` : B ; ordre inversé (pointe vers le bas à gauche) ; exemple demandé (BRACE, phrase en 500, 28 px, interligne 1,2, et les cinq capitales à 600, +3 %).
- `retouches/polices/specimen-C-atkinson-hyperlegible-next.png` : C ; ordre pointe vers le mot d'abord ; exemple demandé (paragraphe 17 px, interligne 1,5, ligne de code Commit Mono à 92 %, lettres R G C 1 I l 0 O Q).
- `retouches/polices/specimen-D-figtree.png` : D ; ordre pointe vers le bas d'abord ; exemple demandé (mot-symbole en 700 grand format avec l'accolade, deux sens).
- `retouches/polices/comparaison-polices.png` : les quatre côte à côte, deux logos par colonne (ordre alterné d'une colonne à l'autre), phrase, texte, lettres confondables.
- Sources : `retouches/polices/{A-schibsted-grotesk,B-bricolage-grotesque,C-atkinson-hyperlegible-next,D-figtree}/` : `logo-tip-up.svg`, `logo-tip-down.svg` (600, +3 %), `logo-700-tip-*.svg`, `word.svg`, `word-700.svg`. Lettres vectorisées depuis chaque police (fontTools, harfbuzz, crénage), accolade dont le trait est la graisse du E de la police.

## L'accolade sous le nom, lettrage actuel (Schibsted 600, +3 %)
Largeur de l'accolade = largeur du mot ; air entre le mot et l'encre la plus proche = 2 x trait (la pointe en bas a ses bouts ronds près du mot, la pointe vers le mot a sa pointe près du mot ; le dessin de la pointe ajoute une légère marge optique).
- `retouches/sous-le-nom/logo-tip-up.svg`, `logo-dark-tip-up.svg`, `logo-mono-tip-up.svg`, `logo-mono-reversed-tip-up.svg` : pointe vers le mot (bouts descendants), couleur, fond sombre, une couleur claire, une couleur inversée. Chacun a son PNG du même nom (`.png`, 1200 x 675, logo seul sur son fond).
- Les mêmes quatre en `-tip-down` : pointe vers le bas (bouts qui remontent vers le mot), SVG et PNG.
- `retouches/sous-le-nom/sous-le-nom-planche.png` : les huit sur une planche (pointe vers le bas en haut, vers le mot en bas).
- Racine du dossier : `retouches/logo.svg`, `logo-dark.svg`, `logo-mono.svg`, `logo-mono-reversed.svg` (pointe vers le mot) et leurs `-tip-down` : copies pour le contrôle et l'outil, aucun sens n'est choisi.

## Icône
- `retouches/icones/favicon-pair.svg` : paire `{ }`, pastille pétrole, grille de 16, trait 2.
- `retouches/icones/favicon-pair-inverted.svg` : variante `} {` (montrée une fois).
- `retouches/icones/favicon-horizontal-tip-up.svg`, `favicon-horizontal-tip-down.svg` : les favicons horizontaux actuels (copie de `raffinement/`).
- `retouches/icones/planche-icones.png` : les quatre à 16, 32, 48 px sur onglet clair, barre claire, onglet sombre, GitHub sombre.
- `retouches/icones/zoom-16px.png` : les quatre rendus réellement à 16 px puis agrandis 11 fois sans lissage, sur onglet clair et sombre.
- Lecture : à 16 px la paire se lit tout de suite comme deux accolades, les pointes tiennent sur un pixel plein. J'ai passé le trait à 2 sur 16 (Olivier disait 1,75) : à 1,75 les pointes se noyaient et la paire se lisait comme des parenthèses `( )`. La variante `} {` se lit comme un noeud papillon ou un sablier à 16 px, comme prévu. Les horizontales ressemblent à un chevron.
- Limite connue, ancienne : la pastille pétrole sur onglet sombre (#35363A) se distingue peu de son fond (le glyphe clair dedans reste à 6,54:1). Plus petite correction possible : un liseré papier de 1 px autour de la pastille pour les fonds sombres. Non fait, à décider.

## Les trois autres idées (lettrage actuel)
Chacune en couleur, sombre, une couleur claire, une couleur inversée (SVG), et testée à 180, 100 et 64 px de large.
- `retouches/idees/1-encadre-logo.svg` (+ `-dark`, `-mono`, `-mono-reversed`) et `1-encadre.png`.
- `retouches/idees/2-a-accolade-logo.svg` (+ variantes) et `2-a-accolade.png` : le A est la lettre de la police sans sa barre (la barre est un contour séparé), la petite accolade (pointe en haut, trait demi-épais, bouts arrondis posés contre les jambes) est dessinée à la main. Elle se lit à partir de 120 px de large du logo ; à 64 px elle disparaît. Elle peut aussi évoquer une moustache de près : même réserve que pour l'accolade horizontale.
- `retouches/idees/3-typographique-logo.svg` (+ variantes) et `3-typographique.png` : accolades de la police (Schibsted 600) en pétrole.
- `retouches/idees/planche-idees.png` : les trois sur une planche, même gabarit (papier, sombre, petites tailles, une phrase).

## brand.css
`retouches/brand.css` : encre documentée en deux options (#171614 recommandée, #171614 = `--dark` ; ou #1A1916), l'interrupteur est la seule ligne marquée "ink" ; surface sombre `--dark-surface: #211F1C` ajoutée ; règle écrite "aucun texte plus clair que #5F5B53 sur papier" ; contrastes notés et recalculés (identiques à ceux d'Olivier : 16,03 / 14,11 ; 13,56 / 6,39 / 7,20 sur la surface sombre ; #8A857B 3,25 refusé) ; les quatre polices déclarées avec @font-face hébergés, Schibsted par défaut, changement documenté en une ligne.

## Checks
`python3 skills/brand/scripts/check_visual.py brand docs/brace/agents/designer/files/retouches` : aucun problème (code 0). Tous les PNG vérifiés à 1200 x 675 et regardés un par un (sauf les sept PNG de `sous-le-nom/` autres que `logo-dark-tip-down.png` et la planche, générés par le même gabarit).

## Pour le client
Aucun geste : tout est en code. À trancher lundi : police (A à D), sens de l'accolade, encre (#171614 ou #1A1916), version du logo, idée éventuelle.
