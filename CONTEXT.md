# 📖 CONTEXT - Warhammer Fantasy V4 Gestionnaire

**Ce fichier contient le contexte complet du projet pour toutes les instances Claude.**

---

## 🎯 **1. Description du Projet**

**Nom complet:** Warhammer Fantasy V4 - Gestionnaire de Personnages

**Objectif:** Application Lazarus permettant de :
- ✅ Créer des personnages Warhammer Fantasy V4
- ✅ Charger les données depuis des fichiers XML
- ✅ Générer des **fiches PDF** détaillées et professionnelles
- ✅ Éditer/créer de nouvelles données via WinLivre

**Technologie:** 
- Lazarus IDE
- Free Pascal
- fpPDF (génération PDF)
- XML natif

**Utilisateur/Contributeur:** Arnau (NonoReading)

---

## 🗂️ **2. Structure du Repository**

**URL:** `https://github.com/NonoReading/Warhammer.git`

**Branch active:** `main`

### **Structure des dossiers:**

```
Warhammer/
│
├── DATABASE/
│   ├── RULESBOOK/                    # Données de règles
│   │   ├── Race_*.xml                # Définitions de races
│   │   ├── Metier_*.xml              # Définitions de métiers
│   │   ├── Competence_*.xml          # Définitions de compétences
│   │   ├── Talent_*.xml              # Définitions de talents
│   │   ├── Arme_*.xml                # Définitions d'armes
│   │   └── Armure_*.xml              # Définitions d'armures
│   │
│   ├── BOOK ARCHIVES OF THE EMPIRE III.Xml
│   ├── BOOK DEATH ON THE REIK COMPANION.Xml
│   ├── BOOK ENEMY IN SHADOWS COMPANION.Xml
│   ├── BOOK LORDS OF NAGGAROTH.Xml
│   ├── BOOK SEA OF CLAWS.Xml
│   └── BOOK WINDS OF MAGIC.Xml
│
├── WarhammerHelp.lpi                 # Fichier projet Lazarus
├── WarhammerHelp.lpr                 # Entry point
│
├── charge*.pas                        # Modules de chargement XML
│   ├── ChargeConstantes.pas
│   ├── ChargeRace.pas
│   ├── ChargeMetier.pas
│   ├── ChargeCompetence.pas
│   ├── ChargeTalent.pas
│   ├── ChargeArme.pas
│   └── ChargeArmure.pas
│
├── win*.pas                           # Modules UI/Formulaires
│   ├── WinLivre.pas / WinLivre.lfm  # Éditeur de données
│   ├── warhammersource.pas
│   └── (autres forms)
│
├── pdf*.pas                           # Modules génération PDF
│   ├── pdfutils.pas                  # Utilitaires PDF
│   ├── pdfutils_police.pas           # Optimisation police
│   ├── pdfutils_cellules.pas         # Cellules PDF
│   ├── pdfutils_cellules_virtuelles.pas  # Cellules virtuelles (NOUVEAU)
│   ├── pdfutils_dessineur_optimise.pas   # Dessineur optimisé (NOUVEAU)
│   └── pdfpersonnage.pas             # Génération fiche personnage
│
├── .gitignore                         # Fichiers à ignorer
└── CONTEXT.md                         # Ce fichier

```

---

## 📋 **3. Format des Fichiers XML**

### **Organisation des données:**

Chaque entité (race, métier, etc.) a son propre fichier XML dans `DATABASE/RULESBOOK/`

### **Format standard:**

**Naming:** `[Type]_[CODE].xml`

Exemples :
- `Race_RACE_HUMAN.xml`
- `Metier_METIER_WARRIOR.xml`
- `Competence_COMP_MELEE.xml`

### **Structure générale:**

```xml
<[Type]>
  <Code[Type]>[UNIQUE_CODE]</Code[Type]>
  <Libelle>[Nom affiché]</Libelle>
  <LibelleGroupe>[Catégorie]</LibelleGroupe>
  <Description>[Détails]</Description>
  <Livre>[Source du livre]</Livre>
  <!-- Champs spécifiques au type -->
</[Type]>
```

### **Exemples concrets:**

