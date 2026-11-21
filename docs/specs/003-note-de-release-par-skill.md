---
status: draft
context: [architecture.md#release]
---
# SPEC-003: Une note de release ne s'applique qu'à un seul skill
## Why
`RELEASE_NOTE` est recopiée dans le commit de **chaque** skill publié par un même lancement. Le 2026-11-21, une release de `spec` a aussi préparé `pin` et `sonar`, dont des modifications déjà enregistrées sur claude.ai n'avaient jamais été publiées : les deux commits portaient la note de `spec`. Seule la relecture du diff avant le push l'a évité, et il a fallu réécrire les commits à la main. Une note fausse sur une Release publique trompe ceux qui installent le skill, et la protection ne doit pas dépendre d'une relecture.
## Acceptance criteria
- [ ] AC1: When release.sh is given skill names as arguments, the system shall release only those skills.
- [ ] AC2: If an argument is not a skill listed in published.txt, then release.sh shall create no commit, name the argument and exit with a non-zero code.
- [ ] AC3: If RELEASE_NOTE is set and more than one skill would be released, then release.sh shall create no commit, list the skills that differ and exit with a non-zero code.
- [ ] AC4: When RELEASE_NOTE is set and exactly one skill is released, release.sh shall use the note as the body of that skill's release commit.
- [ ] AC5: When RELEASE_NOTE is not set, release.sh shall release every skill that differs, each without a commit body.
## Out of scope
- Une note par skill dans un même lancement (fichier de notes, une variable par skill) : plus de mécanique pour un cas rare. Relancer le script une fois par skill suffit.
- Le skill `skills-release` : il devra lancer le script avec le nom du skill modifié, et dire quels autres skills diffèrent. Ce changement se fait sur claude.ai, pas ici.
## Open questions
## Plan
## Implementation notes
