unit ChargePersonnage;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, ChargeConstantes, XMLRead, DOM,
  Unitcalcul, ChargeRace, ChargeMetier, ChargeAttribut, ChargeCompetence,
  ChargeTalent, ChargeArme, ChargeArmure, ChargeArmureSimplifie,
  ChargeTalentCompetenceModif, ChargeArmureBonusModif,
  ChargeSort, ChargeCorruptionTable,
  ChargeCorruptionCompetenceModif, ChargeCorruptionTalent,
  ChargeCorruptionEquipement, ChargeArmureBonusTalent,
  ChargeModificateur, ChargeTalentModificateur, ChargeCareerBonusModificateur,
  ChargeArmeModificateur, ChargeArmureBonusModificateur, ChargeCorruptionModificateur,
  ChargeFabrication,
  XmlExportImport;

Type
  StructurePersonnageAttribut   = Record
     CodeAttribut:          String;
     Valeur:                Integer;
     Bonus:                 String;
  end;


Type
  StructurePersonnageCompetence = Record
     CodeCompetence:        String;
     Valeur:                Integer;
     Bonus:                 String;
  end;

Type
  StructurePersonnageTalent     = Record
     CodeTalent:            String;
     Valeur:                Integer;
     Asterisque:            Integer;
     // Code de ce qui a accorde ce talent automatiquement (ex. une mutation), vide si le
     // joueur l'a choisi/achete normalement. Pas encore alimente ni serialise en XML : premiere
     // etape du chantier "traits de creature", CONTEXT.md/A FAIRE.txt.
     Source:                String;
  end;
  // Nomme, requis par le compilateur comme type de retour de fonction (PersonnageMutationTalent) -
  // un "array of ..." anonyme n'est pas accepte a cet endroit.
  TArrayPersonnageTalent = array of StructurePersonnageTalent;

Type
  StructurePersonnageEquipement = Record
     TypeEquipement:        String;
     CodeEquipement:        String;
     QualiteEquipement:     String;
     CoutXp:                Integer;
     // Meme principe que StructurePersonnageTalent.Source : code de ce qui a accorde cette
     // ligne automatiquement (ex. une mutation), vide si achetee/choisie normalement.
     Source:                String;
     // Vrai si la piece est portee (par opposition a transportee). Ne s'applique qu'aux
     // armes/armures/sets d'armure (TypeEquipWe/Ar/ArS) ; sans effet sur Divers/Sorts.
     Porte:                 Boolean;
  end;
  TArrayPersonnageEquipement = array of StructurePersonnageEquipement;

Type
  // Une entree par qualite d'armure PORTEE, en gardant le lien vers la piece qui la porte -
  // contrairement a PersonnageArmureQualites (liste aplatie, toute pochette possedee comptee,
  // lien piece->qualite perdu). Necessaire pour moduler un malus par Practical/Unreliable de LA
  // piece qui le porte (CONTEXT.md 2.59/A FAIRE.txt).
  StructurePersonnageArmureQualitePortee = Record
     CodeEquipement:        String;
     CodeQualite:           String;
  end;
  TArrayPersonnageArmureQualitePortee = array of StructurePersonnageArmureQualitePortee;

Type
  // historique de corruption : Montant positif = corruption gagnée, négatif = perdue/purifiée
  StructurePersonnageCorruption  = Record
     Montant:               Integer;
     Libelle:               String;
  end;

Type
  // mutation obtenue par le personnage (CONTEXT.md §2.7) - référence (Code stable du catalogue,
  // ex. "RULES-CORMEN_007") vers ListCorruptionTable (ChargeCorruptionTable.pas), pas le texte
  // résolu ni la plage de jet : cohérent avec le reste du projet (codes stockés, texte retraduit
  // à l'affichage via ChercheCorruptionTable), reste valide si un futur livre renumérote sa table
  // de chance (DATA_CORRUPTION_..._CHANCE), et nécessaire pour retrouver/retirer une mutation
  // précise (perte de mutation, rare mais prévue par le livre).
  StructurePersonnageMutation    = Record
     Code:                  String;
  end;

Type
  StructurePersonnageMetier     = Record
     CodeMetier:            String;
     NiveauMetier:          Integer;
     CoutXp:                Integer;
  end;

Type
  StructurePersonnageXpAttribut = Record
     CodeAttribut:          String;
     Debut:                 Integer;
     Fin:                   Integer;
     CoutXp:                Integer;
  end;

Type
  StructurePersonnageXpCompetence = Record
     CodeCompetence:        String;
     Debut:                 Integer;
     Fin:                   Integer;
     CoutXp:                Integer;
  end;

Type
  StructurePersonnageXpTalent = Record
     CodeTalent:            String;
     Debut:                 Integer;
     Fin:                   Integer;
     CoutXp:                Integer;
  end;

Type
  StructurePersonnageTalentPersonnage = Record
     CodeCompetence:        String;
     CodeTalent:            String;
  end;


