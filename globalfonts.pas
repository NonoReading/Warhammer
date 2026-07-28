unit GlobalFonts;

// gérer les polices et les couleurs par défaut des champs

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Controls, StdCtrls, Forms, Grids, LazUtils, ComCtrls, fpttf,
  ChargeConstantes, Graphics, ExtCtrls, SysUtils, Buttons,
  Dialogs, LMessages,LclIntf, Types, BGRAControls, BGRABitmap, BGRABitmapTypes,
  BCButton, BCButtonFocus, BCTypes, BCLabel;


type
 TButton = Class(StdCtrls.Tbutton)
   Procedure WndProc(Var Msg:TLMessage);override;
 end;


procedure StylesTStringGrid(Table: TStringGrid);
procedure MiseAJourUnContenaire(AContainer: TWinControl);
procedure MiseEnFormeDesChamp(Win: TForm);
procedure TabGenericDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; {%H-}aState: TGridDrawState);

implementation

procedure StylesTStringGrid(Table: TStringGrid);
  begin
    Table.Font.Name        := ConstPoliceNom;
    Table.Color            := CouleurDefColor;
    if Table.Font.Size < ConstPoliceTaille then
      Table.Font.Size      := ConstPoliceTaille;
    Table.Font.Bold        := True;
    Table.Font.Color       := clBlack;
    Table.FixedColor       := clBlack;
    Table.GridLineColor    := clSilver;
    Table.TitleFont.Color  := clWhite;
  end;

procedure MiseAJourUnContenaire(AContainer: TWinControl);
var
  Shape:     TShape;
  I, J:      Integer;
