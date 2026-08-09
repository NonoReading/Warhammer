# 🎯 TRI INTELLIGENT + DÉCALAGE COLONNE

## ✨ Améliorations appliquées

### 1️⃣ Décalage d'une colonne vers la droite

**Avant:**
```
Col 0: Code
Col 1: Libellé
Col 2: Livre
Col 3: Sélectionné
Col 4: Valeur
```

**Après:**
```
Col 0: (Vide - pour future interaction)
Col 1: Code
Col 2: Libellé
Col 3: Livre
Col 4: Sélectionné
Col 5: Valeur
```

✅ La colonne 0 est réservée pour des futures interactions (checkbox, boutons, etc.)

---

### 2️⃣ Tri multi-critères

**Critères de tri:**
1. **Priorité 1:** Sélectionnés en premier (✓)
2. **Priorité 2:** Non-sélectionnés après
3. **Priorité 3:** Alphabétique par Libellé dans chaque groupe

**Résultat:**
```
┌───┬──────────┬──────────────┬────────┬─────┬────────┐
│   │ Code     │ Libellé      │ Livre  │ Sél │ Valeur │
├───┼──────────┼──────────────┼────────┼─────┼────────┤
│   │RULE-W01  │ Agitator     │ Core.. │  ✓  │   01   │ ← Sélectionnés
│   │RULE-W02  │ Engineer     │ Core.. │  ✓  │   02   │   (triés alpha)
│   │ARCH-W99  │ Pit Fighter  │ Arch.. │  ✓  │   15   │
│   │RULE-W03  │ Lawyer       │ Core.. │     │        │ ← Non-sélectionnés
│   │RULE-W99  │ Alchemist    │ Core.. │     │        │   (triés alpha)
└───┴──────────┴──────────────┴────────┴─────┴────────┘
```

---

## 🔧 Comment ça marche?

### Format de stockage temporaire

```pascal
TempCareersData: TStringList
```

Chaque ligne au format:
```
"0|Agitator|RULES-WORK01|Core Rules Book|01"
```

Structure: `"Selected|Libelle|Code|Livre|CareerValue"`

Où:
- **Selected:** "0" = sélectionné (en premier), "1" = non-sélectionné (en dernier)
- **Libelle:** Nom du métier
- **Code:** CodeMetier
- **Livre:** Nom traduit du livre
- **CareerValue:** Valeur du XML (ex: "01")

---

### Algorithme de tri

```pascal
// 1. Créer liste avec toutes les données + marqueur de sélection
for I := 0 to ListMetier.Count - 1 do
begin
  if CareerFound then
    TempCareersData.Add('0|' + Libelle + ...)  // 0 = sélectionné
  else
    TempCareersData.Add('1|' + Libelle + ...);  // 1 = non-sélectionné
end;

// 2. Trier lexicographiquement
TempCareersData.Sort;  // "0|..." vient avant "1|..."
                       // Dans chaque groupe, alphabétique par Libelle
```

**Exemple avant tri:**
```
"1|Lawyer|RULES-W03|..."
"0|Engineer|RULES-W02|..."
"0|Agitator|RULES-W01|..."
"1|Alchemist|RULES-W99|..."
```

**Exemple après tri (lexicographique):**
```
"0|Agitator|RULES-W01|..."    ← "0..." vient en premier
"0|Engineer|RULES-W02|..."    ← Alphabétique dans le groupe "0"
"1|Alchemist|RULES-W99|..."   ← "1..." vient après
"1|Lawyer|RULES-W03|..."      ← Alphabétique dans le groupe "1"
```

---

### Affichage dans le grid

