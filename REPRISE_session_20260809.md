# Reprise de session — Projet Warhammer (Lazarus / Free Pascal)

**À donner en début de nouvelle conversation. État arrêté le 09/08/2026.**

---

## 0. Comment travailler avec moi (important)

Retour explicite donné pendant la session, à respecter :

- **Une seule modification à la fois.** Un fichier, un endroit précis, puis STOP : je compile,
  je teste, je te dis, on continue.
- **Jamais de placeholder** dans du code destiné à être collé (pas de `<clé complète>`, pas de
  `...`). Si une valeur manque, demande-la.
- **Ne pas changer une signature** sans corriger tous les appels dans la même réponse.
- **Ne pas enchaîner** plusieurs chantiers imbriqués sans point de compilation entre les deux.
- Les discussions de conception restent **séparées** du code à coller.

Ce qui a mal marché : livraison de blocs de 300 lignes contre du code non relu, avec des colonnes
qui n'existaient pas encore. Ce qui a bien marché : petites corrections validées une par une.

---

## 1. Contexte projet

Application personnelle de gestion de personnages **Warhammer Fantasy V4**, en Lazarus/Free Pascal.
Dépôt : `https://github.com/NonoReading/Warhammer.git`
Local : `C:\Users\arnau\Documents\Lazarus Project\Warhammer\`

Trois programmes principaux :

| Programme | Rôle |
|---|---|
| **WinCreation** (`TWinCreations`, avec un `s`, erreur historique) | création de personnage en 8 phases |
| **WinPersonnage** (`TWinPersonnages`) | modification / progression |
| **WinLivre** (`TWinLivres`) | éditeur XML des livres de règles |

---

## 2. Le fil rouge de la session : les codes non résolus

Tout ce qui a été fait ces 3 jours découle d'un même principe :

> **Un code qui n'est pas encore un vrai code ne doit pas survivre à la validation.**

Trois formes de codes « à résoudre », toutes portées par les XML de livres :

| Forme | Exemple | Qui décide |
|---|---|---|
| Choix multiple (`SeparateurMulti` = `/`) | `RULES-T0002/RULES-T0117` | le joueur |
| Générique (`ValeurGenerique` = `_*`) | `RULES-T0092_*` | le joueur |
| Aléatoire | `RULES-T*` | le **dé** (D100 dans `DATA_RANDOM_TALENT`) |

Constantes (`chargeconstantes.pas` ~13-20) :
`SeparateurMulti='/'`, `SeparateurLivre='-'`, `ValeurSousCompetence='_'`, `ValeurGenerique='_*'`

---

## 3. TERMINÉ ✅

### 3.1 Persistance des spécialisations — compétences (05/08)

`Personnage.MetierCompetence` (chargepersonnage.pas ~97) = instantané de TOUTES les compétences du
métier avec leur niveau. Écrit dans `CHAPTER_SKILL/SUBCHAPTER_SKILLCAREER`, relu, initialisé depuis
`ListMetierCompetence` **uniquement si `NvNiveau = 1`**. Une fois le métier pris, le livre n'est plus
relu : écraser le code générique par le code spécifique suffit.

Correctif dans `TabAugmentationCompetenceDblClick` : blocs A (récupérer la valeur si la spé existe
déjà, sans écraser une saisie), B (`Cells[ColAugmCompCode, Row] := SelectWinCompetence`),
C (propager à `Personnage.MetierCompetence`).

**Piège majeur** : `TabCompetence` ne contient PAS les compétences de métier non encore possédées —
elles n'y sont créées que par `MajTables` (branche `if not trouve`). Tenter d'y renommer une ligne
au double-clic échoue toujours.

**Autre piège** : ne jamais placer le renommage sous `if Cout > 0` — choisir une spécialité et y
investir de l'XP sont indépendants.

### 3.2 Persistance des spécialisations — talents (06/08)

Mêmes blocs A/B/C dans `TabAugmentationTalentDblClick`, plus création de `Personnage.MetierTalent`
(qui n'existait pas du tout) : structure, écriture dans un chapitre **autonome** `CHAPTER_TALENT /
SUBCHAPTER_TALENTCAREER`, relecture (bloc placé **après** celui des compétences car
`ChapterRaceNode` est réutilisée), initialisation à `NvNiveau = 1` dans `MajTables` **et** dans
`wincreation.pas` étape 6.

**Double bug qui se compensait** (le plus instructif) : `ColWidths[ColAugmTalSpe]` réglé deux fois
(200 puis 0) au lieu de `ColAugmTalSpeSel` → la colonne remplie était invisible, et le double-clic
testait `Col = ColAugmTalSpeSel` tout en lisant `ColAugmTalSpe`. Rien ne plantait.

**Règle métier confirmée** : talents = `= MetierNvEnCours` ; compétences = `<= MetierNvEnCours`.
En WFRP4 un talent n'est accessible que pendant le palier qui l'accorde.

### 3.3 Normalisation des préfixes de livre (06/08)

Les XML écrivaient la 2ᵉ branche sans préfixe (`RULES-T0139_GOUT/T0139_VUE`). Or `VerifieRecherche`
(chargeconstantes ~880) fait une **égalité stricte** avec un repli asymétrique (teste
`LivreValeur = ''` et non `LivreRecherche = ''`) → échec silencieux.

**13 fichiers traités, 129 lignes modifiées.** Règle : chaque branche sans `SeparateurLivre` reçoit
le préfixe de la première. `<Price>` et `<Quality>` exclus (le `/` y a un autre sens).

Découvertes : des choix jusqu'à **9 branches**
(`RULES-WORK58/WORK84/.../WORK91`), et des préfixes autres que `RULES-` (`WINDS-`, `ARCH2-`).

### 3.4 Choix multiple N-branches (09/08)

`ListeTalent` (`chargetalent.pas`) réécrite : `TStringList` avec `StrictDelimiter := True` **avant**
`Delimiter` et `DelimitedText`, et **récursion** sur les branches contenant `ValeurGenerique`
(aplatit un générique en ses spécialités, pour n'avoir qu'une seule fenêtre de choix).

`winspecialisation.pas` / `ChargeSpecialisation` : si `Pos(SeparateurMulti, CodeGenerique) > 0`,
utiliser `ListeTalent()` avec `AjouteLigne(..., SansTest=true)` au lieu du balayage par racine
commune — sinon la fenêtre est **vide** pour un choix multiple. Ce correctif sert les deux programmes.

✅ Validé : Artisan monté au niveau 3, choix entre les deux `RULES-T0139_*`, enregistré correctement.

### 3.5 Refonte des choix de talents à la création (07-09/08)

Remplacement de l'ancien mécanisme (4 `GroupBoxTalentChoix` + 8 radios + 3 séries spin/Valider,
plafonné à **4 choix de 2 options**) par deux `TStringGrid` dans `TabSheetTalent` :

- `TabCreationChoix` (haut) — double-clic → `TWinSpecialisations`
- `TabCreationHasard` (bas) — double-clic → `TWinLanceDes` (saisie du D100)

**Modèle mémoire = source de vérité**, les grilles ne sont qu'un rendu :

```pascal
StructureChoixCreation = record
  Origine, CodeSource, CodeParent, CodeChoisi: String;
  Rang: Integer;        // INDISPENSABLE : une race peut avoir plusieurs "RULES-T*"
  Aleatoire: Boolean;   // False = grille Choix, True = grille Aléatoire
  Jet: Integer;
