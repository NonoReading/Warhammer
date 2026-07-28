unit PdfPersonnage;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, fpPDF, PdfUtils, ChargeRace, ChargeMetier, ChargeMetierNiveau,
  ChargeRaceAttribut, ChargeTalent, ChargeCompetence, ChargeArme, ChargeArmure,
  ChargeArmeBonus, ChargeArmureBonus, ChargeSort, ChargeAttribut, ChargeFabrication,
  ChargeConstantes, ChargeMetierAttribut, ChargeTexte, ChargeMetierTalent,
  ChargePersonnage, ChargeArmureSimplifie, ChargeAttributAugmentation,
  ChargeCompetenceAugmentation,
  Dialogs, UnitCalcul, Math, LCLIntf;

Type
  StructureDonnee  = record
    Base:	   Integer;
    Augmentation:  Integer;
    Total:	   Integer;
end;


Procedure PdfPersonnageCompetenceTri(ListPage: TStringList);
Function PdfPersonnageAttribut(Personnage: StructurePersonnage; Attribut: String; var Bonus: String): StructureDonnee;
Procedure PdfPersonnageCreation(Personnage: StructurePersonnage; BackGround: Boolean; DessineTexteLigne: Boolean = True);
Procedure PdfPersonnageCreationFeldo2P(Personnage: StructurePersonnage);
Function PdfPersonnageCompetence(Personnage: StructurePersonnage; Competence: String; var NivMetier: Integer): StructureDonnee;
Function PdfPersonnageTalent(Personnage: StructurePersonnage; Talent: String; Var NivMetier: Integer): StructureDonnee;
Function PdfPersonnageRemplaceBonus(Personnage: StructurePersonnage; ChW: String): String;
Function PdfPersonnageCompetenceBonus(Personnage: StructurePersonnage; CodeCompetence: String): String;
Function PdfPersonnageTalentBonus(Personnage: StructurePersonnage; CodeTalent: String): String;

implementation

Procedure PdfPersonnageCompetenceTri(ListPage: TStringList);
  var
    ListComp:    TStringList;
    ListTri:     TStringList;
    IndC:        Integer;
    Comp:        String;
    PCompetence: StructureCompetence;
  Begin
    ListComp   := TStringList.Create;
    ListTri    := TStringList.Create;

    ListComp.Add('COMPART_*');
    ListComp.Add('COMPATHL');
    ListComp.Add('COMPSUBOR');
    ListComp.Add('COMPCHARM');
    ListComp.Add('COMPANIM');
    ListComp.Add('COMPESCAL');
    ListComp.Add('COMPCALM');
    ListComp.Add('COMPRESALC');
    ListComp.Add('COMPESQU');
    ListComp.Add('COMPCOND');
    ListComp.Add('COMPRESIST');
    ListComp.Add('COMPDIVERT_*');
    ListComp.Add('COMPPARI');
    ListComp.Add('COMPRAGOT');
    ListComp.Add('COMPMARCH');
    ListComp.Add('COMPINTIM');
    ListComp.Add('COMPINTUI');
    ListComp.Add('COMPCOMM');
    ListComp.Add('COMPCOMB_BASE');
    ListComp.Add('COMPCOMB_*');
    ListComp.Add('COMPORIENT');
    ListComp.Add('COMPSURVEXT');
    ListComp.Add('COMPPRECEP');
    ListComp.Add('COMPCHEV_*');
    ListComp.Add('COMPRAMER');
    ListComp.Add('COMPDISC_*');

    // chercher les libellés
    for IndC := 0 to ListComp.count-1 do
      begin
        Comp        := ListComp[IndC];
        PCompetence := ChercheCompetence(Comp);
        ListTri.Add(PCompetence.Libelle+Separateurtabulation+PCompetence.CodeCompetence);
      end;
    ListTri.Sort;
    ListComp.Destroy;

    // ajouter dans la liste finale
    for IndC := 0 to ListTri.count-1 do
      begin
        Comp        := ExtractStringAfter(ListTri[IndC],Separateurtabulation);
        ListPage.Add(Comp);
      end;
    ListTri.Destroy;
end;

Function PdfPersonnageRemplaceBonus(Personnage: StructurePersonnage; ChW: String): String;
  Var
    Res: String;
    Donnee: StructureDonnee;
    Bonus: String;
  Begin
    Res    := ChW;
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracCC, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracCC+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracCC+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracCT, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracCT+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracCT+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracF, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracF+')',        InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracF+')',   InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracE, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracE+')',        InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracE+')',   InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracI, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracI+')',        InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracI+')',   InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracAg, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracAg+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracAg+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracDex, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracDex+')',      InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracDex+')', InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracInt, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracInt+')',      InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracInt+')', InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracFM, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracFM+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracFM+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracSoc, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracSoc+')',      InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracSoc+')', InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Result := Res;
  end;


Function PdfPersonnageTalent(Personnage: StructurePersonnage; Talent: String; Var NivMetier: Integer): StructureDonnee;
  var
    PersonnageTalent: StructurePersonnageTalent;
    PMetierTalent:    StructureMetierTalent;
    Res:              StructureDonnee;
  begin
    Res.Base         := 0;
    Res.Augmentation := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      if CompareRechercheValeur(Talent, PersonnageTalent.CodeTalent) then
        Res.Augmentation := Res.Augmentation + PersonnageTalent.Valeur;
    For PersonnageTalent in Personnage.AugmentationTalent do
      if CompareRechercheValeur(Talent, PersonnageTalent.CodeTalent) then
        Res.Augmentation := Res.Augmentation + PersonnageTalent.Valeur;
    For PMetierTalent in ListMetierTalent do
      if CompareRechercheValeur(PMetierTalent.CodeMetier, Personnage.MetierEnCours.CodeMetier) then
        if CompareRechercheValeur(PMetierTalent.CodeTalent, Talent) then
          begin
            NivMetier := PMetierTalent.NiveauMetier;
            break;
          end
       else if Pos(ValeurGenerique, PMetierTalent.CodeTalent) > 0 then
         if Copy(PMetierTalent.CodeTalent,1,Pos(ValeurGenerique, PMetierTalent.CodeTalent)-1) = Copy(Talent,1,Pos(ValeurSousCompetence, Talent)-1) then
           begin
             NivMetier := PMetierTalent.NiveauMetier;
             break;
           end;
    Res.Total := Res.Base + Res.Augmentation;
    Result := res;
  end;


Function PdfPersonnageCompetence(Personnage: StructurePersonnage; Competence: String; Var NivMetier: Integer): StructureDonnee;
  var
    PersonnageCompetence: StructurePersonnageCompetence;
    PCompetence:          StructureCompetence;
    Res:                  StructureDonnee;
    DonneeAttribut:       StructureDonnee;
    CodeCompetence:       String;
    Bonus:                String;
  begin
    Res.Base         := 0;
    Res.Augmentation := 0;
    NivMetier        := 0;
    PCompetence      := ChercheCompetence(Competence);
    if PCompetence.SousCompetence then
      begin
        CodeCompetence := ExtractStringBefore(PCompetence.CodeCompetence, ValeurSousCompetence) + ValeurGenerique;
        PCompetence    := ChercheCompetence(CodeCompetence);
      end;
    DonneeAttribut := PdfPersonnageAttribut(Personnage, PCompetence.CodeAttribut, Bonus);
    Res.Base       := DonneeAttribut.Total;
    for PersonnageCompetence in Personnage.CreationCompetence35 do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          Res.Augmentation := Res.Augmentation + PersonnageCompetence.Valeur;
          break;
        end;
    for PersonnageCompetence in Personnage.CreationCompetence40 do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          Res.Augmentation := Res.Augmentation + PersonnageCompetence.Valeur;
          break;
        end;
    For PersonnageCompetence in Personnage.AugmentationCompetence do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          Res.Augmentation := Res.Augmentation + PersonnageCompetence.Valeur;
          break;
        end;
    For PersonnageCompetence in Personnage.MetierCompetence do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          NivMetier := PersonnageCompetence.Valeur;
          break;
        end;
    Res.Total := Res.Base + Res.Augmentation;
    Result := res;
  end;


Function PdfPersonnageAttribut(Personnage: StructurePersonnage; Attribut: String; var Bonus: String): StructureDonnee;
  var
    PersonnageAttribut: StructurePersonnageAttribut;
    PersonnageTalent:   StructurePersonnageTalent;
    PTalent:            StructureTalent;
    Res:                StructureDonnee;
    strings:            TStringList;
    Ind:                Integer;
    Neg:                String;
    Attr:               String;
    PRaceAttribut:      StructureRaceAttribut;
  begin
    Res.Base         := 0;
    Res.Augmentation := 0;

    PRaceAttribut := ChercheRaceAttribut(Personnage.Race, Attribut);
    Res.Base      := StrToIntDef(ExtractStringAfter(PRaceAttribut.CalculRace,'+'),0);

    Bonus := '';
    for PersonnageAttribut in Personnage.CreationAttribut do
      if CompareRechercheValeur(PersonnageAttribut.CodeAttribut, Attribut) then
        begin
          Res.Base := Res.Base + PersonnageAttribut.Valeur;
          if PersonnageAttribut.Bonus <> '' then
            Bonus := PersonnageAttribut.Bonus;
          break;
        end;

    For PersonnageTalent in Personnage.CreationTalent do
      Begin
        PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
        if PTalent.Attribut <> '' then
          begin
           strings            := TStringList.Create;
           ExtractStrings([';'], [], PChar(PTalent.Attribut), Strings);
           for Ind := 0 to (Strings.count-1) Do
             begin
               if leftStr(Strings[ind],1) = '-' then
                 Neg := '-'
               else
                 Neg := '';
               Attr  := RightStr(Strings[ind],Length(Strings[ind]) - Length(Neg));
               if Attr = Attribut then
                 Res.Base := Res.Base + StrToIntDef(Neg+'5',0);
             end;
           strings.free;
          end;
      end;

    For PersonnageTalent in Personnage.AugmentationTalent do
      Begin
        PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
        if PTalent.Attribut <> '' then
          begin
           strings            := TStringList.Create;
           ExtractStrings([';'], [], PChar(PTalent.Attribut), Strings);
           for Ind := 0 to (Strings.count-1) Do
             begin
               if leftStr(Strings[ind],1) = '-' then
                 Neg := '-'
               else
                 Neg := '';
               Attr  := RightStr(Strings[ind],Length(Strings[ind]) - Length(Neg));
               if Attr = Attribut then
                 Res.Base := Res.Base + StrToIntDef(Neg+'5',0);
             end;
           strings.free;
          end;
      end;

    For PersonnageAttribut in Personnage.AugmentationAttribut do
      if CompareRechercheValeur(Attribut, PersonnageAttribut.CodeAttribut) then
        Res.Augmentation := Res.Augmentation + PersonnageAttribut.Valeur;

    Res.Total := Res.Base + Res.Augmentation;
    Result := res;
  end;

