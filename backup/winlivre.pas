unit WinLivre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Grids, ExtCtrls, BCButton, GlobalFonts, ChargeConstantes, ChargeRace,
  ChargeTexte, ChargeMetier, ChargeCompetence, ChargeTalent, ChargeArme,
  ChargeArmure, ChargeSort, ChargeRaceAttribut, ChargeAttribut, Unitcalcul,
  ChargeRaceCompetence, ChargeRaceTalent, ChargeRaceMetier,
  ChargeMetierAttribut, ChargeLivre, ChargeMetierCompetence, ChargeMetierTalent,
  ChargeMetierEquipement, ChargeMetierNiveau;

type

  { TWinLivres }

  TWinLivres = class(TForm)
    ButtonAugmentation: TBCButton;
    ButtonSauvegarde: TBCButton;
    LabMetierCode: TEdit;
    LabMetierAttribut: TEdit;
    LabMetierNiveau: TEdit;
    LabMetierEquipement: TEdit;
    LabRaceCompetence: TEdit;
    LabMetierLib: TEdit;
    LabMetierCompetence: TEdit;
    LabRaceMetier: TEdit;
    LabRaceTalent: TEdit;
    LabRaceBlessure: TEdit;
    LabRaceAttribut: TEdit;
    LabRaceBlessureEndurance: TEdit;
    LabRaceBlessureForceMentale: TEdit;
    LabRaceLib: TEdit;
    LabRaceCode: TEdit;
    LabRaceBlessureForce: TEdit;
    LabMetierTalent: TEdit;
    CodeLivre: TEdit;
    RaceBlessureEndurance: TEdit;
    RaceBlessureForceMentale: TEdit;
    RaceCode: TEdit;
    RaceBlessureForce: TEdit;
    MetierCode: TEdit;
    RaceLib: TEdit;
    Livre: TEdit;
    PageEtapes: TPageControl;
    MetierLib: TEdit;
    RadioRulebook: TRadioButton;
    RadioOfficial: TRadioButton;
    RadioUnofficial: TRadioButton;
    RadioTypeBook: TRadioGroup;
    TabArmure: TStringGrid;
    TabCompetenceSpe: TStringGrid;
    TabMetierNiveau: TStringGrid;
    TabMetierEquipement: TStringGrid;
    TabRaceAttribut: TStringGrid;
    TabMetierAttribut: TStringGrid;
    TabRaceCompetence: TStringGrid;
    TabRaceAttributSupp: TStringGrid;
    TabMetierCompetence: TStringGrid;
    TabRaceMetier: TStringGrid;
    TabRaceTalent: TStringGrid;
    TabMetierTalent: TStringGrid;
    TabSheetTexte: TTabSheet;
    TabSheetTalentSpe: TTabSheet;
    TabSheetCompetenceSpe: TTabSheet;
    TabSort: TStringGrid;
    TabCompetence: TStringGrid;
    TabSheetSort: TTabSheet;
    TabSheetArmure: TTabSheet;
    TabTexte: TStringGrid;
    TabTalent: TStringGrid;
    TabRace: TStringGrid;
    TabMetier: TStringGrid;
    TabSheetTalent: TTabSheet;
    TabSheetCompetence: TTabSheet;
    TabSheetArme: TTabSheet;
    TabSheetMetier: TTabSheet;
    TabSheetRace: TTabSheet;
    TabArme: TStringGrid;
    TabTalentSpe: TStringGrid;
    procedure ButtonAugmentationClick(Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure ChargeLivreDonnees();
    procedure ChargeLivreRace();
    procedure ChargeLivreMetier();
    procedure ChargeLivreCompetence();
    procedure ChargeLivreTalent();
    procedure ChargeLivreArme();
    procedure ChargeLivreArmure();
    procedure ChargeLivreSort();
    procedure TabMetierClick({%H-}Sender: TObject);
    procedure TabRaceClick({%H-}Sender: TObject);
    procedure ChargeLivreTexte();

  private

  public

  end;

var
  WinLivres:          TWinLivres;
  PRace:              StructureRace;
  PMetier:            StructureMetier;
  PCompetence:        StructureCompetence;
  PTalent:            StructureTalent;
  PArme:              StructureArme;
  PArmure:            StructureArmure;
  PSort:              StructureSort;
  PRaceAttribut:      StructureRaceAttribut;
  PAttribut:          StructureAttribut;
  PRaceCompetence:    StructureRaceCompetence;
  PRaceTalent:        StructureRaceTalent;
  PRaceMetier:        StructureRaceMetier;
  PMetierAttribut:    StructureMetierAttribut;
  PMetierCompetence:  StructureMetierCompetence;
  PMetierTalent:      StructureMetierTalent;
  PMetierEquipement:  StructureMetierEquipement;
  PMetierNiveau:      StructureMetierNiveau;
  PTexte:             StructureTexte;
  PLivre:             StructureLivre;
  Creation:           Boolean = False;
  Modifiable:         Boolean;

implementation

{$R *.lfm}

{ TWinLivres }

procedure TWinLivres.FormCreate(Sender: TObject);
  begin
    // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    LabRaceCode.Caption                 := GetTexteLibelle('LAB_001');
    LabRaceLib.Caption                  := GetTexteLibelle('LAB_002');
    LabRaceBlessure.Caption             := GetTexteLibelle('ATTR_Wound');
    LabRaceBlessureForce.Caption        := GetTexteLibelle('BATTR_S')+' x';
    LabRaceBlessureEndurance.Caption    := GetTexteLibelle('BATTR_T')+' x';
    LabRaceBlessureForceMentale.Caption := GetTexteLibelle('BATTR_WP')+' x';
    LabRaceAttribut.Caption             := GetTexteLibelle('LAB_008');
    LabRaceCompetence.Caption           := GetTexteLibelle('LAB_009');
    LabRaceTalent.Caption               := GetTexteLibelle('LAB_007');
    LabRaceMetier.Caption               := GetTexteLibelle('LAB_006');

    LabMetierCode.Caption               := GetTexteLibelle('LAB_001');
    LabMetierLib.Caption                := GetTexteLibelle('LAB_002');
    LabMetierAttribut.Caption           := GetTexteLibelle('LAB_008');
    LabMetierCompetence.Caption         := GetTexteLibelle('LAB_009');
    LabMetierTalent.Caption             := GetTexteLibelle('LAB_007');
    LabMetierEquipement.Caption         := GetTexteLibelle('LAB_013');
    LabMetierNiveau.Caption             := GetTexteLibelle('LAB_019');

    TabSheetRace.Caption                := GetTexteLibelle('LAB_042');
    TabSheetMetier.Caption              := GetTexteLibelle('LAB_006');
    TabSheetCompetence.Caption          := GetTexteLibelle('LAB_009');
    TabSheetCompetenceSpe.Caption       := GetTexteLibelle('LAB_146');
    TabSheetTalent.Caption              := GetTexteLibelle('LAB_007');
    TabSheetTalentSpe.Caption           := GetTexteLibelle('LAB_147');
    TabSheetArme.Caption                := GetTexteLibelle('LAB_063');
    TabSheetArmure.Caption              := GetTexteLibelle('LAB_065');
    TabSheetSort.Caption                := GetTexteLibelle('LAB_083');
    TabSheetTexte.Caption               := GetTexteLibelle('LAB_148');

    RadioRulebook.Caption      := getTexteLibelle('LAB_151');
    RadioOfficial.Caption      := getTexteLibelle('LAB_152');
    RadioUnofficial.Caption    := getTexteLibelle('LAB_153');

    if NomLivre <> '' then
      begin
        PLivre            := ChercheLivreLibelle(NomLivre);
        CodeLivre.Caption := PLivre.CodeLivre;
        Livre.Caption     := NomLivre;
        Case PLivre.Officiel of
          0:         RadioRulebook.checked   := True;
          1:         RadioOfficial.checked   := True;
          else       RadioUnofficial.checked := True;
        end;
        ChargeLivreDonnees();
        Modifiable            := (PLivre.Complet = 0) ;
      end
    else
      begin
        CodeLivre.Text         := '';
        Livre.Text             := '';
        RadioOfficial.checked  := True;
        Modifiable             := True;
        Creation               := True;
      end;

    RadioRulebook.Enabled      := False;

    ButtonAugmentation.Caption    := GetTexteLibelle('LAB_101');
    ButtonSauvegarde.Caption      := GetTexteLibelle('LAB_102');

    ButtonAugmentation.Enabled    := Modifiable;
    ButtonSauvegarde.Enabled      := Modifiable;
    Livre.Enabled                 := Modifiable;
    CodeLivre.Enabled             := Modifiable;
    RadioTypeBook.Enabled         := Modifiable;


  end;

procedure TWinLivres.ButtonAugmentationClick(Sender: TObject);
  var
    Erreur:   String;
  begin
    if Creation then
      if (CodeLivre.Text = '') or (Length(CodeLivre.Text) <> 5) then
        Erreur := 'MESS_049' // Le code livre doit avoir 5 caractères
      else if (Livre.Text= '') then
        Erreur := 'MESS_050' // Le code livre doit avoir 5 caractères
      else
        begin
          ChercheLivre(CodeLivre.Text);
          if RechercheTrouve then
            Erreur := 'MESS_051' // ce code livre existe déjà
          else
            begin
              ChercheLivreLibelle(Livre.Text);
              if RechercheTrouve then
                Erreur := 'MESS_052' // ce nom de livre existe déjà
            end
        end;

    If Erreur <> '' then
      ShowMessage(Erreur)
    else
      begin

      end;

    end;

procedure TWinLivres.ChargeLivreDonnees();
  begin
    ChargeLivreRace();
    ChargeLivreMetier();
    ChargeLivreCompetence();
    ChargeLivreTalent();
    ChargeLivreArme();
    ChargeLivreArmure();
    ChargeLivreSort();
    ChargeLivreTexte();
  end;

procedure TWinLivres.ChargeLivreRace();
  var
    IndTab: Integer = 0;
  begin
    TabRace.RowCount      := 1;
    TabRace.ColCount      := 1;
    GridAjouteColonne(TabRace,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRace,GetTexteLibelle('LAB_002'),220);

    TabRace.ColWidths[0]  := 20;
    for PRace in ListRace do
      if PRace.Livre = NomLivre then
        begin
          Inc(IndTab);
          if tabRace.RowCount <= IndTab then
            tabRace.RowCount := tabRace.RowCount + 1;
          tabRace.Cells[1, IndTab] := PRace.CodeRace;
          TabRace.Cells[2, indTab] := PRace.Libelle;
        end;
    AdjustGridColumnsWidth(TabRace, PageEtapes.Height - 40, false, false);

    TabRaceAttribut.RowCount      := 1;
    TabRaceAttribut.ColCount      := 1;
    GridAjouteColonne(TabRaceAttribut,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRaceAttribut,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabRaceAttribut,GetTexteLibelle('LAB_144'),50);
    GridAjouteColonne(TabRaceAttribut,GetTexteLibelle('LAB_025'),50);

    TabRaceAttributSupp.RowCount      := 1;
    TabRaceAttributSupp.ColCount      := 1;
    GridAjouteColonne(TabRaceAttributSupp,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRaceAttributSupp,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabRaceAttributSupp,GetTexteLibelle('LAB_025'),50);

    TabRaceCompetence.RowCount      := 1;
    TabRaceCompetence.ColCount      := 1;
    GridAjouteColonne(TabRaceCompetence,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRaceCompetence,GetTexteLibelle('LAB_002'),100);

    TabRaceTalent.RowCount      := 1;
    TabRaceTalent.ColCount      := 1;
    GridAjouteColonne(TabRaceTalent,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRaceTalent,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRaceTalent,GetTexteLibelle('LAB_127'),50);
    GridAjouteColonne(TabRaceTalent,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabRaceTalent,GetTexteLibelle('LAB_002'),100);

    TabRaceMetier.RowCount      := 1;
    TabRaceMetier.ColCount      := 1;
    GridAjouteColonne(TabRaceMetier,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabRaceMetier,GetTexteLibelle('LAB_127'),100);
    GridAjouteColonne(TabRaceMetier,'%',50);

    TabRaceClick(TabRace);
  end;

procedure TWinLivres.ChargeLivreMetier();
  var
    IndTab: Integer = 0;
  begin
    TabMetier.RowCount      := 1;
    TabMetier.ColCount      := 1;
    GridAjouteColonne(TabMetier,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetier,GetTexteLibelle('LAB_002'),220);

    TabMetier.ColWidths[0]  := 20;
    for PMetier in ListMetier do
      if PMetier.Livre = NomLivre then
        begin
          Inc(IndTab);
          if tabMetier.RowCount <= IndTab then
            tabMetier.RowCount := tabMetier.RowCount + 1;
          tabMetier.Cells[1, IndTab] := PMetier.CodeMetier;
          TabMetier.Cells[2, indTab] := PMetier.Libelle;
        end;
    AdjustGridColumnsWidth(TabMetier, PageEtapes.Height - 40, false, false);
    TabMetier.SortColRow(true,2);

    TabMetierAttribut.RowCount      := 1;
    TabMetierAttribut.ColCount      := 1;
    GridAjouteColonne(TabMetierAttribut,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetierAttribut,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierAttribut,GetTexteLibelle('LAB_019'),50);

    TabMetierCompetence.RowCount      := 1;
    TabMetierCompetence.ColCount      := 1;
    GridAjouteColonne(TabMetierCompetence,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetierCompetence,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierCompetence,GetTexteLibelle('LAB_019'),50);

    TabMetierTalent.RowCount      := 1;
    TabMetierTalent.ColCount      := 1;
    GridAjouteColonne(TabMetierTalent,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetierTalent,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierTalent,GetTexteLibelle('LAB_019'),50);

    TabMetierEquipement.RowCount      := 1;
    TabMetierEquipement.ColCount      := 1;
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_127'),10);
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'),50);
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'));
    GridAjouteColonne(TabMetierEquipement,GetTexteLibelle('LAB_019'));

    TabMetierNiveau.RowCount      := 1;
    TabMetierNiveau.ColCount      := 1;
    GridAjouteColonne(TabMetierNiveau,GetTexteLibelle('LAB_019'),50);
    GridAjouteColonne(TabMetierNiveau,GetTexteLibelle('LAB_002'),100);
    GridAjouteColonne(TabMetierNiveau,GetTexteLibelle('LAB_145'),100);

    TabMetierClick(TabMetier);
  end;

procedure TWinLivres.ChargeLivreCompetence();
  var
    IndTab:    Integer = 0;
    IndTabSpe: Integer = 0;
  begin
    TabCompetence.RowCount      := 1;
    TabCompetence.ColCount      := 1;
    GridAjouteColonne(TabCompetence,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabCompetence,GetTexteLibelle('LAB_002'),220);

    TabCompetenceSpe.RowCount      := 1;
    TabCompetenceSpe.ColCount      := 1;
    GridAjouteColonne(TabCompetenceSpe,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabCompetenceSpe,GetTexteLibelle('LAB_002'),220);

    TabCompetence.ColWidths[0]  := 20;
    TabCompetenceSpe.ColWidths[0]  := 20;
    for PCompetence in ListCompetence do
      if (PCompetence.Livre = NomLivre) then
        begin
          if (PCompetence.SousCompetence = false) then
            begin
              Inc(IndTab);
              if tabCompetence.RowCount <= IndTab then
                tabCompetence.RowCount := tabCompetence.RowCount + 1;
              tabCompetence.Cells[1, IndTab] := PCompetence.CodeCompetence;
              TabCompetence.Cells[2, indTab] := PCompetence.Libelle;
            end
          else
            begin
              Inc(IndTabSpe);
              if tabCompetenceSpe.RowCount <= IndTabSpe then
                tabCompetenceSpe.RowCount := tabCompetenceSpe.RowCount + 1;
              tabCompetenceSpe.Cells[1, IndTabSpe] := PCompetence.CodeCompetence;
              TabCompetenceSpe.Cells[2, indTabSpe] := PCompetence.Libelle;
            end;

        end;
    AdjustGridColumnsWidth(TabCompetence, PageEtapes.Height - 40, false, false);
    TabCompetence.SortColRow(true,2);
    AdjustGridColumnsWidth(TabCompetenceSpe, PageEtapes.Height - 40, false, false);
    TabCompetenceSpe.SortColRow(true,2);
  end;

procedure TWinLivres.ChargeLivreTalent();
  var
    IndTab:    Integer = 0;
    IndTabSpe: Integer = 0;
  begin
    TabTalent.RowCount      := 1;
    TabTalent.ColCount      := 1;
    GridAjouteColonne(TabTalent,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabTalent,GetTexteLibelle('LAB_002'),220);

    TabTalentSpe.RowCount      := 1;
    TabTalentSpe.ColCount      := 1;
    GridAjouteColonne(TabTalentSpe,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabTalentSpe,GetTexteLibelle('LAB_002'),220);

    TabTalent.ColWidths[0]  := 20;
    TabTalentSpe.ColWidths[0]  := 20;
    for PTalent in ListTalent do
      if (PTalent.Livre = NomLivre) then
        begin
          if (PTalent.SousTalent = false) then
            begin
              Inc(IndTab);
              if tabTalent.RowCount <= IndTab then
                tabTalent.RowCount := tabTalent.RowCount + 1;
              tabTalent.Cells[1, IndTab] := PTalent.CodeTalent;
              TabTalent.Cells[2, indTab] := PTalent.Libelle;
            end
          else
            begin
              Inc(IndTabSpe);
              if tabTalentSpe.RowCount <= IndTabSpe then
                tabTalentSpe.RowCount := tabTalentSpe.RowCount + 1;
              tabTalentSpe.Cells[1, IndTabSpe] := PTalent.CodeTalent;
              TabTalentSpe.Cells[2, indTabSpe] := PTalent.Libelle;
            end;

        end;
    AdjustGridColumnsWidth(TabTalent, PageEtapes.Height - 40, false, false);
    TabTalent.SortColRow(true,2);
    AdjustGridColumnsWidth(TabTalentSpe, PageEtapes.Height - 40, false, false);
    TabTalentSpe.SortColRow(true,2);
  end;

procedure TWinLivres.ChargeLivreArme();
  var
    IndTab: Integer = 0;
  begin
    TabArme.RowCount      := 1;
    TabArme.ColCount      := 1;
    GridAjouteColonne(TabArme,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabArme,GetTexteLibelle('LAB_002'),220);

    TabArme.ColWidths[0]  := 20;
    for PArme in ListArme do
      if (PArme.Livre = NomLivre) then
        begin
          Inc(IndTab);
          if tabArme.RowCount <= IndTab then
            tabArme.RowCount := tabArme.RowCount + 1;
          tabArme.Cells[1, IndTab] := PArme.CodeArme;
          TabArme.Cells[2, indTab] := PArme.Libelle;
        end;
    AdjustGridColumnsWidth(TabArme, PageEtapes.Height - 40, false, false);
    TabArme.SortColRow(true,2);
  end;

procedure TWinLivres.ChargeLivreArmure();
  var
    IndTab: Integer = 0;
  begin
    TabArmure.RowCount      := 1;
    TabArmure.ColCount      := 1;
    GridAjouteColonne(TabArmure,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabArmure,GetTexteLibelle('LAB_002'),220);

    TabArmure.ColWidths[0]  := 20;
    for PArmure in ListArmure do
      if (PArmure.Livre = NomLivre) then
        begin
          Inc(IndTab);
          if tabArmure.RowCount <= IndTab then
            tabArmure.RowCount := tabArmure.RowCount + 1;
          tabArmure.Cells[1, IndTab] := PArmure.CodeArmure;
          TabArmure.Cells[2, indTab] := PArmure.Libelle;
        end;
    AdjustGridColumnsWidth(TabArmure, PageEtapes.Height - 40, false, false);
    TabArmure.SortColRow(true,2);
  end;

procedure TWinLivres.ChargeLivreSort();
  var
    IndTab: Integer = 0;
  begin
    TabSort.RowCount      := 1;
    TabSort.ColCount      := 1;
    GridAjouteColonne(TabSort,GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabSort,GetTexteLibelle('LAB_002'),220);

    TabSort.ColWidths[0]  := 20;
    for PSort in ListSort do
      if (PSort.Livre = NomLivre) then
        begin
          Inc(IndTab);
          if tabSort.RowCount <= IndTab then
            tabSort.RowCount := tabSort.RowCount + 1;
          tabSort.Cells[1, IndTab] := PSort.CodeSort;
          TabSort.Cells[2, indTab] := PSort.Libelle;
        end;
    AdjustGridColumnsWidth(TabSort, PageEtapes.Height - 40, false, false);
    TabSort.SortColRow(true,2);
  end;

procedure TWinLivres.ChargeLivreTexte();
  var
    IndTab: Integer = 0;
  begin
    TabTexte.RowCount      := 1;
    TabTexte.ColCount      := 1;
    GridAjouteColonne(TabTexte,GetTexteLibelle('LAB_001'),50);
    GridAjouteColonne(TabTexte,GetTexteLibelle('LAB_002'),220);

    TabTexte.ColWidths[0]  := 20;
    for PTexte in ListTexte do
      if (NomLivre = ConstRulesBook) then
        begin
          Inc(IndTab);
          if tabTexte.RowCount <= IndTab then
            tabTexte.RowCount := tabTexte.RowCount + 1;
          tabTexte.Cells[1, IndTab] := PTexte.Code;
          TabTexte.Cells[2, indTab] := PTexte.Libelle;
        end;
    AdjustGridColumnsWidth(TabTexte, PageEtapes.Height - 40, false, false);
    TabTexte.SortColRow(true,1);
  end;


procedure TWinLivres.TabMetierClick(Sender: TObject);
  var
    IndTab:   Integer = 0;
    stringsI: TStringList;
    stringsT: TStringList;
    IndL:     Integer = 0;
    CodeL:    String;
    Qualite:  String;
  begin
    PMetier         := chercheMetier(TabMetier.Cells[1, TabMetier.Row]);
    MetierCode.Text := PMetier.CodeMetier;
    MetierLib.Text  := PMetier.Libelle;

    ClearStringGrid(TabMetierAttribut);
    TabMetierAttribut.ColWidths[0]      := 20;
    for PMetierAttribut in ListMetierAttribut do
      if (PMetierAttribut.CodeMetier = PMetier.CodeMetier) then
        begin
          PAttribut := ChercheAttribut(PMetierAttribut.CodeAttribut);
          case PAttribut.OrdreAttribut of
            1..10:
              begin
                Inc(IndTab);
                if TabMetierAttribut.RowCount <= IndTab then
                  TabMetierAttribut.RowCount := TabMetierAttribut.RowCount + 1;
                TabMetierAttribut.Cells[1, IndTab]   := PAttribut.CodeAttribut;
                TabMetierAttribut.Cells[2, IndTab]   := PAttribut.Libelle;
                if PMetierAttribut.NiveauMetier <> 0 then
                  TabMetierAttribut.Cells[3, IndTab] := IntToStr(PMetierAttribut.NiveauMetier)
                else
                  TabMetierAttribut.Cells[3, IndTab] := '';
              end;
          end;
        end;
    AdjustGridColumnsWidth(TabMetierAttribut, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabMetierCompetence);
    TabMetierCompetence.ColWidths[0]    := 20;
    IndTab := 0;
    for PMetierCompetence in ListMetierCompetence do
      if (PMetierCompetence.CodeMetier = PMetier.CodeMetier) then
        begin
          Inc(IndTab);
          if TabMetierCompetence.RowCount <= IndTab then
            TabMetierCompetence.RowCount := TabMetierCompetence.RowCount + 1;
          PCompetence := ChercheCompetence(PMetierCompetence.CodeCompetence);
          TabMetierCompetence.Cells[1, IndTab] := PCompetence.CodeCompetence;
          TabMetierCompetence.Cells[2, IndTab] := PCompetence.Libelle;
          TabMetierCompetence.Cells[3, IndTab] := IntToStr(PMetierCompetence.NiveauMetier);
        end;
    AdjustGridColumnsWidth(TabMetierCompetence, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabMetierTalent);
    TabMetierTalent.ColWidths[0]        := 20;
    IndTab := 0;
    for PMetierTalent in ListMetierTalent do
      if (PMetierTalent.CodeMetier = PMetier.CodeMetier) then
        begin
          Inc(IndTab);
          if TabMetierTalent.RowCount <= IndTab then
            TabMetierTalent.RowCount := TabMetierTalent.RowCount + 1;

          PTalent := ChercheTalent(PMetierTalent.CodeTalent);
          TabMetierTalent.Cells[1, IndTab] := PTalent.CodeTalent;
          TabMetierTalent.Cells[2, IndTab] := PTalent.Libelle;
          TabMetierTalent.Cells[3, IndTab] := IntToStr(PMetierTalent.NiveauMetier);
        end;
    AdjustGridColumnsWidth(TabMetierTalent, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabMetierEquipement);
    TabMetierEquipement.ColWidths[0]        := 20;
    IndTab := 0;
    for PMetierEquipement in ListMetierEquipement do
      if (PMetierEquipement.CodeMetier = PMetier.CodeMetier) then
        begin
          Inc(IndTab);
          if TabMetierEquipement.RowCount <= IndTab then
            TabMetierEquipement.RowCount := TabMetierEquipement.RowCount + 1;

          stringsI                := TStringList.Create;
          stringsT                := TStringList.Create;
          ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.Equipement), stringsI);
          ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.TypeEquipement), stringsT);
          // 1 : CodeLivre 1
          // 2 : CodeLivre 2
          // 3 : CodeLivre 3
          // 4 : nb
          // 5 : lib 1
          // 6 : lib 2
          // 7 : lib 3
          // 8 : nv
          // 9 : type 1
          //10 : type 2
          //11 : type 3
          //12 : qualité 1
          //13 : qualité 2
          //14 : qualité 3
          TabMetierEquipement.Cells[4, IndTab] := IntToStr(IndL+1);
          TabMetierEquipement.Cells[8, IndTab] := IntToStr(PMetierEquipement.NiveauMetier);
          For IndL := 0 to (stringsI.Count-1) do
            Begin
              if pos(EquipementQualite, StringsT[IndL]) > 0 then
                begin
                  CodeL  := copy(stringsI[IndL],1,length(stringsI[IndL]) - length(Equipementqualite));
                  Qualite:= GetTexteLibelle('LAB_038');
                end
              else
                begin
                  CodeL  := stringsI[IndL];
                  Qualite:= '';
                end;
              if InList(stringsT[IndL],TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                 begin
                   PArme                    := ChercheArme(CodeL);
                   TabMetierEquipement.Cells[1 + IndL, IndTab] := PArme.CodeArme;
                   TabMetierEquipement.Cells[5 + IndL, IndTab] := PArme.Libelle+Qualite;
                 end
              else if stringsT[IndL] = TypeEquipAR then
                 begin
                   PArmure                  := ChercheArmure(CodeL);
                   TabMetierEquipement.Cells[1 + IndL, IndTab] := PArmure.CodeArmure;
                   TabMetierEquipement.Cells[5 + IndL, IndTab] := PArmure.Libelle+Qualite;
                 end
              else if stringsT[IndL] = TypeEquipDI then
                 begin
                   TabMetierEquipement.Cells[1 + IndL, IndTab] := CodeL;
                   TabMetierEquipement.Cells[5 + IndL, IndTab] := CodeL;
                 end;
              TabMetierEquipement.Cells[9 + IndL, IndTab] := stringsT[IndL];
              TabMetierEquipement.Cells[12+ IndL, IndTab] := qualite;
            end;
          stringsI.Free;
          stringsT.Free;
        end;
    AdjustGridColumnsWidth(TabMetierEquipement, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabMetierNiveau);
    TabMetierNiveau.ColWidths[0]    := 20;
    IndTab := 0;
    for PMetierNiveau in ListMetierNiveau do
      if (PMetierNiveau.CodeMetier = PMetier.CodeMetier) then
        begin
          Inc(IndTab);
          if TabMetierNiveau.RowCount <= IndTab then
            TabMetierNiveau.RowCount := TabMetierNiveau.RowCount + 1;
          TabMetierNiveau.Cells[1, IndTab] := IntToStr(PMetierNiveau.NiveauMetier);
          TabMetierNiveau.Cells[2, IndTab] := PMetierNiveau.Libelle;
          TabMetierNiveau.Cells[3, IndTab] := GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' ');
        end;
    AdjustGridColumnsWidth(TabMetierNiveau, PageEtapes.Height - 40, false, false);

  end;

