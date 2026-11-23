---
title: Charte graphique
author: Isabelle
role: designer
lang: fr
doc: guidelines
phase: delivery
meeting: 6
date: 2026-11-23
layout: landscape
theme: files/delivery/brand.css
---

Ce document dit comment BRACE se montre : son logo, ses couleurs, ses polices, et où chacun se trouve. Il se lit en une demi-heure et se garde sous la main pour tout ce que tu feras ensuite (une page, un message, une affiche). Les fichiers dont il parle seront dans le dossier `brand/` du projet une fois que tu auras donné ton accord à la remise. Les images de chaque support sont dans la [planche de marque](2026-11-23-brand-board.html).

## Les fondations en bref

BRACE donne à chacun toute la puissance de l'IA sur sa machine, sans les galères. Il le fait par trois gestes : il lit ce que le projet dit déjà, il demande ce qu'il ne peut pas savoir, et il note ce qui est décidé. C'est toi qui tranches. Le détail est dans la [plateforme de marque](../2026-11-07-platform.html).

Le caractère est celui de Jarvis pour le comportement et d'Apple pour la sensation : simple, sobre, sans friction. L'émotion à laisser est la sérénité, appuyée sur la confiance. L'identité visuelle en tire quatre règles :

- beaucoup d'air, peu de couleurs, une seule famille de caractères.
- un seul accent, le pétrole, qui reste rare.
- l'accolade, qui tient ensemble le nom et le projet, comme BRACE tient ensemble tes fichiers de suivi.
- jamais les clichés de l'IA (dégradés violets, étincelles, robots, néons) ni le look hacker.

## Le logo

Le logo, c'est l'accolade posée au-dessus du nom BRACE, pointe vers le haut. Les lettres sont en Bricolage Grotesque 600, espacées de 0,03 em. L'accolade est en pétrole, le nom en noir. Le dessin est fait de formes : il ne dépend d'aucune police installée.

### Les versions et quand les utiliser

| Version | Fichier | Quand |
|---|---|---|
| Principale, couleur sur papier | `logo.svg`, `logos/logo-color.svg` | Par défaut : page d'accueil, documents, présentations |
| Sur fond sombre | `logos/logo-dark.svg` | Terminal, mode sombre de GitHub, tout fond noir ou presque |
| Une couleur, noir | `logos/logo-mono.svg` | Un seul encrage, un tampon, une impression en noir |
| Une couleur, inversée | `logos/logo-mono-reversed.svg` | Sur un aplat sombre ou sur le pétrole, en couleur papier |
| Petite marque, le B | `small-mark/b-color.svg`, `b-dark.svg`, `b-mono.svg`, `b-square.svg` | Là où le logo ne tient plus : avatar, icône, pastille |
| Symbole, l'accolade seule | `symbol/brace-*.svg` | Motif ou signe discret, jamais pour remplacer le nom |
| Icône d'onglet | `favicon.svg`, `favicon.ico`, `favicon-16.png` à `favicon-512.png` | Onglet du navigateur, signet |
| Avatar | `avatar-500.png` | Dépôt GitHub, listes de plugins, profils (500 x 500, carré, GitHub le recadre en rond) |
| Image de partage | `og.png` | Aperçu d'un lien, 1280 x 640, l'image sociale du dépôt GitHub |

**Pourquoi le B pour la petite marque.** À 16 pixels, l'accolade seule devient un trait que personne ne reconnaît, et le nom entier est illisible. Le B dessiné à la main sur la grille de 16 pixels tient à toutes les tailles, et il se reconnaît d'un coup d'œil même en pastille ronde dans une liste. L'accolade seule reste disponible comme symbole, pour les grands formats.

### Espace de protection

Laisse autour du logo un vide au moins égal à la hauteur d'une lettre du nom (la hauteur du B de BRACE), sur les quatre côtés. Aucun texte, aucune image, aucun bord de page ne doit entrer dans ce vide.

**Proposé :** cette règle d'espace est une proposition de l'agence, à valider à la remise.

### Tailles minimales

- logo complet : 96 pixels de large à l'écran, 25 mm de large à l'impression. En dessous, passe au B.
- petite marque (le B) : 16 pixels.
- symbole seul : 24 pixels de large.

