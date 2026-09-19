unit WinEquipement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, BCButton, ChargeTrapping, GlobalFonts, ChargeConstantes,
  UnitCalcul, ChargeTexte, WinFiltre;

type

  { TWinEquipements }

  // Liste des objets du catalogue DATA_TRAPPING, filtrable par theme
  // (balise <Theme>) et par livre.
  TWinEquipements = class(TForm)
    AffCap: TEdit;
    AffDispo: TEdit;
    AffEnc: TEdit;
    AffLib: TEdit;
    AffLivre: TEdit;
    AffPrix: TEdit;
    ButtonFiltre: TBCButton;
    CombTheme: TComboBox;
    LabCap: TLabel;
    LabDispo: TLabel;
    LabEnc: TLabel;
    LabLivre: TLabel;
    LabPrix: TLabel;
    LabTheme: TLabel;
    TabEquip: TStringGrid;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormDestroy({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabEquipDblClick({%H-}Sender: TObject);
    procedure TabEquipSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure ThemeChange({%H-}Sender: TObject);
  private
    ListeThemes:   TStringList;
    FiltreLivre:   String;
    EnRemplissage: Boolean;
    procedure ChargeThemes;
    procedure Remplir;
  end;

var
  WinEquipements: TWinEquipements;

implementation

{$R *.lfm}

{ TWinEquipements }

procedure TWinEquipements.FormCreate(Sender: TObject);
begin
  EnRemplissage := false;
  FiltreLivre   := SelectWinLivre;
  ListeThemes   := TStringList.Create;

  MiseEnFormeDesChamp(Self);
  Caption              := GetTexteLibelle('RULES-LAB_202');
  LabTheme.Caption     := GetTexteLibelle('RULES-LAB_201');
  ButtonFiltre.Caption := GetTexteLibelle('RULES-LAB_133');
  LabPrix.Caption      := GetTexteLibelle('RULES-LAB_054');
  LabEnc.Caption       := GetTexteLibelle('RULES-LAB_055');
  LabCap.Caption       := GetTexteLibelle('RULES-LAB_185');
  LabDispo.Caption     := GetTexteLibelle('RULES-LAB_056');
  LabLivre.Caption     := GetTexteLibelle('RULES-LAB_128');

  // colonnes fixees par le .lfm (ColCount = 9) : seuls les titres sont poses ici
  TabEquip.Cells[1, 0] := GetTexteLibelle('RULES-LAB_001');
  TabEquip.Cells[2, 0] := GetTexteLibelle('RULES-LAB_201');
  TabEquip.Cells[3, 0] := GetTexteLibelle('RULES-LAB_002');
  TabEquip.Cells[4, 0] := GetTexteLibelle('RULES-LAB_054');
  TabEquip.Cells[5, 0] := GetTexteLibelle('RULES-LAB_055');
  TabEquip.Cells[6, 0] := GetTexteLibelle('RULES-LAB_185');
  TabEquip.Cells[7, 0] := GetTexteLibelle('RULES-LAB_056');
  TabEquip.Cells[8, 0] := GetTexteLibelle('RULES-LAB_128');
  TabEquip.ColWidths[0] := 20;

  ChargeThemes;
  Remplir;
end;

procedure TWinEquipements.FormDestroy(Sender: TObject);
begin
  ListeThemes.Free;
end;

// themes presents dans le catalogue (dans l'ordre du premier objet rencontre),
// precedes de l'entree "Tous"
procedure TWinEquipements.ChargeThemes;
var
  PTrapping: StructureTrapping;
begin
  ListeThemes.Clear;
  CombTheme.Items.Clear;
  ListeThemes.Add('');
  CombTheme.Items.Add(GetTexteLibelle('RULES-LAB_200'));
  for PTrapping in ListTrapping do
    if (PTrapping.Theme <> '') and (ListeThemes.IndexOf(PTrapping.Theme) < 0) then
      begin
        ListeThemes.Add(PTrapping.Theme);
        CombTheme.Items.Add(GetTexteLibelle(PTrapping.Theme));
      end;
  CombTheme.ItemIndex := 0;
end;

procedure TWinEquipements.Remplir;
var
  PTrapping: StructureTrapping;
  Theme:     String;
  Ind:       Integer;
begin
  Theme := '';
  if CombTheme.ItemIndex > 0 then
    Theme := ListeThemes[CombTheme.ItemIndex];

  EnRemplissage := true;
  try
    TabEquip.RowCount := 1;
    Ind := 0;
    for PTrapping in ListTrapping do
      if ((Theme = '') or (PTrapping.Theme = Theme)) and VerifieFiltre(PTrapping.Livre, FiltreLivre) then
        begin
          Inc(Ind);
          if TabEquip.RowCount <= Ind then
            TabEquip.RowCount := Ind + 1;
          TabEquip.Cells[1, Ind] := PTrapping.CodeTrapping;
          if PTrapping.Theme <> '' then
            TabEquip.Cells[2, Ind] := GetTexteLibelle(PTrapping.Theme);
          TabEquip.Cells[3, Ind] := PTrapping.Libelle;
          TabEquip.Cells[4, Ind] := PTrapping.Prix;
          TabEquip.Cells[5, Ind] := IntToStr(PTrapping.Encombrement);
          TabEquip.Cells[6, Ind] := IntToStr(PTrapping.Capacite);
          TabEquip.Cells[7, Ind] := ReplaceTexteLibelle(PTrapping.Disponibilite);
          TabEquip.Cells[8, Ind] := GetTexteLibelle(PTrapping.Livre, '', '', true);
        end;
    AdjustGridColumnsWidth(TabEquip, Self.Height, false, false);
    // la procedure agrandit la grille a la largeur de ses colonnes : on la remet a sa place
    TabEquip.SetBounds(10, 75, 620, Self.ClientHeight - 85);
    TabEquip.ScrollBars := ssAutoBoth;
  finally
    EnRemplissage := false;
  end;
  if TabEquip.RowCount > 1 then
    begin
      TabEquip.Row := 1;
      TabEquipSelection(TabEquip, 1, 1);
    end;
end;

procedure TWinEquipements.TabEquipSelection(Sender: TObject; aCol, aRow: Integer);
begin
  if EnRemplissage or (aRow < 1) or (aRow >= TabEquip.RowCount) then exit;
  AffLib.Text    := TabEquip.Cells[3, aRow];
  AffPrix.Text   := TabEquip.Cells[4, aRow];
  AffEnc.Text    := TabEquip.Cells[5, aRow];
  AffCap.Text    := TabEquip.Cells[6, aRow];
  AffDispo.Text  := TabEquip.Cells[7, aRow];
  AffLivre.Text  := TabEquip.Cells[8, aRow];
  LabCap.Visible := AffCap.Text <> '0';
  AffCap.Visible := AffCap.Text <> '0';
end;

// Mode selection (appel depuis WinPersonnage) : le double-clic renvoie le code de l'objet.
procedure TWinEquipements.TabEquipDblClick(Sender: TObject);
begin
  if (SelectWinTrapping <> '') and (TabEquip.Row > 0) then
    begin
      ChoixWinTrapping := TabEquip.Cells[1, TabEquip.Row];
      Close;
    end;
end;

procedure TWinEquipements.ThemeChange(Sender: TObject);
begin
  Remplir;
end;

procedure TWinEquipements.ButtonFiltreClick(Sender: TObject);
var
  FenFiltre: TWinFiltre;
begin
  SelectWinLivre     := FiltreLivre;
  WinFiltreAppelant  := ConstXmlArme;
  FenFiltre          := TWinFiltre.Create(Application);
  FenFiltre.Position := poOwnerFormCenter;
  FenFiltre.ShowModal;
  if ChoixWinLivre <> FiltreLivre then
    begin
      FiltreLivre := ChoixWinLivre;
      Remplir;
    end;
end;

procedure TWinEquipements.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then Close;
end;

end.
