# Fichiers : BRACE, logo redessiné (2026-11-27)
Demandé par : brand (Julie), réunion 7, tour de retouches pendant la remise.

## Ce que j'ai dessiné et pourquoi
- **Le nom est dessiné, plus composé.** Les cinq lettres sont en traits, dans les mêmes unités que le B de l'icône (grille de 16, hauteur de lettre 9,8 unités, mise à l'échelle x10,2 : montant 2, courbes 1,8, bouts nets, jonctions arrondies). Le B du logo est le B de l'avatar. R : la panse du haut du B, dont la pointe (le creux du milieu) se prolonge en jambe. A : sommet arrondi, comme le bout de l'accolade, barre basse. C : courbe ouverte, montant vertical comme celui du B. E : trois bras droits. L'accolade a la même épaisseur que les courbes (18 pour une hauteur de lettre de 100). Elle couvre exactement la largeur du nom, pointe en haut, comme validé.
- **Couleurs** : B pétrole #1D5E66 (pétrole clair #6FB7BE sur sombre), R A C E encre #171614 (papier sur sombre), accolade pétrole. Mono et mono inversé : une seule couleur.
- **Espacement** réglé à l'œil sur rendus de 900 px à 72 px.
- **Seuil du B seul** : inchangé, 96 px. Le dessin reste lisible à 72 px, je garde 96 par prudence (à toi de resserrer si tu veux).
- **Écarts à signaler** : (1) pour le 16 px et le recentrage, les panses du B sont 5 % plus étroites (bord droit à 12,0 au lieu de 12,4) : c'est la seule retouche du dessin du B, voir ci-dessous. (2) Le montant ne dépasse plus de 0,1 unité en haut et en bas (le petit cran visible en grand dans l'ancien favicon). (3) Le viewBox du logo est plus court en bas (plus de marge sous la ligne de base : 3 unités).

## Recentrage du B (grille de 16, mesuré sur rendu 1600 px)
| | avant | après |
|---|---|---|
| étendue horizontale | 4,00 à 12,40 | 4,00 à 12,00 |
| centre de la boîte | 8,20 (+0,20 à droite) | 8,00 |
| centre de masse horizontal | 7,78 | 7,59 |
| verticale | 3,1 à 12,9, centre 8,00 | idem |
Honnêtement : par la boîte, l'ancien B penchait de 0,2 à droite ; par la masse, c'est le montant (lourd) qui tire à gauche. Le client voit l'étendue (la panse du bas dépasse), j'ai donc centré la boîte et resserré la panse plutôt que de décaler le B : le montant reste calé sur les pixels 4 et 5 (un décalage de 0,2 l'aurait rendu flou à 16 px). Vérifié à 16, 32, 48 et 500 px, en carré, rond et carré arrondi (planche `check/icon-check.png`, avant et après, avec axes). Le B ne se rapproche pas du bord du rond (distance du coin haut gauche au centre : 6,3 pour un rayon de 8).

## Made (tout dans `docs/brace/agents/designer/files/delivery-2/`, `delivery/` intact)
- Logos : `logo.svg`, `logos/logo-{color,dark,mono,mono-reversed}.svg`
- Symbole : `symbol/brace-{color,dark,mono,mono-reversed}.svg` (accolade à la largeur du nouveau nom)
- Petite marque : `small-mark/b-{color,dark,mono,square}.svg`
- Icône d'onglet : `favicon.svg`, `favicon.ico`, `favicon-{16,32,48,512}.png`, `apple-touch-icon.png`; avatar `avatar-500.png`; `og.png`
- Applications : `applications/{github-readme,avatar-in-lists,terminal}.png`
- Planches : `brand-board.png` (EN), `brand-board-fr.png`; contrôle : `check/icon-check.png`
- `brand.css` (commentaire mis à jour : Bricolage n'est plus dans le logo), `fonts/` (copie)
- Générateurs : `sources/make_delivery_2.py` (dessin des lettres inclus), `sources/make_check_icon.py`
- Documents : `docs/brace/agents/designer/2026-11-27-guidelines.md` et `2026-11-27-brand-board.md` (thème `files/delivery-2/brand.css`, meeting 7, mêmes en-têtes). Mis à jour : description et construction du logo, couleurs du nom, contrastes du B, tailles minimales, interdits, typographie, fichiers.

## Checks
`check_visual.py brand files/delivery-2` : aucune alerte, code 0. Rendus de contrôle regardés (logo de 900 à 72 px sur papier et sombre, planche complète, icône avant/après). Pas de tiret long.

## Limites
- Les lettres sont des traits (`stroke`) avec un `clipPath` pour la ligne de base, pas des contours : fonctionne dans les navigateurs et GitHub (img), mais un outil de découpe ou Canva peut vouloir « outline stroke ». Je n'ai pas converti en contours.
- Rendu des deux Markdown par `render.py` non lancé ici ; le chemin du thème est celui des documents précédents à adapter au dossier final.
- Le C et le A sont mes propres dessins dans le trait du B : à regarder par Olivier avant de graver.

## For the client
Remplacer le logo du README, `avatar-500.png` (profil GitHub) et `og.png` (social preview) par ceux de `delivery-2/` ; je ne les pose pas (mode code).
