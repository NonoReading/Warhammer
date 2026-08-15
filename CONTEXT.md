# Warhammer — Contexte projet

**Dernière mise à jour : 15/08/2026.** Ce fichier remplace tous les anciens
`CONTEXT*.md` / `INDEX*.md` / `RESUME*.md` / `SESSION*.md`. Il n'y en a plus
qu'un : celui-ci. On ne le duplique jamais, on l'édite en place.

---

## 0. Comment travailler avec moi (règles validées par Nono)

- **Une seule modification à la fois.** Un fichier, un endroit précis, puis STOP :
  je compile, je teste, je te dis, on continue.
- **Jamais de placeholder** dans du code destiné à être collé (pas de `<clé complète>`,
  pas de `...`). Si une valeur manque, la demander.
- **Ne pas changer une signature** sans corriger tous les appels dans la même réponse.
- **Ne pas enchaîner** plusieurs chantiers imbriqués sans point de compilation entre les deux.
- Les discussions de conception restent **séparées** du code à coller.
- Ce qui a mal marché : livrer des blocs de 300 lignes non relus, avec des colonnes
  qui n'existaient pas encore. Ce qui marche : petites corrections validées une par une.

---

## 1. Le projet

Application personnelle de gestion de personnages **Warhammer Fantasy V4**, en Lazarus/Free Pascal.

