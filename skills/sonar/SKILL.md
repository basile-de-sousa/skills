---
name: "sonar"
description: "Chercher ce que l'utilisateur a déjà sur un sujet dans ses stockages (pins, buzzwords, notes, méthodes) et expliquer en quoi ça le concerne. Utiliser sur /sonar (seul, ?, sujet) ou « qu'est-ce que j'ai sur… »."
---

# Sonar

## Config
<!-- config -->
- Repo des pins : `<à définir>`
- Repo des buzzwords : `<à définir>`
- Site des buzzwords : `<à définir>`
- Repo des méthodes : `<à définir>`
<!-- /config -->

Chaque valeur désigne la source du même nom (repos GitHub `compte/nom`, produits par les skills `/pin`, `/buzzword` et `/methodo`). Une valeur à `<à définir>` : la source est **ignorée** et signalée dans la dernière ligne (`_Non configuré : buzzwords._`). Si **aucune** source n'est configurée au premier appel, demander à l'utilisateur ses repos, puis proposer une modification de ce skill qui les inscrit dans ce bloc. Le bloc ne contient jamais de secret.

Objectif : quand l'utilisateur démarre un sujet ou un projet, lui ressortir ce qu'il a déjà gardé et qui pourrait servir, avec **pourquoi** ça le concerne, et ce qu'il vaut mieux écarter. Sonar **lit seulement** : il n'écrit, ne crée ni ne modifie rien.

## Usages

| Commande | Effet |
|---|---|
| `/sonar` | **Aide** (voir plus bas), toujours, même en pleine discussion |
| `/sonar ?` | **Sonder le sujet de la conversation** en cours (projet décrit, spec en cours, problème posé). Conversation sans sujet : l'aide |
| `/sonar <sujet, projet ou question>` | Sonder ce sujet (`/sonar jeu 3D web`, `/sonar outil RH avec des données sensibles`) |
| `/sonar <sources> : <sujet>` | Sonder **uniquement** ces sources, pour cette recherche (`/sonar pins buzzwords : jeu 3D web`). Avec `?` : `/sonar pins : ?` |
| `/sonar all : <sujet>` | Sonder **toutes** les sources, sans sélection automatique |

Noms de sources reconnus : `pins`, `buzzwords`, `notes`, `methodo` (singulier, pluriel ou nom du skill). Un filtre ne vaut **que pour l'appel en cours** : rien n'est mémorisé.

### Aide

Réponse immédiate, **aucun outil** : expliquer le skill, pas l'état des stockages.

```
**/sonar** : retrouver ce que tu as déjà gardé (pins, buzzwords, notes, méthodes) quand tu démarres un sujet.
- `/sonar <sujet ou projet>` : ce qui peut servir, ce qu'il vaut mieux écarter
- `/sonar ?` : je sonde le sujet de la conversation en cours
- `/sonar pins notes : <sujet>` : seulement ces sources · `/sonar all : <sujet>` : toutes
- Le bon moment : au **début** d'un projet ou d'une spec, avant de choisir tes outils
```

## Sources

Chaque source est indépendante. Une source non configurée, absente, vide ou inaccessible est ignorée et signalée en une ligne à la fin, sans bloquer les autres.

