unit ChargeAttributAugmentation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureAttributAugmentation  = record
    MinMax:     string;
    Cout:       integer;
    Livre:      String;
  end;
  TListeAttributAugmentation = Specialize TList<StructureAttributAugmentation>;

Var
  ListeAttributAugmentation:      TListeAttributAugmentation;
  NbAttributAugmentation:         Integer;

procedure ChargerAttributAugmentation(Livre: String);
Function ChercheAttributAugmentation(Min :Integer; Max: Integer): StructureAttributAugmentation;

implementation

procedure ChargerAttributAugmentation(Livre: String);
var
  PAttributAugmentation:          StructureAttributAugmentation;
  fichier:                        TextFile;
  ligne:                          string;
  strings:                        TStringList;
  Path:                           String;
Begin
  // Fichier des Augmentations d'Attributs
  Path := CheminFichier(ConstCheminXpAttribut, Livre);
  if FileExists(Path) then
     begin
     // Ouvrir le fichier en lecture
       if Livre = ConstRulesBook then ListeAttributAugmentation      := TListeAttributAugmentation.Create;
       AssignFile(fichier, Path);
       Reset(fichier);

       // Lire chaque ligne du fichier
       while not Eof(fichier) do
       begin
         strings            := TStringList.Create;
         ReadLn(fichier, ligne);
         Ligne := ReplaceTilde(Ligne);
         ExtractStrings([Separateurtabulation], [], PChar(Ligne), Strings);
         PAttributAugmentation.MinMax     := Strings[0];
         PAttributAugmentation.Cout       := StrToInt(Strings[1]);
         PAttributAugmentation.Livre      := Livre;
         ListeAttributAugmentation.add(PAttributAugmentation);
         inc(NbAttributAugmentation);
         strings.Free;
       end;
       CloseFile(fichier);
   end;
end;

Function ChercheAttributAugmentation(Min :Integer; Max: Integer): StructureAttributAugmentation;
var
  PAttributAugmentation: StructureAttributAugmentation;
  MinMax:                String;
Begin
  MinMax := IntToStr(Min)+'-'+IntToStr(Max);
  for PAttributAugmentation in ListeAttributAugmentation do
    if PAttributAugmentation.MinMax = MinMax then
      begin
       Result := PAttributAugmentation;
       break;
      end;

end;


end.

