---
title: Charte graphique
author: Isabelle
role: designer
lang: fr
doc: guidelines
phase: delivery
meeting: 7
date: 2026-11-27
layout: landscape
theme: ../../../../brand/brand.css
---

Ce document dit comment BRACE se montre : son logo, ses couleurs, ses polices, et où chacun se trouve. Il se lit en une demi-heure et se garde sous la main pour tout ce que tu feras ensuite (une page, un message, une affiche). Cette version du 27 novembre remplace celle du 23 : le nom du logo est désormais dessiné à la main, dans le trait du B de l'icône, et le A, sous la pointe de l'accolade, porte la couleur. Les fichiers dont il parle seront dans le dossier `brand/` du projet une fois que tu auras donné ton accord à la remise. Les images de chaque support sont dans la [planche de marque](2026-11-27-brand-board.html).

## Les fondations en bref

BRACE donne à chacun toute la puissance de l'IA sur sa machine, sans les galères. Il le fait par trois gestes : il lit ce que le projet dit déjà, il demande ce qu'il ne peut pas savoir, et il note ce qui est décidé. C'est toi qui tranches. Le détail est dans la [plateforme de marque](../2026-11-07-platform.html).

Le caractère est celui de Jarvis pour le comportement et d'Apple pour la sensation : simple, sobre, sans friction. L'émotion à laisser est la sérénité, appuyée sur la confiance. L'identité visuelle en tire quatre règles :

- beaucoup d'air, peu de couleurs, une seule famille de caractères pour les titres et le texte (le nom du logo est, lui, dessiné).
- un seul accent, le pétrole, qui reste rare.
- l'accolade, qui tient ensemble le nom et le projet, comme BRACE tient ensemble tes fichiers de suivi.
- jamais les clichés de l'IA (dégradés violets, étincelles, robots, néons) ni le look hacker.

## Le logo

Le logo, c'est l'accolade posée au-dessus du nom BRACE, pointe vers le haut. Le nom n'est plus composé dans une police : ses cinq lettres sont dessinées, dans le trait du B de l'icône d'onglet et de l'avatar (le B dessiné à la main, dont le creux au milieu reprend la pointe de l'accolade). Logo et icône sont ainsi une seule famille, de la même main. En couleur, l'accolade et le A sont en pétrole, B, R, C, E en noir. Le A, lettre du milieu, se trouve juste sous la pointe de l'accolade : la couleur marque l'axe du logo, de la pointe au A. Le dessin est fait de formes pleines (lettres et accolade sont des contours remplis, sans trait) : il ne dépend d'aucune police installée et un imprimeur peut le prendre tel quel. Bricolage Grotesque reste la police des titres et du texte, pas celle du logo.

### La construction

- **Un trait, deux épaisseurs.** Le montant (la haste du B, du R, du E) fait 2 unités de la grille de 16 pixels de l'icône, les courbes et les bras 1,8, soit, à la hauteur du logo, environ 20 et 18 centièmes de la hauteur des lettres. L'accolade a la même épaisseur que les courbes (18).
- **Les mêmes gestes partout.** Bouts coupés net, jonctions arrondies. Le B a sa panse du haut et sa panse du bas qui se rejoignent en une pointe vers la gauche ; le R reprend la panse du haut et prolonge cette pointe en jambe ; le A a un sommet arrondi, comme le bout de l'accolade ; le C est une courbe ouverte, le E trois bras droits.
- **La hauteur.** Toutes les lettres ont la même hauteur (le B du nom). Le logo complet fait environ deux fois la hauteur d'une lettre en hauteur et quatre fois et demie en largeur. L'accolade couvre exactement la largeur du nom.
- **La pointe sur le A.** La pointe de l'accolade tombe sur le sommet du A (écart de moins d'un pixel à 420 pixels de large). L'accolade est exactement aussi large que le nom et symétrique, donc le centre du mot est le sommet du A : c'est l'espacement des lettres, réglé à l'œil, qui tient cet alignement. Ne décale ni l'accolade ni une lettre.
- **L'espacement** est une exception voulue à la formule du texte (voir « La typographie ») : −0,02 em, la valeur du h2, et non le plancher de −0,04 em. Dans le dessin, les écarts les plus étroits entre deux lettres (mesurés sur la hauteur de lettre de 100) sont de 14,4 entre B et R, 7,5 entre R et A, 9,4 entre A et C, 14,9 entre C et E : chacun a été resserré de 3 (soit 0,02 em, l'em étant la hauteur de lettre divisée par 0,66, hauteur de capitale de Bricolage) par rapport au dessin précédent. Pourquoi 0,02 et pas le plancher de 0,04 des grands titres : le plus étroit des écarts (R-A, 10,5 avant) doit rester d'au moins un pixel à la taille minimale du nom seul, 64 pixels de large, soit 7,4 ; les lettres du logo sont aussi plus épaisses que celles des titres (montant à 0,13 em contre 0,11). La pointe reste sur le sommet du A : le resserrement est le même à chaque écart, donc le A et le centre du mot se déplacent ensemble, et l'accolade est raccourcie de la même quantité. Le dessin n'obéit à aucune propriété CSS : ne lui ajoute jamais d'espacement, et ne règle pas le nom du logo à la main dans un texte.

