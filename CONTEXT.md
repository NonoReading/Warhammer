# Warhammer — Contexte projet

**Dernière mise à jour : 04/09/2026 — après-midi : la LECTURE des appartenances est branchée
et éprouvée de bout en bout (§2.44), les greffes atterrissent dans la fiche. (Matin : lots 3a, 3b, 3c ET 3d-1 de *Nations of Mankind* TERMINÉS
au §2.37 : les onze ethnies humaines, les 72 sorts des six domaines de magie, l'armurerie —
44 armes de mêlée, 17 à distance, 6 munitions, 28 armures, 3 accessoires — et les sept
provinces de l'Empire. **Il ne reste que 3d-2 (régiments) et 3d-3 (ordres de chevalerie)**,
qui demandent tous deux une conception ; celle du 3d-2 est arretee au §2.44
(table `DATA_CAREER_BONUS`), non appliquee. Les deux bugs laissés ouverts le 03/09 sont corrigés —
qualités d'armes d'Archives I, et export du bloc `DATA_RACE` au §2.42 ; les compétences
« A ou B » n'apparaissaient pas dans WinRaces, corrigé au §2.43. ⚠️ Lire le §0 sur
**l'écriture qui répond « écrit » sans écrire**, découverte le 04/09.)** Ce fichier remplace tous les anciens
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

**Règles de lecture des sources, ajoutées le 30/08/2026 après quatre erreurs de la même
famille dans la même journée** — toutes venaient de conclure trop vite depuis un outil de
lecture, jamais depuis la source elle-même :

- **Chercher dans les TXT AVANT d'ouvrir un PDF (règle de Nono, 03/09/2026).** Traiter un
  PDF coûte cher : il faut le rapatrier entier sur ma machine puis le convertir, quand une
  recherche dans un TXT déjà présent répond en une seconde. Donc, toujours dans cet ordre :
  chercher d'abord dans les TXT, et dans **les deux répertoires**, car ils n'ont pas le même
  contenu — `LIVRES\` (TXT à côté des PDF, tous les livres n'en ont pas) et `PDF_TEXTE\`
  (l'export du corpus, qui couvre des livres absents du premier). N'ouvrir le PDF que si
  aucun des deux ne porte l'information cherchée, ou si l'extraction est visiblement
  fautive.
  Vérifié le 03/09/2026 : les listes « Blessings and Strictures » de *Nations of Mankind*
  ont été extraites du PDF alors que `PDF_TEXTE\Nations of Mankind.txt` les portait
  **à l'identique, aux mêmes numéros de ligne**. Attention donc à ne pas généraliser la
  remarque du §2.37 (« le TXT du corpus ne suffit pas ») : elle vaut pour les **tableaux de
  carrière**, où la mise en page est perdue, et non pour le texte courant.
- **Recharger avant d'indexer.** Avant de construire un index du corpus (résolution de
  libellés en identifiants, recherche de doublons, vérification de références), restager
  les fichiers depuis le poste. Une copie vieille de quelques heures a suffi à me faire
  signaler un bug qui n'existait pas — et aurait tout aussi bien pu m'en faire rater un.
- ⚠️ **L'écriture vers le poste répond « écrit » sans avoir écrit (04/09/2026).** Trois fois
  dans la même session, l'outil qui repose un fichier sur le poste a renvoyé un succès alors
  que le contenu n'avait pas changé — la **date du fichier avançait pourtant**, ce qui rend le
  piège invisible si on ne regarde que l'horodatage. À chaque fois, refaire **exactement le
  même envoi** l'a fait atterrir : c'est le premier envoi après un restage qui se perd.
  Donc : **après chaque écriture, vérifier la TAILLE du fichier sur le poste** (le listing du
  répertoire la donne) et la comparer à celle envoyée ; si elle diffère, réémettre et
  revérifier. Ne jamais annoncer une livraison sur la seule réponse de l'outil. C'est le
  pendant, côté écriture, de la règle « restager avant d'interpréter un test » : la première
  fois, ce sont 23 armes qui n'étaient pas sur le disque alors que je les avais annoncées.
- **Le contrôle de collision doit porter sur la nature de donnée qu'on AJOUTE, pas
  seulement sur celles qu'on référence (04/09/2026).** En écrivant les provinces de
  l'Empire, la résolution des libellés a bien vérifié les 1 044 compétences et talents
  cités — et pas une seule fois les *ethnies* elles-mêmes, qui étaient pourtant l'objet
  du lot. Trois doublons sont partis sur le poste : `Humans (Reikland)` était déjà
  `RULES-RACE_HUM` du Rulebook, Middenland et Nordland étaient déjà dans Middenheim sous
  leurs gentilés. Le nom du Rulebook était même écrit dans un commentaire du fichier, lu
  quelques minutes plus tôt. C'est Nono qui les a vus dans la liste de WinRaces. La règle :
  avant d'écrire N objets d'une nature donnée, indexer les libellés **de cette nature**
  dans tout `DATABASE\`, pas seulement ceux des objets qu'ils citent.

- **Un marqueur compté n'est pas un marqueur lu.** Avant de conclure depuis un `grep -c`,
  sortir le contexte autour des occurrences. Trois livres ont été mal classés parce que
  leurs « Career Path » étaient des fiches de PNJ et de la prose.
- **Un grep aplatit la mise en page.** J'ai déclaré les sorts d'un livre inexploitables
  parce que deux colonnes se mélangeaient dans un résultat de grep ; `pdftotext -layout`
  préservait les positions, il suffisait de découper la gouttière. Un défaut de mon outil
  de lecture n'est pas un défaut de la source.
- **L'outil de lecture perd aussi les attributs de caractère, pas seulement la mise en
  page (03/09/2026).** Sur *Nations of Mankind* j'allais écrire que la compétence de tête
  des 30 carrières « n'existe nulle part dans le PDF », parce que ce livre n'a pas de table
  d'index des carrières. Nono : « c'est la ligne en italique ». Le livre porte bien la
  donnée, en italique dans la liste de compétences du niveau 1 — et `pdftotext` ne
  transporte pas l'italique, quelle que soit l'option. `pdftohtml -xml` conserve les
  balises `<i>` ; les 30 ont été retrouvées en une passe. La règle : **avant de déclarer
  une donnée absente d'un PDF, vérifier qu'elle ne tient pas dans ce que mon extraction
  jette** — italique, gras, couleur, encadré, position. En pratique : `pdftotext -layout`
  pour le texte et les colonnes, `pdftohtml -xml` dès qu'une information peut être portée
  par la typographie.
- **Quand une donnée n'est pas là où je regarde, elle est ailleurs.** L'hypothèse par
  défaut n'est jamais « elle manque ». Pour un talent ou une compétence, le premier
  « ailleurs » à essayer est **la base**, pas une autre page du livre. Deux modes d'échec
  distincts, rencontrés l'un et l'autre : *(a)* chercher un nom de balise et le trouver
  ailleurs qu'on croit — `DATA_CAREER_ROLL` et `DATA_SPECIE_CAREER_DIRECT` emploient les
  mêmes noms d'enfants, donc compter les `<Entry>` mélange des plages de dés et des
  indicateurs d'éligibilité ; toujours ancrer sur le bloc parent attendu. *(b)* ne pas
  trouver un nom de balise et en déduire que la **donnée** est absente — les livres
  n'emploient pas tous la même structure : le Rulebook range ses tables de tirage dans
  `DATA_CAREER_ROLL`, Middenheim les range sous `SUBCHAPTER_CAREER` dans chaque `<Specie>`.
  Avant de dire « ce livre n'a pas X », lister les balises **réellement présentes dans ce
  fichier**, puis chercher par le **contenu**.
- **Avant d'introduire une valeur nouvelle dans un champ existant**, vérifier si le champ
  est un libellé libre ou une **énumération portée par le code**. `TypSpell` en est une :
  y avoir ajouté « Ritual » sans le vérifier a laissé deux bugs derrière moi.
- **RACE et ETHNIE : les balises disent l'inverse de leurs identifiants (relevé le
  03/09/2026).** `DATA_RACE` porte les **races** (`RULES-SPECIE_HUMAN`, `RULES-SPECIE_HELF`…)
  et `DATA_SPECIE` porte les **ethnies** (`RULES-RACE_HUM` « Humans (Reikland) »,
  `MIDDE-RACE_HMIDL`…). Dans chaque `<Specie>`, le champ qui remonte à la race s'appelle
  `<Ethnic>`. Donc, des deux côtés, le nom de balise et le préfixe d'identifiant se
  contredisent :
  ```xml
  <Specie id="RULES-RACE_HUM">              <!-- balise Specie, id RACE_  : une ETHNIE -->
    <Ethnic>"RULES-SPECIE_HUMAN"</Ethnic>   <!-- balise Ethnic, id SPECIE_ : la RACE   -->
  ```
  C'est cohérent dans toute la base, ce n'est donc pas un bug — mais c'est ce qui fait lire
  un fichier de travers. Le modèle, lui, est simple : **une race, N ethnies**. Les neuf
  ethnies humaines (Reikland, Middenheimer, Middenlander, Nordlander, Salzenmunder, les
  trois Norses, Tilea) pointent toutes sur `RULES-SPECIE_HUMAN` ; les onze Hauts Elfes de
  HEPG plus celui du Rulebook pointent tous sur `RULES-SPECIE_HELF`.

**Édition directe des fichiers sur le poste de Nono — deux règles, après trois occurrences
du même incident (31/08, 01/09, 02/09/2026) :**

- **Restager avant CHAQUE édition, pas seulement en début de session.** La copie que j'ai
  sous la main vieillit dès que Nono touche à un fichier, ou dès que je committe moi-même.
  Les trois fois, la copie de base précédait un ajout fait quelques heures plus tôt.
- **Lire les RETRAITS du diff, pas seulement les ajouts.** C'est le seul contrôle qui
  attrape le cas : une insertion de dix lignes qui fait disparaître une ligne existante se
  voit à `diff | grep '^<'`, et à rien d'autre. Un diff dont les retraits ne sont pas
  exactement ceux que j'ai voulus ne part pas ; je refais l'édition depuis la version
  fraîche.

⚠️ **L'ENREGISTREMENT DEPUIS WINLIVRE N'EST PAS ACTIVE (Nono, 04/09/2026).** Ne plus
proposer « sauvegarde le livre depuis WinLivre et on regarde si le bloc ressort » comme
test : l'ecriture n'existe pas encore cote interface (§2.1, phase 2 jamais demarree, tous
les `TEdit` en `ReadOnly`). Ce qui se teste aujourd'hui sur un bloc XML nouveau, c'est le
CHARGEMENT et l'affichage, rien d'autre. La consequence pour la conception ne change pas :
un bloc lu mais non exporte reste un bug a corriger au moment ou on l'ecrit (§2.42), parce
que le jour ou l'enregistrement sera active il effacerait le bloc — mais ce risque ne se
verifie pas par un aller-retour, il se verifie en RELISANT le code d'export.

**Tenue de `A FAIRE.txt` (Nono, 30/08/2026)** — deux règles, parce que ce fichier a déjà
dérivé une fois jusqu'à 2302 lignes :
- **Des items courts plutôt que de gros blocs.** Un sujet qui se décompose en plusieurs
  étapes se scinde en autant d'entrées ; on n'écrit pas un pavé qui mêle le raisonnement,
  la décision et ce qui reste. Ce qui reste à faire doit se lire, pas se déterrer.
- **Une passe de nettoyage à chaque fin de session**, sur tout le fichier et pas seulement
  sur ce qu'on vient de toucher. Le piège vérifié le 30/08 : les blocs marqués « terminé »
  contiennent souvent des points encore ouverts, enfouis au milieu. On **distille** donc
  chaque bloc clos — garder les points vivants, les règles du type « ne plus ressortir en
  anomalie » et les méthodes réutilisables — après avoir vérifié que le reste a bien son
  équivalent daté dans `Log.txt`. Une conception arrêtée mais non appliquée n'a pas sa
  place ici non plus : elle va dans `CONTEXT.md`.

**Quand Nono dit qu'il va committer (règle du 30/08/2026)** — lui proposer **le récapitulatif
de ce qui part dans ce commit**, sans qu'il ait à le demander : la liste des fichiers modifiés
**depuis son dernier commit**, groupés par nature (données / code / fichiers de suivi), avec
une phrase par groupe sur ce qui a changé, et une proposition de message de commit. Cela
suppose de tenir le compte, au fil de la session, de ce qui a été livré depuis le dernier
« j'ai commit » — c'est à moi de le suivre, pas à lui de s'en souvenir.

**Règle de scission des ethnies (Nono, 30/08/2026)** — « ce qu'il faut éviter, c'est le
bête doublon dont juste le nom de l'ethnie change ; si au moins une donnée de création
change, alors on double ». Le critère est donc factuel et se vérifie avant de trancher :
comparer les compétences, les talents, les caractéristiques et la table de carrière. Si
tout est identique, une seule ethnie. Si **une seule** de ces données diffère, on scinde,
même si ça fait beaucoup d'ethnies — les onze sous-types de Haut Elfe de *High Elf
Player's Guide* ont été tranchés ainsi. Conséquence assumée : la table de tirage porte
autant de lignes que d'ethnies.

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

### 2.15 Lézards de Lustria — traits de créature puis race Skink — terminé (03/09/2026)

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

#### Fait et confirmé (22/08/2026) — la race est jouable

**Modification 4 — un talent peut donner des Points d'Armure.** Nouvelle unit
`chargetalentarmuremodif.pas`, copie conforme de `ChargeCorruptionArmureModif` (4 champs, même
balise `<ModifArmour name="ARMOL_XXX">`), lue dans `DATA_TALENT`, écrite à l'export, sommée par
`PersonnageTalentArmureModif` (`chargepersonnage.pas`, à côté de la version mutation) et appelée aux
deux endroits du PDF qui calculent la silhouette. `T0ARM` porte ses 4 `<ModifArmour>` à 1.

La valeur déclarée vaut pour **un niveau** et est multipliée par le niveau possédé : c'est la lecture
de « Armour (**Rating**) », et ça rend exprimable le profil *Armour 2* du Skink Caméléon adverse.
Sert aussi la marque de Quetzl (« Armour +1 »), qui donne des Points d'Armure sans être une mutation.
⚠️ `.Clear` et compteur ajoutés à la RAZ de `ChargerLivre` **dès l'écriture** — c'est exactement
l'oubli du §2.5.

**Modification 5 — le nombre de compétences de race sort du code.** `StructureRace` gagne `NbPoint3`
et `NbPoint5` (le NOMBRE, à ne pas confondre avec `Point3`/`Point5` qui sont la VALEUR de l'avance).
Deux balises optionnelles sur `<Specie>`, `<Skill5>` et `<Skill3>`, **3 par défaut** — aucune race
existante à modifier. Les cinq `3` en dur de `wincreation.pas` remplacés. `MESS_013`/`MESS_014`
portaient le mot « trois » **dans le texte** : passés en `%d` + `Format` (et grammaire corrigée au
passage, « You must choice » → « choose »). En-têtes de colonnes calculées de même
(`Format('%dx %dpts', [NbPoint5, Point5])`) — un Skink affiche « 2x 5pts ».

Découverte : `Point3`/`Point5` existaient déjà dans la structure mais étaient **écrits en dur à 3 et
5 au chargement** (`xmlexportimport.pas`). Le terrain était préparé, jamais branché sur le XML.

**Modification 6 — la race et les deux ethnies.** `LUSTR-SPECIE_LIZARD` + `LUSTR-RACE_SKINK` et
`LUSTR-RACE_SKICH`, complètes : 15 attributs (Blessures `2xBATTR_T+1xBATTR_WP`, sans terme de Force),
compétences, talents au choix, traits, tables de tirage vérifiées **01-100 exactement une fois**.
`Ranged (Blowpipe)` n'existait pas → créé (`LUSTR-COMPPROJ_SARBAC`), et l'entrée combinée déclarée
comme le `RULES-COMPCOMB_2M/RULES-COMPCOMB_FLEAU` du Rulebook. Images : le Skink de la p.136 détouré,
et **le même viré au vert jungle** pour le Caméléon — le livre n'offre aucune illustration de
Chameleon Skink (page 142 entièrement en texte, vérifié au rendu). Triche assumée par Nono.

#### Ce que les lézards ont exhumé — cinq défauts de fondation

Remarque de Nono qui résume la soirée : *« le problème de l'ajout des règles, c'est que cela peut
affecter les fondations »*. Le Skink n'a rien cassé : il a **exercé** des chemins que rien
n'empruntait. Aucun des cinq bugs n'est dans les données des lézards.

1. **Tirage des choix sans protection anti-doublon.** `ButtonTalentHasardClick` résout en 3 passes ;
   seule la passe 2 (tirage aléatoire) testait `TalentDejaPossede`. La passe 1 (choix) tirait à
   l'aveugle. Invisible tant qu'aucune ethnie ne proposait **deux fois la même liste** — le Skink est
   le premier (« 2 talents parmi les 6 listés »). Corrigé, avec repli sur la liste complète si tout
   est déjà pris.
2. **Libellé recopié d'une ligne à l'autre** → §2.17, c'est le défaut systémique des `Cherche*`.
3. **Le rang n'était pas écrit dans `TabCreationChoix`.** `TabCreationChoixDblClick` identifie une
   ligne par (source, parent, **rang**), mais `AfficheChoixCreation` n'écrivait jamais `ColChoixRang`
   — le tableau Hasard voisin écrit le sien depuis toujours. `StrToIntDef('',0)` donnait donc 0 pour
   toutes les lignes et le choix atterrissait **toujours sur la première**. Diagnostic trouvé par
   Nono : « je me demande si tu recherches par le libellé / code qui est identique sur les deux
   lignes ». Une ligne de correctif.
4. **`RecapTalent` figée à 10 lignes.** `RowCount := 10` en dur dans `ChargerImage`, écriture sans
   contrôle dans `PhaseSave` → `EGridException: Index Out of range Cell[Col=1 Row=10]` au passage à
   l'étape suivante. Le Skink cumule 6 traits + 2 talents choisis et franchit la barre. **`RecapComp`
   avait le même défaut à deux endroits**, et sa `RowCount` n'est même jamais fixée dans le code —
   elle aurait sauté une étape plus loin. Trois garde-fous posés, sur le modèle qui existait déjà
   dans `AjouteTalentsResolus`. `RecapAttribut` est borné structurellement (10 colonnes = 10
   attributs), pas touché.
5. **Compétence combinée non déclarée** (`A/B/C` dans `SUBCHAPTER_SKILL`) → même racine que le n°2.

#### Reste à faire

- Les **substitutions de compétences** (13 lignes, p.162), l'**interdiction de changer de métier** et
  les **Marques des Anciens** (9 marques, avec le troc des 2 points supplémentaires) restent dans le
  texte descriptif de l'ethnie, comme convenu.
- Le Skink n'est **pas** dans une table de tirage de race : accessible en choix libre uniquement,
  décision de Nono (« on peut laisser le choix uniquement pour la race »).
**Huitième coquille de livre** — **tranchée et appliquée** (constaté le 03/09/2026 dans
`BOOK LUSTRIA.xml` : Messenger `89-91`, Boatman `92-94`). Lustria p. 161, colonne Skink,
imprimait Messager **89–92** puis Batelier **92–94**, le 92 appartenant aux deux.
L'arithmétique ne tranchait pas seule : toute la fin de la colonne est à 3 valeurs
(86–88, 92–94, 96–97, 98–100), donc l'erreur était sur la *fin* de la plage précédente.

**Les placeholders `LAB_xxx` sont branchés** (03/09/2026) — voir §2.34, qui a traité d'un
coup les quatre de `TabCreationChoix` et de `WinLanceDe`. Ils n'avaient rien de spécifique
aux lézards : ils sont simplement apparus pendant ce chantier.

**Ce que ce chantier a appris sur la tenue des fichiers.** Il est resté marqué « en cours »
jusqu'au 03/09 alors que ses deux derniers points étaient réglés depuis le 27/08 — c'est
Nono qui l'a signalé (« 2.15 n'est pas déjà fait ? »). Le travail avait été fait, jamais
*rayé*. Symétriquement, `A FAIRE.txt` gardait des items que le code avait rattrapés. Vérifier
un item contre la source avant de le réciter coûte quelques secondes ; le laisser traîner
coûte une relance de chantier.


---

### 2.16 Commentaires XML : garde posée une fois pour toutes — terminé (21/08/2026)

**Déclencheur** : troisième plantage de la journée sur la même cause, et celui-là je l'avais
fabriqué. Après avoir réparé les 14 livres le matin (§2.13), j'ai réédité `BOOK LUSTRIA.xml`
**depuis ma copie de travail périmée** et renvoyé la version cassée par-dessus la version réparée.
Nono s'en est sorti en ajoutant un `DATA_LABEL` en tête de fichier : `BookNode.FindNode` ne renvoie
que le **premier** bloc, donc le bloc cassé plus bas n'était plus jamais atteint.

**Audit avant de coder** — ma note dans `A FAIRE.txt` ne citait que 4 blocs, elle était fausse. Sur
les **31 boucles de lecture** de `xmlexportimport.pas`, **27 n'avaient aucune garde** : 24
planteraient sur un commentaire (elles lisent `Attributes`, nil sur un commentaire) et 3
produiraient un doublon silencieux. Seules les 4 écrites cette semaine étaient protégées.

**Correctif : une fonction, pas 27 gardes.** Le problème n'est pas le *nom* du nœud mais le fait
qu'un commentaire et un nœud texte **ne sont pas des éléments** :

```pascal
Function XmlElement(Node: TDOMNode): TDOMNode;
begin
  While Assigned(Node) and (Node.NodeType <> ELEMENT_NODE) do
    Node := Node.NextSibling;
  Result := Node;
end;
```

Puis remplacement mécanique de **136 parcours** (`X := Y.FirstChild;` → `X := XmlElement(Y.FirstChild);`
et l'équivalent pour `NextSibling`), à tous les niveaux d'imbrication. Sur des données valides ça ne
change rien : un élément traverse la fonction intact.

⚠️ **Piège du remplacement automatique** : il a aussi frappé le corps de `XmlElement` elle-même, qui
s'appelait donc récursivement. Attrapé à la relecture avant envoi — un remplacement mécanique se
relit, on ne fait pas confiance au compteur.

**Résultat** : commenter un fichier de données est devenu inoffensif, partout. Confirmé par Nono.

**Restent ouverts, notés dans `A FAIRE.txt`** : `FindNode` ne renvoie que le premier bloc d'un nom
donné (un second `DATA_LABEL` est silencieusement ignoré — c'est ce qui a fait marcher le dépannage),
et il n'y a toujours pas de garde par **nom** de balise (un `<Foo>` égaré serait traité comme une
entrée valide ; beaucoup moins probable, et les boucles internes filtrent déjà par
`case Node.NodeName of`).

**Leçon de méthode, pour moi** : après avoir envoyé un fichier chez Nono, recharger ma copie avant de
le retoucher. Deuxième fois dans la journée qu'une copie périmée cause un dégât — la première était
le script de vérification qui sauvait son état de référence après la modification.


---

### 2.17 Les fonctions `Cherche*` renvoyaient le résultat précédent — terminé (22/08/2026)

**Le défaut.** Une fonction Pascal qui renvoie un `record` **n'initialise pas son `Result`**. Sur les
17 fonctions `Cherche*` du projet, **13 n'affectaient `Result` que dans la branche « trouvé »** :
quand elles ne trouvaient rien, elles rendaient le contenu de l'appel précédent.

**Comment ça s'est vu.** `AfficheChoixCreation` fait, pour chaque ligne :

```pascal
PTalent := ChercheTalent(ListeChoixCreation[Ind].CodeSource);
Lib     := PTalent.Libelle;
if Lib = '' then
  Lib := LibelleChoixMultiple(ListeChoixCreation[Ind].CodeSource);
```

Le code source d'une ligne de choix est `T0149/T0074/...`, pas un talent déclaré. Échec → `Result`
inchangé. Plus bas dans la même boucle, `ChercheTalent` est rappelée avec le talent *choisi*, trouvé,
et `PTalent` contient alors ce talent. Au tour suivant, l'échec rend **ce** contenu : `Lib` n'est pas
vide, `LibelleChoixMultiple` n'est jamais appelé, et **la ligne suivante affiche le talent qu'on vient
de choisir**. Même mécanisme pour le « Discrétion (Rurale) » affiché deux fois la veille.

**Le correctif** — une ligne en tête de chacune des 13 :

```pascal
Result := Default(StructureTalent);
```

`ChercheArmeBonus`, `ChercheArmureBonus`, `ChercheArmureSimplifiee`, `ChercheAttribut`,
`ChercheCompetence`, `ChercheCorruptionTable`, `ChercheFabrication`, `ChercheLivre`,
`ChercheLivreLibelle`, `ChercheRaceAttribut`, `ChercheSort`, `ChercheTalent`, `ChercheTexte`.
Les 4 déjà correctes (`ChercheRace`, `ChercheEspece`, `ChercheMetier`, `ChercheRegle`) — les 4
écrites récemment — n'ont pas été touchées.

⚠️ **Mon remplacement automatique a posé 4 des 13 lignes dans la mauvaise fonction**, dans une
fonction voisine renvoyant une chaîne : ça n'aurait pas compilé. Attrapé en relisant chaque fonction
une par une. C'est la **deuxième fois dans la même journée** (voir §2.16) qu'un remplacement mécanique
dérape — la leçon écrite le matin n'a pas suffi, il faut relire, pas se fier au compteur.

**Conséquence à garder en tête** : plusieurs endroits contournaient ce défaut, notamment le test
`RechercheTrouve` ajouté dans `GetTexteLibelle` (§2.13). Ces contournements deviennent redondants mais
restent corrects — inutile de les retirer.

---

### 2.18 L'accès aux sorts sort du code et passe en données — terminé (23/08/2026)

**Le point de départ.** En inventoriant ce que les livres pourraient encore apporter, la question
« est-ce qu'ajouter *High Magic* demande du code ? » a montré que oui — et Nono a tranché :
*« oui, je pense qu'il faut redéfinir les fondations (une fois de plus...) »*.

**Ce qui était en dur.** `winpersonnage.pas` reconnaissait les talents magiques en testant les
**5 premiers caractères** du code contre quatre constantes (`TalentSortXxx`), à cinq endroits
(lignes ~1097, 1106, 1108, 1232, 1243). Autrement dit : la liste des talents qui donnent des sorts,
et la façon dont ils les donnent, vivaient dans le programme. Ajouter un talent magique = recompiler.

Nono a précisé la règle du jeu, qui est ce qui rend le modèle possible : *« les sorts de bénédiction
sont acquis à la sélection du talent et ils dépendent du dieu. Il n'est pas possible d'en acquérir de
nouveaux. »* Il y a donc **deux comportements**, pas un continuum : le talent donne ses sorts
automatiquement, ou il ouvre un choix.

**Le modèle retenu** — deux balises sur `<Talent>` (et sur `<Specialization>`, qui hérite du talent
générique quand elle ne les porte pas) :

| balise | valeurs | sens |
|---|---|---|
| `<Magic>` | entier | niveau/domaine de magie apporté |
| `<SpellMode>` | `AUTO` / `CHOICE` / `NONE` | sorts donnés d'office, ou choisis, ou aucun |

Constantes ajoutées dans `chargeconstantes.pas` : `ConstXmlMagie`, `ConstXmlModeSort`,
`ConstModeSortAuto`, `ConstModeSortChoix`, `ConstModeSortAucun`. Champs `Magie: Integer` et
`ModeSort: String` sur `StructureTalent`. Lecture/RAZ/export faits dans `xmlexportimport.pas`.
Repli du générique vers la spécialisation dans `ChercheTalent` :

```pascal
if Result.Magie = 0 then
  Result.Magie    := PTalent.Magie;
if Result.ModeSort = '' then
  Result.ModeSort := PTalent.ModeSort;
```

Données saisies dans les deux Rulebooks sur `T0012_*` (Bless), `T0080_*`, `T0088_*`, `T0089`.

**État — étapes 1 et 2 faites (23/08/2026), validées par Nono.** Les quatre constantes
`TalentSortXxx` **n'existent plus**. Trois constantes génériques les remplacent :
`ConstMagieAucune = 0`, `ConstMagieExclusive = 1`, `ConstMagieCumulable = 2`.

Correspondance des données, vérifiée avant de coder :

| talent | `<Magic>` | `<SpellMode>` | ancienne constante |
|---|---|---|---|
| `T0012_*` Bénédiction | 0 | `AUTO` | `TalentSortBenediction` |
| `T0080_*` Miracle | 2 | `CHOICE` | `TalentSortMiracle` |
| `T0088_*` Domaine | 1 | `NONE` | `TalentSortDomaine` |
| `T0089` Magie Mineure | 2 | `NONE` | `TalentSortMagieMineure` |

Trois fichiers touchés, et **les deux derniers n'étaient pas prévus** :

1. `winpersonnage.pas` — `ButtonSortClick` (les deux tests cumulables **fusionnent en un seul**) et
   `SortAffiche`.
2. `winfiltre.pas` — **site oublié à ma première recherche** (voir l'avertissement ci-dessous).
3. `winspell.pas` — le filtre lui-même (voir plus bas).

⚠️ **Ma vérification « tous les appels » était incomplète, et c'est la leçon du jour.** Mon `grep`
portait sur les **71** `.pas` présents dans ma copie de travail, alors que `WarhammerHelp.lpi` en
déclare **84**. `winfiltre.pas` n'y était pas. J'ai donc supprimé des constantes sans avoir tout le
code sous les yeux. **Le bon réflexe : lister les unités du `.lpi` et comparer à ce qu'on a**, avant
tout `grep` censé être exhaustif. Les 13 unités manquantes ont été récupérées ; le relevé refait sur
les 84 ne laisse plus aucune référence.

**Le filtre de `winfiltre.pas` était mort depuis les préfixes de livre.** Il reconnaissait les talents
magiques par `copy(PTalent.CodeTalent,1,5)` — or les **805** `<Talent id=...>` des 17 livres sont tous
préfixés, donc ce `copy` vaut `'RULES'`, jamais `'T0012'` : en mode « sorts seuls » la liste était
**vide**. Reconstruit en deux temps — relever d'abord les *familles* concernées (`<Magic>`/`<SpellMode>`
ne sont déclarés que sur l'entrée générique, alors que la liste affichée contient les spécialisations),
puis tester l'appartenance ; passer par `ChercheTalent` ligne à ligne ferait 800 × 800 comparaisons à
l'ouverture.

🐛 **Le filtre de `winspell.pas` : Kuno se voyait offrir les sorts arcaniques.** Même famille de défaut,
déclenchée par un autre chemin :

```pascal
if pos(ValeurGenerique, PSort.ListeTalent) <> 0 then
  ValT := copy(ValT, 1, 5);          // 'RULES-T0088_*'  ->  'RULES'
```

`'RULES'` étant contenu dans **tous** les codes préfixés, `Pos(ValT, SelectWinSort)` réussissait
toujours et tout sort à talent générique passait. **Ce n'est pas la suppression des constantes qui l'a
déclenché** — `winspell.pas` ne les a jamais utilisées. Le déclencheur est la normalisation §2.19 :
la fiche de Kuno est passée de `T0080_SIGMAR` à `RULES-T0080_SIGMAR`, et `Pos('RULES', ' T0080_SIGMAR')`
valait 0 (rejet correct, **par chance**) là où `Pos('RULES', ' RULES-T0080_SIGMAR')` vaut 2. Diagnostic
établi en comparant deux sauvegardes réelles de Kuno, pas de mémoire.

Remplacé par `SortTalentAccessible`, qui compare vraiment les familles. **Point à retenir** :
`CompareRechercheValeur` **ne sait pas gérer le `_*`** — `VerifieRecherche` compare les codes à
l'identique et ne lève que le préfixe de livre ; la généricité est traitée à part, par le repli
explicite de `ChercheTalent`. Le test dupliqué (écrit **deux fois à l'identique**) a disparu.

**Étape 3 — faite et validée le 23/08/2026 : la Magie du Chaos, en données seules.**

⚠️ D'abord une erreur à ne pas refaire : j'avais proposé *High Magic* comme sujet de test. **Elle
n'existe nulle part** — ni dans les 17 XML, ni dans les quatre PDF (Rulebook, Lustria, Sea of Claws,
Up in Arms). Je l'avais tirée de ma connaissance générale de Warhammer, pas des données de Nono.
**Règle** : un ajout de contenu se vérifie dans les livres *avant* d'être proposé.

Le bon sujet a été trouvé en retournant la question — auditer les **658 sorts** des 17 livres en
demandant « ce sort est-il atteignable par un talent déclaré magique ? ». Six ne l'étaient pas :

```
RULES-CHAOS_01  RULES-T0172_NURGLE     Stream of Corruption
RULES-CHAOS_02  RULES-T0172_SLAANESH   Consent
RULES-CHAOS_03  RULES-T0172_TZEENTCH   Betrayal of Tzeentch      (× 2 langues)
```

`RULES-T0172_*` est la **Magie du Chaos**, saisie de longue date avec ses trois spécialisations et ses
trois sorts, mais absente des quatre constantes : **ces sorts étaient inaccessibles depuis toujours**,
sans que rien ne le signale. Tout le reste était déjà là — `TypeSortChaos = 'Chaos Magic'`, la règle
des 100 XP dans `XpSortCout`, les gardes de suppression d'équipement. Il ne manquait que la
déclaration :

```xml
<Talent id="RULES-T0172_*">
<Magic>"1"</Magic>
<SpellMode>"NONE"</SpellMode>
```

Deux balises, dans les deux Rulebooks, **zéro ligne de Pascal, pas de recompilation**. Profil du
Domaine arcanique : exclusif (cohérent avec « vous ne pouvez connaître qu'un seul Savoir de Magie
chaotique ») et sorts choisis au catalogue. Confirmé par Nono : *Flot de Corruption* est proposé.

Nouvel audit : **0 sort inaccessible sur 658**. Familles magiques déclarées : `T0012`, `T0080`,
`T0088`, `T0089`, `T0172`.

**Cet audit est réutilisable** et vaut mieux qu'une relecture : croiser les `<Talent>` cités par les
`<Sort>` avec les talents portant `<Magic>`/`<SpellMode>`. À relancer après chaque ajout de livre — il
détecte le contenu saisi mais injoignable, qui ne provoque aucune erreur et ne se voit donc jamais.

**Correctif attrapé en chemin** (défaut réel, pas lié au modèle) : `SortAffiche` cherchait les sorts
avec le code du talent **générique** au lieu de la spécialisation choisie — d'où « j'ai ajouté *Blessed
by Sigmar*, mais aucun sort n'est ajouté ». Corrigé : la fonction lit
`TabAugmentationTalent.Cells[ColAugmTalSpeSel, ...]` quand cette cellule est renseignée.

**Hors périmètre, volontairement** : l'axe « restriction par espèce » (*Slann et Elfes seulement*).
Aucun précédent dans les données, aucune demande — à ne pas inventer.

---

### 2.19 Nettoyage des codes sans préfixe de livre dans les fiches — en cours (22/08/2026)

**La décision.** Le filtre des sorts de `winspell.pas` échouait sur les fiches anciennes (voir
`A FAIRE.txt`). Deux issues possibles : faire accepter les deux formes au code indéfiniment, ou nettoyer
les données. Nono a choisi la seconde — *« je pense qu'il faudrait plutôt que je nettoie les données des
personnages qui n'ont pas de préfixe, car normalement plus aucune ne devrait avoir ce cas »*, puis
*« oui, autant partir sur des bases saines ^^ »*.

**Le principe.** Une seule fonction, au **point d'écriture unique** de `chargepersonnage.pas` :

```pascal
Function CodeNormalise(Code, Livre: String): String;
  begin
    if Livre <> '' then
      Result := XmlCreeCodeLivre(Livre, Code)
    else
      Result := Code;
  end;
```

Appliquée à **17 endroits**. La règle « on ne normalise **que si** `.Livre <> ''` » est ce qui protège
l'équipement en texte libre et les codes inconnus — et elle n'est fiable que **grâce au correctif
§2.17** : avant lui, un `Cherche*` en échec rendait le livre de l'appel précédent.

Ouvrir puis enregistrer une fiche suffit donc à la migrer.

**Deux vrais bugs trouvés au passage** (mauvaise variable passée) : `chercheMetier` recevait autre chose
que `PersonnageMetier.CodeMetier`, et `PersonnageLivre` autre chose que `PArmureSimplifiee.livre` —
c'était la cause du **livre affiché `[]`** que Nono signalait depuis un moment. Garde ajoutée en plus :
`if Livre = '' then Result := ListeLivre; Exit;`.

⚠️ **Régression que j'ai introduite, et le piège qu'elle a révélé.** Une fois la fiche écrite en
`RULES-ATTR_WS`, les augmentations de caractéristiques ont disparu de `WinPersonnage` : la ligne de codes
de `TabAttribut` est semée par `AttributInit` à partir des constantes `ConstCaracXxx` (`ATTR_WS`, **sans**
préfixe), et le `=` brut ne matchait plus. Mon premier correctif — passer à `CompareRechercheValeur` — n'a
rien changé (*« pas mieux sur Gunther et Kuno »*), pour la raison suivante, qui vaut pour tout le projet :

> **`CompareRechercheValeur` n'est PAS symétrique.** `VerifieRecherche` n'accepte le cas « livre absent »
> que sur le **second** argument (`LivreValeur = ''`). Le code **préfixé doit venir en premier**, le code
> court en second. Inversé, la comparaison renvoie **toujours** `False`, silencieusement.
> C'est la convention de tout le reste du programme : `ChercheTalent` fait
> `CompareRechercheValeur(PTalent.CodeTalent, CodeTalent)`.

Corrigé à `winpersonnage.pas` ligne ~2604, avec le commentaire sur place. Confirmé par Nono.

**Le signe `-` des modificateurs d'attribut — fausse alerte, tranché le 23/08/2026.** J'avais noté le
22/08 que `-ATTR_Ag` était un danger, `SeparateurLivre` valant `'-'`. **Vérification faite dans le code :
c'est faux.** Les deux seuls lecteurs du champ `<Attribut>` — `TalentAttribut` (`winpersonnage.pas`
~3446) et `PdfPersonnageAttribut` (`pdfpersonnage.pas` ~631) — font tous deux :

```pascal
if leftStr(Strings[ind],1) = '-' then Neg := '-' else Neg := '';
Attr := RightStr(Strings[ind], Length(Strings[ind]) - Length(Neg));
```

Le signe est **consommé en position 1, avant tout découpage de livre**. `-RULES-ATTR_Ag` se lit donc
correctement **sans une ligne de Pascal**. Nono avait proposé des marqueurs `[P]`/`[M]` pour lever
l'ambiguïté : écarté d'un commun accord, ça aurait coûté une convention, du code de découpe et une
réécriture des données pour un problème inexistant, au prix de la lisibilité du XML.

Le recensement fait à cette occasion a montré que les **116** balises `<Attribut>` renseignées étaient
**déjà toutes préfixées sauf une** : celle de `RULES-T0BIG`, saisie la veille par moi. Corrigée en
`RULES-ATTR_S;RULES-ATTR_S;RULES-ATTR_T;RULES-ATTR_T;-RULES-ATTR_Ag` dans les deux Rulebooks.

🐛 **Ce que ce recensement a réellement trouvé** : les deux lecteurs ne comparent **pas** de la même
façon. `winpersonnage.pas` utilise `CompareRechercheValeur` (tolérant au préfixe), `pdfpersonnage.pas`
un `=` **strict** contre un code préfixé. Les codes nus de `T0BIG` étaient donc comptés à l'écran et
**silencieusement ignorés dans le PDF** — le préfixage corrige les deux d'un coup, mais la divergence
entre les deux lecteurs reste et resservira.

⚠️ **La vraie limite du modèle, laissée volontairement en l'état** : la quantité est écrite **en dur**
(`StrToIntDef(Neg+'5',0)`) — toujours ±5, d'où la répétition `RULES-ATTR_S;RULES-ATTR_S` pour +10.
Nono : *« vu que les augmentations ne sont que par 5, on peut partir là-dessus »*. À rouvrir seulement
si un livre demande un jour autre chose qu'un multiple de 5 ; la réponse serait alors de porter une
**valeur**, pas un autre marqueur de signe.

**Point de reprise** : migrer les 4 fiches anciennes restantes (**Ernold, Friederich, Harald,
Markus**) en les ouvrant puis en les enregistrant — Kuno l'a été le 23/08. `winspell.pas` est corrigé
(voir §2.18).

---

### 2.20 Libellés anglais, intégrité des références, et revue des livres — en cours (23/08/2026)

**D'où ça vient.** Nono a expliqué la cause racine, et elle explique presque tout ce chantier :
*« j'ai commencé à faire le programme avec le livre français et, majoritairement, j'ai demandé une
traduction (sauf pour les noms de métier que j'ai cherché manuellement dans le livre anglais) »*.
D'où des noms de carrière justes mais des **noms de niveau en aller-retour**, et des libellés
fantaisistes un peu partout : *tank top* pour débardeur, *Minor* pour mineur, *Foresight* pour
voyance, *Fight* pour bagarre.

**Ce qui a été mesuré plutôt que supposé.** Sur les `<Explanation>` anglaises du Rulebook, la
quasi-totalité des descriptions sont des retraductions (19 talents verbatim sur 178, 2 compétences
sur 45, 2 métiers sur 64, 9 sorts sur 200). **Mais** un second contrôle, comparant talent par talent
les NOMBRES et les NOMS DE CARACTÉRISTIQUE du texte saisi à ceux du livre, ne sort que **9 écarts**,
essentiellement des numéros de page. Conclusion retenue : **ne pas réécrire les 455 descriptions**,
le risque d'une ré-extraction depuis un PDF en deux colonnes dépassant le bénéfice. L'effort va aux
**libellés**, courts et visibles partout.

**Méthode validée par Nono, à réutiliser pour chaque famille** : extraire du PDF la liste de
référence, produire une table `saisi -> livre`, **la lui faire relire**, puis appliquer. Et la règle
d'arbitrage qu'il a posée : *« il vaut mieux se baser sur le livre de règle »* — quand le Rulebook se
contredit lui-même, c'est la ligne `Specialisations:` du chapitre des Compétences qui fait autorité,
pas les blocs de carrière.

**Fait le 23/08 :** 173 noms de niveau du Rulebook, 11 coquilles de compétence, familles
**Secret Signs**, **Entertain** (12 libellés, 77 occurrences) et **Perform** (6 libellés).

#### Le motif récurrent : le doublon d'identifiant

Quatre fois dans la même journée, la même forme : la **même** spécialisation déclarée sous deux
identifiants, l'un venant du français, l'autre du livre anglais — avec pour conséquence deux moitiés
de contenu qui ne se voient pas.

| gardé | supprimé | ce que ça cassait |
|---|---|---|
| `RULES-COMPCOMB_BAGAR` | `_BAGARRE` | le Wolf Kin ne voyait aucune arme de bagarre |
| `RULES-COMPDIVERT_VOYAN` | `_FORTUNETELLING` | Mystic et Astromancer séparés |
| `RULES-COMPDIVERT_INTERP` | `_ACTING` | Rulebook d'un côté, WoM/EiS de l'autre |
| `RULES-COMPSAVOIR_EMPIRE`, `_NECROMANCY`, `_DARKTOUNGE` | doublons exacts | le programme n'en voyait qu'un |

**Règle de fusion appliquée** : garder l'identifiant qui porte les **armes** et le gros des métiers
(l'historique), reprendre le **libellé** de l'autre s'il est celui du livre. Et **toujours vérifier
`SAVED_CARACTERS`** avant : aucune fiche n'utilisait les codes supprimés.

#### Deux audits réutilisables, avec leur piège

1. **Compétences déclarées / référencées.** 300 déclarations, plus aucune référence orpheline.
   ⚠️ **Piège** : une compétence n'est pas référencée que par un attribut `name=`, elle l'est aussi
   par le **texte** d'un élément — `<Skill>"RULES-COMPCOMB_ENTRA"</Skill>` dans `DATA_WEAPON`. Une
   passe ignorant ce canal sortait 60 orphelines au lieu de 35.
2. **Références cassées.** Quatre corrigées (`FOCAL_AZYR`→`FOCAL_CIEUX`, `FOCAL_CHAMON`→`FOCAL_METAL`,
   `FOCAL_KHAINE`→`FOCAL_KHAINITE`, `COMPPROj_POUDRE` avec un J minuscule). Deux compétences créées
   (`Ride (Badger)`, `Secret Signs (Amber Order)`), une redirection (`RULES-BEGGING`→`RULES-COMPCHARM`,
   le livre écrivant *« Tests: Charm (Begging) »*). Il reste **une** référence d'équipement non
   résolue : `RULES-PROJ_LANC` dans une carrière du Rulebook.

#### Revue des livres — méthode et état

Nono a demandé une revue livre par livre, *« les informations ne sont pas toujours facilement
accessibles »*. Recherche web faite : **aucun index public fiable** de ce que chaque livre ajoute
(les fiches des modules Foundry VTT donnent des compteurs bruts, utilisables seulement comme alarme
de couverture). La revue se fait donc **dans les PDF**, qui sont la source d'autorité.

**Outil mis au point pour ça** (à refaire à l'identique pour les autres livres) : extraction depuis
le PDF des schémas de progression — nom de niveau, Skills, Talents, Trappings par niveau — puis diff
automatique contre le XML avec les libellés résolus à travers tous les livres.

**Up in Arms : terminé.** Les 15 carrières, les 11 tables d'armes, les 12 talents de l'appendice III,
les 4 qualités et les 9 miracles sont complets. Seize écarts de carrière corrigés (dont trois
**interversions de talents entre niveaux voisins**, que seul le diff automatique pouvait voir), trois
`Spear` rendues à la `Lance`, et l'armure de plates rendue uniforme sur les quatre carrières
concernées. Décision de Nono : **l'artillerie du chapitre XI n'est pas saisie** — un personnage ne se
déplace pas avec une pièce de siège ; conséquence assumée, `Crewed` et `Salvo` restent non déclarées.

🐛 **Bug signalé, non corrigé, à confirmer par Nono.** Le suffixe de qualité `(Q)` s'écrit de deux
façons dans `DATABASE` : **40** items le collent au code (`RULES-ARMO_14(Q)`), **42** mettent un
**espace** avant (`RULES-COMB_2M_05 (Q)`). Or `winlivre.pas` `LibelleEquipement` retire les 3 derniers
caractères sans `Trim`, `pdfmetier.pas` et `xmlexportimport.pas` coupent avec `ExtractStringBefore`, et
`CompareRechercheValeur` ne trime pas non plus. Pour les 42 items à espace, la recherche d'arme doit
donc échouer et afficher le **code brut**. Test : ouvrir le **Greatsword Sergeant** dans WinLivre — s'il
montre `RULES-COMB_2M_05 de qualité` au lieu de `Zweihänder de qualité`, c'est confirmé. Corrigeable
des deux côtés (un `Trim` dans le code, ou normaliser les 42 items).

#### Ce qui a été fait en fin de séance du 23/08

Le correctif `(Q)` est **confirmé** (WinMetier affiche « (W) Zweihänder de qualité »), donc la
compilation passe. Les familles **Entertain**, **Perform**, **Lore** et **Trade** sont alignées ;
la **rétro-ingénierie** des libellés obscurs est appliquée (12 libellés) ; les deux carrières des
compagnons sont corrigées ; la famille `RULES-T0088_*` est passée à **Arcane Magic**.

**Sept doublons d'identifiant** ont été trouvés et fusionnés au total : `COMB_BAGAR`/`BAGARRE`,
`DIVERT_VOYAN`/`FORTUNETELLING`, `DIVERT_INTERP`/`ACTING`, `SAVOIR_LOCAL`/`REG`,
`SAVOIR_MEDICINE`/`REMED`, `T0088_TZEENTCH` (déclaré deux fois), plus les trois identifiants de
compétence déclarés en double. **Règle de fusion** : garder celui qui porte le contenu, reprendre
le libellé du livre — et **toujours lister les carrières qui utilisent le code, jamais se fier à un
compteur** (une division par deux erronée m'a fait supprimer à tort `METIER_POIS`, rétabli depuis).

**Point de reprise, par ordre de rentabilité :**
1. les deux dernières familles : **Melee** (`Two hands`→`Two-Handed`, `Scourge`→`Flail`) et
   **Ranged** (`Hindrances`→`Entangling`, `Slingshot`→`Sling`, `Black Powder`→`Blackpowder`) ;
2. la convention **`Bless`/`Invoke`** — les livres écrivent `Bless (Sigmar)`, la base
   `Blessed of Sigmar (Empire)`. Décision de Nono ; s'il garde sa version, ce sont les **génériques**
   qu'il faut aligner, pas les 23 spécialisations. Dans tous les cas, `Beni of Manann` et
   `Beni of Rhya` sont du français resté en anglais ;
3. arbitrer `RULES-COMPCOMB_ENTRA` « Melee (Hinder) » contre `RULES-COMPPROJ_ENTRAV` : vérifié dans
   le Rulebook, *Entangling* est une spécialisation de **Ranged**, et le Pit Fighter reçoit
   « Ranged (Entangling) » avec « Net or Whip » — `COMB_ENTRA` est donc un doublon dans la mauvaise
   famille, et les armes Whip/Lasso sont mal classées ;
4. le **ménage d'`A FAIRE.txt`**, qui contient des lignes périmées (Archives III « sans DATA_SPELL »
   alors que 27 sorts y ont été ajoutés, table de tirage de Middenheim déjà réécrite) ;
5. la **revue livre par livre**, sur le modèle d'Up in Arms — seul livre revu à ce jour. Le balayage
   de couverture désigne **Sea of Claws** (15 armes non saisies), **Archives III** (20) et
   **Naggaroth** (sa sorcellerie) comme les plus rentables. ⚠️ Ce balayage compte des motifs de mise
   en page, pas du sens : il dit **où regarder**, jamais « il manque ». Il m'a fait annoncer à tort
   une carrière manquante dans Archives III — c'était le *Power Familiar*, un familier.

#### Les familiers, à trancher

Winds of Magic ne donne que **deux** schémas de progression : « The Combat Familiar can only follow
the Combat Familiar Career, and the Spell Familiar can only follow the Spell Familiar career », et
« Power Familiars use the advance scheme for Spell Familiars but cannot learn spells ». Or la base a
un troisième métier, `WINDS-WORK104`, dont les quatre niveaux (*Newly Powered, Power Familar, Power
Imp, Powerdling*) **n'existent dans aucun livre**. À supprimer au profit de `WINDS-WORK103`, en
logeant les trois particularités du livre (talent *Magical Assistant* au départ, interdiction de
`Channelling` et `Language (Magick)`, interdiction de `Petty Magic` et `Arcane Magic`).
En revanche **Archives III apporte une vraie troisième voie**, celle du familier animal —
*Newly Bonded → Animal Familiar → Spirit Companion → Witchling* — qui, elle, manque.

#### 🔧 Vérification de masse des libellés — outillée, chantier ouvert

**Cause racine révélée par Nono le 23/08** : le texte des PDF était extrait par un programme
travaillant **sur les images**, donc de l'OCR. Deux causes se superposaient donc depuis le début —
la retraduction depuis le français **et** l'OCR (`Tronfist`, `60-sccond`, `Newly Crafter`,
`Throwing kKnife`, `Betrayal of 'Tzeentch`). `LIVRES/` contient désormais la vraie couche texte.

**Méthode** : normaliser apostrophes et espaces, chercher chaque libellé anglais dans le corpus des
14 livres réunis, sortir ce qui ne s'y trouve **nulle part**. Mesure du 23/08 : **0** nom de niveau
de carrière sur ~450 (cette partie est saine), 14 armes sur 183, 43 compétences sur 271, 106 talents
sur 382, 113 sorts sur 478, 24 armures sur 41 — ces dernières étant surtout les `(A3)` et
`Lustrian ...`, conventions volontaires. Faux positifs à filtrer d'entrée. Détail dans `A FAIRE.txt`.

📄 **Les livres vivent dans `LIVRES/`** — les PDF *et* leur extraction en texte brut
(`pdftotext -layout`, mise en page conservée), les 16 livres de `DATABASE` plus *The Horned Rat*.
⚠️ **`PDF_TEXTE/` n'est pas l'ancien nom de `LIVRES/`** — corrigé le 03/09/2026, la phrase
d'origine le laissait croire. Les deux dossiers coexistent avec des rôles différents :
`LIVRES/` = les 17 livres **modélisés**, PDF *et* texte ; `PDF_TEXTE/` = l'export texte de
**tout** le corpus déposé le 29/08, ~200 fichiers et 40 Mo, sous-dossiers compris (Aventures,
Enemy Within and Companions, Fan, Fan Made, LIVRS PDF, Other help, Ubersreik) — texte seul, pas
de PDF. C'est `PDF_TEXTE/` qu'on interroge pour savoir si une donnée existe quelque part.
Les PDF d'origine, eux, vivent hors du dépôt, sous
`C:\Users\arnau\Documents\Famille\Nono\JDR\Warhammer 4\Livres\4th Edition\` (chemin lu dans
`PDF_TEXTE\conversion.log`) et ce dossier **n'est pas partagé avec la session** : tout se fait
sur les TXT, et quand l'extraction est ambiguë on le dit au lieu de trancher seul. **Il est exclu de git** (`LIVRES/` dans `.gitignore`) : ce sont des livres sous droits,
et ils n'ont jamais été commités — vérifié avec Nono, donc pas de `git rm --cached` à faire ni
d'historique à réécrire.

Le texte est la source de référence pour toute vérification : il se lit instantanément, là où un PDF
de 100 Mo doit être retransféré, et à 147 Mo ne passe même plus. À regénérer avec
`pdftotext -layout "LIVRES\<livre>.pdf" "LIVRES\<livre>.txt"` quand un livre est ajouté.
Les **13** livres y sont, The Horned Rat compris : Nono l'a converti lui-même le 23/08 (874 Ko de
texte contre 147 Mo de PDF qui ne passait pas). ⚠️ Sous **PowerShell**, une commande qui commence par
un chemin entre guillemets a besoin de l'opérateur d'appel `&` devant, et la continuation de ligne
est l'accent grave, pas `^`.

Lecture faite : **The Horned Rat est le volume de campagne et ne contient aucune carrière jouable** —
l'Ironbreaker vient du *Horned Rat Companion*, que Nono a déposé dans la foulée. Vérifié : la carrière
y est **complète et juste**, niveau par niveau, et son « 3 Cinderblast Bombs » confirme que l'objet est
son propre projectile. **L'audit des munitions n'a donc plus aucun angle mort.**

✅ **Le correctif du suffixe `(Q)` est APPLIQUÉ et confirmé** (23/08/2026). Nono a vérifié dans
WinMetier : « (W) Zweihänder de qualité » au lieu du code brut. Huit sites, tous le même geste, aucun
changement de signature — `ExtractStringBefore` renvoyant la chaîne entière quand le séparateur est
absent, le `Trim()` est inoffensif là où il n'y a pas de `(Q)` :

```
winlivre.pas               ~1171  CodeItem   := Trim(Copy(CodeItem, 1, ...));        <- commencer ici
chargemetierequipement.pas ~57    Code       := Trim(copy(stringsI[IndL], 1, ...));
winmetier.pas              ~701   Code       := Trim(copy(stringsI[IndL], 1, ...));
winmetier.pas              ~739   Code       := Trim(copy(PMetierEquipement.Equipement, 1, ...));
winmetier.pas              ~760   Code       := Trim(copy(PMetierEquipement.Equipement, 1, ...));
pdfmetier.pas              ~410   Equipement := Trim(ExtractStringBefore(LigneEquip, EquipementQualite));
pdfmetier.pas              ~491   Equipement := Trim(ExtractStringBefore(LigneEquip, EquipementQualite));
xmlexportimport.pas        ~595   Equipement := Trim(ExtractStringBefore(LigneEquip, EquipementQualite));
```

**La table de rétro-ingénierie des libellés obscurs est complète et sans zone d'ombre** (voir
`A FAIRE.txt`) : elle attend seulement une relecture de Nono avant application. Méthode à réutiliser
telle quelle : chercher **quelles carrières** utilisent un libellé douteux, puis lire le bloc de cette
carrière dans le texte du livre — le libellé exact s'y lit sans rien deviner. Elle a livré
`Lore (Region)`→`Lore (Local)` (avec un **cinquième doublon d'identifiant** à la clé),
`Lore (Waterways)`→`Riverways`, `Lore (Know how)`→`Etiquette` (l'identifiant `SAVVIV` disait déjà
« savoir-vivre »), `Trade (trinkets)`→`Charms`, `Trade (Handyman)`→`Tinker`, et sept autres.

---

### 2.21 Icônes de niveau propres à un livre — terminé (30/08/2026)

*High Elf Player's Guide* n'utilise pas les icônes de niveau du livre de base : son schéma
d'avance emploie des glyphes elfiques colorés, un par niveau. D'où un mécanisme général —
n'importe quel livre peut désormais fournir son propre jeu d'icônes.

**Données.** Une balise optionnelle `<PictureLevel>` portant un **nom de dossier** sous
`\PICTURES\` (jamais un chemin), déclarable à trois endroits : sur le **métier**
(`<Career>`), sur l'**ethnie** (`<Specie>`) et sur la **race** (`<Race>`). Écrite à l'export
seulement si elle s'écarte du défaut, comme `Skill3`/`Skill5`. Absente = dossier `NIV`.

**Ordre de résolution : métier → ethnie → race → générique.** La raison du premier rang du
métier est de Nono et vaut d'être retenue : *un métier ne déclare un dossier que s'il vient
d'un livre, et il n'existe que si ce livre est chargé — sa déclaration prouve donc que le
supplément est actif*, ce que l'ethnie seule ne dit pas.

**Code.** `CheminNiveauDossier(Dossier, Niveau)` dans `ChargeRace` fabrique le chemin et
porte les deux replis (dossier vide, fichier absent). Au-dessus :
`CheminNiveauImage(CodeRace, Niveau)` (ethnie→race), `CheminNiveauImageMetier` et
`CheminNiveauImageMetierRace` dans `ChargeMetier`. Chaque fenêtre a une
`ChargeImagesNiveau()` qui vide et recharge sa `TImageList`, appelée dès que le métier ou
l'ethnie est connu — **et jamais avant**, l'ordre des affectations comptant.

**Trois pièges rencontrés, tous du même genre : plusieurs chemins de dessin en parallèle.**
1. `WinRaces` charge une `ColorList` qui ne sert à rien : son test `Node.Text[1] in
   ['1'..'4']` est toujours faux, aucun texte de nœud n'y commence par un chiffre.
2. Dans `WinMetier`, l'arbre passe par `ListImage` mais la **bande de caractéristiques**
   rechargeait le fichier en dur à chaque dessin (l.430) — d'où des glyphes d'un côté et
   des icônes génériques de l'autre. Trouvé par Nono à l'écran.
3. `WinCreation` ne déclarait **ni `ListImage` ni `Path`** : non déclarés, ils se
   résolvaient sur les globales de `WinRaces` (dernière unité de sa clause `uses` à les
   déclarer), si bien qu'elle remplissait la liste d'images d'une autre fenêtre. Sans
   conséquence tant que tout le monde chargeait les mêmes icônes ; faux dès que les icônes
   dépendent du livre. Corrigé par deux déclarations.

**Validé par Nono le 30/08** sur les trois cas qui couvrent la matrice :
ethnie du livre → icônes du livre ; Haut Elfe de base + métier du livre → icônes du livre ;
Haut Elfe de base + métier de base → icônes d'origine.

**Reste hors périmètre** : `pdfmetier.pas` (l.92, 250, 285) charge encore en dur. Les icônes
de **classe** (`winmetier` l.835, `pdfmetier` l.179) ne sont pas concernées.

### 2.22 Substitution du paramètre dans les champs `<Test>` — conception arrêtée, non appliquée (26/08/2026)

Gardée ici et non dans `A FAIRE.txt` : le chantier a été **clos sans modification**, le champ
`<Test>` d'une spécialisation n'étant jamais affiché (`wintalent.pas` ne remplit sa grille que
pour `PTalent.SousTalent = false`, et sélectionner une spécialisation bascule l'affichage sur
son générique). Le design est validé par Nono et attend le jour où l'on voudrait afficher le
test par spécialisation.

La parenthèse ne suffit pas comme repère — quatre familles ont leur paramètre en pleine phrase,
et `Craftsman` a une parenthèse qu'il ne faut **pas** toucher. Marqueur retenu : `*`, placé
n'importe où dans le texte du test.

```
Etiquette     Charm and Gossip (*)
Acute Sense   Perception (*)
Savant        Lore (*)
Hatred/Vice   Willpower (Resist *)
Strider       Athletics Tests to traverse the *
Fearless      Cool to oppose your *'s Intimidate, Fear, and Terror
Resistance    All those to resist the associated *
Craftsman     Trade (any one)   <- inchangé, pas de marqueur = pas de substitution
```

Le programme remplacerait `*` par la parenthèse du libellé de la spécialisation, et par « Any »
pour le générique ; l'absence de marqueur vaut « ne rien faire ». Nono a écarté l'alternative
d'un attribut séparé (`<Test parametre="Social Group">`), trop lourde.

### 2.23 Le nombre de niveaux se calcule depuis la donnée — terminé (31/08/2026)

Les carrières du livre de base ont toutes 4 niveaux, et ce 4 était écrit en dur à six
endroits. *High Elf Player's Guide* apporte un Mage à 5 niveaux. Plutôt que d'élargir à 6 —
ce qu'il aurait fallu refaire au premier livre à 6 niveaux — **le maximum se calcule
maintenant depuis la donnée** (proposition de Nono).

**Deux fonctions dans `chargemetierniveau.pas`** :
- `MaxNiveauMetier()` — le niveau le plus haut de `ListMetierNiveau`, **plancher à 4**
  (valeur historique du livre de base : un chargement partiel ne doit pas rétrécir
  l'affichage sous ce qui a toujours existé).
- `MaxIndiceIconeNiveau()` — le plus grand entre le précédent et **le plus haut fichier
  `N.PNG` présent dans `PICTURES\NIV\`**. Cette seconde borne existe parce que ce dossier
  ne contient pas que des niveaux (voir plus bas). La boucle ne s'arrête pas au premier
  trou.

**Fait et compilé** : les quatre fenêtres (`winraces`, `winmetier`, `winpersonnage`,
`wincreation`) dimensionnent listes d'images et `ColorList` sur `MaxIndiceIconeNiveau()`,
`TabNiveau.RowCount` sur `MaxNiveauMetier() + 1`, et leur chargeur d'icônes **tolère un
fichier absent** — il ajoute alors une image neutre de 8×8 plutôt que de sauter l'entrée,
sans quoi les index de `ListImage` se décaleraient d'un cran. La lecture du numéro de niveau
ne prend plus le premier caractère du texte du nœud (`"10.Archmage"` commence par `'1'`)
mais ce qui précède le point, avec les bornes tirées de `High(ColorList)`.

**Piège découvert en chemin, et corrigé** : `PICTURES\NIV\` sert à deux choses. Les
fichiers 5, 6 et 7 y sont des **pastilles de couleur** — rouge, vert, gris — utilisées comme
indices d'image par les tableaux des onglets Attribut, Talent, Compétence et Avancement de
`WinPersonnage`, et nommées dans `chargeconstantes.pas` (`CouleurNot`, `CouleurOk`,
`CouleurKo`, avec les `CouleurFond*` en regard). Couper le chargement au dernier niveau les
faisait disparaître.

**Pastilles déplacées à 20, 21 et 22 le 31/08/2026**, testé par Nono : la collision avec le
niveau 5 du Mage est levée. `5.png`, `6.png` et `7.png` restent physiquement dans le dossier
et ne servent plus — Nono doit les supprimer, ou remplacer `5.png` par une vraie icône de
niveau 5.

**`pdfmetier.pas` fait le 31/08**, validé par Nono (PDF généré pour une carrière du livre de
base et une carrière elfique) : bornes dimensionnées sur le métier, chemins passant par
`CheminNiveauImageMetier`, tolérance au fichier absent (`PdfImgNv` garde la place avec `-1`,
le rectangle coloré reste tracé), et **géométrie du schéma d'avance rendue variable** —
`For Ind := 0 to NbNiveauMetier + 1`, bas des verticaux à
`270.7 - HautAttribut - ((NbNiveauMetier + 1) * 4.75)`, et
`FinAttribut := 261.15 - HautAttribut - ((NbNiveauMetier - 1) * 4.7)`. Les trois formules
redonnent exactement les valeurs d'origine à 4 niveaux (vérifié numériquement avant
écriture). Le tableau grandit vers le bas et pousse l'image qui le suit, `FinAttribut`
servant déjà d'ancrage.

**La limite des quatre niveaux n'existe plus.** Il ne reste que deux points de confort :
- supprimer `PICTURES\NIV\5.png`, `6.png` et `7.png`, devenus inutiles — **à la main de
  Nono**, la passerelle ne sait pas supprimer ;
- leur remplacer `5.png` par une vraie icône de niveau 5, sans quoi ce niveau s'affichera
  en gris uni via le repli du chargeur tolérant.

**À surveiller à la première carrière à 5 niveaux** : que l'image placée sous le schéma
d'avance ne descende pas trop bas dans la page. Si ça devient serré, l'autre approche est de
garder la hauteur totale constante et de réduire le pas de 4,75.

### 2.24 Carrières avancées : niveau minimum et carrière parente — terminé (31/08/2026)

*High Elf Player's Guide* apporte trois carrières — Smith-priest of Vaul, Storm Weaver,
Loremaster of Hoeth — **qui n'existent qu'à partir du niveau 3**. On ne les commence pas :
on y arrive en montant de niveau depuis le Mage. Conception arrêtée avec Nono le 31/08.

**Une seule donnée nouvelle**, `<Parent>` sur `<Career>` (`ConstXmlMetierParent`, champ
`MetierParent` de `StructureMetier`). Elle contient un code de métier, ou plusieurs séparés
par `SeparateurMulti` — la notation multiple est acceptée dès maintenant même si le livre
n'en a pas besoin, pour ne pas avoir à y revenir.

**Le niveau minimum ne se déclare pas, il se lit.** `ChercheMinMetierNiveau()` dans
`chargemetierniveau.pas`, symétrique de `ChercheMaxMetierNiveau()` : le plus petit
`<Level>` déclaré. Une balise `<MinLevel>` aurait fait doublon, avec le risque classique de
diverger des niveaux réellement présents. Un résultat `> 1` **est** la définition d'une
carrière avancée.

**Les deux vont ensemble** : un parent sans niveau minimum n'aurait aucun effet, un niveau
minimum sans parent rendrait la carrière définitivement inatteignable.

#### Ce qui existait déjà et n'a rien coûté

Le `'X'` de `StructureRaceMetier.Chance` — *« éligible hors tirage »* — fait déjà exactement
ce qu'il fallait : `ChargeTabMetier` l'exclut de la table de d100 de WinCreation, `WinRaces`
l'affiche quand même dans son arbre, `MetierRaceNbSuivant` ne le compte pas. **Aucun blocage
à écrire côté création.**

Mieux : `DATA_SPECIE_CAREER_DIRECT` s'exprime en RACE, et `CompleteRaceMetierParEspece` la
développe en une entrée par ethnie, toujours en `'X'`, **en recopiant le champ `Livre`**
(`PNouveau := PSource`). Une seule entrée `RULES-SPECIE_HELF` par carrière suffit donc pour
les onze ethnies du livre *et* le Haut Elfe du Rulebook — et comme les entrées portent
`HELFG`, `VerifieFiltre` les masque à qui ne charge pas le livre. **Rien ne change pour un
joueur Rulebook seul.**

#### Le blocage manquait ailleurs que prévu

Pas à la création (le `'X'` s'en charge) mais dans **WinPersonnage, sur « Changer de
carrière »** : `ButtonRaceSelectionnerClick` ouvre WinMetier, qui laisse choisir n'importe
quel métier. Le refus y est posé, vide `ChoixWinMetierRace` et retombe ainsi dans l'état
« l'utilisateur a annulé », déjà géré. Message `MESS_057`.

Le test est côté WinPersonnage et **pas** dans WinMetier, qui sert aussi de fenêtre de
consultation : ces carrières doivent rester visibles, seule leur *sélection* est refusée.

#### La bifurcation au passage de niveau

`ComboBoxNvMetier`, posée par Nono sur `TabSheetEvolution` à l'emplacement exact de
`ButtonRaceSelectionner` (Left 8, Top 104, Width 256) — les deux ne servent jamais en même
temps. **Son gestionnaire `ComboBoxNvMetierChange` existait déjà dans le `.pas`, orphelin :
déclaré, implémenté, référencé par aucun contrôle.** Nono avait commencé cette idée à un
moment. Son corps chargeait l'équipement au niveau 1 (il avait été écrit pour le changement
de carrière) ; il charge maintenant le niveau visé.

- `ListeNvMetier(Codes)` construit la liste : **entrée 0 toujours la carrière actuelle**
  (bifurquer reste un choix), puis les enfants dont le niveau minimum vaut exactement le
  niveau visé et que l'ethnie autorise.
- `ChargeComboNvMetier()` remplit, ou laisse caché si moins de deux entrées. Appelée depuis
  les **trois** `RadioButton*Change`.
- Sort toujours sur `ItemIndex = -1` : **aucun choix par défaut** (décision de Nono). La
  validation refuse avec `MESS_058` tant que rien n'est sélectionné.

**Aucun état conservé entre le remplissage et la validation** : `ListeNvMetier` est appelée
deux fois plutôt que de stocker les codes dans un champ du formulaire. L'ordre est
déterministe, donc l'indice désigne le même métier aux deux appels — et rien ne peut se
désynchroniser. Ça évite une variable partagée de plus (voir §4, l'inventaire des globales).

**Le filtre par ethnie est une fonction imbriquée `EthnieAutorise`, pas `VerifieRaceMetier`.**
⚠️ `VerifieRaceMetier(RaceChoisie, MetierActuel, MetierAVerifier)` renvoie **toujours faux**
si `MetierActuel` est vide — sa condition est `(MetierActuel <> '') and (MetierActuel <> ...)`.
Elle répond en fait à « ce métier est-il différent de celui-là ? », pas à « cette ethnie
peut-elle le prendre ? ». Ne pas s'y fier sans la relire.

#### Règles retenues

- **Coût XP** : tarif de continuation, sans surcharge de changement de classe. C'est la même
  carrière qui bifurque.
- **Données** : le personnage bascule entièrement sur la nouvelle carrière, les niveaux 1-2
  du Mage ne comptent plus. Nono : *« je stocke les données du métier en cours, donc c'est ce
  qui va être utilisé »*. Si la règle s'avère fausse un jour, c'est la mise à jour du XML de
  personnage qu'il faudra changer, pas cette mécanique.

#### Erratum du livre, conservé tel quel

Le Smith-priest of Vaul est déclaré pour les Hauts Elfes **et les Elfes Sylvains**, alors que
le Mage n'est proposé qu'aux Hauts Elfes. Le Sylvain ne pourra donc jamais l'atteindre.
Décision de Nono : traduire fidèlement ce que le livre écrit. Le filtre par ethnie règle le
cas tout seul, sans exception dans le code.

#### Éprouvé de bout en bout

Testé par Nono le 31/08/2026 avec les données du lot 2 (§2.25) : un Mage haut-elfe arrivé au
passage de niveau voit bien **les quatre options**, et le choix du Smith-priest of Vaul
aboutit. La mécanique est donc validée sur son seul cas d'usage réel.

### 2.25 High Elf Player's Guide, lot 2 : les quatre lanceurs de sorts — terminé (31/08/2026)

Le Mage (`HELFG-WORK132`, cinq niveaux) et les trois carrières avancées qui en dérivent :
`133` Smith-priest of Vaul, `134` Storm Weaver, `135` Loremaster of Hoeth, niveaux 3 à 5.
Le livre a un encadré « Fifth Level Careers » qui nomme exactement ces quatre-là.

**Sept talents créés**, `HELFG-T0189` à `T0195` : Blessed by Isha, High Magic, Lileath's
Blessing, Mind over Body, Cadai Meditation, Eye of the Storm, Sanctuary of the Mind. Plus la
spécialisation `RULES-T0134_MAGIE` (Savant (Magic)) et deux déclarations combinées. Tout le
reste — 36 compétences, 36 talents — s'est résolu sur la base existante.

#### Comment les bandes d'avance se lisent

Le schéma d'avance est une bande de dix cases, une par attribut, et le contenu de chaque case
est **le numéro du niveau auquel cet attribut devient avançable**, écrit en chiffre elfique.
La couleur double le chiffre et lève toute ambiguïté : **blanc 1, bleu 2, gris 3, jaune 4,
vert 5**. Case vide = jamais. C'est directement la valeur de `<Attribut>` dans
`SUBCHAPTER_ATTR`, où `0` veut dire « jamais ».

Le glyphe qui précède chaque entrée de la *Career Path* donne le niveau de cette entrée : les
trois carrières avancées commencent toutes par le glyphe **gris**, ce qui **prouve** qu'elles
démarrent au niveau 3 — ce n'était pas une déduction.

#### Les compétences de gain se lisent à la police, pas à l'œil

Le livre met la compétence de revenu en *italique* dans la ligne Skills du premier niveau.
`pdfplumber` donne le `fontname` de chaque mot : c'est comme ça qu'elles ont été relevées,
et non en regardant une image. Mage → `Language (Magick)`, Smith-priest → `Trade (Smith)`,
Storm Weaver → `Sail (Any)`, Loremaster → `Research`. Le `(Qhaysh)` des quatre carrières est
aussi en italique, mais c'est le style des spécialisations — présent partout, donc non
discriminant. Méthode à réutiliser pour tout livre à venir.

#### Arbitrages de Nono

- **`Channelling (Any Colour)`** → combiné des **huit** vents de couleur, déclaré avec ce
  libellé. Le générique `RULES-COMPFOCAL_*` aurait été plus court mais faux : il proposerait
  aussi Qhaysh, Dhar, la sorcellerie khainite et la Grande Gueule. ⚠️ **Premier combiné à
  plus de trois membres du corpus.** Vérifié avant écriture que `WinSpecialisation` itère sur
  la liste entière ; c'est le premier endroit à regarder si l'écran de spécialisation se
  comporte mal.
- **Le « Smith »** → `_FORGE` (Blacksmith) pour les trois occurrences : `Trade (Smith)`,
  `Craftsman (Smith)`, `Master Tradesman (Smith)`. Aucun « Trade (Smith) » n'existe dans la
  base.
- **`High Magic` et `Cadai Meditation` n'ont pas de `Max:`** dans le livre — vérifié sur
  l'image des pages 83 et 101, pas seulement sur le texte extrait. Fixé à **1**.
- **`Arcane Magic (Any Arcane Lore)`** → le générique `RULES-T0088_*`.

#### Deux errata du livre, conservés tels quels

- L'entrée `Talent: High Magic` (p.83) commence par une phrase **amputée de son sujet** :
  « *Channelling* (Qhaysh) Skill and *Blessed by Isha* Talent can take this Talent. » Rendu
  de la page à l'appui, ce n'est pas l'extraction. Le sujet manquant a été rétabli dans
  l'`<Explanation>` (« Only those with the… ») parce que la phrase était incompréhensible en
  l'état ; c'est le seul endroit du lot où le texte du livre a été complété.
- Le **Smith-priest of Vaul est annoncé « High Elf, Wood Elf »** (p.100) alors que le Mage,
  son unique parent, n'est ouvert qu'aux Hauts Elfes. Un Sylvain le verra dans WinRaces,
  marqué `X`, sans jamais pouvoir l'atteindre. Décision de Nono : traduire fidèlement la
  contradiction plutôt que de choisir lequel de ses deux côtés est le bon.

#### Corrigé dans la foulée : n'afficher que les niveaux que le métier possède

Les carrières à niveaux 3-5 ont fait sortir un défaut que rien n'avait pu montrer avant, parce
qu'il fallait une carrière ne commençant pas au niveau 1. **Deux endroits parcouraient les
niveaux depuis 1**, et un troisième depuis le maximum *global* :

- `pdfmetier.pas` — le schéma d'avance dessinait deux lignes vides en tête et la colonne de
  droite deux icônes orphelines. `NvMinMetier` introduit ; **`NbNiveauMetier` change de sens**
  et devient un *nombre de lignes* au lieu du numéro du dernier niveau. Les deux se
  confondaient tant que tout commençait à 1, et les trois formules de géométrie du §2.23 s'en
  servaient déjà comme d'un compte — elles n'ont donc pas eu à changer.
- `winpersonnage.pas`, `AfficheImageMetier` — `TabNiveau` était dimensionné **une fois à la
  création de la fenêtre** sur `MaxNiveauMetier()`, le maximum global, et rempli en indexant
  par le numéro de niveau. Lignes désormais **séquentielles**, grille dimensionnée sur le
  métier, et **vidage explicite** qui n'existait nulle part.

⚠️ **Sans risque pour les icônes, et ce n'était pas évident** : `TabDrawCell` lit l'indice
d'image dans le *contenu* de la cellule (colonne 2, le numéro de niveau), pas dans le numéro de
ligne. Si l'indice avait été la ligne, rendre les lignes séquentielles aurait cassé toutes les
pastilles. À revérifier avant toute autre réorganisation de lignes dans ces grilles.

Cette correction rattrape aussi une **régression du §2.23** : depuis que le maximum global était
passé à 5, une carrière du livre de base à quatre niveaux affichait une ligne 5 vide.

### 2.26 High Elf Player's Guide, lot 3 : les 59 sorts — terminé (31/08/2026)

**Le livre est complet.** Six listes : Petty (6), Elven Arcane (8), Lore of High Magic (16),
Vaul (9), Mathlann (10), Hoeth (10).

#### Le `TypSpell` n'est pas un classement, c'est un prix

`XpSortCout` (`winpersonnage.pas`) branche **en dur** sur les six valeurs de l'énumération :
`Blessing` gratuit, `Miracle` 100 × (N−1), `Arcane`/`Domain` 100 × (1 + ⌊(N−1)/BI⌋) **avec
compteur commun**, `Chaos` 100, `Minor` 50 × ⌊(N−1)/BFM⌋. Choisir le type, c'est choisir la
formule — il n'existe aucun autre levier côté données. Arbitrage de Nono : Petty → `Minor
Magic` ; Elven Arcane et High Magic → `Domain Magic` ; sorts à CN 0 des listes de prêtres →
`Blessing` ; les autres → `Miracle`.

#### Les deux balises qui ouvrent le catalogue

⚠️ **Oubliées à la première écriture**, d'où un « You have no spell talent » sur un
Smith-priest ayant pourtant appris High Magic. `HELFG-T0190` porte maintenant :

- `<Magic>"1"` — **exclusif**, comme `Arcane Magic (Any)`. Surtout pas `2` : un cumulable
  n'est regardé que si le personnage n'a **aucun** talent exclusif, donc un Mage — qui porte
  déjà un `Arcane Magic` — n'aurait jamais vu ses sorts de Haute Magie. Le `2` aurait
  fonctionné sur le prêtre et échoué sur le mage, c'est-à-dire à moitié.
- `<SpellMode>"NONE"` — les sorts s'achètent. `AUTO` en aurait accordé **45 d'un coup**.

Vérifié en instrumentant `WinSpell` : 45 lignes proposées à un Smith-priest, filtres vides,
libellés chargés. Les 6 Petty et 8 Elven Arcane sont écartés à juste titre — il n'a ni
`Petty Magic` ni `Arcane Magic`.

#### Ce que le modèle ne peut pas porter, et où c'est allé

Aucun champ n'existe pour les **vents** d'un Elven Arcane, la ligne **Sacrifice** (13 sorts),
les blocs **Overcasting** ni l'état **Yenlui**. Tout cela reste dans l'`<Explanation>`, les
deux premiers **en tête** du texte là où le livre les imprime.

⚠️ **Les Elven Arcane sont un compromis assumé** : le livre exige **les deux** vents,
`SortTalentAccessible` découpe le champ sur la virgule et accepte dès qu'**un** talent
correspond. Il n'y a pas de ET dans le modèle. Les deux vents sont donc nommés dans le texte
pour donner au joueur l'information que la donnée ne peut pas contraindre.

#### Trois pièges de l'extraction, à réutiliser

- **Un titre peut disparaître** : entre *Arcane Unforging* et *Curse of Arrow Attraction*, le
  numéro de page s'était substitué au nom. Le vrai est *Coruscation of Finreir*, retrouvé sur
  l'image de la page.
- **Le pied de page ne peut pas servir de borne** de fin de bloc : il tombe aussi *au milieu*
  d'un sort qui enjambe deux pages. La borne est le titre de section en capitales.
- …avec un cas particulier : la fusion des deux colonnes colle parfois la citation de
  l'encadré voisin **derrière le titre**, sur la même ligne (`LOREMASTER OF HOETH 'There are
  good reasons…'`). Il faut alors ne regarder que la tête de la ligne.

#### Reste du livre

Rien. Les chantiers ouverts qui le touchent encore sont dans `A FAIRE.txt` : le mode de calcul
du coût en donnée du talent, et le sort des 17 `"Ritual"`.

### 2.27 Les images se nomment par le code complet — terminé (31/08/2026)

Les images vivaient dans trois dossiers plats partagés par tous les livres, nommées sur le
code **amputé de son préfixe** (`WORK127.PNG`). Deux livres ne pouvaient donc pas avoir
chacun leur `WORK001`, et **la numérotation continue entre suppléments n'était pas un choix
mais une contrainte imposée par ce nommage** — `HELFG` reprenait à 127 pour cette seule
raison.

**200 fichiers renommés** par `TRAVAIL\renomme_pictures.ps1`, plus trois sites de code qui
construisent désormais le nom sur le code complet : `CheminMetierImage` (`chargemetier`),
`CheminRaceImage` (`chargerace`), `CheminSortImage` (`chargesort`).

#### Le repli qui découple les deux moitiés

Chaque site essaie le code complet, **puis retombe sur l'ancien nom court**. Ce n'est pas de
la prudence gratuite : sans lui, le renommage des fichiers et la modification du code
auraient dû basculer exactement en même temps. Avec lui, on peut compiler avant de renommer,
renommer un dossier sur trois, ou s'arrêter au milieu. ⚠️ **À retirer** le jour où plus
aucune image ne porte de nom court — sinon un oubli de renommage passe inaperçu pour
toujours.

#### Le dossier `SPELL` ne contient pas des sorts

⚠️ Malgré son nom, il porte des images de **TALENTS** — `T0089`, `T0088_FEU`,
`T0080_SIGMAR` — ce qui est cohérent avec `CheminSortImage`, dont le paramètre s'appelle
`CodeTalent`. Première version du script écrite sur les 506 codes de sorts : elle ne
renommait rien, et c'est le décompte de la simulation (174 au lieu de 200) qui l'a révélé.
Les familles génériques `T0088_*` cherchent leur image sous le seul **tronc** `T0088`, que
`CheminSortImage` obtient en coupant au `_`.

#### Deux orphelins trouvés en vérifiant la couverture

- **`T0080_SOLAN.png`** : il manque un **K**, le talent étant `RULES-T0080_SOLKAN`. *Invoke
  (Solkan)* n'avait donc **jamais** affiché son image — pas d'erreur, juste une absence.
  Réparé par le renommage.
- **`T0080_MAW.png`** : aucun talent correspondant, celui de la Grande Gueule étant
  `RULES-T0088_MAW`, dont l'image existe déjà. Laissé en place, à l'appréciation de Nono.

#### Renumérotation : décidée contre

Renuméroter les carrières des suppléments (`HELFG-WORK127` → `HELFG-WORK001`) n'apporte rien
de fonctionnel et **toucherait des identifiants stockés dans les fichiers de personnage**.
Vérifié sur *Gunther Krieg*, le personnage joué : 53 codes, tous `RULES`, donc il n'aurait
rien à subir — mais le bénéfice du chantier est déjà entièrement dans le renommage. Reporté
sine die.

#### Code mort supprimé au passage

La boucle `for Book In ListBook` de `CheminSortImage` : écrite pour un chemin par livre, elle
était devenue inopérante depuis que `warhammersource` l.829-831 écrase les constantes par des
chemins **plats sans `%BOOK%`**. Elle refaisait *N* fois le même test.

### 2.28 Une ethnie sans illustration emprunte celle de sa race — terminé (31/08/2026)

**Quinze ethnies n'ont aucune illustration** (relevé du 31/08) : les onze haut-elfes de *High
Elf Player's Guide*, trois naines (Salzenmund ×2, Sea of Claws) et une humaine (Salzenmunder).
Les trois races concernées ont toutes leur ethnie de référence au Rulebook, donc le repli les
couvre entièrement.

`CheminRaceImage` (`chargerace.pas`) est coupée en deux :

- **`CheminRaceImageSeule(PRace, Indice)`** — le chemin d'**une** ethnie, sans repli, qui
  renvoie **une chaîne vide** si l'image n'existe pas. C'est ce vide qui permet de décider
  s'il faut chercher ailleurs. ⚠️ Changement de contrat : l'ancienne version renvoyait le
  chemin du fichier *normal* même absent. Vérifié avant d'écrire que **les cinq appelants
  testent `FileExists`** — `winraces`, `wincreation`, `winpersonnage`, `winmetier`, `pdfrace`.
- **`CheminRaceImage`** — essaie l'ethnie, puis l'ethnie de référence de sa race.

**Quelle ethnie prête son image** : celle dont le code porte le **même préfixe de livre que la
race**. La race étant déclarée par le livre de base, cela désigne l'ethnie du Rulebook **sans
écrire `"RULES"` en dur**, et continuerait de fonctionner si un supplément définissait sa
propre race. À défaut, la première ethnie de la race qui possède une image.

**L'indice est conservé** : une ethnie qui demande l'illustration 2 reçoit la 2 de sa
référence, pas la 1.

**La règle du livre de base tient** : le repli ne se déclenche que pour une ethnie sans
*aucune* image, ce qui n'est le cas d'aucune ethnie du Rulebook.

Hygiène au passage : le `DecoupeCodeValeur` du repli sur l'ancien nom court est désormais
appelé **juste avant** d'être relu. `CodeValeur` est une globale, et l'ancienne version
s'appuyait sur celle laissée par le `CompareRechercheValeur` de la boucle — ce qui n'aurait
plus tenu dès qu'on traverse deux ethnies.

**Testé par Nono le 31/08/2026**, dans la foulée de l'écriture.

### 2.29 L'armurerie elfique — terminé (01/09/2026). Le livre est intégralement traité.

**13 objets** : les 12 armures de la page 34 (Ithilmar ×6, Dragon ×5, White Lion Hide Cloak)
et le **Greatsword of Hoeth**, qui ferme le trou du sword-dancing — `HELFG-T0187` exigeait
depuis le lot 1 une arme qui n'existait nulle part.

#### Ce que le chapitre contenait, et ce qui a été écarté

Sur la trentaine d'objets du chapitre, seuls 13 étaient modélisables, et c'est le **modèle**
qui a tranché, pas une préférence :

- **Les 7 armes elfiques courantes n'ont pas été écrites.** Ce ne sont pas de nouvelles armes :
  le livre pose une **règle de marché** (p.32) — *« items purchased from Elven markets will
  always have at least one level each of the Durable and Fine Qualities »*. Or `Durable` et
  `Fine` sont des qualités de **fabrication** (`DATA_CRAFTMANSHIP`), que la fenêtre Fabrication
  pose déjà sur l'objet d'un personnage. ⚠️ **Aucun `<Quality>` du corpus ne contient jamais un
  code `QUALITY_`** — vérifié sur tous les fichiers. Les modéliser aurait créé sept doublons ne
  différant que par leur prix.
- **Les 4 herbes, les 6 objets enchantés et les 10 révisions de prix n'ont nulle part où
  aller** : ⚠️ **il n'existe aucun catalogue d'objets**. Ni Lantern, ni Rope, ni Backpack, ni
  Healing Draught dans le Rulebook — seules les armes et les armures ont une table.

#### Les pénalités sont des qualités, pas un champ

`DATA_ARMOR` n'a pas de champ de pénalité : `-10 Perception` est `ARMOB_06` (*Narrow the view*),
`-20 Perception` est `ARMOB_07` (*Blocks the view*), `-10 Stealth` est `ARMOB_05` (*Not
discreet*). Les combinaisons reprises ici sont **exactement celles du Rulebook** — son Helm est
`ARMOB_02,ARMOB_04,ARMOB_05,ARMOB_07`, son Open Helm `ARMOB_03,ARMOB_05,ARMOB_06`.

Les **niveaux** s'écrivent dans le même champ, séparés par une espace : le bouclier du livre de
base porte `WEAPB18 2`.

#### `DISPO_UNIQUE`, un ajout de vocabulaire vérifié avant d'être fait

Le livre marque les 13 objets en *Unique*, disponibilité qui n'existait pas. Contrôlé que
`Disponibilite` ne passe **que** par `GetAllTexteLibelle` et ne fait l'objet d'**aucun
branchement dans le code** — c'est un vocabulaire **ouvert**, contrairement au `TypSpell`.
Le libellé est déclaré dans les deux Rulebook.

#### Noms préfixés

« Ithilmar Breastplate », pas « Breastplate » : le Rulebook a déjà une Breastplate, un Helm et
des Plate Leggings, et WinArmor afficherait sinon plusieurs lignes de même nom. Le contrôle
vérifie qu'aucun libellé ne collisionne avec ceux du livre de base.

#### Erratum du livre

⚠️ **La case AP de l'Ithiltaen Helm est vide** page 34 — vérifié sur l'image, ce n'est pas
l'extraction. Mis à **2**, comme toutes les autres pièces et comme le Helm dont il dérive.
**C'est une déduction, pas une lecture**, signalée en commentaire dans le fichier.

#### Section Sea Elf : déjà faite

L'item du `A FAIRE` était périmé. `HELFG-RACE_SEAEL`, écrit au lot 3, correspond exactement à
la page 57 — les douze compétences, les six talents dont les deux choix combinés et
`HELFG-T0188`. Le reste de la section est du contexte et deux choix laissés au joueur.

### 2.30 Les cinq bugs signalés — corrigés (01/09/2026)

Cinq défauts accumulés et volontairement laissés en l'état à mesure qu'ils étaient trouvés,
traités d'un coup sur décision de Nono. **Aucun n'était une régression** : quatre dataient
d'avant les chantiers de la semaine, le cinquième était mon erreur du lot 1.

1. **`HELFG-T0187`, données.** Le champ `<Test>` portait `"COMPCOMB_2M"`, un code, alors que
   `PTalent.Tests` est de la **prose** affichée telle quelle par `wintalent.pas`. Vérification
   faite en corrigeant : le livre ne donne **aucune** ligne `Tests:` à Sword-dancing (p.68,
   il n'a qu'un `Max: 1`). La valeur était donc fausse deux fois — comme code *et* comme
   contenu. Champ remis à vide.
2. **`chargemetierniveau.pas`** — `ChercheMaxMetierNiveau` comparait les codes avec `=`
   strict. Les **trois** fonctions de l'unité passent à `CompareRechercheValeur` ensemble ;
   les traiter séparément aurait fait diverger les deux bornes d'une même carrière.
3. **`VerifieRaceMetier` répond enfin à la question que son nom pose.** ⚠️ Son paramètre
   `MetierActuel` la faisait renvoyer **toujours faux** sur une chaîne vide, et son unique
   appelant lui passait `'.'` — une valeur bidon choisie pour n'être égale à aucun code. Le
   contrat était donc déjà contourné au point d'appel. Paramètre **supprimé**, appelant
   nettoyé. Ce piège avait été évité de justesse en écrivant la liste de bifurcation (§2.24).
4. **`PdfMetierDoc` ne construisait les icônes qu'une fois**, pour le premier métier de la
   liste : les suivants dessinaient avec ses images, ses couleurs **et son nombre de
   niveaux**. Sans conséquence tant que tout le monde partageait les icônes génériques, réel
   depuis §2.21. La construction est passée dans `PdfMetierPage`, donc refaite par page.
   ⚠️ Les indices restent comptés depuis 1 (`PdfImgNv[Nv-1]`) même pour un métier commençant
   au niveau 3 ; seules les boucles de **dessin** partent de `NvMinMetier`. Une même icône
   sur deux pages est stockée deux fois par `PdfDoc.Images` — le prix d'une image juste.
   **Validé par Nono** en imprimant les académiciens hauts elfes : deux styles d'icônes sur
   la même impression.
5. **`ChercheMetierNiveau`** ne remettait pas `Result` à zéro et renvoyait le résultat de
   l'appel précédent. Dernière `Cherche*` oubliée par le chantier §2.17.

### 2.31 Le coût XP des sorts, aligné sur le Rulebook — terminé (01/09/2026)

Parti d'une question de Nono sur la **mise en donnée** de la tarification, ce chantier a
d'abord révélé que **deux des quatre formules ne suivaient pas le livre**. Corrigées en dur
avant toute réflexion sur le modèle : le défaut existait indépendamment.

#### Ce que dit le Rulebook, table en main

- **Arcane Magic** : *« Up to Intelligence Bonus × 1 → 100 XP, × 2 → 200 XP… »*
- **Petty Magic** : le talent fait mémoriser *« a number of spells equal to your Willpower
  Bonus »* — gratuits — puis *« Up to Willpower Bonus × 1 → 50 XP, × 2 → 100 XP… »*
- **Invoke** : *« 100 XP per miracle you currently know »*

#### Les deux écarts

`n` = sorts **déjà** connus (le sort tarifé est déjà dans la grille, d'où le `Nb-1`).

**Arcane / Domain** — `100 × (1 + ⌊n/BI⌋)` changeait de palier **un sort trop tôt**. Avec
BI = 4, le cinquième sort était facturé 200 là où le livre dit encore 100. Devient
`100 × max(1, ⌈n/BI⌉)`.

**Minor Magic** — `50 × ⌊n/BFM⌋` donnait des paliers **deux fois trop larges**, suivi d'un
correctif (`if CoutXp = MaxMin then CoutXp := 0`) qui annulait le coût de **tous les sorts
d'un palier sauf le premier** : le personnage payait 50, puis rien, puis 100, puis rien.
⚠️ Ce correctif ne figure nulle part dans le livre, et comparait de surcroît un coût **brut**
à une valeur de grille **déjà passée par la division par 25**. Supprimé. Devient : gratuit
tant que `n < BFM`, puis `50 × ⌈n/BFM⌉`.

`Miracle` et `Chaos` étaient justes et sont inchangés.

**Vérifié par simulation avant livraison**, les deux séries reproduisant les tables du livre
case par case, puis validé par Nono sur ses personnages.

#### Deux durcissements au passage

- **Plancher à 1 sur `BI` et `BFM`.** Ils servent de **diviseur** : un personnage dont
  l'Intelligence ou la Force Mentale est inférieure à 10 a un bonus de 0, et la division
  levait une exception. Le défaut préexistait.
- **`NbConnus` est nommé.** Le `Nb-1` traînait dans trois formules sans que rien n'explique
  qu'il désigne l'entrée des tables du livre.

#### Ce que ça change pour le chantier de mise en donnée

Il reste souhaitable mais **pour une autre raison que le nombre de modes** : la formule est
unique, ce sont ses paramètres qui changent. Réalisé le 02/09 — voir 2.32.

### 2.32 La tarification des sorts est une donnée du talent — terminé (02/09/2026)

Idée de Nono du 31/08. Le coût d'un sort ne se déduit plus de son `TypSpell` mais se **lit
dans le talent qui ouvre le catalogue**.

```
cout = XpMultiplier × max( XpFloor , ⌈ n / XpDivisor ⌉ )
```

`n` = sorts **déjà connus dans le même groupe**. Cinq balises, portées par les entrées
génériques uniquement, héritées par les spécialisations via `ChercheTalent` — c'est ce point
vérifié en premier qui a ramené le chantier de ~100 déclarations à **cinq**.

| Talent | Multiplier | Floor | Divisor | Free |
|---|---|---|---|---|
| `RULES-T0012_*` Bless | *rien de déclaré* | | | |
| `RULES-T0080_*` Invoke | 100 | 0 | `1` | – |
| `RULES-T0088_*` Arcane | 100 | 1 | `(BATTR_Int)` | – |
| `RULES-T0089` Petty | 50 | 0 | `(BATTR_WP)` | `(BATTR_WP)` |
| `RULES-T0172_*` Chaos | 100 | 1 | *absent* | – |
| `HELFG-T0190` High Magic | 200 | 1 | `(BATTR_Int)` | – |

**L'absence de déclaration est le tarif des bénédictions** (multiplicateur 0 = gratuit). Les
Blessings ne déclarent donc rien, et l'export n'écrit le bloc que si au moins un champ est
renseigné — sinon un `<XpMultiplier>0</XpMultiplier>` posé partout déclarerait gratuits tous
les talents non encore traités.

#### Le groupe de comptage remplace le `InList()` en dur

`Arcane` et `Domain` partageaient leur compteur via un `InList()` écrit dans le code. Ils le
partagent maintenant **sans qu'aucune donnée ne le déclare** : le groupe d'un sort est
l'entrée générique de son talent (`CodeTalentGenerique`), et les deux citent `RULES-T0088_*`.
Vérifié sur les **719 sorts des seize livres** : la correspondance `TypSpell` → famille de
talent est bijective, aucune exception. `XpPool` ne sert donc qu'à forcer un partage entre
deux familles distinctes — cas qu'aucun livre ne présente aujourd'hui.

#### Trois écarts assumés, tous des corrections

L'objectif était « coûts rigoureusement identiques ». Il l'est pour le Rulebook et tous les
livres de l'Empire. Trois exceptions, toutes découvertes *pendant* le chantier :

1. **Le tarif arcanique se calculait sur l'Initiative.** `XpSortCout` lisait `ColAttI`
   (colonne 6, `ATTR_I`) là où le livre dit *« Up to Intelligence Bonus »* (`ColAttInt`,
   colonne 9, `ATTR_Int`). La variable s'appelait `BI`, qui se lit « Bonus Intelligence ».
   ⚠️ **Piège de nommage franco-anglais** : une variable nommée d'après le français lisant
   une colonne nommée d'après l'anglais. À chercher ailleurs.
2. **High Magic était tarifé par l'étiquette que j'avais posée à l'import** (CN 0 → Blessing,
   sinon Miracle) : 6 gratuits, 16 au tarif arcanique, 23 au tarif miracle — ces 23 polluant
   en plus le compteur d'un prêtre ayant aussi Invoke. Le livre donne sa propre table p.83 :
   200 XP par palier de Bonus d'Intelligence.
3. **Les 17 rituels de Winds of Magic** citent `RULES-T0088_*` : ils sont désormais tarifés
   comme de l'arcanique et comptés dans ce groupe. Referme la question ouverte du 29/08.

#### Deux pièges traités explicitement dans le code

- **Diviseur absent ≠ diviseur nul.** Absent = pas de progression, donc forfait (le Chaos).
  Nul = un bonus d'attribut à zéro, et là c'est le plancher à 1 hérité de l'ancien code.
  Les confondre transformait l'arcanique d'un personnage à Intelligence < 10 en forfait 100.
- Ce même plancher à 1 accordait, en Magie Mineure, **un sort offert au lieu de zéro**.
  Conservé : sans lui un personnage à FM < 10 payait son premier sort.

#### Bug découvert et non corrigé ce jour-là — traité depuis

La liste fermée des six `TypSpell` servait encore à trois endroits de `winpersonnage`.
Laissé au `A FAIRE` le 02/09 (c'est le chemin de sauvegarde, et une modification à la
fois), corrigé le 03/09 — voir **§2.33**.

#### Points de reprise

- `chargetalent.pas` : `CodeTalentGenerique`, et l'héritage des cinq champs dans
  `ChercheTalent` — **découpe recopiée à l'identique**, les deux doivent désigner la même
  entrée sinon un talent hérite d'un tarif et compte dans un autre groupe.
- `winpersonnage.pas` : `ValeurTarifSort`, `TalentSort`, `PoolTalent`, `XpSortCout`.
- `ValeurTarifSort` duplique la découpe `(BATTR_x)` de `TabAugmentationTalentSetEditText`
  (~l.3480). Candidat à une factorisation, non faite pour ne pas toucher à du code hors
  chantier.

### 2.33 La liste fermée des six `TypSpell` disparaît de `winpersonnage` — terminé (03/09/2026)

Suite directe de §2.32, qui avait laissé le bug ouvert parce qu'il touchait la sauvegarde.
Trois sites, corrigés **un par un**, avec compilation et test entre chaque :

| Site | Ce qui était cassé |
|---|---|
| `l.4744`, enregistrement du personnage | Un rituel partait dans le fichier comme **équipement ordinaire** : colonne 7 recopiée en qualité, coût XP forcé à zéro |
| `ButtonFabricationClick` | La fenêtre Fabrication s'ouvrait sur un sort — un « Bulky » a effectivement pu être posé sur un Cursecraft |
| `ButtonDeleteClick` | Le bouton Supprimer s'ouvrait sur un sort (noté « Fabrication » par erreur dans `A FAIRE.txt`) |

Le test est partout le même :

```pascal
TalentSort(TabEquipement.Cells[2, <ligne>]).CodeTalent = ''   // = ce n'est pas un sort
```

Il interroge **les données** au lieu d'une énumération écrite dans le code : une arme ou une
armure n'a pas de `ListeTalent`, donc `TalentSort` renvoie une structure vide. Un `grep` sur
les six constantes `TypeSort*` ne renvoie plus rien dans `winpersonnage.pas`.

**Réserve connue, non régressive :** si le livre d'un sort n'est pas chargé, `ChercheSort`
renvoie vide et la ligne repasse pour un équipement. C'était déjà le cas avant.

#### Ce que la session a appris sur la méthode

- **Restager avant de conclure, pas seulement avant d'éditer.** Trois fois dans la même
  session un test a été rapporté comme concluant alors que le patch n'était pas dans le
  fichier. La date et la taille du fichier sur le poste l'ont dit à chaque fois. La règle
  du 31/08 s'étend donc à l'**interprétation d'un résultat de test**.
- **Un symptôme attendu n'est pas une anomalie.** « Je peux mettre de la fabrication
  partout » décrivait exactement le comportement du code non corrigé ; le dire évite de
  partir chercher une cause ailleurs.

### 2.34 Les placeholders de libellés, et les deux replis d'image — terminé (03/09/2026)

Petit lot de finitions, chaque modification compilée et testée séparément.

**Les sept placeholders de libellés.** `wincreation.pas` portait trois `LAB_xxx` en en-têtes
de `TabCreationChoix` ; `winlancede.pas` en portait un (`LabelInfo`) **et trois `MESS_xxx`**
découverts au passage — ces derniers ne s'affichent que dans des cas d'erreur, ce qui
explique qu'ils aient survécu si longtemps. Créés dans les deux Rulebooks : `LAB_174`
Origine / `LAB_175` Élément / `LAB_176` Choix / `LAB_177` « Entrez le résultat de votre
D100 », et `MESS_059` « Aucun talent ne correspond à ce résultat de dé ».

Deux libellés existants ont suffi pour le reste, **parce qu'ils ont été cherchés avant
d'être créés** : `MESS_019` (« Veuillez renseigner votre résultat de jet de dé »), déjà
utilisé pour ce sens exact dans `wincreation`, et `MESS_021` (« Ce résultat de dé
correspond à un talent déjà pris »), **défini mais orphelin** — écrit pour cette fenêtre,
jamais branché. `MESS_021` a été réécrit avec un `%s` : le code faisait déjà
`Format(..., [PTalent.Libelle])` et le nom du talent était silencieusement ignoré.

**Le repli sur l'ancien nom d'image, retiré** (`chargemetier`, `chargerace`, `chargesort`).
Il servait à découpler le renommage des 200 fichiers de la modification du code ; les deux
étant faits, il ne protégeait plus rien et aurait masqué un oubli de renommage futur. Les
appels `DecoupeCodeValeur` qui n'existaient que pour lui sont partis avec.

**Le repli sur l'ethnie de référence devient TOUT OU RIEN.** Bug signalé par Nono : une
ethnie de Middenheim n'ayant qu'une seule illustration affichait la sienne **et** la
seconde du Rulebook, côte à côte. La cause : `CheminRaceImage` décidait du repli
**indice par indice**. Le commentaire posé le 31/08 annonçait pourtant déjà le bon
comportement — « il ne se déclenche que lorsque l'ethnie demandée n'a aucune image » —
l'intention était écrite, jamais implémentée. *Un commentaire n'est pas une preuve du
comportement du code.*

La correction ajoute `RacePossedeUneImage(PRace)` : un `FindFirst` sur
`<code de l'ethnie>*.PNG`, en vérifiant que ce qui suit le code n'est **que** des chiffres
une fois le suffixe `_TRANS` retiré — sans quoi `MIDD-RACE_X` serait satisfait par une
image de `MIDD-RACE_XY`. **Interroger le dossier plutôt que d'écrire « 1 et 2 » en dur** :
les seuls appelants ne demandent que ces deux indices aujourd'hui, mais une liste fermée
recopiée dans le code est exactement la forme qui a produit les trois bugs du §2.33.
Validé par Nono sur les deux chemins : Middenheim garde son image sans emprunter,
Salzenmünder qui n'en a aucune récupère bien les deux du livre de base.

**Piège d'outillage rencontré, à ne pas réapprendre.** `winlancede.pas` est en **CRLF**
alors que `wincreation.pas` est en **LF**. Une première passe d'édition a normalisé les
fins de ligne et le diff a viré au rouge sur les 102 lignes du fichier. Refaite en binaire,
elle ne portait plus que sur la ligne voulue. Un tel « changement » passerait inaperçu au
commit et polluerait tout l'historique du fichier : **éditer en préservant les octets, et
lire le diff avant d'envoyer.**

---

### 2.35 Intégration d'un livre du corpus — méthode calée sur Wood Elf Wardancer — terminé (03/09/2026)

**Pourquoi ce livre.** `A FAIRE.txt` recommandait depuis le 30/08 de commencer par un très
petit livre « pour caler la méthode à moindres frais ». *Wood Elf Wardancer Career* fait 4 Ko :
une carrière, deux talents, rien d'autre. Il a servi de banc d'essai à la procédure ci-dessous,
qui vaut pour tous les livres restants — c'est **elle** le livrable, le fichier n'en est que la
démonstration.

**Résultat.** `DATABASE\BOOK_WOOD_ELF_WARDANCER.Xml`, seul fichier créé, aucun fichier existant
modifié, donc aucune compilation. Contenu : `WARDA-WORK001` (Wood Elf Wardancer, 4 niveaux),
`WARDA-T0001` (Talismanic Tattoos), `WARDA-T0002` (Shadow Dances of Loec),
`WARDA-COMB_BASE_001` (Asrai War Blade) et `RULES-COMPSIGNES_WOODELF` (Secret Signs (Wood Elves)).

#### La procédure, dans l'ordre

1. **Restager les fichiers de `DATABASE`, puis construire l'index** id → libellé anglais des
   compétences, talents, armes, armures, carrières, races et ethnies. Sans index à jour, on
   « crée » un identifiant qui existe déjà.
2. **Résoudre chaque libellé du livre contre cet index avant d'écrire une ligne.** Sur ce
   livre : 20 compétences et 14 talents résolus, une seule création nécessaire. Ce qui ne se
   résout pas n'est *pas* forcément absent — le premier « ailleurs » à essayer est un autre
   livre de la base (l'Eonir War Blade venait d'`ARCH1`, pas du Rulebook).
3. **Contrôler la forme avant de valider la lecture.** Une carrière WFRP4 a
   **8/6/4/2 compétences et 4/4/4/4 talents**, et un tableau d'avance à **3/1/1/1**. Retomber
   dessus prouve que l'extraction TXT n'a rien perdu ; ne pas y retomber est le signal qu'il
   manque quelque chose.
4. **Rattacher la carrière par `DATA_SPECIE_CAREER_DIRECT`, au niveau RACE**, quand le livre ne
   donne pas de plage de dés — la table de tirage du Rulebook n'est alors pas retaillée et la
   carrière s'obtient par choix. Précédents : High Elf Player's Guide et Sea of Claws.
5. **Valider avant d'envoyer** : le XML parse, chaque référence à code se résout (index + ce que
   le fichier déclare lui-même), aucun identifiant créé n'entre en collision. Les trois contrôles
   sont scriptables et ont tourné à chaque version.
