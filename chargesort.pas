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
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
    Result := Default(StructureSort);
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
         DecoupeCodeValeur(Cod);
         Res      := GetCurrentDir+StringReplace(ConstCheminImageSort, ConstLivre, Book, [rfReplaceAll])+CodeValeur+'.PNG';
         if FileExists(Res) then
           break;
      end;
    Result := res;
  end;

end.

