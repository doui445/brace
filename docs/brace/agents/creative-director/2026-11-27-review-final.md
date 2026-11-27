# Revue : BRACE, logo final (2026-11-27)
Demandé par : brand (Julie), réunion de remise 7.

## Verdicts
- Logo principal (A en pétrole, pointe sur le A) : prêt
- Nom seul (B en pétrole) : prêt
- Présentation (15 diapositives, 02 et 03 regardées) : prêt, avec une retouche de texte
- Document Charte graphique : retouches mineures
- Document Planche de marque (texte et brand-board-fr.png) : retouches mineures

## Ce que j'ai vérifié
- Pointe sur le A : tenue. Sur la diapositive 02, l'og.png et le mockup README, la pointe et le sommet du A sont dans le même axe, et l'accolade couvre exactement la largeur du nom (bords alignés).
- Équilibre : bon. L'accolade (18) et les lettres (20/18) ont le même poids, le A pétrole marque l'axe sans alourdir, la couleur est rare. Sur fond sombre (README sombre, terminal), le A en pétrole clair reste net face aux lettres papier.
- Règle A/B : cohérente partout. Avec accolade, A pétrole : diapositive 02, charte, planche, README, og, terminal. Sans accolade, B pétrole : diapositive 03, charte, planche, fichiers du nom seul. La reco finale l'écrit pareil.
- Affirmations périmées : aucune. Plus de B pétrole dans le logo complet (gardé en historique, marqué « ne plus utiliser »), plus de trait (aucun `stroke`, `clipPath` ni `<text>` dans les SVG de delivery-2), plus de Bricolage dans le logo (dit clairement dans la charte, la planche et la diapositive « polices »).
- Français et tirets longs : aucun tiret long dans les trois textes.

## Retouches
1. designer : `brand-board-fr.png`, la planche « française » garde des libellés anglais dans la tuile avatar (« REAL SIZE, ROUND CROP », « IN A PLUGIN LIST »). À passer en français (« taille réelle, recadrage rond », « dans une liste de plugins »). Le texte du terminal peut rester en anglais, c'est la sortie du produit. Régénérer ensuite `brand-board-fr.png`.
2. designer : charte, section « Tailles minimales » et diapositive 02. Le logo complet dit « en dessous de 96 pixels, passe au B », alors que le nom seul descend à 64 pixels. Entre 64 et 96 pixels, on ne sait pas lequel prendre. Écrire la règle d'un trait : de 96 et plus, logo complet ; de 64 à 96, nom seul si la place est étroite ; en dessous, le B. Brand reprend la même phrase dans la note d'Isabelle de la diapositive 02.
3. designer : tableau des couleurs de la charte (ligne Pétrole : « L'accolade, un lien, un bouton, le bandeau ») et planche (« rare, l'accolade »). Ajouter le A du logo et le B du nom seul, comme le fait déjà la diapositive couleurs.
4. designer : charte, tableau des polices, ligne Bricolage : « plus les lettres du logo : elles sont dessinées, non composées » se lit comme si Bricolage les écrivait. Retirer la parenthèse, la phrase du dessus le dit déjà.
5. brand et designer : forme. Des points-virgules restent dans la charte (« ; elle ne sert plus », « ; avec le nom seul »...) et dans la présentation (« Il est dans ton espace client ; voici l'essentiel », l'élément de la reco « portfolio reste neutre »). Les remplacer par un point. La couverture dit « Mis à jour pendant la remise » : c'est une note interne, à retirer avant que le client ne lise la présentation hors séance.

## Notes
- La règle « jamais le nom seul à côté du logo complet sur la même page » est contredite par la planche elle-même, qui montre les deux. C'est une planche de spécification, donc acceptable. Une demi-phrase suffit : « jamais dans un même usage ».
- Les « Nouveau : » en tête des textes de diapositive sont des étiquettes de séance. À garder en live, à retirer pour la version que le client garde.
- La diapositive 03 laisse beaucoup de vide sous le texte, sans gravité.
- Le rendu HTML des documents de `docs/brace/brand/documents/` n'est pas régénéré (le designer l'a signalé) : à faire par brand après les retouches. Les icônes PNG sont inchangées, c'est cohérent.
- Vérifications `check_visual.py` : non rejouées ici, je m'appuie sur le rapport du designer (aucune alerte).

## Décision
Le logo peut être montré au client maintenant. Les retouches 1 à 5 sont à faire avant de verser la charte et la planche dans l'espace client.
