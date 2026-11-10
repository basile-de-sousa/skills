---
name: "skills-release"
description: "Publier la release d'un skill dans le repo de partage. Utiliser juste après avoir proposé la création ou la modification d'un skill de l'utilisateur, ou sur /skills-release et « release les skills »."
---

# /skills-release

## Config
<!-- config -->
- Repo de partage : `<à définir>`
<!-- /config -->

Le **repo de partage** est le repo GitHub public où sont publiées les releases. Si sa valeur est `<à définir>`, demander à l'utilisateur son repo (`compte/nom`) avant toute release, puis proposer une modification de ce skill qui l'inscrit dans le bloc Config. Ce repo doit contenir la procédure de release (`CLAUDE.md`, `scripts/release.sh`, `published.txt`) : le plus simple est de partir d'une copie du repo où ce skill a été trouvé. Le bloc ne contient jamais de secret (jeton, mot de passe).

Chaque modification acceptée d'un skill devient une release dans le repo de partage, sans que l'utilisateur ait à y penser. La source de vérité d'un skill reste claude.ai ; le repo en garde l'historique et sert au partage.

## Quand

- **Juste après une carte de création ou de modification d'un skill** dans la conversation : terminer la réponse par une ligne, « Dis-moi quand la modification de `<skill>` est enregistrée, je lance la release. » Pourquoi demander : la carte peut être refusée ou retouchée avant l'enregistrement, seule la réponse de l'utilisateur dit ce qui est réellement sur claude.ai.
- **Une release par modification acceptée**, par défaut : l'historique reste fin, même avec plusieurs changements dans la journée. Limite : si l'utilisateur enchaîne visiblement des retouches du même skill, proposer une seule release à la fin plutôt que d'interrompre chaque itération.
- **`/skills-release` ou « release les skills »** sans modification dans la conversation : publier tout skill suivi qui diffère du repo.
- **`/skills-release ?`** : dire quels skills suivis diffèrent du repo, sans rien publier.
- **Skill non suivi** (absent de `published.txt`) : ne pas le publier. Le dire une fois, avec le critère qui manque (voir `docs/architecture.md` du repo), et proposer de l'ajouter s'il les remplit.

## Comment

1. **Ouvrir le repo de partage** avec droit d'écriture et suivre son `CLAUDE.md`. Pourquoi : la procédure vit dans le repo (`scripts/release.sh`), où elle est versionnée et testable ; ce skill dit seulement quand la lancer et quoi vérifier. Si le repo et ce skill se contredisent sur la procédure, le repo a raison.
2. **Vérifier que la copie du skill sur le disque de la session contient la modification** (chercher une phrase qui vient de changer). Pourquoi : le script publie cette copie, et elle peut dater du début de la session. Si elle est ancienne, ne rien publier : le dire, et proposer de relancer « release les skills » dans une nouvelle conversation. Ne pas reconstruire le skill à partir de la carte : l'utilisateur a pu la retoucher avant d'enregistrer, et le repo ne doit contenir que ce qui est sur claude.ai.
3. **Écrire la note de release** (`RELEASE_NOTE`) : une ou deux phrases sur ce qui change et pourquoi, pour quelqu'un qui installe le skill. Elle est disponible ici mieux que nulle part ailleurs, puisque la modification vient d'être discutée.
4. **Lancer le script, puis relire le diff avant de pousser.** Pourquoi : le repo est public et un push ne se rattrape pas vraiment. Relire le diff de **chaque** commit de release, pas seulement celui du skill attendu : une release pour un skill que personne n'a modifié signale un défaut du script, pas un changement. Si le diff ajoute un repo ou un compte personnel, un projet personnel ou une idée de produit, ne pas pousser : montrer la ligne et demander.
5. **Pousser.** La CI crée le tag, le zip et la Release. Confirmer en une ligne : version et lien de la Release. Si la CI échoue, le dire avec la cause.

## Limites

- Sans environnement d'exécution (shell et git), dire que la release demande une session qui en a un, et ne rien simuler.
- Le raisonnement détaillé derrière un changement ne va pas dans ce repo : quand le skill a son propre repo, `/spec` l'y consigne (specs, ADR). Un skill sans repo n'a que sa note de release, et c'est suffisant.
- Ne jamais éditer `skills/` à la main dans le repo : un changement passe par claude.ai, puis par une release.