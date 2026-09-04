unit ChargePersonnage;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, ChargeConstantes, XMLRead, DOM,
  Unitcalcul, ChargeRace, ChargeMetier, ChargeAttribut, ChargeCompetence,
  ChargeTalent, ChargeArme, ChargeArmure, ChargeArmureSimplifie,
  ChargeTalentAttributModif, ChargeTalentCompetenceModif,
  ChargeSort, ChargeCorruptionTable, ChargeCorruptionAttributModif,
  ChargeCorruptionCompetenceModif, ChargeCorruptionArmureModif, ChargeTalentArmureModif, XmlExportImport;

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
  end;

Type
  StructurePersonnageEquipement = Record
     TypeEquipement:        String;
     CodeEquipement:        String;
     QualiteEquipement:     String;
     CoutXp:                Integer;
  end;

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
  // dans Personnage.Mutations. Contrairement à ListTalentAttributModif/ListArmureBonusModif
  // (annotation d'affichage uniquement), ce sont ici de vrais modificateurs additionnés au Total
  // (PdfPersonnageAttribut/PdfPersonnageCompetence, pdfpersonnage.pas).
  Function PersonnageMutationAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  Function PersonnageMutationCompetenceModif(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  Function PersonnageMutationArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  Function PersonnageTalentArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  // Greffes des appartenances (regiments, ordres, cultes) - CONTEXT.md 2.44
  Procedure PersonnageAppliqueGreffes(var Personnage: StructurePersonnage);

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
                 PersonnageEquipement.QualiteEquipement));
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
                 PersonnageEquipement.QualiteEquipement));
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
                  PersonnageEquipement.QualiteEquipement));
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
  // traiter les talents qui augmentent les attributs
  For indiceTalent := 0 to (ListTalentAttributModif.count - 1) Do
    if CompareRechercheValeur(ListTalentAttributModif[indiceTalent].CodeTalent, CodeTalent) then
      begin
        Trouve := False;
        for indiceAttribut := 0 to High(Personnage.CreationAttribut) do
          if CompareRechercheValeur(ListTalentAttributModif[indiceTalent].CodeAttribut, Personnage.CreationAttribut[indiceAttribut].CodeAttribut) then
            begin
              Asterisque := Personnage.Asterisque + 1;
              Trouve     := true;
              break;
            end;
        if Trouve = True then
          begin
            if Personnage.CreationAttribut[indiceAttribut].Bonus <> '' then
              Personnage.CreationAttribut[indiceAttribut].Bonus += '-' ;
            Personnage.CreationAttribut[indiceAttribut].Bonus += ListTalentAttributModif[indiceTalent].ValeurDonnee+' (' + IntToStr(Asterisque) + ')';
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
                if CountOccurrences(Personnage.CreationCompetence35[indiceCompetence].Bonus, '(' + IntToStr(Personnage.Asterisque) + ')') = 0 then
                  begin
                    if Personnage.CreationCompetence35[indiceCompetence].Bonus <> '' then
                      Personnage.CreationCompetence35[indiceCompetence].Bonus += '-';
                    case ListTalentCompetenceModif[indiceTalent].TypeModif of
                      ConstCompetenceInverseDe:
                        Personnage.CreationCompetence35[indiceCompetence].Bonus += '><(' + IntToStr(Personnage.Asterisque) + ')';
                      ConstCompetenceBonus:
                        Personnage.CreationCompetence35[indiceCompetence].Bonus += 'B(' + IntToStr(Personnage.Asterisque) + ')';
                    end;
                  end;
              end;
          // gérer les compétences 35
          For indiceCompetence := 0 to High(Personnage.CreationCompetence40) do
            if CompareRechercheValeur(ListTalentCompetenceModif[indiceTalent].CodeCompetence, Personnage.CreationCompetence40[indiceCompetence].CodeCompetence) then
              begin
                if Asterisque = 0 then
                  Asterisque := Personnage.Asterisque + 1;
                if CountOccurrences(Personnage.CreationCompetence40[indiceCompetence].Bonus, '(' + IntToStr(Personnage.Asterisque) + ')') = 0 then
                  begin
                    if Personnage.CreationCompetence40[indiceCompetence].Bonus <> '' then
                      Personnage.CreationCompetence40[indiceCompetence].Bonus += '-';
                    case ListTalentCompetenceModif[indiceTalent].TypeModif of
                      ConstCompetenceInverseDe:
                        Personnage.CreationCompetence40[indiceCompetence].Bonus += '><(' + IntToStr(Personnage.Asterisque) + ')';
                      ConstCompetenceBonus:
                        Personnage.CreationCompetence40[indiceCompetence].Bonus += 'B(' + IntToStr(Personnage.Asterisque) + ')';
                    end;
                  end;
              end;
          // gérer les compétence augmentées
          For indiceCompetence := 0 to High(Personnage.AugmentationCompetence) do
            if CompareRechercheValeur(ListTalentCompetenceModif[indiceTalent].CodeCompetence, Personnage.AugmentationCompetence[indiceCompetence].CodeCompetence) then
              begin
                if Asterisque = 0 then
                  Asterisque := Personnage.Asterisque + 1;
                if CountOccurrences(Personnage.AugmentationCompetence[indiceCompetence].Bonus, '(' + IntToStr(Personnage.Asterisque) + ')') = 0 then
                  begin
                    if Personnage.AugmentationCompetence[indiceCompetence].Bonus <> '' then
                      Personnage.AugmentationCompetence[indiceCompetence].Bonus += '-';
                    case ListTalentCompetenceModif[indiceTalent].TypeModif of
                      ConstCompetenceInverseDe:
                        Personnage.AugmentationCompetence[indiceCompetence].Bonus += '><(' + IntToStr(Personnage.Asterisque) + ')';
                      ConstCompetenceBonus:
                        Personnage.AugmentationCompetence[indiceCompetence].Bonus += 'B(' + IntToStr(Personnage.Asterisque) + ')';
                    end;
                  end;
              end;

        end;
    end;

  Result := Asterisque;

