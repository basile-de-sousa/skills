# skills

Vitrine de partage des skills claude.ai de Basile : snapshots de release et zips à installer.
La source de vérité d'un skill est claude.ai, jamais `skills/` (voir docs/adr/001).

- Docs : [docs/README.md](docs/README.md). Workflow : skill `/spec`.
- **Ne pas éditer `skills/` à la main** : un changement se fait sur claude.ai, puis arrive ici par une release. Pourquoi : deux endroits modifiables finissent par diverger.
- **Faire une release** (« release les skills ») : `sh scripts/release.sh` puis `git push` (la CI crée tags, zips et Releases). Résumer le changement dans `RELEASE_NOTE` ; le raisonnement complet va dans le repo du skill (ses specs et ADR), pas ici.
- Publier un nouveau skill : vérifier les critères de docs/architecture.md, puis l'ajouter à `published.txt` et au tableau du README.
- Commits : Conventional Commits. Vérification : `sh scripts/test-release.sh`.
