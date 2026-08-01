# 📋 CONTEXT.md - WinLivre v2.0.0

**Last Update:** 2026-08-01 07:15  
**Status:** ✅ **Phase 1 COMPLETE - Phase 2 TODO**

---

## 🎯 Quick Summary

**WinLivre v2.0.0** est une application Lazarus/Free Pascal pour gérer les données Warhammer Fantasy V4 (caractères, races, carrières, talents, etc.) depuis le fichier XML `BOOK_RULESBOOK_FRANCAIS.Xml`.

**Current Goal:** Phase 2 - Implement ÉDITION (Add/Modify/Delete)

---

## ✅ Phase 1: AFFICHAGE (COMPLETE)

### What Works
- ✅ **UI Layout** — Panneau gauche (TreeView) + Panneau droit (Formulaire)
- ✅ **Button "Charger XML..."** — Ouvre un fichier XML (visible et fonctionnel)
- ✅ **TreeView Structure** — Hiérarchie claire:
  ```
  BOOK_RULESBOOK_FRANCAIS.Xml (racine = nom du fichier)
  ├─ Races (5 items)
  │  ├─ RULES-RACE_HUM
  │  ├─ RULES-RACE_HALF
  │  ├─ RULES-RACE_DWAR
  │  ├─ RULES-RACE_HELF
  │  └─ RULES-RACE_WELF
  └─ Carrières (64 items)
     ├─ RULES-WORK01
     └─ ... (64 carrières)
  ```
- ✅ **Race Display** — Clic sur une race → Affiche Code, Libelle, Description (READ-ONLY)
- ✅ **Career Loading** — Les 64 carrières sont chargées (pas d'affichage détails pour l'instant)
- ✅ **Clean Layout** — Plus de lignes vides, DefaultItemHeight = 18px (compact)

### Key Fixes Applied
1. **Layout Issue (PanelTopButtons)** — TreeView recouvrait le bouton → Créé PanelTopButtons avec `Align = alTop`
2. **TabOrder Error** — TBCButton ne supporte pas TabOrder → Supprimé de tous les boutons
3. **Cache Issue** — Lazarus cachait une ancienne version → Nettoyé lib/ folder
4. **Empty Branches** — Supprimé les branches vides (Talents, Compétences, Armes, Armures)
5. **Code Validation** — Ajouté vérification pour ignorer les éléments XML sans Code valide

---

## ➡️ Phase 2: ÉDITION (TODO)

### Tasks to Implement

#### 1. **AJOUTER une race/carrière**
```pascal
procedure MenuItemAjouterClick(Sender: TObject);
// TODO:
// - Nettoyer le formulaire
// - Activer l'édition (ReadOnly := False)
// - Générer un Code unique (ex: CUSTOM_RACE_01)
// - Setter focus sur EditFormCode
// - Mode d'édition: MODE_EDIT := 'NEW'
```

#### 2. **MODIFIER une race/carrière**
```pascal
procedure MenuItemModifierClick(Sender: TObject);
// TODO:
// - Charger les données de l'élément sélectionné
// - Activer l'édition (ReadOnly := False)
// - Mode d'édition: MODE_EDIT := 'MODIFY'
```

#### 3. **SUPPRIMER une race/carrière**
```pascal
procedure MenuItemSupprimerClick(Sender: TObject);
// TODO:
// - Confirmation: ShowMessageDialog('Êtes-vous sûr?')
// - Retirer du TreeView
// - Retirer de RacesDataList
// - Masquer le formulaire
```

#### 4. **VALIDER les changements**
```pascal
procedure ButtonFormValiderClick(Sender: TObject);
// TODO:
// - Si MODE_EDIT = 'NEW': Créer nouvel XMLElement
// - Si MODE_EDIT = 'MODIFY': Mettre à jour XMLElement
// - Ajouter/Mettre à jour RacesDataList
// - Refresh TreeView
// - Masquer le formulaire
// - ShowMessage('✅ Enregistré!')
```

