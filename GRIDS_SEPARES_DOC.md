# 🎯 Grids séparés: Compétences et Métiers

## ✨ Nouvelle architecture

**AVANT:** Grids partagés (trop dangereux et complexe)
```
StringGridSkills → Compétences OU Métiers (alternance)
```

**APRÈS:** Grids séparés et clairs
```
StringGridSkills  → Compétences uniquement
StringGridCareers → Métiers uniquement
```

---

## 📋 Modifications appliquées

### 1. Ajout dans `.lfm` (Interface)

**Créé:** `StringGridCareers` après `StringGridSkills`

```xml
<object StringGridCareers: TStringGrid>
  Left = 20
  Height = 500
  Top = 45
  Width = 900
  Columns = [
    Code (100px),
    Libellé (200px),
    Livre (200px),
    Sélectionné (80px),
    Chance (80px)
  ]
  TabOrder = 2
  Visible = False
</object>
```

✅ Même positionnement que StringGridSkills (superposé)
✅ Même hauteur et largeur
✅ 5 colonnes dédiées aux métiers

---

### 2. Déclaration dans `.pas` (Code)

**Ligne 90 (classe TWinLivres):**
```pascal
StringGridSkills: TStringGrid;
StringGridCareers: TStringGrid;  // ← NOUVEAU
```

---

### 3. Modifications procédures

#### A. `AfficherSkillsForRace()` (Compétences)

**Au début:** Masque StringGridCareers
```pascal
StringGridSkills.Visible := False;
// ... remplissage StringGridSkills ...
StringGridCareers.Visible := False;  // ← NOUVEAU: masquer l'autre grid
StringGridSkills.Visible := True;
```

**Condition else:** Masque aussi StringGridCareers
```pascal
else
begin
  LabelFormSkills.Visible := False;
  StringGridCareers.Visible := False;  // ← NOUVEAU
  StringGridSkills.Visible := False;
end;
```

#### B. `AfficherCareersForRace()` (Métiers)

**Au début:** Masque StringGridSkills
```pascal
LabelFormSkills.Visible := False;
StringGridSkills.Visible := False;  // ← Masquer l'autre grid
// ... remplissage StringGridCareers ...
```

**À la fin:** Affiche StringGridCareers
```pascal
AdjustGridColumnsWidth(StringGridCareers, ...);  // ← NOUVEAU: bon grid
StringGridCareers.Visible := True;
```

---

## 🎨 Comportement final

### Quand utilisateur clique "Compétences de race"

```
1. TreeViewLivreChange() → Cas 3
2. Appelle AfficherSkillsForRace()
3. Masque StringGridCareers
4. Affiche StringGridSkills (compétences)
5. Utilisateur voit: Compétences uniquement
```

### Quand utilisateur clique "Carrières de race"

```
1. TreeViewLivreChange() → Cas 9
2. Appelle AfficherCareersForRace()
3. Masque StringGridSkills
4. Affiche StringGridCareers (métiers)
5. Utilisateur voit: Métiers uniquement
```

---

## 📊 Grilles affichées

### StringGridSkills (Compétences)

```
Code │ Libellé      │ Spécialisation      │ Sélectionné │ ...
─────┼──────────────┼─────────────────────┼─────────────┼─────
     │ Athlétisme   │ (vide)              │      ✓      │
     │ Charisme     │ Leadership          │      ✓      │
     │ Armes        │ Épée longue         │             │
```

### StringGridCareers (Métiers)

```
Code         │ Libellé      │ Livre          │ Sélectionné │ Chance
─────────────┼──────────────┼────────────────┼─────────────┼────────
RULES-WORK01 │ Agitateur    │ Core Rules     │      ✓      │   01
RULES-WORK02 │ Apothicaire  │ Core Rules     │      ✓      │   02
WINDS-WORK15 │ Alchimiste   │ Windswept Path │      ✓      │   15
```

---

## ✅ Avantages architecture

✨ **Clair:** Chaque grid a sa fonction
✨ **Safe:** Pas de risque de mélange données
✨ **Maintenable:** Deux procédures dédiées
✨ **Extensible:** Facile d'ajouter plus de grids si besoin
✨ **Sûr:** Masquage automatique de l'autre grid

---

## 🔄 Points clés

### Grid properties (identiques)
```
Position:   Left=20, Top=45
Dimensions: Width=900, Height=500
TabOrder:   1 et 2 (ordre d'accès)
Visible:    False au départ
Font:       clBlack, Segoe UI, -14
```

### Masquage automatique
```
StringGridSkills.Visible := False;   // Appel de AfficherCareersForRace()
StringGridCareers.Visible := False;  // Appel de AfficherSkillsForRace()
```

### AdjustGridColumnsWidth() adapté
```
AfficherSkillsForRace()  → AdjustGridColumnsWidth(StringGridSkills, ...)
AfficherCareersForRace() → AdjustGridColumnsWidth(StringGridCareers, ...)
```

---

## 🚀 Prochaines étapes

### Immédiat
1. Compile et teste
2. Vérifier masquage fonctionnel
3. Vérifier affichage compétences/métiers

### Phase 2 (Édition)
- StringGridCareers prêt pour édition interactive
- Même pattern que compétences

---

## 📁 Fichiers modifiés

### winlivre.lfm
- ✅ StringGridCareers ajouté (5 colonnes)
- ✅ Positionnement identique à StringGridSkills

### winlivre.pas
- ✅ Déclaration StringGridCareers (ligne 91)
- ✅ AfficherSkillsForRace() masque StringGridCareers
- ✅ AfficherCareersForRace() utilise StringGridCareers
- ✅ AdjustGridColumnsWidth() adapté pour chaque grid

---

## 🧪 Test rapide

```
1. Compile le projet
2. Ouvre un XML
3. Clique "Compétences de race"
   → Grille de compétences affichée
   → Grille métiers masquée
4. Clique "Carrières de race"
   → Grille métiers affichée
   → Grille compétences masquée
5. Alterne entre les deux
   → Masquage/affichage fluide
```

---

**Architecture double-grid complétée!** ✨

Grids séparés = plus sûr + plus maintenable + plus évolutif! 🎉
