---
title: Le nom BRACE parmi les plugins
author: Bruno
role: analyste
lang: fr
meeting: 4
date: 2026-11-07
---

# Le nom BRACE parmi les plugins (2026-11-07)

Contrôle de disponibilité, pas un avis juridique. Profondeur : rapide. Lectures faites le 2026-11-07.

## Résumé

- **Verdict global : doute mineur.** Je n'ai trouvé aucun plugin, outil ou marque nommé BRACE dans la catégorie de BRACE (mémoire de projet pour agents de code).
- **Seul point à surveiller : « Agent-BRACE »**, un code de recherche (article arXiv, 11 étoiles) qui développe BRACE en « Agent Belief state Representation via Abstraction and Confidence Estimation » (source : [README du dépôt](https://github.com/joykirat18/Agent-BRACE) et [article arXiv](https://arxiv.org/abs/2605.11436), lus le 2026-11-07). Autre objet, mais même mot, même univers « agents ».
- **Le mot « brace » est très occupé en développement** (expansion d'accolades `brace-expansion`, l'éditeur `brace`), ce qui gêne le repérage plus que la propriété.
- **Les noms de paquets nus sont pris** : `brace` sur npm (éditeur Ace, 2018) et sur PyPI (gestionnaire de mots de passe, version 0.1). Un plugin Claude Code n'en a pas besoin, mais le nom court npm ne sera pas libre.
- Limite : un seul passage, sur des API et des pages. Antigravity et la place de marché de VS Code n'ont pu être lus (voir « Non vérifié »).

## Constats

| Lieu | Verdict | Pourquoi | Source | Lu le |
|---|---|---|---|---|
| Place de marché officielle de plugins Claude Code (dépôt `anthropics/claude-plugins-official`) | Clair | 41 plugins listés, aucun nommé brace. | [liste du dossier plugins](https://api.github.com/repos/anthropics/claude-plugins-official/contents/plugins) | 2026-11-07 |
| Places de marché communautaires de Claude Code | Non concluant | Une recherche large n'a remonté aucun plugin BRACE. Ces places sont des dizaines de dépôts dispersés : on ne peut pas toutes les lire. | [recherche web](https://github.com/xiaolai/claude-plugin-marketplace/wiki) (aucune mention) | 2026-11-07 |
| Plugins Antigravity | Non vérifié | Pas de registre public lisible trouvé. | n/a | 2026-11-07 |
| npm, paquet `brace` | Doute moyen (nom nu pris) | Occupé par « browserify compatible version of the ace editor », version 0.11.1, dernière publication 2018-02-14, mainteneur thlorenz. Ancien, inactif, mais le nom est tenu. Existent aussi `brace-cli` (« cli for brace », 2018) et, très présents, `brace-expansion` et `braces`. Le périmètre `@brace` est vide. | [registre npm : brace](https://registry.npmjs.org/brace), [brace-cli](https://registry.npmjs.org/brace-cli), [recherche de périmètre](https://registry.npmjs.org/-/v1/search?text=scope:brace&size=10) | 2026-11-07 |
| PyPI, paquet `brace` | Doute moyen (nom nu pris) | Occupé par un gestionnaire de mots de passe, version 0.1, ancien. Sans rapport avec les agents. | [PyPI : brace](https://pypi.org/pypi/brace/json) | 2026-11-07 |
| Homebrew (formule et cask `brace`) | Clair | Aucune formule ni cask à ce nom (404 aux deux). | [formule](https://formulae.brew.sh/api/formula/brace.json), [cask](https://formulae.brew.sh/api/cask/brace.json) | 2026-11-07 |
| GitHub, compte `brace` | Doute mineur | Compte personnel ancien (créé en 2011, un dépôt, sans biographie). Le nom court est donc pris, mais sans activité visible dans la catégorie. | [compte](https://api.github.com/users/brace) | 2026-11-07 |
| GitHub, dépôts de la catégorie agents | Doute mineur | **joykirat18/Agent-BRACE** : code de recherche d'un article ([arXiv:2605.11436](https://arxiv.org/abs/2605.11436), déposé le 2026-05-12, lu le 2026-11-07 ; état de croyance d'un agent LLM, apprentissage par renforcement), Apache 2.0, créé en mai 2026, 11 étoiles. Pas un plugin. **haroon0x/brace-scheduling-agent** : agent de prise de rendez-vous local, 0 étoile, ne revendique pas le nom. **brace-source** : compte personnel ouvert le 2026-10-21, deux dépôts d'agents, aucun produit nommé Brace. | [Agent-BRACE](https://github.com/joykirat18/Agent-BRACE), [scheduling-agent](https://github.com/haroon0x/brace-scheduling-agent), [brace-source](https://github.com/brace-source), [recherche de dépôts](https://api.github.com/search/repositories?q=brace+in:name+agent&sort=stars&per_page=15) | 2026-11-07 |
| GitHub, autres dépôts nommés brace | Doute mineur (bruit) | Le mot est surtout celui de l'expansion d'accolades (`brace-expansion`, `braces`) et de l'éditeur `brace` (1 066 étoiles). Aucun n'est dans la catégorie : gênant pour le repérage, pas pour la propriété. | [recherche de dépôts](https://api.github.com/search/repositories?q=brace+in:name+(mcp+OR+claude+OR+antigravity+OR+skill+OR+memory)&sort=stars&per_page=15) | 2026-11-07 |
| Place de marché de VS Code | Non vérifié | La page de recherche est rendue par script : aucun résultat lisible. | [recherche](https://marketplace.visualstudio.com/search?term=brace&target=VSCode&category=All%20categories&sortBy=Relevance) | 2026-11-07 |
| Web, « BRACE » comme outil de mémoire d'agents | Doute mineur | Une seule mention, dans un condensé d'actualité (mai 2026) : « des outils comme agentmemory et BRACE ». Sans auteur ni lien. Peut renvoyer à Agent-BRACE ou à autre chose. | [condensé nbot.ai](https://nbot.ai/curator/uwe9ft8i/highlights/h6-agent-memory) | 2026-11-07 |

## Lecture pour la décision

- Pas de conflit trouvé. Le plus proche est Agent-BRACE : même mot, public de chercheurs, pas d'outil de développeur. Risque de confusion faible, risque de repérage réel (« brace agent » le fera remonter).
- Pour npm et PyPI, si BRACE y est un jour publié, prévoir un nom composé (par exemple `brace-plugin`, à vérifier) ou un périmètre. Le périmètre `@brace` est libre sur npm (lecture du jour, à réserver pour être sûr).
- À faire avant tout dépôt : lecture des registres de marques et des noms de domaine, hors de cette demande.

## Non vérifié

- **Antigravity** : aucun registre public de plugins lu.
- **VS Code** : page rendue par script, aucun résultat lu. À refaire avec un navigateur piloté ou un appel à l'API de la place de marché.
- **Places de marché communautaires de Claude Code** : seule une recherche large, pas de lecture exhaustive.
- **PyPI** : seul le paquet exact `brace` a été lu, pas les noms voisins (`brace-*`). La date de mise en ligne n'était pas affichée.
- **La mention « BRACE » du condensé nbot.ai** : auteur et lien inconnus.
- **Noms de domaine, marques** : non faits.
- Les statuts « inactif » se déduisent de dates de publication, pas d'un contact avec les auteurs.
