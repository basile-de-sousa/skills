#!/bin/sh
# Tests d'acceptation de scripts/release.sh. Usage : sh scripts/test-release.sh
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
fails=0
ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

# Prépare un repo jetable ($T/repo) et un faux cache de skills ($T/src).
setup() {
  T=$(mktemp -d)
  mkdir -p "$T/repo/scripts" "$T/src"
  cp "$HERE/release.sh" "$T/repo/scripts/"
  cd "$T/repo" || exit 1
  git init -q -b main
  git config user.name test; git config user.email test@example.com
  printf '%s\n' "$@" > published.txt
  git add -A; git commit -q -m init
}
skill() { mkdir -p "$T/src/$1"; cat > "$T/src/$1/SKILL.md"; }
run() { OUT=$(SKILLS_DIR="$T/src" sh scripts/release.sh 2>&1); RC=$?; }
commits() { git rev-list --count HEAD; }

# AC1
setup a
skill a <<'S'
# A
## Config
<!-- config -->
- Repo de données : `acme/data`
- Site : `https://acme.example`
<!-- /config -->
Écrire dans le repo de données.
S
run
if [ "$RC" -eq 0 ] && grep -q 'Repo de données : `<à définir>`' skills/a/SKILL.md 2>/dev/null \
   && grep -q 'Site : `<à définir>`' skills/a/SKILL.md && ! grep -rq acme skills/a; then
  ok "SPEC-001 AC1: les valeurs du bloc Config sont masquées"
else fail "SPEC-001 AC1: les valeurs du bloc Config sont masquées"; fi

# AC5 (suite du même repo : seule la valeur change)
n=$(commits)
skill a <<'S'
# A
## Config
<!-- config -->
- Repo de données : `other/data`
- Site : `https://other.example`
<!-- /config -->
Écrire dans le repo de données.
S
run
if [ "$RC" -eq 0 ] && [ "$(commits)" = "$n" ] && [ -z "$(git status --porcelain)" ]; then
  ok "SPEC-001 AC5: aucun commit quand seule la config change"
else fail "SPEC-001 AC5: aucun commit quand seule la config change"; fi

# AC2 : marqueur de fin absent
setup b
skill b <<'S'
# B
<!-- config -->
- Repo de données : `acme/data`
Suite du skill.
S
run
if [ "$RC" -ne 0 ] && [ ! -e skills/b ] && [ "$(commits)" = 1 ] && [ -z "$(git status --porcelain)" ]; then
  ok "SPEC-001 AC2: bloc sans marqueur de fin, rien n'est publié"
else fail "SPEC-001 AC2: bloc sans marqueur de fin, rien n'est publié"; fi

# AC2 : ligne de liste sans valeur entre backticks
setup c
skill c <<'S'
# C
<!-- config -->
- Repo de données : acme/data
<!-- /config -->
S
run
if [ "$RC" -ne 0 ] && [ ! -e skills/c ] && [ "$(commits)" = 1 ]; then
  ok "SPEC-001 AC2: ligne sans valeur entre backticks, rien n'est publié"
else fail "SPEC-001 AC2: ligne sans valeur entre backticks, rien n'est publié"; fi

# AC3 : la valeur masquée traîne ailleurs
setup d
skill d <<'S'
# D
<!-- config -->
- Repo de données : `acme/data`
<!-- /config -->
Voir https://github.com/acme/data/blob/main/x.md
S
run
if [ "$RC" -ne 0 ] && [ ! -e skills/d ] && [ "$(commits)" = 1 ] \
   && printf '%s' "$OUT" | grep -q 'github.com/acme/data'; then
  ok "SPEC-001 AC3: valeur présente hors du bloc, rien n'est publié et la ligne est montrée"
else fail "SPEC-001 AC3: valeur présente hors du bloc, rien n'est publié et la ligne est montrée"; fi

# AC4 : pas de bloc Config
setup e
skill e <<'S'
# E
Un skill sans config, avec `du code` entre backticks.
S
run
if [ "$RC" -eq 0 ] && cmp -s "$T/src/e/SKILL.md" skills/e/SKILL.md; then
  ok "SPEC-001 AC4: un skill sans bloc Config est publié tel quel"
else fail "SPEC-001 AC4: un skill sans bloc Config est publié tel quel"; fi

# AC4 : fichier sans saut de ligne final, avec et sans bloc Config
setup f g
mkdir -p "$T/src/f" "$T/src/g"
printf '# F\nSans saut de ligne final.' > "$T/src/f/SKILL.md"
printf '# G\n<!-- config -->\n- Repo : `acme/data`\n<!-- /config -->\nFin sans saut de ligne.' > "$T/src/g/SKILL.md"
run
if [ "$RC" -eq 0 ] && cmp -s "$T/src/f/SKILL.md" skills/f/SKILL.md \
   && [ -n "$(tail -c1 skills/g/SKILL.md)" ] && grep -q '`<à définir>`' skills/g/SKILL.md; then
  ok "SPEC-001 AC4: l'absence de saut de ligne final est conservée"
else fail "SPEC-001 AC4: l'absence de saut de ligne final est conservée"; fi

[ "$fails" -eq 0 ] && echo "Tous les tests passent." || echo "$fails test(s) en échec."
exit "$fails"
