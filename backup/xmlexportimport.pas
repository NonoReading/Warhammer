unit XmlExportImport;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeCompetence, ChargeTalent, ChargeRace,
  ChargeRaceAttribut, ChargeRaceCompetence, ChargeRaceTalent, ChargeRaceMetier,
  ChargeMetier, ChargeMetierAttribut, ChargeMetierCompetence, ChargeMetierTalent,
  ChargeMetierEquipement, chargeMetierNiveau, ChargeArme, ChargeArmure,
  ChargeTalentCreation, ChargeRaceCreation, ChargeArmeBonus, ChargeArmureBonus,
  ChargeFabrication, ChargeSort, ChargeMetierRaceChoixMetier, ChargeAttribut,
  ChargeAttributAugmentation, ChargeCompetenceAugmentation, ChargeTexte,
  ChargeMetierSousMetier, ChargeTraduction, ChargeArmureSimplifie, ChargeLivre,
  ChargeRaceCorruptionCreation, ChargeTalentAttributModif,
  ChargeTalentCompetenceModif, ChargeTalentCompetenceAjoute, ChargeRaceOpinion,
  XMLRead, DOM, Unitcalcul,  Dialogs, strutils;

Procedure XmlExportBook(Livre: String; Langue: String);
Procedure XmlImport(FileName: String; OnlyPrimary: Boolean; OnlyCode: Boolean);
Function XmlDebut(TypeDonnee: string): String;
Function XmlFin(TypeDonnee: string): String;
Function XmlLigne(TypeDonnee: string; Valeur: String): String;
Function XmlCommentaire(Valeur: String): String;
Function XmlLigneDonnee(TypeDonnee: String; Name: String; Valeur: String): String;
Function XmlLigneLangue(TypeDonnee: String; Name: String; Valeur: String): String;
Function xmlDataBase(): String;
Function XmlDebutCode(TypeDonnee: string; Valeur: String): String;
Function XmlFinCode(TypeDonnee: String): String;
Function XmlReplace(Source: String): String;
Function XmlDebutLangue(TypeDonnee: String; Name: String): String;
Function XmlLivre(FileName: String): string;
Function XmlCodeLivre(Livre: String): String;
Function XmlCreeCodeLivre(Livre: String; Code: String): String;

implementation

Function XmlReplace(Source: String): String;
begin
  result := ReplaceText(Source, '&', '&amp;');
end;

Function xmlDataBase(): String;
begin
  Result := XmlReplace('<?xml version="1.0" encoding="UTF-8"?>');
end;

Function XmlLigne(TypeDonnee: string; Valeur: String): String;
  begin
    Result := XmlReplace(XmlDebut(TypeDonnee) + '"' + Valeur + '"' + XmlFin(TypeDonnee));
  end;

Function XmlCommentaire(Valeur: String): String;
  begin
    Result := XmlReplace('  <!-- ' + Valeur + ' -->');
  end;

Function XmlLigneDonnee(TypeDonnee: String; Name: String; Valeur: String): String;
  begin
    Result := XmlReplace(XmlDebut(TypeDonnee+' name="'+Name+'"') + '"' + Valeur + '"' + XmlFin(TypeDonnee));
  end;

Function XmlLigneLangue(TypeDonnee: String; Name: String; Valeur: String): String;
  begin
    Result := XmlReplace(XmlDebut(TypeDonnee+' language="'+Name+'"') + '"' + Valeur + '"' + XmlFin(TypeDonnee));
  end;

Function XmlDebut(TypeDonnee: string): String;
  begin
    Result := XmlReplace('<'+TypeDonnee+'>');
  end;

Function XmlFin(TypeDonnee: string): String;
  begin
    Result := XmlReplace('</'+TypeDonnee+'>');
  end;

Function XmlDebutCode(TypeDonnee: string; Valeur: String): String;
  begin
    Result := XmlReplace('<'+TypeDonnee+' id='+ '"' + Valeur + '"' +'>');
  end;

Function XmlFinCode(TypeDonnee: String): String;
  begin
    Result := XmlReplace('</'+TypeDonnee+'>');
  end;

Function XmlDebutLangue(TypeDonnee: String; Name: String): String;
  begin
    Result := XmlReplace(XmlDebut(TypeDonnee+' language="'+Name+'"'));
  end;

Function XmlCodeLivre(Livre: String): String;
Var
  CodeLivre: String = '';
begin
  Case Livre Of
     'BOOK RULESBOOK':                               CodeLivre := 'RULES';
     'BOOK UP IN ARMS':                              CodeLivre := 'UPINA';
     'BOOK WINDS OF MAGIC':                          CodeLivre := 'WINDS';
     'BOOK ARCHIVES OF THE EMPIRE I':                CodeLivre := 'ARCH1';
     'BOOK ARCHIVES OF THE EMPIRE II':               CodeLivre := 'ARCH2';
     'BOOK ARCHIVES OF THE EMPIRE III':              CodeLivre := 'ARCH3';
     'BOOK ROUGH NIGHTS AND HARD DAYS':              CodeLivre := 'ROUGH';
     'BOOK DEATH ON THE REIK COMPANION':             CodeLivre := 'DEATH';
     'BOOK ENEMY IN SHADOWS COMPANION':              CodeLivre := 'ENEMY';
     'BOOK MIDDENHEIM CITY OF THE WHITE WOLF':       CodeLivre := 'MIDDE';
     'BOOK SALZENMUND CITY OF SALT AND SILVER':      CodeLivre := 'SALZE';
     'BOOK THE HORNED RAT COMPANION':                CodeLivre := 'HORNE';
     'BOOK SEA OF CLAWS':                            CodeLivre := 'SEAOF';
     'BOOK GREEN IZ BEST':                           CodeLivre := 'GREEN';
     'BOOK LORDS OF NAGGAROTH':                      CodeLivre := 'NAGGA';
  end;
  Result := CodeLivre;
end;

Function XmlCreeCodeLivre(Livre: String; Code: String): String;
Var
  CodeLivre: String = '';
  Res:       String = '';
begin
    if Code <> '' then
      begin
        if Pos(SeparateurLivre, Code) < 1 then
          begin
            CodeLivre := XmlCodeLivre(Livre);
            Res       := CodeLivre+SeparateurLivre+Code;
          end
        else
          Res       := Code;
      end;
    Result := Res;
end;