Type
  StructurePersonnage = Record
     NomPersonnage:              String;
     LivresAcceptes:             String;
     XpTotal:                    Integer;
     Xp25Total:                  Integer;
     XpActuel:                   Integer;
     Race:                       String;
     MetierEnCours:              StructurePersonnageMetier;
     CreationAttribut:           array of StructurePersonnageAttribut;
     CreationCompetence35:       array of StructurePersonnageCompetence;
     CreationCompetence40:       array of StructurePersonnageCompetence;
     CreationTalent:             array of StructurePersonnageTalent;
     MetierAncien:               array of StructurePersonnageMetier;
     MetierCompetence:           array of StructurePersonnageCompetence;
     MetierTalent:               array of StructurePersonnageTalent;
     AugmentationAttribut:       array of StructurePersonnageAttribut;
     AugmentationCompetence:     array of StructurePersonnageCompetence;
     AugmentationTalent:         array of StructurePersonnageTalent;
     Equipement:                 array of StructurePersonnageEquipement;
     Corruption:                 array of StructurePersonnageCorruption;
     Mutations:                  array of StructurePersonnageMutation;
     XpCoutAttribut:             array of StructurePersonnageXpAttribut;
     XpCoutTalent:               array of StructurePersonnageXpTalent;
     XpCoutCompetence:           array of StructurePersonnageXpCompetence;
     TalentCompetence:           array of StructurePersonnageTalentPersonnage;
     LivresObligatoires:         String;
     Options:                    String;
     Age:                        Integer;
     Height:                     Integer;
     HairColors:                 String;
     EyeColors:                  String;
     Asterisque:                 Integer;
     // Appartenances : les codes des CareerBonus (regiment, ordre de chevalerie, culte)
     // dont ce personnage est membre, separes par des virgules, vide si aucune.
     // C'est une donnee de la FICHE et non une deduction de la carriere en cours : le
     // livre precise qu'on garde les competences et talents acquis meme apres avoir
     // quitte le regiment ou change de carriere. CONTEXT.md 2.44.
     Appartenance:               String;
  end;

  StructureChoixCreation = record
    Origine, CodeSource, CodeParent, CodeChoisi: String;
    CodeSpecialise: String;
    Rang: Integer;
    Aleatoire: Boolean;
    Jet: Integer;
  end;

  // XML
  function PersonnageXmlCreation(Personnage: StructurePersonnage; Xp: Integer; XpRestante: Integer; fileName: string; PersonnageName: String): Boolean;
  function PersonnageXmlChargement(fileName: string): StructurePersonnage;
  function PersonnageXmlFichierActuel(const Directory: string): string;
  function PersonnageLivre(ListeLivre: String; Livre: String): string;
  Function PersonnageTalentAsterisque(var Personnage:StructurePersonnage; CodeTalent: String): Integer;
  // Effets à delta pur des mutations obtenues (CONTEXT.md §2.7, étape 8) - somme, pour un code
  // d'attribut/compétence donné, tous les <ModifyCarac>/<ModifySkill> des mutations présentes
  // dans Personnage.Mutations. Ce sont ici de vrais modificateurs additionnés au Total
  // (PdfPersonnageAttribut/PdfPersonnageCompetence, pdfpersonnage.pas). Implementation deleguee
  // a PersonnageMutationModificateur depuis le 11/09/2026 (migration ModifyCarac sur le moteur
  // generique, meme chantier que Talent/CareerBonus).
  Function PersonnageMutationAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  // Moteur generique (ChargeCorruptionModificateur) cote Mutation - pendant de
  // PersonnageTalentModificateur, sans filtre de palier (une mutation presente compte
  // toujours). CodeSource = StructureCorruptionTable.Code. CONTEXT.md, chantier moteur
  // generique, etape "migrer ModifyCarac d'Attribut" (11/09/2026).
  Function PersonnageMutationModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  // <ModifySkill> des mutations - lit desormais ListCorruptionModificateur (TypeModif =
  // ConstXmlModifieCompetence) depuis le 11/09/2026. Reste une fonction dediee (pas un
  // simple appel a PersonnageMutationModificateur) : gere en plus la famille de
  // sous-competences (CodeGenerique) et le pendant <ModifySkillAttribut>
  // (ListCorruptionCompetenceAttributModif, broadcast par attribut de rattachement, hors
  // moteur generique - pas dans ce chantier).
  Function PersonnageMutationCompetenceModif(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  // <ModifArmour> des mutations - implementation deleguee a PersonnageMutationModificateur
  // depuis le 11/09/2026 (migration ModifySkill/ModifyArmour sur le moteur generique).
  Function PersonnageMutationArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  // Talents accordes automatiquement par les mutations du personnage (ex. Fleshy Tentacle ->
  // Tentacles, cas par cas dans le XML - <Talent> sous <Corruption>, chargecorruptiontalent.pas).
  // Calcule a la volee depuis Personnage.Mutations, meme principe que
  // PersonnageMutationArmureModif juste au-dessus : rien n'est stocke sur la fiche, donc si une
  // mutation disparait un jour de Personnage.Mutations, le talent calcule disparait avec elle
  // sans purge explicite a ecrire. CONTEXT.md, chantier "traits de creature".
  Function PersonnageMutationTalent(Personnage: StructurePersonnage): TArrayPersonnageTalent;
  // Meme principe que PersonnageMutationTalent juste au-dessus, mais pour l'arme/armure
  // accordee par une mutation (<Weapon>/<Armor> sous <Corruption>, chargecorruptionequipement.pas).
  // Calcule a la volee, rien de stocke sur la fiche : meme cascade gratuite au retrait d'une
  // mutation. CONTEXT.md, chantier "traits de creature".
  Function PersonnageMutationEquipement(Personnage: StructurePersonnage): TArrayPersonnageEquipement;
  // Meme principe que PersonnageMutationTalent, mais la source est une qualite d'objet porte
  // (ex. NATIO-ARMOB_16 "Fear" -> RULES-T0049 "Frightening", Skull Trophies) plutot qu'une
  // mutation - <Talent> sous <ArmureBonus>, chargearmurebonustalent.pas. Calcule a la volee
  // depuis Personnage.Equipement : le retrait de l'objet porte fait disparaitre le talent
  // accorde sans purge explicite a ecrire. CONTEXT.md, chantier "traits de creature".
  Function PersonnageArmureBonusTalent(Personnage: StructurePersonnage): TArrayPersonnageTalent;
  Function PersonnageTalentArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  // Même principe que PersonnageMutationAttributModif, mais sur les <ModifyCarac> déclarés
  // directement sur un TALENT (DATA_TALENT) plutôt que sur une mutation. Ajoutée le
  // 06/09/2026 - CONTEXT.md, chantier "résolveur générique Attribut/Compétence" : premier
  // pas, un seul appelant pour l'instant (Mouvement dans PdfPersonnageCreation/Feldo2P, en
  // remplacement du cas TalentVeloce du case sur AugmentationTalent/CreationTalent).
  // Implementation deleguee a PersonnageTalentModificateur depuis le 11/09/2026 (migration
  // ModifyCarac sur le moteur generique) - l'annotation d'affichage
  // (PersonnageTalentAsterisque) lit desormais la meme ListTalentModificateur.
  Function PersonnageTalentAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  // Moteur generique "par source" (chargemodificateur.pas, CONTEXT.md chantier "inversion
  // des recherches") : boucle sur les Talents possedes par le personnage et additionne les
  // <Modificateur Type="..." Cible="..."/> qui correspondent, au lieu d'une fonction dediee
  // par croisement source/cible. Filtre optionnel (ex. skill= pour restreindre un ModifyWeapon
  // a une competence precise), vide si non utilise. Premiere source branchee sur ce format ;
  // les autres (CareerBonus, Mutation...) suivront dans un chantier separe.
  Function PersonnageTalentModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  // Greffes des appartenances (regiments, ordres, cultes) - CONTEXT.md 2.44
  Procedure PersonnageAppliqueGreffes(var Personnage: StructurePersonnage);
  // Niveau atteint par le personnage dans un metier donne (le plus haut entre la carriere en
  // cours et les carrieres passees) - CONTEXT.md 2.50 etape 3. Sert de filtre de palier pour
  // PersonnageCareerBonusAttributModif : contrairement a PersonnageAppliqueGreffes (qui greffe
  // tous les paliers d'une appartenance sans filtrer, l'ecran/le PDF filtrant ensuite par le
  // Valeur tague sur MetierCompetence/MetierTalent), un bonus d'ATTRIBUT est additionne
  // directement au Total et ne peut pas se permettre ce flou.
  Function PersonnageNiveauDansMetier(Personnage: StructurePersonnage; CodeMetier: String): Integer;
  // Même principe que PersonnageTalentAttributModif, mais sur les <ModifyCarac> déclarés dans
  // un palier de DATA_CAREER_BONUS - n'additionne un modificateur que si le personnage a
  // l'appartenance ET a atteint le palier qui le porte. Implementation deleguee a
  // PersonnageCareerBonusModificateur depuis le 11/09/2026 (migration ModifyCarac).
  Function PersonnageCareerBonusAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  // Moteur generique (ChargeCareerBonusModificateur) cote CareerBonus - pendant de
  // PersonnageTalentModificateur ci-dessus, avec en plus le filtre de palier que les Talents
  // n'ont pas : boucle sur les Appartenances du personnage, ne compte un modificateur que si
  // son Niveau est atteint (PersonnageNiveauDansMetier). CONTEXT.md, chantier moteur
  // generique, etape "brancher CareerBonus" (11/09/2026). Remplace en interne les anciennes
  // PersonnageCareerBonusCompetenceModif/ArmeModif, dont les signatures ne changent pas.
  Function PersonnageCareerBonusModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  // Pendant Competence de PersonnageCareerBonusAttributModif ci-dessus - ajouté au 2.44/3d-3 :
  // le palier Knight ("+10 CC avec les lances") se représente comme un bonus chiffré sur
  // Melee (Cavalry) plutôt qu'un simple octroi de compétence. Implementation deleguee a
  // PersonnageCareerBonusModificateur depuis le 11/09/2026 (branchement CareerBonus sur le
  // moteur generique).
  Function PersonnageCareerBonusCompetenceModif(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  // Pendant "par type d'arme" des deux precedents - ajoute le 07/09/2026 : le palier Knight ne
  // bonifie que CERTAINES armes d'une meme competence ("+10 CC avec les lances, les epees a
  // deux mains ou les boucliers", pas tout Melee (Cavalry)/Melee (2 mains)/Melee (Base)).
  // Prend l'ARME ELLE-MEME en parametre (pas son seul CodeCompetence) car le filtre porte sur
  // StructureArme.TypeArme, et FACULTATIVEMENT sur CodeCompetence en plus (voir ChargeMetier).
  // A appeler par ARME possedee, pas par competence generale - PdfPersonnageArmes
  // (pdfpersonnage.pas) est le seul appelant prevu, une ligne d'arme a la fois. Implementation
  // deleguee a PersonnageCareerBonusModificateur depuis le 11/09/2026.
  Function PersonnageCareerBonusArmeModif(Personnage: StructurePersonnage; PArme: StructureArme): Integer;
  // Pendant "regle narrative" des trois PersonnageCareerBonusXxxModif ci-dessus
  // (ListCareerBonusSpecialRule) - ajoute le 08/09/2026 pour le palier 4 ("Knight of the
  // Inner Circle") des Ordres de Chevalerie, qui n'a le plus souvent aucun equivalent
  // chiffre. Renvoie les regles acquises par le personnage (Appartenance + palier
  // atteint) - l'APPELANT est proprietaire de la liste rendue et doit la liberer, meme
  // contrat que NiveauxDuCareerBonus (ChargeMetier). Affichee sur le PDF comme un "talent
  // virtuel" de plus (pdfpersonnage.pas, les deux gabarits).
  Function PersonnageCareerBonusSpecialRule(Personnage: StructurePersonnage): TListCareerBonusSpecialRule;
  // Même principe que PersonnageTalentAttributModif, mais sur les <ModifyCarac> déclarés
  // directement sur une ARME (DATA_ARME) - CONTEXT.md 2.50 étape 3. Une arme n'a pas de
  // niveau : toute arme présente dans Personnage.Equipement compte, comme pour l'armure (pas
  // de distinction "possédé" / "porté" dans ce modèle). Implementation deleguee a
  // PersonnageArmeModificateur depuis le 11/09/2026 (migration ModifyCarac).
  // Pendant "par type d'arme" de PersonnageTalentModificateur, meme principe que
  // PersonnageCareerBonusArmeModif - chantier "moteur generique", etape ModifyWeapon sur
  // Talent (CONTEXT.md, 11/09/2026). Prend l'ARME ELLE-MEME en parametre (TypeArme +
  // CodeCompetence en filtre optionnel), a appeler par arme possedee.
  Function PersonnageTalentArmeModif(Personnage: StructurePersonnage; PArme: StructureArme): Integer;
  Function PersonnageArmeAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  // Moteur generique (ChargeArmeModificateur) cote Arme - pendant de
  // PersonnageTalentModificateur, sans filtre de niveau/palier. CodeSource = CodeArme.
  Function PersonnageArmeModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  // Modificateurs des QUALITES d'armure (<ModifyCarac> sur DATA_ARMURE_BONUS) et migration en
  // vrai calcul de l'ancien mecanisme decoratif ListArmureBonusModif (<Modifier name="..."> lie
  // a une competence, jusqu'ici jamais soustrait du Total - cause du bug Stechzeug Bracers,
  // A FAIRE.txt). CONTEXT.md 2.50 etape 3, point 4/5. Toute piece d'armure equipee (normale ET
  // simplifiee) compte, qualite par qualite dans sa ListeBonus. Implementation deleguee a
  // PersonnageArmureBonusModificateur depuis le 11/09/2026 (migration ModifyCarac).
  Function PersonnageArmureBonusAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  // Moteur generique (ChargeArmureBonusModificateur) cote qualite d'armure - pendant de
  // PersonnageTalentModificateur. CodeSource = CodeArmureBonus ; a appeler avec les codes
  // rendus par PersonnageArmureQualites (une entree par qualite portee, pas par piece).
  Function PersonnageArmureBonusModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  // Qualites d'armure PORTEE, piece par piece (contrairement a PersonnageArmureQualites, qui
  // aplatit et compte l'equipement possede non porte) - base pour moduler le malus ARMOB par
  // Practical/Unreliable de la piece (CONTEXT.md 2.59). Meme extraction catalogue+fabrication
  // et meme resolution des alternatives que PersonnageArmureBonusTalent.
  Function PersonnageArmureQualitesPortees(Personnage: StructurePersonnage): TArrayPersonnageArmureQualitePortee;
  // Malus/bonus ARMOB d'une competence, piece PORTEE par piece PORTEE, module par
  // Practical/Unreliable DE LA piece qui le porte (reduit de 10 plancher 0 / double - Rulebook,
  // CONTEXT.md 2.59). Destine a la colonne "avec equipement" du Pdf Feldo2P.
  Function PersonnageArmureBonusCompetenceModifPortee(Personnage: StructurePersonnage; CodeCompetence: String): Integer;

implementation

////////////////////////////////////////////////////////////////////////////////
//                                 XML                                        //
////////////////////////////////////////////////////////////////////////////////



function PersonnageXmlFichierActuel(const Directory: string): string;
var
  SearchRec:       TSearchRec;
  HighestFileName: string;
begin
  HighestFileName := '';

  if FindFirst(Directory + PathDelim + '*.xml', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory) = 0 then
      begin
        // Vérifier si le fichier a l'extension .xml
        if UpperCase(ExtractFileExt(SearchRec.Name)) = UpperCase('.xml') then
        begin
          // Comparer le nom du fichier avec le nom le plus élevé trouvé jusqu'à présent
          if HighestFileName = '' then
            HighestFileName := SearchRec.Name
          else if CompareText(SearchRec.Name, HighestFileName) > 0 then
            HighestFileName := SearchRec.Name;
        end;
      end;
    until FindNext(SearchRec) <> 0;
  end;

  if HighestFileName <> '' then
    Result := IncludeTrailingPathDelimiter(Directory) + HighestFileName
  else
    Result := '';
end;

Function XmlAttributEquipementPorte(Porte: Boolean): String;
  // Attribut XML optionnel ajoute a la ligne d'equipement : absent si non porte, pour que
  // les fiches deja sauvegardees (sans le champ) soient lues comme "rien d'equipe".
  begin
    if Porte then
      Result := ' '+ConstXmlEquipementPorte+'="1"'
    else
      Result := '';
  end;

Function PersonnageLivre(ListeLivre: String; Livre: String): String;
Var
  AjoutLivre: String;
Begin
   // Un livre vide n'a rien a faire dans la liste : c'est ce qui produisait le "[]" que Nono
   // trainait de longue date, visible en fin de fiche sous la forme "[BOOK RULESBOOK][]".
   // Il apparait des qu'un element n'est pas retrouve dans les listes chargees - du texte
   // libre d'equipement, un code d'un livre decoche, ou une recherche faite sur la mauvaise
   // variable (deux cas corriges juste en dessous). CONTEXT.md 2.19.
   if Livre = '' then
     begin
       Result := ListeLivre;
       Exit;
     end;
   AjoutLivre   := AjouteAccolade(Livre);
   if Pos(AjoutLivre, ListeLivre) = 0 then
     ListeLivre := ListeLivre + AjoutLivre;
   result       := ListeLivre;
end;

Function CodeNormalise(Code, Livre: String): String;
  // Ajoute le prefixe de livre a un code avant ecriture, mais SEULEMENT si l'element a ete
  // retrouve dans les listes chargees (Livre non vide).
  //
  // Deux raisons a cette prudence :
  //  - l'equipement melange des codes et du TEXTE LIBRE ("Practical Tunic and Robes") ; le
  //    texte libre n'est jamais retrouve, donc jamais prefixe ;
  //  - un code inconnu (livre decoche, coquille) ressort intact et reste reperable, plutot
  //    que de recevoir un prefixe invente.
  //
  // Le test sur Livre n'est fiable que depuis le 22/08/2026 : avant, les fonctions Cherche*
  // renvoyaient l'enregistrement de l'appel PRECEDENT quand elles ne trouvaient rien, donc
  // .Livre etait celui d'un autre element (CONTEXT.md 2.17).
  //
  // XmlCreeCodeLivre est idempotente : un code deja prefixe ressort tel quel.
  begin
    if Livre <> '' then
      Result := XmlCreeCodeLivre(Livre, Code)
    else
      Result := Code;
  end;

function PersonnageXmlCreation(Personnage: StructurePersonnage; Xp: Integer; XpRestante: Integer; fileName: string; PersonnageName: String): Boolean;
var
  XMLContent:             TStringList;
  PersonnageAttribut:     StructurePersonnageAttribut;
  PersonnageCompetence:   StructurePersonnageCompetence;
  PersonnageTalent:       StructurePersonnageTalent;
  PersonnageEquipement:   StructurePersonnageEquipement;
  PersonnageCorruption:   StructurePersonnageCorruption;
  PersonnageMutation:     StructurePersonnageMutation;
  PersonnageMetier:       StructurePersonnageMetier;
  PersonnageXpAttribut:   StructurePersonnageXpAttribut;
  PersonnageXpCompetence: StructurePersonnageXpCompetence;
  PersonnageXpTalent:     StructurePersonnageXpTalent;
  PRace:                  StructureRace;
  PMetier:                StructureMetier;
  PAttribut:              StructureAttribut;
  PCompetence:            StructureCompetence;
  PTalent:                StructureTalent;
  PArme:                  StructureArme;
  PArmure:                StructureArmure;
  PArmureSimplifiee:      StructureArmureSimplifiee;
  PSort:                  StructureSort;
  PCorruptionTable:       StructureCorruptionTable;
  ListeLivres:            String = '';
begin
  Result := False; // Initialise le résultat à False
  XMLContent := TStringList.Create;
  try
    try
      // Construire le contenu XML
      XMLContent.Add(XmlDataBase());

      // Personnage
      XMLContent.Add(XmlDebut(ConstXmlPersonnage));

        // Générales
        XMLContent.Add(XmlLigne(ConstXmlName, PersonnageName));
        XMLContent.Add(XmlLigne(ConstXmlRace, Personnage.Race));
        PRace := ChercheRace(Personnage.Race);
        ListeLivres:= PersonnageLivre(ListeLivres, PRAce.livre);
        XMLContent.Add(XmlCommentaire(PRace.Libelle));
        XMLContent.Add(XmlLigne(ConstXmlAge, IntToStr(Personnage.Age)));
        XMLContent.Add(XmlLigne(ConstXmlHeight, IntToStr(Personnage.Height)));
        XMLContent.Add(XmlLigne(ConstXmlHairColors, Personnage.HairColors));
        XMLContent.Add(XmlLigne(ConstXmlEyeColors, Personnage.EyeColors));

        XMLContent.Add(XmlLigne(ConstXmlWork, Personnage.MetierEnCours.CodeMetier));
        PMetier := chercheMetier(Personnage.MetierEnCours.CodeMetier);
        ListeLivres:= PersonnageLivre(ListeLivres, PMetier.livre);
        XMLContent.Add(XmlCommentaire(PMetier.Libelle));

        XMLContent.Add(XmlLigne(ConstXmlNvWork, IntToStr(Personnage.MetierEnCours.NiveauMetier)));
        XMLContent.Add(XmlLigne(ConstXmlXp, InttoStr(Xp)));
        if Pos(AjouteAccolade(ConstXmlOptionXpDiv25), Personnage.Options) > 0 then
          XMLContent.Add(XmlLigne(ConstXmlXp25Total, InttoStr(trunc(Xp/25))));
        XMLContent.Add(XmlLigne(ConstXmlXpCurrent, InttoStr(XpRestante)));

        // Création
        XMLContent.Add(XmlDebut(ConstXmlChapitreCreation));
          // Attributs
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCarac));
          for PersonnageAttribut in Personnage.CreationAttribut do
            begin
              PAttribut := ChercheAttribut(PersonnageAttribut.CodeAttribut);
              // Le code d'attribut est normalise avec son prefixe de livre avant ecriture.
              // Les augmentations viennent de TabAttribut (WinPersonnage), dont la ligne de
              // codes est semee par AttributInit a partir des constantes ConstCaracXxx, qui
              // valent 'ATTR_WS' SANS prefixe - d'ou des fiches melangeant les deux formes,
              // et un filtre de sorts qui ne matchait plus (CONTEXT.md 2.19). XmlCreeCodeLivre
              // est idempotente : elle ne prefixe que si le code ne l'est pas deja.
              XMLContent.Add(XmlLigneDonnee(ConstXmlCarac,
                XmlCreeCodeLivre(PAttribut.Livre, PersonnageAttribut.CodeAttribut),
                IntToStr(PersonnageAttribut.Valeur)));
              XMLContent.Add(XmlCommentaire(PAttribut.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCarac));

          // Compétences 3 et 5
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompSpecie));
          for PersonnageCompetence in Personnage.CreationCompetence35 do
            Begin
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence,
                CodeNormalise(PersonnageCompetence.CodeCompetence, PCompetence.Livre),
                IntToStr(PersonnageCompetence.Valeur)));
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompSpecie));

          // Compétences 40 pts
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompCreation));
          for PersonnageCompetence in Personnage.CreationCompetence40 do
            begin
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence,
                CodeNormalise(PersonnageCompetence.CodeCompetence, PCompetence.Livre),
                IntToStr(PersonnageCompetence.Valeur)));
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompCreation));

          // Talents
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
          for Personnagetalent in Personnage.CreationTalent do
            Begin
              PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
              XMLContent.Add(XmlLigneDonnee(ConstXmlTalent,
                CodeNormalise(PersonnageTalent.CodeTalent, PTalent.Livre),
                IntToStr(PersonnageTalent.Valeur)));
              ListeLivres:= PersonnageLivre(ListeLivres, PTalent.livre);
              XMLContent.Add(XmlCommentaire(PTalent.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreTalent));
        XMLContent.Add(XmlFin(ConstXmlChapitreCreation));

        // Augmentation
        XMLContent.Add(XmlDebut(ConstXmlChapitreAugmentation));
          // Attributs
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCarac));
          for PersonnageAttribut in Personnage.AugmentationAttribut do
            begin
              PAttribut := ChercheAttribut(PersonnageAttribut.CodeAttribut);
              // Le code d'attribut est normalise avec son prefixe de livre avant ecriture.
              // Les augmentations viennent de TabAttribut (WinPersonnage), dont la ligne de
              // codes est semee par AttributInit a partir des constantes ConstCaracXxx, qui
              // valent 'ATTR_WS' SANS prefixe - d'ou des fiches melangeant les deux formes,
              // et un filtre de sorts qui ne matchait plus (CONTEXT.md 2.19). XmlCreeCodeLivre
              // est idempotente : elle ne prefixe que si le code ne l'est pas deja.
              XMLContent.Add(XmlLigneDonnee(ConstXmlCarac,
                XmlCreeCodeLivre(PAttribut.Livre, PersonnageAttribut.CodeAttribut),
                IntToStr(PersonnageAttribut.Valeur)));
              XMLContent.Add(XmlCommentaire(PAttribut.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCarac));

          // Compétences
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompMetier));
          for PersonnageCompetence in Personnage.AugmentationCompetence do
            begin
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence,
                CodeNormalise(PersonnageCompetence.CodeCompetence, PCompetence.Livre),
                IntToStr(PersonnageCompetence.Valeur)));
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompMetier));

          // Talents
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
          for Personnagetalent in Personnage.AugmentationTalent do
            Begin
              PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
              XMLContent.Add(XmlLigneDonnee(ConstXmlTalent,
                CodeNormalise(PersonnageTalent.CodeTalent, PTalent.Livre),
                IntToStr(PersonnageTalent.Valeur)));
              ListeLivres:= PersonnageLivre(ListeLivres, PTalent.livre);
              XMLContent.Add(XmlCommentaire(PTalent.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreTalent));
        XMLContent.Add(XmlFin(ConstXmlChapitreAugmentation));

        // Compétence de Metier en cours
        XMLContent.Add(XmlDebut(ConstXmlChapitreCompetence));
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompMetier));
          for PersonnageCompetence in Personnage.MetierCompetence do
            begin
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence,
                CodeNormalise(PersonnageCompetence.CodeCompetence, PCompetence.Livre),
                IntToStr(PersonnageCompetence.Valeur)));
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompMetier));
        XMLContent.Add(XmlFin(ConstXmlChapitreCompetence));

        // Talents de Metier en cours
        XMLContent.Add(XmlDebut(ConstXmlChapitreTalent));
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalMetier));
          for PersonnageTalent in Personnage.MetierTalent do
            begin
              PTalent     := ChercheTalent(PersonnageTalent.CodeTalent);
              XMLContent.Add(XmlLigneDonnee(ConstXmlTalent,
                CodeNormalise(PersonnageTalent.CodeTalent, PTalent.Livre),
                IntToStr(PersonnageTalent.Valeur)));
              ListeLivres := PersonnageLivre(ListeLivres, PTalent.livre);
              XMLContent.Add(XmlCommentaire(PTalent.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreTalMetier));
        XMLContent.Add(XmlFin(ConstXmlChapitreTalent));

        // anciens métiers
        XMLContent.Add(XmlDebut(ConstXmlChapitreOldWork));
          For PersonnageMetier in Personnage.MetierAncien do
            begin
              // chercheMetier portait sur Personnage.MetierEnCours et non sur le metier de la
              // boucle : la liste des livres recevait le livre du metier COURANT pour chaque
              // ancien metier. Corrige en meme temps que le prefixe. CONTEXT.md 2.19.
              PMetier := chercheMetier(PersonnageMetier.CodeMetier);
              XMLContent.Add(XmlLigneDonnee(ConstXmlWork,
                CodeNormalise(PersonnageMetier.CodeMetier, PMetier.Livre)+SeparateurMulti+IntToStr(PersonnageMetier.NiveauMetier),
                IntToStr(PersonnageMetier.CoutXp)));
              ListeLivres:= PersonnageLivre(ListeLivres, PMetier.livre);
              XMLContent.Add(XmlCommentaire(PMetier.Libelle));
            end;
        XMLContent.Add(XmlFin(ConstXmlChapitreOldWork));

        // Equipement
        XMLContent.Add(XmlDebut(ConstXmlChapitreEquipement));

          // Armes
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreArme));
          for PersonnageEquipement in Personnage.Equipement do
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipWe) then
              begin
               PArme.CodeArme:='';
               PArme := ChercheArme(PersonnageEquipement.CodeEquipement);
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem,
                 CodeNormalise(PersonnageEquipement.CodeEquipement, PArme.Livre),
                 PersonnageEquipement.QualiteEquipement,
                 XmlAttributEquipementPorte(PersonnageEquipement.Porte)));
               ListeLivres:= PersonnageLivre(ListeLivres, PArme.livre);
               if (PArme.CodeArme <> '') then
                 XMLContent.Add(XmlCommentaire(PArme.Libelle));
              end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreArme));

          // Armures
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreArmure));
          for PersonnageEquipement in Personnage.Equipement do
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAr) then
              begin
               PArmure.CodeArmure:='';
               PArmure := ChercheArmure(PersonnageEquipement.CodeEquipement);
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem,
                 CodeNormalise(PersonnageEquipement.CodeEquipement, PArmure.Livre),
                 PersonnageEquipement.QualiteEquipement,
                 XmlAttributEquipementPorte(PersonnageEquipement.Porte)));
               ListeLivres:= PersonnageLivre(ListeLivres, PArmure.livre);
               if (PArmure.CodeArmure<>'') then
                 XMLContent.Add(XmlCommentaire(PArmure.Libelle));
              end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreArmure));

          // Set d'armure
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreArmureSimp));
          for PersonnageEquipement in Personnage.Equipement do
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipArS) then
              begin
                PArmureSimplifiee.CodeArmure:='';
                PArmureSimplifiee := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
                XMLContent.Add(XmlLigneDonnee(ConstXmlItem,
                  CodeNormalise(PersonnageEquipement.CodeEquipement, PArmureSimplifiee.Livre),
                  PersonnageEquipement.QualiteEquipement,
                  XmlAttributEquipementPorte(PersonnageEquipement.Porte)));
                // etait PArmure.livre : le livre de l'armure du bloc PRECEDENT. CONTEXT.md 2.19.
                ListeLivres:= PersonnageLivre(ListeLivres, PArmureSimplifiee.livre);
                if (PArmureSimplifiee.CodeArmure<>'') then
                  XMLContent.Add(XmlCommentaire(PArmureSimplifiee .Libelle));
              end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreArmureSimp));

          // Divers
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreDivers));
          for PersonnageEquipement in Personnage.Equipement do
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipDi) then
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem, PersonnageEquipement.CodeEquipement, PersonnageEquipement.QualiteEquipement));
          XMLContent.Add(XmlFin(ConstXmlSousChapitreDivers));

          // Sorts
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreSort));
          for PersonnageEquipement in Personnage.Equipement do
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipSp) then
              begin
               PSort.CodeSort:='';
               PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem,
                 CodeNormalise(PersonnageEquipement.CodeEquipement, PSort.Livre),
                 IntToStr(PersonnageEquipement.CoutXp)));
               ListeLivres:= PersonnageLivre(ListeLivres, PSort.livre);
               if (PSort.CodeSort<>'') then
                 XMLContent.Add(XmlCommentaire(PSort.Libelle));
              end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreSort));

        XMLContent.Add(XmlFin(ConstXmlChapitreEquipement));

        // Historique de corruption
        XMLContent.Add(XmlDebut(ConstXmlChapitreCorruption));
          for PersonnageCorruption in Personnage.Corruption do
            XMLContent.Add(XmlLigneDonnee(ConstXmlItem, IntToStr(PersonnageCorruption.Montant), PersonnageCorruption.Libelle));
        XMLContent.Add(XmlFin(ConstXmlChapitreCorruption));

        // Mutations obtenues (CONTEXT.md §2.7) - référence (Code stable du catalogue), pas le texte
        XMLContent.Add(XmlDebut(ConstXmlChapitreMutation));
          for PersonnageMutation in Personnage.Mutations do
            begin
              PCorruptionTable.Code := '';
              PCorruptionTable := ChercheCorruptionTable(PersonnageMutation.Code);
              XMLContent.Add(XmlLigneDonnee(ConstXmlItem,
                CodeNormalise(PersonnageMutation.Code, PCorruptionTable.Livre), ''));
              if (PCorruptionTable.Code <> '') then
                XMLContent.Add(XmlCommentaire(PCorruptionTable.Libelle));
            end;
        XMLContent.Add(XmlFin(ConstXmlChapitreMutation));

        // Livres
        XMLContent.Add(XmlLigne(ConstXmlLibelleLivre, ListeLivres));
        if Personnage.LivresAcceptes  = '' then
          Personnage.LivresAcceptes := ListeLivres;
        XMLContent.Add(XmlLigne(ConstXmlRegle,Personnage.LivresAcceptes));

        // Cout Xp hors norme
        XMLContent.Add(XmlDebut(ConstXmlChapitreCoutXp));

          // Attribut
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCarac));
          For PersonnageXpAttribut in Personnage.XpCoutAttribut do
            begin
              PAttribut := ChercheAttribut(PersonnageXpAttribut.CodeAttribut);
              // Le code est colle a ":debut-fin" : seul le code est prefixe.
              XMLContent.Add(XmlLigneDonnee(ConstXmlCarac,
                CodeNormalise(PersonnageXpAttribut.CodeAttribut, PAttribut.Livre)+DriveSeparator+IntToStr(PersonnageXpAttribut.Debut)+SeparateurChance+IntToStr(PersonnageXpAttribut.Fin),
                IntToStr(PersonnageXpAttribut.CoutXp)));
              PAttribut.CodeAttribut := '';
              PAttribut := ChercheAttribut(PersonnageXpAttribut.CodeAttribut);
              if (PAttribut.CodeAttribut <> '') then
                XMLContent.Add(XmlCommentaire(PAttribut.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCarac));

          // Compétence
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompetence));
          For PersonnageXpCompetence in Personnage.XpCoutCompetence do
            begin
              PCompetence := ChercheCompetence(PersonnageXpCompetence.CodeCompetence);
              // Le code est colle a ":debut-fin" : seul le code est prefixe.
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence,
                CodeNormalise(PersonnageXpCompetence.CodeCompetence, PCompetence.Livre)+DriveSeparator+IntToStr(PersonnageXpCompetence.Debut)+SeparateurChance+IntToStr(PersonnageXpCompetence.Fin),
                IntToStr(PersonnageXpCompetence.CoutXp)));
              PCompetence.CodeCompetence := '';
              PCompetence := ChercheCompetence(PersonnageXpCompetence.CodeCompetence);
              if (PCompetence.CodeCompetence <> '') then
                XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompetence));

          // Talent
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
          For PersonnageXpTalent in Personnage.XpCoutTalent do
            begin
              PTalent := ChercheTalent(PersonnageXpTalent.CodeTalent);
              // Le code est colle a ":debut-fin" : seul le code est prefixe.
              XMLContent.Add(XmlLigneDonnee(ConstXmlTalent,
                CodeNormalise(PersonnageXpTalent.CodeTalent, PTalent.Livre)+DriveSeparator+IntToStr(PersonnageXpTalent.Debut)+SeparateurChance+IntToStr(PersonnageXpTalent.Fin),
                IntToStr(PersonnageXpTalent.CoutXp)));
              PTalent.CodeTalent := '';
              PTalent := ChercheTalent(PersonnageXpTalent.CodeTalent);
              if (PTalent.CodeTalent <> '') then
                XMLContent.Add(XmlCommentaire(PTalent.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreTalent));

        XMLContent.Add(XmlFin(ConstXmlChapitreCoutXp));

        // Options
        XMLContent.Add(XmlLigne(ConstXmlOptions, Personnage.Options));

        // Appartenances - voir CONTEXT.md 2.44.
        XMLContent.Add(XmlLigne(ConstXmlAppartenance, Personnage.Appartenance));

      XMLContent.Add(XmlFin(ConstXmlPersonnage));

      // Enregistrer le contenu XML dans un fichier
      XMLContent.SaveToFile(fileName);

      Result := True; // Définit le résultat à True si l'enregistrement s'est bien déroulé

    except
      on E: Exception do
        WriteLn('Erreur lors de la création du fichier XML : ' + E.Message);
    end;
  finally
    XMLContent.Free;
  end;
