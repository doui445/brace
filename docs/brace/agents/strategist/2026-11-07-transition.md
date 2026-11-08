---
title: Plan de transition
author: Chloé
role: stratège
lang: fr
meeting: 4
date: 2026-11-07
---

## En bref

Tu as choisi un **repositionnement** : le nom BRACE reste, la promesse et le
public changent. Il n'y a donc **pas de renommage** : ni le dépôt GitHub, ni
le plugin, ni la migration des anciens utilisateurs ne bougent. La
transition tient en quatre listes, dans cet ordre :

1. ce que l'agence fait elle-même dans le dépôt ;
2. ce qui demande ta confirmation, parce que c'est public ;
3. ce que tu fais en dehors du dépôt ;
4. les nouveaux prénoms de l'équipe, qui entrent en dernier.

Chaque ligne dit le fichier, ce qu'il dit aujourd'hui, et ce qu'il dira. Les
textes viennent tous de la [charte éditoriale](2026-11-07-editorial-guide.html)
(le fichier de voix `VOICE.md`). Nous n'en écrivons aucun nouveau ici.

Règles tenues partout : rien de public sur ce qui n'est pas livré (le design
à venir, les autres compétences à venir, la reprise de documents), la limite
sur la vie privée mot pour mot si elle apparaît, et Antigravity toujours cité
en second : « pour Claude Code, fonctionne aussi avec Antigravity ».

## 1. Ce que l'agence fait elle-même

