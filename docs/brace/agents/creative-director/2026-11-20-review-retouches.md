# Review: BRACE, deck de l'affinage, la suite (2026-11-20)
Asked by: brand (Julie), deck du lundi 23 novembre 2026, 17 h.

## Verdicts
- Demandes du client (compte rendu 5): les cinq sont traitées (accolade sous le nom, icône à deux accolades, autres idées, palette, polices). Pass sur le fond.
- Accolade, les deux sens: pass (slides 3 et 4 de même gabarit, réserves de poids égal). Ordre alterné d'une police à l'autre, voir Notes.
- Logos (slides 3, 4, 7, 8, 9, 12, 14, 16, 18): pass, SVG entiers, ni rognés ni déformés.
- Polices (slides 11, 13, 15, 17): B, C, D s'affichent dans leur propre police, pas de repli. A (Schibsted) est aussi la police du deck : correct, mais rien ne la distingue visuellement ici. Send back sur l'exemple d'usage (voir 1).
- Icône 16 px (slides 5 et 6): le rendu réel est trop petit pour être jugé dans le deck. Il faut montrer la planche `icones/zoom-16px.png` à côté (voir 2).
- Palette (slide 10): send back.
- Présentation: send back (cinq points ci-dessous, aucun ne casse la mise en page).

## Send-backs
1. Brand: le client a demandé "chaque police avec son explication et un exemple d'utilisation". Les slides 11, 13, 15, 17 annoncent des exemples ("le haut de la page de ton projet", "un paragraphe de la page de ton projet", "le nom en grand, à côté de l'accolade") mais n'affichent qu'une phrase en grand. Le paragraphe, la ligne de code et l'accolade des spécimens d'Isabelle (`polices/specimen-A` à `D`) n'apparaissent pas. Montrer chaque spécimen entier à côté de sa slide, ou mettre `comparaison-polices.png` en slide, et ne pas promettre un exemple qu'on ne voit pas. Le texte explicatif français est aussi tout en Commit Mono : long à lire pour quelqu'un hors métier, à passer en police de texte.
2. Brand: slides 5 et 6, à 16 px réels, on ne distingue pas la paire d'une icône de code, ni l'accolade couchée d'une corne. La demande du client est justement de tester 16 px. Ajouter `icones/zoom-16px.png` (agrandi 11 fois, sans lissage) en slide, ou le projeter à côté. La note d'Isabelle (slide 6) renvoie à "la planche de contrôle" que le client n'a pas : montrer la variante `} {` sur ce zoom, ou retirer la phrase.
3. Brand: slide 10, les rapports de contraste sous chaque pastille ne disent pas contre quel fond (papier 1.13:1 / 18.62:1, pétrole 7.38:1 / 2.85:1) et contredisent le texte et le rapport d'Isabelle (16:1 sur papier, pétrole 6,54:1, pétrole clair 7,92:1 sur sombre). Mesurer sur le papier (ou sur le sombre pour les couleurs claires), ou retirer les chiffres. Le paragraphe est un bloc dense avec des points-virgules : le couper en trois phrases courtes, une par réglage. Montrer le bloc "surface sombre" posé sur le fond sombre, car le client ne voit pas à quoi sert `#211F1C` (deux noirs côte à côte).
4. Brand: slide 8, "disparaît sous environ 100 pixels de large", le designer dit 120 px (la planche dit 24 px de capitale). Aligner sur un seul chiffre, celui du designer.
5. Brand: slide 19, "la seule qui n'a rien d'une police déjà vue" est trop fort (Bricolage aussi se distingue) et "Au réglage choisi" (slide 13) est du jargon. Dire "la plus éloignée d'Arial" et "en petite taille optique". L'item 05 "Un seul noir : oui ou non" ne dit pas ce qu'est le non : écrire "un noir ou deux (#171614 seul, ou avec #1A1916)". Slide 2, le texte d'intro gris clair sur carte blanche semble sous 4,5:1, contre notre propre règle du gris : foncer.

Aucun send-back au designer : les fichiers sont conformes (`check_visual.py` sans problème, d'après son rapport).

## Notes
- Chaque police n'est vue que dans un sens (A et C pointe vers le mot, B et D vers le bas). Isabelle l'alterne pour l'égalité, mais cela mélange police et sens dans la comparaison. La planche `comparaison-polices.png` montre les deux sens pour chaque police : l'utiliser règle ce point.
- Slide 6 : la corne ou l'oiseau que fait l'icône horizontale à 16 px est visible. Ce n'est pas un défaut du deck, mais l'équipe devrait le dire clairement au client.
- Slide 11 : "c'est sans doute ce qui te gênait" prête un ressenti au client. Garder le "sans doute", ne pas durcir.
- Langue : français net, pas de tiret long, temps justes ("tu as vue la dernière fois", "tu as demandé").
- Rendu : 19 slides vues, ni débordement, ni police manquante, ni contraste cassé hors point 5. Planches vues en entier : `comparaison-polices.png`, `planche-idees.png`, `planche-icones.png`, `zoom-16px.png`. `sous-le-nom-planche.png` non relue (slides 3 et 4 la couvrent).
