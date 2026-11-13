# Architecture

## Trois endroits, trois rôles
| Endroit | Rôle |
|---|---|
| **claude.ai** | Source de vérité du skill : c'est là qu'il est modifié et utilisé |
| **Repo du skill** (souvent privé : ses données, ses specs, ses ADR) | Le pourquoi des choix, suivi avec `/spec` |
| **Ce repo** (public) | Partage : un snapshot par release, l'historique, le zip à installer |

`skills/` n'est jamais édité à la main. ([ADR-001](adr/001-source-de-verite-claude-ai.md))

## Structure
| Chemin | Contenu |
|---|---|
| `skills/<nom>/` | Snapshot dézippé du skill à sa dernière release |
| `published.txt` | Liste des skills publiés |
| `docs/` | Docs de ce repo uniquement |
| `scripts/release.sh` | La release |
| `.github/workflows/release.yml` | Tag, zip et Release GitHub pour chaque commit de release |

## Release
1. Les skills du compte sont synchronisés sur le disque de chaque session Claude. `scripts/release.sh` copie ceux de `published.txt` dans `skills/`.
2. Si le `SKILL.md` a un bloc Config (entre `<!-- config -->` et `<!-- /config -->`), ses valeurs entre backticks sont remplacées par `<à définir>`. Le snapshot est donc la copie de claude.ai moins la config personnelle. Le script échoue fermé : bloc mal formé, ou valeur masquée encore présente ailleurs dans le skill, et rien n'est publié pour ce skill.
3. Si la copie contient encore le nom du compte propriétaire de ce repo (lu sur le remote `origin`, ou `RELEASE_OWNER`), rien n'est publié pour ce skill. Pourquoi : c'est le signe d'un skill sans bloc Config ou d'une copie sur disque pas encore à jour, et la relecture du diff ne doit pas être le seul filet.
4. Pour chaque skill modifié : un commit `release: <nom>-<version>`.
5. Au push sur `main`, la GitHub Action crée pour chaque commit de release le tag du même nom, construit `<nom>.zip` et l'attache à une Release. Pourquoi la CI et non la session : une session Claude ne peut pas pousser de tags. Le zip n'est jamais commité : un binaire n'a pas de diff.

La copie sur disque suit claude.ai en cours de session, mais avec un délai variable : quelques secondes le plus souvent, plusieurs minutes parfois (observé le 2026-11-10 : deux skills enregistrés à 22:43 UTC encore absents à 22:45). Une release peut donc suivre une modification dans la même conversation, à condition de vérifier d'abord que la copie contient la modification ; c'est ce que fait le skill `skills-release`. Publier sans vérifier, c'est risquer de publier l'ancienne version.

Aucun téléchargement manuel. Version : date de la release, `AAAA.MM.JJ` (suffixe `.2`, `.3` le même jour). Pourquoi : aucune décision humaine à chaque release ; le diff et la note de release disent ce qui change.

La release part d'une session Claude et non d'une CI sur le repo du skill. Pourquoi : le texte du skill n'existe que sur claude.ai, qu'une CI ne peut pas lire ; seule une session en a la copie.

Un skill sans repo (`trad`, `note`) n'a ni specs ni ADR : son historique ici et ses notes de release suffisent.

La note de release (`RELEASE_NOTE`) résume le changement pour ceux qui installent le skill. Le raisonnement complet reste dans le repo du skill.

## Ce qui est publié
Le repo est public, sans licence (choix de Basile). Un skill entre dans `published.txt` quand :
- il fonctionne chez quelqu'un d'autre : ce qui est propre à l'utilisateur (repo de données) tient dans son bloc Config, masqué à la release, et le skill le demande quand il vaut `<à définir>` ;
- un bloc Config ne contient jamais de secret (jeton, mot de passe) ;
- ses exemples ne contiennent rien de personnel (projets, idées de produit) ;
- Basile en est l'auteur.

Publiés : `spec`, `trad`, `pin`, `buzzword`, `note`, `skills-release`, `sonar`.
Non publiés, par choix : `methodo` (pas partagé pour l'instant), `grill-me-solo`, `skill-audit`.
