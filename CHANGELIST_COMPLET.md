# WinLivre - Changements Session 02/08/2026

## 📋 Résumé des modifications

✅ Ajout branche **Career** pour chaque race
✅ Affichage du **libellé** de chaque carrière (via `ListMetier`)
✅ Affichage du **nom du livre** en parenthèses (via `ListLivre`)
✅ Gestion des carrières de **tous les livres** (RULES, ARCH3, DEATH, etc.)

---

## 🔧 Changements détaillés

### **Changement 1: Uses** (ligne ~9)

**Avant:**
```pascal
uses ... ChargeCompetence, ChargeTalent, UnitCalcul, Grids ...
```

**Après:**
```pascal
uses ... ChargeCompetence, ChargeTalent, ChargeMetier, ChargeLivre, UnitCalcul, Grids ...
```

**Raison:** Accès à `ListMetier` et `ListLivre` pour chercher libellés et noms

---

### **Changement 2: Déclaration de procédure** (ligne ~148)

**Ajout:**
```pascal
procedure LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
```

---

### **Changement 3: Implémentation de LoadCareersForRaceTree()** (ligne ~650)

**Procédure complète (~60 lignes):**
```pascal
procedure TWinLivres.LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
var
  CareerChapter: TDOMNode;
  CareerElements: TDOMNodeList;
  I: Integer;
  CareerCode, CareerDesc, DisplayText: String;
  NodeCareers, NodeCareer: TTreeNode;
  CareerNode: TDOMNode;
  Metier: StructureMetier;
  Livre: StructureLivre;
begin
  // 1. Chercher SUBCHAPTER_CAREER
  CareerChapter := RaceElement.FindNode('SUBCHAPTER_CAREER');
  if CareerChapter = nil then Exit;
  
  // 2. Créer branche "Career"
  NodeCareers := TreeViewLivre.Items.AddChild(RaceNode, GetTexteLibelle('LAB_006'));
  NodeCareers.Data := Pointer(PtrInt(9));  // 9 = careers chapter
  
  // 3. Charger les carrières
  CareerElements := CareerChapter.ChildNodes;
  
  if CareerElements.Count > 0 then
  begin
    for I := 0 to CareerElements.Count - 1 do
    begin
      CareerNode := CareerElements[I];
      if CareerNode.NodeName = 'Career' then
      begin
        CareerCode := TDOMElement(CareerNode).GetAttribute('name');
        if CareerCode = '' then Continue;
        
        // Chercher métier dans ListMetier
        Metier := ChercheMetier(CareerCode);
        
        if Metier.CodeMetier <> '' then
        begin
          CareerDesc := Metier.Libelle;
          
          // Chercher livre via ChercheLivre
          Livre := ChercheLivre(Metier.Livre);
          
          // Format: "Nom Métier (Nom Livre)"
          if Livre.CodeLivre <> '' then
            DisplayText := CareerDesc + ' (' + Livre.Libelle + ')'
          else
            DisplayText := CareerDesc + ' (' + Metier.Livre + ')';  // Fallback
        end
        else
        begin
          CareerDesc := CareerCode;
          DisplayText := CareerDesc;
        end;
        
        // Ajouter au TreeView
        NodeCareer := TreeViewLivre.Items.AddChild(NodeCareers, DisplayText);
        NodeCareer.Data := Pointer(PtrInt(13));  // 13 = career item
      end;
    end;
  end;
end;
```

**Points clés:**
- Récupère chaque `<Career name="...">` du XML
- Cherche le métier dans `ListMetier` via `ChercheMetier()`
- Récupère le libellé: `Metier.Libelle`
- Cherche le livre dans `ListLivre` via `ChercheLivre(Metier.Livre)`
- Affiche: "Libellé (Nom du Livre)"
- Fallback intelligent si données manquantes

---

### **Changement 4: Appel dans ChargerXMLFile()** (ligne ~887)

**Avant:**
```pascal
LoadTalentsForRaceTree(XMLElement, NodeRace);
end;  // Fin boucle races
```

**Après:**
```pascal
LoadTalentsForRaceTree(XMLElement, NodeRace);
LoadCareersForRaceTree(XMLElement, NodeRace);  // ← NOUVEAU!
end;  // Fin boucle races
```

---

