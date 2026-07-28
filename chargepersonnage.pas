unit ChargePersonnage;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, ChargeConstantes, XMLRead, DOM,
  Unitcalcul, ChargeRace, ChargeMetier, ChargeAttribut, ChargeCompetence,
  ChargeTalent, ChargeArme, ChargeArmure, ChargeArmureSimplifie,
  ChargeTalentAttributModif, ChargeTalentCompetenceModif,
  ChargeSort, XmlExportImport;

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
     AugmentationAttribut:       array of StructurePersonnageAttribut;
     AugmentationCompetence:     array of StructurePersonnageCompetence;
     AugmentationTalent:         array of StructurePersonnageTalent;
     Equipement:                 array of StructurePersonnageEquipement;
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
  end;


  // XML
  function PersonnageXmlCreation(Personnage: StructurePersonnage; Xp: Integer; XpRestante: Integer; fileName: string; PersonnageName: String): Boolean;
  function PersonnageXmlChargement(fileName: string): StructurePersonnage;
  function PersonnageXmlFichierActuel(const Directory: string): string;
  function PersonnageLivre(ListeLivre: String; Livre: String): string;
  Function PersonnageTalentAsterisque(var Personnage:StructurePersonnage; CodeTalent: String): Integer;

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
   AjoutLivre   := AjouteAccolade(Livre);
   if Pos(AjoutLivre, ListeLivre) = 0 then
     ListeLivre := ListeLivre + AjoutLivre;
   result       := ListeLivre;
end;

