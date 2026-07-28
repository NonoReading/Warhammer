unit ChargeCompetenceModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureCompetenceModif   = Record
        Livre:         string;
	CodeTalent:    string;
        CodeCompetence:String;
        CodeDonnee:    String;
        ValeurDonnee:  String;
end;

  TListCompetenceModif = Specialize TList<StructureCompetenceModif>;

Var
  ListCompetenceModif:     TListCompetenceModif;
  NbCompetenceModif:       Integer;


implementation


end.

