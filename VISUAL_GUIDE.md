# Guide Visuel - Ajout des Carrières

## 📍 **Changement 1: Déclaration (ligne ~148)**

```pascal
// AVANT:
procedure LoadTalentsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
procedure LoadSkillsForRace(RaceElement: TDOMElement; RaceCode: String);

// APRÈS:
procedure LoadTalentsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
procedure LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);  // ← NOUVEAU!
procedure LoadSkillsForRace(RaceElement: TDOMElement; RaceCode: String);
```

---

## 📍 **Changement 1b: Uses (ligne ~9)**

```pascal
// AVANT:
uses ... ChargeCompetence, ChargeTalent, UnitCalcul, Grids ...

// APRÈS:
uses ... ChargeCompetence, ChargeTalent, ChargeMetier, UnitCalcul, Grids ...
```

---

## 📍 **Changement 2: Implémentation (nouvelle procédure ~ligne 650)**

```pascal
// ========== CHARGER CARRIÈRES POUR RACE ==========
procedure TWinLivres.LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
var
  CareerChapter: TDOMNode;
  CareerElements: TDOMNodeList;
  I: Integer;
  CareerCode, CareerDesc: String;
  NodeCareers, NodeCareer: TTreeNode;
  CareerNode: TDOMNode;
  Metier: StructureMetier;  // ← Utilise StructureMetier de ChargeMetier
begin
  // 1. Chercher SUBCHAPTER_CAREER dans cette race
  CareerChapter := RaceElement.FindNode('SUBCHAPTER_CAREER');
  if CareerChapter = nil then Exit;
  
  // 2. Créer la branche "Career" (traduite)
  NodeCareers := TreeViewLivre.Items.AddChild(RaceNode, GetTexteLibelle('LAB_006'));
  NodeCareers.Data := Pointer(PtrInt(9));  // 9 = careers chapter
  
  // 3. Récupérer les Career de cette race
  CareerElements := CareerChapter.ChildNodes;
  
  if CareerElements.Count > 0 then
  begin
    for I := 0 to CareerElements.Count - 1 do
    begin
      CareerNode := CareerElements[I];
      if CareerNode.NodeName = 'Career' then
      begin
        // Récupérer le code: name="RULES-WORK01" ou name="ARCH3-WORK99"
        CareerCode := TDOMElement(CareerNode).GetAttribute('name');
        if CareerCode = '' then Continue;
        
        // ✨ Chercher dans ListMetier (tous les livres!)
        Metier := ChercheMetier(CareerCode);
        
        if Metier.CodeMetier <> '' then
          CareerDesc := Metier.Libelle  // Affiche le libellé
        else
          CareerDesc := CareerCode;     // Fallback si pas trouvé
        
        // Ajouter le nœud dans l'arbre
        NodeCareer := TreeViewLivre.Items.AddChild(NodeCareers, CareerDesc);
        NodeCareer.Data := Pointer(PtrInt(13));  // 13 = career item
      end;
    end;
  end;
end;
```

**Différences clés:**
- ✅ Utilise `ChercheMetier()` au lieu de boucler dans le XML
- ✅ Fonctionne avec métiers de TOUS les livres (RULES, ARCH3, DEATH, etc.)
- ✅ Beaucoup plus simple et performant
- ✅ Fallback si métier pas trouvé

---

## 📍 **Changement 3: Appel dans ChargerXMLFile() (ligne ~887)**

```pascal
// AVANT:
// ========== CHARGER LES TALENTS DE CETTE RACE DANS L'ARBRE ==========
LoadTalentsForRaceTree(XMLElement, NodeRace);
end;  // Fin boucle races
end;

// APRÈS:
// ========== CHARGER LES TALENTS DE CETTE RACE DANS L'ARBRE ==========
LoadTalentsForRaceTree(XMLElement, NodeRace);

// ========== CHARGER LES CARRIÈRES DE CETTE RACE DANS L'ARBRE ==========
LoadCareersForRaceTree(XMLElement, NodeRace);  // ← NOUVEAU!
end;  // Fin boucle races
end;
```

---

## 📍 **Changement 4: Gestion du clic dans TreeViewLivreChange() (ligne ~1061)**

```pascal
// AVANT:
5: begin
     // C'est la branche "Talents"
     TypeNodeSelectionnee := 'CHAPITRE';
     LabelFormTitle.Caption := GetTexteLibelle('LAB_007');
     AfficherTalentsForRace();
   end;
else
  MasquerForm();
end;

// APRÈS:
5: begin
     // C'est la branche "Talents"
     TypeNodeSelectionnee := 'CHAPITRE';
     LabelFormTitle.Caption := GetTexteLibelle('LAB_007');
     AfficherTalentsForRace();
   end;
9: begin  // ← NOUVEAU!
     // C'est la branche "Carrières de race"
     TypeNodeSelectionnee := 'CHAPITRE';
     LabelFormTitle.Caption := GetTexteLibelle('LAB_006');
     MasquerForm();
   end;
13: begin  // ← NOUVEAU!
      // C'est un item "Carrière"
      TypeNodeSelectionnee := 'CARRIERE';
      LabelFormTitle.Caption := Node.Text;
      MasquerForm();
    end;
else
  MasquerForm();
end;
```

---

## 🔄 **Flux de données**

```
ChargerXMLFile()
  ↓
  Pour chaque <Specie>:
    ├─ LoadAttributesForRace()
    ├─ LoadSkillsForRaceTree()
    ├─ LoadTalentsForRaceTree()
    └─ LoadCareersForRaceTree()  ← NOUVEAU!
        └─ Cherche <SUBCHAPTER_CAREER> name="RULES-WORK*"
           └─ Cherche description dans <Career id="RULES-WORK*">
              └─ Ajoute au TreeView avec Node.Data = 13
```

---

## 🧪 **Test rapide**

1. Remplace `winlivre.pas` dans ton projet
2. Compile (`Ctrl+F9` ou Menu → Run → Compile)
3. Ouvre le XML
4. Clique sur une race (ex: "Humans (Reikland)")
5. Expande la race en cliquant sur `>`
6. Tu dois voir:
   ```
   Humans (Reikland)
   ├─ Attributes
   ├─ Skills
   ├─ Talents
   └─ Career ← NOUVEAU!
      ├─ Agitator
      ├─ Engineer
      ├─ Lawyer
      └─ ...
   ```

Si ça marche, tu peux clicker sur chaque carrière pour voir son nom s'afficher dans le titre! 🎉

---

## 🐛 **Si erreur de compilation**

Si tu as une erreur du type:
- `Error: Identifier not found "LoadCareersForRaceTree"`
  → Vérifie que la déclaration (ligne ~148) est bien présente

- `Error: Procedure not found`
  → Vérifie que l'implémentation (ligne ~650) est bien complète

- `Error: Unknown identifier "CareerChapter"`
  → Vérifie que tu as bien tout copié

**Message privé avec la ligne d'erreur et je corrige!** 🔧
