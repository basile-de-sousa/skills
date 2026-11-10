---
name: "note"
description: "Compile des notes brutes (bullets, vocab, Q&A, acteurs, supports joints) en une page HTML épurée par sujet, mise à jour sans doublon. Utiliser sur /note, /note [sujet] {contexte}."
---

# /note [sujet] {contexte}

## Config
<!-- config -->
- Site du glossaire : `<à définir>`
<!-- /config -->

Le **site du glossaire** est l'adresse où sont publiées les fiches `/buzzword` de l'utilisateur ; il ne sert qu'aux liens des fiches buzzword. S'il vaut `<à définir>`, ne rien demander : écrire ces fiches sans `url`. Pourquoi : c'est un confort optionnel, il ne doit pas bloquer la prise de notes. Ce bloc ne contient jamais de secret (jeton, mot de passe).

Notes brutes dans le chat → un artifact HTML par **sujet** (ex. RGPD, Marketing), découpé en **pages internes** (onglets) qui suivent un **fil conducteur**. Objectif : **apprendre vite et recomprendre une notion en quelques secondes**. Contenu épuré (court, sans remplissage), forme identique d'un sujet à l'autre (voir Gabarit). L'artifact est la source de vérité : on l'enrichit, on ne le recrée jamais, on n'en crée pas de doublon.

Les règles ci-dessous sont des **défauts** : une demande de l'utilisateur prime toujours (déplacer, renommer, garder tel quel, plus ou moins de détail).

**Lister les sujets** : toujours `Artifact` list avec `limit: 200`. La liste par défaut ne montre que les 25 artifacts les plus récents : un sujet plus ancien serait invisible et recréé en doublon.

## Commandes

| Commande | Effet |
|---|---|
| `/note` sans notes dans la conversation | Mémo de syntaxe (5 lignes) + liste des sujets (titres `Notes · …` : sujet, date, pages) |
| `/note` avec notes, ou « compile » / « fin » en capture | Compiler |
| `/note sujet {contexte}` | Sans notes : ouvrir une capture. Avec notes : compiler dans ce sujet. `{contexte}` optionnel |
| `/note sujet > page` | Idem, dans la page interne `page` |
| `/note fusion A B` | Fusionner le sujet B dans A (B devient une ou plusieurs pages de A) |

## Capture

Pendant une capture, répondre au plus court :
- **`✓`** quand la note se suffit (un fait clair, une liste, une référence).
- **`✓` + une ligne** (15 mots max) quand elle apporte quelque chose : définir un terme ou un sigle, situer un nom ou un cas, corriger un chiffre. Ex. : `✓ Affaire Alstom : rachat d'Alstom Énergie par GE (2014), sous pression du FCPA américain.` Si le nom est introuvable, le dire : `✓ Breach3d : rien de public sous ce nom, à préciser.`
- **1-2 lignes** pour une question (voir Questions sans réponse).
- `> page` change de page pour la suite : `✓ → page`.
Pas de reformulation de la note, pas de commentaire.

## Syntaxe (toute optionnelle, le texte libre marche)

| Saisie | Devient |
|---|---|
| `- texte` ou texte libre | point rattaché à une notion |
| `> PRINCE2` | une **page interne** (onglet), jamais une simple section ; créée si absente |
| `! texte` | point clé |
| `mot : définition` | glossaire |
| `mot ?` (un mot ou un sigle) | glossaire, définition courte par Claude |
| `question ?` ou `???` | question ouverte, Claude propose une réponse |
| `@JD = Jean Dupont, rôle[, linkedin.com/in/…]` | acteur (le lien peut venir plus tard : `@JD linkedin.com/in/…`) |
| `Q JD : question` puis `R : réponse` | Q&A liée à l'acteur et à la page en cours |
| `slide 12`, `p.4` | référence au support |
| fichier joint (pdf, pptx, html…) | support |

## Description et fil conducteur

- `overview` : **2-3 phrases** en tête du sujet. De quoi parle le cours, à quoi il sert, et comment s'enchaînent ses parties (mots-clés en gras). Elle est réécrite à chaque compilation à partir de **toutes** les notes du sujet, pas seulement des nouvelles.
- Les pages sont **ordonnées selon le fil** du cours (introduction ou cas d'ouverture, méthode, application, cas pratique) et numérotées dans cet ordre. La synthèse de chaque page dit en une ligne son rôle dans le fil.

## Pages internes

Une page = un **thème** ou une **activité** lisible seul : un chapitre (« Méthode du renseignement », « PRINCE2 »), un cas d'étude, un workshop, un coaching, une préparation de soutenance. Champs : `type` (cours, cas, workshop, coaching, soutenance…), `title`, `date` (seulement si connue), synthèse, notions.

- **Nommer les pages par leur thème**, jamais « Cours » fourre-tout.
- **Choisir la page** : `> X` d'abord (titre proche d'une page existante → la réutiliser) ; sinon la page du même thème ; sinon une nouvelle page. Un nouveau thème, un cas d'étude ou une activité mérite sa page dès sa première notion.
- **Éviter la surcharge** : une page doit se lire d'une traite (environ 2 à 5 notions sur un seul thème). Une page qui mélange des thèmes ou s'allonge est scindée. Deux mini-pages du même thème sont réunies. Tout cela sans perte de contenu, avec une ligne dans `log`, et annoncé dans la réponse.
- **Onglet « Référentiel »** (commun) : glossaire, acteurs, à creuser, sources. Une Q&A appartient à sa page et apparaît aussi dans le Référentiel.

