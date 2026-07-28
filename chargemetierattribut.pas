unit ChargeMetierAttribut;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
    StructureMetierAttribut	= Record
	CodeMetier:	String;
	NiveauMetier:	Integer;
	CodeAttribut:	String;
        Livre:          String;
End;

  TListMetierAttribut = Specialize TList<StructureMetierAttribut>;

Var
  ListMetierAttribut:   TListMetierAttribut;
  NbMetierAttribut:     Integer;


implementation

end.

