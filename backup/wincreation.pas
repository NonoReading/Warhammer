unit WinCreation;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  ComCtrls, StdCtrls, Spin, Buttons, ChargeConstantes, GlobalFonts, ChargeRace,
  Types, ChargeMetier, ChargeRaceMetier, ChargeAttribut, ChargeRaceAttribut,
  ChargeMetierAttribut, UnitCalcul, ChargeRaceTalent, ChargeTalent,
  ChargeTalentCreation, ChargeRaceCompetence, ChargeCompetence, ChargeRaceCreation,
  ChargeMetierCompetence, ChargeArme, ChargeArmure, ChargeMetierEquipement,
  WinMetier, WinRaces, ChargeTexte, WinTalent, WinCompetence, ChargeLivre,
  ChargeMetierSousMetier, ChargeMetierRaceChoixMetier, WinSpecialisation,
  ChargeMetierTalent, ChargePersonnage, BGRABitmap, BGRABitmapTypes, BCButton,
  BCLabel, WinLanceDe;

type
  { TWinCreations }
  TWinCreations = class(TForm)
    AffMetierSousMetier: TMemo;
    ButtonAttributHasard: TBCButton;
    ButtonLibellePhase: TBCButton;
    ButtonMetierCompetenceHasard: TBCButton;
    ButtonMetierHasard: TBCButton;
    ButtonMetierSelectionner: TBCButton;
    ButtonMetierSousMetierSelectionner: TBCButton;
    ButtonMetierSousMetierValider: TBCButton;
    ButtonMetierValider: TBCButton;
    ButtonPhaseSuivante: TBCButton;
    ButtonRaceCompetenceHasard: TBCButton;
    ButtonRaceHasard: TBCButton;
    ButtonRaceSelectionner: TBCButton;
    ButtonRaceValider: TBCButton;
    ButtonTalentHasard: TBCButton;
    ButtonTotalMetierCompetence: TButton;
    ComboRaceCreation: TComboBox;
    EditMetierResultat: TSpinEdit;
    EditMetierSousMetierResultat: TSpinEdit;
    EditNomPersonnag: TEdit;
    EditRaceResultat: TSpinEdit;
    GroupBoxAttribut: TGroupBox;
    GroupBoxMetier: TGroupBox;
    GroupBoxRace: TGroupBox;
    ImageScroll: TImage;
    LabDestin: TEdit;
    LabelAttribut: TBCLabel;
    LabelCompetence: TBCLabel;
    LabelMetier: TBCLabel;
    LabelRace: TBCLabel;
    LabelTalent: TBCLabel;
    LabLivre: TEdit;
    LabNomPersonnage: TEdit;
    LabPointSupp: TEdit;
    LabRegle: TEdit;
    LabResilience: TEdit;
    LibMetier: TEdit;
    LibRace: TEdit;
    ImageRace1: TImage;
    ImageRace2: TImage;
    ImageMetier: TImage;
    ImageWar: TImage;
    PageEtapes: TPageControl;
    RadioButtonAttributHasard: TRadioButton;
    RadioButtonAttributHasardAffecte: TRadioButton;
    RadioButtonAttributResultat: TRadioButton;
    RadioButtonAttributResultatAffecte: TRadioButton;
    RadioButtonMetierChoix: TRadioButton;
    RadioButtonMetierHasard: TRadioButton;
    RadioButtonMetierResultat: TRadioButton;
    RadioButtonRaceChoix: TRadioButton;
    RadioButtonRaceHasard: TRadioButton;
    RadioButtonRaceResultat: TRadioButton;
    RecapTalent: TStringGrid;
    RecapComp: TStringGrid;
    RecapAttribut: TStringGrid;
    TabCreationChoix: TStringGrid;
    TabAttribut: TStringGrid;
    TabAttributLanceDe: TStringGrid;
    TabCreationHasard: TStringGrid;
    TabLivre: TStringGrid;
    TabMetier: TStringGrid;
    TabMetierCompetence: TStringGrid;
    TabMetierEquipement: TStringGrid;
    TabRace: TStringGrid;
    TabRaceCompetence: TStringGrid;
    TabSheetAttribut: TTabSheet;
    TabSheetCompMetier: TTabSheet;
    TabSheetCompRace: TTabSheet;
    TabSheetEquipement: TTabSheet;
    TabSheetMetier: TTabSheet;
    TabSheetNom: TTabSheet;
    TabSheetRace: TTabSheet;
    TabSheetTalent: TTabSheet;
    TabTalent: TStringGrid;
    TrackBarPointSupp: TTrackBar;

    // générales
    procedure ButtonMetierSelectionnerClick({%H-}Sender: TObject);
    procedure ButtonMetierSousMetierSelectionnerClick({%H-}Sender: TObject);
    procedure ButtonMetierSousMetierValiderClick({%H-}Sender: TObject);
    procedure ButtonRaceSelectionnerClick({%H-}Sender: TObject);
    procedure ButtonTalentHasardClick(Sender: TObject);
    procedure ComboRaceCreationSelect({%H-}Sender: TObject);
    procedure FormCloseQuery({%H-}Sender: TObject; var {%H-}CanClose: Boolean);
    procedure FormCreate({%H-}Sender: TObject);
    procedure ChargerImage();
    Procedure ChargeImageNiveau(Niveau: Integer);
    procedure LibMetierDblClick({%H-}Sender: TObject);
    procedure LibRaceDblClick({%H-}Sender: TObject);
    procedure RecapAttributSelectEditor({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
      var Editor: TWinControl);
    procedure RecapCompDblClick({%H-}Sender: TObject);
    procedure RecapCompSelectEditor({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
      var Editor: TWinControl);
    procedure RecapTalentDblClick({%H-}Sender: TObject);
    procedure RecapTalentSelectEditor({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
      var Editor: TWinControl);
    procedure TabCreationChoixDblClick(Sender: TObject);
    procedure TabCreationChoixPrepareCanvas(Sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure TabCreationHasardDblClick(Sender: TObject);
    procedure TabCreationHasardPrepareCanvas(Sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure TabLivreDblClick({%H-}Sender: TObject);
    procedure TabMetierCompetenceDblClick({%H-}Sender: TObject);
    procedure TabMetierEquipementDblClick({%H-}Sender: TObject);
    procedure TabRaceCompetenceDblClick({%H-}Sender: TObject);
    procedure TabTalentDblClick({%H-}Sender: TObject);
    Procedure TalentFenetre(Choix: Integer; CodeTalent: String);
    Procedure CompetenceFenetre(CodeCompetence: String);
    Procedure RaceFenetre(CodeRace: String);
    Procedure MetierFenetre(CodeMetier: String);
    procedure ChargerLivre();
    Procedure ReconstruitChoixCreation();
    Procedure AfficheChoixCreation();

    // Phases
    procedure ButtonPhaseSuivanteClick({%H-}Sender: TObject);
    procedure ChangementPhase(Changement: Integer);
    Function PageEtapesChange(): boolean;
    Procedure PhaseSave(NouvellePhase: Integer);

    // XML
    function XmlCalculXp(): Integer;

    // Race
    procedure ChargeTabRaces(Livre: String='');
    procedure TabRaceDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure TabRacePrepareCanvas({%H-}Sender: TObject; {%H-}aCol, aRow: Integer;
      {%H-}aState: TGridDrawState);
    procedure TrackBarPointSuppChange({%H-}Sender: TObject);
    procedure UpdateSheetMetier(Hasard: Boolean);
    procedure AfficheImageRace();
    procedure ButtonRaceHasardClick({%H-}Sender: TObject);
    procedure ButtonRaceValiderClick({%H-}Sender: TObject);
    procedure RadioButtonRaceHasardClick({%H-}Sender: TObject);
    procedure RadioButtonRaceClick({%H-}Sender: TObject);
    procedure TabRaceResultat(Resul: Integer);

    // Métier
    procedure ChargeTabMetier();
    procedure TabMetierDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure TabMetierPrepareCanvas({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
      {%H-}aState: TGridDrawState);
    procedure UpdateSheetRace(Hasard: Boolean);
    procedure AfficheImageMetier();
    procedure ButtonMetierHasardClick({%H-}Sender: TObject);
    procedure ButtonMetierValiderClick({%H-}Sender: TObject);
    procedure RadioButtonMetierHasardClick({%H-}Sender: TObject);
    procedure RadioButtonMetierClick({%H-}Sender: TObject);
    procedure TabMetierResultat(Resul: Integer);

    // Attributs
    procedure ChargeTabAttribut();
    procedure TabAttributDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure TabAttributSelectEditor({%H-}Sender: TObject; aCol, {%H-}aRow: Integer;
      var Editor: TWinControl);
    procedure ButtonAttributHasardClick({%H-}Sender: TObject);
    procedure UpdateSheetAttribut(Hasard: boolean);
    Procedure CalculTabAttribut(Hasard: Boolean; Affectation: Boolean);
    procedure TabAttributLanceDeEditingDone({%H-}Sender: TObject);
    procedure TabAttributLanceDeSelectCell({%H-}Sender: TObject; aCol,
      aRow: Integer; var CanSelect: Boolean);
    procedure RadioButtonAttributClick({%H-}Sender: TObject);
    procedure ComboBoxSelectAttribut(Sender: TObject);
    procedure TabAttributLanceDeSetEditText({%H-}Sender: TObject; {%H-}ACol, ARow: Integer;
      const {%H-}Value: string);
    procedure TabAttributLanceDeClickCombo();

    // Talent
    function TalentTest(Num: Integer; Code: String; Hasard: Boolean): Boolean;
    Function LibelleChoixMultiple(Code: String): String;
    Function ChoixCreationComplet(): Boolean;
    Function RangSuivant(Source, ParentLigne: String): Integer;
    Function ListeTalentsDejaPris(Exclu: String): TStringList;
    Procedure AjouteTalentsResolus();

    // Compétences de race
    procedure TabRaceCompetenceDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure TabRaceCompetenceMouseDown({%H-}Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);
    procedure ButtonRaceCompetenceHasardClick({%H-}Sender: TObject);
    procedure ClickRaceCompetence(aCol, aRow: Integer);
    procedure CalculNbRaceCompetence();

    // Compétence de métier
    procedure TabMetierCompetenceDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure TabMetierCompetenceSelectEditor({%H-}Sender: TObject; aCol,
      {%H-}aRow: Integer; var Editor: TWinControl);
    procedure TabMetierCompetenceValidateEntry({%H-}Sender: TObject; aCol,
      {%H-}aRow: Integer; const OldValue: string; var NewValue: String);
    procedure CalculTotalMetierCompetence();
    procedure ButtonMetierCompetenceHasardClick({%H-}Sender: TObject);

    // Equipement
//    procedure TabMetierEquipementDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
//      aRect: TRect; {%H-}aState: TGridDrawState);
    procedure TabMetierEquipementSelectEditor({%H-}Sender: TObject; {%H-}aCol,
      {%H-}aRow: Integer; var Editor: TWinControl);
    procedure TabSelectEditor({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
      var Editor: TWinControl);

  private
    FEditingCol: Integer;
    FEditingRow: Integer;


  public

  end;

Const
  PhaseDebut = 0;
  PhaseMax   = 7;

var
  WinCreations:                  TWinCreations;

  // Phases
  PhaseEnCours:                  Integer = 0;
  ListPhase:                     TStringList;

  // Pour les images
  ColorLoc:                      TColor;
  ColorList:                     array of TColor;

  // Race
  RaceEnCours:                   String;
  RaceLibEnCours:                String;
  LastRandomRaceResultat:        Integer = 0;
  LastCheckRaceResultat:         Integer = 0;
  ModDesti:                      Boolean = false;
    // Compétence
    NbRaceCompetenceTab:         Integer = 0;
    CompetenceRaceStates:        array of array of Boolean;
    NbRaceComp:                  Integer = 0;
    NbTrois:                     Integer = 0;
    NbCinq:                      Integer = 0;
    // Talent
    TalentRaceChoix1:            String;
    TalentRaceChoix2:            String;
    TalentRaceChoix3:            String;
    TalentRaceChoix4:            String;
    NbGenerique:                 Integer = 0;

  // Métier
  MetierEnCours:                 String;
  MetierLibEnCours:              String;
  MetierEnCoursPrincipal:        String;
  LastRandomMetierResultat:      Integer = 0;
  LastCheckMetierResultat:       Integer = 0;
  LastCheckMetierSousMetierResul:Integer = 0;
    // Compétences
    NbMetierCompetenceTab:       Integer = 0;
    TotalMetierCompetence:       Integer = 0;
    // Equipement
    NbMetierEquipementTab:       Integer = 0;

  // fenêtre de choix
  FenMetier:                   TWinMetiers;
  FenRace:                     TWinRace;
  FenTalent:                   TWintTalent;
  FenCompetence:               TWinCompetence;
  FenSpecialisation:           TWinSpecialisations;
  FenLanceDe:                  TWinLanceDes;

  // gérer click sur les choix de talents multiples
  FirstClick1:                 Boolean = true;
  FirstClick2:                 Boolean = true;
  FirstClick3:                 Boolean = true;
  FirstClick4:                 Boolean = true;

  // objet personnage
  Personnage:                  StructurePersonnage;
  PersonnageAttribut:          StructurePersonnageAttribut;
  PersonnageCompetence:        StructurePersonnageCompetence;
  PersonnageTalent:            StructurePersonnageTalent;
  PersonnageEquipement:        StructurePersonnageEquipement;
  PersonnageMetier:            StructurePersonnageMetier;

  // Livres
  LivresPersonnages:           String;

  // Tableau CHOIX
  ColChoixOrigine: Integer = 1;
  ColChoixLib:     Integer = 2;   // libellé du code source
  ColChoixLibSel:  Integer = 3;   // libellé du choix retenu
  ColChoixSource:  Integer = 4;   // caché
  ColChoixSel:     Integer = 5;   // caché
  ColChoixParent:  Integer = 6;   // caché
  ColChoixRang:    Integer = 7;   // caché

  // Tableau ALÉATOIRE
  ColHasOrigine:   Integer = 1;
  ColHasLib:       Integer = 2;
  ColHasJet:       Integer = 3;
  ColHasLibSel:    Integer = 4;
  ColHasSource:    Integer = 5;   // caché
  ColHasSel:       Integer = 6;   // caché
  ColHasRang:      Integer = 7;   // caché
  ColHasParent:    Integer = 8;   // caché
  ColHasLibSpe:    Integer = 9;   // libellé de la spécialisation retenue
  ColHasSpe:       Integer = 10;  // caché

//  ChoixWinJetDeja: TStringList;

  ListeChoixCreation: array of StructureChoixCreation;

implementation

{$R *.lfm}

{ TWinCreations }

////////////////////////////////////////////////////////////////////////////////
//                                GENERIQUES                                  //
////////////////////////////////////////////////////////////////////////////////

procedure TWinCreations.FormCreate(Sender: TObject);
  var
    indTab:           Integer;
    Bmp: TBGRABitmap;
  begin
    MiseEnFormeDesChamp(self);
    ChargerImage();
    ChargerLivre();
    ChangementPhase(ConstSuivant);
    EditRaceResultat.MinValue    := 0;
    EditRaceResultat.MaxValue    := 100;
    EditMetierResultat.MinValue  := 0;
    EditMetierResultat.MaxValue  := 100;

    // charges les images des niveaux
    SetLength(ColorList, 5);
    ListImage := TImageList.Create(nil);
    For IndTab := 0 to 4 Do
      ChargeImageNiveau(IndTab);

    if FileExists(GetCurrentDir+ConstCheminScroll) then
       begin
         Bmp := TBGRABitmap.Create(GetCurrentDir+ConstCheminScroll);
         ImageScroll.Picture.Bitmap.Assign(Bmp);
         Bmp.Free;
         ImageScroll.SendToBack;
       end;

    LastRandomRaceResultat              := 0;
    LastRandomMetierResultat            := 0;
    LastCheckRaceResultat               := 0;
    LastCheckMetierResultat             := 0;
    LastCheckMetierSousMetierResul      := 0;

    LabelRace.Caption                          := GetTexteLibelle('LAB_042');
    LabelMetier.Caption                        := GetTexteLibelle('LAB_006');
    LabelAttribut.Caption                      := GetTexteLibelle('LAB_008');
    LabelTalent.Caption                        := GetTexteLibelle('LAB_007');
    LabelCompetence.Caption                    := GetTexteLibelle('LAB_009');
    Self.Caption                               := GetTexteLibelle('LAB_081');
    GroupBoxRace.Caption                       := GetTexteLibelle('LAB_084');
    GroupBoxAttribut.Caption                   := GetTexteLibelle('LAB_084');
    GroupBoxMetier.Caption                     := GetTexteLibelle('LAB_084');
    ButtonAttributHasard .Caption              := GetTexteLibelle('LAB_085');
    ButtonRaceHasard.Caption                   := GetTexteLibelle('LAB_085');
    ButtonTalentHasard.Caption                 := GetTexteLibelle('LAB_085');
    ButtonRaceCompetenceHasard.Caption         := GetTexteLibelle('LAB_085');
    ButtonMetierHasard.Caption                 := GetTexteLibelle('LAB_085');
    ButtonMetierCompetenceHasard .Caption      := GetTexteLibelle('LAB_085');
    ButtonRaceValider.Caption                  := GetTexteLibelle('LAB_086');
    ButtonMetierValider.Caption                := GetTexteLibelle('LAB_086');
    ButtonRaceSelectionner.Caption             := GetTexteLibelle('LAB_004');
    ButtonMetierSelectionner.Caption           := GetTexteLibelle('LAB_004');
    TabSheetRace.Caption                       := GetTexteLibelle('LAB_042');
    TabSheetMetier.Caption                     := GetTexteLibelle('LAB_006');
    TabSheetAttribut.Caption                   := GetTexteLibelle('LAB_008');
    TabSheetTalent.Caption                     := GetTexteLibelle('LAB_007');
    TabSheetCompRace.Caption                   := GetTexteLibelle('LAB_087');
    TabSheetCompMetier.Caption                 := GetTexteLibelle('LAB_088');
    TabSheetEquipement.Caption                 := GetTexteLibelle('LAB_013');
    TabSheetNom.Caption                        := GetTexteLibelle('LAB_014');
    RadioButtonRaceHasard.Caption              := GetTexteLibelle('LAB_085')+' (20xp)';
    RadioButtonMetierHasard.Caption            := GetTexteLibelle('LAB_085')+' (50xp)';
    RadioButtonAttributHasard.Caption          := GetTexteLibelle('LAB_085')+' (50xp)';
    RadioButtonRaceResultat.Caption            := GetTexteLibelle('LAB_089')+' (20xp)';
    RadioButtonMetierResultat.Caption          := GetTexteLibelle('LAB_089')+' (50xp)';
    RadioButtonAttributResultat.Caption        := GetTexteLibelle('LAB_089')+' (50xp)';
    RadioButtonRaceChoix.Caption               := GetTexteLibelle('LAB_084')+' (0xp)';
    RadioButtonMetierChoix.Caption             := GetTexteLibelle('LAB_084')+' (0xp)';
    RadioButtonAttributHasardAffecte.Caption   := GetTexteLibelle('LAB_090')+' (25xp)';
    RadioButtonAttributResultatAffecte.Caption := GetTexteLibelle('LAB_091')+' (25xp)';
    LabPointSupp.Caption                       := GetTexteLibelle('LAB_092');
    LabDestin.Caption                          := GetTexteLibelle('LAB_093');
    LabResilience.Caption                      := GetTexteLibelle('LAB_094');
    LabNomPersonnage.Caption                   := GetTexteLibelle('LAB_095');
    ButtonMetierSousMetierSelectionner.Caption := GetTexteLibelle('LAB_004');
    ButtonPhaseSuivante.Caption                := GetTexteLibelle('LAB_134');
    LabRegle.Caption                           := GetTexteLibelle('LAB_135');
    LabLivre.Caption                           := GetTexteLibelle('LAB_137');

    ButtonRaceCompetenceHasard.BringToFront;
    ButtonMetierCompetenceHasard.BringToFront;

    KeyPreview := true;

    LivresPersonnages := LivresCharges;
  end;

procedure TWinCreations.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  var
    i: Integer;
  begin
    ColorLoc := clDefault;
    SetLength(ColorList, 0);
    for i := Low(CompetenceRaceStates) to High(CompetenceRaceStates) do
      SetLength(CompetenceRaceStates[i], 0);
    SetLength(CompetenceRaceStates, 0);
    MetierEnCours := '';
    RaceEnCours   := '';
  end;

procedure TWinCreations.ButtonMetierSelectionnerClick(Sender: TObject);
  var
    PMetier: StructureMetier;
  begin
    // ouvrir les métiers
    SelectWinMetierRace := RaceEnCours;
    SelectWinLivre      := LivresPersonnages;
    FenMetier           := TWinMetiers.Create(Application);
    FenMetier.Position  := poOwnerFormCenter;
    FenMetier.ShowModal;

    if ChoixWinMetierRace <> '' then
      begin
        PMetier          := chercheMetier(ChoixWinMetierRace);
        MetierEnCours    := PMetier.CodeMetier;
        MetierLibEnCours := PMetier.Libelle;
        AfficheImageMetier();
        UpdateSheetMetier(true);
      end;

    SelectWinMetierRace:= '';
    ChoixWinMetierRace := '';
  end;


procedure TWinCreations.ButtonMetierSousMetierSelectionnerClick(Sender: TObject);
  var
    PMetier: StructureMetier;
  begin
    // ouvrir les métiers
    SelectWinMetier     := MetierEnCours;
    SelectWinMetierRace := RaceEnCours;
    FenMetier           := TWinMetiers.Create(Application);
    FenMetier.Position  := poOwnerFormCenter;
    FenMetier.ShowModal;

    if ChoixWinMetierRace <> '' then
      begin
        PMetier          := chercheMetier(ChoixWinMetierRace);
        MetierEnCours    := PMetier.CodeMetier;
        MetierLibEnCours := PMetier.Libelle;
        AfficheImageMetier();
        UpdateSheetMetier(true);
      end;

    SelectWinMetierRace:= '';
    ChoixWinMetierRace := '';
    ButtonMetierSousMetierSelectionner.enabled := false;
  end;


procedure TWinCreations.ButtonMetierSousMetierValiderClick(Sender: TObject);
  Var
    PMetier:  StructureMetier;
  begin
    if (EditMetierSousMetierResultat.Value = 0) then
       ShowMessage(GetTexteLibelle('MESS_019'))
    else
    begin
      LastCheckMetierSousMetierResul := EditMetierSousMetierResultat.Value;
      MetierEnCours := ResultMetierSousMetier(MetierEnCoursPrincipal, LastCheckMetierSousMetierResul, LivresPersonnages);
      if pos(SeparateurMulti,MetierEnCours) = 0 then
        begin
          PMetier          := chercheMetier(MetierEnCours);
          MetierLibEnCours := PMetier.Libelle;
          AfficheImageMetier();
          UpdateSheetMetier(true);
        end
      else
        begin
          ButtonMetierSousMetierValider.enabled       := false;
          ButtonMetierSousMetierSelectionner.visible  := true;
          ButtonMetierSousMetierSelectionner.BringToFront;
        end;
    end
  end;

procedure TWinCreations.ButtonRaceSelectionnerClick(Sender: TObject);
begin
  // ouvrir les métiers
  SelectWinRace     := ConstSelectionne;
  SelectWinLivre    := LivresPersonnages;
  FenRace           := TWinRace.Create(Application);
  FenRace.Position  := poOwnerFormCenter;
  FenRace.ShowModal;

  if ChoixWinRace <> '' then
    begin
      TabRaceResultat(0);
      AfficheImageRace();
      UpdateSheetRace(true);
    end;

  SelectWinRace  := '';
  ChoixWinRace   := '';
  SelectWinLivre := '';
end;

procedure TWinCreations.ButtonTalentHasardClick(Sender: TObject);
  var
    Ind:      Integer;
    NbTour:   Integer = 0;
    ListOpt:  TStringList;
    Deja:     TStringList;
    Jet:      Integer;
    CodeTire: String;
    NbEssai:  Integer;
  begin
    repeat
      // 1 - resoudre les choix
      for Ind := 0 to High(ListeChoixCreation) do
        if (ListeChoixCreation[Ind].CodeChoisi = '') and (not ListeChoixCreation[Ind].Aleatoire) then
          begin
            ListOpt := ListeTalent(ListeChoixCreation[Ind].CodeSource);
            if ListOpt.Count > 0 then
              ListeChoixCreation[Ind].CodeChoisi := ListOpt[Random(ListOpt.Count)];
            ListOpt.Free;
          end;
      ReconstruitChoixCreation();

      // 2 - resoudre les tirages
      for Ind := 0 to High(ListeChoixCreation) do
        if (ListeChoixCreation[Ind].CodeChoisi = '') and ListeChoixCreation[Ind].Aleatoire then
          begin
            Deja := ListeTalentsDejaPris('');
            NbEssai := 0;
            repeat
              Jet      := Random(100) + 1;
              CodeTire := TalentAleatoire(Jet, RaceEnCours);
              NbEssai  := NbEssai + 1;
            until ((CodeTire <> '') and (not TalentDejaPossede(CodeTire, Deja))) or (NbEssai >= 100);
            Deja.Free;
            if CodeTire <> '' then
              begin
                ListeChoixCreation[Ind].Jet        := Jet;
                ListeChoixCreation[Ind].CodeChoisi := CodeTire;
              end;
          end;
      ReconstruitChoixCreation();

      // 3 - resoudre les specialisations
      for Ind := 0 to High(ListeChoixCreation) do
        if (Pos(ValeurGenerique, ListeChoixCreation[Ind].CodeChoisi) > 0)
           and (ListeChoixCreation[Ind].CodeSpecialise = '') then
          begin
            ListOpt := ListeTalent(ListeChoixCreation[Ind].CodeChoisi);
            if ListOpt.Count > 0 then
              ListeChoixCreation[Ind].CodeSpecialise := ListOpt[Random(ListOpt.Count)];
            ListOpt.Free;
          end;
      ReconstruitChoixCreation();

      NbTour := NbTour + 1;
    until ChoixCreationComplet() or (NbTour >= 10);
  end;

procedure TWinCreations.ComboRaceCreationSelect(Sender: TObject);
  begin
    ChargeTabRaces(ComboRaceCreation.Text);
  end;

procedure TWinCreations.ChargerImage();
  var
      I, J:            Integer;
      ComboBoxAttribut:TComboBox;
      PAttribut:       StructureAttribut;
  begin
  // PHASES
    ListPhase := TStringList.Create;
    ListPhase.Add(GetTexteLibelle('LAB_026'));
    ListPhase.Add(GetTexteLibelle('LAB_027'));
    ListPhase.Add(GetTexteLibelle('LAB_028'));
    ListPhase.Add(GetTexteLibelle('LAB_029'));
    ListPhase.Add(GetTexteLibelle('LAB_030'));
    ListPhase.Add(GetTexteLibelle('LAB_031'));
    ListPhase.Add(GetTexteLibelle('LAB_032'));
    ListPhase.Add(GetTexteLibelle('LAB_033'));
    PageEtapes.ActivePageIndex := 0;
    PhaseEnCours := -1;
    // Logo
    if FileExists(GetCurrentDir+ConstCheminLogo1) then
        ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

  // 0 - RECAPITULATIF
    // Attribut
    RecapAttribut.ColCount     := 11;
    RecapAttribut.RowCount     := 2;
    RecapAttribut.ColWidths[0] := 0;
    for I := 1 to 10 do
      begin
        PAttribut := ListeAttribut.Items[I-1];
        RecapAttribut.ColWidths[I]:= 43;
        RecapAttribut.Cells[I, 0] := PAttribut.Resume;
      end;
    // Talent
    RecapTalent.RowCount       := 10;
    RecapTalent.ColCount       := 3;
    RecapTalent.ColWidths[0]   := 0;
    RecapTalent.ColWidths[1]   := 208;
    RecapTalent.ColWidths[2]   := 0;
    // Compétences
    RecapComp.ColCount         := 6;
    RecapComp.ColWidths[0]     := 0;
    RecapComp.ColWidths[1]     := 128;
    RecapComp.ColWidths[2]     := 40;
    RecapComp.ColWidths[3]     := 40;
    RecapComp.ColWidths[4]     := 0;
    RecapComp.ColWidths[5]     := 0;

  // 1 - RACE
    // Mise en forme du tableau de choix des Races
    TabRace.Options          := TabRace.Options + [goEditing, goAlwaysShowEditor];
    TabRace.ColCount         := 5;
    TabRace.RowCount         := NbRace+1;
    TabRace.ColWidths[0]     := 30;
    TabRace.Cells[1, 0]      := GetTexteLibelle('LAB_006');
    TabRace.ColWidths[1]     := 0;
    TabRace.Cells[2, 0]      := GetTexteLibelle('LAB_014');
    TabRace.ColWidths[2]     := 140;
    TabRace.Cells[3, 0]      := GetTexteLibelle('LAB_023');
    TabRace.ColWidths[3]     := 105;
    TabRace.Cells[4, 0]      := 'Sel';
    TabRace.ColWidths[4]     := 0;
    TabRace.Height           := TabRace.DefaultRowHeight * TabRace.RowCount + 5;
    ChargeTabRaces();
    AdjustGridColumnsWidth(TabRace, PageEtapes.Height, false, true);

  // 2 - METIER
    // Mise en forme du tableau de choix des Metiers
    TabMetier.Options          := TabMetier.Options + [goEditing, goAlwaysShowEditor];
    TabMetier.ColCount         := 5;
    TabMetier.RowCount         := 1;
    TabMetier.ColWidths[0]     := 30;
    TabMetier.Cells[1, 0]      := GetTexteLibelle('LAB_006');
    TabMetier.ColWidths[1]     := 0;
    TabMetier.Cells[2, 0]      := GetTexteLibelle('LAB_014');
    TabMetier.ColWidths[2]     := 140;
    TabMetier.Cells[3, 0]      := GetTexteLibelle('LAB_023');
    TabMetier.ColWidths[3]     := 80;
    TabMetier.Cells[4, 0]      := 'Sel';
    TabMetier.ColWidths[4]     := 0;

  // 3 - ATTRIBUTS
    // Mise en forme du tableau de choix des Attributs
    TabAttribut.Options          := TabAttribut.Options + [goEditing, goAlwaysShowEditor];
    TabAttribut.ColCount         := 1;
    TabAttribut.RowCount         := NbAttribut +1;
    TabAttribut.ColWidths[0]     := 30;
    TabAttribut.Columns.add;
    TabAttribut.Columns[0].Title.Caption  := GetTexteLibelle('LAB_001');
    TabAttribut.ColWidths[1]     := 0;
    TabAttribut.Columns.add;
    TabAttribut.Columns[1].Title.Caption      := GetTexteLibelle('LAB_019');
    TabAttribut.ColWidths[2]     := 30;
    TabAttribut.Columns[1].Alignment:= tacenter;
    TabAttribut.Columns.add;
    TabAttribut.Columns[2].Title.Caption      := GetTexteLibelle('LAB_008');
    TabAttribut.ColWidths[3]     := 175;
    TabAttribut.Columns.add;
    TabAttribut.Columns[3].Title.Caption      := GetTexteLibelle('LAB_020');
    TabAttribut.ColWidths[4]     := 80;
    TabAttribut.Columns.add;
    TabAttribut.Columns[4].Title.Caption      := GetTexteLibelle('LAB_022');
    TabAttribut.ColWidths[5]     := 90;
    TabAttribut.Columns.add;
    TabAttribut.Columns[5].Title.Caption      := GetTexteLibelle('LAB_021');
    TabAttribut.ColWidths[6]     := 90;
    TabAttribut.Columns.add;
    TabAttribut.Columns[6].Title.Caption      := '';
    TabAttribut.ColWidths[7]     := 0;
    TabAttribut.Height           := TabAttribut.DefaultRowHeight * TabAttribut.RowCount + 5;
    // Mise en forme du tableau de lancé de dé des attributs
    TabAttributLanceDe.Options     := TabAttributLanceDe.Options + [goEditing, goAlwaysShowEditor];
    TabAttributLanceDe.ColCount    := 12;
    TabAttributLanceDe.RowCount    := 3;
    TabAttributLanceDe.ColWidths[0]:= 20;
    TabAttributLanceDe.OnSetEditText := @TabAttributLanceDeSetEditText;
    For I := 1 to 10 do
      begin
        TabAttributLanceDe.Cells[I, 0]  := 'D'+IntToStr(I);
        TabAttributLanceDe.ColWidths[I] := 53;
      end;
    TabAttributLanceDe.Cells[I+1, 0]    := GetTexteLibelle('LAB_021');
    TabAttributLanceDe.ColWidths[I+1]   := 56;
    TabAttributLanceDe.Height           := TabAttributLanceDe.DefaultRowHeight * TabAttributLanceDe.RowCount + 5;
    TabAttributLanceDe.Width            := 620;
    // Création du composant TComboBox personnalisé pour la ligne 2
     for I := 1 to 11 do
     begin
       ComboBoxAttribut                := TComboBox.Create(Self);
       ComboBoxAttribut.Style          := csDropDownList;
       ComboBoxAttribut.Parent         := TabAttributLanceDe;
       ComboBoxAttribut.DropDownCount  := 10;
       ComboBoxAttribut.Visible        := false; // On le cache initialement
       ComboBoxAttribut.Items.Add(ValeurNonRenseignee);
       for J := 0 to 9 do
       begin
          PAttribut := ListeAttribut.Items[J];
          ComboBoxAttribut.Items.Add(PAttribut.Resume);
       end;
       ComboBoxAttribut.ItemIndex       := 0; // Sélectionner le premier élément
       ComboBoxAttribut.OnChange        := @ComboBoxSelectAttribut;
       TabAttributLanceDe.Objects[I, 2] := ComboBoxAttribut;
     end;
     // Charger les Attributs
    ChargeTabAttribut();

  // 4 - TALENTS
     // Mise en forme du tableau de choix des Talents
     TabTalent.Options          := TabTalent.Options + [goAlwaysShowEditor];
     TabTalent.ColCount         := 3;
     TabTalent.RowCount         := 10;
     TabTalent.ColWidths[0]     := 30;
     TabTalent.Cells[1, 0]      := GetTexteLibelle('LAB_001');
     TabTalent.ColWidths[1]     := 0;
     TabTalent.Cells[2, 0]      := GetTexteLibelle('LAB_007');
     TabTalent.ColWidths[2]     := 200;
     TabTalent.Height           := TabTalent.DefaultRowHeight * TabTalent.RowCount + 5;
     TabTalent.Width            := 235;

     // Talent avec choix
    TabCreationChoix.RowCount := 1;
    TabCreationChoix.ColCount := 8;
    TabCreationChoix.FixedRows := 1;
    TabCreationChoix.Options := TabCreationChoix.Options + [goRowSelect];
    TabCreationChoix.Cells[ColChoixOrigine, 0] := GetTexteLibelle('LAB_xxx');  // Origine
    TabCreationChoix.Cells[ColChoixLib, 0]     := GetTexteLibelle('LAB_xxx');  // Élément
    TabCreationChoix.Cells[ColChoixLibSel, 0]  := GetTexteLibelle('LAB_xxx');  // Choix
    TabCreationChoix.ColWidths[0]               := 0;
    TabCreationChoix.ColWidths[ColChoixOrigine] := 0;
    TabCreationChoix.ColWidths[ColChoixLib]     := 250;
    TabCreationChoix.ColWidths[ColChoixLibSel]  := 250;
    TabCreationChoix.ColWidths[ColChoixSource]  := 0;
    TabCreationChoix.ColWidths[ColChoixSel]     := 0;
    TabCreationChoix.ColWidths[ColChoixParent]  := 0;
    TabCreationChoix.ColWidths[ColChoixRang]    := 0;
    TabCreationChoix.Width:= 2000;

    // --- Tableau ALÉATOIRE
    TabCreationHasard.RowCount := 1;
    TabCreationHasard.ColCount := 11;
    TabCreationHasard.FixedRows := 1;
    TabCreationHasard.Options := TabCreationChoix.Options + [goRowSelect];
    TabCreationHasard.ColWidths[0]             := 0;
    TabCreationHasard.ColWidths[ColHasOrigine] := 0;
    TabCreationHasard.ColWidths[ColHasLib] := 250;
    TabCreationHasard.ColWidths[ColHasJet] := 250;
    TabCreationHasard.ColWidths[ColHasLibSel] := 250;
    TabCreationHasard.ColWidths[ColHasSource] := 0;
    TabCreationHasard.ColWidths[ColHasSel] := 0;
    TabCreationHasard.ColWidths[ColHasRang] := 0;
    TabCreationHasard.ColWidths[ColHasParent] := 0;
    TabCreationHasard.ColWidths[ColHasLibSpe] := 250;
    TabCreationHasard.ColWidths[ColHasSpe] := 0;
    TabCreationHasard.Width:= 2000;

  // 5 - COMPETENCES DE RACES
     // Mise en forme dy tableau de choix des Compétences de race
     TabRaceCompetence.Options          := TabRaceCompetence.Options + [goEditing, goAlwaysShowEditor];
     TabRaceCompetence.ColCount         := 1;
     TabRaceCompetence.RowCount         := 1;
     TabRaceCompetence.ColWidths[0]     := 30;
     TabRaceCompetence.Columns.Add;
     TabRaceCompetence.Columns[0].Title.Caption      := GetTexteLibelle('LAB_001');
     TabRaceCompetence.ColWidths[1]     := 0;
     TabRaceCompetence.Columns.Add;
     TabRaceCompetence.Columns[1].Title.Caption      := GetTexteLibelle('LAB_019');
     TabRaceCompetence.ColWidths[2]     := 30;
     TabRaceCompetence.Columns[1].Alignment := taCenter;
     TabRaceCompetence.Columns.Add;
     TabRaceCompetence.Columns[2].Title.Caption      := GetTexteLibelle('LAB_009');
     TabRaceCompetence.ColWidths[3]     := 265;
     TabRaceCompetence.Columns.Add;
     TabRaceCompetence.Columns[3].Title.Caption      := '3x 5pts';
     TabRaceCompetence.ColWidths[4]     := 80;
     TabRaceCompetence.Columns.Add;
     TabRaceCompetence.Columns[4].Title.Caption      := '3x 3pts';
     TabRaceCompetence.ColWidths[5]     := 90;
     // définir la case à cocher et l'initialiser
     SetLength(CompetenceRaceStates, 6, NbMaxCompetence);
     for I := 4 to 5 do
       for J := 1 to NbMaxCompetence do
         CompetenceRaceStates[I, J] := false;

  // 6 - COMPETENCE DE METIER
     // Mise en forme dy tableau de choix des Compétences de métier
     TabMetierCompetence.Options          := TabMetierCompetence.Options + [goEditing, goAlwaysShowEditor];
     TabMetierCompetence.ColCount         := 1;
     TabMetierCompetence.RowCount         := 1;
     TabMetierCompetence.ColWidths[0]     := 30;
     TabMetierCompetence.Columns.Add;
     TabMetierCompetence.Columns[0].title.caption      := GetTexteLibelle('LAB_001');
     TabMetierCompetence.ColWidths[1]     := 0;
     TabMetierCompetence.Columns.Add;
     TabMetierCompetence.Columns[1].title.caption      := 'R';
     TabMetierCompetence.ColWidths[2]     := 30;
     TabMetierCompetence.Columns[1].Alignment:=Tacenter;
     TabMetierCompetence.Columns.Add;
     TabMetierCompetence.Columns[2].title.caption      := GetTexteLibelle('LAB_009');
     TabMetierCompetence.ColWidths[3]     := 345;
     TabMetierCompetence.Columns.Add;
     TabMetierCompetence.Columns[3].title.caption      := '40 Pts';
     TabMetierCompetence.ColWidths[4]     := 90;
     TabMetierCompetence.Columns.Add;
     TabMetierCompetence.Columns[4].title.caption      := GetTexteLibelle('LAB_078');
     TabMetierCompetence.ColWidths[5]     := 80;
     TabMetierCompetence.Columns.Add;
     TabMetierCompetence.Columns[5].title.caption      := '';
     TabMetierCompetence.ColWidths[6]     := 0;

  // 7 - EQUIPEMENT DE METIER
    // Mise en forme dy tableau de choix des équipement de métier
    TabMetierEquipement.Options          := TabMetierEquipement.Options + [goEditing, goAlwaysShowEditor];
    TabMetierEquipement.ColCount         := 7;
    TabMetierEquipement.RowCount         := 1;
    TabMetierEquipement.ColWidths[0]     := 30;
    TabMetierEquipement.Cells[1, 0]      := GetTexteLibelle('LAB_001');
    TabMetierEquipement.ColWidths[1]     := 0;
    TabMetierEquipement.Cells[2, 0]      := GetTexteLibelle('LAB_013');
    TabMetierEquipement.ColWidths[2]     := 200;
    TabMetierEquipement.Cells[3, 0]      := GetTexteLibelle('LAB_010');
    TabMetierEquipement.ColWidths[3]     := 0;
    TabMetierEquipement.Cells[4, 0]      := GetTexteLibelle('LAB_078');
    TabMetierEquipement.ColWidths[4]     := 75;
    TabMetierEquipement.Cells[5, 0]      := '';
    TabMetierEquipement.ColWidths[5]     := 0;
    TabMetierEquipement.Cells[6, 0]      := '';
    TabMetierEquipement.ColWidths[6]     := 0;

  end;

procedure TWinCreations.TabSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
  // pour ne pas pouvoir saisir dans certaines tables
  begin
    Editor := nil;
  end;

procedure TWinCreations.ChargeImageNiveau(Niveau: Integer);
  // pour afficher les images des niveaux
  begin
      Picture  := TPicture.Create;
      Bitmap   := TBitmap.Create;
      try
        Path   :=GetCurrentDir+ConstCheminImageNiveau+InttoStr(Niveau)+'.PNG';
        Picture.LoadFromFile(Path);
        Bitmap.Assign(Picture.graphic);
        ListImage.Add(Bitmap, nil); // Ajout de l'image au TImageList
        ColorLoc := Bitmap.Canvas.Pixels[1, 1];
        ColorList[Niveau] := ColorLoc;
      finally
        Picture.Free;
        Bitmap.Free;
      end;
  end;

procedure TWinCreations.LibMetierDblClick(Sender: TObject);
  begin
    MetierFenetre(MetierEnCours);
  end;

procedure TWinCreations.LibRaceDblClick(Sender: TObject);
  begin
    RaceFenetre(RaceEnCours);
  end;


////////////////////////////////////////////////////////////////////////////////
//                               PHASES                                       //
////////////////////////////////////////////////////////////////////////////////

procedure TWinCreations.PhaseSave(NouvellePhase: Integer);
  Var
    IndTab:                Integer = 0;
    NbMetierComp:          Integer = 0;
    DebMetierRec:          Integer = 0;
    row:                   Integer;
    NbAdd:                 Integer = 0;
    directoryPath:         String;
    PTalent:               StructureTalent;
    PCompetence:           StructureCompetence;
    PMetierCompetence:     StructureMetierCompetence;
    PMetierTalent:         StructureMetierTalent;
    Xp:                    Integer;
    PRace:                 StructureRace;
  Begin
    // supprimer les éléments des phases suivants
    case NouvellePhase of
      1: Begin         // Race
           Personnage.Race                              := RaceEnCours;
           Personnage.CreationAttribut                  := [];
           Personnage.CreationCompetence35              := [];
           Personnage.CreationCompetence40              := [];
           Personnage.CreationTalent                    := [];
           Personnage.Equipement                        := [];
           Personnage.MetierAncien                      := [];
           Personnage.MetierCompetence                  := [];
           Personnage.MetierTalent                      := [];
           ChargeTabMetier();
         end;

      2: begin         // Métier
           PersonnageMetier.CodeMetier   := MetierEnCours;
           PersonnageMetier.NiveauMetier := 1;
           PersonnageMetier.CoutXp       := 0;
           Personnage.MetierEnCours      := PersonnageMetier;
           Personnage.MetierAncien       += [PersonnageMetier];
         end;

      3: begin         // Attribut
           For IndTab := 1 to (TabAttribut.Rowcount-1) do
             begin
               if TabAttribut.Cells[5, IndTab] <> '' then
                 begin
                   PersonnageAttribut.CodeAttribut := TabAttribut.Cells[7, IndTab];
                   PersonnageAttribut.Valeur       := StrToIntdef(TabAttribut.Cells[5, IndTab],0);
                   Personnage.CreationAttribut     += [PersonnageAttribut];
                 end;
               if IndTab <= 10 then
                   RecapAttribut.Cells[IndTab, 1]               := TabAttribut.Cells[6, IndTab];
             end;
           RecapAttribut.visible := true;
         end;

      4: Begin         // Talents
            AjouteTalentsResolus();
            for IndTab := 1 to (TabTalent.RowCount-1) do
              begin
                if TabTalent.Cells[1, IndTab] <> '' then
                  begin
                    PersonnageTalent.CodeTalent                  := TabTalent.Cells[1, IndTab];
                    PersonnageTalent.Valeur                      := 1;
                    Personnage.CreationTalent                    += [PersonnageTalent];
                  end;
              end;
            IndTab := 0;
            For PersonnageTalent in Personnage.CreationTalent do
              Begin
                PTalent                      := ChercheTalent(PersonnageTalent.CodeTalent);
                RecapTalent.Cells[1, IndTab] := PTalent.Libelle;
                RecapTalent.Cells[2, IndTab] := PTalent.CodeTalent;
                Inc(IndTab);
              end;
            RecapTalent.visible := true;
         end;

      5: Begin         // Compétences de race
           Prace := chercheRace(RaceEnCours);
           for IndTab := 1 to TabRaceCompetence.RowCount - 1 do
             begin
               if CompetenceRaceStates[4, IndTab] then
                 begin
                   NbRaceComp                                   := NbRaceComp + 1;
                   PersonnageCompetence.CodeCompetence          := TabRaceCompetence.Cells[1, IndTab];
                   PersonnageCompetence.Valeur                  := PRace.Point3;
                   Personnage.CreationCompetence35              += [PersonnageCompetence];
                 end;
               if CompetenceRaceStates[5, IndTab] then
                 begin
                   NbRaceComp                                   := NbRaceComp + 1;
                   PersonnageCompetence.CodeCompetence          := TabRaceCompetence.Cells[1, IndTab];
                   PersonnageCompetence.Valeur                  := PRAce.Point5;
                   Personnage.CreationCompetence35              += [PersonnageCompetence];
                 end;
             end;

           IndTab := 0;
           For PersonnageCompetence in Personnage.CreationCompetence35 do
              Begin
                PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
                RecapComp.Cells[1, IndTab] := PCompetence.Libelle;
                RecapComp.Cells[2, IndTab] := IntToStr(PersonnageCompetence.Valeur);
                RecapComp.Cells[5, IndTab] := PCompetence.CodeCompetence;
                Inc(Indtab);
              end;
           RecapComp.visible := true;
         end;

      6: Begin         // Compétences des métier
           DebMetierRec := NbRaceComp;
           for IndTab := 1 to TabMetierCompetence.RowCount - 1 do
             begin
               // ajout si quantité
               if StrToIntdef(TabMetierCompetence.Cells[4, IndTab],0) > 0 then
                 begin
                   NbMetierComp                        := NbMetierComp + 1;
                   PersonnageCompetence.CodeCompetence := TabMetierCompetence.Cells[1, IndTab];
                   PersonnageCompetence.Valeur         := StrToIntdef(TabMetierCompetence.Cells[4, IndTab],0);
                   Personnage.CreationCompetence40     += [PersonnageCompetence];
                 end;
               // liste des compétesnces de ce métier
               PersonnageCompetence.CodeCompetence     := TabMetierCompetence.Cells[1, IndTab];
               PersonnageCompetence.Valeur             := 1;
               Personnage.MetierCompetence             += [PersonnageCompetence];
             end;

           for PMetierCompetence in ListMetierCompetence do
             if (PMetierCompetence.CodeMetier = MetierEnCours) and (PMetierCompetence.NiveauMetier <> 1) then
               begin
                 PersonnageCompetence.CodeCompetence := PMetierCompetence.CodeCompetence;
                 PersonnageCompetence.Valeur         := PMetierCompetence.NiveauMetier;
                 Personnage.MetierCompetence         += [PersonnageCompetence];
               end;

           IndTab := 0;
           For PersonnageCompetence in Personnage.CreationCompetence40 do
             Begin
               PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
               Row         := FindRowByText(RecapComp, PCompetence.CodeCompetence, 4);
               if Row = -1 then
                 begin
                   Row     := DebMetierRec + NbAdd;
                   NbAdd   := NbAdd + 1;
                   RecapComp.Cells[1, Row] := PCompetence.Libelle;
                   RecapComp.Cells[3, Row] := IntToStr(PersonnageCompetence.Valeur);
                   RecapComp.Cells[5, Row] := PCompetence.CodeCompetence;
                   Inc(IndTab);
                 end;
             end;

           // liste des talents de ce métier (tous niveaux)
           for PMetierTalent in ListMetierTalent do
              if (PMetierTalent.CodeMetier = MetierEnCours) then
                begin
                  PersonnageTalent.CodeTalent := PMetierTalent.CodeTalent;
                  PersonnageTalent.Valeur     := PMetierTalent.NiveauMetier;
                  Personnage.MetierTalent     += [PersonnageTalent];
                end;
         end;

      7: Begin
           for IndTab := 1 to TabMetierEquipement.RowCount - 1 do
             begin
               PersonnageEquipement.CodeEquipement          := TabMetierEquipement.Cells[1, IndTab];
               PersonnageEquipement.TypeEquipement          := TabMetierEquipement.Cells[6, IndTab];
               Personnage.Equipement                        += [PersonnageEquipement];
             end;
         end;

      8: Begin         // sauvegarde du personnage
           Xp := XmlCalculXp();
           Personnage.LivresAcceptes:=LivresPersonnages;
           directoryPath := GetCurrentDir+ConstCheminPersonnage+EditNomPersonnag.text;
           if not CreateDir(directoryPath) then
               ShowMessage(GetTexteLibelle('MESS_001')+' '+directoryPath)
           else
             begin
               PersonnageXmlCreation(Personnage, Xp, Xp, directoryPath + '\' + FormatDateTime('yyyymmdd', Date) + '-' + FormatDateTime('hhnnss', Time) + '.xml', EditNomPersonnag.text);
               NeedUpdate          := true;
               RecherchePersonnage := EditNomPersonnag.text;
               close;
             end;
         end;
      end;
  end;

Procedure TWinCreations.TalentFenetre(Choix: Integer; CodeTalent: String);
  BEGIN
    // ouvrir les Talents
    if (Choix = 1) and (FirstClick1 = true) then
        FirstClick1 := false
    else if (choix = 2) and (FirstClick2 = true) then
        FirstClick2 := false
    else if (choix = 3) and (FirstClick3 = true) then
        FirstClick3 := false
    else if (choix = 4) and (FirstClick4 = true) then
        FirstClick4 := false
    else if (CodeTalent <> '') then
      begin
        SelectWinTalent     := CodeTalent;
        FenTalent           := TWintTalent.Create(Application);
        FenTalent.Position  := poOwnerFormCenter;
        FenTalent.ShowModal;
        SelectWinTalent     := '';
        ChoixWinTalent      := '';
      end;
  end;

Procedure TWinCreations.CompetenceFenetre(CodeCompetence: String);
  BEGIN
      SelectWinCompetence     := CodeCompetence;
      FenCompetence           := TWinCompetence.Create(Application);
      FenCompetence.Position  := poOwnerFormCenter;
      FenCompetence.ShowModal;
      SelectWinCompetence     := '';
      ChoixWinCompetence      := '';
  end;

Procedure TWinCreations.RaceFenetre(CodeRace: String);
  BEGIN
      SelectWinRace     := CodeRace;
      FenRace           := TWinRace.Create(Application);
      FenRace.Position  := poOwnerFormCenter;
      FenRace.ShowModal;
      SelectWinRace     := '';
      ChoixWinRace      := '';
  end;

Procedure TWinCreations.MetierFenetre(CodeMetier: String);
  BEGIN
      SelectWinMetier     := CodeMetier;
      FenMetier           := TWinMetiers.Create(Application);
      FenMetier.Position  := poOwnerFormCenter;
      FenMetier.ShowModal;
      SelectWinMetier     := '';
      ChoixWinMetierRace  := '';
  end;


procedure TWinCreations.RecapAttributSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
  begin
    Editor := nil;
  end;

procedure TWinCreations.RecapCompDblClick(Sender: TObject);
  begin
    CompetenceFenetre(RecapComp.Cells[5, RecapComp.Row]);
  end;

procedure TWinCreations.RecapCompSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
  begin
    Editor := nil;
  end;

procedure TWinCreations.RecapTalentDblClick(Sender: TObject);
  begin
    TalentFenetre(0,RecapTalent.Cells[2,RecapTalent.Row]);
  end;

procedure TWinCreations.RecapTalentSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
  begin
    Editor := nil;
  end;

procedure TWinCreations.TabCreationHasardDblClick(Sender: TObject);
  var
    Ind:      Integer;
    Source:   String;
    CodeParentLigne:   String;
    Jet:      Integer;
    CodeTire: String;
  begin
    if TabCreationHasard.Row < 1 then Exit;

    // colonne spécialisation : choisir la spécialité du talent tiré
        if TabCreationHasard.Col = ColHasLibSpe then
          begin
            if Pos(ValeurGenerique, TabCreationHasard.Cells[ColHasSel, TabCreationHasard.Row]) = 0 then Exit;
            ChoixWinTypeFichier := ConstXmlSousChapitreTalent;
            ChoixWinTalent      := TabCreationHasard.Cells[ColHasSel, TabCreationHasard.Row];
            SelectWinTalent     := '';
            FenSpecialisation           := TWinSpecialisations.Create(Application);
            FenSpecialisation.Position  := poOwnerFormCenter;
            FenSpecialisation.ShowModal;
            if SelectWinTalent = '' then Exit;

            ShowMessage('sel=[' + SelectWinTalent + ']'
                          + ' src=[' + TabCreationHasard.Cells[ColHasSource, TabCreationHasard.Row] + ']'
                          + ' par=[' + TabCreationHasard.Cells[ColHasParent, TabCreationHasard.Row] + ']'
                          + ' rang=[' + TabCreationHasard.Cells[ColHasRang, TabCreationHasard.Row] + ']');

            for Ind := 0 to High(ListeChoixCreation) do
              if (ListeChoixCreation[Ind].CodeSource = TabCreationHasard.Cells[ColHasSource, TabCreationHasard.Row])
                 and (ListeChoixCreation[Ind].CodeParent = TabCreationHasard.Cells[ColHasParent, TabCreationHasard.Row])
                   and (ListeChoixCreation[Ind].Rang = StrToIntDef(TabCreationHasard.Cells[ColHasRang, TabCreationHasard.Row], 0)) then
                begin
                  ListeChoixCreation[Ind].CodeSpecialise := SelectWinTalent;
                  break;
                end;
            ReconstruitChoixCreation();
            Exit;
          end;

    Source := TabCreationHasard.Cells[ColHasSource, TabCreationHasard.Row];
    CodeParentLigne := TabCreationHasard.Cells[ColHasParent, TabCreationHasard.Row];

    ChoixWinJetRace := RaceEnCours;
    ChoixWinJetValeur := StrToIntDef(TabCreationHasard.Cells[ColHasJet, TabCreationHasard.Row], 0);
    ChoixWinJetDeja := ListeTalentsDejaPris(TabCreationHasard.Cells[ColHasSel, TabCreationHasard.Row]);
    FenLanceDe                 := TWinLanceDes.Create(Application);
    FenLanceDe.Position        := poOwnerFormCenter;
    FenLanceDe.ShowModal;
    ChoixWinJetDeja.Free;
    ChoixWinJetDeja := nil;
    if SelectWinJetTalent = '' then Exit;
    Jet      := SelectWinJet;
    CodeTire := SelectWinJetTalent;

    for Ind := 0 to High(ListeChoixCreation) do
          if (ListeChoixCreation[Ind].CodeSource = Source)
             and (ListeChoixCreation[Ind].CodeParent = CodeParentLigne)
               and (ListeChoixCreation[Ind].Rang = StrToIntDef(TabCreationHasard.Cells[ColHasRang, TabCreationHasard.Row], 0)) then
        begin
          ListeChoixCreation[Ind].Jet        := Jet;
          ListeChoixCreation[Ind].CodeChoisi := CodeTire;
          ListeChoixCreation[Ind].CodeSpecialise := '';
          break;
        end;

    ReconstruitChoixCreation();
  end;

procedure TWinCreations.TabCreationHasardPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
  begin
    if aRow < 1 then Exit;
    if TabCreationHasard.Cells[ColHasSel, aRow] = '' then
      TabCreationHasard.Canvas.Brush.Color := CouleurFondNot;
  end;

procedure TWinCreations.TabCreationChoixDblClick(Sender: TObject);
  var
    Ind:    Integer;
    Source: String;
    CodeParentLigne: String;
  begin
    if TabCreationChoix.Row < 1 then Exit;
    Source := TabCreationChoix.Cells[ColChoixSource, TabCreationChoix.Row];
    CodeParentLigne := TabCreationChoix.Cells[ColChoixParent, TabCreationChoix.Row];

    ChoixWinTypeFichier        := ConstXmlSousChapitreTalent;
    ChoixWinTalent             := Source;
    SelectWinTalent            := '';
    FenSpecialisation          := TWinSpecialisations.Create(Application);
    FenSpecialisation.Position := poOwnerFormCenter;
    FenSpecialisation.ShowModal;

    if SelectWinTalent <> '' then
      begin
        for Ind := 0 to High(ListeChoixCreation) do
          if (ListeChoixCreation[Ind].CodeSource = Source)
             and (ListeChoixCreation[Ind].CodeParent = CodeParentLigne)
               and (ListeChoixCreation[Ind].Rang = StrToIntDef(TabCreationChoix.Cells[ColChoixRang, TabCreationChoix.Row], 0)) then            begin
              ListeChoixCreation[Ind].CodeChoisi := SelectWinTalent;
              break;
            end;
        ReconstruitChoixCreation();
      end;
    SelectWinTalent := '';
  end;

procedure TWinCreations.TabCreationChoixPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
  begin
    if aRow < 1 then Exit;
    if TabCreationChoix.Cells[ColChoixSel, aRow] = '' then
      TabCreationChoix.Canvas.Brush.Color := CouleurFondNot;
  end;

procedure TWinCreations.TabLivreDblClick(Sender: TObject);
  var
    ind:  Integer;
  begin
    // cocher ou décocher le livre en cours (sauf RULESBOOK qui est en 1)
    if (TabLivre.Row > 1) then
      if TabLivre.Cells[2, TabLivre.Row] <> '' then
        if TabLivre.Cells[1, TabLivre.Row] <> ConstSelectionne then
          TabLivre.Cells[1, TabLivre.Row] := ConstSelectionne
        else
          TabLivre.Cells[1, TabLivre.Row] := '';

     // actualiser les livres que se personnages veut prendre en compte
     LivresPersonnages := '';
     for Ind := 1 to TabLivre.RowCount - 1 do
       if TabLivre.Cells[1, Ind] = ConstSelectionne then
         LivresPersonnages := LivresPersonnages + AjouteAccolade(TabLivre.Cells[3, Ind]);
  end;

procedure TWinCreations.TabMetierCompetenceDblClick(Sender: TObject);
  begin
    if (TabMetierCompetence.Cells[5, TabMetierCompetence.Row] = ConstArbreAuChoix) then
      begin
        ChoixWinTypeFichier         := ConstXmlSousChapitreCompetence;
        ChoixWinCompetence          := TabMetierCompetence.Cells[6, TabMetierCompetence.Row];
        FenSpecialisation           := TWinSpecialisations.Create(Application);
        FenSpecialisation.Position  := poOwnerFormCenter;
        FenSpecialisation.ShowModal;
        if SelectWinCompetence <> '' then
          begin
            TabMetierCompetence.Cells[5, TabMetierCompetence.Row] := '';
            TabMetierCompetence.Cells[1, TabMetierCompetence.Row] := SelectWinCompetence;
            TabMetierCompetence.Cells[3, TabMetierCompetence.Row] := SelWinLibelle;
          end;
      end
    else
      CompetenceFenetre(TabMetierCompetence.Cells[1, TabMetierCompetence.Row]);
  end;

procedure TWinCreations.TabMetierEquipementDblClick(Sender: TObject);
begin
  if TabMetierEquipement.Cells[2, TabMetierEquipement.Row] = ConstArbreAuChoix then
    begin
      ChoixWinTypeFichier         := ConstXmlChapitreEquipement;
      ChoixWinEquipement          := TabMetierEquipement.Cells[3, TabMetierEquipement.Row];
      FenSpecialisation           := TWinSpecialisations.Create(Application);
      FenSpecialisation.Position  := poOwnerFormCenter;
      FenSpecialisation.ShowModal;
      if SelectWinEquipement <> '' then
        begin
          TabMetierEquipement.Cells[1, TabMetierEquipement.Row] := SelectWinEquipement;
          TabMetierEquipement.Cells[2, TabMetierEquipement.Row] := SelWinLibelle;
          TabMetierEquipement.Cells[4, TabMetierEquipement.Row] := '';
          TabMetierEquipement.Cells[6, TabMetierEquipement.Row] := SelWinType;
        end;
    end;
end;

procedure TWinCreations.TabRaceCompetenceDblClick(Sender: TObject);
  begin
    CompetenceFenetre(TabRaceCompetence.Cells[1, TabRaceCompetence.Row]);
  end;

procedure TWinCreations.TabTalentDblClick(Sender: TObject);
  begin
    TalentFenetre(0, TabTalent.Cells[1, TabTalent.Row]);
  end;

procedure TWinCreations.ChangementPhase(Changement: Integer);
  var
    i: Integer;
    TabSheet: TTabSheet;
  begin
    if (PhaseEnCours <> -1) and (Changement > 0) and (not PageEtapesChange()) then
      begin
         Exit;
      end;
    PhaseSave(PhaseEnCours + changement);
    // gérer le changement de phase (avant ou arrière) pour activer/désactiver les onglets
    PhaseEnCours := PhaseEnCours + changement;
    if PhaseEnCours < PhaseDebut then PhaseEnCours := PhaseDebut;
    if PhaseEnCours > PhaseMax   then PhaseEnCours := PhaseMax;
    for i := 0 to PageEtapes.PageCount - 1 do
    begin
      TabSheet := PageEtapes.Pages[i];
      if (i = PhaseEnCours) then
        Begin
          TabSheet.TabVisible := true;
          ButtonLibellePhase.Caption := ListPhase[i];
          TabSheet.Caption := IntToStr(i+1)+' sur '+IntToStr(PhaseMax+1);
        end
      else
        TabSheet.TabVisible := False;
    end;
  end;

procedure TWinCreations.TabMetierEquipementSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
  begin
    Editor := nil;
  end;

Function TWinCreations.PageEtapesChange(): boolean;
  var
    Indtab:             Integer;
    Vide:               Integer;
    Ok:                 Boolean;
  begin
       case PhaseEnCours of
        0:   // choix de la race
         begin
           if RaceEnCours = '' then
              begin
                 ShowMessage(GetTexteLibelle('MESS_002'));
                 Result := False;
              end
           else
                 Result := true;
         end;

         1:  // choix du métier
          begin
            if MetierEnCours = '' then
               begin
                  ShowMessage(GetTexteLibelle('MESS_003'));
                  Result := False;
               end
            else
                  Result := true;
          end;

         2:  // choix des attributs
          Begin
            Vide  := 0;
            for IndTab := 1 to 10 do
              If TabAttribut.Cells[5, Indtab] = '' then
                Vide := Vide+1;

            if Vide > 0 then
                begin
                 ShowMessage(GetTexteLibelle('MESS_004'));
                 Result := False;
                end
              else
                 Result := true;
          end;

         3:  // choix des talents
                   begin
                     Ok := True;
                     if not ChoixCreationComplet() then
                       begin
                         ShowMessage(GetTexteLibelle('MESS_005'));
                         Ok := False;
                       end;
                     result := Ok;
                   end;

         4:  // choix des compétences de race
          Begin
            Ok := True;
            if (NbCinq <> 3) and (Ok) then
              begin
                ShowMessage(GetTexteLibelle('MESS_013'));
                Ok := False;
              end;
            if (NbTrois <> 3) and (Ok) then
              begin
                ShowMessage(GetTexteLibelle('MESS_014'));
                Ok := False;
              end;
            result := Ok;
          end;

         5:  // choix des compétences de métier
          begin
            Ok := True;
            if TotalMetierCompetence <> 40 then
              begin
                ShowMessage(GetTexteLibelle('MESS_015'));
                Ok := False;
              end;
            for IndTab := 1 to TabMetierCompetence.RowCount - 1 do
              if (StrToIntDef(TabMetierCompetence.Cells[4, IndTab],0) <> 0) and (TabMetierCompetence.Cells[5, IndTab] = ConstArbreAuChoix) then
                begin
                  ShowMessage(GetTexteLibelle('MESS_042'));
                  Ok := False;
                end;
            result := Ok;
          end;

         6:   // Choix des équipements
          begin
            Ok := True;
            for IndTab := 1 to TabMetierEquipement.RowCount - 1 do
              If (TabMetierEquipement.Cells[1, IndTab] = '') then
                begin
                  ShowMessage(GetTexteLibelle('MESS_016'));
                  Ok := False;
                  Break;
                end;
            result := Ok;
          end;

         7:  // choix du nom de personnage
          begin
            Ok := True;
            if EditNomPersonnag.text = '' then
              begin
                ShowMessage(GetTexteLibelle('MESS_017'));
                Ok := False;
              end
            else
              begin
                if DirectoryExists(GetCurrentDir+EditNomPersonnag.text) then
                  begin
                    ShowMessage(GetTexteLibelle('MESS_018'));
                    Ok := False;
                  end;
              end;
            result := Ok;
          end;
       end;
  end;

procedure TWinCreations.ButtonPhaseSuivanteClick(Sender: TObject);
  begin
    ChangementPhase(ConstSuivant);
  end;

////////////////////////////////////////////////////////////////////////////////
//                                 XML                                        //
////////////////////////////////////////////////////////////////////////////////

function TWinCreations.XmlCalculXp(): Integer;
  var
    Total: Integer = 0;
//    RadioGroup1.ItemIndex
  begin
    if RadioButtonRaceHasard.Checked or RadioButtonRaceResultat.Checked then
      Total := Total + 20;
    if RadioButtonMetierHasard.Checked or RadioButtonMetierResultat.checked then
      Total := Total + 50;
    if RadioButtonAttributHasard.Checked or RadioButtonAttributResultat.checked then
      Total := Total + 50
    else
      Total := Total + 25;
    Result := Total;
  end;

////////////////////////////////////////////////////////////////////////////////
//                                 RACE                                       //
////////////////////////////////////////////////////////////////////////////////

procedure TWinCreations.TabRaceDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
  begin
    // Vérifier si la ligne actuelle doit avoir une couleur spéciale
    if TabRace.Cells[4, aRow] = '1' then
      TabRace.Canvas.Brush.Color := clLtGray  // Changer la couleur de fond en vert
    else
      TabRace.Canvas.Brush.Color := clWhite; // Utiliser la couleur de fond par défaut

    // Dessiner la cellule avec la couleur modifiée
    TabRace.Canvas.FillRect(aRect);
    TabRace.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2, TabRace.Cells[aCol, aRow]);
  end;

procedure TWinCreations.TabRacePrepareCanvas(Sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
  begin
    if (ARow = 0) then
    begin
      TabRace.Canvas.Brush.Color := clBtnFace; // Couleur de fond de l'en-tête désactivé
      TabRace.Canvas.Font.Color := ClBlack; // Couleur du texte de l'en-tête désactivé
    end;
  end;

Procedure TWinCreations.ChargeTabRaces(Livre: String='');
  Var
    IndTabRace:    Integer;
    PRaceCreation: StructureRaceCreation;
    PRace:         StructureRace;
    OldLivre:      String = '';
    Ind:           Integer;
  Begin
    if Livre = '' then
      begin
        ComboRaceCreation.Style    := csDropDownList;
        for PRaceCreation in ListRaceCreation do
          begin
            if OldLivre <> PRaceCreation.Livre then
              begin
                ComboRaceCreation.Items.add(PRaceCreation.Livre);
                OldLivre := PRaceCreation.Livre
              end;
          end;
        Livre := ConstRulesBook;
        for ind := 0 to ComboRaceCreation.items.count -1 do
          if ComboRaceCreation.items[Ind] = Livre then
            begin
              ComboRaceCreation.itemindex := Ind;
              break;
            end;

      end;

    if TabRace.RowCount>0 then
      begin
        ClearStringGrid(TabRace);
        TabRace.Rowcount := 1;
      end;

    IndTabRace        := 0;

    For PRaceCreation in ListRaceCreation do
      begin
        if PRaceCreation.Livre = Livre then
          begin
            PRace := chercheRace(PRaceCreation.CodeRace);
            Inc(IndTabRace);
            TabRace.Rowcount := IndTabRace+1;
            TabRace.Cells[1, IndTabRace] := PRace.CodeRace;
            TabRace.Cells[2, IndTabRace] := PRace.Libelle;
            TabRace.Cells[3, IndTabRace] := PRaceCreation.Chance;
          end;
    end;
    AdjustGridColumnsWidth(TabRace,0,false,false);
  end;

procedure TWinCreations.ButtonRaceHasardClick(Sender: TObject);
  begin
       LastRandomRaceResultat := (Random(99) + 1);
       TabRaceResultat(LastRandomRaceResultat);
       AfficheImageRace();
       UpdateSheetRace(true);
  end;

procedure TWinCreations.ButtonRaceValiderClick(Sender: TObject);
  begin
       if (EditRaceResultat.Value = 0) then
          ShowMessage(GetTexteLibelle('MESS_19'))
       else
       begin
         LastCheckRaceResultat := EditRaceResultat.Value;
         TabRaceResultat(LastCheckRaceResultat);
         AfficheImageRace();
         UpdateSheetRace(true);
       end
  end;

Procedure TWinCreations.AfficheImageRace();
  Var
    indTabAttribut:          integer;
    Talent1:                 String;
    Talent2:                 String;
    Multi:                   boolean;
    NbMulti:                 Integer;
    NbTalentTab:             Integer;
    PTalent:                 StructureTalent;
    PRaceTalent:             StructureRaceTalent;
    PRaceAttribut:           StructureRaceAttribut;
    CheminImage1:            String;
    CheminImage2:            String;

  begin
    NbMulti                  := 0;
    NbTalentTab              := 0;
    NbGenerique              := 0;
    NbRaceCompetenceTab      := 0;


    if RaceEnCours <> '' then
      begin
       CheminImage1       := CheminRaceImage(RaceEnCours,'2');
       CheminImage2       := CheminRaceImage(RaceEnCours,'1');
       end
    else
      begin
        CheminImage1       := '';
        CheminImage2       := '';
      end;
    if FileExists(CheminImage1) then
       ImageRace1.Picture.LoadFromFile(CheminImage1)
    else
       ImageRace1.Picture := nil;

    if FileExists(CheminImage2) then
       ImageRace2.Picture.LoadFromFile(CheminImage2)
    else
       ImageRace2.Picture := nil;

    LibRace.Text            := RaceLibEnCours;
    LibRace.visible         := (RaceLibEnCours <> '');

    UpdateSheetRace(false);

    // ATTRIBUTS

    For PRaceAttribut in ListRaceAttribut do
      if CompareRechercheValeur(PRaceAttribut.CodeRace, RaceEnCours) then
        for IndTabAttribut := 0 to TabAttribut.RowCount -1 do
           if TabAttribut.Cells[7, IndTabAttribut] = PRaceAttribut.CodeAttribut then
             begin
                TabAttribut.Cells[4, IndTabAttribut] := PRaceAttribut.CalculRace;
                if CompareRechercheValeur(PRaceAttribut.CodeAttribut, ConstCaracPointSupp) then
                  begin
                    LabPointSupp.Text           := PRaceAttribut.CalculRace+' '+GetTexteLibelle('LAB_119');
                    TrackBarPointSupp.Min       := 0;
                    TrackBarPointSupp.Max       := StrToInt(PRaceAttribut.CalculRace);
                    TrackBarPointSupp.Frequency := 1;
                  end;
             end;

    // TALENTS

    For PRaceTalent in ListRaceTalent do
      if CompareRechercheValeur(PRaceTalent.CodeRace, RaceEnCours) then
        Begin
          Talent2 := '';
          Multi   := (pos(SeparateurMulti, PRaceTalent.CodeTalent) > 0);
          if Multi then
             Begin
               NbMulti := NbMulti+1;
               Talent1 := ExtractStringBefore(PRaceTalent.CodeTalent, SeparateurMulti);
               Talent2 := ExtractStringAfter(PRaceTalent.CodeTalent, SeparateurMulti);
             end
          else
             begin
               Talent1 := PRaceTalent.CodeTalent;
             end;

          For PTalent in ListTalent do
            if CompareRechercheValeur(PTalent.CodeTalent, Talent1) and CompareRechercheValeur(PTalent.CodeTalent, TalentGenerique) then
               Begin
                 NbGenerique     := NbGenerique + 1;
               end
            else if CompareRechercheValeur(PTalent.CodeTalent, Talent1) then
              begin
                  if not multi then
                    Begin
                      NbTalentTab                     := NbTalentTab + 1;
                      TabTalent.Cells[1, NbTalentTab] := PTalent.CodeTalent;
                      TabTalent.Cells[2, NbTalentTab] := PTalent.Libelle;
                    end;
              end;
        end;
    ReconstruitChoixCreation();
    ButtonTalentHasard.visible   := (NbGenerique > 0) or (NbMulti > 0);
    ButtonTalentHasard.BringToFront;
  end;

procedure TWinCreations.TabRaceResultat(Resul: Integer);
  var
    IndTab: Integer;
    Deb: Integer;
    Fin: Integer;
    Ch: String;
    IndS: Integer;
    Trouve: Boolean = false;
    PRace: StructureRace;
  begin
    for IndTab := 1 to TabRace.RowCount - 1 do
      begin
        Ch := TabRace.Cells[3, IndTab];
        IndS := Pos(SeparateurChance, Ch);
        if IndS > 0 then
          begin
            Deb := StrToInt(Copy(Ch, 1, IndS-1));
            Fin := StrToInt(Copy(Ch, IndS+1, Length(Ch)));
          end
        else
          begin
            Deb := StrToInt(Ch);
            Fin := StrToInt(Ch);
          end;

        if ChoixWinRace <> '' then
          begin
            if TabRace.Cells[1, Indtab] = ChoixWinRace then
              begin
                IndS := Pos(SeparateurChance, Ch);
                if IndS > 0 then
                  Resul := StrToInt(Copy(Ch, 1, IndS-1))
                else
                  Resul := StrToInt(Ch);
              end
            else
              Deb := 101;
          end;

        if (Deb <= Resul) and (Resul <= Fin) then
          begin
            RaceEnCours              := TabRace.Cells[1, indTab];
            RaceLibEnCours           := TabRace.Cells[2, indTab];
            TabRace.Cells[4, IndTab] := '1';
            TabRace.Invalidate;
            Break;
            Trouve := True;
          end;
      end;
    if (ChoixWinRace <> '') and not Trouve then
      begin
        PRace          := chercheRace(ChoixWinRace);
        RaceEnCours    := Prace.CodeRace;
        RaceLibEnCours := PRace.Libelle;
      end;
  end;

procedure TWinCreations.RadioButtonRaceClick(Sender: TObject);
  begin
    LastRandomRaceResultat := 0;
    LastCheckRaceResultat  := 0;
    RaceEnCours            := '';
    RaceLibEnCours         := '';
    TabRaceResultat(0);
    AfficheImageRace();
    UpdateSheetRace(false);
  end;

procedure TWinCreations.RadioButtonRaceHasardClick(Sender: TObject);
  begin
    LastRandomRaceResultat := 0;
    LastCheckRaceResultat  := 0;
    RaceEnCours            := '';
    RaceLibEnCours         := '';
    TabRaceResultat(0);
    AfficheImageRace();
    UpdateSheetRace(false);
  end;

procedure TWinCreations.UpdateSheetRace(Hasard: Boolean);
  Begin
    // Au Hasard
    ButtonRaceHasard.Visible  := RadioButtonRaceHasard.Checked;
    ButtonRaceHasard.Enabled  := (LastRandomRaceResultat = 0);
    ButtonRaceHasard.BringToFront;

    // donner le résultat de votre lancé de dé
    EditRaceResultat.Visible  := RadioButtonRaceResultat.Checked;
    EditRaceResultat.enabled  := (LastCheckRaceResultat = 0);
    ButtonRaceValider.Visible := RadioButtonRaceResultat.Checked;
    ButtonRaceValider.Enabled := (LastCheckRaceResultat = 0);
    ButtonRaceValider.BringToFront;

    // choisir votre race
    ButtonRaceSelectionner.visible := RadioButtonRaceChoix.Checked;
    ButtonRaceSelectionner.BringToFront;

    // choisir les livres ou les règles
    ComboRaceCreation.Enabled := (not RadioButtonRaceHasard.Checked and not RadioButtonRaceResultat.Checked and not RadioButtonRaceChoix.Checked);
    TabLivre.Enabled          := (not RadioButtonRaceHasard.Checked and not RadioButtonRaceResultat.Checked and not RadioButtonRaceChoix.Checked);

    if Hasard then
      GroupBoxRace.enabled    := false;

  end;


////////////////////////////////////////////////////////////////////////////////
//                               METIER                                       //
////////////////////////////////////////////////////////////////////////////////

procedure TWinCreations.TabMetierPrepareCanvas(Sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
  begin
    TabMetier.Canvas.Brush.Color := clBtnFace; // Couleur de fond de l'en-tête désactivé
    TabMetier.Canvas.Font.Color := ClBlack; // Couleur du texte de l'en-tête désactivé
  end;

procedure TWinCreations.TabMetierDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
  begin
    // Vérifier si la ligne actuelle doit avoir une couleur spéciale
    if TabMetier.Cells[4, aRow] = '1' then
      TabMetier.Canvas.Brush.Color := clLtGray  // Changer la couleur de fond en vert
    else
      TabMetier.Canvas.Brush.Color := clWhite; // Utiliser la couleur de fond par défaut

    // Dessiner la cellule avec la couleur modifiée
    TabMetier.Canvas.FillRect(aRect);
    TabMetier.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2, TabMetier.Cells[aCol, aRow]);
  end;

Procedure TWinCreations.ChargeTabMetier();
  Var
    IndTabMetier:  Integer;
    PMetier:       StructureMetier;
    PRaceMetier:   StructureRaceMetier;
  Begin
    IndTabMetier        := 0;
    TabMetier.RowCount  := 1;
    For PRaceMetier in ListRaceMetier do
      if CompareRechercheValeur(PRaceMetier.CodeRace, RaceEnCours) and (PRaceMetier.Chance <> SeparateurChance) and (PRaceMetier.Chance <> 'X') then //and (PRaceMetier.Livre = ConstRulesBook) then
        begin
            PMetier := ChercheMetier(PRaceMetier.CodeMetier);
            Inc(IndTabMetier);
            TabMetier.RowCount  := TabMetier.RowCount + 1;
            TabMetier.Cells[1, IndTabMetier] := PMetier.CodeMetier;
            TabMetier.Cells[2, IndTabMetier] := PMetier.Libelle;
            TabMetier.Cells[3, IndTabMetier] := PRAceMetier.Chance;
        end;
    AdjustGridColumnsWidth(TabMetier, PageEtapes.Height, false, false);
  end;

procedure TWinCreations.ButtonMetierHasardClick(Sender: TObject);
  begin
     LastRandomMetierResultat := (Random(99) + 1);
     TabMetierResultat(LastRandomMetierResultat);
     AfficheImageMetier();
     UpdateSheetMetier(true);
  end;

Procedure TWinCreations.AfficheImageMetier();
var
  indTabAttribut:     integer;
  PCompetence:        StructureCompetence;
  PRaceCompetence:    StructureRaceCompetence;
  PMetierAttribut:    StructureMetierAttribut;
  PMetierCompetence:  StructureMetierCompetence;
  PMetierEquipement:  StructureMetierEquipement;
  PArme:              StructureArme;
  PArmure:            StructureArmure;
  ListeCode:          String;
  Code:               String;
  Lib:                String;
  Typ:                String;
  CheminImage1:       String;

begin
  if MetierEnCours <> '' then
     CheminImage1       := CheminMetierImage(MetierEnCours)
  else
      CheminImage1      := '';

  if FileExists(CheminImage1) then
     ImageMetier.Picture.LoadFromFile(CheminImage1)
  else
     ImageMetier.Picture := nil;

  LibMetier.Text            := MetierLibEnCours;
  LibMetier.visible         := (MetierLibEnCours <> '');

  UpdateSheetMetier(false);

  For PMetierAttribut in ListMetierAttribut do
    if CompareRechercheValeur(PMetierAttribut.CodeMetier, MetierEnCours) then
      for IndTabAttribut := 0 to TabAttribut.RowCount -1 do
        if (TabAttribut.Cells[7, IndTabAttribut] = PMetierAttribut.CodeAttribut) and (PMetierAttribut.NiveauMetier > 0) then
          TabAttribut.Cells[2, IndTabAttribut] := IntToStr(PMetierAttribut.NiveauMetier);

  // COMPETENCES
  if MetierEnCours <> '' then
   begin
    // Compétences de race
    NbRaceCompetenceTab          := 0;
    TabRaceCompetence.RowCount   := 1;
    NbRaceComp                   := 0;
    For PRaceCompetence in ListRaceCompetence do
      if CompareRechercheValeur(PRaceCompetence.CodeRace, RaceEnCours) then
        Begin
           NbRaceCompetenceTab                             := NbRaceCompetenceTab + 1;
           TabRaceCompetence.RowCount                      := NbRaceCompetenceTab + 1;
           TabRaceCompetence.Cells[1,NbRaceCompetenceTab]  := PRaceCompetence.CodeCompetence;
           PCompetence                                     := ChercheCompetence(PRaceCompetence.CodeCompetence);
           TabRaceCompetence.Cells[3,NbRaceCompetenceTab]  := PCompetence.Libelle;
           PMetierCompetence                               := ChercheMetierCompetence(MetierEnCours,PRaceCompetence.CodeCompetence);
           if PMetierCompetence.CodeMetier <> '' then
             TabRaceCompetence.Cells[2,NbRaceCompetenceTab]:= IntToStr(PMetierCompetence.NiveauMetier);
        end;
    TabRaceCompetence.Height      := TabRaceCompetence.DefaultRowHeight * TabRaceCompetence.RowCount + 5;
    AdjustGridColumnsWidth(TabRaceCompetence, PageEtapes.Height, false, true);

    // Compétences de Métier
    NbMetierCompetenceTab         := 0;
    TabMetierCompetence.RowCount  := 1;
    NbTrois                       := 0;
    NbCinq                        := 0;
    for PMetierCompetence in ListMetierCompetence do
      if CompareRechercheValeur(PMetierCompetence.CodeMetier, MetierEnCours) and (PMetierCompetence.NiveauMetier = 1) then
        Begin
             NbMetierCompetenceTab        := NbMetierCompetenceTab + 1;
             TabMetierCompetence.RowCount := NbMetierCompetenceTab + 1;
             TabMetierCompetence.Cells[1,NbMetierCompetenceTab] := PMetierCompetence.CodeCompetence;
             PCompetence                  := ChercheCompetence(PMetierCompetence.CodeCompetence);
             TabMetierCompetence.Cells[3,NbMetierCompetenceTab] := PCompetence.Libelle;

             if (Pos(ValeurGenerique, PCompetence.CodeCompetence) > 0) or (pos(SeparateurMulti, PCompetence.CodeCompetence) > 0) then
               begin
                 TabMetierCompetence.Cells[5,NbMetierCompetenceTab] := ConstArbreAuChoix;
                 TabMetierCompetence.Cells[6,NbMetierCompetenceTab] := PCompetence.CodeCompetence;
               end;

             PRaceCompetence              := ChercheRaceCompetence(RaceEnCours,PMetierCompetence.CodeCompetence);
             if PRaceCompetence.CodeCompetence <> '' then
                TabMetierCompetence.Cells[2,NbMetierCompetenceTab] := IntToStr(PMetierCompetence.NiveauMetier);
         end;
    TabMetierCompetence.Height          := TabMetierCompetence.DefaultRowHeight * TabMetierCompetence.RowCount + 5;
    CalculTotalMetierCompetence();
    AdjustGridColumnsWidth(TabMetierCompetence, PageEtapes.Height, false, true);

    // Equipement de métier
    NbMetierEquipementTab        := 0;
    TabMetierEquipement.RowCount := 1;
    For PMetierEquipement in ListMetierEquipement do
      if CompareRechercheValeur(PMetierEquipement.CodeMetier, MetierEnCours) and (PMetierEquipement.NiveauMetier = 1) then
        Begin
           NbMetierEquipementTab        := NbMetierEquipementTab + 1;
           TabMetierEquipement.RowCount := NbMetierEquipementTab + 1;
           ListeCode                    := GetListeEquipement(PMetierEquipement.Equipement, PMetierEquipement.TypeEquipement);

           if Pos(',',ListeCode) > 0 then
             begin
               TabMetierEquipement.Cells[2, NbMetierEquipementTab]   := ConstArbreAuchoix;
               TabMetierEquipement.Cells[3, NbMetierEquipementTab]   := ListeCode;
             end
           else
             begin
               Code := PMetierEquipement.Equipement;
               if InList(PMetierEquipement.TypeEquipement,TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                   begin
                     PArme   := ChercheArme(Code);
                     Lib     := PArme.Libelle;
                     Typ     := TypeEquipWe;
                   end
                 else if PMetierEquipement.TypeEquipement = TypeEquipAR then
                   begin
                     PArmure := ChercheArmure(Code);
                     Lib     := PArmure.Libelle;
                     Typ     := TypeEquipAr;
                   end
                 else if PMetierEquipement.TypeEquipement = TypeEquipDI then
                   begin
                     Lib     := Code;
                     Typ     := TypeEquipDi;
                   end;
               TabMetierEquipement.Cells[1, NbMetierEquipementTab] := Code;
               TabMetierEquipement.Cells[2, NbMetierEquipementTab] := Lib;
               TabMetierEquipement.Cells[6, NbMetierEquipementTab] := Typ;
             end;

        end;
    AdjustGridColumnsWidth(TabMetierEquipement, PageEtapes.Height, false, true, true, 10);
   end;
end;

procedure TWinCreations.ButtonMetierValiderClick(Sender: TObject);
begin
     if (EditMetierResultat.Value = 0) then
        ShowMessage(GetTexteLibelle('MESS_019'))
     else
     begin
       LastCheckMetierResultat := EditMetierResultat.Value;
       TabMetierResultat(LastCheckMetierResultat);
       AfficheImageMetier();
       UpdateSheetMetier(true);
     end
end;

procedure TWinCreations.RadioButtonMetierHasardClick(Sender: TObject);
  begin
    LastRandomMetierResultat := 0;
    LastCheckMetierResultat  := 0;
    LastCheckMetierSousMetierResul := 0;
    MetierEnCours            := '';
    MetierLibEnCours         := '';
    TabMetierResultat(0);
    AfficheImageMetier();
    UpdateSheetMetier(false);
  end;

procedure TWinCreations.RadioButtonMetierClick(Sender: TObject);
  begin
    LastRandomMetierResultat := 0;
    LastCheckMetierResultat  := 0;
    LastCheckMetierSousMetierResul := 0;
    MetierEnCours            := '';
    MetierLibEnCours         := '';
    TabMetierResultat(0);
    AfficheImageMetier();
    UpdateSheetMetier(false);
  end;

procedure TWinCreations.UpdateSheetMetier(Hasard: Boolean);
  Begin
    // Au Hasard
    ButtonMetierHasard.Visible  := RadioButtonMetierHasard.Checked;
    ButtonMetierHasard.Enabled  := (LastRandomMetierResultat = 0);
    ButtonMetierHasard.BringToFront;

    // donner le résultat de votre lancé de dé
    EditMetierResultat.Visible  := RadioButtonMetierResultat.Checked;
    EditMetierResultat.enabled  := (LastCheckMetierResultat = 0);
    ButtonMetierValider.Visible := RadioButtonMetierResultat.Checked;
    ButtonMetierValider.Enabled := (LastCheckMetierResultat = 0);
    ButtonMetierValider.BringToFront;

    // choisir votre Metier
    ButtonMetierSelectionner.visible:= RadioButtonMetierChoix.Checked;
    ButtonMetierSelectionner.BringToFront;

    if Hasard then
       GroupBoxMetier.Enabled   := false;
  end;

////////////////////////////////////////////////////////////////////////////////
//                             ATTRIBUTS                                      //
////////////////////////////////////////////////////////////////////////////////


procedure TWinCreations.RadioButtonAttributClick(Sender: TObject);
  begin
    UpdateSheetAttribut(false);
    CalculTabAttribut(false, (ModDesti=false));
    TabAttributLanceDeClickCombo();
  end;

procedure TWinCreations.TabAttributLanceDeEditingDone(Sender: TObject);
  var
    CellValue: Integer;
  begin
    if (FEditingRow = 1) and (FEditingCol > 0) then
    begin
      // Récupérer la valeur de la cellule
      CellValue := StrToIntDef(TabAttributLanceDe.Cells[FEditingCol, FEditingRow], 0);

      // Vérifier les limites de valeur
      if (CellValue > 0) and ((CellValue < 2) or (CellValue > 20)) then
      begin
        // Rétablir la valeur précédente
        TabAttributLanceDe.Cells[FEditingCol, FEditingRow] := '';
        ShowMessage(GetTexteLibelle('MESS_020'));
      end;
    end;
  end;

procedure TWinCreations.TabAttributLanceDeSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
  var
    ComboBoxAttribut: TComboBox;
    cellRect: TRect;
  begin
    FEditingCol := aCol;
    FEditingRow := aRow;
    CanSelect := true;

    if (CanSelect = True) and (aRow = 2) then
    Begin
      ComboBoxAttribut := TabAttributLanceDe.Objects[ACol, ARow] as TComboBox;
      if Assigned(ComboBoxAttribut) then
      begin
        // Récupérer la cellule sélectionnée
        cellRect := TabAttributLanceDe.CellRect(aCol, aRow);

        // Afficher le composant TComboBox dans la cellule sélectionnée
        ComboBoxAttribut.SetBounds(cellRect.Left, cellRect.Top, cellRect.Width, cellRect.Height);
        ComboBoxAttribut.Visible := True;
      end;
    end;
  end;

procedure TWinCreations.TabAttributDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  ImageIndex: Integer;
  CellWidth, CellHeight: Integer;
  MaxWidth, MaxHeight, ImageWidth, ImageHeight: Integer;
  AspectRatio: Double;
  LeftOffset, TopOffset: Integer;
  ImageRect: TRect;
  TopLeftPixelColor: TColor;
  Bitmap: TBitmap;
begin

  if (aRow > 0) then
    begin
      TabAttribut.Canvas.Font.Color := clBlack;
      if (aCol = 2) then
        begin
          // Récupérer la valeur de la cellule correspondante (colonne 2)
          ImageIndex := StrToIntDef(TabAttribut.Cells[aCol, aRow], -1);

          // Vérifier que la valeur est valide et se situe dans la plage d'index d'image
          if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
            begin
              // Calculer la taille de la cellule
              CellWidth := aRect.Right - aRect.Left;
              CellHeight := aRect.Bottom - aRect.Top;

              // Calculer la taille maximale pour l'image en utilisant la taille de la cellule
              // et en ajustant l'aspect ratio de l'image
              MaxWidth := CellWidth;
              MaxHeight := CellHeight;
              ImageWidth := ListImage.Width;
              ImageHeight := ListImage.Height;
              if ImageWidth > 0 then
                begin
                  AspectRatio := ImageHeight / ImageWidth;
                  if ImageWidth > MaxWidth then
                    begin
                      ImageWidth := MaxWidth;
                      ImageHeight := Round(ImageWidth * AspectRatio);
                    end;
                  if ImageHeight > MaxHeight then
                    begin
                      ImageHeight := MaxHeight;
                      ImageWidth := Round(ImageHeight / AspectRatio);
                    end;
                end;

              // Calculer la position de l'image pour centrer verticalement et horizontalement
              // dans la cellule
              LeftOffset := (CellWidth - ImageWidth) div 2;
              TopOffset := (CellHeight - ImageHeight) div 2;
              ImageRect := Rect(aRect.Left + LeftOffset, aRect.Top + TopOffset, aRect.Left + LeftOffset + ImageWidth, aRect.Top + TopOffset + ImageHeight);

              // Obtenir la couleur du pixel en haut à gauche de l'image
              Bitmap := TBitmap.Create;
              try
                ListImage.GetBitmap(ImageIndex, Bitmap);
                TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
              finally
                Bitmap.Free;
              end;

              // Dessiner l'image dans la cellule avec la taille ajustée
              ListImage.Draw(TabAttribut.Canvas, ImageRect.Left, ImageRect.Top, ImageIndex);
            end
          else
            // Dessiner du texte par défaut si la valeur de l'index d'image est invalide
            TabAttribut.DefaultDrawCell(aCol, aRow, aRect, aState);
        end
      else if (aCol >= 3) and (aCol <= 6) then
        begin
          // Obtenir la couleur du pixel en haut à gauche de l'image de la cellule précédente (colonne 2)
          Bitmap := TBitmap.Create;
          try
            ImageIndex := StrToIntDef(TabAttribut.Cells[2, aRow], -1);
            if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
              begin
                ListImage.GetBitmap(ImageIndex, Bitmap);
                TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
              end
            else
              TopLeftPixelColor := clNone;
          finally
            Bitmap.Free;
          end;

          // Changer la couleur de fond de la cellule avec la couleur du pixel en haut à gauche de l'image
          if TopLeftPixelColor <> clNone then
            begin
              TabAttribut.Canvas.Brush.Color := TopLeftPixelColor;
              TabAttribut.Canvas.FillRect(aRect);
            end;

          // Changer la couleur du texte pour les colonnes 3 à 6
          TabAttribut.Canvas.Font.Color := clBlack;

          // Dessiner le texte de la cellule
          TabAttribut.DefaultDrawCell(aCol, aRow, aRect, aState);
        end
      else
        begin
          // Dessiner normalement le contenu textuel des autres cellules
          TabAttribut.DefaultDrawCell(aCol, aRow, aRect, aState);
        end;
    end
  else
    TabAttribut.DefaultDrawCell(aCol, aRow, aRect, aState);
end;

procedure TWinCreations.TabAttributSelectEditor(Sender: TObject; aCol, aRow: Integer; var Editor: TWinControl);
  begin
      // seul le lancé de dé est modifiable
    if (aCol <> 5)  then
      Editor := nil;
  end;

procedure TWinCreations.TrackBarPointSuppChange(Sender: TObject);
  begin
    // Récupérer la valeur actuelle du TrackBar
    CalculTabAttribut(false, (ModDesti=false));
  end;

Procedure TWinCreations.ChargeTabAttribut();
  Var
    IndTabAttribut:  Integer;
    PAttribut:       StructureAttribut;
  Begin
    IndTabAttribut        := 0;
    For PAttribut in ListeAttribut do
      begin
        Inc(IndTabAttribut);
        TabAttribut.Cells[1, IndTabAttribut] := PAttribut.Resume;
        TabAttribut.Cells[3, IndTabAttribut] := PAttribut.Libelle;
        TabAttribut.Cells[7, IndTabAttribut] := PAttribut.CodeAttribut;
      end;
  end;

procedure TWinCreations.TabAttributLanceDeSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
  begin
    if aRow = 1 then
      Begin
        CalculTabAttribut(false, false);
      end;
  end;

procedure TWinCreations.TabAttributLanceDeClickCombo();
  Var
    CellRect:             TRect;
    I:                    Integer;
  begin
    for I := 1 to 11 do
      begin
        CellRect := TabAttributLanceDe.CellRect(I, 2);
        // simuler un click de souris
        TabAttributLanceDe.Perform(WM_LBUTTONDOWN, 0, CellRect.Left or (CellRect.Top shl 16));
        TabAttributLanceDe.Perform(WM_LBUTTONUP, 0, CellRect.Left or (CellRect.Top shl 16));
      end;
  end;

procedure TWinCreations.ButtonAttributHasardClick(Sender: TObject);
  begin
    CalculTabAttribut(True, (RadioButtonAttributHasard.checked));
    UpdateSheetAttribut(true);
  end;

procedure TWinCreations.CalculTabAttribut(Hasard: Boolean; Affectation: Boolean);
var
  PartDe:               String;
  TypeDe:               Integer;
  NbDe:                 Integer;
  PlusDe:               Integer;
  TotalDe:              Integer;
  I,J:                  Integer;
  Ch:                   String;
  IndS:                 Integer;
  TotL:                 Integer;
  ComboBoxAttribut:     TComboBox;
  Index:                Integer;
  Car:                  String;
  ColCombo, RowCombo:   Integer;
  BF, BE, BFM:          Integer;
begin
  TotL := 0;
    // vider les colonnes
    For I:= 1 to TabAttribut.RowCount -1 do
    begin
      TabAttribut.Cells[5, I] := '';
      TabAttribut.Cells[6, I] := '';
    end;

  For I:= 1 to TabAttribut.RowCount -1 do
    begin
      Ch := TabAttribut.Cells[4, I];
      if I <= 10 then
      // caractéristoqies normales
          begin
            // séparer les dé du bonus
            IndS := Pos('+', Ch);
            PartDe := Copy(Ch, 1, IndS-1);
            PlusDe := StrToInt(Copy(Ch, IndS+1, Length(Ch)));
            // séparer le nombre de dé du type
            IndS := Pos('d', PartDe);
             if IndS > 0 then
               begin
                 NbDe  := StrToInt(Copy(PartDe, 1, IndS-1));
                 TypeDe:= StrToInt(Copy(PartDe, IndS+1, Length(PartDe)));
               end
             else
               begin
                 NbDe  := 1;
                 TypeDe:= StrToInt(Copy(PartDe, 2, IndS));
               end;

             if Hasard then
               begin
                 TotalDe    := 0;
                 for J := 1 to NbDe Do
                   TotalDe := TotalDe + (Random(TypeDe-1) + 1);
                 TabAttributLanceDe.Cells[i, 1] := intToStr(TotalDe);
               end
             else
                TotalDe := StrToIntDef(TabAttributLanceDe.Cells[i, 1],0);

             TotL := TotL + TotalDe;
             Index:= -1;
             ComboBoxAttribut := TabAttributLanceDe.Objects[I, 2] as TComboBox;
             if Affectation then
               begin
                 Car                        := TabAttribut.cells[1, I];
                 Index                      := ComboBoxAttribut.Items.IndexOf(Car);
                 if Index > 0 then
                   begin
                    ComboBoxAttribut.enabled   := true;
                    ComboBoxAttribut.ItemIndex := Index;
                    ColCombo                   := I;
                   end
               end
             else
               begin
                 Car   := ComboBoxAttribut.Text;
                 if Car <> ValeurNonRenseignee then
                   begin
                     Index := ComboBoxAttribut.Items.IndexOf(Car);
                     TabAttributLanceDe.MouseToCell(ComboBoxAttribut.Left, ComboBoxAttribut.Top, ColCombo, RowCombo);
                   end
               end;

          if Index > 0 then
            begin
              TabAttribut.Cells[5, Index] := TabAttributLanceDe.Cells[ColCombo, 1];
              TabAttribut.Cells[6, Index] := IntToStr(StrToIntDef(TabAttributLanceDe.Cells[Index, 1],0)+ PlusDe);
              if TabAttribut.Cells[7, Index] = ConstCaracE then
                BE := StrToInt(TabAttribut.Cells[6, Index])
              else if TabAttribut.Cells[7, Index] = ConstCaracF then
                BF := StrToInt(TabAttribut.Cells[6, Index])
              else if TabAttribut.Cells[7, Index] = ConstCaracFM then
                BFM := StrToInt(TabAttribut.Cells[6, Index]);
              end
          end
     else if TabAttribut.Cells[7, I] = ConstCaracBlessure then
       begin
          TabAttribut.Cells[6, I] := IntToStr(CalculBlessure(Ch, BF, BE, BFM));
       end
     else if TabAttribut.Cells[7, I] = ConstCaracDestin then
       begin
         TabAttribut.Cells[5, I]  := IntToStr(TrackBarPointSupp.Max - TrackBarPointSupp.Position);
          TabAttribut.Cells[6, I] := IntToStr(StrToInt(TabAttribut.Cells[4, I]) + StrToIntDef(TabAttribut.Cells[5, I],0));
       end
     else if TabAttribut.Cells[7, I] = ConstCaracResil then
       begin
         TabAttribut.Cells[5, I] := IntToStr(TrackBarPointSupp.Position);
         TabAttribut.Cells[6, I] := IntToStr(StrToInt(TabAttribut.Cells[4, I]) + StrToIntDef(TabAttribut.Cells[5, I],0));
       end
    end;
    TabAttributLanceDe.Cells[11, 1] := InttoStr(TotL);
    UpdateSheetAttribut(false);
end;

procedure TWinCreations.ComboBoxSelectAttribut(Sender: TObject);
Var
   AttEnCours:        String;
   AttLigne:          String;
   ComboBoxAttribut:  TCombobox;
   Col, Row, C:       Integer;
   Index:             Integer;
begin
  ComboBoxAttribut := Sender as TComboBox;
  TabAttributLanceDe.MouseToCell(ComboBoxAttribut.Left, ComboBoxAttribut.Top, Col, Row);

  AttEnCours       := ComboBoxAttribut.Text;

  //// voir si elle n'est pas déjà utilisée
  for C := 1 to TabAttributLanceDe.colCount -2 do
    if (C <> Col) then
      begin
        ComboBoxAttribut :=   TabAttributLanceDe.Objects[C, TabAttributLanceDe.Row] as TComboBox;
        if Assigned(ComboBoxAttribut) then
          begin
            AttLigne       := ComboBoxAttribut.Text;

            if (AttLigne <> '') and (AttLigne = AttEncours) then
               begin
                  Index := ComboBoxAttribut.Items.IndexOf(ValeurNonRenseignee);
                  ComboBoxAttribut.ItemIndex := Index;
               end;
          end;
      end;

  CalculTabAttribut(False, (RadioButtonAttributHasard.checked));
end;

procedure TWinCreations.UpdateSheetAttribut(Hasard: boolean);
Begin
  ButtonAttributHasard.Visible    := (RadioButtonAttributHasard.Checked or RadioButtonAttributHasardAffecte.Checked);
  ButtonAttributHasard.BringToFront;
  ModDesti                        := (RadioButtonAttributHasardAffecte.Checked or RadioButtonAttributResultatAffecte.Checked);
  TabAttributLanceDe.visible      := true;
  TabAttribut.enabled             := false;

  if Hasard then
    begin
      GroupBoxAttribut.Enabled    := false;
      ButtonAttributHasard.Enabled:= false;
    end;
end;




////////////////////////////////////////////////////////////////////////////////
//                              TALENTS                                       //
////////////////////////////////////////////////////////////////////////////////

procedure TWinCreations.TabMetierResultat(Resul: Integer);
  var
    IndTab:   Integer;
    Deb:      Integer = 0;
    Fin:      Integer = 0;
    Ch:       String;
    IndS:     Integer;
    SousM:    Boolean = False;
    RaceC:    Boolean = False;
  begin
    for IndTab := 1 to TabMetier.RowCount-1 do
      begin
        Ch := TabMetier.Cells[3, IndTab];
        DebutFin(Ch, Deb, Fin);
        if ChoixWinMetierRace <> '' then
          begin
            if TabMEtier.Cells[1, Indtab] = ChoixWinMetierRace then
              begin
                IndS := Pos(SeparateurChance, Ch);
                if IndS > 0 then
                  Resul := StrToInt(Copy(Ch, 1, IndS-1))
                else
                  Resul := StrToInt(Ch);
              end
            else
              Deb := 101;
          end;

        if (Deb <= Resul) and (Resul <= Fin) then
          begin
            AffMetierSousMetier.text := TexteMetierSousMetier(TabMetier.Cells[1, indTab], LivresPersonnages);
            if AffMetierSousMetier.text <> '' then
              SousM := True
            else
              begin
                AffMetierSousMetier.text := TexteMetierRaceChoixMetier(TabMetier.Cells[1, indTab], RaceEnCours, LivresPersonnages);
                if AffMetierSousMetier.text <> '' then
                  RaceC := True;
              end;
            if not SousM and not RaceC then
              begin
                MetierEnCours              := TabMetier.Cells[1, indTab];
                MetierLibEnCours           := TabMetier.Cells[2, indTab];
                TabMetier.Cells[4, IndTab] := '1';
                TabMetier.TopRow           := indtab;
                TabMetier.Invalidate;
              end
            else
              begin
                if SousM then
                  begin
                    // second jet de dé
                    MetierEnCoursPrincipal                := TabMetier.Cells[1, indTab];
                    EditMetierSousMetierResultat.visible  := true;
                    ButtonMetierSousMetierValider.visible := true;
                    ButtonMetierSousMetierValider.BringToFront;
                    AffMetierSousMetier.visible           := true;
                  end
                else
                  begin
                    MetierEnCours                              := ResultMetierRaceChoixMetier(TabMetier.Cells[1, indTab], RaceEnCours, LivresPersonnages);
                    ButtonMetierSousMetierSelectionner.visible := true;
                    ButtonMetierSousMetierSelectionner.BringToFront;
                    AffMetierSousMetier.visible                := true;
                  end;
              end;
            Break;
          end
      end;
  end;


Function TWinCreations.TalentTest(Num: Integer; Code: String; Hasard: Boolean): Boolean;
  Var
    I: Integer;
    R: Boolean;
  begin
    R := true;
    // choix entre deux
    if Code = TalentRaceChoix1 then
       R := false;
    if Code = TalentRaceChoix2 then
       R := false;
    if Code = TalentRaceChoix3 then
       R := false;
    if Code = TalentRaceChoix4 then
       R := false;
    // talent forcé
    for I := 0 to TabTalent.RowCount -1 do
      begin
        if TabTalent.cells[1, I] = Code then
          R := false;
      end;
    // talents aléatoires
    if (not Hasard) and (Not R) then
      ShowMessage(GetTexteLibelle('MESS_021'));
    Result := R;
  end;

////////////////////////////////////////////////////////////////////////////////
//                          COMPETENCES DE RACE                               //
////////////////////////////////////////////////////////////////////////////////


procedure TWinCreations.TabRaceCompetenceDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  CheckChar: string;
  ImageIndex: Integer;
  CellWidth, CellHeight: Integer;
  MaxWidth, MaxHeight, ImageWidth, ImageHeight: Integer;
  AspectRatio: Double;
  LeftOffset, TopOffset: Integer;
  ImageRect: TRect;
  TopLeftPixelColor: TColor;
  Bitmap: TBitmap;
begin
  if (aCol = 2) and (aRow > 0) then
      begin
      // Récupérer la valeur de la cellule correspondante (colonne 2)
      ImageIndex := StrToIntDef(TabRaceCompetence.Cells[aCol, aRow], -1);

      // Vérifier que la valeur est valide et se situe dans la plage d'index d'image
      if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
      begin
        // Calculer la taille de la cellule
        CellWidth := aRect.Right - aRect.Left;
        CellHeight := aRect.Bottom - aRect.Top;

        // Calculer la taille maximale pour l'image en utilisant la taille de la cellule
        // et en ajustant l'aspect ratio de l'image
        MaxWidth := CellWidth;
        MaxHeight := CellHeight;
        ImageWidth := ListImage.Width;
        ImageHeight := ListImage.Height;
        if ImageWidth > 0 then
        begin
          AspectRatio := ImageHeight / ImageWidth;
          if ImageWidth > MaxWidth then
          begin
            ImageWidth := MaxWidth;
            ImageHeight := Round(ImageWidth * AspectRatio);
          end;
          if ImageHeight > MaxHeight then
          begin
            ImageHeight := MaxHeight;
            ImageWidth := Round(ImageHeight / AspectRatio);
          end;
        end;

        // Calculer la position de l'image pour centrer verticalement et horizontalement
        // dans la cellule
        LeftOffset := (CellWidth - ImageWidth) div 2;
        TopOffset := (CellHeight - ImageHeight) div 2;
        ImageRect := Rect(aRect.Left + LeftOffset, aRect.Top + TopOffset, aRect.Left + LeftOffset + ImageWidth, aRect.Top + TopOffset + ImageHeight);

        // Obtenir la couleur du pixel en haut à gauche de l'image
        Bitmap := TBitmap.Create;
        try
          ListImage.GetBitmap(ImageIndex, Bitmap);
          TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
        finally
          Bitmap.Free;
        end;

        // Dessiner l'image dans la cellule avec la taille ajustée
        ListImage.Draw(TabRaceCompetence.Canvas, ImageRect.Left, ImageRect.Top, ImageIndex);
      end
      else
        // Dessiner du texte par défaut si la valeur de l'index d'image est invalide
        TabRaceCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
    end
    else if (aCol = 3) then
    begin
      // Obtenir la couleur du pixel en haut à gauche de l'image de la cellule précédente (colonne 2)
      Bitmap := TBitmap.Create;
      try
        ImageIndex := StrToIntDef(TabRaceCompetence.Cells[2, aRow], -1);
        if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
        begin
          ListImage.GetBitmap(ImageIndex, Bitmap);
          TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
        end
        else
          TopLeftPixelColor := clNone;
      finally
        Bitmap.Free;
      end;

      // Changer la couleur de fond de la cellule avec la couleur du pixel en haut à gauche de l'image
      if TopLeftPixelColor <> clNone then
      begin
        TabRaceCompetence.Canvas.Brush.Color := TopLeftPixelColor;
        TabRaceCompetence.Canvas.FillRect(aRect);
      end;

      // Changer la couleur du texte pour les colonnes 3 à 6
      TabRaceCompetence.Canvas.Font.Color := clBlack;


      // Dessiner le texte de la cellule
      TabRaceCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
    end
   else if (aCol in [4,5]) and (aRow > 0) and (aRow <= NbRaceCompetenceTab) then
    begin
      // Obtenir la couleur du pixel en haut à gauche de l'image de la cellule précédente (colonne 2)
      Bitmap := TBitmap.Create;
      try
        ImageIndex := StrToIntDef(TabRaceCompetence.Cells[2, aRow], -1);
        if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
        begin
          ListImage.GetBitmap(ImageIndex, Bitmap);
          TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
        end
        else
          TopLeftPixelColor := clNone;
      finally
        Bitmap.Free;
      end;

      // Changer la couleur de fond de la cellule avec la couleur du pixel en haut à gauche de l'image
      if TopLeftPixelColor <> clNone then
      begin
        TabRaceCompetence.Canvas.Brush.Color := TopLeftPixelColor;
        TabRaceCompetence.Canvas.FillRect(aRect);
      end;

      if CompetenceRaceStates[aCol, aRow] then
        CheckChar := {%H-}CheckCharChecked
      else
        CheckChar := {%H-}CheckCharUnchecked;

      TabRaceCompetence.Canvas.TextRect(aRect, aRect.Left + 2, aRect.Top + 2, CheckChar);
    end
   else
    begin
      // Dessiner normalement le contenu textuel des autres cellules
      TabRaceCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
    end;


end;

procedure TWinCreations.ClickRaceCompetence(aCol, aRow: Integer);
Begin
  if (aCol in [4,5]) then
  begin
    CompetenceRaceStates[ACol, ARow] := not CompetenceRaceStates[ACol, ARow];
    TabRaceCompetence.InvalidateCell(ACol, ARow);
    if CompetenceRaceStates[ACol, ARow] = true then
      begin
        case aCol of
          4: begin
               CompetenceRaceStates[5, ARow]    := false;
               TabRaceCompetence.InvalidateCell(5, ARow);
             end;
          5: begin
               CompetenceRaceStates[4, ARow]    := false;
               TabRaceCompetence.InvalidateCell(4, ARow);
             end;
         end;
      end;
      CalculNbRaceCompetence();
  end;
end;


procedure TWinCreations.TabRaceCompetenceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  TabRaceCompetence.MouseToCell(X, Y, ACol, ARow);
  if (ARow > 0) then
    ClickRaceCompetence(aCol, aRow);
end;

procedure TWinCreations.ButtonRaceCompetenceHasardClick(Sender: TObject);
  var
    IndTab:    Integer;
    IndPass:   Integer;
  begin
    // vérifier s'il reste des Cing ou trois
    if (NbCinq < 3) or (NbTrois < 3) then
      for IndPass := 1 to 3 do
          for IndTab := 1 to TabRaceCompetence.RowCount-1 do
              if (not CompetenceRaceStates[4, IndTab]) and (not CompetenceRaceStates[5, IndTab]) then
                if ((IndPass in [1,2]) and (StrToIntDef(TabRaceCompetence.Cells[2, IndTab],0) > 0)) or (IndPass = 3) then
                  if (IndPass in [1,3]) and (NbCinq < 3) then
                    ClickRaceCompetence(4, IndTab)
                  else if (IndPass in [2,3]) and (NbTrois < 3) then
                    ClickRaceCompetence(5, IndTab);
  end;

procedure TWinCreations.CalculNbRaceCompetence();
Var
  IndTab: Integer;
Begin
  NbTrois := 0;
  NbCinq  := 0;
  for IndTab := 1 to TabRaceCompetence.RowCount -1 do
    begin
      if CompetenceRaceStates[4, IndTab] then
        NbCinq := NbCinq + 1;
      if CompetenceRaceStates[5, IndTab] then
        NbTrois:= NbTrois + 1;
    end;
end;


////////////////////////////////////////////////////////////////////////////////
//                         COMPETENCES DE METIER                              //
////////////////////////////////////////////////////////////////////////////////


procedure TWinCreations.TabMetierCompetenceDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
  Var
    ImageIndex: Integer;
    CellWidth, CellHeight: Integer;
    MaxWidth, MaxHeight, ImageWidth, ImageHeight: Integer;
    AspectRatio: Double;
    LeftOffset, TopOffset: Integer;
    ImageRect: TRect;
    TopLeftPixelColor: TColor;
    Bitmap: TBitmap;
  begin
    if (aCol = 2) and (aRow > 0) then
        begin
        // Récupérer la valeur de la cellule correspondante (colonne 2)
        ImageIndex := StrToIntDef(TabMetierCompetence.Cells[aCol, aRow], -1);

        // Vérifier que la valeur est valide et se situe dans la plage d'index d'image
        if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
        begin
          // Calculer la taille de la cellule
          CellWidth := aRect.Right - aRect.Left;
          CellHeight := aRect.Bottom - aRect.Top;

          // Calculer la taille maximale pour l'image en utilisant la taille de la cellule
          // et en ajustant l'aspect ratio de l'image
          MaxWidth := CellWidth;
          MaxHeight := CellHeight;
          ImageWidth := ListImage.Width;
          ImageHeight := ListImage.Height;
          if ImageWidth > 0 then
          begin
            AspectRatio := ImageHeight / ImageWidth;
            if ImageWidth > MaxWidth then
            begin
              ImageWidth := MaxWidth;
              ImageHeight := Round(ImageWidth * AspectRatio);
            end;
            if ImageHeight > MaxHeight then
            begin
              ImageHeight := MaxHeight;
              ImageWidth := Round(ImageHeight / AspectRatio);
            end;
          end;

          // Calculer la position de l'image pour centrer verticalement et horizontalement
          // dans la cellule
          LeftOffset := (CellWidth - ImageWidth) div 2;
          TopOffset := (CellHeight - ImageHeight) div 2;
          ImageRect := Rect(aRect.Left + LeftOffset, aRect.Top + TopOffset, aRect.Left + LeftOffset + ImageWidth, aRect.Top + TopOffset + ImageHeight);

          // Obtenir la couleur du pixel en haut à gauche de l'image
          Bitmap := TBitmap.Create;
          try
            ListImage.GetBitmap(ImageIndex, Bitmap);
            TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
          finally
            Bitmap.Free;
          end;

          // Dessiner l'image dans la cellule avec la taille ajustée
          ListImage.Draw(TabMetierCompetence.Canvas, ImageRect.Left, ImageRect.Top, ImageIndex);
        end
        else
          // Dessiner du texte par défaut si la valeur de l'index d'image est invalide
          TabMetierCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
      end
      else if (aCol > 2) and (aRow > 0) then
      begin
        // Obtenir la couleur du pixel en haut à gauche de l'image de la cellule précédente (colonne 2)
        Bitmap := TBitmap.Create;
        try
          ImageIndex := StrToIntDef(TabMetierCompetence.Cells[2, aRow], -1);
          if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
          begin
            ListImage.GetBitmap(ImageIndex, Bitmap);
            TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
          end
          else
            TopLeftPixelColor := clNone;
        finally
          Bitmap.Free;
        end;

        // Changer la couleur de fond de la cellule avec la couleur du pixel en haut à gauche de l'image
        if TopLeftPixelColor <> clNone then
        begin
          TabMetierCompetence.Canvas.Brush.Color := TopLeftPixelColor;
          TabMetierCompetence.Canvas.FillRect(aRect);
        end;

        // Changer la couleur du texte
        TabMetierCompetence.Canvas.Font.Color := clBlack;

        // Dessiner le texte de la cellule
        TabMetierCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
      end
     else
      begin
        // Dessiner normalement le contenu textuel des autres cellules
        TabMetierCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
      end;

  end;

procedure TWinCreations.TabMetierCompetenceSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
  begin
    // seul la saisie des 40 points est modifiable
    if (aCol <> 4)  then
      Editor := nil;
  end;


procedure TWinCreations.TabMetierCompetenceValidateEntry(Sender: TObject; aCol,
  aRow: Integer; const OldValue: string; var NewValue: String);
  var
    Value: Integer;
  begin
    // Vérifiez si la colonne concernée est celle qui doit contenir les chiffres entre 0 et 10
    if aCol = 4 then
    begin
      if NewValue <> '' then
      begin
        // Vérifiez si la valeur est un entier valide
        if TryStrToInt(NewValue, Value) then
          begin
            // Vérifiez si la valeur est comprise entre 0 et 10
            if (Value < 0) or (Value > 10) then
              begin
                // La valeur est en dehors de la plage autorisée, vous pouvez afficher un message d'erreur
                ShowMessage(GetTexteLibelle('MESS_022'));
                // Rétablir la valeur précédente
                NewValue := OldValue;
              end;
          end
        else
          begin
            // La valeur n'est pas un entier valide, vous pouvez afficher un message d'erreur
            ShowMessage(GetTexteLibelle('MESS_023'));
            // Rétablir la valeur précédente
            NewValue := OldValue;
          end;
        CalculTotalMetierCompetence();
      end;
    end;
  end;

procedure TWinCreations.CalculTotalMetierCompetence();
  Var
    IndTab:   Integer;
  Begin
    TotalMetierCompetence                := 0;
    for IndTab := 1 to TabMetierCompetence.RowCount-1 do
      TotalMetierCompetence            := TotalMetierCompetence + StrToIntDef(TabMetierCompetence.Cells[4, IndTab],0);
    ButtonTotalMetierCompetence.Caption  := IntToStr(TotalMetierCompetence)+' / 40 Pts';
  end;

procedure TWinCreations.ButtonMetierCompetenceHasardClick(Sender: TObject);
  Var
    IndTab:   Integer;
  Begin
    for IndTab := 1 to 8 do
      TabMetierCompetence.Cells[4, IndTab] := '5';
    CalculTotalMetierCompetence
  end;

procedure TWinCreations.ChargerLivre();
  var
    i:             Integer = 0;
    strings:       TStringList;
    Ind:           Integer;
    Ordre:         String;
    Livre:         String;
    PLivre:        StructureLivre;
  begin
    TabLivre.Clear;
    // mise en forme du tableau de création du Livre
    TabLivre.ColCount         := 8;
    TabLivre.RowCount         := 10;
    TabLivre.ColWidths[0]     := 0;
    TabLivre.ColWidths[1]     := 20;
    TabLivre.Cells[2, 0]      := GetTexteLibelle('LAB_014');
    TabLivre.ColWidths[2]     := 230;
    TabLivre.ColWidths[3]     := 0;
    TabLivre.ColWidths[4]     := 0;
    TabLivre.Cells[5, 0]      := 'R';
    TabLivre.ColWidths[5]     := 0;
    TabLivre.Cells[6, 0]      := 'W';
    TabLivre.ColWidths[6]     := 0;
    TabLivre.Cells[7, 0]      := 'B';
    TabLivre.ColWidths[7]     := 70;

    strings       := TStringList.Create;
    ExtractStrings(['['], [], PChar(LivresCharges), Strings);
    for Ind := 0 to (Strings.count - 1) Do
      begin
        inc(I);
        if TabLivre.RowCount <= I then
          TabLivre.RowCount      := TabLivre.RowCount + 1;
        Livre                    := Strings[ind];
        Livre                    := StringReplace(StringReplace(Livre, '[', '', [rfReplaceAll]), ']', '', [rfReplaceAll]);
        TabLivre.Cells[1, I]     := ConstSelectionne;
        TabLivre.Cells[2, I]     := GetTexteLibelle(Livre,'','',true);
        TabLivre.Cells[3, I]     := Livre;
        PLivre                   := ChercheLivreLibelle(Livre);
        Ordre                    := IntToStr(PLivre.Officiel);
        if Ordre  = '2' then
          TabLivre.Cells[7, I]   := ConstLivreFacultatif
        else
          TabLivre.Cells[7, I]   := ConstLivreOfficiel;
        TabLivre.Cells[4, I]     := Ordre+Livre;
      end;
    Strings.Free;
    TabLivre.SortColRow(true,4);
    AdjustGridColumnsWidth(TabLivre, PageEtapes.Height, false, true);
  end;

Procedure TWinCreations.ReconstruitChoixCreation();
  var
    Sauve:      array of StructureChoixCreation;
    Nouvelle:   StructureChoixCreation;
    PRaceTalent:StructureRaceTalent;
    Ind, Ind2:  Integer;
    ListOpt:    TStringList;
    Msg:        String;
  begin
    // 1 - sauver l'état courant (choix faits et jets obtenus)
    Sauve := Copy(ListeChoixCreation, 0, Length(ListeChoixCreation));
    ListeChoixCreation := [];

    // 2 - racines : talents de race
    For PRaceTalent in ListRaceTalent do
      if CompareRechercheValeur(PRaceTalent.CodeRace, RaceEnCours) then
        begin
          ListOpt := ListeTalent(PRaceTalent.CodeTalent);
          if ListOpt.Count > 1 then
            begin
              Nouvelle.Origine    := ConstOrigineRace;
              Nouvelle.CodeSource := PRaceTalent.CodeTalent;
              Nouvelle.CodeParent := '';
              Nouvelle.CodeChoisi := '';
              Nouvelle.Aleatoire  := False;
              Nouvelle.Jet        := 0;
              Nouvelle.Rang := RangSuivant(Nouvelle.CodeSource, Nouvelle.CodeParent);
              ListeChoixCreation  += [Nouvelle];
            end
          else if CompareRechercheValeur(PRaceTalent.CodeTalent, TalentGenerique) then
            begin
              Nouvelle.Origine    := ConstOrigineRace;
              Nouvelle.CodeSource := PRaceTalent.CodeTalent;
              Nouvelle.CodeParent := '';
              Nouvelle.CodeChoisi := '';
              Nouvelle.Aleatoire  := True;
              Nouvelle.Jet        := 0;
              Nouvelle.Rang := RangSuivant(Nouvelle.CodeSource, Nouvelle.CodeParent);
              ListeChoixCreation  += [Nouvelle];
            end;
          ListOpt.Free;
        end;

    // 3 - réinjecter les choix et jets mémorisés
    for Ind := 0 to High(ListeChoixCreation) do
      for Ind2 := 0 to High(Sauve) do
        if (Sauve[Ind2].CodeSource = ListeChoixCreation[Ind].CodeSource)
          and (Sauve[Ind2].CodeParent = ListeChoixCreation[Ind].CodeParent)
            and (Sauve[Ind2].Rang = ListeChoixCreation[Ind].Rang) then
              begin
                ListeChoixCreation[Ind].CodeChoisi     := Sauve[Ind2].CodeChoisi;
                ListeChoixCreation[Ind].CodeSpecialise := Sauve[Ind2].CodeSpecialise;
                ListeChoixCreation[Ind].Jet            := Sauve[Ind2].Jet;
                break;
              end;

    // 4 - lignes filles engendrées par les choix retenus
    Ind := 0;
    while Ind <= High(ListeChoixCreation) do
      begin
        if (ListeChoixCreation[Ind].CodeChoisi <> '')
          and CompareRechercheValeur(ListeChoixCreation[Ind].CodeChoisi, TalentGenerique)
            and (Pos(ValeurGenerique, ListeChoixCreation[Ind].CodeChoisi) = 0) then          begin
            Nouvelle.Origine    := ListeChoixCreation[Ind].Origine;
            Nouvelle.CodeSource := ListeChoixCreation[Ind].CodeChoisi;
            Nouvelle.CodeParent := ListeChoixCreation[Ind].CodeSource;
            Nouvelle.CodeChoisi := '';
            Nouvelle.Aleatoire  := True;
            Nouvelle.Jet        := 0;
            Nouvelle.Rang := RangSuivant(Nouvelle.CodeSource, Nouvelle.CodeParent);
            ListeChoixCreation  += [Nouvelle];
            // réinjecter aussi son jet éventuel
            for Ind2 := 0 to High(Sauve) do
              if (Sauve[Ind2].CodeSource = Nouvelle.CodeSource)
                 and (Sauve[Ind2].CodeParent = Nouvelle.CodeParent)
                   and (Sauve[Ind2].Rang = Nouvelle.Rang) then
                     begin
                       ListeChoixCreation[High(ListeChoixCreation)].CodeChoisi     := Sauve[Ind2].CodeChoisi;
                       ListeChoixCreation[High(ListeChoixCreation)].CodeSpecialise := Sauve[Ind2].CodeSpecialise;
                       ListeChoixCreation[High(ListeChoixCreation)].Jet            := Sauve[Ind2].Jet;
                       break;
                     end;
            end;
        Ind := Ind + 1;
      end;

    AfficheChoixCreation();
  end;

Procedure TWinCreations.AfficheChoixCreation();
  var
    Ind:      Integer;
    LigChoix: Integer = 0;
    LigHasard:Integer = 0;
    PTalent:  StructureTalent;
    Lib:      String;
  begin
    TabCreationChoix.RowCount  := 1;
    TabCreationHasard.RowCount := 1;

    for Ind := 0 to High(ListeChoixCreation) do
      begin
        // libellé du code source
        PTalent := ChercheTalent(ListeChoixCreation[Ind].CodeSource);
        Lib     := PTalent.Libelle;
        if Lib = '' then
          Lib := LibelleChoixMultiple(ListeChoixCreation[Ind].CodeSource);

        if ListeChoixCreation[Ind].Aleatoire then
          begin
            LigHasard := LigHasard + 1;
            TabCreationHasard.RowCount := LigHasard + 1;
            TabCreationHasard.Cells[ColHasOrigine, LigHasard] := ListeChoixCreation[Ind].Origine;
            TabCreationHasard.Cells[ColHasLib, LigHasard]     := Lib;
            TabCreationHasard.Cells[ColHasSource, LigHasard]  := ListeChoixCreation[Ind].CodeSource;
            TabCreationHasard.Cells[ColHasSel, LigHasard]     := ListeChoixCreation[Ind].CodeChoisi;
            TabCreationHasard.Cells[ColHasRang, LigHasard]    := IntToStr(ListeChoixCreation[Ind].Rang);
            TabCreationHasard.Cells[ColHasParent, LigHasard]  := ListeChoixCreation[Ind].CodeParent;
            if ListeChoixCreation[Ind].Jet > 0 then
              begin
                TabCreationHasard.Cells[ColHasJet, LigHasard] := IntToStr(ListeChoixCreation[Ind].Jet);
                PTalent := ChercheTalent(ListeChoixCreation[Ind].CodeChoisi);
                TabCreationHasard.Cells[ColHasLibSel, LigHasard] := PTalent.Libelle;
              end
            else
              begin
                TabCreationHasard.Cells[ColHasJet, LigHasard]    := '';
                TabCreationHasard.Cells[ColHasLibSel, LigHasard] := GetTexteLibelle(ConstLabSelSpe);
              end;
            // spécialisation éventuelle
            TabCreationHasard.Cells[ColHasSpe, LigHasard] := ListeChoixCreation[Ind].CodeSpecialise;
            if Pos(ValeurGenerique, ListeChoixCreation[Ind].CodeChoisi) > 0 then
              begin
                if ListeChoixCreation[Ind].CodeSpecialise = '' then
                  TabCreationHasard.Cells[ColHasLibSpe, LigHasard] := GetTexteLibelle(ConstLabSelSpe)
                else
                  begin
                    PTalent := ChercheTalent(ListeChoixCreation[Ind].CodeSpecialise);
                    TabCreationHasard.Cells[ColHasLibSpe, LigHasard] := PTalent.Libelle;
                  end;
              end
            else
              TabCreationHasard.Cells[ColHasLibSpe, LigHasard] := '';
          end
        else
          begin
            LigChoix := LigChoix + 1;
            TabCreationChoix.RowCount := LigChoix + 1;
            TabCreationChoix.Cells[ColChoixOrigine, LigChoix] := ListeChoixCreation[Ind].Origine;
            TabCreationChoix.Cells[ColChoixLib, LigChoix]     := Lib;
            TabCreationChoix.Cells[ColChoixSource, LigChoix]  := ListeChoixCreation[Ind].CodeSource;
            TabCreationChoix.Cells[ColChoixSel, LigChoix]     := ListeChoixCreation[Ind].CodeChoisi;
            TabCreationChoix.Cells[ColChoixParent, LigChoix]  := ListeChoixCreation[Ind].CodeParent;
            if ListeChoixCreation[Ind].CodeChoisi = '' then
              TabCreationChoix.Cells[ColChoixLibSel, LigChoix] := GetTexteLibelle(ConstLabSelSpe)
            else
              begin
                PTalent := ChercheTalent(ListeChoixCreation[Ind].CodeChoisi);
                TabCreationChoix.Cells[ColChoixLibSel, LigChoix] := PTalent.Libelle;
              end;
          end;
      end;
    AdjustGridColumnsWidth(TabCreationChoix,  382, False, False, True);
    AdjustGridColumnsWidth(TabCreationHasard, 790, False, False, True);
  end;

Function TWinCreations.ChoixCreationComplet(): Boolean;
  var Ind: Integer;
  begin
    Result := True;
    for Ind := 0 to High(ListeChoixCreation) do
      begin
        if ListeChoixCreation[Ind].CodeChoisi = '' then
          begin
            Result := False;
            Break;
          end;
        if (Pos(ValeurGenerique, ListeChoixCreation[Ind].CodeChoisi) > 0)
           and (ListeChoixCreation[Ind].CodeSpecialise = '') then
          begin
            Result := False;
            Break;
          end;
      end;
  end;

Function TWinCreations.LibelleChoixMultiple(Code: String): String;
  var
    Liste:   TStringList;
    Ind:     Integer;
    PTalent: StructureTalent;
  begin
    Result := '';
    Liste  := ListeTalent(Code);
    for Ind := 0 to Liste.Count - 1 do
      begin
        PTalent := ChercheTalent(Liste[Ind]);
        if Result <> '' then
          Result := Result + ' / ';   // "ou"
        Result := Result + PTalent.Libelle;
      end;
    Liste.Free;
  end;


Function TWinCreations.RangSuivant(Source, ParentLigne: String): Integer;
  var Ind: Integer;
  begin
    Result := 0;
    for Ind := 0 to High(ListeChoixCreation) do
      if (ListeChoixCreation[Ind].CodeSource = Source)
         and (ListeChoixCreation[Ind].CodeParent = ParentLigne) then
        Result := Result + 1;
  end;

Function TWinCreations.ListeTalentsDejaPris(Exclu: String): TStringList;
  var
    Ind: Integer;
  begin
    Result := TStringList.Create;
    for Ind := 1 to TabTalent.RowCount - 1 do
      if (TabTalent.Cells[1, Ind] <> '') and (TabTalent.Cells[1, Ind] <> Exclu) then
        Result.Add(TabTalent.Cells[1, Ind]);
    for Ind := 0 to High(ListeChoixCreation) do
      if (ListeChoixCreation[Ind].CodeChoisi <> '') and (ListeChoixCreation[Ind].CodeChoisi <> Exclu) then
        Result.Add(ListeChoixCreation[Ind].CodeChoisi);
  end;

Procedure TWinCreations.AjouteTalentsResolus();
  var
    Ind:     Integer;
    Lig:     Integer;
    PTalent: StructureTalent;
    CodeFinal: String;
  begin
    // se placer après la dernière ligne remplie
    Lig := 0;
    for Ind := 1 to TabTalent.RowCount - 1 do
      if TabTalent.Cells[1, Ind] <> '' then
        Lig := Ind;

    for Ind := 0 to High(ListeChoixCreation) do
      begin
        CodeFinal := ListeChoixCreation[Ind].CodeSpecialise;
        if CodeFinal = '' then
          CodeFinal := ListeChoixCreation[Ind].CodeChoisi;
        if (CodeFinal <> '') and (not CompareRechercheValeur(CodeFinal, TalentGenerique)) then
          begin
            PTalent := ChercheTalent(CodeFinal);            Lig     := Lig + 1;
            if Lig >= TabTalent.RowCount then
              TabTalent.RowCount := Lig + 1;
            TabTalent.Cells[1, Lig] := PTalent.CodeTalent;
            TabTalent.Cells[2, Lig] := PTalent.Libelle;
          end;
      end;
  end;

end.