end;

function PersonnageXmlChargement(fileName: string): StructurePersonnage;
var
  XMLDoc:                     TXMLDocument;
  PlayerNode, ChapterRaceNode, ChapterItemNode, ItemNode, SubChapterNode, Node: TDOMNode;
  Code:                       String;
  Personnage:                 StructurePersonnage;
  PersonnageMetier:           StructurePersonnageMetier;
  PersonnageAttribut:         StructurePersonnageAttribut;
  PersonnageCompetence:       StructurePersonnageCompetence;
  PersonnageTalent:           StructurePersonnageTalent;
  PersonnageEquipement:       StructurePersonnageEquipement;
  PersonnageCorruption:       StructurePersonnageCorruption;
  PersonnageMutation:         StructurePersonnageMutation;
  PersonnageXpAttribut:       StructurePersonnageXpAttribut;
  PersonnageXpCompetence:     StructurePersonnageXpCompetence;
  PersonnageXpTalent:         StructurePersonnageXpTalent;
  PersonnageTalentCompetence: StructurePersonnageTalentPersonnage;
  PTalent:                    StructureTalent;
  ListeCompetence:            String = '';
  Asterisque:                 Integer = 0;
  IndiceTalent:               Integer = 0;
begin
  XMLDoc := TXMLDocument.Create;
  try
    ReadXMLFile(XMLDoc, FileName);

    PlayerNode := XMLDoc.DocumentElement;
    if Assigned(PlayerNode) and (PlayerNode.NodeName = ConstXmlPersonnage) then
    begin
      // Lire le nom du joueur
      Personnage.CreationAttribut     := [];
      Personnage.CreationCompetence35 := [];
      Personnage.CreationCompetence40 := [];
      Personnage.CreationTalent       := [];
      Personnage.Equipement           := [];
      Personnage.Corruption           := [];
      Personnage.Mutations            := [];
      Personnage.XpCoutAttribut       := [];
      Personnage.XpCoutCompetence     := [];
      Personnage.XpCoutTalent         := [];
      Personnage.TalentCompetence     := [];

      Personnage.NomPersonnage        := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlName).TextContent));
      Personnage.XpTotal              := StrToIntDef(RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlXp).TextContent)),0);
      if Assigned(PlayerNode.FindNode(ConstXmlXp25Total)) then
        Personnage.Xp25Total            := StrToIntDef(RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlXp25Total).TextContent)),0);
      if Assigned(PlayerNode.FindNode(ConstXmlXpCurrent)) then
        Personnage.XpActuel           := StrToIntDef(RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlXpCurrent).TextContent)),0);
      PersonnageMetier.CodeMetier     := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlWork).TextContent));
      PersonnageMetier.NiveauMetier   := StrToInt(RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlNvWork).TextContent)));
      Personnage.MetierEnCours        := PersonnageMetier;
      Personnage.Race                 := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlRace).TextContent));
      if Assigned(PlayerNode.FindNode(ConstXmlLibelleLivre)) then
        Personnage.LivresObligatoires := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlLibelleLivre).TextContent));
      if Assigned(PlayerNode.FindNode(ConstXmlRegle)) then
        Personnage.LivresAcceptes     := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlRegle).TextContent));
      if Assigned(PlayerNode.FindNode(ConstXmlOptions)) then
        Personnage.Options            := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlOptions).TextContent));
      // Balise absente des fiches enregistrees avant le 04/09/2026 : le test Assigned
      // suffit a les charger sans erreur, Appartenance reste vide. CONTEXT.md 2.44.
      Personnage.Appartenance         := '';
      if Assigned(PlayerNode.FindNode(ConstXmlAppartenance)) then
        Personnage.Appartenance       := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlAppartenance).TextContent));
      if Assigned(PlayerNode.FindNode(ConstXmlAge)) then
        Personnage.Age                := StrToInt(RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlAge).TextContent)));
      if Assigned(PlayerNode.FindNode(ConstXmlHeight)) then
        Personnage.Height             := StrToInt(RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlHeight).TextContent)));
      if Assigned(PlayerNode.FindNode(ConstXmlHairColors)) then
        Personnage.HairColors         := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlHairColors).TextContent));
      if Assigned(PlayerNode.FindNode(ConstXmlEyeColors)) then
        Personnage.EyeColors          := RemoveQuotes(UTF8Encode(PlayerNode.FindNode(ConstXmlEyeColors).TextContent));
      Personnage.Asterisque           := 0;

      ChapterRaceNode := PlayerNode.FindNode(ConstXmlChapitreCreation);
      if Assigned(ChapterRaceNode) then
        begin
          // Lire les caractéristiques de la sous-section CARAC
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCarac);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlCarac then
                    begin
                      PersonnageAttribut.CodeAttribut  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageAttribut.Valeur        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.CreationAttribut      += [PersonnageAttribut];
                    end;
                  Node := Node.NextSibling;
                end;
            end;

          // Lire les compétences de la sous-section COMP
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCompSpecie);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlCompetence then
                    begin
                      PersonnageCompetence.CodeCompetence:= RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageCompetence.Valeur        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.CreationCompetence35    += [PersonnageCompetence];
                    end;
                  Node := Node.NextSibling;
                end;
            end;

          // Lire les autres compétences de la sous-section COMP
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCompCreation);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlCompetence then
                    begin
                      PersonnageCompetence.CodeCompetence:= RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageCompetence.Valeur        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.CreationCompetence40    += [PersonnageCompetence];
                    end;
                  Node := Node.NextSibling;
                end;
            end;

          // Lire les talents de la sous-section TALENT
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreTalent);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlTalent then
                    begin
                      PersonnageTalent.CodeTalent     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageTalent.Valeur         := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      PersonnageTalent.Asterisque     := 0;
                      Personnage.CreationTalent       += [PersonnageTalent];
                      // test compétence liées au talent
                      PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
                      if (PTalent.CompAjoutee <> '') then
                        if (Pos(AjouteAccolade(PTalent.CompAjoutee), ListeCompetence) = 0) then
                          begin
                            PersonnageTalentCompetence.CodeCompetence  := PTalent.CompAjoutee;
                            PersonnageTalentCompetence.CodeTalent      := PTalent.CodeTalent;
                            Personnage.TalentCompetence                += [PersonnageTalentCompetence];
                            ListeCompetence                            := ListeCompetence + AjouteAccolade(PTalent.CompAjoutee);
                          end;
                    end;
                    Node := Node.NextSibling;
                  end;
              end;
          end;

      ChapterRaceNode := PlayerNode.FindNode(ConstXmlChapitreAugmentation);
      if Assigned(ChapterRaceNode) then
      begin
        // Lire les caractéristiques de la sous-section CARAC
        SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCarac);
        if Assigned(SubChapterNode) then
          begin
            Node := SubChapterNode.FirstChild;
            while Assigned(Node) do
              begin
                if Node.NodeName = ConstXmlCarac then
                  begin
                    PersonnageAttribut.CodeAttribut  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                    PersonnageAttribut.Valeur        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                    Personnage.AugmentationAttribut  += [PersonnageAttribut];
                  end;
                Node := Node.NextSibling;
              end;
          end;

        // Lire les compétences de la sous-section COMP
        SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCompMetier);
        if Assigned(SubChapterNode) then
          begin
            Node := SubChapterNode.FirstChild;
            while Assigned(Node) do
              begin
                if Node.NodeName = ConstXmlCompetence then
                  begin
                    PersonnageCompetence.CodeCompetence:= RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                    PersonnageCompetence.Valeur        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                    Personnage.AugmentationCompetence  += [PersonnageCompetence];
                  end;
                Node := Node.NextSibling;
              end;
          end;


        // Lire les talents de la sous-section TALENT
        SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreTalent);
        if Assigned(SubChapterNode) then
          begin
            Node := SubChapterNode.FirstChild;
            while Assigned(Node) do
              begin
                if Node.NodeName = ConstXmlTalent then
                  begin
                    PersonnageTalent.CodeTalent     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                    PersonnageTalent.Valeur         := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                    PersonnageTalent.Asterisque     := 0;
                    Personnage.AugmentationTalent   += [PersonnageTalent];
                    // test compétence liées au talent
                    PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
                    if (PTalent.CompAjoutee <> '') then
                      if (Pos(AjouteAccolade(PTalent.CompAjoutee), ListeCompetence) = 0) then
                        begin
                          PersonnageTalentCompetence.CodeCompetence  := PTalent.CompAjoutee;
                          PersonnageTalentCompetence.CodeTalent      := PTalent.CodeTalent;
                          Personnage.TalentCompetence                += [PersonnageTalentCompetence];
                          ListeCompetence                            := ListeCompetence + AjouteAccolade(PTalent.CompAjoutee);
                        end;
                  end;
                  Node := Node.NextSibling;
                end;
            end;
        end;

      // carrière
      ChapterItemNode := PlayerNode.FindNode(ConstXmlChapitreOldWork);
        if Assigned(ChapterItemNode) then
          begin
            ItemNode := ChapterItemNode.FirstChild;
            while Assigned(ITemNode) do
              begin
                if (ItemNode.NodeType = ELEMENT_NODE) then
                  begin
                    Code := RemoveQuotes(UTF8Encode(ITemNode.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                    PersonnageMetier.CodeMetier   := ExtractStringBefore(Code,SeparateurMulti);
                    PersonnageMetier.NiveauMetier := StrToIntDef(ExtractStringAfter(Code,SeparateurMulti),0);
                    PersonnageMetier.CoutXp       := StrToIntDef(RemoveQuotes(UTF8Encode(ITemNode.TextContent)),0);
                    Personnage.MetierAncien       += [PersonnageMetier];
                  end;
                ItemNode := ItemNode.NextSibling;
              end;
          end;

      // Equipement
      ChapterItemNode := PlayerNode.FindNode(ConstXmlChapitreEquipement);
      if Assigned(ChapterItemNode) then
        begin
          ItemNode := ChapterItemNode.FirstChild;
          if Assigned(ITemNode) then
            begin
              // Lire armes
              SubChapterNode := ChapterItemNode.FindNode(ConstXmlSousChapitreArme);
              if Assigned(SubChapterNode) then
                begin
                  Node := SubChapterNode.FirstChild;
                  while Assigned(Node) do
                    begin
                      if (Node.NodeType = ELEMENT_NODE) then
                        begin
                          PersonnageEquipement.CodeEquipement     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                          PersonnageEquipement.TypeEquipement     := TrimRight(TypeEquipWe);
                          PersonnageEquipement.QualiteEquipement  := RemoveQuotes(UTF8Encode(Node.TextContent));
                          PersonnageEquipement.Porte              := Assigned(Node.Attributes.GetNamedItem(ConstXmlEquipementPorte));
                          Personnage.Equipement                   += [PersonnageEquipement];
                        end;
                      Node  := Node.NextSibling;
                    end;
                end;

              // Lire armures
              SubChapterNode := ChapterItemNode.FindNode(ConstXmlSousChapitreArmure);
              if Assigned(SubChapterNode) then
                begin
                  Node := SubChapterNode.FirstChild;
                  while Assigned(Node) do
                    begin
                      if (Node.NodeType = ELEMENT_NODE) then
                        begin
                          PersonnageEquipement.CodeEquipement     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                          PersonnageEquipement.TypeEquipement     := TrimRight(TypeEquipAr);
                          PersonnageEquipement.QualiteEquipement  := RemoveQuotes(UTF8Encode(Node.TextContent));
                          PersonnageEquipement.Porte              := Assigned(Node.Attributes.GetNamedItem(ConstXmlEquipementPorte));
                          Personnage.Equipement                   += [PersonnageEquipement];
                        end;
                      Node  := Node.NextSibling;
                    end;
                end;

              // Lire set d'armures
              SubChapterNode := ChapterItemNode.FindNode(ConstXmlSousChapitreArmureSimp);
              if Assigned(SubChapterNode) then
                begin
                  Node := SubChapterNode.FirstChild;
                  while Assigned(Node) do
                    begin
                      if (Node.NodeType = ELEMENT_NODE) then
                        begin
                          PersonnageEquipement.CodeEquipement     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                          PersonnageEquipement.TypeEquipement     := TrimRight(TypeEquipArS);
                          PersonnageEquipement.QualiteEquipement  := RemoveQuotes(UTF8Encode(Node.TextContent));
                          PersonnageEquipement.Porte              := Assigned(Node.Attributes.GetNamedItem(ConstXmlEquipementPorte));
                          Personnage.Equipement                   += [PersonnageEquipement];
                        end;
                      Node  := Node.NextSibling;
                    end;
                end;

              // Lire les autres équipements
              SubChapterNode := ChapterItemNode.FindNode(ConstXmlSousChapitreDivers);
              if Assigned(SubChapterNode) then
                begin
                  Node := SubChapterNode.FirstChild;
                  while Assigned(Node) do
                    begin
                      PersonnageEquipement.CodeEquipement     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageEquipement.TypeEquipement     := TrimRight(TypeEquipDi);
                      PersonnageEquipement.QualiteEquipement  := RemoveQuotes(UTF8Encode(Node.TextContent));
                      PersonnageEquipement.Porte              := False;
                      Personnage.Equipement                   += [PersonnageEquipement];
                      Node  := Node.NextSibling;
                    end;
                end;

            // Lire les sorts
            SubChapterNode := ChapterItemNode.FindNode(ConstXmlSousChapitreSort);
            if Assigned(SubChapterNode) then
              begin
                Node := SubChapterNode.FirstChild;
                while Assigned(Node) do
                  begin
                    if (Node.NodeType = ELEMENT_NODE) then
                      begin
                        PersonnageEquipement.CodeEquipement     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                        PersonnageEquipement.TypeEquipement     := TrimRight(TypeEquipSp);
                        PersonnageEquipement.CoutXp             := StrToIntdef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                        PersonnageEquipement.Porte              := False;
                        Personnage.Equipement                   += [PersonnageEquipement];
                      end;
                    Node := Node.NextSibling;
                  end;
              end;
          end;
        end;

      // Historique de corruption
      ChapterItemNode := PlayerNode.FindNode(ConstXmlChapitreCorruption);
      if Assigned(ChapterItemNode) then
        begin
          ItemNode := ChapterItemNode.FirstChild;
          while Assigned(ItemNode) do
            begin
              if (ItemNode.NodeType = ELEMENT_NODE) then
                begin
                  PersonnageCorruption.Montant := StrToIntDef(RemoveQuotes(UTF8Encode(ItemNode.Attributes.GetNamedItem(ConstXmlData).NodeValue)),0);
                  PersonnageCorruption.Libelle := RemoveQuotes(UTF8Encode(ItemNode.TextContent));
                  Personnage.Corruption        += [PersonnageCorruption];
                end;
              ItemNode := ItemNode.NextSibling;
            end;
        end;

      // Mutations obtenues (CONTEXT.md §2.7) - référence (Code stable du catalogue), pas le texte
      ChapterItemNode := PlayerNode.FindNode(ConstXmlChapitreMutation);
      if Assigned(ChapterItemNode) then
        begin
          ItemNode := ChapterItemNode.FirstChild;
          while Assigned(ItemNode) do
            begin
              if (ItemNode.NodeType = ELEMENT_NODE) then
                begin
                  PersonnageMutation.Code := RemoveQuotes(UTF8Encode(ItemNode.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                  Personnage.Mutations    += [PersonnageMutation];
                end;
              ItemNode := ItemNode.NextSibling;
            end;
        end;

      ChapterRaceNode := PlayerNode.FindNode(ConstXmlChapitreCompetence);
      if Assigned(ChapterRaceNode) then
        begin
          // Lire les caractéristiques de la sous-section CARAC
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCompMetier);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if (Node.NodeType = ELEMENT_NODE) then
                    begin
                      PersonnageCompetence.CodeCompetence := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageCompetence.Valeur         := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.MetierCompetence         += [PersonnageCompetence];
                    end;
                  Node := Node.NextSibling;
                end;
            end;
        end;

      ChapterRaceNode := PlayerNode.FindNode(ConstXmlChapitreTalent);
      if Assigned(ChapterRaceNode) then
        begin
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreTalMetier);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if (Node.NodeType = ELEMENT_NODE) then
                    begin
                      PersonnageTalent.CodeTalent := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageTalent.Valeur     := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      PersonnageTalent.Asterisque := 0;
                      Personnage.MetierTalent     += [PersonnageTalent];
                    end;
                  Node := Node.NextSibling;
                end;
            end;
        end;

      // Cout d'XP hors normes
      ChapterRaceNode := PlayerNode.FindNode(ConstXmlChapitreCoutXp);
      if Assigned(ChapterRaceNode) then
        begin
          // Cout pour les attributs
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCarac);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlCarac then
                    begin
                      Code := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageXpAttribut.CodeAttribut  := ExtractStringBefore(Code,DriveSeparator);
                      PersonnageXpAttribut.Debut         := StrToIntDef(ExtractStringBefore(ExtractStringAfter(Code,DriveSeparator),SeparateurChance),0);
                      PersonnageXpAttribut.Fin           := StrToIntDef(ExtractStringAfter(ExtractStringAfter(Code,DriveSeparator),SeparateurChance),0);
                      PersonnageXpAttribut.CoutXp        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.XpCoutAttribut          += [PersonnageXpAttribut];
                    end;
                  Node := Node.NextSibling;
                end;
            end;

          // Cout pour les Competences
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreCompetence);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlCompetence then
                    begin
                      Code := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageXpCompetence.CodeCompetence  := ExtractStringBefore(Code,DriveSeparator);
                      PersonnageXpCompetence.Debut           := StrToIntDef(ExtractStringBefore(ExtractStringAfter(Code,DriveSeparator),SeparateurChance),0);
                      PersonnageXpCompetence.Fin             := StrToIntDef(ExtractStringAfter(ExtractStringAfter(Code,DriveSeparator),SeparateurChance),0);
                      PersonnageXpCompetence.CoutXp          := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.XpCoutCompetence            += [PersonnageXpCompetence];
                    end;
                  Node := Node.NextSibling;
                end;
            end;

          // Cout pour les Talents
          SubChapterNode := ChapterRaceNode.FindNode(ConstXmlSousChapitreTalent);
          if Assigned(SubChapterNode) then
            begin
              Node := SubChapterNode.FirstChild;
              while Assigned(Node) do
                begin
                  if Node.NodeName = ConstXmlTalent then
                    begin
                      Code := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PersonnageXpTalent.CodeTalent  := ExtractStringBefore(Code,DriveSeparator);
                      PersonnageXpTalent.Debut       := StrToIntDef(ExtractStringBefore(ExtractStringAfter(Code,DriveSeparator),SeparateurChance),0);
                      PersonnageXpTalent.Fin         := StrToIntDef(ExtractStringAfter(ExtractStringAfter(Code,DriveSeparator),SeparateurChance),0);
                      PersonnageXpTalent.CoutXp      := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                      Personnage.XpCoutTalent        += [PersonnageXpTalent];
                    end;
                  Node := Node.NextSibling;
                end;
            end;
        end;

      // Lire Les talents de création
      for IndiceTalent := 0 to high(Personnage.CreationTalent) Do
        if Personnage.CreationTalent[indiceTalent].Asterisque = 0  then
          begin
            Asterisque := PersonnageTalentAsterisque(Personnage, Personnage.CreationTalent[indiceTalent].CodeTalent);
            if Asterisque <> 0 then
              begin
                Personnage.Asterisque := Asterisque;
                Personnage.CreationTalent[indiceTalent].Asterisque := Asterisque;
              end;
          end;

      // Lire Les talents ajoutés
      for IndiceTalent := 0 to high(Personnage.AugmentationTalent) Do
        if Personnage.AugmentationTalent[indiceTalent].Asterisque = 0  then
          begin
            Asterisque := PersonnageTalentAsterisque(Personnage, Personnage.AugmentationTalent[indiceTalent].CodeTalent);
            if Asterisque <> 0 then
              Personnage.Asterisque := Asterisque;
            Personnage.AugmentationTalent[indiceTalent].Asterisque := Asterisque;
          end;

    end;
  finally
    PlayerNode.Free;
    ChapterRaceNode.Free;
    ChapterItemNode.Free;
    ItemNode.Free;
    SubChapterNode.Free;
    Node.Free;
    XMLDoc.Free;
  end;

  result := Personnage;
