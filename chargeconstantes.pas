unit ChargeConstantes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Graphics, Controls, Grids, StdCtrls, Forms, lcltype, LCLIntf,
  ComCtrls, SysUtils, kgrids, fppdf, fpttf;

Const
      // séparateurs connus
      SeparateurMulti     	        = '/';
      Separateurtabulation              = #9;
      SeparateurRetourLigne             = #13#10;
      SeparateurChance                  = '-';
      SeparateurDetail                  = ':';
      SeparateurLivre                   = '-';
      ValeurSousCompetence		= '_';
      ValeurGenerique			= '_*';
      ValeurNonRenseignee               = '?';

      // Fichier XML de personnages
      ConstXmlRace			= 'Specie';
      ConstXmlWork			= 'Career';
      ConstXmlCarac			= 'Attribut';
      ConstXmlTalent			= 'Talent';
      ConstXmlCompetence		= 'Skill';
      ConstXmlNvWork			= 'Level';
      ConstXmlItem			= 'Item';
      ConstXmlXp			= 'Xp';
      ConstXmlXp25Total                 = 'Xp25';
      ConstXmlXpCurrent			= 'CurrentXp';
      ConstXmlName			= 'Name';
      ConstXmlPersonnage		= 'PLAYER';
      ConstXmlChapitreCreation		= 'CHAPTER_CREATION';
      ConstXmlChapitreAugmentation	= 'CHAPTER_INCREASE';
      ConstXmlChapitreCompetence	= 'CHAPTER_SKILL';
      ConstXmlChapitreTalent            = 'CHAPTER_TALENT';
      ConstXmlChapitreCoutXp            = 'CHAPTER_XP';
      ConstXmlSousChapitreCarac	        = 'SUBCHAPTER_ATTR';
      ConstXmlSousChapitreTalent	= 'SUBCHAPTER_TALENT';
      ConstXmlSousChapitreCompetence    = 'SUBCHAPTER_SKILL';
      ConstXmlSousChapitreCompMetier    = 'SUBCHAPTER_SKILLCAREER';
      ConstXmlSousChapitreTalMetier     = 'SUBCHAPTER_TALENTCAREER';
      ConstXmlSousChapitreCompSpecie    = 'SUBCHAPTER_SKILLSPECIE';
      ConstXmlSousChapitreCompCreation  = 'SUBCHAPTER_SKILLCREATION';
      ConstXmlChapitreOldWork		= 'CHAPTER_OLDCAREER';
      ConstXmlChapitreEquipement	= 'CHAPTER_ITEM';
      ConstXmlChapitreCorruption	= 'CHAPTER_CORRUPTION';
      ConstXmlChapitreMutation	        = 'CHAPTER_MUTATION';
      ConstXmlSousChapitreArme          = 'SUBCHAPTER_WEAPON';
      ConstXmlSousChapitreArmure        = 'SUBCHAPTER_ARMOR';
      ConstXmlSousChapitreArmureSimp    = 'SUBCHAPTER_ARMOR_SET';
      ConstXmlSousChapitreDivers        = 'SUBCHAPTER_MISC';
      ConstXmlSousChapitreSort          = 'SUBCHAPTER_SPELL';
      ConstXmlSousChapitreEquipement    = 'SUBCHAPTER_ITEM';
      ConstXmlSousChapitreNiveau        = 'SUBCHAPTER_LEVEL';
      ConstXmlSousChapitreRace          = 'SUBCHAPTER_SPECIE';
      ConstXmlData                      = 'name';
      ConstXmlCodeLivre                 = 'CODE_BOOK';
      ConstXmlLibelleLivre              = 'BOOK';
      ConstXmlVersionLivre              = 'VERSION';
      ConstXmlOfficielLivre             = 'OFFICIAL';
      ConstXmlCompletLivre              = 'COMPLETE';
      ConstXmlRegle                     = 'RULES';
      ConstXmlOptions                   = 'OPTIONS';
      ConstXmlDataBook                  = 'DATA_BOOK';
      ConstXmlDataAttributCost          = 'DATA_ATTRIBUT_COST';
      ConstXmlDataSkillCost             = 'DATA_SKILL_COST';
      ConstXmlDataAttribut              = 'DATA_ATTRIBUT';
      ConstXmlDataLabel                 = 'DATA_LABEL';
      ConstXmlDataTalent                = 'DATA_TALENT';
      ConstXmlDataTalentSpe             = 'DATA_TALENT_SPECIALIZATION';
      ConstXmlDataSkill                 = 'DATA_SKILL';
      ConstXmlDataSkillSpe              = 'DATA_SKILL_SPECIALIZATION';
      ConstXmlDataSpecie                = 'DATA_SPECIE';
      ConstXmlDataCareer                = 'DATA_CAREER';
      ConstXmlDataWeapon                = 'DATA_WEAPON';
      ConstXmlDataWeaponBonus           = 'DATA_WEAPON_BONUS';
      ConstXmlDataArmor                 = 'DATA_ARMOR';
      ConstXmlDataArmorSimplified       = 'DATA_ARMOR_SIMP';
      ConstXmlDataArmorBonus            = 'DATA_ARMOR_BONUS';
      ConstXmlDataSpell                 = 'DATA_SPELL';
      ConstXmlDataRandomTalent          = 'DATA_RANDOM_TALENT';
      ConstXmlDataSpecieCreation        = 'DATA_RANDOM_SPECIE';
      ConstXmlDataCraftsmanship         = 'DATA_CRAFTMANSHIP';
      ConstXmlDataSpecieCareerChoix     = 'DATA_SPECIE_CAREER_CHOICE';
      ConstXmlDataCareerSubChoice       = 'DATA_CAREER_SUBCHOICE';
      ConstXmlDataPhysicalCorruption    = 'DATA_CORRUPTION_PHYSICAL';
      ConstXmlDataMentalCorruption      = 'DATA_CORRUPTION_MENTAL';
      ConstXmlDataCorruptionTablePhys   = 'DATA_CORRUPTION_TABLE_PHYSICAL';
      ConstXmlDataCorruptionTableMent   = 'DATA_CORRUPTION_TABLE_MENTAL';
      ConstXmlDataCorruptionPhysChance  = 'DATA_CORRUPTION_PHYSICAL_CHANCE';
      ConstXmlDataCorruptionMentChance  = 'DATA_CORRUPTION_MENTAL_CHANCE';
      ConstXmlChance                    = 'Chance';
      ConstXmlLibelle                   = 'Libelle';
      ConstXmlEffet                     = 'Effet';
      ConstXmlDescription               = 'Description';
      ConstXmlExplanation               = 'Explanation';
      ConstXmlShort                     = 'Short';
      ConstXmlMax                       = 'Max';
      ConstXmlForPdf                    = 'PDF';
      ConstXmlTest                      = 'Test';
      ConstXmlEthnic                    = 'Ethnic';
      ConstXmlSousChapitreMetier        = 'SUBCHAPTER_CAREER';
      ConstXmlClass                     = 'Class';
      ConstXmlEquipement                = 'Item';
      ConstXmlArme                      = 'Weapon';
      ConstXmlDamage                    = 'Damage';
      ConstXmlDisponibilite             = 'Availability';
      ConstXmlPorteeArme                = 'Reach';
      ConstXmlPrix                      = 'Price';
      ConstXmlEncombrement              = 'Encumbrance';
      ConstXmlQualite                   = 'Quality';
      ConstXmlMains                     = 'Hand';
      ConstXmlMunition                  = 'Ammunition';
      ConstXmlArmure                    = 'Armor';
      ConstXmlArmureSimplifiee          = 'ArmorSimp';
      ConstXmlEmplacement               = 'Location';
      ConstXmlProtection                = 'ArmorPoint';
      ConstXmlType                      = 'Type';
      ConstXmlNiveau                    = 'Level';
      ConstXmlSalaire                   = 'Salary';
      ConstXmlBonus                     = 'BonusMalus';
      ConstXmlPositifNegatif            = 'Modifier';
      ConstXmlFabrication               = 'Craftsmanship';
      ConstXmlSort                      = 'Sort';
      ConstXmlPorteeSort                = 'Range';
      ConstXmlCible                     = 'Target';
      ConstXmlDuree                     = 'Duration';
      ConstXmlChoix                     = 'Choice';
      ConstXmlAlternative               = 'Alternative';
      ConstXmlId                        = 'id';
      ConstXmlAttribut                  = 'Attribut';
      ConstXmlOrder                     = 'Order';
      ConstXmlCout                      = 'Cost';
      ConstXmlTexte                     = 'Text';
      ConstXmlLabel                     = 'Label';
      ConstXmlLanguage                  = 'language';
      ConstXmlTypeSort                  = 'TypSpell';
      ConstXmlOptionXpDiv25             = 'XpDiv25';
      ConstXmlOptionFeldo2P             = 'PdfFeldo2P';
      ConstXmlOptionQuickArmor          = 'QuickArmor';
      ConstXmlAge                       = 'Age';
      ConstXmlHeight                    = 'Height';
      ConstXmlHairColors                = 'HairColors';
      ConstXmlEyeColors                 = 'EyeColors';
      ConstXmlModifieAttribut           = 'ModifyCarac';
      ConstXmlModifieCompetence         = 'ModifySkill';
      ConstXmlAjouteCompetence          = 'AddSkill';
      ConstXmlOpinions                  = 'OPINIONS';
      ConstXmlOpinion                   = 'Opinion';
      ConstXmlTarget                    = 'target';
      ConstXmlSource                    = 'source';

      // constantes de passage d'étapes de création de personnages
      ConstSuivant			= 1;

      // constantes de caractéristiques
      ConstCaracCC			= 'ATTR_WS';
      ConstCaracCT			= 'ATTR_BS';
      ConstCaracF			= 'ATTR_S';
      ConstCaracE			= 'ATTR_T';
      ConstCaracI			= 'ATTR_I';
      ConstCaracAg			= 'ATTR_Ag';
      ConstCaracDex			= 'ATTR_Dex';
      ConstCaracInt			= 'ATTR_Int';
      ConstCaracFM			= 'ATTR_WP';
      ConstCaracSoc			= 'ATTR_Fel';
      ConstCaracDestin		        = 'ATTR_Fate';
      ConstCaracResil			= 'ATTR_Resil';
      ConstCaracPointSupp               = 'ATTR_Supp';
      ConstCaracBlessure                = 'ATTR_Wound';
      ConstCaracMouvement               = 'ATTR_Move';
      ConstBonusCaracCC			= 'BATTR_WS';
      ConstBonusCaracCT			= 'BATTR_BS';
      ConstBonusCaracF			= 'BATTR_S';
      ConstBonusCaracE			= 'BATTR_T';
      ConstBonusCaracI			= 'BATTR_I';
      ConstBonusCaracAg			= 'BATTR_Ag';
      ConstBonusCaracDex		= 'BATTR_Dex';
      ConstBonusCaracInt		= 'BATTR_Int';
      ConstBonusCaracFM			= 'BATTR_WP';
      ConstBonusCaracSoc		= 'BATTR_Fel';

      // Cout Xp évolution carrière
      ConstXpNouveauNiveau              = 100;
      ConstXpChangerMetier              = 100;
      ConstXpChangerMetierIncomplet     = 200;
      ConstXpChangerClasse              = 100;

      // image de fond et icones
      ConstCheminLogo1                  = '\PICTURES\BACK\LOGO1.png';
      ConstCheminLogo2                  = '\PICTURES\BACK\LOGO2.png';
      ConstCheminBack                   = '\PICTURES\BACK\BACK.jpg';
      ConstCheminSheetTitle             = '\PICTURES\BACK\SHEETTITLE.png';
      ConstCheminSheetPage              = '\PICTURES\BACK\SHEETPAGE.png';
      ConstCheminSheetBack              = '\PICTURES\BACK\UNDER.png';
      ConstCheminXp                     = '\PICTURES\BACK\XP.jpg';
      ConstCheminScroll                 = '\PICTURES\BACK\SCROLL.png';
      ConstCheminBoutonRace             = '\PICTURES\BACK\BUTTON_SPECIES.png';
      ConstCheminBoutonMetier           = '\PICTURES\BACK\BUTTON_CLASS.png';
      ConstCheminBoutonCompetence       = '\PICTURES\BACK\BUTTON_SKILL.png';
      ConstCheminBoutonTalent           = '\PICTURES\BACK\BUTTON_TALENT.png';
      ConstCheminBoutonArme             = '\PICTURES\BACK\BUTTON_WEAPON.png';
      ConstCheminBoutonArmure           = '\PICTURES\BACK\BUTTON_ARMOR.png';
      ConstCheminBoutonSort             = '\PICTURES\BACK\BUTTON_SPELL.png';
      ConstCheminImageArme              = '\PICTURES\WEAPON\';
      ConstCheminImageArmure            = '\PICTURES\ARMOR\';
      ConstCheminImageNiveau            = '\PICTURES\NIV\';
      ConstCheminImagePolice            = '\FONT\';

      // pdf du personnage
      ConstCheminPdfFront               = '\PICTURES\PDF\FRONT.png';
      ConstCheminPdfBack                = '\PICTURES\PDF\BACK.png';
      ConstCheminPdfShadow              = '\PICTURES\PDF\SHADOW.png';
      ConstCheminPdfMetierBack          = '\PICTURES\PDF\PDF_BACKSHEET.jpg';
      ConstCheminPdfMetierAdvance       = '\PICTURES\PDF\PDF_ADVANCE_SCHEME.png';
      ConstCheminPdfMetierLigneG        = '\PICTURES\PDF\PDF_LINE_LEFT.png';
      ConstCheminPdfMetierLigneD        = '\PICTURES\PDF\PDF_LINE_RIGHT.png';
      ConstCheminPdfWarhammer           = '\PICTURES\PDF\PDF_WARHAMMER.png';
      ConstCheminPdfRolePlay            = '\PICTURES\PDF\PDF_ROLEPLAY.png';
      ConstCheminPdfUbersreik           = '\PICTURES\PDF\PDF_UBERSREIK.png';

      // chemin des fichiers de données de base
      ConstCheminAttribut               = '\DATABASE\LANGUAGE\%LANG%\ATTR.TXT';

      // chemin des fichiers liés à l'expérience
      ConstCheminXpAttribut             = '\DATABASE\ATTR_AUGM.TXT';
      ConstCheminXpCompetence           = '\DATABASE\SKILL_AUGM.txt';

      // chemin des textes
      ConstCheminLivre                  = '\DATABASE\';
      ConstCheminLivreExport            = '\DATABASE_EXPORT\';
      ConstFichierIni                   = '\INI.TXT';
      ConstCheminTravail                = '\TRAVAIL\';
      ConstIniLangue                    = 'LANG=';
      ConstIniLivre                     = 'BOOK=';
      ConstAnglais                      = 'ENGLISH';

      // Chemin des personnages
      ConstCheminPersonnage             = '\SAVED_CARACTERS\';

      // Police
      ConstPoliceTaille                 = 10;
      ConstPoliceBtTaille               = 20;
