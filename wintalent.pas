unit WinTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, StdCtrls, ExtCtrls, ChargeTalent, ChargeConstantes, GlobalFonts,
  ChargeTexte, UnitCalcul, ChargeMetierTalent, ChargeMetier, WinMetier,
  ChargeTalentCreation;

type

  { TWintTalent }

  TWintTalent = class(TForm)
    AffAttribut: TEdit;
    AffLivre: TEdit;
    AffMaxi: TEdit;
    AffCode: TEdit;
    AffDescription: TMemo;
    AffLib: TEdit;
    AffTest: TEdit;
    AffDecrShort: TEdit;
    ImageWar: TImage;
    LabAttribut: TLabel;
    LabDescription1: TLabel;
    LabLivre: TLabel;
    LabMetierTalent: TLabel;
    LabMaxi: TLabel;
    LabCode: TLabel;
    LabDescription: TLabel;
    LabLib: TLabel;
    LabSpe: TLabel;
    LabTest: TLabel;
    TabMetierTalent: TStringGrid;
    TabSpe: TStringGrid;
  TabTalent: TStringGrid;
  procedure FormClose({%H-}Sender: TObject; var CloseAction: TCloseAction);
  procedure FormCreate({%H-}Sender: TObject);
  procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
  procedure TabMetierTalentDblClick({%H-}Sender: TObject);
  procedure TabTalentDblClick({%H-}Sender: TObject);
  procedure TabTalentSelection({%H-}Sender: TObject; aCol, aRow: Integer);

  private
  public

  end;

var
  FenMetier: TWinMetiers;

implementation

{$R *.lfm}

{ TWintTalent }

procedure TWintTalent.FormCreate(Sender: TObject);
var
  PTalent:   StructureTalent;
  Accord:    Boolean;
  IndTab:    Integer;
begin
    // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);
    IndTab             := 0;

    // on met toutes les données dans la table pour les afficher directement dans les champs
    TabTalent.RowCount     := 1;
    TabTalent.ColCount     := 1;
    TabTalent.ColWidths[0] := 20;
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_001'));
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_002'), 265);
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_008'));
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_003'));
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_110'));
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_111'));
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_128'), 100);
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_001'), 100);
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_002'), 100);
    GridAjouteColonne(TabTalent, GetTexteLibelle('RULES-LAB_001'), 0);

    TabMetierTalent.RowCount        := 2;
    TabMetierTalent.ColCount        := 1;
    TabMetierTalent.ColWidths[0]    := 20;
    GridAjouteColonne(TabMetierTalent, GetTexteLibelle('RULES-LAB_001'), 0);
    GridAjouteColonne(TabMetierTalent, GetTexteLibelle('RULES-LAB_006'), 250);
    GridAjouteColonne(TabMetierTalent, GetTexteLibelle('RULES-LAB_019'), 70);

    TabSpe.RowCount        := 2;
    TabSpe.ColCount        := 1;
    TabSpe.ColWidths[0]    := 20;
    GridAjouteColonne(TabSpe, GetTexteLibelle('RULES-LAB_001'), 20);
    GridAjouteColonne(TabSpe, GetTexteLibelle('RULES-LAB_006'), 250);

    if Pos(ValeurSousCompetence, SelectWinTalent) > 0 then
      SelectWinTalent := ExtractStringBefore(SelectWinTalent, ValeurSousCompetence) + ValeurGenerique;

    For PTalent in ListTalent do
      begin
        if (SelectWinTalent <> '') and (SelectWinTalent <> PTalent.CodeTalent) then
          Accord := false
        else
          Accord := true;
        if Accord and (PTalent.SousTalent = false) then
            Begin
              Inc(IndTab);
              TabTalent.RowCount := TabTalent.RowCount + 1;
              TabTalent.Cells[ 1, IndTab] := PTalent.CodeTalent;
              TabTalent.Cells[ 2, IndTab] := PTalent.Libelle;
              TabTalent.Cells[ 3, IndTab] := GetAllTexteLibelle(PTalent.Attribut);
              TabTalent.Cells[ 4, IndTab] := PTalent.Description;
              TabTalent.Cells[ 5, IndTab] := PTalent.Tests;
              TabTalent.Cells[ 6, IndTab] := ReplaceTexteLibelle(PTalent.MaxiTalent);
              TabTalent.Cells[ 7, IndTab] := GetTexteLibelle(PTalent.Livre,'','',true);
              TabTalent.Cells[ 8, IndTab] := PTalent.CodeTalent;
              TabTalent.Cells[ 9, IndTab] := PTalent.Resume;
            end;
    end;
    TabTalent.SortColRow(true,2);

    if FileExists(GetCurrentDir+ConstCheminLogo1) then
     ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption              := GetTexteLibelle('RULES-LAB_007');
    Labcode.Caption           := GetTexteLibelle('RULES-LAB_001');
    LabLib.Caption            := GetTexteLibelle('RULES-LAB_002');
    LabAttribut.Caption       := GetTexteLibelle('RULES-LAB_008');
    LabTest.caption           := GetTexteLibelle('RULES-LAB_110');
    LabDescription.caption    := GetTexteLibelle('RULES-LAB_003');
    LabMaxi.caption           := GetTexteLibelle('RULES-LAB_111');
    LabMetierTalent.caption   := GetTexteLibelle('RULES-LAB_006');
    LabLivre.caption          := GetTexteLibelle('RULES-LAB_128');
    LabSpe.caption            := GetTexteLibelle('RULES-LAB_078');

    if SelectWinTalent <> '' then
     begin
       TabTalentSelection(Self, 1,1);
       tabTalent.visible := false;
     end;

    AdjustGridColumnsWidth(TabTalent, self.Height, false, true);
    TabTalent.Row := 1;
    TabTalent.Col := 1;
    TabTalentSelection(TabTalent, 1, 1);
    KeyPreview := true;
