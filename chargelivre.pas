unit ChargeLivre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, UnitCalcul;

Type
  StructureLivre  = record
    CodeLivre:		String;
    Libelle:		String;
    Version:            String;
    Officiel:           Integer;
    Complet:            Integer;
end;

  TListLivre = specialize TList<StructureLivre>;

Var
  ListLivre:      TListLivre;
  NbLivre:        Integer;

function ChercheLivre(CodeLivre :String): StructureLivre;
function ChercheLivreLibelle(Livre :String): StructureLivre;

implementation

function ChercheLivre(CodeLivre :String): StructureLivre;
var
  PLivre:      StructureLivre;
Begin
  RechercheTrouve := false;
  for PLivre in ListLivre do
    if CompareRechercheValeur(PLivre.CodeLivre, CodeLivre) then
       Begin
         Result := PLivre;
         RechercheTrouve := true;
         break;
       end;
end;

function ChercheLivreLibelle(Livre :String): StructureLivre;
var
  PLivre:      StructureLivre;
Begin
  RechercheTrouve := false;
  for PLivre in ListLivre do
    if CompareRechercheValeur(PLivre.Libelle, Livre) then
       Begin
         RechercheTrouve := True;
         Result := PLivre;
         break;
       end;
end;


end.

