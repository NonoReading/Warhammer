unit PdfMetier;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, fpPDF, Dialogs, PicsLib, Graphics, LCLIntf,
  ChargeRaceMetier, ChargeMetierNiveau, ChargeMetier, ChargeConstantes,
  ChargeMetierAttribut, ChargeAttribut, ChargeMetierCompetence,
  ChargeCompetence, ChargeTalent, ChargeMetierTalent, ChargeMetierEquipement,
  ChargeArme, ChargeArmure, PdfPersonnage,
  ChargeTexte, UnitCalcul, PdfUtils;

function PdfPositionFeuille(Base:Integer; NbLigne:Integer; NbDetail:Integer): Real;
Procedure PdfMetierDoc(ListeMetier: String);
Procedure PdfMetierPage(PDFDoc: TPDFDocument; PDFPage: TPDFPage; MetierEnCours: String);

Var
  CheminClass:    String;
  HautFeuille:    Integer = 0;
  TailleCellule:  Integer = 8;
  HautAttribut:   Integer = 5;
  PdfImgFront:    Integer;
  PdfImgFeuille:  Integer;
  PdfImgGauche:   Integer;
  PdfImgDroite:   Integer;
  APdfImgClasse:  Array of array of String;
  NbPdfImgClasse: Integer = 0;
  ColorList:      array of TColor;
  PdfImgNv:       Array of Integer;

implementation

function PdfPositionFeuille(Base:Integer; NbLigne:Integer; NbDetail:Integer): Real;
var
  TailleLigne:  Real = 5.5;
  TailleDetail: Real = 3.5;
begin
  Result := Base - (NbLigne * TailleLigne) - (NbDetail * TailleDetail) + 1 - HautFeuille;
end;

Procedure PdfMetierDoc(ListeMetier: String);
var
  PDFDoc:             TPDFDocument;
  PDFSection:         TPDFSection;
  PDFPage:            TPDFPage;
  PdfChemin:          String;
  PDFOption:          TPDFOptions;
  Strings:            TStringList;
  PMetier:            StructureMetier;
  IndL:               Integer;
begin
  strings          := TStringList.Create;
  ExtractStrings([SeparateurMulti], [], PChar(ListeMetier), strings);
  // Chemin de l'image que vous souhaitez ajouter
  PMetier      := chercheMetier(Strings[0]);
  if strings.Count = 1 then
    PdfChemin    := GetCurrentDir+ConstCheminPersonnage+'\'+TrimRight(PMetier.Libelle)+'.PDF'
  else
    PdfChemin    := GetCurrentDir+ConstCheminPersonnage+'\'+TrimRight(GetTexteLibelle('LAB_006'))+'.PDF';

  if FileExists(PdfChemin) then
    if not DeleteFile(PdfChemin) then
    begin
      ShowMessage(GetTexteLibelle('MESS_038'));
      exit;
    end;
  PDFDoc           := TPDFDocument.Create(nil);
  PDFOption        := [poUseImageTransparency, poCompressImages, poCompressFonts, poCompressText];
  PDFDoc.Options   := PDFOption;
  PDFDoc.StartDocument;
  PdfSection       := PDFDoc.Sections.AddSection;

  PdfImgFront       := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfMetierBack, ConstLangue, ValLangue, [rfReplaceAll]));
  PdfImgGauche      := PdfDoc.Images.AddFromFile(GetCurrentDir+ConstCheminPdfMetierLigneG,false);
  PdfImgDroite      := PdfDoc.Images.AddFromFile(GetCurrentDir+ConstCheminPdfMetierLigneD,false);
  PdfImgFeuille     := PdfDoc.Images.AddFromFile(GetCurrentDir+ConstCheminPdfMetierAdvance,false);
  SetLength(APdfImgClasse,8,2);

  PdfFontBold      := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
  PdfFontValue     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique.ttf', ConstPoliceCarlson);
  PdfFontItalique  := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Italic.ttf', ConstPoliceCarlson+ConstPoliceItalique);

  // couleur et image
  ColorList        := [];
  PdfImgNv         := [];
  SetLength(ColorList, 5);
  For IndL := 1 to ChercheMaxMetierNiveau(PMetier.CodeMetier) do
    begin
      PdfImgNv += [PdfDoc.Images.AddFromFile(GetCurrentDir+ConstCheminImageNiveau+IntToStr(IndL)+'.PNG',false)];
      ColorList[IndL] := ChargeImageArrayColor(IndL);
    end;

  For IndL := 0 to strings.count-1 do
    begin
      PdfPage          := PDFDoc.Pages.AddPage;
      PdfSection.AddPage(PdfPage);
      PdfPage.PaperType:= ptA4;
      PdfPage.UnitOfMeasure := uomMillimeters;
      PdfMetierPage(PDFDoc, PDFPage, strings[IndL]);
    end;

  PDFDoc.SaveToFile(PdfChemin);
  PDFDoc.Free;

  OpenDocument(PdfChemin);

  NbPdfImgClasse := 0;
  for IndL := low(APdfImgClasse) to High(APdfImgClasse) do
    APdfImgClasse[IndL,0] := '';

