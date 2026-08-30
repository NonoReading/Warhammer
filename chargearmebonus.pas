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
// Remplace chaque code de qualite par son libelle, dans une liste separee par des virgules.
//
// L'ancienne version faisait un StringReplace de SOUS-CHAINE sur la liste entiere, apres
// avoir retire le prefixe de livre du code declare. Deux consequences :
//   - un code qui est le prefixe d'un autre (WEAPB4 dans WEAPB40) aurait corrompu
//     l'affichage en silence. Aucun cas aujourd'hui, les codes faisant tous deux
//     chiffres, mais l'equilibre ne tient qu'a cela.
//   - la comparaison ignorait le livre, alors que ChercheArmeBonus sait le gerer.
// Cette version decoupe la liste et resout chaque code entier via ChercheArmeBonus, qui
// passe par CompareRechercheValeur et accepte donc le code prefixe comme non prefixe.
//
// Deux formes particulieres sont conservees telles quelles :
//   "WEAPB18 2"        un indice numerique suit le code, separe par un espace
//   "WEAPB30/WEAPB12"  qualites alternatives, separees par SeparateurMulti
var
  Liste:        TStringList;
  Alternatives: TStringList;
  Element:      String;
  Suffixe:      String;
  Morceau:      String;
  Code:         String;
  PArmeBonus:   StructureArmeBonus;
  Ind:          Integer;
  IndAlt:       Integer;
Begin
  Result       := '';
  Liste        := TStringList.Create;
  Alternatives := TStringList.Create;
  try
    ExtractStrings([','], [], PChar(CodeArmeBonus), Liste);
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
            Code       := Trim(Alternatives[IndAlt]);
            PArmeBonus := ChercheArmeBonus(Code);
            if PArmeBonus.Libelle <> '' then
              Code := PArmeBonus.Libelle;
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
