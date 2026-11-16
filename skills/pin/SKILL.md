---
name: "pin"
description: "Épingler un outil, site, techno, idée ou lecture avec un « utile quand » pour le retrouver au bon moment. Utiliser sur /pin (seul : l'aide ; avec une url, un nom ou un texte), /pin ? ou « pin ça »."
---

# Pin

## Config
<!-- config -->
- Repo de données : `<à définir>`
- Repo de watcher : `<à définir>`
<!-- /config -->

Le **repo de données** est le repo GitHub où vivent les pins ; dans les liens ci-dessous, `<repo>` désigne sa valeur. Si elle vaut `<à définir>`, demander à l'utilisateur son repo (`compte/nom`) avant toute autre action, puis proposer une modification de ce skill qui l'inscrit dans le bloc Config. Pourquoi : un skill n'a pas de mémoire propre, ce bloc est le seul endroit qui tient d'une conversation à l'autre. Il ne contient jamais de secret (jeton, mot de passe).

Le **repo de watcher** est le repo GitHub de la commande watcher (voir « Vidéos »), où vit sa documentation. S'il vaut `<à définir>`, rien n'est bloqué : dire seulement que la documentation de l'archive se trouve dans le repo de watcher, sans demander sa valeur.

Objectif : garder une trace de ce que l'utilisateur croise (outil, site, techno, idée, lecture) avec **quand ça lui servira**, pour qu'une recherche (par exemple `/sonar`) le ressorte au bon moment.

