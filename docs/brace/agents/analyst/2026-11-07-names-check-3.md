---
title: Contrôle des cinq prénoms du troisième tour (stratège)
author: Bruno
role: analyste
lang: fr
meeting: 2
date: 2026-11-07
---

# Contrôle des cinq prénoms, troisième tour : BRACE (2026-11-07)
Demandé par : brand (Alice, directrice de clientèle). Profondeur : rapide. Contrôle de disponibilité, pas un avis juridique.

## Résumé

- **Augustin : clair (vérification mince).** Aucun assistant, modèle ou outil connu à ce nom. Seulement des personnes peu connues.
- **Constance : doute mineur.** Aucun produit d'IA public trouvé, seulement une note interne décrivant un agent juridique du même nom. Le bruit vient du nom commun.
- **Eleanor : doute moyen.** MyndYou commercialise un assistant de soins « Eleanor », une organisation « eleanor-ai » existe sur Hugging Face, et Eleanor Berger est connue dans le milieu des agents.
- **Nestor : doute moyen.** Plusieurs assistants auto-hébergés et une start-up (YC) portent ce nom, aucun dominant.
- **Hector : doute moyen, le plus exposé.** Hector (verikod/hector) est une plateforme d'agents d'IA open source en Go, même catégorie que BRACE.
- Limite : lectures faites sur des résultats de recherche, pages presque jamais ouvertes. « Rien trouvé » ne veut pas dire « rien n'existe ».

## Constats

Lecture le 2026-11-07. Échelle : clair / doute mineur / doute moyen / éviter.