## Notions

Chaque notion = un `brief` (« L'essentiel ») puis des `points` (« Notes »).

**L'essentiel** : la fiche à relire pour recomprendre en 10 secondes, sur le modèle d'une fiche buzzword. Elle est **toujours présente**, même si l'utilisateur n'a noté qu'un mot.
- `one` : **une phrase** qui dit ce qu'est la notion et pourquoi elle compte. Pour un cas : qui, quoi, quand, en quoi c'est un cas d'école.
- `bullets` : 0 à 4 puces, une par angle utile à l'oral (mécanisme, étape clé, chiffre ou exemple, conséquence ou piège). La forme « **Mot-clé** : explication » fonctionne bien.
- **Mots-clés en gras** (`**…**`), peu nombreux : ceux à placer à l'oral.
- `see` (optionnel) : notions liées avec les opérateurs `< X` (compris dans X), `> X` (comprend X), `& X` (voisin), `= X` (synonyme), `≠ X` (faux-ami).
- **Nom propre** (entreprise, affaire, groupe d'attaquants, rapport, loi) : faire une recherche web avant d'écrire, ajouter la source dans `sources`. Rien de trouvé → le dire **dans l'essentiel** (« aucune source publique sous ce nom »), donner le contexte vérifiable autour, et ajouter une piste dans `open`.
- Noms, dates et chiffres exacts. `by: claude` + `sure`, ou `by: me` si l'utilisateur l'a dicté.

**Notes** : ce que l'utilisateur a noté, plus les détails de Claude que l'essentiel ne couvre pas.
- Une note qui ne fait que nommer la notion devient son **titre**, pas un point.
- **Étapes, listes, typologies** : un point court par élément (`ordered: true` pour une séquence), affiché en étiquettes. Jamais une phrase qui énumère les étapes.
- Claude n'ajoute pas de point qui répète l'essentiel. Une notion peut n'avoir aucun point.

## Questions sans réponse

Toute question sans réponse (`Q` sans `R`, note qui finit par `?`, `???`, question dans `open`) reçoit une tentative de réponse, en capture comme en compilation.

- Sources : support joint, puis notes du sujet, puis connaissances générales ; recherche web si la réponse dépend de faits récents ou précis. Citer le support quand il y en a un.
- 1-3 lignes, `by: claude`, `sure: high|low`.
- Q&A adressée à un acteur : réponse de Claude dans `claude_a`, jamais dans `a` ; la question reste « en attente de JD ». Vraie réponse reçue → `a`, garder `claude_a`, et ajouter à `open` si elles divergent.
- Pas de réponse fiable (fait interne au cours, avis de l'acteur) : ne pas inventer, laisser dans `open` avec une piste (« à demander à l'intervenant »).

## Fiches buzzword (optionnel)

Si des fiches `/buzzword` sont affichées **dans la conversation en cours**, les réutiliser ; sinon rien à faire. Ne jamais charger le skill buzzword ni consulter son repo ou son site.
- Glossaire : `term` = nom de la fiche, `def` = première puce en une ligne, `by: buzzword` (remplace une définition `by: claude`, jamais `by: me`). La fiche nourrit aussi l'essentiel de la notion.
- `url` = `<site du glossaire>/<slug>/` (slug = nom complet en kebab-case, sans accents). Sans `/buzzword save` dans la conversation, ajouter « liens actifs après /buzzword save » à la réponse.

## Compiler

1. **Retrouver le sujet** : lister les `Notes · …` (avec `limit: 200`) et comparer (faute de frappe, accents, sigle, synonyme, sujet inclus dans un autre).
   - Correspondance exacte → mise à jour.
   - Proche → demander en une question : mettre à jour « X », créer un sujet, ou en faire une page de « X ».
   - Une activité d'un sujet existant (« atelier RGPD ») → page de ce sujet.
   - Existe : `read`, extraire le JSON `#notes` et le bloc `#diagrams`. Sinon créer, titre `Notes · {Court}`.
2. **Fusionner** les nouvelles notes :
   - télégraphique, une idée par point, dédoublonné ;
   - ne jamais supprimer une note de l'utilisateur sans demande ; contradiction → garder les deux + `open` ;
   - ne rien inventer ; tout ajout de Claude porte `by: claude` ;
   - support : en tirer le plan, renvoyer aux slides, ne pas le recopier ;
   - `{contexte}` s'ajoute à `context` et oriente l'interprétation ;
   - acteurs : initiales inconnues → une seule question groupée, sinon les garder + `open`. LinkedIn uniquement s'il est collé par l'utilisateur, jamais cherché ;
   - questions et fiches buzzword selon les sections ci-dessus ;
   - une ligne dans `log`.
3. **Relire tout le sujet**, pas seulement l'ajout, et corriger ce qui manque :
   - la description est à jour ;
   - les pages suivent le fil et aucune ne mélange des thèmes ;
   - chaque notion a son essentiel ;
   - chaque nom propre est expliqué ou signalé introuvable ;
   - les étapes sont en étiquettes ;
   - aucun point de Claude ne répète l'essentiel.
   Un sujet à un ancien format (sans `pages`, `brief` ou `overview`) est converti au passage.
4. **Écrire** avec le Gabarit et republier avec l'`url` du sujet.
5. **Répondre** en une ligne, page par page (ex. « Cours : +2 notions · nouvelle page PRINCE2 : 3 notions »), sans résumer le contenu.

### Données

Dans `<script type="application/json" id="notes">`. `id` uniques dans tout le sujet (lettres, chiffres, tirets).

```json
{
  "subject": "Court · Long", "updated": "YYYY-MM-DD", "context": "",
  "overview": "2-3 phrases avec **mots-clés**",
  "pages": [{"id": "", "title": "", "type": "cours|cas|workshop|…", "date": null, "summary": ["5 lignes max"],
    "notions": [{"id": "", "title": "", "ordered": false,
      "brief": {"one": "", "bullets": [], "see": [], "by": "claude", "sure": "high"},
      "points": [{"text": "", "key": false, "ref": null, "by": "me", "sure": "high"}]}]}],
  "glossary": [{"term": "", "def": "", "by": "me|claude|buzzword", "url": null}],
  "actors": [{"id": "JD", "name": "", "role": "", "linkedin": null}],
  "qa": [{"page": "", "actor": "JD", "q": "", "a": null, "claude_a": null, "sure": "high", "date": ""}],
  "open": [], "sources": [{"name": "", "type": "oral|web|slides|pdf", "page": ""}],
  "log": [{"date": "", "change": ""}]
}
```

Diagrammes Mermaid : hors JSON, dans `<div id="diagrams" hidden>`, en `<pre class="mermaid" data-for="id-notion" data-caption="…">`. Ne jamais recopier le bloc `claude-mermaid-runtime` d'une page lue : la plateforme le réinjecte.

### Gabarit

Le design est figé dans l'artifact **« Template Notes »** : bandeau « Gabarit du skill /note », exemple fictif de chaque élément, JSON avec `"template": true`, et version dans le commentaire CSS (`Gabarit /note vN`).

- **Version identique** à celle du HTML du sujet → réutiliser ce HTML tel quel, sans relire le gabarit.
- **Sujet nouveau, plus ancien ou sans version** → lire « Template Notes » (le chercher par son titre avec `Artifact` list, `limit: 200`). Recopier son HTML tel quel, en ne remplaçant que le `<title>`, le bloc `#diagrams` (vide si aucun) et le JSON, sans `"template": true`.
- **Gabarit introuvable** : reconstruire d'après le résumé ci-dessous (avec `artifact-design`), le republier sous le titre « Template Notes » en v1, et le signaler en une ligne.
- **Changer le design** : seulement sur demande. Modifier « Template Notes », incrémenter la version, mettre l'exemple et le résumé à jour. Les sujets suivent à leur prochaine compilation.

Résumé du design, pour le reconstruire :
- **Style** : style « dossier de conseil » gris-bleu froid (fond `#F3F4F7`, texte `#141B2D`), accent ambre `#E2A72E`, mode sombre bleu nuit. Polices : Bricolage Grotesque 800, Schibsted Grotesk, IBM Plex Mono. Pas d'ombre ni d'emoji.
- **Bandeau sombre** : titre, description (`overview`, mots-clés en ambre), recherche, bouton « Essentiel seulement » (masque les notes), onglets numérotés des pages (qui passent à la ligne) puis « Référentiel ». Une page visible à la fois (`#id-page`, `#id-notion`) ; les pages masquées le sont par `visibility:hidden` et non `display:none`, pour les diagrammes.
- **Page** : synthèse, sommaire, notions numérotées `01`. Chaque notion montre une carte « L'essentiel » puis « Notes » (masqué si vide). Les items courts s'affichent en étiquettes reliées par → si `ordered`, avec une bordure pointillée prune pour ceux de Claude.
- **Rail flottant à droite** (≥ 1080px) : losanges pour les pages, traits pour les notions, libellés au survol.
- **Couleurs pâles par type** : point clé ambre, glossaire bleu, acteurs et Q&A vert, à creuser orange, badge « + Claude » prune. Le Référentiel est en grille de 2 blocs, avec les liens « buzzword ↗ » et « in ↗ ».