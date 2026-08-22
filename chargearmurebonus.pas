unit ChargeArmureBonus;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, unitCalcul;

Type
  StructureArmureBonus     = record
    CodeArmureBonus: String;
    Libelle:         String;
    Description:     String;
    Malus:           String;
    Livre:           String;
end;

  TListArmureBonus   = specialize Tlist<StructureArmureBonus>;

Var
  ListArmureBonus:   TListArmureBonus;
  NbArmureBonus:     Integer;

function ChercheArmureBonus(CodeArmureBonus :String): StructureArmureBonus;
function GetAllArmureBonusLibelle(CodeArmureBonus :String): String;

implementation

function GetAllArmureBonusLibelle(CodeArmureBonus :String): String;
  var
    PArmureBonus:  StructureArmureBonus;
    Res:           String;
    Code:          String;
  Begin
    Res := CodeArmureBonus;
    For PArmureBonus in ListArmureBonus do
      begin
        Code := ExtractStringAfter(PArmureBonus.CodeArmureBonus, SeparateurLivre);
        if Pos(Code, Res) > 0 then
          Res := StringReplace(Res, Code, PArmureBonus.Libelle, [rfReplaceAll]);
      end;
    Result := Res;
  end;

function ChercheArmureBonus(CodeArmureBonus :String): StructureArmureBonus;
  var
    PArmureBonus:  StructureArmureBonus;
  Begin
    // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
    // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
    // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
    // affichee deux fois. CONTEXT.md 2.17.
    Result := Default(StructureArmureBonus);
    for PArmureBonus in ListArmureBonus do
      if CompareRechercheValeur(PArmureBonus.CodeArmureBonus, CodeArmureBonus) then
         Begin
           Result := PArmureBonus;
           break;
         end;
  end;


end.
