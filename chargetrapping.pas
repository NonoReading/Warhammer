unit ChargeTrapping;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, Generics.Collections, UnitCalcul;

Type
  StructureTrapping     = record
    CodeTrapping:	String;
    Libelle:		String;
    Prix:               String;
    Encombrement:       Integer;
    Capacite:           Integer;
    ProfilAnimal:       String;   // 12 valeurs M WS BS S T I Ag Dex Int WP Fel W separees par des espaces (montures, animaux)
    TraitsAnimal:       String;   // traits separes par des virgules, tels qu'imprimes dans le livre (aussi ceux d'un bateau)
    ProfilBateau:       String;   // 7 valeurs Crew;M voile;M rames;Man;Size;T;W separees par des points-virgules (bateaux)
    Disponibilite:      String;
    Theme:              String;
    Acheteur:           String;
    Localite:           String;   // codes de libelles separes par des virgules (herbes)
    Saison:             String;   // idem
    Livre:              String;

end;

  TListTrapping = specialize TList<StructureTrapping>;

Var
  ListTrapping:      TListTrapping;
  NbTrapping:        Integer;

function ChercheTrapping(CodeTrapping :String): StructureTrapping;
function TexteTrapping(PTrapping: StructureTrapping):String;
function TexteLigneTrapping(PTrapping: StructureTrapping):String;
function TraduireListeLibelles(Liste: String):String;

implementation

function ChercheTrapping(CodeTrapping :String): StructureTrapping;
var
  PTrapping:      StructureTrapping;
Begin
  // Si rien ne correspond, Result doit rester vide : sans ce reset, un appel sans
  // resultat heritait de la valeur laissee par l'appel precedent (Result est passe
  // comme parametre cache pour un record gere, jamais efface tout seul). Visible sur
  // l'arbre des metiers : un item texte libre juste apres un Trapping resolu affichait
  // le libelle du Trapping precedent au lieu de rester en texte brut.
  Result.CodeTrapping := '';
  for PTrapping in ListTrapping do
    if CompareRechercheValeur(PTrapping.CodeTrapping, CodeTrapping) then
       Begin
         Result := PTrapping;
         break;
       end;
end;

function TraduireListeLibelles(Liste: String):String;
  Var
    Code:        String;
  begin
    // liste de codes de libelles separes par des virgules -> textes traduits, meme separateur
    Result := '';
    for Code in Liste.Split([',']) do
      if Trim(Code) <> '' then
        begin
          if Result <> '' then
            Result := Result + ', ';
          Result := Result + GetTexteLibelle(Trim(Code));
        end;
  end;

function TexteTrapping(PTrapping: StructureTrapping):String;
  Var
    Texte:       String;
  begin
    Texte := GetTexteLibelle('RULES-LAB_118') + ' : ';
    if PTrapping.Prix <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_054') + ' : ' + TraduirePrix(PTrapping.Prix);
    if PTrapping.Encombrement <> 0 then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PTrapping.Encombrement);
    if PTrapping.Capacite <> 0 then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_185') + ' : ' + IntToStr(PTrapping.Capacite);
    if PTrapping.Disponibilite <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_056') + ' : ' + ReplaceTexteLibelle(PTrapping.Disponibilite);
    Result   := Texte;
  end;

function TexteLigneTrapping(PTrapping: StructureTrapping):String;
  Var
    Texte:       String;
  begin
    Texte := PTrapping.Libelle;
    if PTrapping.Prix <> '' then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_054') + ' : ' + TraduirePrix(PTrapping.Prix);
    if PTrapping.Encombrement <> 0 then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PTrapping.Encombrement);
    if PTrapping.Capacite <> 0 then
      Texte  := Texte + '|' + GetTexteLibelle('RULES-LAB_185') + ' : ' + IntToStr(PTrapping.Capacite);
    Result   := Texte;
  end;

end.