end;

// Ecrit dans la fiche les competences et talents greffes par les APPARTENANCES du
// personnage (regiments de l'Empire, ordres de chevalerie, cultes). CONTEXT.md 2.44.
//
// POURQUOI ON ECRIT AU LIEU DE CALCULER A L'AFFICHAGE (decision Nono, 04/09/2026) :
// le livre traite ces elements "as if added to their Career". Or dans le projet, etre
// une competence de carriere ne se joue pas dans la grille mais dans
// Personnage.MetierCompetence, qui alimente CalculTableExperience - donc les tables
// d'avance, le cout XP et le PDF. En les ecrivant ici, tout le reste marche sans qu'aucun
// ecran n'ait a connaitre les appartenances. C'est aussi ce qui satisfait naturellement la
// regle de persistance du livre : "If you leave your Regiment ... you maintain all
// additional Skills and Talents."
//
// La Valeur portee est le NUMERO DU PALIER, exactement comme les competences de metier
// ecrites en une fois pour les quatre niveaux a l'entree dans une carriere : c'est
// CalculTableExperience qui filtre ensuite sur Valeur <= niveau courant.
//
// Un element portant SeparateurMulti ('A/B') est greffe TEL QUEL, code de choix compris :
// les deux tableaux d'augmentation savent le resoudre. ListeMetierCompetence et
// ListeTalent aplatissent les branches du '/', la colonne "Spe" s'affiche des que la liste
// rendue compte plus d'une entree, WinSpecialisation propose les branches, et le
// double-clic reecrit le code retenu dans MetierCompetence / MetierTalent. Verifie le
// 04/09/2026 des deux cotes. Ce n'est donc pas a cette procedure de trancher le choix.
Procedure PersonnageAppliqueGreffes(var Personnage: StructurePersonnage);
var
  GreffeCompetence:     String;
  GreffeTalent:         String;
  Liste:                TStringList;
  Ind:                  Integer;
  Code:                 String;
  Trouve:               Boolean;
  PNiveau:              Integer;
  PersonnageCompetence: StructurePersonnageCompetence;
  PersonnageTalent:     StructurePersonnageTalent;
  Appartenances:        TStringList;
  IndApp:               Integer;
  Paliers:              TListCareerBonusNiveau;
  Palier:               StructureCareerBonusNiveau;
