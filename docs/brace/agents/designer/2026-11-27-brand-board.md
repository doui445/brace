---
title: Planche de marque
author: Isabelle
role: designer
lang: fr
doc: brand-board
phase: delivery
meeting: 7
date: 2026-11-27
layout: board
theme: ../../../../brand/brand.css
---

La marque sur une seule page, version du 27 novembre (le A en pétrole) : les logos, les couleurs, les polices, trois supports, trois adjectifs. L'image complète est `brand-board-fr.png` (`brand-board.png` en est la version anglaise), prête à envoyer à un imprimeur ou à un indépendant. Les deux seront dans `brand/` du projet une fois ton accord donné à la remise. Cette page en donne le texte.

## Les logos

- **Principal**, couleur sur papier : `logo.svg`. L'accolade pétrole au-dessus du nom, la pointe sur le sommet du A, le A en pétrole et B, R, C, E en noir ; lettres dessinées dans le trait du B de l'icône, en contours remplis (prêt pour un imprimeur).
- **Sur fond sombre** : `logos/logo-dark.svg`. Accolade et A en pétrole clair, B, R, C, E en `#ECE9E2`.
- **Une couleur**, noir : `logos/logo-mono.svg`. **Inversé** : `logos/logo-mono-reversed.svg`.
- **Le nom seul**, sans accolade : `logos/wordmark/wordmark-color.svg` (et `-dark`, `-mono`, `-mono-reversed`). Le B en pétrole, comme l'icône, le A revient au noir. Seulement là où le logo avec l'accolade ne tient pas (bandeau étroit, en ligne avec du texte), jamais à côté du logo complet. Taille minimale 64 pixels de large (18 mm), vide d'une demi-hauteur de lettre. **Règle des tailles :** logo complet à partir de 96 pixels de large, nom seul de 64 à 96, le B sous 64.
- **Petite marque**, le B : `small-mark/b-color.svg`. C'est le même B que celui du nom ; recentré le 27 novembre. Elle sert d'avatar, de pastille et d'icône d'onglet (`favicon.svg`).
- **Symbole**, l'accolade seule : `symbol/brace-color.svg`.

**La règle de la couleur :** avec l'accolade, le A est en pétrole (sous la pointe) ; sans l'accolade, le B est en pétrole (comme l'icône). Le pétrole de l'A sur papier : contraste 6,54 ; en pétrole clair sur sombre : 7,92.

## Les couleurs

| Couleur | HEX | Rôle |
|---|---|---|
| Papier | `#F4F1EA` | Fond des pages |
| Papier 2 | `#EAE5DA` | Blocs de code, listes |
| Encre | `#171614` | Texte, nom du logo, fond sombre |
| Gris | `#5F5B53` | Texte secondaire |
| Pétrole | `#1D5E66` | Accent, rare : l'accolade, le A du logo, le B du nom seul |
| Pétrole clair | `#6FB7BE` | Accent sur fond sombre |
| Surface sombre | `#211F1C` | Cartes sur fond sombre |
| Gris sur sombre | `#A5A199` | Texte secondaire sur sombre |

## Les polices

- **Bricolage Grotesque**, titres en 500, texte en 400 (le nom du logo n'est plus composé dedans, il est dessiné). *Finally on the same page.*
- **Commit Mono**, 400, pour les commandes et le code seulement. `$ claude`
- **L'espacement des lettres** est fixé par niveau : serré sur les grands titres (de −0,035 em à −0,02 em), nul dans le texte courant, un peu ouvert sur le petit texte (+0,005 à +0,01 em) et les capitales (+0,07 em), nul en Commit Mono. Le tableau est dans la charte.

## Trois supports

- **La page d'accueil GitHub**, logo en version claire et en version sombre : `applications/github-readme.png`.
- **L'avatar**, du 16 au 96 pixels, et dans une liste de plugins : `applications/avatar-in-lists.png`.
- **Le terminal**, logo sombre et lignes en Commit Mono : `applications/terminal.png`.

## Trois adjectifs

**Calme. Fiable. Franc.** Ce sont trois des six adjectifs du caractère de BRACE (autonome, fiable, attentif, prévoyant, calme, franc), choisis parce que ta marque les porte : le calme dans l'air et la sobriété, la fiabilité dans le papier, l'encre et un seul accent, la franchise dans un dessin sans effet.
