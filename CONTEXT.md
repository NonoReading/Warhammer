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

**⚠️ Séquelle trouvée le 21/08/2026 (corrigée) : annotation affichée deux fois.** Sur le PDF de
Gunther Krieg, Discrétion portait `(4) -10%` **deux fois**, Perception `(5) -10%` deux fois.

Le raisonnement qui a mené à la cause tient en une observation : c'était **le même numéro** sur les
deux lignes. L'astérisque étant attribuée une fois par pièce (`AsterisquePiece`), deux pièces
différentes auraient donné `(4)` puis `(5)` — un numéro répété veut dire que la même entrée est
parcourue deux fois dans `ListArmureBonusModif`. L'annotation devenait `" (4) -10% (4) -10%"`,
coupée en deux lignes par le retour à la ligne de `PdfEcrit`.

Cause réelle, sans rapport avec le PDF : **`ListArmureBonusModif.Clear` manquait dans le bloc de RAZ
de `ChargerLivre`** (`warhammersource.pas`). La liste avait été créée dans `FormCreate` pendant ce
chantier (par Nono via l'IDE), mais le `.Clear` correspondant n'a jamais suivi. Chaque rechargement
— changement de livre actif (`TabLivreDblClick`) ou de langue — rempilait donc les 4 entrées.
**Au premier lancement le PDF est correct** ; il double au premier rechargement, triple au second.

`ListArmureSimplifiee` était dans le même cas, trouvée en comparant les listes créées aux listes
vidées — corrigée en même temps. Les deux compteurs (`NbArmureSimplifiee`, `NbArmureBonusModif`)
étaient également absents de la RAZ.

Les 7 autres écarts de cette comparaison sont volontaires : `ListTexte` et `ListTraduction` ne
doivent **surtout pas** être vidées ici (contre-correctif du 18/08, §2.8), `ListLivre`,
`ListLivreTraduit`, `ListeAttribut`, `ListeAttributAugmentation` et `ListeCompetenceAugmentation`
sont remplies ailleurs.

**Idée liée, pas conçue, capturée dans `A FAIRE.txt`** : `BOOK_RULESBOOK_FRANCAIS.Xml`
contient en fait toutes les données (pas seulement les traductions), alors que seul le
chargement du livre anglais alimente réellement les listes utilisées par le programme —
Nono aimerait nettoyer ce fichier mais craint de tout casser à la main.

---

### 2.6 Historique de corruption par personnage — terminé (16/08/2026)

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
3. ✅ Onglet "Corruption" dans WinPersonnage : `TabSheetCorruption` + grille
   `StringGridCorruption` (colonnes Amount/Reason, édition directe en place, même style que
   `TabFabrication`/`TabAugmentationTalent` - pas de fenêtre de saisie séparée, ça n'existe
   nulle part ailleurs dans le projet) + boutons `ButtonCorruptionAjoute`/
   `ButtonCorruptionSupprime` (`TBCButton`, composants ajoutés par Nono directement dans
   l'éditeur Lazarus). Chargement dans `XmlChargePersonnage` juste après l'Équipement,
   sauvegarde par récolte de la grille dans `XmlSauvegarde()` juste avant
   `PersonnageXmlCreation` (pas dans `CalculTableExperience`, la corruption n'a pas besoin
   d'être recalculée en continu). Nouvelles clés de texte `LAB_162..165`/`MESS_053`
   (anglais + français, `BOOK_RULESBOOK.Xml`/`BOOK_RULESBOOK_FRANCAIS.Xml`) ; `LAB_156`
   ("Corruption") réutilisée pour le titre de l'onglet. Bug de visibilité rencontré et
   corrigé en route (`TShape` de fond qui recouvre les nouveaux contrôles, voir CONTEXT.md
   §4). Confirmé par Nono : ajout/suppression de lignes, cycle sauvegarde/rechargement.
4. ✅ Réagencement PDF page 1 : `PdfBlocResilience`/`PdfBlocDestin` resserrés de 78mm à
   53mm (repères internes 29.9/40/69/78 → 20/27/46/53 pour Résilience, 29/38 → 17/24 pour
   Destin, proportionnels à l'ancien) pour laisser `PdfBlocMouvement` sur la même rangée
   (X = début colonne + 56mm) ; `PdfBlocCorruption` déplacé sous Expérience (même colonne,
   même largeur que `PdfBlocExperience`) au lieu d'être à côté. Confirmé par Nono : bon
   placement. En testant, bug PRÉEXISTANT découvert (sans lien avec ce chantier) et corrigé :
   des `(-1)` parasites s'affichaient à côté de chaque talent - voir CONTEXT.md §4 (pattern
   "variable record réutilisée jamais remise à zéro", `PersonnageTalent.Asterisque`).
5. ✅ Extension de `PdfBlocCorruption` (lignes Lost/Left) : panneau porté de 4 à 7
   lignes (titre + Bonus T/Bonus WP/Pure Soul/Total/**Lost**/**Left**), `NbLignes` 4 → 6,
   tous les décalages `(NbLignes - K)` recalculés. `Lost` = somme de
   `Personnage.Corruption[].Montant` (calculée dans `PdfPersonnageCreationFeldo2P` et
   passée en paramètre), `Left = Total - Lost`. Nouveau paramètre `Lost: Integer` ajouté
   à la signature de `PdfBlocCorruption` (déclaration + implémentation, un seul point
   d'appel). Nouvelles clés `PDF_CORRUPTION_LOST`/`PDF_CORRUPTION_LEFT` ("Lost"/"Left",
   "Perdu"/"Restant") dans les deux livres. Confirmé par Nono par test PDF réel :
   Total 10 / Lost 2 / Left 8.
6. ✅ Nouveau tableau détaillé PDF (Montant | Libellé) : nouveau bloc
   `PdfBlocCorruptionDetail`, à droite d'Expérience/Corruption (X = bord droit de ce
   panneau + 3mm, jusqu'à `DessinFinColG`), même Y de départ que `PdfBlocExperience`.
   Une ligne par entrée de `Personnage.Corruption`, la plus récente en haut (parcours
   `High(...) downto Low(...)`) ; au-delà de la capacité du cadre (9 lignes), les plus
   anciennes sont silencieusement omises (même limite que `PdfBlocDiversDonnees` pour
   Divers). Titre "CORRUPTION HISTORY"/"HISTORIQUE DE CORRUPTION" (nouvelle clé
   `PDF_CORRUPTION_HISTORY` ; "HISTORY" seul écarté par Nono, ambiguïté avec l'onglet
   Historique existant) ; en-têtes de colonnes Amount/Reason (réutilise `LAB_162`/`163`).
   Bug de mise en page trouvé et corrigé en route : `PdfEcrit` répartit un libellé trop
   long sur 2 lignes autour du Y donné (±1mm) ; avec le décalage standard +0.6 la 2e ligne
   déborde sous la bordure du bas de la rangée. Corrigé par un décalage +2 quand le
   libellé dépasse 18 caractères (même heuristique de longueur que `PTalent.Resume` dans
   `PdfBlocTalents`, voir plus haut dans le fichier). Confirmé par Nono par test PDF réel.

Les étapes 4-6 (PDF) se sont ajustées comme d'habitude par allers-retours captures d'écran sur
le rendu réel, pas de spec pixel-perfect figée à l'avance.

### 2.7 Mutation quand la corruption atteint son maximum — en cours (démarré le 16/08/2026, dernière mise à jour le 17/08/2026, étape 9)

**Mécanisme** (conception validée par Nono) : quand `Left` (voir §2.6) atteint 0, le joueur
choisit entre dépenser un point de Résilience définitivement, ou accepter une mutation.
Dans les deux cas l'historique de corruption repart à 0. Accepter une mutation tire un D100
en deux temps : d'abord contre `DATA_CORRUPTION_PHYSICAL`/`DATA_CORRUPTION_MENTAL` (déjà
dans le XML, par race) pour savoir Physical ou Mental, puis un second D100 (indépendant,
plage complète) contre la table correspondante (Physical/Mental Corruption Table, texte du
livre donné par Nono) pour l'entrée précise. Les deux tirages offrent les trois mêmes
options que la création de personnage (`wincreation.pas`) : Hasard (aléatoire), Résultat
(le joueur donne son propre jet), Choix (sélection directe dans une liste - utile pour
saisir la corruption d'un personnage déjà existant sur papier). Exception : les races sans
choix possible pour un des deux types (ex. Elfes, "-" dans `DATA_CORRUPTION_PHYSICAL`)
n'auront que Mental disponible.

Popup `WinLanceDes` (winlancede.pas) repérée en cours de route - mécanisme générique
"lancer le dé" déjà à moitié écrit mais câblé uniquement pour le tirage de Talent, pas
finalisé (`GetTexteLibelle('LAB_xxx')` encore en placeholder). Non retenue pour l'instant :
Nono reste sur le pattern radio-boutons intégrés à l'onglet (comme Race/Métier/Attribut
dans `wincreation.pas`) plutôt que de généraliser cette popup. Idée de généralisation notée
dans `A FAIRE.txt` pour plus tard.

V1 scope : les effets de mutation ("+10 Dexterity", "Gain the Tentacles Creature Trait"...)
sont enregistrés en texte (nom + effet) mais **pas appliqués automatiquement** au
personnage - beaucoup d'effets ne sont pas de simples deltas de caractéristique (Traits de
Créature, jets de Localisation, conditions de Psychologie), donc une application 100%
automatique ne couvrirait de toute façon pas tout. L'automatisation façon
`ListArmureBonusModif` (astérisque + application directe) est explicitement différée à une
version ultérieure.

**Étape 1 (✅ terminée)** : couche de données pour les deux tables du livre (Physical/
Mental Corruption Table, 20 entrées chacune, D100 + Description + Effet) :
- Nouvelle unit `ChargeCorruptionTable.pas` : `StructureCorruptionTable` (Livre,
  TypeCorruption, Chance, Libelle, Effet) + `TListCorruptionTable`, même forme que
  `ChargeRaceCorruptionCreation.pas`.
- Nouveaux chapitres XML `DATA_CORRUPTION_TABLE_PHYSICAL`/`DATA_CORRUPTION_TABLE_MENTAL`
  (`BOOK_RULESBOOK.Xml`/`BOOK_RULESBOOK_FRANCAIS.Xml`), entrées `<Corruption name="01-05">`
  avec enfants `<Libelle>`/`<Effet>` (nouvelles constantes `ConstXmlLibelle`/`ConstXmlEffet`,
  `chargeconstantes.pas`). Le "00" final (96-00) représente 100 en D100 (deux d10) - **pas
  encore géré par le code de découpage de plage existant** (`TabRaceResultat` et
  équivalents lisent `StrToInt('00') = 0`, donc un jet de 100 ne matcherait jamais la
  dernière ligne) : à traiter au moment d'écrire le tirage.
- Chargement dans `xmlexportimport.pas`, même emplacement que `DATA_CORRUPTION_PHYSICAL/
  MENTAL`. Contrairement à ce couple (qui ne stocke qu'un nombre, identique dans les deux
  langues, donc chargé une seule fois sur la passe anglaise), Libelle/Effet sont du texte
  réellement traduit : passe par le système `InitTrad`/`AddTrad`/`Traduit` déjà utilisé pour
  Talent/Race/Métier/etc. (`ChargeTraduction.pas`), avec une clé composée
  (`TypeCorruption + ' ' + Chance`, via le paramètre `Code2` d'`InitTrad`) puisque le
  Chance seul n'est pas unique entre Physical et Mental. Nouveau cas `ConstPCorruptionTable`
  ajouté dans `Traduit()` - comparaison par égalité de chaîne stricte, PAS
  `CompareRechercheValeur` (qui suppose un préfixe livre séparé par `-`, ce qui casserait
  sur des plages D100 du type "01-05" qui contiennent déjà un `-`).
- Incohérence de contenu repérée entre "Erratic Fantasist" (EN : Initiative/Willpower) et
  "Imprévisible fantaisiste" (FR : donné initialement comme Intelligence/Force Mentale) -
  Nono confirme que la version anglaise fait foi ; `Effet` français corrigé en
  "-5 Initiative, -5 Force Mentale".
- Confirmé par Nono : compile, pas de souci au changement de livre ni à l'ouverture d'un
  personnage (donc chargement + `Traduit()` fonctionnels sur les deux tables/langues).

**Étape 2 (✅ terminée)** : logique de tirage pure, sans UI, dans `ChargeCorruptionTable.pas` :
- `CorruptionDansPlage(Plage, Jet)` : compare un jet D100 à une plage "Deb-Fin", avec le "00"
  final traité comme 100 (contrairement à `TabRaceResultat`/équivalents dans
  `wincreation.pas`, qui n'ont pas ce cas - pas touchés, nouvelle fonction indépendante).
  Une plage `-` (pas de choix pour cette race/type, ex. Elfes côté Physical) ne matche jamais.
- `CorruptionTypeResultat(CodeRace, Jet)` : Physical ou Mental pour une race/jet, via
  `ListRaceCorruptionCreation` (`DATA_CORRUPTION_PHYSICAL`/`MENTAL`) ; `''` si rien ne matche.
- `CorruptionTableResultat(TypeCorruption, Jet)` : entrée précise (nom + effet) de la table
  correspondante, via `ListCorruptionTable`.
- Confirmé par Nono : compile.

**Conception validée (16/08/2026)** : l'UI vit dans l'onglet Corruption existant de
`WinPersonnage` (pas de fenêtre séparée). Retour à 0 de l'historique : nouvelle ligne
compensatoire négative (montant = `-Lost`, libellé auto, ex. "Résilience dépensée" ou le nom
de la mutation) plutôt que suppression de l'historique - préserve le détail PDF (§2.6).
Dépense de Résilience : décrémente `Personnage.CreationAttribut` (`ATTR_Resil`), peut devenir
négatif (la base de race, elle, est intouchable), mais le TOTAL (race + CreationAttribut) ne
peut jamais descendre sous 0 - donc l'option "dépenser un point de Résilience" doit être
désactivée dès que la Résilience totale actuelle est à 0 (seule la mutation reste possible).

**Étape 3 (✅ terminée)** : affichage "Left" en direct dans l'onglet Corruption de
`WinPersonnage` (première brique d'UI de ce chantier) :
- Nouvelle fonction `PersonnageCorruptionTotal(Personnage)` dans `pdfpersonnage.pas` (juste
  après `PdfPersonnageAttribut`), qui réexpose le calcul du plafond de corruption
  (`Floor(BE/10) + Floor(BFM/10) + AmePure`, identique à `PdfBlocCorruption`) sans toucher au
  code PDF existant - `winpersonnage.pas` a `PdfPersonnage` dans son `uses`, aucune nouvelle
  dépendance.
- `LabelCorruptionLeft` : `TEdit` non modifiable (convention du projet, voir §4 - Nono ne
  parvient pas à styliser proprement un `TLabel`), ajouté par Nono dans l'IDE sur l'onglet
  Corruption.
- `TWinPersonnages.CalculCorruptionLeft` (nouvelle procédure, nommée sur le modèle
  `Calcul...` déjà utilisé dans cette classe) : `Total - somme de la colonne Montant de
  StringGridCorruption` (pas `Personnage.Corruption` directement, pour refléter les éditions
  non encore sauvegardées de la grille). Appelée au chargement d'un personnage, après
  `ButtonCorruptionAjouteClick`/`ButtonCorruptionSupprimeClick`, et depuis un nouveau
  gestionnaire `StringGridCorruptionEditingDone` (câblé manuellement par Nono dans l'Object
  Inspector, `OnEditingDone` de `StringGridCorruption`).
- **Bug trouvé et corrigé le 16/08/2026** : `PersonnageCorruptionTotal` affichait 7 alors que
  le PDF (source de vérité, confirmée par Nono) affichait 8 pour le même personnage, y compris
  juste après chargement (pas un problème de synchronisation grille/sauvegarde). Cause :
  `PdfPersonnageAttribut` compare en interne le code d'attribut reçu aux entrées `<Attribut>`
  d'un talent (bonus d'attribut donné par certains talents, ex. +5 Endurance) par ÉGALITÉ DE
  CHAÎNE STRICTE (pas `CompareRechercheValeur`) contre des valeurs XML préfixées par le livre
  (`"RULES-ATTR_WP"`). `PersonnageCorruptionTotal` appelait `PdfPersonnageAttribut` avec les
  constantes nues `ConstCaracE`/`ConstCaracFM` (`'ATTR_T'`/`'ATTR_WP'`, sans préfixe), alors
  que le code PDF (`PdfPersonnageCreationFeldo2P`) passe toujours `PAttribut.CodeAttribut`
  (préfixé, via `ListeAttribut`) - la comparaison échouait donc silencieusement côté écran, et
  tout bonus d'attribut venant d'un talent était ignoré, faisant chuter `Floor(BE/10)` ou
  `Floor(BFM/10)` d'une unité en franchissant un palier de 10. Corrigé en passant par
  `ChercheAttribut(ConstCaracE)`/`ChercheAttribut(ConstCaracFM)` (`chargeattribut.pas`, déjà
  dans le `uses` de `pdfpersonnage.pas`) pour récupérer le code complet avant l'appel à
  `PdfPersonnageAttribut` - même remède que `ChercheRaceAttribut` ailleurs dans le fichier.
  4e occurrence du piège "un seul côté d'une comparaison stripé du préfixe livre" documenté en
  §4. Confirmé par Nono après recompilation.

**Étape 4 (✅ terminée, 16/08/2026)** : UI de déclenchement + flux complet Résilience/Mutation
(tirages Hasard uniquement pour l'instant, Résultat/Choix reportés) :
- Nouveau bouton `ButtonCorruptionMutation` (onglet Corruption de `WinPersonnage`), actif
  uniquement quand `Restant` (variable renommée depuis `Left` par Nono - `Left` entre en
  conflit avec `TControl.Left`, ne compile pas dans une méthode de `TWinPersonnages`) est ≤ 0 -
  logique dans `CalculCorruptionLeft` (§2.7 étape 3), qui appelle un nouveau
  `CalculCorruptionLost()` (extrait de `CalculCorruptionLeft` pour être réutilisable).
- Nouvelle fenêtre modale `WinMutation.pas`/`.lfm` (`TWinMutations`), même principe d'échange
  que les autres fenêtres modales du projet (WinArmor etc.) : des variables `Select.../Choix...`
  partagées via `chargeconstantes.pas` plutôt qu'un passage direct de `Personnage` (aucune
  fenêtre modale existante n'en a besoin, `WinMutation` ne fait pas exception) - nouvelles
  variables `MutationCodeRace`/`MutationResilienceDisponible` (entrée) et
  `MutationChoix`/`MutationLibelle`/`MutationEffet` (sortie, `MutationChoix` = `''` / `'RESILIENCE'` /
  `'MUTATION'`). Flux dans la fenêtre : choix initial (bouton Résilience désactivé si la
  Résilience totale actuelle est à 0) → si Mutation, tirage D100 Physical/Mental
  (`CorruptionTypeResultat`) puis tirage D100 de l'entrée précise (`CorruptionTableResultat`)
  → bouton Confirmer.
- Retour dans `WinPersonnage` (`ButtonCorruptionMutationClick`) : si Résilience, cherche
  l'entrée `ATTR_Resil` dans `Personnage.CreationAttribut` (en ajoute une à -1 si absente,
  jamais écrite depuis `TabAttribut` ailleurs dans ce fichier - contrairement à
  `Personnage.Corruption`, `CreationAttribut` n'est synchronisé nulle part depuis la grille,
  donc la mutation directe du tableau est la seule façon de la faire persister) puis ajoute une
  ligne compensatoire (`-Lost`, libellé "Résilience dépensée") à `StringGridCorruption`. Si
  Mutation, ajoute la même ligne compensatoire (libellé "Mutation acceptée") PLUS une ligne à
  montant 0 dont le libellé est `MutationLibelle + ': ' + MutationEffet` - V1 : pas de nouvelle
  structure de données, `Personnage.Corruption` sert aussi de mémoire des mutations. **Revu en
  Étape 5** : Nono a repéré le lendemain que ça mélangeait ledger narratif et donnée
  structurée, remplacé par `Personnage.Mutations`.
- Nouvelles clés `LAB_166` à `LAB_170` (Annuler/Dépenser un point de Résilience/Accepter une
  mutation/Résilience dépensée/Mutation acceptée). Le type Physical/Mental est affiché via
  `GetTexteLibelle` directement sur les constantes `CorruptionPhysique`/`CorruptionMentale`
  (`'CORRUPTION_PHYSICAL'`/`'CORRUPTION_MENTAL'`), qui existaient déjà comme clés de texte dans
  les deux livres ("Physical Corruption"/"Corruption Physique" etc.) - aucune nouvelle clé
  nécessaire pour ça. Boutons Hasard/Valider réutilisent LAB_085/LAB_086 (déjà utilisées pour
  ce rôle partout dans `wincreation.pas`).
- Confirmé par Nono par test réel : tirage Mental obtenu, entrée "Hateful Impulses" (31-35,
  Mental Corruption Table) affichée avec son effet, correspond exactement au livre.

**Étape 5 (✅ terminée, 17/08/2026)** : deux pivots de conception coup sur coup, tous deux
initiés par Nono en relisant le XML sauvegardé d'un personnage après l'Étape 4 :

*Pivot 1 - liste dédiée `Personnage.Mutations`.* Nono a remarqué que la mutation obtenue
finissait comme simple ligne texte à montant 0 dans `Personnage.Corruption`
(`<Item name="0">"Hateful Impulses : ..."</Item>`), mélangée à l'historique narratif de
points. Deux problèmes : le texte résolu est figé dans la langue active au moment du tirage
(pas retraduisible, contrairement au reste du projet qui stocke des codes) et une entrée
texte libre est difficile à cibler pour une future application automatique d'effet ou pour
une future perte de mutation (Nono a confirmé via le livre que perdre une mutation est
possible, bien que très rare). Fix : nouveau type `StructurePersonnageMutation`
(`chargepersonnage.pas`) et champ `Personnage.Mutations: array of ...`, persistés dans un
nouveau chapitre XML `CHAPTER_MUTATION` (constante `ConstXmlChapitreMutation`,
`chargeconstantes.pas`) via `PersonnageXmlCreation`/le chargement, suivant le même schéma que
`Personnage.Corruption`. `Personnage.Corruption` retrouve son rôle d'origine, pur ledger de
points (seule la ligne compensatoire `-Lost` "Mutation acceptée" y reste pour ce cas).

*Pivot 2 - catalogue à code stable + table de chance séparée.* En lisant le XML de plus près
(`<Corruption name="01-05">`), Nono a réalisé qu'une plage D100 comme identité de mutation
est fragile : si un futur livre ajoute des entrées aux tables Physical/Mental, les plages
peuvent être renumérotées, ce qui repointerait silencieusement les mutations déjà
enregistrées sur des personnages existants vers une entrée différente. Fix, sur le modèle
déjà utilisé pour Talents/Races (code stable book-prefixé, jamais la position/le tirage comme
identité) : le catalogue (`DATA_CORRUPTION_TABLE_PHYSICAL`/`MENTAL`, dans les deux livres)
utilise maintenant `<Corruption name="RULES-CORPHY_NNN">`/`RULES-CORMEN_NNN">` (codes stables,
001-020, même ordre que les anciennes plages, `Libelle`/`Effet` inchangés) au lieu de la plage
D100. Deux nouveaux chapitres `DATA_CORRUPTION_PHYSICAL_CHANCE`/`MENTAL_CHANCE` (contenu
identique dans les deux livres, comme les autres chapitres purement mécaniques) portent
maintenant le lien D100 → code (`<Chance name="01-05">"RULES-CORPHY_001"</Chance>`), propre à
chaque livre et librement extensible sans perturber les codes existants.
- `ChargeCorruptionTable.pas` : `StructureCorruptionTable.Chance` renommé `.Code` ; nouveau
  type `StructureCorruptionChance` (Livre, TypeCorruption, Chance, Code) + `ListCorruptionChance`
  (même schéma de reset/init que `ListCorruptionTable` dans `warhammersource.pas`).
  `CorruptionTableResultat(TypeCorruption, Jet)` fait maintenant une recherche en deux temps :
  `ListCorruptionChance` (jet → Code) puis `ListCorruptionTable` (Code → catalogue, via
  `CompareRechercheValeur`, redevenu possible car `Code` est un vrai code book-prefixé - avant
  ce pivot, `Chance` contenait un `-` qui cassait ce découpage). Nouvelle fonction
  `ChercheCorruptionTable(Code)` (même pattern que `ChercheTalent`/`ChercheAttribut`) pour
  retrouver une mutation déjà stockée depuis son seul code.
- `xmlexportimport.pas` : chargement des deux nouveaux chapitres `_CHANCE` (même schéma que
  `DATA_CORRUPTION_PHYSICAL`/`MENTAL` - pas de traduction, chargé une fois sur la passe
  anglaise) ; `InitTrad` du catalogue simplifié pour utiliser `Code` seul (plus besoin du
  `Code2` composé `TypeCorruption+Chance`, `Code` est maintenant unique tout seul).
  `chargetraduction.pas` : `ConstPCorruptionTable` repassé au pattern standard
  `CompareRechercheValeur` (plus besoin de la comparaison de chaîne composée, contournement
  documenté comme piège potentiel maintenant obsolète pour ce cas précis).
- `Personnage.Mutations`/`StructurePersonnageMutation` simplifiés en cohérence : un seul champ
  `Code` (plus `TypeCorruption`+`Chance`). Variables d'échange `WinMutation` simplifiées en
  conséquence : `MutationTypeCorruption`+`MutationChance` fusionnées en `MutationCode`.
- Confirmé par Nono par test réel après recompilation : tirage Mental, mutation "Fearful
  Concern" (26-30, code `RULES-CORMEN_006`), sauvegardée comme
  `<Item name="RULES-CORMEN_006">""</Item>` dans `CHAPTER_MUTATION` - référence stable, plus
  de plage D100 ni de texte résolu dans le XML de sauvegarde.
- Complément demandé par Nono le même jour, en relisant ce XML : `CHAPTER_MUTATION` a reçu le
  commentaire `<!-- Libellé -->` sous chaque `<Item name="Code">` que le reste du fichier de
  sauvegarde personnage a déjà partout où c'est possible (Attributs, Compétences, Talents,
  Armes, Armures, Sorts, Ancien métier...) - convention déjà en place via `XmlCommentaire` +
  une fonction `Cherche...` de résolution Code → Libelle, `PersonnageXmlCreation`
  (`chargepersonnage.pas`). Réutilise `ChercheCorruptionTable(Code)` (ajoutée au pivot 2
  ci-dessus), même garde-fou `if Code <> ''` que Arme/Armure/Sort (au cas où un code de
  mutation stocké ne matcherait plus aucun livre chargé). En vérifiant les autres chapitres à
  la demande de Nono ("sauf oubli de ma part"), un vrai oubli préexistant (sans rapport avec
  ce chantier) a été trouvé et corrigé au passage : `CHAPTER_XP` (coûts XP hors norme -
  Attribut/Compétence/Talent) n'avait jamais ce commentaire malgré des codes tout aussi
  résolubles - ajouté avec le même schéma (`ChercheAttribut`/`ChercheCompetence`/
  `ChercheTalent`). `SUBCHAPTER_MISC` (Divers) et `CHAPTER_CORRUPTION` restent sans commentaire
  à raison : ils stockent déjà du texte libre, pas un code de catalogue. Confirmé par Nono :
  compile, commentaires corrects dans le XML de sauvegarde.

**Étape 6 (✅ terminée, 17/08/2026)** : options Résultat (saisie manuelle du jet) et Choix
(sélection directe) sur les deux tirages de `WinMutation`, jusque-là Hasard uniquement - même
principe que Race/Métier dans `wincreation.pas` (trio de `TRadioButton` dans un `TGroupBox`,
comme `GroupBoxRace`, PAS un `TRadioGroup` - Nono avait posé la question, confirmé que le
projet groupe par `Parent` commun).
- Cas particulier trouvé par Nono en concevant : la Physical Corruption Table a une entrée
  "GM's Choice" (96-00, code `RULES-CORPHY_020`) qui n'est pas une vraie mutation mais une
  instruction de consulter le MJ (Mental n'a pas d'équivalent - son 96-00, "Worried Jitters",
  est une entrée normale). Option retenue (B, choisie par Nono) : si Hasard ou Résultat tombe
  dessus, redirection automatique vers le mode Choix avec un message (nouvelle clé
  `MESS_054`) plutôt que de proposer de valider un résultat qui n'existe pas encore - repéré
  via un nouveau marqueur `CorruptionChoixMJ = 'CORPHY_020'` (`chargeconstantes.pas`, comparé
  comme les autres codes bruts du projet). Un choix VOLONTAIRE de cette entrée dans la grille
  Choix (double-clic) n'est en revanche pas redirigé (l'utilisateur vient de la choisir en
  connaissance de cause).
- `WinMutation` (`winmutation.pas`) : deux trios `TRadioButton`/`TGroupBox`
  (`GroupBoxMutationType`/`GroupBoxMutationEntree`), un `TSpinEdit` (0-100) + bouton Valider
  par tirage pour Résultat, deux boutons directs Physical/Mental pour le Choix du Type (grisés
  si la race n'a pas cette option - nouvelle fonction `CorruptionTypeDisponible(CodeRace,
  TypeCorruption)` dans `ChargeCorruptionTable.pas`, nécessaire car le Choix direct contourne
  le jet de dé qui gérait déjà ce cas via `CorruptionDansPlage('-', ...)`), et un
  `TStringGrid` (`TabMutationChoix`) pour le Choix de l'Entrée (double-clic, colonne 0
  réservée, Code caché en colonne 1, Libellé visible en colonne 2 - même convention que
  `TabCreationChoix` dans `wincreation.pas`). Logique de résolution centralisée
  (`AfficheTypeResolu`/`AfficheEntreeResolue`) partagée entre Hasard et Résultat, pour éviter
  de dupliquer la logique de redirection "GM's Choice". Changer de mode avant résolution
  repart de zéro (et invalide l'Entrée déjà résolue si on change le Type), même principe que
  `RadioButtonRaceClick` dans `wincreation.pas`.
- Piège Lazarus trouvé en cours de route (documenté aussi en §4) : les contrôles ajoutés dans
  l'IDE (nouveaux `TRadioButton`/`TBCButton`/`TStringGrid`) n'ont PAS leurs événements
  `OnClick`/`OnDblClick` câblés automatiquement juste en écrivant le code Pascal derrière -
  Nono avait bien ajouté les contrôles mais oublié de les câbler dans l'Inspecteur d'objets,
  ce qui compilait sans erreur mais laissait la fenêtre figée dans son état initial (repéré
  via une capture d'écran de Nono montrant le bouton "Randomly" toujours visible malgré un
  autre mode sélectionné).
- Confirmé par Nono par test réel après câblage : Type en mode Choix → "Physical Corruption"
  sélectionné directement ; Entrée en mode Résultat → jet 55 saisi à la main → "Inverted Face"
  (-20 to all Fellowship Tests, plage 51-55 de la table Physical), conforme au livre.

**Étape 7 (✅ terminée, 17/08/2026)** : affichage de `Personnage.Mutations` dans la fiche
personnage. Nono a demandé cet affichage en relisant l'onglet Corruption existant ("il faudrait
aussi l'afficher dans la fiche"), ce qui a fait remonter une question d'ergonomie séparée (trop
d'onglets dans `WinPersonnage`) - tranchée rapidement avec Nono via deux choix indépendants :
nouvel onglet dédié pour les Mutations (plutôt que fusionner dans l'onglet Corruption), et
réorganisation plus large des onglets remise à plus tard (notée dans `A FAIRE.txt`).
- Nono a ajouté les composants dans l'IDE (`TabSheetMutation`, `TabMutation` en `TStringGrid`,
  `MemoMutationEffet` en `TMemo`), avec `TabMutation.OnClick` déjà câblé vers `TabMutationClick`
  - Lazarus avait donc auto-généré la déclaration et un stub vide, retrouvés et remplacés par
  l'implémentation réelle (piège § câblage IDE, voir §4, cette fois repéré avant que Nono ait à
  déboguer).
- `winpersonnage.pas` : nouvelle procédure `AfficheMutations()` (reconstruit `TabMutation` ligne
  par ligne depuis `Personnage.Mutations`, résolu via `ChercheCorruptionTable(Code)` - colonne 1
  Type (`GetTexteLibelle` sur `TypeCorruption`), colonne 2 Libellé, colonne 3 Code caché pour le
  clic) et `TabMutationClick()` (affiche l'Effet de la ligne cliquée dans `MemoMutationEffet`,
  garde `if TabMutation.Row < 1 then Exit;` même style que `TabCreationChoixDblClick`). Appelée
  au chargement du personnage (`XmlChargePersonnage`, juste après `CalculCorruptionLeft();`) et
  à l'obtention d'une nouvelle mutation (`ButtonCorruptionMutationClick`, juste après
  `Personnage.Mutations += [PersonnageMutation];`). Grille configurée en lecture seule
  (`Initialisation()` : `ColCount := 4`, en-têtes `LAB_171`/`LAB_002` réutilisés, colonne 3
  cachée via `ColWidths[3] := 0`, `MemoMutationEffet.ReadOnly := True`). Piège TShape/BringToFront
  (§4) anticipé cette fois : `TabMutation.BringToFront;`/`MemoMutationEffet.BringToFront;`
  ajoutés dans `AfficheImageRace()` dès l'implémentation, avant tout test.
- Nouvelles clés `LAB_171` ("Type") et `LAB_172` ("Mutations", caption de l'onglet) ajoutées aux
  deux livres.
- Confirmé par Nono par test réel : "cela marche".

**Étape 8 (✅ terminée, 17/08/2026)** : contrairement à ce que le "V1 scope" ci-dessus prévoyait,
Nono a finalement demandé l'application automatique des effets de mutation à delta pur, en vrai
modificateur sur le personnage (pas juste une annotation texte) - d'abord sur les Attributs
(`<ModifyCarac>`), puis sur les Compétences (`<ModifySkill>`), en PDF et dans `WinPersonnage` :
- Nouvelle couche de données, calquée sur `StructureArmureBonusModif` : `StructureCorruptionAttributModif`/`StructureCorruptionCompetenceModif`
  (Livre, CodeCorruption, CodeAttribut/CodeCompetence, Valeur:Integer), chacune avec son
  `TList` (`chargecorruptionattributmodif.pas`/`chargecorruptioncompetencemodif.pas`, nouveaux
  fichiers), initialisées/nettoyées dans `warhammersource.pas`.
- `xmlexportimport.pas` : chargement des tables `DATA_CORRUPTION_TABLE_PHYSICAL`/`MENTAL`
  changé de `FindNode` (un seul enfant du même nom) à une itération `FirstChild`/`NextSibling`,
  pour supporter plusieurs `<ModifyCarac>`/`<ModifySkill>` sur une même entrée. Réutilise les
  noms de tags `ConstXmlModifieAttribut`/`ConstXmlModifieCompetence` déjà utilisés sous
  `<Talent>` - ambiguïté de nom signalée à Nono (sous `<Talent>`, `<ModifySkill>` porte un
  indicateur texte "Bonus"/"ChooseDice" ; sous `<Corruption>`, un delta numérique), pas gênante
  en pratique (parsing scopé par boucle parente), gardée telle quelle.
- XML (les deux livres, données réelles côté anglais uniquement via `LangueDef = ConstAnglais`) :
  22 entrées `<Corruption>` ont reçu un ou plusieurs `<ModifyCarac>` (Physical : CORPHY_002,
  003, 004, 006, 010, 012, 019 ; Mental : CORMEN_001, 002, 004, 005, 006, 008, 009, 011, 012,
  014, 015, 016, 017, 019, 020). Une seule entrée a un `<ModifySkill>` numérique : CORPHY_019
  (Pistage, +10). Exclus (texte seul, décisions validées avec Nono) : effets sur Movement
  (CORPHY_001/015, système d'application différent, reporté), effets modifiant un jet plutôt
  qu'une valeur (CORPHY_005/011/013, CORMEN_010/018), CORPHY_020 ("GM's Choice").
- `chargepersonnage.pas` : `PersonnageMutationAttributModif`/`PersonnageMutationCompetenceModif`
  (Personnage, Code) → somme des modificateurs de toutes les mutations du personnage pour cet
  attribut/cette compétence. Utilisées à la fois par le PDF et par `WinPersonnage` - un seul
  calcul, jamais deux implémentations à maintenir en parallèle.
- PDF : `PdfPersonnageAttribut` ajoute le delta à `Res.Base` (même case que les Talents).
  `PdfPersonnageCompetence` ajoute le delta à `Res.Total` **après** son calcul normal
  (`Base + Augmentation`), jamais à `Res.Augmentation` - voir bug ci-dessous.
- Nouveau petit tableau PDF `PdfBlocMutations` (page 2, à droite de l'image SHADOW/Armour
  Points, 3 lignes + entête, affiche les mutations les plus récentes du personnage, masque
  silencieusement les plus anciennes si ça déborde).
- Astérisques croisées étendues aux mutations (`PdfPersonnageMutationAsterisques`), chaînées
  avec le compteur déjà partagé Talents/Armure (`PdfPersonnageArmureAsterisques` prend
  maintenant `AsterisqueDepart` en paramètre au lieu de partir de `Personnage.Asterisque` en
  dur) - jamais de collision de numéro entre les trois sources. Couvre Attributs (format
  `"+N (n)"`, comme les Talents) et Compétences (format `"(n) N%"`, comme l'Armure).
- Deux bugs de rendu PDF trouvés et corrigés en testant avec Nono (`DessinerTableau`,
  orColonne, tableau Caractéristiques) : (1) l'annotation était dessinée 3mm AU-DESSUS du haut
  de sa propre ligne (`YHautLigne + 3`), donc quasiment collée à la ligne d'en-tête juste
  au-dessus (hauteur de ligne 4,6mm, à peine plus que l'offset) - corrigé en l'ancrant sur le
  bas de la ligne (même ancrage que la valeur elle-même) avec un offset de +1,5. (2) quand un
  attribut a plusieurs annotations (Talent + Mutation), elles étaient concaténées sans
  séparateur, ce qui produisait un texte trop long coupé n'importe où par le retour à la ligne
  automatique de `PdfEcrit` - corrigé en séparant à la concaténation avec un marqueur `'|'`, et
  en affichant chaque source sur sa propre ligne empilée dans `DessinerTableau` (espacement
  calqué sur celui déjà utilisé en interne par `PdfEcrit` pour ses propres cas à 2/3 lignes).
  Limite résiduelle notée dans `A FAIRE.txt` (pas un bug) : un delta à deux chiffres (ex.
  "+10") peut encore forcer `PdfEcrit` à passer sur 2 lignes même pour une seule source, la
  zone d'annotation étant très étroite (~5,9mm à la police plancher).
- `WinPersonnage`, onglet Fiche/Attributs (`TabAttribut`) : nouvelle ligne "Mutations"
  (constante `LigAttMutation`, insérée juste après `LigAttTalent`, toutes les constantes de
  ligne suivantes renumérotées, `RowCount` 12→13), masquée par défaut, affichée/masquée avec la
  même case "afficher le calcul" que Race/Lance/Talent, remplie via
  `PersonnageMutationAttributModif`, incluse dans la somme qui alimente `LigAttBase` puis
  `LigAttTotal` (`CalculTotaux`).
- `WinPersonnage`, onglet Compétences (`TabCompetence`) : nouvelle COLONNE "Mutations"
  (constante `ColCompMutation`, insérée juste après `ColCompWork` et avant `ColCompBonus`,
  toutes les constantes de colonne suivantes renumérotées, `ColCount` 17→18), même principe de
  masquage/case à cocher que les colonnes 3p/5p, 40pts, Travail, remplie via
  `PersonnageMutationCompetenceModif`.
- **Bug trouvé par Nono en testant, corrigé le 17/08/2026 (PDF et WinPersonnage)** : le delta de
  mutation sur une compétence avait d'abord été ajouté à `Res.Augmentation` (PDF) /
  `ColCompBonus` (WinPersonnage) - la colonne "Adv" du PDF, qui correspond aux avancements
  RÉELLEMENT PAYÉS et sert aussi ailleurs (ex. calcul du coût Xp, ~ligne 3814 de
  `winpersonnage.pas`) à déterminer combien de compétences ont été augmentées. Un effet de
  mutation n'est pas un avancement acheté : le mélanger à `Augmentation`/`ColCompBonus` faussait
  ce calcul (une compétence jamais achetée semblait "augmentée"). Corrigé en ajoutant le delta
  uniquement au Total final (`Res.Total`/`ColCompTotal`), jamais à `Res.Augmentation`/
  `ColCompBonus`. Conséquence attendue et confirmée correcte par Nono : une compétence Avancée
  jamais payée (donc `Augmentation = 0`) disparaît maintenant de la liste "Advanced Skills" du
  PDF même si une mutation lui donne un bonus - cohérent avec la règle (sans avancement payé, le
  personnage n'est pas censé savoir utiliser la compétence, donc pas non plus en bénéficier).
- Confirmé par Nono via tests PDF + WinPersonnage réels tout au long de l'étape.

**Étape 9 (✅ terminée, 17/08/2026)** : Nono a repris un par un les effets de mutation exclus à
l'étape 8 (Movement, familles de compétences, effets "Tests de X", Armour Points), en ajoutant
à chaque fois le mécanisme minimal nécessaire plutôt qu'un système générique unique :
- **Movement** (CORPHY_001/002/015) : traité comme "juste un attribut de plus" - aucune nouvelle
  structure, `PersonnageMutationAttributModif` réutilisé tel quel avec `ConstCaracMouvement`
  (`'ATTR_Move'`). Appliqué aux deux sites de calcul du Mouvement dans `pdfpersonnage.pas`
  (legacy page 1 et Feldo2P), juste après `Mouv := StrToInt(PRaceAttribut.CalculRace);`.
  Explicitement SANS astérisque (choix de Nono - juste le chiffre correct). PDF uniquement,
  pas de champ Mouvement dans `WinPersonnage`.
- **Familles de compétences** (CORPHY_013, "-10 to all Language Tests") : `<ModifySkill
  name="RULES-COMPLANG_*">-10</ModifySkill>` - réutilise le même tag que l'étape 8, mais
  `PersonnageMutationCompetenceModif` étendu pour tester aussi la forme générique `_*` d'une
  sous-compétence (`PCompetence.SousCompetence` + `ExtractStringBefore(...,
  ValeurSousCompetence) + ValeurGenerique`, mêmes constantes que `PdfPersonnageCompetence`
  ailleurs dans le fichier) quand le code exact ne matche pas.
- **Effets "-N to all X Tests" par attribut de rattachement** (CORPHY_011, "-20 to all
  Fellowship Tests") : nouveau mécanisme dédié, tag `<ModifySkillAttribut name="RULES-ATTR_Xxx">`
  (nom de tag délibérément distinct de `ModifySkill`, choix de Nono pour ne pas répéter
  l'ambiguïté de nom déjà notée à l'étape 8). Erreur de conception initiale corrigée en route :
  ma première proposition réutilisait `<ModifyCarac>` directement sur l'attribut, ce que Nono a
  refusé à raison ("la caractéristique va aussi descendre de 20 ?") - un effet "Tests de X" ne
  doit PAS faire baisser l'attribut affiché, seulement les compétences qui s'appuient dessus.
  Nouvelle couche `StructureCorruptionCompetenceAttributModif` (Livre, CodeCorruption,
  CodeAttribut, Valeur), ajoutée dans le même fichier que la structure de l'étape 8
  (`chargecorruptioncompetencemodif.pas`, deuxième bloc Type/List/Vars). `PersonnageMutation
  CompetenceModif` résout l'attribut de rattachement de la compétence interrogée (le sien, ou
  celui de sa forme générique si sous-compétence) et applique tous les modificateurs de cet
  attribut, sans toucher `Res.Base`/l'attribut lui-même. Bug trouvé et corrigé pendant le test
  Nono ("Gossip reste à 30... la colonne mutation est vide") : mauvais code attribut utilisé
  dans le XML (`RULES-ATTR_Soc` au lieu de `RULES-ATTR_Fel`, vérifié contre `ConstCaracSoc` et
  contre l'entrée XML réelle de la compétence Gossip) - corrigé dans les deux livres.
  Astérisque étendue au cas par-attribut dans `PdfPersonnageMutationAsterisques` (itère tout le
  catalogue `ListCompetence` pour trouver les compétences dont `CodeAttribut` matche, faute de
  code de compétence unique disponible pour ce type de modificateur).
- **Armour Points** (CORPHY_012 "+2 all locations", CORPHY_016 "+1 all locations", CORPHY_017
  "+1 Head") : PDF uniquement (pas de panneau Armure dans `WinPersonnage`). Nono avait proposé
  6 `<ModifArmour>` (un par emplacement Tête/Bras G/Bras D/Corps/Jambe G/Jambe D, cohérent avec
  la table de localisation des coups du livre) ; contre-proposition retenue après vérification
  du code existant : le système d'armure (pièces portées ET panneau PDF `PdfBlocArmourPoints`)
  ne distingue déjà nulle part gauche/droite, seulement 4 emplacements (`BonusTete`/`BonusBras`/
  `BonusCorps`/`BonusJambes`, `chargeconstantes.pas`) - réutilisation de ces 4 codes plutôt que
  d'en inventer 6 nouveaux, acceptée par Nono. Nouvelle couche `chargecorruptionarmuremodif.pas`
  (`StructureCorruptionArmureModif` : Livre, CodeCorruption, CodeLocalisation, Valeur ; nouveau
  fichier, même forme que les autres). Nouvelle constante `ConstXmlModifieArmure = 'ModifArmour'`
  (tag dédié, pas de réutilisation). `xmlexportimport.pas` : nouvelle branche de cas dans les
  deux boucles de parsing `<Corruption>` (Physical et Mental, identiques). Nouvelle fonction
  `PersonnageMutationArmureModif(Personnage, CodeLocalisation)` (`chargepersonnage.pas`, même
  forme que `PersonnageMutationAttributModif`). Appliquée dans `pdfpersonnage.pas` aux deux
  sites de calcul d'armure (legacy page 1 et `PdfBlocArmuresDonnees`/Feldo2P), juste après la
  boucle de sommation de l'équipement porté, sur `ArmureTete`/`ArmureBras`/`ArmureCorps`/
  `ArmureJambe`. Confirmé par Nono par test PDF réel (version +2 partout et version +1 Tête).
  Astérisque PAS encore ajoutée pour ce cas (Nono la veut, mais `PdfBlocArmourPoints` n'a
  aujourd'hui aucune capacité de dessiner une annotation - contrairement aux tableaux
  Caractéristiques/Compétences - donc nécessite d'abord une conception de l'affichage avant
  d'implémenter, remis à une prochaine session).

**Reste à faire** : le mécanisme de perte de mutation lui-même (rare, confirmé possible par le
livre) n'est ni conçu ni implémenté - c'est justement ce qui a motivé `Personnage.Mutations`
comme liste dédiée plutôt qu'un ledger texte, mais aucune UI/logique de retrait n'existe
encore. Astérisque numérotée pour les effets Armour Points (§ étape 9 ci-dessus) : conception de
l'affichage sur `PdfBlocArmourPoints` à faire avec Nono avant de coder.

---

### 2.8 Changement de langue en direct — terminé (17/08/2026)

Jusqu'ici, changer de langue (`ComboBoxLangue`, menu principal) se contentait d'appeler
`SauveIni()` puis `Application.Terminate` - il fallait relancer le programme pour voir l'effet.
Nono a demandé si on pouvait éviter la fermeture. Conception validée après avoir vérifié le code
existant :

- **Précédent trouvé** : changer de livre actif (`TabLivreDblClick`) fait déjà un rechargement en
  direct sans fermer le programme, via `ChargerLivre(true, '')` (vide ~30 listes globales,
  réimporte les XML des livres sélectionnés, puis `Traduit(ValLangue, '')` réapplique les
  traductions) - architecturalement, c'est exactement ce qu'il fallait pour la langue aussi.
- **Fiches personnage (`TWinPersonnages`) et assistant de création (`TWinCreations`) bloquent
  le changement de langue** s'ils sont ouverts (choix de Nono, `MESS_055`) plutôt que d'être
  fermés/rouverts automatiquement : `Personnage` et tous les records associés
  (`PersonnageMetier`, `PersonnageAttribut`, etc., `winpersonnage.pas`) sont des **variables
  globales partagées par toutes les fenêtres `TWinPersonnages`**, pas des champs propres à
  chaque fenêtre (repéré en creusant le code, voir §4) - les fermer sans sauvegarde risquerait de
  perdre une saisie non enregistrée. Détection par balayage de `Screen.Forms` (pas des variables
  globales `FenXxx`, qui ne reflètent que la DERNIÈRE fenêtre créée de chaque type et ne
  permettent pas de savoir si une fenêtre plus ancienne est encore ouverte).
- **Les autres fenêtres secondaires** (Livre/Compétence/Talent/Race/Sorts/Arme/Armure/Métier :
  catalogues sans saisie à perdre) sont repérées via `Screen.Forms`, fermées, puis rouvertes à
  l'identique après le rechargement - état minimal retenu ("était ouverte"), pas de position/
  onglet/ligne sélectionnée mémorisé (choix volontairement simple).
- **`RafraichirLibellesMenu`** (nouvelle procédure, `warhammersource.pas`) : les libellés déjà
  posés sur le menu principal lui-même (boutons, en-têtes de colonnes des tableaux Livres/
  Personnages, libellé de chaque livre dans `TabLivre`) ne se refont pas tout seuls - ils sont
  fixés une seule fois dans `FormCreate`. Impossible de rappeler `FormCreate` tel quel pour les
  rafraîchir : il fait aussi de la construction à usage unique (`GridAjouteColonne` AJOUTE une
  colonne à chaque appel, sans vérifier si elle existe déjà - un second appel aurait dupliqué les
  colonnes des tableaux Livres/Personnages ; une trentaine de `ListXxx.Create` auraient fui
  l'instance précédente ; plusieurs listes/tableaux sont remplis par `+=`, donc auraient dupliqué
  leur contenu). `RafraichirLibellesMenu` duplique DÉLIBÉRÉMENT le sous-ensemble sûr (libellés
  simples, en-têtes de colonnes déjà créées réécrites via `.Columns[i].Title.Caption`, pas
  `GridAjouteColonne`) plutôt que de refactoriser `FormCreate` - si un nouveau libellé
  dépendant de la langue est ajouté à `FormCreate` plus tard, il faudra penser à l'ajouter aussi
  ici.
- `MESS_041` (confirmation du changement de langue) mis à jour : ne mentionne plus "prendra
  effet au prochain lancement", devenu faux.
- Nouveau message `MESS_055` (les deux livres) : averti l'utilisateur qu'une fiche personnage ou
  un assistant de création doit être fermé avant de changer de langue.
- **Bug #1 découvert au test (18/08/2026) : l'interface (boutons du menu) restait en français
  après un changement de langue, alors que les données du jeu se rechargeaient bien.** Cause :
  `Traduit(Langue, Livre)` (`chargetraduction.pas`) avait une garde
  `if (Langue <> ConstAnglais) or (Livre <> '') then` qui sautait tout le corps de la fonction
  quand on rebasculait vers l'anglais en mode "tous les livres" (`Livre=''`). Or `ListTexte` (et
  aussi `ListeAttribut`/`ListeAttributAugmentation`/`ListeCompetenceAugmentation`, même souci
  latent, pas encore rencontré) ne peuvent être remises à jour QUE par `Traduit` : ces listes sont
  remplies par `XmlImport` uniquement quand `OnlyPrimary=true`, ce qui n'arrive qu'UNE fois, au
  tout premier chargement dans `FormCreate` - `ChargerLivre` (utilisée pour le changement de livre
  ET de langue en direct) appelle toujours `XmlImport(..., false, false)`, donc ne les retouche
  jamais elle-même. Une première tentative de correctif (vider `ListTexte` dans `ChargerLivre`,
  par analogie avec les ~30 autres listes qui elles SONT rechargées à chaque fois) s'est révélée
  contre-productive : elle vidait la liste sans que rien ne puisse jamais la reremplir depuis
  `ChargerLivre`, provoquant un bug pire (codes bruts `LAB_082` etc. affichés au lieu du texte,
  `GetTexteLibelle` retombant sur son fallback faute de trouver quoi que ce soit) - annulée.
  Correctif final : suppression de la garde inutile dans `Traduit` (la boucle interne filtre déjà
  par langue/livre, elle n'avait pas besoin d'un garde-fou en plus par-dessus).
- **Bug #2 découvert au test (18/08/2026) : la fenêtre principale (et ses tableaux Livres/
  Personnages) grossissait un peu plus à chaque changement de langue.** Trois passes
  successives avant résolution complète :
  1. Cause partielle identifiée : `Grid.AutoSizeColumn` (appelée en interne par
     `AdjustGridColumnsWidth`, `chargeconstantes.pas`) agrandit une colonne pour tenir son
     contenu mais ne la rétrécit jamais (comportement connu de la LCL) - inoffensif tant que
     `AdjustGridColumnsWidth` n'était appelée qu'une fois au démarrage, mais
     `RafraichirLibellesMenu` la rappelle à chaque changement de langue. Correctif : remise des
     colonnes auto-dimensionnées de `TabLivre`/`TabPersonnage` à leur largeur de départ (celle
     donnée dans `FormCreate` via `GridAjouteColonne`) juste avant chaque appel à
     `AdjustGridColumnsWidth`. Insuffisant seul - le grossissement continuait (proportionnel à
     toute la fenêtre, pas juste aux colonnes ; les fenêtres secondaires fermées/rouvertes, elles,
     ne grossissaient pas - indice que la fenêtre PRINCIPALE, jamais recréée, était seule en
     cause).
  2. Cause principale trouvée : `AdjustGridColumnsWidth` appelle aussi
     `Grid.ScaleFormToDesign(96)`, qui remet à l'échelle DPI la fenêtre PROPRIÉTAIRE entière à
     partir de sa taille actuelle - correct au tout premier appel (`FormCreate`), mais cumulatif
     si rappelé sans que la fenêtre reparte d'un état neuf (exactement le cas de
     `RafraichirLibellesMenu`, jamais recréée contrairement aux fenêtres secondaires). Un ancien
     TODO dans `A FAIRE.txt` pointait déjà ce `ScaleFormToDesign(96)` comme suspect (écart avec le
     `DesignTimePPI = 120` des `.lfm`). Correctif : nouveau paramètre optionnel
     `ScaleDpi: Boolean = true` sur `AdjustGridColumnsWidth` (défaut inchangé partout ailleurs),
     appelé avec `ScaleDpi=false` depuis `RafraichirLibellesMenu`.
  3. Un résidu de dérive subsistait malgré les deux correctifs ci-dessus (cause exacte non
     identifiée avec certitude). Filet de sécurité proposé par Nono, appliqué dans
     `RafraichirLibellesMenu` : mémoriser `Self.Width`/`Height` et la taille de `TabLivre`/
     `TabPersonnage` tout au début de la procédure, et les réimposer de force juste après les
     deux appels à `AdjustGridColumnsWidth`, quoi qu'il se soit passé entre-temps.
- Confirmé fonctionnel par Nono le 18/08/2026 (données, libellés d'interface, et taille de la
  fenêtre/des tableaux stable dans la durée, testé dans les deux sens EN/FR).

---

### 2.9 Import Lustria (PDF → XML) & robustesse du chargement des livres — terminé (démarré le 18/08/2026, clos le 20/08/2026)

<!-- Suite directe : §2.10 (races et ethnies), lancée par Nono à partir de ce que cet import a révélé. -->

**Import des carrières (`DATABASE\BOOK LUSTRIA.xml`, code livre `LUSTR`, livre officiel) :**
- ✅ Interprète (`LUSTR-WORK123`) et Oracle (`LUSTR-WORK124`) : données complètes (4 paliers,
  compétences/talents/équipement, portrait transparent composité correctement à partir du
  soft-mask embarqué dans le PDF), éligibilité raciale sur les deux mécanismes existants
  (`DATA_SPECIE_CAREER_CHOICE` pour le tirage aléatoire + entrées directes
  `SUBCHAPTER_CAREER Chance="X"` pour le choix libre), confirmés par Nono.
- ⬜ Survivalist (page 198) et Trailblazer (page 200) : pas encore commencés. Même pipeline
  complet à reprendre (image Advance Scheme, texte via `pdftotext` sans `-layout`, codes
  compétences/talents, portrait composité, éligibilité raciale sur les deux mécanismes, note
  "GENERATING A ...").

**Découverte en cours de route — deux mécanismes d'éligibilité race/carrière, tous les deux
nécessaires** (voir aussi §4 pour le détail) : `DATA_SPECIE_CAREER_CHOICE`
(`ChargeMetierRaceChoixMetier.pas`, tirage d100 avec substitution) et entrée directe
`SUBCHAPTER_CAREER Chance="X"` dans `<Specie>` (choix libre en création de personnage,
`winmetier.pas`). Une carrière ajoutée sans les deux n'est pas sélectionnable dans tous les
modes de création.

**Bug découvert au test (19/08/2026) : lignes de race fantômes.** Ajouter un `<Specie>` "stub"
dans `BOOK LUSTRIA.xml` (juste pour y accrocher un `SUBCHAPTER_CAREER Chance="X"` sur une race
déjà définie ailleurs, ex. `RULES-RACE_HELF`) faisait créer une DEUXIÈME ligne dans `ListRace`
pour le même `CodeRace` (visible dans WinLivre : colonne "R" de Lustria à 9 au lieu de 0).
Cause : dans `xmlexportimport.pas`, le bloc de lecture des noeuds `<Specie>` faisait
`ListRace.add(PRace)` sans jamais vérifier si ce `CodeRace` existait déjà.
**Correctif (proposé par Nono) :** ajout d'une garde `if ChercheRace(PRace.CodeRace).CodeRace = '' then`
avant le `ListRace.add` — n'ajoute une ligne que si la race n'existe pas encore.

**Ce correctif a révélé un vrai problème d'ordre de chargement**, signalé par Nono
("ma seule peur : dans quel ordre je lis les livres ?") : `FindFirst`/`FindNext` sur
`DATABASE\*.xml` (dans `TMenu.FormCreate` ET `TMenu.ChargerLivre`, `warhammersource.pas`) ne
trient jamais les fichiers — ordre brut du système de fichiers, non garanti. Si le stub d'un
supplément est traité AVANT le livre qui définit vraiment la race, la garde ci-dessus fait
l'inverse de ce qu'elle devrait : elle bloque l'ajout des VRAIES données quand elles arrivent
ensuite, parce que le stub incomplet est déjà là. Pire que le bug d'origine (perte silencieuse
de la race pour toute la session, pas juste une ligne fantôme en trop).

- **Premier correctif appliqué (19/08/2026, `warhammersource.pas`, `TMenu.FormCreate` et
  `TMenu.ChargerLivre`)** : les fichiers `.xml` trouvés sont d'abord collectés dans une
  `TStringList`, puis celui dont le `BOOK` déclaré vaut `ConstRulesBook` ('BOOK RULESBOOK') est
  importé en premier (via `XmlLivre` pour l'identifier), avant tous les autres. Compile, et
  corrige bien le cas Rulebook-vs-supplément.
- **⚠️ Insuffisant : régression trouvée au test par Nono.** Les races de Middenheim
  (`MIDDE-RACE_HMIDH/HMIDL/HNORD`) disparaissent de la fenêtre Race — remplacées par des lignes
  vides attribuées à "(F) Book Lustria". Cause probable : `BOOK LUSTRIA.xml` contient AUSSI des
  `<Specie>` stubs pour ces races (pour leur accrocher l'éligibilité Interprète), et si
  `BOOK LUSTRIA.xml` est énuméré avant le livre Middenheim, le même mécanisme de shadowing se
  reproduit — mais cette fois entre deux suppléments, pas seulement Rulebook-vs-supplément
  (mon correctif ne traite que le cas spécial du Rulebook).
- **✅ Solution finale retenue (20/08/2026) — supprimer le besoin de stub plutôt que d'ordonner
  le chargement.** Nono a eu une meilleure idée que le tri par dépendances façon compilateur :
  sortir complètement la déclaration d'éligibilité de `<Specie>`/`<Career>`, pour qu'elle ne
  dépende plus jamais de qui définit quoi ni de l'ordre de chargement.
  - Nouveau bloc XML **`DATA_SPECIE_CAREER_DIRECT`** (constantes `ConstXmlDataSpecieCareerDirect`
    et `ConstXmlEntry`, `chargeconstantes.pas`), une liste à plat d'`<Entry><Specie>"CODE"</Specie>
    <Career name="CODE">"Chance"</Career></Entry>`, sur le modèle de `DATA_SPECIE_CAREER_CHOICE`
    (déjà order-safe puisqu'il ne stocke que des codes texte, résolus à l'usage via
    `ChercheRace`/`ChercheMetier`, sans jamais créer de noeud `<Specie>` ni `<Career>`).
  - Lecture ajoutée dans `xmlexportimport.pas` (`XmlImport`, juste après le bloc "Metier choix
    race" existant) : alimente `ListRaceMetier` directement — exactement la même liste que
    `SUBCHAPTER_CAREER` sous `<Specie>` et que lit déjà `winmetier.pas` pour le choix libre.
    Compile, confirmé par Nono.
  - **`BOOK LUSTRIA.xml`** migré : les 9 `<Specie>` stubs de `DATA_SPECIE` (12 entrées
    Chance="X" au total) remplacés par un bloc `DATA_SPECIE_CAREER_DIRECT` de 12 `<Entry>`, et
    `DATA_SPECIE` supprimé du fichier (Lustria ne définit aucune race elle-même). Testé et
    confirmé par Nono le 20/08/2026 : les races de Middenheim réapparaissent normalement,
    Interprète/Oracle restent sélectionnables en choix libre sur toutes les races concernées.
  - Existe aussi, découvert au passage mais non utilisé pour Lustria : `SUBCHAPTER_SPECIE`
    (constante `ConstXmlSousChapitreRace`, string `'SUBCHAPTER_SPECIE'`) sous `<Career>` —
    fonctionne côté lecture mais ne résout le problème que si le livre courant définit déjà
    entièrement la carrière (sinon même risque de shadowing, côté `ListMetier`/`ChercheMetier`
    cette fois — repéré par Nono avant qu'on choisisse `DATA_SPECIE_CAREER_DIRECT`).
  - **Limite connue, notée dans `A FAIRE.txt`** : pas de pendant écriture/export pour
    `DATA_SPECIE_CAREER_DIRECT` dans `XmlExportBook` — `ListRaceMetier` ne garde pas la trace du
    mécanisme XML d'origine par entrée, donc un export naïf dupliquerait celles déjà écrites via
    `SUBCHAPTER_CAREER`. Pas bloquant tant qu'on édite les livres à la main.
  - Le correctif "RULESBOOK en premier" (`FormCreate`/`ChargerLivre`, 19/08/2026) reste en place
    comme filet de sécurité, mais n'est plus nécessaire pour ce cas précis.
- **✅ Survivalist (`LUSTR-WORK125`) et Trailblazer (`LUSTR-WORK126`) ajoutés et confirmés
  (20/08/2026)**, même pipeline complet que Interprète/Oracle :
  - Survivalist remplace Road Warden (`RULES-WORK47`) ; Trailblazer remplace Coachman
    (`RULES-WORK13`). Ni l'un ni l'autre n'est disponible pour Nain/Haut Elfe/Elfe Sylvain dans
    le Rulebook (comme Lawyer pour l'Interprète) — substitution (`DATA_SPECIE_CAREER_CHOICE`)
    là où la carrière remplacée existe, choix libre (`DATA_SPECIE_CAREER_DIRECT`) pour toutes les
    races listées par le PDF.
  - Tous les codes compétence/talent trouvés dans le Rulebook, y compris des cas déjà présents
    mais non repérés au premier essai (`Secret Signs (Ranger)` = `RULES-COMPSIGNES_RANGER`,
    `Lore (Local)` = `RULES-COMPSAVOIR_LOCAL` malgré la coquille "Lore (Loca)" dans le Rulebook,
    non corrigée) — aucune nouvelle spécialisation à créer cette fois.
  - Portraits extraits et rendus transparents (même méthode masque embarqué + PIL).
  - **Bug trouvé par Nono après coup (20/08/2026) : plusieurs équipements (`SUBCHAPTER_ITEM`)
    étaient en texte libre alors que ce sont des armes du Rulebook**, à corriger avec le vrai
    code (`DATA_WEAPON`) comme le fait déjà le reste de la base (ex. `RULES-ARMO_04` pour les
    armures). Corrigé sur les 4 carrières : Oracle *Quarterstaff* → `RULES-COMB_HAST_01`,
    *Javelin* → `RULES-PROJ_LANC_05` ; Survivalist *Hand Weapon* → `RULES-COMB_BASE_*` (arme de
    base non précisée, même convention que le reste du Rulebook), *Sling with Ammunition* →
    scindé en deux lignes `RULES-PROJ_FROND_02` + `RULES-MUNI_05` (même palier) - schéma
    arme+munition déjà utilisé partout ailleurs ; Trailblazer *Machete* → `RULES-COMB_BASE_04`
    (Sword, pas d'équivalent exact, approximation validée par Nono), *Pistol with 10 Shots* →
    `RULES-PROJ_POUDRE_04` + `RULES-MUNI_06` + une ligne texte libre "10 Shots" pour garder la
    quantité (pas de champ quantité sur `<Item>`, palier = niveau d'avancement uniquement).
    **Leçon pour la suite** : toujours vérifier `DATA_WEAPON`/`DATA_ARMOR` avant de saisir un
    équipement en texte libre lors d'un futur import PDF.

**Chantier Lustria (les 4 carrières) terminé et confirmé par Nono le 20/08/2026.** Reste en
`A FAIRE.txt` (non bloquant, pas commencé) : le pendant écriture/export de
`DATA_SPECIE_CAREER_DIRECT`, l'éligibilité Ogre pour Survivalist/Trailblazer (encadré Archives of
the Empire II), et le nom de fichier image sans préfixe de livre. La notion de race générique,
elle, a été traitée dans la foulée — voir §2.10.

---

### 2.10 Races et ethnies — terminé (20/08/2026)

Chantier lancé par Nono juste après Lustria, pour régler à la racine le problème découvert
pendant l'import : un métier déclaré sur le Reiklander était inaccessible aux autres Humains.

**Vocabulaire fixé avec Nono (à respecter dans toute discussion future) :**

- **ETHNIE** = ce que le joueur choisit à la création, et ce que le code appelle
  historiquement "Race" (`StructureRace`, `chargerace.pas`, balise XML `<Specie>`,
  codes `RULES-RACE_HUM`…). Ex. "Humans (Reikland)".
- **RACE** = le regroupement au-dessus, commun à plusieurs ethnies. Ex. "Human".
  Balise XML `<Race>`, bloc `DATA_RACE`, codes `RULES-SPECIE_HUMAN`…, unité `chargeespece.pas`.
- **Les noms Pascal et XML sont croisés** (`ConstXmlRace = 'Specie'` pour l'ethnie,
  `ConstXmlEspece = 'Race'` pour la race) — c'est volontaire, pour ne pas renommer les 17
  fichiers de livres. Un commentaire le rappelle dans `chargeespece.pas` et `chargeconstantes.pas`.

**Ampleur réelle du problème, mesurée avant de concevoir** (c'est ce chiffrage qui a orienté
toute la solution) : le Reiklander avait 105 entrées `SUBCHAPTER_CAREER` (63 dans la table de
jet + 42 en `X`), le Tiléen 103 (quasi-copie), mais les trois ethnies de Middenheim n'avaient
QUE leur table de jet régionale et **zéro entrée `X`** — les 42 métiers de suppléments accumulés
sur le Reiklander leur étaient inaccessibles.

**Point de conception clé** : le champ existait déjà et était déjà rempli partout
(`StructureRace.Espece` ← balise `<Ethnic>`), mais il ne servait QUE à l'affichage
(`pdfrace.pas`, `winraces.pas`, `chargeracemetier.pas`/`MetierRaceCourt`). Il portait cependant
un regroupement *biologique* (les 3 elfes partageaient `SPECIE_ELF`) incompatible avec un
regroupement *d'éligibilité* — d'où le découpage des races ci-dessous.

**Ce qui a été fait, dans l'ordre :**

1. `chargeespece.pas` (nouvelle unité) : `StructureEspece`, `ListEspece`, `NbEspece`,
   `ChercheEspece`. Constantes `ConstXmlEspece`/`ConstXmlDataEspece`/`ConstPEspece`.
2. Plomberie de liste dans `warhammersource.pas` (Create dans `FormCreate`, Clear + RAZ dans
   `ChargerLivre`), lecture du bloc `DATA_RACE` dans `xmlexportimport.pas` (juste avant celui de
   `DATA_SPECIE`), et branchement traduction dans `chargetraduction.pas` (case `ConstPEspece:`).
3. Bloc `DATA_RACE` ajouté dans 7 livres — **chaque livre déclare désormais ses propres races**,
   au lieu du Rulebook qui déclarait `SPECIE_OGRE`/`_GNOME`/`_FAMILIAR`/… pour des races venant
   de suppléments (et `SPECIE_VAMPIRE`, qui ne servait à rien).
4. Bascule : les 6 appels `GetTexteLibelle(PRace.Espece)` remplacés par
   `ChercheEspece(PRace.Espece).Libelle`, les 20 balises `<Ethnic>` réorientées vers les nouveaux
   codes préfixés par livre.
5. Nettoyage : suppression des 10 `<Text name="RULES-SPECIE_*">` (EN + FR) et des 10 constantes
   `RaceHumain`/`RaceElf`/… de `chargeconstantes.pas` — **découvertes inutilisées nulle part**.
6. `CompleteRaceMetierParEspece` (`chargeracemetier.pas`), appelée en fin de `ChargerLivre` :
   pour chaque entrée de `ListRaceMetier`, ajoute le même métier aux autres ethnies de la même
   race, **toujours en `'X'`**. Donc l'accessibilité se propage, jamais les fourchettes de dés :
   les tables de jet régionales restent intactes (`ChargeTabMetier` exclut déjà les `'X'`).
   Garde-fou anti-doublon obligatoire (`TStringList` triée + `IndexOf`), car `ChargerLivre` est
   rappelée à chaque changement de livre actif ou de langue.

**Découpage des races — seul l'Humain regroupe plusieurs ethnies.** Repéré en simulant le
résultat AVANT de faire tester Nono : la propagation cassait les Familiers (chacun a un unique
métier qui est lui-même — un Familier de Combat serait devenu Familier de Sort) et élargissait
indûment les Orques Noirs (4 métiers volontairement restreints contre 30 aux Orques Communs).
Donc `SPECIE_ELF` → `_HELF`/`_WELF`/`_DELF`, `SPECIE_FAMILIAR` → `_FAMIC`/`_FAMIS`/`_FAMIP`,
`SPECIE_ORC` → `_CORC`/`_BORC`, `SPECIE_GOBLIN` → `_CGOB`/`_NGOB`/`_HGOB`. Résultat final :
`RULES-SPECIE_HUMAN` est la seule race regroupante (5 ethnies), les 15 autres ont une ethnie
unique.

**Résultat confirmé par Nono le 20/08/2026** : Middenheimer 60 → 110 métiers accessibles
(+50), Middenlander et Nordlander 66 → 110 (+44), Reiklander 109 → 110, Tiléen 106 → 110 ;
tirages d100 inchangés, Familiers et Peaux-Vertes inchangés. Toute nouvelle ethnie Humaine
ajoutée dans un futur livre héritera automatiquement de tous les métiers en choix libre, sans
retoucher quoi que ce soit.

---

### 2.11 Règles de jeu optionnelles & table de tirage lustrienne — terminé (20/08/2026)

Suite directe de §2.10, lancée par Nono en découvrant la "Lustrian Class and Career Table"
(Lustria p.192-193) : une table de tirage des métiers **complète et alternative**, qui remplace
celle des pages 30-31 du livre de règles pour une campagne située en Lustria.

**Ce que le modèle n'avait pas** : `Chance` était une propriété du couple (ethnie, métier),
stockée dans `SUBCHAPTER_CAREER` - il n'existait qu'UNE table implicite, et rien ne permettait de
dire "je tire sur telle table". Or le texte précise que le MJ peut garder la table normale.

**Décisions prises avec Nono (elles conditionnent tout le reste) :**

1. **Portée** : la règle change le tirage, et ses métiers s'AJOUTENT au choix libre - elle ne
   retire jamais rien. Raison : la table lustrienne ne liste que les 64 métiers de base, donc
   une règle qui *remplacerait* l'accessibilité ferait perdre au Reiklander les 42 métiers de
   suppléments accumulés en `X` (dont ceux de Lustria elle-même).
2. **Ethnie non couverte** (pas de colonne Gnome, Ogre, Elfe Noir, Peau-Verte) : repli sur la
   table par défaut, jamais de blocage.
3. **Pas de mémorisation dans le personnage** - justification de Nono : *"la règle ne sert que
   lors de la création ; une fois son personnage créé, la personne peut voyager et apprendre une
   carrière non liée à sa règle de création"*. C'est ce qui a évité de toucher `chargepersonnage.pas`.

**Forme retenue** : mêmes principes que §2.9/§2.10 - blocs à plat portés par le livre qui apporte
la règle, jamais d'écriture dans les `<Specie>` des autres livres, et résolution à l'usage (pas au
chargement) donc insensible à l'ordre de lecture des fichiers.

- `DATA_RULE` / `<Rule id="...">` : déclaration des règles (`chargeregle.pas`, `ListRegle`).
- `DATA_CAREER_ROLL` / `<Entry><Rule><Specie><Career name=...>` : les entrées de tirage
  (`ListRegleMetier`). **`<Specie>` accepte indifféremment une ETHNIE ou une RACE** - c'est ce
  qui permet d'écrire la colonne "Old World Human" une seule fois pour les 5 ethnies Humaines.

**Réalisé, dans l'ordre :**

1. `chargeregle.pas` (nouvelle unité) + constantes. **Piège rencontré** : `ConstXmlRegle` existait
   déjà avec la valeur `'RULES'` (la liste des livres acceptés d'un personnage, `chargepersonnage.pas`)
   - repéré par Nono à la compilation. La nouvelle s'appelle `ConstXmlRegleJeu` (valeur `'Rule'`),
   avec un commentaire croisé entre les deux pour éviter la confusion.
2. Plomberie de liste (`warhammersource.pas`), lecture des deux blocs (`xmlexportimport.pas`),
   branchement traduction (`chargetraduction.pas`, case `ConstPRegle`).
3. `RegleMetierApplicable` / `RegleCouvreRace` (`chargeregle.pas`) : la résolution règle →
   ethnie-ou-race, et le test de repli.
4. UI : `GroupBoxRegle` + `ComboBoxRegle` sur la page Métier de l'assistant (`wincreation.lfm`),
   `ChargeComboRegle` / `RegleEnCours` / `ComboBoxRegleSelect`, et `ChargeTabMetier` réécrite avec
   les deux branches. Le cadre est **masqué tant qu'aucun livre n'apporte de règle**, donc écran
   inchangé pour qui n'en a pas. L'index du combo suit `ListRegle`, aucune liste parallèle.
5. Données : les 223 entrées de la table (5 colonnes ; le Norse est laissé de côté, cf. plus bas).

**Bug trouvé au test, instructif** : un commentaire XML placé ENTRE deux `<Entry>` créait une
entrée fantôme dupliquant la précédente (symptôme : "Sorcier 14" affiché deux fois). La boucle de
lecture parcourt tous les nœuds enfants, commentaires compris ; pour un commentaire `FirstChild`
est nil, donc l'enregistrement était ajouté avec les valeurs encore en mémoire. Corrigé sur les
4 blocs récents (`DATA_RACE`, `DATA_RULE`, `DATA_CAREER_ROLL`, `DATA_SPECIE_CAREER_DIRECT`) par
une garde `if NodeNv2.NodeName = <balise attendue>` + remise à zéro de l'enregistrement.
**⚠️ Le même piège reste dans les blocs plus anciens** (`DATA_SPECIE_CAREER_CHOICE`,
`DATA_SKILL_SPECIALIZATION`, `DATA_CAREER_SUBCHOICE`...) : non corrigés, non déclenchés
aujourd'hui faute de commentaires à ces endroits. Pire sur les blocs à `id` : `Attributes` est nil
sur un commentaire, donc plantage et pas seulement doublon.

**Trois coquilles du livre corrigées à la saisie** (choix de Nono : *"fais en sorte qu'il y ait un
résultat et un seul"*), détail et justification dans `A FAIRE.txt`. Chaque colonne couvre
désormais 01-100 exactement une fois, vérifié depuis le XML écrit. Aucun errata officiel Cubicle 7
n'existe pour Lustria à ce jour.

**Le cas "3f" (union côté choix libre) réglé par les données, pas par le code.** Mesuré après
coup, l'écart entre la table lustrienne et ce qui est déjà accessible se réduisait à **un seul
métier** : le Stevedore pour le Haut Elfe (tirable sur 80 sous la règle, mais pas choisissable).
Le chantier §2.10 avait déjà rendu accessible tout le reste. Réglé par une entrée
`DATA_SPECIE_CAREER_DIRECT` plutôt qu'en faisant remonter la règle jusqu'à `winmetier.pas` -
Nono : *"je suis aussi pour l'ajouter dans les races ayant accès. On voit que les livres ont des
ratés"*. Contrepartie assumée : l'accès est inconditionnel, pas réservé à la règle Lustria.

**Piège découvert en écrivant cette entrée, puis refermé.** `DATA_SPECIE_CAREER_DIRECT`
n'acceptait QUE des codes d'ethnie : ses entrées vont dans `ListRaceMetier`, dont tous les
consommateurs comparent à l'ethnie du personnage. Un code de RACE y était donc chargé sans
erreur mais ne matchait jamais - inerte et silencieux. La résolution race-ou-ethnie n'existait
que dans `RegleMetierApplicable`, donc pour `DATA_CAREER_ROLL` uniquement.
Corrigé en ajoutant une **phase 1** à `CompleteRaceMetierParEspece` : toute entrée ciblant une
race est développée en une entrée par ethnie, puis l'originale supprimée. Trois précautions :
le développement a lieu APRÈS le chargement de tous les livres (sinon les ethnies des autres
livres manquent - le piège de §2.9), la boucle descend car elle supprime pendant le parcours,
et les deux phases partagent le même index anti-doublon.
Validé sur données réelles : le bloc de Lustria a été réécrit intégralement en codes de race,
**19 entrées au lieu de 31**, qui se développent en 35 au chargement - accès identique à avant,
confirmé par Nono.

**🔧 Reste à faire (un seul point, non bloquant) :**

- **Colonne Norse non saisie** : la race Norse existe dans le livre Sea of Claws mais **pas dans la
  base** - `BOOK_SEA_OF_CLAWS.Xml` ne contient que `DATA_CAREER`/`DATA_TALENT`/`DATA_SPELL`, aucun
  `DATA_SPECIE`. C'est aussi ce qui explique que ses 9 métiers soient raccrochés en `X` aux races
  existantes. La saisir est un chantier à part (race complète + classe Seafarer absente,
  `CLASS_SEAF` n'existe pas) ; le format à plat fait que la colonne s'ajoutera ensuite sans rien
  retoucher.

---

### 2.12 Norse & classe Seafarer (Sea of Claws) — terminé (21/08/2026)

Suite de §2.11 : la colonne « Norse » de la table lustrienne ne pouvait pas être saisie faute de
race Norse en base. En ouvrant Sea of Claws (`Sea of Claws.pdf`, à la racine du projet), le
chantier s'est révélé plus large que prévu.

**Découverte 1 — il n'y a pas une race Norse, mais TROIS ethnies** (p.56) : Bjornling, Sarl,
Skaeling, chacune avec ses propres compétences et talents de départ. Elles se rattachent toutes
à la race `RULES-SPECIE_HUMAN`, exactement comme Reikland/Tilée/Middenheim.

**Découverte 2 — le livre valide le modèle de §2.10 mot pour mot** (p.57) : *« Whilst Norse
careers are limited in scope, they count as Humans for the purpose of taking on new careers, so
whilst a Norse Character may not start their career as a wizard, they do have the potential to
become a Wizard »*. C'est littéralement table de tirage restreinte + accessibilité de la race
entière. La propagation (phase 2) fait donc la bonne chose sans rien ajouter.

**Découverte 3 — la table Norse n'est PAS une règle optionnelle.** Première lecture erronée de
ma part, corrigée : *« Norse Characters may generate starting careers using the table below »* -
c'est LEUR table, au même titre que celle du Reiklander. Elle va donc dans leur
`SUBCHAPTER_CAREER` par le mécanisme historique, pas dans un `DATA_RULE`.

**Fait et confirmé par Nono :**

- **Classe `CLASS_SEAF`** (Seafarers). Constat rassurant : rien n'était « oublié » - les 9 métiers
  de Sea of Claws étaient bien saisis et correctement répartis par race, mais tous en `Chance="X"`,
  faute de pouvoir exprimer une table de substitution partielle à l'époque. Ajouter une classe ne
  demande **aucun code** : `StructureMetier.LibelleGroupe` est une simple chaîne, sans table ni
  validation. Il a fallu (1) un bloc `DATA_LABEL` dans Sea of Claws - **premier supplément à en
  porter un** - avec « Seafarers » / « Marins », (2) l'icône `PICTURES\NIV\CLASS_SEAF.png`
  extraite du PDF p.66 et détourée (51x61 RGBA, comme les 8 autres ; c'est le même crâne, teinté
  par classe), (3) les 9 `<Class>` passés de `CLASS_RIVE` à `CLASS_SEAF`.
  **`<Class>` reste sans préfixe de livre** alors que le libellé est `SEAOF-CLASS_SEAF` :
  `pdfmetier.pas` construit le chemin de l'icône avec `LibelleGroupe + '.png'`, un préfixe
  chercherait un fichier inexistant. Les 8 classes existantes suivent la même règle.
- **Les 3 ethnies Norse** (`SEAOF-RACE_HBJOR/HSARL/HSKAE`) : caractéristiques de l'Humain (le
  livre ne remplace que compétences et talents de la p.36 du Rulebook), 12 compétences chacune,
  talents à choix via la syntaxe `A/B` (vérifié : 18 des 24 références à choix déjà présentes en
  base n'ont aucune entrée combinée déclarée, donc le `/` est bien interprété à l'exécution), et
  la table de tirage Norse complète (31 métiers). Trois spécialisations créées au passage :
  `RULES-COMPSAVOIR_NORSCA`, `RULES-COMPSAVOIR_KHORNE`, `RULES-COMPLANG_GOSPO` (préfixe `RULES-`
  conservé comme pour `RULES-COMPSIGNES_LIZARD`, ce sont des spécialisations de compétences du
  Rulebook).
- **Quatrième coquille de livre corrigée** : table Norse, Agitator 05-06 puis Artisan **08-10**,
  le 07 n'était attribué à personne. Vérifié à l'image. Saisi en 07-10, la table couvre désormais
  01-100 exactement une fois.

**Tests et corrections du 21/08/2026 (tout confirmé par Nono) :**

- ✅ **Les 3 ethnies fonctionnent** : création possible, table norse correcte (31 métiers,
  Beachcomber 65-66, Artisan 07-10 donc la coquille corrigée, aucun Sorcier), et en choix libre
  l'accès à TOUT ce qui est humain - exactement ce que décrit le livre, obtenu sans une ligne de
  code spécifique aux Norses.
- ✅ **Colonne Norse de la table lustrienne saisie** : 102 entrées (34 métiers x 3 ethnies).
  La table lustrienne est donc complète : **325 entrées, 8 cibles**, chacune couvrant 01-100
  exactement une fois. Cette colonne n'a aucune coquille, mais elle était incomplète à
  l'extraction : les lignes Boatman/Huffer/Seaman portent un appel de note en exposant qui
  collait au chiffre - d'où les "52-64 manquants" signalés à tort la veille.
- 🐛 **Bug de précédence trouvé au test** : un Norse recevait la FUSION des colonnes "Old World
  Human" (qui vise la RACE) et "Norse" (qui vise l'ETHNIE), les deux matchant simultanément.
  Corrigé par une règle explicite : **l'ethnie prime sur la race**. Nouvelle fonction
  `RegleCibleEthnie` (`chargeregle.pas`) + paramètre `EthnieSeule` sur `RegleMetierApplicable`,
  calculé une seule fois avant la boucle dans `ChargeTabMetier`. Ce cas ne pouvait pas se
  produire avant : il fallait qu'une même règle porte les deux granularités.
- ✅ **Substitutions Norses** (notes 4-5-6 p.193 de Lustria) : Boatman → Beachcomber, Huffer →
  son équivalent Seafarer, Seaman → Sailor. 9 entrées `DATA_SPECIE_CAREER_CHOICE` déclarées
  **dans Sea of Claws**, donc actives seulement si ce livre est chargé - ce qui est exactement la
  condition posée par les notes ("in Sea of Claws"). Nuance assumée : les notes disent "always
  substituted" alors que le mécanisme propose un CHOIX entre les deux, conformément à la
  préférence exprimée par Nono pour Lustria.

**🐛 Découverte majeure : deux mécanismes désactivés depuis toujours.**
`chargeconstantes.pas` déclarait deux drapeaux globaux, testés mais **jamais affectés nulle
part** dans le projet :

- `AvecRaceChoixMetier` → gardait `DATA_SPECIE_CAREER_CHOICE`. **La substitution raciale n'avait
  donc jamais fonctionné**, y compris pour les 16 entrées de Lustria saisies l'avant-veille - on
  ne l'avait pas vu faute d'avoir testé ce chemin précis. Passé à `true` le 21/08/2026.
- `AvecSousMetier` → gardait `DATA_CAREER_SUBCHOICE` (second jet de dé : Engineer puis, sur
  76-100, Artillerist). Les 22 entrées de Up in Arms et 8 de Winds of Magic n'avaient donc jamais
  rien produit non plus. **Activé le 21/08/2026**, après vérification des données ; confirmé
  fonctionnel par Nono sur Cavalryman → Light Cavalryman. Le bouton « Valider » de cette branche
  bénéficie du même `BringToFront` ajouté pour la substitution raciale, donc il s'est affiché du
  premier coup.
  **Septième coquille de livre, trouvée en vérifiant AVANT d'activer** : la table de sous-métiers
  du Soldat (Up in Arms p.9) donne Halberdier 51-75 puis Handgunner **71**-85, soit 71-75
  attribués deux fois. Vérifié à l'image : la saisie de Nono était exacte, c'est bien le livre.
  Particularité de ce cas : **l'arithmétique ne tranchait pas** - corriger l'une ou l'autre borne
  rendait la table complète. Retenu Handgunner **76**-85, sur deux indices convergents : dans les
  tableaux voisins de la même page, un "01-75" enchaîne toujours sur "76-00" (Pedlar,
  Cavalryman) ; et l'exemple travaillé de la page suppose Halberdier à partir de 51.
  À noter, cet exemple est lui-même fautif ("second roll is 57, so Gerd is an Archer", alors
  qu'Archer est 41-50) - possible trace d'un remaniement de la table en cours de rédaction, mais
  reconstituer la version d'origine aurait été de la spéculation : seul le chevauchement, défaut
  certain, a été corrigé.

**🐛 Piège d'affichage LCL, à connaître pour toute future modification de l'assistant.**
Le bouton de substitution restait invisible bien que `Visible := true` soit exécuté. Cause :
`MiseAJourUnContenaire` (`globalfonts.pas`) crée **à l'exécution** un `TShape` en `alClient` sur
chaque onglet (le fond noir). Créé après les contrôles du concepteur, il se retrouve en fin de
liste d'enfants, donc dessiné par-dessus. Les `TMemo` y échappent (contrôles fenêtrés), pas les
`TBCButton`. C'est la raison d'être des nombreux `BringToFront` dans `UpdateSheetMetier` - mais
celle-ci s'exécute APRES `TabMetierResultat` et ne connaissait pas les deux boutons de
sous-métier/substitution. Correctif : leur `BringToFront` ajouté en fin d'`UpdateSheetMetier`,
conditionné à `Visible`. **Ne pas supprimer ces lignes en les croyant redondantes.**
Fausse piste à ne pas refaire : la superposition avec le mémo n'était PAS en cause - le bouton
est déclaré après lui dans le `.lfm`, donc il lui passe de toute façon devant.

**🔧 Reste à faire :**

- ~~Images des 3 ethnies~~ **fait (21/08/2026)**. Le livre n'a aucun portrait d'ethnie : le
  chapitre Norse ne contient que trois illustrations exploitables, le reste étant des fonds de
  parchemin. Attribuées ainsi, sur critère thématique validé par Nono :
  `RACE_HBJOR1.png` = jarl à la hache runique (p.47, le plus « noble »),
  `RACE_HSARL1.png` = guerrier masqué (p.55),
  `RACE_HSKAE1.png` = guerrière rousse au crâne (p.57) - la seule EN COULEUR, et la plus
  marquée par le Chaos, ce qui colle au culte de Khorne des Skaeling.
  Position de Nono, à garder en tête pour les prochains imports : *« j'aime avoir un visuel, tant
  pis s'il n'est pas 100% fidèle »* - donc une illustration approchante vaut mieux qu'une case
  vide, tant que le choix est documenté.
  Traitement appliqué : détourage du fond blanc par propagation depuis les bords (celle de la
  p.55 avait déjà son masque), recadrage sur le contenu, hauteur ramenée à **530 px** - celle des
  `RACE_*.png` existants, relevée sur `RACE_DELF1.png` (365x530, RGBA, fond transparent). Les
  livrer déjà transparentes évite au programme de refaire le calcul via
  `RemplacerPixelParTransparent`, à l'origine du « ça boucle » sur l'Interprète de Lustria.
  Deux écarts assumés : `RACE_HSKAE1` est en couleur quand les deux autres sont en niveaux de
  gris, et elle conserve son décor peint au lieu d'être détourée comme les autres portraits.
  Nommage sans préfixe de livre (`RACE_HBJOR1.png`), conforme à la convention - donc exposé au
  risque de collision entre livres déjà noté dans `A FAIRE.txt`.
  **Piège d'extraction à retenir** : la meilleure des trois n'a **pas** de soft-mask associé,
  contrairement aux figures détourées. Un filtre « image RGB + smask » la ratait complètement -
  c'est Nono qui l'a repérée en feuilletant le PDF.
- Le PDF `Sea of Claws.pdf` est à la racine du projet, comme `Lustria.pdf`.

**✅ Règles PARTIELLES & table Seafarer — fait et confirmé (21/08/2026).**

Le problème : `DATA_CAREER_ROLL` ne savait faire qu'un remplacement TOTAL, alors que la table
Seafarer (p.63) ne remplace que la **section Riverfolk** de la table de base, le joueur choisissant
avant de lancer. Constat qui a débloqué la conception : les fourchettes Seafarer coïncident
**exactement** avec la section Riverfolk de chaque race (Humain 61-74, Nain 68-78, Halfling 69-82,
Haut Elfe 64-80, Elfe Sylvain 79). C'est donc un remplacement de section au dé près.

**Solution : le caractère partiel n'est jamais déclaré, il se DÉDUIT de la couverture.**
`ChargeTabMetier` a été réécrite et ses deux branches ont fusionné en un seul enchaînement :
(1) ajouter les entrées de la règle en marquant les valeurs de dé qu'elles occupent ;
(2) compléter avec la table de base, en écartant toute entrée qui empiète sur ces valeurs.
Lustria couvre 01-100 → rien ne s'ajoute (comportement inchangé) ; Seafarer ne couvre que la
section Riverfolk → le reste subsiste ; sans règle, rien n'est marqué → tout est repris. **Le
comportement d'origine est devenu un cas particulier du nouveau, sans syntaxe supplémentaire.**
Ajout d'une colonne masquée n°5 dans `TabMetier` (début zéro-comblé sur 3 chiffres) pour retrier
après fusion - sinon les entrées arrivent entrelacées, et un tri texte classerait « 100 » avant
« 96 ».

**Ciblage : par ETHNIE pour la colonne Human.** La section Riverfolk n'est pas au même endroit
selon l'ethnie humaine (Reikland et Tilée 61-74, Middenheimer 66-68, Middenlander 59-72,
Nordlander 57-73, Norses aucune). La colonne « Human » vaut 61-74 : elle vise donc explicitement
`RULES-RACE_HUM` et `UPINA-RACE_HTIL`, jamais la race. **Les trois ethnies de Middenheim ne sont
pas couvertes** et gardent leur table de base - le livre ne leur fournit pas de fourchettes.
Si le besoin apparaît, il faudra leur en calculer.

Vérifié par simulation avant livraison : après fusion, chaque ethnie couverte retombe sur une
table complète 01-100 sans trou ni doublon (63 métiers pour les Humains, 45 Nain/Halfling,
37 Haut Elfe, 22 Elfe Sylvain).

**Sixième coquille de livre** : colonne Humain, Sailor-Priest 67 puis Sailor 69-71 - le 68
n'appartenait à personne. Saisi en 68-71.

**Correctif d'ergonomie (21/08/2026)** : `TabMetier` était `Enabled = False` dans le `.lfm`, ce qui
la rendait non modifiable... mais bloquait aussi l'ascenseur et la molette, un contrôle désactivé
n'acceptant aucune souris. Nono ne se souvenait plus du motif ; son commentaire dans
`TabMetierPrepareCanvas` (« Couleur de fond de l'en-tête désactivé ») l'a retrouvé : la grille
porte `goEditing`, elle avait donc été désactivée pour empêcher la saisie, puis dotée d'un dessin
personnalisé pour compenser le grisage. Correctif : `Enabled = True` **et** retrait de
`[goEditing, goAlwaysShowEditor]` - l'aspect ne bouge pas puisque `TabMetierDrawCell` peint les
cellules lui-même. **`TabRace` est dans le même cas**, non traité faute de demande.

---

### 2.13 Chaque livre porte « ses » infos — nettoyage du périmètre des livres — terminé (21/08/2026)

**Origine.** Nono envisage d'ajouter, **avant l'étape 1 de la création**, un choix des livres
(cochés par défaut sur les livres actifs), et s'inquiète des contrecoups. En creusant, la vraie
gêne n'est pas l'écran à ajouter : c'est que le livre de règles contient des données qui ne lui
appartiennent pas, donc que « livre actif » et « données disponibles » ne coïncident pas
exactement. Principe posé par Nono, qui a servi de règle de tri pour tout le chantier :

> « hors je voudrais que chaque livre possède "ses" infos »

Conséquence directe : **ajouter un livre ne doit plus jamais demander de modifier
`BOOK_RULESBOOK.Xml`.** C'était le cas pour deux familles de données.

**A. Éligibilité aux métiers des suppléments (89 entrées).** Les deux livres de règles portaient
89 balises `<Career name="XXXX-...">"X"</Career>` sous leurs `<Specie>` — c'est-à-dire que le
Rulebook déclarait l'accès à des métiers venus d'autres livres. Toutes déplacées vers le bloc
`DATA_SPECIE_CAREER_DIRECT` du livre propriétaire (8 suppléments concernés), forme déjà retenue
au §2.9/§2.11 précisément parce qu'elle est à plat, portée par le livre contributeur et résolue
à l'usage. Vérification faite livre par livre : inventaire des couples (ethnie, métier) accessibles
avant modification, puis recomparaison après — identique à chaque fois. Les deux Rulebooks ne
contiennent désormais plus que des `<Career name="RULES-...">` (215 de chaque côté).

⚠️ Une entrée déplacée n'est active **que si son livre est chargé** — c'est justement l'effet
recherché, mais cela veut dire qu'un supplément désactivé retire maintenant ses accès, là où le
Rulebook les accordait inconditionnellement.

**B. Libellés d'affichage des livres (16 entrées).** Les deux Rulebooks portaient les
`<Text name="RULES-BOOK ...">` de **tous** les livres — Nono s'en sert pour l'affichage du nom
d'un livre (l'usage « livre officiel » qu'il en faisait a été repris par la balise `<OFFICIAL>`).
Chaque livre reçoit maintenant son propre libellé dans son `<DATA_LABEL>`, sous son propre code :
`<Text name="SEAOF-BOOK SEA OF CLAWS">"Sea of Claws"</Text>`, dans les deux blocs
`<Label language="ENGLISH">` et `<Label language="FRANCAIS">` (le parser lit bien plusieurs
`<Label>` par `DATA_LABEL`, vérifié dans `xmlexportimport.pas` avant de se lancer). Les deux
Rulebooks ne gardent que le leur, chacun dans sa langue.

**Trois libellés manquaient** et ont été créés au passage : `LUSTR-BOOK LUSTRIA`,
`GREEN-BOOK GREEN IZ BEST`, `NAGGA-BOOK LORDS OF NAGGAROTH`. Lustria s'affichait donc « (F) »
depuis son import — voir le piège ci-dessous.

**Bug de mon script, trouvé à la vérification finale** : la regex de suppression a retiré des deux
Rulebooks *leur propre* libellé, que le script venait d'ajouter. Réinséré à la main
(`"Rules Book"` / `"Livre de Règles"`). Contrôle final : **17 fichiers, 17 libellés, tous couverts**,
et les 17 XML se parsent.

**Kaboom au lancement — access violation, corrigé.** J'avais posé dans 14 livres un commentaire XML
expliquant le déplacement, **juste à l'intérieur** de `<DATA_LABEL>`. La boucle de lecture
(`xmlexportimport.pas` ligne 1022-1025) parcourt tous les nœuds enfants sans garde sur le nom :

```pascal
NodeNv2 := NodeNv1.FirstChild;
While Assigned(NodeNv2) do
  begin
    Langue := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
```

Un commentaire n'a pas d'`Attributes` → `nil.GetNamedItem` → *Access violation reading from address
`$0000000000000010`* dès le chargement. C'est exactement le piège documenté au §2.11, que j'ai
reproduit moi-même une semaine plus tard. Correctif : les 14 commentaires remontés **avant**
`<DATA_LABEL>`, au niveau `DATA_BOOK` — niveau atteint uniquement par `BookNode.FindNode(...)`
(vérifié : `BookNode` n'apparaît jamais dans une boucle sur ses enfants), où d'autres commentaires
vivent déjà. Aucune recompilation, ce sont des données.

⚠️ **Leçon sur la vérification.** Mon contrôle testait que les XML *se parsent* et que les libellés
étaient présents — un commentaire est du XML parfaitement valide, il passait. La bonne question après
un ajout de commentaire n'est pas « est-ce du XML valide ? » mais **« la boucle qui lit ce bloc
a-t-elle une garde sur le nom du nœud ? »**. Les blocs récents (`DATA_RACE`, `DATA_RULE`,
`DATA_CAREER_ROLL`, `DATA_SPECIE_CAREER_DIRECT`) l'ont ; `DATA_LABEL`,
`DATA_SPECIE_CAREER_CHOICE`, `DATA_SKILL_SPECIALIZATION` et `DATA_CAREER_SUBCHOICE` ne l'ont
toujours pas — un simple commentaire y plante le programme au lancement (dans `A FAIRE.txt`).

**Le `(F)` : source de vérité changée (21/08/2026, confirmé par Nono).** `GetTexteLibelle(...,true)`
préfixait `(F)` quand le libellé était **introuvable** (`chargetexte.pas` ligne 99-114), en
reconstruisant un nom présentable à partir du code. Ça ressemblait à un marqueur « livre de fan »
tant que les seuls livres sans libellé étaient Green iz Best et Lords of Naggaroth — mais la
coïncidence ne tenait déjà plus : Lustria, officielle, affichait « (F) Book Lustria ». En créant les
3 libellés manquants, le `(F)` a disparu des deux livres fan, ce que Nono a vu tout de suite.

Nono veut le garder (« ça permet de savoir que ce n'est pas un livre officiel directement »), donc il
est **reconstruit délibérément depuis `<OFFICIAL>`** :

- `chargeconstantes.pas` : `ConstLivreFanOfficiel = 2` (0 = livre de règles, 1 = supplément officiel,
  2 = livre de fan) ;
- `chargetexte.pas` : `uses` + `ChargeLivre` (pas de cycle, `ChargeLivre` ne remonte pas vers
  `ChargeTexte`), le repli ne fait plus que remettre le code en forme, et le préfixe est ajouté après :

```pascal
    if Livre then
      begin
        PLivre := ChercheLivreLibelle(CodeTexte);
        if RechercheTrouve and (PLivre.Officiel = ConstLivreFanOfficiel) then
          Res := '(' + ConstLivreFacultatif + ') ' + Res;
      end;
```

Le marqueur réutilise `ConstLivreFacultatif`, la lettre déjà affichée dans la colonne O/F du tableau
des livres (`warhammersource.pas` ligne 974-978) : les deux affichages ne peuvent plus diverger.
Les 8 appelants de `GetTexteLibelle(...,true)` en bénéficient d'un coup (liste des livres ×2,
armures ×2, création ×2, métiers, personnage). Confirmé par Nono.

⚠️ **Bug signalé, non corrigé** : `ChercheLivreLibelle` et `ChercheLivre` (`chargelivre.pas`)
**n'affectent pas leur `Result` quand elles ne trouvent rien** — les champs entiers valent alors
n'importe quoi. D'où le passage par `RechercheTrouve` ci-dessus. Le cas est réel (l'écran des armures
affiche le livre d'une armure même si ce livre n'est pas chargé), et `warhammersource.pas` ligne 973
lit `PLivre.Officiel` sans garde.

**Reste ouvert.** Le garde-fou sur la boucle de sauvegarde des `LivresAcceptes` dans
`winpersonnage.pas` (`if TabLivre.Cells[3, Ind] <> ''`), qui expliquerait le « livre vide » ajouté à
l'enregistrement dont Nono se souvient — proposé, pas encore validé. L'écran de choix des livres,
motivation d'origine du chantier, a démarré sur ce terrain nettoyé : §2.14.

---

### 2.14 Choix des livres à la création — écran terminé (21/08/2026), filtrage à faire

**Idée de Nono**, formulée pendant §2.13 : ajouter, avant l'étape 1 de la création, un choix des
livres affichant ceux qui sont actifs par défaut — avec la crainte explicite des contrecoups.

**Ce qui existait déjà** (la moitié du chantier, trouvé en creusant avant de coder) :

- `TabLivre` vivait déjà **dans WinCreation**, posée sur `TabSheetRace`, avec son `TabLivreDblClick`
  qui reconstruit `LivresPersonnages` à chaque bascule ;
- `LivresPersonnages := LivresCharges` au démarrage (ligne 438) : les livres actifs du menu principal
  arrivent **pré-cochés**, exactement ce que Nono décrivait, sans rien à coder ;
- `Personnage.LivresAcceptes := LivresPersonnages` à la sauvegarde finale.

**Découverte qui a simplifié le reste : la création n'avance que vers l'avant.** Il n'existe aucun
bouton retour (`ButtonPhaseSuivante` → `ChangementPhase(ConstSuivant)` est le seul appel utilisateur)
et les onglets des autres phases sont `TabVisible = False`. Donc **aucune invalidation à écrire** :
on ne peut pas revenir décocher un livre après avoir choisi une ethnie.

**Le contrecoût, mesuré avant de toucher quoi que ce soit.** `PhaseEnCours` n'apparaît qu'à 8
endroits, tous dans la navigation — aucun autre bout de code ne code un numéro d'étape en dur.
Ajouter une étape se réduit donc à 5 points, notés en commentaire au-dessus de `PhaseMax` :

1. `PhaseMax` (7 → 8) ;
2. `ListPhase` dans `ChargerImage` (un libellé de plus, en tête) ;
3. le `case PhaseEnCours` de `PageEtapesChange()` — validation avant de quitter une étape ;
4. le `case NouvellePhase` de `PhaseSave()` — **`NouvellePhase` est l'étape où l'on ARRIVE**, chaque
   branche enregistre donc le résultat de la précédente et efface ce qui suit ;
5. l'ordre des `TTabSheet` dans le `.lfm`.

**Réalisé.** `TabSheetLivre` insérée en première page de `PageEtapes` avec `TabLivre` et `LabLivre`
déplacés depuis `TabSheetRace` ; les deux `case` décalés d'un cran ; nouvelle branche `0:` dans
`PageEtapesChange` qui refuse d'avancer si plus aucun livre n'est coché (`MESS_056`) ; nouvelle
branche `1:` dans `PhaseSave`, vide et commentée.

⚠️ **Les libellés de phase portaient leur numéro en dur** : `LAB_026` valait littéralement
« Phase 1 sur 8 - Choix de la Race ». Les 8 ont dû être réécrits en « sur 9 », plus `LAB_173` créé
pour la nouvelle étape. Le numéro est pourtant déjà calculé ailleurs
(`TabSheet.Caption := IntToStr(i+1)+' sur '+IntToStr(PhaseMax+1)`) : à terme, retirer le préfixe des
libellés éviterait de renuméroter 8 textes × 2 livres à chaque étape ajoutée (dans `A FAIRE.txt`).

**Le gel de `TabLivre`** (`UpdateSheetRace`, ligne ~1858 : `TabLivre.Enabled := not
RadioButtonRace*.Checked`) est resté en place. Il ne sert plus à rien puisque le tableau n'est plus
sur l'onglet de l'ethnie et que la navigation est unidirectionnelle, mais le retirer aurait été une
modification de plus.

#### En cours : le filtrage

C'est ici que se trouve la vraie valeur, et rien n'est fait. **`LivresPersonnages` n'est passé qu'à
4 endroits** — `ResultMetierSousMetier`, `TexteMetierSousMetier`, `TexteMetierRaceChoixMetier`,
`ResultMetierRaceChoixMetier`. Ni la liste des ethnies, ni celle des métiers, ni les talents,
compétences ou équipements ne le regardent : **décocher un livre ne change presque rien à l'écran.**

Le filtrage se fait à l'usage sur le champ `.Livre`, présent sur tous les records — pas de
rechargement. À traiter liste par liste, chacune testable séparément.

Point particulier repéré : `ComboRaceCreation` (ligne 1597, `ChargeTabRaces`) choisit **de quel livre
on prend la table de tirage des ethnies**, se remplit depuis `ListRaceCreation` et ignore
`LivresPersonnages` — on peut donc prendre la table d'un livre qu'on vient de décocher. Deux widgets
de livres au sens différent cohabitaient sur l'étape 1 ; ils sont maintenant séparés (les cases sur
l'étape 0, la combo sur l'étape de l'ethnie), mais la combo reste à filtrer.

---

### 2.15 Lézards de Lustria — traits de créature puis race Skink — en cours (21/08/2026)

Demande de Nono : « tu peux voir pour ajouter les lézards ? » (ligne « faire les lézards des LUCIA »
qui traînait en tête d'`A FAIRE.txt`).

**Ce que le livre offre** (Lustria p. 160-163, le PDF a la même numérotation que le livre) : deux
profils jouables, **Skink** et **Skink Caméléon** — le livre exclut explicitement Saurus, Kroxigor
et Slann. C'est le modèle du §2.10 sans rien forcer : une RACE `LIZARDMAN`, deux ETHNIES, comme les
Norses. Attributs, formule de Blessures (`2xBATTR_T+1xBATTR_WP`, sans terme de Force), compétences,
talents et table de tirage par ethnie s'expriment tous tels quels — et les 21 métiers de la table
sont **tous des métiers du Rulebook**, rien à créer.

Renvois utiles : p. 135 (tempéraments, blessures spécifiques aux Lézards), p. 151 (Marques des
Anciens **et** définition des traits `Chameleon`/`Telepathy`), Rulebook p. 338-341 (les ~70 traits).

#### La décision de conception : un trait EST un talent

J'ai d'abord proposé un catalogue séparé `DATA_CREATURE_TRAIT`. **Nono a objecté**, et son objection
était juste : « théoriquement, il faut un talent du niveau. Et il faudrait mélanger des talents et
des traits ? » Le mélange vient de la séparation, pas de son absence :

- le Rulebook définit lui-même **Night Vision** comme *« The creature has the Night Vision Talent »* ;
  avec deux catalogues, un Skink porterait `TRAIT_NIGHTVISION` pendant qu'un métier lui proposerait
  `RULES-T0164` — deux entrées pour la même chose, sans rien pour détecter le doublon ;
- le tableau des Marques des Anciens (p. 151) distribue **traits et talents côte à côte**, dans le
  même paquet, sans coût (Tzunki donne *Amphibious* et *Acute Sense (Sight)* ensemble).

Et la progression n'est pas concernée : un trait ne s'achète jamais. Les talents proposés viennent
toujours d'une table explicite — `ListMetierTalent`, `ListRaceTalent`, `ListTalentCreation` — donc un
trait ne peut pas apparaître dans un choix de niveau.

**Retenu : un trait est un talent qu'on ne peut pas CHOISIR**, marqué par un drapeau.

**Découverte : Nono avait déjà commencé.** `DATA_TALENT` contenait déjà sept traits de créature,
avec sa propre convention — `T0` + trois lettres (au lieu de `T0` + quatre chiffres pour les vrais
talents), et `_*` pour les paramétrés : `T0BIG`, `T0PAI`, `T0DIE`, `T0BEL`, `T0DVI`, `T0HAT_*`
(Animosity), `T0AFR_*` (Afraid). Convention suivie, aucune nouvelle inventée.

**Deuxième usage, signalé par Nono** : ça débloque les mutations physiques du §2.7. Deux entrées
renvoient à un trait — `CORPHY_008` *Fleshy Tentacle* (« Gain the Tentacles Creature Trait ») et
`CORPHY_020` *GM's Choice*. La première devient un ajout de talent ordinaire, et hérite de
l'astérisque numérotée déjà en place.

#### Fait et confirmé

**Modification 1 — le drapeau (code).** `ConstXmlTrait = 'Trait'` et `ConstVrai = '1'`
(`chargeconstantes.pas`) ; champ `Trait: Boolean` sur `StructureTalent` (`chargetalent.pas`), à côté
de `SousTalent` qui servait de précédent ; lecture + remise à zéro dans `DATA_TALENT` **et**
`DATA_TALENT_SPECIALIZATION` (une spécialisation de trait reste un trait — sinon `Immunity (Poison)`
de la marque de Sotek passerait à travers), écriture à l'export seulement si vrai.

Le filtre ne sert qu'à **un seul endroit** : `winspecialisation.pas` ligne ~91, la branche `else` qui
liste le catalogue complet quand il faut choisir « un talent quelconque ». C'est le seul parcours de
`ListTalent` proposé au joueur dans tout le programme — vérifié.

**Modification 2 — les 7 traits existants marqués** (données, les deux Rulebooks). Premier vrai test
du drapeau, sur des données antérieures : ils disparaissent des choix de talent. Confirmé.

#### Livré, test non confirmé

**Modification 3 — les traits du Skink saisis.** Rulebook : `T0AMP` Amphibie, `T0ARB` Arboricole,
`T0COL` Sang-froid, `T0STE` Furtif, `T0ARM` Armure (Valeur), `T0SIZ_*` Taille + les 7 degrés en
spécialisations (`T0SIZ_TINY` à `T0SIZ_MONS`, modèle `T0AFR_ELF`). Marquées aussi `T0AFR_ELF` et
`T0HAT_GREENSKIN`, spécialisations de traits restées choisissables. Lustria : nouveau `DATA_TALENT`
avec `LUSTR-T0CHA` (Chameleon) et `LUSTR-T0TEL` (Telepathy), les deux traits que ce livre ajoute.

⚠️ Le commentaire explicatif de Lustria est posé **avant** `<DATA_TALENT>`, jamais dedans : cette
boucle n'a toujours pas de garde `NodeName` (§2.13), un commentaire à l'intérieur ferait planter le
chargement.

Champ `PDF` posé après accord de Nono : `T0STE` → `COMPDISC_*`, `T0AMP` → `COMPNATA`. Laissé vide
ailleurs à raison — *Sang-froid* agit sur un attribut, *Caméléon* pénalise la Perception **des
autres**. Le champ accepte des listes (`COMPDISC_*,COMPPRECEP,COMPINTUI` existe déjà), donc
*Arboricole* pourrait porter `COMPESCAL,COMPDISC_*` — proposé, pas tranché.

#### Point de reprise exact : que faire de `T0ARM`

`T0ARM` est aujourd'hui **décoratif** : sa Valeur (1 pour le Skink, 1 point d'armure sur toutes les
localisations) n'est calculée nulle part. Les points d'armure ne viennent que des pièces portées et,
depuis le §2.7, de `ListCorruptionArmureModif` (`chargepersonnage.pas` ligne ~1203). Un Skink saisi
tel quel afficherait le trait avec zéro point d'armure — c'est faux et ça se voit.

Trois options soumises à Nono, sans réponse :

- **(a)** laisser tel quel et le documenter ;
- **(b)** retirer `T0ARM` et décrire la peau écailleuse dans le texte de l'ethnie ;
- **(c)** créer `ListTalentArmureModif`, copie de `StructureCorruptionArmureModif` (4 champs) avec
  une balise `<ModifArmour>` sur le talent et une boucle de plus au même endroit dans
  `chargepersonnage.pas`. Sert aussi la **marque de Quetzl** (« Armour +1 »), qui donne des points
  d'armure sans être une mutation.

Recommandation : **(c)**. `T0ARM` est le seul des sept traits du Skink qui porte un chiffre.

#### Ensuite

1. `NbCinq`/`NbTrois` sont **écrits en dur à 3** dans `wincreation.pas` (lignes ~1512, ~1517, ~2890,
   ~2895, ~2897). Le Skink prend **2** compétences à +5 et **2** à +3. `StructureRace` porte déjà
   `Point3`/`Point5` mais ce sont les *valeurs*, pas les *nombres* : deux champs de plus, une balise
   dans `<Specie>`, et 3 par défaut pour ne rien changer aux races existantes.
2. La race `LIZARDMAN` dans `DATA_RACE` + les deux ethnies dans Lustria (attributs, compétences,
   talents dont les traits, tables de tirage), puis les images.
3. Étape 3, non conçue : substitutions de compétences (13 lignes p. 162), « un Skink ne change jamais
   de métier », et les Marques des Anciens (9 marques, avec le troc des 2 points supplémentaires).

**Huitième coquille de livre**, vérifiée à l'image (Lustria p. 161, colonne Skink) : Messager
**89–92** puis Batelier **92–94**, le 92 appartient aux deux. L'arithmétique ne tranche pas seule,
comme pour Up in Arms. Proposé : **Messager 89–91** — toute la fin de la colonne est à 3 valeurs
(86–88, 92–94, 96–97, 98–100) et un chevauchement d'exactement 1 sur le début du suivant ressemble à
une erreur sur la *fin* de la plage précédente. Non tranché par Nono.

---

## 3. TODO / Backlog

Le backlog complet (tout ce qui n'est pas encore commencé) vit dans `A FAIRE.txt`
(fichier déjà existant dans le projet), pas ici — pour pouvoir y ajouter une ligne à
tout moment sans toucher à l'état détaillé des chantiers ci-dessus. Dès qu'un item
d'`A FAIRE.txt` passe en travail actif, il migre dans la section "en cours" du
chantier concerné, avec les détails techniques.

---

## 4. Pièges Lazarus / Free Pascal accumulés

- **Toute nouvelle liste globale `ListXxx` doit être ajoutée au bloc de RAZ de `ChargerLivre`**
  (`warhammersource.pas`, `if ForceMaj then`), avec son compteur `NbXxx`. Créer la liste dans
  `FormCreate` ne suffit pas : sans le `.Clear`, chaque rechargement (changement de livre actif ou
  de langue) empile le contenu par-dessus l'ancien, et le bug ne se voit **pas** au premier
  lancement. Symptôme typique : une donnée affichée deux fois, puis trois. Arrivé deux fois
  (`ListArmureBonusModif`, `ListArmureSimplifiee`, §2.5). Contre-exemples à ne pas toucher :
  `ListTexte` et `ListTraduction`, volontairement hors de la RAZ (§2.8).
  Contrôle rapide : comparer les `ListXxx := TListXxx.Create` de `FormCreate` aux `ListXxx.Clear`
  du bloc de RAZ.
- **Un commentaire XML est un nœud enfant comme un autre.** Une boucle
  `Node := Parent.FirstChild; While Assigned(Node) do ... Node.Attributes.GetNamedItem(...)`
  plante sur un commentaire (`Attributes` vaut `nil` → *access violation reading from `$10`*), et sur
  un bloc sans attribut elle rejoue silencieusement les valeurs du nœud précédent. Toujours poser
  `if Node.NodeName = <balise attendue> then` avant de lire. Vu deux fois : doublon silencieux
  (§2.11), puis plantage au lancement (§2.13). Les commentaires de documentation se posent **avant**
  la balise du bloc, pas dedans.
- Une fonction Pascal qui renvoie un `record` **ne garantit pas** l'initialisation de son `Result` :
  si aucune branche ne l'affecte (cas de `ChercheLivre`/`ChercheLivreLibelle` quand rien n'est
  trouvé), les champs entiers contiennent n'importe quoi. Tester le drapeau `RechercheTrouve` plutôt
  que le contenu du record.
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
- Retirer le préfixe de livre d'un seul côté d'une comparaison (`ExtractStringAfter(Code,
  SeparateurLivre) = AutreCode`) casse tout aussi sûrement que ne pas le retirer du tout :
  si `AutreCode` garde son préfixe, la comparaison ne matche plus jamais. Toujours traiter
  les DEUX côtés avec la même fonction (`CompareRechercheValeur`, qui découpe les deux
  valeurs en interne) plutôt que de découper à la main un seul argument. Bug réel trouvé le
  16/08/2026 dans `PdfPersonnageCreationFeldo2P` (pdfpersonnage.pas) : le calcul de
  Fortune/Resolve comparait `ExtractStringAfter(PRaceAttribut.CodeRace, SeparateurChance) =
  Personnage.Race`, alors que `Personnage.Race` garde son préfixe livre (`RULES-RACE_HUM`) -
  la base de race n'était donc jamais ajoutée, et Fortune/Resolve affichaient exactement la
  moitié de Fate/Resilience (qui, eux, passent par `PdfPersonnageAttribut`, correcte).
  Repéré par Nono en comparant un rendu PDF réel aux données du XML de sauvegarde. Corrigé
  avec `CompareRechercheValeur(Personnage.Race, PRaceAttribut.CodeRace)`.
- Variante du piège ci-dessus, cette fois sans `CompareRechercheValeur` disponible :
  `PdfPersonnageAttribut` (pdfpersonnage.pas) compare les bonus d'attribut donnés par un
  talent (`PTalent.Attribut`, liste ';' de codes AVEC préfixe livre, ex. `"RULES-ATTR_WP"`)
  par ÉGALITÉ DE CHAÎNE STRICTE (`Attr = Attribut`), pas via `CompareRechercheValeur`. Il faut
  donc toujours lui passer un code d'attribut complet (préfixé), jamais une constante nue
  comme `ConstCaracE`/`ConstCaracFM` - sinon la comparaison échoue systématiquement et
  silencieusement, et les bonus d'attribut venant de talents sont ignorés. Bug réel trouvé le
  16/08/2026 dans la nouvelle fonction `PersonnageCorruptionTotal` (§2.7, Étape 3) : appelait
  `PdfPersonnageAttribut(Personnage, ConstCaracE, Bonus)` avec la constante nue, alors que
  `PdfPersonnageCreationFeldo2P` passe toujours `PAttribut.CodeAttribut` (préfixé, via
  `ListeAttribut`) - `WinPersonnage` affichait 7 là où le PDF affichait 8. Corrigé en
  récupérant le code complet via `ChercheAttribut(ConstCaracE)` (chargeattribut.pas, déjà
  prefix-safe comme `ChercheRaceAttribut`) avant l'appel.
- `TStringGrid.Cells[Col, Row]` (et toute propriété indexée avec getter/setter, plus
  généralement) n'est pas une vraie variable (l-value) : `+=` dessus échoue à la
  compilation avec "Variable identifier expected" (pas une erreur logique, une erreur de
  compilation). Utiliser une réaffectation complète : `Cells[C,R] := Cells[C,R] + '...';`.
  Bug réel trouvé le 16/08/2026 dans `TWinArmors.TabArmorSelection` (winarmor.pas) en
  construisant le texte de malus à partir de plusieurs entrées de `ListArmureBonusModif`.
- **Nouveau contrôle ajouté sur un `TTabSheet` de `WinPersonnage` invisible à l'exécution
  (mais présent dans le `.lfm`, compile sans erreur)** : `MiseEnFormeDesChamp(self)`
  (`globalfonts.pas`, appelée dans `Initialisation()`) crée dynamiquement, pour CHAQUE
  `TTabSheet` du formulaire, un `TShape` plein cadre (`Align := alClient`) par-dessus tout
  le contenu de l'onglet, pour donner le fond noir/thème (`MiseAJourUnContenaire`,
  `globalfonts.pas` ~ligne 52). Ce `TShape` passe devant les contrôles existants sauf s'ils
  sont explicitement ramenés au premier plan - d'où le `ButtonHistorique.BringToFront;` déjà
  présent en fin d'`AfficheImageRace()`. Tout nouveau contrôle posé sur un onglet (existant
  ou nouveau) doit recevoir son propre `.BringToFront;` au même endroit, sinon il compile et
  s'affiche dans l'éditeur Lazarus mais reste invisible une fois l'appli lancée. Bug réel
  trouvé le 16/08/2026 avec `StringGridCorruption`/`ButtonCorruptionAjoute`/
  `ButtonCorruptionSupprime` (nouvel onglet Corruption) - confirmé par Nono : c'est la
  méthode connue (et seule connue) pour avoir un fond noir homogène sur les onglets de ce
  projet, donc pas un bug à corriger à la source, juste un réflexe à avoir pour tout nouvel
  ajout.
- **Pattern récurrent - variable record réutilisée d'un tour de boucle à l'autre pendant un
  chargement XML, jamais remise à vide/zéro avant d'être ajoutée au tableau** : ce projet
  charge presque tout le XML avec UNE SEULE variable record locale par type de donnée
  (`PersonnageTalent`, `PArmureBonus`, etc.), réutilisée pour toutes les entrées d'un même
  tableau (voire plusieurs tableaux différents dans `PersonnageXmlChargement`). Tout champ non
  explicitement réaffecté à chaque itération garde la valeur du tour précédent (voire d'un
  tableau totalement différent chargé plus haut dans la même fonction) - ce n'est PAS remis à
  zéro automatiquement par le `for`/`while`. Déjà rencontré deux fois : `PArmureBonus.Malus`
  (15/08/2026, xmlexportimport.pas, voir plus haut) et `PersonnageTalent.Asterisque`
  (16/08/2026, chargepersonnage.pas, `PersonnageXmlChargement` - `.Asterisque` jamais
  initialisé aux trois sites de chargement `CreationTalent`/`AugmentationTalent`/
  `MetierTalent`, ce qui affichait des `(-1)` parasites à côté de chaque talent sur le PDF ;
  une deuxième erreur s'y ajoutait, la boucle de calcul des astérisques pour
  `AugmentationTalent` testait `PersonnageTalent.Asterisque` - la variable de boucle du
  chargement XML, sans rapport - au lieu de `Personnage.AugmentationTalent[indiceTalent]
  .Asterisque`). Réflexe à avoir : quand une variable record locale est réutilisée pour
  peupler un tableau dans une boucle de chargement XML, vérifier que TOUS ses champs sont
  explicitement réaffectés à chaque itération, pas seulement ceux qui viennent du XML lu à cet
  endroit précis.
- Ajouter un contrôle dans l'IDE (glisser-déposer un `TRadioButton`/`TBCButton`/`TStringGrid`
  etc.) ne câble PAS son `OnClick`/`OnDblClick` tout seul, même si le gestionnaire existe déjà
  dans le `.pas` (écrit par Claude, pas créé via double-clic dans l'IDE). Il faut explicitement
  aller dans l'Inspecteur d'objets (onglet Events) et choisir le nom du gestionnaire dans le
  menu déroulant pour CHAQUE contrôle. Tant que ce n'est pas fait, le code compile sans erreur
  (les procédures existent, juste non référencées par aucun contrôle) mais la fenêtre reste
  figée dans son état de départ - aucun retour visuel n'indique l'oubli. Repéré le 17/08/2026
  (CONTEXT.md §2.7, étape 6) : Nono avait ajouté tous les nouveaux contrôles de `WinMutation`
  mais pas câblé leurs événements, ce qui laissait le bouton "Randomly" (Hasard) visible même
  après avoir sélectionné un autre mode - diagnostiqué en relisant le `.lfm` (aucune ligne
  `OnClick =` sur les nouveaux contrôles).
- **`Personnage` (et tous les records associés : `PersonnageMetier`, `PersonnageAttribut`,
  `PersonnageCompetence`, etc., `winpersonnage.pas`) ne sont PAS des champs propres à chaque
  fenêtre `TWinPersonnages`** : ce sont des variables globales UNIQUES au niveau de l'unité
  (déclarées avec des initialiseurs `= false`/`= ''` typiques d'un bloc `var` d'unité, pas d'un
  champ de classe), partagées par TOUTES les instances de fenêtre ouvertes. Repéré le
  17/08/2026 en concevant le changement de langue en direct (§2.8) : impossible de savoir "quel
  personnage est ouvert dans quelle fenêtre" en lisant cette donnée, puisqu'elle est écrasée par
  la dernière fenêtre créée/chargée, quel que soit le nombre de fenêtres réellement visibles à
  l'écran. Pas corrigé (hors scope de ce chantier, comportement pré-existant) - juste contourné
  en identifiant les fenêtres via `Screen.Forms` + `is TWinPersonnages`/`is TWinCreations`
  plutôt que via cette donnée interne. À garder en tête pour tout futur chantier touchant à
  l'ouverture simultanée de plusieurs personnages : deux fenêtres ouvertes en même temps
  partagent aujourd'hui le même `Personnage` en mémoire.

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
