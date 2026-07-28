unit ChargeArmure;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, ChargeArmureBonus, Generics.Collections, UnitCalcul;

Type
  StructureArmure     = record
    CodeArmure:		String;
    Libelle:		String;
    TypeMateriel:       String;
    Prix:               String;
    Encombrement:       Integer;
    Disponibilite:      String;
    Emplacement:        String;
    Protection:         Integer;
    ListeBonus:         String;
    Livre:              String;

end;

  TListArmure = specialize TList<StructureArmure>;

Var
  ListArmure:      TListArmure;
  NbArmure:        Integer;

function ChercheArmure(CodeArmure :String): StructureArmure;
function TexteArmure(PArmure: StructureArmure):String;
Function CheminArmureImage(Indice: String): String;
function TexteLigneArmure(PArmure: StructureArmure):String;

implementation

function ChercheArmure(CodeArmure :String): StructureArmure;
var
  PArmure:      StructureArmure;
Begin
  for PArmure in ListArmure do
    if CompareRechercheValeur(PArmure.CodeArmure, CodeArmure) then
       Begin
         Result := PArmure;
         break;
       end;
end;

function TexteArmure(PArmure: StructureArmure):String;
  Var
    Texte:       String;
    Debut:       String;
  begin
    if Pos(ValeurGenerique,PArmure.CodeArmure) = 0 then
      begin
        Texte := GetTexteLibelle('LAB_118') + ' : ';
        if PArmure.TypeMateriel <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_074') + ' : ' + ReplaceTexteLibelle(PArmure.TypeMateriel);
        if PArmure.Prix <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_054') + ' : ' + PArmure.Prix;
        if PArmure.Encombrement <> 0 then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_055') + ' : ' + IntToStr(PArmure.Encombrement);
        if PArmure.Disponibilite <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_056') + ' : ' + ReplaceTexteLibelle(PArmure.Disponibilite);
        if PArmure.Emplacement <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_075') + ' : ' + ReplaceTexteLibelle(PArmure.Emplacement);
        if PArmure.Protection <> 0 then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_076') + ' : ' + IntToStr(PArmure.Protection);
        if PArmure.ListeBonus <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_034') + ' : ' + GetAllArmureBonusLibelle(PArmure.ListeBonus);
      end
    else
      begin
        Texte := GetTexteLibelle('LAB_010') + ' : ';
        Debut := copy(PArmure.CodeArmure,1,Length(PArmure.CodeArmure) - Length(ValeurGenerique) + 1);
          for PArmure in ListArmure do
            if (copy(PArmure.CodeArmure,1,Length(Debut)) = Debut) and (Pos(ValeurGenerique,PArmure.CodeArmure) = 0) then
              Texte  := Texte + SeparateurRetourLigne + ' - ' + PArmure.Libelle;
      end;
    Result   := Texte;
  end;

function TexteLigneArmure(PArmure: StructureArmure):String;
  Var
    Texte:       String;
  begin
    if Pos(ValeurGenerique,PArmure.CodeArmure) = 0 then
      begin
        Texte := PArmure.Libelle;
        if PArmure.Protection <> 0 then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_076') + ' : ' + IntToStr(PArmure.Protection);
        if PArmure.Encombrement <> 0 then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_055') + ' : ' + IntToStr(PArmure.Encombrement);
        if PArmure.Emplacement <> '' then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_075') + ' : ' + ReplaceTexteLibelle(PArmure.Emplacement);
        if PArmure.ListeBonus <> '' then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_034') + ' : ' + GetAllArmureBonusLibelle(PArmure.ListeBonus);
      end;
    Result   := Texte;
  end;


Function CheminArmureImage(Indice: String): String;
  begin
    Result := GetCurrentDir+StringReplace(ConstCheminImageArmure, ConstLivre, ConstRulesBook, [rfReplaceAll])+'ARMOR'+Indice+'.PNG';;
  end;


end.