begin
  // Mise à jour des différents types de champ pour homogénéiser le tout
  // Changer la couleur de la barre de titre en noir

  for I := 0 to AContainer.ComponentCount - 1 do
  begin
    if (AContainer.Components[I] is TTabSheet) then
      begin
          Shape                  := tshape.Create(AContainer);
          Shape.Parent           := TTabSheet(AContainer.Components[I]);
          Shape.Align            := alClient;
          Shape.Font.Name        := ConstPoliceNom;
          Shape.Font.Size        := ConstPoliceTaille;
          Shape.Brush.Color      := CouleurDefInverse;
          For J := 0 to TTabSheet(AContainer.Components[I]).ControlCount  - 1 do
            begin
              if TTabSheet(AContainer.Components[I]).Controls[J] is TLabel then
                 begin
                   TLabel(TTabSheet(AContainer.Components[I]).Controls[J]).ParentColor := False;
                   TLabel(TTabSheet(AContainer.Components[I]).Controls[J]).Color       := ClREd;
                   TLabel(TTabSheet(AContainer.Components[I]).Controls[J]).Font.Color  := ClGray;
                 end;
            end;
      end

    // Champs de saisie
    else if (AContainer.Components[I] is TComboBox)
       or (AContainer.Components[I] is TTreeView) then
        begin
          TControl(AContainer.Components[I]).Font.Name := ConstPoliceNom;
          TControl(AContainer.Components[I]).Color     := CouleurDefColor;
          if TControl(AContainer.Components[I]).Font.Size < ConstPoliceTaille then
             TControl(AContainer.Components[I]).Font.Size := ConstPoliceTaille;
        end

    else if (AContainer.Components[I] is TMemo) then
        begin
          TMemo(AContainer.Components[I]).Font.Name := ConstPoliceNom;
          if TMemo(AContainer.Components[I]).ReadOnly = true then
            begin
              TMemo(AContainer.Components[I]).Color     := CouleurDefColor;
              TMemo(AContainer.Components[I]).Font.Color:= CouleurDefInverse;
            end
          else
            TMemo(AContainer.Components[I]).Color     := ClWhite;
          if TMemo(AContainer.Components[I]).Font.Size < ConstPoliceTaille then
             TMemo(AContainer.Components[I]).Font.Size := ConstPoliceTaille;
        end

    // Champs de saisie
    else if (AContainer.Components[I] is TEdit) then
        begin
          TEdit(AContainer.Components[I]).Font.Name := ConstPoliceNom;
          if TEdit(AContainer.Components[I]).ReadOnly = true then
            begin
              TEdit(AContainer.Components[I]).Color     := CouleurDefColor;
              TEdit(AContainer.Components[I]).Font.Color:= CouleurDefInverse;
            end
          else
            TEdit(AContainer.Components[I]).Color     := CouleurDefColor;
          if TEdit(AContainer.Components[I]).Font.Size < ConstPoliceTaille then
             TEdit(AContainer.Components[I]).Font.Size := ConstPoliceTaille;
        end

    // Tableaux
    else if (AContainer.Components[I] is TStringGrid) then
        StylesTStringGrid(TStringGrid(AContainer.Components[I]))

    // Libellés
    else if (AContainer.Components[I] is TLabel) then
     begin
         TControl(AContainer.Components[I]).Font.Name := ConstPoliceNom;
         if TControl(AContainer.Components[I]).Font.Size < ConstPoliceTaille then
            TControl(AContainer.Components[I]).Font.Size := ConstPoliceTaille;
         TControl(AContainer.Components[I]).Font.Bold:= True;
         TControl(AContainer.Components[I]).Font.color:= clRed;
     end

    // Libellés
    else if (AContainer.Components[I] is TBCLabel) then
     begin
         TBCLabel(AContainer.Components[I]).FontEx.Name         := ConstPoliceNom;
         TBCLabel(AContainer.Components[I]).FontEx.Height       := 30;
         TBCLabel(AContainer.Components[I]).FontEx.Style        := [fsbold];
         TBCLabel(AContainer.Components[I]).FontEx.color        := ClYellow;
         TBCLabel(AContainer.Components[I]).FontEx.Shadow       := True;
         TBCLabel(AContainer.Components[I]).FontEx.ShadowColor  := ClRed;
         TBCLabel(AContainer.Components[I]).FontEx.ShadowRadius := 5;
         TBCLabel(AContainer.Components[I]).FontEx.ShadowOffsetX:= 2;
         TBCLabel(AContainer.Components[I]).FontEx.ShadowOffsetY:= 2;
         TBCLabel(AContainer.Components[I]).Height:= 40;
     end

    // Radio button
    else if AContainer.Components[I] is TRadioButton then
        begin
          TRadioButton(AContainer.Components[I]).Font.Name := ConstPoliceNom;
          TRadioButton(AContainer.Components[I]).Font.Size := ConstPoliceTaille;
          TRadioButton(AContainer.Components[I]).Font.Bold := True;
          TRadioButton(AContainer.Components[I]).Color     := CouleurDefColor;
        end

    // Boutons
    else if (AContainer.Components[I] is TButton) then
        begin
          TButton(AContainer.Components[I]).Font.Name := ConstPoliceNom;
          if TButton(AContainer.Components[I]).Font.Size < ConstPoliceBtTaille then
             TButton(AContainer.Components[I]).Font.Size := ConstPoliceBtTaille;
          TButton(AContainer.Components[I]).Font.Bold:= True;
          TButton(AContainer.Components[I]).Color     := CouleurDefColor;
        end

    // Boutons
    else if (AContainer.Components[I] is TBCButton) then
        begin
          TBCButton(AContainer.Components[I]).StateNormal.Background.Gradient1.EndColor   := CouleurButton;//ClSilver;
          TBCButton(AContainer.Components[I]).StateNormal.Background.Gradient2.EndColor   := CouleurButton;//ClSilver;
          TBCButton(AContainer.Components[I]).StateNormal.Background.Gradient1.StartColor := CouleurButton;//ClSilver;
          TBCButton(AContainer.Components[I]).StateNormal.Background.Gradient2.StartColor := CouleurButton;//ClSilver;
          TBCButton(AContainer.Components[I]).StateNormal.FontEx.ShadowColor              := ClRed;
          TBCButton(AContainer.Components[I]).StateNormal.FontEx.ShadowRadius             := 5;
          TBCButton(AContainer.Components[I]).StateNormal.FontEx.Color                    := ClYellow;
          TBCButton(AContainer.Components[I]).StateNormal.FontEx.Height                   := ConstPoliceBtTaille;
          TBCButton(AContainer.Components[I]).StateNormal.FontEx.Style                    := [fsBold];
          TBCButton(AContainer.Components[I]).StateNormal.FontEx.Name                     := ConstPoliceNom;
          TBCButton(AContainer.Components[I]).StateNormal.Border.Style                    := bboSolid;
          TBCButton(AContainer.Components[I]).StateNormal.Border.Width                    := 2;
          TBCButton(AContainer.Components[I]).StateNormal.Border.Color                    := ClRed;

          TBCButton(AContainer.Components[I]).StateHover.Background.Gradient1.EndColor    := ClBlack;
          TBCButton(AContainer.Components[I]).StateHover.Background.Gradient2.EndColor    := ClBlack;
          TBCButton(AContainer.Components[I]).StateHover.Background.Gradient1.StartColor  := ClBlack;
          TBCButton(AContainer.Components[I]).StateHover.Background.Gradient2.StartColor  := ClBlack;
          TBCButton(AContainer.Components[I]).StateHover.FontEx.Color                     := ClRed;
          TBCButton(AContainer.Components[I]).StateHover.FontEx.Height                    := ConstPoliceBtTaille;
          TBCButton(AContainer.Components[I]).StateClicked.FontEx.Style                   := [fsbold];
          TBCButton(AContainer.Components[I]).StateHover.FontEx.Name                      := ConstPoliceNom;

          TBCButton(AContainer.Components[I]).StateClicked.Background.Gradient1.EndColor  := ClBlack;
          TBCButton(AContainer.Components[I]).StateClicked.Background.Gradient2.EndColor  := ClBlack;
          TBCButton(AContainer.Components[I]).StateClicked.Background.Gradient1.StartColor:= ClBlack;
          TBCButton(AContainer.Components[I]).StateClicked.Background.Gradient2.StartColor:= ClBlack;
          TBCButton(AContainer.Components[I]).StateClicked.FontEx.Color                   := CouleurButton;
          TBCButton(AContainer.Components[I]).StateClicked.FontEx.Height                  := ConstPoliceBtTaille;
          TBCButton(AContainer.Components[I]).StateClicked.FontEx.Style                   := [fsbold];
          TBCButton(AContainer.Components[I]).StateClicked.FontEx.Name                    := ConstPoliceNom;
        end
    else if (AContainer.Components[I] is TBCButtonFocus) then
        begin
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Background.Gradient1.EndColor   := ClSilver;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Background.Gradient2.EndColor   := ClSilver;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Background.Gradient1.StartColor := ClSilver;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Background.Gradient2.StartColor := ClSilver;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.FontEx.ShadowColor              := ClRed;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.FontEx.ShadowRadius             := 5;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.FontEx.Color                    := ClYellow;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.FontEx.Height                   := ConstPoliceBtTaille;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.FontEx.Style                    := [fsBold];
          TBCButtonFocus(AContainer.Components[I]).StateNormal.FontEx.Name                     := ConstPoliceNom;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Border.Style                    := bboSolid;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Border.Width                    := 2;
          TBCButtonFocus(AContainer.Components[I]).StateNormal.Border.Color                    := ClRed;

          TBCButtonFocus(AContainer.Components[I]).StateHover.Background.Gradient1.EndColor    := ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateHover.Background.Gradient2.EndColor    := ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateHover.Background.Gradient1.StartColor  := ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateHover.Background.Gradient2.StartColor  := ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateHover.FontEx.Color                     := ClRed;
          TBCButtonFocus(AContainer.Components[I]).StateHover.FontEx.Height                    := ConstPoliceBtTaille;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.FontEx.Style                   := [fsbold];
          TBCButtonFocus(AContainer.Components[I]).StateHover.FontEx.Name                      := ConstPoliceNom;

          TBCButtonFocus(AContainer.Components[I]).StateClicked.Background.Gradient1.EndColor  := ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.Background.Gradient2.EndColor  := ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.Background.Gradient1.StartColor:= ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.Background.Gradient2.StartColor:= ClBlack;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.FontEx.Color                   := CouleurDefColor;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.FontEx.Height                  := ConstPoliceBtTaille;
          TBCButtonFocus(AContainer.Components[I]).StateClicked.FontEx.Style                   := [fsbold];
          TBCButtonFocus(AContainer.Components[I]).StateClicked.FontEx.Name                    := ConstPoliceNom;

        end;
  end;