6. **Commenter dans le fichier tout ce qui n'est pas une donnée du livre** — choix de saisie,
   lecture d'une mise en page aplatie, donnée venue d'ailleurs. C'est ce qui permet à la
   prochaine revue de distinguer une erreur d'un arbitrage.

#### Décisions de portée générale prises à cette occasion

- **La numérotation repart à 001 dans chaque nouveau livre** (Nono, 03/09/2026). Le préfixe de
  livre étant désormais porté partout, la clé est unique sans série globale. Le code ne dépend
  pas de la largeur : `RULES-WORK01` et `HELFG-WORK135` coexistent déjà. Les talents restent sur
  4 chiffres (`WARDA-T0001`), les carrières sur 3 (`WARDA-WORK001`).
- **Une spécialisation nouvelle d'une compétence du Rulebook garde le préfixe `RULES`** et se
  déclare dans le fichier du livre qui l'introduit. Conventions de nommage : anglais, comme
  `RULES-COMPSIGNES_SHADOWWAR` (HEPG) et `RULES-COMPSAVOIR_OLDONES` (Lustria).
- **Répéter une ligne de `SUBCHAPTER_ITEM` exprime la quantité.** Le Rulebook pose deux fois
  `RULES-COMB_BASE_04` au niveau 3 de `RULES-WORK18`. La limite notée dans `A FAIRE.txt` était
  donc trop absolue ; elle y est corrigée.
