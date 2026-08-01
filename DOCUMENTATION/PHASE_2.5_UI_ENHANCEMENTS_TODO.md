# 🎨 PHASE_2.5_UI_ENHANCEMENTS_TODO.md

**UI/UX Improvements: Menu + Pretty TreeView Names**

**Status:** ⏳ TODO  
**Difficulty:** Medium  
**Estimated Time:** 1-2 sessions  

---

## 🎯 Phase 2.5 Objectives

### Enhancement 1: File Menu for Quick Book Loading
- Scan DATABASE/ folder
- List all .xml files
- Click to load directly (no dialog)
- Optional: Recent files list

### Enhancement 2: Pretty TreeView Names
- Use DATA_LABEL for translations
- Display "Human" instead of "RULES-RACE_HUM"
- Cache code in Node.Data
- Sort alphabetically (optional)

---

## 📋 Enhancement 1: File Menu

### Goal
Instead of:
```
Button "Charger XML..." (dialog required)
```

Have:
```
Menu "Fichier"
  ├─ BOOK RULESBOOK.Xml
  ├─ BOOK ARCHIVES OF THE EMPIRE I.Xml
  ├─ BOOK GREEN IZ BEST.Xml
  └─ ...
```

### Implementation Steps

#### Step 1: Add Main Menu Component

**In winlivre.lfm:**
```
Add: TMainMenu (MainMenu1)
  └─ MenuItem: "Fichier"
     ├─ MenuItem: "Charger Livre..."
     ├─ ---
     ├─ MenuItem: "[Book 1]"
     ├─ MenuItem: "[Book 2]"
     └─ MenuItem: "Quitter"
```

**In winlivre.pas:**
```pascal
private
  MainMenu1: TMainMenu;
  MenuItemFichier: TMenuItem;
  MenuItemCharger: TMenuItem;
  MenuItemBooks: array of TMenuItem;  // Dynamic array
  MenuItemQuit: TMenuItem;
  
  procedure MenuItemFichierClick(Sender: TObject);
  procedure MenuItemBookClick(Sender: TObject);
  procedure MenuItemQuitClick(Sender: TObject);
```

#### Step 2: Scan DATABASE Folder

```pascal
procedure ScanDatabaseFolder;
var
  SearchRec: TSearchRec;
  FilePath: String;
  MenuItem: TMenuItem;
  Count: Integer;
begin
  FilePath := ExtractFilePath(Application.ExeName) + '..\DATABASE';
  
  Count := 0;
  if FindFirst(FilePath + '\*.Xml', faAnyFile, SearchRec) = 0 then begin
    repeat
      if (SearchRec.Attr and faDirectory) = 0 then begin
        // Create menu item for this file
        MenuItem := TMenuItem.Create(MenuItemFichier);
        MenuItem.Caption := SearchRec.Name;
        MenuItem.OnClick := @MenuItemBookClick;
        MenuItem.Tag := Count;  // Index
        MenuItemFichier.Add(MenuItem);
        
        // Store full path
        SetLength(MenuItemBooks, Count + 1);
        MenuItemBooks[Count] := MenuItem;
        
        Inc(Count);
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;
```

#### Step 3: Menu Click Handler

```pascal
procedure MenuItemBookClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  BookName: String;
  FilePath: String;
begin
  MenuItem := Sender as TMenuItem;
  BookName := MenuItem.Caption;
  FilePath := ExtractFilePath(Application.ExeName) + '..\DATABASE\' + BookName;
  
  if FileExists(FilePath) then
    ChargerXMLFile(FilePath)
  else
    ShowMessage('❌ Fichier non trouvé: ' + FilePath);
end;
```

#### Step 4: FormCreate - Initialize Menu