| Prénom | Verdict | Pourquoi | Source | Lu le |
|---|---|---|---|---|
| **Constance** | Doute mineur | Aucun produit d'IA commercial trouvé. Seule trace : une note de coffre personnel décrivant un agent « Constance » (rédaction de documents juridiques, nommé d'après Constance Baker Motley), donc projet privé, pas une marque. Aucune personnalité du code relevée. La recherche « Constance AI agent » ne remonte que des résultats génériques : le bruit du nom commun est réel, et cela joue en faveur de la liberté mais contre le repérage. | [note Constance](https://auset-brain-vault.pages.dev/Agents/Constance/characteristics), [recherche large](https://eesel.ai/blog/npm-install-claude-code) (aucune mention) | 2026-11-07 |
| **Nestor** | Doute moyen | Plusieurs projets du même nom, dans la catégorie : `nestor-home` (PyPI, MIT), assistant domestique auto-hébergé relié à Home Assistant et à des messageries ; `ashbert/nestor`, assistant familial privé pour Telegram et Slack qui s'appuie sur Claude ou GPT-4 ; un assistant personnel sous Signal (n8n) ; un cadriciel Python d'agents conversationnels (non confirmé). S'y ajoute Nestor, start-up « people intelligence » (YC, seed de 2 M$ en décembre 2022), hors agents. Une fiche creati.ai « Nestor » existe, sans détail lu. Aucun n'est dominant. | [PyPI nestor-home](https://pypi.org/project/nestor-home/), [ashbert/nestor (miroir)](https://2.ravana69.workers.dev/https/github.com/ashbert/nestor), [billet Signal](https://sebastienlallemand-net.pages.dev/en/posts/nestor-ai-signal/), [creati.ai](https://creati.ai/ai-tools/nestor), [nordic9](https://nordic9.com/news/nestor-in-a-2m-equity-round-backed-by-eleven-ventures-and-underline-ventures/) | 2026-11-07 |
| **Hector** | Doute moyen | **Hector (verikod/hector, ex kadirpekel/hector)** : plateforme d'agents d'IA native A2A, déclarative en YAML, écrite en Go, MIT, installable par `go install`, Homebrew ou Docker, orchestration multi-agents ; présentée sur Show HN, avec un tutoriel « assistant de code à la Cursor ». Même catégorie que BRACE. Autres : Hector AI (outil Amazon PPC, fiche G2), un propriétaire de GitHub nommé Hector Flores (personne, pas ce projet). Pas de personnalité du code dominante relevée. Le plus exposé des cinq : la recherche « Hector AI agent » ramène d'abord ce projet. | [pkg.go.dev](https://pkg.go.dev/github.com/verikod/hector), [Show HN](https://hn.svelte.dev/item/45493411), [DEV](https://dev.to/kadir_pekel_3277e6819e5b9/build-a-cursor-like-ai-coding-assistant-278o), [G2 Hector AI](https://www.g2.com/de/sellers/hectorai) | 2026-11-07 |
| **Eleanor** | Doute moyen | **Eleanor de MyndYou** : assistant de soins virtuel à écoute active, vendu dans la santé (hors développeurs). Organisation « Eleanor AI » sur Hugging Face (monorepo Python avec agents, collections de mémoire, utilisateurs). Application de hackathon (React, Google AI), compagnon « Eleanor » à l'état de projet (121 Collaborative), post israélien présentant un agent Eleanor. **Eleanor Berger** : ingénieure en IA, enseigne les agents de code, fondatrice d'Agentic Ventures, présente sur ThursdAI : une personne du public de BRACE, sans être célèbre. Rappel du rédacteur : « Eleanor Rigby » non vérifié ici. | [MyndYou (CB Insights)](https://www.cbinsights.com/company/myndyou), [Hugging Face](https://huggingface.co/eleanor-ai), [121 Collaborative](https://121collaborative.vercel.app/eleanor), [ThursdAI](https://thursdai.news/guests/intellectronica), [Maven](https://maven.com/p/b9a2df/build-your-own-ai-coding-agent-from-scratch) | 2026-11-07 |
| **Augustin** | Clair (vérification mince) | Aucun assistant, modèle, entreprise d'IA ou outil nommé Augustin trouvé. Seulement des personnes : Augustin Combes (indépendant, agents et MCP, ingénieur fondateur chez dircut.ai), Augustin Vignet (CTO IA générative), Augustin Chan (fondateur 8-Bit Oracle), connus sur des annuaires de freelances ou d'événements, pas des figures du milieu. Noms voisins sans collision : Augusta Labs, Augustus Intelligence, Auggie d'Augment Code. | [Malt Combes](https://www.malt.com/profile/augustincombes), [Malt Vignet](https://www.malt.com/profile/augustinvignet), [Startup Grind](https://www.startupgrind.com/events/details/startup-grind-hong-kong-presents-code-your-vision-with-ai-with-augustin-chan), [Augusta Labs](https://f4.fund/startups/augusta-labs), [Augment](https://awesome.ecosyste.ms/projects/github.com%2Faugmentcode%2Faugment-agent) | 2026-11-07 |

## Lecture pour le choix de la stratège

Du plus sûr au moins sûr : **Augustin** (clair), **Constance** (doute mineur), puis **Nestor** et **Eleanor** (doute moyen), enfin **Hector** (doute moyen, le seul qui désigne une plateforme d'agents de même catégorie que BRACE).

- **Constance**, choix du rédacteur : tient. Rien de public dans la catégorie. Le seul risque est de repérage (nom commun), pas de collision.
- **Nestor**, second choix : tient avec réserve. Plusieurs petits assistants, dont un branché sur Claude, mais aucun dominant ; le prénom est un cas de « nom d'assistant domestique », ce qui peut le faire lire comme un assistant plutôt que comme un stratège.
- **Hector** : à écarter si une alternative existe, à cause du projet de même nom dans la catégorie.
- **Eleanor** : tient, mais l'écart entre l'anglais et le français (Éléonore) s'ajoute aux trois collisions mineures.

## Ajouté au-delà de la demande

- Eleanor Berger : personne du milieu des agents de code, non citée par le rédacteur.
- Hector AI (Amazon) et la start-up Nestor (YC) : homonymes hors catégorie, relevés par prudence.

## Espaces ouverts

- Seul Augustin ne remonte aucun produit d'IA. Il ressemble à un nom qui n'est pas pris, mais peu d'indices le confirment au-delà des annuaires.
- Constance est libre de produit mais pas de bruit : une recherche large ne la fera pas apparaître avant le mot.

## Non vérifié

- « Eleanor Rigby », Tintin (Nestor), le dessin animé Hector, saint Augustin, Constance Baker Motley : références culturelles citées par le rédacteur ou connues, non contrôlées ici.
- La page creati.ai Nestor et le cadriciel Python `nestor` : fiches d'annuaires sans détail lu.
- Les sources sont des résultats de recherche, avec beaucoup de miroirs et d'agrégateurs (pages.dev, workers.dev, ecosyste.ms). Les détails peuvent être périmés.
- Noms de domaine, paquets (npm, PyPI) et marques : hors de cette demande, non faits.
