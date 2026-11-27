# Fichiers : BRACE, deux variantes du logo (2026-11-27)
Demandé par : brand (Julie), réunion 7, deuxième retouche en séance.

## Ce que j'ai changé
- **Pointe sur le A.** J'ai rééquilibré l'espacement, je n'ai pas décalé l'accolade. Raison : l'accolade doit rester à la largeur exacte du nom et symétrique (ses deux bouts tiennent le mot), et le sommet du A était 1,7 unité à droite du centre du mot. Les lettres de gauche (B, R) avaient des blancs plus larges que celles de droite. Positions (unités de la grille, avant puis après) : R 9,9 puis 9,7 ; A 19,3 puis 18,8 ; C 29,0 puis 28,7 ; E 38,2 puis 38,6. Sommet du A et pointe : écart de 0,1 unité (moins de 1 px à 420 px de large), mesuré sur le dessin, vu sur le rendu.
- **Écart B-R** resserré de 0,2 (bord à bord, 1,9 puis 1,7), à égalité avec C-E.
- **Cran en haut à gauche du R** : le haut de la panse du R était tracé 0,1 plus épais que le montant (et dépassait de 0,05). Panse remise à l'épaisseur du B, jambe d'une seule venue avec elle (une première tentative avec une jambe séparée faisait un cran au creux, écartée). Vérifié à très grand (900 px pour la lettre) : plus de marche. La jambe du R est donc 0,1 plus fine qu'avant (1,8), à peine visible.
- Le favicon, l'avatar et la petite marque restent le B (inchangés).

## Made (dossier `docs/brace/agents/designer/files/delivery-2/`)
- Variante a, B pétrole (celle de la séance, recalée) : `logos/logo-{color,dark,mono,mono-reversed}.svg`, `logo.svg`
- Variante b, A pétrole, B R C E encre : `logos/variant-a-petrol/logo-{color,dark}.svg` (même espacement, même accolade, même viewBox)
- Planche de comparaison : `check/variants.png` (1600 x 900 : grand sur papier, sur sombre, à taille README, "B pétrole" / "A pétrole")
- Mockup README, variante a seule : `applications/github-readme.png` ; régénérés avec le logo recalé : `og.png`, `applications/terminal.png`, `brand-board.png`, `brand-board-fr.png`, `symbol/brace-*.svg` (largeur de l'accolade : 46,4 unités au lieu de 46,0). Guidelines et brand board Markdown non touchés ; la planche PNG du dossier, elle, montre déjà le nouvel espacement (variante a).
- Générateurs : `sources/make_delivery_2.py` (POS, R, `logo_svg(..., petrol_letter)`), `sources/make_variants.py`, `sources/make_variants_board.py`

## Mon avis, honnêtement
- **B pétrole** : le B est la même lettre que l'avatar, donc le lien logo et icône est direct ; la couleur ouvre le mot. Mais il est à l'extrémité gauche, loin de la pointe : l'œil lit "B + RACE" et la pointe tombe sur du noir.
- **A pétrole** : le point de couleur tombe sous la pointe, l'accolade et le A forment un axe, la composition est plus stable et plus propre en symétrie. Le A est aussi la lettre la plus reconnaissable de la forme (triangle) : ça tient bien en petit, y compris à 300 px. Contre : le lien avec l'icône (un B pétrole) est plus lâche, il faudrait alors un favicon en B encre sur fond pétrole comme aujourd'hui (le B est déjà papier sur pétrole, donc rien à changer) mais la couleur de la lettre ne se répète plus d'un support à l'autre ; et le pétrole de l'A, fin à 16 px, ne jouerait que dans le logo complet.
- Ma lecture : l'A pétrole est le logo le plus équilibré, le B pétrole est la famille la plus cohérente avec l'icône. Si le client tient à l'unité logo et avatar, B ; s'il a vu le désalignement et veut un axe fort, A. Je ne tranche pas.

## Checks
`check_visual.py brand files/delivery-2` : aucune alerte. Rendus regardés : planche variants, mockup README, R à grande taille.

## Limites
- Lettres toujours en traits (outline stroke à faire pour un imprimeur), comme signalé ce matin.
- Variantes mono et mono inversé : une seule couleur, donc identiques pour a et b, pas de fichier à part.
- Si le client prend la variante b : `logos/variant-a-petrol/` à remonter en `logos/` et `logo.svg`, puis README, og et board à régénérer (une commande, `make_variants.py` avec `petrol_letter="A"`, à ajouter).

## For the client
none