- **Une donnée de fan peut entrer dans un livre de fan, à condition de le dire.** L'Asrai War
  Blade n'existe dans aucun livre officiel — vérifié dans Archives of the Empire I (qui ne donne
  que l'Eonir, p.94) et sur douze livres de `PDF_TEXTE/` : zéro occurrence. Son profil vient d'un
  wiki de campagne, il ne diffère de l'Eonir que par Enc 1 et Rare, et le commentaire du fichier
  dit tout cela. Le livre entier étant `OFFICIAL="2"` — la carrière elle-même n'existe dans aucun
  livre officiel — l'ensemble reste cohérent.

#### Ce qui reste à surveiller sur ce livre

Les deux talents sont **purement descriptifs** : Ward, Magic Resistance, attaque gratuite,
qualité Impale et trait Distracting ne sont calculés nulle part. Même parti que `NAGGA-T0185`.
Le niveau 4 est en **Silver 5 et non en Gold** : c'est bien ce qu'écrit le livre. Les
« Asrai/Eonir War Blades » du niveau 2 sont posées en **une seule ligne** — le livre n'y exprime
pas de quantité, contrairement au niveau 1.

**Suite** : la méthode a été passée à l'échelle sur *Nations of Mankind*, voir §2.37.
*Parravonese, Strigany, and Signaller Career* (8 Ko) reste le prochain livre à exercer
`DATA_SPECIE` et `DATA_CAREER_ROLL`, que ni le Wardancer ni Nations n'ont touchés : il
apporte une carrière **et deux ethnies avec leurs tables de tirage de 100 lignes**.
Attention, son tableau d'avance est **vide dans l'export TXT** ; le lire sur le PDF.
Ordre complet dans `A FAIRE.txt`.

