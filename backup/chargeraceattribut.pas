unit ChargeRaceAttribut;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureRaceAttribut         = record
    CodeRace:			string;
    CalculRace:			string;
    CodeAttribut:		string;
    Livre:                      String;
end;

  TListRaceAttribut = Specialize TList<StructureRaceAttribut>;

Var
  ListRaceAttribut:   TListRaceAttribut;
  NbRaceAttribut:     Integer;

function ChercheRaceAttribut(CodeRace :String; CodeAttribut: String): StructureRaceAttribut;

implementation

function ChercheRaceAttribut(CodeRace :String; CodeAttribut: String): StructureRaceAttribut;
var
  PRaceAttribut:        StructureRaceAttribut;
Begin
  For PRaceAttribut in ListRaceAttribut do
    if (PRaceAttribut.CodeRace = CodeRace) and (PRaceAttribut.CodeAttribut = CodeAttribut) then
      begin
       Result := PRaceAttribut;
       break;
      end;
end;


end.

