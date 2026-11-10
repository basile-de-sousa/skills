---
name: "buzzword"
description: "Fiche ultra-courte pour comprendre et expliquer à l'oral un terme de stratégie IT ou d'architecture SI (préparation d'entretiens). Utiliser quand l'utilisateur envoie un mot, un acronyme ou une notion, ou tape /buzzword save."
---

# Buzzword

## Config
<!-- config -->
- Repo de données : `<à définir>`
<!-- /config -->

Le **repo de données** est le repo GitHub où `/buzzword save` range les fiches. Si sa valeur est `<à définir>`, afficher une fiche reste possible sans rien demander ; sur `/buzzword save`, demander à l'utilisateur son repo (`compte/nom`), puis proposer une modification de ce skill qui l'inscrit dans le bloc Config. Pourquoi : un skill n'a pas de mémoire propre, ce bloc est le seul endroit qui tient d'une conversation à l'autre. Il ne contient jamais de secret (jeton, mot de passe).

Objectif : permettre de comprendre une notion en quelques secondes et de l'expliquer à l'oral en entretien. Priorité absolue à la concision : une image mentale simple, pas d'exhaustivité.

Trois usages :
- `/buzzword <terme>` : afficher la fiche, immédiatement. **Aucun outil, aucune sauvegarde.**
- `/buzzword save` : enregistrer dans le repo toutes les fiches de la conversation (voir « Sauvegarde »).
- `/buzzword` seul : aide (voir plus bas).

## Aide : `/buzzword` seul

Réponse immédiate, **aucun outil** : expliquer le skill, pas l'état du repo.

```
**/buzzword** : une fiche courte pour comprendre une notion et l'expliquer à l'oral.
- `/buzzword <terme>` : la fiche, tout de suite (ex. `/buzzword ESB`)
- `/buzzword save` : enregistre les fiches de la conversation dans ton glossaire (repo et site)
```

Ajouter **une seule ligne de conseil**, seulement si la conversation en donne l'occasion, par exemple :
- des fiches affichées mais pas enregistrées → `2 fiches pas encore enregistrées (GPU, APU) : /buzzword save` ;
- un terme technique qui revient dans la discussion → `Pour l'expliquer en entretien : /buzzword RAG`.

Sinon, rien de plus.

## Format

**Nom complet (ACRONYME, ou synonyme courant)**
- Puces courtes et pragmatiques qui expliquent la notion. Nombre libre, souvent 1 à 3. Angles utiles : « Conceptuellement : … », « Techniquement : … », « Sert à : … ».
- Ex : 2 à 3 produits ou acteurs parmi les plus connus, avec leur nom réel et actuel.
- Buzzwords : notions associées, reliées par des opérateurs.

## Opérateurs

- `< X` : la notion est comprise dans X (ESB < EAI).
- `> X` : la notion comprend X. À réserver aux cas importants, car cet opérateur devient vite exhaustif.
- `& X` : notion voisine dans le même domaine, qui se substitue ou se complète (ESB & API Gateway).
- `= X` : synonyme (ESB = Integration Bus).
- `≠ X` : faux-ami souvent confondu (ESB ≠ ETL).

## Règles

- Mettre en **gras** les mots-clés importants dans les puces d'explication : ceux qui portent l'idée et qu'il faut placer à l'oral (ex. **routage**, **orchestration**, **transformation**). 2 à 4 mots par puce au maximum, pour que le gras reste lisible en un coup d'œil.
- Pas d'introduction ni de conclusion : la fiche seule.
- Pas d'historique ni de détails d'implémentation.
- Noms de produits exacts et actuels (ex. IBM App Connect, pas « IBM ESB »). En cas de doute sur l'état actuel d'un produit, vérifier.
- Si la notion est legacy ou en déclin, l'indiquer en quelques mots dans une puce.
- Répondre en français, en gardant les termes techniques anglais usuels.

## Exemple

