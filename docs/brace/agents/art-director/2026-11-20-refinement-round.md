# Visual: BRACE, tour de retouches de l'affinage (2026-11-20)
Asked by: brand (Julie), pour la suite de l'affinage, lundi 23 novembre 2026 à 17 h.

Rien ne manque au brief. Mode : tout en code (Isabelle dessine après ce rapport). Aucune image générée. Les polices ne sont pas revues à l'écran aujourd'hui : les descriptions viennent du métier, et le choix se fait sur les spécimens d'Isabelle. Licences et versions à reconfirmer dans les paquets téléchargés.

## 1. Typographie

### Ce que je lis dans le « sans savoir dire pourquoi »
Deux indices dans nos propres fichiers. La revue de Lou (19 novembre) note que les lettres du logo « ressemblent à Helvetica ou Arial » (terminaisons du C coupées en biais, R large) : en capitales, Schibsted est une grotesque très neutre, donc proche de ce que le client a vu mille fois. Et nous lui demandons de juger cinq capitales, là où Schibsted est dessinée pour le texte courant. Le défaut n'est donc sans doute pas la police mais l'absence de caractère dans BRACE en capitales. Les alternatives ci-dessous varient précisément là-dessus : un peu plus de personnalité dans le B, le R, le C, sans perdre le calme.

### Contrainte de licence qui change la liste
Le dépôt BRACE est public et la marque héberge ses polices avec sa licence. La licence des polices Fontshare interdit la redistribution des fichiers : on ne peut pas les poser dans le dépôt, seulement les lier. Je garde donc uniquement des polices SIL OFL 1.1 (hébergeables et redistribuables), et je laisse Fontshare de côté, même pour de bonnes polices. Velvetyne : rien qui serve un outil calme.

### Les quatre pistes (une seule famille de titres et de texte + Commit Mono)

**A. Schibsted Grotesk (point de comparaison, déjà dessinée)**
- Ce qu'elle dit : une grotesque de presse, ferme, neutre, chaleureuse en texte.
- Pourquoi pour Rassemblé : sérieuse sans froideur, mais ses capitales sont les plus « déjà vues » des quatre.
- Avec Commit Mono : bon accord (deux formes neutres), rien à changer.
- Exemple : le logo actuel (v1, demi-gras 600, +3 %), déjà fait : sert d'étalon.
- Où : Google Fonts, SIL OFL 1.1, déjà hébergée.

**B. Bricolage Grotesque (la plus de caractère)**
- Ce qu'elle dit : une grotesque d'aujourd'hui, avec de petites encoches d'encre aux jonctions, des capitales qui ne ressemblent pas à Arial. Elle a un axe de taille optique : plus nette en petit, plus expressive en grand titre. Fabriquée comme un outil d'atelier, pas comme un produit d'entreprise.
- Pourquoi pour Rassemblé : le B, le R et le C ont une silhouette qu'on retient ; l'accolade du signe, un trait régulier et net, gagne à se poser sous des lettres qui ont un peu de main. Risque : elle peut se lire « tendance startup » si on la pousse ; en semi-gras et taille optique basse elle reste calme.
- Avec Commit Mono : bon contraste (une sans vivante, une mono neutre qui montre les fichiers). Rien à changer.
- Exemple à poser : le titre du README, « BRACE », puis la phrase « Finally on the same page. » en Bricolage 500 à 28 px, interligne 1.2, sous le logo ; en regard, les cinq capitales du logo à 600, +3 %.
- Où : Google Fonts ou le dépôt de l'atelier (github.com/ateliertriay/bricolage), SIL OFL 1.1, variable.