### Les versions et quand les utiliser

| Version | Fichier | Quand |
|---|---|---|
| Principale, couleur sur papier | `logo.svg`, `logos/logo-color.svg` | Par défaut : page d'accueil, documents, présentations |
| Sur fond sombre | `logos/logo-dark.svg` | Terminal, mode sombre de GitHub, tout fond noir ou presque |
| Une couleur, noir | `logos/logo-mono.svg` | Un seul encrage, un tampon, une impression en noir |
| Une couleur, inversée | `logos/logo-mono-reversed.svg` | Sur un aplat sombre ou sur le pétrole, en couleur papier |
| Le nom seul, sans accolade (le B en pétrole) | `logos/wordmark/wordmark-color.svg`, `-dark.svg`, `-mono.svg`, `-mono-reversed.svg` | Seulement là où le logo avec l'accolade ne tient pas : bandeau horizontal étroit, en ligne à côté d'un texte |
| Petite marque, le B | `small-mark/b-color.svg`, `b-dark.svg`, `b-mono.svg`, `b-square.svg` | Là où le logo ne tient plus : avatar, icône, pastille |
| Symbole, l'accolade seule | `symbol/brace-*.svg` | Motif ou signe discret, jamais pour remplacer le nom |
| Icône d'onglet | `favicon.svg`, `favicon.ico`, `favicon-16.png` à `favicon-512.png` | Onglet du navigateur, signet |
| Avatar | `avatar-500.png` | Dépôt GitHub, listes de plugins, profils (500 x 500, carré, GitHub le recadre en rond) |
| Image de partage | `og.png` | Aperçu d'un lien, 1280 x 640, l'image sociale du dépôt GitHub |

**Où va la couleur : avec ou sans accolade.** Avec l'accolade, c'est le A qui est en pétrole, sous la pointe. Sans l'accolade (le nom seul), il n'y a plus de pointe sur laquelle poser le A : le B passe en pétrole, comme l'icône d'onglet et l'avatar, et le A revient au noir. Le nom seul n'est jamais posé sur la même page que le logo complet : on prend l'un ou l'autre, pas les deux. L'ancienne version du logo avec le B en pétrole sous l'accolade est gardée en historique dans `sources/variant-b-petrol/` ; elle ne sert plus.

**Pourquoi le B pour la petite marque.** À 16 pixels, l'accolade seule devient un trait que personne ne reconnaît, et le nom entier est illisible. Le B dessiné à la main sur la grille de 16 pixels tient à toutes les tailles, et il se reconnaît d'un coup d'œil même en pastille ronde dans une liste. C'est le même B que dans le nom du logo : quand le logo est trop petit, tu retrouves la première lettre, au même trait. La couleur du logo (le A) ne se répète pas dans l'icône (le B en pétrole) : les deux se lisent comme une même main, pas comme un même point de couleur ; avec le nom seul, les deux B en pétrole se répondent. L'accolade seule reste disponible comme symbole, pour les grands formats. Le B de l'icône a été recentré le 27 novembre : l'étendue horizontale est maintenant de 4 à 12 sur la grille de 16 (elle allait de 4 à 12,4), le montant reste aligné sur les pixels pour un 16 pixels net.