begin
  if Trim(Personnage.Appartenance) = '' then
    Exit;

  Appartenances := TStringList.Create;
  try
    ExtractStrings([','], [], PChar(Personnage.Appartenance), Appartenances);
    for IndApp := 0 to Appartenances.Count - 1 do
      begin
        if Trim(Appartenances[IndApp]) = '' then
          continue;
        // NiveauxDuCareerBonus rend une liste dont l'APPELANT est proprietaire.
        Paliers := NiveauxDuCareerBonus(Trim(Appartenances[IndApp]));
        try
          for Palier in Paliers do
            begin
              if Palier.Niveau <= 0 then
                continue;
              PNiveau          := Palier.Niveau;
              GreffeCompetence := Palier.ListeCompetence;
              GreffeTalent     := Palier.ListeTalent;

              // Competences du palier
              if Trim(GreffeCompetence) <> '' then
                begin
                  Liste := TStringList.Create;
                  try
                    ExtractStrings([','], [], PChar(GreffeCompetence), Liste);
                    for Ind := 0 to Liste.Count - 1 do
                      begin
                        Code := Trim(Liste[Ind]);
                        if Code = '' then
                          continue;
                        Trouve := false;
                        for PersonnageCompetence in Personnage.MetierCompetence do
                          if CompareRechercheValeur(PersonnageCompetence.CodeCompetence, Code) then
                            begin
                              Trouve := true;
                              break;
                            end;
                        if not Trouve then
                          begin
                            PersonnageCompetence                := Default(StructurePersonnageCompetence);
                            PersonnageCompetence.CodeCompetence := Code;
                            PersonnageCompetence.Valeur         := PNiveau;
                            Personnage.MetierCompetence         += [PersonnageCompetence];
                          end;
                      end;
                  finally
                    Liste.Free;
                  end;
                end;

              // Talents du palier
              if Trim(GreffeTalent) <> '' then
                begin
                  Liste := TStringList.Create;
                  try
                    ExtractStrings([','], [], PChar(GreffeTalent), Liste);
                    for Ind := 0 to Liste.Count - 1 do
                      begin
                        Code := Trim(Liste[Ind]);
                        if Code = '' then
                          continue;
                        Trouve := false;
                        for PersonnageTalent in Personnage.MetierTalent do
                          if CompareRechercheValeur(PersonnageTalent.CodeTalent, Code) then
                            begin
                              Trouve := true;
                              break;
                            end;
                        if not Trouve then
                          begin
                            PersonnageTalent            := Default(StructurePersonnageTalent);
                            PersonnageTalent.CodeTalent := Code;
                            PersonnageTalent.Valeur     := PNiveau;
                            Personnage.MetierTalent     += [PersonnageTalent];
                          end;
                      end;
                  finally
                    Liste.Free;
                  end;
                end;
            end;
        finally
          Paliers.Free;
        end;
      end;
  finally
    Appartenances.Free;
  end;