**C. Atkinson Hyperlegible Next (la plus claire, humaniste)**
- Ce qu'elle dit : une sans humaniste dessinée par le Braille Institute pour qu'aucune lettre ne se confonde avec une autre : ouvertures larges, R et G très lisibles. Aucune ressemblance avec Arial.
- Pourquoi pour Rassemblé : la plateforme parle de fichiers lisibles par tous (toi, l'humain, et l'agent) et de « même page » : une police dessinée pour la lecture sans malentendu porte cette idée sans un mot de plus. C'est la plus calme du lot. Risque : moins de signature en grand titre, elle compte sur la justesse plus que sur le dessin.
- Avec Commit Mono : bon accord, les deux sont dessinées pour la lisibilité ; une mono à 92 % de la taille du texte pour égaler la hauteur d'x.
- Exemple à poser : un paragraphe de texte du README (17 px, interligne 1.5, ligne de 60 à 70 signes) avec une ligne de code en Commit Mono au milieu, et le logo en 600 : c'est là qu'elle se juge.
- Où : Google Fonts (famille Atkinson Hyperlegible Next, version 2025) ou brailleinstitute.org, SIL OFL 1.1. À reconfirmer : le nom exact de la famille et la licence dans le paquet.

**D. Figtree (la plus ronde)**
- Ce qu'elle dit : une sans géométrique douce, C, E, A aux courbes pleines, un ton aimable.
- Pourquoi pour Rassemblé : ses courbes se répondent avec celles de l'accolade (arrondis de l'accolade, arrondis des lettres) et « tenir ensemble » appelle un ton accueillant. Risque : très répandue dans les produits SaaS, donc la moins distincte des quatre en titre ; et plus ronde que Commit Mono, dont les angles sont plus droits.
- Avec Commit Mono : accord correct, un cran moins naturel. Si la ronde plaît, on peut essayer IBM Plex Mono (SIL OFL) à la place pour ses courbes, mais je ne le propose que si le client choisit D.
- Exemple à poser : le mot-symbole BRACE en 700 à grande taille à côté de l'accolade, pour juger si les courbes s'accordent.
- Où : Google Fonts ou github.com/erikdkennedy/figtree, SIL OFL 1.1, variable.

### Recommandation
**C. Atkinson Hyperlegible Next** pour les titres et le texte, avec Commit Mono. C'est la plus calme (le critère du client), la seule qui n'a rien d'Arial, et elle donne un argument vrai à la plateforme (lisible, sans malentendu). **B. Bricolage Grotesque** est la réserve si le client veut plus de caractère dans le nom lui-même. Je recommande que le designer pose ces deux sur la même planche, mêmes cinq lettres, même accolade, avec Schibsted en témoin : ce que je recommande reste provisoire tant que je n'ai pas vu les lettres rendues, et le client tranche sur le dessin, pas sur mes mots.

## 2. Palette

Contrastes recalculés (papier `#F4F1EA`, papier profond `#E7E3D9`, voile `#DCEBEA`, sombre `#171614`) :

| Paire | Rapport |
|---|---|
| encre `#1A1916` / papier | 15,58 |
| encre / papier profond | 13,72 |
| gris `#5F5B53` / papier | 5,99 ; / papier profond 5,27 ; / voile 5,51 |
| pétrole `#1D5E66` / papier | 6,54 ; / papier profond 5,76 ; / voile 6,02 |
| pétrole foncé `#123E44` / voile | 9,52 |
| papier / pastille pétrole (favicon, avatar) | 6,54 |
| texte `#ECE9E2` / sombre | 14,91 |
| gris `#A5A199` / sombre | 7,02 |
| pétrole clair `#6FB7BE` / sombre | 7,92 |

**Verdict : elle est cohérente telle quelle.** Le papier chaud et le sombre d'Écrit se marient avec le pétrole : c'est le seul froid dans une famille chaude, ce qui le garde rare et visible, sans autre raison à chercher. Tous les textes passent à 4,5:1 sur tous les fonds prévus. Trois ajustements utiles, aucun de plus :

