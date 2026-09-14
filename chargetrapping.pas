unit ChargeTrapping;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, Generics.Collections, UnitCalcul;

Type
  StructureTrapping     = record
    CodeTrapping:	String;
    Libelle:		String;
    Prix:               String;
    Encombrement:       Integer;
    Disponibilite:      String;
    Livre:              String;

end;

  TListTrapping = specialize TList<StructureTrapping>;

Var
  ListTrapping:      TListTrapping;
  NbTrapping:        Integer;

function ChercheTrapping(CodeTrapping :String): StructureTrapping;
function TexteTrapping(PTrapping: StructureTrapping):String;
function TexteLigneTrapping(PTrapping: StructureTrapping):String;

implementation

function ChercheTrapping(CodeTrapping :String): StructureTrapping;
var
  PTrapping:      StructureTrapping;
Begin
  for PTrapping in ListTrapping do
    if CompareRechercheValeur(PTrapping.CodeTrapping, CodeTrapping) then
       Begin
         Result := PTrapping;
         break;
       end;
end;

function TexteTrapping(PTrapping: StructureTrapping):String;
  Var
    Texte:       String;
  begin
    Texte := GetTexteLibelle('RULES-LAB_118') + ' : ';
    if PTrapping.Prix <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_054') + ' : ' + PTrapping.Prix;
    if PTrapping.Encombrement <> 0 then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PTrapping.Encombrement);
    if PTrapping.Disponibilite <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_056') + ' : ' + ReplaceTexteLibelle(PTrapping.Disponibilite);
    Result   := Texte;
  end;

function TexteLigneTrapping(PTrapping: StructureTrapping):String;
  Var
    Texte:       String;
  begin
    Texte := PTrapping.Libelle;
    if PTrapping.Prix <> '' then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_054') + ' : ' + PTrapping.Prix;
    if PTrapping.Encombrement <> 0 then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PTrapping.Encombrement);
    Result   := Texte;
  end;

end.
