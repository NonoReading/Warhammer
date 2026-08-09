# Session du 05/08/2026 — WinPersonnage : persistance des choix de spécialisation

## Résumé

Correction du mécanisme de conservation des choix de spécialisation pour les
**compétences génériques de métier** (`RULES-COMPART_*` → `RULES-COMPART_CALLI`).
Le choix est désormais persisté correctement dans les deux chapitres du XML de
sauvegarde, quel que soit l'ordre des actions du joueur.

**État : compétences RÉSOLU / talents À FAIRE.**

---

## Le mécanisme de persistance (rappel)

`Personnage.MetierCompetence` est un **instantané** de toutes les compétences du
métier, avec leur niveau — y compris les niveaux non encore atteints.

| Rôle | Emplacement |
|---|---|
| Structure | `chargepersonnage.pas:97` |
| Écriture XML | `chargepersonnage.pas:308-318` → `CHAPTER_SKILL / SUBCHAPTER_SKILLCAREER` |
| Relecture XML | `chargepersonnage.pas:774-792` |
| Initialisation | `winpersonnage.pas:3975-3981` — **uniquement si `NvNiveau = 1`** |
| Utilisation | `winpersonnage.pas:3636` → `ChargeAugmentation` |

**Principe clé** : une fois le métier pris au niveau 1, le livre (`ListMetierCompetence`)
n'est plus jamais relu. Le tableau devient la mémoire du personnage. Il suffit donc
d'écraser le code générique par le code spécifique pour que le choix survive.

---

## Correctif appliqué

Tout se joue dans `TabAugmentationCompetenceDblClick`, branche « spécialisation »,
après le retour de `FenSpecialisation`. Trois blocs, dans cet ordre :

```pascal
// A - récupérer la valeur si la spécialisation existe déjà dans la fiche
//     sans écraser une saisie déjà faite par le joueur
for Ind := 1 to TabCompetence.RowCount - 1 do
  if TabCompetence.Cells[ColCompCode, Ind] = SelectWinCompetence then
    begin
      Value := TabCompetence.Cells[ColCompBonus, Ind];
      if TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row]
         = TabAugmentationCompetence.Cells[ColAugmCompActuel, TabAugmentationCompetence.Row] then
        TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row] := Value;
      TabAugmentationCompetence.Cells[ColAugmCompActuel, TabAugmentationCompetence.Row] := Value;
      Value := TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row];
      TabAugmentationCompetenceCalcul(TabAugmentationCompetence.Row, Value);
      break;
    end;

// B - le choix devient le code de référence de la ligne d'augmentation
TabAugmentationCompetence.Cells[ColAugmCompCode, TabAugmentationCompetence.Row] := SelectWinCompetence;

// C - propager au tableau métier (c'est LUI qui assure la persistance)
for Ind2 := 0 to High(Personnage.MetierCompetence) do
  if Personnage.MetierCompetence[Ind2].CodeCompetence = ChoixWinCompetence then
    begin
      Personnage.MetierCompetence[Ind2].CodeCompetence := SelectWinCompetence;
      break;
    end;
```

Une fois `ColAugmCompCode` porteur du bon code, tout le reste suit mécaniquement :
`MajTables` crée la ligne avec le bon code, l'historique MJ XP enregistre le bon
code, et le rechargement est cohérent.

---

## Pièges rencontrés (à ne pas réintroduire)

### 1. `TabCompetence` ne contient pas les compétences non possédées

`ChargeCompetences` (~2343) ne fait que **marquer** les lignes existantes ; elle n'en
crée aucune. Une compétence de métier que le personnage n'a pas encore n'apparaît
donc **pas** dans `TabCompetence` au moment du double-clic. Elle n'y est ajoutée que
plus tard, par `MajTables` (branche `if not trouve`, ~3850).

→ Toute tentative de renommer une ligne de `TabCompetence` au double-clic échoue
silencieusement. C'était la cause finale du bug.

### 2. Ne jamais placer le renommage sous `if Cout > 0`

Le bloc compétence de `MajTables` est gardé par :

```pascal
if StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompCout, indAugm],0) > 0 then
```

