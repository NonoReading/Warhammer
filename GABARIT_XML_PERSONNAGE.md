# Gabarit de reference : structure d'un XML de personnage (SAVED_CARACTERS/*.xml)

Ce fichier n'est PAS un des trois fichiers de suivi (CONTEXT.md/Log.txt/A FAIRE.txt) : c'est
une reference technique de structure XML, a consulter AVANT de modifier tout code qui touche
`StructurePersonnage`, `Personnage.*` ou le chargement/l'ecriture d'un XML de sauvegarde -
au lieu de deviner ce qu'un champ represente. Extension .md volontaire (pas .xml).

Ecrit le 26/09/2026 apres une session ou plusieurs corrections de suite (talents de carriere,
`Personnage.MetierTalent`) sont parties d'une lecture fausse de cette structure. Regle du
projet renforcee par cet episode : **lire ce fichier avant de toucher a un chapitre**, pas
seulement "verifier l'existant avant de concevoir" en general.

A METTRE A JOUR des qu'un nouveau `CHAPTER_*`/`SUBCHAPTER_*` apparait, ou si le role d'un champ
existant est mal compris puis corrige en session.

## Regle d'or : catalogue vs possession

Deux familles de donnees se ressemblent dans le XML mais n'ont RIEN a voir :

- **Ce que le personnage POSSEDE reellement** (compte dans les totaux, les bonus, l'affichage
  "talents/competences acquis") : uniquement `CHAPTER_CREATION` (choix de creation) et
  `CHAPTER_INCREASE` (achete en Xp, y compris un talent de carriere une fois REELLEMENT
  achete). Rien d'autre ne doit jamais alimenter un total ou un bonus.