**Enterprise Service Bus (ESB)**
- Conceptuellement : un modèle d'**architecture orientée services (SOA)**.
- Techniquement : un **middleware** qui assure le **routage**, l'**orchestration** et la **transformation** des données entre applications.
- Ex : TIBCO BusinessWorks, IBM App Connect, MuleSoft.
- Buzzwords : < EAI, < SOA, & API Gateway, = Integration Bus, ≠ ETL

## Sauvegarde : `/buzzword save`

Uniquement sur `/buzzword save`. Enregistrer **toutes les fiches affichées dans la conversation** dans le repo de données (bloc Config), branche `main`, en **un seul commit**. Si une notion a été affichée plusieurs fois, garder la dernière version.

### Comment écrire dans le repo

1. Si le repo n'est pas déjà dans la session, l'ajouter avec un accès en écriture (push), via l'outil d'ajout de repository GitHub de la session.
2. Le cloner (`git clone --depth 1`), ou faire `git pull` s'il est déjà cloné.
3. Écrire les fichiers, `git add`, un seul `git commit`, `git push origin main`.
4. L'intégration GitHub de synchronisation des sources d'un Project est en lecture seule : elle ne permet pas d'écrire. Ne pas s'arrêter là.

### Pas de doublon

Avant d'écrire, comparer chaque fiche aux frontmatters existants (`term`, `acronym`, `aliases`), **sur le sens** et pas seulement sur le slug : la même notion peut exister sous son acronyme, sa traduction ou un synonyme (« Calcul haute performance » = High-Performance Computing).

- **Même notion** : remplacer la fiche existante (même slug), en conservant `created` et en fusionnant `aliases` et `tags`.
- **Notion voisine** (l'une contient l'autre, par exemple) : créer la fiche et relier les deux par `relations`.
- `acronym` : uniquement l'acronyme **propre** à la notion. Ne jamais reprendre celui d'une notion qui la contient (Supercalculateur n'a pas l'acronyme HPC : il est `in: [HPC]`).

### Fichier par fiche

- Chemin : `buzzwords/<slug>.md`. Slug = nom complet en kebab-case, sans accents (ex. `enterprise-service-bus`).
- Si le fichier existe déjà : le remplacer en conservant sa date `created`, et mettre `updated` à la date du jour.
- Contenu : le frontmatter ci-dessous, puis le corps de la fiche en Markdown **sans la ligne « Buzzwords : »** (ses relations passent dans le frontmatter, le site les affiche).

```markdown
---
term: Enterprise Service Bus
slug: enterprise-service-bus
acronym: ESB
aliases: [Integration Bus]
tags: [integration, middleware]
relations:
  in: [EAI, SOA]           # <
  contains: []             # >
  near: [API Gateway]      # &
  same: [Integration Bus]  # =
  not: [ETL]               # ≠
created: 2026-09-26
updated: 2026-09-26
---
**Enterprise Service Bus (ESB)**
- Conceptuellement : ...
- Techniquement : ...
- Ex : ...
```

- Champs obligatoires : `term`, `slug`, `created`, `updated`. Omettre `acronym`, `aliases`, `tags` ou une liste de `relations` quand ils sont vides.
- Relations : chaque notion de la ligne « Buzzwords : » va dans la liste de son opérateur, écrite comme dans la fiche (acronyme ou nom usuel).
- Tags : 1 à 3, en minuscules kebab-case, domaines larges (ex. `cloud`, `integration`, `data`, `securite`, `gouvernance`). Réutiliser un tag déjà présent dans `buzzwords/` plutôt qu'en inventer un proche.

### Commit et confirmation

- Message : `docs(buzzword): add ESB, CDC, FinOps` (termes courts, `update` si seules des mises à jour ; `add` et `update` séparés par `;` si les deux).
- Réponse, uniquement après un `git push` réussi : une ligne `Sauvegardé : N fiches (commit <sha court>)`, suivie de la liste des fichiers, avec `(mise à jour)` pour une fiche qui existait déjà.
- Aucune fiche dans la conversation : le dire en une ligne.
- Échec : `Non sauvegardé : <raison en quelques mots>`. Ne jamais écrire « Sauvegardé » sans commit poussé.