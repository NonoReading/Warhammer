unit ChargeTalentCompetenceAjoute;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureTalentCompetenceAjoute   = Record
        Livre:         string;
	CodeTalent:    string;
        CodeCompetence:String;
end;

  TListTalentCompetenceAjoute = Specialize TList<StructureTalentCompetenceAjoute>;

Var
  ListTalentCompetenceAjoute:     TListTalentCompetenceAjoute;
  NbTalentCompetenceAjoute:       Integer;


implementation


end.