//
      // Souris
      WM_LBUTTONDOWN                    = $0201;
      WM_LBUTTONUP                      = $0202;

      // case à cocher
      CheckCharUnchecked                = #$2610;
      CheckCharChecked                  = #$2611;

      // couleurs générales
      CouleurGrisFonce: TColor          = $B4B4B4;
      CouleurDefColor:  Tcolor          = $E8F0F0;
      CouleurDefInverse:Tcolor          = $130000;
      CouleurButton:    Tcolor          = $ACBDBD;

      // compétence de race
      NbMaxCompetence                   = 12;

      // Talents qui donnent des bonus
      TalentGenerique                   = 'T*';
      TalentAmePure                     = 'T0005';
      TalentDurACuire                   = 'T0047';
      TalentCostaud                     = 'T0035';
      TalentVeloce                      = 'T0162';
      TalentChanceux                    = 'T0020';
      TalentObstine                     = 'T0107';
      TalentCoutPuissant                = 'T0037';
      TalentHaineSacree                 = 'T0070';
      TalenttirPrecis                   = 'T0149';
      TalentSprinteur                   = 'T0145';
      TalentSortBenediction             = 'T0012';
      TalentSortMiracle                 = 'T0080';
      TalentSortMagieMineure            = 'T0089';
      TalentSortDomaine                 = 'T0088';

      // Type d'équipement et de sorts
      EquipementCC                      = 'COMB_';
      EquipementCT                      = 'PROJ_';
      EquipementMU                      = 'MUNI_';
      EquipementAR                      = 'ARMO_';
      EquipementQualite                 = '(Q)';
      BonusProtection                   = 'WEAPB18 ';
      BonusBras                         = 'ARMOL_ARM';
      BonusCorps                        = 'ARMOL_BODY';
      BonusJambes                       = 'ARMOL_LEG';
      BonusTete                         = 'ARMOL_HEAD';
      SortBenediction                   = 'BENED_';
      SortMiracle                       = 'MIRAC_';
      SortMineur                        = 'SPELL_';
      SortArcane                        = 'ARCAN_';
      SortCouleur                       = 'COLOR_';
      FabricationBonus                  = 'BONUS';
      FabricationMalus                  = 'MALUS';
      SortChaos                         = 'CHAOS_';
      RaceHumain                        = 'SPECIE_HUMAN';
      RaceElf                           = 'SPECIE_ELF';
      RaceNain                          = 'SPECIE_DWARF';
      RaceOgre                          = 'SPECIE_OGRE';
      RaceGnome                         = 'SPECIE_GNOME';
      RaceHalfling                      = 'SPECIE_HALFLING';
      RaceGoblin                        = 'SPECIE_GOBLIN';
      RaceOrc                           = 'SPECIE_ORC';
      RaceVampire                       = 'SPECIE_VAMPIRE';
      RaceFamilier                      = 'SPECIE_FAMILIAR';
      CorruptionPhysique                = 'CORRUPTION_PHYSICAL';
      CorruptionMentale                 = 'CORRUPTION_MENTAL';
      // "GM's Choice" (Physical Corruption Table, 96-00) - pas une vraie mutation, une
      // instruction de consulter le MJ (CONTEXT.md §2.7). Seule la table Physical a ce cas ;
      // Mental n'a pas d'entrée équivalente à 96-00 ("Worried Jitters", une entrée normale).
      CorruptionChoixMJ                 = 'CORPHY_020';

      KEY_ESC                           = #27;

      ConstLangue                           = '%LANG%';
      ConstLivre                            = '%BOOK%';
      ConstRulesBook                        = 'BOOK RULESBOOK';
      ConstBookUpInArms                     = 'BOOK UP IN ARMS';
      ConstBookWindsOfMagic                 = 'BOOK WINDS OF MAGIC';
      ConstBookArchiveEmpire1               = 'BOOK ARCHIVES OF THE EMPIRE I';
      ConstBookArchiveEmpire2               = 'BOOK ARCHIVES OF THE EMPIRE II';
      ConstBookArchiveEmpire3               = 'BOOK ARCHIVES OF THE EMPIRE III';
      ConstBookRoughNightsHardDays          = 'BOOK ROUGH NIGHTS AND HARD DAYS';
      ConstBookDeathOnTheReikCompanion      = 'BOOK DEATH ON THE REIK COMPANION';
      ConstBookEnemyInShadowsCompanion      = 'BOOK ENEMY IN SHADOWS COMPANION';
      ConstBookMiddenheimCityOftheWhiteWolf = 'BOOK MIDDENHEIM CITY OF THE WHITE WOLF';
      ConstBookSalzenmundCityOfSaltAndSilver= 'BOOK SALZENMUND CITY OF SALT AND SILVER';
      ConstBookSeaOfClaws                   = 'BOOK SEA OF CLAWS';
      ConstBookTheHornedRatCompanion        = 'BOOK THE HORNED RAT COMPANION';

      ConstDebutAttribut                    = 'ATTR_';
      ConstDebutCompetence                  = 'COMP';
      ConstSelectionne                      = 'X';
      ConstCodeRaceCreationGenerique        = 'x';

      ConstLivreOfficiel                    = 'O';
      ConstLivreFacultatif                  = 'F';

      ConstLabSelSpe                        = 'LAB_129';
      ConstLabAdd                           = 'LAB_143';

      ConstTransparent                      = '_TRANS';

      ConstPAttribut                        = 'PAttribut';
      ConstPTexte                           = 'PTexte';
      ConstPCompetence                      = 'PCompetence';
      ConstPTalent                          = 'PTalent';
      ConstPRace                            = 'PRace';
      ConstPMetier                          = 'PMetier';
      ConstPArme                            = 'PArme';
      ConstPArmeBonus                       = 'PArmeBonus';
      ConstPArmure                          = 'PArmure';
      ConstPArmureSimplifiee                = 'PArmureSimplifiee';
      ConstPArmureBonus                     = 'PArmureBonus';
      ConstPSort                            = 'PSort';
      ConstPFabrication                     = 'PFabrication';
      ConstPCorruptionTable                 = 'PCorruptionTable';

      ConstCEsquive                         = 'RULES-COMPESQU';
      ConstCCalme                           = 'RULES-COMPCALM';
      ConstCResitance                       = 'RULES-COMPRESIST';
      ConstCCommandement                    = 'RULES-COMPCOMM';
      ConstCIntuition                       = 'RULES-COMPINTUI';

      ConstCompetenceInverseDe              = 'ChooseDice';
      ConstCompetenceBonus                  = 'Bonus';

      ConstOrigineRace                      = 'RACE';
      ConstOrigineMetier                    = 'METIER';

