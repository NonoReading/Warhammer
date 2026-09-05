unit PdfRace;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpPDF, Dialogs, PicsLib, Graphics, LCLIntf,
  ChargeRace, ChargeEspece, ChargeConstantes, ChargeAttribut, ChargeRaceAttribut,
  ChargeRaceCompetence, ChargeCompetence, ChargeRaceTalent, ChargeTalent,
  ChargeRaceMetier, ChargeMetier, PdfPersonnage,
  ChargeTexte, PdfUtils, UnitCalcul;

Procedure PdfRaceCreation(RaceEnCours: String);
function PdfPositionFeuille(Base:Integer; NbLigne:Integer): Real;

implementation

Var
  HautFeuille:   Integer = 0;

function PdfPositionFeuille(Base:Integer; NbLigne:Integer): Real;
var
  TailleLigne:  Real = 3.5;

begin
  Result := Base - (NbLigne * TailleLigne) + 1 - HautFeuille;
end;

Procedure PdfRaceCreation(RaceEnCours: String);
  var
    PDFDoc:             TPDFDocument;
    PDFSection:         TPDFSection;
    PDFPage:            TPDFPage;
    PdfChemin:          String;
    PDFOption:          TPDFOptions;
    PRace:              StructureRace;
    Path:               String;
    PdfImgRace:         Integer;
    PdfImgFront:        Integer;
    PdfImgGauche:       Integer;
    PdfImgDroite:       Integer;
    PdfImgFeuille:      Integer;
    Ind:                Integer;
    IWidth, IHeight:    dword;
    CWidth, cHeight:    dword;
    MinPolice:          integer = 7;
    DebutFeuille:       Integer = 100;
    LargeurFeuille:     Integer = 100;
    DebutImgMetier:     Integer = 10;
    TailleCellule:      Integer = 8;
    HautAttribut:       Integer = 5;
    DebutSous:          Integer = 10;
    DebutTalent:        Integer = 60;
    PAttribut:          StructureAttribut;
    PRaceAttribut:      StructureRaceAttribut;
    NbLigne:            Integer = 0;
    Coord:              TPDFCoord;
    DebutTexte:         Integer = 265;
    MargeDroite:        Integer = 5;
    StringAttribut:     TStringList;
    IndAttribut:        Integer;
    PRaceCompetence:    StructureRaceCompetence;
    PCompetence:        StructureCompetence;
    StringTalent:       TStringList;
    IndTalent:          Integer;
    PRaceTalent:        StructureRaceTalent;
    PTalent:            StructureTalent;
    DecAuchoix:         Integer;
    PRaceMetier:        StructureRaceMetier;
    PMetier:            StructureMetier;
    DebutCompetence:    Integer;
    NbTalent:           Integer;
    DerniereClasse:     String;
    Totaltalent:        Integer = 0;
    MaxTailleDetail:    Integer = 110;
    TexteCompetence:    String;
    IndC:               Integer;
    ListPage:           TStringList;
    Trouve:             Boolean;