end;
```

**Clé d'identification = `(CodeSource, CodeParent, Rang)`.** Sans le `Rang`, deux lignes
`RULES-T*` racines sont indiscernables et tous les tirages écrivent au même endroit.

`ReconstruitChoixCreation()` reconstruit tout à chaque changement et réinjecte les jets mémorisés →
**réversibilité** : le joueur peut revenir sur « Doomed », puis re-choisir « Random Talent ».
Justification de conception : le MJ explique souvent les implications *après* que le joueur ait coché.

**Cascade bidirectionnelle** : Choix→Aléatoire (le joueur prend `RULES-T*`) et Aléatoire→Choix
(le dé donne un générique, ex. `RULES-T0139_*` sur 01-03). Boucle `while` (pas `for`) à l'étape 4
car le tableau grandit pendant l'itération.

Autres éléments en place :
- `AjouteTalentsResolus()` appelée dans `PhaseSave` branche `4:` (pas dans `AfficheImageRace`,
  où aucun choix n'est encore fait) → alimente `TabTalent` → `Personnage.CreationTalent` → XML
- Bouton « Au hasard » : boucle `repeat` résolvant choix puis tirages, avec reconstruction entre
  les deux, jusqu'à `ChoixCreationComplet()`
- Garde-fou dans `PageEtapesChange` cas `3:` via `ChoixCreationComplet()`
- Coloration permanente des lignes non résolues via `OnPrepareCanvas`
  (couleurs relevées : rouge `TColor($8487F0)`, vert `$57ED71`, gris `$7F7F7F`)
- `TWinLanceDes` : `SpinEdit` 0-100 pré-rempli par `ChoixWinJetValeur`, bouton Lancer,
  contrôle du doublon via `TalentDejaPossede(Code, ChoixWinJetDeja)`, refus du jet à 0

**Règle de validation** : une ligne du tableau Choix produit un talent **sauf** si `CodeChoisi`
vaut `RULES-T*` — sa ligne fille du tableau Aléatoire s'en charge.

✅ Validé de bout en bout, XML compris.

### 3.6 `ListeMetierCompetence` N-branches (09/08)

Même correction récursive que `ListeTalent`, appliquée dans `chargemetiercompetence.pas`.
Compile.

---

## 4. EN COURS — point de reprise immédiat 🔧

**`ChargeAugmentation` (winpersonnage.pas) : la colonne de choix n'apparaît pas pour une
compétence à choix multiple.**

Cause identifiée : dans le **bloc compétence** de `ChargeAugmentation`, `ListComp` est créée
(`ListComp := TStringList.Create;`) mais **jamais alimentée**. Le test est pourtant complet :

```pascal
if (ListComp.Count > 1) or (Pos(ValeurGenerique, PersonnageCompetence.CodeCompetence) > 0) then
  TabAugmentationCompetence.Cells[ColAugmCompSpe, NbC] := GetTexteLibelle(ConstLabSelSpe);
