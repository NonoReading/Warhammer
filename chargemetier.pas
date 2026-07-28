unit ChargeMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeTexte, PdfUtils, FileUtil, Unitcalcul;

Type
  StructureMetier	= Record
  	CodeMetier:	String;
  	Libelle:	String;
  	LibelleGroupe:	String;
        Description:	String;
        Livre:          String;
        CodeCompetence: String;
  End;

  TListMetier = specialize TList<StructureMetier>;

var
  ListMetier:     TListMetier;
  NbMetier:       Integer;

function chercheMetier(CodeMetier :String): StructureMetier;
Function CheminMetierImage(CodeMetier: String): String;

implementation


function ChercheMetier(CodeMetier :String): StructureMetier;
Var
  PMetier:  StructureMetier;
  PVide:    StructureMetier;
  Trouve:   Boolean;
Begin
  for PMetier in ListMetier do
    if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
      begin
        Result := PMetier;
        Trouve := true;
        break;
      end;
  if not trouve then
    begin
      PVide.Libelle := GetTexteLibelle('LAB_138');
      result:= PVide;
    end;
end;

Function CheminMetierImage(CodeMetier: String): String;
  var
    PMetier:        StructureMetier;
    ResTrans:     String;
    ResNormal:    String;
    Res:          String;
  begin
    for PMetier in ListMetier do
      if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
        Begin
          ResTrans  := GetCurrentDir+StringReplace(ConstCheminImageMetier, ConstLivre, PMetier.Livre, [rfReplaceAll])+CodeValeur+ConstTransparent+'.PNG';
          ResNormal := GetCurrentDir+StringReplace(ConstCheminImageMetier, ConstLivre, PMetier.Livre, [rfReplaceAll])+CodeValeur+'.PNG';
          if not FileExists(ResTrans) then
            if FileExists(ResNormal) then
              if (Not TestPixelZeroZero(ResNormal)) then
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

