# 🔧 Correction: Tri des compétences restauré

## ✅ Problème trouvé

**Problème:** Le tri des compétences ne fonctionnait plus après les changements de grids.

**Cause:** `SortSkillsGrid()` utilisait `StringGridCareers` au lieu de `StringGridSkills`!

**Impact:** Les compétences n'étaient pas triées (sélectionnées en premier, puis alphabétique).

---

## 🐛 Erreurs identifiées

### Erreur 1: Lecture des données
```pascal
// ❌ AVANT (FAUX)
LastRow := StringGridCareers.RowCount - 1;  // Mauvais grid!
for I := 1 to LastRow do
begin
  Rows[I - 1].Code := StringGridCareers.Cells[1, I];      // ❌
  Rows[I - 1].Label_ := StringGridCareers.Cells[2, I];    // ❌
  Rows[I - 1].Specialization := StringGridCareers.Cells[3, I];  // ❌
  Rows[I - 1].Selected := StringGridCareers.Cells[4, I];  // ❌
end;
```

**Problème:** `SortSkillsGrid()` lisait les compétences depuis `StringGridCareers` (les métiers)!

### Erreur 2: Affichage des données triées
```pascal
// ❌ AVANT (FAUX)
for I := 1 to LastRow do
begin
  StringGridCareers.Cells[1, I] := Rows[I - 1].Code;          // ❌ Métiers!
  StringGridCareers.Cells[2, I] := Rows[I - 1].Label_;        // ❌
  StringGridCareers.Cells[3, I] := Rows[I - 1].Specialization; // ❌
  StringGridCareers.Cells[4, I] := Rows[I - 1].Selected;      // ❌
end;
```

**Problème:** Les données triées étaient réécrites dans le mauvais grid!

---

## ✅ Correction appliquée

### Correction 1: Lecture des données
```pascal
// ✅ APRÈS (BON)
LastRow := StringGridSkills.RowCount - 1;  // ✓ Bon grid!
for I := 1 to LastRow do
begin
  Rows[I - 1].Code := StringGridSkills.Cells[0, I];        // ✓ Col 0
  Rows[I - 1].Label_ := StringGridSkills.Cells[1, I];      // ✓ Col 1
  Rows[I - 1].Specialization := StringGridSkills.Cells[2, I]; // ✓ Col 2
  Rows[I - 1].Selected := StringGridSkills.Cells[4, I];    // ✓ Col 4 (checkbox)
end;
```

**Note:** Les colonnes sont 0, 1, 2, 4 (car col 3 est la spécialisation)

### Correction 2: Affichage des données triées
```pascal
// ✅ APRÈS (BON)
for I := 1 to LastRow do
begin
  StringGridSkills.Cells[0, I] := Rows[I - 1].Code;        // ✓ Col 0
  StringGridSkills.Cells[1, I] := Rows[I - 1].Label_;      // ✓ Col 1
  StringGridSkills.Cells[2, I] := Rows[I - 1].Specialization; // ✓ Col 2
  StringGridSkills.Cells[4, I] := Rows[I - 1].Selected;    // ✓ Col 4
end;
```

---

## 📊 Résultat du tri

### Avant (sans tri)
```
Compétence 1        Spécialisation 1      ✓
Compétence 2        Spécialisation 2      
Compétence 3        Spécialisation 3      ✓
Compétence 4        (vide)                
```

### Après (avec tri correct)
```
Compétence 1        Spécialisation 1      ✓  ← Sélectionnées en premier
Compétence 3        Spécialisation 3      ✓  ← Puis alphabétique
Compétence 2        Spécialisation 2         ← Non-sélectionnées après
Compétence 4        (vide)                   ← Puis alphabétique
```

✅ **Sélectionnées (✓) en premier**
✅ **Alphabétique par Libellé dans chaque groupe**

---

## 🎯 Logique du tri

### Étape 1: Charger les données
```pascal
// Lire depuis StringGridSkills
Rows[I - 1].Code := StringGridSkills.Cells[0, I];
Rows[I - 1].Label_ := StringGridSkills.Cells[1, I];
Rows[I - 1].Specialization := StringGridSkills.Cells[2, I];
Rows[I - 1].Selected := StringGridSkills.Cells[4, I];  // ✓ ou ''
```

### Étape 2: Trier à bulles
```pascal
if Rows[I].Selected < Rows[I + 1].Selected then
  NeedSwap := True;  // '' < '✓' alphabétiquement, donc ✓ remonte en premier
else if Rows[I].Selected = Rows[I + 1].Selected then
begin
  // Même status (✓/✓ ou ''/'' ), comparer alphabétiquement
  if AnsiCompareText(Rows[I].Label_, Rows[I + 1].Label_) > 0 then
    NeedSwap := True;
end;
```

### Étape 3: Réafficher les données triées
```pascal
// Écrire dans StringGridSkills
StringGridSkills.Cells[0, I] := Rows[I - 1].Code;
StringGridSkills.Cells[1, I] := Rows[I - 1].Label_;
StringGridSkills.Cells[2, I] := Rows[I - 1].Specialization;
StringGridSkills.Cells[4, I] := Rows[I - 1].Selected;
```

---

## ✨ Structure des colonnes StringGridSkills

```
Col 0: Code           (ex: "RULES-COMPCALM")
Col 1: Libellé        (ex: "Calme")
Col 2: Spécialisation (ex: "Leadership" ou vide)
Col 3: (Sélectionné?) (pas utilisé dans ce cas)
Col 4: Sélectionné    (✓ ou vide)
```

---

## 🧪 Test du tri

```
1. Ouvre un XML
2. Clique "Compétences de race"
3. Observe l'ordre:
   ✓ Compétences avec ✓ en premier
   ✓ Triées alphabétiquement par Libellé
   ✓ Puis compétences sans ✓
   ✓ Triées alphabétiquement par Libellé
```

---

## 📁 Fichier modifié

**winlivre.pas:** Procédure `SortSkillsGrid()`
- ✅ Ligne ~1710: Utiliser `StringGridSkills` au lieu de `StringGridCareers`
- ✅ Lignes ~1716-1719: Lire depuis les bonnes colonnes (0, 1, 2, 4)
- ✅ Lignes ~1753-1759: Réafficher dans les bonnes colonnes (0, 1, 2, 4)

---

## 🎉 Résultat

Tri des compétences **parfaitement restauré**! 🎊

- Sélectionnées en premier
- Alphabétique par Libellé
- Non-sélectionnées après
- Alphabétique par Libellé

Navigation complète et cohérente! ✨
