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
2. Pour chaque skill modifié : un commit `release: <nom>-<version>`.
3. Au push sur `main`, la GitHub Action crée pour chaque commit de release le tag du même nom, construit `<nom>.zip` et l'attache à une Release. Pourquoi la CI et non la session : une session Claude ne peut pas pousser de tags. Le zip n'est jamais commité : un binaire n'a pas de diff.

Aucun téléchargement manuel. Version : date de la release, `AAAA.MM.JJ` (suffixe `.2`, `.3` le même jour). Pourquoi : aucune décision humaine à chaque release ; le diff et la note de release disent ce qui change.

La release part d'une session Claude et non d'une CI sur le repo du skill. Pourquoi : le texte du skill n'existe que sur claude.ai, qu'une CI ne peut pas lire ; seule une session en a la copie.

La note de release (`RELEASE_NOTE`) résume le changement pour ceux qui installent le skill. Le raisonnement complet reste dans le repo du skill.

## Ce qui est publié
Le repo est public, sans licence (choix de Basile). Un skill entre dans `published.txt` quand :
- il fonctionne chez quelqu'un d'autre : aucun repo ou compte personnel codé en dur ;
- ses exemples ne contiennent rien de personnel (projets, idées de produit) ;
- Basile en est l'auteur.

Publiés : `spec`, `trad`.
En attente de paramétrage : `pin` d'abord, puis `sonar`, `buzzword`, `methodo`, `note`. La spec de ce travail vit dans le repo de chaque skill.
Non publiés, par choix : `grill-me-solo`, `skill-audit`.

## Open questions
- **Fraîcheur du cache** : la copie sur disque date probablement du début de la session ; une release lancée juste après une modification dans la même conversation pourrait publier l'ancienne version. Réglé par : un test à la prochaine modification d'un skill.
- **Skills sans repo** (`trad`, `note`) : où va leur pourquoi le jour où ils en ont un ? Réglé par : le premier cas réel ; d'ici là, la note de release suffit.
