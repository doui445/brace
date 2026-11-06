---
title: Benchmark concurrentiel
author: Bruno
role: analyste
lang: fr
meeting: 2
date: 2026-11-06
---

Ce document met à jour le benchmark du 19 octobre. Il lit les concurrents par leur discours et leur ton, pas seulement par leurs fonctions. Il ajoute les outils de branding par IA que ton brief demandait de vérifier, donne la parole au public élargi, et dit où BRACE apparaît aujourd'hui. Tout est daté et sourcé. Ce que je n'ai pas pu vérifier est marqué *non vérifié*.

## Ce qu'il faut retenir

1. **Ton hypothèse se confirme, avec une nuance.** Les outils de branding par IA existent, mais ils vendent un logo et un kit à des gens sans graphiste, ou un document de stratégie fait en une fois sur le web. Aucun de ceux que j'ai lus ne garde la marque comme un dossier lisible dans le projet, que l'IA relit ensuite pour écrire et construire.
2. **Le voisin le plus important est Anthropic.** Claude Design (17 avril 2026) apprend le système de design d'une équipe à partir de son code, et son plugin marketing annonce « enforce brand voice ». Le design qui arrive chez BRACE croisera le produit de l'hôte.
3. **Les « agences IA » crient des chiffres.** « 650+ agents », « jusqu'à 60 % de gaspillage en moins », « l'agence est remplacée ». C'est le contraire de la retenue que tu demandes : la place du ton calme est libre.
4. **Les paquets de compétences grossissent** (superpowers 313 000 étoiles, ECC 298 000) et claude-mem dit maintenant « pour tous les agents ». L'argument « plusieurs agents » ne distingue plus BRACE seul.
5. **Le public élargi décrit la même douleur que les développeurs**, avec des mots d'entrepreneur. La note qu'on ne tient pas à jour est la plainte la plus répétée.
6. **BRACE est presque invisible en public** : une étoile, pas de description, aucune mention trouvée. L'ancien nom traîne dans le README, le fichier de la place de marché et le plugin passerelle.

## 1. Les concurrents, mis à jour

Les niveaux restent ceux d'avant : 1 les alternatives, 2 les concurrents directs, 3 les promesses voisines. J'ajoute un niveau 4, les outils de branding et les « agences » IA. Seul ce qui a changé depuis le 19 octobre est repris ; le reste est dans le benchmark précédent.

### Niveau 1 : les alternatives (nouveautés)