- **Ce qui est un CATALOGUE/MENU** (ce qui est proposable, pas ce qui est pris) : `CHAPTER_SKILL`
  et le `SUBCHAPTER_TALENTCAREER` de `CHAPTER_TALENT`. Ces blocs recopient la table de la
  carriere EN COURS (tous paliers, cf. `ListMetierCompetence`/`ListMetierTalent`,
  `chargemetiercompetence.pas`/`chargemetiertalent.pas`) pour que l'ecran Augmentation sache
  quoi proposer a chaque palier - **jamais** pour dire "le personnage l'a deja". Un talent
  present ici peut ne JAMAIS avoir ete pris. Confirme par Nono le 26/09/2026 (chantier
  "Combat Master affiche comme acquis alors qu'il ne l'est pas").
  - Sert aussi a memoriser, pour un talent `_*`/choix multiple de cette table, quelle
    specialite a ete resolue (le code generique est remplace en place par le code precis
    une fois le choix fait, cf. `ChoixWinTalent`/`SelectWinTalent`, `winpersonnage.pas`).
  - En code : `Personnage.MetierCompetence`/`Personnage.MetierTalent`, reconstruits en
    ENTIER (tous paliers 1 a 4 d'un coup) au moment ou `Personnage.MetierEnCours` passe au
    niveau 1 d'une nouvelle carriere (`winpersonnage.pas`, bloc `if StrToInt(NvNiveau) = 1`).
    Le champ `Valeur`/`NiveauMetier` de ces deux listes porte le PALIER de la table ou
    l'entree apparait (1 a 4), jamais un nombre de rangs.

Erreur a ne plus refaire : boucler sur `Personnage.MetierTalent`/`Personnage.MetierCompetence`
pour additionner un total affiche ou un bonus de calcul. Toute somme/bonus vient uniquement de
`Personnage.CreationTalent`/`Personnage.CreationCompetence*` et
`Personnage.AugmentationTalent`/`Personnage.AugmentationCompetence`.

## Plan du fichier, chapitre par chapitre

```
PLAYER
├── Name / Specie / Age / Height... / Career / Level / Xp / Xp25 / CurrentXp
│     Career = code de la carriere EN COURS ; Level = palier atteint dans cette carriere.
│     Xp = total BRUT cumule (JAMAIS divise) ; Xp25 = Xp/25 si l'option est cochee ;
│     CurrentXp = Xp restant a depenser, dans l'unite courante (brute ou /25).
│
├── CHAPTER_CREATION                         -> choix faits A LA CREATION (possede, gratuit)
│   ├── SUBCHAPTER_ATTR                      -> Personnage.CreationAttribut
│   ├── SUBCHAPTER_SKILLSPECIE               -> Personnage.CreationCompetence35 (bonus d'espece)
│   ├── SUBCHAPTER_SKILLCREATION             -> Personnage.CreationCompetence40 (points de creation)
│   └── SUBCHAPTER_TALENT                    -> Personnage.CreationTalent (POSSEDE)
│
├── CHAPTER_INCREASE                         -> achete en Xp via l'ecran Augmentation (POSSEDE)
│   ├── SUBCHAPTER_ATTR                      -> Personnage.AugmentationAttribut
│   ├── SUBCHAPTER_SKILLCAREER               -> Personnage.AugmentationCompetence (rangs achetes)
│   └── SUBCHAPTER_TALENT                    -> Personnage.AugmentationTalent (rangs achetes, POSSEDE)
│
├── CHAPTER_SKILL                            -> CATALOGUE, PAS une possession
│   └── SUBCHAPTER_SKILLCAREER               -> Personnage.MetierCompetence (menu carriere en cours,
│                                                tous paliers, valeur = palier, PAS un rang)
│
├── CHAPTER_TALENT                           -> CATALOGUE, PAS une possession
│   └── SUBCHAPTER_TALENTCAREER              -> Personnage.MetierTalent (menu carriere en cours,
│                                                tous paliers, valeur = palier, PAS un rang ;
│                                                sert aussi a fixer la specialite d'un talent '_*')
│
├── CHAPTER_OLDCAREER                        -> Personnage.MetierAncien (carrieres precedentes,
│                                                Career name="CODE/instance", valeur = cout Xp)
│
├── CHAPTER_ITEM                             -> Personnage.Equipement, un SUBCHAPTER par type
│   ├── SUBCHAPTER_WEAPON / SUBCHAPTER_ARMOR / SUBCHAPTER_ARMOR_SET / SUBCHAPTER_MISC / SUBCHAPTER_SPELL
│         worn="1" = porte (PersonnageEquipement.Porte) ; sans worn = possede mais pas porte.
│
├── CHAPTER_CORRUPTION                       -> Personnage.Corruption (historique, texte libre)
├── CHAPTER_MUTATION                         -> Personnage.Mutations (reference au catalogue)
│
├── CHAPTER_TALENT_CAREER_LINK               -> Personnage.TalentCarriereRequise : talents dont
│         l'EFFET reste lie a une carriere+palier precis (ex. Virtue of the Quest, CONTEXT.md
│         2.78) - fige au moment de l'octroi, compare a la carriere en cours a l'affichage pour
│         barrer le talent sans le retirer. Vide si le personnage n'en a aucun (cas courant).
│         NE PAS CONFONDRE avec SUBCHAPTER_TALENTCAREER (nom proche, role totalement different).
│
├── BOOK / RULES                             -> liste des livres utilises par au moins un
│                                                element de la fiche (recalculee a l'ecriture)
│
├── CHAPTER_XP                               -> couts d'Xp hors barème standard, saisis a la main
│   └── SUBCHAPTER_ATTR / SUBCHAPTER_SKILL / SUBCHAPTER_TALENT   (ex. "RULES-ATTR_T:0-5")
│
├── OPTIONS                                  -> options cochees ([XpDiv25][PdfFeldo2P]...)
├── MEMBERSHIP / ADAPTATION_CHOICE / SUBCHAPTER_SKILLAPPARTENANCE
```

## Piege deja rencontre

`SUBCHAPTER_TALENTCAREER` (dans `CHAPTER_TALENT`) et `CHAPTER_TALENT_CAREER_LINK` ont des noms
qui se ressemblent enormement mais n'ont aucun rapport : le premier est un catalogue de menu
(peut lister un talent jamais pris), le second est une liste de talents REELLEMENT possedes
dont l'effet est conditionne a la carriere. Une lecture rapide du nom seul a deja fait confondre
les deux dans une session (26/09/2026) - toujours verifier la constante Pascal
(`chargeconstantes.pas`) et le tableau ci-dessus avant de coder sur l'un des deux.
