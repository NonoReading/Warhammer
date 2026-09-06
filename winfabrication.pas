unit WinFabrication;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids,
  BCButton, ChargeTexte, ChargeConstantes, ChargeFabrication, GlobalFonts,
  Unitcalcul;

type

  { TWinFabrications }

  TWinFabrications = class(TForm)
    ButtonOk: TBCButton;
    TabFabrication: TStringGrid;
    procedure ButtonOkClick({%H-}Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure TabFabricationSelectEditor({%H-}Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure TabFabricationValidateEntry({%H-}Sender: TObject; aCol, aRow: Integer;
      const OldValue: string; var NewValue: String);

  private

  public

  end;

var
  WinFabric: TWinFabrications;

implementation

{$R *.lfm}

{ TWinFabrications }

procedure TWinFabrications.FormCreate(Sender: TObject);
  Var
    I,J:          Integer;
    PFabrication: StructureFabrication;
    IndTab:       Integer               = 0;
    strings:      TStringList;
    Code:         String;
    Qte:          String;
  begin
     MiseEnFormeDesChamp(self);
       // Mise en forme dy tableau de choix des Compétences de race
     TabFabrication.Options          := TabFabrication.Options + [goEditing, goAlwaysShowEditor];
     TabFabrication.ColCount         := 7;
     TabFabrication.RowCount         := NbFabrication + 1;
     TabFabrication.ColWidths[0]     := 30;
     TabFabrication.Cells[1, 0]      := GetTexteLibelle('RULES-LAB_001');
     TabFabrication.ColWidths[1]     := 0;
     TabFabrication.Cells[2, 0]      := GetTexteLibelle('RULES-LAB_019');
     TabFabrication.ColWidths[2]     := 125;
     TabFabrication.Cells[3, 0]      := GetTexteLibelle('RULES-LAB_045');
     TabFabrication.ColWidths[3]     := 50;
     TabFabrication.Cells[4, 0]      := GetTexteLibelle('RULES-LAB_111');
     TabFabrication.ColWidths[4]     := 50;
     TabFabrication.Cells[5, 0]      := GetTexteLibelle('RULES-LAB_018');
     TabFabrication.ColWidths[5]     := 70;
     TabFabrication.Cells[6, 0]      := GetTexteLibelle('RULES-LAB_073');
     TabFabrication.ColWidths[6]     := 500;

     For PFabrication in ListFabrication do
       begin
         inc(IndTab);
         TabFabrication.Cells[1, IndTab] := PFabrication.CodeFabrication;
         TabFabrication.Cells[2, IndTab] := PFabrication.Libelle;
         TabFabrication.Cells[4, IndTab] := PFabrication.Maximum;
         TabFabrication.Cells[5, IndTab] := PFabrication.TypeQualite;
         TabFabrication.Cells[6, IndTab] := PFabrication.Resume;
       end;

     ButtonOk.Caption := getTexteLibelle('RULES-LAB_106');

     if SelectWinFabrication <> '' then
       begin
         strings            := TStringList.Create;
         ExtractStrings([','], [], PChar(SelectWinFabrication), Strings);
         for I := 0 to Strings.Count -1 do
           Begin
             Code := ExtractStringBefore(Strings[I],' ');
             Qte  := ExtractStringAfter(Strings[I],' ');
             For J := 1 to TabFabrication.RowCount -1 do
               if TabFabrication.Cells[1, J] = Code then
                 TAbFAbrication.Cells[3, J] := Qte;
           end;
         strings.FRee;
       end;

     ChoixWinFabrication := SelectWinFabrication;
     AdjustGridColumnsWidth(TabFabrication, self.Height, false, true);

     KeyPreview := true;
end;

procedure TWinFabrications.ButtonOkClick(Sender: TObject);
  Var
    IndTab:  Integer;
    Res:     String = '';
  begin

    For IndTab := 1 to TabFabrication.RowCount - 1 do
      begin
        if StrToIntDef(TabFabrication.Cells[3, IndTab],0) > 0 then
          Begin
            if Res <> '' then Res := Res + ',';
            Res := Res + TabFabrication.Cells[1, IndTab]+' '+TabFabrication.Cells[3, IndTab];
          end;
      end;
    ChoixWinFabrication := Res;
    Close;
  end;

procedure TWinFabrications.TabFabricationSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
begin
  if (aRow = 0) or (ACol <> 3) then
    Editor := nil;
end;

procedure TWinFabrications.TabFabricationValidateEntry(Sender: TObject; aCol,
  aRow: Integer; const OldValue: string; var NewValue: String);
var
  Value:  Integer;
  Max:    Integer;
begin
  if (ARow > 0) and (ACol = 3) then
    begin
      if NewValue <> '' then
      begin
        // Vérifiez si la valeur est un entier valide
        if TryStrToInt(NewValue, Value) then
        begin
          // Vérifiez si la valeur est comprise entre 0 et 10
          Max := StrToIntDef(TabFabrication.Cells[4, TabFabrication.Row],0);
          if (Value < 0) or (Value > MAx) then
          begin
            // La valeur est en dehors de la plage autorisée, vous pouvez afficher un message d'erreur
            ShowMessage(GetTexteLibelle('RULES-MESS_040'));
            // Rétablir la valeur précédente
            NewValue := OldValue;
          end;
        end
        else
        begin
          // La valeur n'est pas un entier valide, vous pouvez afficher un message d'erreur
          ShowMessage(GetTexteLibelle('RULES-MESS_040'));
          // Rétablir la valeur précédente
          NewValue := OldValue;
        end;
      end;

    end;

end;


end.

