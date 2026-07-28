unit WinCompetence;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, StdCtrls, ExtCtrls, ChargeCompetence, ChargeConstantes, GlobalFonts,
  ChargeTexte, UnitCalcul, LCLType, ChargeMetierCompetence, ChargeMetier,
  WinMetier;

type

  { TWinCompetence }

  TWinCompetence = class(TForm)
    AffCode: TEdit;
    AffAttribut: TEdit;
    AffLib: TEdit;
    AffLivre: TEdit;
    AffSpecialisation: TEdit;
    ImageWar: TImage;
    LabCode: TLabel;
    LabAttribut: TLabel;
    LabLivre: TLabel;
    LabMetierCompetence: TLabel;
    LabSpe: TLabel;
    LabSpecialisation: TLabel;
    LabLib: TLabel;
    LabDescription: TLabel;
    AffDescription: TMemo;
    TabMetierCompetence: TStringGrid;
    TabCompetence: TStringGrid;
    TabSpe: TStringGrid;
    procedure FormClose({%H-}Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabCompetenceAfterSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabCompetenceDblClick({%H-}Sender: TObject);
    procedure TabMetierCompetenceDblClick({%H-}Sender: TObject);
    procedure TabSpeDblClick({%H-}Sender: TObject);

  private

  public

  end;

  var
    FenMetier: TWinMetiers;


implementation

{$R *.lfm}

{ TWinCompetence }

procedure TWinCompetence.FormCreate(Sender: TObject);
var
  PCompetence:   StructureCompetence;
  IndTab:        Integer;
  Accord:        Boolean;
begin
    // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    TabCompetence.RowCount := 1;
    IndTab                 := 0;

    // on met toutes les données dans la table pour les afficher directement dans les champs
    TabCompetence.ColCount     := 1;
    TabCompetence.ColWidths[0] := 20;
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_001'));
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_002'), 265);
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_002'));
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_003'));
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_078'));
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_128'), 130);
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_001'), 130);
    GridAjouteColonne(TabCompetence, GetTexteLibelle('LAB_001'));

    TabMetierCompetence.RowCount        := 2;
    TabMetierCompetence.ColCount        := 1;
    TabMetierCompetence.ColWidths[0]    := 20;
    GridAjouteColonne(TabMetierCompetence, GetTexteLibelle('LAB_001'), 0);
    GridAjouteColonne(TabMetierCompetence, GetTexteLibelle('LAB_006'), 250);
    GridAjouteColonne(TabMetierCompetence, GetTexteLibelle('LAB_019'), 70);

    TabSpe.RowCount        := 2;
    TabSpe.ColCount        := 1;
    TabSpe.ColWidths[0]    := 20;
    GridAjouteColonne(TabSpe, GetTexteLibelle('LAB_001'), 0);
    GridAjouteColonne(TabSpe, GetTexteLibelle('LAB_006'), 70);

    if Pos(ValeurSousCompetence, SelectWinCompetence) > 0 then
      SelectWinCompetence := ExtractStringBefore(SelectWinCompetence, ValeurSousCompetence) + ValeurGenerique;

    For PCompetence in ListCompetence do
      begin
        if (SelectWinCompetence <> '') and (PCompetence.CodeCompetence <> SelectWinCompetence) then
          Accord := False
        else
          Accord := True;
        if Accord and (PCompetence.SousCompetence = false) then
            Begin
              Inc(IndTab);
              TabCompetence.RowCount := TabCompetence.RowCount + 1;
              TabCompetence.Cells[1, IndTab] := PCompetence.CodeCompetence;
              TabCompetence.Cells[2, IndTab] := PCompetence.Libelle;
              TabCompetence.Cells[3, IndTab] := GetTexteLibelle(PCompetence.CodeAttribut);
              TabCompetence.Cells[4, IndTab] := PCompetence.Description;
              TabCompetence.Cells[6, IndTab] := GetTexteLibelle(PCompetence.Livre,'','',true);
              TabCompetence.Cells[7, IndTab] := PCompetence.CodeCompetence;
            end;
      end;
    //Sort
    TabCompetence.SortColRow(true,2);

    if FileExists(GetCurrentDir+ConstCheminLogo1) then
      ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption                := GetTexteLibelle('LAB_009');
    Labcode.Caption             := GetTexteLibelle('LAB_001');
    LabLib.Caption              := GetTexteLibelle('LAB_002');
    LabAttribut.Caption         := GetTexteLibelle('LAB_008');
    LabSpecialisation.caption   := GetTexteLibelle('LAB_078');
    LabDescription.caption      := GetTexteLibelle('LAB_003');
    LabMetierCompetence.caption := GetTexteLibelle('LAB_006');
    LabLivre.caption            := GetTexteLibelle('LAB_128');
    LabSpe.caption              := GetTexteLibelle('LAB_078');

    if SelectWinCompetence <> '' then
      begin
        tabCompetence.visible := false;
        TabCompetenceAfterSelection(self, 1, 1)
      end;

    AdjustGridColumnsWidth(TabCompetence, self.Height, false, false);
    if (TabCompetence.Width > (Labcode.Left - 20)) then
      TabCompetence.Width := (Labcode.Left - 20);
    TabCompetence.Row := 1;
    TabCompetenceAfterSelection(TabCompetence, 1, 1);

    KeyPreview := true;
end;

procedure TWinCompetence.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinCompetence.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
    TabCompetence.Clear;
    AffDescription.Clear;
    CloseAction := caFree;
end;

procedure TWinCompetence.TabCompetenceAfterSelection(Sender: TObject; aCol,
  aRow: Integer);
  var
    PMetierCompetence: StructureMetierCompetence;
    PMetier:           StructureMetier;
    PCompetence:       StructureCompetence;
    Ind:               Integer;
  begin
    // renseigner les données
    AffCode.Text             := TabCompetence.Cells[1,aRow];
    AffLib.Text              := TabCompetence.Cells[2,aRow];
    AffAttribut.Text         := TabCompetence.Cells[3,aRow];
    Affdescription.Text      := TabCompetence.Cells[4,aRow];
    AffSpecialisation.Text   := TabCompetence.Cells[5,aRow];
    AffLivre.Text            := TabCompetence.Cells[6,aRow];

    // cacher les spécialisations si elles ne sont pas nécessaire
    AffSpecialisation.Visible:= (AffSpecialisation.Text <> '');
    LabSpecialisation.Visible:= (AffSpecialisation.Text <> '');

    ClearStringGrid(TabMetierCompetence);
    TabMetierCompetence.RowCount := 2;
    Ind := 0;
    For PMetierCompetence in ListMetierCompetence do
      if ExtractStringBefore(PMetierCompetence.CodeCompetence,'_') = extractStringBefore(AffCode.Text,'_') then
        begin
          PMetier := chercheMetier(PMetierCompetence.CodeMetier);
          Inc(Ind);
          if Ind = TabMetierCompetence.RowCount then
            TabMetierCompetence.RowCount    := TabMetierCompetence.RowCount + 1;
          TabMetierCompetence.Cells[1, Ind] := PMetier.CodeMetier;
          TabMetierCompetence.Cells[2, Ind] := PMetier.Libelle;
          TabMetierCompetence.Cells[3, Ind] := IntToStr(PMetierCompetence.NiveauMetier);
        end;
    TabMetierCompetence.SortColRow(true,2);
    AdjustGridColumnsWidth(TabMetierCompetence, self.Height, false, false);

    ClearStringGrid(TabSpe);
    TabSpe.RowCount := 2;
    Ind := 0;
    if Pos(ValeurGenerique, AffCode.Text) > 0 then
      begin
        For PCompetence in ListCompetence do
          if (PCompetence.CodeCompetence <> AffCode.Text) and (ExtractStringBefore(PCompetence.CodeCompetence,ValeurSousCompetence) = ExtractStringBefore(AffCode.Text,ValeurSousCompetence)) then
            begin
              Inc(Ind);
              if Ind = TabSpe.RowCount then
                TabSpe.RowCount    := TabSpe.RowCount + 1;
              TabSpe.Cells[1, Ind]    := PCompetence.CodeCompetence;
              TabSpe.Cells[2, Ind]    := PCompetence.Libelle;
            end;
        AdjustGridColumnsWidth(TabSpe, self.Height, false, false);
      end;
    LabSpe.Visible := (Ind > 0);
    TabSpe.Visible := (Ind > 0);
    TabSpe.SortColRow(True, 2);
  end;

procedure TWinCompetence.TabCompetenceDblClick(Sender: TObject);
begin
  if ChoixWinTypeFichier <> '' then
    begin
      if TabSpe.Visible then
        showmessage(GetTexteLibelle('MESS_034'))
      else
        begin
          SelectWinCompetence := TabCompetence.Cells[1, TabCompetence.Row];
          close;
        end;
    end;
end;

procedure TWinCompetence.TabMetierCompetenceDblClick(Sender: TObject);
begin
  // ouvrir les métiers
  SelectWinMetier     := TabMetierCompetence.Cells[1,TabMetierCompetence.Row];
  FenMetier           := TWinMetiers.Create(Application);
  FenMetier.Position  := poOwnerFormCenter;
  FenMetier.ShowModal;
  SelectWinMetier     := '';

end;

procedure TWinCompetence.TabSpeDblClick(Sender: TObject);
begin
  if ChoixWinTypeFichier <> '' then
    begin
      SelectWinCompetence := TabSpe.Cells[1, Tabspe.Row];
      close;
    end;
end;

end.

