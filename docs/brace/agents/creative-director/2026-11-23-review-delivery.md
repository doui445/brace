# Revue : BRACE, la remise (2026-11-23)
Demandée par : brand (Julie), avant le rendez-vous 6 du 25 novembre. Lou, directrice de création.

Champs reçus : brief client (DECISIONS.md, entrée du 23 novembre), deck (Markdown + 13 captures), 5 documents client (Markdown, HTML lu sans rendu visuel), fichiers de la remise. Rendu des HTML des documents non vérifié visuellement.

## Verdicts
- Deck (13 diapos) : send back
- Charte graphique (designer) : send back
- Planche de marque, texte et image `brand-board.png` : send back (texte), pass (image, avec notes)
- Plan de transition (stratège) : send back
- Plan de test, personas (stratège) : send back
- Annonce (rédacteur) : send back
- Fichiers `applications/*.png`, `og.png`, `avatar-500.png` : pass, avec notes

## Send-backs

### Brand (le deck)
1. Diapo 5, couleurs : la 7e pastille (surface sombre) déborde sur le pied de page, et sa ligne de contraste est coupée. En outre la palette montre 7 couleurs sur 8 : le gris sur sombre #A5A199, validé, manque. Les deux ratios affichés par pastille (par exemple 1,13:1 / 18,62:1) sont calculés contre du blanc pur et du noir pur, pas contre le papier et l'encre ; ils ne correspondent pas à la charte (encre sur papier 16,03) et un client non expert ne sait pas les lire. Corriger la mise en page, ajouter la 8e couleur, retirer ou rendre juste et lisible les ratios.
2. Diapo 6, polices : le paragraphe d'explication est composé en Commit Mono, alors que la règle validée est « Commit Mono pour les commandes seulement ». La diapo contredit ce qu'elle énonce. Le texte courant doit être en Bricolage, Commit Mono réservé à un exemple de commande.
3. Thème : le brief dit « pas de blanc pur » (charte, brand.css : « never pure white »), or les cartes des diapos 2, 9, 10, 11, 12 et les pastilles de la diapo 5 sont en blanc pur sur fond papier 2. Passer en papier / papier 2 avec le filet.
4. Diapo 1, couverture : l'italique est d'un vert sauge qui n'est pas dans la palette (ni pétrole clair #6FB7BE, ni gris sur sombre). Et la couverture d'une remise de logo ne montre pas le logo. Utiliser le logo sombre et le pétrole clair.
5. Diapo 8 : la légende dit « avec le logo en tête », mais la maquette d'ordinateur ne montre aucun logo, juste le mot BRACE en texte, sur un faux GitHub bleuté. La diapo contredit sa légende, et ne montre pas le seul support que la remise a de neuf. Utiliser `applications/github-readme.png` ou y placer le logo.
6. Diapo 4, icône : les pastilles font quelques dizaines de pixels dans deux bandes immenses, avec la moitié basse de la diapo vide. Rien n'est lisible de ce que « dessiné trait par trait » promet. Montrer le B en grand, puis aux tailles réelles.
7. Cohérence avec la cible « rien de nouveau » : la couverture le promet, mais la diapo 3 énonce une règle (96 px) que la diapo 13 range ensuite dans « à décider ». Ou bien c'est une règle, ou bien c'est une décision à prendre : choisir et aligner. Même chose pour les « trois mots » de la diapo 2 posés comme acquis puis soumis à validation en diapo 13.
8. Temps : la colonne « Avec ta marque » de la diapo 7 et la maquette de la diapo 8 parlent au présent de choses qui n'existent pas encore dans le dépôt (logo en tête de page, image de partage, icône pétrole). Dire « le jour de la sortie » ou le futur. Vérifier aussi « Une image générée par GitHub » et « l'icône par défaut de GitHub » : non sourcés dans les documents.
9. Vocabulaire : la remise s'appelle « remise » dans le deck et « livraison » dans les documents ; « sortie » dans le deck, « lancement » et « sortie » dans la transition. Choisir un mot par chose.

Points propres : aucun tiret long dans le deck, français correct, pas de « visage » ni de « 1.2 », police et thème appliqués ailleurs.