Choisir une spécialité et y investir de l'XP sont deux actes **indépendants** : un
joueur peut fixer sa spécialité maintenant et n'y mettre de l'XP que trois séances
plus tard. Un choix sans dépense doit être conservé.

### 3. Erreur de colonne (corrigée)

L'ancienne ligne 3842 écrivait le code choisi dans `ColCompActuel` (13) au lieu de
`ColCompCode` (1). Le commentaire disait la bonne intention, la colonne était fausse.
**Le même bug subsiste ligne 3890 pour les talents** : `TabTalent.Cells[2, IndActu]`
est la colonne image du niveau métier, pas `ColTalCode`.

### 4. Boucle d'écrasement de la saisie

La boucle de fin de branche réécrivait `ColAugmCompNouveau` avec la valeur actuelle.
Si le joueur saisissait ses points **avant** de choisir, ils étaient perdus, le coût
retombait à 0, et `MajTables` sautait tout le bloc. Corrigé par le test d'égalité
`Nouveau = Actuel` du bloc A.

---

## Validation

Fichiers de test (`Test compétence générique`, métier Artiste, Art → Calligraphie) :

| Fichier | `CHAPTER_INCREASE` | `CHAPTER_SKILL` | Verdict |
|---|---|---|---|
| `20260805-052810` | `_*` | `_*` | avant correction |
| `20260805-053754` | `_*` | `_CALLI` | bloc C seul |
| `20260805-055037` | `_*` | `_CALLI` | bloc B inopérant |
| `20260805-055611` | `_CALLI` "5" | `_CALLI` "1" | **OK** |

### Restant à vérifier

- [ ] Choix **sans** dépense d'XP → sauvegarde → rechargement : la ligne reste
      Calligraphie et ne repropose plus le choix
- [ ] Ordre inverse (points puis choix) → résultat identique
- [ ] `ChoixNonFait()` ne bloque plus le changement de carrière (MESS_032) une fois
      le choix effectué
- [ ] Retirer le `ShowMessage` de debug du bloc B

---

## Prochaine étape : les talents

Le problème est structurellement **plus profond** que pour les compétences :
`Personnage.MetierTalent` **n'existe pas**. `ChargeAugmentation` (~3711) boucle
directement sur `ListMetierTalent`, c'est-à-dire sur le livre, à chaque ouverture.
Aucun choix ne peut donc y survivre.

Étapes :

1. Ajouter `MetierTalent: array of StructurePersonnageTalent` dans
   `StructurePersonnage` (`chargepersonnage.pas:97`, juste après `MetierCompetence`)
2. Écrire un `SUBCHAPTER_TALENTCAREER` dans `CHAPTER_SKILL` (`chargepersonnage.pas:318`)
3. Le relire (`chargepersonnage.pas:792`)
4. L'initialiser depuis `ListMetierTalent` quand `NvNiveau = 1` (`winpersonnage.pas:3981`)
5. Faire boucler `ChargeAugmentation` (3711) sur `Personnage.MetierTalent`
6. Corriger la colonne ligne 3890
7. Transposer les blocs A / B / C dans `TabAugmentationTalentDblClick`

## Puis : le choix multiple

Une fois le tuyau talent en place, le cas
`<Talent>RULES-T0002/RULES-T0117</Talent>` (« Stout-hearted **or** Very Resilient »)
devient abordable : il réutilise exactement le même mécanisme, avec une seule
différence — la façon de **construire la liste des options** proposées par
`TWinSpecialisations` :

- spécialisation → recherche des filles d'un code mère (préfixe + `_`)
- choix multiple → découpage explicite sur `/` (déjà la convention des races et de
  l'équipement, cf. `SeparateurMulti`)

À prévoir : `EstChoixMultiple(Code)` et `ListeChoixTalent(Code)`.

**Rappel** : ces entrées sont actuellement rangées à tort dans
`DATA_TALENT_SPECIALIZATION` côté XML — à corriger dans WinLivre.

---

## Divers

- Coquille dans les libellés XML : `LAB_130` affiche « Spéc**u**lation choisie » au
  lieu de « Spécialisation choisie ». À corriger en phase édition de WinLivre.
