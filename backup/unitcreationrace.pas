unit UnitCreationRace;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  ComCtrls, StdCtrls, Spin, ChargeConstantes, GlobalFonts, ChargeRace, Types,
  ChargeMetier, ChargeRaceMetier, ChargeAttribut, ChargeRaceAttribut,
  ChargeMetierAttribut;

// Race
procedure ChargeTabRaces();
procedure TabRaceDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; {%H-}aState: TGridDrawState);
procedure TabRacePrepareCanvas(Sender: TObject; {%H-}aCol, aRow: Integer;
  {%H-}aState: TGridDrawState);
procedure UpdateSheetMetier();
procedure AfficheImageRace();
procedure ButtonRaceHasardClick(Sender: TObject);
procedure ButtonRaceValiderClick(Sender: TObject);
procedure RadioButtonRaceHasardClick(Sender: TObject);
procedure RadioButtonRaceClick(Sender: TObject);
procedure TabRaceClick(Sender: TObject);
procedure TabRaceResultat(Resul: Integer);



implementation

Procedure ChargeTabRaces();
Var
  IndRace:     Integer;
  IndTabRace:  Integer;
Begin
  IndTabRace        := 0;
  for IndRace := 0 to NbRace - 1 do
    begin
      New(PRace);
      PRace := ListRace.Items[IndRace];
      Race  := PRace^;

      Inc(IndTabRace);
      WinCreation.TabRace.Cells[1, IndTabRace] := Race.CodeRace;
      TabRace.Cells[2, IndTabRace] := Race.LibelleRace;
      TabRace.Cells[3, IndTabRace] := Race.PourcentRace;
  end;
end;


procedure TabRaceClick(Sender: TObject);
var
  row: Integer;
begin
  row := TabRace.Row;

  if (TabRace.Cells[4, row] = '1') then
    begin
     TabRace.Cells[4, row] := '';
     RaceEnCours           := '';
    end
  else
    begin
      TabRace.Cells[4, row] := '1';
      if LastCheckedRace > 0 then
           TabRace.Cells[4, LastCheckedRace] := '';
      LastCheckedRace       := row;
      RaceEnCours           := TabRace.Cells[1, row];
      RaceLibEnCours        := TabRace.Cells[2, row];
  end;
    AfficheImageRace();
end;

procedure TabRaceDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
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
end;

procedure TabRacePrepareCanvas(Sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
begin
  if (ARow = 0) then
  begin
    TabRace.Canvas.Brush.Color := clBtnFace; // Couleur de fond de l'en-tête désactivé
    TabRace.Canvas.Font.Color := ClBlack; // Couleur du texte de l'en-tête désactivé
  end;
end;


end.