Chaque modification est montrée avant d'être faite, et enregistrée une fois
que tu as validé (la publication suit ta règle d'enregistrement habituelle).

### La page d'accueil du dépôt

Fichier : `README.md`.

| Ligne | Aujourd'hui | Ce qui change |
|---|---|---|
| 3 | « Finally on the same page. » | Reste. Elle est déjà en place |
| 5 à 6 | « Your AI forgets your project between sessions, and you explain it again. Every time. » | Remplacé : voir le haut du README tel qu'il se lira |
| 8 à 12 | « BRACE turns your AI into a real assistant for your projects. It's a free, open-source plugin for Claude Code and Antigravity. It keeps your project's memory… » | Remplacé : voir le haut du README |
| 14 à 15 | « Its skills share that memory. Track follows your projects, brand gives them a voice and a strategy, and **design is on its way**. » | Remplacé, et la mention du design à venir **sort** : voir le haut du README |
| 17 à 18 | « Pick up where you left off. Keep your project clean. Follow a summary of all your projects on a single page. » | Remplacé : voir le haut du README |
| 99 à 100 | « Claude Code or Antigravity — that's the only hard requirement. » | Réécrit : voir la ligne de prérequis dans le même texte |

Les textes eux-mêmes sont écrits par David, avec le haut du README tel qu'il
se lira : [textes de la page d'accueil](2026-11-07-front-page-texts.html).
Ce plan ne les redécrit pas : tu valides ce texte, pas un tableau
d'intentions.

### La mention « formerly project-tracker »

- **Aujourd'hui** : `README.md` ligne 20, « Formerly project-tracker. »
- **Demain** : elle reste, **seule**, à la ligne 20 du README (règle de la
  plateforme, partie 9). Aucune autre page ne parle de l'ancien nom : ni les
  descriptions, ni les nouvelles de la version dans le README, ni les notes de
  version, ni l'annonce.
- **Combien de temps** : *proposition de notre part*, jusqu'à la revue de six
  mois (mai 2027). On la retire alors, avec la section ci-dessous. À toi de
  confirmer, ou de choisir une autre date.

La section « Coming from project-tracker » (`README.md` lignes 47 à 58) n'est
pas une mention « formerly » : c'est le mode d'emploi pour qui a encore
l'ancien plugin. Elle cite l'ancien nom six fois, parce qu'elle doit. Elle
**reste** tant que des gens peuvent encore avoir l'ancien plugin (règle de
zéro rupture). Elle part en même temps que la mention de la ligne 20.

### Les descriptions affichées à l'installation

| Fichier | Ligne | Aujourd'hui | Ce qui change |
|---|---|---|---|
| `.claude-plugin/plugin.json` | 3 | « BRACE turns your AI into a real assistant for your projects: it remembers, keeps them clean and professional, and follows them all. For Claude Code and Antigravity. » | La description de la charte (anglais) : voir le [texte de David](2026-11-07-front-page-texts.html) |
| `plugin.json` (racine, Antigravity) | 3 | Le même texte | La même description : même page |
| `.claude-plugin/marketplace.json` | 11 | Le même texte (entrée `brace`) | La même description : même page |
| `.claude-plugin/marketplace.json` | 6 | « BRACE, a real assistant for your projects in Claude Code and Antigravity, and the project-tracker bridge that installs it. » | Réécrit : voir la même page |

**À ne pas toucher.** `.claude-plugin/marketplace.json` lignes 15 à 18 (l'entrée
du plugin passerelle : « project-tracker is now BRACE. This final release
installs brace for you. ») et `bridge/.claude-plugin/plugin.json` ligne 4. Le
plugin passerelle est publié, il fait la migration, et il dit déjà la bonne
chose.

**La version.** Les trois fichiers affichent `1.0.0` (`.claude-plugin/plugin.json`
ligne 4, `.claude-plugin/marketplace.json` ligne 12, `plugin.json` racine).
Les nouvelles descriptions n'arrivent chez les utilisateurs qu'avec une
version publiée. La prochaine est **1.1 (à confirmer à la sortie)**, comme
dans l'annonce. *À compléter :* sa date. Les trois fichiers restent égaux.

### Les restes d'avant qui contredisent la nouvelle voix

Relevé du dépôt, hors dossier `docs/`. Il est court :

- `README.md` ligne 15, « design is on its way » (déjà dans le tableau
  ci-dessus).
- `README.md` lignes 8 à 12 et les descriptions des trois manifestes :
  « it remembers » et « real assistant » parlent de mémoire, l'ancienne
  promesse (audit, partie 4).
- `README.md` ligne 9 et ligne 99 : « Claude Code and Antigravity » côte à côte.
- `docs/brace/STATUS.md` ligne 2, `project: project-tracker` : **on ne le
  change pas**. La règle du fichier est que cette valeur est le nom du
  dossier, et le dossier s'appelle encore ainsi. Voir « À décider »
  plus bas.

Deux choses ne sont pas des restes à effacer :

- `docs/brace/brand/VOICE.md`, partie « Earlier texts » : deux textes d'avant,
  dont l'un contient « design is on its way ». Ils sont gardés comme archive,
  pas comme modèles.
- Les scripts de migration dans `skills/track/hooks/` citent `project-tracker`
  pour trouver les anciens dossiers. C'est leur travail.

*Ce que nous n'avons pas relu :* les messages que BRACE affiche pendant une
séance. Ils sont la voix aussi, mais dispersés dans le code ; ils sont
vérifiés à la main aux revues, et pas par ce plan.

## 2. Ce qui demande ta confirmation (c'est public)

Rien ne part sans que tu aies dit oui.

### La description du dépôt GitHub et ses sujets

Le dépôt `doui445/brace` n'a aujourd'hui **ni description ni sujets ni site**
(recherche de Bruno, 6 novembre).

- **Description.** Nous proposons la description de la charte, mot pour mot
  (environ 275 caractères, sous la limite de GitHub). L'agence la pose avec
  `gh repo edit` après ton accord.
- **Sujets.** *Proposition de notre part, non relevée dans un fait :*
  `claude-code`, `claude-code-plugin`, `ai-agent`, `project-tracking`. Bruno
  vérifie d'abord que ces sujets existent et sont utilisés.
  Antigravity est cité dans la description, pas dans les sujets : un sujet
  n'a pas de rang, et il mettrait les deux au même niveau.
- **Site.** Il n'existe pas. On ne met pas d'adresse.

### Ce qui devient public

- Le `README.md` et les manifestes, à l'enregistrement, selon ta règle de
  publication.
- Les notes de la version, quand elle sort : David les écrit avec
  l'annonce, pour la version 1.1 (à confirmer à la sortie).

## 3. Ce que tu fais en dehors du dépôt

- **Lancer le test.** Envoyer la page aux 5 à 10 personnes
  ([plan de test](2026-11-07-test-plan.html)).
- **Publier l'annonce**, une fois la version sortie et l'annonce validée. Elle
  remplace le court message du 21 octobre, qui parle encore de mémoire et met
  les deux agents côte à côte.
- **Les profils et publications qui présentent BRACE.** *À compléter :*
  lesquels existent. Nous n'en avons trouvé aucun dans nos recherches
  (aucune mention de BRACE, benchmark partie 3), mais nous ne voyons pas tes
  comptes. S'il y en a, chacun est repris avec la description de la charte.
- **Le site.** Prévu, non commencé : rien à faire pour l'instant.
- **Les entretiens.** Le guide d'Alice est prêt ; ils ne sont pas dans la
  transition, mais ils nourrissent la revue de six mois.
- **Dire merci** aux personnes du test, et revenir vers celles qui ont laissé
  une adresse.

**Le nom BRACE : vérifié.** Bruno a fait la vérification
([note](2026-11-07-names-check-4.html)). Verdict : *doute mineur*, rien ne
bloque. Il n'a trouvé aucun plugin, outil ou marque BRACE dans cette
catégorie. Le nom `brace` seul est pris sur npm et sur PyPI par des projets
sans rapport. La place de marché officielle de Claude Code, Homebrew et
`@brace` sont libres. Il n'a **pas** vérifié Antigravity, VS Code ni les
places de marché communautaires. C'est une vérification, pas un avis
juridique. Le plan reste donc valable tel quel.

## 4. Les nouveaux prénoms de l'équipe

Tu as choisi Julie, Ravi, Constance, Ben et Lou au rendez-vous 2. Ils entrent
**à la livraison**, **en dernier**, une fois la mission fermée, pour que les
documents de ce rendez-vous restent signés de façon cohérente.

| Rôle | Aujourd'hui | Demain |
|---|---|---|
| Directrice de clientèle | Alice | Julie |
| Analyste | Bruno | Ravi |
| Stratège | Chloé | Constance |
| Rédacteur | David | Ben |
| Directrice de création | Emma | Lou |

Les rôles ne changent pas. Source du tableau : compte rendu du rendez-vous 2.

**Où ils vivent.** Dans le catalogue des textes :

- `skills/track/references/i18n/en.md`, lignes 192 à 201 : les clés
  `brand.team.brand`, `brand.team.analyst`, `brand.team.strategist`,
  `brand.team.copywriter` et `brand.team.creative_director`, chacune avec son
  `.name` et son `.role`.
- `skills/track/references/i18n/fr.md`, lignes 186 à 195 : les mêmes dix clés.

Dix lignes par fichier, vingt en tout. Seuls les `.name` changent, jamais les
`.role`, et les clés restent telles quelles. Les agents et les documents les
lisent dans ce catalogue, nulle part ailleurs.

Deux doutes sont déjà notés : Julie (une assistante de planning IA porte ce
nom en France, vérification de Bruno) et Ravi (un petit outil d'agents IA, compte
rendu du rendez-vous 2). Ils ne bloquent pas.

Deux autres endroits en dépendent, mais se règlent d'eux-mêmes :

- Les fichiers `BRIEF.md` de chaque agent, dans `docs/brace/agents/`, citent
  les prénoms provisoires. Chaque agent les met à jour à sa prochaine mission.
- `skills/brand/scripts/test_render.py` (lignes 18, 99, 101 et 113) utilise
  « Bruno » comme exemple dans un test. C'est un jeu d'essai, pas un texte de
  marque : il peut rester.

**Les documents déjà rendus** (plateforme, charte, manifeste, procès-verbaux)
sont signés des prénoms d'alors. Nous proposons de les laisser tels quels :
ils ont été validés ainsi, et ils sont l'archive du travail. Si tu préfères les
refaire, dis-le.

## 5. À décider avec toi

- **Le dossier du projet.** Le dossier s'appelle encore `project-tracker`.
  C'est un reste de l'ancien nom, mais le nom BRACE ne change pas dans ce
  repositionnement, et le renommer n'est pas dans la mission. Si tu veux le
  faire, c'est la toute dernière action de la session, avec la commande de
  secours (BRACE tourne depuis ce dossier). Il fait aussi passer
  `project:` de `STATUS.md` à `brace`, et le portfolio avec lui. *Notre avis :*
  pas maintenant, une décision séparée.
- **La date où la mention « formerly project-tracker » part.** Proposition :
  la revue de six mois.
- **Les documents signés des anciens prénoms** : les laisser, ou les refaire.

## Ordre et calendrier

| Quand | Quoi | Qui |
|---|---|---|
| Au rendez-vous 4 | Tu valides ce plan, le plan de test, l'annonce et la phrase en place sur la page d'accueil | Toi |
| Juste après | Les modifications des listes 1 (page d'accueil, mention, descriptions) | L'agence |
| Le soir même ou le lendemain | Le test, envoyé à 5 à 10 personnes | Toi |
| À la sortie de la version | Description et sujets GitHub, notes de version, annonce | L'agence (après ton oui) et toi |
| En dernier, une fois la mission fermée | Les cinq prénoms dans les deux catalogues | L'agence |
| Revue de six mois (mai 2027, *à confirmer*) | Retrait de « formerly project-tracker » et de la section d'accueil de l'ancien plugin ; relecture de la voix | L'agence et toi |

*À compléter :* la date de la version (1.1, à confirmer à la sortie), l'outil du
formulaire de test.
