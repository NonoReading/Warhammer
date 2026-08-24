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
  end;

  TListMetierEquipement = specialize TList<StructureMetierEquipement>;

Var
  ListMetierEquipement: TListMetierEquipement;
  NbMetierEquipement:   Integer;

function GetListeEquipement(ListeCodes: String; ListeTypes: String):String;

implementation

function GetListeEquipement(ListeCodes: String; ListeTypes: String):String;
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
  begin
    stringsI                := TStringList.Create;
    stringsT                := TStringList.Create;

    ExtractStrings([SeparateurMulti], [], PChar(ListeCodes), stringsI);
    ExtractStrings([SeparateurMulti], [], PChar(ListeTypes), stringsT);

    ListeRes := '';
    For IndL := 0 to stringsI.count-1 do
      Begin
        Lib := '';
        if ListeRes <> '' then
          ListeRes := ListeRes + ',';

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

        if InList(stringsT[IndL], TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
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
      end;
    stringsI.Free;
    stringsT.Free;

    Result := ListeRes;
  end;

end.

