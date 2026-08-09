# 🚀 FEUILLE DE ROUTE - Phase 2: ÉDITION INTERACTIVE

## ✅ Phase 1 complétée
- ✅ Grille de métiers affichée
- ✅ Tri intelligent (sélectionnés en premier)
- ✅ En-têtes traduits
- ✅ Parsing robuste
- ✅ 5 colonnes: Code, Libellé, Livre, Sélectionné, Chance

**État:** Prêt pour édition interactive

---

## 🎯 Phase 2: Édition interactive

### Objectif
Permettre à l'utilisateur de:
1. **Toggler la sélection** d'un métier (double-clic ou clic)
2. **Éditer la chance** (valeur du XML)
3. **Sauvegarder** les changements dans le XML
4. **Annuler** les changements non validés

---

## 📋 Tâches Phase 2

### Tâche 1: Interactivité Col 3 (Sélectionné)
**Élément:** Colonne "Sélectionné" (✓)

**Action:** Double-clic ou clic
```
Si clique sur ✓ → Enlever (vider la cellule)
Si clique sur vide → Ajouter (mettre ✓)
```

**Implémentation:**
- [ ] Ajouter event `StringGridSkillsSelectCell` (OnSelectCell)
- [ ] Détecter double-clic ou clic simple
- [ ] Modifier `RaceCareersData` in-memory
- [ ] Rafraîchir l'affichage
- [ ] Ré-trier si nécessaire

**Code pattern:**
```pascal
procedure TWinLivres.StringGridSkillsSelectCell(Sender: TObject; 
  aCol, aRow: Integer);
begin
  if aCol = 3 then  // Colonne "Sélectionné"
  begin
    if StringGridSkills.Cells[3, aRow] = '✓' then
      // Enlever de RaceCareersData
    else
      // Ajouter à RaceCareersData
    // Rafraîchir affichage
  end;
end;
```

### Tâche 2: Édition Col 4 (Chance)
**Élément:** Colonne "Chance" (valeur)

**Action:** Double-clic = Mode édition
```
Mode édition: TEdit ou SpinBox
Valider: Enter ou Escape
Annuler: Escape
```

**Implémentation:**
- [ ] Détecter double-clic sur Col 4
- [ ] Afficher TEdit/SpinBox au-dessus de la cellule
- [ ] Permettre édition
- [ ] Valider avec Enter → Mettre à jour RaceCareersData
- [ ] Annuler avec Escape → Rejeter changement

**Code pattern:**
```pascal
procedure TWinLivres.StringGridSkillsDblClick(Sender: TObject);
var
  Pt: TPoint;
  aCol, aRow: Integer;
begin
  Pt := StringGridSkills.ScreenToClient(Mouse.CursorPos);
  StringGridSkills.MouseToCell(Pt.X, Pt.Y, aCol, aRow);
  
  if aCol = 4 then  // Colonne "Chance"
  begin
    // Afficher TEdit avec la valeur actuelle
    // Permettre édition
  end;
end;
```

### Tâche 3: Sauvegarder les changements
**Élément:** Bouton "Valider" (à ajouter)

**Action:** Sauvegarde dans le XML
```
RaceCareersData → <SUBCHAPTER_CAREER> du XML
Persister le fichier
Afficher message confirmation
```

**Implémentation:**
- [ ] Créer procédure `SauvegarderCareersForRace(RaceCode)`
- [ ] Mettre à jour `<SUBCHAPTER_CAREER>` dans XMLDoc
- [ ] XMLDoc.SaveToFile(cheminXML)
- [ ] Afficher message: "Métiers sauvegardés"

**Code pattern:**
```pascal
procedure TWinLivres.ButtonValiderClick(Sender: TObject);
var
  RaceCode: String;
begin
  RaceCode := GetCurrentRaceCode();  // À implémenter
  SauvegarderCareersForRace(RaceCode);
  ShowMessage('Métiers sauvegardés avec succès!');
end;

procedure TWinLivres.SauvegarderCareersForRace(RaceCode: String);
begin
  // 1. Trouver <Specie id="RaceCode">
  // 2. Chercher <SUBCHAPTER_CAREER>
  // 3. Vider les <Career> existants
  // 4. Recréer <Career> à partir de RaceCareersData
  // 5. XMLDoc.SaveToFile(...)
end;
```

### Tâche 4: Annuler les changements
**Élément:** Bouton "Annuler" (à ajouter)

**Action:** Rejeter modifications
```
Recharger RaceCareersData depuis le XML
Rafraîchir l'affichage
Afficher message annulation
```

**Implémentation:**
- [ ] Créer procédure `AnnulerCareersForRace()`
- [ ] Recharger `LoadCareersForRace()`
- [ ] Rafraîchir `AfficherCareersForRace()`
- [ ] Afficher message: "Modifications annulées"