---

### 2.36 Inventaire du corpus PDF_TEXTE — ce qui reste à modéliser (03/09/2026)

Balayage de ~150 fichiers du corpus, en écartant les 19 livres déjà présents dans
`DATABASE`. **`PDF_TEXTE` n'est pas l'ancien nom de `LIVRES`** : `LIVRES` = les livres
modélisés avec leurs PDF, `PDF_TEXTE` = l'export texte de tout le corpus.

Ce qui a de la matière, par ordre de rendement :

| Livre | Contenu repéré |
|---|---|
| **Nations of Mankind** | 30 carrières, 16 talents, 7 domaines de magie — **lots 1 et 2 faits, voir §2.37** |
| **Unofficial Grimoire 1.2** | ~215 sorts sur 16 domaines (Élémentalisme, Nécromancie, Nurgle/Slaanesh/Tzeentch, Warp) + 3 carrières de lanceur |
| **Dwarf Player's Guide** | 9 carrières nommées + ~23 autres blocs à extraire, 9 blocs d'armure, ethnies naines |
| **Deft Steps, Light Fingers** | 9 carrières (prêtres de Ranald et Taal, Forger, Poacher, Gamekeeper) |
| **Princes of Ulthuan** | 4 carrières hauts elfes (White Lion, Swordmaster, Shadow Warrior, Seaguard) |
| Lots de sorts purs | Reikland Miscellanea (50, dont Hedgecraft/Witchcraft), Sullasara's (50), Blood and Bramble (48), Tribes and Tribulations (30), Temple of Spite (26, elfes noirs) |
| Ethnies | Temple of Spite (elfes noirs), Lords of Stone and Steel (Karak Azgaraz), Kings of the Dead (fan, Khemri) |

