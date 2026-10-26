# Catalogue i18n — Français (`fr`)

Traduction 1:1 de `en.md` : **mêmes clés, même ordre**. Un test le vérifie.
`en.md` fait foi pour les clés et la structure ; ce fichier n'en est que la
traduction.

**Jamais traduit** (absent d'ici, gardé verbatim dans toutes les langues) :
clés de frontmatter et leurs valeurs énumérées (`status: active|paused|blocked|archived`,
`"non"`, `"adopté"`, `"leger"`, `"superpowers"`), noms des fichiers standard,
noms de hooks, le tag `#tracker-sync`, les codes de langue.

## STATUS.md

- status.title: STATUS — {project}
- status.intro: Instantané de l'état courant. Entièrement réécrit chaque session.
- status.heading.where_it_stands: État actuel
- status.heading.what_works: Ce qui marche
- status.heading.known_gaps: Angles morts connus
- status.heading.next_actions: 3 prochaines actions

## ROADMAP.md

La structure dépend des phases (voir `references/backlog-phases.md`) : sans
phase démarrée, `current_focus` porte une simple liste priorisée ; dès qu'une
phase tourne, `in_progress` et `after` la remplacent.

- roadmap.title: ROADMAP — {project}
- roadmap.intro: Synthèse priorisée. Le détail brut est dans BACKLOG.md.
- roadmap.heading.done: Fait
- roadmap.heading.current_focus: Focus actuel
- roadmap.heading.in_progress: Phase {n} — en cours
- roadmap.heading.after: Après la phase {n}
- roadmap.heading.unprioritised: Idées non priorisées

## JOURNAL.md

- journal.title: JOURNAL — {project}
- journal.intro: Journal chronologique daté. Ajout uniquement.
- journal.entry_heading: {date} — {topic}

## CHANGELOG.md

- changelog.title: Changelog — {project}
- changelog.intro: Format basé sur Keep a Changelog.
- changelog.heading.unreleased: Non publié
- changelog.group.added: Ajouté
- changelog.group.changed: Modifié
- changelog.group.fixed: Corrigé
- changelog.group.removed: Retiré

## DECISIONS.md

- decisions.title: DECISIONS — {project}
- decisions.intro: Pourquoi chaque choix structurel, et ce qui a été écarté. Ajout uniquement.
- decisions.label.context: Contexte
- decisions.label.decision: Choix
- decisions.label.rejected: Écarté
- decisions.label.downside: Inconvénient accepté

## ERRORS.md

- errors.title: ERRORS — {project}
- errors.intro: Bug puis cause puis correctif, cherchable. Ajout uniquement.
- errors.empty: Aucune entrée pour l'instant.
- errors.label.symptom: Symptôme
- errors.label.cause: Cause racine
- errors.label.fix: Correctif
- errors.label.recognise: Le reconnaître à nouveau

## BACKLOG.md

- backlog.title: BACKLOG — {project}
- backlog.intro: Réservoir brut de toutes les idées. Jamais purgé, seulement archivé.
- backlog.heading.high: Priorité haute
- backlog.heading.medium: Priorité moyenne
- backlog.heading.low: Priorité basse
- backlog.heading.completed: Terminé
- backlog.heading.how_to_use: Comment utiliser ce backlog
- backlog.none_open: (rien en cours)

## GLOSSARY.md

Optionnel, créé au premier besoin (pas de titres fixes — liste plate ou
groupée par thème).

- glossary.title: GLOSSARY — {project}
- glossary.intro: Termes propres à ce projet, et ce qu'ils signifient ici.

## SUBPROJECTS.md

Optionnel, créé au premier besoin (une section de prose par sous-projet, pas
de titres fixes en dehors des noms des sous-projets).

- subprojects.title: SUBPROJECTS — {project}
- subprojects.intro: Les sous-projets rattachés à ce projet : pourquoi chacun existe, où il en est, et où trouver ses propres fichiers.

## brand/FOUNDATIONS.md

Écrit par `brace:brand` (voir `skills/brand/references/`). `journey`
seulement pour une marque perso.

- brand.foundations.title: FOUNDATIONS — {project}
- brand.foundations.intro: Qui on est et pourquoi. La base durable contre laquelle tout autre choix de marque est jugé.
- brand.foundations.heading.purpose: Raison d'être
- brand.foundations.heading.personality: Personnalité
- brand.foundations.heading.emotion: Émotion cœur
- brand.foundations.heading.story: Histoire de marque
- brand.foundations.heading.journey: Parcours
- brand.foundations.heading.name: Nom

## brand/STRATEGY.md

`architecture` seulement si le projet a des sous-marques ou des
sous-projets ; `packaging` et `channels` seulement pour une marque perso. La
section `touchpoints` liste les fichiers du repo entre accents graves : un
hook la lit.

- brand.strategy.title: STRATEGY — {project}
- brand.strategy.intro: Où on joue et face à qui. Se révise dans le temps.
- brand.strategy.heading.objectives: Objectifs
- brand.strategy.heading.personas: Personas
- brand.strategy.heading.landscape: Paysage concurrentiel
- brand.strategy.heading.differentiators: Différenciateurs
- brand.strategy.heading.positioning: Positionnement
- brand.strategy.heading.mechanism: Mécanisme
- brand.strategy.heading.proof: Preuves
- brand.strategy.heading.indicator: Indicateur
- brand.strategy.heading.touchpoints: Points de contact
- brand.strategy.heading.architecture: Architecture de marque
- brand.strategy.heading.packaging: Packaging
- brand.strategy.heading.channels: Canaux et cadence
- brand.strategy.heading.non_goals: Non-objectifs

## brand/VOICE.md

- brand.voice.title: VOICE — {project}
- brand.voice.intro: Comment la marque parle. Les textes publics y sont confrontés.
- brand.voice.heading.exercise: La voix d'abord
- brand.voice.heading.attributes: Attributs de voix
- brand.voice.heading.tone: Ton selon le contexte
- brand.voice.heading.lexicon: Lexique
- brand.voice.heading.mechanics: Règles d'écriture
- brand.voice.heading.pillars: Piliers de message
- brand.voice.heading.tagline: Tagline et présentation

## brand/DECISIONS.md

Append-only, séparé du `DECISIONS.md` principal du projet.

- brand.decisions.title: DÉCISIONS DE MARQUE — {project}
- brand.decisions.intro: Les choix de marque : ce qui a été essayé, pourquoi c'est écarté, ce qui est retenu.

## Brand notifications

The macOS notification sent when a brand presentation is ready.

- brand.notify.title: BRACE
- brand.notify.ready: Ta présentation de marque est prête.

## Shared

- shared.to_fill_in: à compléter
- shared.none_yet: Aucune entrée pour l'instant.