end;

procedure TWintTalent.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWintTalent.TabMetierTalentDblClick(Sender: TObject);
  begin
    if ChoixWinTypeFichier <> '' then
      begin
        SelectWinTalent := TabSpe.Cells[1, Tabspe.Row];
        close;
      end;
  end;

procedure TWintTalent.TabTalentDblClick(Sender: TObject);
begin
  if ChoixWinTypeFichier <> '' then
    begin
      if TabSpe.Visible then
        showmessage(GetTexteLibelle('MESS_034'))
      else
        begin
          SelectWinTalent := TabTalent.Cells[1, TabTalent.Row];
          close;
        end;
    end;
end;

procedure TWintTalent.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    TabTalent.Clear;
    AffDescription.Clear;
    CloseAction := caFree;

    ModalResult := mrOk;
end;

procedure TWintTalent.TabTalentSelection(Sender: TObject; aCol, aRow: Integer);
var
  PMetierTalent:   StructureMetierTalent;
  PMetier:         StructureMetier;
  Ind:             Integer;
  PTalent:         StructureTalent;

begin
    // renseigner les données
    IndTab                   := aCol;                        // bidon pour compilateur
    AffCode.Text             := TabTalent.Cells[1,aRow];
    AffLib.Text              := TabTalent.Cells[2,aRow];
    AffAttribut.Text         := TabTalent.Cells[3,aRow];
    Affdescription.Text      := DescriptionTalent(TabTalent.Cells[1,aRow], ConstCodeRaceCreationGenerique);
    AffTEst.Text             := TabTalent.Cells[5,aRow];
    AffMaxi.Text             := TabTalent.Cells[6,aRow];
    AffLivre.Text            := TabTalent.Cells[7,aRow];
    AffDecrShort.Text        := TabTalent.Cells[9,aRow];

    // cacher les spécialisations si elles ne sont pas nécessaire
    AffTest.Visible          := (AffTest.Text <> '');
    LabTest.Visible          := (AffTest.Text <> '');
    AffMaxi.Visible          := (AffMaxi.Text <> '');
    LabMaxi.Visible          := (AffMaxi.Text <> '');
    AffAttribut.Visible      := (AffAttribut.Text <> '');
    LabAttribut.Visible      := (AffAttribut.Text <> '');

    ClearStringGrid(TabMetierTalent);
    TabMetierTalent.RowCount := 2;
    Ind := 0;
    For PMetierTalent in ListMetierTalent do
      if PMetierTalent.CodeTalent = AffCode.Text then
        begin
          PMetier := chercheMetier(PMetierTalent.CodeMetier);
          Inc(Ind);
          if Ind = TabMetierTalent.RowCount then
            TabMetierTalent.RowCount    := TabMetierTalent.RowCount + 1;
          TabMetierTalent.Cells[1, Ind] := PMetier.CodeMetier;
          TabMetierTalent.Cells[2, Ind] := PMetier.Libelle;
          TabMetierTalent.Cells[3, Ind] := IntToStr(PMetierTalent.NiveauMetier);
        end;
    AdjustGridColumnsWidth(TabMetierTalent, self.Height, false, false);
    TabMetierTalent.SortColRow(True, 2);

    ClearStringGrid(TabSpe);
    TabSpe.RowCount := 2;
    Ind := 0;
    if Pos(ValeurGenerique, AffCode.Text) > 0 then
      begin
        For PTalent in ListTalent do
          if (PTalent.CodeTalent <> AffCode.Text) and (ExtractStringBefore(Ptalent.CodeTalent,ValeurSousCompetence) = ExtractStringBefore(AffCode.Text,ValeurSousCompetence)) then
            begin
              Inc(Ind);
              if Ind = TabSpe.RowCount then
                TabSpe.RowCount    := TabSpe.RowCount + 1;
              TabSpe.Cells[1, Ind]    := PTalent.CodeTalent;
              TabSpe.Cells[2, Ind]    := PTalent.Libelle;
            end;
        AdjustGridColumnsWidth(TabSpe, self.Height, false, false);
      end;
    LabSpe.Visible := (Ind > 0);
    TabSpe.Visible := (Ind > 0);
    TabSpe.SortColRow(True, 2);
  end;

end.


