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
- ✅ Bloc Entête (`PdfBlocEntete`) — cadre à colonnes irrégulières (les séparateurs
  changent d'une ligne à l'autre), donc bloc simple et non `TPdfTableau`. Ajustement
  suite retour Nono : la colonne "Species"/"Career Level" débordait sur son libellé en
  anglais (libellés plus longs qu'en français) — séparateur du milieu déplacé de 5mm
  vers la gauche (82→77) pour lui donner plus de place.
- ✅ Bloc Ambitions (`PdfBlocAmbitions`) — panneau sans donnée calculée (titre +
  deux lignes laissées vides pour être remplies à la main).
- ✅ Blocs Expérience / Mouvement / Corruption (`PdfBlocExperience` /
  `PdfBlocMouvement` / `PdfBlocCorruption`) — trois panneaux côte à côte sous
  Résilience/Destin, même gabarit "titre + lignes libellé/valeur". Au passage,
  suppression d'un calcul mort repéré pendant l'extraction (une première affectation de
  `DessinDebutHautExp`, juste après Résilience/Destin, était systématiquement écrasée
  par une deuxième avant la moindre lecture — code mort probablement laissé par
  l'ancien bloc Blessure aujourd'hui commenté).
- ✅ Blocs morts supprimés (page 1) : l'ancien bloc "Dessin Blessure" (commenté, ~35
  lignes) et l'ancien bloc "Dessin PCM" (commenté, ~15 lignes, aucune variable
  associée — code mort pur). Attention pour la suite : il existe un bloc Blessure
  actif (non commenté, page 2, vers la zone Encombrement — réutilise les mêmes noms
  `DessinDebutHautBle`/`DessinHauteurBle`/`DessinNbLigBle`/`DessinLargeurBle`/`Ch`
  /`DurACuire`/`ValDurACuire` que l'ancien bloc mort de la page 1) : ce n'est pas du
  code mort, à ne pas supprimer par erreur en confondant les deux blocs. Confirmé par
  Nono (15/08/2026) : Blessure a été déplacée **définitivement** de la page 1 vers la
  page 2 pour regrouper toutes les données liées au combat sur une seule page (ne pas
  avoir à retourner la page en jeu). Pour la même raison, le bloc "Compétence de
  combat" de la page 2 (~L.3283, `DessinDebutHautComC`, libellés
  `RULES-PDF_SKILLS1_BASIC`/`RULES-PDF_SKILLS2_TOTAL`) réaffiche volontairement en
  doublon Esquive/Calme/Résistance/Commandement/Intuition — déjà montrées dans le
  tableau Compétences de base de la page 1 (`TotalEsquive`/`TotalCalme`/
  `TotalResitance`/`TotalCommandement`/`TotalIntuition`, sortis en paramètres `out` de
  `PdfPreparerRecordSetCompetencesBase` précisément pour cette réutilisation). C'est un
  doublon voulu, pas une redondance à supprimer.
