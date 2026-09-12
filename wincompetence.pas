unit WinCompetence;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, StdCtrls, ExtCtrls, BCButton, ChargeCompetence, ChargeConstantes,
  GlobalFonts, ChargeTexte, UnitCalcul, LCLType, ChargeMetierCompetence,
  ChargeMetier, WinMetier, WinFiltre;

type

  { TWinCompetence }

  TWinCompetence = class(TForm)
    AffCode: TEdit;
    AffAttribut: TEdit;
    AffLib: TEdit;
    AffLivre: TEdit;
    AffSpecialisation: TEdit;
    ButtonFiltre: TBCButton;
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
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure FormClose({%H-}Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabCompetenceAfterSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabCompetenceDblClick({%H-}Sender: TObject);
    procedure TabMetierCompetenceDblClick({%H-}Sender: TObject);
    procedure TabSpeDblClick({%H-}Sender: TObject);
    procedure WinCharger();
    Procedure WinVider();

  private

  public

  end;

  var
    FenMetier:    TWinMetiers;
    FiltreLivre:  String;
    FenFiltre:    TWinFiltre;


implementation

{$R *.lfm}

{ TWinCompetence }

procedure TWinCompetence.FormCreate(Sender: TObject);
begin
    FiltreLivre := SelectWinLivre;
    WinCharger();
end;

procedure TWinCompetence.WinCharger();
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
    if TabCompetence.ColCount < 2 then
      begin
        TabCompetence.ColCount     := 1;
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_001'));
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_002'), 265);
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_002'));
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_003'));
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_078'));
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_128'), 130);
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_001'), 130);
        GridAjouteColonne(TabCompetence, GetTexteLibelle('RULES-LAB_001'));
      end;
    TabCompetence.ColWidths[0] := 20;

    if TabMetierCompetence.ColCount < 2 then
      begin
        TabMetierCompetence.ColCount        := 1;
        GridAjouteColonne(TabMetierCompetence, GetTexteLibelle('RULES-LAB_001'), 0);
        GridAjouteColonne(TabMetierCompetence, GetTexteLibelle('RULES-LAB_006'), 250);
        GridAjouteColonne(TabMetierCompetence, GetTexteLibelle('RULES-LAB_019'), 70);
      end;
    TabMetierCompetence.RowCount        := 2;
    TabMetierCompetence.ColWidths[0]    := 20;

    if TabSpe.ColCount < 2 then
      begin
        TabSpe.ColCount        := 1;
        GridAjouteColonne(TabSpe, GetTexteLibelle('RULES-LAB_001'), 0);
        GridAjouteColonne(TabSpe, GetTexteLibelle('RULES-LAB_006'), 70);
      end;
    TabSpe.RowCount        := 2;
    TabSpe.ColWidths[0]    := 20;

    if Pos(ValeurSousCompetence, SelectWinCompetence) > 0 then
      begin
        // Lien explicite (CONTEXT.md 2.67) prioritaire sur la deduction par radical, qui
        // gardait le prefixe de livre de SelectWinCompetence au lieu de celui de la
        // generique - seul repli quand <Generique> n'est pas renseigne.
        PCompetence := ChercheCompetence(SelectWinCompetence);
        if PCompetence.CodeGenerique <> '' then
          SelectWinCompetence := PCompetence.CodeGenerique
        else
          SelectWinCompetence := ExtractStringBefore(SelectWinCompetence, ValeurSousCompetence) + ValeurGenerique;
      end;

    For PCompetence in ListCompetence do
      begin
        if (SelectWinCompetence <> '') and (PCompetence.CodeCompetence <> SelectWinCompetence) then
          Accord := False
        else
          Accord := True;
        if Accord and (PCompetence.SousCompetence = false) and VerifieFiltre(PCompetence.Livre, FiltreLivre) then
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

    Self.Caption                := GetTexteLibelle('RULES-LAB_009');
    Labcode.Caption             := GetTexteLibelle('RULES-LAB_001');
    LabLib.Caption              := GetTexteLibelle('RULES-LAB_002');
    LabAttribut.Caption         := GetTexteLibelle('RULES-LAB_008');
    LabSpecialisation.caption   := GetTexteLibelle('RULES-LAB_078');
    LabDescription.caption      := GetTexteLibelle('RULES-LAB_003');
    LabMetierCompetence.caption := GetTexteLibelle('RULES-LAB_006');
    LabLivre.caption            := GetTexteLibelle('RULES-LAB_128');
    LabSpe.caption              := GetTexteLibelle('RULES-LAB_078');
    ButtonFiltre.Caption        := GetTexteLibelle('RULES-LAB_133');

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

Procedure TWinCompetence.WinVider();
  begin
      TabCompetence.Clear;
      TabCompetence.RowCount:= 1;
      AffDescription.Clear;
  end;

procedure TWinCompetence.ButtonFiltreClick(Sender: TObject);
  begin
    SelectWinLivre      := FiltreLivre;
    WinFiltreAppelant   := ConstXmlCompetence;
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
      // Radicaux compares SANS le prefixe de livre : une carriere d'un livre peut citer une
      // competence generique d'un autre (meme piege que winspecialisation.pas AjouteLigne).
      if ExtractStringBefore(CodeSansLivre(PMetierCompetence.CodeCompetence),'_') = extractStringBefore(CodeSansLivre(AffCode.Text),'_') then
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
          // Meme radical SANS le livre : une specialisation (ex. LUSTR-COMPPROJ_SARBAC) peut
          // venir d'un livre different de sa competence generique (ex. RULES-COMPPROJ_*).
          if (PCompetence.CodeCompetence <> AffCode.Text) and (ExtractStringBefore(CodeSansLivre(PCompetence.CodeCompetence),ValeurSousCompetence) = ExtractStringBefore(CodeSansLivre(AffCode.Text),ValeurSousCompetence)) then
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
        showmessage(GetTexteLibelle('RULES-MESS_034'))
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

