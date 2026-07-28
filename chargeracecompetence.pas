unit ChargeRaceCompetence;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, UnitCalcul;

Type
  StructureRaceCompetence   = record
    CodeRace:		string;
    CodeCompetence:	string;
    Livre:              String;
end;

  TListRaceCompetence = specialize TList<StructureRaceCompetence>;

Var
  ListRaceCompetence: TListRaceCompetence;
  NbRaceCompetence:   Integer;

function ChercheRaceCompetence(CodeRace :String; CodeCompetence :String): StructureRaceCompetence;

implementation

Function ChercheRaceCompetence(CodeRace :String; CodeCompetence :String): StructureRaceCompetence;
Var
  PRaceCompetence:    StructureRaceCompetence;
  trouve:             boolean=false;
  PRaceCompetenceDef: StructureRaceCompetence;
Begin
  for PRaceCompetence in ListRaceCompetence do
    if CompareRechercheValeur(PRaceCompetence.CodeRace, CodeRace) and CompareRechercheValeur(PRaceCompetence.CodeCompetence, CodeCompetence) then
      begin
        trouve := true;
        Result := PRaceCompetence;
        break;
      end;

  if Not trouve then
    begin
      PRaceCompetenceDef.CodeRace       := '';
      PRaceCompetenceDef.CodeCompetence := '';
      Result                            := PRaceCompetenceDef
    end;
end;


end.

