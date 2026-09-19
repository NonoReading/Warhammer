unit WinMutationCatalogue;

// Consultation du catalogue des mutations (Physical/Mental Corruption Table, CONTEXT.md
// 2.7) depuis le menu principal. Fenetre construite en code (pas de .lfm) : une grille en
// lecture seule alimentee par ListCorruptionTable. Distincte de WinMutation, qui sert au
// tirage d'une mutation pour un personnage.

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Grids,
  ChargeConstantes, ChargeTexte, ChargeCorruptionTable, Unitcalcul;

type

  { TWinMutationCatalogue }

  TWinMutationCatalogue = class(TForm)
  private
    TabMutation: TStringGrid;
    procedure Remplir();
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  WinMutationCat: TWinMutationCatalogue;

implementation

constructor TWinMutationCatalogue.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner);
  Caption      := GetTexteLibelle('RULES-LAB_172');
  Color        := clBlack;
  Width        := 1000;
  Height       := 600;
  TabMutation             := TStringGrid.Create(Self);
  TabMutation.Parent      := Self;
  TabMutation.Align       := alClient;
  TabMutation.BorderSpacing.Around := 16;
  TabMutation.FixedCols   := 0;
  TabMutation.Options     := TabMutation.Options - [goEditing] + [goRowSelect];
  Remplir();
end;

procedure TWinMutationCatalogue.Remplir();
  var
    P:   StructureCorruptionTable;
    Ind: Integer = 0;
  begin
    TabMutation.ColCount := 5;
    TabMutation.RowCount := ListCorruptionTable.Count + 1;
    TabMutation.Cells[0, 0] := GetTexteLibelle('RULES-LAB_171');
    TabMutation.Cells[1, 0] := GetTexteLibelle('RULES-LAB_001');
    TabMutation.Cells[2, 0] := GetTexteLibelle('RULES-LAB_014');
    TabMutation.Cells[3, 0] := GetTexteLibelle('RULES-LAB_117');
    TabMutation.Cells[4, 0] := GetTexteLibelle('RULES-LAB_128');
    for P in ListCorruptionTable do
      begin
        Inc(Ind);
        TabMutation.Cells[0, Ind] := GetTexteLibelle(P.TypeCorruption);
        TabMutation.Cells[1, Ind] := P.Code;
        TabMutation.Cells[2, Ind] := P.Libelle;
        TabMutation.Cells[3, Ind] := P.Effet;
        TabMutation.Cells[4, Ind] := GetTexteLibelle(P.Livre, '', '', true);
      end;
    TabMutation.ColWidths[0] := 90;
    TabMutation.ColWidths[1] := 150;
    TabMutation.ColWidths[2] := 200;
    TabMutation.ColWidths[3] := 400;
    TabMutation.ColWidths[4] := 150;
  end;

end.
