unit ChargeTalentModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  StructureTalentModif   = Record
        Livre:         string;
	CodeTalent:    string;
        TypeDonnee:    String;
        CodeDonnee:    String;
        ValeurDonnee:  String;
end;

  TListTalentModif = Specialize TList<StructureTalentModif>;

Var
  ListTalentModif:     TListTalentModif;
  NbTalentModif:       Integer;


implementation


end.

