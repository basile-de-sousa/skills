# ADR-001: La source de vérité d'un skill est claude.ai, ce repo est une vitrine de partage
Status: accepted - Date: 2026-11-10
Type: process · Scope: all
## Context
Les skills sont créés et modifiés en conversation sur claude.ai, qui ne garde ni historique ni diff et ne permet pas de les partager simplement. Objectifs : historique, pourquoi des choix, partage. Voir [architecture.md](../architecture.md).
## Decision
- claude.ai reste la source de vérité.
- Le pourquoi (specs, ADR) vit dans le repo de chaque skill, suivi avec `/spec`.
- Ce repo public ne sert qu'au partage : un snapshot dézippé par skill, un tag par release, un zip construit par une GitHub Action.
- La release est lancée depuis une session Claude, qui copie le cache synchronisé des skills.
## Alternatives rejected (and why)
- **Repo comme source de vérité** : il faudrait ré-importer le skill dans claude.ai après chaque changement, alors que les modifications se font en conversation.
- **Zip commité à chaque release** : binaire sans diff, et téléchargement manuel qui finirait par être sauté.
- **Docs de tous les skills dans ce repo** (dossier unique trié par `Scope`, ou un dossier par skill) : détourne le format de `/spec`, et rend public un raisonnement qui cite des projets personnels.
- **CI sur le repo de chaque skill** : le texte du skill n'y est pas, et une CI ne peut pas lire claude.ai.
## Consequences
- `skills/` ne doit jamais être édité à la main.
- Ce repo peut être en retard sur claude.ai entre deux releases : c'est attendu.
- Le pourquoi détaillé n'est pas public ; seule la note de release l'est.
