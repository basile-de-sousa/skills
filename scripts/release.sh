#!/bin/sh
# Copie les skills listés dans published.txt depuis le cache claude.ai de la session
# vers skills/, puis crée un commit "release: <skill>-<version>" par skill modifié.
# Les valeurs du bloc Config d'un skill sont masquées (voir mask_config).
# Le tag, le zip et la Release GitHub sont créés par la CI au push.
# Usage : sh scripts/release.sh            (puis : git push)
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
failed=""

# Masque les valeurs du bloc Config de skills/<nom>/SKILL.md (entre <!-- config --> et
# <!-- /config -->) : chaque valeur entre backticks devient `<à définir>`.
# Échoue fermé : bloc mal formé, ou valeur masquée encore présente ailleurs -> code 1.
mask_config() {
  dir=$1; f="$dir/SKILL.md"; vals=$(mktemp); out=$(mktemp)
  if ! awk -v vals="$vals" '
    /<!-- config -->/  { inb = 1; print; next }
    /<!-- \/config -->/ { inb = 0; print; next }
    inb && /^[ \t]*-/ {
      if ($0 !~ /`[^`]+`/) { bad = "ligne du bloc Config sans valeur entre backticks : " $0; exit }
      line = $0
      while (match(line, /`[^`]+`/)) {
        v = substr(line, RSTART + 1, RLENGTH - 2)
        if (v != "<à définir>") print v > vals
        line = substr(line, RSTART + RLENGTH)
      }
      gsub(/`[^`]+`/, "`<à définir>`")
    }
    { print }
    END {
      if (bad == "" && inb) bad = "bloc Config sans marqueur de fin <!-- /config -->"
      if (bad != "") { print bad > "/dev/stderr"; exit 1 }
    }' "$f" > "$out"; then
    rm -f "$vals" "$out"; return 1
  fi
  cat "$out" > "$f"; rm -f "$out"
  leak=0
  while IFS= read -r v; do
    [ -n "$v" ] || continue
    if grep -rnF -- "$v" "$dir" >&2; then
      echo "valeur du bloc Config encore présente hors du bloc : $v" >&2; leak=1
    fi
  done < "$vals"
  rm -f "$vals"
  return "$leak"
}

# Remet skills/<nom> dans l'état du dernier commit (ou l'enlève s'il n'a jamais été publié).
restore() {
  git reset -q HEAD -- "skills/$1" 2>/dev/null || true
  rm -rf "skills/$1"
  git checkout -q HEAD -- "skills/$1" 2>/dev/null || true
}

while read -r name; do
  case "$name" in ''|'#'*) continue ;; esac
  if [ ! -f "$SRC/$name/SKILL.md" ]; then
    echo "Ignoré : $name absent du cache." >&2; continue
  fi
  rm -rf "skills/$name"; mkdir -p skills; cp -R "$SRC/$name" "skills/$name"
  if ! mask_config "skills/$name"; then
    echo "Non publié : $name (voir ci-dessus)." >&2
    restore "$name"; failed="$failed $name"; continue
  fi
  git add -A "skills/$name"
  if git diff --cached --quiet; then continue; fi
  ver=$(date -u +%Y.%m.%d); tag="$name-$ver"; n=2
  while git log --format=%s | grep -Fxq "release: $tag"; do
    tag="$name-$ver.$n"; n=$((n + 1))
  done
  if [ -n "${RELEASE_NOTE:-}" ]; then
    git commit -q -m "release: $tag" -m "$RELEASE_NOTE"
  else
    git commit -q -m "release: $tag"
  fi
  released="$released $tag"
done < published.txt
if [ -z "$released" ]; then echo "Rien à publier."; else echo "Publié :$released"; fi
if [ -n "$failed" ]; then echo "Non publiés :$failed" >&2; exit 1; fi