end;

Function PersonnageTalentAsterisque(var Personnage:StructurePersonnage; CodeTalent: String): Integer;
var
  Trouve:                 Boolean = False;
  Asterisque:             Integer = 0;
  indiceAttribut:         Integer = 0;
  indiceTalent:           Integer = 0;
  indiceCompetence:       Integer = 0;
begin
  // En Free Pascal, une variable locale initialisee (= valeur) est une constante typee :
  // elle n'est initialisee qu'une fois au demarrage du programme, pas a chaque appel.
  // Sans cette remise a zero explicite, un talent qui ne matche rien heritait de la
  // derniere asterisque laissee par l'appel precedent (Strike Mighty Blow/Strike to
  // Stun/Very Resilient/Knight of the Order of the Hammer partageant tous "(4)" a tort,
  // signale par Nono le 11/09/2026). Meme famille de piege que ChercheCompetence, §2.17.
  Asterisque := 0;
  // traiter les talents qui augmentent les attributs. ListTalentAttributModif -> filtre sur
  // ListTalentModificateur (TypeModif = ConstXmlModifieAttribut) depuis le 11/09/2026,
  // migration ModifyCarac sur le moteur generique - meme donnee, CodeSource remplace
  // CodeTalent et Cible/Facteur remplacent CodeAttribut/Valeur.
  For indiceTalent := 0 to (ListTalentModificateur.count - 1) Do
    if (ListTalentModificateur[indiceTalent].TypeModif = ConstXmlModifieAttribut)
       and CompareRechercheValeur(ListTalentModificateur[indiceTalent].CodeSource, CodeTalent) then
      begin
        Trouve := False;
        for indiceAttribut := 0 to High(Personnage.CreationAttribut) do
          if CompareRechercheValeur(ListTalentModificateur[indiceTalent].Cible, Personnage.CreationAttribut[indiceAttribut].CodeAttribut) then
            begin
              Asterisque := Personnage.Asterisque + 1;
              Trouve     := true;
              break;
            end;
        if Trouve = True then
          begin
            if Personnage.CreationAttribut[indiceAttribut].Bonus <> '' then
              Personnage.CreationAttribut[indiceAttribut].Bonus += '-' ;
            // ValeurDonnee (texte brut) -> Valeur (Integer) le 06/09/2026 : le signe n'est
            // plus recopie tel quel depuis le XML, on le reconstruit - meme convention que
            // PdfPersonnageCreation l.2326 pour Personnage.Corruption[].Montant.
            if ListTalentModificateur[indiceTalent].Facteur > 0 then
              Personnage.CreationAttribut[indiceAttribut].Bonus += '+' + IntToStr(ListTalentModificateur[indiceTalent].Facteur)+' (' + IntToStr(Asterisque) + ')'
            else
              Personnage.CreationAttribut[indiceAttribut].Bonus += IntToStr(ListTalentModificateur[indiceTalent].Facteur)+' (' + IntToStr(Asterisque) + ')';
          end;
      end;

  // traiter les talents qui impactent les compétences créées.
  for indiceTalent := 0 to (ListTalentCompetenceModif.count - 1) Do
    begin
      if CompareRechercheValeur(ListTalentCompetenceModif[indiceTalent].CodeTalent, CodeTalent) then
        begin
          // gérer les compétences 35
          For indiceCompetence := 0 to High(Personnage.CreationCompetence35) do
            if CompareRechercheValeur(ListTalentCompetenceModif[indiceTalent].CodeCompetence, Personnage.CreationCompetence35[indiceCompetence].CodeCompetence) then
              begin
                if Asterisque = 0 then
                  Asterisque := Personnage.Asterisque + 1;
                if CountOccurrences(Personnage.CreationCompetence35[indiceCompetence].Bonus, '(' + IntToStr(Asterisque) + ')') = 0 then
                  begin
                    if Personnage.CreationCompetence35[indiceCompetence].Bonus <> '' then
                      Personnage.CreationCompetence35[indiceCompetence].Bonus += '-';
                    case ListTalentCompetenceModif[indiceTalent].TypeModif of
                      ConstCompetenceInverseDe:
                        Personnage.CreationCompetence35[indiceCompetence].Bonus += '><(' + IntToStr(Asterisque) + ')';
                      ConstCompetenceBonus:
                        Personnage.CreationCompetence35[indiceCompetence].Bonus += 'B(' + IntToStr(Asterisque) + ')';
                    end;
                  end;
              end;
          // gérer les compétences 35
          For indiceCompetence := 0 to High(Personnage.CreationCompetence40) do
            if CompareRechercheValeur(ListTalentCompetenceModif[indiceTalent].CodeCompetence, Personnage.CreationCompetence40[indiceCompetence].CodeCompetence) then
              begin
                if Asterisque = 0 then
                  Asterisque := Personnage.Asterisque + 1;
                if CountOccurrences(Personnage.CreationCompetence40[indiceCompetence].Bonus, '(' + IntToStr(Asterisque) + ')') = 0 then
                  begin
                    if Personnage.CreationCompetence40[indiceCompetence].Bonus <> '' then
                      Personnage.CreationCompetence40[indiceCompetence].Bonus += '-';
                    case ListTalentCompetenceModif[indiceTalent].TypeModif of
                      ConstCompetenceInverseDe:
                        Personnage.CreationCompetence40[indiceCompetence].Bonus += '><(' + IntToStr(Asterisque) + ')';
                      ConstCompetenceBonus:
                        Personnage.CreationCompetence40[indiceCompetence].Bonus += 'B(' + IntToStr(Asterisque) + ')';
                    end;
                  end;
              end;
          // gérer les compétence augmentées
          For indiceCompetence := 0 to High(Personnage.AugmentationCompetence) do
            if CompareRechercheValeur(ListTalentCompetenceModif[indiceTalent].CodeCompetence, Personnage.AugmentationCompetence[indiceCompetence].CodeCompetence) then
              begin
                if Asterisque = 0 then
                  Asterisque := Personnage.Asterisque + 1;
                if CountOccurrences(Personnage.AugmentationCompetence[indiceCompetence].Bonus, '(' + IntToStr(Asterisque) + ')') = 0 then
                  begin
                    if Personnage.AugmentationCompetence[indiceCompetence].Bonus <> '' then
                      Personnage.AugmentationCompetence[indiceCompetence].Bonus += '-';
                    case ListTalentCompetenceModif[indiceTalent].TypeModif of
                      ConstCompetenceInverseDe:
                        Personnage.AugmentationCompetence[indiceCompetence].Bonus += '><(' + IntToStr(Asterisque) + ')';
                      ConstCompetenceBonus:
                        Personnage.AugmentationCompetence[indiceCompetence].Bonus += 'B(' + IntToStr(Asterisque) + ')';
                    end;
                  end;
              end;

        end;
    end;

  Result := Asterisque;

end;

Function PersonnageMutationAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  begin
    Result := PersonnageMutationModificateur(Personnage, ConstXmlModifieAttribut, CodeAttribut);
  end;

Function PersonnageMutationModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  var
    PersonnageMutation: StructurePersonnageMutation;
    indiceModif:        Integer;
  begin
    Result := 0;
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionModificateur.Count - 1) do
        if (ListCorruptionModificateur[indiceModif].TypeModif = TypeModif)
           and CompareRechercheValeur(ListCorruptionModificateur[indiceModif].CodeSource, PersonnageMutation.Code)
           and CompareRechercheValeur(ListCorruptionModificateur[indiceModif].Cible, Cible)
           and ((Trim(ListCorruptionModificateur[indiceModif].Filtre) = '')
                or CompareRechercheValeur(ListCorruptionModificateur[indiceModif].Filtre, Filtre)) then
          Result := Result + ListCorruptionModificateur[indiceModif].Facteur;
  end;

Function PersonnageTalentAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  begin
    // Multiplie par PersonnageTalent.Valeur (niveau du talent) dans PersonnageTalentModificateur
    // depuis le 06/09/2026 : un talent a niveaux multiples (Max different de "1", ex. Luck/
    // Chanceux RULES-T0020, Strong-Minded/Obstine RULES-T0107) donne son ModifyCarac autant de
    // fois que de niveaux pris, comme le faisait l'ancien case (Chance := Chance + Val). Sans
    // effet sur le pilote Fleet Footed (RULES-T0162, Max="1", Valeur toujours 1).
    Result := PersonnageTalentModificateur(Personnage, ConstXmlModifieAttribut, CodeAttribut);
  end;

Function PersonnageTalentModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  var
    PersonnageTalent: StructurePersonnageTalent;
    indiceModif:      Integer;
  begin
    Result := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      for indiceModif := 0 to (ListTalentModificateur.Count - 1) do
        if (ListTalentModificateur[indiceModif].TypeModif = TypeModif)
           and CompareRechercheValeur(ListTalentModificateur[indiceModif].CodeSource, PersonnageTalent.CodeTalent)
           and CompareRechercheValeur(ListTalentModificateur[indiceModif].Cible, Cible)
           and ((Trim(ListTalentModificateur[indiceModif].Filtre) = '')
                or CompareRechercheValeur(ListTalentModificateur[indiceModif].Filtre, Filtre)) then
          Result := Result + ListTalentModificateur[indiceModif].Facteur * PersonnageTalent.Valeur;
    // MetierTalent (talent choisi dans la grille de carriere, distinct de CreationTalent/
    // AugmentationTalent) manquait ici - trou trouve le 11/09/2026 en migrant ModifArmour,
    // deja present sur les 4 cibles migrees avant (ModifyCarac/ModifySkill/ModifyWeapon/
    // ModifyDamage). PersonnageTalentArmureModif, la version dediee encore a migrer, boucle
    // deja les trois listes.
    for PersonnageTalent in Personnage.MetierTalent do
      for indiceModif := 0 to (ListTalentModificateur.Count - 1) do
        if (ListTalentModificateur[indiceModif].TypeModif = TypeModif)
           and CompareRechercheValeur(ListTalentModificateur[indiceModif].CodeSource, PersonnageTalent.CodeTalent)
           and CompareRechercheValeur(ListTalentModificateur[indiceModif].Cible, Cible)
           and ((Trim(ListTalentModificateur[indiceModif].Filtre) = '')
                or CompareRechercheValeur(ListTalentModificateur[indiceModif].Filtre, Filtre)) then
          Result := Result + ListTalentModificateur[indiceModif].Facteur * PersonnageTalent.Valeur;
    for PersonnageTalent in Personnage.AugmentationTalent do
      for indiceModif := 0 to (ListTalentModificateur.Count - 1) do
        if (ListTalentModificateur[indiceModif].TypeModif = TypeModif)
           and CompareRechercheValeur(ListTalentModificateur[indiceModif].CodeSource, PersonnageTalent.CodeTalent)
           and CompareRechercheValeur(ListTalentModificateur[indiceModif].Cible, Cible)
           and ((Trim(ListTalentModificateur[indiceModif].Filtre) = '')
                or CompareRechercheValeur(ListTalentModificateur[indiceModif].Filtre, Filtre)) then
          Result := Result + ListTalentModificateur[indiceModif].Facteur * PersonnageTalent.Valeur;
  end;

