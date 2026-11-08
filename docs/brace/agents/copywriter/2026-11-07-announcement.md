---
title: L'annonce
author: David
role: rédacteur
lang: fr
meeting: 4
date: 2026-11-07
---

L'annonce dit le repositionnement de BRACE en trois textes : la note de version GitHub, le paragraphe d'actualité du README, et un court post pour les réseaux. Le nom ne change pas. Chaque texte est écrit en anglais, la langue de la marque, puis en français, en deux blocs séparés. L'ancien nom n'y figure pas : la seule mention « Formerly project-tracker. » reste celle du README, ligne 20.

Tout ce qui est annoncé est livré. Rien sur le design à venir, rien sur la vie privée au-delà de la limite validée, aucune comparaison avec d'autres outils.

## La note de version GitHub

### English

**BRACE 1.1: Finally on the same page.**

BRACE 1.1 adds brand: your project's voice and strategy, written down like the rest of your project.

BRACE turns your AI agent into an assistant you can agree with: it reads your project first, asks only what it can't know, writes down what you decide in files you can read, and keeps all your projects on one page. A free plugin for Claude Code, it also works with Antigravity.

It asks. It writes it down. You decide.

**What changes for you**

- `brace:brand` asks about your project, then writes its foundations, strategy and voice in plain files in `docs/brace/brand/`. You can read, correct or delete them.
- It works in meetings. A workshop on a brief it pre-fills from your project, a presentation of the possible routes, then each document shown to you, one at a time. Nothing moves on until you validate it. Each meeting ends with written minutes.
- If your project already has a brand, it archives it first, audits it, and lets you decide how far to go: a refresh, a repositioning or a new name.
- The texts you list as public (README, descriptions) are checked against the voice you chose.

BRACE was repositioned this way. The meetings, the documents and the decisions are in `docs/brace/` in this repository, for you to read.

**What does not change**

- The name: BRACE.
- Tracking, decisions written down, and all your projects on one page.
- It saves and publishes only what you have approved. It publishes nothing to GitHub without your confirmation.
- It is free and open source (MIT). It needs an AI agent on your computer.

**Update**

Update the plugin the way you installed it. Your projects stay as they are. [Update commands: to fill in.]

### Français

**BRACE 1.1 : Enfin sur la même longueur d'onde.**

BRACE 1.1 ajoute la marque : la voix et la stratégie de ton projet, écrites comme le reste de ton projet.

BRACE fait de ton agent IA un assistant avec qui tu es d'accord : il lit d'abord ton projet, ne demande que ce qu'il ne peut pas savoir, écrit ce que tu décides dans des fichiers que tu peux relire, et garde tous tes projets sur une seule page. Un plugin libre et gratuit pour Claude Code, il fonctionne aussi avec Antigravity.

Il demande. Il écrit. Tu décides.

**Ce qui change pour toi**

- `brace:brand` te pose des questions sur ton projet, puis écrit ses fondations, sa stratégie et sa voix dans des fichiers simples, dans `docs/brace/brand/`. Tu peux les lire, les corriger ou les supprimer.
- Il travaille en rendez-vous. Un atelier sur un brief qu'il préremplit à partir de ton projet, une présentation des pistes possibles, puis chaque document t'est montré, un à la fois. Rien n'avance tant que tu n'as pas validé. Chaque rendez-vous se termine par un compte rendu écrit.
- Si ton projet a déjà une marque, il l'archive d'abord, en fait l'audit, et te laisse décider jusqu'où aller : un rafraîchissement, un repositionnement ou un nouveau nom.
- Les textes que tu désignes comme publics (README, descriptions) sont vérifiés par rapport à la voix que tu as choisie.

BRACE a été repositionné de cette façon. Les rendez-vous, les documents et les décisions sont dans `docs/brace/`, dans ce dépôt, à lire.

**Ce qui ne change pas**

- Le nom : BRACE.
- Le suivi, les décisions écrites, et tous tes projets sur une seule page.
- Il n'enregistre et ne publie que ce que tu as validé. Il ne publie rien sur GitHub sans ta confirmation.
- Il est libre et gratuit (MIT). Il demande un agent IA sur ton ordinateur.

**Mise à jour**

Mets le plugin à jour comme tu l'as installé. Tes projets restent comme ils sont. [Commandes de mise à jour : à compléter.]

## Le paragraphe d'actualité du README

### English

