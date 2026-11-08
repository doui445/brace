---
title: Les personas vérifiés
author: Chloé
role: stratège
lang: fr
meeting: 4
date: 2026-11-08
---

## En bref

**C'est une hypothèse, pas un test.** Aucune vraie personne n'a lu quoi que ce soit. J'ai relu les deux présentations avec les trois personas et avec les recherches de Bruno. Cela oriente, cela ne valide rien. Les décisions de marque noteront « hypothèse, non testée ».

Tu as validé les personas sans les changer. Cette validation dit que tu t'y reconnais, elle ne dit pas qu'ils sont vrais : ils viennent de six proches et de voix en ligne, jamais d'un entretien ([personas](2026-11-06-personas.html)). Ils restent provisoires.

Les deux présentations sont celles du [plan de test](2026-11-07-test-plan.html) : la nouvelle (« Finally on the same page. », « It asks. It writes it down. You decide. », la description de la charte) et celle d'avant (la description du 22 octobre, « it remembers »).

**Résultat.** Une hypothèse tient, deux sont fragiles, une n'est pas soutenue. Rien ne bloque.

| Hypothèse | Verdict |
|---|---|
| Le pilote accepte un plugin de plus s'il peut tout relire | Tient, comme condition nécessaire seulement |
| L'entrepreneur utilise une IA sur sa machine et peut franchir cette porte | Non soutenue |
| « D'accord » est la première lecture de la phrase pour un lecteur dont l'anglais n'est pas la langue première | Fragile |
| Les gens perçoivent « des projets qui te ressemblent » comme un désir | Fragile |

## 1. Le pilote accepte un plugin de plus s'il peut tout relire

**Ce qui le soutient.**
- Sur les six répondants du questionnaire, personne ne fait confiance au résultat sans le vérifier (stratégie du 22 octobre, reprise dans les personas).
- Deux voix craignent l'erreur silencieuse : « the failure mode isn't "tool forgot", it's "tool remembers a stale fact" » (développeur à quinze applications, 27 avril 2026, [recherche du 6 novembre](2026-11-06-research.html), partie 4).
- Des fichiers lisibles sont justement ce que la mémoire en base de données de claude-mem n'offre pas (recherche du 6 novembre, niveau 2).

**Ce qui ne le soutient pas.**
- Pouvoir relire est une condition, pas une raison d'installer. Les sources parlent aussi du coût : « It ended up burning so much tokens and taking actually longer to finish » (développeur qui a désinstallé superpowers, 5 octobre 2026, [audience du 19 octobre](2026-10-19-audience.html), partie 5).
- Le pilote a déjà ses fichiers : « 16 apps, each with its own CLAUDE.md ». Rien ne dit qu'il veut un système de plus à côté.

**Verdict : tient, comme condition nécessaire.** Sans relecture possible, il n'accepte pas. Avec, rien ne prouve qu'il accepte.

**Un vrai test devrait vérifier** ce qu'il refuse en plus de la relecture : le coût en jetons, le doublon avec ses fichiers actuels.

## 2. L'entrepreneur utilise une IA sur sa machine et peut franchir cette porte

**Ce qui le soutient.** Presque rien. Une personne qui produit du contenu « works with AI tools daily » (26 avril 2026), mais elle ne dit pas où : navigateur ou machine.

**Ce qui ne le soutient pas.**
- Le persona le dit lui-même : c'est le moins appuyé, et sa porte d'entrée est « à construire ».
- Bruno n'a trouvé aucun entrepreneur non technique qui parle à la première personne de son IA qui laisse son projet en désordre (recherche, « Unverified »).
- Le signal le plus proche va dans l'autre sens : 4 répondants sur 6 passent par une application web. Ce sont des proches, pas forcément des entrepreneurs, donc ce n'est pas une preuve, seulement un signal.

**Verdict : non soutenue.** Les deux moitiés (il utilise un agent sur sa machine, il franchit la porte) restent sans source.

**Un vrai test devrait vérifier** les deux questions de l'écran 1 déjà prévues (« Cette IA, c'est plutôt… ») et si, à la lecture de « an AI agent on your computer », la personne comprend ce qu'il lui faut. C'est le point que le test plan donne comme prioritaire.

## 3. « Agreed » est la première lecture de « Finally on the same page. » pour un lecteur dont l'anglais n'est pas la langue première

**Ce qui le soutient.** Notre intention : la charte écrit que la phrase « first means "agreed, aligned" » (VOICE, « How to read the tagline »). L'expression anglaise courante est bien celle de l'accord, mais c'est une connaissance générale, aucun fichier du projet ne la mesure chez un lecteur non anglophone.