**Les quatre Companions de l'Enemy Within sont déclarés mais quasi vides** : leur XML fait
6 à 8 Ko alors que les textes portent **108 sorts** (Horned Rat 38, Enemy in Shadows 25,
Power Behind the Throne 33, Death on the Reik 12) et quatre carrières (Ironbreaker,
Cultist, Warrior of Tzeentch). C'est le meilleur rapport travail/résultat du corpus, parce
que les livres existent déjà dans la base.

**Zéro rendement, vérifié** : toutes les aventures (Ubersreik 1/2/3, les cinq volumes de
l'Enemy Within, les one-shots, Fan Made, Other help hors Grimoire) — fiches de PNJ et aides
de jeu, rien de modélisable. Ne pas y revenir.

**Piège confirmé au passage** : les 15 occurrences de « Species » de *The Imperial Zoo*
sont des fiches de PNJ, pas des ethnies — même famille que les « Career Path » mal comptés
le 30/08. Un marqueur compté n'est toujours pas un marqueur lu.

---

### 2.37 Nations of Mankind — lots 1, 2, 3a, 3b, 3c et 3d-1 terminés (04/09/2026) ; restent 3d-2 et 3d-3

Fichier unique `DATABASE\BOOK_NATIONS_OF_MANKIND.Xml`, 277 Ko, `CODE_BOOK` = `NATIO`,
`OFFICIAL=2`, `COMPLETE=0`. Aucun fichier existant modifié, donc aucune compilation.
Chargé et vérifié par Nono : les 30 métiers s'affichent proprement.

**Fait — lot 1, les briques** : 35 spécialisations de compétence (13 `Lore`, 5 `Ride`,
4 `Perform`, 4 `Play`, 2 `Art`, 3 `Secret Signs`, plus Language/Entertain/Trade), 16 talents
propres au livre, 29 spécialisations de talent (8 styles de Kenjutsu, 8 voies de Martial
Artist, 5 Marques des dieux, plus Fearless/Hatred/Bless/Invoke/Savant).

**Fait — lot 2, les carrières** : les 30, avec leurs 120 niveaux, tableaux d'avance,
compétences, talents et équipements. **1077 références résolues sur 1077.**

**Fait — lot 3b, les domaines de magie (04/09/2026).** Les **72 sorts** des pages 48-57, saisie
pure, aucun fichier de code touché : Dazh 8, Tor 7, Ursun 8, Ormazd 6, les Devas 8, l'Orange
Simca 8, **Lore of Ice 18**, **Lore of the Desert 9**. Le compte du XML correspond domaine par
domaine à celui du PDF. Les huit talents cités par les sorts (`RULES-T0080_*` pour les six
dieux, `RULES-T0088_ICE` et `_DESERT`) sont **tous déclarés dans le fichier** en
spécialisations — aucune référence pendante. `TypSpell` : `Miracle` pour les quatre divine
lores (aucun miracle du livre ne porte de CN, d'où un `Level` vide), `Arcane Magic` pour Ice
et Desert, qui portent le leur.

Et le bloc `DATA_SPELL_TALENT` du §2.39 **a trouvé son premier client** : 16 bénédictions
`RULES-BENED_*` du Rulebook rattachées aux sept talents `Bless (…)`, sans toucher au fichier
du Rulebook. **Testé par Nono le 04/09** : le prêtre de Dazh reçoit ses bénédictions, et
`Invoke (Dazh)` lui ouvre ses miracles. Le chantier du 03/09 est donc validé sur un livre
*autre* que celui qui déclare les sorts — ce pour quoi il avait été fait.

⚠️ **Deux constats de ce test, qui ne concernent pas ce livre.** *(a)* Les `Ritual` qui
apparaissent dans la liste d'un lanceur de Nations sont **normaux** : ce sont les six rituels
de *Winds of Magic* marqués `RULES-T0088_*`, le joker « n'importe quel domaine arcane » ; les
onze rituels à domaine précis sont bien filtrés. Même mécanisme pour les sorts arcanes communs
du Rulebook. **Vérifier le champ `<Talent>` avant de conclure à un débordement de filtre.**
*(b)* En revanche leur **coût est faux** : le livre imprime un `Learning XP:` propre à chaque
rituel (100 à 600), là où le §2.32 point 3 les tarife au tarif arcanique — et surtout les fait
**compter dans le groupe arcanique**, donc renchérir les vrais sorts du personnage. Le modèle
ne porte pas de coût fixe par sort. Conception à mener : **arbitrage 6 d'`A FAIRE.txt`**, où
les 17 valeurs sont relevées.

**Reste — lot 3**, découpé le 03/09/2026 :

- **3a — l'éligibilité par espèce. ✅ TERMINÉ le 04/09/2026.** Conception d'origine, conservée
  parce qu'elle explique le blocage qu'il a fallu lever : les espèces des 30 carrières étaient en
  commentaire (`<!-- espece : ... -->`) dans le fichier. Voir plus bas « le blocage de 3a » :
  ce n'est pas un simple rattachement, neuf des ethnies citées n'existent pas en base.
- **3b — les domaines de magie** (Divine Lore of Kislev / Araby / Ind / Nippon, Lore of Ice,
  Lore of the Desert), p.48-57. **✅ TERMINÉ le 04/09/2026**, voir ci-dessus. Six domaines et
  non sept : le compte de sept venait de compter Kislev deux fois.
- **3c — armes, armures et qualités** (p.58-61). **✅ TERMINÉ le 04/09/2026**, voir plus bas.
  **Les montures restent hors périmètre** (décision Nono, 03/09/2026) : la section « New
  Mounts » et l'Estalian War Bull attendent.
- **3d — Provinces / Regiments / Knightly Orders** (p.5-9). Lecture du 04/09/2026 : ce ne
  sont pas trois fois la même chose, et le lot s'est scindé en trois.
  - **3d-1 — les provinces de l'Empire (p.5). ✅ TERMINÉ le 04/09/2026.** Ce ne sont PAS des
    bonus conditionnels : le livre leur donne la forme exacte d'une ethnie (liste de
    compétences, liste de talents finissant par N Random Talents) et les appelle lui-même
    « Empire Province **Racial** Skills » (p.8, Grand Order of the Reiksguard). Saisies dans
    le moule du lot 3a. Voir plus bas « les trois provinces écartées ».
  - **3d-2 — les régiments (p.6-7).** 14 régiments provinciaux + 11 « Regiments of Renown ».
    Quatre paliers (Recruit / Soldier / Sergeant / Officer) qui greffent une compétence ou un
    talent sur **la carrière Soldier du Rulebook**. **Conception à mener, une seule question :
    un régiment est-il une CARRIÈRE dérivée (« Soldier (Averland) », 14 carrières, saisie
    mécanique dans un modèle qui existe déjà) ou un GREFFON (une donnée nouvelle qui ajoute
    des compétences et des talents au niveau N d'une carrière déjà chargée) ?** La première
    marche demain, la seconde est plus juste et resservira. Les huit `Lore (…)` de province
    créées au 3d-1 sont déjà en place : chaque régiment donne le `Lore` de sa province.
  - **3d-3 — les ordres de chevalerie (p.8-9).** Même architecture, sur la carrière Knight
    (Squire / Knight / First Knight / Knight of the Inner Circle), mais **le palier Squire est
    le seul saisissable** : les trois autres sont des règles rédigées (« +10 à tes tests de CC
    avec les lances », « tes haches gagnent le miracle Winter's Bite en début de rencontre »,
    « tu gagnes le trait Champion contre tes ennemis haïs », « +10 Fel et +10 WP permanents »).
    Même famille de problème que les psychologies et que la pénalité de Dextérité des
    Stechzeug Bracers, toutes deux dans `A FAIRE.txt` : le modèle porte une compétence ou un
    talent, pas un effet de règle. **Ne pas commencer avant d'avoir tranché ça.**

**Le 3d-1 en détail, et les trois provinces écartées (04/09/2026).** Sept provinces saisies —
Averland, Hochland, Ostermark, Ostland, Stirland, Talabecland, Wissenland — soit 84 compétences
et 35 talents, plus **huit spécialisations `Lore (…)` créées** (`RULES-COMPSAVOIR_AVERLAND`,
`_HOCHLAND`, `_OSTERMARK`, `_OSTLAND`, `_REIKLAND`, `_STIRLAND`, `_TALABECLAND`,
`_WISSENLAND` ; Middenland et Nordland existaient déjà au Rulebook). Aucun fichier de code
touché, donc aucune compilation.

**Trois provinces sur dix n'ont PAS été saisies**, par la règle du 03/09 « l'officiel gagne
sur le fan pour une IDENTITÉ, une ethnie étant unique » :
- **Reikland** *est* `RULES-RACE_HUM` du Rulebook, dont le libellé est littéralement
  « Humans (Reikland) » — contenu identique à une compétence près (le Rulebook y écrit
  `Lore (Local)`).
- **Middenland** et **Nordland** sont déjà dans *Middenheim* (officiel) sous leurs gentilés,
  `MIDDE-RACE_HMIDL` « Humans (Middenlander) » et `MIDDE-RACE_HNORD` « Humans (Nordlander) ».
  L'écart de contenu entre les deux versions est relevé dans `A FAIRE.txt`.

⚠️ **Ces trois doublons sont partis sur le poste avant d'être vus** — c'est Nono qui les a
repérés dans la liste de WinRaces. Voir la règle ajoutée au §0 : le contrôle de collision doit
porter sur la nature de donnée qu'on **ajoute**, pas seulement sur celles qu'on référence.

**Résolution des libellés du 3d-1**, trois lectures à connaître : `Language (Mootish)` lu comme
`Language (Halfling)` (le Moot est le pays halfling, aucun « Mootish » dans le corpus),
`Secret Signs (Hunters)` comme `Secret Signs (Hunter)`, `Trade (Farmer)` comme
`Trade (Farming)`. Décisions Nono du 04/09/2026.

**Point de reprise : 3d-2** — voir la puce 3d-2 plus haut et le point de reprise en fin de
section. Ce paragraphe portait au 03/09 l'hypothèse « une province est peut-être une ethnie » :
**elle s'est vérifiée le 04/09**, et le 3d-1 est fait. Ce qui reste — régiments et ordres — est
bien, lui, du bonus **conditionnel à l'appartenance**, et aucune table ne porte ça ; le plus
proche parent reste `DATA_SPECIE_TRAIT` (§2.41), écrit pour les traits d'ethnie à sous-liste.

#### 3c — ce qui est écrit, et les cinq leçons (04/09/2026)

**98 entrées, aucune compilation.** 44 armes de mêlée (`NATIO-COMB_<CAT>_NN`, sept catégories),
17 armes à distance et 6 munitions (`NATIO-PROJ_*`, `NATIO-MUNI_*`), 28 armures
(`NATIO-ARMO_NN`), 3 accessoires (`NATIO-QUALITY_01..03`), 6 qualités d'arme
(`NATIO-WEAPB38..43`), 6 qualités d'armure (`NATIO-ARMOB_09..14`), 1 type d'armure
(`NATIO-ARMOT_LAMELLAR`). Contrôles : XML bien formé, diff sans retrait à chaque passe,
identifiants uniques, libellés sans collision, toutes les qualités et compétences résolues.
**Nations est le premier livre autre que le Rulebook à déclarer des armures.**

- **Le TXT du corpus a suffi pour toute la section.** Contrairement à 3b, `PDF_TEXTE\Nations
  of Mankind.txt` rend les tableaux d'armes et d'armures lisibles tels quels. La règle
  TXT-avant-PDF du §0 a payé : aucun PDF ouvert de la journée. Ne pas généraliser « les
  tableaux sont inexploitables » — c'était vrai des tableaux de carrière et de la magie.
- **Un vocabulaire n'est pas ouvert parce qu'un autre l'est.** Contrôle fait champ par champ,
  méthode du `DISPO_UNIQUE` de 2.29 : le **type** d'armure est OUVERT (il ne passe que par
  `GetAllTexteLibelle`, winarmor.pas l.132, et `ReplaceTexteLibelle`, chargearmure.pas l.59),
  d'où `NATIO-ARMOT_LAMELLAR` ; la **localisation** est FERMÉE (`pdfpersonnage.pas`
  l.1626-1629 fait un `case` sur `BonusTete/BonusBras/BonusCorps/BonusJambes`), ce qui
  condamne les Skull Trophies, dont l'emplacement est « Any ». Deux champs voisins du même
  bloc, deux réponses opposées.
