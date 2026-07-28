unit ChargeTalentCompetenceModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureTalentCompetenceModif   = Record
        Livre:         string;
	CodeTalent:    string;
        CodeCompetence:String;
        CodeDonnee:    String;
        TypeModif:     String;
end;

  TListTalentCompetenceModif = Specialize TList<StructureTalentCompetenceModif>;

Var
  ListTalentCompetenceModif:     TListTalentCompetenceModif;
  NbTalentCompetenceModif:       Integer;


implementation


end.

