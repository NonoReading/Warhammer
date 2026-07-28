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

procedure ChargerMetierEquipement(Livre: String);
function GetListeEquipement(ListeCodes: String; ListeTypes: String):String;

implementation

Procedure ChargerMetierEquipement(Livre: String);
var
  PMetierEquipement:    StructureMetierEquipement;
  strings:              TStringList;
  stringsEqu:           TStringList;
  fichier:              TextFile;
  ligne:                String;
  ListeEquip:           String;
  Ind:                  Integer;
  Path:                 String;
Begin
  // Fichier des Equipementx de Métiers
  Path := CheminFichier(ConstCheminMetierEquipement, Livre);
  if FileExists(Path) then
     begin
     // Ouvrir le fichier en lecture
       AssignFile(fichier, Path);
       Reset(fichier);

       // Lire chaque ligne du fichier
       while not Eof(fichier) do
       begin
         strings            := TStringList.Create;
         StringsEqu         := TStringList.Create;
         ReadLn(fichier, ligne);
         Ligne := ReplaceTilde(Ligne);
         ExtractStrings([Separateurtabulation], [], PChar(Ligne), Strings);

         ListeEquip                            := Strings[2];

         if ListeEquip <> '-' then
           begin

             ExtractStrings([','], [], PChar(ListeEquip), StringsEqu);
             for Ind := 0 to StringsEqu.Count - 1 do
             begin
               PMetierEquipement.CodeMetier         := Strings[0];
               PMetierEquipement.NiveauMetier       := StrToInt(Strings[1]);
               PMetierEquipement.TypeEquipement     := GetTypeMetierEquipement(StringsEqu[Ind]);
               PMetierEquipement.Equipement         := StringsEqu[Ind];
               PMetierEquipement.Livre              := Livre;
               ListMetierEquipement.add(PMetierEquipement);
               inc(NbMetierEquipement);
             end;
           end;
         StringsEqu.Free;
         strings.Free;
       end;
       CloseFile(fichier);
   end;
 end;

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
            Code   := copy(stringsI[IndL],1,length(stringsI[IndL]) - length(Equipementqualite));
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

