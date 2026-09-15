unit WinChoixCompetenceAppartenance;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Grids, Dialogs, BCButton,
  GlobalFonts, ChargeConstantes, ChargeTexte, ChargeRaceCompetence, ChargeCompetence,
  UnitCalcul, Graphics;

type

  { TWinChoixCompetenceAppartenance }

  TWinChoixCompetenceAppartenance = class(TForm)
    ButtonAnnuler:      TBCButton;
    ButtonValider:      TBCButton;
    LabelInfo:          TLabel;
    TabChoixCompetence: TStringGrid;
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ButtonValiderClick({%H-}Sender: TObject);
    procedure ButtonAnnulerClick({%H-}Sender: TObject);
    procedure TabChoixCompetenceMouseDown({%H-}Sender: TObject; Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);
    procedure TabChoixCompetenceDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
  public
  end;

var
  // Etat coche/decoche, une entree par ligne de TabChoixCompetence (index = numero de
  // ligne, 0 inutilise). Meme principe que CompetenceRaceStates (wincreation.pas), mais
  // un seul tableau puisqu'une seule colonne de coche ici (pas de 3x5pts/3x3pts).
  EtatChoixCompetence: array of Boolean;

const
  ColChoixCode:  Integer = 1;
  ColChoixLib:   Integer = 2;
  ColChoixCoche: Integer = 3;

implementation

{$R *.lfm}

procedure TWinChoixCompetenceAppartenance.FormCreate(Sender: TObject);
  var
    PRaceCompetence: StructureRaceCompetence;
    PCompetence:      StructureCompetence;
    NbLig:            Integer;
    Ind:              Integer;
  begin
    MiseEnFormeDesChamp(self);

    TabChoixCompetence.RowCount                := 1;
    TabChoixCompetence.ColCount                := 4;
    TabChoixCompetence.ColWidths[0]             := 20;
    TabChoixCompetence.Cells[ColChoixCode, 0]   := GetTexteLibelle('RULES-LAB_002');
    TabChoixCompetence.ColWidths[ColChoixCode]  := 0;
    TabChoixCompetence.Cells[ColChoixLib, 0]    := GetTexteLibelle('RULES-LAB_003');
    TabChoixCompetence.ColWidths[ColChoixLib]   := 300;
    TabChoixCompetence.Cells[ColChoixCoche, 0]  := '';
    TabChoixCompetence.ColWidths[ColChoixCoche] := 30;

    // Le pool est l'ethnie DU PERSONNAGE (ChoixCompetenceAppartenanceRace, positionne par
    // l'appelant avant ShowModal) - meme source que TabRaceCompetence en creation
    // (wincreation.pas), pas une liste portee par le CareerBonus. CONTEXT.md.
    NbLig := 0;
    for PRaceCompetence in ListRaceCompetence do
      if CompareRechercheValeur(PRaceCompetence.CodeRace, ChoixCompetenceAppartenanceRace) then
        begin
          Inc(NbLig);
          TabChoixCompetence.RowCount := NbLig + 1;
          PCompetence                 := ChercheCompetence(PRaceCompetence.CodeCompetence);
          TabChoixCompetence.Cells[ColChoixCode, NbLig] := PRaceCompetence.CodeCompetence;
          TabChoixCompetence.Cells[ColChoixLib,  NbLig] := PCompetence.Libelle;
        end;

    SetLength(EtatChoixCompetence, TabChoixCompetence.RowCount);
    for Ind := 0 to High(EtatChoixCompetence) do
      EtatChoixCompetence[Ind] := false;

    LabelInfo.Caption    := Format(GetTexteLibelle('RULES-LAB_187'),
                                   [ChoixCompetenceAppartenanceCount, 0]);
    ButtonValider.Enabled := (ChoixCompetenceAppartenanceCount = 0);
    SelectCompetenceAppartenance := '';
  end;

procedure TWinChoixCompetenceAppartenance.TabChoixCompetenceDrawCell(Sender: TObject;
  aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
  var
    CheckChar: String;
  begin
    if (aCol = ColChoixCoche) and (aRow > 0) then
      begin
        if EtatChoixCompetence[aRow] then
          CheckChar := CheckCharChecked
        else
          CheckChar := CheckCharUnchecked;
        TabChoixCompetence.Canvas.TextRect(aRect, aRect.Left + 2, aRect.Top + 2, CheckChar);
      end
    else
      TabChoixCompetence.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;

procedure TWinChoixCompetenceAppartenance.TabChoixCompetenceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var
    ACol, ARow: Integer;
    NbCoche:    Integer;
    Ind:        Integer;
  begin
    TabChoixCompetence.MouseToCell(X, Y, ACol, ARow);
    if (ARow > 0) and (ACol = ColChoixCoche) then
      begin
        NbCoche := 0;
        for Ind := 1 to TabChoixCompetence.RowCount - 1 do
          if EtatChoixCompetence[Ind] then
            Inc(NbCoche);

        // Refuse de cocher une case de plus une fois le plafond atteint - decocher reste
        // toujours possible. Meme principe que ClickRaceCompetence (wincreation.pas), sans
        // les deux colonnes croisees (5pts/3pts) qui n'existent pas ici.
        if EtatChoixCompetence[ARow] or (NbCoche < ChoixCompetenceAppartenanceCount) then
          begin
            EtatChoixCompetence[ARow] := not EtatChoixCompetence[ARow];
            TabChoixCompetence.InvalidateCell(ACol, ARow);
            if EtatChoixCompetence[ARow] then
              Inc(NbCoche)
            else
              Dec(NbCoche);
            LabelInfo.Caption     := Format(GetTexteLibelle('RULES-LAB_187'),
                                            [ChoixCompetenceAppartenanceCount, NbCoche]);
            ButtonValider.Enabled := (NbCoche = ChoixCompetenceAppartenanceCount);
          end;
      end;
  end;

procedure TWinChoixCompetenceAppartenance.ButtonValiderClick(Sender: TObject);
  var
    Ind: Integer;
  begin
    SelectCompetenceAppartenance := '';
    for Ind := 1 to TabChoixCompetence.RowCount - 1 do
      if EtatChoixCompetence[Ind] then
        begin
          if SelectCompetenceAppartenance <> '' then
            SelectCompetenceAppartenance := SelectCompetenceAppartenance + ',';
          SelectCompetenceAppartenance := SelectCompetenceAppartenance +
                                           TabChoixCompetence.Cells[ColChoixCode, Ind];
        end;
    Close;
  end;

procedure TWinChoixCompetenceAppartenance.ButtonAnnulerClick(Sender: TObject);
  begin
    SelectCompetenceAppartenance := '';
    Close;
  end;

procedure TWinChoixCompetenceAppartenance.FormPaint(Sender: TObject);
  begin
    Canvas.Pen.Color   := ClWhite;
    Canvas.Pen.Width   := 3;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(2, 2, ClientWidth - 2, ClientHeight - 2);
  end;

end.
