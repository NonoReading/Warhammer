unit ChargeMetierTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTalent, Generics.Collections;

Type
    StructureMetierTalent	= Record
	CodeMetier:	String;
	NiveauMetier:	Integer;
	CodeTalent:	String;
        Livre:          String;
End;

  TListMetierTalent = specialize TList<StructureMetierTalent>;

Var
  ListMetierTalent: TListMetierTalent;
  NbMetierTalent:   Integer;

procedure ChargerMetierTalent(Livre: String);

implementation

Procedure ChargerMetierTalent(Livre: String);
var
  PMetierTalent:    StructureMetierTalent;
  fichier:          TextFile;
  ligne:            String;
  stringsMetier:    TStringList;
  StringTalent:     TStringList;
  Ind:              Integer;
  NbNiveau:         Integer;
  Path:             String;
Begin
  // Fichier des Attributx de Métiers
  Path := CheminFichier(ConstCheminMetierTalent, Livre);
  if FileExists(PAth) then
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
         StringTalent     := TStringList.Create;
         ReadLn(fichier, ligne);
         Ligne := ReplaceTilde(Ligne);
         ExtractStrings([Separateurtabulation], [], PChar(Ligne), StringTalent);

         NbNiveau          := StringTalent.count;
         for Ind := 1 to NbNiveau-1 Do
         Begin
           PMetierTalent.CodeMetier     := StringsMetier[Ind];
           PMetierTalent.NiveauMetier   := StrToInt(StringTalent[0]);
           PMetierTalent.CodeTalent     := StringTalent[Ind];
           PMetierTalent.Livre          := Livre;
           if PMetierTalent.CodeTalent <> '-' then
             begin
               ListMetierTalent.add(PMetierTalent);
               inc(NbMetierTalent);
             end;
         end;
         StringTalent.Free;
       end;
       StringsMetier.Free;
       CloseFile(fichier);
   end;
 end;

end.

