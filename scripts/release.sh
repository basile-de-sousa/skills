#!/bin/sh
# Copie les skills listés dans published.txt depuis le cache claude.ai de la session
# vers skills/, puis crée un commit et un tag par skill modifié.
# Usage : sh scripts/release.sh            (puis : git push --follow-tags)
#   RELEASE_NOTE="pourquoi ce changement"  -> corps du commit, repris dans la Release GitHub
#   SKILLS_DIR=/chemin/du/cache            -> si le cache n'est pas à l'endroit habituel
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC=${SKILLS_DIR:-}
if [ -z "$SRC" ]; then
  for m in "$HOME"/.claude/skills/synced/*/manifest.json; do
    [ -f "$m" ] && SRC=$(dirname "$m") && break
  done
fi
if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
  echo "Cache des skills introuvable. Indiquer SKILLS_DIR=/chemin." >&2; exit 1
fi
cd "$ROOT"
if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree non propre : commiter ou mettre de côté avant la release." >&2; exit 1
fi
released=""
while read -r name; do
  case "$name" in ''|'#'*) continue ;; esac
  if [ ! -f "$SRC/$name/SKILL.md" ]; then
    echo "Ignoré : $name absent du cache." >&2; continue
  fi
  rm -rf "skills/$name"; mkdir -p skills; cp -R "$SRC/$name" "skills/$name"
  git add -A "skills/$name"
  if git diff --cached --quiet; then continue; fi
  ver=$(date -u +%Y.%m.%d); tag="$name-$ver"; n=2
  while git rev-parse -q --verify "refs/tags/$tag" >/dev/null; do
    tag="$name-$ver.$n"; n=$((n + 1))
  done
  if [ -n "${RELEASE_NOTE:-}" ]; then
    git commit -q -m "release: $tag" -m "$RELEASE_NOTE"
  else
    git commit -q -m "release: $tag"
  fi
  git tag "$tag"
  released="$released $tag"
done < published.txt
if [ -z "$released" ]; then echo "Rien à publier : le repo est à jour."; else echo "Publié :$released"; fi
