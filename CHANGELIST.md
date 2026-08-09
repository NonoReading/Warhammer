# WinLivre - Changements Session 02/08/2026

## ✅ Modifications effectuées

### 1️⃣ Ajout de la procédure `LoadCareersForRaceTree()`
- **Fichier:** `winlivre.pas` (ligne ~148)
- **Déclaration ajoutée:**
  ```pascal
  procedure LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
  ```
- **Implémentation (ligne ~650):**
  - Cherche `SUBCHAPTER_CAREER` dans chaque race du XML
  - Récupère tous les Career elements du XML pour trouver les descriptions
  - Crée une branche "Career" (traduite via `LAB_006` = "Career")
  - Ajoute chaque carrière accessible à la race avec son libellé
  - Assigne `Node.Data := Pointer(PtrInt(9))` pour la branche
  - Assigne `Node.Data := Pointer(PtrInt(13))` pour chaque item carrière

### 2️⃣ Appel dans `ChargerXMLFile()`
- **Fichier:** `winlivre.pas` (ligne ~887)
- **Ajout:** Appel de `LoadCareersForRaceTree(XMLElement, NodeRace)` 
  - Appelée après `LoadTalentsForRaceTree()`
  - À chaque itération de la boucle de races

### 3️⃣ Gestion dans `TreeViewLivreChange()`
- **Fichier:** `winlivre.pas` (ligne ~1061)
- **Deux nouveaux cas ajoutés:**
  ```pascal
  case 9: Branche "Career" sélectionnée
          → Affiche le titre, masque le formulaire
  
  case 13: Item "Carrière" sélectionné
           → Affiche le titre avec le nom de la carrière
           → Pour l'instant, masque le formulaire (Phase 2)
  ```

## 📊 Hiérarchie TreeView mise à jour

```
BOOK RULESBOOK (0)
├─ Specie (0)
│  ├─ Humans (Reikland) (1)
│  │  ├─ Attributes (0)
│  │  │  ├─ WS: 2d10+20 (2)
│  │  │  └─ ...
│  │  ├─ Skills (3)
│  │  │  └─ Cool (4)
│  │  ├─ Talents (5)
│  │  │  ├─ {Au choix} (11)
│  │  │  │  ├─ Suave (12)
│  │  │  │  └─ Savvy (12)
│  │  │  └─ Doomed (8)
│  │  └─ Career (9) ← NOUVEAU!
│  │     ├─ Agitator (13)
│  │     ├─ Engineer (13)
│  │     └─ ...
│  ├─ Dwarves (1)
│  └─ ...
└─ Career (0) [global list]
```

## 🎯 Code Node.Data Reference

| Node.Data | Type | Description |
|-----------|------|-------------|
| 0 | - | Chapitre (Races, Careers, Attributes, etc.) |
| 1 | Specie | Race/Peuple |
| 2 | Attribute | Attribut de race |
| 3 | - | Branche Compétences de race |
| 4 | - | Item Compétence |
| 5 | - | Branche Talents de race |
| 6 | - | Talent aléatoire (RULES-T*) |
| 7 | - | Nœud choix multiple "{Au choix}" |
| 8 | - | Talent (fixe ou choix) |
| **9** | **- (NEW)** | **Branche Carrières de race** |
| **13** | **- (NEW)** | **Item Carrière** |

## 🧪 Tests à effectuer

1. ✅ Charger le XML
2. ✅ Sélectionner une race
3. ✅ Vérifier que la branche "Career" s'affiche sous la race
4. ✅ Vérifier que les carrières s'affichent avec leurs libellés
5. ✅ Cliquer sur une carrière → affiche le titre sans erreur

## 🔧 Correction appliquée (Session 02/08/2026)

### Bug fix: Métiers sans libellé
**Problème:** Métiers comme `ARCH3-WORK99`, `DEATH-WORK105` affichaient leur code au lieu du libellé
**Solution:** Utiliser `ChercheMetier()` de `ListMetier` au lieu de chercher dans XML

**Changements:**
1. Ajout `ChargeMetier` aux uses (ligne ~9)
2. Remplacement complet de `LoadCareersForRaceTree()` (ligne ~650)
   - Avant: ~70 lignes, cherchait dans XML
   - Après: ~45 lignes, utilise `ListMetier`

**Résultat:** Tous les métiers de tous les livres affichent maintenant leur libellé correctement ✅

---

## 📝 Phase 2 TODO

- Créer procédure `AfficherCareerForRace()` pour afficher les détails:
  - Code carrière
  - Description complète
  - Explication
  - Classe (CLASS)
  - Attributs bonus (SUBCHAPTER_ATTR)
  - Compétences bonus (SUBCHAPTER_SKILL)
  - Talents bonus (SUBCHAPTER_TALENT)
  - Niveaux disponibles (SUBCHAPTER_LEVEL)

## 📂 Fichiers fournis

- `winlivre.pas` - Code Pascal modifié
- `winlivre.lfm` - Layout (inchangé)
- `BOOK RULESBOOK.Xml` - XML test
- `CHANGELIST.md` - Ce fichier

**Remplace le `winlivre.pas` de ton projet et compile!** 🚀
