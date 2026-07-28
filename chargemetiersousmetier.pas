unit ChargeMetierSousMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeMetier,
  ChargeTexte, UnitCalcul;

Type
    StructureMetierSousMetier	= Record
	CodeMetier:	String;
	Chance:	        String;
	CodeSousMetier: String;
        Livre:          String;
End;

  TListMetierSousMetier = specialize TList<StructureMetierSousMetier>;

Var
  ListMetierSousMetier:   TListMetierSousMetier;
  NbMetierSousMetier:     Integer;

function TexteMetierSousMetier(CodeMetier: String; ListeLivre: String):String;
function ResultMetierSousMetier(CodeMetier: String; ValDe: Integer; ListeLivre: String): String;

implementation

function TexteMetierSousMetier(CodeMetier: String; ListeLivre: String):String;
  Var
    PMetierSousMetier: StructureMetierSousMetier;
    Texte:             String = '';
    PMetier:           StructureMetier;
    String2:           TStringList;
    Ind:               Integer = 0;
  begin
    if AvecSousMetier = true then
      For PMetierSousMetier in ListMetierSousMetier do
        if CompareRechercheValeur(PMetierSousMetier.CodeMetier, CodeMetier) and VerifieFiltre(PMetierSousMetier.Livre, ListeLivre) then
          begin
            if Texte = '' then Texte := SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_127') + ' : ';
            String2     := TStringList.Create;
            ExtractStrings([SeparateurMulti], [], PChar(PMetierSousMetier.CodeSousMetier), string2);
            for Ind := 0 to string2.Count - 1 do
            begin
              PMetier := ChercheMetier(string2[Ind]);
              if Ind = 0 then
                Texte := Texte + ' ' + SeparateurRetourLigne + PMetierSousMetier.Chance+' : '+PMetier.Libelle
              else
                Texte := Texte + ' / ' + PMetier.Libelle;
            end;
          end;
    Result   := Texte;
  end;

function ResultMetierSousMetier(CodeMetier: String; ValDe: Integer; ListeLivre: String): String;
  Var
    PMetierSousMetier: StructureMetierSousMetier;
    CodeRes:           String = '';
    Deb:               Integer= 0;
    Fin:               Integer= 0;
  begin
    if AvecSousMetier = true then
      For PMetierSousMetier in ListMetierSousMetier do
        if CompareRechercheValeur(PMetierSousMetier.CodeMetier, CodeMetier) and VerifieFiltre(PMetierSousMetier.Livre, ListeLivre) then
          begin
            DebutFin(PMetierSousMetier.Chance, Deb, Fin);
            if (ValDe >= Deb) and (ValDe <= Fin) then
              begin
                CodeRes := PMetierSousMetier.CodeSousMetier;
                Break;
              end;
        end;
    Result   := CodeRes;
  end;


end.

