unit ChargeCompetence;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

type
    StructureCompetence	               = record
  	CodeCompetence:		       string;
  	Libelle:                       string;
  	CodeAttribut:		       string;
  	Description:	               string;
  	SousCompetence:	               boolean;
        Livre:                         string;
    end;

  TListCompetence = Specialize TList<StructureCompetence>;

var
  ListCompetence:     TListCompetence;
  NbCompetence:       Integer;
  NbCompetenceUnique: Integer;
  DescriptionComp:    string;
  SpecialisationComp: string;

function ChercheCompetence(CodeCompetence :String): StructureCompetence;

implementation

function CountOccurrences(const str, subStr: string): Integer;
var
  index, count: Integer;
begin
  count := 0;
  index := 1;

  while index > 0 do
  begin
    index := Pos(subStr, str, index);
    if index > 0 then
    begin
      Inc(count);
      Inc(index, Length(subStr));
    end;
  end;

  Result := count;
end;

function ChercheCompetence(CodeCompetence :String): StructureCompetence;
var
  PCompetence:        StructureCompetence;
Begin
  for PCompetence in ListCompetence do
    if PCompetence.CodeCompetence = CodeCompetence then
       Begin
         Result := PCompetence;
         break;
       end;
end;

initialization


end.