```

Pour `RULES-COMPDISC_RURAL/RULES-COMPDISC_URB` : `Count = 0` et pas de `ValeurGenerique`
→ aucune colonne de choix.

**Correction attendue** : ajouter `ListComp := ListeMetierCompetence(PersonnageCompetence.CodeCompetence);`
au bon endroit, comme le fait le bloc talent avec `ListeTalent`.

➡️ **Redonner `winpersonnage.pas` en début de nouvelle conversation** pour obtenir la ligne exacte
(les numéros de ligne ont bougé).

Il faudra aussi vérifier la branche **compétence** de `winspecialisation.pas` : elle a probablement
besoin du même correctif `SeparateurMulti` que la branche talent (§3.4), sinon la fenêtre s'ouvrira
vide.

---

## 5. TODO

### WinCreation
- [ ] Nettoyer les blocs commentés dans `PhaseSave`, `PageEtapesChange`, `AfficheImageRace`
- [ ] Supprimer du `.lfm` les anciens composants (4 GroupBox, 8 radios, 3 séries spin/Valider)
- [ ] Améliorer l'affichage de `TWinLanceDes` (boutons qui débordent)

### Général
- [ ] **Passe globale sur les libellés** `LAB_xxx` / `MESS_xxx` (volontairement reportée)
- [ ] Coquille `LAB_130` : « Spéc**u**lation choisie » → « Spécialisation choisie »
- [ ] Appliquer `GridAjouteColonne` (déjà écrite dans `ChargeConstantes`) aux nouvelles grilles :
      supprime les indices en dur et rend impossible le bug du double `ColWidths`.
      ⚠️ passe les grilles en mode `Columns`, à tester avec `OnPrepareCanvas`
- [ ] `ColAugmTalLib` trop étroite pour les libellés spécialisés
- [ ] `TabAugmentationTalentDblClick`, branche « ajouter un talent » : utilise `ColCompLib` et
      `ColAugmCompLib` (constantes **compétence**) au lieu de `ColAugmTalLib`
- [ ] `VerifieRecherche` est dans `ChargeConstantes` alors qu'elle n'est appelée que depuis `UnitCalcul`
- [ ] Entrées fantômes `<Skill id="RULES-COMPCOMB_2M/COMPCOMB_FLEAU">` (libellé
      « Corps à corps (Fléau ou Deux mains) ») : suppression envisagée → prévoir de construire le
      libellé à la volée en joignant les branches par « ou »
- [ ] Le menu des livres retrouve le fichier par le **libellé** → renommer les fichiers
      (supprimer les espaces) casserait le lien. Chantier isolé si besoin.
- [ ] `ChargeImageNiveau` / `ColorList` sont locales à WinPersonnage → mutualisables dans
      `ChargeConstantes` si on veut les couleurs partagées
- [ ] Le protocole par globales (`ChoixWinTalent`, `SelectWinTalent`, `ChoixWinJetRace`,
      `ChoixWinJetDeja`, `ChoixWinJetValeur`, `SelectWinJet`, `SelectWinJetTalent`…) grossit.
      Passer par des propriétés de fiche serait plus sûr. Pas urgent.
- [ ] `AdjustGridColumnsWidth` appelle `ScaleFormToDesign(96)` alors que les `.lfm` sont en
      `DesignTimePPI = 120` → écart d'échelle possible, d'où les paramètres `AddHeight`/`AddWidth`
      qui servent à rattraper à la main. Chantier à part.

### WinLivre
- [ ] Phase ÉDITION non démarrée (tous les TEdit encore ReadOnly)
- [ ] Aide à la saisie de formules (clic droit, parseur de grammaire partagé pour
      Dégâts/Portée/Durée avec les jetons `(ATTR_xx)`/`(BATTR_xx)`, en s'appuyant sur `DecouperDegats`)

---

## 6. Pièges Lazarus / Free Pascal accumulés

- **Colonne 0 réservée** dans une `TStringGrid` (les données commencent à `Cells[1]`)
- **`ColCount` = dernier indice + 1**, sinon les écritures sont perdues sans erreur
- **`StrictDelimiter := True` AVANT `Delimiter` et `DelimitedText`**, sinon les espaces séparent
- Les gestionnaires d'événements doivent être dans la section **`published`**
- Les contrôles créés dynamiquement qui recouvrent une ScrollBox doivent avoir `Parent := Self`
- **`Parent` est une propriété de `TControl`** → ne jamais nommer une variable locale `Parent`
  (erreur `Duplicate identifier`)
- **`TColor` s'écrit en BGR**, pas en RGB (`#FF8080` → `$8080FF`)
- **Homonymie de globales** : une variable déclarée dans deux unités compile sans erreur ; c'est la
  dernière unité du `uses` qui gagne. `Ctrl+Clic` mène à la déclaration réellement utilisée.
  Convention à tenir : les globales partagées vivent **uniquement** dans `ChargeConstantes`.