Function PersonnageTalentArmeModif(Personnage: StructurePersonnage; PArme: StructureArme): Integer;
  begin
    Result := 0;
    if Trim(PArme.TypeArme) = '' then
      Exit;
    Result := PersonnageTalentModificateur(Personnage, ConstXmlModifieArme, PArme.TypeArme, PArme.CodeCompetence);
  end;

Function PersonnageNiveauDansMetier(Personnage: StructurePersonnage; CodeMetier: String): Integer;
  var
    IndMetier: Integer;
  begin
    Result := 0;
    if CompareRechercheValeur(Personnage.MetierEnCours.CodeMetier, CodeMetier) then
      Result := Personnage.MetierEnCours.NiveauMetier;
    for IndMetier := 0 to High(Personnage.MetierAncien) do
      if CompareRechercheValeur(Personnage.MetierAncien[IndMetier].CodeMetier, CodeMetier) then
        if Personnage.MetierAncien[IndMetier].NiveauMetier > Result then
          Result := Personnage.MetierAncien[IndMetier].NiveauMetier;
  end;

Function PersonnageCareerBonusAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  begin
    Result := PersonnageCareerBonusModificateur(Personnage, ConstXmlModifieAttribut, CodeAttribut);
  end;

Function PersonnageCareerBonusModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  var
    Appartenances:  TStringList;
    IndApp:         Integer;
    IndModif:       Integer;
    NiveauAtteint:  Integer;
    PBonus:         StructureCareerBonus;
    CodeApp:        String;
  begin
    Result := 0;
    if Trim(Personnage.Appartenance) = '' then
      Exit;
    Appartenances := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(Personnage.Appartenance), Appartenances);
      for IndApp := 0 to Appartenances.Count - 1 do
        begin
          CodeApp := Trim(Appartenances[IndApp]);
          if CodeApp = '' then
            continue;
          PBonus        := ChercheCareerBonus(CodeApp);
          NiveauAtteint := PersonnageNiveauDansMetier(Personnage, PBonus.CodeMetier);
          if NiveauAtteint <= 0 then
            continue;
          for IndModif := 0 to (ListCareerBonusModificateur.Count - 1) do
            if (ListCareerBonusModificateur[IndModif].TypeModif = TypeModif)
               and CompareRechercheValeur(ListCareerBonusModificateur[IndModif].CodeSource, CodeApp)
               and CompareRechercheValeur(ListCareerBonusModificateur[IndModif].Cible, Cible)
               and ((Trim(ListCareerBonusModificateur[IndModif].Filtre) = '')
                    or CompareRechercheValeur(ListCareerBonusModificateur[IndModif].Filtre, Filtre))
               and (ListCareerBonusModificateur[IndModif].Niveau <= NiveauAtteint) then
              Result := Result + ListCareerBonusModificateur[IndModif].Facteur;
        end;
    finally
      Appartenances.Free;
    end;
  end;

Function PersonnageCareerBonusCompetenceModif(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  begin
    Result := PersonnageCareerBonusModificateur(Personnage, ConstXmlModifieCompetence, CodeCompetence);
  end;

Function PersonnageCareerBonusArmeModif(Personnage: StructurePersonnage; PArme: StructureArme): Integer;
  begin
    Result := 0;
    if Trim(PArme.TypeArme) = '' then
      Exit;
    Result := PersonnageCareerBonusModificateur(Personnage, ConstXmlModifieArme, PArme.TypeArme, PArme.CodeCompetence);
  end;

Function PersonnageCareerBonusSpecialRule(Personnage: StructurePersonnage): TListCareerBonusSpecialRule;
  var
    Appartenances:  TStringList;
    IndApp:         Integer;
    IndRegle:       Integer;
    NiveauAtteint:  Integer;
    PBonus:         StructureCareerBonus;
    CodeApp:        String;
  begin
    Result := TListCareerBonusSpecialRule.Create;
    if Trim(Personnage.Appartenance) = '' then
      Exit;
    Appartenances := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(Personnage.Appartenance), Appartenances);
      for IndApp := 0 to Appartenances.Count - 1 do
        begin
          CodeApp := Trim(Appartenances[IndApp]);
          if CodeApp = '' then
            continue;
          // Meme filtre de palier que PersonnageCareerBonusArmeModif ci-dessus.
          PBonus        := ChercheCareerBonus(CodeApp);
          NiveauAtteint := PersonnageNiveauDansMetier(Personnage, PBonus.CodeMetier);
          if NiveauAtteint <= 0 then
            continue;
          for IndRegle := 0 to (ListCareerBonusSpecialRule.Count - 1) do
            if CompareRechercheValeur(ListCareerBonusSpecialRule[IndRegle].CodeBonus, CodeApp)
               and (ListCareerBonusSpecialRule[IndRegle].Niveau <= NiveauAtteint) then
              Result.Add(ListCareerBonusSpecialRule[IndRegle]);
        end;
    finally
      Appartenances.Free;
    end;
  end;

Function PersonnageArmeAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  begin
    Result := PersonnageArmeModificateur(Personnage, ConstXmlModifieAttribut, CodeAttribut);
  end;

Function PersonnageArmeModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  var
    PersonnageEquipement: StructurePersonnageEquipement;
    IndModif:             Integer;
  begin
    Result := 0;
    for PersonnageEquipement in Personnage.Equipement do
      if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipWe) then
        for IndModif := 0 to (ListArmeModificateur.Count - 1) do
          if (ListArmeModificateur[IndModif].TypeModif = TypeModif)
             and CompareRechercheValeur(ListArmeModificateur[IndModif].CodeSource, PersonnageEquipement.CodeEquipement)
             and CompareRechercheValeur(ListArmeModificateur[IndModif].Cible, Cible)
             and ((Trim(ListArmeModificateur[IndModif].Filtre) = '')
                  or CompareRechercheValeur(ListArmeModificateur[IndModif].Filtre, Filtre)) then
            Result := Result + ListArmeModificateur[IndModif].Facteur;
  end;

Function PersonnageArmureQualites(Personnage: StructurePersonnage): TStringList;
// Un code de qualite (ListeBonus) par occurrence, pour chaque piece d'armure equipee -
// normale (TypeEquipAR, ChercheArmure) ou simplifiee (TypeEquipARS, ChercheArmureSimplifiee).
// Pas de deduplication : deux pieces portant la meme qualite cumulent. Suffixe numerique
// optionnel ("ARMOB_18 2") retire ; les alternatives ("ARMOB_02/ARMOB_04") sont gardees
// telles quelles, comme l'annotation existante (pdfpersonnage.pas) qui ne les resout pas
// non plus. L'APPELANT est proprietaire de la liste rendue et doit la liberer - meme
// contrat que NiveauxDuCareerBonus (chargemetier.pas, 2.44).
  var
    PersonnageEquipement: StructurePersonnageEquipement;
    PArmure:              StructureArmure;
    PArmureSimplifiee:    StructureArmureSimplifiee;
    ListeBonus:           String;
    Liste:                TStringList;
    Element:              String;
    Ind:                  Integer;
  begin
    Result := TStringList.Create;
    Liste  := TStringList.Create;
    try
      for PersonnageEquipement in Personnage.Equipement do
        begin
          ListeBonus := '';
          if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAR) then
            begin
              PArmure    := ChercheArmure(PersonnageEquipement.CodeEquipement);
              ListeBonus := PArmure.ListeBonus;
            end
          else if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipARS) then
            begin
              PArmureSimplifiee := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
              ListeBonus         := PArmureSimplifiee.ListeBonus;
            end;
          if (ListeBonus <> '') and (ListeBonus <> '-') then
            begin
              Liste.Clear;
              ExtractStrings([','], [], PChar(ListeBonus), Liste);
              for Ind := 0 to Liste.Count - 1 do
                begin
                  Element := Trim(Liste[Ind]);
                  if Pos(' ', Element) > 0 then
                    Element := Trim(ExtractStringBefore(Element, ' '));
                  if Element <> '' then
                    Result.Add(Element);
                end;
            end;
        end;
    finally
      Liste.Free;
    end;
  end;

Function PersonnageArmureQualitesPortees(Personnage: StructurePersonnage): TArrayPersonnageArmureQualitePortee;
  var
    PersonnageEquipement: StructurePersonnageEquipement;
    ListeQualites:        String;
    Liste:                TStringList;
    Alternatives:         TStringList;
    Element:              String;
    Code:                 String;
    Ind, IndAlt:          Integer;
    Entree:               StructurePersonnageArmureQualitePortee;
  begin
    Result       := [];
    Liste        := TStringList.Create;
    Alternatives := TStringList.Create;
    try
      for PersonnageEquipement in Personnage.Equipement do
        if PersonnageEquipement.Porte
           and ((TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAR))
                or (TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipARS))) then
          begin
            // Meme double source que PersonnageArmureBonusTalent : qualites du catalogue
            // (StructureArmure/ArmureSimplifiee.ListeBonus) et qualites de fabrication ajoutees
            // par le joueur (PersonnageEquipement.QualiteEquipement).
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAR) then
              ListeQualites := ChercheArmure(PersonnageEquipement.CodeEquipement).ListeBonus
            else
              ListeQualites := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement).ListeBonus;
            if PersonnageEquipement.QualiteEquipement <> '' then
              begin
                if ListeQualites <> '' then
                  ListeQualites := ListeQualites + ',';
                ListeQualites := ListeQualites + PersonnageEquipement.QualiteEquipement;
              end;

            Liste.Clear;
            ExtractStrings([','], [], PChar(ListeQualites), Liste);
            for Ind := 0 to Liste.Count - 1 do
              begin
                Element := Trim(Liste[Ind]);
                if Pos(' ', Element) > 0 then
                  Element := Trim(ExtractStringBefore(Element, ' '));

                Alternatives.Clear;
                ExtractStrings([SeparateurMulti], [], PChar(Element), Alternatives);
                for IndAlt := 0 to Alternatives.Count - 1 do
                  begin
                    Code := Trim(Alternatives[IndAlt]);
                    if Code <> '' then
                      begin
                        Entree.CodeEquipement := PersonnageEquipement.CodeEquipement;
                        Entree.CodeQualite    := Code;
                        Result                += [Entree];
                      end;
                  end;
              end;
          end;
    finally
      Alternatives.Free;
      Liste.Free;
    end;
  end;

