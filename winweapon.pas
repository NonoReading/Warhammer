unit WinWeapon;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, BCButton, ChargeArme, GlobalFonts, ChargeConstantes,
  ChargeCompetence, UnitCalcul, ChargeArmeBonus, ChargeTexte, WinFiltre;

type

  { TWinWeapons }

  TWinWeapons = class(TForm)
    AffCode: TEdit;
    AffDegat: TEdit;
    AffDescription: TMemo;
    AffLivre: TEdit;
    AffMunition: TEdit;
    AffPortee: TEdit;
    AffMain: TEdit;
    AffCompetence: TEdit;
    AffLib: TEdit;
    AffDisponbilite: TEdit;
    AffPrix: TEdit;
    AffEncombrement: TEdit;
    ButtonFiltre: TBCButton;
    Image2: TImage;
    Image1: TImage;
    ImageWar: TImage;
    LabCode: TLabel;
    LabDegat: TLabel;
    LabBonus: TLabel;
    LabLivre: TLabel;
    LabMunition: TLabel;
    LabPortee: TLabel;
    LabDisponibilite: TLabel;
    LabPrix: TLabel;
    LabMain: TLabel;
    LabCompetence: TLabel;
    LabLib: TLabel;
    LabEncombrement: TLabel;
    TabBonus: TStringGrid;
    TabWeapon: TStringGrid;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabBonusSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabWeaponAfterSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabWeaponDblClick({%H-}Sender: TObject);
    procedure WinCharger();
    Procedure WinVider();
  private

  public

  end;

var
  WinWeapons:     TWinWeapons;
  FiltreLivre:    String;
  FenFiltre:      TWinFiltre;

implementation

{$R *.lfm}

{ TWinWeapons }

procedure TWinWeapons.WinCharger();
var
  PArme:        StructureArme;
  Code:         String;
  Code1:        String;
  Code2:        String;
  PCompetence:  StructureCompetence;
  IndTab:       integer;