begin
    PRace := chercheRace(RaceEnCours);

    // Chemin de l'image que vous souhaitez ajouter
    PdfChemin        := GetCurrentDir+ConstCheminPersonnage+'\'+TrimRight(PRace.Libelle)+'.PDF';

    ListPage       := TStringList.Create;

    PdfPersonnageCompetenceTri(ListPage);

    if FileExists(PdfChemin) then
      if not DeleteFile(PdfChemin) then
      begin
        ShowMessage(GetTexteLibelle('MESS_038'));
        exit;
      end;
    PDFDoc           := TPDFDocument.Create(nil);
    PDFOption        := [poUseImageTransparency, poCompressImages, poCompressFonts, poCompressText ];
    PDFDoc.Options   := PDFOption;
    PDFDoc.StartDocument;
    PdfSection       := PDFDoc.Sections.AddSection;

    PdfPage          := PDFDoc.Pages.AddPage;
    PdfFontBold      := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique.ttf', ConstPoliceCarlson);
    PdfFontItalique  := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Italic.ttf', ConstPoliceCarlson+ConstPoliceItalique);

    PdfSection.AddPage(PdfPage);
    PdfPage.PaperType:= ptA4;
    PdfPage.UnitOfMeasure := uomMillimeters;

    // image fond
    Path              := GetCurrentDir+StringReplace(ConstCheminPdfMetierBack, ConstLangue, ValLangue, [rfReplaceAll]);
    PdfImgFront       := PdfDoc.Images.AddFromFile(Path);
    PdfPage.DrawImage(0, 0, 210, 297, PdfImgFront);

    // Haut et bas de page
      // gauche
      Path              := GetCurrentDir+ConstCheminPdfMetierLigneG;
      PdfImgGauche      := PdfDoc.Images.AddFromFile(Path,false);
      GetImageSize(Path, IWidth, IHeight);
      RedimensionneImage(IWidth, IHeight, 85, 999, CWidth, cHeight);
      PdfPage.DrawImage(10, 10, cWidth, cHeight, PdfImgGauche);
      PdfPage.DrawImage(10, 287, cWidth, cHeight, PdfImgGauche);

      // droite
      Path              := GetCurrentDir+ConstCheminPdfMetierLigneD;
      PdfImgDroite      := PdfDoc.Images.AddFromFile(Path,false);
      GetImageSize(Path, IWidth, IHeight);
      RedimensionneImage(IWidth, IHeight, 85, 999, CWidth, cHeight);
      PdfPage.DrawImage(115, 10, cWidth, cHeight, PdfImgDroite);
      PdfPage.DrawImage(115, 287, cWidth, cHeight, PdfImgDroite);

      // texte
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 9);
      PdfCentre(PdfPage, 95, 115, 11, WideUpperCase(WideString(ChercheEspece(PRace.Espece).Libelle)){%H-});
      PdfCentre(PdfPage, 95, 115, 288, WideUpperCase(WideString(ChercheEspece(PRace.Espece).Libelle)){%H-});

      // texte
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 24);
      PdfEcrit(PdfPage, 17, 999, 278, WideUpperCase(WideString(PRace.Libelle)){%H-},MinPolice);
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 9);
      PdfEcrit(PdfPage, DebutImgMetier, 999, 268, GetTexteLibelle('RULES-LAB_128') {%H-}+ ' : ' + WideUpperCase(WideString(GetTexteLibelle(PRace.Livre))){%H-}, MinPolice);


      // image Feuille
      Path              := GetCurrentDir+ConstCheminPdfMetierAdvance;
      PdfImgFeuille     := PdfDoc.Images.AddFromFile(Path,false);
      PdfPage.DrawImage(DebutFeuille - 2, 15, LargeurFeuille, 260, PdfImgFeuille);


      // Attributs complémentaires
      // rectangle
      Inc(NbLigne);
      PdfPage.SetColor($E0E0E0,false);
      Coord.X := DebutFeuille + DebutSous - 5;
      Coord.Y := PdfPositionFeuille(DebutTexte,NbLigne)-0.5;
      PdfPage.DrawRect(Coord,LargeurFeuille - DebutSous - MargeDroite,4,0,true,false,0);
      PdfPage.SetColor(ClBlack,false);
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
      PdfEcrit(PdfPage,DebutFeuille + DebutSous - 5, 999, PdfPositionFeuille(DebutTexte,NbLigne) + 0.5, GetTexteLibelle('RULES-LAB_008')+' : ',MinPolice);

      Ind := 0;
      For PAttribut in ListeAttribut do
        Begin
          Inc(Ind);
          if Ind <= 10 then
            begin
              PdfCentre(PdfPage,DebutImgMetier + ((Ind-1)*TailleCellule),DebutImgMetier + (ind*TailleCellule),267-HautAttribut,PAttribut.Resume);
              for PRaceAttribut in ListRaceAttribut do
                if (PRaceAttribut.CodeRace = RaceEnCours) and (PRaceAttribut.CodeAttribut = PAttribut.CodeAttribut) then
                  begin
                    PdfCentre(PdfPage,DebutImgMetier + ((Ind-1)*TailleCellule),DebutImgMetier + (ind*TailleCellule),262-HautAttribut,' '+ExtractStringBefore(PRaceAttribut.CalculRace,'+'));
                    PdfCentre(PdfPage,DebutImgMetier + ((Ind-1)*TailleCellule),DebutImgMetier + (ind*TailleCellule),257-HautAttribut,'+'+ExtractStringAfter(PRaceAttribut.CalculRace,'+'));
                    break;
                  end;
            end
          else
            begin
              for PRaceAttribut in ListRaceAttribut do
                if (PRaceAttribut.CodeRace = RaceEnCours) and (PRaceAttribut.CodeAttribut = PAttribut.CodeAttribut) then
                  begin
                    inc(NbLigne);
                    PdfEcrit(PdfPage,DebutFeuille + DebutSous, 999, PdfPositionFeuille(DebutTexte,NbLigne), '¤ '+PAttribut.Libelle,MinPolice);
                    StringAttribut  := TStringList.Create;
                    ExtractStrings(['+'], [], PChar(PRaceAttribut.CalculRace), StringAttribut);
                    for IndAttribut := 0 to StringAttribut.count - 1 do
                      begin
                        if indAttribut <> 0 then
                          begin
                            inc(NbLigne);
                            PdfEcrit(PdfPage,DebutFeuille + DebutSous + 30, 999, PdfPositionFeuille(DebutTexte,NbLigne), '   + '+ReplaceTexteLibelle(StringAttribut[IndAttribut]),MinPolice);
                          end
                        else
                          PdfEcrit(PdfPage,DebutFeuille + DebutSous + 30, 999, PdfPositionFeuille(DebutTexte,NbLigne), ': '+ReplaceTexteLibelle(StringAttribut[IndAttribut]),MinPolice);
                      end;
                    StringAttribut.Free;
                    break;
                  end;
            end;
        end;

      // Compétences
      // rectangle
      Inc(NbLigne);
      Inc(NbLigne);
      DebutCompetence := NbLigne;
      PdfPage.SetColor($E0E0E0,false);
      Coord.X := DebutFeuille + DebutSous - 5;
      Coord.Y := PdfPositionFeuille(DebutTexte,NbLigne)-0.5;
      PdfPage.DrawRect(Coord,LargeurFeuille - DebutSous - MargeDroite,4,0,true,false,0);
      PdfPage.SetColor(ClBlack,false);
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
      PdfEcrit(PdfPage,DebutFeuille + DebutSous - 5, 999, PdfPositionFeuille(DebutTexte,NbLigne) + 0.5, GetTexteLibelle('RULES-LAB_009')+' : ',MinPolice);

      For PRaceCompetence in ListRaceCompetence do
        if (PRaceCompetence.CodeRace = RaceEnCours) then
          begin
            Inc(NbLigne);
            PCompetence := ChercheCompetence(PRaceCompetence.CodeCompetence);
            PAttribut := ChercheAttribut(PCompetence.CodeAttribut);
            TexteCompetence := Trim(PCompetence.Libelle) + ' ['+GetTexteLibelle(PAttribut.Resume)+']';
            Trouve          := false;
            for IndC := 0 to ListPage.count-1 do
              if ListPage[IndC] = PCompetence.CodeCompetence then
                begin
                  Trouve := true;
                  Break;
                end;

            if not trouve then
              TexteCompetence := TexteCompetence +' *';

            PdfEcrit(PdfPage,DebutFeuille + DebutSous, 999, PdfPositionFeuille(DebutTexte,NbLigne), '¤ '+TexteCompetence, MinPolice);
          end;

      // Talents
      // rectangle
      NbTalent := DebutCompetence;
      PdfPage.SetColor($E0E0E0,false);
      Coord.X := DebutFeuille + DebutTalent - 5;
      Coord.Y := PdfPositionFeuille(DebutTexte,NbTalent)-0.5;
      PdfPage.DrawRect(Coord,LargeurFeuille - DebutTalent - MargeDroite,4,0,true,false,0);
      PdfPage.SetColor(ClBlack,false);
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
      PdfEcrit(PdfPage,DebutFeuille + DebutTalent - 5, 999, PdfPositionFeuille(DebutTexte,NbTalent) + 0.5, GetTexteLibelle('RULES-LAB_007')+' : ',MinPolice);

      For PRaceTalent in ListRaceTalent do
        if (PRaceTalent.CodeRace = RaceEnCours) then
          begin
            StringTalent  := TStringList.Create;
            ExtractStrings([SeparateurMulti], [], PChar(PRaceTalent.CodeTalent), StringTalent);

            DecAuchoix := 0;
            For IndTalent := 0 to StringTalent.count - 1 do
              begin
                if (IndTalent = 0) and (StringTalent.count > 1) then
                  begin
                    Inc(NbTalent);
                    DecAuchoix := 5;
                    PdfEcrit(PdfPage,DebutFeuille + DebutTalent, 999, PdfPositionFeuille(DebutTexte,NbTalent), ConstArbreAuChoix, MinPolice);
                  end;
                Inc(NbTalent);
                PTalent := ChercheTalent(StringTalent[IndTalent]);
                PdfEcrit(PdfPage,DebutFeuille + DebutTalent + DecAuchoix, 999, PdfPositionFeuille(DebutTexte,NbTalent), '¤ '+PTalent.Libelle, MinPolice);
                Inc(Totaltalent);
              end;
          end;

      if NbTalent > NbLigne then
        NbLigne := NbTalent;

      // CArrières
      // rectangle
      Inc(NbLigne);
      Inc(NbLigne);
      PdfPage.SetColor($E0E0E0,false);
      Coord.X := DebutFeuille + DebutSous - 5;
      Coord.Y := PdfPositionFeuille(DebutTexte,NbLigne)-0.5;
      PdfPage.DrawRect(Coord,LargeurFeuille - DebutSous - MargeDroite,4,0,true,false,0);
      PdfPage.SetColor(ClBlack,false);
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
      PdfEcrit(PdfPage,DebutFeuille + DebutSous - 5, 999, PdfPositionFeuille(DebutTexte,NbLigne) + 0.5, GetTexteLibelle('RULES-LAB_006')+' : ',MinPolice);

      DerniereClasse  := '';
      DebutCompetence := NbLigne;
      For PRaceMetier in ListRaceMetier do
        if (PRaceMetier.CodeRace = RaceEnCours) and (PRaceMetier.Chance <> 'X') then
          begin
            if PdfPositionFeuille(DebutTexte,NbLigne + MetierRaceNbSuivant(RaceEnCours,PRaceMetier.CodeMetier) + 2) < 20 then
              Begin
                NbLigne   := DebutCompetence;
                DebutSous := 50;
              end;

            PMetier := ChercheMetier(PRaceMetier.CodeMetier);
            if DerniereClasse <> PMetier.LibelleGroupe then
              begin
                Inc(NbLigne);
                Inc(NbLigne);
                PdfEcrit(PdfPage,DebutFeuille + DebutSous + DecAuchoix, 999, PdfPositionFeuille(DebutTexte,NbLigne), ' '+GetTexteLibelle(PMetier. LibelleGroupe), MinPolice);

                DerniereClasse := PMetier.LibelleGroupe;
              end;

            Inc(NbLigne);
            PdfEcrit(PdfPage,DebutFeuille + DebutSous + DecAuchoix, 999, PdfPositionFeuille(DebutTexte,NbLigne), '   ¤ '+PMetier.Libelle, MinPolice);
            if TailleTexte(PMetier.Libelle+'  ', PdfFontTaille) < 30 then
              PdfPage.DrawLine(DebutFeuille + DebutSous + DecAuchoix + TailleTexte(PMetier.Libelle+'  ', PdfFontTaille),PdfPositionFeuille(DebutTexte,NbLigne),DebutFeuille + DebutSous + DecAuchoix + 30,PdfPositionFeuille(DebutTexte,NbLigne),1);
            PdfEcrit(PdfPage,DebutFeuille + DebutSous + DecAuchoix + 30, 999, PdfPositionFeuille(DebutTexte,NbLigne), ' '+PRaceMetier.Chance, MinPolice);
          end;

      PdfPage.DrawLine(DebutImgMetier,271-HautAttribut,DebutImgMetier + (TailleCellule*10),271-HautAttribut,1);
      PdfPage.DrawLine(DebutImgMetier,266-HautAttribut,DebutImgMetier + (TailleCellule*10),266-HautAttribut,1);
      PdfPage.DrawLine(DebutImgMetier,256-HautAttribut,DebutImgMetier + (TailleCellule*10),256-HautAttribut,1);
      PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 9);
      for Ind := 1 to 9 do
        PdfPage.DrawLine(DebutImgMetier + (Ind*Taillecellule),256-HautAttribut,DebutImgMetier + (Ind*TailleCellule),271-HautAttribut,1);

      // dessin fond info complémentaires
      If TotalTalent > 0 then
        Totaltalent := Totaltalent + 1;
      Path              := GetCurrentDir+ConstCheminPdfMetierAdvance;
      PdfImgFeuille     := PdfDoc.Images.AddFromFile(Path,false);
      PdfPage.DrawImage(DebutImgMetier-2, 15, 90, (TotalTalent + 2) * 4, PdfImgFeuille);

      // information complémentaires
        // Talent
        NbLigne := 0;
        For Ind := ListRaceTalent.count -1 downto 0 do
          begin
            PRaceTalent := ListRaceTalent[Ind];
            if (PRaceTalent.CodeRace = RaceEnCours) then
              begin
                StringTalent  := TStringList.Create;
                ExtractStrings([SeparateurMulti], [], PChar(PRaceTalent.CodeTalent), StringTalent);

                DecAuchoix := 0;
                For IndTalent := 0 to StringTalent.count - 1 do
                  begin
                    inc(NbLigne);
                    PTalent := ChercheTalent(StringTalent[IndTalent]);
                    PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail, 20+(NbLigne-1)*4, '¤'+PTalent.Libelle+' : '+PTalent.Resume,MinPolice)
                  end;
              end;
          end;
        inc(NbLigne);
        PdfPage.SetColor($E0E0E0,false);
        Coord.X := DebutImgMetier + 1;
        Coord.Y := 19+(NbLigne-1)*4;
        PdfPage.DrawRect(Coord, MaxTailleDetail - DebutImgMetier - 15,4,0,true,false,0);
        PdfPage.SetColor(clBlack,false);
        PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail - DebutImgMetier - 2 , 20+(NbLigne-1)*4, GetTexteLibelle('RULES-LAB_007'),MinPolice);

        PdfPage.SetColor(clBlack,false);


    // image race 1
    For Ind := 1 to 2 do
      begin
        Path              := CheminRaceImage(RaceEnCours, IntToStr(Ind));
        if FileExists(Path) then
          begin
            PdfImgRace        := PdfDoc.Images.AddFromFile(Path,false);
            GetImageSize(Path, IWidth, IHeight);
            RedimensionneImage(IWidth, IHeight, 95, 80, CWidth, cHeight);
            PdfPage.DrawImage(30 - ((ind-1) * 35), 150 - ((ind-1)*45), cWidth, cHeight, PdfImgRace);
          end;
      end;

    PDFDoc.SaveToFile(PdfChemin);
    PDFDoc.Free;

    OpenDocument(PdfChemin);

  end;

end.