end;

Procedure PdfMetierPage(PDFDoc: TPDFDocument; PDFPage: TPDFPage; MetierEnCours: String);
var
  PdfImgMetier:       Integer;
  Path:               String;
  IWidth, IHeight:    dword;
  CWidth, cHeight:    dword;
  Ind:                Integer;
  Nv:                 Integer;
  Coord:              TPDFCoord;
  PMetier:            StructureMetier;
  PMetierNiveau:      StructureMetierNiveau;
  PMetierCompetence:  StructureMetierCompetence;
  PCompetence:        StructureCompetence;
  PMetierTalent:      StructureMetierTalent;
  PTalent:            StructureTalent;
  PMetierEquipement:  StructureMetierEquipement;
  PArme:              StructureArme;
  PArmure:            StructureArmure;
  PAttribut:          StructureAttribut;
  PMetierAttribut:    StructureMetierAttribut;
  ListEspece:         String;
  DebutImgMetier:     Integer = 10;
  DebutFeuille:       Integer = 100;
  NbLigne:            Integer;
  DebutTexte:         Integer;
  NbDetail:           Integer;
  IndDetail:          Integer;
  DecDetail:          Real;
  MaxDetail:          Integer;
  TexteTal:           String;
  DebutSous:          Integer = 10;
  DebutDetail:        Integer = 15;
  LargeurFeuille:     Integer = 100;
  MargeDroite:        Integer = 5;
  DebutTalent:        Integer = 45;
  FinAttribut:        Double = 0;
  DernierTalent:      Integer = 0;
  TotalEquip:         Integer = 0;
  TotalTalent:        Integer = 0;
  MaxTailleDetail:    Integer = 110;
  MinPolice:          integer = 7;
  StringEquip:        TStringList;
  StringType:         TStringList;
  LigneEquip:         String;
  LigneType:          String;
  LigneIndice:        Integer;
  Decalage:           String;
  TexteCompetence:    String;
  IndC:               Integer;
  ListPage:           TStringList;
  Trouve:             Boolean;
  i:                  Integer;
  PdfImgClasse:       Integer;
  AddImg:             Boolean = true;
  Qualite:            string;
  Equipement:         String;