end;

Procedure TButton.WndPRoc(Var Msg:TLMessage);
//const GlyphOffset=4;
 var
   C:TControlCanvas;
   R:TREct;
//   TextDimension:Tsize;
//   X,Y,GlyphHeight:integer;
Begin
  Inherited;
  if Msg.Msg = LM_Paint Then
    Begin
      C             := TControlCanvas.Create;
      C.Control     := Self;
      C.Brush.Color := CouleurDefColor;
      R             := ClientRect;
      C.FillRect(R);
      C.Pen.Color   := CouleurDefInverse;
      C.Font.Bold   := true;
      if Self.Font.Size < ConstPoliceTaille then
        C.Font.Size := ConstPoliceTaille
      else
        C.Font.Size := Self.Font.Size;
      InFlateRect(R,-1,-1);
      C.Rectangle(R);
      C.TextOut(3,2,Caption);

      C.Free;
    end;
end;

procedure MiseEnFormeDesChamp(Win: TForm);
var
  I: Integer;
begin
  // Recherche des contenaires de l'unité en cours
  for I := 0 to Screen.FormCount - 1 do
  begin
    // Parcourir tous les formulaires ou composants qui affichent du texte
    if Screen.Forms[I] is TForm then
       if Screen.Forms[I] = Win then
          if Screen.Forms[I].Enabled then
            MiseAJourUnContenaire(Screen.Forms[I]);
  end;