La capture doit être **rapide** : aucune recherche nouvelle (pas de web, pas d'approfondissement). Ce qui a déjà été dit dans la conversation peut être gardé, mais **trié** : un pin n'est pas une note de cours. Il garde l'essentiel et les choix structurants, pas tout ce qui a été discuté.

Un pin **vit** : il reflète l'état actuel de ce que l'utilisateur sait et pense. Approfondir un pin, c'est simplement en discuter dans une conversation, puis lancer `/pin ?` (ou « pin ça ») : le skill met à jour le contenu et le statut.

Une idée qui a mûri garde sa matière dans un **dossier** (voir « Dossier d'une idée ») : la fiche reste courte, le dossier n'est lu que pour approfondir.

Un **abandon est un contexte daté, pas une interdiction** : il garde sa raison et ce qui le rouvrirait, pour qu'un futur modèle ou une situation nouvelle puisse le réévaluer au lieu de le subir.

Une **vidéo** épinglée garde ce qu'elle apprend, pas seulement son lien : `/pin` la lit avec **watcher** quand cette commande est présente (voir « Vidéos »). Lire la vidéo n'est pas une recherche nouvelle, c'est l'objet même qu'on épingle. watcher en garde aussi la **matière brute** (vidéo, transcript, images) dans une archive sur Google Drive, pour y revenir plus tard (voir « Approfondir avec la matière d'une vidéo »). Sans watcher, `/pin` fonctionne comme avant.

Un pin n'est **pas une tâche** : une chose à faire avec une échéance (corriger une faille, rendre un devoir) va dans un gestionnaire de tâches. Ce qu'on apprend en la réalisant, lui, peut être épinglé.

## Usages

| Commande | Effet |
|---|---|
| `/pin <url, nom ou texte libre> [contexte]` | Créer l'entrée (statut `noté`) ou mettre à jour une entrée existante, et l'enregistrer immédiatement |
| `/pin <X> ? [ce que je veux savoir]` | Passer X en **`à creuser`** (le créer s'il n'existe pas) |
| `/pin <X> ! [verdict]` | Passer X en **`exploré`**, avec son verdict (utilisé dans tel projet, écarté pour telle raison, à garder pour…) |
| `/pin vidéos [--frames]` | **Traiter toutes les vidéos en attente**, tous pins confondus : lire celles qui ne le sont pas, archiver celles qui ne le sont pas, compléter chaque section `## Vidéos`. Aussi « /pin all videos », « lis et archive mes vidéos » |
| `/pin <X> vidéos [--frames]` | Pareil, pour le seul pin X |
| « dans les vidéos de X, … » | **Approfondir** avec la matière d'une vidéo : citation exacte, image, détail (voir plus bas) |
| `/pin ?` ou « pin ça » | **Où j'en suis** : d'abord le **bilan de la conversation** s'il y a eu une discussion (nouveaux éléments à épingler **et** pins à mettre à jour, enregistrés après ton « ok »), puis l'**état des lieux** (à creuser, explorés récemment, suggestions, vidéos en attente). Voir plus bas |
| `/pin` **seul** (aussi `/pin aide`, `/pin help`) | **Aide**, toujours, même après une discussion (voir plus bas) |

Les formulations naturelles marchent aussi (« /pin WebGPU je veux m'y pencher », « /pin wllama écarté, trop lent ») : `?` et `!` ne sont que des raccourcis.

### Aide

Réponse immédiate, **aucun outil** : expliquer le skill, pas l'état du repo.

```
**/pin** : garder un outil, un site, une techno ou une idée avec **quand ça te servira**.
- `/pin <url ou nom> [contexte]` : épingler (le contexte suffit, je remplis le reste)
- `/pin X ?` : à creuser · `/pin X !` : exploré (ajoute ton verdict si tu veux)
- `/pin vidéos` : lire et archiver sur ton Drive **toutes** les vidéos en attente (sur ton PC, avec watcher) ; `/pin X vidéos` pour un seul pin
- « dans les vidéos de X, retrouve la phrase sur… » : je vais chercher dans l'archive
- `/pin ?` (ou « pin ça ») : où tu en es. Après une discussion, je propose d'abord ce qu'il faut épingler ou mettre à jour ; puis ce qui est à creuser, exploré récemment, à reprendre, et les vidéos en attente
- Pour retrouver : `/sonar <sujet>` · cette aide : `/pin`
```

Ajouter **une seule ligne de conseil** si la conversation en donne l'occasion (par exemple un outil mentionné plus haut sans être épinglé : `À garder ? /pin Three.js`). Sinon, rien de plus.

## Statut et avis

| Statut | Sens | Comment il est posé |
|---|---|---|
| `noté` | gardé, sans engagement | par défaut |
| `à creuser` | l'utilisateur veut s'y pencher | `/pin X ?`, ou quand il le dit ; **jamais posé seul** (mais suggéré, voir plus bas) |
| `exploré` | il s'y est penché | `/pin X !`, ou proposé par le bilan quand une conversation a dépassé la simple mention |

**Cas d'une idée** : tant qu'elle a des **questions ouvertes**, une idée creusée **reste `à creuser`**, avec la question la plus importante en avis. Elle passe en `exploré` seulement avec un verdict (utilisée, écartée, à garder).

**`avis`** (optionnel, une ligne courte) : le texte après `?` ou `!`.
- Avec `à creuser` : ce que l'utilisateur veut savoir (« tient-il sur mobile ? »).
- Avec `exploré` : le verdict. Commencer par **utilisé**, **écarté** ou **à garder** quand c'est l'un des trois, puis la précision (« utilisé dans STP », « écarté : trop lent sur mobile », « à garder pour un jeu »). C'est ce que `/sonar` lit pour classer une entrée à utiliser ou à écarter.
- Un avis peut préciser sa **portée** quand le verdict n'est pas le même partout : « écarté comme brique ; à garder comme concurrent ». `/sonar` n'écarte l'entrée que pour cette portée.
- Si l'utilisateur ne donne pas d'avis, le **déduire de la conversation** quand elle le dit clairement ; sinon, pas d'avis.
- `status-since` : la date du dernier **changement de statut** (pas de contenu). C'est elle qui sert à « depuis X » dans `/pin ?`.
- Un nouvel avis **remplace** l'ancien. On peut repasser d'`exploré` à `à creuser` (nouvelle question).

**Suggérer `à creuser`, sans le poser** : à la création d'une **idée**, la confirmation ajoute `À creuser ? /pin <slug> ?`. Un oui d'un mot suffit ; sans réponse, l'idée reste `noté`.

## Où j'en suis : `/pin ?` ou « pin ça »

Deux parties, dans cet ordre, en une seule réponse :

1. **Bilan de la conversation** (section suivante), seulement si la conversation a abordé des sujets à épingler ou des pins existants. Conversation vide, ou rien à proposer : sauter cette partie sans le dire.
2. **État des lieux**, ci-dessous, toujours. Un pin déjà proposé dans le bilan n'y est pas répété.

La réponse se termine par la question de validation du bilan s'il y en a un (`Je les enregistre ?`) ; l'état des lieux, lui, ne modifie rien.

### État des lieux


Lire `index.md` (type, statut et avis y figurent), puis en local, sans ouvrir les fichiers un par un : `grep -H '^status-since' -r pins` pour les durées, `grep -H '^links' -r pins` pour les liens, et `grep -H '^videos:' -r pins` pour les vidéos. Répondre :

```
**À creuser** (du plus ancien au plus récent)
- [**WebGPU**](https://github.com/<repo>/blob/main/pins/webgpu.md) · depuis 3 sem. · tient-il sur mobile ?

**Explorés récemment** (30 derniers jours)
- [**wllama**](https://github.com/<repo>/blob/main/pins/wllama.md) · écarté : trop lent sans WebGPU

**À creuser ?**
- [**Chat local dans le navigateur**](https://github.com/<repo>/blob/main/pins/chat-local-navigateur.md) · idée · un prototype est déjà esquissé → `/pin chat-local-navigateur ?`
- [**llmfit**](https://github.com/<repo>/blob/main/pins/llmfit.md) · outil · préalable à tes autres pins d'IA locale

⚠ À creuser depuis plus d'un mois : **WebGPU**. Toujours d'actualité ?

🎬 **Vidéos** · 5 à lire, 2 à archiver (4 pins) → sur ton PC : `/pin vidéos`
- [**Montage vidéo avec Claude**](…) · 3 non lues · à creuser
```

- Chaque nom est un lien vers son fichier.
- **À creuser ?** : **au plus 3** pins `noté` qui mériteraient de l'être, chacun avec la raison en quelques mots. Priorité : les **idées** de l'utilisateur (une idée jamais reprise se perd), puis un pin dont dépendent plusieurs autres (`links`), puis ceux liés à un pin `à creuser` ou au sujet de la conversation en cours. Jamais une suggestion sans lien avec ce qui occupe l'utilisateur. Ne suggérer que ce qui a une vraie raison ; sinon, omettre la section.
- Section vide : l'omettre. Tout vide : `Rien à creuser, rien d'exploré récemment.`
- La ligne ⚠ n'apparaît que s'il y a des entrées concernées ; si l'utilisateur répond non, repasser l'entrée en `noté`.
- **Vidéos** (état **déduit**, jamais stocké ; `pin ?` signale, il ne lit rien) : une URL de `videos:` **non lue** n'a aucun bloc dans la section `## Vidéos` de son pin (`grep -F '<url>'` dans le fichier) ; une vidéo **non archivée** a un bloc lu sans ligne `archive:`. Un bloc « illisible » compte comme traité. Afficher le **nombre** de vidéos à lire et à archiver et de pins concernés, puis au plus 3 pins en liste, ceux `à creuser` d'abord. Rien en attente : ne pas parler des vidéos.

## Bilan de conversation (première partie de `/pin ?`)

1. **Lire `index.md`** (cloner ou `git pull` le repo).
2. **Repérer les pins concernés** par la conversation :
   - ceux déjà épinglés **plus tôt dans cette conversation**, puis rediscutés ;
   - ceux de l'index dont le sujet a été **discuté en profondeur** ici (pas une simple mention).
   Ouvrir uniquement ces fichiers-là.
3. **Vérifier les voisins** : pour chaque pin mis à jour, relire dans l'index la ligne de ses `links`. Si une décision de la conversation **contredit** ou **change** l'un d'eux (piste abandonnée, outil retenu comme brique, nouvelle limite), l'ajouter aux mises à jour.
4. **Repérer les nouveaux éléments** à épingler (outils, technos, **idées propres à l'utilisateur**). Si la conversation donne déjà un verdict, le nouvel élément est créé directement avec ce statut et cet avis.
5. **Proposer en une seule liste**, une ligne par élément, puis enregistrer après validation (un « ok » suffit, l'utilisateur peut retirer ou corriger un élément) :

```
**Nouveaux**
- **Three.js** · outil · utile quand : rendu 3D web avec repli WebGL
- **Prompt API de Chrome** · techno · exploré · avis : écarté comme brique ; à garder comme concurrent

**À mettre à jour**
- **WebGPU** · à creuser → exploré · avis : utilisé dans un jeu web
- **Chat local dans le navigateur** · dossier créé : 3 décisions, 2 questions ouvertes · reste à creuser : quel modèle sur un GPU intégré ?
- **wllama** · voisin : retenu comme repli sans WebGPU du chat local
```

Rien à épingler ni à mettre à jour : pas de bilan, seulement l'état des lieux.

## Vidéos

**watcher** est une commande locale (sur le PC de l'utilisateur) qui sort, sans token, les métadonnées et le transcript d'une vidéo, et des planches d'images avec `--frames`. Elle ne garde rien en local et ne connaît pas les pins. Avec `--keep`, elle copie le dossier de la vidéo dans une **archive sur Google Drive** (dossier `pins-videos`, un sous-dossier `<plateforme>-<id>` par vidéo, avec un `README.md` qui décrit chaque fichier). Interface garantie : `watcher <url>`, `watcher --meta <url>` (métadonnées seules, rien de téléchargé), `watcher --frames <url>`, `watcher --keep [--frames] <url>` (lecture, puis une ligne `archive: <clé> (<utilisé> sur <plafond>)` ou `archive: échec (<raison>)`), `watcher --restore <clé>` (remet le dossier archivé sur le PC et affiche son chemin) ; code retour `0` réussi, `1` échec, `2` non supporté. Ne pas dépendre du format exact de sa sortie : la lire comme un texte.

Tout le reste de l'archive (mise en place, plafond de 20 Go, couper l'accès, accès expiré, nouvelle machine) est documenté dans le **repo de watcher** (bloc Config), `docs/architecture.md#archive` : y renvoyer l'utilisateur, ou le lire, dès qu'il pose une question sur l'archive ou sur son accès à Drive.

**Présente ?** `command -v watcher` dans le shell de la session. Absente (session cloud, téléphone, commande non installée) : **aucune erreur, aucun message**, on ne lit pas les vidéos.

**Quand lire** :
- **À la capture** d'un lien vidéo (`/pin <url>`), si watcher est présente : lire, puis écrire le pin en connaissance de cause (corps et « utile quand » nourris par la vidéo).
- **Plus tard, sur demande explicite** : `/pin vidéos` (tous les pins) ou `/pin <X> vidéos` (un seul). Traiter les vidéos **en attente** : non lues (lire avec `--keep`) et lues sans ligne `archive:` (`watcher --keep <url>`, puis ajouter la ligne `archive:` sans réécrire le reste du bloc ; vidéo disparue depuis : le dire, ne rien changer). Jamais par effet de bord d'une autre commande (bilan, `?`, `!`, mise à jour).
- **Toutes à la fois** : d'abord `watcher --meta` sur les vidéos à lire, puis **une seule question** pour toutes celles de plus de ~20 min (`2 vidéos longues : 48 min et 31 min. Les lire aussi ?`), puis le reste sans s'arrêter. Un seul commit pour l'ensemble, et une confirmation qui regroupe par pin.
- **En parallèle** (Claude Code) : lancer les `watcher --keep` **3 par 3**, en plusieurs appels Bash dans le même message (chaque vidéo a son dossier, aucun conflit ; au-delà de 3, la transcription se dispute le processeur et l'envoi Drive le réseau). **Plus de 6 vidéos** : confier chaque pin à un sous-agent (outil Agent), avec ce skill et la liste de ses URL ; il lance watcher, lit, écrit la section `## Vidéos` de **son seul** fichier et rend une ligne de résumé, sans commit. Les transcripts et les images restent dans son contexte, pas dans le tien. Au plus 3 sous-agents à la fois ; à la fin, relire les fichiers modifiés (`git diff --stat`), faire le commit unique et la confirmation.
- Demande explicite sans watcher : une ligne, `watcher introuvable ici : relance depuis ton PC (Claude Code dans WSL).`

**Comment lire une vidéo** :
1. `watcher --meta <url>`. Durée **au-delà de ~20 min** : demander avant de lire (`Vidéo de 48 min, ~12 000 tokens de transcript. La lire ?`).
2. `watcher --keep <url>` : **texte seul** par défaut (métadonnées + transcript), et la vidéo est archivée. Toute vidéo lue est archivée, sans tri : on ne sait pas d'avance ce qui servira, et la place n'est pas un souci.
3. `--frames` (avec `--keep`) seulement si l'utilisateur le demande, ou si la vidéo **n'a pas de parole** (transcript vide ou quasi vide). Lire les planches d'images est l'étape la plus coûteuse.
4. Code `2`, ou vidéo supprimée, privée ou indisponible : bloc **illisible**, avec la raison. Code `1` pour une autre cause (réseau, erreur passagère) : ne rien écrire, la vidéo reste non lue, et le dire dans la confirmation.
5. Dernière ligne `archive: <clé> (…)` : noter la clé dans le bloc. `archive: échec (<raison>)` : écrire le bloc sans ligne `archive:` et donner la raison dans la confirmation (plafond atteint, accès Drive expiré…) ; le prochain `/pin vidéos` rattrapera.
   **Plafond atteint** : la lecture et la fiche ne changent pas. Dire dans la confirmation la place utilisée (donnée par watcher), et proposer, sans rien faire soi-même : relever le plafond (`WATCHER_ARCHIVE_MAX`, voir la doc de watcher) ou faire le tri à la main dans `pins-videos`. Ne jamais supprimer ni alléger une archive (la vidéo brute pèse le plus, mais c'est la seule copie si la vidéo disparaît de la plateforme).


**Section `## Vidéos`** du fichier du pin, après le corps, un bloc par URL dans l'ordre de `videos:` :

```markdown
## Vidéos
- **Hyperframes : vidéo en HTML animé** · https://vt.tiktok.com/ZSpFrp5bo/
  Claude écrit la vidéo en HTML/CSS animé, puis on l'exporte : idéal pour une démo produit.
  Limite : pas de vrai montage de rushs filmés.
  archive: tiktok-7697573255380585760 · repères : 0:12 le prompt de départ ; 0:41 « le rendu reste du HTML » ; #9 timeline animée
- https://vt.tiktok.com/ZSpFhCjCn/ · illisible : vidéo supprimée
```

- 1 à 3 lignes par vidéo : ce qu'elle apporte **pour l'usage du pin** (méthode, outil cité, limite, chiffre qui décide). Jamais le transcript, jamais un résumé exhaustif : même test de chaque ligne que pour le corps. L'exemple ci-dessus est un exemple, jamais du contenu.
- La section n'entre pas dans la longueur du corps (1 à 4 lignes, 8 pour une idée). Si la vidéo change ce qu'on sait, **mettre aussi à jour** le corps et le « utile quand ».
- Une vidéo lue qui révèle un nouvel outil ou une idée : le proposer comme nouveau pin, en une ligne.
- **Ligne `archive:`** : la clé `<plateforme>-<id>` est aussi le nom du dossier sur Drive ; c'est elle qui relie la fiche à sa matière. Suivie de 0 à 4 **repères** : un instant `m:ss` (transcript) ou une image `#n` (le numéro de sa case sur la planche-contact, qui est aussi son rang dans `frames/frames.json`), avec 3 à 6 mots sur ce qu'on y trouve. Un repère `#n` seulement pour une image **réellement vue** (planches lues, avec `--frames` ou faute de parole) : sans planches, seuls les repères `m:ss` sont permis. Un repère marque ce qu'on voudra **retrouver** (phrase forte à citer, visuel inspirant, chiffre, démonstration), pas un résumé. Ils servent d'index du contenu : on cherche dans le repo, puis on va chercher le fichier voulu dans l'archive.

### Approfondir avec la matière d'une vidéo

Quand l'utilisateur veut **plus que la fiche** d'une vidéo épinglée : une citation exacte, une image comme inspiration, un passage précis, tout ce qui est dit sur un point. Formulation naturelle, sans commande : « dans les vidéos de X, retrouve la phrase sur… », « montre-moi l'écran de la timeline », « qu'est-ce qu'il dit exactement sur le prix ? ». Ce n'est pas une recherche nouvelle : on relit ce qui est déjà archivé.

1. **Trouver la vidéo** : le pin X (index ou `grep -r` dans `pins/`), puis le bloc de la vidéo et sa ligne `archive: <clé>`. Les repères disent souvent déjà où regarder.
2. **Lire l'archive** :
   - **Sur le PC** (watcher présent) : `watcher --restore <clé>` affiche le chemin du dossier. Y lire `README.md`, puis `transcript.json` (segments horodatés : c'est là qu'on cherche une citation exacte), `frames/frames.json` (instant de chaque image) et les images de `frames/`.
   - **Ailleurs** (téléphone, claude.ai, session cloud) : avec le connecteur Google Drive, chercher le dossier `<clé>` (dans `pins-videos`), lire son `README.md`, puis les fichiers utiles. **Lecture seule** : ne jamais déplacer, modifier, partager ni supprimer quoi que ce soit dans l'archive.
   - Ni watcher ni connecteur Drive : le dire en une ligne, avec où relancer.
3. **Répondre** avec la source : `[0:41] « citation exacte »`, ou l'image (chemin sur le PC, lien Drive ailleurs) avec son instant.
4. **Pas de ligne `archive:`** : la vidéo n'a pas été archivée. Si watcher est présent et la vidéo encore en ligne, proposer `/pin <X> vidéos`.
5. Si la réponse mérite d'être retrouvée plus tard, proposer d'ajouter un **repère** au bloc (un seul, en une ligne) : c'est une mise à jour du pin, enregistrée comme les autres.

## Mettre à jour une entrée

Un pin décrit **l'état actuel**, pas l'historique : l'historique est dans Git.

- **Outil exploré** : intégrer ce qui a été appris (limite constatée, manière de l'utiliser) **sans dépasser la longueur de son type** : remplacer une information devenue fausse ou moins importante plutôt qu'ajouter des lignes. Le verdict va dans `avis`, pas dans le corps.
- **Idée modifiée** : **réécrire** les sections concernées pour qu'elles disent ce que l'utilisateur pense maintenant. Ce qui a été **abandonné** passe dans la section `**Abandonné**`, avec la raison et, quand c'est possible, **ce qui le rouvrirait** (`réouvrir si : …`). C'est ce qui évite de reproposer une piste écartée **tant que sa raison tient**.
- **Idée explorée en profondeur** : si l'essentiel ne tient plus en 8 lignes, créer ou compléter son **dossier** (voir plus bas) plutôt que tronquer.
- **Avis « écarté »** : même règle, ajouter `réouvrir si` quand la raison dépend d'un état qui peut changer (« écarté : trop lent sur CPU · réouvrir si WebGPU indisponible »).
- Une mise à jour ne fait **jamais grossir** un pin au-delà de sa longueur : elle le réécrit.
- **`useful-when`** : l'ajuster si la conversation a révélé de meilleurs usages, ou en a écarté un.
- Garder `created`, mettre `updated` à jour (y compris pour un simple changement de statut), et remplacer la ligne d'index.

## Dossier d'une idée

Quand une idée a été **creusée** et que sa matière utile dépasse la fiche (décisions argumentées, questions, pistes), elle passe en **dossier**. C'est rare : la plupart des pins restent une fiche.

**Structure** : l'entrée devient un dossier, avec le même slug.

```
pins/<slug>/README.md   ← la fiche : même frontmatter, 8 lignes au plus, même rôle
pins/<slug>/dossier.md  ← la matière, lue seulement pour approfondir
```

- Déplacer la fiche avec `git mv pins/<slug>.md pins/<slug>/README.md` dans un **premier commit à part** (`docs(pin): move <slug> to folder`), puis réécrire : sinon Git perd l'historique de la fiche. C'est la seule exception à « un seul commit par appel ».
- Mettre à jour le lien dans l'index (`pins/<slug>/README.md`). Le slug et les `pin:<slug>` des autres entrées ne changent pas.
- Une fois le dossier créé, la fiche redevient **très courte** : environ 150 caractères par section, le détail va dans le dossier.
- La fiche ajoute `dossier` dans ses `links` et reste la seule chose que `/sonar` lit d'office.

**`dossier.md`** : un seul fichier (un modèle le lit en une fois), quatre parties.

```markdown
# <titre> · dossier

## Décisions
### D1 · WebLLM plutôt que wllama (2026-11-05)
- Pourquoi : WebGPU est disponible sur les machines visées, et c'est nettement plus rapide.
- Écarté : wllama, trop lent sur CPU.
- Réouvrir si : WebGPU manque sur mobile.

## Questions ouvertes
- Quel modèle de 3-4B appelle le mieux des fonctions ?

## Pistes
- Ajouter la lecture de documents locaux.

## Sources
- Conversation Claude sur WebGPU (2026-11-04).
```

- **Décisions** (format ADR condensé) : numérotées, datées, chacune avec **pourquoi** quand il est connu. À la création du dossier, les choix déjà présents dans la fiche deviennent des décisions datées de son `created` ; sans raison connue, pas de ligne « Pourquoi », **ne jamais en inventer**. Les exemples de ce skill sont des exemples, jamais du contenu.
- Chaque décision : ce qui a été **écarté**, et **réouvrir si** quand la décision dépend d'un état qui peut changer (techno, prix, contrainte). Une décision remplacée reste, en une ligne : `Remplacée par D4 : raison`.
- **Questions ouvertes** : une question tranchée devient une décision et quitte la liste.
- Ce qui n'y va pas : la transcription de la conversation, les listes exhaustives, le savoir général qu'une recherche retrouve. Même test que pour chaque ligne d'un pin. **Pas de limite de longueur** : la sélection fait le travail.
- **Distinguer faits et jugements** : un chiffre ou un état de l'art est daté (« en 2026 »), une opinion est attribuée (« jugé trop lent »). C'est ce qui permet à un futur modèle de savoir quoi revérifier.

**Quand l'idée devient un projet** (l'utilisateur la construit) : elle part dans son propre repo, où le dossier sert de base aux premiers ADR et specs. Le pin passe en `exploré` avec l'avis `utilisé : <projet>`, et `links` pointe vers le repo (`doc:<url>`). Le dossier reste comme archive.

## Quoi épingler

- Oui : ce que l'utilisateur veut **utiliser** ou **retrouver** plus tard.
- Non : une **tâche** avec une échéance. Le dire en une ligne et proposer de la créer dans un gestionnaire de tâches s'il en a un de connecté.
- Un concept à **expliquer** relève de `/buzzword`. On peut quand même l'épingler pour l'angle usage (« WebGPU pour les jeux 3D web »), sans le redéfinir : le corps ne parle que de l'usage. Pas de lien vers la fiche : elle n'est pas forcément enregistrée, et `/sonar` rapproche lui-même pins et buzzwords.
- Une news : épingler l'outil, le concept ou l'idée qu'elle révèle, et citer la news dans `source`.
- Les idées de l'utilisateur (produit, projet, angle de recherche) sont les plus précieuses : ne pas les laisser passer.

## Pas de doublon

Avant d'écrire, comparer chaque élément à `index.md` (titre, slug, « utile quand », tags), **sur le sens** et pas seulement sur le nom : autre orthographe, sigle, outil renommé, même idée formulée autrement.

- **Même chose** (même outil, même idée) : **mettre à jour** l'entrée existante (voir « Mettre à jour une entrée »).
- **Proche mais distinct** (deux outils concurrents, un outil et l'idée qui l'utilise) : créer l'entrée et **ajouter le lien dans les deux sens** (`links`).
- **Doute** : une question en une ligne (« Mettre à jour *WebLLM* ou créer *MLC LLM* à part ? »). Sans réponse, mettre à jour.
- Même slug : toujours une mise à jour, jamais un écrasement aveugle.

## Règles de rédaction

- **`useful-when` est obligatoire.** C'est le champ qui fait ressortir l'entrée. Une situation concrète, formulée comme un projet ou un besoin (« faire un jeu 3D web avec beaucoup d'entités », « traiter des données sensibles sans serveur »), jamais une simple catégorie (« graphisme »). Le proposer à partir du contexte, sans poser de question ; l'utilisateur corrigera.
- **Le test de chaque ligne** : *si je l'enlève, est-ce qu'on refera une erreur, un débat déjà tranché, ou qu'on passera à côté du bon usage ?* Si non, l'enlever. Pas de listes exhaustives (tous les cas d'usage, toutes les briques, tous les réglages), pas de détails techniques qu'une recherche retrouve, pas de chiffres qui ne décident de rien. Garder au plus **2 à 3 éléments** par énumération : les plus décisifs.
- **Longueur selon le type** :
  - `outil`, `site`, `techno`, `concept`, `lecture` : **1 à 4 lignes**. Ce que c'est, en une ligne, puis ce qui compte pour s'en servir : **limites**, comment l'utiliser, alternative.
  - `idee` : **une ligne courte par section, 8 lignes au plus**. But : pouvoir reprendre l'idée dans une autre conversation sans refaire les mêmes débats.
    ```
    **Idée** : la proposition en une phrase.
    **Pourquoi** : le problème résolu, l'argument clé.
    **Choix structurants** : les décisions prises qui orientent la suite (pas la liste des briques).
    **Abandonné** : pistes écartées, avec la raison (et `réouvrir si` quand elle peut changer).
    **Limites** : seulement celles qui peuvent faire échouer l'idée.
    **Concurrence** : les 2 ou 3 acteurs qui comptent.
    **Pistes** : la prochaine étape, et au plus deux questions ouvertes.
    ```
    Omettre une section qui n'a pas été abordée. Si l'idée ne tient plus en 8 lignes, elle passe en **dossier** (voir « Dossier d'une idée ») : la fiche garde le résumé.
- Les **limites** comptent pour tous les types : c'est ce qui permet plus tard de déconseiller une entrée.
- Récupérer la page (une seule fois) uniquement si l'utilisateur ne donne qu'une URL sans contexte et que l'outil est inconnu. Sinon, aucun outil avant l'enregistrement, **sauf watcher** pour un lien vidéo (voir « Vidéos »).
- Ne rien inventer : dans le doute, omettre l'information.
- Français, en gardant les termes techniques anglais usuels.

## Fichier par entrée

Chemin : `pins/<slug>.md` (ou `pins/<slug>/README.md` pour une idée en dossier). Slug = titre en kebab-case, sans accents, parlant (`webllm`, `llm-local-navigateur`, `webgpu-jeux-web`). Le slug ne change pas quand l'entrée évolue (les liens en dépendent).

```markdown
---
title: wllama
slug: wllama
type: outil
tags: [llm, ia-locale, webassembly]
useful-when: faire tourner un LLM au format GGUF dans le navigateur, y compris sans WebGPU
source: conversation Claude sur WebGPU
links: [pin:webllm]
status: exploré
status-since: 2026-11-20
avis: écarté : trop lent sur CPU · réouvrir si WebGPU indisponible
created: 2026-11-04
updated: 2026-11-20
---
llama.cpp compilé en WebAssembly : tourne sur CPU, donc plus lent que WebLLM mais plus compatible.
```

- `type` : `outil`, `site`, `techno`, `idee`, `concept`, `lecture`.
- `status` : `noté`, `à creuser` ou `exploré` (voir « Statut et avis »).
- `avis` : optionnel, une ligne courte.
- `status-since` : date du dernier changement de statut (à la création : `created`).
- `tags` : 1 à 4, minuscules kebab-case. Réutiliser un tag existant dans `index.md` plutôt qu'en créer un voisin.
- `videos` : les URL de **vidéos** (TikTok, Reels, YouTube, etc.) citées par l'entrée, **telles que partagées** (souvent un lien court), en liste. C'est le jugement à la capture qui décide qu'un lien est une vidéo (pas une liste de plateformes) : un compte, une page ou un lien d'affiliation n'en sont pas. Ce qu'elles apportent va dans la section `## Vidéos` (voir « Vidéos »).
- `links` : `pin:<slug>`, `doc:<url>` ou `dossier` (l'entrée a un `dossier.md`), seulement pour des éléments qui existent (un pin présent dans l'index). Jamais de lien vers une fiche buzzword ni vers un autre stockage : chaque skill reste indépendant, `/sonar` fait les rapprochements.
- Champs obligatoires : `title`, `slug`, `type`, `useful-when`, `status`, `status-since`, `created`, `updated`. Omettre les autres quand ils sont vides.

## Index

`index.md` à la racine : une ligne par entrée, triée par slug. C'est le seul fichier qu'une recherche doit lire pour savoir ce qui existe, il doit donc rester à jour. Le statut (et l'avis s'il y en a un, après `:`) y figure.

```markdown
- [WebGPU](pins/webgpu.md) · techno · à creuser : tient-il sur mobile ? · jeu 3D web avec beaucoup d'entités · #webgpu #3d
- [wllama](pins/wllama.md) · outil · exploré : écarté, trop lent sur CPU · LLM GGUF dans le navigateur, y compris sans WebGPU · #llm #webassembly
- [WebLLM](pins/webllm.md) · outil · noté · faire tourner un petit LLM dans le navigateur, sans serveur · #llm #ia-locale
```

Créer le fichier s'il n'existe pas. À chaque ajout ou mise à jour, écrire ou remplacer la ligne correspondante. Dans l'index, l'avis peut être raccourci.

## Enregistrement

Repo de données (bloc Config), branche `main`, **un seul commit par appel** (sauf le déplacement vers un dossier, voir plus haut).

1. Si le repo n'est pas déjà dans la session, l'ajouter avec un accès en écriture (push), via l'outil d'ajout de repository GitHub de la session.
2. Le cloner (`git clone --depth 1`), ou `git pull` s'il est déjà cloné.
3. Écrire les fichiers et la ligne d'index, `git add`, un seul `git commit`, `git push origin main`.
4. L'intégration GitHub de synchronisation des sources d'un Project est en lecture seule : ne pas s'arrêter là.

Message de commit : `docs(pin): add three-js; update webgpu, chat-local-navigateur` (`add` pour une création, `update` pour une mise à jour, séparés par `;`).

## Confirmation

Uniquement après un `git push` réussi :

```
Épinglé (commit <sha court>) :
- [**Three.js**](https://github.com/<repo>/blob/main/pins/three-js.md) · ajouté · utile quand : rendu 3D web avec repli WebGL
- [**WebGPU**](https://github.com/<repo>/blob/main/pins/webgpu.md) · à creuser → exploré · utilisé dans un jeu web
- [**Chat local dans le navigateur**](https://github.com/<repo>/blob/main/pins/chat-local-navigateur/README.md) · dossier créé · [dossier](https://github.com/<repo>/blob/main/pins/chat-local-navigateur/dossier.md)
```

- Chaque nom est un **lien vers son fichier** : `https://github.com/<repo>/blob/main/pins/<slug>.md` (ou `…/pins/<slug>/README.md`), comme dans `/sonar`. Pour une idée en dossier, ajouter `· [dossier](…/pins/<slug>/dossier.md)`.
- Vidéos lues : `· 2 vidéos lues et archivées, 1 illisible` ; vidéo restée non lue (échec passager) : le dire ; archive en échec : `· archive en échec : limite de 20 Go atteinte` (la raison donnée par watcher), rattrapé par le prochain `/pin vidéos`. Rien sur les vidéos si watcher était absente.
- Pour un ajout, afficher le `useful-when` pour que l'utilisateur puisse le corriger d'un mot ; pour une mise à jour, ce qui a changé.
- Pour une **idée ajoutée** en `noté` : une dernière ligne `À creuser ? /pin <slug> ?`.
- Si l'identité de l'élément était ambiguë (plusieurs « heretic » possibles), une ligne pour dire lequel a été retenu.
- Rien d'autre.

## Échec

`Non épinglé : <raison en quelques mots>`. Ne jamais écrire « Épinglé » sans commit poussé.

Si l'échec vient de l'accès au repo, ne pas renvoyer vers des fichiers locaux (l'utilisateur ne les voit pas). Donner **dans la réponse** un bloc prêt à coller dans une autre conversation :

````
```
/pin Enregistre ces entrées telles quelles (un seul commit) :
--- pins/<slug>.md ---
<fichier complet>
--- ligne d'index ---
<ligne>
```
````