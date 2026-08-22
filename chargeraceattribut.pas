unit ChargeRaceAttribut;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, UnitCalcul;

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
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureRaceAttribut);
  For PRaceAttribut in ListRaceAttribut do
    if CompareRechercheValeur(PRaceAttribut.CodeRace, CodeRace) and CompareRechercheValeur(PRaceAttribut.CodeAttribut, CodeAttribut) then
      begin
       Result := PRaceAttribut;
       break;
      end;
end;


end.

