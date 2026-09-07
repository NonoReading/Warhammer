unit ChargeArme;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeCompetence, ChargeTexte,
  ChargeArmeBonus, Generics.Collections, UnitCalcul;

Type
  StructureArme     = record
    CodeArme:	    String;
    CodeCompetence: String;
    Libelle:	    String;
    Mains:	    Integer;
    Prix:	    String;
    Encombrement:   Integer;
    Disponibilite:  String;
    Portee:	    String;
    CalculDegat:    String;
    ListeBonus:	    String;
    Munition:	    Integer;
    // Type generique de l'arme (ex. RULES-WTYPE_SWORD, RULES-WTYPE_LANCE,
    // RULES-WTYPE_SHIELD) - CONTEXT.md 2.50 etape 3 (3d-3, Ordres de Chevalerie).
    // Orthogonal a CodeCompetence (qui classe par MANIEMENT - Base/Cavalerie/2
    // mains/...) : TypeArme classe par NATURE de l'arme (epee/lance/bouclier/...),
    // ce que les qualites (ListeBonus) ne permettent pas de deduire de facon fiable
    // (verifie le 07/09/2026 : Defensive et Undamaging se retrouvent chacun sur des
    // armes d'autres familles, et meme leur conjonction sur l'Epee d'escrime -
    // Log.txt). Facultatif : '' si l'arme n'a pas encore besoin d'etre filtree par un
    // ModifyWeapon (voir ChargeMetier). Pas de table de libelles pour l'instant -
    // usage interne au filtrage, rien a afficher tant qu'aucun ecran n'en a besoin.
    TypeArme:       String;
    Livre:          String;
end;

  TListArme =  Specialize TList<StructureArme>;

Var
  ListArme:      TListArme;
  NbArme:        Integer;
  NbArmeUnique:  Integer;

function ChercheArme(CodeArme :String): StructureArme;
function TexteArme(PArme: StructureArme):String;
function TexteLigneArme(PArme: StructureArme):String;
Function CheminArmeImage(CodeCompetence: String; Indice: String): String;

implementation

function ChercheArme(CodeArme :String): StructureArme;
var
  PArme:        StructureArme;
Begin
  for PArme in ListArme do
    if CompareRechercheValeur(PArme.CodeArme, CodeArme) then
       Begin
         Result := PArme;
         break;
       end;
end;

function TexteArme(PArme: StructureArme):String;
  Var
    Texte:       String;
    PCompetence: StructureCompetence;
    Debut:       String;
    Ind:           Integer;
  begin
    Texte    := '';
    if Pos(ValeurGenerique,PArme.CodeArme) = 0 then
      begin
        Texte := GetTexteLibelle('RULES-LAB_118') + ' : ';
        if PArme.Mains <> 0 then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_053') + ' : ' + IntToStr(PArme.Mains);
        if PArme.CalculDegat <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_058') + ' : ' + ReplaceTexteLibelle(PArme.CalculDegat);
        if (PArme.CodeCompetence <> '-') and (PArme.Munition = 0) then
          begin
            PCompetence := cherchecompetence(PArme.CodeCompetence);
            Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_009') + ' : ' + PCompetence.Libelle;
          end;
        if PArme.Prix <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_054') + ' : ' + PArme.Prix;
        if PArme.Disponibilite <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_056') + ' : ' + GetAllTexteLibelle(PArme.Disponibilite);
        if PArme.Encombrement <> 0 then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PArme.Encombrement);
        if PArme.Portee <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_057') + ' : ' + GetAllTexteLibelle(PArme.Portee);
        if (PArme.Munition <> 0) and (IntToStr(PArme.Munition) <> '-') then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_060') + ' : ' + IntToStr(PArme.Munition);
        if PArme.ListeBonus <> '' then
          Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_034') + ' : ' + GetAllArmeBonusLibelle(PArme.ListeBonus);
      end
    else
      begin
        Texte := GetTexteLibelle('RULES-LAB_010') + ' : ';
        Debut := copy(PArme.CodeArme,1,Length(PArme.CodeArme) - Length(ValeurGenerique) + 1);
        For Ind := 0 to NbArme-1 do
          Begin
            PArme := ListArme[Ind];
            if (copy(PArme.CodeArme,1,Length(Debut)) = Debut) and (Pos(ValeurGenerique,PArme.CodeArme) = 0) then
              begin
                Texte  := Texte + SeparateurRetourLigne + ' - ' + PArme.Libelle;
              end;
          end;
      end;
    Result   := Texte;
  end;

function TexteLigneArme(PArme: StructureArme):String;
  Var
    Texte:       String;
    PCompetence: StructureCompetence;
  begin
    Texte := PArme.Libelle + ' : ';
    if PArme.Mains <> 0 then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_053') + ' : ' + IntToStr(PArme.Mains);
    if PArme.CalculDegat <> '' then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_058') + ' : ' + ReplaceTexteLibelle(PArme.CalculDegat);
    if (PArme.CodeCompetence <> '-') and (PArme.Munition = 0) then
      begin
        PCompetence := cherchecompetence(PArme.CodeCompetence);
        Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_009') + ' : ' + PCompetence.Libelle;
      end;
    if PArme.Encombrement <> 0 then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PArme.Encombrement);
    if PArme.Portee <> '' then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_057') + ' : ' + GetAllTexteLibelle(PArme.Portee);
    if (PArme.Munition <> 0) and (IntToStr(PArme.Munition) <> '-') then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_060') + ' : ' + IntToStr(PArme.Munition);
    if PArme.ListeBonus <> '' then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_034') + ' : ' + GetAllArmeBonusLibelle(PArme.ListeBonus);
    Result   := Texte;
  end;

Function CheminArmeImage(CodeCompetence: String; Indice: String): String;
  begin
    Result := GetCurrentDir+StringReplace(ConstCheminImageArme, ConstLivre, ConstRulesBook, [rfReplaceAll])+ExtractStringAfter(ExtractStringBefore(CodeCompetence,'_'),SeparateurLivre)+Indice+'.JPG';
  end;


end.