**News.** `brace:brand` is new in BRACE 1.1: it writes your project's voice and strategy in plain files you can read, after meetings where you validate each document. The name stays. So does everything else: tracking, decisions written down, all your projects on one page. It needs an AI agent on your computer. A free plugin for Claude Code, it also works with Antigravity.

### Français

**Actualité.** `brace:brand` arrive avec BRACE 1.1 : il écrit la voix et la stratégie de ton projet dans des fichiers simples que tu peux relire, après des rendez-vous où tu valides chaque document. Le nom reste. Le reste aussi : le suivi, les décisions écrites, tous tes projets sur une seule page. Il demande un agent IA sur ton ordinateur. Un plugin libre et gratuit pour Claude Code, il fonctionne aussi avec Antigravity.

## Le post pour les réseaux

### English

Monday morning. You paste in the same instructions as last week, and you are not sure which of your notes is still true.

BRACE 1.1 adds brand: your project's voice and strategy, written down in files you can read. It asks. It writes it down. You decide.

A free plugin for Claude Code, it also works with Antigravity. It needs an AI agent on your computer.

Finally on the same page.

github.com/doui445/brace

### Français

Lundi matin. Tu recolles les mêmes consignes que la semaine dernière, et tu ne sais plus laquelle de tes notes est encore vraie.

BRACE 1.1 ajoute la marque : la voix et la stratégie de ton projet, écrites dans des fichiers que tu peux relire. Il demande. Il écrit. Tu décides.

Un plugin libre et gratuit pour Claude Code, il fonctionne aussi avec Antigravity. Il demande un agent IA sur ton ordinateur.

Enfin sur la même longueur d'onde.

github.com/doui445/brace

## Ce que tu peux vérifier dans ces textes

Chaque affirmation de l'annonce renvoie à quelque chose que tu peux ouvrir.

| Le texte dit | Ce qui le soutient |
|---|---|
| `brace:brand` écrit les fondations, la stratégie et la voix dans `docs/brace/brand/` | les fichiers `FOUNDATIONS.md`, `STRATEGY.md`, `VOICE.md` et `DECISIONS.md` de ce dépôt, et l'entrée « brand » de `docs/brace/CHANGELOG.md` |
| Il travaille en rendez-vous, avec un compte rendu écrit à chaque fois | les comptes rendus dans `docs/brace/agents/brand/` et `docs/brace/brand/SESSIONS.md` |
| Chaque document t'est montré un à la fois, et rien n'avance sans ta validation | les documents rendus dans `docs/brace/brand/documents/` et les décisions dans `DECISIONS.md` |
| Si ton projet a déjà une marque, il l'archive, l'audite, et tu décides de l'ampleur | l'archive de la marque d'avant, dans `docs/brace/brand/archive/2026-11-06/` (fondations, stratégie, voix et décisions), et la description du repositionnement dans `docs/brace/CHANGELOG.md` |
| BRACE a été repositionné de cette façon | les rendez-vous, les documents et les décisions de cette mission, publics dans `docs/brace/` |
| Les textes publics désignés sont vérifiés par rapport à la voix | la liste des points de contact dans `STRATEGY.md` et la vérification de la voix sur ces fichiers, décrite dans `docs/brace/CHANGELOG.md` |
| Il ne publie rien sur GitHub sans confirmation | le comportement décrit dans le README et `AGENTS.md` (section Git / GitHub) |
| Il est libre et gratuit | la licence MIT du dépôt |
| Il fonctionne avec Claude Code, et aussi avec Antigravity | les deux manifestes à la racine du dépôt (`.claude-plugin/plugin.json` et `plugin.json`) |
| Il demande un agent IA sur ton ordinateur | ce que BRACE est : un plugin |

Le comportement « tu valides chaque document avant qu'il avance » est celui décrit dans la spécification de `brace:brand`. À relire avec le dépôt avant publication.

## Ce que l'annonce ne dit pas

Pas un mot sur le design à venir ni sur les compétences à venir, sur la vie privée, sur la reprise de documents faits par ailleurs, ni sur d'autres outils. Le mot « agence » n'y figure pas. Le mot « honnête » non plus : le texte montre des gestes.

## À compléter

- **La date de publication** de la version et **son numéro** : 1.1 (hypothèse, à confirmer à la sortie). L'annonce ne se publie qu'après la fusion de la branche `feat/brand` et la sortie de la version.
- **Les commandes de mise à jour**, à écrire d'après ce qui est testé à la sortie. Je n'en invente pas.
- **Le lien du post** : l'adresse du dépôt est celle des manifestes. Elle change si le dépôt est renommé.