procedure TWinLivres.TabRaceClick(Sender: TObject);
  Var
    IndTab: Integer = 0;
    IndTabS:Integer = 0;
    Debut:  String = '';
    Fin:    String = '';
    Talent1:String = '';
    Talent2:String = '';
    Multi:  boolean = false;
    Nb:     Integer = 0;
  begin
    PRace         := chercheRace(TabRace.Cells[1, TabRace.Row]);
    RaceCode.Text := PRace.CodeRace;
    RaceLib.Text  := PRace.Libelle;

    ClearStringGrid(TabRaceAttribut);
    TabRaceAttribut.ColWidths[0]      := 20;
    ClearStringGrid(TabRaceAttributSupp);
    TabRaceAttributSupp.ColWidths[0]  := 20;
    for PRaceAttribut in ListRaceAttribut do
      if (PRaceAttribut.CodeRace = PRace.CodeRace) then
        begin
          PAttribut := ChercheAttribut(PRaceAttribut.CodeAttribut);
          case PAttribut.OrdreAttribut of
            1..10:
              begin
                Inc(IndTab);
                if TabRaceAttribut.RowCount <= IndTab then
                  TabRaceAttribut.RowCount := TabRaceAttribut.RowCount + 1;
                TabRaceAttribut.Cells[1, IndTab] := PAttribut.CodeAttribut;
                TabRaceAttribut.Cells[2, IndTab] := PAttribut.Libelle;
                Debut := ExtractStringBefore(ExtractStringBefore(PRaceAttribut.CalculRace,'+'),'d10');
                Fin   := ExtractStringAfter(PRaceAttribut.CalculRace,'+');
                TabRaceAttribut.Cells[3, IndTab] := Debut;
                TabRaceAttribut.Cells[4, IndTab] := Fin;
              end;
            11:
              begin
                DecodeBlessure(PRaceAttribut.CalculRace);
                RaceBlessureForce.text        := IntToStr(SelectWinF);
                RaceBlessureEndurance.Text    := IntToStr(SelectWinE);
                RaceBlessureForceMentale.Text := IntToStr(SelectWinFM);
              end;
            12..15:
              begin
                Inc(IndTabS);
                if TabRaceAttributSupp.RowCount <= IndTabS then
                  TabRaceAttributSupp.RowCount := TabRaceAttributSupp.RowCount + 1;
                TabRaceAttributSupp.Cells[1, IndTabS] := PAttribut.CodeAttribut;
                TabRaceAttributSupp.Cells[2, IndTabS] := PAttribut.Libelle;
                TabRaceAttributSupp.Cells[3, IndTabS] := PRaceAttribut.CalculRace;
              end;
          end;
        end;
    AdjustGridColumnsWidth(TabRaceAttribut, PageEtapes.Height - 40, false, false);
    AdjustGridColumnsWidth(TabRaceAttributSupp, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabRaceCompetence);
    TabRaceCompetence.ColWidths[0]    := 20;
    IndTab := 0;
    for PRaceCompetence in ListRaceCompetence do
      if (PRaceCompetence.CodeRace = PRace.CodeRace) then
        begin
          Inc(IndTab);
          if TabRaceCompetence.RowCount <= IndTab then
            TabRaceCompetence.RowCount := TabRaceCompetence.RowCount + 1;
          PCompetence := ChercheCompetence(PRaceCompetence.CodeCompetence);
          TabRaceCompetence.Cells[1, IndTab] := PCompetence.CodeCompetence;
          TabRaceCompetence.Cells[2, IndTab] := PCompetence.Libelle;
        end;
    AdjustGridColumnsWidth(TabRaceCompetence, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabRaceTalent);
    TabRaceTalent.ColWidths[0]        := 20;
    IndTab := 0;
    for PRaceTalent in ListRaceTalent do
      if (PRaceTalent.CodeRace = PRace.CodeRace) then
        begin
          Inc(IndTab);
          if TabRaceTalent.RowCount <= IndTab then
            TabRaceTalent.RowCount := TabRaceTalent.RowCount + 1;

          Multi   := (pos(SeparateurMulti, PRaceTalent.CodeTalent) > 0);
          if Multi then
             Begin
               Nb      := 2;
               Talent1 := ExtractStringBefore(PRaceTalent.CodeTalent, SeparateurMulti);
               Talent2 := ExtractStringAfter(PRaceTalent.CodeTalent, SeparateurMulti);
             end
          else
             begin
               Nb      := 1;
               Talent1 := PRaceTalent.CodeTalent;
               Talent2 := '';
             end;

          PTalent := ChercheTalent(Talent1);
          TabRaceTalent.Cells[1, IndTab] := PTalent.CodeTalent;
          TabRaceTalent.Cells[3, IndTab] := IntToStr(Nb);
          TabRaceTalent.Cells[4, IndTab] := PTalent.Libelle;
          if Talent2 <> '' then
            begin
              PTalent := ChercheTalent(Talent2);
              TabRaceTalent.Cells[2, IndTab] := PTalent.CodeTalent;
              TabRaceTalent.Cells[5, IndTab] := PTalent.Libelle;
            end;
        end;
    AdjustGridColumnsWidth(TabRaceTalent, PageEtapes.Height - 40, false, false);

    ClearStringGrid(TabRaceMetier);
    TabRaceMetier.ColWidths[0]        := 20;
    IndTab := 0;
    for PRaceMetier in ListRaceMetier do
      if (PRaceMetier.CodeRace = PRace.CodeRace) and (PRaceMetier.Livre = NomLivre) then
        begin
          Inc(IndTab);
          if TabRaceMetier.RowCount <= IndTab then
            TabRaceMetier.RowCount := TabRaceMetier.RowCount + 1;

          PMetier := ChercheMetier(PRaceMetier.CodeMetier);
          TabRaceMetier.Cells[1, IndTab] := PMetier.CodeMetier;
          TabRaceMetier.Cells[2, IndTab] := PMetier.Libelle;
          TabRaceMetier.Cells[3, IndTab] := PRaceMetier.Chance;
        end;
    AdjustGridColumnsWidth(TabRaceMetier, PageEtapes.Height - 40, false, false);

  end;

end.