Var
  NomPersonnage:       String;
  CodeLivre:           String;
  NomLivre:            String;
  NeedUpdate:          Boolean = false;
  SelectWinMetierRace: String = '';
  ChoixWinMetierRace:  String = '';
  SelectWinRace:       String = '';
  ChoixWinRace:        String = '';
  SelectWinMetier:     String = '';
  SelectWinArme:       String = '';
  ChoixWinArme:        String = '';
  SelectWinArmure:     String = '';
  ChoixWinArmure:      String = '';
  SelectWinArmureSimp: String = '';
  ChoixWinArmureSimp:  String = '';
  SelectWinSort:       String = '';
  ChoixWinSort:        String = '';
  SelectWinFabrication:String = '';
  ChoixWinFabrication: String = '';
  SelectWinTalent:     String = '';
  ChoixWinTalent:      String = '';
  SelectWinAttribut:   String = '';
  ChoixWinAttribut:    String = '';
  SelectWinCompetence: String = '';
  ChoixWinCompetence:  String = '';
  RecherchePersonnage: String = '';
  ChoixWinTypeFichier: String = '';
  SelectWinEquipement: String = '';
  SelWinLibelle:       String = '';
  SelWinType:          String = '';
  ChoixWinEquipement:  String = '';
  SelectWinLivre:      String = '';
  ChoixWinLivre:       String = '';
  ListeLivre:          String = '';
  WinFiltreAppelant:   String = '';
  SelectWinGroupe:     String = '';
  ChoixWinGroupe:      String = '';
  SelectWinQuickArmor: Boolean= false;
  SelectWinF:          Integer = 0;
  SelectWinE:          Integer = 0;
  SelectWinFM:         Integer = 0;

  // Fenêtre WinMutation (CONTEXT.md §2.7) - même principe Select.../Choix... que les autres
  // fenêtres modales : WinPersonnage renseigne les entrées avant ShowModal, WinMutation
  // renseigne le résultat avant de se fermer.
  MutationCodeRace:             String  = '';    // entrée : Personnage.Race, pour le tirage Physical/Mental
  MutationResilienceDisponible: Boolean = false;  // entrée : Résilience totale actuelle > 0
  MutationChoix:                String  = '';    // sortie : '' (annulé) / 'RESILIENCE' / 'MUTATION'
  // sortie (si MUTATION) : référence stockée sur le personnage (Personnage.Mutations, CONTEXT.md
  // §2.7) - le code stable du catalogue (ex. "RULES-CORMEN_007"), pas le texte résolu ni la
  // plage de jet, pour rester cohérent avec le reste du projet (codes stockés, texte retraduit
  // à l'affichage) et rester valide même si un futur livre renumérote les tables de chance, et
  // permettre de retrouver/retirer une mutation précise plus tard (mutation perdue, rare mais
  // prévu par le livre).
  MutationCode:                 String  = '';
  MutationLibelle:              String  = '';    // sortie : nom de la mutation tirée (si MUTATION)
  MutationEffet:                String  = '';    // sortie : texte de l'effet de la mutation tirée

  // Constantes de thèmes des données des arbres d'affichages
  ConstArbreAttribut:       String;
  ConstArbreCompetence:     String;
  ConstArbreTalent:         String;
  ConstArbreAuChoix:        String;
  ConstArbreMetierPossible: String;
  ConstArbreRacePossible:   String;
  ConstArbreEquipement:     String;
  ConstArbreCorruption:     String;

  TypeEquipCC:              String;
  TypeEquipCT:              String;
  TypeEquipMU:              String;
  TypeEquipWe:              String;
  TypeEquipDI:              String;
  TypeEquipAR:              String;
  TypeEquipARS:             String;
  TypeEquipSp:              String;

  TypeSortBenediction:     String = 'Blessing';
  TypeSortMiracle:         String = 'Miracle';
  TypeSortMineur:          String = 'Minor Magic';
  TypeSortArcane:          String = 'Arcane Magic';
  TypeSortCouleur:         String = 'Domain Magic';
  TypeSortChaos:           String = 'Chaos Magic';

  ListBook:                array of String;
  ListGroup:               array of String;

  NbLivreRace:             Integer;
  NbLivreMetier:           Integer;

  ValLangue:               String = ConstAnglais;

  AvecSousMetier:          Boolean = false;
  AvecRaceChoixMetier:     Boolean = false;

  ConstPoliceNom:          String = 'Arial.ttf';
  ConstPoliceGras:         String = ' Bold';
  ConstPoliceItalique:     String = ' Italic';
  ConstPoliceCarlson:      String = 'Caslon Antique';
  ConstPoliceArial:        String = 'Arial';

  PdfFontBack:             Integer;
  PdfFontValue:            Integer;
  PdfFontBold:             Integer;
  PdfFontEnCours:          Integer;
  PdfFontTaille:           Integer;
  PdfFontItalique:         Integer;

  PdfFamilyName:           String;
  PdfIsBold:               Boolean;
  PdfIsItalic:             Boolean;

  LivresCharges:           String;
  LivresLivres:            String;

  LivreLangue:             String;
  ListeLangue:             String;

  ImageTmp:                String;

  LivreNbRace:             Integer;
  LivreNbMetier:           Integer;

  // chemins génériques
  ConstCheminImageRace:    String    = '\DATABASE\BOOKS\%BOOK%\PICTURE\SPECIE\';
  ConstCheminImageMetier:  String    = '\DATABASE\BOOKS\%BOOK%\PICTURE\CLASS\';
  ConstCheminImageSort:    String    = '\DATABASE\BOOKS\%BOOK%\PICTURE\SPELL\';

  AttributNiveau:          String;

  CodeRecherche:           String;
  LivreRecherche:          String;
  CodeValeur:              String;
  LivreValeur:             String;

  RechercheTrouve:         Boolean = false;
  LivreComplet:            Boolean = false;

  ChoixWinJetRace:    String;    // race en cours, pour TalentAleatoire
  SelectWinJet:       Integer;   // 0 = annulé
  SelectWinJetTalent: String;    // code du talent obtenu, '' = annulé
  ChoixWinJetDeja:    TStringList;
  ChoixWinJetValeur:  Integer;

  CouleurOk:      String = '6';
  CouleurNot:     String = '5';
  CouleurKo:      String = '7';
  CouleurFondNot: TColor = TColor($8487F0);   // rouge saumon (5.png) - action requise
  CouleurFondOk:  TColor = TColor($57ED71);   // vert (6.png)
  CouleurFondKo:  TColor = TColor($7F7F7F);   // gris (7.png)

