# ⚡ QUICK START - Tester en 2 minutes

## 🚀 Démarrage rapide

### Étape 1: Remplacer le fichier
```
1. Backup ton winlivre.pas actuel
2. Remplace par le nouveau winlivre.pas
```

### Étape 2: Compiler
```
Lazarus → Run → Compile (Ctrl+F9)
```

### Étape 3: Tester
```
1. Lance l'application
2. Ouvre le XML
3. Clique sur une race (ex: "Humans (Reikland)")
4. Clique sur "Career" (la branche)
5. ✅ Tu vois un tableau avec tous les métiers!
```

---

## 🎯 Ce que tu verras

```
┌─────────────────────────────────────────────────────────────┐
│ Code           │ Libellé          │ Livre          │ Sél │  V│
├─────────────────┼──────────────────┼────────────────┼─────┼───┤
│ RULES-WORK01    │ Agitator         │ Core Rules...  │  ✓  │ 01│
│ RULES-WORK02    │ Engineer         │ Core Rules...  │  ✓  │ 02│
│ RULES-WORK03    │ Lawyer           │ Core Rules...  │     │   │
│ ...             │ ...              │ ...            │ ... │...│
│ ARCH3-WORK99    │ Pit Fighter      │ Archives 3 ... │  ✓  │ 15│
│ DEATH-WORK105   │ Cursed Wanderer  │ Death ...      │  ✓  │ 38│
│ ENEMY-WORK106   │ Enemy Agent      │ Enemy ...      │     │   │
└─────────────────┴──────────────────┴────────────────┴─────┴───┘
```

### Légende
- **Code**: Référence unique (caché visuellement)
- **Libellé**: Nom du métier (ex: "Agitator")
- **Livre**: Source traduite (ex: "Core Rules Book")
- **Sél**: ✓ si le métier est assigné à la race
- **V**: Valeur du XML (ex: "01" = première page)

---

## 🔍 Où aller en cas de problème

| Problème | Solution | Lire |
|----------|----------|------|
| Pas de colonne "Career" | Compiler ou mettre à jour | SESSION_FINALE_RESUME.md |
| Clique Career mais rien | Vérifier LoadCareersForRace | PHASE2_AFFICHAGE_CAREERS.md |
| Métiers ne s'affichent pas | Vérifier ListMetier chargée | PHASE2_AFFICHAGE_CAREERS.md |
| Livres pas traduits | Vérifier GetTexteLibelle | CORRECTION_NONO.md |

---

## ✅ Checklist avant utilisation

- [ ] Fichier winlivre.pas remplacé
- [ ] Compilation réussie (pas d'erreurs)
- [ ] XML peut être ouvert
- [ ] Race peut être sélectionnée
- [ ] Branche "Career" s'affiche
- [ ] Clic sur "Career" affiche le grid
- [ ] Grid affiche tous les métiers
- [ ] Les métiers de la race ont ✓

---

## 💡 Résumé des changements

### Ajoutés
- ✅ Variable `RaceCareersData: TStringList`
- ✅ Procédure `LoadCareersForRace()`
- ✅ Procédure `AfficherCareersForRace()`
- ✅ Cas 9 dans TreeViewLivreChange()

### Modifiés
- ✅ TreeViewLivreChange - Cas 9 enrichi
- ✅ FormCreate - Init RaceCareersData
- ✅ Déclarations - 2 nouvelles procédures

### Fichiers
- ✅ Seul winlivre.pas modifié
- ❌ lfm inchangé
- ❌ XML de référence inchangé

---

## 🎮 Interaction utilisateur

**Avant cette session:**
```
Clique "Career"
  → Rien (masque juste le form)
```

**Après cette session:**
```
Clique "Career"
  → StringGrid avec tous les métiers
  → ✓ pour les métiers de la race
  → Valeurs affichées
  → Livres traduits
```

---

## 🚀 Prochaine étape (Phase 3)

**Édition interactive:**
- Double-clic sur métier → toggle sélection
- Double-clic sur valeur → éditer
- Bouton Valider → sauvegarder
- Bouton Annuler → rejeter

*Même pattern que pour les compétences!*

---

## 🎯 Fichiers de documentation

1. **SESSION_FINALE_RESUME.md** ← Lire d'abord!
2. **PHASE2_AFFICHAGE_CAREERS.md** ← Détails techniques
3. **CORRECTION_NONO.md** ← i18n et livres
4. **INDEX.md** ← Navigation complète

---

## ⚠️ Attention

- Ne pas modifier `BOOK RULESBOOK.Xml`
- `ChargeMetier.pas` doit exister
- `ChargeLivre.pas` doit exister
- `ListMetier` doit être chargé au démarrage
- `ListLivre` doit être chargé au démarrage

---

**C'est prêt! Compile et profite!** 🎉

**Des questions? Lis SESSION_FINALE_RESUME.md** 📖