**Ce qui ne le soutient pas.**
- Aucune source ne parle de la façon dont ces lecteurs comprennent la phrase. Il s'agit de ce que nous voulons qu'on lise.
- L'audit lui-même relève le risque de « page » lu comme page web ou document, et le test plan le liste parmi les contresens à relever.
- Le texte voisin tire vers le sens littéral : la description dit « keeps all your projects on one page », juste sous la phrase.
- En français, ce risque disparaît, mais « longueur d'onde » ajoute l'affinité et peut glisser vers « il me devine » (document du territoire 4, 6 novembre). Cela ne concerne pas ce lecteur-ci.

**Verdict : fragile.** L'intention est claire, aucun appui chez le lecteur visé.

**Un vrai test devrait vérifier** ce que ce lecteur dit comprendre. Un manque à corriger : les quatre questions de l'écran 1 ne demandent pas la langue première. Sans elle, on ne sait pas qui est ce lecteur. Je l'ajouterais.

## 4. Les gens perçoivent « des projets qui te ressemblent » comme un désir

**Ce qui le soutient.** Une seule voix : la tienne, à la question « qu'est-ce que BRACE en une phrase » (« mais surtout tes projets qui te ressemblent », territoire 4). C'est une donnée réelle, mais c'est celle de la personne qui a créé l'outil.

**Ce qui ne le soutient pas.**
- Les voix du public parlent de douleurs, pas d'un désir de ressemblance : l'oubli, la note périmée, « onboarding the same assistant from scratch ». Le plus proche est la personne qui recolle « the same brand guidelines, the same tone rules » : elle veut de la constance, pas forcément se reconnaître.
- Le débrouillard veut un plan qu'il peut modifier, sans plus (questionnaire).
- Les outils de marque (Looka, Brandmark) vendent le « à vous » pour le logo (recherche, niveau 4), mais c'est un autre marché.
- Les textes d'origine mettent en garde : en français la formule peut se lire comme une apparence, ou comme « il te devine ». C'est pour cela qu'elle n'est que la couleur des textes, jamais la promesse (VOICE).
- Aucune des deux présentations du test ne contient cette formule : le test principal ne la mesure pas.

**Verdict : fragile.** Elle repose sur une voix.

**Un vrai test devrait vérifier** avec une question à part, par exemple faire lire « Au bout, un projet fait de ce que tu as décidé » et demander ce que la personne en retient et si cela lui donne envie.

## Quelle présentation parle à quel persona

| Persona | Celle qui lui parle mieux | Pourquoi, d'après les sources | Confiance |
|---|---|---|---|
| **Le pilote** | La nouvelle | Il veut des agents qui devinent avant que tout soit dit et il vérifie tout. La nouvelle fait les deux gestes : « it reads your project first, asks only what it can't know », puis des fichiers qu'il peut relire. L'ancienne promet « it remembers », or sa plainte est « tool remembers a stale fact ». | Moyenne à bonne |
| **L'entrepreneur** | Partagé | L'ancienne ouvre sur sa douleur, dans ses mots (« Your AI forgets your project… and you explain it again »). La nouvelle parle mieux de ce qu'il cherche, « all your projects on one page », mais ce besoin est une hypothèse du persona. | Faible |
| **Le débrouillard** | La nouvelle, un peu | « Asks only what it can't know » répond à « réfléchir à la façon de lui parler », et les fichiers lisibles à un plan qu'il peut modifier. Mais l'ancienne dit « suggests the right tools », proche de « une IA qui s'organise toute seule ». Aucune des deux ne parle de jetons, et dans les deux il faut un agent sur la machine, alors que 4 répondants sur 6 passent par le web. | Faible |

Pour l'entrepreneur, le test compare deux ensembles entiers. La nouvelle présentation du test n'a pas la ligne de départ « Monday morning… » du README : elle serait donc la plus faible sur le point où il se reconnaît le mieux. Un vrai test le dirait.

## Ce que cela change

Rien ne bloque. Quatre repères :

1. **Ne pas écrire « validé ».** Les décisions de marque notent « hypothèse, non testée » pour les quatre points, et les personas restent « provisoires ».
2. **Entrepreneur et porte d'entrée.** Rien dans cette lecture ne change la ligne « An AI agent on your computer » du README : elle reste, c'est la seule réponse honnête à un point ouvert.
3. **La phrase.** Elle est gardée, comme décidé à l'atelier. Son sens « agreed » reste une intention. Si un test a lieu plus tard, ajouter la langue première à l'écran 1.
4. **« Te ressemblent »** reste la couleur des textes, jamais la promesse. Rien n'autorise à la monter d'un cran.