- **Une qualité de fabrication n'est pas une qualité d'objet.** Le livre imprime Bulky,
  Durable, Fine, Practical et Ugly dans la même colonne que les vraies qualités d'armure. Ce
  sont des `RULES-QUALITY_*` / `RULES-DEFECT_*` (`DATA_CRAFTMANSHIP`), que le bouton
  `+Qualité` de WinPersonnage pose sur l'objet **que possède un personnage**
  (`winpersonnage.pas` l.758 → colonne 7 → `QualiteEquipement`, sauvegardé dans la fiche).
  Non saisies, signalées à leur place — même règle qu'au `DATA_ARMOR` de HEPG.
  ⚠️ **Ne pas conclure de là que la table dort** : c'est ce que j'ai affirmé à tort en
  cherchant « aucun appelant » sur six fichiers `.pas` rapatriés au lieu de tous. Rapatrier
  avant de conclure, ou ne pas conclure.
- **Un accessoire est une fabrication.** Barrel Extension, Bayonet et Telescopic Sight sont
  entrés en `DATA_CRAFTMANSHIP` plutôt qu'en table nouvelle : un accessoire se monte sur
  l'arme d'un personnage. Ils sont **descriptifs** — le `Modifier` d'une fabrication n'est
  branché sur aucun calcul (aucun code `QUALITY_` référencé dans le corpus, `FabricationDetail`
  sans appelant). Item ouvert dans `A FAIRE.txt`.
- **La règle « l'officiel gagne » ne s'applique PAS aux objets.** Quatre armes portent le nom
  d'une arme qu'*Up in Arms* décrit déjà autrement (Warhammer, Scimitar, Saber/Sabre, Bill).
  Décision Nono, 04/09 : **les deux coexistent**, sous des noms distincts (règle de nommage
  2.29) — Warhammer (Nations of Mankind), Arabyan Scimitar, Fencing Saber, Hooked Bill. La
  règle de 2.37 sur Norsca et Tilea vaut pour une **identité** (une ethnie est unique), pas
  pour un catalogue où deux cimeterres différents peuvent exister.

**Autres choix de saisie, tous commentés dans le fichier :** les quatre armes à poudre
reçoivent `Blackpowder` et `Damaging` que le tableau n'imprime pas, parce que le texte de
`Suppressed` les suppose (déduction) ; `Incendiary` est résolu en `RULES-WEAPB29`, dont
l'explication EST celle d'Incendiary bien que son libellé soit « Ablaze » (aucune qualité
créée pour rien) ; deux homonymes internes au livre renommés `Morningstar (Two-Handed)` et
`Flanged Mace (Two-Handed)` ; cases vides saisies `+0` ou `-` ; quantité 12 des flèches
reprise du Rulebook (déduction) ; coquilles corrigées (*Very Lorng*, *designed will*,
*Missile Resistance*).

⚠️ **La pénalité de Dextérité des Stechzeug Bracers n'est pas calculée** : le `Modifier name`
d'une qualité d'armure est résolu par `ChercheCompetence` (`pdfpersonnage.pas` l.1746) et
n'accepte donc **que des compétences, jamais un attribut**. `NATIO-ARMOB_14` est descriptive,
et le dit dans son explication.

**Le blocage de 3a, constaté le 03/09/2026.** L'index des ethnies de la base a été
reconstruit : sur les onze groupes cités par les commentaires d'espèce, **deux seulement
existent** — Norscan (`SEAOF-RACE_HBJOR` / `HSARL` / `HSKAE`) et Tilean (`UPINA-RACE_HTIL`).
Manquent Bretonnien (noble et paysan), Ungol, Gospodar, Arabe, Indan, Cathayan, Nipponais,
Estalien et Albion. Or le livre porte précisément de quoi les créer : ses pages 3-4 donnent
pour chacune des 13 nations une liste de compétences et de talents — c'est-à-dire des
données de création au sens de la règle de scission du §0 — et la page 5 fait de même pour
dix provinces de l'Empire. **Direction retenue (Nono, 03/09/2026) : créer les ethnies**,
sur le modèle exact de *High Elf Player's Guide* — onze ethnies posées sur une race
existante. Ce n'est donc pas « créer des races », c'est faire pour les humains ce que HEPG
a fait pour les Hauts Elfes. La partie « Provinces » de 3d est avalée au passage.

#### 3a — état de la conception au 03/09/2026, point de reprise

**Dix ethnies à créer**, toutes rattachées à `RULES-SPECIE_HUMAN` par leur champ
`<Ethnic>` : Albion, Araby, Bretonnia (Peasantry), Bretonnia (Nobility), Cathay, Estalia,
Ind, Kislev (Gospodar), Kislev (Ungol), Nippon. Source : pages 3-4 du livre, une liste de
compétences et une de talents par nation.

**Les caractéristiques sont recopiées du Reiklander (décision Nono, 03/09/2026).** Tous les
humains ont les mêmes caractéristiques de base ; le `SUBCHAPTER_ATTR` de `RULES-RACE_HUM`
est repris tel quel sur les dix — `2d10+20` sur les dix caractéristiques, Fate 2, Resil 1,
Wound `1xBATTR_S+2xBATTR_T+1xBATTR_WP`, Supp 3, Move 4 — avec un commentaire disant d'où il
vient. Le livre ne donne ni caractéristiques ni table de carrière par nation.

**Norsca et Tilea ne sont PAS créées.** Le livre les redécrit, mais la base les porte déjà,
et les listes diffèrent franchement : *Sea of Claws* a **trois** ethnies norses (Bjornling,
Sarl, Skaeling) là où Nations n'en donne qu'une avec cinq *Tribe Traits* (dont
Baersonslingers et Skeggi, qui n'existent nulle part) ; et `UPINA-RACE_HTIL` porte Cool,
Évaluate, Haggle, Ranged (Crossbow) quand Nations donne Art, Bribery, Consume Alcohol,
Perform, Sleight of Hand. **Règle posée à cette occasion : quand un livre de fan redécrit
une ethnie qu'un livre officiel porte déjà, l'officiel gagne.** La règle de scission du §0
départage des ethnies d'un *même* livre ; elle ne s'applique pas à deux descriptions
concurrentes du même peuple. Les carrières « Human Norscan » se rattachent donc aux trois
norses de *Sea of Claws*, « Human Tilean » à `UPINA-RACE_HTIL`.

**Résolution des libellés déjà faite** contre l'index des 18 fichiers : l'essentiel se
résout, et il reste une quinzaine de spécialisations à créer — compétences `Lore (Albion)`,
`Lore (Dukedom)`, `Lore (Agriculture)`, `Lore (City State)`, `Lore (Province)`,
`Lore (Region)`, `Lore (Kingdom)`, `Lore (Nippon)`, `Language (Indan)`,
`Language (Nipponese)`, `Language (Cathayan)`, `Language (Ungol)` ; talents
`Resistance (Heat)` et `Resistance (Cold)`. À refaire depuis des fichiers restagés le jour
où on écrit, la liste ci-dessus n'étant qu'un ordre de grandeur.

**Ce qui ne se modélise pas, et reste en suspens** : `Provincial Trait (Any)`,
`Dukedom Trait (Any)`, `City State Trait (Any)`, `Clan Trait (Any)`, `Region Trait (Any)`,
`Kingdom Trait (Any)`. Chacun renvoie à une sous-liste de la page (« •Aquitaine :
Coolheaded, One Random Talent ») — un second niveau de choix que rien ne porte
aujourd'hui. Tranché le 03/09/2026 : laissés en commentaire dans le
fichier pour Kislev (Ungol), et une table `DATA_SPECIE_TRAIT` est conçue pour les porter —
voir §2.41, qui est à appliquer avant d'écrire les neuf autres ethnies.

**3a est TERMINÉ (04/09/2026).** Les **onze** ethnies humaines sont écrites et chargées :
Kislev (Ungol) `NATIO-RACE_HUNG`, plus Albion `HALBI`, Araby `HARAB`, Bretonnia (Peasantry)
`HBRPA`, Bretonnia (Nobility) `HBRNO`, Cathay `HCATH`, Estalia `HESTA`, Ind `HIND`,
Kislev (Gospodar) `HGOSP`, Nippon `HNIPP`, Westerland (Marienburg) `HWEST`. Toutes sur
`RULES-SPECIE_HUMAN`, caractéristiques et table de tirage recopiées du Reiklander. Contrôles :
199 références résolues sur 199, aucune collision d'identifiant, diff sans aucun retrait.

**Westerland était une omission de périmètre, pas un oubli du livre.** La conception du 03/09
listait dix ethnies en partant des commentaires d'espèce des 30 carrières ; les pages 3-4 en
décrivent **treize** — les dix, plus Norsca et Tilea (écartées à raison), plus Westerland
(Marienburg), qui n'avait été ni créée ni écartée. Ajoutée le 04/09 sur décision de Nono. La
leçon : le périmètre tiré des **références** d'un livre n'est pas celui de ses **pages**.
Si un livre officiel donne un jour l'ethnie de Marienburg, la règle « l'officiel gagne »
s'appliquera comme pour Norsca et Tilea.

**Six tables `SpecieTrait` de plus** : `NATIO-TRAIT_ARABY` (City State, 9 options),
`_DUCHE` (Dukedom, 14 — citée par les DEUX Bretonnia), `_CATHAY` (Provincial, 7),
`_ESTALIA` (Region, 12), `_IND` (Kingdom, 7), `_NIPPON` (Clan, 4). Attention : `_CATHAY` et
`_KISLEV` portent le **même libellé** « Provincial Trait » et sont deux listes différentes.

**Dix-sept créations**, aucune collision : `Lore (Agriculture / Albion / City State / Dukedom /
Kingdom / Nippon / Province / Region / Westerland)`, `Language (Cathayan / Indan / Nipponese /
Ungol)`, `Trade (Farming)`, `Resistance (Heat)` = `RULES-T0129_CHALEUR`,
`Craftsman (Miner)` = `RULES-T0092_MINNER` (la famille `Craftsman` n'avait pas de Miner alors
que `Trade (Miner)` existait — créée pour aligner les deux familles),
`Hatred (Daemons)` = `RULES-T0069_DEMON`.

**Coquilles du livre tranchées le 04/09**, chacune commentée à l'endroit où elle est faite :
Language (Arabic)→(Arabyan), Trade (Mining)→Trade (Miner), Strider (Marshes)→(Swamps),
Craftsman (Ferrier)→(Farrier), Craftsman (Engineering)→(Engineer), Craftsman (Trade)→(Any),
Seasoned Traveler→Traveller, Field-Dressing→Field Dressing, Deal Maker→Dealmaker.

**`Prejudice (Bretonnians)` n'est PAS saisi (décision Nono, 04/09/2026).** Le livre le nomme
lui-même une **Psychologie** (p.4, Almogavar : « the Prejudice (Tileans) Psychology ») et cite
ailleurs « Prejudice **or** Hatred » : ce sont deux choses distinctes, et le rabattre sur
`Hatred` durcirait la règle. C'est un préjugé culturel, informatif, sans effet sur la fiche.
L'option Antoch se réduit donc à *Marksman or Warrior Born*. Le modèle ne porte pas les
psychologies — item ouvert dans `A FAIRE.txt`, et il y en aura d'autres que Prejudice.

**Les onze `Explanation` sont rédigées, pas tirées du livre**, et signalées comme choix de
saisie dans chaque bloc : les pages 3-4 ne portent que des listes de compétences et de talents.
À relire par Nono.

**Point de reprise : 3d-2, et c'est une conception, pas une saisie.** La question à trancher
est écrite plus haut dans la puce 3d-2 : carrière dérivée ou greffon. Rien à écrire dans le XML
tant qu'elle ne l'est pas. Deux points de méthode qui valent pour toute la suite : refaire la
résolution des libellés depuis des fichiers **restagés** le jour où on écrit, et réextraire une
section à deux colonnes au `pdftotext -layout -x 306 -W 306`, l'export de `PDF_TEXTE` y étant
inexploitable — sauf pour le texte courant, qui a suffi aux pages 5-9.

**Ce que ce livre a appris, et qui resservira sur les gros livres :**

- **Le TXT du corpus ne suffit pas au-delà d'une petite carrière — mais seulement pour les
  TABLEAUX.** L'export de `PDF_TEXTE` a été fait sans `-layout` : dans les tableaux
  d'avance, les noms de niveaux sont tronqués et les colonnes mêlées, et là il faut refaire
  l'export soi-même depuis le PDF. **Le texte courant, lui, y est intact** : les listes de
  bénédictions « Blessings and Strictures » s'y lisent aussi bien que dans le PDF
  (vérifié le 03/09/2026). Ne pas transformer cette remarque en « ouvrir le PDF d'abord » :
  voir la règle TXT-avant-PDF du §0.
- **Découper le PDF en colonnes vaut mieux que chercher une gouttière.** Aucune colonne de
  blancs n'existait (les titres traversent la page) ; `pdftotext -layout -x 306 -W 306` sur
  une page Letter isole la colonne de droite, où tiennent les 30 tableaux de carrière.
- **La compétence de tête est en italique** — voir §0, c'est la leçon principale de la
  session.
- **Le contrôle de collision d'identifiants sert à trouver des doublons, pas seulement à
  les éviter.** Il a arrêté la création d'`Arcane Magic (Celestial)` en montrant que
  `RULES-T0088_CIEUX` existait déjà sous *Arcane Magic (Heavens)* : deux noms du même
  domaine. Sans ce contrôle, le doublon partait.
- **Un talent peut échapper au filtre par son premier caractère.** `¡¡Despierta, Fierro!!`
  a été manqué au lot 1 parce que le motif de titre exigeait une majuscule ASCII. Trouvé
  seulement parce qu'une carrière le référençait et que la résolution a échoué — c'est la
  résolution exhaustive qui rattrape les trous de l'extraction, pas l'inverse.

**Choix de saisie signalés dans le fichier, à confirmer par Nono :**

- `OFFICIAL=2` : aucune mention d'éditeur sur le PDF, contenu non officiel (Vimto Monks,
  Champion of the Orange Simca).
