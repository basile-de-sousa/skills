# skills

Mes skills pour Claude, versionnés.

> **Ce repo est un miroir.** La source de vérité de chaque skill est sa version sur claude.ai.
> Ici : un snapshot par release, son historique, et le zip à installer.

## Skills publiés

| Skill | Rôle |
|---|---|
| [spec](skills/spec/SKILL.md) | Workflow spec-driven pour un repo git : specs, ADR, docs de vérité courante, exécution |
| [trad](skills/trad/SKILL.md) | Entraînement à l'anglais : traduction FR↔EN avec reformulations |
| [pin](skills/pin/SKILL.md) | Épingler un outil, site, techno, idée ou lecture avec un « utile quand », dans ton propre repo GitHub |
| [buzzword](skills/buzzword/SKILL.md) | Fiche ultra-courte pour comprendre et expliquer à l'oral un terme de stratégie IT ou d'architecture SI |

## Installer un skill

1. Ouvrir [Releases](../../releases) et télécharger le zip du skill voulu.
2. L'ajouter à ses skills dans claude.ai.
3. Si le skill a un bloc Config à `<à définir>`, il te demandera tes valeurs (par exemple ton repo de données) au premier lancement.

Avec Claude Code, copier le dossier `skills/<nom>/` dans `~/.claude/skills/` suffit.

## Historique

- `git log --oneline --grep "release: <skill>"` : les versions d'un skill, avec leur note.
- [docs/architecture.md](docs/architecture.md) : comment ce repo fonctionne.
