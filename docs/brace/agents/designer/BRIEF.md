# BRIEF : designer, BRACE

Créé le 2026-11-18, à la première mission (fichiers des deux pistes pour la
réunion des pistes de création, réunion 4 de la refonte, jeudi 19 novembre
2026 à 17 h). Demandé par brand (Julie, directrice de clientèle).

## Le projet

BRACE, un plugin libre et gratuit pour les agents IA sur la machine
(Claude Code d'abord, fonctionne aussi avec Antigravity). Le projet se suit
lui-même dans `docs/brace/`. Plateforme : `docs/brace/brand/FOUNDATIONS.md`,
`STRATEGY.md`, `VOICE.md` ; brief du visage : `docs/brace/brand/BRIEF.md`.
La direction : `docs/brace/agents/art-director/2026-11-18-routes.md`.

## À garder en tête

- Nom toujours **BRACE**, en capitales.
- Langue de travail : français pour l'agence ; langue principale de la
  marque : anglais.
- Tant qu'aucune piste n'est choisie : les deux au même niveau de finition
  (le client les compare à égalité dans le deck créatif).
- Mode : tout en code (SVG, CSS). Pas de Canva, pas d'image générée.
- Les polices ne sont pas installées : les mots-symboles référencent la
  famille avec un repli système (`textLength` fixe la largeur). Ne rien
  télécharger d'internet sans autorisation.
- Supports : README GitHub (fonds `#FFFFFF` et `#0D1117`), avatar rond,
  favicon 16 / 32 / 48 px, portfolio, espace client, terminal.
- Les fichiers se refont avec `files/make_files.py <dossier files>` puis
  `files/make_check.py` (planches de contrôle).

## Corrections passées

Aucune pour l'instant.

## Corrections du client (2026-11-18, pistes créatives)

- Piste retenue : **Rassemblé**. Écrit est écartée.
- Le papier et le fond sombre viennent d'Écrit : papier #F4F1EA, fond
  sombre #171614. Le pétrole (#1D5E66, #6FB7BE pour le sombre) reste
  l'accent. Revérifier les contrastes sur ce papier.
- L'accolade **pointe en bas** est à montrer à côté de la pointe en haut,
  au même soin, au vrai format et en tout petit : le client y voit une
  flèche qui invite à lire la suite. Ne pas trancher à sa place.
- Le prénom du designer est Isabelle, celui du directeur artistique Olivier.

## Réunion 5, affinage (2026-11-19)

- Polices installées dans `files/raffinement/fonts/` (OFL 1.1 : Schibsted
  Grotesk variable depuis google/fonts, Commit Mono 1.143 depuis la release
  GitHub). Lettres du logo vectorisées (fontTools + uharfbuzz, crénage
  inclus) par `files/make_refinement.py`; applications et planche par
  `files/make_apps.py`; rendus PNG par Chrome headless.
- Trois versions : v1 Posée (600), v2 Serrée (700), v3 En ligne (500).
  Les deux sens de pointe sont livrés partout (`-tip-down`), non tranchés.
- Encre gardée à #1A1916 (celle d'Écrit, mieux accordée au papier #F4F1EA) :
  à confirmer avec le client.

## Retours du client, affinage (2026-11-20)

- Rien n'est tranché : sens, version et encre restent à choisir lundi
  23 novembre 2026 à 17 h (suite de l'affinage).
- Voir l'accolade **sous le nom**, dans les deux sens (pointe vers le bas,
  pointe vers le mot).
- Icône en petit : tester une **paire d'accolades** qui encadre, à 16 px.
- Le client veut voir **d'autres idées de logo** de l'agence, dans
  Rassemblé.
- Palette : vérifier qu'elle reste cohérente avec le papier et le fond
  sombre d'Écrit ; proposer les ajustements utiles, chacun avec sa raison.
- Police : Schibsted Grotesk ne le convainc pas, sans raison précise.
  Proposer d'autres polices variées, chacune avec une explication et un
  exemple d'utilisation. Schibsted reste une option parmi d'autres.

## Tour de retouches (2026-11-20, rapport 2026-11-20-retouches.md)

- Dossier `files/retouches/` (l'historique `raffinement/` reste intact) ; générateurs `files/make_retouches.py` (SVG) puis `files/make_retouches_pages.py` (HTML et PNG 1200 x 675 par Chrome headless). Polices des quatre pistes dans `retouches/fonts/` avec leur OFL.txt.
- Encre des fichiers de ce tour : #171614 (encre unique recommandée) ; #1A1916 documenté en option dans `retouches/brand.css`. Surface sombre #211F1C ajoutée.
- Images toujours entières (aucun recadrage), deux sens de l'accolade à égalité, ordre alterné.

## Retours du client, suite de l'affinage (2026-11-20 au soir)

- Palette **validée** avec ses trois réglages ; **un seul noir** #171614 (abandonner #1A1916).
- Accolade : deux finalistes, **sous le nom pointe vers le bas** et **au-dessus du nom pointe vers le haut** (les bouts tiennent le mot dans les deux cas). Le **A à l'accolade** reste en lice (symétrie appréciée, doute sur sa force).
- Police : préférence pour une **grotesque** (Schibsted Grotesk ou Bricolage Grotesque), **un peu moins épaisse** que dans le tour précédent. Atkinson et Figtree écartées.
- Icône d'onglet : hésite entre **l'accolade couchée** et **une lettre avec l'accolade** ; vérifier honnêtement à 16 px.
- Le client choisira sur une **maquette de page d'accueil de site**, en situation, lundi 23 novembre 2026 à 17 h.

## Maquette de page d'accueil (2026-11-20, rapport 2026-11-20-maquette.md)

- Dossier `files/maquette/`, générateur `files/make_maquette.py <retouches> <maquette>` (réutilise make_retouches.py). Noir unique #171614 (plus de #1A1916). Titres et logo à 500 (un cran sous 600), texte 400; Bricolage fixé à opsz 24 comme le logo.
- Six pages (police A/B x logo a/b/c) + page interactive `maquette.html#A-a`; PNG pleine page dans `maquette/png/`; planche d'icônes `favicon-board`.