### Espace de protection

Laisse autour du logo un vide au moins égal à la hauteur d'une lettre du nom (la hauteur du B de BRACE), sur les quatre côtés. Aucun texte, aucune image, aucun bord de page ne doit entrer dans ce vide. Pour le nom seul (sans accolade), le vide est d'une demi-hauteur de lettre sur les quatre côtés, ce qui permet de l'insérer dans un bandeau étroit.

**Validé** à la remise, le 27 novembre 2026.

### Tailles minimales

- logo complet : 96 pixels de large à l'écran, 25 mm de large à l'impression. **Entre 64 et 96 pixels de large : le nom seul** (sans accolade, le B en pétrole). **Sous 64 pixels : le B** (la petite marque). Le dessin a été regardé à 96, 72 et 48 pixels : il reste lisible à 72, mais je garde 96 pixels par prudence.
- nom seul, sans accolade : 64 pixels de large à l'écran, 18 mm à l'impression. Les lettres font alors environ 13 pixels de haut ; en dessous, passe au B.
- petite marque (le B) : 16 pixels.
- symbole seul : 24 pixels de large.

**Validé** à la remise, le 27 novembre 2026, le symbole à 24 pixels compris.

### Ce qu'il ne faut jamais faire

- changer les couleurs : une accolade rouge, un nom tout pétrole ou tout noir en version couleur, une autre lettre que le A en pétrole sous l'accolade (le B en pétrole n'est que pour le nom seul).
- poser la version couleur sur un fond sombre ou sur le pétrole : prends la version sombre ou inversée.
- étirer, pencher, comprimer ou faire pivoter le logo.
- retaper le nom dans une police (Bricolage comprise) : les lettres sont dessinées, prends le fichier ; ne retouche ni l'espacement ni l'épaisseur.
- poser le nom seul à côté du logo complet sur la même page, ou prendre le nom seul quand le logo avec l'accolade tient.
- mettre le A en pétrole sur le nom seul, ou le B en pétrole sous une accolade.
- mettre l'accolade sous le nom ou lui faire pointer vers le bas.
- ajouter une ombre, un dégradé, un contour ou un effet lumineux.
- placer le logo sur une photo chargée ou sur un fond de contraste trop faible.
- redessiner le B de l'icône d'onglet ou du logo à partir d'une police : garde le fichier fourni.

## Les couleurs

Le papier et l'encre portent presque tout. Le pétrole est l'accent, et il reste rare : à l'écran, s'il est partout, on ne le voit plus. Pas de blanc pur : le papier est légèrement chaud, c'est lui le « blanc » de BRACE. L'accent se distingue des voisins de BRACE, qui tirent vers le violet, le néon ou le vert sur noir.

### Les codes

| Nom | HEX | RVB | Rôle |
|---|---|---|---|
| Papier | `#F4F1EA` | 244, 241, 234 | Le fond des pages, des documents, de l'image de partage |
| Papier 2 | `#EAE5DA` | 234, 229, 218 | Blocs de code, liste de fichiers, les rares surfaces |
| Encre | `#171614` | 23, 22, 20 | Le texte, le nom du logo, le fond sombre : le seul noir |
| Gris | `#5F5B53` | 95, 91, 83 | Texte secondaire sur papier : le plus clair autorisé |
| Pétrole | `#1D5E66` | 29, 94, 102 | L'accolade, le A du logo, le B du nom seul, un lien, un bouton, le bandeau d'une phrase |
| Pétrole clair | `#6FB7BE` | 111, 183, 190 | Le pétrole sur fond sombre |
| Surface sombre | `#211F1C` | 33, 31, 28 | Cartes et blocs de code sur fond sombre |
| Gris sur sombre | `#A5A199` | 165, 161, 153 | Texte secondaire sur fond sombre |
| Texte sur sombre | `#ECE9E2` | 236, 233, 226 | Texte courant sur fond sombre |