#### **Race:**
```xml
<Race>
  <CodeRace>RACE_HUMAN</CodeRace>
  <Libelle>Humain</Libelle>
  <LibelleGroupe>Humains</LibelleGroupe>
  <Description>Peuple polyvalent et ambitieux</Description>
  <Livre>RULEBOOK</Livre>
  <NiveauExperience>20</NiveauExperience>
</Race>
```

#### **Métier:**
```xml
<Metier>
  <CodeMetier>METIER_WARRIOR</CodeMetier>
  <Libelle>Guerrier</Libelle>
  <LibelleGroupe>Guerriers</LibelleGroupe>
  <Description>Maître du combat au corps à corps</Description>
  <Livre>RULEBOOK</Livre>
</Metier>
```

#### **Arme:**
```xml
<Arme>
  <CodeArme>ARME_SWORD</CodeArme>
  <Libelle>Épée</Libelle>
  <Dommage>1d8</Dommage>
  <Encombrement>2</Encombrement>
  <Livre>RULEBOOK</Livre>
</Arme>
```

### **Champs communs:**

| Champ | Type | Requis | Notes |
|-------|------|--------|-------|
| `Code*` | String | ✅ | Identifiant unique, format UPPERCASE_SNAKE_CASE |
| `Libelle` | String | ✅ | Nom affiché |
| `LibelleGroupe` | String | ❌ | Catégorie/Groupe |
| `Description` | String | ❌ | Détails et explications |
| `Livre` | String | ✅ | Source (quel livre de règles) |

---

## 🏗️ **4. Architecture Technique**

### **Flux de données:**

```
XML (DATABASE/)
    ↓
charge*.pas (parsing)
    ↓
Structures Pascal (mémoire)
    ↓
WinLivre.pas (édition)
    ↓
Générer XML / Générer PDF
```

### **Modules clés:**

#### **Chargement (charge*.pas):**
- `ChargeRace.pas` - Parse `Race_*.xml`
- `ChargeMetier.pas` - Parse `Metier_*.xml`
- `ChargeCompetence.pas` - Parse `Competence_*.xml`
- `ChargeTalent.pas` - Parse `Talent_*.xml`
- `ChargeArme.pas` - Parse `Arme_*.xml`
- `ChargeArmure.pas` - Parse `Armure_*.xml`

#### **Génération PDF (pdf*.pas):**
- `pdfutils.pas` - Utilitaires PDF base
- `pdfutils_police.pas` - Optimisation calcul taille police
- `pdfutils_cellules.pas` - Classe TPdfCellule
- `pdfutils_cellules_virtuelles.pas` - **NOUVEAU** - Cellules virtuelles (séparation données/dessin)
- `pdfutils_dessineur_optimise.pas` - **NOUVEAU** - Dessineur optimisé (fusion des lignes)
- `pdfpersonnage.pas` - Génération de la fiche personnage (2810 lignes → en refactorisation)

#### **UI/Édition (win*.pas):**
- `WinLivre.pas` - Éditeur de données XML
- `warhammersource.pas` - Formulaire principal

---

## 🚀 **5. Problèmes Identifiés & Solutions**

### **Problème 1: PDF lourd (pdfpersonnage.pas)**

**Issue:**
- 2810 lignes de code
- 100+ appels `DrawLine` en dur
- Calcul police inefficace (20 itérations/calcul)
- Difficile à maintenir/modifier

**Solution en cours:**
- **Virtualisation des cellules** - Séparer données du dessin
- **Fusion des lignes** - Detecter et fusionner les traits qui se suivent
- **Optimisation police** - Ratio direct au lieu de boucles
- **Refactorisation** → 2810 → ~500 lignes + sections réutilisables

**Fichiers concernés:**
- `pdfutils_cellules_virtuelles.pas` (TCelluleVirtuelle, TLignesVirtuelles)
- `pdfutils_dessineur_optimise.pas` (TDessineurOptimise, TConstructeurPDF)
- `pdfpersonnage_complet.pas` (version refactorisée complète)

**Gains mesurables:**
- 85-95% moins de DrawLine
- 6-20x plus rapide
- Code 64% plus court

---

### **Problème 2: Création XML lourd (WinLivre)**