- ✅ Bloc Talents (`PdfBlocTalents`) — liste répétitive à deux passes (talents acquis,
  puis talents accessibles via le métier mais pas encore pris, grisés), du même esprit
  que Compétences groupées, mais gardée en bloc simple plutôt que réécrite avec
  `DessinerTableau` : la colonne Description a un décalage vertical qui dépend de la
  longueur du texte (`Length(Resume) > 20` → `+1.5` au lieu de `+1`, pour recentrer un
  résumé probablement affiché sur 2 lignes par `PdfEcrit`), un cas que le tableau
  générique ne modélise pas aujourd'hui — pas de généralisation forcée pour un seul
  cas. Utilise directement les globales `ListTalent`/`ListMetierTalent`/`ChercheTalent`
  (déjà globales dans l'ancien code). Au passage, nettoyage de 6 variables devenues
  inutilisées par le découpage dans `PdfPersonnageCreationFeldo2P` (`PTalent`,
  `PMetierTalent`, `TalentDonnee`, `NivTalMetier`, `ListeTalent`, `NbLigne`).
- ✅ Bloc Armures, cadre uniquement (`PdfBlocArmures`) — page 2. Structure différente
  des blocs précédents : dans le code d'origine, tous les cadres de la page 2
  (Armures/Équipement/Armes/Sorts/Encombrement) sont dessinés à la suite, PUIS une
  seule boucle plus loin (`for PersonnageEquipement in Personnage.Equipement`)
  remplit les lignes des 4 tableaux (Armes/Armures/Équipement-Divers/Sorts) en un seul
  passage, en accumulant des totaux partagés (`EncArme`, `EncArmure`, `ArmureBras`/
  `Corps`/`Jambe`/`Tete`, `NbArme`/`NbArmure`/`NbSort`, `ArmureBonii`/`ArmeBonii`/
  `FabricationBonii`) réutilisés encore plus loin par le bloc Encombrement (valeurs) et
  par le cadre "DessinExplication" en fin de page. Extraire ce remplissage bloc par
  bloc comme pour Talents casserait ce partage de totaux entre 4 tableaux + 2 blocs
  aval — nécessite une vraie discussion de conception (regrouper le calcul des totaux
  avant l'affichage ? les faire remonter en `out` comme
  `PdfPreparerRecordSetCompetencesBase` ?) avant d'y toucher, pas juste un découpage
  mécanique. Pour avancer sans bloquer, seuls les 5 cadres (dessin du cadre + en-têtes,
  sans les données) sont extraits un par un pour l'instant, en gardant le remplissage
  dans la procédure principale. `PdfBlocArmures` ne prend pas `MinPolice` (aucun
  `PdfEcrit`, uniquement des libellés fixes via `PdfCentre`). Point d'attention
  particulier : `DessinDebutHautArm` (Y du haut) et `DessinLargeurArm` (bord droit)
  sont relus bien plus loin (cadre "DessinExplication", ~L.3341) — l'appelant garde
  donc ses propres variables, le bloc ne fait que dessiner avec les valeurs qu'on lui
  passe.
- ✅ Bloc Équipement, cadre uniquement (`PdfBlocEquipement`) — même principe que
  `PdfBlocArmures`. Point curieux préservé tel quel (pas un bug, confirmé par Nono) :
  la grille de colonnes Nom/Encombrement est doublée (répétée deux fois dans
  l'en-tête) parce que la liste "Divers" se répartit sur deux demi-colonnes quand elle
  dépasse la hauteur du cadre (le remplissage bascule sur
  `IndDivers > DessinNbLigEqu - 1`) — volontaire, pour ne pas prendre trop de place en
  hauteur si la liste s'allonge.
- ✅ Bloc Armes, cadre uniquement (`PdfBlocArmes`) — même principe.
- ✅ Bloc Sorts, cadre uniquement (`PdfBlocSorts`) — même principe. Au passage,
  correction d'une incohérence de casse sans impact fonctionnel repérée dans l'ancien
  code (`DessinHauteursor` au lieu de `DessinHauteurSor` sur 6 lignes — Pascal étant
  insensible à la casse, c'était déjà la même variable, juste écrite différemment ;
  uniformisé dans la fonction extraite).
- ✅ Bloc Encombrement, cadre uniquement (`PdfBlocEncombrement`) — dernier de la série
  cadre+en-têtes. Contrairement aux 4 précédents (Armures/Équipement/Armes/Sorts), a
  des libellés de largeur variable (`PdfEcrit`), donc reprend `MinPolice` en
  paramètre. Les valeurs (totaux d'encombrement, écrites après la boucle de
  remplissage) restent dans la procédure principale, hors de ce bloc. **Les 5 cadres
  de la page 2 sont maintenant tous extraits.**
- **Décisions de conception validées par Nono (15/08/2026)** pour le remplissage des 4
  tableaux (Armes/Armures/Équipement-Divers/Sorts) : (1) le découper en 4 boucles
  séparées plutôt que garder le passage unique actuel — Nono confirme que parcourir 4
  fois `Personnage.Equipement` n'a aucun impact perf vu la taille des données ; (2)
  faire remonter les totaux partagés (`EncArme`, `EncArmure`, `ArmureBras/Corps/Jambe/
  Tete`, `ArmureBonii`, `ArmeBonii`, `FabricationBonii`) en paramètres `out`, même
  principe que `PdfPreparerRecordSetCompetencesBase` pour les compétences de combat ;
  (3) le cadre "DessinExplication" (affichage des libellés de bonus/malus accumulés)
  peut lui aussi devenir une boucle à part — contrainte à respecter : ne pas afficher
  deux fois la même info de bonus/malus si elle est présente sur plusieurs
  équipements (dédoublonnage déjà présent dans le code via `Pos(...) = 0` avant
  d'ajouter à `ArmureBonii`/`ArmeBonii` — à bien vérifier qu'il survit au découpage).
- ✅ Remplissage Sorts, première des 4 boucles séparées (`PdfBlocSortsDonnees`) —
  filtre `Personnage.Equipement` sur `TypeEquipSp`, remplit le tableau dont le cadre
  est `PdfBlocSorts`. `NbSort` est resté purement local à cette procédure (personne ne
  le relit après dans `PdfPersonnageCreationFeldo2P`), contrairement aux totaux
  d'Armes/Armures qui devront être remontés en `out`/`var` car réutilisés par
  l'Encombrement et DessinExplication (voir ci-dessous). Nettoyage au passage :
  `NBSort` et `PSort` retirés du bloc `var` principal (devenus inutilisés par ce
  découpage). Retirée de la boucle partagée, c'était la dernière clause du
  if/else-if — Divers en devient la dernière clause.
- ✅ Remplissage Divers, deuxième des 4 boucles séparées (`PdfBlocDiversDonnees`) —
  filtre `Personnage.Equipement` sur `TypeEquipDI`, remplit la liste Divers du cadre
  Équipement (`PdfBlocEquipement`), avec bascule en deuxième demi-colonne au-delà de
  `NbLignes` lignes préservée telle quelle (comportement volontaire, voir plus haut).
  `IndDivers` purement local à cette procédure (comme `NbSort` pour Sorts) ; retiré du
  bloc `var` principal de `PdfPersonnageCreationFeldo2P` (l'occurrence dans l'ancienne
  `PdfPersonnageCreation`, non touchée par ce chantier, garde la sienne). C'était la
  dernière clause du if/else-if partagé ; Armures en devient la dernière clause.
  Poussé le 15/08/2026, pas encore testé/compilé par Nono.
- ✅ Remplissage Armes, troisième des 4 boucles séparées (`PdfBlocArmesDonnees`) —
  filtre `Personnage.Equipement` sur `TypeEquipWe`, remplit le tableau dont le cadre
  est `PdfBlocArmes`. Le cas délicat annoncé : `FabricationBonii` est accumulé par
  Armes ET Armures (les deux ajoutent au même texte d'explication affiché plus loin
  via `FabricationDetail`), remonté en paramètre `var` plutôt que local pour que les
  deux boucles s'y ajoutent sans s'écraser — Armures reste pour l'instant dans la
  boucle partagée de la procédure principale (prochaine étape), donc `FabricationBonii`
  y est encore accédé directement, en plus d'être passé en `var` à `PdfBlocArmesDonnees`.
  `EncArme`/`ArmeBonii` remontés en `out` (réutilisés par l'Encombrement et
  DessinExplication) ; `BF`/`TBonusCC`/`TBonusCT` passés en lecture seule (déjà
  calculés plus haut dans la procédure principale, non modifiés entre-temps).
  Nettoyage au passage : `NbArme`, `PArme`, `TexteRange1`/`TexteRange2`, `Portee`,
  `PorteMoyenne`, `Deg`, `PosProtection`, `Pourcent`, `PasBonus`, `Bidon`, `ListMalii`
  retirés du bloc `var` principal (devenus inutilisés par ce découpage, purement
  locaux à la nouvelle procédure). `ArmureBouclier` aussi retiré — il était déjà
  écrit sans jamais être relu dans `PdfPersonnageCreationFeldo2P` (voir la liste de
  nettoyage pré-existante ci-dessous, dont cet item disparaît puisqu'il est
  maintenant traité). Armes était la première clause du if/else-if partagé ; Armures
  (seule clause restante) passe de `else if` à `if` simple. Poussé le 15/08/2026, pas
  encore testé/compilé par Nono.
- ✅ Remplissage Armures, dernière des 4 boucles séparées (`PdfBlocArmuresDonnees`) —
  filtre `Personnage.Equipement` sur `TypeEquipAR`/`TypeEquipARS` selon `ArmureSet`,
  remplit le tableau dont le cadre est `PdfBlocArmures`. **Les 4 boucles de
  remplissage (Sorts/Divers/Armes/Armures) sont maintenant toutes extraites de
  l'ancienne boucle unique sur `Personnage.Equipement`.** `FabricationBonii` en
  paramètre `var` (partagé avec Armes, comme prévu) ; `EncArmure`/
  `ArmureBras/Corps/Jambe/Tete`/`ArmureBonii` remontés en `out` ; `ArmureSet` passé en
  lecture seule. Nettoyage au passage : `Quality`, `Enc`, `EncP`, `NbArmure`,
  `LigneBonus`, `PArmure`, `PArmureSimplifiee`, `PersonnageEquipement` retirés du bloc
  `var` principal (devenus inutilisés). C'était la seule clause restante de l'ancienne
  boucle partagée ; toute la boucle (le `for PersonnageEquipement in
  Personnage.Equipement do ... end;`) a donc disparu de
  `PdfPersonnageCreationFeldo2P`, remplacée par les 4 appels séquentiels. La ligne
  `PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);` qui précédait
  l'ancienne boucle a aussi disparu : `PdfBlocSortsDonnees` (premier des 4 appels) fait
  déjà ce même réglage de police en tout début de procédure, donc la police à 9 reste
  correctement établie avant Sorts/Divers/Armes/Armures (chaîne vérifiée : aucun des 4
  ne change la police avant sa propre première utilisation, sauf Armes et Armures qui
  la remettent explicitement à 9 en fin de chaque itération).
  **Découverte signalée à Nono, non corrigée** : `ArmureBras`/`ArmureCorps`/
  `ArmureJambe`/`ArmureTete` sont calculés dans `PdfPersonnageCreationFeldo2P` mais ne
  semblent lus nulle part ensuite dans cette procédure (contrairement à l'ancienne
  `PdfPersonnageCreation`, qui les affiche via `WriteText` sur une silhouette de
  protection, lignes ~1600-1613) — possible fonctionnalité manquante sur la page 2 du
  PDF (silhouette/tableau de protection par emplacement du corps absent). Comportement
  préservé tel quel par cette extraction (gardés en `out` params, aucune suppression) ;
  à investiguer/concevoir séparément si Nono confirme le manque. Poussé le 15/08/2026,
  confirmé par Nono ("cela compile et donne une résultat juste") — les 4 boucles de
  remplissage sont validées.
- ✅ Cadre "DessinExplication" (affichage des libellés de bonus/malus accumulés pour
  Armures/Armes/Fabrication, dernier bloc de `PdfPersonnageCreationFeldo2P` avant la
  sauvegarde du PDF) extrait dans `PdfBlocDessinExplication`. Contrairement aux 4
  boucles de remplissage ci-dessus (qui remplissent un cadre déjà dessiné ailleurs),
  ce bloc dessine lui-même son propre cadre : troisième pattern de bloc (cadre +
  contenu combinés dans une seule procédure), en plus des blocs "cadre seul" et
  "remplissage seul" déjà établis. `ArmureBonii`/`ArmeBonii`/`FabricationBonii` reçus
  déjà construits et dédoublonnés (le dédoublonnage se fait en amont, rien à refaire
  ici). `NbBonus` reste un compteur de ligne **PARTAGÉ** entre les trois sections,
  jamais remis à zéro entre elles (comportement intentionnel préservé tel quel, à la
  différence de `NbSort`/`IndDivers`/`NbArme`/`NbArmure` qui sont chacun réinitialisés
  au début de leur propre boucle). Nettoyage au passage : `NbBonus`, `NbLoca`,
  `IndLoca`, `PArmureBonus`, `PArmeBonus`, `PFabrication`, `TxtBonus` retirés du bloc
  `var` principal (devenus inutilisés) ; `LocData` gardé (reréutilisé plus loin dans
  une boucle Métier sans rapport) ; `DessinHauteurExl` gardé (passé en paramètre
  `HauteurLigne` à l'appel de `PdfBlocDessinExplication`, donc toujours en usage).
  **Incohérence pré-existante signalée à Nono, non corrigée** : l'entête de la section
  Fabrication utilise un `X=15` en dur (`PdfPage.WriteText(15, ...)`) au lieu de
  `XGauche + 4` comme les entêtes Armures/Armes et comme toutes les lignes de détail
  des trois sections (y compris celles de Fabrication elle-même) — désalignement
  visuel préservé exactement tel quel, avec un commentaire dans le code signalant le
  problème. Poussé le 15/08/2026, pas encore testé/compilé par Nono.

**Nettoyage variables inutilisées** : un passage de compilation du 15/08/2026 a
remonté plusieurs "Note: Local variable ... not used" dans
`PdfPersonnageCreationFeldo2P`. Quatre étaient une conséquence directe du découpage
(`DessinNbLigCarac`, `DessinNbColCarac`, `DessinNbColComp`, `DessinNbColComg` —
supprimées du bloc `var`). Les autres sont préexistantes, sans lien avec ce chantier
(`PMetierAttribut`, `Comp`, `ValStat`, `ValBonus`, `ValTotal`,
`PersonnageCompetence`, `NivCompMetier`, `AmePure` à la ligne 535 — pas celui du bloc
Corruption, qui lui est utilisé) — reportées dans `A FAIRE.txt`, à traiter avec le
nettoyage des blocs morts. (`ArmureBouclier` faisait partie de cette liste ; retiré du
`var` block lors de l'extraction d'Armes, n'y figure donc plus.)

**Confirmation de la découverte ci-dessus (15/08/2026)** : Nono confirme que le bloc
"Armour Points" (silhouette + valeurs de protection par emplacement du corps - Tête,
Bras, Corps, Jambes, Bouclier) existe bien dans l'autre PDF (`PdfPersonnageCreation`,
page 1, lignes ~1594-1613) et veut qu'il soit ajouté à `PdfPersonnageCreationFeldo2P`,
sous le bloc Encombrement de la page 2. **Correction en cours de conception** (ma
première lecture du code était incomplète) : le bloc n'est pas qu'une image de fond
avec des `WriteText` par-dessus — les cases et le losange "Shield" sont dessinés en
vectoriel par l'utilitaire déjà partagé `PdfEncadre` (`PdfUtils.pas`, appelé une fois
par emplacement), et c'est seulement la silhouette du personnage en arrière-plan qui
vient d'une image, mais un asset dédié déjà existant (`SHADOW.png`, 55x72mm,
`ConstCheminPdfShadow`), pas `BACK.png` (qui est le fond de page complet de l'ancien
PDF, sans rapport) - confirmé par Nono de mémoire. Le modèle de données ne distingue
pas gauche/droite : `ArmureBras` sert aux deux bras (primaire ET secondaire),
`ArmureJambe` aux deux jambes, une seule valeur écrite deux fois à des coordonnées
différentes. `ArmureBouclier` (protection du bouclier, calculée à part dans les
branches Armes - voir plus haut) fait aussi partie de ce bloc.

- ✅ Bloc "Armour Points" implémenté (`PdfBlocArmourPoints`, cadre + contenu comme
  `PdfBlocDessinExplication` : troisième pattern de bloc). Combine une image
  (`PdfImgShadow`, chargée une seule fois au début de la page 2 de
  `PdfPersonnageCreationFeldo2P` via `PdfDoc.Images.AddFromFile` — `PdfDoc` n'étant pas
  accessible depuis un bloc séparé, seul l'identifiant Integer est passé en paramètre,
  comme `PdfImgWarhammer`/`PdfImgFantasy`/`PdfImgUbersreik`) et 7 appels à `PdfEncadre`
  (Tête/Bras droit/Jambe droite/Bouclier/Bras gauche/Corps/Jambe gauche). `(X, Y)` =
  coin bas-gauche de l'image, exactement comme `(135, 190)` dans l'ancien PDF - tous
  les décalages internes (offsets vers chaque `PdfEncadre` et chaque `WriteText` de
  valeur) reproduisent à l'identique les coordonnées absolues de l'ancien bloc, juste
  traduits par rapport à ce nouvel ancrage (même taille 55x72mm, mêmes écarts relatifs,
  validé avec Nono - pas de mise à l'échelle). Positionné sous l'Encombrement, ancré à
  `X = DessinDebColG`. `PdfFontBack`/`PdfFontValue` (globales de `ChargeConstantes.pas`,
  pas des paramètres) : `PdfEncadre` écrit ses étiquettes en `PdfFontBack` (Carlson Bold
  10, comme l'ancien PDF), puis on repasse en `PdfFontValue`/Arial 9 pour les valeurs
  numériques - à l'identique de l'ancien bloc. **Changement de signature** :
  `ArmureBouclier` était calculé dans `PdfBlocArmesDonnees` mais jamais relu (item
  pré-existant listé dans `A FAIRE.txt`) - remonté en paramètre `out` pour alimenter ce
  nouveau bloc ; seul appel corrigé dans le même mouvement. Poussé le 15/08/2026.
- ✅ Retour de Nono sur le premier rendu ("presque parfait", capture d'écran à l'appui) :
  deux ajustements demandés — un cadre autour du bloc, et un peu plus d'espace entre
  l'Encombrement et le bloc. Ajouté dans `PdfBlocArmourPoints` : un cadre (`DrawLine`)
  avec 4mm de marge à gauche/droite/haut autour de l'image, 8mm en bas pour laisser la
  place à l'étiquette "Shield" qui déborde sous l'image (`PdfEncadre` avec
  `Bouclier = true` dessine son étiquette 7.5mm sous le point d'ancrage). Poussé le
  15/08/2026, pas encore testé/compilé par Nono à ce stade.
- ✅ Nono renvoie une capture pleine page : le coin haut-gauche du bloc lui semble mal
  calculé, il veut qu'il tombe exactement sous le coin bas-gauche du cadre Encombrement,
  avec le même espace qu'entre Sorts et Encombrement. **Bug réel trouvé** : le calcul du
  bas d'Encombrement dans le nouveau bloc oubliait le "+1" que tous les autres blocs
  appliquent au nombre de lignes pour retrouver le vrai bas d'un cadre (voir
  `PdfBlocEncombrement` : bas = `Y - ((NbLignes+1)*HauteurLigne)`) - le nouveau bloc
  démarrait donc quasiment collé sous l'Encombrement (écart réel d'à peine 0.4mm) au
  lieu de l'espace visé. `PdfBlocArmourPoints` réécrit : `(X, Y)` reçu est maintenant le
  coin **HAUT-GAUCHE du cadre** (plus l'ancien coin bas-gauche de l'image), aligné
  exactement sur `DessinDebColG` comme tous les autres blocs de la page (plus de
  décalage de 4mm vers la gauche) ; l'image et les 7 `PdfEncadre` sont recalculés en
  interne (`ImgX`/`ImgY`, décalés de 4mm par rapport au cadre) par rapport à ce nouveau
  point d'ancrage. Appel corrigé pour utiliser exactement le même `-3` que
  Sorts→Encombrement partout ailleurs sur la page :
  `DessinHautArmourPoints := DessinDebutHautEnc - ((DessinNbLigEnc + 1) *
  DessinHauteurEnc) - 3;`. Var renommée `DessinBasArmourPoints` → `DessinHautArmourPoints`
  (reflète maintenant le haut du cadre, pas le bas de l'image comme avant). **Point
  d'attention pour le prochain test** : la page 2 de Feldo2P est déjà chargée (5 blocs
  empilés avant celui-ci) ; avec ce repositionnement, le bas du cadre se retrouve à
  environ 9mm du bas de la page (calcul à la main, pas vérifié par un rendu réel) - à
  surveiller si Nono voit quoi que ce soit de coupé ou de trop proche du bord en bas.
  Poussé le 15/08/2026, confirmé par Nono ("c'est bon") - positionnement et cadre
  corrects.

**✅ Chantier "refonte Bloc/Tableau de `PdfPersonnageCreationFeldo2P`" terminé et
confirmé par Nono le 15/08/2026** : 5 blocs "cadre uniquement" (Armures/Équipement/
Armes/Sorts/Encombrement), 4 boucles de remplissage (Sorts/Divers/Armes/Armures), 2
blocs "cadre + contenu" (DessinExplication, Armour Points). Nono s'arrête ici pour
l'instant ("ce chantier est fini, je m'arrête un peu").

**Prochaine étape (à la reprise)** : rien d'urgent en cours - au choix de Nono selon
l'envie du moment :
- le bloc Blessure actif et le bloc Compétence de combat de la page 2 (candidats pour
  une brique ultérieure, non demandés pour l'instant) ;
- appliquer la même approche Bloc/Tableau à l'ancienne `PdfPersonnageCreation` (page 1) ;
- un des autres chantiers listés dans `A FAIRE.txt` (nettoyage des variables inutilisées
  pré-existantes, astérisques numérotées croisées, refonte sorts liés aux talents, etc.).

---

### 2.5 Astérisques numérotées croisées — armure → compétence — en cours (démarré le 15/08/2026)

**Rappel de l'idée** (capturée dans `A FAIRE.txt`) : aujourd'hui, chaque astérisque
(talent, compétence/caractéristique) s'affiche indépendamment, sans lien visible entre
l'élément qui cause le bonus/malus et l'élément affecté. Nono voudrait qu'une armure
qui inflige un malus à une compétence (typiquement Discrétion/Perception) porte une
astérisque numérotée, et que la compétence affectée porte la même astérisque en face —
un vrai renvoi partagé, pas juste "il y a un malus ici".

**Découverte de départ** : un mécanisme équivalent existe déjà pour les talents
(`Personnage.Asterisque` + `PersonnageTalentAsterisque` + `ListTalentAttributModif`/
`ListTalentCompetenceModif`, `chargepersonnage.pas`), entièrement câblé jusqu'à
l'affichage PDF (`PdfBlocTalents` + `TPdfValeurCase.Annotation` via `DessinerTableau`).
Ce qui manque spécifiquement, c'est l'équivalent côté armure : `StructureArmureBonus.Malus`
(`ChargeArmureBonus.pas`) n'était jusqu'ici que du texte libre anglais (ex. `"Stealth
-10"`), sans lien structuré vers un code de compétence ni valeur numérique exploitable.

**Décisions de conception validées par Nono** :
- Affichage : la valeur de base de la compétence reste inchangée en police normale ;
  chaque source de malus (chaque pièce d'armure portée) obtient sa propre annotation en
  petite police avec son propre pourcentage, ex. `(5) -10% (6) -20%` — pas une seule
  astérisque cumulée, car un personnage peut porter certaines pièces d'un ensemble sans
  les autres (ex. la maille mais pas la coiffe).
- Numérotation : au moment de la génération du PDF, relire le maximum déjà utilisé par
  `Personnage.Asterisque` (posé par le système de talents au chargement du personnage)
  et continuer à partir de là, sans jamais réécrire cette valeur dans les données du
  personnage — évite les doublons sans avoir à synchroniser deux phases de calcul
  distinctes (chargement vs génération PDF).

**Syntaxe XML retenue pour `<Modifier>`** (mêmes conventions que le système de talents
existant, pas une invention isolée) : le fichier réel `BOOK_RULESBOOK.Xml` utilise déjà,
pour les talents, `<ModifySkill name="RULES-COMPXXX">"Bonus"</ModifySkill>` — un attribut
`name` (constante `ConstXmlData = 'name'`) portant le code de compétence complet, lu et
ajouté (pas écrasé) dans une liste (`ListTalentCompetenceModif`) à chaque balise
rencontrée. Repris à l'identique pour l'armure, avec la valeur numérique signée en
contenu texte (comme `<ModifyCarac name="RULES-ATTR_Fel">+5</ModifyCarac>`, pas de
guillemets autour d'un nombre) :
`<Modifier name="RULES-COMPDISC_*">-10</Modifier>`. Une balise sans attribut `name`
reste une note mécanique libre (ex. `"combinable with Plate"`), comportement inchangé —
c'est la présence de l'attribut qui distingue les deux cas au chargement.

**Implémenté et confirmé (15/08/2026)** :
- Nouvelle unit `ChargeArmureBonusModif.pas` (calquée sur `ChargeTalentCompetenceModif.pas`) :
  `StructureArmureBonusModif` (`Livre`, `CodeArmureBonus`, `CodeCompetence`, `Valeur:
  Integer`) + `TListArmureBonusModif` + `ListArmureBonusModif`/`NbArmureBonusModif`.
  Instanciée dans `WarhammerSource.pas` (`TMenu.FormCreate`, à côté de
  `ListArmureBonus := TListArmureBonus.Create;`) — fait par Nono directement (via
  l'IDE), confirmé compilant.
- `xmlexportimport.pas`, bloc de lecture `<DATA_ARMOR_BONUS>` (`ConstXmlPositifNegatif`,
  `'Modifier'`) : si la balise a l'attribut `name`, ajoute une entrée à
  `ListArmureBonusModif` (`CodeCompetence` = valeur de l'attribut, `Valeur` =
  `StrToInt` du contenu) au lieu d'écraser `PArmureBonus.Malus` ; sinon, comportement
  inchangé (texte libre dans `.Malus`). Corrige au passage le bug latent déjà repéré
  (plusieurs `<Modifier>` sur une même entrée n'auraient gardé que le dernier lu) —
  plusieurs balises structurées sur une même `<BonusMalus>` s'accumulent maintenant
  naturellement dans la liste.
- **Bug réel trouvé et corrigé pendant le test** : `PArmureBonus` est réutilisée d'un
  tour de boucle à l'autre sans être réinitialisée. Avant ce chantier, `.Malus` était
  toujours réécrit (chaque entrée avait un unique `<Modifier>` texte libre) donc ça ne
  se voyait jamais. Depuis que certaines entrées passent par la branche structurée
  (qui n'écrit plus `.Malus`), une entrée structurée gardait le `.Malus` de l'entrée
  précédente lue dans le même livre (repéré par Nono dans WinArmor : "Not discreet"
  affichait le texte de malus de "Weakpoints"). Corrigé en réinitialisant
  `PArmureBonus.Malus := '';` au tout début de chaque `<BonusMalus>`, avant la lecture
  du `<Modifier>`.
- `BOOK_RULESBOOK.Xml` et `BOOK_RULESBOOK_FRANCAIS.Xml` (`DATABASE/`) : les 4 entrées
  liées à une compétence converties au nouveau format — `ARMOB_05`/`ARMOB_19`
  (Discrétion, `name="RULES-COMPDISC_*"`, -10/-20) et `ARMOB_06`/`ARMOB_07`
  (Perception, `name="RULES-COMPPRECEP"`, -10/-20). Les 5 autres entrées mécaniques
  (`ARMOB_01,02,03,04,08`) inchangées, toujours en texte libre.
- Confirmé par Nono par test dans WinArmor : le tableau Bonus/Malus n'affiche plus de
  texte incohérent (colonne Penalty vide pour les 4 entrées converties — attendu, rien
  n'affiche encore la valeur structurée dans WinArmor à ce stade), l'explication en
  dessous du tableau reste correcte.

**✅ Colonne Penalty de WinArmor comblée (16/08/2026)** : dans
`TWinArmors.TabArmorSelection` (`winarmor.pas`), quand `PArmureBonus.Malus` est vide
(les 4 entrées converties), le texte de la colonne Penalty est reconstruit en
parcourant `ListArmureBonusModif` pour ce `CodeArmureBonus` et en affichant
`ChercheCompetence(CodeCompetence).Libelle + ' ' + Valeur + '%'` (plusieurs entrées se
concatènent avec une virgule si une pièce affecte plusieurs compétences). Confirmé par
Nono par test : "Stealth (Any) -10%, Perception -10%". Bug de compilation rencontré et
corrigé au passage (`+=` sur une propriété indexée `TStringGrid.Cells` invalide en
Pascal — voir §4).

**✅ Régression PDF corrigée (16/08/2026)** : même cause que WinArmor — la légende
bonus/malus (`PdfBlocDessinExplication` en Feldo2P, ligne ~2542, et le bloc équivalent
non refondu de l'ancienne `PdfPersonnageCreation`, ligne ~1601, toujours utilisée en
production - confirmé par Nono) affichait un texte vide après le `:` pour les 4
entrées converties. Même correctif que WinArmor appliqué aux deux endroits
(reconstruction depuis `ListArmureBonusModif` si `.Malus` est vide). Confirmé par
Nono par test PDF réel : `Not discreet:Stealth (Any) -10%`, `Narrow the
view:Perception -10%`.

**✅ Chantier "astérisques armure → compétence" terminé et confirmé par Nono le
16/08/2026.** Décision finale sur la légende (clarifiée par Nono en route) : pas de
bloc légende séparé ni d'ajout dans `PdfBlocDessinExplication` — le pourcentage
affiché directement à côté de la valeur de compétence suffit, l'objectif étant
d'alerter vite le joueur, pas de le renvoyer sur une autre page. En revanche, le même
numéro s'affiche aussi à côté de la pièce d'armure elle-même (tableau Armures, page
2), pour qu'on puisse retrouver quelle pièce cause quel malus - même principe que les
talents (`PdfPersonnageTalentBonus`/`PdfBlocTalents`, `(N)` à côté du nom).

Implémentation (`pdfpersonnage.pas`) :
- `PdfPersonnageArmureAsterisques(Personnage; out AsterisqueParEquipement): TStringList`
  — nouvelle fonction pure (aucun dessin), même résolution armure normale/simplifiée
  que `PdfBlocArmuresDonnees` mais sans rien dessiner, appelable avant la page 1 (les
  données d'équipement du personnage sont connues dès le départ). Une astérisque par
  PIÈCE portée ayant au moins un code de bonus lié à une compétence (pas par code —
  deux pièces différentes avec le même code gardent chacune leur numéro), numérotation
  continuant après `Personnage.Asterisque` sans jamais l'écrire. Renvoie deux
  `TStringList` à libérer par l'appelant : le `Result` (`CodeCompetence -> " (5) -10%
  (6) -20%"`, à concaténer à l'annotation des talents) et `AsterisqueParEquipement`
  (`CodeEquipement -> "(5)"`, pour l'affichage côté armure).
- `PdfPreparerRecordSetCompetencesBase`/`Groupees` : nouveau paramètre
  `AnnotationArmure: TStringList`, concaténé à la suite du texte de
  `PdfPersonnageCompetenceBonus` existant (même emplacement, même mécanisme
  `TPdfValeurCase.Annotation` que les talents - pas un nouvel affichage séparé).
- `PdfBlocArmuresDonnees` : nouveau paramètre `AsterisqueParEquipement: TStringList`,
  affiché en police 4 juste après le libellé de la pièce (même principe visuel que
  `PdfBlocTalents`).
- `PdfPersonnageCreationFeldo2P` : les deux listes sont calculées une seule fois avant
  les tableaux de Compétences de la page 1 (`ListAsterisqueArmure`/
  `AsterisqueParEquipement`), et libérées après l'appel à `PdfBlocArmuresDonnees` sur
  la page 2 (dernier endroit où `AsterisqueParEquipement` sert).
- **Bug de mise en page trouvé et corrigé pendant le test** : le premier rendu
  affichait `(5)` et `-10%` sur deux lignes non alignées. Cause : `PdfEcrit` (retour à
  la ligne automatique si le texte dépasse la largeur disponible) — la boîte
  d'annotation du tableau Compétences (`DessinerTableau`, orientation `orLigne`) ne
  faisait que 8.5mm, suffisant pour les annotations de talent seules (`><(3)`, 4-5
  caractères) mais pas pour `(5) -10%` (8+ caractères). Élargie à 13mm - ce
  `PdfEcrit` est spécifique au champ `Nom` des tableaux Compétences (`Valeurs[0]`),
  ne touche pas l'annotation du tableau Caractéristiques (`orColonne`, autre
  `PdfEcrit`, table différente).
- **Limite connue, pas un bug** : la correspondance armure→compétence est une
  comparaison EXACTE de code (`CompareRechercheValeur`, pas de recherche floue) - un
  code générique comme `RULES-COMPDISC_*` ("Discrétion" toutes variantes) ne matche
  que si le personnage a littéralement cette compétence générique, pas une variante
  spécialisée type "Discrétion (Urbain)". Même limitation préexistante que le système
  de talents (`ListTalentCompetenceModif`), pas quelque chose d'introduit ici.

Confirmé par Nono par test PDF réel, sur les deux points (alignement compétence +
présence du numéro dans le tableau Armures) : "c'est bon".

**Idée liée, pas conçue, capturée dans `A FAIRE.txt`** : `BOOK_RULESBOOK_FRANCAIS.Xml`
contient en fait toutes les données (pas seulement les traductions), alors que seul le
chargement du livre anglais alimente réellement les listes utilisées par le programme —
Nono aimerait nettoyer ce fichier mais craint de tout casser à la main.

---

### 2.6 Historique de corruption par personnage — en cours (démarré le 16/08/2026)

**Rappel de l'idée** (capturée dans `A FAIRE.txt` le 16/08) : garder, pour chaque
personnage, un historique des points de corruption gagnés/perdus au fil du temps (montant
signé + libellé expliquant la raison), consultable et modifiable dans un nouvel onglet
"Corruption" de WinPersonnage (boutons Ajouter/Modifier), et résumé sur le PDF. Motivation
de Nono : "cela permet aussi de calculer le nombre de points de corruption encore
disponibles" — donc l'historique doit s'accrocher au plafond de corruption déjà calculé
par le programme, pas réinventer un système parallèle.

**Système existant retrouvé** (rien à modifier ici) : `PdfBlocCorruption` (`pdfpersonnage.pas`
~2026) dessine déjà un panneau "Tolérance/Volonté/Bonus/Total" calculé à la volée à chaque
génération PDF, jamais stocké : Tolérance = Bonus Endurance/10, Volonté = Bonus Force
Mentale/10, Bonus = valeur du talent Âme Pure (0 si absent), Total = somme des trois. C'est
exactement le plafond WFRP4e de points de corruption avant mutation — la case "Total" que
le nouvel historique doit venir consommer.

**Conception validée par Nono** :
- Sens des montants : positif = corruption gagnée (vient réduire la marge), négatif =
  corruption perdue/purifiée — rare, sauf au moment où le plafond est atteint (le
  personnage repart à 0 et prend une mutation — chantier suivant, pas encore abordé).
- PDF : le panneau `PdfBlocCorruption` existant passe de 4 à 6 lignes (Bonus T / Bonus WP /
  Pure Soul / Total / **Lost** / **Left**), avec Lost = somme des montants de l'historique
  et Left = Total − Lost. En plus de ça, un **nouveau tableau détaillé** (Montant | Libellé,
  le détail gagné/perdu ligne par ligne) est ajouté sur la page 1, à droite
  d'Expérience/Corruption, dans l'espace libéré par le réagencement ci-dessous.
- Réagencement page 1 nécessaire (pas encore fait) : Résilience/Destin raccourcis pour
  mettre Mouvement à côté (même ligne) ; le panneau Corruption déplacé sous Expérience
  (au lieu d'être à côté, comme actuellement).
- Toutes les balises XML (chapitre, nœuds, attributs) et tous les libellés PDF
  (`GetTexteLibelle`) doivent rester en anglais, même logique que l'existant — pas de
  français introduit dans la structure ou l'affichage PDF (seul le libellé de la raison,
  texte libre saisi par le joueur, peut être dans sa langue).

**Ordre de travail retenu, une pièce à la fois** :
1. ✅ Couche de données : `StructurePersonnageCorruption` (Montant, Libelle) +
   champ `Personnage.Corruption` (`chargepersonnage.pas`). Compile, confirmé par Nono.
2. ✅ Persistance XML : nouveau chapitre `ConstXmlChapitreCorruption = 'CHAPTER_CORRUPTION'`
   (`chargeconstantes.pas`), sauvegarde/chargement dans `chargepersonnage.pas` — même
   pattern que `Equipement`/`MetierAncien` (une ligne `<Item name="Montant">"Libelle"</Item>`
   par entrée, pas de sous-chapitres). Compile, confirmé par Nono (ouverture d'un
   personnage existant sans crash).
3. ⏳ Onglet "Corruption" dans WinPersonnage (grille + boutons Ajouter/Modifier) — pas
   commencé, prochaine étape.
4. ⏳ Réagencement PDF page 1 (Résilience/Destin/Mouvement/Corruption) — pur repositionnement.
5. ⏳ Extension de `PdfBlocCorruption` (lignes Lost/Left).
6. ⏳ Nouveau tableau détaillé PDF (Montant | Libellé).

Les étapes 4-6 (PDF) s'ajustent comme d'habitude par allers-retours captures d'écran sur
le rendu réel, pas de spec pixel-perfect figée à l'avance.

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
- Ne jamais comparer un `CodeTalent`/`CodeSort`/etc. par position brute (`copy(Code,1,N)`) en
  supposant l'absence de préfixe de livre (`LIVRE-CODE`) : ça casse dès qu'un livre est ajouté
  et que le code se retrouve préfixé. Utiliser `DecoupeCodeValeur`/`CodeValeur` (unitcalcul.pas)
  ou `CompareRechercheValeur`, qui gèrent déjà le découpage. Bug réel trouvé le 15/08/2026 dans
  `TWinPersonnages.SortAffiche` (winpersonnage.pas) : `copy(Tal,1,5) = TalentSortBenediction`
  ne matchait plus depuis l'ajout d'un livre, empêchant l'ajout automatique des sorts liés à un
  talent de Bénédiction - corrigé en insérant `DecoupeCodeValeur(Tal)` avant la comparaison.
- `CompareRechercheValeur` fait une comparaison EXACTE du code (après retrait du préfixe de
  livre), pas une comparaison de préfixe : `(LivreRecherche=LivreValeur) and
  (CodeRecherche=CodeValeur)`. Pour les catégories de talent qui existent en variantes
  suffixées par divinité/domaine (Miracle `T0080_*`, Domaine `T0088_*` - voir
  `BOOK_RULESBOOK.Xml`), comparer avec `CompareRechercheValeur(Code, TalentSortMiracle)` ne
  matche donc jamais, même sans problème de préfixe de livre. Bug réel trouvé le 15/08/2026
  dans `TWinPersonnages.ButtonSortClick` (winpersonnage.pas) : les trois vérifications
  (Domaine/Miracle/MagieMineure) utilisaient `CompareRechercheValeur` contre les constantes
  brutes `TalentSortDomaine`/`TalentSortMiracle`/`TalentSortMagieMineure` - corrigé en
  `DecoupeCodeValeur(...)` puis `copy(CodeValeur,1,5) = TalentSortXXX` (comparaison de préfixe
  sur les 5 premiers caractères, cohérente aussi pour MagieMineure/T0089 qui n'a pas de
  variante suffixée).
- `TStringGrid.Cells[Col, Row]` (et toute propriété indexée avec getter/setter, plus
  généralement) n'est pas une vraie variable (l-value) : `+=` dessus échoue à la
  compilation avec "Variable identifier expected" (pas une erreur logique, une erreur de
  compilation). Utiliser une réaffectation complète : `Cells[C,R] := Cells[C,R] + '...';`.
  Bug réel trouvé le 16/08/2026 dans `TWinArmors.TabArmorSelection` (winarmor.pas) en
  construisant le texte de malus à partir de plusieurs entrées de `ListArmureBonusModif`.

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
