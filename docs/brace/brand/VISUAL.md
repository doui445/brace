# VISUAL — BRACE

L'identité visuelle validée à la remise du 27 novembre 2026. À lire avant de
faire quoi que ce soit de visuel pour BRACE. Le détail est dans la
[charte graphique](documents/06-delivery/2026-11-27-guidelines.html), les
fichiers dans `brand/` à la racine du projet.

## Palette and use

| Nom | HEX | Rôle |
|---|---|---|
| Papier | `#F4F1EA` | Le fond. Pas de blanc pur. |
| Papier 2 | `#EAE5DA` | Blocs de code, liste de fichiers, rares surfaces |
| Encre | `#171614` | Le texte, le nom, le fond sombre : le seul noir |
| Gris | `#5F5B53` | Texte secondaire sur papier (5,99) |
| Pétrole | `#1D5E66` | L'accolade, le A du logo, le B du nom seul, un lien, un bouton, un bandeau (6,54 sur papier) |
| Pétrole clair | `#6FB7BE` | Le pétrole sur fond sombre (7,92 sur l'encre) |
| Surface sombre | `#211F1C` | Cartes et blocs sur fond sombre |
| Gris sur sombre | `#A5A199` | Texte secondaire sur sombre (7,02) |
| Texte sur sombre | `#ECE9E2` | Texte courant sur sombre (14,91) |

Teintes : pétrole foncé `#123E44` (survol), pétrole moyen `#3E8A92` (traits,
jamais du texte), voile `#DCEBEA`, filet `#DAD5CA` (ne porte pas de texte).
Répartition : environ 60 % papier et encre, 30 % gris et surfaces, 10 % au
plus de pétrole, en pratique moins de 5 % d'une page. Codes écran
seulement ; CMJN et Pantone à fixer le jour d'un support imprimé.

## Type

- **Bricolage Grotesque** (opsz fixé à 24) : titres en 500, texte en 400,
  jamais 600. **Commit Mono** 400 : commandes, fichiers, code, rien
  d'autre. Les deux sous OFL 1.1, hébergées dans `brand/fonts/`.
- **Espacement des lettres**, une valeur par niveau, d'une seule règle :
  −0,02 em par doublement de la taille depuis 17 px (= 0), arrondi à
  0,005, plancher −0,04, plafond +0,02 ; capitales + 0,06 ; code 0 ; clair
  sur sombre + 0,01.

| Niveau | Taille | Interligne | Espacement |
|---|---|---|---|
| Display | 56 px | 1,1 | −0,035 em |
| H1 | 44 px | 1,15 | −0,025 em |
| H2 | 32 px | 1,2 | −0,02 em |
| H3 | 26 px | 1,25 | −0,01 em |
| H4 | 20 px | 1,3 | −0,005 em |
| Texte | 17 px | 1,5 | 0 |
| Petit | 14 px | 1,5 | +0,005 em |
| Légende | 13 px | 1,4 | +0,01 em |
| Capitales | 12 px | 1,3 | +0,07 em |
| Code | 0,9 em | 1,5 | 0 |

Les valeurs sont dans `brand/brand.css` (`--track-*`, `--size-*`,
`--lead-*`). Lignes de 45 à 75 caractères. Sur GitHub, la police est celle
de GitHub.

## Logo rules

- **Le logo** : l'accolade au-dessus du nom, pointe vers le haut, sur le
  sommet du A. Les cinq lettres sont dessinées dans le trait du B de
  l'icône, en formes pleines. Le A en pétrole, B R C E à l'encre.
  Espacement du dessin : −0,02 em, une exception voulue à la règle,
  bornée par l'écart R-A.
- **Le nom seul** (sans accolade) : le B en pétrole, le A à l'encre.
  Seulement là où le logo ne tient pas, jamais sur la même page que lui.
- **La petite marque** : le B dessiné à la main, recentré le 27 novembre ;
  icône d'onglet et avatar.
- **Tailles** : logo complet à partir de 96 px (25 mm), nom seul de 64 à
  96 px (18 mm), le B en dessous ; symbole seul 24 px.
- **Espace de protection** : une hauteur de lettre autour du logo, une
  demi-hauteur autour du nom seul.
- **Jamais** : changer les couleurs, une autre lettre en pétrole sous
  l'accolade, la version couleur sur fond sombre, déformer, retaper le
  nom dans une police, l'accolade sous le nom, ombre ou dégradé.

## Images

Pas de photo ni d'illustration dans la marque pour l'instant. Des
maquettes en situation (README, terminal, avatar) dans
`brand/sources/applications/`. Aucune image générée.

## Files

Tout est en code, fait par Isabelle (designer) le 27 novembre 2026.

| Fichier | Contenu |
|---|---|
| `brand/logo.svg`, `brand/logos/` | Le logo : couleur, sombre, une couleur, inversé |
| `brand/logos/wordmark/` | Le nom seul, mêmes déclinaisons |
| `brand/small-mark/`, `brand/symbol/` | Le B, l'accolade seule |
| `brand/favicon.*`, `brand/favicon-*.png`, `brand/apple-touch-icon.png` | L'icône d'onglet |
| `brand/avatar-500.png`, `brand/og.png` | Avatar et image de partage |
| `brand/brand.css` | Couleurs, polices, niveaux et espacements en variables |
| `brand/fonts/` | Bricolage Grotesque, Commit Mono, avec leur `OFL.txt` (OFL 1.1) |
| `brand/brand-board.png`, `brand/brand-board-fr.png` | La planche de marque |
| `brand/sources/` | Hors git : générateurs (`make_delivery_2.py`, demande shapely), maquettes, contrôles, aperçus, l'ancien logo B pétrole (historique) |