end;

Function PersonnageMutationAttributModif(Personnage: StructurePersonnage; CodeAttribut: String): Integer;
  var
    PersonnageMutation: StructurePersonnageMutation;
    indiceModif:        Integer;
  begin
    Result := 0;
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionAttributModif.Count - 1) do
        if CompareRechercheValeur(ListCorruptionAttributModif[indiceModif].CodeCorruption, PersonnageMutation.Code)
           and CompareRechercheValeur(ListCorruptionAttributModif[indiceModif].CodeAttribut, CodeAttribut) then
          Result := Result + ListCorruptionAttributModif[indiceModif].Valeur;
  end;

Function PersonnageMutationCompetenceModif(Personnage: StructurePersonnage; CodeCompetence: String): Integer;
  var
    PersonnageMutation: StructurePersonnageMutation;
    indiceModif:        Integer;
    PCompetence:        StructureCompetence;
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
      CodeGenerique := ExtractStringBefore(PCompetence.CodeCompetence, ValeurSousCompetence) + ValeurGenerique;
    // Une sous-compétence (ex. RULES-COMPLANG_BRET) n'a pas son propre <Attribut> dans le XML,
    // seule l'entrée générique (RULES-COMPLANG_*) l'a - on va le chercher là si besoin.
    AttributCompetence := PCompetence.CodeAttribut;
    if (AttributCompetence = '') and (CodeGenerique <> '') then
      AttributCompetence := ChercheCompetence(CodeGenerique).CodeAttribut;
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionCompetenceModif.Count - 1) do
        if CompareRechercheValeur(ListCorruptionCompetenceModif[indiceModif].CodeCorruption, PersonnageMutation.Code)
           and (CompareRechercheValeur(ListCorruptionCompetenceModif[indiceModif].CodeCompetence, CodeCompetence)
                or ((CodeGenerique <> '') and CompareRechercheValeur(ListCorruptionCompetenceModif[indiceModif].CodeCompetence, CodeGenerique))) then
          Result := Result + ListCorruptionCompetenceModif[indiceModif].Valeur;

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
  var
    PersonnageMutation: StructurePersonnageMutation;
    indiceModif:        Integer;
  begin
    Result := 0;
    for PersonnageMutation in Personnage.Mutations do
      for indiceModif := 0 to (ListCorruptionArmureModif.Count - 1) do
        if CompareRechercheValeur(ListCorruptionArmureModif[indiceModif].CodeCorruption, PersonnageMutation.Code)
           and CompareRechercheValeur(ListCorruptionArmureModif[indiceModif].CodeLocalisation, CodeLocalisation) then
          Result := Result + ListCorruptionArmureModif[indiceModif].Valeur;
  end;

Function PersonnageTalentArmureModif(Personnage: StructurePersonnage; CodeLocalisation: String): Integer;
  // Talents donnant des Points d'Armure - meme principe et memes 4 emplacements que
  // PersonnageMutationArmureModif juste au-dessus, mais la source est un talent du
  // personnage au lieu d'une mutation. Premier usage : le trait Armour (Rating)
  // (RULES-T0ARM), que le Skink porte en "Armour 1 (Scaly Skin)". CONTEXT.md 2.15.
  //
  // Les trois listes de talents du personnage sont parcourues (creation, metier,
  // augmentation) : un trait de race arrive par CreationTalent, mais rien n'interdit
  // qu'un talent donnant de l'armure vienne d'ailleurs.
  //
  // La valeur declaree vaut pour UN niveau, elle est multipliee par le niveau possede :
  // "Armour (Rating)" pris au niveau 2 donne 2 Points d'Armure.
  var
    Total: Integer = 0;

  Procedure Cumule(Talents: array of StructurePersonnageTalent);
    var
      IndTal, IndMod: Integer;
    begin
      for IndTal := 0 to High(Talents) do
        for IndMod := 0 to (ListTalentArmureModif.Count - 1) do
          if CompareRechercheValeur(ListTalentArmureModif[IndMod].CodeTalent, Talents[IndTal].CodeTalent)
             and CompareRechercheValeur(ListTalentArmureModif[IndMod].CodeLocalisation, CodeLocalisation) then
            Total := Total + ListTalentArmureModif[IndMod].Valeur * Talents[IndTal].Valeur;
    end;

  begin
    Cumule(Personnage.CreationTalent);
    Cumule(Personnage.MetierTalent);
    Cumule(Personnage.AugmentationTalent);
    Result := Total;
  end;

end.