### **Changement 5: Gestion dans TreeViewLivreChange()** (ligne ~1061)

**Deux nouveaux cas ajoutés au switch:**
```pascal
9: begin
     // Branche "Career" sélectionnée
     TypeNodeSelectionnee := 'CHAPITRE';
     LabelFormTitle.Caption := GetTexteLibelle('LAB_006');
     MasquerForm();
   end;
13: begin
     // Item "Career" sélectionné
     TypeNodeSelectionnee := 'CARRIERE';
     LabelFormTitle.Caption := Node.Text;
     MasquerForm();
    end;
```

---

## 📊 Node.Data Reference complète

| Node.Data | Type | Description |
|-----------|------|-------------|
| 0 | - | Chapitre (Races, Careers globales, etc.) |
| 1 | Specie | Race/Peuple |
| 2 | Attribute | Attribut de race |
| 3 | - | Branche Compétences de race |
| 4 | - | Item Compétence |
| 5 | - | Branche Talents de race |
| 6 | - | Talent aléatoire (RULES-T*) |
| 7 | - | Nœud choix multiple "{Au choix}" |
| 8 | - | Talent (fixe ou choix) |
| **9** | **- NEW** | **Branche Carrières de race** |
| **13** | **- NEW** | **Item Carrière** |

---

## 🎯 Résultat final - Hiérarchie TreeView

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
│  │  └─ Career (9) ✨ NOUVEAU!
│  │     ├─ Agitator (Core Rules Book) (13)
│  │     ├─ Engineer (Core Rules Book) (13)
│  │     ├─ Lawyer (Core Rules Book) (13)
│  │     ├─ Pit Fighter (Archives 3) (13)
│  │     ├─ Rogue Guard (Archives 3) (13)
│  │     ├─ Cursed Wanderer (Death) (13)
│  │     └─ Enemy Agent (Enemy) (13)
│  ├─ Dwarves (1)
│  └─ ...
└─ Career (0) [global list]
```

---

## 🧪 Test

1. **Remplace** `winlivre.pas`
2. **Compile** (`Ctrl+F9`)
3. **Ouvre** XML
4. **Sélectionne** race
5. **Expande** "Career"
6. ✅ Voir: **"Nom Métier (Nom Livre)"**

Exemple:
```
Agitator (Core Rules Book)
Engineer (Core Rules Book)
Pit Fighter (Archives 3)
Cursed Wanderer (Death)
```

---

## 📁 Fichiers modifiés

- ✅ `winlivre.pas` - Seul fichier modifié
- ❌ `winlivre.lfm` - Inchangé
- ❌ `BOOK RULESBOOK.Xml` - Inchangé (donné de référence)

---

## 🔄 Architecture - Sources de données

```
XML Race (SUBCHAPTER_CAREER)
  └─ Career name="RULES-WORK01"
     └─ ChercheMetier("RULES-WORK01")
        ├─ ListMetier
        │  └─ Metier.Libelle = "Agitator"
        │  └─ Metier.Livre = "RULES"
        └─ ChercheLivre("RULES")
           └─ ListLivre
              └─ Livre.Libelle = "Core Rules Book"
              
AFFICHAGE: "Agitator (Core Rules Book)"
```

---

## 💡 Avantages de cette approche

1. ✅ **Centralisé** - Utilise les listes chargées au démarrage
2. ✅ **Performant** - Pas de recherche XML, données en mémoire
3. ✅ **Complet** - Couvre tous les livres (RULES, ARCH*, DEATH, etc.)
4. ✅ **Traçable** - Nom du livre visible pour chaque carrière
5. ✅ **Robuste** - Fallbacks intelligents si données manquantes
6. ✅ **Cohérent** - Même pattern que Compétences et Talents

---

## 📝 Phase 2 TODO

- [ ] Créer `AfficherCareerForRace()` pour afficher détails complets
- [ ] Afficher: Code, Description, Classe, Attributs, Compétences, Talents, Niveaux

---

## 📌 Notes pour futures sessions

- `ListMetier` chargé au démarrage: utiliser `ChercheMetier()`
- `ListLivre` chargé au démarrage: utiliser `ChercheLivre()`
- Pattern identique pour Talents et Compétences
- Toujours chercher dans les listes, pas dans XML directement
