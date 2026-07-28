unit ChargeMetierNiveau;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureMetierNiveau	= Record
  	CodeMetier:	String;
  	NiveauMetier:	Integer;
  	Libelle:	String;
        SalaireMetier:  String;
        Livre:          String;
  End;

  TListMetierNiveau = Specialize TList<StructureMetierNiveau>;

var
  ListMetierNiveau:     TListMetierNiveau;
  NbMetierNiveau:       Integer;

function ChercheMetierNiveau(CodeMetier :String; NiveauMetier: Integer): StructureMetierNiveau;
function ChercheMaxMetierNiveau(CodeMetier :String): Integer;

implementation

function ChercheMetierNiveau(CodeMetier :String; NiveauMetier: Integer): StructureMetierNiveau;
var
  PMetierNiveau:        StructureMetierNiveau;
Begin
  For PMetierNiveau in ListMetierNiveau do
    if (CompareRechercheValeur(PMetierNiveau.CodeMetier, CodeMetier) = True) and (PMetierNiveau.NiveauMetier = NiveauMetier) then
      begin
       Result := PMetierNiveau;
       break;
      end;
end;

function ChercheMaxMetierNiveau(CodeMetier :String): Integer;
var
  PMetierNiveau:        StructureMetierNiveau;
  MaxNiveau:            Integer = 0;
Begin
  For PMetierNiveau in ListMetierNiveau do
    if (PMetierNiveau.CodeMetier = CodeMetier) and (PMetierNiveau.NiveauMetier > MaxNiveau) then
      MaxNiveau := PMetierNiveau.NiveauMetier;
  Result := MaxNiveau;
end;


end.

