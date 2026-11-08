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

## brand/BRIEF.md

Le brief client : pré-rempli par `brace:brand` à partir de ce que le projet
dit déjà, validé avec l'utilisateur à l'atelier.

- brand.brief.title: BRIEF DE MARQUE — {project}
- brand.brief.intro: Ce que tu as demandé à l'agence. On l'a pré-rempli à partir de ce qu'on a lu dans ton projet. Dis-nous ce qui ne te ressemble pas.
- brand.brief.heading.project: Le projet
- brand.brief.heading.objectives: Ce que la marque doit obtenir
- brand.brief.heading.audience: Pour qui
- brand.brief.heading.competitors: Les concurrents que tu connais
- brand.brief.heading.name: Le nom
- brand.brief.heading.taste: Ce que tu aimes
- brand.brief.heading.emotion: L'émotion à laisser
- brand.brief.heading.never: Ce que tu ne veux surtout pas
- brand.brief.heading.languages: Les langues (principale, secondaires)

## brand/SESSIONS.md

Append-only, une entrée par séance.

- brand.sessions.title: SÉANCES DE MARQUE — {project}
- brand.sessions.intro: Une entrée par séance avec l'agence : ce qui est décidé, ce qui attend, ce qui vient ensuite.
- brand.sessions.decided: Décidé
- brand.sessions.waiting: En attente
- brand.sessions.next: Suite
- brand.sessions.meeting: Prochain rendez-vous

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

## Notifications de marque

La notification macOS envoyée quand une présentation de marque est prête.

- brand.team.brand.name: Julie
- brand.team.brand.role: directrice de clientèle
- brand.team.analyst.name: Ravi
- brand.team.analyst.role: analyste
- brand.team.strategist.name: Constance
- brand.team.strategist.role: stratège
- brand.team.copywriter.name: Ben
- brand.team.copywriter.role: rédacteur
- brand.team.creative_director.name: Lou
- brand.team.creative_director.role: directrice de création
- brand.lex.contact: prise de contact
- brand.lex.proposal: proposition
- brand.lex.kickoff: réunion de lancement
- brand.lex.workshop: atelier de cadrage
- brand.lex.minutes: compte rendu
- brand.lex.meeting: rendez-vous
- brand.lex.recommendation: recommandation stratégique
- brand.lex.routes: territoires
- brand.lex.platform: plateforme de marque
- brand.lex.editorial_guide: charte éditoriale
- brand.lex.manifesto: manifeste
- brand.lex.delivery: livraison
- brand.lex.client_space: espace client
- brand.lex.test_plan: plan de test
- brand.lex.benchmark: benchmark concurrentiel
- brand.lex.personas: personas
- brand.lex.rebrand: rebranding
- brand.lex.audit: audit de marque
- brand.lex.transition: plan de transition
- brand.lex.announcement: annonce
- brand.lex.before: aujourd'hui
- brand.lex.after: demain
- brand.lex.archive: archive
- brand.space.title: Ta marque, {project}
- brand.space.next: Prochain rendez-vous
- brand.space.ask: Ce qu'on attend de toi
- brand.space.none: Rien pour l'instant.
- brand.space.short: espace client
- brand.space.days: lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche
- brand.space.months: janvier, février, mars, avril, mai, juin, juillet, août, septembre, octobre, novembre, décembre
- brand.space.date: {day} {date} {month}{year}
- brand.space.at: {when} à {time}
- brand.space.time: {h} h {mm}
- brand.space.time_whole: {h} h
- brand.space.tab.home: Accueil
- brand.space.tab.meetings: Rendez-vous
- brand.space.tab.documents: Documents
- brand.space.tab.presentations: Présentations
- brand.space.tab.brand: Ma marque
- brand.space.block.purpose: Raison d'être
- brand.space.block.positioning: Positionnement
- brand.space.block.emotion: Émotion
- brand.space.block.tagline: Signature
- brand.space.block.lexicon: Nos mots
- brand.phase.contact: Prise de contact et proposition
- brand.phase.framing: Atelier de cadrage
- brand.phase.strategy: Recommandation stratégique
- brand.phase.platform: Plateforme de marque
- brand.phase.visual: Identité visuelle
- brand.phase.delivery: Livraison
- brand.doc.by: {name}, {role}
- brand.notify.title: BRACE
- brand.notify.ready: Le travail de l'agence est prêt.

## Shared

- shared.to_fill_in: à compléter
- shared.none_yet: Aucune entrée pour l'instant.
