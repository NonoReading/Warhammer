unit ChargeRaceCorruptionCreation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureRaceCreation     = Record
	Livre:	            string;
	CodeRace:           string;
        TypeCorruption:     string;
	Chance:	            string;
end;

  TListRaceCorruptionCreation = Specialize TList<StructureRaceCorruptionCreation>;

var
  ListRaceCorruptionCreation:  TListRaceCorruptionCreation;
  nbRaceCorruptionCreation:    Integer;



implementation



end.

