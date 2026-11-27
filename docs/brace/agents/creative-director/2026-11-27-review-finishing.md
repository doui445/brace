# Revue : BRACE, espacement des lettres et finition (2026-11-27)
Demandée par : brand (Julie), réunion de remise 7.

## Verdicts
- Règle d'espacement : passe (valeurs recalculées, toutes cohérentes)
- Logo resserré : passe (équilibré, pointe sur le A), une réserve en note
- Finition : passe (finition seulement, aucun changement de direction)
- Présentation (draft3, 9 diapositives) : renvoyée, pas prête à montrer
- Rendu vérifié sur 01, 02, 03, 04, 05, 07, 08, 09. La 06 n'a pas été ouverte, elle a le même gabarit que 04, 05, 07 et 08.

## Recalcul de la règle (−0,02 em par doublement depuis 17 px, arrondi à 0,005, plancher −0,04, plafond +0,02)
| Niveau | −0,02 × log2(taille/17) | Arrondi | Dans brand.css et la charte |
|---|---|---|---|
| 56 | −0,0344 | −0,035 | −0,035 |
| 44 | −0,0274 | −0,025 | −0,025 |
| 32 | −0,0182 | −0,020 | −0,02 |
| 26 | −0,0123 | −0,010 | −0,01 |
| 20 | −0,0047 | −0,005 | −0,005 |
| 17 | 0 | 0 | 0 |
| 14 | +0,0056 | +0,005 | +0,005 |
| 13 | +0,0077 | +0,010 | +0,01 |
| 12 en capitales | +0,0100, plus 0,06 | +0,07 | +0,07 |

Les 10 valeurs sont justes. La charte (section typographie) et les variables `--track-*` de `brand.css` sont identiques, et le tableau du rapport aussi. Le mobile utilise bien le niveau h2 avec son espacement. Aucun écart.

## Logo
J'ai relu les contours de `logo-color.svg`. Les écarts entre lettres sont B-R 14,4, R-A 7,5, A-C 9,4 et C-E 14,9, comme annoncé. Le centre du A et la pointe de l'accolade sont tous deux à x = 242,73. La composition est équilibrée, la pointe est bien sur le A. Sur la planche « après » le nom tient bien, y compris la version « nom seul » et l'avatar.

À 64 px de large, l'écart R-A vaut environ 1 px (7,5 × 64/467). Il est juste lisible, mais la marge est faible. Le designer l'a vu et a fixé la limite là. Je laisse passer et je note la limite.

## Finition
Elle reste de la finition. Les maquettes passent dans la police de GitHub et du terminal. Les graisses 600 passent à 500, les capitales à +0,07, et les états de survol et de focus sont ajoutés. La mise en page mobile est corrigée et les orphelins sont traités. La palette, les polices de la marque et le logo ne changent pas. Le passage du texte à 17 px est visible, mais il applique une valeur déjà déclarée. Les points qui relèvent du moteur (`doc.css`) sont bien listés à part dans le rapport, sans y toucher.

