unit ChargeMetierAttribut;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
    StructureMetierAttribut	= Record
	CodeMetier:	String;
	NiveauMetier:	Integer;
	CodeAttribut:	String;
        Livre:          String;
End;

  TListMetierAttribut = Specialize TList<StructureMetierAttribut>;

Var
  ListMetierAttribut:   TListMetierAttribut;
  NbMetierAttribut:     Integer;

procedure ChargerMetierAttribut(Livre: String);

implementation

Procedure ChargerMetierAttribut(Livre: String);
var
  PMetierAttribut:      StructureMetierAttribut;
  fichier:              TextFile;
  ligne:                String;
  stringsMetier:        TStringList;
  stringsNiveau:        TStringList;
  Ind:                  Integer;
  NbNiveau:             Integer;
  Path:                 String;
Begin
  // Fichier des Attributx de Métiers
  Path := CheminFichier(ConstCheminMetierAttribut, Livre);
  if FileExists(Path) then
     begin
     // Ouvrir le fichier en lecture
       AssignFile(fichier, Path);
       Reset(fichier);

       if Not Eof(fichier) then
       Begin
           stringsMetier     := TStringList.Create;
           ReadLn(fichier, ligne);
           Ligne := ReplaceTilde(Ligne);
           ExtractStrings([Separateurtabulation], [], PChar(Ligne), StringsMetier);
       end;

       // Lire chaque ligne du fichier
       while not Eof(fichier) do
       begin
         stringsNiveau     := TStringList.Create;
         ReadLn(fichier, ligne);
         Ligne := ReplaceTilde(Ligne);
         ExtractStrings([Separateurtabulation], [], PChar(Ligne), StringsNiveau);

         NbNiveau          := StringsNiveau.count;
         for Ind := 1 to NbNiveau-1 Do
         Begin
           PMetierAttribut.CodeMetier         := StringsMetier[Ind];
           PMetierAttribut.NiveauMetier       := StrToInt(StringsNiveau[Ind]);
           PMetierAttribut.CodeAttribut       := StringsNiveau[0];
           PMetierAttribut.Livre              := Livre;
           ListMetierAttribut.add(PMetierAttribut);
           inc(NbMetierAttribut);
         end;
         StringsNiveau.Free;
       end;
       StringsMetier.Free;
       CloseFile(fichier);
   end;
 end;

end.