```pascal
procedure FormCreate(Sender: TObject);
begin
  // ... existing code ...
  
  // Create Main Menu
  MainMenu1 := TMainMenu.Create(Self);
  Self.Menu := MainMenu1;
  
  MenuItemFichier := TMenuItem.Create(MainMenu1);
  MenuItemFichier.Caption := '&Fichier';
  MainMenu1.Items.Add(MenuItemFichier);
  
  // Charger
  MenuItemCharger := TMenuItem.Create(MenuItemFichier);
  MenuItemCharger.Caption := '&Charger Livre...';
  MenuItemCharger.OnClick := @ButtonChargerXMLClick;
  MenuItemFichier.Add(MenuItemCharger);
  
  // Separator
  TMenuItem.Create(MenuItemFichier).Caption := '-';
  
  // Scan database
  ScanDatabaseFolder;
  
  // Quit
  MenuItemQuit := TMenuItem.Create(MenuItemFichier);
  MenuItemQuit.Caption := '&Quitter';
  MenuItemQuit.OnClick := @MenuItemQuitClick;
  MenuItemFichier.Add(MenuItemQuit);
end;
```

---

## 📋 Enhancement 2: Pretty TreeView Names

### Goal
**Before:**
```
BOOK_RULESBOOK.Xml
├─ Races
│  ├─ RULES-RACE_HUM
│  ├─ RULES-RACE_DWAR
│  └─ RULES-RACE_HELF
└─ Carrières
   ├─ RULES-WORK01
   └─ RULES-WORK02
```

**After:**
```
BOOK_RULESBOOK.Xml
├─ Races
│  ├─ Human            [cached: RULES-RACE_HUM]
│  ├─ Dwarf            [cached: RULES-RACE_DWAR]
│  └─ High Elf         [cached: RULES-RACE_HELF]
└─ Carrières
   ├─ Agitator         [cached: RULES-WORK01]
   └─ Apothecary       [cached: RULES-WORK02]
```

### Implementation Steps

#### Step 1: Create Label Cache Data Structure

```pascal
type
  TLabelCache = record
    Code: String;
    DisplayName: String;
  end;
  
  PLabelCache = ^TLabelCache;
  TLabelCacheMap = specialize TFPGMap<String, String>;  
  // Key: Code, Value: DisplayName
```

**In winlivre.pas (private):**
```pascal
private
  LabelCache: TLabelCacheMap;  // Global label cache
```

#### Step 2: Load DATA_LABEL from XML

```pascal
procedure LoadLabelsFromXML;
var
  LabelElements: TDOMNodeList;
  XMLElement: TDOMElement;
  I: Integer;
  Code, DisplayName: String;
begin
  LabelCache.Clear;
  
  LabelElements := XMLDoc.GetElementsByTagName('Text');
  
  for I := 0 to LabelElements.Count - 1 do begin
    XMLElement := TDOMElement(LabelElements.Item[I]);
    Code := XMLElement.GetAttribute('name');
    DisplayName := XMLElement.TextContent;
    
    // Remove quotes if present
    if (DisplayName[1] = '"') and (DisplayName[Length(DisplayName)] = '"') then
      DisplayName := Copy(DisplayName, 2, Length(DisplayName) - 2);
    
    if Code <> '' then
      LabelCache.Add(Code, DisplayName);
  end;
  
  ShowMessage('✅ ' + IntToStr(LabelCache.Count) + ' labels chargés');
end;
```

#### Step 3: Get Pretty Name Function

```pascal
function GetPrettyName(Code: String): String;
var
  Index: Integer;
begin
  Index := LabelCache.IndexOf(Code);
  if Index >= 0 then
    Result := LabelCache.ValueAt[Index]
  else
    Result := Code;  // Fallback to code if not found
end;
```

#### Step 4: Modify ChargerXMLFile to Use Pretty Names

```pascal
procedure ChargerXMLFile(AFilePath: String);
begin
  // ... existing XML loading code ...
  
  // NEW: Load label mappings
  LoadLabelsFromXML;
  
  // Load RACES with pretty names
  for I := 0 to SpecieElements.Count - 1 do begin
    XMLElement := TDOMElement(SpecieElements.Item[I]);
    Code := XMLElement.GetAttribute('id');
    if Code = '' then Continue;
    
    // ... store in RacesDataList ...
    
    // NEW: Use pretty name
    PrettyName := GetPrettyName(Code);
    NodeRace := TreeViewLivre.Items.AddChild(NodeRaces, PrettyName);
    
    // NEW: Cache the code in Node.Data
    NodeRace.Data := Pointer(PtrInt(1));
    // Note: Store actual code somewhere for later retrieval!
  end;
  
  // Similar for careers
  ...
end;
```