procedure NettoyerElementsFenetre(Fenetre: TWinControl);
procedure AdjustGridColumnsWidth(Grid: TStringGrid; MaxHeight: Integer; ForceMax: Boolean; MaxWidth: boolean; AutoSizeCol: Boolean = true; AddHeight: Integer = 0; AddWidth: Integer = 0; ForceScroll: TScrollStyle = ssautoboth);
procedure AdjustTKGridColumnsWidth(Grid: TKGrid; MaxHeight: Integer; ForceMax: Boolean; MaxWidth: boolean; AutoSizeCol: Boolean = true; AddHeight: Integer = 0; AddWidth: Integer = 0; ForceScroll: TScrollStyle = ssautoboth);
Function GridAjouteColonne(Grid: TStringGrid; Caption: String = ''; Widths: Integer = 0; Align: TAlignment = taLeftJustify): Integer;
procedure ClearStringGrid(Grid: TStringGrid);
Procedure DeleteData(ATreeView: TTreeView; ANode: TTreeNode);
Function AjouteAccolade(Filtre: String): String;
Function EnleveAccolade(Filtre: String): String;
Function VerifieFiltre(Valeur: String; Liste: String): Boolean;
Function ReplaceTilde(Ligne: String): String;
Function LivreOrdre(Livre: String): String;
Function CheminFichier(TypeDonnee: String; Livre: String): String;
function extractnumbers(line: string): String;
function VerifieRecherche():Boolean;
Function LivreRepertoireTravail(CodeLivre, Langue: String): String;
Function LivreFichierActuel(CodeLivre, Langue: String): String;

