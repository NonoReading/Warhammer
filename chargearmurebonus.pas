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
// Remplace chaque code de qualite par son libelle, dans une liste separee par des virgules.
//
// L'ancienne version faisait un StringReplace de SOUS-CHAINE sur la liste entiere, apres
// avoir retire le prefixe de livre du code declare. Deux consequences :
//   - un code prefixe d'un autre (ARMOB_1 dans ARMOB_10) aurait corrompu l'affichage ;
//   - a partir du moment ou les references portent leur prefixe de livre (CONTEXT.md 2.49),
//     le remplacement laissait le prefixe devant le libelle : "RULES-Partial".
// Cette version decoupe la liste et resout chaque code entier via ChercheArmureBonus, qui
// passe par CompareRechercheValeur et accepte donc le code prefixe comme non prefixe.
// Transposition de GetAllArmeBonusLibelle (chargearmebonus.pas), corrigee le 04/09/2026.
//
// Deux formes particulieres sont conservees telles quelles, par symetrie avec les armes :
//   "ARMOB_18 2"          un indice numerique suit le code, separe par un espace
//   "ARMOB_02/ARMOB_04"   qualites alternatives, separees par SeparateurMulti
var
  Liste:          TStringList;
  Alternatives:   TStringList;
  Element:        String;
  Suffixe:        String;
  Morceau:        String;
  Code:           String;
  PArmureBonus:   StructureArmureBonus;
  Ind:            Integer;
  IndAlt:         Integer;
Begin
  Result       := '';
  Liste        := TStringList.Create;
  Alternatives := TStringList.Create;
  try
    ExtractStrings([','], [], PChar(CodeArmureBonus), Liste);
    for Ind := 0 to Liste.Count - 1 do
      begin
        Element := Trim(Liste[Ind]);
        Suffixe := '';
        if Pos(' ', Element) > 0 then
          begin
            Suffixe := ' ' + Trim(ExtractStringAfter(Element, ' '));
            Element := Trim(ExtractStringBefore(Element, ' '));
          end;

        Alternatives.Clear;
        ExtractStrings([SeparateurMulti], [], PChar(Element), Alternatives);
        Morceau := '';
        for IndAlt := 0 to Alternatives.Count - 1 do
          begin
            Code         := Trim(Alternatives[IndAlt]);
            PArmureBonus := ChercheArmureBonus(Code);
            if PArmureBonus.Libelle <> '' then
              Code := PArmureBonus.Libelle;
            if Morceau <> '' then
              Morceau := Morceau + SeparateurMulti;
            Morceau := Morceau + Code;
          end;

        if Result <> '' then
          Result := Result + ',';
        Result := Result + Morceau + Suffixe;
      end;
  finally
    Alternatives.Free;
    Liste.Free;
  end;
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
