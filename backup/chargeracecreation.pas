unit ChargeRaceCreation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureRaceCreation     = Record
	Livre:	   string;
	CodeRace:string;
	Chance:	 string;
end;

  TListRaceCreation = Specialize TList<StructureRaceCreation>;

var
  ListRaceCreation:  TListRaceCreation;
  nbRaceCreation:    Integer;

procedure ChargerRaceCreation(Livre: String);


implementation

Procedure ChargerRaceCreation(Livre: String);
var
  PRaceCreation:  StructureRaceCreation;
  fichier:        TextFile;
  ligne:          string;
  strings:        TStringList;
  Path:           String;
Begin
  // Fichier des Talents
  Path := CheminFichier(ConstCheminRaceCreation, Livre);
  if FileExists(Path) then
     begin
     // Ouvrir le fichier en lecture

       AssignFile(fichier, Path);
       Reset(fichier);

       // Lire chaque ligne du fichier
       while not Eof(fichier) do
       begin
         strings            := TStringList.Create;
         ReadLn(fichier, ligne);
         Ligne := ReplaceTilde(Ligne);
         ExtractStrings([Separateurtabulation], [], PChar(Ligne), Strings);

         PRaceCreation.CodeRace  := Strings[0];
         PRaceCreation.Chance    := Strings[1];
         PRaceCreation.Livre     := Livre;

         ListRaceCreation.add(PRaceCreation);
         inc(NbRaceCreation);
         strings.Free;
       end;
       CloseFile(fichier);
   end;
 end;


end.

