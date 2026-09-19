unit ChargeMetierEquipement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, ChargeArme, ChargeArmure
  , Generics.Collections;

Type
  StructureMetierEquipement     = record
    CodeMetier:             String;
    NiveauMetier:	    Integer;
    Equipement:             String;
    TypeEquipement:         String;
    Livre:                  String;
    Quantite:               Integer;
    // Quantites par branche d'un choix "A/B/C", texte brut du livre aligne sur les branches
    // ("2/1/1"). Vide = pas de quantite par branche : Quantite vaut alors pour tout l'item.
    // Quand il est renseigne, Quantite reste a 1 et ne doit plus etre lu.
    QuantiteListe:          String;
  end;

  TListMetierEquipement = specialize TList<StructureMetierEquipement>;

Var
  ListMetierEquipement: TListMetierEquipement;
  NbMetierEquipement:   Integer;

function GetListeEquipement(ListeCodes: String; ListeTypes: String):String;
function GetListeEquipement(ListeCodes: String; ListeTypes: String; QuantiteListe: String; out ListeQuantites: String):String;
function QuantiteSuffixe(Quantite: Integer): String;
function QuantiteDeBranche(QuantiteListe: String; Branche: Integer): Integer;

implementation

function GetListeEquipement(ListeCodes: String; ListeTypes: String):String;
  var
    Ignore: String;
  begin
    Result := GetListeEquipement(ListeCodes, ListeTypes, '', Ignore);
  end;

// ListeQuantites : une quantite par code de Result, dans le meme ordre, separees par ','.
// Un code generique developpe en plusieurs armes donne la quantite de SA branche a chacune.
function GetListeEquipement(ListeCodes: String; ListeTypes: String; QuantiteListe: String; out ListeQuantites: String):String;
  var
    PArme:              StructureArme;
    PArmure:            StructureArmure;
    StringsI:           TStringList;
    StringsT:           TStringList;
    IndL:               Integer;
    Code:               String;
    Qualite:            String;
    ListeRes:           String;
    Lib:                String;
    Debut:              String;
    NbCodes:            Integer;
  begin
    stringsI                := TStringList.Create;
    stringsT                := TStringList.Create;

    ExtractStrings([SeparateurMulti], [], PChar(ListeCodes), stringsI);
    ExtractStrings([SeparateurMulti], [], PChar(ListeTypes), stringsT);

    ListeRes       := '';
    ListeQuantites := '';
    For IndL := 0 to stringsI.count-1 do
      Begin
        Lib := '';
        if ListeRes <> '' then
          ListeRes := ListeRes + ',';
        if ListeQuantites <> '' then
          ListeQuantites := ListeQuantites + ',';

        if pos(EquipementQualite, StringsT[IndL]) > 0 then
          begin
            Code   := Trim(copy(stringsI[IndL],1,length(stringsI[IndL]) - length(Equipementqualite)));
            Qualite:= Equipementqualite;
          end
        else
          begin
            Code   := stringsI[IndL];
            Qualite:= '';
          end;

        if InList(stringsT[IndL], TypeEquipMetierArme) then
           begin
             if pos(ValeurGenerique, Code) > 0 then
               begin
                 Debut := copy(Code,1,length(code) - length(ValeurGenerique) + 1);
                 for PArme in ListArme do
                   if (copy(PArme.CodeArme,1,Length(Debut)) = Debut) and (Pos(ValeurGenerique,PArme.CodeArme) = 0) then
                     begin
                        if Lib <> '' then
                          Lib:= Lib + ',';
                        Lib  := Lib + PArme.CodeArme + Qualite;
                     end
               end
             else
               begin
                 PArme    := ChercheArme(Code);
                 if Lib <> '' then
                   Lib:= Lib + ',';
                 Lib  := Lib + PArme.CodeArme + Qualite;
               end;
           end

         else if stringsT[IndL] = TypeEquipAR then
           begin
             PArmure  := ChercheArmure(Code);
             Lib      := PArmure.CodeArmure + Qualite;
           end

         else if stringsT[IndL] = TypeEquipDI then
           begin
             Lib := Code + Qualite;
           end;

         ListeRes := ListeRes + Lib;

         // un code par morceau separe par ',' (vide compte pour un) : meme decompte cote quantites
         For NbCodes := 0 to Length(Lib) - Length(StringReplace(Lib, ',', '', [rfReplaceAll])) do
           begin
             if NbCodes > 0 then
               ListeQuantites := ListeQuantites + ',';
             ListeQuantites := ListeQuantites + IntToStr(QuantiteDeBranche(QuantiteListe, IndL));
           end;
      end;
    stringsI.Free;
    stringsT.Free;

    Result := ListeRes;
  end;

// Quantite de la branche numero Branche (base 0) d'un choix. Une liste sans SeparateurMulti est
// une quantite unique, valable pour toutes les branches ; vide ou hors limites = 1.
function QuantiteDeBranche(QuantiteListe: String; Branche: Integer): Integer;
  var
    Morceaux: TStringList;
  begin
    Result := 1;
    if QuantiteListe = '' then
      exit;
    if Pos(SeparateurMulti, QuantiteListe) = 0 then
      Result := StrToIntDef(Trim(QuantiteListe), 1)
    else
      begin
        Morceaux := TStringList.Create;
        try
          ExtractStrings([SeparateurMulti], [], PChar(QuantiteListe), Morceaux);
          if (Branche >= 0) and (Branche < Morceaux.Count) then
            Result := StrToIntDef(Trim(Morceaux[Branche]), 1);
        finally
          Morceaux.Free;
        end;
      end;
  end;

// Suffixe affiche a cote du libelle d'un equipement de metier quand le livre en donne
// plusieurs exemplaires (ex. "2 Sets of Clothing", CONTEXT.md 2.77) - meme convention que
// les prefixes (W)/(P)/(D) : marqueur non traduit, pas une phrase.
function QuantiteSuffixe(Quantite: Integer): String;
  begin
    if Quantite <> 1 then
      Result := ' x' + IntToStr(Quantite)
    else
      Result := '';
  end;

end.