1. **Un seul noir : l'encre devient `#171614`** (le sombre déjà validé), plutôt que d'ajouter `#1A1916`. Les deux sont à trois pas l'un de l'autre, personne ne verra la différence, et deux presque noirs obligent à choisir à chaque fois. Contraste : 16,03 sur papier, 14,11 sur papier profond. C'est la réponse à la remarque de Lou sur les deux noirs, et un jeton de moins. Si le client préfère l'encre `#1A1916`, c'est aussi acceptable : à lui de trancher lundi, l'enjeu est mince.
2. **Ajouter une surface sombre `#211F1C`** (le papier profond du mode sombre : cartes et blocs de code sur sombre). Aujourd'hui elle n'existe pas : le sombre n'a qu'un fond. Contrastes à garder : texte `#ECE9E2` dessus 13,56 ; gris `#A5A199` 6,39 ; pétrole clair `#6FB7BE` 7,20 (passe) ; pétrole `#1D5E66` dessus 2,23 (refusé, comme sur le sombre).
3. **Une règle, pas une couleur : aucun texte plus clair que le gris `#5F5B53` sur papier.** La revue de Lou signale des gris de pied de page sous 4,5:1. Un gris moyen type `#8A857B` n'atteint que 3,25 sur papier : réservé aux filets et aux décors, jamais au texte.

À ne pas toucher : le pétrole moyen `#3E8A92` reste pour les éléments d'interface (3,54 sur papier, 3,12 sur papier profond : passe à 3:1 de justesse sur papier profond, à ne pas y descendre) ; sur sombre 4,11. Le voile `#DCEBEA` est un peu plus froid que le papier : c'est voulu (il porte le pétrole), à valider à l'œil sur la planche.

## 3. Logo

Même grammaire pour tout : le symbole reste la grille de 24, trait de 2,5, bouts arrondis, pointe centrale nette. Seul l'emplacement et le sens changent.

### (a) L'accolade sous le nom, les deux sens à égalité
Dans les deux cas : symbole exactement de la largeur du mot, marge entre mot et symbole égale à l'épaisseur du trait fois deux, version une couleur identique.

**Pointe vers le bas (les bouts se relèvent vers le mot)** : la sous-accolade des maths, celle qui regroupe les lettres qui la surmontent.
- Ce qu'elle dit : les cinq lettres sont tenues ensemble, portées par l'accolade comme par un socle. C'est le sens le plus littéral de « grouper ».
- Ce qu'elle coûte : les bouts qui remontent forment un U très ouvert : on peut y lire un sourire ou un bol. Sur le mot, c'est souvent un soulignement : on le prend pour une décoration, pas pour un signe.
- À tester petit : la petite marque en même sens (pointe vers le bas), à 16, 32 et 48 px : à 16 px elle est susceptible de se lire comme un chevron « v » ou une flèche vers le bas.

**Pointe vers le mot (les bouts descendent)** : le dessin déjà fait, déplacé sous le nom.
- Ce qu'elle dit : une pointe qui désigne le mot, comme une marque de lecture ; le nom est présenté, pas porté.
- Ce qu'elle coûte : une pointe qui monte vers les lettres se lit comme un accent circonflexe « ^ » ; les bouts qui descendent évoquent, à certaines tailles, une moustache ou un oiseau (réserve déjà écrite, la même pour les deux sens).
- À tester petit : la petite marque en même sens, même relevé.

Dans les deux sens, la petite marque et l'avatar suivent le sens choisi, pour que la famille ne se contredise pas. Mêmes critères pour Isabelle : un sens ne passe pas devant l'autre dans la planche, ordre inversé d'une ligne à l'autre.

### (b) La paire d'accolades `{ }` en 16 px
- Idée : deux accolades verticales qui encadrent un vide, posées sur la pastille pétrole, dans le même trait que l'accolade du nom (trait 2 sur une grille de 16, pointe centrale nette, bouts arrondis). Pour rester à BRACE plutôt qu'au code : proportions larges, vide au centre plus grand que d'habitude, aucun point ni curseur dedans (le point était l'idée « Accolé », écartée).
- Ce que ça dit : « encadrer, tenir ce qui est entre ». Cela se lit tout de suite sans le nom.
- Ce que ça coûte : c'est le signe que tous les outils de code utilisent (icônes JSON, extensions d'éditeur) : à 16 px, il se lira « code » avant de se lire BRACE. Et il ne ressemble pas à l'accolade horizontale du logo : deux signes dans la famille, sauf si on le relie (voir les idées ci-dessous, « Encadré »).
- Taille : sur 16 px, deux accolades de 4 px de large chacune et un vide de 5 à 6 px : tient à trait de 1,75 ; en dessous, les pointes se bouchent. À montrer à 16, 32 et 48 px, clair et sombre, à côté de la version horizontale.
- Variante à tester une fois : les pointes vers l'intérieur `} {`. Elle s'éloigne du signe JSON et dit « on tient serré », mais risque de se lire comme un sablier ou un nœud papillon. À montrer, pas à pousser.