begin
      // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    TabWeapon.RowCount      := 1;
    // on met toutes les données dans la table pour les afficher directement dans les champs
    if TabWeapon.ColCount < 2 then
      begin
        TabWeapon.ColCount      := 1;
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_001'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_018'),120);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_009'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_002'),200);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_053'),100);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_054'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_055'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_056'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_057'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_058'),100);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_059'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_060'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_128'),100);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_001'),180);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_009'),100);
      end;
    TabWeapon.ColWidths[0]  := 20;

        // on met toutes les données dans la table pour les afficher directement dans les champs
    TabBonus.RowCount      := 7;
    If TabBonus.ColCount < 2 then
      begin
        TabBonus.ColCount      := 1;
        TabBonus.ColWidths[0]  := 20;
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_002'),100);
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_072'));
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_073'),380);
      end;

    IndTab := 0;
    For Parme In ListArme do
      begin
        if (Pos(ValeurGenerique,PArme.CodeArme) = 0) and VerifieFiltre(PArme.Livre, FiltreLivre) then
          begin
            Inc(IndTab);
            if TabWeapon.RowCount <= IndTab then
              TabWeapon.RowCount := TabWeapon.RowCount + 1;

            TabWeapon.Cells[1, IndTab]   := PArme.CodeArme;
            // Le code porte son prefixe de livre (RULES-COMB_BASE_10) : tester les cinq
            // premiers caracteres du code COMPLET donnait "RULES", donc AUCUNE arme ne
            // matchait et toutes prenaient le libelle du else. Meme moule que
            // GetTypeMetierEquipement (unitcalcul.pas l.218) : decouper d'abord.
            DecoupeCodeValeur(PArme.CodeArme);
            if copy(CodeValeur,1,5) = EquipementMU then
              TabWeapon.Cells[2, IndTab] := GetTexteLibelle('RULES-LAB_060')
            else if copy(CodeValeur,1,5) = EquipementCC then
              TabWeapon.Cells[2, IndTab] := GetTexteLibelle('RULES-LAB_061')
            else
              TabWeapon.Cells[2, IndTab] := GetTexteLibelle('RULES-LAB_062');
            TabWeapon.Cells[3, IndTab]   := PArme.CodeCompetence;
            TabWeapon.Cells[4, IndTab]   := PArme.Libelle;
            TabWeapon.Cells[5, IndTab]   := IntToStr(PArme.Mains);
            TabWeapon.Cells[6, IndTab]   := PArme.Prix;
            TabWeapon.Cells[7, IndTab]   := IntToStr(PArme.Encombrement);
            TabWeapon.Cells[8, IndTab]   := GetAllTexteLibelle(PArme.Disponibilite);
            TabWeapon.Cells[9, IndTab]   := ReplaceTexteLibelle(PArme.Portee);
            TabWeapon.Cells[10,IndTab]   := ReplaceTexteLibelle(PArme.CalculDegat);
            TabWeapon.Cells[11,IndTab]   := PArme.ListeBonus;
            TabWeapon.Cells[12,IndTab]   := IntToStr(PArme.Munition);
            TabWeapon.Cells[13,IndTab]   := GetTexteLibelle(PArme.Livre,'','',true);
            TabWeapon.Cells[14,IndTab]   := PArme.CodeArme;
            Code := PArme.CodeCompetence;
            if CountOccurrences(Code,SeparateurMulti) = 1 then
              begin
                Code1                := ExtractChaine(SeparateurMulti, Code, 1);
                PCompetence          := ChercheCompetence(Code1);
                TabWeapon.Cells[15,IndTab]   := PCompetence.Libelle;
                Code2                := ExtractChaine(SeparateurMulti, Code, 2);
                PCompetence          := ChercheCompetence(Code2);
                TabWeapon.Cells[15,IndTab]   := TabWeapon.Cells[15,IndTab]+' / '+PCompetence.Libelle;
              end
            else
              begin
                PCompetence          := ChercheCompetence(Code);
                TabWeapon.Cells[15,IndTab]   := PCompetence.Libelle;
              end;
         end
    end;
    //Sort
    TabWeapon.SortColRow(true,2);
    AdjustGridColumnsWidth(TabWeapon, self.Height, false, true);
    AdjustGridColumnsWidth(TabBonus, self.Height, false, false);

    if FileExists(GetCurrentDir+ConstCheminLogo1) then
      ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption              := GetTexteLibelle('RULES-LAB_063');
    Labcode.Caption           := GetTexteLibelle('RULES-LAB_001');
    LabMain.Caption           := GetTexteLibelle('RULES-LAB_053');
    LabPrix.Caption           := GetTexteLibelle('RULES-LAB_054');
    LabEncombrement.Caption   := GetTexteLibelle('RULES-LAB_055');
    LabMunition.Caption       := GetTexteLibelle('RULES-LAB_112');
    LabLib.Caption            := GetTexteLibelle('RULES-LAB_002');
    LabCompetence.Caption     := GetTexteLibelle('RULES-LAB_009');
    LabPortee.Caption         := GetTexteLibelle('RULES-LAB_057');
    LabDisponibilite.Caption  := GetTexteLibelle('RULES-LAB_056');
    LabDegat.Caption          := GetTexteLibelle('RULES-LAB_058');
    LabBonus.Caption          := GetTexteLibelle('RULES-LAB_034');
    LabLivre.Caption          := GetTexteLibelle('RULES-LAB_128');
    ButtonFiltre.Caption      := GetTexteLibelle('RULES-LAB_133');
    TabWeapon.Row := 1;
    TabWeaponAfterSelection(TabWeapon, 1, 1);

    KeyPreview := true;
end;

procedure TWinWeapons.FormCreate(Sender: TObject);
begin
    FiltreLivre := SelectWinLivre;
    WinCharger()
end;

