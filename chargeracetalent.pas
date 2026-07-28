unit ChargeRaceTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureRaceTalent   = record
    CodeRace:		string;
    CodeTalent:		string;
    Livre:              String;
end;

 TListRaceTalent = specialize TList<StructureRaceTalent>;

Var
  ListRaceTalent: TListRaceTalent;
  NbRaceTalent:   Integer;

implementation

end.

