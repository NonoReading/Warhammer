# 📊 Structure des colonnes - Grille Métiers

## ✅ Configuration finale - 6 colonnes

| Col | Header | Contenu | Rôle |
|-----|--------|---------|------|
| 0 | (Vide) | (Vide) | Réservée pour futures interactions |
| 1 | Code | RULES-WORK01 | Code unique du métier |
| 2 | Libellé | Agitateur | Nom du métier |
| 3 | Livre | Core Rules Book | Nom du livre source (traduit) |
| 4 | Sélectionné | ✓ ou (vide) | Marqueur de sélection |
| 5 | Chance | 01, 02, 15, ... | Valeur/Chance du métier |

---

## 📋 Exemple d'affichage

```
┌───┬─────────────┬──────────────┬────────────────┬─────────┬────────┐
│   │ Code        │ Libellé      │ Livre          │ Sélec.  │ Chance │
├───┼─────────────┼──────────────┼────────────────┼─────────┼────────┤
│   │RULES-WORK01 │ Agitateur    │ Core Rules     │    ✓    │   01   │
│   │RULES-WORK02 │ Apothicaire  │ Core Rules     │    ✓    │   02   │
│   │WINDS-WORK15 │ Alchimiste   │ Windswept Path │    ✓    │   15   │
│   │RULES-WORK03 │ Avocat       │ Core Rules     │         │        │
│   │UPINA-WORK20 │ Archer       │ Uplands        │         │        │
└───┴─────────────┴──────────────┴────────────────┴─────────┴────────┘
```

---

## 🔄 Tri appliqué

**Priorité 1:** Sélectionnés (✓) en premier
**Priorité 2:** Non-sélectionnés après
**Priorité 3:** Alphabétique par Libellé dans chaque groupe

**Résultat:** Sélectionnés visibles immédiatement, faciles à trouver

---

## 💾 Format de stockage interne

```
TempCareersData (TStringList):
  "0|Agitateur|RULES-WORK01|Core Rules Book|01"
  "0|Apothicaire|RULES-WORK02|Core Rules Book|02"
  "0|Alchimiste|WINDS-WORK15|Windswept Path|15"
  "1|Avocat|RULES-WORK03|Core Rules Book|"
  "1|Archer|UPINA-WORK20|Uplands|"
```

Format: `"Selected|Libelle|Code|Livre|Chance"`
- Selected = "0" (sélectionné) ou "1" (non-sélectionné)

---

## 🎯 Colonnes détaillées

### Col 0 - Vide
- ✅ Réservée pour futures interactions
- ✅ Pourrait accueillir checkbox interactive (Phase 3)
- ✅ Ou boutons d'action

### Col 1 - Code
- ✅ Identifiant unique du métier
- ✅ Format: LIVRE-WORKXX (ex: RULES-WORK01)
- ✅ Non éditable (référence absolue)

### Col 2 - Libellé
- ✅ Nom du métier traduit
- ✅ Exemple: "Agitateur", "Alchimiste"
- ✅ Éditable en Phase 3

### Col 3 - Livre
- ✅ Nom du livre source traduit
- ✅ Exemple: "Core Rules Book", "Windswept Path"
- ✅ Non éditable (déterminé par le code)

### Col 4 - Sélectionné
- ✅ "✓" si le métier est assigné à la race
- ✅ Vide sinon
- ✅ Sera interactive en Phase 3 (toggle)

### Col 5 - Chance
- ✅ Valeur du métier (numérique)
- ✅ Exemple: "01", "02", "15"
- ✅ Correspond à la "chance" dans Warhammer
- ✅ Sera éditable en Phase 3

---

## 📝 Cas de test

### Test 1: Sélectionnés
```
✓ Agitateur       (01)
✓ Apothicaire     (02)
✓ Alchimiste      (15)
  Avocat          ( )
  Archer          ( )
```

### Test 2: Plusieurs livres
```
✓ Agitateur       Core Rules      (01)
✓ Alchimiste      Windswept       (15)
  Archer          Uplands         ( )
✓ Artisan         Core Rules      (03)
```

### Test 3: Ordre alphabétique
```
Sélectionnés (triés alphabet):
  ✓ Agitateur
  ✓ Alchimiste
  ✓ Apothicaire
Non-sélectionnés (triés alphabet):
  Avocat
  Archer
```

---

## 🚀 Phase 3 - Interactions futures

**Col 0:** 
- [ ] Double-clic → Toggle sélection
- [ ] Ou checkbox

**Col 4:**
- [ ] Double-clic → Toggle sélection
- [ ] Ou drag/drop

**Col 5:**
- [ ] Double-clic → Éditer valeur
- [ ] Spin box

---

## ✅ Affichage correct

**Conditions:**
- ✅ Col 0 vide
- ✅ Col 1 = Code complet (RULES-WORK01, pas tronqué)
- ✅ Col 2 = Libellé
- ✅ Col 3 = Livre traduit
- ✅ Col 4 = "✓" ou vide
- ✅ Col 5 = Chance/Valeur
- ✅ Tri sélectionnés en premier
- ✅ Alphabétique par Libellé

---

**6 colonnes, simple et efficace!** ✨