- **Almogavar en « Copper 3/5 »** : lu comme `TIERS_BRASS`, décision Nono — la base ne
  connaît que Brass, Silver et Gold. Ne pas créer `TIERS_COPPER` sans avoir cherché où la
  liste des paliers est écrite en dur dans le code (même forme que les six `TypSpell`).
- **Highlander en Brass 0 sur ses quatre niveaux** : vérifié sur le PDF page 42, c'est bien
  ce qu'imprime le livre.
- **Bretonnian Knight a 4 caractéristiques de départ** (WS, Force, Agilité, Intelligence)
  là où toutes les autres en ont 3. Saisi tel quel.
- **Cinq carrières portent deux noms** — le titre de page et l'en-tête du tableau d'avance
  diffèrent (Janissary / Arabyan Janissary, Samurai / Nippon Samurai, Inquisidor / Estalian
  Inquisidor, Celestial Dragon Monk / Cathayan Dragon Monk, Cathayan Jinyiwei / Jinyiwei).
  Le titre de page fait foi, la variante est en commentaire.
- `Animal Training` et `Stealth (Everything)` lus comme les formes `(Any)` existantes ;
  `Trade (Bladesmith)` créé tel quel plutôt que corrigé en Blacksmith (carrière nipponne).
- Deux phrases du livre ne sont pas des compétences et ne sont pas saisies : « Starting
  Skills / Talents based on Inquisitor School » (Estalian Inquisidor niveau 1).

**Les espèces sont en commentaire, pas en donnée** : « Human Ungol or Gospodar », « Dwarf,
Gnome, Halfling, High Elf, Human »… demandent un rattachement aux races existantes et un
bloc d'éligibilité. C'est le premier morceau du lot 3.

---

### 2.38 Nom de niveau de carrière au masculin et au féminin — conception, non appliquée (03/09/2026)

**Idée de Nono** : ajouter deux champs optionnels à `<Level>`, un nom masculin et un nom
féminin, à côté du `<Description>` actuel.

**Le besoin ne vient pas de Nations mais de la traduction.** Vérifié le 03/09 :
`BOOK_RULESBOOK_FRANCAIS.Xml` porte ses **256 noms de niveaux encore en anglais** — la
traduction française des carrières n'est pas faite. C'est là que le genre est massif
(Apprenti/Apprentie, Artisan/Artisane sur 256 niveaux), pas dans les 12 niveaux
hispanisants de Nations. Ce chantier est donc à mener **avec** celui de la traduction, pas
pour un livre.

**Ce que ça touche** : le chargeur, l'affichage dans WinPersonnage et WinLivre, le PDF de
personnage, et une règle de repli quand les deux champs sont absents — ce qui est le cas de
la quasi-totalité des niveaux existants. Ce n'est pas une ligne de XML.

**Décision du 03/09, validée par Nono** : Nations est saisi avec la forme du livre telle
quelle dans le `<Description>` actuel — `"Recortador/Recortadora"`, `"Mercenario/Mercenaria"`,
`"Diestro/Diestra"`, `"Torero/Torera"`, `"Banderizo/Banderiza"`, `"Bravucón/Bravucona"`,
`"Jarl/Chaos Warlord"`, `"Coin King/Queen"`. C'est fidèle et **récupérable sans perte** : le
jour où les deux champs existent, un script découpe sur le `/` et les remplit, sur Nations
comme sur le reste. Rien n'est à ressaisir.

---

### 2.39 La relation sort <-> talent est devenue extensible — terminé (03/09/2026)

**Fait, testé, en service.** Décision de Nono : « je voudrais évolutif, et ce livre prouve
que ce ne l'est pas », puis « avoir une table à part pour les bénédictions et ne plus les
renseigner dans le talent, pour ne pas avoir à modifier RULEBOOK si un nouvel élément est
ajouté ». C'est ce qui a été livré, en cinq points de compilation.

**Le problème, mis au jour par les six dieux de Nations.** La relation « ce talent donne
accès à ce sort » est stockée **du côté du sort**, dans son champ `<Talent>`. Tant qu'un
livre apporte ses sorts *et* ses talents ensemble, ça ne se voit pas — c'était le cas des
Elven Arcane du High Elf. Nations casse ça : ses six dieux (Dazh, Tor, Ursun, Ormazd, les
Devas, Orange Simca) accordent des bénédictions qui sont des `<Sort>` **du Rulebook**. La
donnée est à cheval sur deux livres, et le modèle oblige à l'écrire dans celui des deux qui
ne l'introduit pas.