### Designer (la charte graphique, la planche, les fichiers)
10. Charte : le mot « visage » (« Le visage en tire quatre règles ») est un terme interne. Écrire « l'identité » ou « la marque ». Même chose dans le texte de la planche (« parce que le visage les porte »).
11. Charte : deux listes à puces se terminent par des points-virgules (les quatre règles, les « ne jamais faire »). Phrases courtes ou puces sans ponctuation de liste.
12. Charte et planche : des éléments absents de la décision du 23 novembre y sont posés comme validés : le texte sur sombre #ECE9E2, quatre teintes (#123E44, #3E8A92, #DCEBEA, #DAD5CA), l'espace de protection, la taille minimale du symbole (24 px), les graisses 500. Rien ne doit être nouveau pour le client : soit les ajouter explicitement à la liste « à décider » de la diapo 13 avec leur raison, soit les retirer. À noter : c'est aussi ce que la diapo 13 annonce comme à trancher (« espace autour du logo, tailles minimales »), donc la charte devrait dire « proposé » à ces endroits.
13. Charte : le paragraphe d'ouverture est bon, mais « Les fichiers sont dans brand/ » renvoie à un dossier que le client n'a pas encore ; le dire (« à la livraison »).
14. Planche, image : tout est en anglais (« Brand board », « Calm, Reliable, Frank ») alors que le document qui l'accompagne est en français. Acceptable pour un imprimeur étranger, mais le dire dans la planche ; sinon livrer les deux. Les vignettes d'applications en bas sont trop petites pour se lire.
15. Fichiers : le B de `avatar-500.png` montre à gauche, en haut et en bas de la hampe, un petit décrochement visible à 500 px. Si c'est le dessin à la main validé, bon ; si c'est un défaut d'export, à corriger. À confirmer par vous.

### Strategist (transition et plan de test)
16. Transition, titre et texte : « visage » dans le titre (« Plan de transition du visage ») et tout au long. Terme interne, à remplacer. Idem dans le plan de test (« face au visage », « le visage que tu as validé »).
17. Plan de test, titre : « Les personas vérifiés » contredit le contenu, qui dit en gras « hypothèse, pas un test ». Retitrer (par exemple « Tes personas face à ta marque », comme le deck).
18. Plan de test : la section « Ce que cela change » donne des consignes internes (« Ne pas écrire "validé" » dans les décisions) dans un document client. Les passer dans la note d'équipe. La citation anglaise du développeur n'est pas traduite pour un lecteur non expert.
19. Les deux documents : première phrase ou deux sur le plan du document (« construit en cinq parties », « en quatre parties »), à retirer ; « Je n'en ai ajouté aucun » est de la méta ; les étiquettes « Verdict : hypothèse plausible » sont des fragments à étiquette.
20. Transition : « Le jour de la livraison », « le jour du lancement », « le jour de la sortie » désignent trois dates ou une seule ? Fixer le vocabulaire avec brand. Et qui met les fichiers dans le projet : la transition dit l'agence, la diapo 13 (point 4) le range parmi les décisions du client. Aligner.
21. Transition : le tableau « en dehors du dépôt » est riche mais il y a deux « À compléter » légitimes (date de version, comptes). Les garder, ils sont honnêtes ; en revanche, la réponse du client sur « adopter la marque ou rester neutres » doit sortir dans la diapo 13 avec la même formulation que le document.

### Copywriter (annonce)
22. L'annonce part du principe que le client a des réseaux sociaux (« le post pour les réseaux », « sur tes réseaux ») alors que la transition dit qu'on n'en a trouvé aucun et que le client doit le confirmer. Reformuler en « message court, pour l'endroit où tu présentes BRACE » ou signaler « à confirmer ».
23. L'annonce dit « Tu publies quand tu veux, mais une fois le logo en place », la transition dit « le jour de la sortie ». Aligner sur la transition.
24. Le tableau « Ce que tu peux vérifier » cite des dates de décision et « rendez-vous 6 » : interne, pas pour un lecteur client. Dire « ce que tu as validé » et la date en clair.
25. « validée aujourd'hui » : date relative qui sera fausse le 25. Utiliser « validée le 23 novembre ».
26. Dans la note de version, la dernière phrase colle deux propositions par une virgule (« It is still a free plugin for Claude Code, it also works with Antigravity »). Reprise du README : corriger aux deux endroits ou laisser identique et le dire.