begin
  PMetier := chercheMetier(MetierEnCours);

  ListPage       := TStringList.Create;

  PdfPersonnageCompetenceTri(ListPage);

  CheminClass     := GetCurrentDir + ConstCheminImageNiveau + PMetier.LibelleGroupe+'.png';
  for I := low(APdfImgClasse) to High(APdfImgClasse) do
    if APdfImgClasse[i,0] = PMetier.LibelleGroupe+'.png' then
      begin
        PdfImgClasse    := StrToIntDef(APdfImgClasse[I,1],0);
        AddImg          := false;
        break;
      end;

  if (AddImg) then
      begin
        PdfImgClasse  := PdfDoc.Images.AddFromFile(CheminClass,false);

        APdfImgClasse[NbPdfImgClasse,0] := PMetier.LibelleGroupe+'.png';
        APdfImgClasse[NbPdfImgClasse,1] := IntToStr(PdfImgClasse);
        Inc(NbPdfImgClasse);
      end;

  // image fond
  PdfPage.DrawImage(0, 0, 210, 297, PdfImgFront);

  // Haut et bas de page
    // gauche
    Path              := GetCurrentDir+ConstCheminPdfMetierLigneG;
    GetImageSize(Path, IWidth, IHeight);
    RedimensionneImage(IWidth, IHeight, 85, 999, CWidth, cHeight);
    PdfPage.DrawImage(10, 10, cWidth, cHeight, PdfImgGauche);
    PdfPage.DrawImage(10, 287, cWidth, cHeight, PdfImgGauche);

    // droite
    Path              := GetCurrentDir+ConstCheminPdfMetierLigneD;
    GetImageSize(Path, IWidth, IHeight);
    RedimensionneImage(IWidth, IHeight, 85, 999, CWidth, cHeight);
    PdfPage.DrawImage(115, 10, cWidth, cHeight, PdfImgDroite);
    PdfPage.DrawImage(115, 287, cWidth, cHeight, PdfImgDroite);

    // texte
    PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 9);
    PdfCentre(PdfPage, 95, 115, 11, WideUpperCase(WideString(GetTexteLibelle(PMetier.LibelleGroupe))){%H-});
    PdfCentre(PdfPage, 95, 115, 288, WideUpperCase(WideString(GetTexteLibelle(PMetier.LibelleGroupe))){%H-});

  // Image Classe
  Path              := CheminClass;
  GetImageSize(Path, IWidth, IHeight);
  RedimensionneImage(IWidth, IHeight, 10, 10, CWidth, cHeight);
  PdfPage.DrawImage(15, 275, CWidth, CHeight, PdfImgClasse);

  // texte
  PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 24);
  PdfEcrit(PdfPage, 17 + CWidth, 999, 278, WideUpperCase(WideString(PMetier.Libelle)){%H-},MinPolice);
  PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 9);
  ListEspece := MetierRaceCourt(MetierEnCours);
  PdfEcrit(PdfPage, 17 + CWidth, 999, 275, ListEspece,MinPolice);
  PdfEcrit(PdfPage, DebutImgMetier, 999, 268, GetTexteLibelle('LAB_128') {%H-}+ ' : ' + WideUpperCase(WideString(GetTexteLibelle(PMetier.Livre))){%H-}, MinPolice);


  Ind := 0;
  For PAttribut in ListeAttribut do
    Begin
      Inc(Ind);
      if Ind <= 10 then
        begin
          Nv := 0;
          For PMetierAttribut in ListMetierAttribut do
            if (PMetierAttribut.CodeMetier = MetierEnCours) and (PMetierAttribut.CodeAttribut = PAttribut.CodeAttribut) then
              begin
                Nv := PMetierAttribut.NiveauMetier;
                break;
              end;
          if Nv > 0 then
            begin
              Path := GetCurrentDir+ConstCheminImageNiveau+IntToStr(Nv)+'.PNG';
              GetImageSize(Path, IWidth, IHeight);
              RedimensionneImage(IWidth, IHeight, TailleCellule, 4, CWidth, cHeight);
              PdfPage.SetColor(ColorToARGB(ColorList[Nv],0),false);
              Coord.X := DebutImgMetier + ((Ind - 1.0) * TailleCellule);
              Coord.Y := 261.15 - HautAttribut - ((Nv-1)*4.7);
              PdfPage.DrawRect(Coord,TailleCellule,4.7,0,true,false,0);
              PdfPage.DrawImage(DebutImgMetier + ((Ind-0.75)*TailleCellule),Coord.Y, CWidth, cHeight, PdfImgNv[NV-1]);
              Coord.Y := 261.15 - HautAttribut + 4.7;
              PdfPage.DrawRect(Coord,TailleCellule,4.7,0,true,false,0);
              PdfPage.SetColor(clblack,false);
            end;
          PdfCentre(PdfPage,DebutImgMetier + ((Ind-1)*TailleCellule),DebutImgMetier + (ind*TailleCellule),267-HautAttribut,PAttribut.Resume);
        end;
        FinAttribut := 261.15-HautAttribut  - ((3)*4.7);
    end;

  For Ind := 0 to 5 do
    PdfPage.DrawLine(DebutImgMetier,270.7 - HautAttribut - (Ind * 4.75),DebutImgMetier + (TailleCellule*10),270.7 - HautAttribut - (Ind * 4.75),1);

  PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 9);
  for Ind := 1 to 9 do
    PdfPage.DrawLine(DebutImgMetier + (Ind*Taillecellule),246.95-HautAttribut,DebutImgMetier + (Ind*TailleCellule),270.7-HautAttribut,1);

  // image Feuille
  Path              := GetCurrentDir+ConstCheminPdfMetierAdvance;
  PdfPage.DrawImage(DebutFeuille - 2, 15, LargeurFeuille, 260, PdfImgFeuille);

  // Niveau
  NbLigne := 0;
  NbDetail:= 0;
  DebutTexte := 265;
  for Nv := 1 to ChercheMaxMetierNiveau(PMetier.CodeMetier) do
    begin
      Inc(NBDetail);
      Path := GetCurrentDir+ConstCheminImageNiveau+IntToStr(Nv)+'.PNG';
      GetImageSize(Path, IWidth, IHeight);
      RedimensionneImage(IWidth, IHeight, 5, 5, CWidth, cHeight);
      PdfPage.DrawImage(DebutFeuille + 5 ,PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) - 1, CWidth, cHeight, PdfImgNv[Nv-1]);
      for PMetierNiveau in ListMetierNiveau do
        if (PMetierNiveau.CodeMetier = Metierencours) and (PMetierNiveau.NiveauMetier = Nv) then
          begin
            // rectangle
            PdfPage.SetColor(ColorToARGB(ColorList[Nv],0),false);
            Coord.X := DebutFeuille + 11;
            Coord.Y := PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) - 1;
            PdfPage.DrawRect(Coord,LargeurFeuille - MargeDroite -11 ,5,0,true,false,0);

            // libellé niveau et salaire
            PdfPage.SetColor(clBlack,false);
            PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfEcrit(PdfPage,DebutFeuille + 12, 999, PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) + 0.5, PMetierNiveau.Libelle,MinPolice);
            PdfEcrit(PdfPage,DebutFeuille + 75, 999, PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) + 0.5, GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' '),MinPolice);


            // COMPETENCE
            // rectangle
            Inc(NbLigne);
            PdfPage.SetColor($E0E0E0,false);
            Coord.X := DebutFeuille + DebutSous;
            Coord.Y := PdfPositionFeuille(DebutTexte,NbLigne,NbDetail)-0.5;
            PdfPage.DrawRect(Coord,LargeurFeuille - DebutSous - MargeDroite,4,0,true,false,0);
            PdfPage.SetColor(ClBlack,false);
            PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfEcrit(PdfPage,DebutFeuille + DebutSous, 999, PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) + 0.5, GetTexteLibelle('LAB_009')+' : ',MinPolice);

            // détail compétences
            IndDetail := 0;
            DecDetail := 0;

            For PMetierCompetence in ListMetierCompetence do
              if (PMetierCompetence.CodeMetier = MetierEnCours) and (PMetierCompetence.NiveauMetier = Nv) then
                begin
                  Inc(IndDetail);
                  PCompetence := ChercheCompetence(PMetierCompetence.CodeCompetence);
                  if PMetierCompetence.CodeCompetence = PMetier.CodeCompetence then
                    PdfTaillePolice(PdfPage, PdfFontItalique, ConstPoliceCarlson, 9)
                  else
                    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceCarlson+ConstPoliceItalique, 9);
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

                  PdfEcrit(PdfPage,DebutFeuille + DecDetail + DebutDetail, 999, PdfPositionFeuille(DebutTexte,NbLigne,IndDetail+NbDetail), '¤ '+TexteCompetence,MinPolice);
                  Maxdetail := IndDetail;
                end;


            // TALENT
            PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfEcrit(PdfPage,DebutFeuille + DebutSous + DebutTalent, 999, PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) + 0.5, GetTexteLibelle('LAB_007')+' : ',MinPolice);

            // détail talents
            IndDetail := 0;
            DecDetail := 0;

            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceCarlson, 9);
            For PMetierTalent in ListMetierTalent do
              if (PMetierTalent.CodeMetier = MetierEnCours) and (PMetierTalent.NiveauMetier = Nv) then
                begin
                  Inc(IndDetail);
                  Inc(TotalTalent);
                  PTalent := ChercheTalent(PMetierTalent.CodeTalent);
                  TexteTal := PTalent.Libelle;
                  PdfEcrit(PdfPage,DebutFeuille + DecDetail + DebutDetail + DebutTalent, DebutFeuille + DecDetail+ DebutTalent + LargeurFeuille - MargeDroite, PdfPositionFeuille(DebutTexte,NbLigne,IndDetail+NbDetail), '¤ '+TexteTal,MinPolice);
                end;
            if IndDetail > MaxDetail then
              MaxDetail := IndDetail;
            NbDetail := NbDetail + MaxDetail;

            // Equipement
            Inc(NbLigne);
            PdfPage.SetColor($E0E0E0,false);
            Coord.X := DebutFeuille + DebutSous;
            Coord.Y := PdfPositionFeuille(DebutTexte,NbLigne,NbDetail)-0.5;
            PdfPage.DrawRect(Coord,LargeurFeuille - DebutSous - MargeDroite,4,0,true,false,0);
            PdfPage.SetColor(ClBlack,false);
            PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfEcrit(PdfPage,DebutFeuille + DebutSous, 999, PdfPositionFeuille(DebutTexte,NbLigne,NbDetail) + 0.5, GetTexteLibelle('LAB_013')+' : ',MinPolice);

            // détail Equipements
            IndDetail   := 0;
            DecDetail   := 0;
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceCarlson, 9);

            For PMetierEquipement in ListMetierEquipement do
              if (PMetierEquipement.CodeMetier = MetierEnCours) and (PMetierEquipement.NiveauMetier = Nv) then
                begin
                  StringEquip := TStringList.Create;
                  StringType  := TStringList.Create;

                  ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.Equipement), StringEquip);
                  ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.TypeEquipement), StringType);

                  if StringEquip.Count > 1 then
                    begin
                      Inc(IndDetail);
                      PdfEcrit(PdfPage,DebutFeuille + DecDetail + DebutDetail, DebutFeuille + DecDetail + 110, PdfPositionFeuille(DebutTexte,NbLigne,IndDetail+NbDetail), '¤ '+ConstArbreAuChoix,MinPolice);
                      Decalage := '     -';
                    end
                  else
                    Decalage := '¤';

                  LigneIndice := 0;
                  For LigneEquip in StringEquip do
                    begin
                      Qualite    := '';
                      Equipement := LigneEquip;
                      if (Pos(EquipementQualite, Equipement) > 0) then
                        begin
                          Qualite    := ' '+EquipementQualite;
                          Equipement := Trim(ExtractStringBefore(LigneEquip,EquipementQualite));
                        end;
                      LigneType := StringType[LigneIndice];
                      Inc(LigneIndice);
                      if InList(LigneType,TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                          begin
                            Inc(IndDetail);
                            PArme   := ChercheArme(Equipement);
                            if pos(ValeurGenerique, PArme.CodeArme) = 0 then
                              Inc(TotalEquip);
                            PdfEcrit(PdfPage,DebutFeuille + DecDetail + DebutDetail, 999, PdfPositionFeuille(DebutTexte,NbLigne,IndDetail+NbDetail), Decalage+' '+PArme.Libelle+Qualite,MinPolice);
                          end
                        else if LigneType = TypeEquipAR then
                          begin
                            Inc(IndDetail);
                            Inc(TotalEquip);
                            PArmure := ChercheArmure(Equipement);
                            PdfEcrit(PdfPage,DebutFeuille + DecDetail + DebutDetail, DebutFeuille + DecDetail + 110, PdfPositionFeuille(DebutTexte,NbLigne,IndDetail+NbDetail), Decalage+' '+PArmure.Libelle+Qualite,MinPolice);
                          end
                        else if LigneType = TypeEquipDI then
                          begin
                            Inc(IndDetail);
                            PdfEcrit(PdfPage,DebutFeuille + DecDetail + DebutDetail, DebutFeuille + DecDetail + 110, PdfPositionFeuille(DebutTexte,NbLigne,IndDetail+NbDetail), Decalage+' '+Equipement+Qualite,MinPolice);
                          end;
                      end;
                    StringEquip.free;
                    StringType.Free;
                  end;

            NbDetail := NbDetail + IndDetail;
            Inc(NbLigne);

          end;
    end;

  // dessin fond info complémentaires
  If TotalTalent > 0 then
    Totaltalent := Totaltalent + 1;
  If TotalEquip > 0 then
    TotalEquip := TotalEquip + 1;
  Path              := GetCurrentDir+ConstCheminPdfMetierAdvance;
  PdfPage.DrawImage(DebutImgMetier-2, 15, 90, (TotalEquip + TotalTalent + 2) * 4, PdfImgFeuille);

  // information complémentaires
    // Talent
    NbDetail := 0;
    For Ind := ListMetierTalent.count -1 downto 0 do
      begin
        PMetierTalent := ListMetierTalent[Ind];
        if (PMetierTalent.CodeMetier = MetierEnCours) then
          begin
            inc(Nbdetail);
            PTalent := ChercheTalent(PMetierTalent.CodeTalent);
            TexteTal := PTalent.Libelle;
            PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail, 20+(NbDetail-1)*4, '¤'+PTalent.Libelle+' : '+PTalent.Resume,MinPolice)
          end;
      end;
    inc(NbDetail);
    PdfPage.SetColor($E0E0E0,false);
    Coord.X := DebutImgMetier + 1;
    Coord.Y := 19+(NbDetail-1)*4;
    PdfPage.DrawRect(Coord, MaxTailleDetail - DebutImgMetier - 15,4,0,true,false,0);

    PdfPage.SetColor(clBlack,false);
    PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail, 20+(NbDetail-1)*4, GetTexteLibelle('LAB_007'),MinPolice);
    inc(NbDetail);
    DernierTalent := NbDetail;
    For Ind := ListMetierEquipement.count -1 downto 0 do
      begin
        PMetierEquipement := ListMetierEquipement[Ind];
        if (PMetierEquipement.CodeMetier = MetierEnCours) then
          begin
            StringEquip := TStringList.Create;
            StringType  := TStringList.Create;

            ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.Equipement), StringEquip);
            ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.TypeEquipement), StringType);

            LigneIndice := 0;
            For LigneEquip in StringEquip do
              begin
                Equipement := Trim(ExtractStringBefore(LigneEquip,EquipementQualite));
                LigneType  := StringType[LigneIndice];
                Inc(LigneIndice);

                if InList(LigneType,TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                    begin
                      PArme   := ChercheArme(Equipement);
                      if Pos(ValeurGenerique,PArme.CodeArme) = 0 then
                        begin
                          Inc(NbDetail);
                          PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail, 20+(NbDetail-1)*4, '¤'+TexteLigneArme(PArme),MinPolice);
                        end;
                    end
                  else if LigneType = TypeEquipAR then
                    begin
                      PArmure := ChercheArmure(Equipement);
                      Inc(NbDetail);
                      PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail, 20+(NbDetail-1)*4, '¤'+TexteLigneArmure(PArmure),MinPolice);
                    end;
              end;
          end;
      end;
  if DernierTalent <> NbDetail then
    begin
      inc(NbDetail);
      PdfPage.SetColor($E0E0E0,false);
      Coord.X := DebutImgMetier + 1;
      Coord.Y := 19+(NbDetail-1)*4;
      PdfPage.DrawRect(Coord, MaxTailleDetail - DebutImgMetier - 15,4,0,true,false,0);

      PdfPage.SetColor(clBlack,false);
      PdfEcrit(PdfPage,DebutImgMetier+2, MaxTailleDetail - DebutImgMetier - 2 , 20+(NbDetail-1)*4, GetTexteLibelle('LAB_013'),MinPolice);
    end;

  // image métier
  Path              := CheminMetierImage(MetierEnCours);
  PdfImgMetier      := PdfDoc.Images.AddFromFile(Path,false);
  GetImageSize(Path, IWidth, IHeight);
  RedimensionneImage(IWidth, IHeight, 95, Trunc(finAttribut) - 30 -(NbDetail*4), CWidth, cHeight);
  PdfPage.DrawImage(DebutImgMetier-2, FinAttribut - cHeight - 5, cWidth, cHeight, PdfImgMetier);

end;

end.