**Pourquoi on ne peut pas compléter depuis Nations** (vérifié dans `chargesort.pas`) :
`ChercheSort` prend le **premier** enregistrement dont le code correspond et sort de la
boucle. Aucune fusion. Une deuxième entrée portant `RULES-BENED_001` serait ignorée ou
masquerait l'autre selon l'ordre de chargement. Les deux seules sorties sans code étaient
donc : compléter le `<Talent>` côté Rulebook (six lignes, mais un livre écrit dans le
fichier d'un autre), ou recopier dans Nations **16 des 18 bénédictions** — l'union des
bénédictions des six dieux. Les deux ont été écartées au profit de la correction de fond.

**La conception retenue : un bloc `DATA_SPELL_TALENT`, purement ADDITIF**, que n'importe
quel livre peut porter.

```xml
<DATA_SPELL_TALENT>
<Access sort="RULES-BENED_007" talent="RULES-T0012_URSUN"/>
<Access sort="RULES-BENED_001" talent="RULES-T0012_DAZH,RULES-T0012_TOR"/>
</DATA_SPELL_TALENT>
```

Le champ `<Talent>` du sort **ne bouge pas** : la table ne fait qu'ajouter des talents à ceux
qu'il cite déjà. Rien à migrer, aucun livre existant à retoucher, et un livre non chargé
retire ses lignes de lui-même — donc pas de référence pendante à signaler au contrôle
d'intégrité du §2.20.

**Ce que ça touche côté code — plus petit qu'il n'y paraît.** `PSort.ListeTalent` est le seul
point de lecture de la relation, et deux fonctions le découpent, toutes deux avec le
commentaire « même découpe » : `TalentSort` (`winpersonnage.pas`) et `SortTalentAccessible`
(côté `winspell`). Donc :

1. un chargeur pour le nouveau bloc, sur le modèle des autres `DATA_*` ;
2. **une seule fonction** `TalentsDuSort(CodeSort)` qui renvoie la concaténation du champ
   `<Talent>` et des lignes de la table ;
3. les deux appelants passent par elle au lieu de lire `PSort.ListeTalent` directement.

**Piège à vérifier au test** : `PoolTalent` bâtit le groupe de comptage XP sur le talent
**trouvé**, pas sur la chaîne écrite dans le sort. Tant que la table renvoie des codes de
talents réels, les coûts ne bougent pas — à confirmer avec un personnage portant deux dieux,
car c'est exactement le cas que le modèle actuel ne rencontrait jamais.

**Premier client** : les bénédictions des six dieux de Nations, laissées en attente à la fin
du lot 3 (voir §2.37). Elles ne seront branchées que par ce chantier.

---

**CE QUI A ÉTÉ FAIT — écart assumé par rapport à la conception ci-dessus sur deux points.**

*Point 1, le format XML.* Pas `<Access sort=… talent=…/>` mais la forme de tout le reste du
projet, qui réutilise `XmlDebutCode` / `XmlLigne` / `XmlFinCode` sans écrire de helper
multi-attributs :

```xml
<DATA_SPELL_TALENT>
<Sort id="RULES-BENED_001">
<Talent>"RULES-T0012_DAZH,RULES-T0012_TOR"</Talent>
</Sort>
</DATA_SPELL_TALENT>
```

*Point 2, la table n'est plus seulement additive pour les bénédictions.* La conception disait
« le champ `<Talent>` du sort ne bouge pas ». Nono a tranché autrement : pour les
bénédictions, la relation **sort du sort** et vit uniquement dans la table. Les 19
`RULES-BENED_*` du Rulebook ont donc leur `<Talent>` vidé, et leurs dieux sont dans un bloc
`DATA_SPELL_TALENT` porté par le Rulebook lui-même. Le mécanisme reste additif pour tous les
autres sorts, qui gardent leur `<Talent>` — un domaine de magie dont le livre apporte sorts
et talents ensemble n'a aucune raison de passer par la table.

**Périmètre décidé avec Nono** : migration des bénédictions seules (pas des ~1000 autres
relations), et saisie du bloc en XML à la main — aucun écran d'édition dans WinLivre pour
l'instant.

**Ce qui a été écrit, dans l'ordre des points de compilation :**

1. `chargesort.pas` — `StructureSortTalent` (CodeSort / ListeTalent / Livre), `TListSortTalent`,
   `ListSortTalent`, `NbSortTalent`, et **`TalentsDuSort(const PSort: StructureSort): String`**,
   qui concatène le champ `<Talent>` et les lignes de la table sans doublon. Signature par
   record et non par code : cinq des six appelants ont déjà leur `PSort`, ce qui évite une
   recherche dans la boucle de `SortAffiche`.
2. `warhammersource.pas` — `TListSortTalent.Create` et, surtout, `ListSortTalent.Clear` au
   même endroit que celui qui avait été oublié pour `ListSort` jusqu'au 21/08.
3. `chargeconstantes.pas` (`ConstXmlDataSpellTalent`) et `xmlexportimport.pas` — chargement
   après le bloc Sorts, export après le bloc Sort. **Piège traité à l'export** : le sort cité
   peut appartenir à un autre livre, donc c'est `PSortTalent.Livre` qui décide où la ligne
   part, et le code n'est **pas** repassé par `ChercheSort` / `XmlCreeCodeLivre` — il est déjà
   complet. Sans ça, l'export aurait réattribué les lignes au livre du sort.
4. Les **six** points de lecture — et non deux comme l'annonçait la conception : `TalentSort`
   et la boucle `ModeSort = AUTO` (`winpersonnage.pas`), le filtre par talent, le test
   d'accessibilité et la colonne 9 (`winspell.pas`). Le sixième, `TabSpellSelection`, se règle
   tout seul : il relit la colonne 9, qui contient désormais la liste complète.
   Dans `TalentSort`, le garde `PSort.ListeTalent = ''` devenait faux — un sort sans `<Talent>`
   mais servi par la table sortait trop tôt ; il porte maintenant sur le résultat de
   `TalentsDuSort`.
5. Les données : les 19 bénédictions migrées dans `BOOK_RULESBOOK.Xml` **et** dans
   `BOOK_RULESBOOK_FRANCAIS.Xml` (ce dernier n'est pas chargé dans `ListSort`, le garde
   `LangueDef = ConstAnglais` s'en charge, mais y laisser l'ancienne forme aurait fait croire
   qu'elle fait foi), puis le bloc de Nations.

**Résultat côté Nations** : 16 bénédictions concernées, **7** dieux, 42 couples, et **zéro
ligne ajoutée au Rulebook** — ce qui était tout l'objet du chantier. Sept et non six : la
**Dame de Bretonnie** (`RULES-T0012_LADY`) était déclarée depuis le lot 1 mais n'accordait
aucune bénédiction ; le livre les liste p.9 sous « Blessings of the Lady ». Trou du lot 1,
refermé ici. Testé par Nono sur un personnage de la Dame : les six bénédictions arrivent.

**Reste ouvert** : `PoolTalent` sur un personnage portant **deux** dieux — le cas que le
modèle ne rencontrait jamais avant, donc jamais éprouvé. À vérifier le jour où un tel
personnage existe.

---

### 2.40 Les bénédictions n'arrivaient jamais quand on choisissait le dieu après coup — corrigé (03/09/2026)

**Bug antérieur au §2.39, révélé par lui.** Nono crée un prêtre, prend `Bless`, choisit
Sigmar : aucune bénédiction. `SUBCHAPTER_SPELL` vide dans le fichier sauvegardé.

**La chaîne réelle**, qu'il faut avoir en tête avant de chercher :

`SortAffiche` remplit `TabSort` → `MajTables` (l.~4628) recopie `TabSort` dans
`TabEquipement`, la fiche.

C'est le souvenir de Nono — « les bénédictions ne sont pas ajoutées lors de l'update
sheet ? » — qui a fermé le diagnostic : `MajTables` **n'ajoute rien**, il ne fait que
reporter. Un `TabSort` vide au moment de la validation donne une fiche vide, et le défaut
ne pouvait donc être qu'au remplissage.

**La cause.** `SortAffiche` n'était appelée qu'à l'édition d'une cellule de la table
d'augmentation (l.~2722 et l.~3593). L'ordre naturel des gestes est : saisir le `1` dans
la colonne « Nouveau », **puis** double-cliquer pour choisir le dieu. Au seul appel,
`ColAugmTalSpeSel` était donc encore vide et `Tal` valait le code générique
`RULES-T0012_*`, qui ne correspond à aucune bénédiction — elles citent le dieu. Rien ne
rappelait `SortAffiche` après le choix.

**La correction** : un appel à `SortAffiche()` en fin du bloc de choix de spécialisation
de `TabAugmentationTalentDblClick` (bloc « D », après le C qui propage au tableau métier).

**Même famille que le §2.18**, mais sur l'autre axe : là il s'agissait de *lire* le bon
code, ici de le lire *au bon moment*. Le correctif vaut pour tous les talents à
spécialisation portant un `SpellMode` — `Invoke (…)` et `Arcane Magic (…)` étaient dans le
même cas, en mode CHOICE.

**Reste ouvert, et c'est un autre chantier** : un talent de bénédiction posé **à la
création** n'accorde toujours rien. `SortAffiche` ne regarde que les lignes où
`Nouveau > Actuel`, or `MajTables` (l.~4434-4467) écrit `Nouveau := Actuel` pour tout
talent déjà possédé. Les bénédictions devraient découler du talent **possédé**, pas du
talent acheté ce tour-ci. Noté dans `A FAIRE.txt`.

---

### 2.41 Les « Trait (Any) » des ethnies — terminé (03/09/2026)

**Le besoin.** Les pages 3-4 de *Nations of Mankind* donnent à chaque nation un dernier talent
qui n'en est pas un : `Provincial Trait (Any)`, `Dukedom Trait (Any)`, `City State Trait (Any)`,
`Clan Trait (Any)`, `Region Trait (Any)`, `Kingdom Trait (Any)`. Chacun renvoie à une sous-liste
de la même page — « •Northern Kislev : Night Vision, One Random Talent » — soit **un choix parmi
N groupes de talents**, une soixantaine de sous-entrées sur les dix ethnies du lot 3a. Le modèle
sait écrire un choix entre deux talents (`A/B`) et un talent aléatoire (`RULES-T*`), pas ça.

**Pourquoi une table à part, et pas un champ de l'ethnie** (idée de Nono, 03/09/2026) — deux
raisons données par le livre lui-même :
- **une même liste sert plusieurs ethnies** : les *Provincial Traits* de Kislev sont cités par
  Gospodar et par Ungol ; Sartosa apparaît dans les *City State Traits* d'Araby et dans les
  *Region Traits* d'Estalia. Dans le bloc de l'ethnie, on recopie ; dans une table, on cite ;
- **un trait n'est pas un talent** : une option en accorde deux ou trois (« Nan-Gau :
  Craftsman (Engineering) ou Warrior Born, **plus** deux talents au hasard »). Aucun `<Talent>`
  ne sait faire ça.

**La forme retenue.** Un bloc `DATA_SPECIE_TRAIT` que n'importe quel livre peut porter, cité
depuis `SUBCHAPTER_TALENT` exactement là où un talent l'est aujourd'hui :

```xml
<DATA_SPECIE_TRAIT>
<SpecieTrait id="NATIO-TRAIT_KISLEV">
<Description language="ENGLISH">"Provincial Trait"</Description>
  <Option id="NATIO-TRAIT_KISLEV_NORD">
  <Description language="ENGLISH">"Northern Kislev"</Description>
  <Talent>"RULES-T0164"</Talent>               <!-- Night Vision -->
  <Talent>"RULES-T*"</Talent>                  <!-- One Random Talent -->
  </Option>
  <Option id="NATIO-TRAIT_KISLEV_ERENGRAD">
  <Description language="ENGLISH">"Western Kislev (Erengrad)"</Description>
  <Talent>"RULES-T0085/RULES-T0119"</Talent>   <!-- Old Salt or Sea Legs -->
  <Talent>"RULES-T*"</Talent>
  </Option>
</SpecieTrait>
</DATA_SPECIE_TRAIT>
```

**La balise s'appelle `SpecieTrait`, pas `Trait`** — relevé par Nono le 03/09/2026 à la
compilation : `ConstXmlTrait` = `'Trait'` existe depuis le §2.15, c'est le drapeau
« trait de créature » d'un talent. Deux notions sans rapport ; garder le même nom aurait
donné une déclaration en double, et surtout une balise dont le sens dépend du parent —
la forme même du piège du §0 (« chercher un nom de balise et le trouver ailleurs qu'on
croit »). Les constantes sont `ConstXmlSpecieTrait` et `ConstXmlTraitOption`.

**Une option porte UNE balise `<Talent>`, liste séparée par des virgules** — et non une
balise par talent comme le disait la première rédaction de cette section. Même forme que
`DATA_SPELL_TALENT`, ce qui rend l'aller-retour import/export exact sans code de fusion ;
on y perd le commentaire par talent.

Les formes existantes se réemploient **telles quelles** à l'intérieur d'une option : `A/B` pour un
choix, `RULES-T*` pour un aléatoire. Rien de nouveau sous le niveau de l'option.

**Ce que le code demande — moins qu'attendu, parce que le moteur est déjà hiérarchique.**
Vérifié dans `ReconstruitChoixCreation` (`wincreation.pas` l.3241) avant de proposer quoi que ce
soit : `StructureChoixCreation` porte déjà `CodeParent` et `Rang`, l'étape 4 engendre déjà des
lignes filles à partir d'un choix fait, et le routage Choix / Aléatoire se fait déjà sur la nature
du code obtenu. Ce n'est donc pas une refonte mais une extension en trois points :

1. **Lecture** : bloc `DATA_SPECIE_TRAIT`, structure mémoire, `ChercheTrait` — même patron que
   `DATA_SPELL_TALENT` du 03/09 (§2.39), y compris le piège de l'export : sans structure mémoire
   ni bloc d'export dédiés, la première sauvegarde depuis WinLivre effacerait le bloc.
2. **Racine** : à l'étape 2, un code de trait cité dans `SUBCHAPTER_TALENT` devient une ligne du
   tableau Choix dont les options sont les provinces.
3. **Le seul vrai changement** : l'étape 4 engendre aujourd'hui **une** ligne fille au plus ; une
   option de trait en engendre **deux ou trois**. `Rang` existe déjà pour distinguer deux lignes
   filles de même source (bug du Skink, §2.15), donc le terrain est préparé.

La conception du 06/08 (`CONCEPTION_creation_choix_talents.md`) prévoyait qu'il ne resterait qu'un
cas de cascade, `RULES-T*` en option d'un choix. Le trait en ajoute un second, du même genre.

**Tranché par Nono le 03/09/2026 :**
- **libellé fidèle au livre** — la ligne s'affiche « Provincial Trait », pas « Province d'origine » ;
- **le trait est un objet de livre, pas d'ethnie** : `NATIO-TRAIT_KISLEV` est un identifiant de
  premier rang, comme un talent, et plusieurs ethnies le citent ;
- **« One Random Roll » et « One Random Talent » sont la même chose** — le livre écrit les deux
  (Ind, Tilea) ; saisir un `RULES-T*` dans les deux cas.

**Appliqué le 03/09/2026, en quatre points de compilation**, dans l'ordre qui avait marché le
02/09 : les structures et la lecture XML d'abord (compile, ne change rien), les données
ensuite (inertes), puis le branchement.

1. **Structures et XML** — `chargeconstantes.pas` (`ConstXmlDataSpecieTrait`,
   `ConstXmlSpecieTrait`, `ConstXmlTraitOption`), `chargerace.pas` (`StructureTrait`,
   `StructureTraitOption`, `ChercheTrait`), `warhammersource.pas` (création/vidage des deux
   listes), `xmlexportimport.pas` (lecture **et écriture**).
2. **Données** — `BOOK_NATIONS_OF_MANKIND.Xml` : `NATIO-TRAIT_KISLEV` et ses quatre options,
   cité par Kislev (Ungol) dans son `SUBCHAPTER_TALENT`.
3. **Affichage et choix** — `ChercheTraitOption` et `OptionsDuTrait` (`chargerace.pas`, même
   contrat que `ListeTalent` : liste toujours créée, à libérer par l'appelant, ce qui permet
   aux appelants d'écrire l'une ou l'autre) ; la racine et le libellé dans `wincreation.pas` ;
   les options proposées dans `winspecialisation.pas`.
4. **Cascade et consommation** — `wincreation.pas` : une option engendre N lignes filles,
   l'option elle-même n'est pas consommée comme un talent, et le double-clic est neutralisé
   sur une ligne dont la source est un talent concret.

**Trois pièges rencontrés, tous de la même famille : un troisième chemin qu'on n'avait pas
regardé.**

- **`ConstXmlTrait` existait déjà** (§2.15, le drapeau « trait de créature » d'un talent).
  Relevé par Nono à la compilation. La balise du trait d'ethnie s'appelle donc `SpecieTrait` :
  renommer la seule constante aurait laissé une balise dont le sens dépend du parent.
- **WinRaces a son propre arbre** (`ChargeRaceTalent`, `winraces.pas` l.419), qui n'a rien à
  voir avec les tableaux de WinCreation. Un code de trait n'ayant pas de `/`, il tombait dans
  la branche « choix unique » et affichait **une puce vide**. Signalé par Nono, capture à
  l'appui. Le trait y est maintenant une sous-branche, sur le modèle de la branche « au choix ».
- **`ChargeSpecialisation` bascule sur le catalogue COMPLET des talents** dès qu'un code n'a ni
  `/` ni `_*`. Sans garde, le double-clic sur un talent accordé sec par une province aurait
  laissé le joueur le remplacer.

**Demande de Nono, faite dans la foulée** : cliquer un trait ou une province dans WinRaces
affiche à droite les talents correspondants, et un talent aléatoire y déroule sa table de D100
via `DescriptionTalent` — la même fonction que partout ailleurs dans cette fenêtre. Le repérage
s'y fait sur la **donnée du nœud** et non sur `Node.Parent.Text`, dont le routage ne pouvait pas
marcher pour une option (son parent est le libellé du trait).

Au passage : `RULES-T*` **a** un libellé, « Random Talent », défini dans le Rulebook. Le
`LAB_xxx` un moment envisagé pour lui n'a pas lieu d'être.

**Suite donnée le 04/09/2026** : les dix ethnies restantes ont été écrites (§2.37), et six
tables `SpecieTrait` de plus sont venues s'ajouter à `NATIO-TRAIT_KISLEV`. La table à part a
tenu ses deux promesses : Gospodar **cite** la table de Kislev sans la redéclarer, et les deux
Bretonnia partagent celle des duchés.

---

### 2.42 `DATA_RACE` était lu et jamais exporté — corrigé (04/09/2026)

Bug relevé le 03/09 en écrivant l'export de `DATA_SPECIE_TRAIT`, corrigé le 04/09.
`ListEspece` n'apparaissait nulle part dans l'écriture de `xmlexportimport.pas` : exporter un
livre lui aurait fait perdre son bloc de races. Même piège que le §2.39, mais antérieur à ce
chantier-là. Corrigé par une déclaration `PEspece: StructureEspece;` dans `XmlExportBook` et un
bloc d'export inséré **avant** `DATA_SPECIE`, dans le même ordre qu'à la lecture ; il écrit
`<Race id>` avec `Description` et, seulement s'il est renseigné, `PictureLevel`.

**Ce que la correction a mis au jour, et qui compte plus que le bug** : `XmlExportBook`
**n'est appelée nulle part**. Tout le chemin d'export est du code mort aujourd'hui, ce qui
explique qu'un bloc manquant ait pu passer inaperçu si longtemps. La correction est donc en
place et **non testable** : le seul contrôle possible est la compilation.

**Pourquoi l'export n'est pas branché tout de suite (décision Nono, 04/09/2026)** : WinLivre
n'affiche pas encore toutes les données d'un livre, et un export écraserait ce que l'écran ne
sait pas montrer. Le préalable est donc de compléter l'affichage/édition de WinLivre — pas
d'ajouter un bouton. Et **avant** de brancher l'export : croiser la liste des `ConstXmlData*`
lus avec ceux écrits, pour attraper d'un coup tous les blocs dans le cas de `DATA_RACE`
(item dans `A FAIRE.txt`).

---

### 2.43 Les compétences « A ou B » n'apparaissaient pas dans WinRaces — corrigé (04/09/2026)

Signalé par Nono, capture à l'appui, en vérifiant les nouvelles ethnies : Araby affichait
**deux puces vides** dans sa liste de compétences, aux places exactes de
`Language (Indan or Wastelander)` et `Ride (Camel or Horse)`.

**Ce n'était pas la donnée.** `ChargeRaceCompetence` (`winraces.pas`) appelait
`ChercheCompetence` sur le code entier `A/B`, qui ne résout rien, d'où un libellé vide. Le côté
**talents** gérait ce cas depuis longtemps — sous-branche « Au choix », une feuille par
talent — mais le côté **compétences** ne l'avait jamais fait. Le défaut est **antérieur** aux
ethnies : le Skink de Lustria porte déjà un code de ce genre, et devait afficher la même puce
vide sans que personne ne le remarque. Corrigé en reprenant telle quelle la forme des talents.

**Puis un access violation, en cliquant la pastille « Au choix » elle-même.** La sous-branche
est un nœud **sans `Data`**, et son parent est bien `ConstArbreCompetence` : elle entrait donc
dans le nouveau bloc et déréférençait `nil`. La branche talent avait déjà son garde
`if Node.Text <> ConstArbreAuChoix` ; il n'avait pas été repris. **La leçon : quand on recopie
une forme qui marche, recopier aussi ses gardes** — c'est le garde, pas la forme, qui porte le
cas limite déjà rencontré.

**Et le routage du clic.** La feuille se retrouvant sous « Au choix », son parent n'est plus
`ConstArbreCompetence` et elle serait tombée dans la branche **talents** (`ChercheTalent` sur
un code de compétence). Le test regarde donc aussi le grand-parent, et passe avant le cas
talent. Troisième occurrence du même piège en deux jours : **un aiguillage sur
`Node.Parent.Text` ne survit pas à l'ajout d'un niveau dans l'arbre** (§2.41).

---

### 2.44 `DATA_CAREER_BONUS` — l'appartenance greffe des données sur une carrière — table et fiche EN PLACE, lecture à brancher (04/09/2026)

C'est la réponse à la question laissée ouverte au 3d-2 du §2.37 (« carrière dérivée ou
greffon ? »). **Greffon**, et le livre le dit lui-même p.6 : « All Lore Skills and Talents
granted to the soldier by their Regiment are treated **as if added to their Career** and may
be purchased and advanced as normal ». Une carrière dérivée aurait dupliqué quatorze fois
les quatre tableaux d'avance du Soldier pour changer une ligne.

**Le modèle, formulé par Nono le 04/09** : un élément complémentaire qui **nécessite une
ethnie et un métier**, et qui, **suivant le niveau**, donne accès à une donnée supplémentaire
en plus des compétences et talents normaux. Le livre pose exactement ces deux conditions
p.6 : « granted to those who select the **Soldier Career** » et « your character must
originate from the Empire and their **respective Province** ».

**Pourquoi une table nouvelle et pas `DATA_SPECIE_TRAIT` (§2.41) — décision Nono.** « Les
Reiklander existent depuis le RULEBOOK et je ne voudrais pas avoir à modifier cette table
pour une option de fanbook. » C'est le raisonnement qui avait déjà produit
`DATA_SPELL_TALENT` au §2.39 : un bloc **additif**, porté par le livre qui l'apporte, qu'un
autre livre n'a jamais à retoucher, et qui se retire de lui-même si son livre n'est pas
chargé — donc aucune référence pendante pour le contrôle d'intégrité du §2.20.
`DATA_SPECIE_TRAIT` ne connaît d'ailleurs ni le métier ni le niveau.

**La table ne doit pas s'appeler « régiment ».** La même structure porte les ordres de
chevalerie du 3d-3 (sur la carrière Knight) et vraisemblablement les cultes
d'*Initiations and Cult Skills*. D'où un nom générique, `DATA_CAREER_BONUS`.

Forme retenue, dans le style du projet (`XmlDebutCode` / `XmlLigne` / `XmlFinCode`, pas
d'attributs multiples — voir l'écart du §2.39 point 1) :

```xml
<DATA_CAREER_BONUS>
<Bonus id="NATIO-REGIM_AVER">
<Name>"Averland State Army"</Name>
<Career>"RULES-WORK41"</Career>          <!-- Soldier, code a confirmer -->
<Specie>"NATIO-RACE_AVERLAND"</Specie>   <!-- vide = aucune condition d'origine -->
<Level1><Competence>"..._AVERLAND"</Competence></Level1>
<Level2><Talent>"..."</Talent></Level2>
<Level3><Competence>"..._DWARFS/..._GREENSKINS"</Competence></Level3>
<Level4><Talent>"..."</Talent></Level4>
</Bonus>
</DATA_CAREER_BONUS>
```

Le « A ou B » du palier Sergeant passe par le séparateur multi `/`, que le §2.43 vient de
faire fonctionner dans WinRaces. `<Specie>` vide vaut « ouvert à tous » : **validé par Nono
le 04/09**, c'est le cas de Marienburg, que le livre dispense explicitement de la condition
d'origine (« with the exception of Marienburg who hires anyone »).

**Les quatre régiments de villes** (Altdorf, Nuln, Talabheim, Marienburg) n'ont pas d'ethnie
au 3d-1, qui n'a saisi que des provinces. Décision : on met l'ethnie de la province mère,
que le livre désigne lui-même par le `Lore` qu'il accorde — Altdorf → Reikland, Nuln →
Wissenland, Talabheim → Talabecland ; Marienburg reste sans condition.

**Ce que la table ne porte pas, et qui est le vrai coût du chantier.** Contrairement à
`DATA_SPELL_TALENT`, qui était en lecture seule, « ce personnage appartient au régiment
d'Averland » est une **donnée de la fiche** : champ nouveau dans `chargepersonnage.pas` et
`xmlexportimport.pas`, plus un endroit pour le choisir dans WinPersonnage. Le livre ajoute
une règle de persistance qui interdit de déduire l'appartenance de la carrière courante :
« If you leave your Regiment under any conditions, such as being discharged or changing
Careers, you maintain all additional Skills and Talents. »

**Les Regiments of Renown (11) ne rentrent PAS dans ce moule tel quel** et sont à traiter
après les quatorze provinciaux. Trois écarts : la condition est le **niveau 3 atteint** et
non l'ethnie seule ; l'effet comprend des **trappings** (de l'équipement, que le greffon
compétence/talent ne porte pas) ; et le livre y ajoute un effet de règle que le modèle ne
sait pas dire (« votre rang 3 est ramené à Soldier mais votre statut social reste celui du
3 »). Même famille que les psychologies et le 3d-3.

**Avant la saisie** : passer au contrôle de collision les `Lore (…)` cités par les
régiments — Blackpowder, Taxes, Armory, Westerland, Riverways, Empire, Morr, Undead,
Manann, Sigmar, Ulric, Taal, Beastmen, Norscans, Greenskins, Dwarfs — **sur la nature
ajoutée** (spécialisations de compétence), et pas seulement sur les objets qu'ils citent :
c'est la règle du §0 née des trois doublons d'ethnies du 04/09.

**Coquille du livre relevée** : le palier Sergeant de Stirland est imprimé « Death Jacks: »
au lieu de « Sergeant: » (p.6).

---

**CE QUI A ÉTÉ FAIT LE 04/09/2026 — trois points de compilation, tous verts.**

*Point 1, les structures.* `chargeconstantes.pas` : `ConstXmlDataCareerBonus`
(`'DATA_CAREER_BONUS'`) et `ConstXmlCareerBonus` (`'CareerBonus'`) — toutes les autres
balises existaient déjà (`Description`, `Career`, `Specie`, `Level`, `Skill`, `Talent`,
`id`), et le **numéro** du palier réutilise `ConstXmlOrder`, `'Level'` servant déjà de nom à
la balise du palier. `chargemetier.pas` : `StructureCareerBonus` et
`StructureCareerBonusNiveau`, leurs deux `TList`, `ChercheCareerBonus` (avec le `Default()`
du §2.17) et `NiveauxDuCareerBonus`, dont **l'appelant est propriétaire de la liste rendue**,
même contrat que `OptionsDuTrait`. `warhammersource.pas` : les deux `Create` et les deux
`Clear`, pas de `Free` (aucune liste du projet n'en a).

*Point 2, l'aller-retour XML.* Import **et** export dans la même passe de
`xmlexportimport.pas`, juste après `DATA_SPECIE_TRAIT`, plus les deux variables locales dans
les `var` des deux procédures. Le libellé passe par `XmlLigneLangue(ConstXmlDescription, …)`
comme tout libellé traduisible du projet, d'où `ConstPCareerBonus` pour `InitTrad`.

*Point 3, la fiche.* `chargepersonnage.pas` : le champ `Appartenance: String` dans
`StructurePersonnage` (codes de `CareerBonus` séparés par des virgules), écrit après
`OPTIONS` et relu sous `ConstXmlAppartenance` (`'MEMBERSHIP'`), **remis à vide avant le test
`Assigned`** pour que les fiches enregistrées avant ce jour se rechargent sans erreur.

*Premier régiment saisi*, comme cas d'essai : `NATIO-REGIM_AVER` « Averland State Army »
dans `BOOK_NATIONS_OF_MANKIND.Xml`, `Career` = `RULES-WORK57` (Soldier du Rulebook),
`Specie` = `NATIO-RACE_HAVER`, quatre paliers, le palier 3 portant le choix
`RULES-COMPSAVOIR_NAIN/RULES-COMPSAVOIR_GREENSKIN`. A demandé une spécialisation nouvelle,
`RULES-T0136_DWARFS` « Etiquette (Dwarfs) », absente de tout `DATABASE\` (collision
vérifiée avant écriture). **Le livre charge sans erreur.**

---

**LA LECTURE EST BRANCHÉE ET ÉPROUVÉE (04/09/2026, après-midi).**

*La bifurcation de conception, et c'est Nono qui l'a vue.* La première tentative calculait les
greffes **à l'affichage**, dans `XmlChargePersonnage`. Elle a été écrite, compilée, puis
**retirée** : question de Nono, « on a les talents dans le XML, pourquoi ne pas simplement les
y ajouter au choix de la carrière ? ». L'argument décisif est que dans ce projet, « être une
compétence de carrière » ne se joue pas dans la grille mais dans `Personnage.MetierCompetence`,
qui alimente `CalculTableExperience` — donc les tables d'avance, le coût XP et le PDF. Une
greffe posée seulement dans `TabCompetence` s'affiche mais n'est pas achetable au tarif de
carrière : elle ne serait pas « as if added to their Career ». En l'écrivant dans la fiche,
tout le reste marche sans qu'aucun écran n'ait à connaître les appartenances.

Deux conséquences de cette bascule, à ne pas reperdre :
- la règle de persistance du livre (« si tu quittes ton régiment, tu gardes tout ») devient
  l'état naturel de la donnée au lieu d'une exception à coder ;
- **rien ne marque qu'une ligne vient d'un régiment, et c'est assumé** (décision Nono) :
  retirer une appartenance ne se fait pas, et de toute façon une compétence où de l'XP a été
  dépensé reste sur le personnage, en « hors carrière ».

*Ce qui a été écrit.* `PersonnageAppliqueGreffes(var Personnage: StructurePersonnage)` dans
`chargepersonnage.pas`, juste avant `PersonnageTalentAsterisque` — cette unité possède
`StructurePersonnage` et utilise déjà `ChargeMetier`, donc aucun `uses` à toucher. Elle ajoute
dans `MetierCompetence` et `MetierTalent` les éléments de chaque palier, **avec `Valeur` = le
numéro du palier**. `GreffesDesAppartenances` reste dans `chargemetier.pas` mais n'est plus
appelée par personne : à supprimer ou à garder pour un usage en lecture seule, non tranché.

*Le point d'accroche, et pourquoi il n'y en a qu'un.* `winpersonnage.pas`, dans le bloc
`if StrToInt(NvNiveau) = 1` du changement de carrière (vers l. 4705), **après** les deux
boucles qui reconstruisent `MetierCompetence` et `MetierTalent` — placé avant, il serait
effacé par leur `:= []`. Découverte qui a simplifié tout le chantier : ces deux listes ne sont
reconstruites **qu'à l'entrée dans une carrière**, et remplies d'un coup pour les quatre
niveaux, chaque entrée portant son niveau en `Valeur` ; c'est `CalculTableExperience` qui
filtre ensuite sur `Valeur <= niveau courant`. Donc **aucun crochet à chaque passage de
niveau** n'est nécessaire.

*Éprouvé.* Personnage « solder Aver 2 », Humans (Averland), `MEMBERSHIP` = `NATIO-REGIM_AVER`,
Soldier → Advisor → Soldier. Le XML sauvegardé porte exactement les trois lignes attendues :
`RULES-COMPSAVOIR_AVERLAND` en valeur 1, `RULES-T0136_DWARFS` en valeur 2, `RULES-T0028` en
valeur 4. Le palier 3 est absent — voir juste en dessous.

*Deux faux bugs rencontrés pendant le test, tous deux des symptômes attendus.* (1) Une fiche
créée par WinCreation a `MEMBERSHIP` vide : WinCreation ne remplit pas le champ et n'appelle
pas la procédure. (2) Une valeur saisie à la main dans le XML a disparu : la fiche était déjà
chargée en mémoire quand le fichier a été édité, et la sauvegarde a réécrit le champ vide.
**Corollaire de méthode** : avant de diagnostiquer, vérifier la date de l'EXE. Ce jour-là,
`WarhammerHelp.exe` datait de 11:42 et les deux unités modifiées de 13:08 et 13:13 — le
programme testé ne contenait pas le code discuté.

**POINTS DE REPRISE, dans l'ordre :**

1. **Retirer les deux tests `if Pos(SeparateurMulti, Code) > 0 then continue;`** de
   `PersonnageAppliqueGreffes`. Ils sautent les éléments à choix `A/B` par prudence, or Nono a
   vérifié ce jour que **le tableau des compétences sait déjà résoudre un choix** : Play (Drum
   or Fife) se choisit dans la grille et le niveau suit. Le palier 3 d'Averland apparaîtra
   alors normalement, sans écran ni champ supplémentaire. **À vérifier avant** : le tableau des
   TALENTS sait-il faire la même chose ? Le palier 3 est une compétence, mais d'autres
   régiments auront des talents à choix.
2. **L'écran de choix de l'appartenance.** Rien ne remplit `Personnage.Appartenance` : il faut
   le saisir à la main dans le XML. L'écran a sa place dans WinCreation autant que dans
   WinPersonnage, puisque c'est à la création que l'ethnie et le métier — les deux conditions
   de la table — sont choisis.
3. **Brancher WinCreation**, qui bâtit ses propres listes et n'appelle pas la procédure.
4. **La saisie mécanique des treize régiments restants**, puis le 3d-3.

**Bug voisin découvert au passage, antérieur au chantier et noté dans `A FAIRE.txt`** :
revenir dans une carrière déjà exercée redonne l'équipement de départ en double, et sans
libellé (le code brut s'affiche en Description, « Various » en Kind). Boucle « Équipement » du
changement de carrière, `winpersonnage.pas` vers l. 4675 : elle n'écrit ni la colonne du
libellé, ni ne teste le doublon.

---

## 3. TODO / Backlog

Le backlog complet (tout ce qui n'est pas encore commencé) vit dans `A FAIRE.txt`
(fichier déjà existant dans le projet), pas ici — pour pouvoir y ajouter une ligne à
tout moment sans toucher à l'état détaillé des chantiers ci-dessus. Dès qu'un item
d'`A FAIRE.txt` passe en travail actif, il migre dans la section "en cours" du
chantier concerné, avec les détails techniques.

---

## 4. Pièges Lazarus / Free Pascal accumulés

- **Ne jamais appeler une primitive « sur toute l'image » à l'intérieur d'une boucle qui
  parcourt déjà toute l'image.** `RemplacerPixelParTransparent` (`pdfutils.pas`) appelait
  `Img.ReplaceColor` pour chaque pixel de fond rencontré, et `ReplaceColor` reparcourt le
  bitmap entier. Le piège était doublé par une asymétrie : le test de couleur avait une
  **tolérance** alors que `ReplaceColor` exige la couleur **exacte**, donc chaque pixel
  d'anti-aliasing survivait au remplacement, re-matchait, et déclenchait un balayage
  complet de plus. Des centaines de balayages pour une icône. Réécrit le 31/08/2026 en un
  seul passage : quelques millisecondes.
- **`img.Colors[x, y]` est un accesseur coûteux**, pas un accès mémoire. C'est l'interface
  `TFPColor` de FPImage : chaque lecture convertit le pixel BGRA en quatre canaux 16 bits.
  Le lire une fois par canal dans une comparaison le fait donc payer quatre fois. Pour
  parcourir une image, passer par `ScanLine[y]`, qui rend un `PBGRAPixel` sur la ligne —
  et parcourir en **lignes**, pas en colonnes : les données sont rangées en lignes.
- **Après une écriture directe via `ScanLine`, `Img.InvalidateBitmap` est obligatoire.**
  BGRABitmap garde une copie LCL du bitmap ; sans invalidation elle n'est pas reconstruite
  et `SaveToFile` peut écrire l'image d'AVANT les modifications. Panne silencieuse : aucune
  erreur, juste un fichier inchangé.
- **Attention aux échelles de couleur qui se mélangent.** `TFPColor` va de 0 à 65535,
  `TBGRAPixel` de 0 à 255, et la conversion est un facteur **257** (pas 256). Un seuil de
  tolérance écrit en pensant au 0-255 mais appliqué à du 16 bits est 257 fois trop serré —
  c'était le cas du `MaxDiff = 2000` de l'ancien `TestCouleur`, soit 3 % et non 2000.

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

### Un nom de variable n'est pas une preuve de ce qu'elle lit

Trouvé le 02/09/2026. `XpSortCout` calculait le tarif arcanique à partir de `BI`, qu'on lit
naturellement « Bonus Intelligence ». `BI` lisait `TabAttribut.Cells[ColAttI]` — colonne 6,
`ATTR_I`, l'**Initiative**. L'Intelligence est `ColAttInt`, colonne 9, `ATTR_Int`. Le bug a
survécu des années à des relectures du code parce que la ligne *se lit juste*.

Le projet est structurellement exposé : **les identifiants sont en anglais, les variables en
français**, et plusieurs paires ne se distinguent que par trois lettres — `ATTR_I` /
`ATTR_Int`, `ATTR_S` / `ATTR_Supp`, `ATTR_T` / `ATTR_Fate`. Quand une valeur numérique sort
d'une grille ou d'un dictionnaire, **remonter jusqu'au code de la colonne** avant de croire
le nom de la variable qui la reçoit. Ce contrôle ne coûte qu'un `grep` sur la déclaration.

### Contrôle systématique des tables de tirage, et arbitrage des orphelins

Toute table de tirage (`DATA_CAREER_ROLL`, tables de sous-métiers, tables de corruption) est
vérifiée **avant saisie** : chaque colonne doit couvrir **01-100 exactement une fois**, sans trou
ni chevauchement. Ce contrôle a trouvé **dix coquilles d'édition** dans les livres officiels — il
en trouve à peu près une par table.

⚠️ Une valeur orpheline est une **coquille du livre**, pas une erreur d'extraction : elle se
vérifie **à l'image** (`pdftoppm` sur la page, puis lecture du rendu) avant toute conclusion.
L'extraction texte d'un PDF en colonnes se trompe assez souvent pour que cette étape soit
obligatoire.

**Règle d'arbitrage, posée par Nono le 23/08/2026** — quand l'arithmétique ne tranche pas :

> La valeur orpheline va au voisin qui en a le **moins**. À égalité, elle va au **premier**
> (celui qui précède).

Exemple d'application : Sea of Claws p.57, *Agitator* 05-06 puis *Artisan* 08-10, le 07 orphelin
→ donné à *Agitator* (2 valeurs contre 3), qui devient 05-07.

Cette règle remplace le raisonnement au cas par cas utilisé jusque-là (Up in Arms p.9 :
*Handgunner* 76-85 retenu « parce que les tableaux voisins enchaînent 01-75 sur 76-00 »). Si un
cas résiste vraiment, le signaler plutôt que de trancher seul.

⚠️ **Piège d'écriture** : un commentaire XML ne peut pas contenir `--`. Un séparateur
`<!-- ----- Nom ----- -->` rend le fichier mal formé — utiliser `<!-- === Nom === -->`.

---


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