procedure TWinWeapons.ButtonFiltreClick(Sender: TObject);
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

procedure TWinWeapons.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinWeapons.TabBonusSelection(Sender: TObject; aCol, aRow: Integer);
begin
    AffDescription.Text := TabBonus.Cells[2, aRow];
    if AffDescription.Text = '' then
      AffDescription.Visible := false
    else
      AffDescription.Visible := true;
end;

procedure TWinWeapons.TabWeaponAfterSelection(Sender: TObject; aCol,
  aRow: Integer);
var
  ListeBonus:   String;
  NbBonus:      Integer;
  Ind:          Integer;
  I,J:          Integer;
  PArmeBonus:   StructureArmeBonus;
  Bonus:        String;
  CheminImage1: String;
  CheminImage2: String;
begin
    // renseigner les données
    AffCode.Text             := TabWeapon.Cells[ 1,aRow];
    AffCompetence.Text       := TabWeapon.Cells[15,aRow];
    AffLib.Text              := TabWeapon.Cells[ 4,aRow];
    AffMain.Text             := TabWeapon.Cells[ 5,aRow];
    AffPrix.Text             := TabWeapon.Cells[ 6,aRow];
    AffEncombrement.Text     := TabWeapon.Cells[ 7,aRow];
    AffDisponbilite.Text     := TabWeapon.Cells[ 8,aRow];
    AffPortee.Text           := TabWeapon.Cells[ 9,aRow];
    AffDegat.Text            := TabWeapon.Cells[10,aRow];
    ListeBonus               := TabWeapon.Cells[11,aRow];
    AffMunition.Text         := TabWeapon.Cells[12,aRow];
    AffLivre.Text            := TabWeapon.Cells[13,aRow];

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
        if (copy(Bonus,length(Bonus)-1,1) = ' ') then
          if (copy(Bonus,length(Bonus),1) >= '1') then
            if (copy(Bonus,length(Bonus),1) <= '9') then
              Bonus := copy(Bonus,1,length(Bonus)-2);
        PArmeBonus := ChercheArmeBonus(Bonus);
        TabBonus.Cells[1, Ind+1] := PArmeBonus.Libelle;
        TabBonus.Cells[2, Ind+1] := PArmeBonus.Description;
        TabBonus.Cells[3, Ind+1] := PArmeBonus.Resume;
      end;
    AffDescription.Text := '';


    if AffMain.Text = '0' then
      begin
        LabMain.Visible:= false;
        AffMain.Visible:= false;
      end
    else
      begin
        LabMain.Visible:= true;
        AffMain.Visible:= true;
      end;

    if AffMunition.Text = '0' then
      begin
        LabMunition.Visible:= false;
        AffMunition.Visible:= false;
      end
    else
      begin
        LabMunition.Visible:= true;
        AffMunition.Visible:= true;
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

    CheminImage1       := CheminArmeImage(TabWeapon.Cells[3,aRow],'2');
    CheminImage2       := CheminArmeImage(TabWeapon.Cells[3,aRow],'1');
    if FileExists(CheminImage1) then
       Image1.Picture.LoadFromFile(CheminImage1)
    else
       Image1.Picture := nil;
    if FileExists(CheminImage2) then
       Image2.Picture.LoadFromFile(CheminImage2)
    else
       Image2.Picture := nil;
    Image1.BringToFront;

    AffDescription.Visible := false;
    AdjustGridColumnsWidth(TabBonus, self.Height, false, false);

end;

Procedure TWinWeapons.WinVider();
  begin
      TabWeapon.Clear;
      TabWeapon.RowCount:= 1;
      AffDescription.Clear;
  end;


procedure TWinWeapons.TabWeaponDblClick(Sender: TObject);
begin
  if SelectWinArme <> '' then
    begin
      ChoixWinArme := TabWeapon.Cells[1,TabWeapon.Row];
      close;
    end;
end;

end.