function PersonnageXmlCreation(Personnage: StructurePersonnage; Xp: Integer; XpRestante: Integer; fileName: string; PersonnageName: String): Boolean;
var
  XMLContent:             TStringList;
  PersonnageAttribut:     StructurePersonnageAttribut;
  PersonnageCompetence:   StructurePersonnageCompetence;
  PersonnageTalent:       StructurePersonnageTalent;
  PersonnageEquipement:   StructurePersonnageEquipement;
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
              XMLContent.Add(XmlLigneDonnee(ConstXmlCarac, PersonnageAttribut.CodeAttribut, IntToStr(PersonnageAttribut.Valeur)));
              PAttribut := ChercheAttribut(PersonnageAttribut.CodeAttribut);
              XMLContent.Add(XmlCommentaire(PAttribut.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCarac));

          // Compétences 3 et 5
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompSpecie));
          for PersonnageCompetence in Personnage.CreationCompetence35 do
            Begin
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence, PersonnageCompetence.CodeCompetence, IntToStr(PersonnageCompetence.Valeur)));
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompSpecie));

          // Compétences 40 pts
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompCreation));
          for PersonnageCompetence in Personnage.CreationCompetence40 do
            begin
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence, PersonnageCompetence.CodeCompetence, IntToStr(PersonnageCompetence.Valeur)));
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompCreation));

          // Talents
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
          for Personnagetalent in Personnage.CreationTalent do
            Begin
              XMLContent.Add(XmlLigneDonnee(ConstXmlTalent, PersonnageTalent.CodeTalent, IntToStr(PersonnageTalent.Valeur)));
              PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
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
              XMLContent.Add(XmlLigneDonnee(ConstXmlCarac, PersonnageAttribut.CodeAttribut, IntToStr(PersonnageAttribut.Valeur)));
              PAttribut := ChercheAttribut(PersonnageAttribut.CodeAttribut);
              XMLContent.Add(XmlCommentaire(PAttribut.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCarac));

          // Compétences
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompMetier));
          for PersonnageCompetence in Personnage.AugmentationCompetence do
            begin
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence, PersonnageCompetence.CodeCompetence, IntToStr(PersonnageCompetence.Valeur)));
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompMetier));

          // Talents
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
          for Personnagetalent in Personnage.AugmentationTalent do
            Begin
              XMLContent.Add(XmlLigneDonnee(ConstXmlTalent, PersonnageTalent.CodeTalent, IntToStr(PersonnageTalent.Valeur)));
              PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
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
              XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence, PersonnageCompetence.CodeCompetence, IntToStr(PersonnageCompetence.Valeur)));
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              ListeLivres:= PersonnageLivre(ListeLivres, PCompetence.livre);
              XMLContent.Add(XmlCommentaire(PCompetence.Libelle));
            end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompMetier));
        XMLContent.Add(XmlFin(ConstXmlChapitreCompetence));

        // anciens métiers
        XMLContent.Add(XmlDebut(ConstXmlChapitreOldWork));
          For PersonnageMetier in Personnage.MetierAncien do
            begin
              XMLContent.Add(XmlLigneDonnee(ConstXmlWork, PersonnageMetier.CodeMetier+SeparateurMulti+IntToStr(PersonnageMetier.NiveauMetier), IntToStr(PersonnageMetier.CoutXp)));
              PMetier := chercheMetier(Personnage.MetierEnCours.CodeMetier);
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
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem, PersonnageEquipement.CodeEquipement, PersonnageEquipement.QualiteEquipement));
               PArme.CodeArme:='';
               PArme := ChercheArme(PersonnageEquipement.CodeEquipement);
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
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem, PersonnageEquipement.CodeEquipement, PersonnageEquipement.QualiteEquipement));
               PArmure.CodeArmure:='';
               PArmure := ChercheArmure(PersonnageEquipement.CodeEquipement);
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
                XMLContent.Add(XmlLigneDonnee(ConstXmlItem, PersonnageEquipement.CodeEquipement, PersonnageEquipement.QualiteEquipement));
                PArmureSimplifiee.CodeArmure:='';
                PArmureSimplifiee := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
                ListeLivres:= PersonnageLivre(ListeLivres, PArmure.livre);
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
               XMLContent.Add(XmlLigneDonnee(ConstXmlItem, PersonnageEquipement.CodeEquipement, IntToStr(PersonnageEquipement.CoutXp)));
               PSort.CodeSort:='';
               PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
               ListeLivres:= PersonnageLivre(ListeLivres, PSort.livre);
               if (PSort.CodeSort<>'') then
                 XMLContent.Add(XmlCommentaire(PSort.Libelle));
              end;
          XMLContent.Add(XmlFin(ConstXmlSousChapitreSort));

        XMLContent.Add(XmlFin(ConstXmlChapitreEquipement));

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
            XMLContent.Add(XmlLigneDonnee(ConstXmlCarac, PersonnageXpAttribut.CodeAttribut+DriveSeparator+IntToStr(PersonnageXpAttribut.Debut)+SeparateurChance+IntToStr(PersonnageXpAttribut.Fin), IntToStr(PersonnageXpAttribut.CoutXp)));
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCarac));

          // Compétence
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreCompetence));
          For PersonnageXpCompetence in Personnage.XpCoutCompetence do
            XMLContent.Add(XmlLigneDonnee(ConstXmlCompetence, PersonnageXpCompetence.CodeCompetence+DriveSeparator+IntToStr(PersonnageXpCompetence.Debut)+SeparateurChance+IntToStr(PersonnageXpCompetence.Fin), IntToStr(PersonnageXpCompetence.CoutXp)));
          XMLContent.Add(XmlFin(ConstXmlSousChapitreCompetence));

          // Talent
          XMLContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
          For PersonnageXpTalent in Personnage.XpCoutTalent do
            XMLContent.Add(XmlLigneDonnee(ConstXmlTalent, PersonnageXpTalent.CodeTalent+DriveSeparator+IntToStr(PersonnageXpTalent.Debut)+SeparateurChance+IntToStr(PersonnageXpTalent.Fin), IntToStr(PersonnageXpTalent.CoutXp)));
          XMLContent.Add(XmlFin(ConstXmlSousChapitreTalent));

        XMLContent.Add(XmlFin(ConstXmlChapitreCoutXp));

        // Options
        XMLContent.Add(XmlLigne(ConstXmlOptions, Personnage.Options));

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
        if PersonnageTalent.Asterisque = 0  then
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

end.

