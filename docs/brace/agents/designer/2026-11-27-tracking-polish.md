# Fichiers : BRACE, espacement des lettres et finition (2026-11-27)
Demandé par : brand (Julie), réunion 7, avant la remise.

## Partie 1, l'espacement par taille
Règle (charte, section « La typographie », et `brand.css`) : Bricolage est fixé à opsz 24, la police ne se resserre plus seule, l'espacement prend le relais. Texte en minuscules : −0,02 em par doublement de la taille, compté depuis 17 px (= 0), arrondi à 0,005 em, plancher −0,04, plafond +0,02. Capitales : valeur du niveau + 0,06 em. Commit Mono : 0 (la chasse fixe). Clair sur sombre : +0,01 em (`.on-dark`).

| Niveau | Taille | Graisse | Interligne | Espacement |
|---|---|---|---|---|
| display | 56 | 500 | 1,1 | −0,035 |
| h1 | 44 | 500 | 1,15 | −0,025 |
| h2 | 32 | 500 | 1,2 | −0,02 |
| h3 | 26 | 500 | 1,25 | −0,01 |
| h4 | 20 | 500 | 1,3 | −0,005 |
| texte | 17 | 400 | 1,5 | 0 |
| petit | 14 | 400 | 1,5 | +0,005 |
| légende | 13 | 400 | 1,4 | +0,01 |
| capitales | 12 | 500 | 1,3 | +0,07 |
| code | 0,9 em | 400 | 1,5 | 0 |

Variables `--track-*`, `--size-*`, `--lead-*` dans `brand.css`, appliquées aux sélecteurs du moteur (doc.css) ; le texte passe enfin à 17 px (il était déclaré, pas appliqué). Planche, og et maquettes : mêmes valeurs en ligne.

**Le dessin du logo** : mesuré, il ne suivait pas la règle. Ses écarts (14,4 / 7,5 / 9,4 / 14,9 sur 100 de hauteur de lettre, avant 17,4 / 10,5 / 12,4 / 17,9) valaient environ 0 em, la valeur de Bricolage par défaut, pas le niveau le plus serré. Chaque écart est resserré de 3 (0,02 em). Pas plus : le plus étroit (R-A) doit rester à 1 px à 64 px de large (7,4), et les lettres sont plus épaisses que les titres. Pointe de l'accolade sur le sommet du A : vérifiée (centre de l'accolade 242,73, centre du A 242,73). Fichiers touchés : tous les logos, le nom seul, le symbole (accolade seule, plus courte), leurs viewBox (largeur −12). shapely n'est pas installé et je n'ai rien téléchargé : les contours ont été translatés exactement (`sources/warp_tracking.py`, copies d'avant dans `sources/before-tracking/`) ; `make_delivery_2.py` a les nouvelles positions (POS) pour un rerun avec shapely. PNG régénérés (`sources/run_regen.py`) : og, planches EN et FR, github-readme, avatar-in-lists, terminal.

## Partie 2, finition (impeccable : polish, typeset, audit ; aucun script d'installation lancé, ni PRODUCT.md ni DESIGN.md)
Corrigé dans nos fichiers :
1. Maquette README : tagline et en-tête GitHub étaient en Bricolage, or GitHub n'en charge aucune. Maintenant police de GitHub, tagline 16 px en gras, vrai « une-ligne » du README prévu, plus de barres grises, orphelin retiré. Haut de README prévu : `applications/readme-top.md` (picture clair/sombre, alt, largeur 320).
2. Terminal : police du terminal de l'utilisateur, plus Commit Mono.
3. Espace client, mobile : marges de 80 px conservées jusqu'à 320 px (colonne de 230 px, tableaux écrasés). Media query dans brand.css (marges 20 px, onglets défilants sans retour à la ligne, tableaux défilables, titre un niveau plus bas).
4. Graisses 600 sur kicker, h3 de bloc, th, noms de couleur : ramenées à 500 (graisses de la marque).
5. Étiquettes en capitales à +0,14 em : ramenées à +0,07 (même règle partout).
6. États manquants : survol et focus des liens, survol des onglets.
7. Orphelins et veuves : `text-wrap: balance` sur les titres, `pretty` sur le texte.
8. Contrastes : tout passe par les paires déclarées (gris 5,99 sur papier) ; le gris clair d'origine de doc.css (--ink-3) est déjà remplacé par brand.css.

Hors de nos fichiers (ne pas modifier, à faire dans le moteur) :
- `skills/brand/assets/doc.css` : `.page` garde `padding: 72px 80px` et `margin: 48px auto` sur mobile ; ajouter `@media (max-width: 720px)` (notre brand.css le compense, mais un document sans brand.css reste cassé). Il manque aussi l'ordre de liens : brand.css doit être lié après doc.css.
- `skills/brand/assets/doc.css` : `.space .block h3` met un petit titre en capitales espacées au-dessus de chaque bloc (le motif « eyebrow sur chaque section » qu'impeccable signale) ; remplacer par un titre en casse normale. Nous n'avons que réduit son espacement.
- `doc.css` : polices Fraunces et Inter déclarées en `@font-face` même avec une marque (inutiles) ; `font-display: block` du moteur contre `swap` de la marque.
- `doc.css` : pas de mode sombre pour l'espace client (non pris en charge, donc pas de rendu sombre).
- `doc.css` : onglets sans indice de défilement sur mobile (« Présentations » est coupé), il faudrait un fondu de bord ; états `:hover` des onglets absents (compensés).

## Images pour le client (dossier `docs/brace/agents/designer/files/delivery-2/`)
- Page d'accueil GitHub : `preview/before/github-readme-before.png` et `preview/after/github-readme-after.png`.
- Espace client : `preview/before/space-{home,documents,brand}-{1280,390}.png` et `preview/after/…` (même noms) ; page de prévisualisation : `preview/space.html`.
- Planche : `preview/before/brand-board-before.png`, `preview/after/brand-board-after.png` ; logo avant/après : `sources/before-tracking/logos/` et `logos/`.

## Checks
`check_visual.py brand files/delivery-2` : aucune alerte (code 0). Rendus regardés : logo avant/après à 640 px et nom seul à 64 px, README, planche, espace à 1280 et 390 px (iframe, Chrome headless ne descend pas sous 500).

## For the client
none
