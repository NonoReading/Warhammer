# 🎯 Fonction centralisée: MasquerAfficherElements()

## ✨ Nouvelle procédure

Crée une **source unique de vérité** pour gérer la visibilité de tous les éléments UI!

---

## 📋 Signature

```pascal
procedure MasquerAfficherElements(ElementType: String);
```

---

## 🎨 Types d'éléments supportés

### `'COMPETENCE'`
Affiche:
- ✅ `LabelFormSkills` 
- ✅ `StringGridSkills`

Masque:
- ❌ `StringGridCareers`
- ❌ `TreeViewTalents`
- ❌ `LabelTalentsRandom`

### `'CARRIERE'` ou `'METIER'`
Affiche:
- ✅ `LabelFormSkills`
- ✅ `StringGridCareers`

Masque:
- ❌ `StringGridSkills`
- ❌ `TreeViewTalents`
- ❌ `LabelTalentsRandom`

### `'TALENT'`
Affiche:
- ✅ `TreeViewTalents`
- ✅ `LabelTalentsRandom`

Masque:
- ❌ `StringGridSkills`
- ❌ `StringGridCareers`

### `''` (vide) ou autre
Masque tout:
- ❌ `LabelFormSkills`
- ❌ `StringGridSkills`
- ❌ `StringGridCareers`
- ❌ `TreeViewTalents`
- ❌ `LabelTalentsRandom`

---

## 💡 Utilisation

### Avant (code dupliqué partout)
```pascal
procedure AfficherSkillsForRace();
begin
  // Masquage manuel - répété dans 3 procédures
  if LabelTalentsRandom <> nil then
    LabelTalentsRandom.Visible := False;
  if TreeViewTalents <> nil then
    TreeViewTalents.Visible := False;
  StringGridCareers.Visible := False;
  // ... code métier ...
  LabelFormSkills.Visible := True;
  StringGridSkills.Visible := True;
end;
```

### Après (une ligne!)
```pascal
procedure AfficherSkillsForRace();
begin
  // Gestion centralisée
  MasquerAfficherElements('COMPETENCE');
  
  // ... code métier ...
end;
```

---

## 📊 Code source

```pascal
procedure TWinLivres.MasquerAfficherElements(ElementType: String);
begin
  // Masquer tous les éléments par défaut
  LabelFormSkills.Visible := False;
  StringGridSkills.Visible := False;
  StringGridCareers.Visible := False;
  if TreeViewTalents <> nil then
    TreeViewTalents.Visible := False;
  if LabelTalentsRandom <> nil then
    LabelTalentsRandom.Visible := False;
  
  // Afficher selon le type d'élément sélectionné
  case ElementType of
    'COMPETENCE':
      begin
        LabelFormSkills.Visible := True;
        StringGridSkills.Visible := True;
      end;
    
    'CARRIERE', 'METIER':
      begin
        LabelFormSkills.Visible := True;
        StringGridCareers.Visible := True;
      end;
    
    'TALENT':
      begin
        if TreeViewTalents <> nil then
          TreeViewTalents.Visible := True;
        if LabelTalentsRandom <> nil then
          LabelTalentsRandom.Visible := True;
      end;
    
    else
      begin
        // RIEN: masquer tous les grids
      end;
  end;
end;
```

---

## 🚀 Intégration appliquée

### AfficherSkillsForRace()
```pascal
procedure TWinLivres.AfficherSkillsForRace(RaceCode: String);
begin
  MasquerAfficherElements('COMPETENCE');  // ← UNE LIGNE!
  
  // ... reste du code ...
end;
```

### AfficherTalentsForRace()
```pascal
procedure TWinLivres.AfficherTalentsForRace();
begin
  MasquerAfficherElements('TALENT');  // ← UNE LIGNE!
  
  // ... reste du code ...
end;
```

### AfficherCareersForRace()
```pascal
procedure TWinLivres.AfficherCareersForRace(RaceCode: String);
begin
  MasquerAfficherElements('CARRIERE');  // ← UNE LIGNE!
  
  // ... reste du code ...
end;
```

---

## ✅ Avantages

### 1. DRY (Don't Repeat Yourself)
✅ Pas de duplication de code
✅ Une source unique de vérité
✅ Facile à auditer

### 2. Maintenabilité
✅ Quand tu ajoutes un nouvel élément (ex: Label, Grid), une seule place à modifier
✅ Pas de risque d'oublier de masquer/afficher quelque chose
✅ Coherence garantie

### 3. Évolutivité
✅ Ajoute facilement de nouveaux types: `'ATTRIBUT'`, `'RACE'`, etc.
✅ Réutilise partout dans le code
✅ Scalable quand le UI grandit

### 4. Clarté
✅ Le code est plus lisible
✅ Intention claire avec `MasquerAfficherElements('COMPETENCE')`
✅ Plus facile à debugger

---

## 🔄 Cas d'usage

### Clic sur une branche dans TreeView
```pascal
procedure TreeViewLivreChange(...);
begin
  case TypeNode of
    3: MasquerAfficherElements('COMPETENCE');  // Compétences
    9: MasquerAfficherElements('CARRIERE');    // Métiers
    5: MasquerAfficherElements('TALENT');      // Talents
    else
      MasquerAfficherElements('');             // Rien
  end;
  
  // Afficher le contenu
  Afficher...();
end;
```

### Ajout d'un nouveau type (ex: Attributs)
```pascal
// 1. Ajouter dans MasquerAfficherElements
case ElementType of
  'ATTRIBUT':
    begin
      LabelFormAttr.Visible := True;
      GridAttributs.Visible := True;
    end;
end;

// 2. Utiliser partout
MasquerAfficherElements('ATTRIBUT');
```

---

## 🎯 Points clés

### Pour ajouter un nouvel élément visuel
1. Crée le contrôle dans le `.lfm`
2. Déclare-le dans la classe
3. Ajoute une ligne dans `MasquerAfficherElements()`
4. Utilise dans toutes les procédures Afficher...

### Pattern maintenant standard
```
[Clic sur TreeView]
    ↓
Détermine le type de donnée
    ↓
MasquerAfficherElements(Type)  ← Gestion centralisée!
    ↓
Afficher...() avec données correctes
```

---

## 🧪 Test

```
1. Compile
2. Clique "Compétences" → Grid compétences ✓, autres masqués ✓
3. Clique "Talents" → TreeView talents ✓, autres masqués ✓
4. Clique "Métiers" → Grid métiers ✓, autres masqués ✓
5. Alterne → Transitions fluides ✓
```

---

## 📁 Fichier modifié

**winlivre.pas:**
- ✅ Procédure `MasquerAfficherElements()` ajoutée (ligne ~1210)
- ✅ Déclaration dans la classe (ligne ~157)
- ✅ `AfficherSkillsForRace()` simplifiée (utilise MasquerAfficherElements)
- ✅ `AfficherTalentsForRace()` simplifiée (utilise MasquerAfficherElements)
- ✅ `AfficherCareersForRace()` simplifiée (utilise MasquerAfficherElements)

---

## 🎉 Résultat

**Avant:** 30+ lignes de masquage/affichage dispersées
**Après:** 1 procédure, 1 ligne d'appel, zéro duplication!

Code plus propre = plus facile à maintenir = moins de bugs! ✨