Des teintes complètent le pétrole, déclarées dans `brand.css` : pétrole foncé `#123E44` (survol), pétrole moyen `#3E8A92` (traits et pastilles, jamais du texte), voile `#DCEBEA` (une note, un état choisi). Le filet `#DAD5CA` sépare, il ne porte jamais de texte.

Le texte sur sombre `#ECE9E2` et ces teintes dérivées sont **validés** à la remise, le 27 novembre 2026.

Les codes sont ceux de l'écran. BRACE n'est pas imprimé pour l'instant : les codes d'impression (CMJN, Pantone) restent à fixer le jour où un support papier le demande.

### La répartition

Environ 60 % de papier et d'encre, 30 % de gris, papier 2 et surfaces sombres, et 10 % au plus de pétrole. En pratique, le pétrole occupe moins de 5 % d'une page : l'accolade, un lien, un seul bandeau pleine largeur pour une phrase qui compte.

### Les contrastes

Seuil visé : 4,5 pour 1 pour le texte, 3 pour 1 pour le grand texte et les éléments d'interface (règle WCAG). Les paires ci-dessous sont celles que BRACE utilise.

| Texte | Fond | Contraste | Usage |
|---|---|---|---|
| Encre | Papier | 16,03 | Texte courant |
| Encre | Papier 2 | 14,40 | Texte dans un bloc |
| Gris | Papier | 5,99 | Texte secondaire |
| Gris | Papier 2 | 5,38 | Texte secondaire dans un bloc |
| Pétrole | Papier | 6,54 | Liens, texte d'accent |
| Papier | Pétrole | 6,54 | Le bandeau pétrole |
| Texte sur sombre | Encre | 14,91 | Texte courant sur sombre |
| Gris sur sombre | Encre | 7,02 | Texte secondaire sur sombre |
| Pétrole clair | Encre | 7,92 | Liens et accent sur sombre |
| Pétrole clair | Surface sombre | 7,20 | Accent dans une carte sombre |
| Pétrole | Papier | 6,54 | Le A du logo sur papier (le B du nom seul) |
| Pétrole clair | Encre | 7,92 | Le A du logo sur fond sombre (le B du nom seul) |
| Papier | Pétrole | 6,54 | Le B de l'icône sur sa pastille pétrole |

Le A en pétrole se distingue des lettres noires par la couleur, pas par le contraste (pétrole sur encre : 2,45) : c'est son contraste avec le fond qui compte, et il est bon sur papier (6,54) comme, en pétrole clair, sur fond sombre (7,92). Le A reste lisible en noir et blanc, car la version une couleur le passe en noir comme le reste.

À éviter, car sous le seuil : le pétrole sur fond sombre (2,45), le pétrole clair sur papier (2,03), un gris plus clair que `#5F5B53` sur papier, le pétrole moyen pour du texte.

## La typographie

Une seule famille de titres et de texte, et une police à chasse fixe pour les commandes. Les lettres du logo sont dessinées à la main et n'appartiennent à aucune police. Bricolage Grotesque a du caractère sans bruit : ses formes un peu arrondies donnent la chaleur voulue, et elle reste sobre en texte. Commit Mono n'apparaît que pour ce qui se tape ou se lit comme du code.

| Police | Rôle | Graisses utilisées |
|---|---|---|
| Bricolage Grotesque | Titres, texte, éléments de marque | 400 (texte), 500 (titres) |
| Commit Mono | Commandes, noms de fichiers, code, rien d'autre | 400 |

### L'espacement des lettres (crénage de suivi, ou tracking)

Une valeur fixe par niveau, jamais de réglage à la main. Bricolage Grotesque existe avec un axe de taille optique (`opsz`) qui resserre ses lettres quand la taille grandit ; nous l'avons fixé à 24 pour que les titres et le logo aient le même dessin. La police ne s'adapte donc plus toute seule, et c'est l'espacement qui prend le relais. La règle tient en quatre lignes :