implementation

procedure NettoyerElementsFenetre(Fenetre: TWinControl);
  var
    i: Integer;
    Control: TControl;
  begin
    // Parcourir tous les contrôles de la fenêtre
    for i := 0 to Fenetre.ControlCount - 1 do
      begin
        Control := Fenetre.Controls[i];

        // Vérifier le type de contrôle et nettoyer en conséquence
        if Control is TStringGrid then
          TStringGrid(Control).Clear
        else if Control is TEdit then
          TEdit(Control).Text := ''
        else if Control is TComboBox then
          TComboBox(Control).Clear;
      end;
  end;

procedure AdjustGridColumnsWidth(Grid: TStringGrid; MaxHeight: Integer; ForceMax: Boolean; MaxWidth: boolean; AutoSizeCol: Boolean = true; AddHeight: Integer = 0; AddWidth: Integer = 0; ForceScroll: TScrollStyle = ssautoboth);
  var
    Col:   Integer;
    Lig:   Integer;
    TotalC:Integer = 0;
    TotalL:Integer = 0;
    Asc:   Integer = 0;
    Form:  TForm;
  begin
    // Hauteur
    For Lig := 0 to Grid.RowCount -1 do
      TotalL:= TotalL + Grid.RowHeights[Lig];

    // chercher la taille maximal si elle n'est pas renseignée
    if MaxHeight = 0 then
      Begin
        Form := TForm(Grid.owner);
        MaxHeight := Form.Height;
      end;

    // agrandir à une taille max
    if ForceMax then
      begin
        Grid.Height := MaxHeight - Grid.Top - 10;
        if (Grid.Top + TotalL + 10) > MaxHeight then
          Asc := 20;
      end
    else
      begin
        if (MaxHeight > 0) and ((Grid.Top + TotalL + 10) > MaxHeight) then
          begin
            TotalL := MaxHeight - Grid.Top - 10;
            Asc    := 20;
          end;
        Grid.Height := TotalL + 5;
      end;

    // Largeur
    if AutoSizeCol then
      for Col := 1 to Grid.ColCount - 1 do
        if Grid.ColWidths[Col] <> 0 then
          Grid.AutoSizeColumn(Col);
    for Col := 0 to Grid.ColCount - 1 do
      TotalC:= TotalC + Grid.ColWidths[Col];
    if not MaxWidth then
      Grid.Width := TotalC + 5
    else if Grid.Width > (TotalC + 5) then
      Grid.Width := TotalC + 5;
    Grid.ScaleFormToDesign(96);
    if not MaxWidth then
      if  Asc > 0 then
        Grid.Width := Grid.Width + Asc;

    // forcer les tailles ajustées
    if AddHeight > 0 then
      Grid.Height := Grid.Height + AddHeight;
    if AddWidth > 0 then
      Grid.Width := Grid.Width + AddWidth;

    // les ascenseurs
    if ForceScroll <> ssAutoBoth then
      Grid.ScrollBars := ForceScroll
    else
      if Grid.Rowcount * Grid.RowHeights[1] > Grid.Height then
        if TotalC > Grid.Width then
          Grid.ScrollBars := ssboth
        else
          Grid.ScrollBars := ssVertical
      else
        if TotalC > Grid.Width then
          Grid.ScrollBars := ssHorizontal
        else
          Grid.ScrollBars := ssnone;

    Grid.Invalidate;

  end;

