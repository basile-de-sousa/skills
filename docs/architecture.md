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
3. Pour chaque skill modifié : un commit `release: <nom>-<version>`.
4. Au push sur `main`, la GitHub Action crée pour chaque commit de release le tag du même nom, construit `<nom>.zip` et l'attache à une Release. Pourquoi la CI et non la session : une session Claude ne peut pas pousser de tags. Le zip n'est jamais commité : un binaire n'a pas de diff.

La copie sur disque suit claude.ai en quelques secondes, même en cours de session (vérifié le 2026-11-10 : skill enregistré à 22:07:03 UTC, présent sur disque à 22:07:07). Une release peut donc suivre une modification dans la même conversation ; c'est ce que fait le skill `skills-release`, qui propose la release après chaque modification acceptée.

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

Publiés : `spec`, `trad`, `pin`, `buzzword`.
En attente de leur bloc Config : `note`, `skills-release`.
Non publiés, par choix : `methodo`, `sonar` (pas partagés pour l'instant), `grill-me-solo`, `skill-audit`.