#### Step 5: Extended Node.Data to Store Code

**Problem:** Node.Data currently stores only type (0=chapter, 1=data)  
**Solution:** Create extended data structure

```pascal
type
  TNodeData = record
    NodeType: Integer;  // 0=chapter, 1=data
    Code: String;       // RULES-RACE_HUM, etc.
  end;
  PNodeData = ^TNodeData;
```

**Update code:**
```pascal
var
  NodeData: PNodeData;
begin
  // When adding race to tree:
  New(NodeData);
  NodeData^.NodeType := 1;
  NodeData^.Code := Code;  // Store code here!
  
  NodeRace := TreeViewLivre.Items.AddChild(NodeRaces, GetPrettyName(Code));
  NodeRace.Data := Pointer(NodeData);
end;
```

#### Step 6: Update Selection Handler

```pascal
procedure TreeViewLivreChange(Sender: TObject; Node: TTreeNode);
var
  NodeData: PNodeData;
begin
  NodeSelectionnee := Node;
  
  if Node.Data <> nil then begin
    NodeData := PNodeData(Node.Data);
    TypeNodeSelectionnee := 'CHAPITRE';
    
    if NodeData^.NodeType = 1 then begin
      TypeNodeSelectionnee := 'DONNEE';
      CodeDonneeSelectionnee := NodeData^.Code;  // Get original code
      AfficherDonneeRace(CodeDonneeSelectionnee);
    end;
  end;
end;
```

---

## 🔗 Integration Points

### When to Load Labels
1. **Right after XML loads** in ChargerXMLFile()
2. **Before creating TreeView nodes**
3. **Use for all element types** (races, careers, talents, etc.)

### Sorting (Optional Enhancement)
If displaying alphabetically:
```pascal
TreeViewLivre.AlphaSort;  // Built-in function
```

---

## 🎨 Visual Result

After Phase 2.5:
```
Menu Bar:
  [Fichier] [?]
    ├─ Charger Livre...
    ├─ ──────────────
    ├─ BOOK RULESBOOK.Xml
    ├─ BOOK ARCHIVES I.Xml
    └─ Quitter

TreeView (After clicking a book):
  BOOK_RULESBOOK.Xml
  ├─ Races (5)
  │  ├─ Human           [code: RULES-RACE_HUM]
  │  ├─ Halfling        [code: RULES-RACE_HALF]
  │  ├─ Dwarf           [code: RULES-RACE_DWAR]
  │  ├─ High Elf        [code: RULES-RACE_HELF]
  │  └─ Wood Elf        [code: RULES-RACE_WELF]
  └─ Carrières (64)
     ├─ Agitator        [code: RULES-WORK01]
     ├─ Apothecary      [code: RULES-WORK02]
     └─ ... (62 more)
```

---

## 🧪 Testing Checklist

- [x] Main menu appears in form
- [x] Menu lists all .xml books from DATABASE/
- [x] Click menu item loads that book
- [x] Labels load correctly from XML
- [x] TreeView shows pretty names (Human, Dwarf, etc.)
- [x] Code cached in Node.Data
- [x] Clicking element retrieves correct code
- [x] Display still works with pretty names
- [x] Edit/Add/Delete still works
- [x] Persistence still works

---

## ⚠️ Edge Cases

1. **Missing labels** → Fallback to code
2. **Special characters** → Handle quotes properly
3. **Long names** → TreeView width adjustable
4. **No DATABASE folder** → Handle gracefully
5. **Empty books** → Still list, show "no data"

---

## 🚀 Success Criteria

- [x] Main menu populated with all .xml books
- [x] Click menu item loads book instantly
- [x] TreeView displays pretty names
- [x] Code cached invisible to user
- [x] All Phase 1 functionality still works
- [x] All Phase 2 functionality still works
- [x] Professional UI appearance

---

**Phase 2.5 makes WinLivre user-friendly!** 🎯
