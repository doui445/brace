---
title: Les textes en place
author: David
role: rédacteur
lang: fr
meeting: 4
date: 2026-11-07
---

Voici les textes exacts que la page d'accueil du dépôt et les fiches d'installation afficheront, tels qu'ils se liraient en place. Pour chaque ligne, le texte actuel, puis le nouveau. Ils sont en anglais, la langue de la marque. Aucun fichier du dépôt n'est modifié avant ta validation.

Les lignes viennent du [plan de transition](2026-11-07-transition.html). La description, la phrase d'appui et la phrase de marque sont reprises mot pour mot de la charte éditoriale. Rien n'est annoncé qui ne soit pas livré, et Antigravity vient toujours en second.

## La page d'accueil (README.md)

### Lignes 5 et 6, la situation de départ

Actuel :

> Your AI forgets your project between sessions, and you explain it again.
> Every time.

Nouveau :

> Monday morning. You paste in the same instructions as last week, and you are not sure which of your notes is still true.

### Lignes 8 à 12, la description

Actuel :

> BRACE turns your AI into a real assistant for your projects. It's a free,
> open-source plugin for Claude Code and Antigravity. It keeps your project's
> memory in files you can read: where you stand, what was decided, what comes
> next. It keeps them up to date, suggests the right tools when they help, and
> tells you when it doesn't know.

Nouveau (mot pour mot de la charte) :

> BRACE turns your AI agent into an assistant you can agree with: it reads your project first, asks only what it can't know, writes down what you decide in files you can read, and keeps all your projects on one page. A free plugin for Claude Code, it also works with Antigravity.

### Lignes 14 et 15, les compétences

Actuel :

> Its skills share that memory. Track follows your projects, brand gives them a
> voice and a strategy, and design is on its way.

Nouveau (le design à venir sort, et « memory » aussi) :

> Track follows your projects. Brand writes down your project's voice and strategy, after meetings where you validate each document.

### Lignes 17 et 18, la phrase d'appui

Actuel :

> Pick up where you left off. Keep your project clean. Follow a summary of all
> your projects on a single page.

Nouveau (mot pour mot de la charte) :

> It asks. It writes it down. You decide.

### Ligne 20, la mention de l'ancien nom

Actuel et nouveau, inchangée. C'est la seule mention de l'ancien nom dans les textes publics.

> Formerly project-tracker.

### Lignes 99 et 100, ce qu'il faut

Actuel :

> - **Claude Code** or **Antigravity** — that's the only hard requirement.

Nouveau :

> - **An AI agent on your computer.** BRACE is a plugin for Claude Code, and it also works with Antigravity. Without an agent, it has nothing to run in. It is the only hard requirement.

### La première page, lue d'un trait

Une fois les lignes en place, le haut du README se lit ainsi :

> # BRACE
>
> **Finally on the same page.**
>
> Monday morning. You paste in the same instructions as last week, and you are not sure which of your notes is still true.
>
> BRACE turns your AI agent into an assistant you can agree with: it reads your project first, asks only what it can't know, writes down what you decide in files you can read, and keeps all your projects on one page. A free plugin for Claude Code, it also works with Antigravity.
>
> Track follows your projects. Brand writes down your project's voice and strategy, after meetings where you validate each document.
>
> It asks. It writes it down. You decide.
>
> Formerly project-tracker.

## Les descriptions affichées à l'installation

### .claude-plugin/plugin.json, ligne 3 (Claude Code)

Actuel :

> BRACE turns your AI into a real assistant for your projects: it remembers, keeps them clean and professional, and follows them all. For Claude Code and Antigravity.

Nouveau (la description de la charte, mot pour mot) :

> BRACE turns your AI agent into an assistant you can agree with: it reads your project first, asks only what it can't know, writes down what you decide in files you can read, and keeps all your projects on one page. A free plugin for Claude Code, it also works with Antigravity.

### plugin.json à la racine, ligne 3 (Antigravity)

Actuel : le même texte que ci-dessus. Nouveau : la même description, mot pour mot.

### .claude-plugin/marketplace.json, ligne 11 (l'entrée brace)

Actuel : le même texte que ci-dessus. Nouveau : la même description, mot pour mot.

### .claude-plugin/marketplace.json, ligne 6 (la place de marché)

Actuel :

> BRACE, a real assistant for your projects in Claude Code and Antigravity, and the project-tracker bridge that installs it.

Nouveau :

> BRACE, a plugin for your AI agent: it asks, writes down what you decide, and keeps all your projects on one page. For Claude Code, it also works with Antigravity. This marketplace also carries the update for people coming from the earlier plugin.

La ligne 6 ne cite plus l'ancien nom : la seule mention reste celle du README. L'entrée de la passerelle (lignes 15 à 18) n'est pas touchée.

### La version

Les trois fichiers affichent 1.0.0. Les nouvelles descriptions n'arrivent chez les gens qu'avec une version publiée : 1.1 (hypothèse, à confirmer à la sortie).

## Avant, en français

Ce texte sert au plan de test : il faut la version française de la présentation d'avant, pour la comparer à la nouvelle. C'est une proposition de traduction du texte anglais du 22 octobre, que tu valides. Le français cherche l'expression qui existe, il ne calque pas. Ce texte n'est pas à publier : il garde « design arrive » parce que l'original le disait, et c'est justement ce que le test compare.

### La phrase de marque

> Enfin sur la même page.

### La description d'avant

> BRACE fait de ton IA un vrai assistant pour tes projets. C'est un plugin libre et open source pour Claude Code et Antigravity. Il garde la mémoire de ton projet dans des fichiers que tu peux lire : où tu en es, ce qui a été décidé, ce qui vient ensuite. Il les tient à jour, te propose les bons outils quand ils aident, et te dit quand il ne sait pas.

### Le texte de présentation d'avant, en entier

> Ton IA oublie ton projet d'une session à l'autre, et tu le lui réexpliques. À chaque fois.
>
> BRACE fait de ton IA un vrai assistant pour tes projets. C'est un plugin libre et open source pour Claude Code et Antigravity. Il garde la mémoire de ton projet dans des fichiers que tu peux lire : où tu en es, ce qui a été décidé, ce qui vient ensuite. Il les tient à jour, te propose les bons outils quand ils aident, et te dit quand il ne sait pas.
>
> Ses compétences partagent cette mémoire. Track suit tes projets, brand leur donne une voix et une stratégie, et design arrive.
>
> Reprends là où tu t'étais arrêté. Garde ton projet propre. Suis le résumé de tous tes projets sur une seule page.

## Ce que tu peux vérifier

| Le texte dit | Ce qui le soutient |
|---|---|
| Les textes actuels cités | les lignes du `README.md`, de `.claude-plugin/plugin.json`, de `plugin.json` et de `.claude-plugin/marketplace.json`, aux numéros indiqués |
| La description, la phrase d'appui et la phrase de marque sont mot pour mot ceux de la charte | `docs/brace/brand/VOICE.md`, partie « Tagline and boilerplate » |
| Le texte d'avant en français traduit l'anglais du 22 octobre | `docs/brace/brand/VOICE.md`, partie « Earlier texts », « Presentation text » |
| Brand écrit la voix et la stratégie du projet après des rendez-vous validés | `docs/brace/brand/` et `docs/brace/agents/brand/` dans ce dépôt |
| Il faut un agent IA sur l'ordinateur | ce que BRACE est : un plugin |
