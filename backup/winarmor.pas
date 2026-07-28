unit WinArmor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, BCButton, ChargeArmure, GlobalFonts, ChargeConstantes,
  UnitCalcul, ChargeArmureBonus, ChargeTexte, WinFiltre, ChargeArmureSimplifie;

type

  { TWinArmors }

  TWinArmors = class(TForm)
    AffCode: TEdit;
    AffDescription: TMemo;
    AffEmplacement: TEdit;
    AffLivre: TEdit;
    AffProtection: TEdit;
    AffType: TEdit;
    AffLib: TEdit;
    AffDisponbilite: TEdit;
    AffPrix: TEdit;
    AffEncombrement: TEdit;
    ButtonFiltre: TBCButton;
    CheckBoxSimplified: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    ImageWar: TImage;
    LabCode: TLabel;
    LabQuickArmor: TLabel;
    LabEmplacement: TLabel;
    LabBonus: TLabel;
    LabLivre: TLabel;
    LabProtection: TLabel;
    LabDisponibilite: TLabel;
    LabPrix: TLabel;
    LabType: TLabel;
    LabLib: TLabel;
    LabEncombrement: TLabel;
    TabBonus: TStringGrid;
    TabArmor: TStringGrid;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure CheckBoxSimplifiedClick(Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabArmorDblClick({%H-}Sender: TObject);
    procedure TabArmorSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabBonusSelection({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
    procedure WinCharger();
    procedure WinVider();
  private

  public

  end;

var
  WinArmors:      TWinArmors;
  FiltreLivre:    String;
  FenFiltre:      TWinFiltre;

implementation

{$R *.lfm}

{ TWinArmors }

procedure TWinArmors.FormCreate(Sender: TObject);
  begin
    FiltreLivre := SelectWinLivre;
    WinCharger();
  end;

procedure TWinArmors.WinCharger();
var
  PArmure:           StructureArmure;
  PArmureSimplifiee: StructureArmureSimplifiee;
  NbWeap:            Integer = 0;
  IndTab:            Integer = 0;
  begin
      // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    TabArmor.RowCount      := 1;
    // on met toutes les données dans la table pour les afficher directement dans les champs
    if TabArmor.ColCount < 2 then
      begin
        TabArmor.ColCount      := 1;
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_074'),120);
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_002'),220);
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_075'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_054'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_055'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_056'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_076'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_059'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_128'),100);
        GridAjouteColonne(TabArmor,GetTexteLibelle('LAB_001'),100);
      end;
    TabArmor.ColWidths[0]  := 20;

        // on met toutes les données dans la table pour les afficher directement dans les champs
    TabBonus.RowCount      := 7;
    if TabBonus.ColCount < 2 then
      begin
        TabBonus.ColCount      := 1;
        TabBonus.ColWidths[0]  := 20;
        GridAjouteColonne(TabBonus,GetTexteLibelle('LAB_002'),120);
        GridAjouteColonne(TabBonus,GetTexteLibelle('LAB_072'));
        GridAjouteColonne(TabBonus,GetTexteLibelle('LAB_077'),300);
      end;

    IndTab := 0;
    if (CheckBoxSimplified.Checked = false) then
      begin
        TabArmor.ColWidths[2]               := 120;
        for Parmure in ListArmure do
          if (Pos(ValeurGenerique,PArmure.CodeArmure) = 0) and VerifieFiltre(PArmure.Livre, FiltreLivre) then
            begin
              Inc(IndTab);
              if TabArmor.RowCount <= IndTab then
                TabArmor.RowCount := TabArmor.RowCount + 1;

              TabArmor.Cells[ 1,NbWeap+1]  := PArmure.CodeArmure;
              TabArmor.Cells[ 2,NbWeap+1]  := GetAllTexteLibelle(PArmure.TypeMateriel);
              TabArmor.Cells[ 3,NbWeap+1]  := PArmure.Libelle;
              TabArmor.Cells[ 4,NbWeap+1]  := GetAllTexteLibelle(PArmure.Emplacement);
              TabArmor.Cells[ 5,NbWeap+1]  := PArmure.Prix;
              TabArmor.Cells[ 6,NbWeap+1]  := IntToStr(PArmure.Encombrement);
              TabArmor.Cells[ 7,NbWeap+1]  := GetAllTexteLibelle(PArmure.Disponibilite);
              TabArmor.Cells[ 8,NbWeap+1]  := IntToStr(PArmure.Protection);
              TabArmor.Cells[ 9,NbWeap+1]  := PArmure.ListeBonus;
              TabArmor.Cells[10,NbWeap+1]  := GetTexteLibelle(PArmure.Livre,'','',true);
              TabArmor.Cells[11,NbWeap+1]  := PArmure.CodeArmure;
              Inc(NbWeap);
           end;
        end
    else
      begin
        TabArmor.ColWidths[2]               := 0;
        for PArmureSimplifiee in ListArmureSimplifiee do
          if (Pos(ValeurGenerique,PArmureSimplifiee.CodeArmure) = 0) and VerifieFiltre(PArmureSimplifiee.Livre, FiltreLivre) then
            begin
              Inc(IndTab);
              if TabArmor.RowCount <= IndTab then
                TabArmor.RowCount := TabArmor.RowCount + 1;

              TabArmor.Cells[ 1,NbWeap+1]  := PArmureSimplifiee.CodeArmure;
              TabArmor.Cells[ 3,NbWeap+1]  := PArmureSimplifiee.Libelle;
              TabArmor.Cells[ 5,NbWeap+1]  := PArmureSimplifiee.Prix;
              TabArmor.Cells[ 6,NbWeap+1]  := IntToStr(PArmureSimplifiee.Encombrement);
              TabArmor.Cells[ 7,NbWeap+1]  := GetAllTexteLibelle(PArmureSimplifiee.Disponibilite);
              TabArmor.Cells[ 8,NbWeap+1]  := IntToStr(PArmureSimplifiee.Protection);
              TabArmor.Cells[ 9,NbWeap+1]  := PArmureSimplifiee.ListeBonus;
              TabArmor.Cells[10,NbWeap+1]  := GetTexteLibelle(PArmureSimplifiee.Livre,'','',true);
              TabArmor.Cells[11,NbWeap+1]  := PArmureSimplifiee.CodeArmure;
              Inc(NbWeap);
           end;
        end;

    //Sort
    if (CheckBoxSimplified.Checked = false) then
      TabArmor.SortColRow(true,2)
    else
      TabArmor.SortColRow(true,1);
    AdjustGridColumnsWidth(TabArmor, self.Height, false, true);
    AdjustGridColumnsWidth(TabBonus, self.Height, false, true);

    if FileExists(GetCurrentDir+ConstCheminLogo1) then
      ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption              := GetTexteLibelle('LAB_065');
    Labcode.Caption           := GetTexteLibelle('LAB_001');
    LabLib.Caption            := GetTexteLibelle('LAB_002');
    LabPrix.Caption           := GetTexteLibelle('LAB_054');
    LabDisponibilite.Caption  := GetTexteLibelle('LAB_056');
    LabEncombrement.Caption   := GetTexteLibelle('LAB_055');
    LabType.Caption           := GetTexteLibelle('LAB_018');
    LabEmplacement.Caption    := GetTexteLibelle('LAB_075');
    LabProtection.Caption     := GetTexteLibelle('LAB_076');
    LabBonus.Caption          := GetTexteLibelle('LAB_034');
    LabLivre.Caption          := GetTexteLibelle('LAB_128');
    LabQuickArmor.Caption     := GetTexteLibelle('LAB_149');

    TabArmor.Row := 1;
    TabArmorSelection(TabArmor, 1, 1);

    KeyPreview := true;
  end;

procedure TWinArmors.ButtonFiltreClick(Sender: TObject);
begin
    SelectWinLivre      := FiltreLivre;
    WinFiltreAppelant   := ConstXmlArme;
    FenFiltre           := TWinFiltre.Create(Application);
    FenFiltre.Position  := poOwnerFormCenter;
    FenFiltre.ShowModal;
    if (ChoixWinLivre <> FiltreLivre) then
     Begin
       FiltreLivre := ChoixWinLivre;
       WinVider();
       WinCharger();
     end;
end;

procedure TWinArmors.CheckBoxSimplifiedClick(Sender: TObject);
begin
  WinVider();
  WinCharger();
end;

procedure TWinArmors.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinArmors.TabArmorDblClick(Sender: TObject);
begin
    if SelectWinArmure <> '' then
      begin
        ChoixWinArmure := TabArmor.Cells[1,TabArmor.Row];
        close;
      end;
end;

procedure TWinArmors.TabArmorSelection(Sender: TObject; aCol, aRow: Integer);
var
  ListeBonus:   String;
  NbBonus:      Integer;
  Ind:          Integer;
  I,J:          Integer;
  PArmureBonus: StructureArmureBonus;
  Bonus:        String;
  CheminImage1: String;
  CheminImage2: String;
  CheminImage3: String;
begin
    // renseigner les données
    AffCode.Text             := TabArmor.Cells[ 1,aRow];
    AffType.Text             := TabArmor.Cells[ 2,aRow];
    AffLib.Text              := TabArmor.Cells[ 3,aRow];
    AffEmplacement.Text      := TabArmor.Cells[ 4,aRow];
    AffPrix.Text             := TabArmor.Cells[ 5,aRow];
    AffEncombrement.Text     := TabArmor.Cells[ 6,aRow];
    AffDisponbilite.Text     := TabArmor.Cells[ 7,aRow];
    AffProtection.Text       := TabArmor.Cells[ 8,aRow];
    ListeBonus               := TabArmor.Cells[ 9,aRow];
    AffLivre.Text            := TabArmor.Cells[10,aRow];

    if (ListeBonus <> '') and (ListeBonus <> '-') then
      NbBonus                := CountOccurrences(ListeBonus,',')+1
    else
      NbBonus                := 0;

    For I := 1 to TabBonus.ColCount -1 do
      for J := 1 to TabBonus.RowCount -1 do
        TabBonus.Cells[I, J] := '';

    For ind := 0 to NbBonus - 1 do
      begin
        Bonus := ExtractChaine(',', ListeBonus, Ind+1);
        PArmureBonus := ChercheArmureBonus(Bonus);
        TabBonus.Cells[1, Ind+1] := PArmureBonus.Libelle;
        TabBonus.Cells[2, Ind+1] := PArmureBonus.Description;
        TabBonus.Cells[3, Ind+1] := PArmureBonus.Malus;
      end;

    if AffEncombrement.Text = '0' then
      begin
        LabEncombrement.Visible:= false;
        AffEncombrement.Visible:= false;
      end
    else
      begin
        LabEncombrement.Visible:= true;
        AffEncombrement.Visible:= true;
      end;

    if NbBonus = 0 then
      begin
        LabBonus.Visible       := false;
        TabBonus.Visible       := false;
      end
    else
      begin
        LabBonus.Visible      := true;
        TabBonus.Visible      := true;
      end;

    CheminImage1       := CheminArmureImage('1');
    CheminImage2       := CheminArmureImage('2');
    CheminImage3       := CheminArmureImage('3');
    if FileExists(CheminImage1) then
       Image1.Picture.LoadFromFile(CheminImage1)
    else
       Image1.Picture := nil;
    if FileExists(CheminImage2) then
       Image2.Picture.LoadFromFile(CheminImage2)
    else
       Image2.Picture := nil;
    if FileExists(CheminImage3) then
       Image3.Picture.LoadFromFile(CheminImage3)
    else
       Image3.Picture := nil;

    AffDescription.text := '';
    AffDescription.visible := false;
    AdjustGridColumnsWidth(TabBonus, self.Height, false, false);

end;

procedure TWinArmors.TabBonusSelection(Sender: TObject; aCol, aRow: Integer);
begin
  AffDescription.Text := TabBonus.Cells[2, TabBonus.Row];
  if AffDescription.Text <> '' then
    AffDescription.visible := true
  else
    AffDescription.visible := false;
end;

Procedure TWinArmors.WinVider();
  begin
      TabArmor.Clear;
      TabArmor.RowCount:= 1;
      AffDescription.Clear;
  end;


end.

