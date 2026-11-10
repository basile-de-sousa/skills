---
status: done
context: [architecture.md#release, architecture.md#ce-qui-est-publié]
---
# SPEC-001: Masquer le bloc Config d'un skill à la release
## Why
Un skill peut contenir un bloc Config avec des valeurs propres à son utilisateur (un repo de données). Ce repo est public : ces valeurs ne doivent pas y arriver, et celui qui installe le skill doit recevoir un bloc à remplir.

Format du bloc dans `SKILL.md` :

    ## Config
    <!-- config -->
    - Repo de données : `compte/nom`
    <!-- /config -->
## Acceptance criteria
- [x] AC1: When a skill's SKILL.md contains a Config block, release.sh shall replace each backtick value inside the block with `<à définir>` in the published copy.
- [x] AC2: If a Config block has no closing marker, or one of its list lines has no backtick value, then release.sh shall publish nothing for that skill and report why.
- [x] AC3: If a masked value still appears elsewhere in the published copy of the skill, then release.sh shall publish nothing for that skill and print the offending lines.
- [x] AC4: When a skill has no Config block, release.sh shall publish it unchanged.
- [x] AC5: When only Config values changed since the last release, release.sh shall create no release commit.
## Out of scope
- Détecter des données personnelles hors du bloc Config par d'autres moyens : c'est la relecture du diff par le skill `skills-release`.
- Les secrets : un bloc Config n'en contient jamais.
## Open questions
## Plan
1. Tests d'acceptation dans `scripts/test-release.sh` (repo jetable + faux cache).
2. `mask_config` et `restore` dans `scripts/release.sh`.
3. Docs de vérité courante, tests dans la CI.
## Implementation notes
- Masquage en `awk` (POSIX, aucune dépendance).
- Une valeur courte et banale dans le bloc (par exemple `main`) apparaîtra forcément ailleurs et bloquera la release : c'est le comportement voulu, le bloc est fait pour des valeurs propres à l'utilisateur.
- Le script sort en erreur dès qu'un skill n'a pas pu être publié, mais publie quand même les autres.
- Suggestion : `skills-release` pourrait tourner `/skills-release ?` en lecture seule à partir de `git diff` après un essai à blanc ; pas fait, hors spec.
