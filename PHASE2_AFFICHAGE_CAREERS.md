# 🎯 AfficherCareersForRace() - Phase 2 ÉDITION

## Objectif

Afficher un **tableau (StringGrid)** avec tous les métiers quand on clique sur la branche "Career" d'une race.

---

## 📊 Structure du tableau

### En-têtes (Ligne 0)
```
Col 0: Code         (caché en affichage)
Col 1: Libellé      (nom du métier)
Col 2: Livre        (nom du livre, traduit)
Col 3: Sélectionné  (✓ si métier sélectionné pour la race)
Col 4: Valeur       (le "38" du XML)
```

### Données (Lignes 1 à N)
- **Une ligne par métier** de `ListMetier`
- Total: `ListMetier.Count` lignes

---

## 🔧 Procédures créées/modifiées

### 1️⃣ LoadCareersForRace(RaceElement)
**Rôle:** Charger les carrières de la race depuis le XML

**Fonctionnement:**
```pascal
// Cherche <SUBCHAPTER_CAREER>
// Pour chaque <Career name="CODE">"VALUE"</Career>
//   Ajoute "CODE|VALUE" dans RaceCareersData
```

**Stockage:** `RaceCareersData: TStringList`
- Format: `"CODE|Valeur"`
- Ex: `"RULES-WORK01|01"`, `"RULES-WORK02|02"`

### 2️⃣ AfficherCareersForRace(RaceCode: String)
**Rôle:** Afficher le grid avec tous les métiers

**Fonctionnement:**
```
1. Chercher l'élément <Specie id="RaceCode"> dans XMLDoc
2. Appeler LoadCareersForRace() pour remplir RaceCareersData
3. Créer StringGrid avec 5 colonnes
4. Pour chaque métier de ListMetier:
   ├─ Col 0: Code
   ├─ Col 1: Libellé (de ListMetier)
   ├─ Col 2: Livre traduit (chercher via ChercheLivreLibelle)
   ├─ Col 3: ✓ si trouvé dans RaceCareersData
   └─ Col 4: Valeur associée
```

### 3️⃣ TreeViewLivreChange() - Cas 9
**Rôle:** Intercepter le clic sur la branche "Career"

**Logique:**
```pascal
case 9:  // Branche "Career"
  ├─ Récupérer le code de la race parent
  └─ Appeler AfficherCareersForRace(RaceCode)
```

---

## 📝 Exemple - Humans (Reikland)

### XML
```xml
<Specie id="RULES-RACE_HUM">
  <SUBCHAPTER_CAREER>
    <Career name="RULES-WORK01">"01"</Career>
    <Career name="RULES-WORK02">"02"</Career>
    <Career name="ARCH3-WORK99">"15"</Career>
    ...
  </SUBCHAPTER_CAREER>
</Specie>
```

### Affichage StringGrid
```
Code           │ Libellé         │ Livre          │ Sélectionné │ Valeur
────────────────┼─────────────────┼────────────────┼─────────────┼────────
RULES-WORK01    │ Agitator        │ Core Rules Book│     ✓       │ 01
RULES-WORK02    │ Engineer        │ Core Rules Book│     ✓       │ 02
RULES-WORK03    │ Lawyer          │ Core Rules Book│             │
...
ARCH3-WORK99    │ Pit Fighter     │ Archives 3     │     ✓       │ 15
...
DWARVES-WORK01  │ Dwarf Warrior   │ Core Rules Book│             │
```

---

## 🔗 Flux de données complet

```
TreeView: Clic sur "Career" (nœud 9)
    ↓
TreeViewLivreChange() - Cas 9
    ├─ Récupère RaceCodeFound ("RULES-RACE_HUM")
    └─ Appelle AfficherCareersForRace("RULES-RACE_HUM")
        ↓
    AfficherCareersForRace()
        ├─ Cherche <Specie id="RULES-RACE_HUM"> dans XMLDoc
        └─ Appelle LoadCareersForRace(RaceElement)
            ├─ Cherche <SUBCHAPTER_CAREER>
            ├─ RaceCareersData.Add("RULES-WORK01|01")
            ├─ RaceCareersData.Add("RULES-WORK02|02")
            └─ RaceCareersData.Add("ARCH3-WORK99|15")
                ↓
        Remplit StringGrid:
            ├─ Boucle sur ListMetier (TOUS les métiers)
            ├─ Pour chaque métier:
            │  ├─ Affiche Libellé
            │  ├─ Cherche Livre via ChercheLivreLibelle()
            │  ├─ Cherche dans RaceCareersData
            │  │  └─ Si trouvé → Col 3: ✓  Col 4: Valeur
            │  │  └─ Sinon   → Col 3: ""  Col 4: ""
            │  └─ Affiche la ligne
            └─ Affiche le StringGrid
```