Procedure PdfPersonnageCreation(Personnage: StructurePersonnage; BackGround: Boolean; DessineTexteLigne: Boolean = True);
  var
    PDFDoc:               TPDFDocument;
    PdfSection:           TPDFSection;
    PdfPage:              TPDFPage;
    PDFOption:            TPDFOptions;
    PdfFront:             Integer;
    PdfBack:              Integer;
    PdfShadow:            Integer;
    PdfChemin:            String;
    PRace:                StructureRace;
    PMetier:         StructureMetier;
    PMetierNiveau:   StructureMetierNiveau;
    PRaceAttribut:   StructureRaceAttribut;
    PTalent:         StructureTalent;
    Mouv:            Integer = 0;
    ListPage:        TStringList;
    Comp:            String;
    PCompetence:     StructureCompetence;
    ValStat:         String;
    ValBonus:        String;
    ValTotal:        String;
    DebPage:         Integer;
    NbLigne:         Integer;
    IndC:            Integer;
    ListPris:        String;
    LibComp:         String;
    BF, BE, BFM:     Integer;
    Ch:              String;
    DurACuire:       Integer = 0;
    BonusEncomb:     Integer = 0;
    Enc:             Integer;
    EncP:            Integer;
    PArme:           StructureArme;
    PArmure:         StructureArmure;
    Deg:             Integer;
    Pourcent:        String;
    EncArme:         Integer;
    EncArmure:       Integer;
    ArmureTete:      Integer;
    ArmureBras:      Integer;
    ArmureCorps:     Integer;
    ArmureJambe:     Integer;
    ArmureBouclier:  Integer = 0;
    PosProtection:   SizeInt;
    NbLoca:          Integer;
    IndLoca:         Integer;
    LocData:         String;
    NbArme:          Integer;
    NbArmure:        Integer;
    ArmeBonii:       String = '';
    ArmureBonii:     String = '';
    FabricationBonii:String = '';
    PArmureBonus:    StructureArmureBonus;
    PArmeBonus:      StructureArmeBonus;
    NbBonus:         Integer;
    TxtBonus:        String;
    IndDivers:       Integer = 0;
    PasBonus:        Boolean;
    ListMalii:       String;
    NBSort:          Integer;
    PSort:           StructureSort;
    LigneBonus:      String;
    Ind:             Integer;
    PAttribut:       StructureAttribut;
    PFabrication:    StructureFabrication;
    Quality:         String;
    Portee:          String;
    TexteRange1:     String;
    TexteRange2:     String;
    PorteMoyenne:    Integer;
    Chance:          Integer;
    Determine:       Integer;
    TBonusCC:        Integer=0;
    TBonusCT:        Integer=0;
    Val:             Integer;
    Asterisc:        String='';
    BonusSprint:     Integer=0;
    MinPolice:       Integer=5;
    DernierMetier:   String='';
    PersonnageAttribut:   StructurePersonnageAttribut;
    AttributDonnee:       StructureDonnee;
    CompetenceDonnee:     StructureDonnee;
    PersonnageTalent:     StructurePersonnagetalent;
    TalentDonnee:         StructureDonnee;
    PersonnageEquipement: StructurePersonnageEquipement;
    PersonnageMetier:     StructurePersonnageMetier;
    PArmureSimplifiee:    StructureArmureSimplifiee;
    Bidon:                Integer = 0;
    ArmureSet:            Boolean = false;
    AmePure:              Integer = 0;
    Bonus:                String;

  begin
    PdfChemin        := GetCurrentDir+ConstCheminPersonnage+Personnage.NomPersonnage+'\'+Personnage.NomPersonnage+'.PDF';

    if (Pos(AjouteAccolade(ConstXmlOptionQuickArmor),Personnage.Options) > 0) then
      ArmureSet := True;

    if FileExists(PdfChemin) then
      if not DeleteFile(PdfChemin) then
        begin
          ShowMessage(GetTexteLibelle('MESS_038'));
          exit;
        end;

    PDFDoc          := TPDFDocument.Create(nil);
    PDFOption       := [poUseImageTransparency, poCompressImages, poCompressFonts, poCompressText ];
    PDFDoc.Options  := PDFOption;
    PDFDoc.StartDocument;
    PdfSection      := PDFDoc.Sections.AddSection;

  // PAGE 1
    PdfPage         := PDFDoc.Pages.AddPage;
    PdfFontBack     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue    := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'ariali.ttf', ConstPoliceArial);
    PdfFontBold     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'arialbd.ttf', ConstPoliceArial+ConstPoliceGras);

    PdfSection.AddPage(PdfPage);
    PdfPage.PaperType:= ptA4;
    PdfPage.UnitOfMeasure := uomMillimeters;

    // Paramétrages : liste des compétences de la page 1
    ListPage       := TStringList.Create;

    PdfPersonnageCompetenceTri(ListPage);
    // charger l'image de fond
    if BackGround = true then
      begin
        PdfFront         := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfFront, ConstLangue, ValLangue, [rfReplaceAll]),false);
        PdfPage.DrawImage(0, 0, 210, 297, PdfFront);
      end;

    // gérer les lignes
    if DessineTexteLigne then
      begin
        // Écrire du texte sur la page PDF
        PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

        // Haut
          // H
        PdfPage.DrawLine(17,235,194,235,1);
        PdfPage.DrawLine(17,240,194,240,1);
        PdfPage.DrawLine(17,245,194,245,1);
        PdfPage.DrawLine(105,250,105,240,1);
        PdfPage.DrawLine(105,235,105,230,1);
          // V
        PdfPage.DrawLine(149.5,250,149.5,245,1);
        PdfPage.DrawLine(149.5,240,149.5,230,1);
        PdfPage.DrawLine(61.5,235,61.5,230,1);
          // T
        PdfPage.WriteText( 18, 246, GetTexteLibelle('PDF_MAIN1_NAME'));
        PdfPage.WriteText(106.5, 246, GetTexteLibelle('PDF_MAIN1_SPECIES'));
        PdfPage.WriteText(151.5, 246, GetTexteLibelle('PDF_MAIN1_CLASS'));

        PdfPage.WriteText( 18, 241, GetTexteLibelle('PDF_MAIN2_CAREER'));
        PdfPage.WriteText(106.5, 241, GetTexteLibelle('PDF_MAIN2_CAREERLEVEL'));

        PdfPage.WriteText( 18, 236, GetTexteLibelle('PDF_MAIN3_CAREERPATH'));
        PdfPage.WriteText(151.5, 236, GetTexteLibelle('PDF_MAIN3_STATUS'));

        PdfPage.WriteText( 18, 231, GetTexteLibelle('PDF_MAIN4_AGE'));
        PdfPage.WriteText(63, 231, GetTexteLibelle('PDF_MAIN4_HEIGHT'));
        PdfPage.WriteText(106.5, 231, GetTexteLibelle('PDF_MAIN4_HAIR'));
        PdfPage.WriteText(151.5, 231, GetTexteLibelle('PDF_MAIN4_EYES'));

        // caractéristiques
          // H
        PdfPage.DrawLine(17,219,96,219,1);
        PdfPage.DrawLine(17,214,96,214,1);
        PdfPage.DrawLine(17,207,96,207,1);
        PdfPage.DrawLine(17,200,96,200,1);
          // V
        For ind := 0 to 9 do
          PdfPage.DrawLine(31.5+(ind * 6.5),219,31.5+(ind * 6.5),193,1);
           // T
        PdfCentre(PdfPage,17,96,221,GetTexteLibelle('PDF_CHARAC1_CHARAC'));
        PdfCentre(PdfPage,31,38,215,GetTexteLibelle('SHORTATTR_WS'));

        PdfCentre(PdfPage,38,45,215, GetTexteLibelle('SHORTATTR_BS'));
        PdfCentre(PdfPage,45,51,215, GetTexteLibelle('SHORTATTR_S'));
        PdfCentre(PdfPage,51,58,215, GetTexteLibelle('SHORTATTR_T'));
        PdfCentre(PdfPage,58,64,215, GetTexteLibelle('SHORTATTR_I'));
        PdfCentre(PdfPage,64,71,215, GetTexteLibelle('SHORTATTR_Ag'));
        PdfCentre(PdfPage,71,77,215, GetTexteLibelle('SHORTATTR_Dex'));
        PdfCentre(PdfPage,78,85,215, GetTexteLibelle('SHORTATTR_Int'));
        PdfCentre(PdfPage,84,90,215, GetTexteLibelle('SHORTATTR_WP'));
        PdfCentre(PdfPage,91,97,215, GetTexteLibelle('SHORTATTR_Fel'));
        PdfPage.WriteText( 18, 209, GetTexteLibelle('PDF_CHARAC3_INITIAL'));
        PdfPage.WriteText( 18, 202, GetTexteLibelle('PDF_CHARAC3_ADVANCES'));
        PdfPage.WriteText( 18, 195, GetTexteLibelle('PDF_CHARAC3_CURRENT'));
        // Destin
          // H
        PdfPage.DrawLine(101,219,118,219,1);
        PdfPage.DrawLine(101,214,118,214,1);
          // V
        PdfPage.DrawLine(111,209,111,219,1);
          // T
        PdfCentre(PdfPage,101,118,221,GetTexteLibelle('PDF_FATE1_FATE'));
        PdfPage.WriteText(101,215,GetTexteLibelle('PDF_FATE2_FATE'));
        PdfPage.WriteText(101,210,GetTexteLibelle('PDF_FATE3_FORTUNE'));
        // Résilience
          // H
        PdfPage.DrawLine(123,219,162,219,1);
        PdfPage.DrawLine(123,214,162,214,1);
          // V
        PdfPage.DrawLine(137,209,137,219,1);
        PdfPage.DrawLine(148,209,148,219,1);
          // T
        PdfCentre(PdfPage,123,163,221,GetTexteLibelle('PDF_RESIL1_RESILIENCE'));
        PdfCentre(PdfPage,123,137,215,GetTexteLibelle('PDF_RESIL2A_RESILIENCE'));
        PdfCentre(PdfPage,137,148,215,GetTexteLibelle('PDF_RESIL2B_RESOLVE'));
        PdfCentre(PdfPage,148,162,215,GetTexteLibelle('PDF_RESIL2C_MOTIVATION'));
        // Expérience
          // H
        PdfPage.DrawLine(165,219,194,219,1);
        PdfPage.DrawLine(165,214,194,214,1);
          // V
        PdfPage.DrawLine(176,209,176,219,1);
        PdfPage.DrawLine(185,209,185,219,1);
          // T
        PdfCentre(PdfPage,165,194,221,GetTexteLibelle('PDF_XP1_EXPERIENCE'));
        PdfCentre(PdfPage,165,176,215,GetTexteLibelle('PDF_XP2A_CURRENT'));
        PdfCentre(PdfPage,176,185,215,GetTexteLibelle('PDF_XP2B_SPENT'));
        PdfCentre(PdfPage,185,194,215,GetTexteLibelle('PDF_XP2C_TOTAL'));
        // Mouvement
          // H
        PdfPage.DrawLine(101,198,194,198,1);
          // V
        PdfPage.DrawLine(121.5,198,121.5,193,1);
        PdfPage.DrawLine(132.5,198,132.5,193,1);
        PdfPage.DrawLine(149.5,198,149.5,193,1);
        PdfPage.DrawLine(164.5,198,164.5,193,1);
        PdfPage.DrawLine(181.5,198,181.5,193,1);
          // T

        PdfCentre(PdfPage,101,194,200,GetTexteLibelle('PDF_MV1_MOVEMENT'));
        PdfPage.WriteText(102,194,GetTexteLibelle('PDF_MV2A_MOVEMENT'));
        PdfPage.WriteText(133.5,194,GetTexteLibelle('PDF_MV2B_WALK'));
        PdfPage.WriteText(165.5,194,GetTexteLibelle('PDF_MV2C_RUN'));
        // Basic 1
          // H
        For Ind := 0 to 13 do
          PdfPage.DrawLine(17,181.5 - (ind * 5),72,181.5 - (ind * 5),1);
          // V
        PdfPage.DrawLine(41,181.5,41,111.5,1);
        PdfPage.DrawLine(49,176.5,49,111.5,1);
        PdfPage.DrawLine(57,181.5,57,111.5,1);
        PdfPage.DrawLine(64,181.5,64,111.5,1);
         // T
        PdfCentre(PdfPage,17,72,183.5,GetTexteLibelle('PDF_SKILLS1_BASIC'));
        PdfEcrit(PdfPage,18,41,177.5,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
        PdfCentre(PdfPage,42,57,177.5,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
        PdfCentre(PdfPage,57,64,177.5,GetTexteLibelle('PDF_SKILLS2_ADV'));
        PdfCentre(PdfPage,64,72,177.5,GetTexteLibelle('PDF_SKILLS2_SKILL'));
        // Basic 2
          // H
        For Ind := 0 to 13 do
          PdfPage.DrawLine(78,181.5 - (ind * 5),133,181.5 - (ind * 5),1);
          // V
        PdfPage.DrawLine(102,181.5,102,111.5,1);
        PdfPage.DrawLine(110,176.5,110,111.5,1);
        PdfPage.DrawLine(118,181.5,118,111.5,1);
        PdfPage.DrawLine(125,181.5,125,111.5,1);
         // T
         PdfCentre(PdfPage,78,133.5,183.5,GetTexteLibelle('PDF_SKILLS1_BASIC'));
         PdfEcrit(PdfPage,78,102,177.5,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
         PdfCentre(PdfPage,102,118,177.5,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
         PdfCentre(PdfPage,118,125,177.5,GetTexteLibelle('PDF_SKILLS2_ADV'));
         PdfCentre(PdfPage,125,133,177.5,GetTexteLibelle('PDF_SKILLS2_SKILL'));
        // Groupé
          // H
        For Ind := 0 to 1 do
          PdfPage.DrawLine(139,181.5 - (ind * 5),194,181.5 - (ind * 5),1);
          // V
        PdfPage.DrawLine(162,181.5,162,111.5,1);
        PdfPage.DrawLine(170,176.5,170,111.5,1);
        PdfPage.DrawLine(178,181.5,178,111.5,1);
        PdfPage.DrawLine(185,181.5,185,111.5,1);
          // T
        PdfCentre(PdfPage,139,194,183.5,GetTexteLibelle('PDF_SKILLS1_ADVANCED'));
        PdfEcrit(PdfPage,139,162,177.5,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
        PdfCentre(PdfPage,162,178,177.5,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
        PdfCentre(PdfPage,178,185,177.5,GetTexteLibelle('PDF_SKILLS2_ADV'));
        PdfCentre(PdfPage,185,194,177.5,GetTexteLibelle('PDF_SKILLS2_SKILL'));
        // Talents
          // H
        PdfPage.DrawLine(17,100,100,100,1);
        PdfPage.DrawLine(17,92,100,92,1);
          // V
        PdfPage.DrawLine(45,100,45,20,1);
        PdfPage.DrawLine(56,100,56,20,1);
          // T
        PdfCentre(PdfPage,17,100,102,GetTexteLibelle('PDF_TALENT1_TALENTS'));
        PdfPage.WriteText(18,95,GetTexteLibelle('PDF_TALENT2_TALENTNAME'));
        PdfCentre(PdfPage,45,56,96,GetTexteLibelle('PDF_TALENT2A_TAKEN'));
        PdfCentre(PdfPage,45,56,93,GetTexteLibelle('PDF_TALENT2B_TAKEN'));
        PdfPage.WriteText(58,95,GetTexteLibelle('PDF_TALENT2_DESC'));
         // Ambitions
          // H
        PdfPage.DrawLine(106,100,194,100,1);
        PdfPage.DrawLine(106,88,194,88,1);
          // T
        PdfCentre(PdfPage,106,194,102,GetTexteLibelle('PDF_AMBITION1_AMBITIONS'));
        PdfPage.WriteText(108,94,GetTexteLibelle('PDF_AMBITION2A_SHORT'));
        PdfPage.WriteText(108,91,GetTexteLibelle('PDF_AMBITION2B_SHORT'));
        PdfPage.WriteText(108,83,GetTexteLibelle('PDF_AMBITION3A_LONG'));
        PdfPage.WriteText(108,80,GetTexteLibelle('PDF_AMBITION3B_LONG'));
        // Party
          // H
        PdfPage.DrawLine(106,65,194,65,1);
        PdfPage.DrawLine(106,59,194,59,1);
        PdfPage.DrawLine(106,47,194,47,1);
        PdfPage.DrawLine(106,36,194,36,1);
          // T
        PdfCentre(PdfPage,106,194,67,GetTexteLibelle('PDF_PARTY1_PARTY'));
        PdfPage.WriteText(108,61,GetTexteLibelle('PDF_PARTY2_PARTYNAME'));
        PdfPage.WriteText(108,53,GetTexteLibelle('PDF_PARTY3A_SHORT'));
        PdfPage.WriteText(108,50,GetTexteLibelle('PDF_PARTY3B_SHORT'));
        PdfPage.WriteText(108,42,GetTexteLibelle('PDF_PARTY4A_LONG'));
        PdfPage.WriteText(108,39,GetTexteLibelle('PDF_PARTY4B_LONG'));
        PdfPage.WriteText(108,30,GetTexteLibelle('PDF_PARTY5_MEMBERS'));
      end;

    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);

    // Entête
    PRace          := ChercheRace(Personnage.Race);
    LocData        := '';
    for PersonnageMetier in Personnage.MetierAncien do
      begin
        if (DernierMetier <> PersonnageMetier.CodeMetier) then
          begin
            PMetier       := ChercheMetier(PersonnageMetier.CodeMetier);
            if Locdata <> '' then
              LocData     := LocData + ' - ';
            LocData       := LocData + PMetier.Libelle + ':';
            DernierMetier := PersonnageMetier.CodeMetier;
          end
        else if LocData <> '' then
          LocData         := LocData + ',';
         LocData          := LocData + IntToStr(PersonnageMetier.NiveauMetier);
      end;
    PMetier        := ChercheMetier(Personnage.MetierEnCours.CodeMetier);
    PMetierNiveau  := ChercheMetierNiveau(Personnage.MetierEnCours.CodeMetier, Personnage.MetierEnCours.NiveauMetier);
    PRaceAttribut  := ChercheRaceAttribut(Personnage.Race, ConstCaracMouvement);
    Mouv           := StrToInt(PRaceAttribut.CalculRace);

    Chance         := 0;
    Determine      := 0;
    For PRaceAttribut in ListRaceAttribut do
      if PRaceAttribut.CodeRace = Personnage.Race then
        case ExtractStringAfter(PRaceAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracDestin: Chance    := Chance    + StrToIntDef(PRaceAttribut.CalculRace,0);
          ConstCaracResil:  Determine := Determine + StrToIntDef(PRaceAttribut.CalculRace,0);
        end;
    for PersonnageAttribut in Personnage.CreationAttribut do
      case ExtractStringAfter(PersonnageAttribut.CodeAttribut, SeparateurLivre) of
        ConstCaracDestin: Chance    := Chance    + PersonnageAttribut.Valeur;
        ConstCaracResil:  Determine := Determine + PersonnageAttribut.Valeur;
      end;

    // chercher les Valeur d'attributs
    for Ind := 0 to 9 do
      begin
        PAttribut      := ListeAttribut[Ind];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        val            := AttributDonnee.Total;
        case ExtractStringAfter(PAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracE:  BE  := Val;
          ConstCaracF:  BF  := Val;
          ConstCaracFM: BFM := Val;
        end;
      end;

    // chercher les talents et calculer les bonus correspondants
    BonusEncomb := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:    DurACuire   := Floor(BE/10) * Val;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;
    for PersonnageTalent in Personnage.AugmentationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:    DurACuire   := Floor(BE/10) * Val;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;

    // Entête
    PdfPage.WriteText( 50, 246, Personnage.NomPersonnage);                               // Nom
    PdfPage.WriteText(118, 246, PRace.Libelle);                                      // Race
    PdfPage.WriteText(165, 246, GetTexteLibelle(PMetier.LibelleGroupe));                 // Classe
    PdfPage.WriteText( 50, 241, PMetier.Libelle);                                  // Métier
    PdfPage.WriteText(135, 241, IntToStr(Personnage.MetierEnCours.NiveauMetier)+' - '+ PMetierNiveau.Libelle);     // Niveau
    PdfPage.WriteText( 50, 236, LocData);     // Schéma
    PdfPage.WriteText(165, 236, GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' '));  // Salaire

    // Caractéristiques
    for Ind := 1 to 10 do
      begin
        PAttribut      := ListeAttribut[Ind-1];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        PdfPage.WriteText(26+(Ind*6.5), 210, IntToStr(AttributDonnee.Base));        // Base
        if AttributDonnee.Augmentation <> 0 then
          PdfPage.WriteText(26+(Ind*6.5), 203, IntToStr(AttributDonnee.Augmentation));// Bonus
        PdfPage.WriteText(26+(Ind*6.5), 195, IntToStr(AttributDonnee.Total));       // Total
        //if TabAttribut.Cells[Ind+1, LigAttAsterisc] <> '' then
        //  begin
        //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 5);
        //    PdfPage.WriteText(29+(Ind*6.5), 198, '('+TabAttribut.Cells[Ind+1, LigAttAsterisc]+')'); // Talent
        //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
        //  end;

      end;

    // Destin
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracDestin, Bonus);
    PdfPage.WriteText(115, 216, IntToStr(AttributDonnee.Total));          // Destin
    PdfPage.WriteText(115, 210, IntToStr(Chance));                        // Chance

    // Destin
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracResil, Bonus);
    PdfPage.WriteText(128, 210, IntToStr(AttributDonnee.Total));          // Résilience
    PdfPage.WriteText(142, 210, IntToStr(Determine));                     // Détermination

    // Expérience
    PdfCentre(PdfPage,165,176,210,IntToStr(Personnage.XpActuel));                      // Total Xp
    PdfCentre(PdfPage,176,185,210,IntToStr(Personnage.XpTotal - personnage.XpActuel)); // Utilisé
    PdfCentre(PdfPage,185,194,210,IntToStr(Personnage.XpTotal));                       // Restant

    // Mouvement
    PdfPage.WriteText(127, 194, IntToStr(Mouv));                              // Mouvement
    PdfPage.WriteText(157, 194, IntToStr(Mouv*2));                            // Marche
    PdfPage.WriteText(188, 194, IntToStr((Mouv + BonusSprint)*4));            // Course

    // Compétences page 1
    NbLigne := 0;
    ListPris:= '';
    for IndC := 0 to ListPage.count-1 do
      begin
        Asterisc    := '';
        Comp        := ListPage[IndC];
        PCompetence := ChercheCompetence(Comp);
        CompetenceDonnee := PdfPersonnageCompetence(Personnage, Comp, Bidon);
        ValStat     := IntToStr(CompetenceDonnee.Base);
        ValBonus    := IntToStr(CompetenceDonnee.Augmentation);
        ValTotal    := IntToStr(CompetenceDonnee.Total);
        ListPris    := ListPris + Separateurtabulation + Comp;
        //Asterisc := TabCompetence.Cells[ColCompAsterisc, IndT];

        // premier ou seconde colonne
        if IndC <= 12 then
          DebPage := 51
        else
          DebPage := 112;
        if IndC = 13 then
          NbLigne := 0;
        if ValBonus = '0' then
          ValBonus := '';
        if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
          ValBonus := ' ' + ValBonus;
        if DessineTexteLigne then
          begin
            if CompareCompetence(PCompetence.CodeCompetence,PMetier.CodeCompetence) then
              PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceArial+ConstPoliceGras, 8)
            else
              PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfEcrit(PdfPage,DebPage - 33, DebPage - 9, 173-(NbLigne*5), PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle),MinPolice);
            PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
            PdfPage.WriteText(DebPage - 9, 173-(NbLigne*5), GetTexteLibelle(PAttribut.Resume)); // PdfPage.WriteText(DebPage - 9, 173-(NbLigne*5), GetTexteLibelle('SHORT'+PCompetence.CodeAttribut));
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          end;
        PdfPage.WriteText(DebPage,    173-(NbLigne*5), ValStat);  // Compétence Caractéristique
        PdfPage.WriteText(DebPage+7,  173-(NbLigne*5), ValBonus); // Compétence Bonus
        if Pos(ValeurGenerique, PCompetence.codeCompetence) > 0 then
          PdfPage.DrawLine(DebPage+6.5,  172-(NbLigne*5), DebPage+12.5,  176-(NbLigne*5), 1);
        PdfPage.WriteText(DebPage+14, 173-(NbLigne*5), ValTotal); // Compétence Total
        if Asterisc <> '' then
          begin
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 5);
            PdfPage.WriteText(DebPage+19, 174.5-(NbLigne*5), '('+Asterisc+')'); // Talent
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          end;

        NbLigne := NbLigne + 1;
      end;
    ListPage.Destroy;

    // compétences groupés et avancées
    NbLigne := 0;
    for IndC := 0 to ListCompetence.Count-1 do
      begin
        PCompetence   := ListCompetence[IndC];
        if (pos(PCompetence.CodeCompetence, ListPris) = 0) then
          begin
            CompetenceDonnee := PdfPersonnageCompetence(Personnage, PCompetence.CodeCompetence, Bidon);
            if CompetenceDonnee.Augmentation <> 0 then
            begin
              ValBonus := IntToStr(CompetenceDonnee.Augmentation);
              if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
                ValBonus := ' ' + ValBonus;
              PCompetence := ChercheCompetence(PCompetence.CodeCompetence);
              LibComp     := PCompetence.Libelle;
              if CompareCompetence(PCompetence.CodeCompetence,PMetier.CodeCompetence) then
                PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceArial+ConstPoliceGras, 6)
              else
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
              PdfEcrit(PdfPage,137, 163, 173-(NbLigne*3.5), LibComp,MinPolice);                                // Gr_Av Libellé
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
              PAttribut := ChercheAttribut(PCompetence.CodeAttribut);
              PdfPage.WriteText(163, 173-(NbLigne*3.5), PAttribut.Resume);                   // Gr_Av Attribut
              PdfPage.WriteText(172, 173-(NbLigne*3.5), IntToStr(CompetenceDonnee.Base));                 // Gr_Av Caractéristique
              PdfPage.WriteText(180, 173-(NbLigne*3.5), IntToStr(CompetenceDonnee.Augmentation));         // Gr_Av Bonus
              PdfPage.WriteText(188, 173-(NbLigne*3.5), IntToStr(CompetenceDonnee.Total));                // Gr_Av Total
              NbLigne := NbLigne + 1;
            end;
        end;
      end;

    // talents
    NbLigne := 0;
    For IndC := 0 to ListTalent.count - 1 do
      begin
        PTalent := ListTalent[IndC];
        TalentDonnee := PdfPersonnageTalent(Personnage, PTalent.CodeTalent, Bidon);
        if TalentDonnee.Total <> 0 then
        begin
          inc(NbLigne);
          PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
          PdfEcrit(PdfPage, 16, 49, 92-(NbLigne*3.5), PTalent.Libelle,MinPolice);              // Gr_Av Libellé
          PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          PdfPage.WriteText(49, 92-(NbLigne*3.5), IntToStr(TalentDonnee.Total));              // Gr_Av Attribut
          //if TabTalent.Cells[ColTalAsterisk, IndC] <> '' then
          //  begin
          //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
          //    PdfPage.WriteText(12.5, 92.5-(IndC*3.5), '('+TabTalent.Cells[ColTalAsterisk, IndC]+')');
          //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          //  end;
          if PTalent.SousTalent then
            PTalent := ChercheTalent(Copy(PTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
          if PTalent.Resume <> '' then
            begin
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
              PdfEcrit(PdfPage, 58, 105, 92-(NbLigne*3.5), PTalent.Resume,MinPolice);
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end;
        end;
      end;

  // PAGE 2

    // charger l'image de fond
    PdfPage          := PDFDoc.Pages.AddPage;
    PdfFontBack      := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'ariali.ttf', ConstPoliceArial);
    PdfSection.AddPage(PdfPage);

    if BackGround = true then
      begin
        PdfBack          := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfBack, ConstLangue, ValLangue, [rfReplaceAll]),false);
        PdfPage.DrawImage(0, 0, 210, 297, PdfBack);

        PdfShadow          := PdfDoc.Images.AddFromFile(GetCurrentDir+ConstCheminPdfShadow,false);
        PdfPage.DrawImage(135, 190, 55, 72, PdfShadow);
      end;


    // gérer les lignes
    if DessineTexteLigne then
      begin
        PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

        // Armure
          // H
        PdfPage.DrawLine(17,260,134,260,1);
        for ind := 0 to 4 do
          PdfPage.DrawLine(17,254 - (ind*5),134,254 - (ind*5),1);
          // V
        PdfPage.DrawLine(50,260,50,229,1);
        PdfPage.DrawLine(72,260,72,229,1);
        PdfPage.DrawLine(79,260,79,229,1);
        PdfPage.DrawLine(89,260,89,229,1);
          // T
        PdfCentre(PdfPage,17,134,262,GetTexteLibelle('PDF_ARMOUR1_ARMOUR'));
        PdfPage.WriteText(18,255,GetTexteLibelle('PDF_ARMOUR2_NAME'));
        PdfCentre(PdfPage,50,72,255,GetTexteLibelle('PDF_ARMOUR2_LOCATIONS'));
        PdfCentre(PdfPage,72,79,255,GetTexteLibelle('PDF_ARMOUR2_ENCUMBRANCE'));
        PdfCentre(PdfPage,79,89,255,GetTexteLibelle('PDF_ARMOUR2_ARMOURPOINT'));
        PdfPage.WriteText(90,255,GetTexteLibelle('PDF_ARMOUR2_QUALITIES'));
        // Equipement
          // H
        PdfPage.DrawLine(17,218,73,218,1);
        PdfPage.DrawLine(17,212,73,212,1);
          // V
        PdfPage.DrawLine(65,218,65,136,1);
          // T
        PdfCentre(PdfPage,17,73,220,GetTexteLibelle('PDF_TRAPPING1_TRAPPINGS'));
        PdfPage.WriteText(18,213,GetTexteLibelle('PDF_TRAPPING2_NAME'));
        PdfCentre(PdfPage,65,73,213,GetTexteLibelle('PDF_TRAPPING2_ENCUMBRANCE'));
        // Psychologie
          // H
        for ind := 0 to 2 do
          PdfPage.DrawLine(77,218 - (ind * 5),134,218 - (ind * 5),1);
        // T
        PdfCentre(PdfPage,77,134,220,GetTexteLibelle('PDF_PSYCHOLOGY'));
        // Corruption
          // H
        PdfPage.DrawLine(77,192,134,192,1);
          // T
        PdfCentre(PdfPage,77,134,194,GetTexteLibelle('PDF_CORRUPTION'));
        // Points d'Armure
        PdfCentre(PdfPage,138,194,262,GetTexteLibelle('PDF_ARMOURPOINT_ARMOURPOINT'));
        PdfEncadre(PdfPage, 145, 250, false, GetTexteLibelle('PDF_ARMOURPOINT_HEAD'),'','01-09');
        PdfEncadre(PdfPage, 145, 229, false, GetTexteLibelle('PDF_ARMOURPOINT_RIGHTARM1'),GetTexteLibelle('PDF_ARMOURPOINT_RIGHTARM2'),'25-44');
        PdfEncadre(PdfPage, 145, 207.5, false, GetTexteLibelle('PDF_ARMOURPOINT_RIGHTLEG'),'','90-00');
        PdfEncadre(PdfPage, 145, 190, true, GetTexteLibelle('PDF_ARMOURPOINT_SHIELD'),'','');
        PdfEncadre(PdfPage, 184.5, 241, false, GetTexteLibelle('PDF_ARMOURPOINT_LEFTARM1'),GetTexteLibelle('PDF_ARMOURPOINT_LEFTARM2'),'10-24');
        PdfEncadre(PdfPage, 184.5, 219.5, false, GetTexteLibelle('PDF_ARMOURPOINT_BODY'),'','45-79');
        PdfEncadre(PdfPage, 184.5, 195.5, false, GetTexteLibelle('PDF_ARMOURPOINT_LEFTLEG'),'','80-89');
        // Richesse
          // H
        for ind := 0 to 2 do
          PdfPage.DrawLine(77,167 - (ind * 11),102,167 - (ind * 11),1);
          // V
        PdfPage.DrawLine(88,167,88,136,1);
          // T
        PdfCentre(PdfPage,77,102,169,GetTexteLibelle('PDF_WEALTH1_WEALTH'));
        PdfPage.WriteText(78,160,GetTexteLibelle('PDF_WEALTH2_D'));
        PdfPage.WriteText(78,149,GetTexteLibelle('PDF_WEALTH3_SS'));
        PdfPage.WriteText(78,138,GetTexteLibelle('PDF_WEALTH4_GC'));
        // Encombrement
          // H
        for ind := 0 to 4 do
          PdfPage.DrawLine(106,167 - (ind * 6.1),134,167 - (ind * 6.1),1);
          // V
        PdfPage.DrawLine(120,167,120,136,1);
          // T
        PdfCentre(PdfPage,106,134,169,GetTexteLibelle('PDF_ENCUMBRANCE1_ENCUMBRANCE'));
        PdfPage.WriteText(107,163,GetTexteLibelle('PDF_ENCUMBRANCE2_ARMOUR'));
        PdfPage.WriteText(107,157,GetTexteLibelle('PDF_ENCUMBRANCE3_WEAPONS'));
        PdfPage.WriteText(107,151,GetTexteLibelle('PDF_ENCUMBRANCE4_TRAPPINGS'));
        PdfPage.WriteText(107,144.2,GetTexteLibelle('PDF_ENCUMBRANCE5_MAXENC'));
        PdfPage.WriteText(107,137.6,GetTexteLibelle('PDF_ENCUMBRANCE6_TOTAL'));
        // Blessure
          // H
        PdfPage.DrawLine(138,167,194,167,1);
        for ind := 1 to 4 do
          PdfPage.DrawLine(138,167 - (ind * 6.1),160,167 - (ind * 6.1),1);
          // V
        PdfPage.DrawLine(152,167,152,136,1);
        PdfPage.DrawLine(160,167,160,136,1);
          // T
        PdfCentre(PdfPage,138,160,169,GetTexteLibelle('PDF_WOUNDS1_WOUNDS'));
        PdfPage.WriteText(139,163,GetTexteLibelle('PDF_WOUNDS2_SB'));
        PdfPage.WriteText(139,157,GetTexteLibelle('PDF_WOUNDS3_TBX2'));
        PdfPage.WriteText(139,151,GetTexteLibelle('PDF_WOUNDS4_WPB'));
        PdfPage.WriteText(139,144.2,GetTexteLibelle('PDF_WOUNDS5_HARDY'));
        PdfPage.WriteText(139,137.6,GetTexteLibelle('PDF_WOUNDS6_WOUNDS'));
        // Armes
          // H
        for ind := 0 to 7 do
          PdfPage.DrawLine(17,125 - (ind*5),194,125 - (ind*5),1);
          // V
        PdfPage.DrawLine(66,125,66,85,1);
        PdfPage.DrawLine(79,125,79,85,1);
        PdfPage.DrawLine(90,125,90,85,1);
        PdfPage.DrawLine(108,125,108,85,1);
        PdfPage.DrawLine(128,125,128,85,1);
          // T
        PdfCentre(PdfPage,17,194,127,GetTexteLibelle('PDF_WEAPONS1_WEAPONS'));
        PdfPage.WriteText(18,121,GetTexteLibelle('PDF_WEAPONS2_NAME'));
        PdfCentre(PdfPage,66,79,121,GetTexteLibelle('PDF_WEAPONS2_GROUP'));
        PdfCentre(PdfPage,79,90,121,GetTexteLibelle('PDF_WEAPONS2_ENCUMBRANCE'));
        PdfCentre(PdfPage,90,108,121,GetTexteLibelle('PDF_WEAPONS2_RANGE'));
        PdfCentre(PdfPage,108,128,121,GetTexteLibelle('PDF_WEAPONS2_DAMAGE'));
        PdfPage.WriteText(129,121,GetTexteLibelle('PDF_WEAPONS2_QUALITIES'));
        // Sorts
          // H
        for ind := 0 to 8 do
          PdfPage.DrawLine(17,75 - (ind*5),194,75 - (ind*5),1);
          // V
        for ind := 0 to 4 do
          PdfPage.DrawLine(55 + (ind*15),75,55 + (ind*15),30,1);
        PdfPage.DrawLine(170,35,170,30,1);
        PdfPage.DrawLine(179,35,179,30,1);
          // T
        PdfCentre(PdfPage,17,194,77,GetTexteLibelle('PDF_SPELL1_SPELL'));
        PdfPage.WriteText(18,71,GetTexteLibelle('PDF_SPELL2_NAME'));
        PdfCentre(PdfPage,55,70,71,GetTexteLibelle('PDF_SPELL2_CN'));
        PdfCentre(PdfPage,70,85,71,GetTexteLibelle('PDF_SPELL2_RANGE'));
        PdfCentre(PdfPage,85,100,71,GetTexteLibelle('PDF_SPELL2_TARGET'));
        PdfCentre(PdfPage,100,115,71,GetTexteLibelle('PDF_SPELL2_DURATION'));
        PdfPage.WriteText(116,71,GetTexteLibelle('PDF_SPELL2_EFFECT'));
        PdfPage.WriteText(171,31,GetTexteLibelle('PDF_SPELL3_SIN'));

      end;

    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);

    // afficher les blessure
    Ch := IntToStr(Floor(BF/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,163, Ch);
    Ch := IntToStr(Floor(BE/10)*2);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,157, Ch);
    Ch := IntToStr(Floor(BFM/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,150.5, Ch);
    if DurACuire > 0 then
      begin
        Ch := IntToStr(DurACuire);
        if Length(Ch) = 1 then Ch := ' '+Ch;
        PdfPage.WriteText(154,144, Ch);
      end;
    PRaceAttribut := ChercheRaceAttribut(Personnage.Race, ConstCaracBlessure);
    Ch := IntToStr(CalculBlessure(PRaceAttribut.CalculRace, BF, BE, BFM) + DurACuire);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,137.5, Ch);

    // afficher l'encombrement
    Ch := IntToStr(Floor(BF/10) + Floor(BE/10) + BonusEncomb);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(125,144, Ch);

    // Afficher l'équipement
    EncArme     := 0;
    EncArmure   := 0;
    ArmureBras  := 0;
    ArmureCorps := 0;
    ArmureJambe := 0;
    ArmureTete  := 0;
    NbArme      := 0;
    NbArmure    := 0;
    NbSort      := 0;
    Quality     := '';
    for PersonnageEquipement in Personnage.Equipement do
      begin
        Enc := 0;
        EncP:= 0;
        if PersonnageEquipement.TypeEquipement = TypeEquipWe then
          // gérer les armes
            begin
              TexteRange1:= '';
              TexteRange2:= '';
              PArme      := ChercheArme(PersonnageEquipement.CodeEquipement);

              Portee     := PArme.Portee;
              if Pos('(B'+ConstCaracF+')',Portee) > 0 then
                begin
                  Portee       := StringReplace(Portee, '(B'+ConstCaracF+')', IntToStr(Trunc(BF/10)), [rfReplaceAll]);;
                  PorteMoyenne := MultiChaine(Portee);
                  Portee       := IntToStr(PorteMoyenne);
                end
              else
                PorteMoyenne   := StrToIntDef(Portee,0);

              Enc        := PArme.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement, Quality);
              EncArme    := EncArme + Enc;

              Inc(NbArme);

              Pourcent := '';

              CompetenceDonnee := PdfPersonnageCompetence(Personnage, PArme.CodeCompetence, Bidon);

              Pourcent := IntToStr(CompetenceDonnee.Total);
              PasBonus := (CompetenceDonnee.Augmentation = 0);

              if pos(EquipementCT, PArme.CodeArme) > 0 then
                begin
                  TexteRange1 := '< : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/10)))+'m '+IntToStr(StrToInt(Pourcent)+40)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/2 )))+'m '+IntToStr(StrToInt(Pourcent)+20)+'%';
                  TexteRange2 := '> : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*2 )))+'m '+IntToStr(StrToInt(Pourcent)-10)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*3 )))+'m '+IntToStr(StrToInt(Pourcent)-30)+'%';
                end;

              PdfEcrit(PdfPage,18,70,121-(NbArme*5), PArme.Libelle+Quality,MinPolice);

              LigneBonus := '';

              PdfPage.WriteText(70,121-(NbArme*5), Pourcent + ' %');
              if PArme.Encombrement <> 0 then
                PdfPage.WriteText(84,121-(NbArme*5), IntToStr(Enc));
              PdfPage.WriteText(92,121-(NbArme*5), GetAllTexteLibelle(Portee));

              Deg   := CalculDegat(PArme.CalculDegat, BF);
              if pos(EquipementCC, PArme.CodeArme) > 0 then
                Deg := Deg + TBonusCC
              else if pos(EquipementCT, PArme.CodeArme) > 0 then
                Deg := Deg + TBonusCT;

              if Deg = 0 then
                PdfPage.WriteText(114,121-(NbArme*5), '-')
              else
                PdfPage.WriteText(114,121-(NbArme*5), 'DR + '+IntToStr(Deg));

              PosProtection := pos(BonusProtection, PArme.ListeBonus);
              if PosProtection > 0 then
                ArmureBouclier := StrToInt(copy(PArme.ListeBonus, PosProtection + Length(BonusProtection), 1));
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);

              if TexteRange1 <> '' then
                begin
                  PdfPage.WriteText(170,122.5-(NbArme*5), TexteRange1);
                  PdfPage.WriteText(170,120.5-(NbArme*5), TexteRange2);
                end;

              if PasBonus = false then
                begin
                  LigneBonus := PArme.Listebonus;
                  if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                    begin
                      NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                      for IndLoca := 1 to NbLoca do
                        begin
                          LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                          if pos(' ',LocData) <> 0 then
                            LocData := copy(LocData,1,Length(LocData)-2);
                          PArmeBonus := ChercheArmeBonus(LocData);
                          LigneBonus := StringReplace(LigneBonus, LocData, PArmeBonus.Libelle, [rfReplaceAll]);
                          if Pos(PArmeBonus.CodeArmeBonus, ArmeBonii) = 0 then
                           begin
                             if ArmeBonii <> '' then
                              ArmeBonii := ArmeBonii + ',';
                              ArmeBonii := ArmeBonii + PArmeBonus.CodeArmeBonus;
                           end;
                        end;
                    end;
                  FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
                  PdfPage.WriteText(132,121-(NbArme*5), LigneBonus);
                end
              else
                begin
                  PCompetence := ChercheCompetence(PArme.CodeCompetence);
                  ListMalii := 'pas ' + PCompetence.Libelle;

                  if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                    begin
                      NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                      for IndLoca := 1 to NbLoca do
                        begin
                          LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                          if pos(' ',LocData) <> 0 then
                            LocData := copy(LocData,1,Length(LocData)-2);
                          PArmeBonus := ChercheArmeBonus(LocData);
                          if PArmeBonus.PlusMoins = '-' then
                            begin
                              if Pos(PArmeBonus.Libelle, ArmeBonii) = 0 then
                                begin
                                  if ArmeBonii <> '' then ArmeBonii := ArmeBonii + ',';
                                  ArmeBonii := ArmeBonii + LocData;
                                end;
                              ListMalii  := ListMalii + ',' + PArmeBonus.Libelle;
                            end;
                        end;
                    end;
                  FabricationDetail(PersonnageEquipement.QualiteEquipement, ListMalii, FabricationBonii);
                  PdfPage.WriteText(132,121-(NbArme*5), ListMalii);
                end;
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end

          else if ((ArmureSet = false) and (PersonnageEquipement.TypeEquipement = TypeEquipAR)) or
                  ((ArmureSet = true)  and (PersonnageEquipement.TypeEquipement = TypeEquipARS)) then
            // gérer les armures
            begin
              if PersonnageEquipement.TypeEquipement = TypeEquipAR then
                begin
                  PArmure   := ChercheArmure(PersonnageEquipement.CodeEquipement);
                  Enc       := PArmure.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                end
              else
                begin
                  PArmureSimplifiee   := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
                  Enc                 := PArmureSimplifiee.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                end;

              EncP      := Enc;
              if EncP > 0 then
                EncP    := EncP - 1;
              EncArmure := EncArmure + EncP;
              NbLoca    := CountOccurrences(PArmure.Emplacement,',') + 1;
              if PersonnageEquipement.TypeEquipement = TypeEquipAR then
                For IndLoca := 1 to NbLoca do
                  begin
                    LocData := ExtractChaine(',',PArmure.Emplacement,IndLoca);
                    case LocData of
                      BonusBras:   ArmureBras  := ArmureBras  + PArmure.Protection;
                      BonusCorps:  ArmureCorps := ArmureCorps + PArmure.Protection;
                      BonusJambes: ArmureJambe := ArmureJambe + PArmure.Protection;
                      BonusTete:   ArmureTete  := ArmureTete  + PArmure.Protection;
                    end;
                  end
              else
                begin
                  ArmureBras  := ArmureBras  + PArmureSimplifiee.Protection;
                  ArmureCorps := ArmureCorps + PArmureSimplifiee.Protection;
                  ArmureJambe := ArmureJambe + PArmureSimplifiee.Protection;
                  ArmureTete  := ArmureTete  + PArmureSimplifiee.Protection;
                end;

              Inc(NBArmure);
              if PersonnageEquipement.TypeEquipement = TypeEquipAR then
                begin
                  PdfEcrit(PdfPage,18,52,255-(NbArmure*5), Parmure.Libelle+Quality,MinPolice);
                  PdfPage.WriteText(52,255-(NbArmure*5), GetAllTexteLibelle(PArmure.Emplacement));
                  PdfPage.WriteText(83.5,255-(NbArmure*5), IntToStr(PArmure.Protection));
                  LigneBonus := PArmure.Listebonus;
                end
              else
                begin
                  PdfEcrit(PdfPage,18,52,255-(NbArmure*5), ParmureSimplifiee.Libelle+Quality,MinPolice);
                  PdfPage.WriteText(83.5,255-(NbArmure*5), IntToStr(PArmureSimplifiee.Protection));
                  LigneBonus := PArmureSimplifiee.Listebonus;
                end;
              if Enc <> 0 then
                if EncP <> Enc then
                  PdfPage.WriteText(73,255-(NbArmure*5), IntToStr(EncP)+ '('+IntToStr(Enc)+')')
                else
                  PdfPage.WriteText(73,255-(NbArmure*5), IntToStr(Enc));
              if (PersonnageEquipement.TypeEquipement = TypeEquipAR) and (PArmure.ListeBonus <> '') and (PArmure.ListeBonus <> '-') or
                 (PersonnageEquipement.TypeEquipement = TypeEquipARS) and (PArmureSimplifiee.ListeBonus <> '') and (PArmureSimplifiee.ListeBonus <> '-') then
                begin
                  if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                    NbLoca  := CountOccurrences(PArmure.ListeBonus,',') + 1
                  else
                    NbLoca  := CountOccurrences(PArmureSimplifiee.ListeBonus,',') + 1;
                  for IndLoca := 1 to NbLoca do
                    begin
                      if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                        LocData := ExtractChaine(',',PArmure.ListeBonus,IndLoca)
                      else
                        LocData := ExtractChaine(',',PArmureSimplifiee.ListeBonus,IndLoca);
                      if pos(' ',LocData) <> 0 then
                        LocData := copy(LocData,1,Length(LocData)-2);
                      PArmureBonus := ChercheArmureBonus(LocData);
                      LigneBonus := StringReplace(LigneBonus, LocData, PArmureBonus.Libelle, [rfReplaceAll]);
                      if pos(LocData, ArmureBonii) = 0 then
                        begin
                          if ArmureBonii <> '' then
                           ArmureBonii := ArmureBonii + ',';
                          ArmureBonii := ArmureBonii + LocData;
                        end;
                    end;
                end;
              FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);
              PdfPage.WriteText(90,255-(NbArmure*5), LigneBonus);
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end

          else if (PersonnageEquipement.TypeEquipement = TypeEquipDI) then
            // gérer les divers
            begin
              Inc(IndDivers);
              PdfEcrit(PdfPage,18,65,212-(IndDivers*3.5), PersonnageEquipement.CodeEquipement,MinPolice);
            end

          else if PersonnageEquipement.TypeEquipement = TypeEquipSp then
            begin
              // gérer les sorts
              Inc(NbSort);
              PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
              PdfEcrit (PdfPage, 18   , 59.5,71.5-(NbSort*5), PSort.Libelle, MinPolice);
              PdfCentre(PdfPage, 59.5 , 73  ,71.5-(NbSort*5), PSort.Niveau);
              PdfCentre(PdfPage, 73   , 85.5,71.5-(NbSort*5), PdfPersonnageRemplaceBonus(Personnage, PSort.Portee));
              PdfCentre(PdfPage, 85.5 ,100  ,71.5-(NbSort*5), PdfPersonnageRemplaceBonus(Personnage, PSort.Cible));
              PdfCentre(PdfPage,101   ,117  ,71.5-(NbSort*5), PdfPersonnageRemplaceBonus(Personnage, PSort.Duree));
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end;
      end;

    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);

    NbBonus := 0;
    if ArmureBonii <> '' then
      begin
        NbLoca := CountOccurrences(ArmureBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData      := ExtractChaine(',',ArmureBonii,IndLoca);
            PArmureBonus := ChercheArmureBonus(LocData);
            TxtBonus     := PArmureBonus.Libelle+':'+PArmureBonus.Malus;
            PdfPage.WriteText(15,133+(NbBonus*2), TxtBonus);
          end;
        Inc(NbBonus);
        PdfPage.WriteText(15,133+(NbBonus*2), ' --------- ' + GetTexteLibelle('LAB_122') + ' --------- ');
      end;

    if ArmeBonii <> '' then
      begin
        NbLoca := CountOccurrences(ArmeBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',ArmeBonii,IndLoca);
            PArmeBonus  := ChercheArmeBonus(LocData);
            TxtBonus    := PArmeBonus.Libelle+':'+PArmeBonus.Resume;
            PdfPage.WriteText(15,133+(NbBonus*2), TxtBonus);
          end;
        Inc(NbBonus);
        PdfPage.WriteText(15,133+(NbBonus*2), ' ---------- ' + GetTexteLibelle('LAB_123') + ' ---------- ');
      end;

    if FabricationBonii <> '' then
      begin
        NbLoca := CountOccurrences(FabricationBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',FabricationBonii,IndLoca);
            PFabrication:= ChercheFabrication(LocData);
            TxtBonus    := PFabrication.Libelle+':'+PFabrication.Resume;
            PdfPage.WriteText(15,133+(NbBonus*2), TxtBonus);
          end;
        Inc(NbBonus);
        PdfPage.WriteText(15,133+(NbBonus*2), ' ---------- ' + GetTexteLibelle('LAB_124') + ' ---------- ');
      end;

    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);

    PdfPage.WriteText(126,163, IntToStr(EncArmure));
    PdfPage.WriteText(126,157, IntToStr(EncArme));
    PdfPage.WriteText(126,137.5, IntToStr(EncArme + EncArmure));

    if ArmureBouclier > 0 then
      PdfPage.WriteText(145, 190, IntToStr(ArmureBouclier));
    if ArmureJambe > 0 then
     begin
      PdfPage.WriteText(145, 207.5, IntToStr(ArmureJambe));
      PdfPage.WriteText(184.5, 195.5, IntToStr(ArmureJambe));
     end;
    if ArmureBras > 0 then
     begin
      PdfPage.WriteText(145, 229, IntToStr(ArmureBras));
      PdfPage.WriteText(184.5, 241, IntToStr(ArmureBras));
     end;
    if ArmureTete > 0 then
      PdfPage.WriteText(145, 250, IntToStr(Armuretete));
    if ArmureCorps > 0 then
     PdfPage.WriteText(184.5, 219.5, IntToStr(ArmureCorps));

    PDFDoc.SaveToFile(PdfChemin);
    PDFDoc.Free;

    OpenDocument(PdfChemin);
  end;

Function PdfPersonnageTalentBonus(Personnage: StructurePersonnage; CodeTalent: String): String;
var
  Indice: Integer;
  Bonus:  String = '';
begin
  For Indice := 0 to high(Personnage.CreationTalent) do
    if CompareRechercheValeur(Personnage.CreationTalent[Indice].CodeTalent, CodeTalent) then
      if Personnage.CreationTalent[Indice].Asterisque <> 0 then
        Bonus := '(' + IntToStr(Personnage.CreationTalent[Indice].Asterisque) + ')';

  For Indice := 0 to high(Personnage.AugmentationTalent) do
    if CompareRechercheValeur(Personnage.AugmentationTalent[Indice].CodeTalent, CodeTalent) then
      if Personnage.AugmentationTalent[Indice].Asterisque <> 0 then
        Bonus := '(' + IntToStr(Personnage.AugmentationTalent[Indice].Asterisque) + ')';

  Result := Bonus;
end;


Function PdfPersonnageCompetenceBonus(Personnage: StructurePersonnage; CodeCompetence: String): String;
var
  Indice: Integer;
  Bonus:  String = '';
begin
  For Indice := 0 to high(Personnage.CreationCompetence35) do
    if CompareRechercheValeur(Personnage.CreationCompetence35[Indice].CodeCompetence, CodeCompetence) then
      if Personnage.CreationCompetence35[Indice].Bonus <> '' then
        if CountOccurrences(Personnage.CreationCompetence35[Indice].Bonus, Bonus) = 0 then
          begin
            if Bonus <> '' then
              Bonus += '-';
            Bonus += Personnage.CreationCompetence35[Indice].Bonus;
          end;

  For Indice := 0 to high(Personnage.CreationCompetence40) do
    if CompareRechercheValeur(Personnage.CreationCompetence40[Indice].CodeCompetence, CodeCompetence) then
      if Personnage.CreationCompetence40[Indice].Bonus <> '' then
        if CountOccurrences(Personnage.CreationCompetence40[Indice].Bonus, Bonus) = 0 then
          begin
            if Bonus <> '' then
              Bonus += '-';
            Bonus += Personnage.CreationCompetence40[Indice].Bonus;
          end;

  For Indice := 0 to high(Personnage.AugmentationCompetence) do
    if CompareRechercheValeur(Personnage.AugmentationCompetence[Indice].CodeCompetence, CodeCompetence) then
      if Personnage.AugmentationCompetence[indice].Bonus <> '' then
        if CountOccurrences(Personnage.AugmentationCompetence[Indice].Bonus, Bonus) = 0 then
          begin
            if Bonus <> '' then
              Bonus += '-';
            Bonus += Personnage.AugmentationCompetence[Indice].Bonus;
          end;

  Result := Bonus;
end;

Procedure PdfPersonnageCreationFeldo2P(Personnage: StructurePersonnage);
  var
    PDFDoc:          TPDFDocument;
    PdfSection:      TPDFSection;
    PdfPage:         TPDFPage;
    PDFOption:       TPDFOptions;
    PdfChemin:       String;
    PRace:           StructureRace;
    PMetier:         StructureMetier;
    PMetierNiveau:   StructureMetierNiveau;
    PRaceAttribut:   StructureRaceAttribut;
    PTalent:         StructureTalent;
    PMetierAttribut: StructureMetierAttribut;
    PMetierTalent:   StructureMetierTalent;
    Mouv:            Integer = 0;
    ListPage:        TStringList;
    Comp:            String;
    PCompetence:     StructureCompetence;
    ValStat:         String;
    ValBonus:        String;
    ValTotal:        String;
    NbLigne:         Integer;
    IndC:            Integer;
    ListPris:        String;
    BF, BE, BFM:     Integer;
    Ch:              String;
    DurACuire:       Integer = 0;
    ValDurACuire:    Integer = 0;
    BonusEncomb:     Integer = 0;
    Enc:             Integer;
    EncP:            Integer;
    PArme:           StructureArme;
    PArmure:         StructureArmure;
    Deg:             Integer;
    Pourcent:        String;
    EncArme:         Integer;
    EncArmure:       Integer;
    ArmureTete:      Integer;
    ArmureBras:      Integer;
    ArmureCorps:     Integer;
    ArmureJambe:     Integer;
    ArmureBouclier:  Integer = 0;
    PosProtection:   SizeInt;
    NbLoca:          Integer;
    IndLoca:         Integer;
    LocData:         String;
    NbArme:          Integer;
    NbArmure:        Integer;
    ArmeBonii:       String = '';
    ArmureBonii:     String = '';
    FabricationBonii:String = '';
    PArmureBonus:    StructureArmureBonus;
    PArmeBonus:      StructureArmeBonus;
    NbBonus:         Integer;
    TxtBonus:        String;
    IndDivers:       Integer = 0;
    PasBonus:        Boolean;
    ListMalii:       String;
    NBSort:          Integer;
    PSort:           StructureSort;
    LigneBonus:      String;
    Ind:             Integer;
    PAttribut:       StructureAttribut;
    PFabrication:    StructureFabrication;
    Quality:         String;
    Portee:          String;
    TexteRange1:     String;
    TexteRange2:     String;
    PorteMoyenne:    Integer;
    Chance:          Integer;
    Determine:       Integer;
    TBonusCC:        Integer=0;
    TBonusCT:        Integer=0;
    Val:             Integer;
    BonusSprint:     Integer=0;
    MinPolice:       Integer=5;
    DernierMetier:   String='';
    PersonnageAttribut:      StructurePersonnageAttribut;
    AttributDonnee:          StructureDonnee;
    CompetenceDonnee:        StructureDonnee;
    PersonnageTalent:        StructurePersonnagetalent;
    TalentDonnee:            StructureDonnee;
    PersonnageEquipement:    StructurePersonnageEquipement;
    PersonnageMetier:        StructurePersonnageMetier;
    PersonnageCompetence:    StructurePersonnageCompetence;
    PArmureSimplifiee:       StructureArmureSimplifiee;
    NivCompMetier:           Integer = 0;
    NivTalMetier:            Integer = 0;
    ListeTalent:             String='';
    bidon:                   Integer=0;
    ArmureSet:               Boolean = false;
    AmePure:                 Integer=0;
    PersonnageXpAttribut:    StructurePersonnageXpAttribut;
    PersonnageXpCompetence:  StructurePersonnageXpCompetence;
    PersonnageXpTalent:      StructurePersonnageXpTalent;
    TotalXpSoustrait:        Integer = 0;
    PAttributAugmentation:   StructureAttributAugmentation;
    PCompetenceAugmentation: StructureCompetenceAugmentation;
    TotalEsquive:            Integer = 0;
    TotalCalme:              Integer = 0;
    TotalResitance:          Integer = 0;
    TotalCommandement:       Integer = 0;
    TotalIntuition:          Integer = 0;
    Bonus:                   String;

    // Page 1
      // Entête
      DessinFinEntete:      Integer = 143;
      DessinDebColG:        Integer = 20;
      DessinFinColG:        Integer = 98;
      DessinDebColD:        Integer = 102;
      DessinFinColD:        Integer = 188;
      // Colonne gauche
        // Images
        PdfImgWarhammer: Integer;
        PdfImgFantasy:   Integer;
        PdfImgUbersreik: Integer;
        // Entete
        DessinDebutHautEntete:Single  = 285;
        DessinHauteurEntete:  Single  = 4.5;
        DessinNbLigEntete:    Integer = 4;
        // Caractéristiques
        DessinDebutHautCarac: Single;
        DessinHauteurCarac:   Single  = 4.6;
        DessinNbLigCarac:     Integer = 6;
        DessinNbColCarac:     Integer = 10;
        DessinLargeurCarac:   Single  = 10.3;
        // Compétence
        DessinDebutHautComp:  Single;
        DessinHauteurComp:    Single  = 4.4;
        DessinNbLigComp:      Integer = 28;
        DessinNbColComp:      Integer = 5;
        DessinLargeurComp:    Single  = 8.6;
        // Ambition
        DessinDebutHautAmb:   Single;
        DessinHauteurAmb:     Single  = 4.4;
        DessinNbLigAmb:       Integer = 3;
        // Résilience
        DessinDebutHautRes:   Single;
        DessinHauteurRes:     Single  = 4.4;
        DessinNbLigRes:       Integer = 4;
        DessinLargeurBle:     Single;
        // Destin
        DessinDebutHautDes:   Single;
        DessinHauteurDes:     Single  = 4.4;
        // Blessure
        DessinDebutHautBle:   Single;
        DessinDebutGaucheBle: Single;
        DessinHauteurBle:     Single  = 4.6;
        DessinNbLigBle:       Integer = 6;
        // Expérience
        DessinDebutHautExp:   Single;
        DessinHauteurExp:     Single = 4.4;
        DessinNbLigExp:       Integer = 3;
        DessinLargeurExp:     Single = 45;
        // Mouvement
        DessinDebutHautMou:   Single;
        DessinDebutGaucheMou: Single;
        DessinHauteurMou:     Single = 4.4;
        DessinNbLigMou:       Integer = 3;
        DessinLargeurMou:     Single = 22;
        // Corruption
        DessinDebutHautCor:   Single;
        DessinDebutGaucheCor: Single;
        DessinHauteurCor:     Single = 4.4;
        DessinNbLigCor:       Integer = 4;
        DessinLargeurCor:     Single;
      // Colonne droite
        // Compétence Groupée
        DessinDebutHautComg:  Single;
        DessinHauteurComg:    Single  = 4.4;
        DessinNbLigComg:      Integer = 26;
        DessinNbColComg:      Integer = 5;
        DessinLargeurComg:    Single  = 9;
        // Talents
        DessinDebutHautTal:   Single;
        DessinHauteurTal:     Single  = 4.4;
        DessinNbLigTal:       Integer = 24;

    // Page 2
      // Armure
        DessinDebutHautArm:   Single;
        DessinHauteurArm:     Single = 4.4;
        DessinNbLigArm:       Integer = 6;
        DessinLargeurArm:     Single = 128;
      // Equipement
        DessinDebutHautEqu:   Single;
        DessinHauteurEqu:     Single = 4.4;
        DessinNbLigEqu:       Integer = 5;
        DessinLargeurEqu:     Single = 128;
      // Armes
        DessinDebutHautWea:   Single;
        DessinHauteurWea:     Single = 4.4;
        DessinNbLigWea:       Integer = 8;
        DessinLargeurWea:     Single = 200;
      // Sorts
        DessinDebutHautSor:   Single;
        DessinHauteurSor:     Single = 4.4;
        DessinNbLigSor:       Integer = 11;
        DessinLargeurSor:     Single = 200;
      // Explications
        DessinHauteurExl:     Single = 2.5;
      // Encombrement
        DessinDebutHautEnc:   Single;
        DessinHauteurEnc:     Single = 4.6;
        DessinNbLigEnc:       Integer = 5;
        DessinLargeurEnc:     Single = 44;
      // Compétence de combat
        DessinDebutHautComC:  Single;
        DessinHauteurComC:    Single = 4.6;
        DessinNbLigComC:      Integer = 5;
        DessinLargeurComC:    Single = 200;
        DessinDebutGaucheComC:Single;


  begin
    PdfChemin        := GetCurrentDir+ConstCheminPersonnage+Personnage.NomPersonnage+'\'+Personnage.NomPersonnage+'.PDF';

    if (Pos(AjouteAccolade(ConstXmlOptionQuickArmor),Personnage.Options) > 0) then
      ArmureSet := True;

    if FileExists(PdfChemin) then
      if not DeleteFile(PdfChemin) then
        begin
          ShowMessage(GetTexteLibelle('MESS_038'));
          exit;
        end;

    PDFDoc          := TPDFDocument.Create(nil);
    PDFOption       := [poUseImageTransparency, poCompressImages, poCompressFonts, poCompressText ];
    PDFDoc.Options  := PDFOption;
    PDFDoc.StartDocument;
    PdfSection      := PDFDoc.Sections.AddSection;

  // PAGE 1
    PdfPage         := PDFDoc.Pages.AddPage;
    PdfFontBack     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue    := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'ariali.ttf', ConstPoliceArial);
    PdfFontBold     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'arialbd.ttf', ConstPoliceArial+ConstPoliceGras);

    PdfSection.AddPage(PdfPage);
    PdfPage.PaperType:= ptA4;
    PdfPage.UnitOfMeasure := uomMillimeters;

    PdfImgWarhammer  := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfWarhammer, ConstLangue, ValLangue, [rfReplaceAll]),false);
    PdfPage.DrawImage(152, DessinDebutHautEntete - 5, 36, 5, PdfImgWarhammer);
    PdfImgFantasy    := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfRolePlay, ConstLangue, ValLangue, [rfReplaceAll]),false);
    PdfPage.DrawImage(152, DessinDebutHautEntete - 17, 36, 12, PdfImgFantasy);
    PdfImgUbersreik  := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfUbersreik, ConstLangue, ValLangue, [rfReplaceAll]),false);
    PdfPage.DrawImage(152, DessinDebutHautEntete - 55, 36, 38, PdfImgUbersreik);

    // Paramétrages : liste des compétences de la page 1
    ListPage       := TStringList.Create;

    // gérer les lignes
    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

    // Entête
    PRace          := ChercheRace(Personnage.Race);
    LocData        := '';
    for PersonnageMetier in Personnage.MetierAncien do
      begin
        if (DernierMetier <> PersonnageMetier.CodeMetier) then
          begin
            PMetier       := ChercheMetier(PersonnageMetier.CodeMetier);
            if Locdata <> '' then
              LocData     := LocData + ' - ';
            LocData       := LocData + PMetier.Libelle + ':';
            DernierMetier := PersonnageMetier.CodeMetier;
          end
        else if LocData <> '' then
          LocData         := LocData + ',';
         LocData          := LocData + IntToStr(PersonnageMetier.NiveauMetier);
      end;
    PMetier        := ChercheMetier(Personnage.MetierEnCours.CodeMetier);
    PMetierNiveau  := ChercheMetierNiveau(Personnage.MetierEnCours.CodeMetier, Personnage.MetierEnCours.NiveauMetier);
    PRaceAttribut  := ChercheRaceAttribut(Personnage.Race, ConstCaracMouvement);
    Mouv           := StrToInt(PRaceAttribut.CalculRace);

    Chance         := 0;
    Determine      := 0;
    For PRaceAttribut in ListRaceAttribut do
      if ExtractStringAfter(PRaceAttribut.CodeRace, SeparateurChance) = Personnage.Race then
        case ExtractStringAfter(PRaceAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracDestin: Chance    := Chance    + StrToIntDef(PRaceAttribut.CalculRace,0);
          ConstCaracResil:  Determine := Determine + StrToIntDef(PRaceAttribut.CalculRace,0);
        end;
    for PersonnageAttribut in Personnage.CreationAttribut do
      case ExtractStringAfter(PersonnageAttribut.CodeAttribut, SeparateurLivre) of
        ConstCaracDestin: Chance    := Chance    + PersonnageAttribut.Valeur;
        ConstCaracResil:  Determine := Determine + PersonnageAttribut.Valeur;
      end;


    // chercher les Valeur d'attributs
    for Ind := 0 to 9 do
      begin
        PAttribut      := ListeAttribut[Ind];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        val            := AttributDonnee.Total;
        case ExtractStringAfter(PAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracE:  BE  := Val;
          ConstCaracF:  BF  := Val;
          ConstCaracFM: BFM := Val;
        end;
      end;

    // chercher les talents et calculer les bonus correspondants
    BonusEncomb := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:
            begin
              ValDurACuire:= Val;
              DurACuire   := Floor(BE/10) * ValDurACuire;
            end;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;
    for PersonnageTalent in Personnage.AugmentationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:
            begin
              ValDurACuire:= Val;
              DurACuire   := Floor(BE/10) * ValDurACuire;
            end;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;

    // Paramétrages : liste des compétences
    ListPage       := TStringList.Create;
    PdfPersonnageCompetenceTri(ListPage);

    // dessin entête
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautEntete, DessinDebColG, DessinDebutHautEntete - (DessinNbLigEntete * DessinHauteurEntete), 1);
    PdfPage.DrawLine(DessinFinEntete, DessinDebutHautEntete,DessinFinEntete, DessinDebutHautEntete - (DessinNbLigEntete * DessinHauteurEntete), 1);
    for IndC := 0 to DessinNbLigEntete do
      begin
        PdfPage.DrawLine(DessinDebColG,DessinDebutHautEntete - (indC * DessinHauteurEntete), DessinFinEntete, DessinDebutHautEntete - (indC * DessinHauteurEntete), 1);
        if IndC > 0 then
          begin
            if IndC = 4 then PdfPage.DrawLine( 52, DessinDebutHautEntete - ((indC-1) * DessinHauteurEntete), 52, DessinDebutHautEntete - (indC * DessinHauteurEntete), 1);
            if IndC <>3 then PdfPage.DrawLine( 82, DessinDebutHautEntete - ((indC-1) * DessinHauteurEntete), 82, DessinDebutHautEntete - (indC * DessinHauteurEntete), 1);
            if IndC <>2 then PdfPage.DrawLine(114, DessinDebutHautEntete - ((indC-1) * DessinHauteurEntete),114, DessinDebutHautEntete - (indC * DessinHauteurEntete), 1);
          end;
      end;
    DessinDebutHautCarac :=  DessinDebutHautEntete - (indC * DessinHauteurEntete) - 3;
    // Texte Entête
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfPage.WriteText( 21, DessinDebutHautEntete - (DessinHauteurEntete * 1) + 1, GetTexteLibelle('PDF_MAIN1_NAME'));
    PdfPage.WriteText( 83, DessinDebutHautEntete - (DessinHauteurEntete * 1) + 1, GetTexteLibelle('PDF_MAIN1_SPECIES'));
    PdfPage.WriteText(115, DessinDebutHautEntete - (DessinHauteurEntete * 1) + 1, GetTexteLibelle('PDF_MAIN1_CLASS'));
    PdfPage.WriteText( 21, DessinDebutHautEntete - (DessinHauteurEntete * 2) + 1, GetTexteLibelle('PDF_MAIN2_CAREER'));
    PdfPage.WriteText( 83, DessinDebutHautEntete - (DessinHauteurEntete * 2) + 1, GetTexteLibelle('PDF_MAIN2_CAREERLEVEL'));
    PdfPage.WriteText( 21, DessinDebutHautEntete - (DessinHauteurEntete * 3) + 1, GetTexteLibelle('PDF_MAIN3_CAREERPATH'));
    PdfPage.WriteText(115, DessinDebutHautEntete - (DessinHauteurEntete * 3) + 1, GetTexteLibelle('PDF_MAIN3_STATUS'));
    PdfPage.WriteText( 21, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, GetTexteLibelle('PDF_MAIN4_AGE'));
    PdfPage.WriteText( 53, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, GetTexteLibelle('PDF_MAIN4_HEIGHT'));
    PdfPage.WriteText( 83, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, GetTexteLibelle('PDF_MAIN4_HAIR'));
    PdfPage.WriteText(115, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, GetTexteLibelle('PDF_MAIN4_EYES'));
    // Valeur Entête
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfEcrit(PdfPage, 32, 86, DessinDebutHautEntete - (DessinHauteurEntete * 1) + 1, Personnage.NomPersonnage, MinPolice);
    PdfEcrit(PdfPage, 89,115, DessinDebutHautEntete - (DessinHauteurEntete * 1) + 1, PRace.Libelle, MinPolice);
    PdfEcrit(PdfPage,126,DessinFinEntete, DessinDebutHautEntete - (DessinHauteurEntete * 1) + 1, GetTexteLibelle(PMetier.LibelleGroupe), MinPolice);
    PdfEcrit(PdfPage, 32, 85, DessinDebutHautEntete - (DessinHauteurEntete * 2) + 1, PMetier.Libelle, MinPolice);
    PdfEcrit(PdfPage, 95,DessinFinEntete, DessinDebutHautEntete - (DessinHauteurEntete * 2) + 1, IntToStr(Personnage.MetierEnCours.NiveauMetier)+' - '+ PMetierNiveau.Libelle, MinPolice);
    PdfEcrit(PdfPage, 50,DessinFinEntete, DessinDebutHautEntete - (DessinHauteurEntete * 3) + 1, LocData, MinPolice);
    PdfEcrit(PdfPage,125,DessinFinEntete, DessinDebutHautEntete - (DessinHauteurEntete * 3) + 1, GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' '), MinPolice);
    PdfEcrit(PdfPage, 32, 53, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, IntToStr(Personnage.Age), MinPolice);
    PdfEcrit(PdfPage, 63, 83, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, IntToStr(Personnage.Height), MinPolice);
    PdfEcrit(PdfPage, 98, 115, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, Personnage.HairColors, MinPolice);
    PdfEcrit(PdfPage, 125, DessinFinEntete, DessinDebutHautEntete - (DessinHauteurEntete * 4) + 1, Personnage.EyeColors, MinPolice);

    // Dessin caractéristiques
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautCarac,DessinFinEntete, DessinDebutHautCarac, 1);
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautCarac, 20, DessinDebutHautCarac - (DessinNbLigCarac * DessinHauteurCarac), 1);
    for IndC := 0 to DessinNbColCarac do
      PdfPage.DrawLine( 40 + (IndC * DessinLargeurCarac), DessinDebutHautCarac, 40  + (IndC * DessinLargeurCarac), DessinDebutHautCarac - (DessinNbLigCarac * DessinHauteurCarac), 1);
    for IndC := 0 to DessinNbLigCarac do
      PdfPage.DrawLine(20,DessinDebutHautCarac - (indC * DessinHauteurCarac), DessinFinEntete, DessinDebutHautCarac - (indC * DessinHauteurCarac), 1);
    DessinDebutHautComp := DessinDebutHautCarac - (DessinNbLigCarac * DessinHauteurCarac) - 3;
    DessinDebutHautComg := DessinDebutHautComp;

    // Texte caractéristiques
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    For PAttribut in ListeAttribut do
      if (PAttribut.OrdreAttribut <= 10) then
        PdfCentre(PdfPage,40 + ((PAttribut.OrdreAttribut-1) * DessinLargeurCarac),40 + (PAttribut.OrdreAttribut * DessinLargeurCarac),DessinDebutHautCarac - (DessinHauteurCarac * 1 ) + 1, GetTexteLibelle('SHORTATTR_'+ExtractStringAfter(PAttribut.CodeAttribut,'_')));
    PdfCentre(PdfPage,21, 43, DessinDebutHautCarac - (DessinHauteurCarac * 1 ) + 1, GetTexteLibelle('PDF_CHARAC1_CHARAC'));
    PdfCentre(PdfPage,21, 43, DessinDebutHautCarac - (DessinHauteurCarac * 2 ) + 1, GetTexteLibelle('PDF_CHARAC3_INITIAL'));
    PdfCentre(PdfPage,21, 43, DessinDebutHautCarac - (DessinHauteurCarac * 3 ) + 1, GetTexteLibelle('PDF_CHARAC3_IMPROV'));
    PdfCentre(PdfPage,21, 43, DessinDebutHautCarac - (DessinHauteurCarac * 4 ) + 1, GetTexteLibelle('PDF_CHARAC3_ADVANCES'));
    PdfCentre(PdfPage,21, 43, DessinDebutHautCarac - (DessinHauteurCarac * 5 ) + 1, GetTexteLibelle('PDF_CHARAC3_CURRENT'));
    PdfCentre(PdfPage,21, 43, DessinDebutHautCarac - (DessinHauteurCarac * 6 ) + 1, GetTexteLibelle('PDF_CHARAC3_BONUS'));
    // Valeur caractéristiques
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    for Ind := 1 to 10 do
      begin
        PAttribut      := ListeAttribut[Ind-1];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        PdfCentre(PdfPage,  40 + ((Ind-1) * DessinLargeurCarac),40 + (Ind * DessinLargeurCarac),DessinDebutHautCarac - (DessinHauteurCarac * 2 ) + 1, IntToStr(AttributDonnee.Base));
        if Bonus <> '' then
          PdfEcrit(PdfPage,  40 + ((Ind - 0.5) * DessinLargeurCarac) + 0.75, 40 + (Ind * DessinLargeurCarac) +0.75,DessinDebutHautCarac - (DessinHauteurCarac * 1 ) + 3, Bonus, 4);
        For PAttribut in ListeAttribut do
          if PAttribut.OrdreAttribut = Ind then
            break;
        For PMetierAttribut in ListMetierAttribut do
          if (PMetierAttribut.CodeMetier = PMetier.CodeMetier)
             and (PMetierAttribut.CodeAttribut = PAttribut.CodeAttribut)
             and (PMetierAttribut.NiveauMetier > 0) then
            begin
              if (PMetierAttribut.NiveauMetier > Personnage.MetierEnCours.NiveauMetier) then
                PdfPage.SetColor(RGB(150,150,150), False);
              PdfCentre(PdfPage,  40 + ((Ind-1) * DessinLargeurCarac),40 + (Ind * DessinLargeurCarac),DessinDebutHautCarac - (DessinHauteurCarac * 3 ) + 1, InttoStr(PMetierAttribut.NiveauMetier));
              PdfPage.SetColor(clBlack, False);
              break;
            end;
        if AttributDonnee.Augmentation <> 0 then
          PdfCentre(PdfPage,40 + ((Ind-1) * DessinLargeurCarac),40 + (Ind * DessinLargeurCarac),DessinDebutHautCarac - (DessinHauteurCarac * 4 ) + 1, IntToStr(AttributDonnee.Augmentation));
        PdfCentre(PdfPage,  40 + ((Ind-1) * DessinLargeurCarac),40 + (Ind * DessinLargeurCarac),DessinDebutHautCarac - (DessinHauteurCarac * 5 ) + 1, IntToStr(AttributDonnee.Total));
        PdfCentre(PdfPage,  40 + ((Ind-1) * DessinLargeurCarac),40 + (Ind * DessinLargeurCarac),DessinDebutHautCarac - (DessinHauteurCarac * 6 ) + 1, IntToStr(Trunc(AttributDonnee.Total/10)));
      end;

    // Dessin compétence de base
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautComp, DessinFinColG, DessinDebutHautComp, 1);
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautComp, DessinDebColG, DessinDebutHautComp - (DessinNbLigComp * DessinHauteurComp), 1);
    for IndC := 0 to DessinNbColComp do
      if Indc = DessinNbColComp then
        PdfPage.DrawLine( 55 + (IndC * DessinLargeurComp), DessinDebutHautComp, 55  + (IndC * DessinLargeurComp), DessinDebutHautComp - (DessinNbLigComp * DessinHauteurComp), 1)
      else if Indc = 1 then
        PdfPage.DrawLine( 55 + (IndC * DessinLargeurComp), DessinDebutHautComp - (DessinHauteurComp * 2), 55  + (IndC * DessinLargeurComp), DessinDebutHautComp - (DessinNbLigComp * DessinHauteurComp), 1)
      else
        PdfPage.DrawLine( 55 + (IndC * DessinLargeurComp), DessinDebutHautComp - DessinHauteurComp, 55  + (IndC * DessinLargeurComp), DessinDebutHautComp - (DessinNbLigComp * DessinHauteurComp), 1);
    for IndC := 0 to DessinNbLigComp do
      PdfPage.DrawLine(DessinDebColG,DessinDebutHautComp - (indC * DessinHauteurComp), DessinFinColG, DessinDebutHautComp - (indC * DessinHauteurComp), 1);
    DessinDebutHautAmb := DessinDebutHautComp - (indC * DessinHauteurComp) - 3;
    // Texte Compétence de base
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebColG + 15, DessinFinColG, DessinDebutHautComp - (1 * DessinHauteurComp) + 1, Trim(GetTexteLibelle('PDF_SKILLS1_BASIC')));
    PdfEcrit(PdfPage, 22, 55, DessinDebutHautComp - (2 * DessinHauteurComp) + 1,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
    PdfCentre(PdfPage, 55 + (0 * DessinLargeurComp) + 1, 55 + (2 * DessinLargeurComp), DessinDebutHautComp - (2 * DessinHauteurComp) + 1,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
    PdfCentre(PdfPage, 55 + (2 * DessinLargeurComp) + 1, 55 + (3 * DessinLargeurComp), DessinDebutHautComp - (2 * DessinHauteurComp) + 1,GetTexteLibelle('PDF_SKILLS2_UPG'));
    PdfCentre(PdfPage, 55 + (3 * DessinLargeurComp) + 1, 55 + (4 * DessinLargeurComp), DessinDebutHautComp - (2 * DessinHauteurComp) + 1,GetTexteLibelle('PDF_SKILLS2_ADV'));
    PdfCentre(PdfPage, 55 + (4 * DessinLargeurComp) + 1, 55 + (5 * DessinLargeurComp), DessinDebutHautComp - (2 * DessinHauteurComp) + 1,GetTexteLibelle('PDF_SKILLS2_TOTAL'));
    // Valeur compétence de base
    // Compétences page 1
    NbLigne := 0;
    ListPris:= '';
    for IndC := 0 to ListPage.count-1 do
      begin
        Comp        := ListPage[IndC];
        PCompetence := ChercheCompetence(Comp);
        CompetenceDonnee := PdfPersonnageCompetence(Personnage, Comp, NivCompMetier);
        ValStat     := IntToStr(CompetenceDonnee.Base);
        ValBonus    := IntToStr(CompetenceDonnee.Augmentation);
        ValTotal    := IntToStr(CompetenceDonnee.Total);
        case Comp of
          ConstCEsquive:      TotalEsquive      := CompetenceDonnee.Total;
          ConstCCalme:        TotalCalme        := CompetenceDonnee.Total;
          ConstCResitance:    TotalResitance    := CompetenceDonnee.Total;
          ConstCCommandement: TotalCommandement := CompetenceDonnee.Total;
          ConstCIntuition:    TotalIntuition    := CompetenceDonnee.Total;
        end;
        ListPris    := ListPris + Separateurtabulation + Comp;
        //Asterisc := TabCompetence.Cells[ColCompAsterisc, IndT];

        if ValBonus = '0' then
          ValBonus := '';
        if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
          ValBonus := '  ' + ValBonus;
        if CompareCompetence(PCompetence.CodeCompetence,PMetier.CodeCompetence) then
          PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceArial+ConstPoliceGras, 8)
        else
          PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

        PdfEcrit(PdfPage, 22, 55 + (0 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 1, PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle),MinPolice);
        // gérer les astérisques
        Bonus       := PdfPersonnageCompetenceBonus(Personnage, Comp);
        if Bonus <> '' then
          begin
            PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceArial, 6);
            PdfEcrit(PdfPage, 50, 55 + (0 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 2, Bonus, 6);
            if CompareCompetence(PCompetence.CodeCompetence,PMetier.CodeCompetence) then
              PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceArial+ConstPoliceGras, 8)
            else
              PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
          end;
        PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
        PdfEcrit(PdfPage, 55 + (0 * DessinLargeurComp) + 3.5, 55 + (1 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 1, GetTexteLibelle(PAttribut.Resume),MinPolice);
        PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
        PdfEcrit(PdfPage, 55 + (1 * DessinLargeurComp) + 3.5, 55 + (2 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 1, ValStat,MinPolice);
        if (NivCompMetier > 0) then
          begin
            if (NivCompMetier > Personnage.MetierEnCours.NiveauMetier) then
              PdfPage.SetColor(RGB(150,150,150), False);
            PdfEcrit(PdfPage, 55 + (2 * DessinLargeurComp) + 3.5, 55 + (3 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 1, IntToStr(NivCompMetier),MinPolice);
            PdfPage.SetColor(clBlack, False);
          end;
        PdfEcrit(PdfPage, 55 + (3 * DessinLargeurComp) + 3.5, 55 + (4 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 1, ValBonus,MinPolice);
        PdfEcrit(PdfPage, 55 + (4 * DessinLargeurComp) + 3.5, 55 + (5 * DessinLargeurComp) + 3.5, DessinDebutHautComp - (DessinHauteurComp * (IndC+3)) + 1, ValTotal,MinPolice);

        NbLigne := NbLigne + 1;
      end;
    ListPage.Destroy;

    // Dessin Ambitions
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautAmb, DessinDebColG, DessinDebutHautAmb - (DessinNbLigAmb * DessinHauteurAmb), 1);
    PdfPage.DrawLine( 39.9, DessinDebutHautAmb - DessinHauteurAmb, 39.9, DessinDebutHautAmb - (DessinNbLigAmb * DessinHauteurAmb), 1);
    PdfPage.DrawLine( DessinFinColG, DessinDebutHautAmb, DessinFinColG, DessinDebutHautAmb - (DessinNbLigAmb * DessinHauteurAmb), 1);
    for IndC := 0 to DessinNbLigAmb do
      PdfPage.DrawLine(20,DessinDebutHautAmb - (indC * DessinHauteurAmb), DessinFinColG, DessinDebutHautAmb - (indC * DessinHauteurAmb), 1);
    DessinDebutHautRes := DessinDebutHautAmb - (indC * DessinHauteurAmb) - 3;
    DessinDebutHautDes := DessinDebutHautAmb - (indC * DessinHauteurAmb) - 3;
    // Texte Ambitions
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, 22, DessinFinColG, DessinDebutHautAmb - (1 * DessinHauteurAmb) + 1,GetTexteLibelle('PDF_AMBITION1_AMBITIONS'));
    PdfEcrit(PdfPage, 22, 39.9, DessinDebutHautAmb - (2 * DessinHauteurAmb) + 1, GetTexteLibelle('PDF_AMBITION2A_SHORT')+GetTexteLibelle('PDF_AMBITION2B_SHORT'),MinPolice);
    PdfEcrit(PdfPage, 22, 39.9, DessinDebutHautAmb - (3 * DessinHauteurAmb) + 1, GetTexteLibelle('PDF_AMBITION3A_LONG')+GetTexteLibelle('PDF_AMBITION3B_LONG'),MinPolice);

    // Dessin Résilience
    PdfPage.DrawLine( DessinDebColG, DessinDebutHautRes, DessinDebColG, DessinDebutHautRes - (DessinNbLigRes * DessinHauteurRes), 1);
    PdfPage.DrawLine( 49.9, DessinDebutHautRes - DessinHauteurRes, 49.9, DessinDebutHautRes - (DessinNbLigRes * DessinHauteurRes), 1);
    PdfPage.DrawLine( 60, DessinDebutHautRes, 60, DessinDebutHautRes - ((DessinNbLigRes-1) * DessinHauteurRes), 1);
    PdfPage.DrawLine( 89, DessinDebutHautRes - DessinHauteurRes, 89, DessinDebutHautRes - ((DessinNbLigRes-1) * DessinHauteurRes), 1);
    PdfPage.DrawLine( DessinFinColG, DessinDebutHautRes, DessinFinColG, DessinDebutHautRes - (DessinNbLigRes * DessinHauteurRes), 1);
    for IndC := 0 to DessinNbLigRes do
      PdfPage.DrawLine(20,DessinDebutHautRes - (indC * DessinHauteurRes), DessinFinColG, DessinDebutHautRes - (indC * DessinHauteurRes), 1);
    // Texte Résilience
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage,22,62,DessinDebutHautRes - (1 * DessinHauteurRes) + 1, GetTexteLibelle('PDF_RESIL1_RESILIENCE'));
    PdfEcrit(PdfPage,22,62,DessinDebutHautRes - (2 * DessinHauteurRes) + 1, GetTexteLibelle('PDF_RESIL2A_RESILIENCE'),MinPolice);
    PdfEcrit(PdfPage,22,62,DessinDebutHautRes - (3 * DessinHauteurRes) + 1, GetTexteLibelle('PDF_RESIL2B_RESOLVE'),MinPolice);
    PdfEcrit(PdfPage,22,69,DessinDebutHautRes - (DessinNbLigRes * DessinHauteurRes) + 1, GetTexteLibelle('PDF_RESIL2C_MOTIVATION'),MinPolice);
    // Valeur Résilience
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracResil, Bonus);
    PdfCentre(PdfPage,50,60, DessinDebutHautRes - (2 * DessinHauteurRes) + 1,IntToStr(AttributDonnee.Total));          // Résilience
    PdfCentre(PdfPage,50,60, DessinDebutHautRes - (3 * DessinHauteurRes) + 1,IntToStr(Determine));                     // Détermination

    //DessinDebutHautBle := DessinDebutHautDes - (indC * DessinHauteurDes) - 3;
    DessinDebutHautExp := DessinDebutHautDes - (indC * DessinHauteurDes) - 3;
    // Texte Destin
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage,62,DessinFinColG,DessinDebutHautDes - (1 * DessinHauteurDes) + 1, GetTexteLibelle('PDF_FATE1_FATE'));
    PdfEcrit(PdfPage,62,89,DessinDebutHautDes - (2 * DessinHauteurDes) + 1, GetTexteLibelle('PDF_FATE2_FATE'),MinPolice);
    PdfEcrit(PdfPage,62,89,DessinDebutHautDes - (3 * DessinHauteurDes) + 1, GetTexteLibelle('PDF_FATE3_FORTUNE'),MinPolice);
    // Valeur Destin
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracDestin, Bonus);
    PdfCentre(PdfPage,89,DessinFinColG, DessinDebutHautDes - (2 * DessinHauteurDes) + 1,IntToStr(AttributDonnee.Total));          // Destin
    PdfCentre(PdfPage,89,DessinFinColG, DessinDebutHautDes - (3 * DessinHauteurDes) + 1,IntToStr(Chance));                        // Chance

    //// Dessin Blessure
    //PdfPage.DrawLine( DessinDebColG , DessinDebutHautBle, DessinDebColG, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    //PdfPage.DrawLine( 47 , DessinDebutHautBle - (4 * DessinHauteurBle), 47, DessinDebutHautBle - (5 * DessinHauteurBle), 1);
    //PdfPage.DrawLine( 66 , DessinDebutHautBle - (1 * DessinHauteurBle), 66, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    //PdfPage.DrawLine( 79 , DessinDebutHautBle - (1 * DessinHauteurBle), 79, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    //PdfPage.DrawLine( DessinFinColG, DessinDebutHautBle, DessinFinColG, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    //for IndC := 0 to DessinNbLigBle do
    //  if (IndC < 2) or (IndC = DessinNbLigBle) then
    //    PdfPage.DrawLine(DessinDebColG,DessinDebutHautBle - (indC * DessinHauteurBle), DessinFinColG, DessinDebutHautBle - (indC * DessinHauteurBle), 1)
    //  else
    //    PdfPage.DrawLine(DessinDebColG,DessinDebutHautBle - (indC * DessinHauteurBle), 79, DessinDebutHautBle - (indC * DessinHauteurBle), 1);
    //// Texte Blessure
    //PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    //PdfCentre(PdfPage,22,DessinFinColG,DessinDebutHautBle - (1 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS1_WOUNDS'));
    //PdfEcrit(PdfPage,22,79,DessinDebutHautBle - (2 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BS'),MinPolice);
    //PdfEcrit(PdfPage,22,79,DessinDebutHautBle - (3 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BT'),MinPolice);
    //PdfEcrit(PdfPage,22,79,DessinDebutHautBle - (4 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BWP'),MinPolice);
    //PdfEcrit(PdfPage,22,47,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS5_HARDY'),MinPolice);
    //PdfEcrit(PdfPage,22,79,DessinDebutHautBle - (6 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_Tot'),MinPolice);
    //// Valeur Blessure
    //Ch := IntToStr(Floor(BF/10));
    //if Length(Ch) = 1 then Ch := ' '+Ch;
    //PdfCentre(PdfPage,66,79,DessinDebutHautBle - (2 * DessinHauteurBle) + 1, Ch);
    //Ch := IntToStr(Floor(BE/10)*2);
    //if Length(Ch) = 1 then Ch := ' '+Ch;
    //PdfCentre(PdfPage,66,79,DessinDebutHautBle - (3 * DessinHauteurBle) + 1, Ch);
    //Ch := IntToStr(Floor(BFM/10));
    //if Length(Ch) = 1 then Ch := ' '+Ch;
    //PdfCentre(PdfPage,66,79,DessinDebutHautBle - (4 * DessinHauteurBle) + 1, Ch);
    //if DurACuire > 0 then
    //  begin
    //    Ch := IntToStr(DurACuire);
    //    if Length(Ch) = 1 then Ch := ' '+Ch;
    //    PdfCentre(PdfPage,47,66,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, IntToStr(ValDurACuire));
    //    PdfCentre(PdfPage,66,79,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, Ch);
    //  end;
    //PRaceAttribut := ChercheRaceAttribut(Personnage.Race, ConstCaracBlessure);
    //Ch := IntToStr(CalculBlessure(PRaceAttribut.CalculRace, BF, BE, BFM) + DurACuire);
    //if Length(Ch) = 1 then Ch := ' '+Ch;
    //PdfCentre(PdfPage,66,79,DessinDebutHautBle - (6 * DessinHauteurBle) + 1, Ch);

    // calcul expérience
    for PersonnageXpAttribut in Personnage.XpCoutAttribut do
      begin
        TotalXpSoustrait := TotalXpSoustrait + PersonnageXpAttribut.CoutXp;
        PAttributAugmentation := ChercheAttributAugmentation(PersonnageXpAttribut.Debut, PersonnageXpAttribut.Fin);
        TotalXpSoustrait := TotalXpSoustrait - ((PersonnageXpAttribut.Fin - PersonnageXpAttribut.Debut)  * PAttributAugmentation.Cout);
      end;
    for PersonnageXpCompetence in Personnage.XpCoutCompetence do
      begin
        TotalXpSoustrait := TotalXpSoustrait + PersonnageXpCompetence.CoutXp;
        PCompetenceAugmentation := ChercheCompetenceAugmentation(PersonnageXpCompetence.Debut, PersonnageXpCompetence.Fin);
        TotalXpSoustrait := TotalXpSoustrait - ((PersonnageXpCompetence.Fin - PersonnageXpCompetence.Debut)  * PCompetenceAugmentation.Cout);
      end;
    for PersonnageXpTalent in Personnage.XpCoutTalent do
      TotalXpSoustrait := TotalXpSoustrait + PersonnageXpAttribut.CoutXp - (100 + (PersonnageXpCompetence.Fin - PersonnageXpCompetence.Debut - 1) * 100);

    // Dessin Expérience
    DessinDebutHautExp := DessinDebutHautDes - (DessinNbLigRes * DessinHauteurDes) - 3;
    DessinDebutHautMou := DessinDebutHautDes - (DessinNbLigRes * DessinHauteurDes) - 3;
    PdfPage.DrawLine( DessinDebColG      , DessinDebutHautExp                         , DessinDebColG      , DessinDebutHautExp - ((DessinNbLigExp + 1) * DessinHauteurExp), 1);
    PdfPage.DrawLine( DessinDebColG +  15, DessinDebutHautExp - (1 * DessinHauteurExp), DessinDebColG +  15, DessinDebutHautExp - ((DessinNbLigExp + 1) * DessinHauteurExp), 1);
    PdfPage.DrawLine( DessinLargeurExp   , DessinDebutHautExp                         , DessinLargeurExp   , DessinDebutHautExp - ((DessinNbLigExp + 1) * DessinHauteurExp), 1);
    for IndC := 0 to (DessinNbLigExp + 1) do
      PdfPage.DrawLine(DessinDebColG,DessinDebutHautExp - (indC * DessinHauteurExp), DessinLargeurExp, DessinDebutHautExp - (indC * DessinHauteurExp), 1);
    // Expérience
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebColG + 1, DessinLargeurExp  , DessinDebutHautExp - ((DessinNbLigExp - 2) * DessinHauteurExp) + 0.6, GetTexteLibelle('PDF_XP1_EXPERIENCE'));
    PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautExp - ((DessinNbLigExp - 1) * DessinHauteurExp) + 0.6, GetTexteLibelle('PDF_XP2C_TOTAL')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautExp - ((DessinNbLigExp - 0) * DessinHauteurExp) + 0.6, GetTexteLibelle('PDF_XP2B_SPENT')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautExp - ((DessinNbLigExp + 1) * DessinHauteurExp) + 0.6, GetTexteLibelle('PDF_XP2A_CURRENT')    , MinPolice);
    // Valeur Expérience
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfCentre(PdfPage,  DessinDebColG + 15, DessinLargeurExp, DessinDebutHautExp - ((DessinNbLigExp - 1) * DessinHauteurExp) + 0.6, IntToStr(Trunc(Personnage.Xp25Total)));                      // Total Xp
    PdfCentre(PdfPage,  DessinDebColG + 15, DessinLargeurExp, DessinDebutHautExp - ((DessinNbLigExp - 0) * DessinHauteurExp) + 0.6, IntToStr(Trunc(Personnage.Xp25Total - personnage.XpActuel)));// Utilisé
    PdfCentre(PdfPage,  DessinDebColG + 15, DessinLargeurExp, DessinDebutHautExp - ((DessinNbLigExp + 1) * DessinHauteurExp) + 0.6, IntToStr(Trunc(Personnage.XpActuel)));                       // Restant

    // Dessin Mouvement
    DessinDebutHautMou   := DessinDebutHautDes - (DessinNbLigRes * DessinHauteurDes) - 3;
    DessinDebutGaucheMou := DessinLargeurExp + 3;
    PdfPage.DrawLine( DessinDebutGaucheMou      , DessinDebutHautMou                         , DessinDebutGaucheMou      , DessinDebutHautMou - ((DessinNbLigMou + 1) * DessinHauteurMou), 1);
    PdfPage.DrawLine( DessinDebutGaucheMou +  15, DessinDebutHautMou - (1 * DessinHauteurMou), DessinDebutGaucheMou +  15, DessinDebutHautMou - ((DessinNbLigMou + 1) * DessinHauteurMou), 1);
    PdfPage.DrawLine( DessinDebutGaucheMou + DessinLargeurMou   , DessinDebutHautMou                         , DessinDebutGaucheMou + DessinLargeurMou   , DessinDebutHautMou - ((DessinNbLigMou + 1) * DessinHauteurMou), 1);
    for IndC := 0 to (DessinNbLigMou + 1) do
      PdfPage.DrawLine(DessinDebutGaucheMou, DessinDebutHautMou - (indC * DessinHauteurMou), DessinDebutGaucheMou + DessinLargeurMou, DessinDebutHautMou - (indC * DessinHauteurMou), 1);
    // Mouvement
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebutGaucheMou + 1, DessinDebutGaucheMou + DessinLargeurMou  , DessinDebutHautMou - ((DessinNbLigMou - 2) * DessinHauteurMou) + 0.6, GetTexteLibelle('PDF_MV1_MOVEMENT'));
    PdfEcrit(PdfPage,  DessinDebutGaucheMou + 1, DessinDebutGaucheMou + 15, DessinDebutHautMou - ((DessinNbLigMou - 1) * DessinHauteurMou) + 0.6, GetTexteLibelle('PDF_MV2A_MOVEMENT')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebutGaucheMou + 1, DessinDebutGaucheMou + 15, DessinDebutHautMou - ((DessinNbLigMou - 0) * DessinHauteurMou) + 0.6, GetTexteLibelle('PDF_MV2B_WALK')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebutGaucheMou + 1, DessinDebutGaucheMou + 15, DessinDebutHautMou - ((DessinNbLigMou + 1) * DessinHauteurMou) + 0.6, GetTexteLibelle('PDF_MV2C_RUN')    , MinPolice);
    // Valeur Mouvement
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfCentre(PdfPage,  DessinDebutGaucheMou + 15, DessinDebutGaucheMou + DessinLargeurMou, DessinDebutHautMou - ((DessinNbLigMou - 1) * DessinHauteurMou) + 0.6, IntToStr(Mouv));
    PdfCentre(PdfPage,  DessinDebutGaucheMou + 15, DessinDebutGaucheMou + DessinLargeurMou, DessinDebutHautMou - ((DessinNbLigMou - 0) * DessinHauteurMou) + 0.6, IntToStr(Mouv * 2));
    PdfCentre(PdfPage,  DessinDebutGaucheMou + 15, DessinDebutGaucheMou + DessinLargeurMou, DessinDebutHautMou - ((DessinNbLigMou + 1) * DessinHauteurMou) + 0.6, IntToStr((Mouv + BonusSprint)*4));

    // Dessin Corruption
    DessinDebutHautCor   := DessinDebutHautDes - (DessinNbLigRes * DessinHauteurDes) - 3;
    DessinDebutGaucheCor := DessinDebutGaucheMou + DessinLargeurMou + 3;
    DessinLargeurCor     := DessinFinColG - DessinDebutGaucheCor;
    PdfPage.DrawLine( DessinDebutGaucheCor      , DessinDebutHautCor                         , DessinDebutGaucheCor      , DessinDebutHautCor - ((DessinNbLigCor + 1) * DessinHauteurCor), 1);
    PdfPage.DrawLine( DessinDebutGaucheCor +  15, DessinDebutHautCor - (1 * DessinHauteurCor), DessinDebutGaucheCor +  15, DessinDebutHautCor - ((DessinNbLigCor + 1) * DessinHauteurCor), 1);
    PdfPage.DrawLine( DessinDebutGaucheCor + DessinLargeurCor   , DessinDebutHautCor                         , DessinDebutGaucheCor + DessinLargeurCor   , DessinDebutHautCor - ((DessinNbLigCor + 1) * DessinHauteurCor), 1);
    for IndC := 0 to (DessinNbLigCor + 1) do
      PdfPage.DrawLine(DessinDebutGaucheCor, DessinDebutHautCor - (indC * DessinHauteurCor), DessinDebutGaucheCor + DessinLargeurCor, DessinDebutHautCor - (indC * DessinHauteurCor), 1);
    // Corruption
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebutGaucheCor + 1, DessinDebutGaucheCor + DessinLargeurCor  , DessinDebutHautCor - ((DessinNbLigCor - 3) * DessinHauteurCor) + 0.6, GetTexteLibelle('PDF_CORRUPTION_TITLE'));
    PdfEcrit(PdfPage,  DessinDebutGaucheCor + 1, DessinDebutGaucheCor + 15, DessinDebutHautCor - ((DessinNbLigCor - 2) * DessinHauteurCor) + 0.6, GetTexteLibelle('PDF_CORRUPTION_T')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebutGaucheCor + 1, DessinDebutGaucheCor + 15, DessinDebutHautCor - ((DessinNbLigCor - 1) * DessinHauteurCor) + 0.6, GetTexteLibelle('PDF_CORRUPTION_WP')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebutGaucheCor + 1, DessinDebutGaucheCor + 15, DessinDebutHautCor - ((DessinNbLigCor - 0) * DessinHauteurCor) + 0.6, GetTexteLibelle('PDF_CORRUPTION_BONUS')      , MinPolice);
    PdfEcrit(PdfPage,  DessinDebutGaucheCor + 1, DessinDebutGaucheCor + 15, DessinDebutHautCor - ((DessinNbLigCor + 1) * DessinHauteurCor) + 0.6, GetTexteLibelle('PDF_CORRUPTION_TOTAL')    , MinPolice);
    // Valeur Corruption
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfCentre(PdfPage,  DessinDebutGaucheCor + 15, DessinDebutGaucheCor + DessinLargeurCor, DessinDebutHautCor - ((DessinNbLigCor - 2) * DessinHauteurCor) + 0.6, IntToStr(Floor(BE/10)));
    PdfCentre(PdfPage,  DessinDebutGaucheCor + 15, DessinDebutGaucheCor + DessinLargeurCor, DessinDebutHautCor - ((DessinNbLigCor - 1) * DessinHauteurCor) + 0.6, IntToStr(Floor(BFM/10)));
    PdfCentre(PdfPage,  DessinDebutGaucheCor + 15, DessinDebutGaucheCor + DessinLargeurCor, DessinDebutHautCor - ((DessinNbLigCor - 0) * DessinHauteurCor) + 0.6, IntToStr(AmePure));
    PdfCentre(PdfPage,  DessinDebutGaucheCor + 15, DessinDebutGaucheCor + DessinLargeurCor, DessinDebutHautCor - ((DessinNbLigCor + 1) * DessinHauteurCor) + 0.6, IntToStr(Floor(BE/10) + Floor(BFM/10) + AmePure));


    //// Dessin PCM
    //PdfPage.DrawLine( DessinDebColG     , DessinDebutHautPCM     , DessinDebColG + 28, DessinDebutHautPCM     , 1);
    //PdfPage.DrawLine( DessinDebColG + 30, DessinDebutHautPCM     , DessinDebColG + 52, DessinDebutHautPCM     , 1);
    //PdfPage.DrawLine( DessinDebColG + 54, DessinDebutHautPCM     , DessinDebColG + 78, DessinDebutHautPCM     , 1);
    //PdfPage.DrawLine( DessinDebColG     , DessinDebutHautPCM -  4, DessinDebColG + 28, DessinDebutHautPCM -  4, 1);
    //PdfPage.DrawLine( DessinDebColG + 30, DessinDebutHautPCM -  4, DessinDebColG + 52, DessinDebutHautPCM -  4, 1);
    //PdfPage.DrawLine( DessinDebColG + 54, DessinDebutHautPCM -  4, DessinDebColG + 78, DessinDebutHautPCM -  4, 1);
    //PdfPage.DrawLine( DessinDebColG     , DessinDebutHautPCM - 19, DessinDebColG + 28, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 30, DessinDebutHautPCM - 19, DessinDebColG + 52, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 54, DessinDebutHautPCM - 19, DessinDebColG + 78, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG     , DessinDebutHautPCM     , DessinDebColG     , DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 28, DessinDebutHautPCM     , DessinDebColG + 28, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 30, DessinDebutHautPCM     , DessinDebColG + 30, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 52, DessinDebutHautPCM     , DessinDebColG + 52, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 54, DessinDebutHautPCM     , DessinDebColG + 54, DessinDebutHautPCM - 19, 1);
    //PdfPage.DrawLine( DessinDebColG + 78, DessinDebutHautPCM     , DessinDebColG + 78, DessinDebutHautPCM - 19, 1);

    // Dessin compétences groupées
    PdfPage.DrawLine( DessinDebColD, DessinDebutHautComg, DessinFinColD, DessinDebutHautComg, 1);
    PdfPage.DrawLine( DessinDebColD, DessinDebutHautComg, DessinDebColD, DessinDebutHautComg - (DessinNbLigComg * DessinHauteurComg), 1);
    for IndC := 0 to DessinNbColComg do
      if Indc = DessinNbColComg then
        PdfPage.DrawLine( 143 + (IndC * DessinLargeurComg), DessinDebutHautComg, 143  + (IndC * DessinLargeurComg), DessinDebutHautComg - (DessinNbLigComg * DessinHauteurComg), 1)
      else if Indc = 1 then
        PdfPage.DrawLine( 143 + (IndC * DessinLargeurComg), DessinDebutHautComg - (DessinHauteurComg * 2), 143  + (IndC * DessinLargeurComg), DessinDebutHautComg - (DessinNbLigComg * DessinHauteurComg), 1)
      else
        PdfPage.DrawLine( 143 + (IndC * DessinLargeurComg), DessinDebutHautComg - DessinHauteurComg, 143  + (IndC * DessinLargeurComg), DessinDebutHautComg - (DessinNbLigComg * DessinHauteurComg), 1);
    for IndC := 0 to DessinNbLigComg do
      PdfPage.DrawLine(DessinDebColD,DessinDebutHautComg - (indC * DessinHauteurComg), DessinFinColD, DessinDebutHautComg - (indC * DessinHauteurComg), 1);
    DessinDebutHautTal := DessinDebutHautComg - (DessinNbLigComg * DessinHauteurComg) - 3;
    // Texte compétences groupées
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebColD + 15, DessinFinColD, DessinDebutHautComg - (1 * DessinHauteurComg) + 1, Trim(GetTexteLibelle('PDF_SKILLS1_ADVANCED')));
    PdfEcrit(PdfPage, DessinDebColD + 5, 148, DessinDebutHautComg - (2 * DessinHauteurComg) + 1,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
    PdfCentre(PdfPage, 143 + (0 * DessinLargeurComg) + 1, 143 + (2 * DessinLargeurComg), DessinDebutHautComg - (2 * DessinHauteurComg) + 1,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
    PdfCentre(PdfPage, 143 + (2 * DessinLargeurComg) + 1, 143 + (3 * DessinLargeurComg), DessinDebutHautComg - (2 * DessinHauteurComg) + 1,GetTexteLibelle('PDF_SKILLS2_UPG'));
    PdfCentre(PdfPage, 143 + (3 * DessinLargeurComg) + 1, 143 + (4 * DessinLargeurComg), DessinDebutHautComg - (2 * DessinHauteurComg) + 1,GetTexteLibelle('PDF_SKILLS2_ADV'));
    PdfCentre(PdfPage, 143 + (4 * DessinLargeurComg) + 1, 143 + (5 * DessinLargeurComg), DessinDebutHautComg - (2 * DessinHauteurComg) + 1,GetTexteLibelle('PDF_SKILLS2_TOTAL'));
    // Valeur Compétences groupées
    NbLigne := 0;
    for IndC := 0 to ListCompetence.Count-1 do
      begin
        PCompetence   := ListCompetence[IndC];
        if (pos(PCompetence.CodeCompetence, ListPris) = 0) then
          begin
            CompetenceDonnee := PdfPersonnageCompetence(Personnage, PCompetence.CodeCompetence, NivCompMetier);
            if CompetenceDonnee.Augmentation <> 0 then
              begin
                ValStat     := IntToStr(CompetenceDonnee.Base);
                ValBonus    := IntToStr(CompetenceDonnee.Augmentation);
                ValTotal    := IntToStr(CompetenceDonnee.Total);
                if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
                  ValBonus := '  ' + ValBonus;
                //PCompetence := ChercheCompetence(PCompetence.CodeCompetence);
                // gérer les astérisques
                Bonus       := PdfPersonnageCompetenceBonus(Personnage, Comp);
                if Bonus <> '' then
                  begin
                    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceArial, 6);
                    PdfEcrit(PdfPage, 138, 143 , DessinDebutHautComp - (DessinHauteurComp * (NbLigne+3)) + 2, Bonus, 6);
                  end;
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
                PdfEcrit(PdfPage, 105 , 143, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle),MinPolice);
                PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
                PdfEcrit(PdfPage, 143 + (0 * DessinLargeurComg) + 2.5, 143 + (1 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, GetTexteLibelle(PAttribut.Resume),MinPolice);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
                PdfEcrit(PdfPage, 143 + (1 * DessinLargeurComg) + 2.5, 143 + (2 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, ValStat,MinPolice);
                if (NivCompMetier > 0) then
                  begin
                    if (NivCompMetier > Personnage.MetierEnCours.NiveauMetier) then
                      PdfPage.SetColor(RGB(150,150,150), False);
                    PdfEcrit(PdfPage, 143 + (2 * DessinLargeurComg) + 2.5, 143 + (3 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, IntToStr(NivCompMetier),MinPolice);
                    PdfPage.SetColor(clBlack, False);
                  end;
                PdfEcrit(PdfPage, 143 + (3 * DessinLargeurComg) + 2.5, 143 + (4 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, ValBonus,MinPolice);
                PdfEcrit(PdfPage, 143 + (4 * DessinLargeurComg) + 2.5, 143 + (5 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, ValTotal,MinPolice);
                NbLigne := NbLigne + 1;
              end;
          end;
      end;
    // Valeur Compétences groupées non prises
    PdfPage.SetColor(RGB(150,150,150), False);
    for PersonnageCompetence in Personnage.MetierCompetence do
      begin
        CompetenceDonnee := PdfPersonnageCompetence(Personnage, PersonnageCompetence.CodeCompetence, NivCompMetier);
        if (CompetenceDonnee.Augmentation = 0) and (NivCompMetier > 0) then
          begin
            if (pos(PersonnageCompetence.CodeCompetence, ListPris) = 0) and (NbLigne < (DessinNbLigComg - 2)) then
              begin
                ValStat     := IntToStr(CompetenceDonnee.Base);
                ValBonus    := IntToStr(CompetenceDonnee.Augmentation);
                ValTotal    := IntToStr(CompetenceDonnee.Total);
                PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
                PdfEcrit(PdfPage, 105 , 143, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle),MinPolice);
                PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
                PdfEcrit(PdfPage, 143 + (0 * DessinLargeurComg) + 2.5, 143 + (1 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, GetTexteLibelle(PAttribut.Resume),MinPolice);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
                PdfEcrit(PdfPage, 143 + (1 * DessinLargeurComg) + 2.5, 143 + (2 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, ValStat,MinPolice);
                if (NivCompMetier > 0) then
                  PdfEcrit(PdfPage, 143 + (2 * DessinLargeurComg) + 2.5, 143 + (3 * DessinLargeurComg) + 2.5, DessinDebutHautComg - (DessinHauteurComg * (NbLigne+3)) + 1, IntToStr(NivCompMetier),MinPolice);
                NbLigne := NbLigne + 1;
              end;
          end;
        end;
    PdfPage.SetColor(clBlack, False);

    // Dessin Talents
    PdfPage.DrawLine( DessinDebColD, DessinDebutHautTal, DessinDebColD, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinDebColD + 41, DessinDebutHautTal - (1 * DessinHauteurTal), DessinDebColD + 41, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinDebColD + 47, DessinDebutHautTal - (1 * DessinHauteurTal), DessinDebColD + 47, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinDebColD + 53, DessinDebutHautTal - (1 * DessinHauteurTal), DessinDebColD + 53, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinFinColD, DessinDebutHautTal, DessinFinColD, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    for IndC := 0 to DessinNbLigTal do
      PdfPage.DrawLine(DessinDebColD,DessinDebutHautTal - (indC * DessinHauteurTal), DessinFinColD, DessinDebutHautTal - (indC * DessinHauteurTal), 1);
    // Texte Talents
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebColD, DessinFinColD, DessinDebutHautTal - (1 * DessinHauteurTal) + 1, Trim(GetTexteLibelle('PDF_TALENT1_TALENTS')));
    PdfCentre(PdfPage, DessinDebColD, DessinDebColD + 40, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_TALENTNAME'));
    PdfCentre(PdfPage, DessinDebColD + 41, DessinDebColD + 47, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_UPG'));
    PdfCentre(PdfPage, DessinDebColD + 47, DessinDebColD + 51, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_LEVEL'));
    PdfCentre(PdfPage, DessinDebColD + 53, DessinFinColD, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_DESC'));
    // Valeur Talents
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    NbLigne := 0;
    For IndC := 0 to ListTalent.count - 1 do
      begin
        PTalent := ListTalent[IndC];
        NivTalMetier := 0;
        TalentDonnee := PdfPersonnageTalent(Personnage, PTalent.CodeTalent, NivTalMetier);
        if TalentDonnee.Total <> 0 then
          begin
            inc(NbLigne);
            PdfEcrit(PdfPage, DessinDebColD + 2, DessinDebColD + 41, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, PTalent.Libelle, MinPolice);
            Bonus := PdfPersonnageTalentBonus(Personnage, PTalent.CodeTalent);
            // Afficher l'astérisque pour les talents
            if Bonus <> '' then
              begin
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 4);
                PdfEcrit(PdfPage, DessinDebColD + 38, DessinDebColD + 41, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 3, Bonus, 4);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
              end;
            if (NivTalMetier > 0) then
              begin
                if (NivTalMetier > Personnage.MetierEnCours.NiveauMetier) then
                  PdfPage.SetColor(RGB(150,150,150), False);
                PdfEcrit(PdfPage, DessinDebColD + 43, DessinDebColD + 47, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, IntToStr(NivTalMetier),MinPolice);
                PdfPage.SetColor(clBlack, False);
              end;
            PdfCentre(PdfPage, DessinDebColD + 47, DessinDebColD + 53, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, IntToStr(TalentDonnee.Total));
            if PTalent.SousTalent then
              PTalent := ChercheTalent(Copy(PTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
            if PTalent.Resume <> '' then
              begin
                if Length(PTalent.Resume) > 20 then
                  PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1.5, PTalent.Resume, MinPolice)
                else
                  PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, PTalent.Resume, MinPolice);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
              end;
            ListeTalent += AjouteAccolade(PTalent.CodeTalent);
          end;
      end;
    // Valeur Talents non acquis
    PdfPage.SetColor(RGB(150,150,150), False);
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    For PMetierTalent In ListMetierTalent do
      if (PMetierTalent.CodeMetier = Personnage.MetierEnCours.CodeMetier) then
        if (PMetierTalent.NiveauMetier >= Personnage.MetierEnCours.NiveauMetier) then
          if (Pos(AjouteAccolade(PMetierTalent.CodeTalent),ListeTalent) = 0)  and (NbLigne < (DessinNbLigTal - 2)) then
            begin
              PTalent := chercheTalent(PMetierTalent.CodeTalent);
              PdfEcrit(PdfPage, DessinDebColD +  2, DessinDebColD + 41, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1, PTalent.Libelle, MinPolice);
              PdfEcrit(PdfPage, DessinDebColD + 43, DessinDebColD + 47, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1, InttoStr(PMetierTalent.NiveauMetier), MinPolice);
              if PTalent.SousTalent then
                PTalent := ChercheTalent(Copy(PTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
              if PTalent.Resume <> '' then
                begin
                  if Length(PTalent.Resume) > 20 then
                    PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1.5, PTalent.Resume, MinPolice)
                  else
                    PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1, PTalent.Resume, MinPolice);
                  PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
                end;
              NbLigne := NbLigne + 1;
            end;
    PdfPage.SetColor(clBlack, False);


   // PAGE 2
     PdfPage         := PDFDoc.Pages.AddPage;
     PdfSection.AddPage(PdfPage);
     PdfPage.PaperType:= ptA4;
     PdfPage.UnitOfMeasure := uomMillimeters;
     PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
     // Dessin Armures
     DessinDebutHautArm := DessinDebutHautEntete;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautArm, DessinDebColG, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG +  0, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG +  0, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 34, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 34, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 53, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 53, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 62, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 62, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 70, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 70, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinLargeurArm, DessinDebutHautArm, DessinLargeurArm, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     for IndC := 0 to (DessinNbLigArm + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautArm - (indC * DessinHauteurArm), DessinLargeurArm, DessinDebutHautArm - (indC * DessinHauteurArm), 1);
     // Texte Armure
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurArm  , DessinDebutHautArm - (1 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR1_ARMOUR'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 34, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  34, DessinDebColG + 53, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_LOCATIONS'));
     PdfCentre(PdfPage, DessinDebColG +  53, DessinDebColG + 62, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_ENCUMBRANCE'));
     PdfCentre(PdfPage, DessinDebColG +  62, DessinDebColG + 70, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_ARMOURPOINT'));
     PdfCentre(PdfPage, DessinDebColG +  70, DessinLargeurArm  , DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_QUALITIES'));
     // Dessin Equipement
     DessinDebutHautEqu := DessinDebutHautArm - (indC * DessinHauteurArm) - 3;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautEqu, DessinDebColG, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG +   0, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG +   0, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG +  48, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG +  48, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG +  55, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG +  55, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG + 100, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG + 100, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinLargeurEqu, DessinDebutHautEqu, DessinLargeurEqu, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     for IndC := 0 to (DessinNbLigEqu + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautEqu - (indC * DessinHauteurEqu), DessinLargeurEqu, DessinDebutHautEqu - (indC * DessinHauteurEqu), 1);
     // Texte Equipement
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurEqu  , DessinDebutHautEqu - (1 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING1_TRAPPINGS'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 48, DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  48, DessinDebColG + 55, DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_ENCUMBRANCE'));
     PdfCentre(PdfPage, DessinDebColG +  55, DessinDebColG +100, DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_NAME'));
     PdfCentre(PdfPage, DessinDebColG + 100, DessinLargeurEqu  , DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_ENCUMBRANCE'));
     // Dessin Armes
     DessinDebutHautWea := DessinDebutHautEqu - (indC * DessinHauteurEqu) - 3;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautWea, DessinDebColG, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +   0, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +   0, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  45, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  45, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  64, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  64, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  71, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  71, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  96, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  96, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG + 113, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG + 113, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinLargeurWea, DessinDebutHautWea, DessinLargeurWea, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     for IndC := 0 to (DessinNbLigWea + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautWea - (indC * DessinHauteurWea), DessinLargeurWea, DessinDebutHautWea - (indC * DessinHauteurWea), 1);
     // Texte Armes
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurWea  , DessinDebutHautWea - (1 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS1_WEAPONS'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 45, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  45, DessinDebColG + 64, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_GROUP'));
     PdfCentre(PdfPage, DessinDebColG +  64, DessinDebColG + 71, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_ENCUMBRANCE'));
     PdfCentre(PdfPage, DessinDebColG +  71, DessinDebColG + 96, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_RANGE'));
     PdfCentre(PdfPage, DessinDebColG +  96, DessinDebColG +113, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_DAMAGE'));
     PdfCentre(PdfPage, DessinDebColG + 113, DessinLargeurWea  , DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_QUALITIES'));
     // Dessin Sorts
     DessinDebutHautSor := DessinDebutHautWea - (indC * DessinHauteurWea) - 3;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautSor, DessinDebColG, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +   0, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +   0, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  38, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  38, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  51, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  51, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  66, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  66, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  82, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  82, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  98, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  98, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinLargeurSor, DessinDebutHautSor, DessinLargeurSor, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     for IndC := 0 to (DessinNbLigSor + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautSor - (indC * DessinHauteurSor), DessinLargeurSor, DessinDebutHautSor - (indC * DessinHauteurSor), 1);
     // Texte Sorts
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurSor  , DessinDebutHautSor - (1 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL1_SPELL'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 38, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  38, DessinDebColG + 51, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_CN'));
     PdfCentre(PdfPage, DessinDebColG +  51, DessinDebColG + 66, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_RANGE'));
     PdfCentre(PdfPage, DessinDebColG +  66, DessinDebColG + 82, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_TARGET'));
     PdfCentre(PdfPage, DessinDebColG +  82, DessinDebColG + 98, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_DURATION'));
     PdfCentre(PdfPage, DessinDebColG +  98, DessinLargeurSor  , DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_EFFECT'));
     // Encombrement
     DessinDebutHautEnc := DessinDebutHautSor - (indC * DessinHauteurSor) - 3;
     PdfPage.DrawLine( DessinDebColG      , DessinDebutHautEnc                         , DessinDebColG      , DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc), 1);
     PdfPage.DrawLine( DessinDebColG +  15, DessinDebutHautEnc - (1 * DessinHauteurEnc), DessinDebColG +  15, DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc), 1);
     PdfPage.DrawLine( DessinLargeurEnc   , DessinDebutHautEnc                         , DessinLargeurEnc   , DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc), 1);
     for IndC := 0 to (DessinNbLigEnc + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautEnc - (indC * DessinHauteurEnc), DessinLargeurEnc, DessinDebutHautEnc - (indC * DessinHauteurEnc), 1);
     // Texte Encombrement
     PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
     PdfCentre(PdfPage, DessinDebColG + 1, DessinLargeurEnc  , DessinDebutHautEnc - ((DessinNbLigEnc - 4) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE1_ENCUMBRANCE'));
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 3) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE2_ARMOUR')    , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 2) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE3_WEAPONS')   , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 1) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE4_TRAPPINGS') , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 0) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE5_MAXENC')    , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE6_TOTAL')     , MinPolice);

     // Valeurs Armures, Equipement, Armes
     PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
     EncArme     := 0;
     EncArmure   := 0;
     ArmureBras  := 0;
     ArmureCorps := 0;
     ArmureJambe := 0;
     ArmureTete  := 0;
     NbArme      := 0;
     NbArmure    := 0;
     NbSort      := 0;
     Quality     := '';
     for PersonnageEquipement in Personnage.Equipement do
       begin
         Enc := 0;
         EncP:= 0;
         if PersonnageEquipement.TypeEquipement = TypeEquipWe then
           // gérer les armes
             begin
               TexteRange1:= '';
               TexteRange2:= '';
               PArme      := ChercheArme(PersonnageEquipement.CodeEquipement);

               Portee     := PArme.Portee;
               if Pos('(B'+ConstCaracF+')',Portee) > 0 then
                 begin
                   Portee       := StringReplace(Portee, '(B'+ConstCaracF+')', IntToStr(Trunc(BF/10)), [rfReplaceAll]);;
                   PorteMoyenne := MultiChaine(Portee);
                   Portee       := IntToStr(PorteMoyenne);
                 end
               else
                 PorteMoyenne   := StrToIntDef(Portee,0);

               Enc        := PArme.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement, Quality);
               EncArme    := EncArme + Enc;

               Inc(NbArme);

               Pourcent := '';

               CompetenceDonnee := PdfPersonnageCompetence(Personnage, PArme.CodeCompetence, Bidon);

               Pourcent := IntToStr(CompetenceDonnee.Total);
               PasBonus := (CompetenceDonnee.Augmentation = 0);

               if pos(EquipementCT, PArme.CodeArme) > 0 then
                 begin
                   TexteRange1 := '< : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/10)))+'m '+IntToStr(StrToInt(Pourcent)+40)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/2 )))+'m '+IntToStr(StrToInt(Pourcent)+20)+'%';
                   TexteRange2 := '> : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*2 )))+'m '+IntToStr(StrToInt(Pourcent)-10)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*3 )))+'m '+IntToStr(StrToInt(Pourcent)-30)+'%';
                 end;

               PdfEcrit(PdfPage, DessinDebColG +  1, DessinDebColG + 45, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, PArme.Libelle + Quality, MinPolice);

               LigneBonus := '';

               PdfCentre(PdfPage, DessinDebColG +  45, DessinDebColG + 64, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, Pourcent + ' %');
               if PArme.Encombrement <> 0 then
                 PdfCentre(PdfPage, DessinDebColG +  64, DessinDebColG + 71, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, IntToStr(Enc));
               PdfCentre(PdfPage, DessinDebColG +  71, DessinDebColG + 96, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, GetAllTexteLibelle(Portee));

               Deg   := CalculDegat(PArme.CalculDegat, BF);
               if pos(EquipementCC, PArme.CodeArme) > 0 then
                 Deg := Deg + TBonusCC
               else if pos(EquipementCT, PArme.CodeArme) > 0 then
                 Deg := Deg + TBonusCT;

               if Deg = 0 then
                 PdfCentre(PdfPage, DessinDebColG +  96, DessinDebColG + 113, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, '-')
               else
                 PdfCentre(PdfPage, DessinDebColG +  96, DessinDebColG + 113, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, 'DR + '+IntToStr(Deg));

               PosProtection := pos(BonusProtection, PArme.ListeBonus);
               if PosProtection > 0 then
                 ArmureBouclier := StrToInt(copy(PArme.ListeBonus, PosProtection + Length(BonusProtection), 1));
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);

               if TexteRange1 <> '' then
                 begin
                   PdfEcrit(PdfPage, DessinDebColG + 113 + 40, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, TexteRange1, MinPolice);
                   PdfEcrit(PdfPage, DessinDebColG + 113 + 40, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.3, TexteRange2, MinPolice);
                 end;

               if PasBonus = false then
                 begin
                   LigneBonus := PArme.Listebonus;
                   if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                     begin
                       NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                       for IndLoca := 1 to NbLoca do
                         begin
                           LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                           if pos(' ',LocData) <> 0 then
                             LocData := copy(LocData,1,Length(LocData)-2);
                           PArmeBonus := ChercheArmeBonus(LocData);
                           LigneBonus := StringReplace(LigneBonus, LocData, PArmeBonus.Libelle, [rfReplaceAll]);
                           if Pos(PArmeBonus.CodeArmeBonus, ArmeBonii) = 0 then
                            begin
                              if ArmeBonii <> '' then
                               ArmeBonii := ArmeBonii + ',';
                               ArmeBonii := ArmeBonii + PArmeBonus.CodeArmeBonus;
                            end;
                         end;
                     end;
                   FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
                   if (TexteRange1 = '') then
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, LigneBonus, MinPolice)
                   else
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinDebColG + 113 + 40, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, LigneBonus, MinPolice);
                 end
               else
                 begin
                   PCompetence := ChercheCompetence(PArme.CodeCompetence);
                   ListMalii := 'pas ' + PCompetence.Libelle;

                   if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                     begin
                       NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                       for IndLoca := 1 to NbLoca do
                         begin
                           LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                           if pos(' ',LocData) <> 0 then
                             LocData := copy(LocData,1,Length(LocData)-2);
                           PArmeBonus := ChercheArmeBonus(LocData);
                           if PArmeBonus.PlusMoins = '-' then
                             begin
                               if Pos(PArmeBonus.Libelle, ArmeBonii) = 0 then
                                 begin
                                   if ArmeBonii <> '' then ArmeBonii := ArmeBonii + ',';
                                   ArmeBonii := ArmeBonii + LocData;
                                 end;
                               ListMalii  := ListMalii + ',' + PArmeBonus.Libelle;
                             end;
                         end;
                     end;
                   FabricationDetail(PersonnageEquipement.QualiteEquipement, ListMalii, FabricationBonii);

                   if (TexteRange1 = '') then
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, ListMalii, MinPolice)
                   else
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinDebColG + 113 + 40, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2, ListMalii, MinPolice);

                 end;
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
             end

         else if ((ArmureSet = false) and (PersonnageEquipement.TypeEquipement = TypeEquipAR)) or
                 ((ArmureSet = true)  and (PersonnageEquipement.TypeEquipement = TypeEquipARS)) then
             // gérer les armures
             begin
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 begin
                   PArmure    := ChercheArmure(PersonnageEquipement.CodeEquipement);
                   Enc        := PArmure.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                   NbLoca     := CountOccurrences(PArmure.Emplacement,',') + 1;
                   LigneBonus := PArmure.Listebonus;
                 end
               else
                 begin
                   PArmureSimplifiee   := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
                   Enc                 := PArmureSimplifiee.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                   LigneBonus          := PArmureSimplifiee.Listebonus;
                 end;

               EncP      := Enc;
               if EncP > 0 then
                 EncP    := EncP - 1;
               EncArmure := EncArmure + EncP;
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 For IndLoca := 1 to NbLoca do
                   begin
                     LocData := ExtractChaine(',',PArmure.Emplacement,IndLoca);
                     case LocData of
                       BonusBras:   ArmureBras  := ArmureBras  + PArmure.Protection;
                       BonusCorps:  ArmureCorps := ArmureCorps + PArmure.Protection;
                       BonusJambes: ArmureJambe := ArmureJambe + PArmure.Protection;
                       BonusTete:   ArmureTete  := ArmureTete  + PArmure.Protection;
                     end;
                   end
               else
                 begin
                   ArmureBras  := ArmureBras  + PArmureSimplifiee.Protection;
                   ArmureCorps := ArmureCorps + PArmureSimplifiee.Protection;
                   ArmureJambe := ArmureJambe + PArmureSimplifiee.Protection;
                   ArmureTete  := ArmureTete  + PArmureSimplifiee.Protection;
                 end;

               Inc(NBArmure);

               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 begin
                   PdfEcrit(PdfPage, DessinDebColG +  1, DessinDebColG + 34, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, Parmure.Libelle + Quality, MinPolice);
                   PdfEcrit(PdfPage, DessinDebColG + 35, DessinDebColG + 53, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, GetAllTexteLibelle(PArmure.Emplacement), MinPolice);
                 end
               else
                 PdfEcrit(PdfPage, DessinDebColG +  1, DessinDebColG + 34, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, PArmureSimplifiee.Libelle + Quality, MinPolice);
               if Enc <> 0 then
                 if EncP <> Enc then
                   PdfCentre(PdfPage, DessinDebColG + 53, DessinDebColG + 62, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(EncP)+ '('+IntToStr(Enc)+')')
                 else
                   PdfCentre(PdfPage, DessinDebColG + 53, DessinDebColG + 62, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(Enc));
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 PdfCentre(PdfPage, DessinDebColG + 62, DessinDebColG + 70, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(PArmure.Protection))
               else
                 PdfCentre(PdfPage, DessinDebColG + 62, DessinDebColG + 70, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(PArmureSimplifiee.Protection));
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) and (PArmure.ListeBonus <> '') and (PArmure.ListeBonus <> '-') or
                  (PersonnageEquipement.TypeEquipement = TypeEquipARS) and (PArmureSimplifiee.ListeBonus <> '') and (PArmureSimplifiee.ListeBonus <> '-') then
                 begin
                   if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                     NbLoca  := CountOccurrences(PArmure.ListeBonus,',') + 1
                   else
                     NbLoca  := CountOccurrences(PArmureSimplifiee.ListeBonus,',') + 1;
                   for IndLoca := 1 to NbLoca do
                     begin
                       if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                         LocData := ExtractChaine(',',PArmure.ListeBonus,IndLoca)
                       else
                         LocData := ExtractChaine(',',PArmureSimplifiee.ListeBonus,IndLoca);
                       if pos(' ',LocData) <> 0 then
                         LocData := copy(LocData,1,Length(LocData)-2);
                       PArmureBonus := ChercheArmureBonus(LocData);
                       LigneBonus := StringReplace(LigneBonus, LocData, PArmureBonus.Libelle, [rfReplaceAll]);
                       if pos(LocData, ArmureBonii) = 0 then
                         begin
                           if ArmureBonii <> '' then
                            ArmureBonii := ArmureBonii + ',';
                           ArmureBonii := ArmureBonii + LocData;
                         end;
                     end;
                 end;
               FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);
               PdfEcrit(PdfPage, DessinDebColG + 70 +1, DessinLargeurArm, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, LigneBonus, MinPolice);
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
             end

           else if PersonnageEquipement.TypeEquipement = TypeEquipDI then
             // gérer les divers
             begin
               Inc(IndDivers);
               if (IndDivers <= (DessinNbLigEqu * 2)) then
                  begin
                    if IndDivers > (DessinNbLigEqu - 1) then
                      PdfEcrit(PdfPage, DessinDebColG +  56, DessinDebColG + 100, DessinDebutHautEqu - ((IndDivers - DessinNbLigEqu + 3) * DessinHauteurEqu) + 0.6, PersonnageEquipement.CodeEquipement, MinPolice)
                    else
                      PdfEcrit(PdfPage, DessinDebColG +   1, DessinDebColG +  48, DessinDebutHautEqu - ((IndDivers + 2) * DessinHauteurEqu) + 0.6, PersonnageEquipement.CodeEquipement, MinPolice);
                  end;
             end

           else if PersonnageEquipement.TypeEquipement = TypeEquipSp then
             begin
               // gérer les sorts
               Inc(NbSort);
               PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
               PdfEcrit (PdfPage, DessinDebColG +   1, DessinDebColG + 38, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PSort.Libelle, MinPolice);
               PdfCentre(PdfPage, DessinDebColG +  38, DessinDebColG + 51, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PSort.Niveau);
               PdfCentre(PdfPage, DessinDebColG +  51, DessinDebColG + 66, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PdfPersonnageRemplaceBonus(Personnage, PSort.Portee));
               PdfCentre(PdfPage, DessinDebColG +  66, DessinDebColG + 82, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PdfPersonnageRemplaceBonus(Personnage, PSort.Cible));
               PdfCentre(PdfPage, DessinDebColG +  82, DessinDebColG + 98, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PdfPersonnageRemplaceBonus(Personnage, PSort.Duree));
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
             end;
       end;
        // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);

    //  gérer les encombrement
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc - 3) * DessinHauteurEnc) + 0.9, IntToStr(EncArmure));
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc - 2) * DessinHauteurEnc) + 0.9, IntToStr(EncArme));
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc - 0) * DessinHauteurEnc) + 0.9, IntToStr(Floor(BF/10) + Floor(BE/10) + BonusEncomb));
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc) + 0.9, IntToStr(EncArmure + EncArme));

    // Dessin Blessure
    DessinDebutHautBle   := DessinDebutHautEnc;
    DessinDebutGaucheBle := DessinLargeurEnc + 3;
    DessinLargeurBle     := DessinLargeurEqu;
    PdfPage.DrawLine( DessinDebutGaucheBle , DessinDebutHautBle, DessinDebutGaucheBle, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinDebutGaucheBle + 29 , DessinDebutHautBle - (4 * DessinHauteurBle), DessinDebutGaucheBle + 29, DessinDebutHautBle - (5 * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinDebutGaucheBle + 48 , DessinDebutHautBle - (1 * DessinHauteurBle), DessinDebutGaucheBle + 48, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinDebutGaucheBle + 61 , DessinDebutHautBle - (1 * DessinHauteurBle), DessinDebutGaucheBle + 61, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinLargeurEqu, DessinDebutHautBle, DessinLargeurEqu, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    for IndC := 0 to DessinNbLigBle do
      if (IndC < 2) or (IndC = DessinNbLigBle) then
        PdfPage.DrawLine(DessinDebutGaucheBle,DessinDebutHautBle - (indC * DessinHauteurBle), DessinLargeurBle, DessinDebutHautBle - (indC * DessinHauteurBle), 1)
      else
        PdfPage.DrawLine(DessinDebutGaucheBle,DessinDebutHautBle - (indC * DessinHauteurBle), DessinLargeurBle - 20, DessinDebutHautBle - (indC * DessinHauteurBle), 1);
    // Texte Blessure
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (1 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS1_WOUNDS'));
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (2 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BS'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (3 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BT'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (4 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BWP'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle - 20,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS5_HARDY'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (6 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_Tot'),MinPolice);
    // Valeur Blessure
    Ch := IntToStr(Floor(BF/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (2 * DessinHauteurBle) + 1, Ch);
    Ch := IntToStr(Floor(BE/10)*2);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (3 * DessinHauteurBle) + 1, Ch);
    Ch := IntToStr(Floor(BFM/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (4 * DessinHauteurBle) + 1, Ch);
    if DurACuire > 0 then
      begin
        Ch := IntToStr(DurACuire);
        if Length(Ch) = 1 then Ch := ' '+Ch;
        PdfCentre(PdfPage,DessinDebutGaucheBle + 29,DessinDebutGaucheBle + 48,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, IntToStr(ValDurACuire));
        PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, Ch);
      end;
    PRaceAttribut := ChercheRaceAttribut(Personnage.Race, ConstCaracBlessure);
    Ch := IntToStr(CalculBlessure(PRaceAttribut.CalculRace, BF, BE, BFM) + DurACuire);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (6 * DessinHauteurBle) + 1, Ch);

    // Dessin Compétence de combat
    DessinDebutHautComC   := DessinDebutHautEnc;
    DessinDebutGaucheComC := DessinLargeurEqu + 3;
    PdfPage.DrawLine(DessinDebutGaucheComC    , DessinDebutHautComC,    DessinDebutGaucheComC,     DessinDebutHautComC  - (6 * DessinHauteurComC), 1);
    PdfPage.DrawLine(DessinLargeurComC - 10   , DessinDebutHautComC,    DessinLargeurComC - 10,    DessinDebutHautComC  - (6 * DessinHauteurComC), 1);
    PdfPage.DrawLine(DessinLargeurComC        , DessinDebutHautComC,    DessinLargeurComC,         DessinDebutHautComC  - (6 * DessinHauteurComC), 1);
    for IndC := 0 to (DessinNbLigComC + 1) do
      PdfPage.DrawLine(DessinDebutGaucheComC,DessinDebutHautComC - (indC * DessinHauteurComC), DessinLargeurComC, DessinDebutHautComC - (indC * DessinHauteurComC), 1);
    // Texte Compétence de combat
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage,DessinDebutGaucheComC,DessinLargeurComC - 10,DessinDebutHautComC - (1 * DessinHauteurComC) + 1, GetTexteLibelle('RULES-PDF_SKILLS1_BASIC'));
    PdfCentre(PdfPage,DessinLargeurComC - 10,DessinLargeurComC,DessinDebutHautComC     - (1 * DessinHauteurComC) + 1, GetTexteLibelle('RULES-PDF_SKILLS2_TOTAL'));
    PCompetence := ChercheCompetence(ConstCEsquive);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (2 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (2 * DessinHauteurComC) + 1, IntToStr(TotalEsquive));
    PCompetence := ChercheCompetence(ConstCCalme);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (3 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (3 * DessinHauteurComC) + 1, IntToStr(TotalCalme));
    PCompetence := ChercheCompetence(ConstCIntuition);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (4 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (4 * DessinHauteurComC) + 1, IntToStr(TotalIntuition));
    PCompetence := ChercheCompetence(ConstCCommandement);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (5 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (5 * DessinHauteurComC) + 1, IntToStr(TotalCommandement));
    PCompetence := ChercheCompetence(ConstCResitance);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (6 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (6 * DessinHauteurComC) + 1, IntToStr(TotalResitance));

    // DessinExplication
    PdfPage.DrawLine(DessinLargeurArm + 3, DessinDebutHautArm,    DessinLargeurArm + 3, DessinDebutHautWea + 3, 1);
    PdfPage.DrawLine(DessinLargeurWea    , DessinDebutHautArm,    DessinLargeurWea    , DessinDebutHautWea + 3, 1);
    PdfPage.DrawLine(DessinLargeurArm + 3, DessinDebutHautArm,    DessinLargeurWea    , DessinDebutHautArm, 1);
    PdfPage.DrawLine(DessinLargeurArm + 3, DessinDebutHautWea + 3,DessinLargeurWea    , DessinDebutHautWea + 3, 1);

    NbBonus := 0;
    if ArmureBonii <> '' then
      begin
        Inc(NbBonus);
        Inc(NbBonus);
        PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), ' --------- ' + GetTexteLibelle('LAB_122') + ' --------- ');
        Inc(NbBonus);
        NbLoca := CountOccurrences(ArmureBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData      := ExtractChaine(',',ArmureBonii,IndLoca);
            PArmureBonus := ChercheArmureBonus(LocData);
            TxtBonus     := PArmureBonus.Libelle+':'+PArmureBonus.Malus;
            PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), TxtBonus);
          end;
      end;

    if ArmeBonii <> '' then
      begin
        Inc(NbBonus);
        Inc(NbBonus);
        PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), ' ---------- ' + GetTexteLibelle('LAB_123') + ' ---------- ');
        Inc(NbBonus);
        NbLoca := CountOccurrences(ArmeBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',ArmeBonii,IndLoca);
            PArmeBonus  := ChercheArmeBonus(LocData);
            TxtBonus    := PArmeBonus.Libelle+':'+PArmeBonus.Resume;
            PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), TxtBonus);
          end;
      end;

    if FabricationBonii <> '' then
      begin
        Inc(NbBonus);
        Inc(NbBonus);
        PdfPage.WriteText(15,DessinDebutHautArm-(NbBonus*DessinHauteurExl), ' ---------- ' + GetTexteLibelle('LAB_124') + ' ---------- ');
        Inc(NbBonus);
        NbLoca := CountOccurrences(FabricationBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',FabricationBonii,IndLoca);
            PFabrication:= ChercheFabrication(LocData);
            TxtBonus    := PFabrication.Libelle+':'+PFabrication.Resume;
            PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), TxtBonus);
          end;
      end;


    PDFDoc.SaveToFile(PdfChemin);
    PDFDoc.Free;

    OpenDocument(PdfChemin);
  end;


end.

