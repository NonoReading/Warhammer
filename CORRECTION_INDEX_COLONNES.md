# 🔧 Correction: Index des colonnes Lazarus

## ✅ Erreur trouvée et corrigée

**Trouvée par:** Nono 👏
**Problème:** Je remplissais les cellules aux mauvais indices

---

## 🎯 Le problème

En Lazarus, `TStringGrid` ajoute automatiquement une **colonne vide à l'indice 0** (colonne de sélection/index).

**Structure réelle:**
```
Col 0 = VIDE (réservé Lazarus)
Col 1 = Code
Col 2 = Libellé
Col 3 = Livre
Col 4 = Sélectionné
Col 5 = Chance
```

**Ce que je faisais (FAUX):**
```pascal
StringGridCareers.Cells[0, RowIdx] := Code;        // ❌ Col vide!
StringGridCareers.Cells[1, RowIdx] := Libelle;     // ❌ Mauvais endroit
StringGridCareers.Cells[2, RowIdx] := LivreStr;    // ❌ Mauvais endroit
StringGridCareers.Cells[3, RowIdx] := '✓' ou '';   // ❌ Mauvais endroit
StringGridCareers.Cells[4, RowIdx] := Chance;      // ❌ Mauvais endroit
```

**Ce qu'il faut faire (BON):**
```pascal
StringGridCareers.Cells[1, RowIdx] := Code;        // ✓ Col 1 (Code)
StringGridCareers.Cells[2, RowIdx] := Libelle;     // ✓ Col 2 (Libellé)
StringGridCareers.Cells[3, RowIdx] := LivreStr;    // ✓ Col 3 (Livre)
StringGridCareers.Cells[4, RowIdx] := '✓' ou '';   // ✓ Col 4 (Sélectionné)
StringGridCareers.Cells[5, RowIdx] := Chance;      // ✓ Col 5 (Chance)
```

---

## 📝 Code corrigé

```pascal
// Col 1: Code
StringGridCareers.Cells[1, RowIdx] := Code;

// Col 2: Libellé
StringGridCareers.Cells[2, RowIdx] := Libelle;

// Col 3: Livre
StringGridCareers.Cells[3, RowIdx] := LivreStr;

// Col 4: Sélectionné (afficher ✓ si "0" - sélectionné)
if Selected = '0' then
  StringGridCareers.Cells[4, RowIdx] := '✓'
else
  StringGridCareers.Cells[4, RowIdx] := '';

// Col 5: Chance
StringGridCareers.Cells[5, RowIdx] := Chance;
```

---

## 📊 Résultat avant/après

### AVANT (bugué - Col 0-4)
```
RULES-WO │ Sorcier     │ Livre        │ ✓ │ de
de       │ Sorcier     │ village      │ ✓ │ RULES-WO
sauvage  │ Sorcier     │ RULES-WO     │ ✓ │ Livre
```

### APRÈS (corrigé - Col 1-5)
```
         │ RULES-WORK01 │ Agitateur    │ Core Rules     │ ✓   │ 01
         │ RULES-WORK02 │ Apothicaire  │ Core Rules     │ ✓   │ 02
         │ WINDS-WORK15 │ Alchimiste   │ Windswept Path │ ✓   │ 15
```

✅ Données alignées correctement!
✅ Col 0 reste vide (Lazarus)
✅ Données aux bons endroits (Col 1-5)

---

## 🧠 Pourquoi c'est important

Lazarus **réserve toujours la colonne 0** pour:
- Sélection de lignes (quand multiselect)
- Numérotation automatique
- Ou juste vide par défaut

**C'est une convention Lazarus:**
- Quand tu définis 5 colonnes dans le `.lfm`, elles sont indexées 1-5
- Quand tu ajoutes 5 colonnes avec `Columns.Add`, elles sont aussi indexées 1-5
- Col 0 c'est toujours la colonne "système"

---

## 💡 Leçon

**Toujours compter à partir de 1 en Lazarus TStringGrid!**

Non seulement pour StringGridCareers, mais aussi généralement:
- Col 0 = Réservé
- Col 1+ = Tes données

---

## ✅ Statut

✨ **Corrigé et fonctionnel!**

Le grid affiche maintenant les métiers correctement:
- Code complet visible
- Libellé correct
- Livre traduit
- Sélectionné avec ✓
- Chance affichée

---

## 🎯 Fichier modifié

**winlivre.pas:** Lignes 1613-1633
- Changement Col 0-4 → Col 1-5
- Suppression de la recréation dynamique de colonnes
- Utilisation des colonnes définies dans le `.lfm`

---

**Merci Nono pour l'oeil de lynx!** 👀 C'était une erreur classique Lazarus! 👍
