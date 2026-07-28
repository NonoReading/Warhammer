unit ChargeRaceCreation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureRaceCreation     = Record
	Livre:	   string;
	CodeRace:string;
	Chance:	 string;
end;

  TListRaceCreation = Specialize TList<StructureRaceCreation>;

var
  ListRaceCreation:  TListRaceCreation;
  nbRaceCreation:    Integer;



implementation



end.

