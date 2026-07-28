unit ChargeCompetenceAugmentation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureCompetenceAugmentation  = record
    MinMax:     string;
    Cout:       integer;
    Livre:      String;
  end;

  TListeCompetenceAugmentation = Specialize TList<StructureCompetenceAugmentation>;

Var
  ListeCompetenceAugmentation:    TListeCompetenceAugmentation;
  NbCompetenceAugmentation:       Integer;

procedure ChargerCompetenceAugmentation(Livre: String);
Function ChercheCompetenceAugmentation(Min :Integer; Max: Integer): StructureCompetenceAugmentation;

implementation

procedure ChargerCompetenceAugmentation(Livre: String);
var
  PCompetenceAugmentation:        StructureCompetenceAugmentation;
  fichier:                        TextFile;
  ligne:                          string;
  strings:                        TStringList;
  Path:                           String;
Begin
  // Fichier des Augmentations d'Competences
  Path := CheminFichier(ConstCheminXpCompetence, Livre);
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
         PCompetenceAugmentation.MinMax     := Strings[0];
         PCompetenceAugmentation.Cout       := StrToInt(Strings[1]);
         PCompetenceAugmentation.Livre      := Livre;
         ListeCompetenceAugmentation.add(PCompetenceAugmentation);
         inc(NbCompetenceAugmentation);
         strings.Free;
       end;
       CloseFile(fichier);
   end;
end;

Function ChercheCompetenceAugmentation(Min :Integer; Max: Integer): StructureCompetenceAugmentation;
var
  PCompetenceAugmentation: StructureCompetenceAugmentation;
  MinMax:                  String;
Begin
  MinMax := IntToStr(Min)+'-'+IntToStr(Max);
  For PCompetenceAugmentation in ListeCompetenceAugmentation do
    if PCompetenceAugmentation.MinMax = MinMax then
      begin
       Result := PCompetenceAugmentation;
       break;
      end;
end;

end.

