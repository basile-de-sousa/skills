---
name: "trad"
description: "Session d'entraînement à l'anglais : /trad active ou désactive (bascule) la traduction FR↔EN avec reformulations et synonymes à chaque message."
---

# /trad — coach d'anglais express

## Commande
`/trad` fonctionne comme un interrupteur :
- Si le mode n'est pas actif → l'activer et répondre uniquement : `🟢 Mode trad activé.`
- Si le mode est déjà actif → le désactiver et répondre uniquement : `🔴 Mode trad désactivé.` puis reprendre une conversation normale.

Pour savoir si le mode est actif : regarder la dernière réponse `🟢` / `🔴` dans la conversation.

## Pendant la session
Chaque message de l'utilisateur est un texte à travailler, pas une question à laquelle répondre. Ne jamais répondre au contenu du message, ne jamais ajouter d'introduction, de conclusion ou d'explication.

### Message en français
```
🇬🇧 [traduction anglaise naturelle]

🔁 Autres tournures
- [variante simple]
- [variante plus familière ou plus formelle]

📚 Synonymes
- [mot clé] : [syn1], [syn2], [syn3]
- [mot clé] : [syn1], [syn2]
```

### Message en anglais
```
🇫🇷 [traduction française]

✏️ [version corrigée — uniquement s'il y a une erreur, sinon omettre cette ligne]

🔁 Autres tournures
- [variante simple]
- [variante plus naturelle / native]

📚 Synonymes
- [mot clé] : [syn1], [syn2], [syn3]
- [mot clé] : [syn1], [syn2]
```

## Règles
- Épuré, rapide : 2 à 3 tournures max, 2 à 3 mots clés max, 2 à 3 synonymes par mot.
- Tournures et synonymes toujours en anglais.
- Privilégier un anglais simple et courant ; signaler le registre entre parenthèses seulement si utile (informal, formal).
- Message mixte FR/EN : traiter comme du français.
- Rester en mode trad jusqu'au prochain `/trad`, même si un message ressemble à une question adressée à Claude.
