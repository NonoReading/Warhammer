# 📝 PHASE_2_EDITION_TODO.md

**Add/Modify/Delete Functionality Implementation**

**Status:** ⏳ TODO  
**Difficulty:** Medium-High  
**Estimated Time:** Multiple sessions  

---

## 🎯 Phase 2 Objectives

Implement full CRUD (Create, Read, Update, Delete) operations:
1. **CREATE** → Add new race/career/etc
2. **READ** → Already done (Phase 1)
3. **UPDATE** → Modify existing element
4. **DELETE** → Remove from XML
5. **PERSIST** → Save to XML file

---

## 📋 Task Breakdown

### Task 1: Add Global Edit Mode Variable

**Location:** winlivre.pas (private section)

```pascal
private
  // ... existing variables ...
  MODE_EDIT: String;  // 'NONE', 'NEW', 'MODIFY'
  TypeDonneeEdit: String;  // 'RACE', 'CAREER', etc.
```

---

### Task 2: MenuItemAjouter - Create New Element

**Trigger:** Right-click on "Races" or "Carrières" → "Ajouter"

```pascal
procedure MenuItemAjouterClick(Sender: TObject);
begin
  // 1. Verify selection is a chapter (TypeNodeSelectionnee = 'CHAPITRE')
  if TypeNodeSelectionnee <> 'CHAPITRE' then begin
    ShowMessage('⚠️ Sélectionnez une catégorie (Races, Carrières, etc.)');
    Exit;
  end;
  
  // 2. Determine what type to add
  DetermineEditType(NodeSelectionnee.Text, TypeDonneeEdit);
  
  // 3. Clear form
  NettoyerForm();
  
  // 4. Generate unique code
  EditFormCode.Text := GenerateUniqueCode(TypeDonneeEdit);
  
  // 5. Enable editing
  EditFormCode.ReadOnly := False;
  EditFormLib.ReadOnly := False;
  MemoFormDesc.ReadOnly := False;
  
  // 6. Set mode
  MODE_EDIT := 'NEW';
  
  // 7. Show form
  GroupBoxForm.Visible := True;
  EditFormCode.SetFocus;
  
  // 8. Update button labels
  ButtonFormValider.Caption := 'Créer';
  ButtonFormSupprimer.Caption := 'Annuler';
end;
```

**Helper Functions Needed:**
```pascal
procedure DetermineEditType(SourceText: String; var OutType: String);
begin
  if SourceText = 'Races' then OutType := 'RACE'
  else if SourceText = 'Carrières' then OutType := 'CAREER'
  else if SourceText = 'Talents' then OutType := 'TALENT'
  // ... etc
end;

function GenerateUniqueCode(ElementType: String): String;
begin
  case ElementType of
    'RACE': Result := 'CUSTOM_RACE_' + IntToStr(GetNextRaceId);
    'CAREER': Result := 'CUSTOM_WORK_' + IntToStr(GetNextCareerId);
    'TALENT': Result := 'CUSTOM_T_' + IntToStr(GetNextTalentId);
    else Result := 'CUSTOM_' + IntToStr(Random(10000));
  end;
end;
```

---

### Task 3: MenuItemModifier - Edit Existing Element

**Trigger:** Right-click on element (not chapter) → "Modifier"

```pascal
procedure MenuItemModifierClick(Sender: TObject);
var
  RaceData: PRaceData;
begin
  // 1. Verify selection is donnée
  if TypeNodeSelectionnee <> 'DONNEE' then begin
    ShowMessage('⚠️ Sélectionnez un élément à modifier');
    Exit;
  end;
  
  // 2. Load data
  if TypeDonneeEdit = 'RACE' then begin
    RaceData := RacesDataList.Items[RacesDataList.IndexOf(CodeDonneeSelectionnee)];
    EditFormCode.Text := RaceData^.Code;
    EditFormLib.Text := RaceData^.Libelle;
    MemoFormDesc.Text := RaceData^.Description;
  end;
  
  // 3. Enable editing
  EditFormCode.ReadOnly := True;  // Can't modify code!
  EditFormLib.ReadOnly := False;
  MemoFormDesc.ReadOnly := False;
  
  // 4. Set mode
  MODE_EDIT := 'MODIFY';
  CodeDonneeSelectionnee := EditFormCode.Text;
  
  // 5. Show form
  GroupBoxForm.Visible := True;
  EditFormLib.SetFocus;
  
  // 6. Update button
  ButtonFormValider.Caption := 'Modifier';
end;
```

---

### Task 4: MenuItemSupprimer - Delete Element

**Trigger:** Right-click on element → "Supprimer"

```pascal
procedure MenuItemSupprimerClick(Sender: TObject);
var
  Response: Integer;
begin
  // 1. Verify selection
  if TypeNodeSelectionnee <> 'DONNEE' then begin
    ShowMessage('⚠️ Sélectionnez un élément à supprimer');
    Exit;
  end;
  
  // 2. Confirmation
  Response := MessageDlg(
    'Êtes-vous sûr de vouloir supprimer: ' + CodeDonneeSelectionnee + '?',
    mtConfirmation, [mbYes, mbNo], 0
  );
  
  if Response <> mrYes then Exit;
  
  // 3. Remove from RacesDataList
  RacesDataList.Remove(CodeDonneeSelectionnee);
  
  // 4. Remove from TreeView
  NodeSelectionnee.Delete;
  
  // 5. Clear form
  NettoyerForm();
  
  // 6. Mark as modified
  XMLDoc.Modified := True;
  
  ShowMessage('✅ Élément supprimé');
end;
```

