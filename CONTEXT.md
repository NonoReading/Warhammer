# 📋 CONTEXT.md - WinLivre v2.0.0

**Last Update:** 2026-08-01 08:20  
**Status:** ✅ **Phase 1 COMPLETE** | ➡️ **Phase 2 & 2.5 TODO**

---

## 🎯 Quick Summary

**WinLivre v2.0.0** est une application Lazarus/Free Pascal pour gérer les données Warhammer Fantasy V4 depuis les fichiers XML (`BOOK_RULESBOOK_FRANCAIS.Xml`, etc.).

**Current Goal:** Phase 2.5 - Implement UI/UX Enhancements (Menu + Pretty TreeView)

---

## 📚 Documentation Structure

**Read these in order based on your needs:**

### 🧠 Understanding the System
- **[BUSINESS_LOGIC.md](DOCUMENTATION/BUSINESS_LOGIC.md)** — How Warhammer data relates (Races → Careers → Talents → Equipment)
- **[DATA_STRUCTURE_XML.md](DOCUMENTATION/DATA_STRUCTURE_XML.md)** — Complete XML tree (all DATA_* sections)

### ✅ Phase Progress
- **[PHASE_1_AFFICHAGE_COMPLETE.md](DOCUMENTATION/PHASE_1_AFFICHAGE_COMPLETE.md)** — What's done, fixes applied, testing notes
- **[PHASE_2_EDITION_TODO.md](DOCUMENTATION/PHASE_2_EDITION_TODO.md)** — Add/Modify/Delete implementation plan
- **[PHASE_2.5_UI_ENHANCEMENTS_TODO.md](DOCUMENTATION/PHASE_2.5_UI_ENHANCEMENTS_TODO.md)** — Menu + Pretty TreeView plan

---

## 🗂️ Project Files

```
Warhammer/
├─ CONTEXT.md (this file - overview)
├─ DOCUMENTATION/
│  ├─ BUSINESS_LOGIC.md
│  ├─ DATA_STRUCTURE_XML.md
│  ├─ PHASE_1_AFFICHAGE_COMPLETE.md
│  ├─ PHASE_2_EDITION_TODO.md
│  └─ PHASE_2.5_UI_ENHANCEMENTS_TODO.md
│
├─ winlivre.pas (main unit)
├─ winlivre.lfm (form layout)
│
└─ DATABASE/
   ├─ BOOK RULESBOOK.Xml (base)
   └─ ... (15+ books with extensions)
```

---

## ⚡ Quick Navigation

**Starting a new session?**
1. Read this CONTEXT.md (you are here!)
2. Based on what you want to do:
   - Understanding data? → BUSINESS_LOGIC.md
   - Technical details? → DATA_STRUCTURE_XML.md
   - Checking Phase 1? → PHASE_1_AFFICHAGE_COMPLETE.md
   - Implementing Phase 2? → PHASE_2_EDITION_TODO.md
   - UI improvements? → PHASE_2.5_UI_ENHANCEMENTS_TODO.md

**Coding tips:**
- `winlivre.pas` — Main logic (ChargerXMLFile, TreeView handlers, etc.)
- `winlivre.lfm` — Form layout (PanelTopButtons, TreeView, form controls)
- `DATABASE/` — All XML books (use for testing/data loading)

---

## 🔄 Current Implementation Status

### ✅ Completed
- Phase 1: TreeView display with Races + Careers
- Clean UI layout (PanelTopButtons fix)
- XML loading and parsing
- Race details display (Code, Libelle, Description)

### ➡️ In Progress / TODO
- Phase 2: Edit functionality (Add/Modify/Delete)
- Phase 2.5: UI enhancements (Menu + Pretty names)
- Phase 3+: Other data types (Talents, Skills, Weapons, Armor)

---

## 🚀 Next Steps

1. **Read relevant documentation** based on current task
2. **Update code** in winlivre.pas/winlivre.lfm
3. **Test locally** with Lazarus (Ctrl+F9 compile, F9 run)
4. **Commit to GitHub** with meaningful message
5. **Update CONTEXT.md** if major changes

---

**For detailed information, see the DOCUMENTATION/ folder →** 📚