- Éditer un `.lfm` à la main : **fermer Lazarus d'abord**, et remplacer les blocs, ne pas les ajouter

---

## 7. Méthode de débogage qui a fait ses preuves

**L'écran ment, le XML et le modèle disent la vérité.** Trois bugs sur quatre venaient d'une valeur
écrite dans la mauvaise colonne, ou lue dans la mauvaise colonne — jamais d'une logique fausse.

Le réflexe qui a débloqué chaque situation : un `ShowMessage` affichant l'état réel.

```pascal
// vue directe sur le modèle
Msg := '';
for Ind := 0 to High(ListeChoixCreation) do
  Msg := Msg + IntToStr(Ind) + ' src=' + ListeChoixCreation[Ind].CodeSource
             + ' rang=' + IntToStr(ListeChoixCreation[Ind].Rang)
             + ' choisi=[' + ListeChoixCreation[Ind].CodeChoisi + ']'
             + ' jet=' + IntToStr(ListeChoixCreation[Ind].Jet) + SeparateurRetourLigne;
ShowMessage(Msg);
```

⚠️ Ce témoin s'affiche **avant** le rafraîchissement des grilles : un écart entre le message et
l'écran est normal.

⚠️ Vérifier que le témoin lui-même lit la **bonne grille** — une fois, il lisait `TabCreationChoix`
au lieu de `TabCreationHasard` et a envoyé sur une fausse piste.

**Témoins de debug encore en place à retirer** : ceux de `TabCreationHasardDblClick` et
`ReconstruitChoixCreation` (commentés pour la plupart).