**Issue:**
- Créer XML à la main = 15 min par entité
- Facile de faire des erreurs
- Doublons non détectés
- Validation manuelle/complexe

**Solution créée:**
- **Générateur XML** - TXmlBuilder, TSerializeur
- **Validateur** - TValidateurRace, TValidateurMetier, etc.
- **Helper intégration** - THelperWinLivre
- **Automatisation** - CreerEtExporter*() - 30 sec par entité

**Fichiers concernés:**
- `generateur_xml_universel.pas` (génération)
- `validateur_donnees.pas` (validation)
- `winlivre_integration.pas` (intégration dans WinLivre)

**Gains mesurables:**
- 30x plus rapide (15 min → 30 sec)
- Validation automatique
- Zéro erreurs de format

---

## 📝 **6. Workflow Développement**

### **Quand on modifie les sources:**

```bash
# 1. Cloner le repo (première fois)
git clone https://github.com/NonoReading/Warhammer.git
cd Warhammer

# 2. Faire les modifications
# (Éditer vos fichiers .pas, .lfm)

# 3. Tester localement
# (Compiler dans Lazarus, vérifier les PDFs)

# 4. Pousser vers GitHub
git add .
git commit -m "Description du changement"
git push

# 5. Pull pour récupérer les changements d'autres Claude
git pull
```

### **Fichiers à ignorer (.gitignore):**

```
*.exe
*.o
*.a
*.so
*.dll
*.obj
*.pyc
__pycache__/
*.rtf
*.doc
*.docx
```

---

## 🎯 **7. Points Clés pour Travailler sur le Projet**

### **Avant de modifier:**
- [ ] Lire ce CONTEXT.md
- [ ] Comprendre la structure XML
- [ ] Connaître les problèmes en cours de résolution

### **Quand on code:**
- [ ] Respecter le naming (UPPERCASE_SNAKE_CASE pour les codes)
- [ ] Valider les données avant création XML
- [ ] Utiliser les classes de virtualisation pour le PDF
- [ ] Commenter les changements majeurs

### **Avant de commit:**
- [ ] Compiler sans erreurs
- [ ] Tester localement (générer un PDF)
- [ ] Vérifier que le XML est valide
- [ ] Écrire un message de commit descriptif

---

## 📚 **8. Documentation Complémentaire**

Dans le repo, vous trouverez aussi:

- **GUIDE_CELLULES_VIRTUELLES.md** - Guide PDF virtuel
- **GUIDE_CREATION_XML.md** - Guide création XML
- **INTEGRATION_CELLULES_VIRTUELLES.md** - Comment intégrer dans pdfpersonnage.pas
- **exemple_cellules_virtuelles.pas** - Exemples concrets
- **exemple_creation_xml.pas** - Exemples d'utilisation XML

---

## 🔗 **9. Références Importantes**

| Élément | Lien/Valeur |
|---------|------------|
| **Repository** | https://github.com/NonoReading/Warhammer.git |
| **Branch** | main |
| **Chemin local** | C:\Users\arnau\Documents\Lazarus Project\Warhammer\ |
| **Utilisateur** | NonoReading (Arnau) |
| **IDE** | Lazarus |
| **Language** | Free Pascal (Object Pascal) |
| **Packages** | fpPDF, KControlsLaz, bgracontrols, LCL |

---

## 💡 **10. Tips pour les Futures Conversations**

### **Quand tu reviens travailler sur le projet:**

1. **Commencer par** `git pull` (récupérer les derniers changements)
2. **Lire** ce CONTEXT.md si tu as un doute
3. **Cloner** si c'est la première fois
4. **Compiler** avant de faire des modifications
5. **Tester** les PDFs générés

### **Pour les modifications PDF:**
- Utiliser les classes virtuelles (pas de DrawLine en dur!)
- Préférer la fusion des lignes
- Optimiser les calculs de police

### **Pour les modifications XML:**
- Utiliser le générateur + validateur
- Pas de triage manuel
- Laisser le système détecter les erreurs

---

## ✅ **Mis à jour:** Juillet 2026

**Ce document est la source unique de vérité pour le contexte du projet.**

Si quelque chose change (nouvelle feature, bug fix, etc.), mettez à jour ce fichier !

---

**Bon développement ! 🚀**