procedure AdjustTKGridColumnsWidth(Grid: TKGrid; MaxHeight: Integer; ForceMax: Boolean; MaxWidth: boolean; AutoSizeCol: Boolean = true; AddHeight: Integer = 0; AddWidth: Integer = 0; ForceScroll: TScrollStyle = ssautoboth);
  var
    Col:   Integer;
    Lig:   Integer;
    TotalC:Integer = 0;
    TotalL:Integer = 0;
    Asc:   Integer = 0;
    Form:  TForm;
  begin
    // Hauteur
    For Lig := 0 to Grid.RowCount -1 do
      TotalL:= TotalL + Grid.RowHeights[Lig];

    // chercher la taille maximal si elle n'est pas renseignée
    if MaxHeight = 0 then
      Begin
        Form := TForm(Grid.owner);
        MaxHeight := Form.Height;
      end;

    // agrandir à une taille max
    if ForceMax then
      begin
        Grid.Height := MaxHeight - Grid.Top - 10;
        if (Grid.Top + TotalL + 10) > MaxHeight then
          Asc := 20;
      end
    else
      begin
        if (MaxHeight > 0) and ((Grid.Top + TotalL + 10) > MaxHeight) then
          begin
            TotalL := MaxHeight - Grid.Top - 10;
            Asc    := 20;
          end;
        Grid.Height := TotalL + 5;
      end;

    // Largeur
    if AutoSizeCol then
      for Col := 1 to Grid.ColCount - 1 do
        if Grid.ColWidths[Col] <> 0 then
          Grid.AutoSizeCol(Col);
    for Col := 0 to Grid.ColCount - 1 do
      TotalC:= TotalC + Grid.ColWidths[Col];
    if not MaxWidth then
      Grid.Width := TotalC + 5
    else if Grid.Width > (TotalC + 5) then
      Grid.Width := TotalC + 5;
    Grid.ScaleFormToDesign(96);
    if not MaxWidth then
      if  Asc > 0 then
        Grid.Width := Grid.Width + Asc;

    // forcer les tailles ajustées
    if AddHeight > 0 then
      Grid.Height := Grid.Height + AddHeight;
    if AddWidth > 0 then
      Grid.Width := Grid.Width + AddWidth;

    // les ascenseurs
    if ForceScroll <> ssAutoBoth then
      Grid.ScrollBars := ForceScroll
    else
      if Grid.Rowcount * Grid.RowHeights[1] > Grid.Height then
        if TotalC > Grid.Width then
          Grid.ScrollBars := ssboth
        else
          Grid.ScrollBars := ssVertical
      else
        if TotalC > Grid.Width then
          Grid.ScrollBars := ssHorizontal
        else
          Grid.ScrollBars := ssnone;

    Grid.Invalidate;

  end;


