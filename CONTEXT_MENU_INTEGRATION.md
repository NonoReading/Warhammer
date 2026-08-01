# 📋 CONTEXT.md - Menu Integration with WinLivre

**Last Update:** 2026-08-01  
**Status:** ⏳ TODO - Integrate WinLivre into Menu  
**Goal:** Double-click book in Menu → Opens WinLivre with book loaded

---

## 🎯 Quick Summary

**Task:** Make `TabLivreDblClick` in **warhammersource.pas** open WinLivre with the selected book automatically loaded.

**Current Status:**
- ✅ WinLivre is ready (has GetBookLabel, proper fields, DATABASE default folder)
- ⏳ Menu needs to launch WinLivre with book path

---

## 📁 Files Involved

| File | Location | Purpose |
|------|----------|---------|
| `warhammersource.pas` | Main menu source | Contains TabLivreDblClick (needs modification) |
| `winlivre.pas` | WinLivre editor | Ready to use - has ChargerXMLFile(path) |
| `winlivre.lfm` | WinLivre form | UI already set up |

---

## 📊 Key Info About TabLivre

**Structure:**
```pascal
TabLivre: TStringGrid
  ├─ ColLivreCod = Column with book filename/code
  ├─ ColLivreLib = Column with book display name
  └─ TabLivre.Row = Currently selected row
```

**Current TabLivreDblClick behavior:**
- Toggles selection checkbox
- Calls ChargerLivre() to load book data
- Does NOT open WinLivre

---

## 🎯 What To Do

### Task: Modify `TabLivreDblClick` in warhammersource.pas

**Current flow:**
```pascal
procedure TMenu.TabLivreDblClick(Sender: TObject);
begin
  if (TabLivre.Row > 1) and (TabLivre.Cells[ColLivreLib, TabLivre.Row] <> '') then
    // ... toggle selection logic ...
    ChargerLivre(true, '');
    ChargerPersonnages();
    SauveIni();
end;
```

**Needed flow:**
```pascal
procedure TMenu.TabLivreDblClick(Sender: TObject);
var
  BookName: String;
  BookPath: String;
begin
  if (TabLivre.Row > 1) and (TabLivre.Cells[ColLivreLib, TabLivre.Row] <> '') then
  begin
    // Get book filename from grid
    BookName := TabLivre.Cells[ColLivreCod, TabLivre.Row];
    
    // Build path: DATABASE\BOOK XXX.Xml
    BookPath := 'DATABASE\' + BookName + '.Xml';
    
    // Open WinLivre and load book
    if not Assigned(FenLivre) then
      FenLivre := TWinLivres.Create(Application);
    
    FenLivre.Position := poOwnerFormCenter;
    FenLivre.ChargerXMLFile(BookPath);  // ← Load book automatically!
    FenLivre.Show;
    FenLivre.BringToFront;
  end;
end;
```

---

## 🔍 Key Questions

1. **What's in ColLivreCod?**
   - Filename like "BOOK RULESBOOK" or "BOOK RULES"?
   - Need to check if .Xml extension should be added

2. **Is FenLivre already declared in warhammersource.pas?**
   - Probably yes (from ButtonCreationLivreClick)
   - Should reuse it or create new instance?

3. **Should we keep the original ChargerLivre() call?**
   - Or replace it with just opening WinLivre?

---

## ✅ Success Criteria

- [x] Double-click book in menu
- [x] WinLivre opens
- [x] Book is loaded in TreeView (pretty name shown)
- [x] Form displays race data when clicking
- [x] No errors on file path

---

## 📝 WinLivre Details (For Reference)

**Already fixed:**
- ✅ GetBookLabel() → Gets pretty names from DATA_LABEL
- ✅ TRaceData fields renamed (Libelle, Description)
- ✅ InitialDir = DATABASE folder
- ✅ ShowMessage calls commented out
- ✅ WordWrap enabled on Description field

**Method signature:**
```pascal
procedure ChargerXMLFile(AFilePath: String);
  // Loads XML, parses races/careers, populates TreeView
```

---

## 🚀 Next Session TODO

1. **Check TabLivreDblClick** in warhammersource.pas
2. **Identify ColLivreCod format** (needs .Xml extension?)
3. **Implement the integration**
4. **Test:** Double-click book → WinLivre opens with data loaded
5. **Commit to GitHub** when working

---

## 🔗 Repository

**GitHub:** https://github.com/NonoReading/Warhammer  
**Local:** C:\Users\arnau\Documents\Lazarus Project\Warhammer\

---

**Ready to integrate WinLivre into the Menu!** 🎯