1. **Selon la taille.** Pour un texte en minuscules : espacement = −0,02 em par doublement de la taille, en comptant à partir du texte courant (17 px = 0). Arrondi à 0,005 em. Plancher : jamais plus serré que −0,04 em (au-delà, les lettres se touchent) ; plafond : +0,02 em.
2. **Capitales.** La valeur du niveau plus 0,06 em : les capitales sont dessinées pour avoir des lettres basses à côté d'elles, et sans cette ouverture elles se collent.
3. **Chasse fixe (Commit Mono).** Zéro : tout réglage casserait l'alignement des colonnes de code.
4. **Texte clair sur fond sombre.** Ajoute 0,01 em (classe `.on-dark`) : la lumière déborde un peu sur le fond et boucherait les lettres, surtout en petit.

| Niveau | Taille | Graisse | Interligne | Espacement | Pourquoi |
|---|---|---|---|---|---|
| Titre d'affiche (display) | 56 px | 500 | 1,1 | −0,035 em | −0,02 × log2(56/17) = −0,034 ; grands corps, lettres serrées pour tenir ensemble ; reste au-dessus du plancher de −0,04 |
| Titre de page (h1) | 44 px | 500 | 1,15 | −0,025 em | formule : −0,027 |
| Titre de section (h2) | 32 px | 500 | 1,2 | −0,02 em | formule : −0,018 |
| Sous-titre (h3) | 26 px | 500 | 1,25 | −0,01 em | formule : −0,012 |
| Petit titre (h4) | 20 px | 500 | 1,3 | −0,005 em | formule : −0,005 |
| Texte courant | 17 px | 400 | 1,5 | 0 | le point de départ de la règle ; la police est dessinée pour cette taille |
| Texte secondaire | 14 px (jamais moins) | 400 | 1,5 | +0,005 em | formule : +0,006 ; une touche d'air pour que les petits intérieurs de lettres ne se bouchent pas |
| Légende | 13 px | 400 | 1,4 | +0,01 em | formule : +0,008, arrondi à +0,01 |
| Étiquette en capitales | 12 px | 500 | 1,3 | +0,07 em | légende (+0,01) + capitales (+0,06) |
| Commande ou code (Commit Mono) | 0,9 × le texte | 400 | 1,5 | 0 | chasse fixe |
| Logo, le nom dessiné | | | | −0,02 em | exception voulue à la formule (la valeur du h2, pas le plancher) : bornée par l'écart R-A, qui doit rester d'au moins 1 px à 64 px de large, et par des traits plus épais que ceux des titres ; voir « Le logo » |