procedure ClearStringGrid(Grid: TStringGrid);
  var
    Row, Col: Integer;
  begin
    for Row := 1 to Grid.RowCount - 1 do
      for Col := 1 to Grid.ColCount - 1 do
        Grid.Cells[Col, Row] := ''; // Effacer le contenu de la cellule
  end;

Procedure DeleteData(ATreeView: TTreeView; ANode: TTreeNode);
begin
  if ANode = nil then
    exit;

  // Destroy the Data.
  if (ANode.Data <> nil) then
  begin
    TObject(ANode.Data).Free;
    ANode.Data := nil;
  end;

  // Now delete Data in the children, grandchildren etc. of the node...
  if ANode.HasChildren then
    DeleteData(ATreeView, ANode.GetFirstChild);

  // ... and delete Data in the siblings of the node.
  ANode := ANode.GetNextSibling;
  if ANode <> nil then
    DeleteData(ATreeView, ANode);
end;

Function AjouteAccolade(Filtre: String): String;
begin
  Result := '[' + Filtre + ']';
end;

Function EnleveAccolade(Filtre: String): String;
begin
  result := StringReplace(Filtre, '[', '', [rfReplaceAll]);
  result := StringReplace(result, ']', '', [rfReplaceAll]);
end;

Function ReplaceTilde(Ligne: String): String;
Begin
  result := StringReplace(Ligne, '''', '’', [rfReplaceAll]);
  result := StringReplace(result, '"', '“', [rfReplaceAll]);
  result := StringReplace(result, '''', '’', [rfReplaceAll]);

end;

Function SupprimeDetail(Ligne: String): String;
var
  SeparatorPos: Integer;
begin
  SeparatorPos := Pos(SeparateurDetail, Ligne);
  if SeparatorPos > 0 then
    Result := Copy(Ligne, 1, SeparatorPos - 1)
  else
    Result := Ligne;
end;

Function VerifieFiltre(Valeur: String; Liste: String): Boolean;
  var
    Strings:    TStringList;
    Ind:        Integer;
    Res:        Boolean = false;
    Val:        String;
  begin
    AttributNiveau := '';
    if (Liste = '') then
      Res := true
    else if (pos(ValeurGenerique, Liste) > 0) then
      Res := (pos(Valeur,copy(Liste,1,pos(ValeurGenerique, Liste))) > 0)
    else if (pos(',',Valeur) = 0) then
      begin
        if Pos(SeparateurDetail, liste) = 0 then
          Res := (Pos(AjouteAccolade(Valeur), Liste) > 0)
        else
          begin
            Strings   := TStringList.Create;
            ExtractStrings([']'], [], PChar(Liste), Strings);
            for Ind := 0 to (Strings.count-1) Do
              begin
                Val := Strings[Ind];
                Val := SupprimeDetail(Val);
                Val := EnleveAccolade(Val);
                if (Val = Valeur) then
                  begin
                    Res := true;
                    AttributNiveau := Strings[Ind];
                    break;
                  end;
              end;
            Strings.free;
          end
      end
    else
      begin
        Strings   := TStringList.Create;
        ExtractStrings([','], [], PChar(Valeur), Strings);
        for Ind := 0 to (Strings.count-1) Do
          begin
            Strings[Ind] := SupprimeDetail(Strings[Ind]);
            Strings[Ind] := AjouteAccolade(Strings[Ind]);
            AttributNiveau := Strings[Ind];
            if (Strings[Ind] = Liste) then
              Res := true
            else if (pos(ValeurGenerique, Strings[Ind]) > 0) and (pos(Valeur,copy(Strings[Ind],1,pos(ValeurGenerique, Strings[Ind]))) > 0) then
              Res := true
            else if (pos(ValeurGenerique, Liste) > 0) and (pos(Strings[Ind],copy(Liste,1,pos(ValeurGenerique, Liste))) > 0) then
              Res := true;
            if Res = true then
              break;
          end;
        Strings.free;
      end;
    Result := Res;
  end;

Function LivreOrdre(Livre: String): String;
  Var
    Res:   String;
  begin
    if Livre = ConstRulesBook then
      res   := '0'
    else if Livre = ConstBookUpInArms then
      res   := '1'
    else if Livre = ConstBookWindsOfMagic then
      res   := '1'
    else if Livre = ConstBookArchiveEmpire1 then
      res   := '1'
    else if Livre = ConstBookArchiveEmpire2 then
      res   := '1'
    else if Livre = ConstBookArchiveEmpire3 then
      res   := '1'
    else if Livre = ConstBookRoughNightsHardDays then
      res   := '1'
    else if Livre = ConstBookDeathOnTheReikCompanion then
      res   := '1'
    else if Livre = ConstBookEnemyInShadowsCompanion then
      res   := '1'
    else if Livre = ConstBookMiddenheimCityOftheWhiteWolf then
      res   := '1'
    else if Livre = ConstBookSalzenmundCityOfSaltAndSilver then
      res   := '1'
    else if Livre = ConstBookSeaOfClaws then
      res   := '1'
    else if Livre = ConstBookTheHornedRatCompanion then
      res   := '1'
    else
      res   := '2';
    Result  := res;
  end;

Function CheminFichier(TypeDonnee: String; Livre: String): String;
  var
    Path:      String;
  begin
    // chercher le livre dans la langue
    Path := GetCurrentDir+StringReplace(StringReplace(TypeDonnee, ConstLangue, ValLangue, [rfReplaceAll]), ConstLivre, Livre, [rfReplaceAll]);
    if FileExists(Path) then
      result := Path
    else if ValLangue <> ConstAnglais then
      begin
        // si la langue n'est pas l'anglais, chercher en anglais
        Path := GetCurrentDir+StringReplace(StringReplace(TypeDonnee, ConstLangue, ConstAnglais, [rfReplaceAll]), ConstLivre, Livre, [rfReplaceAll]);
        if FileExists(Path) then
          result := Path
        else
          result := '';
      end
    else
      result := '';

  end;

Function GridAjouteColonne(Grid: TStringGrid; Caption: String = ''; Widths: Integer = 0; Align: TAlignment = taLeftJustify): Integer;
  var
    Nb: Integer;
  begin
    Grid.Columns.Add;
    Nb := Grid.ColCount - 1;
    Grid.Columns[Nb-1].title.caption := Caption;
    Grid.ColWidths[Nb]               := Widths;
    Grid.Columns[Nb-1].Alignment     := Align;
    result := Nb;
  end;

function extractnumbers(line: string): String;
  const
    n = ['0'..'9'];
  var
    i: integer;
  begin
    i := 1;
    extractnumbers :='';
    while  i < length(line) do
    begin
      if line[i] in n then extractnumbers := extractnumbers + line[i];
      inc(i);
    end;
  end;

Function VerifieRecherche():Boolean;
var
  Trouve: Boolean;
begin
  if (LivreRecherche = LivreValeur) and (CodeRecherche = CodeValeur) then
    Trouve := True
  else if (LivreValeur = '') and (CodeRecherche = CodeValeur) then
    Trouve := True
  else
    Trouve := False;
  result := Trouve;
  end;

Function LivreRepertoireTravail(CodeLivre, Langue: String): String;
  begin
    Result := GetCurrentDir + ConstCheminTravail + CodeLivre + '_' + Langue;
  end;

Function LivreFichierActuel(CodeLivre, Langue: String): String;
  var
    SearchRec:   TSearchRec;
    PlusRecent:  String;
    Repertoire:  String;
  begin
    Result     := '';
    PlusRecent := '';
    Repertoire := LivreRepertoireTravail(CodeLivre, Langue);
    if not DirectoryExists(Repertoire) then Exit;
    if FindFirst(Repertoire + PathDelim + '*.xml', faAnyFile, SearchRec) = 0 then
      begin
        repeat
          if (SearchRec.Attr and faDirectory) = 0 then
            if PlusRecent = '' then
              PlusRecent := SearchRec.Name
            else if CompareText(SearchRec.Name, PlusRecent) > 0 then
              PlusRecent := SearchRec.Name;
        until FindNext(SearchRec) <> 0;
        FindClose(SearchRec);
      end;
    if PlusRecent <> '' then
      Result := IncludeTrailingPathDelimiter(Repertoire) + PlusRecent;
  end;
end.

