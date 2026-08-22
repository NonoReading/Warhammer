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
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureLivre);
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
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureLivre);
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