end;

procedure TabGenericDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
Var
  CellText: string;
  TextWidth: Integer;
  TextX: Integer;
  TextY: integer;
  Grid:  TStringGrid;
begin
    Grid := TStringGrid(Sender);
    if (aCol > 0) then
     begin
       if aRow = 0 then
         begin
           // Dessiner le fond de la cellule de l'entête
           Grid.Canvas.Brush.Color := clBlack;
           Grid.Canvas.FillRect(aRect);

           // Dessiner le texte de l'entête centré horizontalement et verticalement
           Grid.Canvas.Font.Color := clWhite;
           Grid.Canvas.Font.Style := [fsBold];
           Grid.Canvas.Font.Size  := ConstPoliceTaille;
           Grid.Canvas.Font.Name  := ConstPoliceNom;

           // Calculer la position x et y du texte pour l'alignement centré
           if aCol > 0 then
           begin
             CellText  := Grid.Cells[aCol, aRow]; //Grid.Columns[aCol-1].Title.Caption; //
             TextWidth := Grid.Canvas.TextWidth(CellText);
             TextX     := aRect.Left + (aRect.Right - aRect.Left - TextWidth) div 2;
             TextY     := aRect.Top + (aRect.Bottom - aRect.Top - Grid.Canvas.TextHeight(CellText)) div 2;

             // Dessiner le texte de l'entête
             Grid.Canvas.TextRect(aRect, TextX, TextY, CellText);
           end;
         end
      end;
  end;


end.