## Renvois
1. **brand (présentation, diapositives 4, 5, 6, 7, 8)** : les captures sont rognées dans une boîte d'environ 400 × 395 px. On ne voit que « CE » et « BR » du logo sur la page d'accueil, un morceau de titre sur l'espace client, et les deux tiers de la diapositive restent vides. Le client ne peut pas comparer avant et après, alors que c'est la preuve de la finition. Il faut afficher chaque image en entier, grande. Si le gabarit `@image` ne le permet pas, c'est un bug du moteur à signaler. La page d'accueil claire et sombre est trop large pour un cadre : plein cadre ou deux images côte à côte.
2. **brand (présentation, ajout)** : le logo resserré, première demande du client, n'est jamais montré. Il faut une diapositive avant et après, par exemple `logos/logo-color.svg` contre `sources/before-tracking/logos/logo-color.svg`, ou la planche. Le client lit aujourd'hui seulement « −0,02 em » dans la diapositive 3 sans voir ce que ça change.
3. **brand (diapositive 3)** : mur de valeurs, jargon (« sans aller jusqu'à −0,04 »), et les coupures tombent mal (« −0,01 / em » sur deux lignes, titres 1 à 4 enchaînés sur une même ligne). Il faut un tableau simple (niveau, taille, valeur) ou une valeur par ligne, avec des espaces insécables entre le nombre et « em ». Il faut aussi raccourcir l'explication du logo à une phrase.
4. **brand (diapositive 1)** : « lettres, » tombe seul sur sa ligne dans le titre. Il faut reformuler ou équilibrer la césure du titre.
5. **brand (diapositive 7 et texte)** : la diapositive annonce que « les onglets défilent », mais « Présentations » reste coupé sans aucun indice, ce que le rapport reconnaît lui-même (hors de nos fichiers). Il faut le dire en une phrase honnête, ou ne pas le promettre.
6. **designer (charte, tableau, ligne « Logo »)** : « niveau le plus serré, borné par le plus étroit des écarts » est inexact. Le niveau le plus serré est −0,035 (display) et le plancher −0,04, alors que le logo est à −0,02, soit la valeur de h2. La règle sert à justifier chaque valeur. Il faut écrire que le logo est une exception assumée à la formule, bornée par l'écart R-A qui doit rester à 1 px, et non « le plus serré ».

## Notes
- Pas de tiret long dans la présentation (vérifié). Le français est correct et le ton est bien dit à « tu », pas d'erreur de fait par rapport au rapport.
- La diapositive 9 est claire. Les captures de l'espace client à 390 px, vues dans leur cadre, montrent bien le gain (onglets, marges).
- Deux éléments de la finition ne sont pas dans la présentation : les corrections hors de nos fichiers (`doc.css`) et le mode sombre de l'espace client. C'est acceptable pour le client. Julie peut en garder une ligne dans la note d'équipe.
- Décision : une fois les renvois 1 à 4 faits, prête à montrer. Le 6 peut se corriger en parallèle, il ne bloque pas la présentation.

## Second regard (draft4, 8 diapositives, toutes vérifiées)
Renvois 1 à 6 : corrigés pour l'essentiel. La charte dit maintenant que le logo est une exception voulue à la formule (renvoi 6 passé). La table de la diapositive 3 est claire, les diapositives 2, 6 et 8 sont bonnes, le texte est honnête (onglets) et sans tiret long.

Reste à corriger avant de montrer :
1. **brand, diapositive 4** : un texte parasite, « Image d'exploration, non publiée », est imprimé par le gabarit de l'image par-dessus les deux logos, au milieu du nom BRACE (avant comme après). C'est une étiquette interne qui apparaît chez le client. Il faut la retirer pour ces images (ou signaler le bug au moteur).
2. **brand, diapositive 7** : les captures grand écran sont minuscules dans de grands cadres gris, le texte est illisible et l'on ne voit aucune différence entre avant et après. La diapositive ne prouve rien. Il faut recadrer sur le haut de la page (titre, onglets, premier paragraphe) pour que ce soit lisible, ou la supprimer : la 6 montre déjà le gain.
3. **brand, diapositive 5** : lisible mais petite, avec beaucoup de vide gris autour. À améliorer en même temps (recadrer sur le bloc du README).

Note : sur la diapositive 1, « lettres » reste seul sur sa ligne (le titre passe sur trois lignes). Ce n'est pas bloquant, mais un titre plus court réglerait le problème.

Verdict : pas encore prête. Dès que la 4 est propre et que la 7 est lisible ou supprimée, elle est prête.

## Troisième regard (draft5, 7 diapositives)
- Diapositive 1 : le titre tient sur deux lignes, plus de mot orphelin.
- Diapositive 4 : l'étiquette parasite a disparu, les deux logos sont propres, on voit l'écart resserré.
- Diapositive 5 : avant et après sont empilés, la différence se voit (le paragraphe apparaît). L'image ne grossit pas, il reste des bandes grises de chaque côté, et le cadre du bas touche presque le pied de page. Ce n'est pas bloquant.
- Diapositive 7 (grand écran) : supprimée, la 6 suffit.

Verdict : prête à montrer.
