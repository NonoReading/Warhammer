# 📚 DOCUMENTATION INDEX

**WinLivre v2.0.0 - Warhammer Fantasy V4 XML Editor**

---

## 🗺️ Navigation Map

### For Understanding the System
1. **Start here:** [CONTEXT.md](../CONTEXT.md) - Overview & quick start
2. **Deep dive:** [BUSINESS_LOGIC.md](BUSINESS_LOGIC.md) - How Warhammer data relates
3. **Technical:** [DATA_STRUCTURE_XML.md](DATA_STRUCTURE_XML.md) - XML file structure

### By Development Phase
1. **[PHASE_1_AFFICHAGE_COMPLETE.md](PHASE_1_AFFICHAGE_COMPLETE.md)** ✅ **DONE**
   - TreeView display with Races + Careers
   - XML loading
   - Data display (READ-ONLY)

2. **[PHASE_2_EDITION_TODO.md](PHASE_2_EDITION_TODO.md)** ⏳ **TODO**
   - Add/Modify/Delete functionality
   - XML persistence
   - Form validation

3. **[PHASE_2.5_UI_ENHANCEMENTS_TODO.md](PHASE_2.5_UI_ENHANCEMENTS_TODO.md)** ⏳ **TODO**
   - Menu for quick book loading
   - Pretty TreeView names (using DATA_LABEL)
   - Code caching system

---

## 📖 Document Purposes

| Document | Purpose | Read When |
|----------|---------|-----------|
| CONTEXT.md | Overview + links | Starting new session |
| BUSINESS_LOGIC.md | Data relationships | Understanding game rules |
| DATA_STRUCTURE_XML.md | Technical XML details | Debugging, extending code |
| PHASE_1_*.md | What's implemented | Reviewing completed work |
| PHASE_2_*.md | What to implement next | Starting Phase 2 coding |
| PHASE_2.5_*.md | UI enhancements | UI improvements |

---

## 🔍 Quick Search

**Looking for...**

- **How do careers work?** → BUSINESS_LOGIC.md § Career Progression
- **What's in the XML?** → DATA_STRUCTURE_XML.md § Complete Data Sections
- **How to add/edit data?** → PHASE_2_EDITION_TODO.md
- **How to load books?** → PHASE_2.5_UI_ENHANCEMENTS_TODO.md § Enhancement 1
- **Pretty TreeView names?** → PHASE_2.5_UI_ENHANCEMENTS_TODO.md § Enhancement 2
- **What's a Talent?** → BUSINESS_LOGIC.md § Talents
- **Attribute system?** → BUSINESS_LOGIC.md § Foundation
- **Skills in Warhammer?** → BUSINESS_LOGIC.md § Skills

---

## 📋 File Structure

```
Warhammer/
├─ CONTEXT.md (START HERE)
├─ DOCUMENTATION/
│  ├─ INDEX.md (this file)
│  ├─ BUSINESS_LOGIC.md (understand system)
│  ├─ DATA_STRUCTURE_XML.md (technical details)
│  ├─ PHASE_1_AFFICHAGE_COMPLETE.md (✅ done)
│  ├─ PHASE_2_EDITION_TODO.md (⏳ next)
│  └─ PHASE_2.5_UI_ENHANCEMENTS_TODO.md (⏳ enhancements)
├─ winlivre.pas (main code)
├─ winlivre.lfm (form layout)
└─ DATABASE/ (XML files)
```

---

## 🚀 Typical Workflows

### Session 1: Learning the System
1. Read CONTEXT.md
2. Read BUSINESS_LOGIC.md (understand races, careers, talents)
3. Skim DATA_STRUCTURE_XML.md (see what's available)
4. Look at PHASE_1_AFFICHAGE_COMPLETE.md (see what's done)

### Session 2: Implementing Phase 2
1. Quick re-read CONTEXT.md (refresh)
2. Open PHASE_2_EDITION_TODO.md
3. Implement Task by Task
4. Test each function

### Session 3: UI Improvements
1. Read PHASE_2.5_UI_ENHANCEMENTS_TODO.md
2. Implement Enhancement 1 (Menu)
3. Implement Enhancement 2 (Pretty names)
4. Test thoroughly

---

## 📞 Need Help?

- **Understanding Warhammer rules?** → BUSINESS_LOGIC.md
- **Finding XML elements?** → DATA_STRUCTURE_XML.md
- **Questions about code structure?** → PHASE_1_AFFICHAGE_COMPLETE.md
- **Stuck on Phase 2?** → PHASE_2_EDITION_TODO.md (has pseudo-code examples)
- **Want to make UI better?** → PHASE_2.5_UI_ENHANCEMENTS_TODO.md

---

## ✅ Status Overview

| Phase | Status | Priority | Notes |
|-------|--------|----------|-------|
| Phase 1 | ✅ COMPLETE | — | TreeView display working |
| Phase 2 | ⏳ TODO | HIGH | CRUD operations needed |
| Phase 2.5 | ⏳ TODO | MEDIUM | UI polish |
| Phase 3 | ⏰ FUTURE | LOW | Support more data types |

---

**This documentation helps you navigate the entire project!** 🗺️