Function PersonnageArmureBonusCompetenceModifPortee(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  var
    QualitesPortees:     TArrayPersonnageArmureQualitePortee;
    PiecesTraitees:      TStringList;
    Ind, IndModif:       Integer;
    IndListe:            Integer;
    Piece:               String;
    SousTotalPiece:      Integer;
    PieceEstPractical:   Boolean;
    PieceEstUnreliable:  Boolean;
  begin
    Result          := 0;
    QualitesPortees := PersonnageArmureQualitesPortees(Personnage);
    PiecesTraitees  := TStringList.Create;
    try
      for Ind := 0 to Length(QualitesPortees) - 1 do
        begin
          Piece := QualitesPortees[Ind].CodeEquipement;
          if PiecesTraitees.IndexOf(Piece) >= 0 then
            continue;
          PiecesTraitees.Add(Piece);

          // Malus/bonus ARMOB de CETTE piece pour CodeCompetence, et qualites Practical/
          // Unreliable de la MEME piece (peuvent cohabiter parmi ses qualites de catalogue
          // et de fabrication, cf. PersonnageArmureQualitesPortees).
          SousTotalPiece     := 0;
          PieceEstPractical  := False;
          PieceEstUnreliable := False;
          for IndModif := 0 to Length(QualitesPortees) - 1 do
            if QualitesPortees[IndModif].CodeEquipement = Piece then
              begin
                if FabricationEstPractical(QualitesPortees[IndModif].CodeQualite) then
                  PieceEstPractical := True;
                if FabricationEstUnreliable(QualitesPortees[IndModif].CodeQualite) then
                  PieceEstUnreliable := True;
              end;
          for IndModif := 0 to Length(QualitesPortees) - 1 do
            if QualitesPortees[IndModif].CodeEquipement = Piece then
              For IndListe := 0 to (ListArmureBonusModif.Count - 1) do
                if CompareRechercheValeur(ListArmureBonusModif[IndListe].CodeArmureBonus, QualitesPortees[IndModif].CodeQualite)
                   and CompareRechercheValeur(ListArmureBonusModif[IndListe].CodeCompetence, CodeCompetence) then
                  SousTotalPiece := SousTotalPiece + ListArmureBonusModif[IndListe].Valeur;

          // Practical/Unreliable ne modulent que des PENALITES (Rulebook : "penalties for
          // wearing it are reduced"/"penalties ... are doubled"), jamais un bonus.
          if SousTotalPiece < 0 then
            begin
              if PieceEstPractical then
                begin
                  SousTotalPiece := SousTotalPiece + 10;
                  if SousTotalPiece > 0 then
                    SousTotalPiece := 0;
                end;
              // Ordre Practical puis Unreliable arbitraire si une piece cumulait les deux (cas
              // non couvert par le Rulebook, non rencontre dans les livres actuels).
              if PieceEstUnreliable then
                SousTotalPiece := SousTotalPiece * 2;
            end;

          Result := Result + SousTotalPiece;
        end;
    finally
      PiecesTraitees.Free;
    end;
  end;

Function PersonnageArmureBonusAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  begin
    Result := PersonnageArmureBonusModificateur(Personnage, ConstXmlModifieAttribut, CodeAttribut);
  end;

Function PersonnageArmureBonusModificateur(Personnage: StructurePersonnage; TypeModif, Cible: String; Filtre: String = ''): Integer;
  var
    Qualites: TStringList;
    Ind:      Integer;
    IndModif: Integer;
  begin
    Result   := 0;
    Qualites := PersonnageArmureQualites(Personnage);
    try
      for Ind := 0 to Qualites.Count - 1 do
        for IndModif := 0 to (ListArmureBonusModificateur.Count - 1) do
          if (ListArmureBonusModificateur[IndModif].TypeModif = TypeModif)
             and CompareRechercheValeur(ListArmureBonusModificateur[IndModif].CodeSource, Qualites[Ind])
             and CompareRechercheValeur(ListArmureBonusModificateur[IndModif].Cible, Cible)
             and ((Trim(ListArmureBonusModificateur[IndModif].Filtre) = '')
                  or CompareRechercheValeur(ListArmureBonusModificateur[IndModif].Filtre, Filtre)) then
            Result := Result + ListArmureBonusModificateur[IndModif].Facteur;
    finally
      Qualites.Free;
    end;
  end;

Function PersonnageMutationCompetenceModif(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  var
    PersonnageMutation: StructurePersonnageMutation;
    indiceModif:        Integer;
    PCompetence:        StructureCompetence;
    PGenerique:         StructureCompetence;
    CodeGenerique:      String;
    AttributCompetence: String;
  begin
    Result        := 0;
    // Certains effets de mutation visent une FAMILLE de compétences (ex. "-10 to all Language
    // Tests", CORPHY_013) plutôt qu'une compétence précise - même mécanisme que les sous-
    // compétences ailleurs (ex. PdfPersonnageCompetence) : si CodeCompetence est une sous-
    // compétence (ex. RULES-COMPLANG_BRET), on teste aussi sa forme générique (COMPLANG_*).
    CodeGenerique := '';
    PCompetence   := ChercheCompetence(CodeCompetence);
    if PCompetence.SousCompetence then
      begin
        CodeGenerique := ExtractStringBefore(PCompetence.CodeCompetence, ValeurSousCompetence) + ValeurGenerique;
        // La specialisation et son entree generique peuvent venir de deux livres differents
        // (ex. LUSTR-COMPPROJ_SARBAC specialise RULES-COMPPROJ_*) : le prefixe herite ci-dessus
        // est alors celui de la specialisation, pas celui de la generique, et ChercheCompetence/
        // CompareRechercheValeur plus bas exigent le MEME livre pour matcher. On retrouve ici le
        // prefixe REEL de l'entree generique dans la base, radical par radical, livre ignore.
        for PGenerique in ListCompetence do
          if CodeSansLivre(PGenerique.CodeCompetence) = CodeSansLivre(CodeGenerique) then
            begin
              CodeGenerique := PGenerique.CodeCompetence;
              break;
            end;
      end;
    // Une sous-compétence (ex. RULES-COMPLANG_BRET) n'a pas son propre <Attribut> dans le XML,
    // seule l'entrée générique (RULES-COMPLANG_*) l'a - on va le chercher là si besoin.
    AttributCompetence := PCompetence.CodeAttribut;
    if (AttributCompetence = '') and (CodeGenerique <> '') then
      AttributCompetence := ChercheCompetence(CodeGenerique).CodeAttribut;
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionModificateur.Count - 1) do
        if (ListCorruptionModificateur[indiceModif].TypeModif = ConstXmlModifieCompetence)
           and CompareRechercheValeur(ListCorruptionModificateur[indiceModif].CodeSource, PersonnageMutation.Code)
           and (CompareRechercheValeur(ListCorruptionModificateur[indiceModif].Cible, CodeCompetence)
                or ((CodeGenerique <> '') and CompareRechercheValeur(ListCorruptionModificateur[indiceModif].Cible, CodeGenerique))) then
          Result := Result + ListCorruptionModificateur[indiceModif].Facteur;

    // Effets visant TOUTES les compétences d'un attribut de rattachement (ex. "-20 to all
    // Fellowship Tests", CORPHY_011) - sans toucher l'attribut lui-même (CONTEXT.md §2.7,
    // étape 8). <ModifySkillAttribut>, liste et comparaison séparées de celles ci-dessus.
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionCompetenceAttributModif.Count - 1) do
        if CompareRechercheValeur(ListCorruptionCompetenceAttributModif[indiceModif].CodeCorruption, PersonnageMutation.Code)
           and (AttributCompetence <> '')
           and CompareRechercheValeur(ListCorruptionCompetenceAttributModif[indiceModif].CodeAttribut, AttributCompetence) then
          Result := Result + ListCorruptionCompetenceAttributModif[indiceModif].Valeur;
  end;

Function PersonnageMutationArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  // Effets de mutation donnant des Points d'Armure (ex. "+2 Armour Points to all locations",
  // CORPHY_012/016/017, CONTEXT.md §2.7, étape 8) - PDF uniquement, réutilise les 4
  // emplacements de l'armure portée (BonusTete/BonusBras/BonusCorps/BonusJambes).
  begin
    Result := PersonnageMutationModificateur(Personnage, ConstXmlModifieArmure, CodeLocalisation);
  end;

Function PersonnageMutationTalent(Personnage: StructurePersonnage): TArrayPersonnageTalent;
  var
    PersonnageMutation: StructurePersonnageMutation;
    indiceModif:        Integer;
    PTalent:             StructurePersonnageTalent;
  begin
    Result := [];
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionTalent.Count - 1) do
        if CompareRechercheValeur(ListCorruptionTalent[indiceModif].CodeCorruption, PersonnageMutation.Code) then
          begin
            PTalent.CodeTalent := ListCorruptionTalent[indiceModif].CodeTalent;
            PTalent.Valeur     := 1;
            PTalent.Asterisque := 0;
            PTalent.Source     := PersonnageMutation.Code;
            Result             += [PTalent];
          end;
  end;

Function PersonnageMutationEquipement(Personnage: StructurePersonnage): TArrayPersonnageEquipement;
  var
    PersonnageMutation:  StructurePersonnageMutation;
    indiceModif:         Integer;
    PEquipement:          StructurePersonnageEquipement;
  begin
    Result := [];
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionEquipement.Count - 1) do
        if CompareRechercheValeur(ListCorruptionEquipement[indiceModif].CodeCorruption, PersonnageMutation.Code) then
          begin
            if ListCorruptionEquipement[indiceModif].EstArme then
              PEquipement.TypeEquipement := TypeEquipWe
            else
              PEquipement.TypeEquipement := TypeEquipAr;
            PEquipement.CodeEquipement    := ListCorruptionEquipement[indiceModif].CodeEquipement;
            PEquipement.QualiteEquipement := '';
            PEquipement.CoutXp            := 0;
            PEquipement.Source            := PersonnageMutation.Code;
            // Une arme/armure de mutation fait partie du corps, ne se retire pas comme un
            // achat normal : toujours consideree portee. A confirmer si un cas reel contredit
            // cette hypothese.
            PEquipement.Porte             := True;
            Result                        += [PEquipement];
          end;
  end;

Function PersonnageArmureBonusTalent(Personnage: StructurePersonnage): TArrayPersonnageTalent;
  var
    PersonnageEquipement: StructurePersonnageEquipement;
    indiceModif:          Integer;
    PTalent:              StructurePersonnageTalent;
    Liste:                TStringList;
    Alternatives:         TStringList;
    Element:              String;
    Code:                 String;
    Ind, IndAlt:          Integer;
    ListeQualites:        String;
  begin
    Result       := [];
    Liste        := TStringList.Create;
    Alternatives := TStringList.Create;
    try
      for PersonnageEquipement in Personnage.Equipement do
        if (TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAr))
           or (TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipArS)) then
          begin
            // Les qualites d'un objet vivent a deux endroits : celles du catalogue
            // (StructureArmure/StructureArmureSimplifiee.ListeBonus, ex. NATIO-ARMOB_16 sur
            // Skull Trophies - c'est CE champ que "Fear 1" affiche sur la fiche, chargearmure.pas)
            // et celles ajoutees par le joueur en fabrication (PersonnageEquipement.QualiteEquipement,
            // TabEquipement colonne Fabrication, winpersonnage.pas). Les deux sont scannees, au cas
            // ou une qualite de fabrication accorderait un jour un talent elle aussi.
            if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAr) then
              ListeQualites := ChercheArmure(PersonnageEquipement.CodeEquipement).ListeBonus
            else
              ListeQualites := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement).ListeBonus;
            if PersonnageEquipement.QualiteEquipement <> '' then
              begin
                if ListeQualites <> '' then
                  ListeQualites := ListeQualites + ',';
                ListeQualites := ListeQualites + PersonnageEquipement.QualiteEquipement;
              end;

            // Meme decoupage que GetAllArmureBonusLibelle (chargearmurebonus.pas) : virgules
            // entre qualites, suffixe numerique separe par un espace (ignore ici, seul le code
            // importe pour l'octroi), alternatives separees par SeparateurMulti.
            Liste.Clear;
            ExtractStrings([','], [], PChar(ListeQualites), Liste);
            for Ind := 0 to Liste.Count - 1 do
              begin
                Element := Trim(Liste[Ind]);
                if Pos(' ', Element) > 0 then
                  Element := Trim(ExtractStringBefore(Element, ' '));

                Alternatives.Clear;
                ExtractStrings([SeparateurMulti], [], PChar(Element), Alternatives);
                for IndAlt := 0 to Alternatives.Count - 1 do
                  begin
                    Code := Trim(Alternatives[IndAlt]);
                    for indiceModif := 0 to (ListArmureBonusTalent.Count - 1) do
                      if CompareRechercheValeur(ListArmureBonusTalent[indiceModif].CodeArmureBonus, Code) then
                        begin
                          PTalent.CodeTalent := ListArmureBonusTalent[indiceModif].CodeTalent;
                          PTalent.Valeur     := 1;
                          PTalent.Asterisque := 0;
                          PTalent.Source     := PersonnageEquipement.CodeEquipement;
                          Result             += [PTalent];
                        end;
                  end;
              end;
          end;
    finally
      Alternatives.Free;
      Liste.Free;
    end;
  end;

Function PersonnageTalentArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  // Talents donnant des Points d'Armure - meme principe que PersonnageMutationArmureModif
  // juste au-dessus, mais la source est un talent du personnage au lieu d'une mutation.
  // Premier usage : le trait Armour (Rating) (RULES-T0ARM), que le Skink porte en
  // "Armour 1 (Scaly Skin)". CONTEXT.md 2.15. Migre sur le moteur generique le 11/09/2026
  // (meme pathway que ModifyWeapon/ModifyDamage) - l'ancienne liste dediee
  // ListTalentArmureModif et son unite ChargeTalentArmureModif sont retirees.
  begin
    Result := PersonnageTalentModificateur(Personnage, ConstXmlModifieArmure, CodeLocalisation);
  end;

end.