- Dépôt : `https://github.com/NonoReading/Warhammer.git`
- Local : `C:\Users\arnau\Documents\Lazarus Project\Warhammer\`

| Programme | Rôle |
|---|---|
| **WinCreation** (`TWinCreations`, avec un `s`, erreur historique conservée) | création de personnage en 8 phases |
| **WinPersonnage** (`TWinPersonnages`) | modification / progression du personnage |
| **WinLivre** (`TWinLivres`) | éditeur XML des livres de règles |

Pattern général du projet : les données (métiers, compétences, talents, livres) sont
chargées en mémoire au démarrage (`ListMetier`, `ListCompetence`, `ListTalent`, `ListLivre`)
et consultées via des fonctions `ChercheXxx()`. On ne relit pas le XML à la volée.

Constantes clés (`chargeconstantes.pas` ~13-20) :
`SeparateurMulti='/'`, `SeparateurLivre='-'`, `ValeurSousCompetence='_'`, `ValeurGenerique='_*'`.

---

## 2. État par chantier

### 2.1 WinLivre — Affichage des carrières : ✅ Phase 1 terminée

Ajout d'une branche "Career" par race dans le TreeView, affichant le libellé du métier
et le nom du livre (ex. `Agitator (Core Rules Book)` au lieu de `RULES-WORK01`), toutes
races et tous livres confondus (RULES, ARCH2, ARCH3, WINDS, DEATH, ENEMY...).

- Fichier concerné : `winlivre.pas` (1530+ lignes), `winlivre.lfm`
- Fonction clé : `LoadCareersForRaceTree()`
- Grille métiers : 5 colonnes (Code, Libellé, Livre, Sélectionné, Chance), tri
  "sélectionnés d'abord puis alphabétique", en-têtes i18n (`LAB_*`), parsing manuel
  (pas `DelimitedText`, jugé peu fiable pour ce cas)

**Phase 2 (édition interactive) : ⏳ non démarrée**, tous les `TEdit` encore en `ReadOnly`.
Prévu (jamais commencé) :
- Double-clic sur "Sélectionné" → toggle
- Double-clic sur "Chance" → éditer
- Boutons Valider / Annuler → écrire dans le XML
- Aide à la saisie de formules (clic droit, parseur partagé Dégâts/Portée/Durée avec
  jetons `(ATTR_xx)`/`(BATTR_xx)`, sur la base de `DecouperDegats`)

**Conception de l'enregistrement/versionning : arrêtée le 14/08/2026, pas encore
implémentée.**

En-tête présent dans chaque XML de livre (`<DATA_BOOK>`) :
`CODE_BOOK` (5 caractères, préfixe unique du livre, ex. `RULES-`), `BOOK` (libellé),
`language` (livres créés en anglais uniquement, traduction = processus séparé),
`VERSION` (`AAAAMMJJ`, complété par `-HHMMSS` à l'enregistrement), `OFFICIAL`
(`0` = RULESBOOK, cas obligatoire particulier ; `1` = livre officiel ; `2` = livre
créé par un fan), `COMPLETE` (`0`/`1` — un livre `COMPLETE = 1` n'est plus modifiable).

Flux retenu — trois moments d'écriture distincts, jamais d'écrasement en place :

1. **Premier enregistrement** d'un nouveau livre : écrit un stub minimal (juste
   l'en-tête `DATA_BOOK`, `COMPLETE = "0"`) dans `DATABASE\` (dossier nommé en dur,
   à côté de l'exécutable). Un livre `COMPLETE = "0"` n'est jamais proposé/chargé
   dans le reste du programme (sélection des livres au démarrage) — seul `WinLivre`
   sait le rouvrir pour continuer à l'éditer.
2. **Sauvegardes intermédiaires**, tant que `COMPLETE = "0"` : chaque enregistrement
   crée un nouveau fichier horodaté `TRAVAIL\<CODE_BOOK>\<AAAAMMJJ-HHMMSS>.xml` —
   jamais d'écrasement, `DATABASE` n'est pas touché. Au chargement, `WinLivre` lit
   le stub dans `DATABASE`, voit `COMPLETE = "0"`, et va chercher dans
   `TRAVAIL\<CODE_BOOK>\` le fichier le plus récent (tri alphabétique = tri
   chronologique grâce au format de nom). Même principe que `SAVED_CARACTERS`
   (un dossier par entité, un fichier horodaté par sauvegarde), déjà en place et
   validé pour les personnages.
3. **Finalisation** (nouveau bouton, à créer) : bascule `COMPLETE` de `"0"` à
   `"1"` et écrit l'arborescence en cours à la place du stub dans `DATABASE`. À
   partir de ce moment, `TRAVAIL\<CODE_BOOK>\` n'est plus jamais relu — gardé
   uniquement comme historique, sans conséquence si vidé.

Conséquence sur les boutons déjà présents dans `winlivre.pas`/`winlivre.lfm`
(`ButtonFormValiderClick`, `ButtonFormAnnulerClick`, `ButtonFormSupprimerClick`,
tous vides aujourd'hui) : "Valider" sur un formulaire ne doit modifier que la
mémoire (`XMLDoc`), pas écrire sur disque. Les écritures réelles viennent de deux
actions séparées à créer : "Enregistrer une version de travail" (écrit dans
`TRAVAIL`) et "Marquer comme terminé" (écrit dans `DATABASE`, bascule `COMPLETE`).

Point technique déjà identifié en lisant `winlivre.pas` : le chemin complet du
fichier XML chargé n'est stocké nulle part comme champ de la classe (`ChargerXMLFile`
ne garde que `FileCode`, pas le chemin) — il faudra ajouter un champ (ex.
`CurrentFilePath`) avant de pouvoir implémenter l'enregistrement.

Reste à préciser avant l'implémentation : que devient `TRAVAIL\<CODE_BOOK>\` une fois
`COMPLETE = "1"` (gardé tel quel, purgé, archivé ailleurs) — pas bloquant, à trancher
si besoin le jour où on l'implémente.

### 2.2 WinPersonnage / WinCreation — Persistance des choix & refonte de la création

**✅ Terminé :**

- Persistance des spécialisations de **compétences** de métier : `Personnage.MetierCompetence`
  est un instantané écrit/relu dans `CHAPTER_SKILL/SUBCHAPTER_SKILLCAREER`
  (`chargepersonnage.pas ~97, 308-318, 774-792`), mis à jour dans
  `TabAugmentationCompetenceDblClick` (blocs A/B/C). Piège : `TabCompetence` ne contient
  pas les compétences non encore possédées (créées seulement par `MajTables`) ; ne jamais
  garder le renommage sous `if Cout > 0`.
- Même mécanisme pour les **talents** : création de `Personnage.MetierTalent` (n'existait
  pas), chapitre autonome `CHAPTER_TALENT/SUBCHAPTER_TALENTCAREER`, blocs A/B/C dans
  `TabAugmentationTalentDblClick`. Bug corrigé : double réglage de `ColWidths` sur la
  mauvaise colonne (`ColAugmTalSpe` au lieu de `ColAugmTalSpeSel`).
- Normalisation des préfixes de livre dans les XML (13 fichiers, 129 lignes) : chaque
  branche `/` sans `SeparateurLivre` reçoit le préfixe de la première branche
  (`<Price>`/`<Quality>` exclus). Jusqu'à 9 branches vues, préfixes autres que `RULES-`
  (`WINDS-`, `ARCH2-`).
- `ListeTalent` et `ListeMetierCompetence` réécrites en récursif pour aplatir les
  génériques (`ValeurGenerique`) en spécialités, avec `StrictDelimiter := True` **avant**
  `Delimiter`/`DelimitedText`.
- Refonte complète de l'étape "choix" de création de personnage : remplacement de
  l'ancien système (4 `GroupBoxTalentChoix` + radios, plafonné à 4 choix de 2 options)
  par deux `TStringGrid` (`TabCreationChoix` / `TabCreationHasard`) pilotées par un
  modèle mémoire `StructureChoixCreation` (clé = `CodeSource, CodeParent, Rang`),
  reconstruit à chaque changement (`ReconstruitChoixCreation()`), avec cascade
  bidirectionnelle Choix↔Aléatoire. Validé de bout en bout XML compris.

**🔧 En cours — point de reprise immédiat :**

`ChargeAugmentation` (`winpersonnage.pas`) : la colonne de choix n'apparaît pas pour une
compétence à choix multiple (ex. `RULES-COMPDISC_RURAL/RULES-COMPDISC_URB`).

Cause identifiée : dans le bloc compétence, `ListComp` est créée mais jamais alimentée.
**Correction attendue** : ajouter
`ListComp := ListeMetierCompetence(PersonnageCompetence.CodeCompetence);`
comme le fait déjà le bloc talent avec `ListeTalent`.

→ Redonner `winpersonnage.pas` à jour en début de session pour la ligne exacte (les
numéros ont bougé depuis le 09/08).

→ Vérifier aussi la branche compétence de `winspecialisation.pas` : elle a probablement
besoin du même correctif `SeparateurMulti` que la branche talent, sinon la fenêtre de
choix s'ouvre vide.

### 2.3 Versionning des éléments entre livres/suppléments — conception arrêtée le 10/08, non démarré

Besoin : certains éléments du Livre de Règles ont une variante révisée dans un
supplément (ex. `RULES-COMPATL` → `UPINA-COMPATL`). Deux objectifs :

1. Corriger un bug latent : au changement de métier, une compétence possédée sous un
   livre n'est pas reconnue comme celle demandée par le nouveau métier sous un autre
   livre → doublon.
2. Ajouter une fonctionnalité : bouton dans WinPersonnage "mettre à jour les éléments
   par rapport à un livre", qui liste ce qui est remplaçable et laisse le joueur cocher.

Périmètre : compétences, talents, équipements, sorts. Exclus : race et métier (trop
structurants). À relire en entier au lancement de ce chantier — conception détaillée
dans l'historique (voir `Log.txt`, entrée du 10/08/2026).

### 2.4 Refonte du PDF de personnage — architecture Bloc/Tableau — ⭐ priorité pour Nono, en cours

**Problème** : `pdfpersonnage.pas` contient deux procédures géantes qui dessinent
chacune une fiche de personnage entière, coordonnée par coordonnée, en millimètres,
sans aucune séparation entre mise en page et données :
- `PdfPersonnageCreation` : 1071 lignes (294-1365), ~90 variables locales — pas encore
  attaqué, viendra après `PdfPersonnageCreationFeldo2P` (priorité de Nono).
- `PdfPersonnageCreationFeldo2P` : ~1388 lignes à l'origine, contient aussi des blocs
  entiers commentés/morts (ex. bloc "Blessure" ~40 lignes, bloc "PCM" ~15 lignes) pas
  encore supprimés — en cours de découpage, voir avancement ci-dessous.

Douleur exprimée par Nono : impossible de retrouver facilement un bloc ("tableau
avec titre et données") pour le modifier ou en ajouter un — tout est noyé dans une
seule fonction.

**Architecture retenue** — deux briques (types définis en tête de `pdfpersonnage.pas`,
juste après `StructureDonnee`) :

*Brique 1 — "bloc simple"* : pour les panneaux à champs fixes, sans lignes répétées.
Chaque bloc est sa propre procédure, qui ne connaît que son coin de départ (jamais sa
position absolue sur la page) — ex. `PdfBlocResilience`/`PdfBlocDestin`.

*Brique 2 — "tableau de données"* : pour les grilles répétitives (Compétences, Talents,
Armes, Sorts, Équipement, Caractéristiques). Une seule procédure générique
`DessinerTableau(PdfPage, Tableau: TPdfTableau, Donnees: TPdfRecordSet): Single`
(renvoie le Y du bas du tableau) dessine cadre + en-têtes + valeurs ; la seule logique
spécifique à chaque tableau est sa fonction de préparation (ex.
`PdfPreparerRecordSetCaracteristiques`), qui lit les structures du personnage et
remplit un `TPdfRecordSet` sans jamais dessiner. `TPdfRecordSet` simule un
"enregistrement SQL" : chaque valeur est retrouvée par son nom de champ
(`TPdfColonne.Champ`), pas par position, pour que préparation et mise en page restent
indépendantes.

Deux orientations, selon si une "entrée" du tableau est une ligne ou une colonne :
- `orColonne` (une entrée = une colonne, ses champs empilés en lignes) : cas des
  Caractéristiques, où chaque caractéristique occupe une colonne.
- `orLigne` (une entrée = une ligne, ses champs en colonnes) : cas des Compétences.
  Gère colonnes de largeur variable, en-tête fusionné sur plusieurs colonnes, police à
  3 états par case (valeur / en-tête / accent), cadre à capacité fixe supérieure au
  nombre d'entrées réelles (grille surdimensionnée, comme l'ancien code).

Un mécanisme d'annotation générique (`TPdfValeurCase.Annotation`) couvre à la fois le
bonus racial/talent des Caractéristiques et l'astérisque des Compétences : la
préparation pose juste le texte, `DessinerTableau` choisit position/taille selon
l'orientation.

**Avancement (extraits de `PdfPersonnageCreationFeldo2P`, chacun validé à la
compilation et comparé visuellement à l'original — rendu identique)** :
- ✅ Bloc Résilience/Destin (`PdfBlocResilience`/`PdfBlocDestin`)
- ✅ Tableau Caractéristiques (`orColonne`, `PdfPreparerRecordSetCaracteristiques`)
- ✅ Tableau Compétences de base (`orLigne`, `PdfPreparerRecordSetCompetencesBase`)
- ✅ Tableau Compétences groupées (`orLigne`, réutilise `DessinerTableau` tel quel,
  `PdfPreparerRecordSetCompetencesGroupees`). A nécessité de généraliser les décalages
  d'en-tête (`TPdfColonne.DecalageEnteteMin/DecalageEnteteMax`, jusque-là en dur dans
  `DessinerTableau`) pour supporter les deux jeux d'offsets différents des deux tableaux
  de compétences. A aussi corrigé un bug préexistant de l'ancien code, validé avec Nono :
  l'astérisque de bonus utilisait une variable `Comp` restée de la boucle précédente au
  lieu du code de la compétence courante ; corrigé en utilisant
  `PCompetence.CodeCompetence`.
- ⏳ Reste dans le bloc monolithique d'origine : Entête, Ambitions, Expérience,
  Mouvement, Corruption, blocs morts (Blessure, PCM) à supprimer, Talents, Armes,
  Armures, Sorts.

**Prochaine étape** : continuer bloc par bloc / tableau par tableau, compilation entre
chaque (règle §0). Une fois `PdfPersonnageCreationFeldo2P` terminée, appliquer la même
approche à `PdfPersonnageCreation`.

---

## 3. TODO / Backlog

Le backlog complet (tout ce qui n'est pas encore commencé) vit dans `A FAIRE.txt`
(fichier déjà existant dans le projet), pas ici — pour pouvoir y ajouter une ligne à
tout moment sans toucher à l'état détaillé des chantiers ci-dessus. Dès qu'un item
d'`A FAIRE.txt` passe en travail actif, il migre dans la section "en cours" du
chantier concerné, avec les détails techniques.

---

## 4. Pièges Lazarus / Free Pascal accumulés

- Colonne 0 réservée dans un `TStringGrid` (les données commencent à `Cells[1]`)
- `ColCount` = dernier indice + 1, sinon les écritures sont perdues sans erreur
- `StrictDelimiter := True` **avant** `Delimiter` et `DelimitedText`, sinon les espaces séparent
- Les gestionnaires d'événements doivent être dans la section `published`
- Les contrôles créés dynamiquement qui recouvrent une ScrollBox doivent avoir `Parent := Self`
- `Parent` est une propriété de `TControl` → ne jamais nommer une variable locale `Parent`
  (erreur "Duplicate identifier")
- `TColor` s'écrit en BGR, pas en RGB (`#FF8080` → `$8080FF`)
- Homonymie de globales : une variable déclarée dans deux unités compile sans erreur ; la
  dernière unité du `uses` gagne. `Ctrl+Clic` mène à la déclaration réellement utilisée.
  Convention à tenir : les globales partagées vivent uniquement dans `ChargeConstantes`.
