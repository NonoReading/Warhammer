unit ChargeAttribut;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, Generics.Collections, Unitcalcul;

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
Begin  // Fichier des Attributs
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
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureAttribut);
  for PAttribut in ListeAttribut do
    if CompareRechercheValeur(PAttribut.CodeAttribut, CodeAttribut) then
      begin
       Result := PAttribut;
       break;
      end;
end;


end.

