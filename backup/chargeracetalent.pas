unit ChargeRaceTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureRaceTalent   = record
    CodeRace:		string;
    CodeTalent:		string;
    Livre:              String;
end;

 TListRaceTalent = specialize TList<StructureRaceTalent>;

Var
  ListRaceTalent: TListRaceTalent;
  NbRaceTalent:   Integer;

procedure ChargerRaceTalent(Livre: String);

implementation

Procedure ChargerRaceTalent(Livre: String);
var
  PRaceTalent:    StructureRaceTalent;
  fichier:        TextFile;
  ligne:          String;
  strings:        TStringList;
  Path:           String;
Begin
  // Fichier des Talentx de Métiers
  Path := CheminFichier(ConstCheminRaceTalent, Livre);
  if FileExists(Path) then
     begin
     // Ouvrir le fichier en lecture
       AssignFile(fichier, Path);
       Reset(fichier);

       // Lire chaque ligne du fichier
       while not Eof(fichier) do
       begin
         strings     := TStringList.Create;
         ReadLn(fichier, ligne);
         Ligne := ReplaceTilde(Ligne);
         ExtractStrings([Separateurtabulation], [], PChar(Ligne), Strings);

         PRaceTalent.CodeRace    := Strings[0];
         PRaceTalent.CodeTalent  := Strings[1];
         PRaceTalent.Livre       := Livre;
         ListRaceTalent.add(PRaceTalent);
         inc(NbRaceTalent);

         Strings.Free;
       end;
       CloseFile(fichier);
   end;
 end;

end.