**Proposé :** ces tailles minimales, le symbole à 24 pixels compris, sont des propositions de l'agence, à valider à la remise.

### Ce qu'il ne faut jamais faire

- changer les couleurs (une accolade rouge, un nom pétrole).
- poser la version couleur sur un fond sombre ou sur le pétrole : prends la version sombre ou inversée .
- étirer, pencher, comprimer ou faire pivoter le logo .
- retaper le nom dans une autre police, ou changer l'espacement des lettres .
- mettre l'accolade sous le nom ou lui faire pointer vers le bas .
- ajouter une ombre, un dégradé, un contour ou un effet lumineux .
- placer le logo sur une photo chargée ou sur un fond de contraste trop faible .
- redessiner le B de l'icône d'onglet à partir d'une police : garde le fichier fourni.

## Les couleurs

Le papier et l'encre portent presque tout. Le pétrole est l'accent, et il reste rare : à l'écran, s'il est partout, on ne le voit plus. Pas de blanc pur : le papier est légèrement chaud, c'est lui le « blanc » de BRACE. L'accent se distingue des voisins de BRACE, qui tirent vers le violet, le néon ou le vert sur noir.

### Les codes

| Nom | HEX | RVB | Rôle |
|---|---|---|---|
| Papier | `#F4F1EA` | 244, 241, 234 | Le fond des pages, des documents, de l'image de partage |
| Papier 2 | `#EAE5DA` | 234, 229, 218 | Blocs de code, liste de fichiers, les rares surfaces |
| Encre | `#171614` | 23, 22, 20 | Le texte, le nom du logo, le fond sombre : le seul noir |
| Gris | `#5F5B53` | 95, 91, 83 | Texte secondaire sur papier : le plus clair autorisé |
| Pétrole | `#1D5E66` | 29, 94, 102 | L'accolade, un lien, un bouton, le bandeau d'une phrase |
| Pétrole clair | `#6FB7BE` | 111, 183, 190 | Le pétrole sur fond sombre |
| Surface sombre | `#211F1C` | 33, 31, 28 | Cartes et blocs de code sur fond sombre |
| Gris sur sombre | `#A5A199` | 165, 161, 153 | Texte secondaire sur fond sombre |
| Texte sur sombre | `#ECE9E2` | 236, 233, 226 | Texte courant sur fond sombre |

Des teintes complètent le pétrole, déclarées dans `brand.css` : pétrole foncé `#123E44` (survol), pétrole moyen `#3E8A92` (traits et pastilles, jamais du texte), voile `#DCEBEA` (une note, un état choisi). Le filet `#DAD5CA` sépare, il ne porte jamais de texte.

**Proposé :** le texte sur sombre `#ECE9E2` et ces teintes dérivées (`#123E44`, `#3E8A92`, `#DCEBEA`, `#DAD5CA`) n'ont pas été validées le 23 novembre ; tu les valides ou les écartes à la remise.

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
| Encre | Pétrole clair | 7,92 | Le B sur fond clair, version sombre |

À éviter, car sous le seuil : le pétrole sur fond sombre (2,45), le pétrole clair sur papier (2,03), un gris plus clair que `#5F5B53` sur papier, le pétrole moyen pour du texte.

## La typographie

Une seule famille de titres et de texte, et une police à chasse fixe pour les commandes. Bricolage Grotesque a du caractère sans bruit : ses formes un peu arrondies donnent la chaleur voulue, et elle reste sobre en texte. Commit Mono n'apparaît que pour ce qui se tape ou se lit comme du code.

| Police | Rôle | Graisses utilisées |
|---|---|---|
| Bricolage Grotesque | Titres, texte, éléments de marque, lettres du logo | 400 (texte), 500 (titres), 600 (logo, dessiné en formes) |
| Commit Mono | Commandes, noms de fichiers, code, rien d'autre | 400 |

### La hiérarchie

