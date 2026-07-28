unit ChargeArmureSimplifie;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, ChargeArmureBonus, Generics.Collections;

Type
  StructureArmureSimplifiee  = record
    CodeArmure:		String;
    Libelle:		String;
    Prix:               String;
    Encombrement:       Integer;
    Disponibilite:      String;
    Protection:         Integer;
    ListeBonus:         String;
    Livre:              String;

end;

  TListArmureSimplifiee = specialize TList<StructureArmureSimplifiee>;

Var
  ListArmureSimplifiee:      TListArmureSimplifiee;
  NbArmureSimplifiee:        Integer;

function ChercheArmureSimplifiee(CodeArmure :String): StructureArmureSimplifiee;
function TexteArmureSimplifiee(PArmureSimplifiee: StructureArmureSimplifiee):String;
Function CheminArmureSimplifieeImage(Indice: String): String;
function TexteLigneArmureSimplifiee(PArmureSimplifiee: StructureArmureSimplifiee):String;

implementation

function ChercheArmureSimplifiee(CodeArmure :String): StructureArmureSimplifiee;
var
  PArmureSimplifiee:      StructureArmureSimplifiee;
Begin
  for PArmureSimplifiee in ListArmureSimplifiee do
    if CompareRechercheValeur(PArmureSimplifiee.CodeArmure, CodeArmure) then
       Begin
         Result := PArmureSimplifiee;
         break;
       end;
end;

function TexteArmureSimplifiee(PArmureSimplifiee: StructureArmureSimplifiee):String;
  Var
    Texte:       String;
    Debut:       String;
  begin
    if Pos(ValeurGenerique,PArmureSimplifiee.CodeArmure) = 0 then
      begin
        Texte := GetTexteLibelle('LAB_118') + ' : ';
        if PArmureSimplifiee.Prix <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_054') + ' : ' + PArmureSimplifiee.Prix;
        if PArmureSimplifiee.Encombrement <> 0 then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_055') + ' : ' + IntToStr(PArmureSimplifiee.Encombrement);
        if PArmureSimplifiee.Disponibilite <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_056') + ' : ' + ReplaceTexteLibelle(PArmureSimplifiee.Disponibilite);
        if PArmureSimplifiee.Protection <> 0 then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_076') + ' : ' + IntToStr(PArmureSimplifiee.Protection);
        if PArmureSimplifiee.ListeBonus <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_034') + ' : ' + GetAllArmureBonusLibelle(PArmureSimplifiee.ListeBonus);
      end
    else
      begin
        Texte := GetTexteLibelle('LAB_010') + ' : ';
        Debut := copy(PArmureSimplifiee.CodeArmure,1,Length(PArmureSimplifiee.CodeArmure) - Length(ValeurGenerique) + 1);
          for PArmureSimplifiee in ListArmureSimplifiee do
            if (copy(PArmureSimplifiee.CodeArmure,1,Length(Debut)) = Debut) and (Pos(ValeurGenerique,PArmureSimplifiee.CodeArmure) = 0) then
              Texte  := Texte + SeparateurRetourLigne + ' - ' + PArmureSimplifiee.Libelle;
      end;
    Result   := Texte;
  end;

function TexteLigneArmureSimplifiee(PArmureSimplifiee: StructureArmureSimplifiee):String;
  Var
    Texte:       String;
  begin
    if Pos(ValeurGenerique,PArmureSimplifiee.CodeArmure) = 0 then
      begin
        Texte := PArmureSimplifiee.Libelle;
        if PArmureSimplifiee.Protection <> 0 then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_076') + ' : ' + IntToStr(PArmureSimplifiee.Protection);
        if PArmureSimplifiee.Encombrement <> 0 then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_055') + ' : ' + IntToStr(PArmureSimplifiee.Encombrement);
        if PArmureSimplifiee.ListeBonus <> '' then
          Texte  := Texte + '|' + GetTexteLibelle('LAB_034') + ' : ' + GetAllArmureBonusLibelle(PArmureSimplifiee.ListeBonus);
      end;
    Result   := Texte;
  end;


Function CheminArmureSimplifieeImage(Indice: String): String;
  begin
    Result := GetCurrentDir+StringReplace(ConstCheminImageArmure, ConstLivre, ConstRulesBook, [rfReplaceAll])+'ARMOR'+Indice+'.PNG';;
  end;


end.
