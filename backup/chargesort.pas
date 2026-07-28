unit ChargeSort;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Dialogs, Generics.Collections;

Type
  StructureSort       = Record
	CodeSort:	  string;
        ListeTalent:	  string;
        Libelle:	  string;
        Portee:	          string;
        Cible:	          string;
        Duree:	          string;
        Description:      string;
        Niveau:	          string;
        TypeSort:         String;
        Livre:            String;
end;

  TListSort = specialize TList<StructureSort>;

Var
  ListSort:     TListSort;
  NbSort:       Integer;

function ChercheSort(CodeSort :String): StructureSort;
Function CheminSortImage(CodeTalent: String): String;

implementation


function ChercheSort(CodeSort :String): StructureSort;
  var
    PSort:        StructureSort;
  Begin
    For PSort in ListSort do
      if CompareRechercheValeur(PSort.CodeSort, CodeSort) then
         Begin
           Result := PSort;
           break;
         end;
  end;

Function CheminSortImage(CodeTalent: String): String;
  var
    Res: String;
    Cod: String;
    Book:String;
  begin
    if pos(ValeurGenerique, CodeTalent) = 0 then
      Cod := CodeTalent
    else
      Cod := ExtractStringBefore(CodeTalent,'_');
    for Book In ListBook do
      begin
         Res      := GetCurrentDir+StringReplace(ConstCheminImageSort, ConstLivre, Book, [rfReplaceAll])+Cod+'.PNG';
         if FileExists(Res) then
           break;
      end;
    Result := res;
  end;

end.