#### 5. **SAUVEGARDER dans XML**
```pascal
procedure SaveXMLFile;
// TODO:
// - Écrire les modifications dans BOOK_RULESBOOK_FRANCAIS.Xml
// - Gestion des erreurs (fichier verrouillé, permissions, etc.)
// - Backup optionnel du fichier original
```

---

## 📁 Project Structure

```
C:\Users\arnau\Documents\Lazarus Project\Warhammer\
├─ winlivre.pas (385+ lines, unit principal)
├─ winlivre.lfm (form layout avec PanelTopButtons)
├─ DATABASE/RULESBOOK/
│  ├─ BOOK_RULESBOOK_FRANCAIS.Xml (source data)
│  └─ (autres fichiers XML pour futures phases)
└─ lib/ (cache Lazarus, peut être supprimé)
```

---

## 🏗️ Architecture Notes

### Classes & Types
```pascal
TRaceData = record
  Code: String;
  Description: String;
  Explanation: String;
end;

TRaceDataMap = specialize TFPGMap<String, PRaceData>;
  // Stocke les données des races chargées
  // Clé = Code (ex: RULES-RACE_HUM)
  // Valeur = Pointeur vers TRaceData

TWinLivres = class(TForm)
  // Classe principale contenant tous les contrôles
```

### Key Variables
```pascal
XMLDoc: TXMLDocument;              // Document XML chargé
RacesDataList: TRaceDataMap;       // Map des races
NodeSelectionnee: TTreeNode;       // Nœud actuellement sélectionné
TypeNodeSelectionnee: String;      // 'CHAPITRE' ou 'DONNEE'
CodeDonneeSelectionnee: String;    // Code de l'élément sélectionné
```

### TreeView Node Data Convention
```
Node.Data = 0  →  Chapitre (branche)
Node.Data = 1  →  Donnée (feuille)
```

---

## 🔧 Technical Details

### XML Sections Used
- `<DATA_SPECIE>` — Contains `<Specie id="...">` elements (races)
- `<DATA_CAREER>` — Contains `<Career id="...">` elements (careers)
- Not yet implemented:
  - `<DATA_TALENT>` — Talents
  - `<DATA_SKILL>` — Compétences
  - `<DATA_WEAPON>` — Armes
  - `<DATA_ARMOR>` — Armures

### UI Behavior
- **Read-Only Phase 1:** All edit fields are `ReadOnly := True`
- **Phase 2:** Will toggle `ReadOnly := False` when editing
- **Buttons State:**
  - Valider / Supprimer: Initially show "Fonctionnalité d'édition non disponible en phase affichage"
  - Will be activated in Phase 2

### Lazarus Specifics
- **Compiler:** Free Pascal with Lazarus IDE
- **Platform:** Windows 10/11 (tested)
- **DPI Scaling:** DesignTimePPI = 120
- **Components Used:**
  - TPanel, TLabel, TEdit, TMemo, TTreeView (standard)
  - TBCButton (custom component from BCButton package)
  - TSplitter (for resizable panel)

---

## 🚀 Next Session TODO

### Immediate (Start of Session)
1. **git pull** to sync latest changes
2. **Compile in Lazarus:** Ctrl+F9
3. **Test:** Load XML and verify Phase 1 still works
4. **Load CONTEXT.md** for context

### Phase 2 Implementation Plan
1. Add global variable `MODE_EDIT: String` to track edit mode
2. Implement `MenuItemAjouterClick` — New race/career dialog
3. Implement `MenuItemModifierClick` — Edit existing entry
4. Implement `MenuItemSupprimerClick` — Delete with confirmation
5. Implement `ButtonFormValiderClick` — Save to XML memory + TreeView
6. Implement `SaveXMLFile` — Persist to disk
7. Test all edit operations
8. Commit Phase 2 complete