**Code pattern:**
```pascal
procedure TWinLivres.ButtonAnnulerClick(Sender: TObject);
var
  RaceCode: String;
  RaceElement: TDOMElement;
begin
  RaceCode := GetCurrentRaceCode();
  RaceElement := GetCurrentRaceElement();
  LoadCareersForRace(RaceElement);  // Recharger
  AfficherCareersForRace(RaceCode);  // Rafraîchir
  ShowMessage('Modifications annulées');
end;
```

---

## 🎨 Interface utilisateur

### Boutons à ajouter
```
┌────────────────────────────────────────────┐
│ [Valider]  [Annuler]  [?]                 │
└────────────────────────────────────────────┘
```

**Placement:**
- Au-dessus ou en-dessous de la grille
- Vérifier avec Nono l'emplacement

### États des boutons
```
- "Valider": Activé si des changements
- "Annuler": Activé si des changements
- "?": Info sur les changements
```

---

## 🧪 Tests Phase 2

### Test 1: Toggle sélection
```
1. Clic sur métier non-sélectionné (Col 3 vide)
2. → Doit afficher ✓
3. Clic sur ✓
4. → Doit enlever ✓
```

### Test 2: Éditer chance
```
1. Double-clic sur "01" (Col 4)
2. → TEdit apparaît
3. Taper "42"
4. Enter
5. → Affiche "42" dans la grille
```

### Test 3: Sauvegarder
```
1. Modifier quelques métiers
2. Clic "Valider"
3. → Message "Sauvegardé"
4. Ouvrir le XML en éditeur texte
5. → Voir les changements dans <SUBCHAPTER_CAREER>
```

### Test 4: Annuler
```
1. Modifier métiers
2. Clic "Annuler"
3. → Message "Annulé"
4. → Grille recharge l'état précédent
```

### Test 5: Persistance
```
1. Sauvegarder changements
2. Fermer l'application
3. Rouvrir
4. Ouvrir le XML
5. Clique race → Career
6. → Voir les changements persistés
```

---

## 📌 Variables à conserver/créer

```pascal
// Existantes à conserver
RaceCareersData: TStringList  // Métiers sélectionnés
CurrentRaceCode: String       // Race courante

// À créer
RaceCareersDataBackup: TStringList  // Pour annuler
HasChanges: Boolean  // État modifications
```

---

## 🔄 Flux utilisateur Phase 2

```
Utilisateur voit grille (Phase 1)
        ↓
[Double-clic Col 3] 
  → Toggle ✓
  → RaceCareersData modifié in-memory
  → Grille rafraîchie
  ↓
[Double-clic Col 4]
  → TEdit apparaît
  → Édite valeur
  → Enter → Mise à jour RaceCareersData
  ↓
[Clic "Valider"]
  → SauvegarderCareersForRace()
  → XMLDoc.SaveToFile()
  → Message confirmation
  ↓
[Ou clic "Annuler"]
  → Recharger depuis XML
  → Affichage restauré
  → Message annulation
```

---

## 📝 Code structure sugérée

```pascal
// Nouvelles procédures
procedure StringGridSkillsSelectCell(Sender: TObject; aCol, aRow: Integer);
procedure StringGridSkillsDblClick(Sender: TObject);
procedure ButtonValiderClick(Sender: TObject);
procedure ButtonAnnulerClick(Sender: TObject);

// Procédures utilitaires
procedure SauvegarderCareersForRace(RaceCode: String);
procedure AnnulerCareersForRace(RaceCode: String);
function GetCurrentRaceCode(): String;
procedure MarquerModifications();
procedure RafraichirAffichage();
```

---

## ⚠️ Points importants Phase 2

1. **RaceCareersData** = État in-memory, modifié par interactions
2. **XML** = Persistant, modifié au clic "Valider"
3. **Backup** = Garder une copie pour "Annuler"
4. **Tri** = Réappliquer après chaque modification
5. **Validation** = Vérifier format valeurs avant sauvegarder
6. **UX** = Feedback clair (messages, boutons activés/désactivés)

---

## 🎯 Priorités

1. **Haute:** Toggle sélection + Sauvegarder
2. **Moyenne:** Éditer chance + Annuler
3. **Basse:** Validations avancées, Confirmations

---

## 📚 Fichiers à préparer

- [ ] winlivre.pas (ajouter procédures Phase 2)
- [ ] winlivre.lfm (ajouter boutons)
- [ ] Documentation Phase 2
- [ ] Tests unitaires

---

## 🚀 Démarrage Phase 2

**Quand:** Une fois que Nono confirme que Phase 1 est stable
**Qui:** Nono pour feedback, Claude pour implémentation
**Durée estimée:** 1-2 sessions

---

**Phase 1 ✅ terminée**
**Phase 2 🚀 prête à démarrer!**
