---
status: done
context: [architecture.md#release]
---
# SPEC-003: Une note de release ne s'applique qu'à un seul skill
## Why
`RELEASE_NOTE` est recopiée dans le commit de **chaque** skill publié par un même lancement. Le 2026-11-21, une release de `spec` a aussi préparé `pin` et `sonar`, dont des modifications déjà enregistrées sur claude.ai n'avaient jamais été publiées : les deux commits portaient la note de `spec`. Seule la relecture du diff avant le push l'a évité, et il a fallu réécrire les commits à la main. Une note fausse sur une Release publique trompe ceux qui installent le skill, et la protection ne doit pas dépendre d'une relecture.
## Acceptance criteria
- [x] AC1: When release.sh is given skill names as arguments, the system shall release only those skills.
- [x] AC2: If an argument is not a skill listed in published.txt, then release.sh shall create no commit, name the argument and exit with a non-zero code.
- [x] AC3: If RELEASE_NOTE is set and more than one skill would be released, then release.sh shall create no commit, list the skills that differ and exit with a non-zero code.
- [x] AC4: When RELEASE_NOTE is set and exactly one skill is released, release.sh shall use the note as the body of that skill's release commit.
- [x] AC5: When RELEASE_NOTE is not set, release.sh shall release every skill that differs, each without a commit body.
## Out of scope
- Une note par skill dans un même lancement (fichier de notes, une variable par skill) : plus de mécanique pour un cas rare. Relancer le script une fois par skill suffit.
- Le skill `skills-release` : il devra lancer le script avec le nom du skill modifié, et dire quels autres skills diffèrent. Ce changement se fait sur claude.ai, pas ici.
## Open questions
## Plan
1. Tests d'acceptation dans `scripts/test-release.sh`.
2. `scripts/release.sh` en deux passes : préparer tous les skills, puis commiter.
3. Docs de vérité courante.
## Implementation notes
- Deux passes : la première copie, masque, vérifie et met en index sans commiter, pour pouvoir tout annuler si la note ne peut pas s'appliquer ; la seconde fait un commit par skill, limité à son dossier.
- AC5 passait déjà avant l'implémentation : c'est un critère de non-régression.
- Un skill nommé en argument mais absent du cache reste « Ignoré », comme sans argument.
- Suggestion : le skill `skills-release` devrait lancer le script avec le nom du skill modifié et signaler les autres skills qui diffèrent (à faire sur claude.ai).