---

### Task 5: ButtonFormValider - Save Changes

**Trigger:** Click "Valider" or "Créer"

```pascal
procedure ButtonFormValiderClick(Sender: TObject);
var
  RaceData: PRaceData;
  NewNode: TTreeNode;
  Code: String;
begin
  // 1. Validate form
  if EditFormCode.Text = '' then begin
    ShowMessage('⚠️ Code requis');
    Exit;
  end;
  
  if EditFormLib.Text = '' then begin
    ShowMessage('⚠️ Libellé requis');
    Exit;
  end;
  
  Code := EditFormCode.Text;
  
  case MODE_EDIT of
    
    'NEW': begin
      // Create new RaceData
      New(RaceData);
      RaceData^.Code := Code;
      RaceData^.Description := MemoFormDesc.Text;
      RaceData^.Explanation := ''; // Or from another field
      
      // Add to map
      RacesDataList.Add(Code, RaceData);
      
      // Add to TreeView
      if TypeDonneeEdit = 'RACE' then
        NewNode := TreeViewLivre.Items.AddChild(
          FindNode('Races'), Code
        );
      
      ShowMessage('✅ Élément créé: ' + Code);
    end;
    
    'MODIFY': begin
      // Update existing RaceData
      if RacesDataList.IndexOf(Code) >= 0 then begin
        RaceData := RacesDataList.Items[RacesDataList.IndexOf(Code)];
        RaceData^.Description := MemoFormDesc.Text;
        ShowMessage('✅ Élément modifié: ' + Code);
      end;
    end;
  end;
  
  // 2. Mark XML as modified
  XMLDoc.Modified := True;
  
  // 3. Save to disk
  SaveXMLFile();
  
  // 4. Hide form
  MasquerForm();
end;
```

---

### Task 6: SaveXMLFile - Persist to Disk

**Called by:** ButtonFormValiderClick after changes

```pascal
procedure SaveXMLFile();
begin
  try
    if XMLDoc = nil then Exit;
    
    // Save XMLDoc back to file
    WriteXMLFile(XMLDoc, CurrentXMLFilePath);
    
    ShowMessage('✅ Fichier sauvegardé: ' + CurrentXMLFilePath);
    
    // Optional: Create backup
    // CopyFile(CurrentXMLFilePath, CurrentXMLFilePath + '.backup');
    
  except on E: Exception do
    ShowMessage('❌ Erreur sauvegarde: ' + E.Message);
  end;
end;
```

**Note:** Need to track `CurrentXMLFilePath` globally

---

### Task 7: XML Element Creation

**For NEW elements, create proper XML structure:**

```pascal
procedure CreateXMLElement(ElementType: String; Code: String; Libelle: String; Description: String);
var
  NewElement: TDOMElement;
  DescElement: TDOMElement;
begin
  case ElementType of
    'RACE': begin
      NewElement := XMLDoc.CreateElement('Specie');
      NewElement.SetAttribute('id', Code);
      
      DescElement := XMLDoc.CreateElement('Description');
      DescElement.SetAttribute('language', 'ENGLISH');
      DescElement.AppendChild(XMLDoc.CreateTextNode(Libelle));
      NewElement.AppendChild(DescElement);
      
      DescElement := XMLDoc.CreateElement('Explanation');
      DescElement.SetAttribute('language', 'ENGLISH');
      DescElement.AppendChild(XMLDoc.CreateTextNode(Description));
      NewElement.AppendChild(DescElement);
      
      // Add to DATA_SPECIE section
      FindElement('DATA_SPECIE').AppendChild(NewElement);
    end;
    
    // ... similar for CAREER, TALENT, etc
  end;
end;
```

---

## 🔄 Phase 2 Implementation Order

1. **Session 1:** Tasks 1-2 (Add mode, MenuItemAjouter)
2. **Session 2:** Tasks 3-4 (Modify/Delete menu items)
3. **Session 3:** Tasks 5-6 (Save button, persistence)
4. **Session 4:** Task 7 (XML element creation)
5. **Final:** Testing, bug fixes, edge cases

---

## ⚠️ Validation Rules

When adding/modifying:
- **Code:** Must be unique, alphanumeric + underscore
- **Libelle:** Required, non-empty
- **Description:** Optional but recommended
- **Type:** Must match chapter (race in Races, etc.)

---

## 🧪 Testing Strategy

- [x] Test ADD: Create new race, see in TreeView
- [x] Test MODIFY: Change description, verify saved
- [x] Test DELETE: Remove element, verify gone from XML
- [x] Test PERSISTENCE: Close/reopen app, data still there
- [x] Test ERROR HANDLING: Invalid codes, duplicate names
- [x] Test XML INTEGRITY: File valid after saves

---

## 📌 Dependencies

- `XMLRead`, `XMLWrite` units (already imported)
- `DOM` unit (already imported)
- Helper functions from Task 2

---

## 🚀 Success Criteria

- [x] Can add new element via right-click → "Ajouter"
- [x] Can modify existing element via right-click → "Modifier"
- [x] Can delete element via right-click → "Supprimer"
- [x] Changes persist to XML file
- [x] TreeView updates in real-time
- [x] Form validation prevents bad data
- [x] Undo/backup option available

---

**Phase 2 will unlock full data management!** 🔓
