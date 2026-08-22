unit ChargeArmeBonus;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, Unitcalcul;

Type
  StructureArmeBonus     = record
    CodeArmeBonus:    String;
    Libelle:          String;
    Description:      String;
    Resume:           String;
    PlusMoins:        String;
    Livre:            String;
  end;

  TListArmeBonus =  Specialize TList<StructureArmeBonus>;

Var
  NbArmeBonus:     Integer;
  ListArmeBonus:   TListArmeBonus;

function ChercheArmeBonus(CodeArmeBonus :String): StructureArmeBonus;
function GetAllArmeBonusLibelle(CodeArmeBonus :String): String;

implementation

function GetAllArmeBonusLibelle(CodeArmeBonus :String): String;
var
  PArmeBonus:        StructureArmeBonus;
  Res:               String;
  Code:              String;
Begin
  Res := CodeArmeBonus;
  for PArmeBonus in ListArmeBonus do
    begin
      Code := ExtractStringAfter(PArmeBonus.CodeArmeBonus, SeparateurLivre);
      if Pos(Code, Res) > 0 then
        Res := StringReplace(Res, Code, PArmeBonus.Libelle, [rfReplaceAll]);
    end;
  Result := Res;
end;

function ChercheArmeBonus(CodeArmeBonus :String): StructureArmeBonus;
var
  PArmeBonus:        StructureArmeBonus;
Begin
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureArmeBonus);
    for PArmeBonus in ListArmeBonus do
      if CompareRechercheValeur(PArmeBonus.CodeArmeBonus, CodeArmeBonus) then
         Begin
           Result := PArmeBonus;
           break;
         end;
end;


end.
