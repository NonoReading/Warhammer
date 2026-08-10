# Chantier — Versionning des éléments entre livres

**Conception arrêtée le 10/08/2026. Non démarré.**
À relire au lancement du chantier.

---

## 1. Le besoin

Certains éléments du *Livre de Règles* ont une version révisée dans un supplément
(*Up in Arms*, *Winds of Magic*, *Sea of Claws*…). Exemple : `RULES-COMPATL` a une
variante `UPINA-COMPATL`.

Deux objectifs distincts :

1. **Corriger un bug latent** — au changement de métier, une compétence possédée sous
   un livre n'est pas reconnue comme étant celle demandée par le nouveau métier sous
   un autre livre → doublon.
2. **Ajouter une fonctionnalité** — un bouton dans WinPersonnage : « mettre à jour les
   éléments par rapport à un livre », qui liste ce qui est remplaçable et laisse le
   joueur cocher.

Périmètre : **compétences, talents, équipements, sorts**.
Exclus : **race et métier** — trop structurants (niveaux, XP investi, progression).

---

## 2. Le contexte qui rend le problème réel

Un personnage est **hétérogène par nature** :

- race d'un livre, métier d'un autre
- changement de métier en cours de partie vers un troisième livre
- la majorité des données restent `RULES-`, les suppléments sont minoritaires

La progression elle-même est à l'abri : depuis 08/2026, `Personnage.MetierCompetence` et
`Personnage.MetierTalent` sont des instantanés pris à `NvNiveau = 1`, et le livre n'est
plus relu ensuite.

**Le seul moment où les deux mondes se rencontrent est le changement de métier**, où
`ListMetierCompetence` est relue et `MajTables` compare à ce que le personnage possède.
`VerifieRecherche` faisant une égalité stricte sur `(Livre, Code)`, la comparaison échoue
et la branche `if not trouve` crée une seconde ligne.

⚠️ **À vérifier avant toute chose** : ce doublon est une hypothèse, pas un fait constaté.
Test : prendre un personnage avec des compétences `RULES-`, lui faire prendre un métier
`UPINA-` qui reprend l'une d'elles, regarder si `TabCompetence` affiche une ou deux lignes.

- une seule ligne → `MajTables` gère déjà, le chantier se réduit à la commodité d'affichage
- deux lignes → traiter le bug **avant** la fonctionnalité, sinon le bouton ne fera
  qu'ajouter une façon de plus de créer des doublons

---

## 3. Solutions envisagées

### 3.1 Comparaison sur le code nu (écartée)

Une fonction `MemeElement(Code1, Code2)` qui découpe sur `SeparateurLivre` et ne compare
que la partie droite. `RULES-COMPATL` = `UPINA-COMPATL`.

- ✅ zéro modification des données
- ❌ ne gère pas le cas où le supplément **renomme** l'élément
  (`UPINA-COMPMELEE` révisant `RULES-COMPATL` serait invisible)
- ❌ faux positifs possibles si deux livres réutilisent un code pour autre chose

Reste utilisable comme repli, mais insuffisante seule.

### 3.2 Conversion déclarée dans l'entrée d'origine (écartée)

`RULES-COMPATL` déclarerait « je deviens `UPINA-COMPATL` ».

- ❌ **mauvaise direction de dépendance** : le livre de base devrait être modifié à
  chaque parution d'un supplément
- ❌ avec trois variantes, trois conversions à maintenir au même endroit

### 3.3 Champ `Variante` sur chaque entrée ✅ **RETENUE**

Chaque entrée déclare sa racine :

| Code | `Variante` |
|---|---|
| `RULES-COMPATL` | *(absent)* → implicitement lui-même |
| `UPINA-COMPATL` | `RULES-COMPATL` |
| `UPINA-COMPMELEE` (renommage) | `RULES-COMPATL` |

**Règles :**

- champ **absent ⇒ variante = le code lui-même**. Seules les entrées effectivement
  variantes sont renseignées → les XML restent lisibles, une variante se repère d'un
  coup d'œil, et peu à défaire si le mécanisme change.
- `Variante` désigne **toujours la racine, jamais un intermédiaire**. Un troisième livre
  révisant `UPINA-COMPATL` pointe vers `RULES-COMPATL`. Évite de remonter une chaîne et
  tout risque de cycle.
- deux entrées sont « la même chose » si elles partagent la même racine.

**Avantages :** local (ajouter un supplément ne touche que son fichier), supporte le
renommage, uniforme.

**Coût :** un champ dans `StructureCompetence`, `StructureTalent`, `StructureArme`,
`StructureArmure`, `StructureSort` + les `Charge*` correspondants. Mécanique, réparti
sur cinq unités.

L'export XML est jugé peu coûteux : volume de données négligeable, et l'outillage existe
déjà (script Python de normalisation des préfixes — 13 fichiers, 129 lignes, sans
difficulté).

---

## 4. Ordre de travail

0. **Vérifier l'hypothèse du doublon** (§2) — quinze minutes, conditionne la suite
1. **Inventaire des correspondances** — quelles entrées des suppléments sont réellement
   des révisions ? Travail de données, non déductible des fichiers : demande de comparer
   les livres. **C'est l'étape qui conditionne tout le reste.**
2. **Champ `Variante`** dans les structures et les `Charge*`
3. **`MajTables`** — reconnaître qu'une compétence du nouveau métier est déjà possédée
   sous une autre variante *(correctif de bug)*
4. **Bouton de mise à jour** dans WinPersonnage — fenêtre modale sur le modèle de
   `TWinSpecialisations` : choisir un livre, afficher les éléments remplaçables, cocher
   *(fonctionnalité)*

⚠️ L'ordre 3 avant 4 n'est pas négociable.

---

## 5. Points ouverts

- **Granularité** : la mise à jour est-elle globale au personnage, ou élément par
  élément ? (le joueur peut vouloir Up in Arms pour les armes et rester sur les règles
  de base pour les compétences)
- **Historique** : si de l'XP a été investi dans `RULES-COMPATL`, la progression suit-elle
  la bascule ? Elle le devrait → réécriture dans `CHAPTER_SKILL` **et** dans
  `Personnage.MetierCompetence`, donc les blocs corrigés en 08/2026.
- **Réversibilité** : le MJ peut changer d'avis, comme pour les talents à la création.
- **`SeparateurLivre` est surchargé** : `-` sert aussi aux intervalles de
  `DATA_RANDOM_TALENT` (« 19-21 »). Pas de collision réelle (contextes différents), mais
  à garder en tête. Tout découpage doit se faire sur le **premier** séparateur seulement.