- Éditer un `.lfm` à la main : fermer Lazarus d'abord, remplacer les blocs, ne pas les ajouter

---

## 5. Méthode de débogage qui a fait ses preuves

**L'écran ment, le XML et le modèle disent la vérité.** La plupart des bugs viennent
d'une valeur écrite ou lue dans la mauvaise colonne — rarement d'une logique fausse.

Réflexe qui débloque : un `ShowMessage` qui affiche l'état réel du modèle, ex. :

```pascal
Msg := '';
for Ind := 0 to High(ListeChoixCreation) do
  Msg := Msg + IntToStr(Ind) + ' src=' + ListeChoixCreation[Ind].CodeSource
             + ' rang=' + IntToStr(ListeChoixCreation[Ind].Rang)
             + ' choisi=[' + ListeChoixCreation[Ind].CodeChoisi + ']'
             + ' jet=' + IntToStr(ListeChoixCreation[Ind].Jet) + SeparateurRetourLigne;
ShowMessage(Msg);
```

⚠️ Ce témoin s'affiche **avant** le rafraîchissement des grilles : un écart entre le
message et l'écran est normal.
⚠️ Vérifier que le témoin lit bien la bonne grille (déjà arrivé : lecture de
`TabCreationChoix` au lieu de `TabCreationHasard`).
