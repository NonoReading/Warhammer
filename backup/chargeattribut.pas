unit ChargeAttribut;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, Generics.Collections;

Type
  StructureAttribut      = record
    CodeAttribut:              string;
    Libelle:                   string;
    Description:               string;
    Resume:                    String;
    OrdreAttribut:             integer;
    Livre:                     String;
  end;

  TListeAttribut =  Specialize TList<StructureAttribut>;

Var
  NbAttribut:        Integer;
  ListeAttribut:     TListeAttribut;

procedure ChargerAttribut(Livre: String);
function ChercheAttribut(CodeAttribut :String): StructureAttribut;

implementation

procedure ChargerAttribut(Livre: String);
var
  fichier:            TextFile;
  ligne:              string;
  strings:            TStringList;
  PAttribut:          StructureAttribut;
  Path:               String;
Begin
  // Fichier des Attributs
  Path := CheminFichier(ConstCheminAttribut, Livre);
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

         PAttribut.CodeAttribut          := Strings[0];
         PAttribut.Libelle               := Strings[1];
         PAttribut.Description           := Strings[2];
         PAttribut.Resume             := GetTexteLibelle(Strings[3]);
         PAttribut.OrdreAttribut         := StrToInt(Strings[4]);
         PAttribut.Livre                 := Livre;
         ListeAttribut.add(PAttribut);
         inc(NbAttribut);
         strings.Free;
       end;
       CloseFile(fichier);
   end;
end;

Function ChercheAttribut(CodeAttribut :String): StructureAttribut;
var
  PAttribut:          StructureAttribut;
Begin
  for PAttribut in ListeAttribut do
    if PAttribut.CodeAttribut = CodeAttribut then
      begin
       Result := PAttribut;
       break;
      end;
end;


end.