Procedure XmlExportBook(Livre: String; Langue: String);
  var
    XMLContent:               TStringList;
    FileName:                 String;
    PCompetence:              StructureCompetence;
    PTalent:                  StructureTalent;
    PRace:                    StructureRace;
    PRaceAttribut:            StructureRaceAttribut;
    PRaceCompetence:          StructureRaceCompetence;
    PRaceTalent:              StructureRaceTalent;
    PRaceMetier:              StructureRaceMetier;
    PMetier:                  StructureMetier;
    PMetierAttribut:          StructureMetierAttribut;
    PMetiercompetence:        StructureMetierCompetence;
    PMetierTalent:            StructureMetierTalent;
    PMetierEquipement:        StructureMetierEquipement;
    PMetierNiveau:            StructureMetierNiveau;
    PRaceOpinion:             StructureRaceOpinion;  // ✨ NOUVEAU
    PTalentCreation:          StructureTalentCreation;
    PRaceCreation:            StructureRaceCreation;
    PArme:                    StructureArme;
    PArmeBonus:               StructureArmeBonus;
    PArmure:                  StructureArmure;
    PArmureBonus:             StructureArmureBonus;
    PFabrication:             StructureFabrication;
    PMetierRaceChoixMetier:   StructureMetierRaceChoixMetier;
    PSort:                    StructureSort;
    PMetierSousMetier:        StructureMetierSousMetier;
    PAttribut:                StructureAttribut;
    PAttributAugmentation:    StructureAttributAugmentation;
    PCompetenceAugmentation:  StructureCompetenceAugmentation;
    PTexte:                   StructureTexte;
    PArmureSimplifiee:        StructureArmureSimplifiee;
    PLivre:                   StructureLivre;
    Fist:                     Boolean;
    Ind:                      Integer;
    StringEquip:              TStringList;
    StringType:               TStringList;
    LigneEquipement:          String;
    LigneIndice:              Integer;
    LigneEquip:               String;
    LigneType:                String;
    Qualite:                  String;
    Equipement:               String;
    StringTalent:             TStringList;
    LigneTalent:              String;
    ListeTalent:              String;

  begin
    if Langue = ConstAnglais then
      FileName   := GetCurrentDir+ConstCheminLivreExport+Livre+'.Xml'
    else
      FileName   := GetCurrentDir+ConstCheminLivreExport+Livre+'_'+Langue+'.Xml';
    XMLContent := TStringList.Create;
    try
      try
        // Construire le contenu XML
        XMLContent.Add(XmlDataBase());

        XMLContent.Add(XmlDebut(ConstXmlDataBook));

        XmlContent.Add(XmlLigne(ConstXmlCodeLivre, XmlCodeLivre(Livre)));
        XmlContent.Add(XmlLigne(ConstXmlLibelleLivre, Livre));
        XmlContent.Add(XmlLigne(ConstXmlLanguage, Langue));

        // Livres
        PLivre.Version := '';
        PLivre := ChercheLivreLibelle(Livre);
        if PLivre.Version <> '' then
          XmlContent.Add(XmlLigne(ConstXmlVersionLivre, PLivre.Version))
        else
          XmlContent.Add(XmlLigne(ConstXmlVersionLivre, FormatDateTime('YYYYMMDD',Now)));
        PLivre.Officiel := StrToInt(LivreOrdre(PLivre.Libelle));
        XmlContent.Add(XmlLigne(ConstXmlOfficielLivre, IntToStr(PLivre.Officiel)));
        PLivre.Complet  := 1;
        XmlContent.Add(XmlLigne(ConstXmlCompletLivre, IntToStr(PLivre.Complet)));

        // Attribut
        Fist := true;
        for PAttribut in ListeAttribut do
          if (PAttribut.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataAttribut));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlAttribut, XmlCreeCodeLivre(PAttribut.Livre, PAttribut.CodeAttribut)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PAttribut.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PAttribut.Description));
              XmlContent.Add(XmlLigneLangue(ConstXmlShort, Langue, PAttribut.Resume));
              XmlContent.Add(XmlLigne(ConstXmlOrder, IntToStr(PAttribut.OrdreAttribut)));
              XmlContent.Add(XmlFinCode(ConstXmlAttribut));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataAttribut));

        // Attribut Augmentation
        Fist := true;
        for PAttributAugmentation in ListeAttributAugmentation do
          if (PAttributAugmentation.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataAttributCost));
                  Fist := false;
                end;
              XmlContent.Add(XmlLigneDonnee(ConstXmlCout, PAttributAugmentation.MinMax, IntToStr(PAttributAugmentation.Cout)));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataAttributCost));

        // Competence Augmentation
        Fist := true;
        for PCompetenceAugmentation in ListeCompetenceAugmentation do
          if (PCompetenceAugmentation.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSkillCost));
                  Fist := false;
                end;
              XmlContent.Add(XmlLigneDonnee(ConstXmlCout, PCompetenceAugmentation.MinMax, IntToStr(PCompetenceAugmentation.Cout)));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSkillCost));

        // Texte
        Fist := true;
        if (Livre = ConstRulesBook) then
          for PTexte in ListTexte do
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataLabel));
                  XmlContent.Add(XmlDebutLangue(ConstXmlLabel, Langue));
                  Fist := false;
                end;
              XmlContent.Add(XmlLigneDonnee(ConstXmlTexte, XmlCreeCodeLivre(ConstRulesBook, PTexte.Code), PTexte.Libelle));
            end;
        if Fist = false then
          begin
            XmlContent.Add(XmlFin(ConstXmlLabel));
            XmlContent.Add(XmlFin(ConstXmlDataLabel));
          end;

        // compétence
        Fist := true;
        for PCompetence in ListCompetence do
          if (PCompetence.Livre = Livre) and (PCompetence.SousCompetence = false) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSkill));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlCompetence, XmlCreeCodeLivre(PCompetence.Livre, PCompetence.CodeCompetence)));
              XmlContent.Add(XmlLigne(ConstXmlCarac, XmlCreeCodeLivre(ConstRulesBook, PCompetence.CodeAttribut)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PCompetence.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PCompetence.Description));
              XmlContent.Add(XmlFinCode(ConstXmlCompetence));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSkill));

        // compétence spécialisation
        Fist := true;
        for PCompetence in ListCompetence do
          if (PCompetence.Livre = Livre) and (PCompetence.SousCompetence = true) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSkillSpe));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlCompetence, XmlCreeCodeLivre(PCompetence.Livre, PCompetence.CodeCompetence)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PCompetence.Libelle));
              XmlContent.Add(XmlFinCode(ConstXmlCompetence));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSkillSpe));

        // Talent
        Fist := true;
        for PTalent in ListTalent do
          if (PTalent.Livre = Livre) and (PTalent.SousTalent = false) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataTalent));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlTalent, XmlCreeCodeLivre(PTalent.Livre, PTalent.CodeTalent)));
              XmlContent.Add(XmlLigne(ConstXmlCarac, XmlCreeCodeLivre(ConstRulesBook, PTalent.Attribut)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PTalent.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlShort, Langue, PTalent.Resume));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PTalent.Description));
              if PTalent.CompAjoutee <> '' then
                begin
                  PCompetence := ChercheCompetence(PTalent.CompAjoutee);
                  XmlContent.Add(XmlLigne(ConstXmlCompetence, XmlCreeCodeLivre(PCompetence.Livre, PTalent.CompAjoutee)));
                end
              else
                 XmlContent.Add(XmlLigne(ConstXmlCompetence, ''));
              XmlContent.Add(XmlLigne(ConstXmlMax, PTalent.MaxiTalent));
              XmlContent.Add(XmlLigne(ConstXmlForPdf, PTalent.TalentPdf));
              XmlContent.Add(XmlLigneLangue(ConstXmlTest, Langue, PTalent.Tests));

              XmlContent.Add(XmlFinCode(ConstXmlTalent));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataTalent));

        // Talent spécialisation
        Fist := true;
        for PTalent in ListTalent do
          if (PTalent.Livre = Livre) and (PTalent.SousTalent = true) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataTalentSpe));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlTalent, XmlCreeCodeLivre(PTalent.Livre, PTalent.CodeTalent)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PTalent.Libelle));
              XmlContent.Add(XmlFinCode(ConstXmlTalent));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataTalentSpe));

        // Talent au hasard
        Fist := true;
        for PTalentCreation in ListTalentCreation do
          if (PTalentCreation.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataRandomTalent));
                  Fist := false;
                end;
              PTalent := ChercheTalent(PTalentCreation.CodeTalent);
              XmlContent.Add(XmlDebutCode(ConstXmlDataRandomTalent, XmlCreeCodeLivre(PTalent.Livre, PTalent.CodeTalent)));
              PRace := ChercheRace(PTalentCreation.CodeRace);
              XmlContent.Add(XmlLigne(ConstXmlRace, XmlCreeCodeLivre(PRace.Livre, PTalentCreation.CodeRace)));
              XmlContent.Add(XmlLigneDonnee(ConstXmlTalent, XmlCreeCodeLivre(PTalent.Livre, PTalent.CodeTalent), PTalentCreation.Chance));
              XmlContent.Add(XmlCommentaire(LibelleTalent(PTalentCreation.CodeTalent)));
              XmlContent.Add(XmlFinCode(ConstXmlDataRandomTalent));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataRandomTalent));

        // race
        Fist := true;
        For PRace In ListRace do
          if PRace.Livre = Livre then
            begin
              if Fist = True then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSpecie));
                  Fist := false;
                end;
              // données de base
              XmlContent.Add(XmlDebutCode(ConstXmlRace, XmlCreeCodeLivre(PRace.Livre, PRace.CodeRace)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PRace.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PRace.Description));
              XmlContent.Add(XmlLigne(ConstXmlEthnic, PRace.Espece));
              // Attribut de race
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreCarac));
              for PRaceAttribut in ListRaceAttribut do
                if PRaceAttribut.CodeRace = PRace.CodeRace then
                  begin
                    PAttribut := ChercheAttribut(PRaceAttribut.CodeAttribut);
                    XmlContent.Add(XmlLigneDonnee(ConstXmlCarac, XmlCreeCodeLivre(PAttribut.Livre, PRaceAttribut.CodeAttribut), PRaceAttribut.CalculRace));
                  end;
              XmlContent.Add(Xmlfin(ConstXmlSousChapitreCarac));
              // Compétence
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreCompetence));
              for PRaceCompetence in ListRaceCompetence do
                if PRaceCompetence.CodeRace = PRace.CodeRace then
                  begin
                    PCompetence := ChercheCompetence(PRaceCompetence.CodeCompetence);
                    XmlContent.Add(XmlLigne(ConstXmlCompetence, XmlCreeCodeLivre(PCompetence.Livre, PRaceCompetence.CodeCompetence)));
                    PCompetence := ChercheCompetence(PRaceCompetence.CodeCompetence);
                    XmlContent.Add(XmlCommentaire(PCompetence.Libelle));
                  end;
              XmlContent.Add(XmlFin(ConstXmlSousChapitreCompetence));
              // Talent
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
              for PRaceTalent in ListRaceTalent do
                if PRaceTalent.CodeRace = PRace.CodeRace then
                  begin
                    PTalent := ChercheTalent(PRaceTalent.CodeTalent);
                    XmlContent.Add(XmlLigne(ConstXmlTalent, XmlCreeCodeLivre(PTalent.Livre, PRaceTalent.CodeTalent)));
                    XmlContent.Add(XmlCommentaire(LibelleTalent(PRaceTalent.CodeTalent)));
                  end;
              XmlContent.Add(XmlFin(ConstXmlSousChapitreTalent));
              // Metier
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreMetier));
              for PRaceMetier in ListRaceMetier do
                if PRaceMetier.CodeRace = PRace.CodeRace then
                  begin
                    PMetier := ChercheMetier(PRaceMetier.CodeMetier);
                    XmlContent.Add(XmlLigneDonnee(ConstXmlWork, XmlCreeCodeLivre(PMetier.Livre, PRaceMetier.CodeMetier), PRaceMetier.Chance));
                    XmlContent.Add(XmlCommentaire(PMetier.Libelle));
                  end;
              XmlContent.Add(XmlFinCode(ConstXmlSousChapitreMetier));
              XmlContent.Add(XmlFinCode(ConstXmlRace));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSpecie));

        // Race au hasard
        Fist := true;
        for PRaceCreation in ListRaceCreation do
          if (PRaceCreation.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSpecieCreation));
                  Fist := false;
                end;
              PRace := ChercheRace(PRaceCreation.CodeRace);
              XmlContent.Add(XmlLigneDonnee(ConstXmlRace, XmlCreeCodeLivre(PRace.Livre, PRaceCreation.CodeRace), PRaceCreation.Chance));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSpecieCreation));

        // Métier
        Fist := true;
        for PMetier in ListMetier do
          if PMetier.Livre = Livre then
            begin
              if Fist = True then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataCareer));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlWork, XmlCreeCodeLivre(PMetier.Livre, PMetier.CodeMetier)));
              // données de base
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PMetier.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PMetier.Description));
              PCompetence := ChercheCompetence(PMetier.CodeCompetence);
              XmlContent.Add(XmlLigne(ConstXmlCompetence, XmlCreeCodeLivre(PCompetence.Livre, PMetier.CodeCompetence)));
              XmlContent.Add(XmlLigne(ConstXmlClass, PMetier.LibelleGroupe));

              // Niveau
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreNiveau));
              for PMetierNiveau in ListMetierNiveau do
                For Ind := 1 to ChercheMaxMetierNiveau(PMEtier.CodeMetier) do
                  begin
                    if (PMetierNiveau.CodeMetier = PMetier.CodeMetier) and (PMetierNiveau.NiveauMetier = Ind) then
                       begin
                         XmlContent.Add(XmlDebutCode(ConstXmlNiveau, IntToStr(PMetierNiveau.NiveauMetier)));
                         XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PMetierNiveau.Libelle));
                         XmlContent.Add(XmlLigne(ConstXmlSalaire, PMetierNiveau.SalaireMetier));
                         XmlContent.Add(XmlFinCode(ConstXmlNiveau));
                       end;
                  end;
              XmlContent.Add(XmlFin(ConstXmlSousChapitreNiveau));

              // Attribut
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreCarac));
              for PMetierAttribut in ListMetierAttribut do
                if (PMetierAttribut.CodeMetier = PMetier.CodeMetier) then
                  begin
                    PAttribut := ChercheAttribut(PMetierAttribut.CodeAttribut);
                   XmlContent.Add(XmlLigneDonnee(ConstXmlCarac, XmlCreeCodeLivre(PAttribut.Livre, PMetierAttribut.CodeAttribut), IntToStr(PMetierAttribut.NiveauMetier)));
                  end;
              XmlContent.Add(XmlFin(ConstXmlSousChapitreCarac));

              // Competence
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreCompetence));
              for PMetierCompetence in ListMetierCompetence do
                if (PMetierCompetence.CodeMetier = PMetier.CodeMetier) then
                  begin
                    PCompetence := ChercheCompetence(PMetierCompetence.CodeCompetence);
                    XmlContent.Add(XmlLigneDonnee(ConstXmlCompetence, XmlCreeCodeLivre(PCompetence.Livre, PMetierCompetence.CodeCompetence), IntToStr(PMetierCompetence.NiveauMetier)));
                    XmlContent.Add(XmlCommentaire(PCompetence.Libelle));
                  end;
              XmlContent.Add(XmlFin(ConstXmlSousChapitreCompetence));

              // Talent
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreTalent));
              for PMetierTalent in ListMetierTalent do
                if (PMetierTalent.CodeMetier = PMetier.CodeMetier) then
                  begin
                    PTalent := ChercheTalent(PMetierTalent.CodeTalent);
                    XmlContent.Add(XmlLigneDonnee(ConstXmlTalent, XmlCreeCodeLivre(PTalent.Livre,  PMetierTalent.CodeTalent), IntToStr(PMetierTalent.NiveauMetier)));
                    XmlContent.Add(XmlCommentaire(PTalent.Libelle));
                  end;
              XmlContent.Add(XmlFin(ConstXmlSousChapitreTalent));

              // Equipement
              XmlContent.Add(XmlDebut(ConstXmlSousChapitreEquipement));
              for PMetierEquipement in ListMetierEquipement do
                if (PMetierEquipement.CodeMetier = PMetier.CodeMetier) then
                  begin

                    StringEquip := TStringList.Create;
                    StringType  := TStringList.Create;

                    ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.Equipement), StringEquip);
                    ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.TypeEquipement), StringType);

                    LigneIndice := 0;
                    LigneEquipement := '';
                    For LigneEquip in StringEquip do
                      begin
                        if LigneEquipement <> '' then
                          LigneEquipement := LigneEquipement + SeparateurMulti;
                        Qualite    := '';
                        Equipement := LigneEquip;
                        if (Pos(EquipementQualite, Equipement) > 0) then
                          begin
                            Qualite    := EquipementQualite;
                            Equipement := ExtractStringBefore(LigneEquip,EquipementQualite);
                          end;
                        LigneType := StringType[LigneIndice];
                        Inc(LigneIndice);
                        if InList(LigneType,TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                            begin
                              PArme   := ChercheArme(Equipement);
                              LigneEquipement := LigneEquipement + XmlCreeCodeLivre(Parme.livre, Equipement) + Qualite;
                            end
                          else if LigneType = TypeEquipAR then
                            begin
                              PArmure := ChercheArmure(Equipement);
                              LigneEquipement := LigneEquipement + XmlCreeCodeLivre(PArmure.Livre, Equipement) + Qualite;
                            end
                          else if LigneType = TypeEquipDI then
                            begin
                              LigneEquipement := LigneEquipement + Equipement + Qualite;
                            end;
                        end;
                      StringEquip.free;
                      StringType.Free;
                      XmlContent.Add(XmlLigneDonnee(ConstXmlEquipement, LigneEquipement, IntToStr(PMetierEquipement.NiveauMetier)));
                      LigneEquipement  := '';
                    end;


              XmlContent.Add(XmlFin(ConstXmlSousChapitreEquipement));

              XmlContent.Add(XmlFinCode(ConstXmlWork));
            end;


        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataCareer));

        // Arme
        Fist := true;
        for PArme in ListArme do
          if (PArme.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataWeapon));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlArme, XmlCreeCodeLivre(PArme.Livre, PArme.CodeArme)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PArme.Libelle));
              PCompetence := ChercheCompetence(PArme.CodeCompetence);
              XmlContent.Add(XmlLigne(ConstXmlCompetence, XmlCreeCodeLivre(PArme.Livre, PArme.CodeCompetence)));
              XmlContent.Add(XmlLigne(ConstXmlDamage, PArme.CalculDegat));
              XmlContent.Add(XmlLigne(ConstXmlDisponibilite, PArme.Disponibilite));
              XmlContent.Add(XmlLigne(ConstXmlPorteeArme, PArme.Portee));
              XmlContent.Add(XmlLigne(ConstXmlPrix, PArme.Prix));
              XmlContent.Add(XmlLigne(ConstXmlEncombrement, IntToStr(PArme.Encombrement)));
              XmlContent.Add(XmlLigne(ConstXmlQualite, PArme.ListeBonus));
              XmlContent.Add(XmlLigne(ConstXmlMains, IntToStr(PArme.Mains)));
              XmlContent.Add(XmlLigne(ConstXmlMunition, IntToStr(PArme.Munition)));

              XmlContent.Add(XmlFinCode(ConstXmlArme));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataWeapon));

        // ArmeBonus
        Fist := true;
        for PArmeBonus in ListArmeBonus do
          if (PArmeBonus.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataWeaponBonus));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlBonus, XmlCreeCodeLivre(PArmeBonus.Livre, PArmeBonus.CodeArmeBonus)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PArmeBonus.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PArmeBonus.Description));
              XmlContent.Add(XmlLigneLangue(ConstXmlShort, Langue, PArmeBonus.Resume));
              XmlContent.Add(XmlLigne(ConstXmlPositifNegatif, PArmeBonus.PlusMoins));

              XmlContent.Add(XmlFinCode(ConstXmlBonus));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataWeaponBonus));

        // Armure
        Fist := true;
        for PArmure in ListArmure do
          if (PArmure.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataArmor));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlArmure, XmlCreeCodeLivre(PArmure.Livre, PArmure.CodeArmure)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PArmure.Libelle));
              XmlContent.Add(XmlLigne(ConstXmlDisponibilite, PArmure.Disponibilite));
              XmlContent.Add(XmlLigne(ConstXmlPrix, PArmure.Prix));
              XmlContent.Add(XmlLigne(ConstXmlEncombrement, IntToStr(PArmure.Encombrement)));
              XmlContent.Add(XmlLigne(ConstXmlQualite, PArmure.ListeBonus));
              XmlContent.Add(XmlLigne(ConstXmlEmplacement, PArmure.Emplacement));
              XmlContent.Add(XmlLigne(ConstXmlProtection, IntToStr(PArmure.Protection)));
              XmlContent.Add(XmlLigne(ConstXmlType, PArmure.TypeMateriel));

              XmlContent.Add(XmlFinCode(ConstXmlArmure));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataArmor));

        // Armure Simplifiée
        Fist := true;
        for PArmureSimplifiee in ListArmureSimplifiee  do
          if (PArmureSimplifiee.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataArmorSimplified));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlArmureSimplifiee, XmlCreeCodeLivre(PArmureSimplifiee.Livre, PArmureSimplifiee.CodeArmure)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PArmureSimplifiee.Libelle));
              XmlContent.Add(XmlLigne(ConstXmlDisponibilite, PArmureSimplifiee.Disponibilite));
              XmlContent.Add(XmlLigne(ConstXmlPrix, PArmureSimplifiee.Prix));
              XmlContent.Add(XmlLigne(ConstXmlEncombrement, IntToStr(PArmureSimplifiee.Encombrement)));
              XmlContent.Add(XmlLigne(ConstXmlQualite, PArmureSimplifiee.ListeBonus));
              XmlContent.Add(XmlLigne(ConstXmlProtection, IntToStr(PArmureSimplifiee.Protection)));

              XmlContent.Add(XmlFinCode(ConstXmlArmureSimplifiee));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataArmorSimplified));

        // ArmureBonus
        Fist := true;
        for PArmureBonus in ListArmureBonus do
          if (PArmureBonus.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataArmorBonus));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlBonus, XmlCreeCodeLivre(PArmureBonus.livre, PArmureBonus.CodeArmureBonus)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PArmureBonus.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PArmureBonus.Description));
              XmlContent.Add(XmlLigne(ConstXmlPositifNegatif, PArmureBonus.Malus));

              XmlContent.Add(XmlFinCode(ConstXmlBonus));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataArmorBonus));

        // Sort
        Fist := true;
        for PSort in ListSort do
          if (PSort.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSpell));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlSort, XmlCreeCodeLivre(PSort.Livre, PSort.CodeSort)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PSort.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PSort.Description));
              XmlContent.Add(XmlLigne(ConstXmlCible, PSort.Cible));
              XmlContent.Add(XmlLigne(ConstXmlDuree, PSort.Duree));
              XmlContent.Add(XmlLigne(ConstXmlPorteeSort, PSort.Portee));
              StringTalent := TStringList.Create;
              ExtractStrings([','], [], PChar(PSort.ListeTalent), StringTalent);
              ListeTalent := '';
              For LigneTalent in StringTalent do
                begin
                  if ListeTalent <> '' then
                    ListeTalent := ListeTalent + ',';
                  PTalent := ChercheTalent(LigneTalent);
                  ListeTalent := ListeTalent + XmlCreeCodeLivre(PTalent.Livre, PTalent.CodeTalent);
                end;
              StringTalent.free;
              XmlContent.Add(XmlLigne(ConstXmlTalent, ListeTalent));
              XmlContent.Add(XmlLigne(ConstXmlNiveau, PSort.Niveau));
              XmlContent.Add(XmlLigne(ConstXmlTypeSort, PSort.TypeSort));

              XmlContent.Add(XmlFinCode(ConstXmlSort));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSpell));

        // Fabrication
        Fist := true;
        for PFabrication in ListFabrication do
          if (PFabrication.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataCraftsmanship));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebutCode(ConstXmlFabrication, XmlCreeCodeLivre(PFabrication.Livre, PFabrication.CodeFabrication)));
              XmlContent.Add(XmlLigneLangue(ConstXmlDescription, Langue, PFabrication.Libelle));
              XmlContent.Add(XmlLigneLangue(ConstXmlExplanation, Langue, PFabrication.Description));
              XmlContent.Add(XmlLigneLangue(ConstXmlShort, Langue, PFabrication.Resume));
              XmlContent.Add(XmlLigne(ConstXmlMax, PFabrication.Maximum));
              XmlContent.Add(XmlLigne(ConstXmlPositifNegatif, PFabrication.TypeQualite));

              XmlContent.Add(XmlFinCode(ConstXmlFabrication));
            end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataCraftsmanship));

        // Metier choix race
        Fist := true;
        for PMetierRaceChoixMetier in ListMetierRaceChoixMetier do
          if (PMetierRaceChoixMetier.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataSpecieCareerChoix));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebut(ConstXmlChoix));
              PRace := chercheRace(PMetierRaceChoixMetier.CodeRace);
              XmlContent.Add(XmlLigne(ConstXmlRace, XmlCreeCodeLivre(PRace.Livre, PMetierRaceChoixMetier.CodeRace)));
              PMetier := chercheMetier(PMetierRaceChoixMetier.CodeMetier);
              XmlContent.Add(XmlLigne(ConstXmlWork, XmlCreeCodeLivre(PMetier.Livre, PMetierRaceChoixMetier.CodeMetier)));
              PMetier := chercheMetier(PMetierRaceChoixMetier.CodeSousMetier);
              XmlContent.Add(XmlLigne(ConstXmlAlternative, XmlCreeCodeLivre(PMetier.Livre, PMetierRaceChoixMetier.CodeSousMetier)));
              XmlContent.Add(XmlFin(ConstXmlChoix));
           end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataSpecieCareerChoix));

        // Sous Metier
        Fist := true;
        for PMetierSousMetier in ListMetierSousMetier do
          if (PMetierSousMetier.Livre = Livre) then
            begin
              if Fist = true then
                begin
                  XmlContent.Add(XmlDebut(ConstXmlDataCareerSubChoice));
                  Fist := false;
                end;
              XmlContent.Add(XmlDebut(ConstXmlChoix));
              PMetier := ChercheMetier(PMetierSousMetier.CodeMetier);
              XmlContent.Add(XmlLigne(ConstXmlWork, XmlCreeCodeLivre(PMetier.Livre, PMetierSousMetier.CodeMetier)));
              PMetier := ChercheMetier(PMetierSousMetier.CodeSousMetier);
              XmlContent.Add(XmlLigneDonnee(ConstXmlAlternative, XmlCreeCodeLivre(PMetier.Livre, PMetierSousMetier.CodeSousMetier), PMetierSousMetier.Chance));
              XmlContent.Add(XmlFin(ConstXmlChoix));
           end;
        if Fist = false then
           XmlContent.Add(XmlFin(ConstXmlDataCareerSubChoice));

        // fin de livre
        XMLContent.Add(XmlFin(ConstXmlDataBook));

        // Enregistrer le contenu XML dans un fichier
        XMLContent.SaveToFile(fileName);

      except
        on E: Exception do
          WriteLn('Erreur lors de la création du fichier XML : ' + E.Message);
      end;
    finally
      XMLContent.Free;
    end;
  end;

