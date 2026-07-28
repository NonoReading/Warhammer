unit ChargeRace;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeTexte, PdfUtils, UnitCalcul;

Type
  StructureRace	= Record
      	CodeRace:	String;
	Libelle:	String;
	PourcentRace:	String;
	AgeRace:	String;
	TailleRace:	String;
        Description:	String;
        Livre:          String;
        Espece:         String;
        Point3:         Integer;
        Point5:         Integer;
  End;

  TListRace = Specialize TList<StructureRace>;

var
  ListRace:     TListRace;
  NbRace:       Integer;

function chercheRace(CodeRace :String): StructureRace;
Function CheminRaceImage(CodeRace: String; Indice: String): String;

implementation

Function ChercheRace(CodeRace :String): StructureRace;
Var
  PRace:  StructureRace;
  PVide:    StructureRace;
  Trouve:   Boolean;
Begin
  for PRace in ListRace do
    if CompareRechercheValeur(PRace.CodeRace, CodeRace) then
      begin
        Result := PRace;
        Trouve := true;
        break;
      end;
  if not trouve then
    begin
      PVide.Libelle := GetTexteLibelle('LAB_138');
      result:= PVide;
    end;
end;

Function CheminRaceImage(CodeRace: String; Indice: String): String;
  var
    PRace:        StructureRace;
    ResTrans:     String;
    ResNormal:    String;
    Res:          String;
  begin
    for PRace in ListRace do
      if CompareRechercheValeur(PRace.CodeRace, CodeRace) then
        Begin
          ResTrans := GetCurrentDir+StringReplace(ConstCheminImageRace, ConstLivre, PRace.Livre, [rfReplaceAll])+CodeValeur+Indice+ConstTransparent+'.PNG';
          ResNormal:= GetCurrentDir+StringReplace(ConstCheminImageRace, ConstLivre, PRace.Livre, [rfReplaceAll])+CodeValeur+Indice+'.PNG';

          if not FileExists(ResTrans) then
            if FileExists(ResNormal) then
              if Not TestPixelZeroZero(ResNormal) then
                RemplacerPixelParTransparent(ResNormal,ResTrans);

          if FileExists(ResTrans) then
            Res    := ResTrans
          else
            Res    := ResNormal;
          break;
        end;
    Result := Res;
  end;
end.