Les valeurs sont dans `brand.css` (`--track-display`, `--track-h1`, `--track-h2`, `--track-h3`, `--track-h4`, `--track-body`, `--track-small`, `--track-caption`, `--track-label`, `--track-code`, `--track-on-dark`) avec la taille et l'interligne de chaque niveau. Partout où BRACE s'écrit en lettres (titres, texte, légendes), la valeur du niveau s'applique, et rien d'autre : pas d'espacement ajouté à un mot isolé pour « faire joli ». Sur écran étroit (moins de 720 px), le titre de page descend d'un niveau (32 px, −0,02 em). Dans un README GitHub, la police est celle de GitHub (aucune police web n'y charge) : seul le logo, qui est dessiné, garde son espacement.

### La hiérarchie

Les polices, les graisses et les niveaux sont dans le tableau ci-dessus. Les titres sont en 500, le texte en 400, jamais en 600 dans nos supports. Le texte secondaire est en gris, sur papier, sans jamais dépasser le contraste de la section « Les contrastes ». Les titres ont `text-wrap: balance`, les paragraphes `text-wrap: pretty`, pour éviter les orphelins.

Les lignes de texte font entre 45 et 75 caractères (66 par défaut). Pas de capitales sur de longues phrases, pas d'italique de décoration.

### Où les trouver, et la licence

Les deux polices sont sous licence SIL Open Font 1.1 : usage commercial permis, partage permis avec la licence jointe. Les fichiers sont dans `brand/fonts/` (sous-ensemble latin, format WOFF, avec chacun son `OFL.txt`). Pour installer les polices entières sur un ordinateur (une maquette, un document), prends Bricolage Grotesque sur Google Fonts et Commit Mono sur le site de son auteur, `commitmono.com`. Aucun coût, aucun serveur tiers : les polices se chargent depuis `brand.css`.

Quand une police manque (un courriel, un tableur), la suite de repli est Helvetica Neue, Helvetica, Arial, et ui-monospace pour le code.

## La voix

La voix de BRACE n'est pas décrite ici : elle a son propre document, le [guide éditorial](../05-refinement/2026-11-19-editorial-guide.html). En une ligne : calme, claire, franche, avec une pointe d'esprit. BRACE montre des gestes (une question posée, un « à compléter », une décision écrite), pas des adjectifs.

## Les applications

Trois supports sont montrés dans la [planche de marque](2026-11-27-brand-board.html) et en fichiers dans `sources/applications/`.

- **La page d'accueil GitHub** (`github-readme.png`). Le logo en haut du README, version couleur sur fond clair et version sombre en mode sombre (GitHub propose les deux ; l'élément `picture` choisit). Une phrase d'accroche, puis le texte, avec beaucoup d'air.
- **L'avatar et l'image de partage** (`avatar-in-lists.png`, `og.png`). Le B en pastille ronde reste lisible dès 16 pixels, dans une liste de plugins comme à côté d'un commit. L'avatar et l'icône sont recentrés : le B est à égale distance des deux bords. L'image de partage reprend le logo et la phrase « Finally on the same page. » sur papier.
- **Le terminal** (`terminal.png`). Le logo sombre, puis des lignes en Commit Mono : « BRACE » en pétrole clair, le texte en `#ECE9E2`, ce qui est secondaire en `#A5A199`.

Les autres lieux (notes de version, messages de présentation, portfolio généré par BRACE, espace client) reprennent les mêmes règles : papier ou encre en fond, Bricolage, un seul accent. Le site et les réseaux sociaux viendront plus tard avec les mêmes fichiers.

## Les fichiers, et qui demander

| Dossier ou fichier | Contenu |
|---|---|
| `brand.css` | Les couleurs et les polices en variables, les paires de contraste déclarées |
| `logo.svg`, `logos/` | Le logo avec le A en pétrole : couleur, sombre, une couleur, inversé (tous en contours remplis) |
| `logos/wordmark/` | Le nom seul, sans accolade, le B en pétrole : couleur, sombre, une couleur, inversé |
| `sources/variant-b-petrol/` | Historique : l'ancien logo avec le B en pétrole (ne plus utiliser) |
| `symbol/`, `small-mark/` | L'accolade seule, le B |
| `favicon.svg`, `favicon.ico`, `favicon-*.png`, `apple-touch-icon.png` | L'icône d'onglet |
| `avatar-500.png`, `og.png` | Avatar et image de partage |
| `sources/applications/` | Les trois supports, en PNG |
| `fonts/` | Bricolage Grotesque et Commit Mono, avec leur licence |
| `sources/` | Le script `make_delivery_2.py` qui refait tous les fichiers (dessin des lettres et passage en contours compris ; il demande la bibliothèque Python shapely), et `make_check_icon.py` qui vérifie l'icône |

Pendant la mission, pour une question ou un fichier manquant, demande à Julie, directrice de clientèle, ou à Isabelle, designer. Ensuite, le script de `sources/` refait tous les fichiers en une commande, et ce document en dit les règles.

## Qui tient ce document à jour

À la remise, ce document passe à toi. La règle est simple : une décision visuelle change d'abord la charte, puis les supports, jamais l'inverse. Tout changement se note dans les décisions de la marque, avec sa raison et la date. Pour trancher, la boussole de la marque : est-ce que ça sert le mieux l'objectif, et pas ce qui fait plaisir ? On relit la charte quand un nouveau support arrive (le site, un réseau social) et à chaque bilan de la marque.