| Nom | Ce qu'il promet, et sur quel ton | Forces | Limites | Source | Vérifié |
|---|---|---|---|---|---|
| Claude Design (Anthropic Labs) | Créer des visuels, prototypes, présentations avec Claude. À l'installation, Claude apprend le système de design de l'équipe depuis son code, puis l'applique. Ton enthousiaste, centré sur le bénéfice. Aperçu de recherche pour les abonnés Pro, Max, Team et Enterprise. | Officiel, même hôte que BRACE, lit le code | Le visuel seulement : ni stratégie, ni voix, ni suivi décrits. Le système de design vit dans le produit d'Anthropic. | [anthropic.com](https://www.anthropic.com/news/claude-design-anthropic-labs) | 2026-11-06 |
| Plugin « marketing » d'Anthropic | « Draft content, plan campaigns, enforce brand voice, brief on competitors, and report on performance across channels. » Ton fonctionnel. | Officiel, pour Cowork et Claude Code | Pensé pour des équipes marketing ; je n'ai pas pu lire ses compétences, donc je ne sais pas comment il construit une voix. | [GitHub](https://github.com/anthropics/knowledge-work-plugins) | 2026-11-06 |
| Compétence « brand-guidelines » d'Anthropic | Applique les couleurs et polices d'Anthropic à des documents. C'est sa propre identité, pas un outil pour créer la tienne. | Montre le format de compétence | Aucune comme concurrent | [GitHub](https://raw.githubusercontent.com/anthropics/skills/main/skills/brand-guidelines/SKILL.md) | 2026-11-06 |

### Niveau 2 : les concurrents directs (chiffres du jour)

| Nom | Discours | Étoiles (avant) | Ce qui a bougé | Source | Vérifié |
|---|---|---|---|---|---|
| superpowers | « An agentic skills framework & software development methodology that works. » Sûr de lui, enthousiaste. | 313 000 (302 000) | Rien sur le fond | [GitHub](https://api.github.com/repos/obra/superpowers) | 2026-11-06 |
| ECC (Everything Claude Code) | Description : système d'optimisation de la performance pour les agents (compétences, « instincts », mémoire, sécurité). Promotionnel, riche en chiffres. | 298 000 (284 000) | Description reformulée | [GitHub](https://api.github.com/repos/affaan-m/everything-claude-code) | 2026-11-06 |
| claude-mem | « Persistent Context Across Sessions for Every Agent. » Technique, sûr de lui. | 114 000 (102 000) | Se présente maintenant comme multi-agents (Claude Code, Codex, Gemini, Copilot et d'autres) | [GitHub](https://api.github.com/repos/thedotmack/claude-mem) | 2026-11-06 |
| Spec Kit | « Toolkit to help you get started with SDD or any other process! » Pratique. | 148 000 (142 000) | Rien sur le fond | [GitHub](https://api.github.com/repos/github/spec-kit) | 2026-11-06 |
| BMAD-METHOD | « Breakthrough Method for Agile Ai Driven Development. » | 55 000 (54 000) | Rien sur le fond | [GitHub](https://api.github.com/repos/bmad-code-org/BMAD-METHOD) | 2026-11-06 |

Taskmaster et les tableaux de bord de sessions : non revérifiés depuis le 19 octobre.

### Niveau 3 : les promesses voisines

OpenClaw, Hermes, Meta Muse, Tab, Notion AI, Manus : non revérifiés depuis le 19 octobre, rien dans cette mission ne les contredit. Ils vendent « il fait des choses » ; seul Tab joue la confiance.

### Niveau 4 (nouveau) : les outils de branding par IA et les « agences » IA

Le marché se découpe en trois familles.

**a. Logo et kit de marque (le visuel)**

| Nom | Ce qu'il promet, et sur quel ton | Forces | Limites | Source | Vérifié |
|---|---|---|---|---|---|
| Looka | « Design your own beautiful brand », « The easiest way to design and launch your new business », « Looka is your personal designer ». Chaleureux, tourné vers l'entrepreneur. Livre logos, kit de marque, modèles pour les réseaux. | Très connu, rapide | Du visuel ; ni stratégie ni voix sur la page. Un comparatif dit que les logos peuvent se ressembler et que le kit est un abonnement à part (source secondaire). | [looka.com](https://looka.com), [comparatif Dorik](https://dorik.com/blog/best-ai-tools-for-branding) | 2026-11-06 |
| Brandmark | « Create a unique, professional logo for your business. » Promet un logo tout de suite, des retouches illimitées, « No more designer anxiety ». Rassurant. Paiement unique. | Prix simple, peu de friction | Du visuel et des modèles ; pas de suivi dans le temps | [brandmark.io](https://brandmark.io) | 2026-11-06 |
| Tailor Brands | « The only place to build a real business. » « Independence doesn't mean doing it alone. » L'assistant Navi suit les échéances. Le branding n'est qu'une partie de l'offre. Rassurant, simple. | Ton de compagnon, rappels | Stratégie de marque non décrite ; offre centrée sur la création d'entreprise aux États-Unis | [tailorbrands.com](https://tailorbrands.com) | 2026-11-06 |
| Canva (kit de marque, IA) | *Non vérifié* : page refusée à mes deux outils de lecture. Les comparatifs disent que le kit de marque demande un abonnement payant. | Écosystème | Pas de source primaire | [comparatif Dorik](https://dorik.com/blog/best-ai-tools-for-branding) | 2026-11-06 |
| Pomelli (Google Labs) | « Easily generate on-brand content for your business. » C'est la seule ligne lisible de la page. | Distribution Google | Reste non vérifié | [labs.google.com](https://labs.google.com/pomelli/about/) | 2026-11-06 |

**b. Stratégie de marque (le document)**

| Nom | Ce qu'il promet, et sur quel ton | Forces | Limites | Source | Vérifié |
|---|---|---|---|---|---|
| BrandGap.AI | Lancé le 26 juin 2026. Cartes de territoires, douze archétypes, analyse de ton, écarts de positionnement, piliers de message. « Des jours de recherche en quelques minutes », base de plus de 1 200 marques. Se présente comme un soutien aux stratèges. À partir de 199 $ par analyse. Efficace, appuyé sur les preuves. | Le plus proche de ta méthode (benchmark, territoires) | Un rapport sur le web, sans lien avec le projet ensuite | [TechIntelPro](https://techintelpro.com/news/marketing/ai/brandgapai-launches-ai-platform-for-fast-brand-positioning-analysis) (communiqué) | 2026-11-06 |
| Servo, BrightMyBrand, Brand Strategy Kit | D'après des résumés de recherche : livre de marque pour fondateurs, guides en PDF, modèles de positionnement et de voix. | Ciblent les fondateurs | *Non vérifiés* : pages primaires refusées ou non ouvertes | recherche web du 2026-11-06 | 2026-11-06 |
| Kits de prompts pour ChatGPT ou Claude | Séances guidées vendues une dizaine de dollars. | Peu cher | *Non vérifié* : non ouvert | recherche web du 2026-11-06 | 2026-11-06 |

**c. Les « agences » IA (l'exécution marketing)**

| Nom | Ce qu'il promet, et sur quel ton | Forces | Limites | Source | Vérifié |
|---|---|---|---|---|---|
| MarkGrid (Two99) | Lancé le 13 mai 2026. « 650+ AI agents », coût d'acquisition en baisse de plus de 15 % en 90 jours, contenu x10. Son fondateur dit que le modèle d'agence est « structurellement remplacé ». Bruyant, chiffré, contre les agences. | Échelle, grandes entreprises | Du marketing en exploitation, pas de la création de marque ; chiffres annoncés par l'éditeur | [Campaign India](https://www.campaignindia.in/article/two99-launches-ai-native-marketing-platform-markgrid/4vcad26373d905r263cx6qvmws) | 2026-11-06 |
| MarkBase AI | Annoncé le 15 avril 2026. Jusqu'à 60 % de gaspillage opérationnel en moins, campagnes pilotées par commandes écrites. Ton de « disrupteur ». | Exécution depuis un chat | Ni stratégie ni voix de marque ; accès anticipé | [Newswire](https://www.newswire.com/news/the-agency-killer-why-a-marketing-veteran-built-the-ai-platform-22763607) (communiqué) | 2026-11-06 |

Je n'ai trouvé aucun produit qui fasse à la fois ces trois choses : construire une stratégie et une voix de marque, les garder en fichiers lisibles dans le projet de l'utilisateur, puis s'en servir pour vérifier les textes et construire le produit. Ce n'est pas une preuve qu'il n'existe pas : ma recherche était limitée.

### Ce que personne ne tient

- **La marque comme dossier vivant dans le projet.** Les outils de branding livrent un PDF ou un kit ; BRACE écrit les fichiers à côté du code et l'IA les relit.
- **La stratégie et la voix, pas seulement le logo.** Les pages des outils de logo en parlent à peine.
- **Le calme à la place des chiffres.** Les « agences » IA crient des chiffres et « remplacent l'agence ». Tu refuses la surenchère : ce contraste est libre.
- **Un rythme humain.** Réunions, documents, validation, face à « un logo tout de suite » ou « en quelques minutes ». Seul BrandGap.AI dit soutenir des stratèges, et il vend un rapport, pas un déroulé avec le client.
- **Toujours libres depuis le 19 octobre** : la mémoire lisible, le projet qui reste propre, le portfolio de tous les projets avec un vrai suivi, le ton calme, la boîte à outils courte.
- **Moins libre qu'avant** : « partagé entre agents » (claude-mem le revendique maintenant).

## 2. Ce que dit le public : plusieurs projets concrets à mener

Les citations viennent de deux fils de discussion d'Indie Hackers (lus le 6 novembre 2026) et de Hacker News. Je donne un rôle, jamais un nom. Beaucoup d'auteurs d'Indie Hackers présentent leur propre outil de mémoire : je les marque « bâtisseur ». Ce ne sont pas des échantillons représentatifs. Rouvre le lien avant tout usage public.

- Fil A : [How do you handle the fact that your AI forgets everything between sessions?](https://www.indiehackers.com/post/how-do-you-handle-the-fact-that-your-ai-forgets-everything-between-sessions-03d215aa82)
- Fil B : [How are you handling memory and context across AI tools?](https://www.indiehackers.com/post/how-are-you-handling-memory-and-context-across-ai-tools-fb5bfc470a)

### L'oubli, en mots d'entrepreneur

> "Every time I start a new session with ChatGPT or Claude, I'm back to square one."

Fondateur, bâtisseur (il crée un agent à mémoire). 1er avril 2026. Fil A.

> "this feels exactly like hiring a brilliant consultant who gets amnesia every Monday morning."

Consultant en organisation pour petites entreprises. 1er avril 2026. Fil A.

> "I work with AI tools daily for content and every new session I'm basically onboarding the same assistant from scratch. Copy pasting the same brand guidelines, the same tone rules, the same product details. It works but it's dumb."

Personne qui produit du contenu. 26 avril 2026. Fil B.

> "I'm a researcher building a SaaS tool on the side — 1-2 hours a day after work — and the biggest overhead isn't coding, it's re-explaining context to AI every session."

Chercheur qui lance un outil à côté. 25 avril 2026. Fil B.

### Les notes qu'on tient à la main ne durent pas

> "Giant paste-docs died because I never updated them."

Créateur de produit. 10 septembre 2026. Fil A.

> "the moment you stop maintaining that doc tho everything goes sideways, the AI starts suggesting stuff you already tried and rejected 3 weeks ago"

Porteur d'un projet à côté. 2 mai 2026. Fil B.

> "The painful part is maintaining them manually. After a big session I have to remember to update Project_History.md or the next session is missing critical context. I've forgotten a few times and paid for it."

Créateur d'un SaaS. 26 avril 2026. Fil B.

### Plusieurs projets à la fois

> "It works for small sets of projects, but it doesn't scale and breaks down when switching between multiple active things throughout the day."

Créateur de produit. 26 avril 2026. Fil B.

> "Mental exhaustion when working on multiple different projects/agent sessions is real"

Développeur, Hacker News. 15 mars 2026. [Lien](https://news.ycombinator.com/item?id=47392043) (relevé du 19 octobre).

### La confiance : on vérifie tout

> "the failure mode isn't "tool forgot", it's "tool remembers a stale fact"."

Développeur qui gère une quinzaine d'applications. 27 avril 2026. Fil B.

> "context gets silently wrong. You re-feed it, the assistant confirms it, and then three prompts later it's drifted back to a stale assumption."

Bâtisseur d'un outil de spécifications. 25 avril 2026. Fil B.

> "Once you get burned by one "we've updated context handling" email, you learn pretty fast."

Créateur qui garde son contexte dans ses propres fichiers. 26 avril 2026. Fil B.

### Le désordre et le décalage

> "these projects reach a point where it's just a swirling mess of pieces duct taped together in a way that passes tests."

Développeur, à propos de projets construits par IA. 4 juin 2026. [Lien](https://news.ycombinator.com/item?id=48392461).

> "It kept missing documents and reprocessing the same ones over and over again."

Développeur, à propos de l'outil d'un collègue non technique. 17 mai 2026. [Lien](https://news.ycombinator.com/item?id=48170241).

> "they'll change caveats into hard rules"

Utilisateur d'application de chat. 15 septembre 2026. [Lien](https://news.ycombinator.com/item?id=49719165) (relevé du 19 octobre).

### Ce que cela veut dire pour BRACE

- Le public élargi n'a pas un autre problème, il a d'autres mots : « onboarder », « consultant amnésique », « mes consignes de marque à recoller ». La promesse peut garder son fond et changer ses exemples.
- La plainte la plus répétée est la note qu'on oublie de mettre à jour. Elle soutient « tenu à jour sans y penser » plutôt que « se souvient ».
- Deux voix craignent l'erreur silencieuse. Elles soutiennent une mémoire lisible, modifiable, et « il demande quand il ne sait pas ».
- Le désordre est surtout décrit par des observateurs, à propos du travail d'autres personnes. Je n'ai pas trouvé de non-développeur disant, à la première personne, « mon IA laisse mon projet en désordre ». Sur le décalage entre ce qu'on demande et ce qu'on obtient, les voix sont rares aussi.

## 3. La marque actuelle

### Où BRACE apparaît aujourd'hui (vérifié le 6 novembre 2026)

| Lieu | Ce qu'on y trouve | Source |
|---|---|---|
| Dépôt GitHub `doui445/brace` | Public, licence MIT, créé le 28 août 2026. 1 étoile, 0 fourche, 0 ticket ouvert. Ni description, ni sujets, ni site. | [API GitHub](https://api.github.com/repos/doui445/brace) |
| Étiquettes de version | 19 étiquettes, de v0.1.0 à v1.0.0. Je n'ai pas pu confirmer l'existence de « releases » GitHub avec notes. | [API GitHub](https://api.github.com/repos/doui445/brace/tags) |
| README public (branche principale) | Titre BRACE, la signature « Barely Remarkable, Admittedly Capable Engine » et « formerly project-tracker », puis le suivi et le portfolio. Il ne parle ni de la compétence de marque ni de « Finally on the same page. ». Il diffère du README de la branche de travail : la vitrine est en retard sur le travail. Lu par un outil de résumé, à revérifier à l'œil. | [dépôt](https://github.com/doui445/brace) |
| Place de marché Claude Code | Le fichier du dépôt liste deux plugins : `brace` 1.0.0 et la passerelle `project-tracker` 0.14.0. L'installation passe par une place de marché tierce. Je n'ai trouvé BRACE dans aucun annuaire ni liste officielle. | fichier `.claude-plugin/marketplace.json` du dépôt |
| Antigravity | Installation par l'adresse du dépôt. Aucune fiche trouvée. | README du dépôt |

### Comment on en parle

Je n'ai rien trouvé. Recherches faites le 6 novembre 2026 : « doui445 » et « project-tracker claude plugin » sur Hacker News (0 résultat), recherches web sur le dépôt et sur la signature complète (aucune page), recherche GitHub de dépôts qui citent le compte (rien). La recherche dans le code de GitHub demande une connexion : les mentions dans d'autres dépôts ne sont pas vérifiées.

Conséquence : le point de départ de ton indicateur « recommandations spontanées » est zéro, et il n'y a aucune opinion publique à corriger. Le rebranding part d'une page blanche.

### Où l'ancien nom « project-tracker » se voit encore

- **En public** : l'entrée `project-tracker` 0.14.0 (la passerelle) dans le fichier de la place de marché ; la mention « formerly project-tracker » du README. Le nom était générique : une recherche GitHub sort plusieurs plugins sans lien avec toi qui portent le même nom ([recherche GitHub](https://api.github.com/search/repositories?q=project-tracker+claude+code+plugin&per_page=10), 6 novembre 2026). Il n'a jamais été distinctif.
- **Dans le dépôt, à décider** : la ligne « Formerly project-tracker. » et la section « Coming from project-tracker » du README ; la description du fichier de la place de marché, qui parle de la passerelle ; le champ `project: project-tracker` du fichier d'état, que le portfolio affiche pour BRACE lui-même ; quelques lignes du guide interne et un commentaire du fichier d'exclusion.
- **Dans le dépôt, à garder** : tout ce qui sert la migration des anciens utilisateurs (le plugin passerelle, qui est gelé, les scripts de migration et leurs tests, la reconnaissance de l'ancien dossier `docs/project-tracker/`). Ce sont des fonctions, pas des restes.
- Le dossier de travail local s'appelle encore `project-tracker`. Il n'est pas public.

## Ce que je n'ai pas pu vérifier

- Canva, Servo, BrightMyBrand, Brand Strategy Kit, Pomelli (détail), Automata Studio, la fonction « Brand Voice 2.0 » d'Attentive : pages refusées, rendues par script, ou connues seulement par un résumé de recherche.
- Le plugin marketing d'Anthropic : je n'ai vu que sa description, pas ses fichiers.
- Les étoiles sont celles de l'API GitHub le 6 novembre 2026. Le niveau 3 n'a pas été revérifié depuis le 19 octobre.
- Le public : des créateurs et des bâtisseurs, pas un échantillon. Reddit n'est pas accessible depuis mon environnement. Je n'ai pas trouvé de voix à la première personne sur le désordre.
- Si des « releases » GitHub existent, et si le README public est exactement tel que résumé.
- Les mentions de BRACE dans le code d'autres dépôts et sur les réseaux sociaux.
- Ceci est un relevé, pas un avis juridique ; aucune vérification de disponibilité de nom n'était demandée.