### (c) D'autres idées de logo, toujours dans Rassemblé

**1. Encadré** : le nom entre deux accolades horizontales (une au-dessus pointe vers le haut, une au-dessous pointe vers le bas), c'est-à-dire la paire `{ }` couchée.
- Idée derrière : la même paire que l'icône, mais tournée à 90 degrés autour du mot : le logo et l'icône sont un seul geste, ce qui répond au défaut de (b).
- Ce que ça coûte : trois couches (accolade, mot, accolade), donc plus d'encre et moins de calme que le logo à une accolade ; plus de hauteur, mal à l'aise en bandeau. Le dessin existe déjà, aucune nouvelle forme : coût de dessin faible.

**2. L'A à traverse en accolade** : dans le mot-symbole, la barre du A est remplacée par une petite accolade pointe vers le haut, la seule retouche faite au dessin des lettres.
- Idée derrière : le signe n'est plus posé à côté du nom, il est dans le nom, comme la barre qui tient les deux jambes du A (tenir ensemble).
- Ce que ça coûte : une lettre dessinée à la main (le reste est la police), et le détail n'existe qu'à partir de 24 px environ : en petit, la petite marque reste l'accolade seule. Le A fait aussi une marque à part, mais l'initiale de BRACE est B : à ne pas pousser pour l'avatar.

**3. Le mot dans ses accolades** : `{ BRACE }` en typographie, le nom entre ses propres accolades de la police.
- Idée derrière : le nom est le signe (BRACE est le mot anglais de l'accolade), aucun dessin à inventer.
- Ce que ça coûte : presque rien à fabriquer et il tient partout, y compris au terminal. Mais c'est la forme la plus attendue : un variable de gabarit, ni plus ni moins. À garder comme version de secours des textes (README, terminal), pas comme logo.

Piste d'accompagnement, pas un logo : l'accolade horizontale peut aussi servir de filet sous un titre de page (une seule fois par page), si le sens « sous le nom » est retenu : un élément graphique, sans coût de dessin.

## Pour Isabelle (résumé de la planche)
1. Un spécimen par police (A à D) : mêmes cinq lettres BRACE en 600, +3 %, avec l'accolade sous le nom (les deux sens), plus l'exemple d'usage de chaque police ci-dessus. Schibsted garde son dessin actuel.
2. Palette : mettre à jour `brand.css` avec l'encre unique (ou les deux encres, selon la décision de lundi) et la surface sombre `#211F1C` ; reporter les contrastes.
3. Le logo : l'accolade sous le nom, deux sens, version une couleur incluse ; la petite marque `{ }` à 16, 32, 48 px (clair, sombre) avec la variante `} {` ; les trois idées (Encadré, A à traverse, `{ BRACE }`) sur une seule planche, au même niveau.
4. Pas d'image en carré rogné : montrer les images entières (contain), comme demandé par la revue de Lou.

## Set aside
- **Une serif en titres (Source Serif 4, Literata)** : elle donne du caractère, mais elle ramène vers Écrit (la route écartée) et, avec le papier crème, vers le registre éditorial de l'hôte. Le pétrole nous sépare déjà ; la police ne doit pas rapprocher.
- **Les polices Fontshare (General Sans, Satoshi, Switzer, etc.)** : bonnes polices, licence qui interdit de les redistribuer dans le dépôt public.
- **Geist, Space Grotesk, Manrope, Plus Jakarta Sans** : trop présentes dans l'imagerie des outils d'IA et de développement, donc le cliché que le brief refuse.
- **Un point ou un curseur entre les accolades de l'icône** : l'idée « Accolé », écartée au premier tour pour la même raison.