Procedure XmlImport(FileName: String; OnlyPrimary: Boolean; OnlyCode: Boolean);
  var
    XMLDoc:                   TXMLDocument;
    BookNode:                 TDOMNode;
    Livre:                    String;
    CodeLivre:                String;
    NodeNv1:                  TDOMNode;
    NodeNv2:                  TDOMNode;
    NodeNv3:                  TDOMNode;
    NodeNv4:                  TDOMNode;
    NodeCode:                 TDOMNode;
    Node:                     TDOMNode;
    PCompetence:              StructureCompetence;
    PTalent:                  StructureTalent;
    PTalentCreation:          StructureTalentCreation;
    PRace:                    StructureRace;
    PRaceAttribut:            StructureRaceAttribut;
    PRaceCompetence:          StructureRaceCompetence;
    PRaceTalent:              StructureRaceTalent;
    PRaceMetier:              StructureRaceMetier;
    PRaceCreation:            StructureRaceCreation;
    PMetier:                  StructureMetier;
    PMetierNiveau:            StructureMetierNiveau;
    PMetierAttribut:          StructureMetierAttribut;
    PMetierTalent:            StructureMetierTalent;
    PMetiercompetence:        StructureMetierCompetence;
    PMetierEquipement:        StructureMetierEquipement;
    PArme:                    StructureArme;
    PArmeBonus:               StructureArmeBonus;
    PArmure:                  StructureArmure;
    PArmureBonus:             StructureArmureBonus;
    PSort:                    StructureSort;
    PFabrication:             StructureFabrication;
    PMetierRaceChoixMetier:   StructureMetierRaceChoixMetier;
    PMetierSousMetier:        StructureMetierSousMetier;
    PAttribut:                StructureAttribut;
    PAttributAugmentation:    StructureAttributAugmentation;
    PCompetenceAugmentation:  StructureCompetenceAugmentation;
    PTexte:                   StructureTexte;
    PCompetenceMere:          StructureCompetence;
    PTraduction:              StructureTraduction;
    PTraductionNv2:           StructureTraduction;
    PArmureSimplifiee:        StructureArmureSimplifiee;
    PRaceCorruptionCreation:  StructureRaceCorruptionCreation;
    PTalentAttributModif:     StructureTalentAttributModif;
    PTalentCompetenceModif:   StructureTalentCompetenceModif;
    PTalentCompetenceAjoute:  StructureTalentCompetenceAjoute;
    PLivre:                   StructureLivre;
    Langue:                   String;
    LangueNv2:                String;
    LangueDef:                String;
    Version:                  String;
    Officiel:                 Integer;
    Complet:                  Integer = 1;
  begin
    LivreNbMetier := 0;
    LivreNbRace   := 0;
    XMLDoc   := TXMLDocument.Create;
    try
      ReadXMLFile(XMLDoc, GetCurrentDir + ConstCheminLivre + FileName + '.xml');
      BookNode := XMLDoc.DocumentElement;
      if Assigned(BookNode) and (BookNode.NodeName = ConstXmlDataBook) then
        Begin
          Livre     := RemoveQuotes(UTF8Encode(BookNode.FindNode(ConstXmlLibelleLivre).TextContent));
          NodeCode  := BookNode.FindNode(ConstXmlCodeLivre);
          if Assigned(NodeCode) then
            CodeLivre := RemoveQuotes(UTF8Encode(BookNode.FindNode(ConstXmlCodeLivre).TextContent));
          NodeCode  := BookNode.FindNode(ConstXmlVersionLivre);
          if Assigned(NodeCode) then
            Version := RemoveQuotes(UTF8Encode(BookNode.FindNode(ConstXmlVersionLivre).TextContent));
          NodeCode  := BookNode.FindNode(ConstXmlOfficielLivre);
          if Assigned(NodeCode) then
            Officiel:= StrToInt(RemoveQuotes(UTF8Encode(BookNode.FindNode(ConstXmlOfficielLivre).TextContent)));
          NodeCode  := BookNode.FindNode(ConstXmlCompletLivre);
          if Assigned(NodeCode) then
            Complet := StrToInt(RemoveQuotes(UTF8Encode(BookNode.FindNode(ConstXmlCompletLivre).TextContent)));
          Node      := BookNode.FindNode(ConstXmlLanguage);
          LangueDef := RemoveQuotes(UTF8Encode(Node.TextContent));

          PLIvre.CodeLivre:= '';
          PLivre := ChercheLivreLibelle(Livre);
          if PLivre.CodeLivre = '' then
            begin
              PLivre.CodeLivre := CodeLivre;
              PLivre.Libelle   := Livre;
              PLivre.Version   := Version;
              PLivre.Officiel  := Officiel;
              PLivre.Complet   := Complet;
              ListLivre.add(PLivre);
              inc(NbLivre);
            end;
          if OnlyPrimary then
            begin
              // Attribut
              NodeNv1 := BookNode.FindNode(ConstXmlDataAttribut);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PAttribut.Livre          := Livre;
                      PAttribut.CodeAttribut   := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction              := InitTrad(ConstPAttribut, PAttribut.CodeAttribut, '', PAttribut.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlDescription:
                              begin
                                PAttribut.Libelle       := RemoveQuotes(UTF8Encode(Node.TextContent));
                                PTraduction.Libelle     := PAttribut.Libelle;
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue))
                              end;
                            ConstXmlExplanation:
                              begin
                                PAttribut.Description   := RemoveQuotes(UTF8Encode(Node.TextContent));
                                PTraduction.Description := PAttribut.Description;
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue))
                              end;
                            ConstXmlShort:
                              begin
                                PAttribut.Resume        := RemoveQuotes(UTF8Encode(Node.TextContent));
                                PTraduction.Resume      := PAttribut.Resume;
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue))
                              end;
                            ConstXmlOrder:
                              PAttribut.OrdreAttribut   := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                          end;

                          Node := Node.NextSibling;
                        end;
                        if LangueDef = ConstAnglais then
                          begin
                            ListeAttribut.add(PAttribut);
                            inc(NbAttribut);
                          end;

                        AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // AttributAugmentation
              NodeNv1 := BookNode.FindNode(ConstXmlDataAttributCost);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PAttributAugmentation.Livre  := Livre;
                      PAttributAugmentation.MinMax := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PAttributAugmentation.Cout   := StrToIntDef(RemoveQuotes(UTF8Encode(NodeNv2.TextContent)),0);

                        if LangueDef = ConstAnglais then
                          begin
                            ListeAttributAugmentation.add(PAttributAugmentation);
                            inc(NbAttributAugmentation);
                          end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // CompetenceAugmentation
              NodeNv1 := BookNode.FindNode(ConstXmlDataSkillCost);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PCompetenceAugmentation.Livre          := Livre;
                      PCompetenceAugmentation.MinMax := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PCompetenceAugmentation.Cout   := StrToIntDef(RemoveQuotes(UTF8Encode(NodeNv2.TextContent)),0);

                        if LangueDef = ConstAnglais then
                          begin
                            ListeCompetenceAugmentation.add(PCompetenceAugmentation);
                            inc(NbCompetenceAugmentation);
                          end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Texte
              NodeNv1 := BookNode.FindNode(ConstXmlDataLabel);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      Langue                    := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                      NodeNv3 := NodeNv2.FirstChild;
                      While Assigned(NodeNv3) do
                        begin
                          PTexte.Code           := RemoveQuotes(UTF8Encode(NodeNv3.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                          PTexte.Livre          := Livre;
                          PTraduction           := InitTrad(ConstPTexte, PTexte.Code, '', PTexte.Livre);
                          PTexte.Libelle        := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                          PTraduction.Libelle   := PTexte.Libelle;

                            if LangueDef = ConstAnglais then
                              begin
                                ListTexte.add(PTexte);
                                inc(NbTexte);
                              end;

                          AddTrad(PTraduction, Langue);

                          NodeNv3 := NodeNv3.NextSibling;
                        end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;
            end;

         if Not OnlyPrimary then
            begin
              // Compétences
              NodeNv1 := BookNode.FindNode(ConstXmlDataSkill);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PCompetence.Livre          := Livre;
                      PCompetence.SousCompetence := False;
                      PCompetence.CodeCompetence := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction                := InitTrad(ConstPCompetence, PCompetence.CodeCompetence, '', PCompetence.Livre);
                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlCarac:
                              PCompetence.CodeAttribut  := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlDescription:
                              begin
                                PCompetence.Libelle     := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle     := PCompetence.Libelle;
                              end;
                            ConstXmlExplanation:
                              begin
                                PCompetence.Description := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description := PCompetence.Description;
                              end;
                          end;

                          Node := Node.NextSibling;
                        end;
                     if LangueDef = ConstAnglais then
                       begin
                          ListCompetence.add(PCompetence);
                          inc(NbCompetence);
                          inc(NbCompetenceUnique);
                       end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Compétences spécialisée
              NodeNv1 := BookNode.FindNode(ConstXmlDataSkillSpe);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PCompetence.Livre          := Livre;
                      PCompetence.SousCompetence := True;
                      PCompetence.Description := '';
                      PCompetence.CodeAttribut   := '';
                      PCompetence.CodeCompetence := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction                := InitTrad(ConstPCompetence, PCompetence.CodeCompetence, '', PCompetence.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlDescription:
                              begin
                                PCompetence.Libelle     := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle     := PCompetence.Libelle;
                              end;
                          end;

                          Node := Node.NextSibling;
                        end;
                      PCompetenceMere := ChercheCompetence(ExtractStringBefore(PCompetence.CodeCompetence,ValeurSousCompetence)+ValeurGenerique);
                      PCompetence.CodeAttribut := PCompetenceMere.CodeAttribut;
                       if LangueDef = ConstAnglais then
                         begin
                          ListCompetence.add(PCompetence);
                          inc(NbCompetence);
                         end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Talent
              NodeNv1 := BookNode.FindNode(ConstXmlDataTalent);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PTalent.Livre          := Livre;
                      PTalent.SousTalent     := false;
                      PTalent.CodeTalent     := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction            := InitTrad(ConstPTalent, PTalent.CodeTalent, '', PTalent.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlCarac:
                              PTalent.Attribut          := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlDescription:
                              begin
                                PTalent.Libelle         := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle     := PTalent.Libelle;
                              end;
                            ConstXmlExplanation:
                              begin
                                PTalent.Description     := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description := PTalent.Description;
                              end;
                            ConstXmlShort:
                              begin
                                PTalent.Resume          := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Resume      := PTalent.Resume;
                              end;
                            ConstXmlCompetence:
                              PTalent.CompAjoutee       := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlMax:
                              PTalent.MaxiTalent        := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlForPdf:
                              PTalent.TalentPdf         := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlTest:
                              begin
                                PTalent.Tests           := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Tests       := PTalent.Tests;
                              end;
                            ConstXmlModifieAttribut:
                              begin
                                PTalentAttributModif.Livre        := Livre;
                                PTalentAttributModif.CodeTalent   := PTalent.CodeTalent;
                                PTalentAttributModif.CodeAttribut := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                PTalentAttributModif.ValeurDonnee := RemoveQuotes(UTF8Encode(Node.TextContent));
                                if LangueDef = ConstAnglais then
                                   begin
                                    ListTalentAttributModif.add(PTalentAttributModif);
                                    inc(NbTalentAttributModif);
                                   end;
                              end;
                            ConstXmlModifieCompetence:
                              begin
                                PTalentCompetenceModif.Livre          := Livre;
                                PTalentCompetenceModif.CodeTalent     := PTalent.CodeTalent;
                                PTalentCompetenceModif.CodeCompetence := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                PTalentCompetenceModif.TypeModif      := RemoveQuotes(UTF8Encode(Node.TextContent));
                                if LangueDef = ConstAnglais then
                                   begin
                                    ListTalentCompetenceModif.add(PTalentCompetenceModif);
                                    inc(NbTalentCompetenceModif);
                                   end;
                              end;
                            ConstXmlAjouteCompetence:
                              begin
                                PTalentCompetenceAjoute.Livre          := Livre;
                                PTalentCompetenceAjoute.CodeTalent     := PTalent.CodeTalent;
                                PTalentCompetenceAjoute.CodeCompetence := RemoveQuotes(UTF8Encode(Node.TextContent));
                                if LangueDef = ConstAnglais then
                                   begin
                                    ListTalentCompetenceAjoute.add(PTalentCompetenceAjoute);
                                    inc(NbTalentCompetenceAjoute);
                                   end;
                              end;
                          end;

                          Node := Node.NextSibling;
                        end;
                       if LangueDef = ConstAnglais then
                         begin
                          ListTalent.add(PTalent);
                          inc(NbTalent);
                          inc(NbTalentUnique);
                         end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // talents spécialisée
              NodeNv1 := BookNode.FindNode(ConstXmlDataTalentSpe);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PTalent.Livre             := Livre;
                      PTalent.SousTalent        := True;
                      PTalent.Description       := '';

                      PTalent.Attribut          := '';
                      PTalent.Description       := '';
                      PTalent.Resume            := '';
                      PTalent.CompAjoutee       := '';
                      PTalent.MaxiTalent        := '';
                      PTalent.TalentPdf         := '';
                      PTalent.Tests             := '';
                      PTalent.CodeTalent        := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction               := InitTrad(ConstPTalent, PTalent.CodeTalent, '', PTalent.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlDescription:
                              begin
                              PTalent.Libelle     := RemoveQuotes(UTF8Encode(Node.TextContent));
                              Langue              := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                              PTraduction.Libelle := PTalent.Libelle;
                              end;
                          end;

                          Node := Node.NextSibling;
                        end;
                       if LangueDef = ConstAnglais then
                         begin
                          ListTalent.add(PTalent);
                          inc(NbTalent);
                         end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Talent Création
              NodeNv1 := BookNode.FindNode(ConstXmlDataRandomTalent);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PTalentCreation.Livre      := Livre;
                      PTalentCreation.CodeTalent := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlRace:
                              PTalentCreation.CodeRace   := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlTalent:
                              PTalentCreation.Chance     := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;

                          Node := Node.NextSibling;
                        end;
                       if LangueDef = ConstAnglais then
                         begin
                          ListTalentCreation.add(PTalentCreation);
                          inc(NbTalentCreation);
                         end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Race
              NodeNv1 := BookNode.FindNode(ConstXmlDataSpecie);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PRace.Livre    := Livre;
                      PRace.CodeRace := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PRace.Point3   := 3;
                      PRace.Point5   := 5;
                      PTraduction    := InitTrad(ConstPRace, PRace.CodeRace, '', PRace.Livre);

                      NodeNv3 := NodeNv2.FirstChild;
                      while Assigned(NodeNv3) do
                        begin
                          case NodeNv3.NodeName of
                            ConstXmlDescription:
                              begin
                                PRace.Libelle          := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                                Langue                 := RemoveQuotes(UTF8Encode(NodeNv3.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle    := PRace.Libelle;
                              end;
                            ConstXmlExplanation:
                              begin
                                PRace.Description       := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(NodeNv3.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description := PRace.Description;
                              end;
                            ConstXmlEthnic:
                              PRace.Espece              := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                            ConstXmlSousChapitreCarac:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlCarac:
                                         begin
                                           PRaceAttribut.Livre        := Livre;
                                           PRaceAttribut.CodeRace     := PRace.CodeRace;
                                           PRaceAttribut.CodeAttribut := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PRaceAttribut.CalculRace   := RemoveQuotes(UTF8Encode(Node.TextContent));
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListRaceAttribut.add(PRaceAttribut);
                                               inc(NbRaceAttribut);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreCompetence:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlCompetence:
                                         begin
                                           PRaceCompetence.Livre          := Livre;
                                           PRaceCompetence.CodeRace       := PRace.CodeRace;
                                           PRaceCompetence.CodeCompetence := RemoveQuotes(UTF8Encode(Node.TextContent));
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListRaceCompetence.add(PRaceCompetence);
                                               inc(NbRaceCompetence);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreTalent:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlTalent:
                                         begin
                                           PRaceTalent.Livre          := Livre;
                                           PRaceTalent.CodeRace       := PRace.CodeRace;
                                           PRaceTalent.CodeTalent     := RemoveQuotes(UTF8Encode(Node.TextContent));
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListRaceTalent.add(PRaceTalent);
                                               inc(NbRaceTalent);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreMetier:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlWork:
                                         begin
                                           PRaceMetier.Livre        := Livre;
                                           PRaceMetier.CodeRace     := PRace.CodeRace;
                                           PRaceMetier.CodeMetier   := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PRaceMetier.Chance       := RemoveQuotes(UTF8Encode(Node.TextContent));
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListRaceMetier.add(PRaceMetier);
                                               inc(NbRaceMetier);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlOpinions:  // ✨ NOUVEAU - Traiter les opinions
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlOpinion:
                                         begin
                                           PRaceOpinion.Livre      := Livre;
                                           PRaceOpinion.CodeRace   := PRace.CodeRace;
                                           PRaceOpinion.TargetRace := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlTarget).NodeValue));
                                           PRaceOpinion.Source     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlSource).NodeValue));
                                           PRaceOpinion.Citation   := RemoveQuotes(UTF8Encode(Node.TextContent));
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListRaceOpinion.add(PRaceOpinion);
                                               inc(NbRaceOpinion);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;

                          end;

                          NodeNv3 := NodeNv3.NextSibling;
                        end;
                       if LangueDef = ConstAnglais then
                         begin
                          ListRace.add(PRace);
                          inc(NbRace);
                          Inc(LivreNbrace);
                         end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Race au hasard
              NodeNv1 := BookNode.FindNode(ConstXmlDataSpecieCreation);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PRaceCreation.Livre    := Livre;
                      PRaceCreation.CodeRace := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PRaceCreation.Chance   := RemoveQuotes(UTF8Encode(NodeNv2.TextContent));

                       if LangueDef = ConstAnglais then
                         begin
                          ListRaceCreation.add(PRaceCreation);
                          inc(NbRaceCreation);
                         end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Métier
              NodeNv1 := BookNode.FindNode(ConstXmlDataCareer);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PMetier.Livre      := Livre;
                      PMetier.CodeMetier := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction        := InitTrad(ConstPMetier, PMetier.CodeMetier, '', PMetier.Livre);

                      NodeNv3 := NodeNv2.FirstChild;
                      while Assigned(NodeNv3) do
                        begin
                          case NodeNv3.NodeName of
                            ConstXmlDescription:
                              begin
                                PMetier.Libelle         := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(NodeNv3.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle     := PMetier.Libelle;
                              end;
                            ConstXmlExplanation:
                              begin
                                PMetier.Description     := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                                Langue                  := RemoveQuotes(UTF8Encode(NodeNv3.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description := PMetier.Description;
                              end;
                            ConstXmlClass:
                              PMetier.LibelleGroupe := RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                            ConstXmlCompetence:
                              PMetier.CodeCompetence:= RemoveQuotes(UTF8Encode(NodeNv3.TextContent));
                            ConstXmlSousChapitreNiveau:
                              begin
                                NodeNv4 := NodeNv3.FirstChild;
                                while Assigned(NodeNv4) do
                                  begin
                                    case NodeNv4.NodeName of
                                       ConstXmlNvWork:
                                         begin
                                           PMetierNiveau.NiveauMetier := StrToIntDef(RemoveQuotes(UTF8Encode(NodeNv4.Attributes.GetNamedItem(ConstXmlId).NodeValue)),0);
                                           PMetierNiveau.Livre        := Livre;
                                           PMetierNiveau.CodeMetier   := PMetier.CodeMetier;
                                           PTraductionNv2             := InitTrad(PMetierNiveau.CodeMetier, IntToStr(PMetierNiveau.NiveauMetier), '', PMetierNiveau.Livre);
                                           Node := NodeNv4.FirstChild;
                                           while Assigned(Node) do
                                             begin
                                               case Node.NodeName of
                                                  ConstXmlDescription:
                                                    begin
                                                      PMetierNiveau.Libelle  := RemoveQuotes(UTF8Encode(Node.TextContent));
                                                      LangueNv2              := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                                      PTraductionNv2.Libelle := PMetierNiveau.Libelle;
                                                    end;
                                                  ConstXmlSalaire:
                                                    PMetierNiveau.SalaireMetier := RemoveQuotes(UTF8Encode(Node.TextContent));
                                               end;
                                               Node := Node.NextSibling;
                                             end;
                                            if LangueDef = ConstAnglais then
                                              begin
                                                ListMetierNiveau.Add(PMetierNiveau);
                                                Inc(NbMetierNiveau);
                                              end;

                                           AddTrad(PTraductionNv2, LangueNv2);
                                         end;
                                    end;
                                    NodeNv4 := NodeNv4.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreCarac:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlCarac:
                                         begin
                                           PMetierAttribut.Livre        := Livre;
                                           PMetierAttribut.CodeMetier   := PMetier.CodeMetier;
                                           PMetierAttribut.CodeAttribut := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PMetierAttribut.NiveauMetier := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListMetierAttribut.add(PMetierAttribut);
                                               inc(NbMetierAttribut);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreCompetence:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlCompetence:
                                         begin
                                           PMetierCompetence.Livre          := Livre;
                                           PMetierCompetence.CodeMetier     := PMetier.CodeMetier;
                                           PMetierCompetence.CodeCompetence := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PMetierCompetence.NiveauMetier   := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListMetierCompetence.add(PMetierCompetence);
                                               inc(NbMetierCompetence);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreTalent:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlTalent:
                                         begin
                                           PMetierTalent.Livre          := Livre;
                                           PMetierTalent.CodeMetier     := PMetier.CodeMetier;
                                           PMetierTalent.CodeTalent     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PMetierTalent.NiveauMetier   := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                                            if LangueDef = ConstAnglais then
                                              begin
                                               ListMetierTalent.add(PMetierTalent);
                                               inc(NbMetierTalent);
                                              end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreEquipement:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlEquipement:
                                         begin
                                           PMetierEquipement.Livre          := Livre;
                                           PMetierEquipement.CodeMetier     := PMetier.CodeMetier;
                                           PMetierEquipement.Equipement     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PMetierEquipement.NiveauMetier   := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);

                                           if LangueDef = ConstAnglais then
                                             begin
                                               PMetierEquipement.TypeEquipement := GetTypeMetierEquipement(PMetierEquipement.Equipement);
                                               ListMetierEquipement.add(PMetierEquipement);
                                               inc(NbMetierEquipement);
                                             end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                            ConstXmlSousChapitreRace:
                              begin
                                Node := NodeNv3.FirstChild;
                                while Assigned(Node) do
                                  begin
                                    case Node.NodeName of
                                       ConstXmlRace:
                                         begin
                                           PRaceMetier.Livre          := Livre;
                                           PRaceMetier.CodeMetier     := PMetier.CodeMetier;
                                           PRaceMetier.CodeRace       := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                           PRaceMetier.Chance         := RemoveQuotes(UTF8Encode(Node.TextContent));

                                           if LangueDef = ConstAnglais then
                                             begin
                                               ListRaceMetier.add(PRaceMetier);
                                               inc(NbRaceMetier);
                                             end;
                                         end;
                                    end;
                                    Node := Node.NextSibling;
                                  end;
                              end;
                          end;

                          NodeNv3 := NodeNv3.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListMetier.add(PMetier);
                          inc(NbMetier);
                          Inc(LivreNbMetier);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Armes
              NodeNv1 := BookNode.FindNode(ConstXmlDataWeapon);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PArme.Livre    := Livre;
                      PArme.CodeArme := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction    := InitTrad(ConstPArme, PArme.CodeArme, '', PArme.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlCompetence:
                              PArme.CodeCompetence  := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlDescription:
                              begin
                                PArme.Libelle       := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue              := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle := PArme.Libelle;
                              end;
                            ConstXmlDisponibilite:
                              PArme.Disponibilite   := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlDamage:
                              PArme.CalculDegat     := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlEncombrement:
                              PArme.Encombrement    := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlQualite:
                              PArme.ListeBonus      := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlMains:
                              PArme.Mains           := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlMunition:
                              PArme.Munition        := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlPorteeArme:
                              PArme.Portee          := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlPrix:
                              PArme.Prix            := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;

                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListArme.add(PArme);
                          inc(NbArme);
                          inc(NbArmeUnique);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // ArmeBonus
              NodeNv1 := BookNode.FindNode(ConstXmlDataWeaponBonus);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PArmeBonus.Livre         := Livre;
                      PArmeBonus.CodeArmeBonus := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction              := InitTrad(ConstPArmeBonus, PArmeBonus.CodeArmeBonus, '', PArmeBonus.livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlExplanation:
                              begin
                                PArmeBonus.Description     := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description    := PArmeBonus.Description;
                              end;
                            ConstXmlDescription:
                              begin
                                PArmeBonus.Libelle         := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle        := PArmeBonus.Libelle;
                              end;
                            ConstXmlBonus:
                              PArmeBonus.PlusMoins         := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlShort:
                              begin
                                PArmeBonus.Resume          := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Resume         := PArmeBonus.Resume;
                              end;
                          end;

                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListArmeBonus.add(PArmeBonus);
                          inc(NbArmeBonus);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Armures simplifiées
              NodeNv1 := BookNode.FindNode(ConstXmlDataArmorSimplified);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PArmureSimplifiee.Livre      := Livre;
                      PArmureSimplifiee.CodeArmure := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction                  := InitTrad(ConstPArmureSimplifiee, PArmureSimplifiee.CodeArmure, '', PArmureSimplifiee.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlProtection:
                              PArmureSimplifiee.Protection      := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlDescription:
                              begin
                                PArmureSimplifiee.Libelle       := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                          := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle             := PArmureSimplifiee.Libelle;
                              end;
                            ConstXmlDisponibilite:
                              PArmureSimplifiee.Disponibilite   := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlEncombrement:
                              PArmureSimplifiee.Encombrement    := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlPrix:
                              PArmureSimplifiee.Prix            := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlQualite:
                              PArmureSimplifiee.ListeBonus      := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;

                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListArmureSimplifiee.add(PArmureSimplifiee);
                          inc(NbArmureSimplifiee);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Armures
              NodeNv1 := BookNode.FindNode(ConstXmlDataArmor);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PArmure.Livre      := Livre;
                      PArmure.CodeArmure := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction        := InitTrad(ConstPArmure, PArmure.CodeArmure, '', PArmure.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlProtection:
                              PArmure.Protection      := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlDescription:
                              begin
                                PArmure.Libelle       := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle   := PArmure.Libelle;
                              end;
                            ConstXmlDisponibilite:
                              PArmure.Disponibilite   := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlType:
                              PArmure.TypeMateriel    := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlEncombrement:
                              PArmure.Encombrement    := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlPrix:
                              PArmure.Prix            := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlEmplacement:
                              PArmure.Emplacement     := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlQualite:
                              PArmure.ListeBonus      := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;

                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListArmure.add(PArmure);
                          inc(NbArmure);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // ArmureBonuss
              NodeNv1 := BookNode.FindNode(ConstXmlDataArmorBonus);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PArmureBonus.Livre           := Livre;
                      PArmureBonus.CodeArmureBonus := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction                  := InitTrad(ConstPArmureBonus, PArmureBonus.CodeArmureBonus, '', PArmureBonus.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlExplanation:
                              begin
                                PArmureBonus.Description   := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description    := PArmureBonus.Description;
                              end;
                            ConstXmlDescription:
                              begin
                                PArmureBonus.Libelle       := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                     := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle        := PArmureBonus.Libelle;
                              end;
                            ConstXmlPositifNegatif:
                              PArmureBonus.Malus           := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;

                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListArmureBonus.add(PArmureBonus);
                          inc(NbArmureBonus);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Sorts
              NodeNv1 := BookNode.FindNode(ConstXmlDataSpell);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PSort.Livre    := Livre;
                      PSort.CodeSort := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction    := InitTrad(ConstPSort, PSort.CodeSort, '', PSort.Livre);

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlExplanation:
                              begin
                                PSort.Description         := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                    := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description   := PSort.Description;
                              end;
                            ConstXmlDescription:
                              begin
                                PSort.Libelle             := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                    := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle       := PSort.Libelle;
                              end;
                            ConstXmlCible:
                              PSort.Cible           := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlDuree:
                              PSort.Duree           := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlPorteeSort:
                              PSort.Portee          := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlTalent:
                              PSort.ListeTalent     := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlNiveau:
                              PSort.Niveau          := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlTypeSort:
                              PSort.TypeSort        := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;

                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListSort.add(PSort);
                          inc(NbSort);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Fabrication
              NodeNv1 := BookNode.FindNode(ConstXmlDataCraftsmanship);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PFabrication.Livre           := Livre;
                      PFabrication.CodeFabrication := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlId).NodeValue));
                      PTraduction                  := InitTrad(ConstPFabrication, PFabrication.CodeFabrication, '', PFabrication.Livre);
                      PFabrication.Encombrement    := 0;
                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlDescription:
                              begin
                                PFabrication.Libelle     := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                   := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Libelle      := PFabrication.Libelle;
                              end;
                            ConstXmlExplanation:
                              begin
                                PFabrication.Description := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                   := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Description  := PFabrication.Description;
                              end;
                            ConstXmlShort:
                              begin
                                PFabrication.Resume      := RemoveQuotes(UTF8Encode(Node.TextContent));
                                Langue                   := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlLanguage).NodeValue));
                                PTraduction.Resume       := PFabrication.Resume;
                              end;
                            ConstXmlEncombrement:
                              PFabrication.Encombrement  := StrToIntDef(RemoveQuotes(UTF8Encode(Node.TextContent)),0);
                            ConstXmlMax:
                              PFabrication.Maximum       := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlPositifNegatif:
                              PFabrication.TypeQualite   := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;
                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListFabrication.add(PFabrication);
                          inc(NbFabrication);
                        end;

                      AddTrad(PTraduction, Langue);

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Metier choix race
              NodeNv1 := BookNode.FindNode(ConstXmlDataSpecieCareerChoix);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PMetierRaceChoixMetier.Livre    := Livre;

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlRace:
                              PMetierRaceChoixMetier.CodeRace       := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlWork:
                              PMetierRaceChoixMetier.CodeMetier     := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlAlternative:
                              PMetierRaceChoixMetier.CodeSousMetier := RemoveQuotes(UTF8Encode(Node.TextContent));
                          end;
                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListMetierRaceChoixMetier.add(PMetierRaceChoixMetier);
                          inc(NbMetierRaceChoixMetier);
                        end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Metier Sous Métier
              NodeNv1 := BookNode.FindNode(ConstXmlDataCareerSubChoice);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PMetierSousMetier.Livre    := Livre;

                      Node := NodeNv2.FirstChild;
                      while Assigned(Node) do
                        begin
                          case Node.NodeName of
                            ConstXmlWork:
                              PMetierSousMetier.CodeMetier       := RemoveQuotes(UTF8Encode(Node.TextContent));
                            ConstXmlAlternative:
                              begin
                                PMetierSousMetier.CodeSousMetier := RemoveQuotes(UTF8Encode(Node.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                                PMetierSousMetier.Chance         := RemoveQuotes(UTF8Encode(Node.TextContent));
                              end;
                          end;
                          Node := Node.NextSibling;
                        end;
                      if LangueDef = ConstAnglais then
                        begin
                          ListMetierSousMetier.add(PMetierSousMetier);
                          inc(NbMetierSousMetier);
                        end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Race Corruption Physique
              NodeNv1 := BookNode.FindNode(ConstXmlDataPhysicalCorruption);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PRaceCorruptionCreation.Livre          := Livre;
                      PRaceCorruptionCreation.CodeRace       := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PRaceCorruptionCreation.TypeCorruption := CorruptionPhysique;
                      PRaceCorruptionCreation.Chance         := RemoveQuotes(UTF8Encode(NodeNv2.TextContent));

                       if LangueDef = ConstAnglais then
                         begin
                          ListRaceCorruptionCreation.add(PRaceCorruptionCreation);
                          inc(nbRaceCorruptionCreation);
                         end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

              // Race Corruption Mentale
              NodeNv1 := BookNode.FindNode(ConstXmlDataMentalCorruption);
              if Assigned(NodeNv1) then
                begin
                  NodeNv2 := NodeNv1.FirstChild;
                  While Assigned(NodeNv2) do
                    begin
                      PRaceCorruptionCreation.Livre          := Livre;
                      PRaceCorruptionCreation.CodeRace       := RemoveQuotes(UTF8Encode(NodeNv2.Attributes.GetNamedItem(ConstXmlData).NodeValue));
                      PRaceCorruptionCreation.TypeCorruption := CorruptionMentale;
                      PRaceCorruptionCreation.Chance         := RemoveQuotes(UTF8Encode(NodeNv2.TextContent));

                       if LangueDef = ConstAnglais then
                         begin
                          ListRaceCorruptionCreation.add(PRaceCorruptionCreation);
                          inc(nbRaceCorruptionCreation);
                         end;

                      NodeNv2 := NodeNv2.NextSibling;
                    end;
                end;

            end;

        end;
    finally
      XMLDoc.Free;
    end;
  end;

Function XmlLivre(FileName: String): string;
  var
    XMLDoc:                   TXMLDocument;
    BookNode:                 TDOMNode;
    Node:                     TDOMNode;
    Livre:                    String = '';
  begin
    XMLDoc   := TXMLDocument.Create;
    try
      ReadXMLFile(XMLDoc, GetCurrentDir + ConstCheminLivre + FileName + '.xml');
      BookNode := XMLDoc.DocumentElement;
      if Assigned(BookNode) and (BookNode.NodeName = ConstXmlDataBook) then
        begin
          Livre          := RemoveQuotes(UTF8Encode(BookNode.FindNode(ConstXmlLibelleLivre).TextContent));
          Node           := BookNode.FindNode(ConstXmlLanguage);
          LivreLangue    := RemoveQuotes(UTF8Encode(Node.TextContent));
          Node           := BookNode.FindNode(ConstXmlCompletLivre);
          if Assigned(BookNode.FindNode(ConstXmlCompletLivre)) then
            LivreComplet := StrtoBool(RemoveQuotes(UTF8Encode(Node.TextContent)))
          else
            LivreComplet := True;
        end;
    finally
      XMLDoc.Free;
    end;
    Result := Livre;
  end;

end.

