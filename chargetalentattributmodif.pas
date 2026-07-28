unit ChargeTalentAttributModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  StructureTalentAttributModif = Record
        Livre:         string;
	CodeTalent:    string;
        CodeAttribut:  String;
        ValeurDonnee:  String;
end;

  TListTalentAttributModif = Specialize TList<StructureTalentAttributModif>;

Var
  ListTalentAttributModif:     TListTalentAttributModif;
  NbTalentAttributModif:       Integer;


implementation


end.