| Source | Où | Catalogue (à lire en entier) | Détail (seulement si pertinent) |
|---|---|---|---|
| Pins | Repo des pins (Config) | `index.md` : une ligne par entrée avec type, **statut** (`noté`, `à creuser`, `exploré`), **avis** éventuel après `:`, « utile quand » et tags | `pins/<slug>.md` ou `pins/<slug>/README.md` ; le `dossier.md` d'une idée **seulement** si la requête nomme l'idée (ou son slug), ou si l'utilisateur dit vouloir avancer dessus ; pour annoncer le dossier, compter ses décisions et questions avec `grep -c` sans l'ouvrir |
| Buzzwords | Repo des buzzwords (Config), dossier `buzzwords/` | frontmatter de chaque fiche : `term`, `acronym`, `aliases`, `tags`, `relations` | corps de la fiche ; lien `<Site des buzzwords>/<slug>/` |
| Notes | artifacts dont le titre commence par `Notes · ` (`Artifact` list avec `limit: 200` : la liste par défaut s'arrête aux 25 plus récents) | titres des sujets | `read` du sujet, puis le JSON `#notes` : `overview`, titres et `id` des pages et des notions, glossaire |
| Méthodes | Repo des méthodes (Config) | `index.md` : une ligne par méthode avec type, scope, **statut**, « utile quand » ; `observations.md` | `methodes/<slug>.md` |

Une nouvelle source s'ajoute par une ligne dans ce tableau.

### Choix des sources

Sans filtre ni `all`, sonar **choisit** les sources qui peuvent répondre au contexte, et les autres ne sont pas sondées :

| Le contexte porte sur… | Sources |
|---|---|
| un choix d'outil, de techno, une idée, un projet à lancer | pins, buzzwords, + notes si un sujet de cours y touche |
| comprendre ou expliquer une notion | buzzwords, notes, + pins |
| une façon de faire : s'organiser, présenter, décider, débloquer | methodo, + pins |
| un cours, un examen, un sujet académique | notes, buzzwords |

- **En cas de doute, inclure** : une source sondée pour rien coûte quelques secondes, une source oubliée fait rater la bonne entrée.
- Les **notes** sont la source la plus coûteuse : lister les titres est rapide, n'ouvrir un sujet que si son titre colle.
- Les sources non sondées sont **toujours nommées** dans la dernière ligne, avec la raison, pour que l'utilisateur puisse relancer avec `all` ou un filtre.

## Recherche

Vite et léger : le coût dépend du nombre de fichiers ouverts, pas du nombre de sources.

1. **Formuler le contexte** en une ligne : ce que l'utilisateur fait et ce dont il a besoin (« jeu 3D web, beaucoup d'entités à l'écran »). Avec `/sonar ?`, c'est la synthèse de la conversation. Puis **choisir les sources** (voir plus haut), sauf filtre ou `all`. Tout le jugement de pertinence se fait par rapport à cette ligne.
2. **Élargir la requête** : synonymes, acronymes, technos et notions voisines, en français et en anglais (« jeu 3D web » → WebGL, WebGPU, Three.js, game, rendu, GPU). La recherche lexicale seule rate trop de choses.
3. **Récupérer les repos des sources retenues** **en parallèle**, dans une seule commande (`git clone --depth 1 … &` pour chacun, puis `wait` ; `git pull` s'ils sont déjà clonés), en lecture seule. Pendant ce temps, lister les notes si elles sont retenues. Puis travailler en local (`grep`, lecture des frontmatters), sans ouvrir les fichiers un par un à distance.
4. **Lire les catalogues** : l'index des pins en entier, un extrait compact des frontmatters buzzwords (une ligne par fiche, produite par un petit script Python qui lit le YAML et aplatit `relations` ; un `awk` ligne à ligne perd les relations), la liste des sujets de notes, l'index des méthodes et `observations.md`. Juger **sur le sens**, pas seulement sur les mots trouvés.
5. **Ouvrir uniquement les candidats** : au plus une dizaine d'entrées en tout. Pour les notes, ne lire un sujet que si son titre ou la requête le justifie (ce sont de grosses pages).
6. **Suivre les liens** d'un résultat (`links` d'un pin, `relations` d'une fiche) seulement s'ils mènent à une entrée existante et pertinente.
7. **Juger chaque candidat** face au contexte, en lisant ses limites **et l'avis** de l'utilisateur : il sert directement, il aide à côté, ou il correspond au thème mais **ne convient pas** ici (avis « écarté », limite bloquante, alternative meilleure dans les résultats).
8. **Un abandon est un contexte daté, pas une interdiction** : pour un avis « écarté » ou une piste abandonnée, vérifier si sa raison tient encore face au contexte actuel (`réouvrir si` rempli, contrainte différente, techno qui a évolué). Si elle ne tient plus, présenter l'entrée comme **à réévaluer**, avec la raison d'origine, au lieu de l'écarter. Si le contexte ne permet pas de trancher (il manque une information), afficher **À réévaluer si** <condition>, en ★. Un avis à **portée** précisée (« écarté comme brique ; à garder comme concurrent ») ne vaut que pour cette portée.

## Réponse

Style fiche buzzword : épuré, puces courtes, **2 à 3 mots-clés en gras** par puce, aucune phrase de remplissage.

```
**Contexte** : jeu 3D web, beaucoup d'entités à l'écran.

**WebGPU** · pin techno · ★★★ · [↗](lien)
- **Compute shaders** : des milliers d'ennemis gérés par le GPU.
- Via **Three.js WebGPURenderer**, repli WebGL automatique.
- **À creuser** : tient-il sur mobile ? C'est le moment.

**GPU** · buzzword · ★ · [↗](lien)
- Comprendre pourquoi le calcul passe sur la **carte graphique**.

**À écarter**
- **wllama** · pin outil : tu l'as écarté, **trop lent sur CPU**.

_Non sondé : methodo (sans rapport). Notes : aucun sujet sur la 3D ou le jeu._
```

- **Contexte** : toujours en première ligne, une phrase. Elle montre sur quoi sonar a cherché ; l'utilisateur corrige si c'est à côté.
- **Pertinence** : ★★★ sert directement · ★★ utile en appui · ★ pour comprendre ou en marge. Classer du plus au moins pertinent.
- Par résultat : une ligne de titre (**nom** · source et type · étoiles · lien), puis **1 à 3 puces** qui disent **en quoi ça sert ici**, jamais la définition générale.
- Lien : `https://github.com/<Repo des pins>/blob/main/pins/<slug>.md` (ou `…/<slug>/README.md`, plus `· [dossier ↗](…/<slug>/dossier.md)` pour une idée en dossier) pour un pin, `<Site des buzzwords>/<slug>/` pour un buzzword (sans site : le fichier dans son repo), `https://github.com/<Repo des méthodes>/blob/main/methodes/<slug>.md` pour une méthode, `<url du sujet>#<id de la page>` pour une note (titre affiché : `Notes · X > page`), qui ouvre directement le bon onglet.
- **Méthodes** : une méthode dit **comment** l'utilisateur travaille ; les puces disent comment l'appliquer à ce contexte, pas ce qu'elle est. Statut `confirmé` : rien de plus. `observation` : puce **Observation** (pas encore validée). `contesté` : puce **Contestée**. `déprécié` : dans **À écarter**, avec sa raison. Une observation de `observations.md` qui colle au contexte : une ligne en ★, `observation · méthodo`.
- **Statut et avis des pins** :
  - `noté`, ou `exploré` sans avis : rien de plus à signaler.
  - `à creuser` en ★★★ ou ★★ : une puce **À creuser**, avec l'avis s'il y en a un (la question que l'utilisateur se posait).
  - `exploré` avec un avis « utilisé » ou « à garder » : une puce qui le rappelle (**Déjà utilisé** dans un projet nommé), c'est un signal fort.
  - `exploré` avec un avis « écarté » : dans **À écarter**, avec la raison de l'utilisateur, même si l'entrée semble pertinente ; sauf si la raison ne tient plus (étape 8) : alors en résultat, avec une puce **À réévaluer** : écarté pour <raison>, qui ne tient plus parce que <changement>.
  - Idée en **dossier** en ★★★ : une puce qui le signale (**Dossier** : N décisions, questions ouvertes).
- **À écarter** : les entrées qui correspondent au thème mais ne conviennent pas, une ligne chacune avec la **raison**. Seulement quand la raison vient de l'entrée elle-même (avis, limites), d'un meilleur résultat trouvé, ou de la **contrainte posée par la requête** (« exclu par ta contrainte : exige WebGPU ») ; sinon ne pas les mentionner.
- Au plus 6 résultats, plus « À écarter » ; au-delà, dire combien d'autres sont plus loin du sujet.
- Dernière ligne en italique : sources **non sondées** (et pourquoi), vides ou inaccessibles, en quelques mots. Ex. : `_Non sondé : methodo, notes (sans rapport). /sonar all : … pour tout sonder._` Avec un filtre : `_Sondé : pins, buzzwords (filtre)._`
- Rien de pertinent : `**Contexte** : …` puis `Rien dans <sources sondées>.` (et la ligne des sources non sondées, pour pouvoir élargir). Ne pas combler avec des résultats faibles ni avec des connaissances générales.
- Pas d'introduction, pas de conclusion. Français, en gardant les termes techniques anglais usuels.