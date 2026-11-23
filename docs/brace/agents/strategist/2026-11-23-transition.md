---
title: Plan de transition de ton identité visuelle
author: Constance
role: stratège
lang: fr
doc: transition
phase: delivery
meeting: 6
date: 2026-11-23
---

Ce document dit comment l'identité visuelle de BRACE (le logo, les couleurs, les polices, l'icône d'onglet, l'image de partage) arrive sur chaque endroit où ta marque apparaît. Il donne pour chaque support ce qui change, quand, et qui s'en charge. Les supports sont ceux de ton brief de marque et de la liste des points de contact de la stratégie.

Deux dates seulement structurent la transition. **La remise** est le rendez-vous du 25 novembre, où tu valides les fichiers. **La sortie de la prochaine version** est le jour où ce qui est public change vraiment. Sa date reste à compléter : nous ne l'avons pas.

## Ce qui change et ce qui ne change pas

Le nom BRACE reste, la promesse aussi, et le dossier du projet s'appelle déjà `brace`. **Aucun renommage n'est donc nécessaire**, ni du dossier, ni du dépôt GitHub, ni du plugin. Seule l'apparence change.

Ce que ta marque apporte à chaque support, dans le même vocabulaire partout :

- le logo (l'accolade au-dessus du nom) et ses déclinaisons, dont une version en une seule couleur ;
- le papier chaud et l'encre sombre, avec le pétrole en couleur rare, et un fond sombre pour les endroits sombres ;
- Bricolage Grotesque pour les textes et Commit Mono pour les commandes ;
- l'icône d'onglet, un B dessiné sur la grille de 16 pixels ;
- l'image de partage `og.png`, l'avatar `avatar-500.png` et la feuille de style `brand.css` que les supports peuvent porter.

**Qui met les fichiers dans le projet.** À la remise, si tu es d'accord, l'agence les copie dans le dossier `brand/` à la racine du projet. C'est l'une des décisions que tu prends à ce rendez-vous. Tout le reste s'appuie sur eux.

La mention « Formerly project-tracker. » ne bouge pas : elle reste seule dans le `README.md` jusqu'à la revue de six mois, comme décidé le 8 novembre.

## Les supports, un par un

Le calendrier se lit avec ces mots. **À la remise** : le 25 novembre, rien de public. **À la sortie** : le jour de la sortie de la prochaine version. **Peu à peu** : à chaque fois qu'on touche le support, sans date. **Tel quel** veut dire que rien ne change, et la raison est dite. Le responsable est soit l'agence (dans le dépôt), soit toi (en dehors du dépôt, ou quand la décision publique est la tienne).

### Dans le dépôt

| Support | Ce qui change | Calendrier | Responsable |
|---|---|---|---|
| Espace client de l'agence | Le logo en en-tête, les couleurs et les polices de BRACE à la place de la maison de l'agence et de son vert | À la remise | L'agence |
| Portfolio que BRACE génère | Le logo, le papier et l'encre, le pétrole, l'icône d'onglet à la place du dossier actuel | À la sortie, avec la prochaine version | L'agence |
| `README.md`, la page d'accueil | Le logo en haut de la page, en version claire et sombre. Les textes ne changent pas | À la sortie | L'agence |
| Descriptions des manifestes (`.claude-plugin/plugin.json`, `plugin.json`, `.claude-plugin/marketplace.json`) | Rien : ce sont des textes. Si une liste de plugins offre un jour une place pour une icône, on y met l'avatar | Tel quel | L'agence |
| Descriptions des agents et des compétences | Rien : ce sont des textes, déjà vérifiés à la main aux revues | Tel quel | L'agence |
| Notification macOS | Rien : elle appartient au système | Tel quel | L'agence |
| Documents de marque déjà rendus (plateforme, charte, manifeste, procès-verbaux) | Rien : ils sont l'archive du travail, validés dans leur apparence d'alors | Tel quel | L'agence |
| Documents et présentations à venir | Ils portent `brand.css` dès leur création | Peu à peu | L'agence |

Les messages que BRACE affiche pendant une séance (les questions, les confirmations) restent aussi tels quels : ils sont du texte, pas de l'image, et la voix les couvre déjà.

### En dehors du dépôt

| Support | Ce qui change | Calendrier | Responsable |
|---|---|---|---|
| Avatar du dépôt GitHub (ou du compte qui le publie) | Le fichier `avatar-500.png`, à poser dans les réglages. L'agence fournit le fichier au bon format | À la sortie | Toi |
| Image de partage du dépôt (« social preview ») | `og.png` à téléverser dans les réglages du dépôt. GitHub n'offre pas de commande pour cela, il faut passer par la page des réglages | À la sortie | Toi |
| Description du dépôt et ses sept sujets | Rien : ce sont des textes | Tel quel | Toi, avec l'agence pour toute retouche |
| Notes de version GitHub | Le logo en haut de la première note qui suit la remise, puis chaque note l'a ou non selon le besoin | À la sortie, puis peu à peu | L'agence écrit la note, tu la publies |
| Messages et publications qui présentent BRACE | L'image de partage sur les prochains messages. Les anciens ne sont pas repris | Peu à peu | Toi |
| Profils et réseaux sociaux | Avatar et logo, quand un profil existe. Nos recherches n'en ont trouvé aucun, mais nous ne voyons pas tes comptes : *à compléter par toi* | Peu à peu, à la création | Toi |
| Site | Prévu, pas commencé. Quand ses fichiers existeront, ils partent de `brand.css` et des fichiers de `brand/` | Plus tard | À définir avec toi |
| Listes de plugins à l'installation | Aujourd'hui, ces listes montrent le texte des descriptions. L'avatar y servira seulement si une liste prévoit une icône. *À vérifier à la sortie*, nous ne l'avons pas établi | À la sortie, si possible | Toi, avec l'agence |

L'impression (stickers, t-shirts) est possible plus tard, comme le dit ton brief. La version en une seule couleur du logo existe pour cela, mais aucun code d'impression n'est fixé. Rien à faire maintenant.

## L'ordre des opérations

1. **À la remise.** Si tu es d'accord, l'agence copie les fichiers dans `brand/`, et l'espace client prend la nouvelle apparence. Cela ne touche rien de public.
2. **Avant la sortie.** L'agence prépare le portfolio avec la nouvelle identité et le logo du `README.md`. Tu les relis avant l'enregistrement, comme pour tout ce qui devient public.
3. **À la sortie.** La version part avec le portfolio et le `README.md`. Le même jour, tu poses l'avatar et l'image de partage dans les réglages de GitHub, et la note de version porte le logo.
4. **Les jours suivants.** Tu utilises `og.png` sur les prochains messages. Les profils et le site prennent l'identité visuelle à leur création.

## Le portfolio et l'espace client : adopter la marque ou rester neutres

Ces deux supports sont touchés les premiers, parce qu'ils sont à l'intérieur. Ils portent aujourd'hui la maison de l'agence, avec un accent vert pour l'espace client et ses propres couleurs pour le portfolio. Voici notre recommandation, et c'est toi qui décides.

- **L'espace client adopte la marque** pour ce projet. Il montre ton projet, et ta marque doit s'y voir dès la remise. C'est aussi la façon la plus simple de voir le logo et les couleurs à l'usage avant la sortie.
- **Le portfolio adopte la marque, en gardant ses couleurs d'état.** C'est le premier geste visible de BRACE (« tous tes projets sur une page ») et il est ouvert tous les jours. Il porte le logo, le papier, l'encre, le pétrole et l'icône d'onglet. Les couleurs qui disent l'état d'un projet (en cours, bloqué, en pause) gardent leur rôle : elles servent à lire, pas à décorer.
- **L'autre choix** est de les laisser neutres. Le portfolio resterait alors un outil sans signe distinctif, utile pour tous les projets d'une personne, y compris ceux qui n'ont rien à voir avec BRACE. C'est défendable, mais le premier geste de BRACE y perdrait sa marque.

Si tu choisis la marque, la modification du portfolio change le comportement du plugin : elle part donc avec la prochaine version, jamais en cours de route.

## Ce que tu fais en dehors du dépôt

1. Poser `avatar-500.png` dans les réglages GitHub, à la sortie.
2. Téléverser `og.png` comme image de partage du dépôt, à la sortie.
3. Publier la note de version quand elle est validée.
4. Utiliser l'image de partage sur tes prochains messages.
5. Nous dire quels profils et publications existent, pour que nous les reprenions un par un.

## À décider avec toi

- **Le portfolio et l'espace client** : adopter la marque, ce que nous recommandons, ou rester neutres.
- **La date de la sortie** de la prochaine version : à compléter.
- **Les endroits en dehors du dépôt** : les profils et les publications que tu as, et que nous ne voyons pas.

Le dossier s'appelle déjà `brace`, comme ta marque : il n'y a rien à renommer.