### Optional Enhancements
- Add undo/redo for edits
- Add search/filter for TreeView
- Load more data types (Talents, Skills, Weapons, Armor)
- Add validation rules for Code field
- Export/Import features

---

## 🎨 Phase 2.5: UI/UX Enhancements (TODO)

### 1. **Menu pour Ouvrir les Livres Rapidement**
```pascal
// TODO:
// - Créer un Menu "Fichiers récents" ou "Livres disponibles"
// - Scanner la folder DATABASE/RULESBOOK/ pour les fichiers .xml
// - Afficher une liste cliquable: BOOK_RULESBOOK_FRANCAIS.Xml, etc.
// - Click → Charge le livre directement (sans dialog)
// - Bonus: Mémoriser le dernier livre ouvert
```

### 2. **TreeView avec Noms "Pretty" au lieu de Codes**
```pascal
// Problem: RULES-RACE_HUM est technique et peu lisible
// Solution: Afficher le nom traduit (ex: "Humain") au lieu du code

// TODO:
// - Créer une map: Code → NomAffichage
//   Ex: RULES-RACE_HUM → "Humain"
// - Charger les noms depuis XML (section DATA_LABEL)
// - Afficher le nom dans TreeView
// - Stocker le Code en cache (Node.Data ou custom property)
// - Quand click sur "Humain" → Récupère le Code "RULES-RACE_HUM" en cache

// Implementation Hint:
// TreeNode.Text = "Humain (lisible)"
// TreeNode.Data = Pointer(PtrInt(Code)) ou créer TCacheData record
```

### 3. **Example: XML Labels (DATA_LABEL)**
```xml
<DATA_LABEL>
  <Text name="RULES-SPECIE_HUMAN">"Humain"</Text>
  <Text name="RULES-SPECIE_ELF">"Elfe"</Text>
  <Text name="RULES-SPECIE_DWARF">"Nain"</Text>
  ...
  <Text name="RULES-WORK01">"Acrobate"</Text>
  <Text name="RULES-WORK02">"Alchimiste"</Text>
  ...
</DATA_LABEL>
```

---

### Optional Enhancements
- Add undo/redo for edits
- Add search/filter for TreeView
- Load more data types (Talents, Skills, Weapons, Armor)
- Add validation rules for Code field
- Export/Import features

---

## 📝 Session History

### 2026-08-01 Session 1 (Phase 1)
- **Issues Fixed:**
  - Layout: PanelTopButtons (alTop) prevents TreeView from covering button
  - TabOrder: Removed from all TBCButton components (custom component limitation)
  - Cache: Lazarus was holding old .lfm version
  - Empty branches: Removed static empty nodes
  - Code validation: Added check to skip empty XML elements

- **Completed:**
  - TreeView structure with filename as root
  - Load 5 races (DATA_SPECIE)
  - Load 64 careers (DATA_CAREER)
  - Display race details (Code, Libelle, Description)
  - Clean compact UI (DefaultItemHeight = 18px)

- **Files Modified:**
  - winlivre.pas — ChargerXMLFile() refactored
  - winlivre.lfm — PanelTopButtons added, DefaultItemHeight reduced

---

## 💾 Git Notes

**Repository:** https://github.com/NonoReading/Warhammer.git (private)

**Commits:**
- Phase 1 complete - TreeView structure + Race/Career loading

**Next Commit:** Phase 2 - Edit (Add/Modify/Delete) implementation

---

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| XML not loading | Check file path, ensure `BOOK_RULESBOOK_FRANCAIS.Xml` exists |
| TreeView empty | Verify XML structure, check `ReadXMLFile()` result |
| Buttons not visible | Ensure `PanelTopButtons` has `Align = alTop` |
| Cache issues | Delete `lib/` folder, rebuild project |
| TBCButton errors | Remove all `TabOrder` properties from TBCButton |

---

**Status:** Ready for Phase 2 implementation! 🚀