| Niveau | Police et graisse | Taille et interligne |
|---|---|---|
| Titre de page | Bricolage 500 | grand, interligne 1,15 |
| Titre de section | Bricolage 500 | interligne 1,2 |
| Texte courant | Bricolage 400 | 17 px, interligne 1,5 |
| Texte secondaire | Bricolage 400, gris | un cran plus petit, jamais sous 14 px |
| Commande ou code | Commit Mono 400 | un peu plus petit que le texte, sur papier 2 ou surface sombre |

Les lignes de texte font entre 45 et 75 caractères (66 par défaut). Pas de capitales sur de longues phrases, pas d'italique de décoration.

### Où les trouver, et la licence

Les deux polices sont sous licence SIL Open Font 1.1 : usage commercial permis, partage permis avec la licence jointe. Les fichiers sont dans `brand/fonts/` (sous-ensemble latin, format WOFF, avec chacun son `OFL.txt`). Pour installer les polices entières sur un ordinateur (une maquette, un document), prends Bricolage Grotesque sur Google Fonts et Commit Mono sur le site de son auteur, `commitmono.com`. Aucun coût, aucun serveur tiers : les polices se chargent depuis `brand.css`.

Quand une police manque (un courriel, un tableur), la suite de repli est Helvetica Neue, Helvetica, Arial, et ui-monospace pour le code.

## La voix

La voix de BRACE n'est pas décrite ici : elle a son propre document, le [guide éditorial](../05-refinement/2026-11-19-editorial-guide.html). En une ligne : calme, claire, franche, avec une pointe d'esprit. BRACE montre des gestes (une question posée, un « à compléter », une décision écrite), pas des adjectifs.

## Les applications

Trois supports sont montrés dans la [planche de marque](2026-11-23-brand-board.html) et en fichiers dans `applications/`.

- **La page d'accueil GitHub** (`github-readme.png`). Le logo en haut du README, version couleur sur fond clair et version sombre en mode sombre (GitHub propose les deux ; l'élément `picture` choisit). Une phrase d'accroche, puis le texte, avec beaucoup d'air.
- **L'avatar et l'image de partage** (`avatar-in-lists.png`, `og.png`). Le B en pastille ronde reste lisible dès 16 pixels, dans une liste de plugins comme à côté d'un commit. L'image de partage reprend le logo et la phrase « Finally on the same page. » sur papier.
- **Le terminal** (`terminal.png`). Le logo sombre, puis des lignes en Commit Mono : « BRACE » en pétrole clair, le texte en `#ECE9E2`, ce qui est secondaire en `#A5A199`.

Les autres lieux (notes de version, messages de présentation, portfolio généré par BRACE, espace client) reprennent les mêmes règles : papier ou encre en fond, Bricolage, un seul accent. Le site et les réseaux sociaux viendront plus tard avec les mêmes fichiers.

## Les fichiers, et qui demander

| Dossier ou fichier | Contenu |
|---|---|
| `brand.css` | Les couleurs et les polices en variables, les paires de contraste déclarées |
| `logo.svg`, `logos/` | Le logo : couleur, sombre, une couleur, inversé |
| `symbol/`, `small-mark/` | L'accolade seule, le B |
| `favicon.svg`, `favicon.ico`, `favicon-*.png`, `apple-touch-icon.png` | L'icône d'onglet |
| `avatar-500.png`, `og.png` | Avatar et image de partage |
| `applications/` | Les trois supports, en PNG |
| `fonts/` | Bricolage Grotesque et Commit Mono, avec leur licence |
| `sources/` | Le script qui refait tous les fichiers à partir des dessins validés |

Pendant la mission, pour une question ou un fichier manquant, demande à Julie, directrice de clientèle, ou à Isabelle, designer. Ensuite, le script de `sources/` refait tous les fichiers en une commande, et ce document en dit les règles.

## Qui tient ce document à jour

À la remise, ce document passe à toi. La règle est simple : une décision visuelle change d'abord la charte, puis les supports, jamais l'inverse. Tout changement se note dans les décisions de la marque, avec sa raison et la date. Pour trancher, la boussole de la marque : est-ce que ça sert le mieux l'objectif, et pas ce qui fait plaisir ? On relit la charte quand un nouveau support arrive (le site, un réseau social) et à chaque bilan de la marque.