```pascal
for I := 0 to TempCareersData.Count - 1 do
begin
  Parts := TempCareersData[I].Split('|');
  
  StringGridSkills.Cells[0, RowIdx] := '';        // Col 0: Vide
  StringGridSkills.Cells[1, RowIdx] := Parts[2]; // Col 1: Code
  StringGridSkills.Cells[2, RowIdx] := Parts[1]; // Col 2: Libelle
  StringGridSkills.Cells[3, RowIdx] := Parts[3]; // Col 3: Livre
  StringGridSkills.Cells[4, RowIdx] := 
    (Parts[0] = '0') ? '✓' : '';                  // Col 4: Sélectionné
  StringGridSkills.Cells[5, RowIdx] := Parts[4]; // Col 5: Valeur
  
  Inc(RowIdx);
end;
```

---

## 📊 Exemple complet

### Données initiales de ListMetier
```
RULES-WORK03  | Lawyer        | Core Rules Book
RULES-WORK02  | Engineer      | Core Rules Book
ARCH3-WORK99  | Pit Fighter   | Archives 3
RULES-WORK01  | Agitator      | Core Rules Book
DEATH-WORK105 | Cursed Wander | Death
```

### Sélectionnés pour la race (RaceCareersData)
```
RULES-WORK01|01
RULES-WORK02|02
ARCH3-WORK99|15
```

### Après traitement et tri
```
TempCareersData:
  "0|Agitator|RULES-WORK01|Core Rules Book|01"      ← Sélectionné #1
  "0|Engineer|RULES-WORK02|Core Rules Book|02"      ← Sélectionné #2
  "0|Pit Fighter|ARCH3-WORK99|Archives 3|15"        ← Sélectionné #3
  "1|Cursed Wander|DEATH-WORK105|Death|"            ← Non-sélectionné #1
  "1|Lawyer|RULES-WORK03|Core Rules Book|"          ← Non-sélectionné #2
```

### Affichage dans le grid
```
┌───┬──────────────┬──────────────┬────────────┬─────┬─────┐
│   │ Code         │ Libellé      │ Livre      │ Sél │ Val │
├───┼──────────────┼──────────────┼────────────┼─────┼─────┤
│   │RULES-WORK01  │ Agitator     │ Core Rules │  ✓  │ 01  │
│   │RULES-WORK02  │ Engineer     │ Core Rules │  ✓  │ 02  │
│   │ARCH3-WORK99  │ Pit Fighter  │ Archives 3 │  ✓  │ 15  │
│   │DEATH-WORK105 │ Cursed Wand. │ Death      │     │     │
│   │RULES-WORK03  │ Lawyer       │ Core Rules │     │     │
└───┴──────────────┴──────────────┴────────────┴─────┴─────┘
```

✅ **Sélectionnés en premier**, puis **alphabétique** dans chaque groupe

---

## 🧪 Cas de test

### Test 1: Plusieurs sélectionnés
```
✓ Agitator
✓ Engineer
✓ Pit Fighter
  Alchemist
  Lawyer
```

### Test 2: Un seul sélectionné
```
✓ Engineer
  Agitator
  Lawyer
```

### Test 3: Aucun sélectionné
```
  Agitator
  Engineer
  Lawyer
```

---

## 💾 Variables utilisées

| Variable | Type | Rôle |
|----------|------|------|
| `TempCareersData` | TStringList | Liste temporaire pour tri |
| `Parts` | TStringList | Parser les lignes "0\|Lib\|..." |
| `CodeLivre` | String | Livre traduit |
| `CareerFound` | Boolean | Vérifie si sélectionné |

---

## 📌 Points importants

✅ **Préfixe "0" = sélectionné** (sort avant "1")
✅ **Préfixe "1" = non-sélectionné** (sort après "0")
✅ **Sort() trie lexicographiquement** (ASCII: "0" < "1")
✅ **Col 0 est vide** (pour future utilisation)
✅ **Données décalées** Col 1-5 (au lieu de 0-4)

---

## 🚀 Avantages

✨ **Utilisateur voit immédiatement les sélectionnés**
✨ **Alphabétique facile à trouver**
✨ **Pas de tri manuel complexe**
✨ **Col 0 libre pour futures améliorations**
✨ **Format |pipe| facilite parsing**

---

**Tri intelligent et décalage appliqués!** 🎉
