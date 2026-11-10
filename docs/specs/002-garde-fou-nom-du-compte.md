---
status: in-progress
context: [architecture.md#release, architecture.md#ce-qui-est-publié]
---
# SPEC-002: Refuser de publier un skill qui contient le nom du compte
## Why
Le masquage ne couvre que le bloc Config. Un skill ajouté à `published.txt` sans bloc Config, ou dont la copie sur disque est encore une ancienne version, part tel quel avec ses repos personnels. Le 2026-11-10, seule la relecture du diff a empêché la publication de `note` et `skills-release` dans cet état. La protection ne doit pas dépendre d'une relecture qu'on peut oublier.
## Acceptance criteria
- [ ] AC1: If the published copy of a skill contains the account name of the share repository's owner, then release.sh shall publish nothing for that skill and print the offending lines.
- [ ] AC2: When the account name appears only as a Config value, release.sh shall publish the skill with the value masked.
- [ ] AC3: Where RELEASE_OWNER is set, release.sh shall use it as the account name instead of the owner of the `origin` remote.
- [ ] AC4: If the account name cannot be determined, then release.sh shall say the check was skipped and continue.
## Out of scope
- Détecter d'autres données personnelles (noms de projets, sigles, initiales) : relecture du diff par `skills-release`.
## Open questions
## Plan
## Implementation notes
