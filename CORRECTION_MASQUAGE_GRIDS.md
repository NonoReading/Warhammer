# 🔧 Correction: Masquage cohérent des grids

## ✅ Problème résolu

**Problème:** Quand tu navigues vers un élément non géré (Attribute, etc.), les grids des compétences/métiers/talents restaient visibles.

**Cause:** `TreeViewLivreChange()` n'appelait pas `MasquerAfficherElements('')` pour les cas non gérés.

**Solution:** Ajouter `MasquerAfficherElements('')` partout où on n'affiche pas de grid!

---

## 📋 Cas par cas

### ✅ Cas gérés (avec grids)

**Cas 3:** Branche "Compétences de race"
```pascal
AfficherSkillsForRace(RaceCodeFound);
// Cette procédure appelle:
// → MasquerAfficherElements('COMPETENCE');
```

**Cas 5:** Branche "Talents"
```pascal
AfficherTalentsForRace();
// Cette procédure appelle:
// → MasquerAfficherElements('TALENT');
```

**Cas 9:** Branche "Carrières de race"
```pascal
AfficherCareersForRace(RaceCodeFound);
// Cette procédure appelle:
// → MasquerAfficherElements('CARRIERE');
```

### ❌ Cas non gérés (sans grids)

**Cas 0:** Chapitre (Races, Attributes, Careers, etc.)
```pascal
MasquerAfficherElements('');  // ← Masquer tous les grids
MasquerForm();
```

**Cas 1:** Race
```pascal
MasquerAfficherElements('');  // ← Masquer tous les grids
AfficherDonneeRace(CurrentRaceCode);
```

**Cas 2:** Attribut
```pascal
MasquerAfficherElements('');  // ← Masquer tous les grids
AfficherDonneeAttribut(CurrentAttributeValue);
```

**Cas 4:** Item "Compétence"
```pascal
MasquerAfficherElements('');  // ← Masquer tous les grids
MasquerForm();
```

**Cas 13:** Item "Carrière"
```pascal
MasquerAfficherElements('');  // ← Masquer tous les grids
MasquerForm();
```

**Cas else:** Autres cas
```pascal
MasquerAfficherElements('');  // ← Masquer tous les grids
MasquerForm();
```

---

## 🎯 Flux de navigation

```
Utilisateur clique TreeView
    ↓
TreeViewLivreChange() détermine Node.Data
    ↓
    ├─ Cas 3/5/9 (Compétences/Talents/Métiers)
    │  ↓
    │  Appelle AfficherSkillsForRace() / AfficherTalentsForRace() / AfficherCareersForRace()
    │  ↓
    │  MasquerAfficherElements('COMPETENCE'/'TALENT'/'CARRIERE')
    │  ↓
    │  ✓ Affiche le grid, masque les autres
    │
    └─ Cas 0/1/2/4/13/else (Tous les autres)
       ↓
       MasquerAfficherElements('')
       ↓
       ✓ Masque TOUS les grids
       ↓
       Affiche autre contenu (Attribute, Race, etc.)
```

---

## ✨ Résultat

### Navigation complète

1. **Clique Attribute** → Grids masqués ✓
2. **Clique Compétences** → Grid compétences visible ✓, autres masqués ✓
3. **Clique Attribute à nouveau** → Grids masqués ✓
4. **Clique Talents** → Grid talents visible ✓, autres masqués ✓
5. **Clique Métiers** → Grid métiers visible ✓, autres masqués ✓

Aucun reste d'affichage antérieur! 🎉

---

## 🔑 Principes

### Règle 1: Cohérence
```
Si tu gères l'élément avec un grid
  → La procédure Afficher...() appelle MasquerAfficherElements(Type)
Si tu NE gères pas l'élément
  → TreeViewLivreChange() appelle MasquerAfficherElements('')
```

### Règle 2: Une seule source
```
MasquerAfficherElements() = point unique de contrôle
  → Pas de Visible := True/False dispersés
  → Maintenance facile
```

---

## 📁 Fichier modifié

**winlivre.pas:** TreeViewLivreChange()
- ✅ Cas 0: Ajouter MasquerAfficherElements('')
- ✅ Cas 1: Ajouter MasquerAfficherElements('')
- ✅ Cas 2: Ajouter MasquerAfficherElements('')
- ✅ Cas 3: Ajouter MasquerAfficherElements('') si pas de parent
- ✅ Cas 4: Ajouter MasquerAfficherElements('')
- ✅ Cas 5: Pas de changement (procédure gère)
- ✅ Cas 9: Ajouter MasquerAfficherElements('') si pas de parent
- ✅ Cas 13: Ajouter MasquerAfficherElements('')
- ✅ Else: Ajouter MasquerAfficherElements('')

---

## 🚀 Maintenance future

**Quand tu ajoutes un nouvel élément avec grid:**

1. Crée la procédure `AfficherXxx()` qui appelle `MasquerAfficherElements('XXX')`
2. Ajoute le cas dans TreeViewLivreChange()
3. Appelle `AfficherXxx()`
4. Zéro duplication! ✨

**Exemple:**
```pascal
// Dans AfficherDonneeRace(), si tu veux afficher un grid:
case ElementType of
  'RACE_ATTRIBUTES':
    begin
      MasquerAfficherElements('RACE_ATTRIBUTES');
      // ... afficher grid ...
    end;
end;

// Dans TreeViewLivreChange():
case PtrInt(Node.Data) of
  10: AfficherDonneeRace(CurrentRaceCode);  // Fait déjà le masquage!
end;
```

---

**Navigation fluide et cohérente!** 👍 ✨