---

## 📊 Variables globales utilisées

| Variable | Type | Rôle |
|----------|------|------|
| `RaceCareersData` | `TStringList` | Stocke Code\|Valeur des carrières sélectionnées |
| `ListMetier` | `TListMetier` | Tous les métiers chargés au démarrage |
| `XMLDoc` | `TXMLDocument` | Document XML chargé |

---

## 🧪 Test

### Procédure
1. Ouvre le XML
2. Sélectionne une race (ex: Humans)
3. Clique sur "Career" (la branche)
4. ✅ Tu vois le StringGrid avec:
   - Tous les métiers
   - Les métiers de la race marqués avec ✓
   - Les valeurs associées affichées

### Cas de test

**Test 1: Métiers RULES**
```
RULES-WORK01 (Agitator) - ✓ - 01
RULES-WORK02 (Engineer) - ✓ - 02
```

**Test 2: Métiers mixtes**
```
RULES-WORK50 (Soldier) - ✓ - 50
ARCH3-WORK99 (Pit Fighter) - ✓ - 15
DEATH-WORK105 (Cursed Wanderer) - ✓ - 38
```

**Test 3: Métiers non sélectionnés**
```
RULES-WORK03 (Lawyer) - [] - (vide)
RULES-WORK99 (Alchemist) - [] - (vide)
```

---

## 📌 Architecture - Code Node.Data

```
TreeView structure:
  Root (0)
    └─ Specie (1)
        ├─ Attributes (0)
        ├─ Skills (3)
        ├─ Talents (5)
        └─ Career (9) ← On clique ici
              ├─ Agitator (13)
              ├─ Engineer (13)
              └─ ...
```

---

## 🚀 Phase 3 TODO - ÉDITION interactive

Actuellement: **AFFICHAGE SEUL** (lecture)

À ajouter (Phase 3):
- [ ] Rendre Col 3 interactive (clic = toggle sélection)
- [ ] Rendre Col 4 éditable (saisir nouvelle valeur)
- [ ] Bouton "Valider" pour sauvegarder dans XML
- [ ] Bouton "Annuler" pour rejeter les modifications

---

## 💡 Avantages de cette approche

✅ **Affichage complet** - Tous les métiers visibles d'un coup
✅ **Traçabilité** - Voir pour chaque métier s'il est sélectionné
✅ **Valeurs visibles** - Voir le "38" (dés ou autre) directement
✅ **Livre traduit** - Savoir d'où vient chaque métier
✅ **Prêt pour édition** - Structure idéale pour Phase 3

---

## 🔍 Dépannage

### Q: Le grid affiche mais pas de ✓?
**R:** Vérifie que LoadCareersForRace() charge bien les carrières
- Debug: Affiche RaceCareersData.Count et son contenu

### Q: Tous les métiers affichent ✓?
**R:** LoadCareersForRace() charge peut-être plusieurs fois
- Appelle RaceCareersData.Clear() avant le chargement

### Q: Les livres ne s'affichent pas traduits?
**R:** Vérifie que GetTexteLibelle() retourne une traduction
- Fallback affiche le code du livre

---

## 📌 Points importants

✅ `RaceCareersData` utilise format "CODE|Valeur" (avec pipe)
✅ Chercher via `Pos(CodeMetier + '|', ...)` pour trouver exact
✅ Tous les métiers affichés, pas juste les sélectionnés
✅ Valeur récupérée du XML (pas calculée)

---

**Phase 2 AFFICHAGE: ✅ TERMINÉE**

**Prochaine: Phase 3 ÉDITION INTERACTIVE**