## Notes
- Les logos et le système (accolade pointe haute, 0,03 em, papier, encre, pétrole rare) sont fidèles à la décision. Planche : 8 logos, 8 couleurs, polices, trois applications ; cohérence du système, bon travail.
- `og.png` (1280 x 640), `avatar-500.png`, `applications/*.png` : pas de défaut de rendu, contrastes lisibles. Le terminal montre le logo dessiné dans un terminal réel (impossible en texte brut) : à présenter comme une illustration, pas comme un comportement du produit. Le dialogue du terminal est une invention d'illustration : à marquer comme tel.
- Citation « stale fact » du plan de test : présente dans la recherche de l'analyste, pas d'invention.
- Tous les tirets : aucun tiret long dans les six Markdown.
- Vérification de rendu : « rendering not checked » pour les HTML des documents.

## Second regard : deck à 14 diapos (2026-11-23)
Verdict : send back, 3 casses de rendu et 2 restes. Documents non revus (hors demande).

Corrigé : points 2 (la diapo 7 n'est plus en Commit Mono), 3 (plus de blanc pur : cartes et pastilles en papier 2), 4 (couverture en pétrole clair, la palette est tenue), 7 (« proposé », « que nous te proposons »), 8 (futur et « Rien qui soit à toi »), 9 (« remise » et « mise en place » alignés, sauf « sortie » qui reste, ce qui est cohérent avec la transition). Le point 1 est traité par la nouvelle diapo 6 (toute la palette, 8 couleurs, mais voir ci-dessous).

Encore faux ou cassé, pour brand :
1. Diapo 9 (supports) : les deux images affichent « Image d'exploration, non publiée » : un cadre vide, pas les maquettes. Le chemin `applications/` est refusé ou mal résolu. Bloquant.
2. Diapo 6 (toute la palette) : le tableau est brut, sans style. Les colonnes se touchent (« #F4F1EALe fond des pages »), les en-têtes ne sont pas alignés, le code est minuscule. À mettre dans le thème, ou à refaire en liste.
3. Diapo 7 (polices) : les deux étiquettes du bas disent « Bricolage Grotesque » deux fois, alors que le titre promet Commit Mono et qu'aucun exemple de commande n'est montré. Remettre « Commit Mono » en deuxième étiquette et montrer une seule commande en Commit Mono (par exemple `$ claude`), sans repasser le paragraphe en mono.
4. Diapo 5 : les ratios sous chaque pastille (7,38:1 / 2,85:1, 18,08:1 / 1,16:1...) sont encore calculés contre blanc et noir purs, et contredisent les chiffres de la diapo 6 (16, 6,5...). Les retirer, la diapo 6 donne les bons.
5. Diapo 4 (icône) : inchangée, trois pastilles minuscules et la moitié basse vide (point 6 de ma revue). Pas bloquant, à améliorer si le temps le permet.

## Troisième regard : rendu seul, deck à 13 diapos (2026-11-23)
Verdict : send back, un seul bloquant.
- Corrigé : la palette est une liste lisible avec ratios sur fonds nommés (diapo 5, pass) ; la diapo 6 montre `/plugin install brace` en Commit Mono dans un texte en Bricolage (pass).
- Diapo 8 (supports) : les images se rendent, mais elles sont rognées dans des carrés. On voit « CE », « BR », un B coupé, la moitié des tailles d'avatar : illisible, et la moitié claire (blanc pur) est tronquée. Afficher chaque image entière (pas de recadrage, format paysage, une par ligne ou côte à côte plus larges). Bloquant.
- Note, non bloquant : diapo 6, les deux étiquettes du bas disent « Bricolage Grotesque » deux fois ; en retirer une.
- Quatrième regard (diapos 8 et 9, 14 diapos) : pass, les deux maquettes sont entières, lisibles, une par diapo. Note : sur la diapo 9, la légende répète le texte de droite, et les libellés de l'image restent en anglais.
