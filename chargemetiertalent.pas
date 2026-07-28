unit ChargeMetierTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTalent, Generics.Collections;

Type
    StructureMetierTalent	= Record
	CodeMetier:	String;
	NiveauMetier:	Integer;
	CodeTalent:	String;
        Livre:          String;
End;

  TListMetierTalent = specialize TList<StructureMetierTalent>;

Var
  ListMetierTalent: TListMetierTalent;
  NbMetierTalent:   Integer;

implementation

end.

