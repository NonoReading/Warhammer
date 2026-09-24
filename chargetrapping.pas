unit ChargeTrapping;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, Generics.Collections, UnitCalcul,
  ChargeFabrication;

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
    ProfilVehicule:     String;   // 4 valeurs Motive Power;T;W;Strike separees par des points-virgules (chars, chariots, vehicules terrestres)
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
function TrappingEstPorteur(PTrapping: StructureTrapping): Boolean;
function TexteTrapping(PTrapping: StructureTrapping):String;
function TexteLigneTrapping(PTrapping: StructureTrapping):String;
function TraduireListeLibelles(Liste: String):String;
// Profil calcule d'un bateau (Crew;M voile;M rames;Man;Size;T;W) : profil de base
// (ProfilBateau) + effet des traits deja inscrits sur le bateau (Armoured/Sturdy,
// catalogue) + effet des amenagements confies (ListeCodesFittings, meme format que
// ChercheFabrication : "CODE niveau,CODE niveau"). Seuls les 4 effets chiffrables
// releves dans Death on the Reik Companion/Sea of Claws sont calcules (24/09/2026) :
// les autres amenagements (couverture, bonus de test, AP de coque...) restent hors
// moteur, decision de Nono - voir A FAIRE.txt "AMENAGEMENTS DE BATEAU".
function BoatProfilCalcule(PBateau: StructureTrapping; ListeCodesFittings: String): String;

implementation

// Niveau d'un trait de bateau ("Sturdy 2" -> 2, "Sturdy" seul -> 1, absent -> 0), sur le
// modele de DescriptionTraitsBateau (winanimal.pas) qui retire le meme suffixe numerique.
function NiveauTraitBateau(Traits, NomTrait: String): Integer;
  var
    Trait, Cle, Chiffres: String;
  begin
    Result := 0;
    for Trait in Traits.Split([',']) do
      begin
        Cle      := Trim(Trait);
        Chiffres := '';
        while (Cle <> '') and (Cle[Length(Cle)] in ['0'..'9']) do
          begin
            Chiffres := Cle[Length(Cle)] + Chiffres;
            Delete(Cle, Length(Cle), 1);
          end;
        Cle := Trim(Cle);
        if SameText(Cle, NomTrait) then
          begin
            Result := StrToIntDef(Chiffres, 1);
            break;
          end;
      end;
  end;

// Ajoute Delta au nombre EN TETE de Valeur, en preservant tout suffixe ("12 (30)" -> "11 (30)"
// pour Delta=-1 ; "4 (vapeur)" -> "5 (vapeur)" pour Delta=+1). Une colonne sans propulsion de
// ce type ("-") ou deja en texte pur ("+2 SL") reste inchangee : les colonnes de profil de
// bateau ne sont PAS de simples entiers (parenthese, "vapeur"/"vent", "-", "+N SL"). 24/09/2026,
// bug releve par Nono (Fore-and-Aft Rudder sur un bateau a rames, M Voile "-" lu comme 0).
function AjusteValeurEnTete(Valeur: String; Delta: Integer): String;
  var
    Ind:  Integer;
    Base: Integer;
  begin
    Result := Valeur;
    if Delta = 0 then exit;
    Valeur := Trim(Valeur);
    Ind := 1;
    while (Ind <= Length(Valeur)) and (Valeur[Ind] in ['0'..'9']) do Inc(Ind);
    if Ind = 1 then exit; // ne commence pas par un chiffre ("-", "+2 SL"...) : rien a ajuster
    Base   := StrToIntDef(Copy(Valeur, 1, Ind - 1), 0);
    Result := IntToStr(Base + Delta) + Copy(Valeur, Ind, Length(Valeur));
  end;

// Meme principe, mais multiplie le nombre en tete par (1 + Facteur) au lieu d'ajouter.
function AjusteValeurProportionnelle(Valeur: String; Facteur: Double): String;
  var
    Ind:  Integer;
    Base: Integer;
  begin
    Result := Valeur;
    if Facteur = 0 then exit;
    Valeur := Trim(Valeur);
    Ind := 1;
    while (Ind <= Length(Valeur)) and (Valeur[Ind] in ['0'..'9']) do Inc(Ind);
    if Ind = 1 then exit;
    Base   := StrToIntDef(Copy(Valeur, 1, Ind - 1), 0);
    Result := IntToStr(Round(Base * (1 + Facteur))) + Copy(Valeur, Ind, Length(Valeur));
  end;

function BoatProfilCalcule(PBateau: StructureTrapping; ListeCodesFittings: String): String;
  var
    Valeurs: TStringArray;
    Crew, MSail, MOar, Man, Size, T, W: String;
    DeltaM:  Integer;
  begin
    Result := PBateau.ProfilBateau;
    if PBateau.ProfilBateau = '' then exit;
    Valeurs := PBateau.ProfilBateau.Split([';']);
    if Length(Valeurs) < 7 then exit;
    Crew  := Valeurs[0];
    MSail := Valeurs[1];
    MOar  := Valeurs[2];
    Man   := Valeurs[3];
    Size  := Valeurs[4];
    T     := Valeurs[5];
    W     := Valeurs[6];

    // Traits deja inscrits sur le bateau (catalogue, Sea of Claws p.96-97) : Armoured N =
    // +10 Toughness par niveau, Sturdy N = +30% Wounds par niveau.
    T := AjusteValeurEnTete(T, 10 * NiveauTraitBateau(PBateau.TraitsAnimal, 'Armoured'));
    W := AjusteValeurProportionnelle(W, 0.3 * NiveauTraitBateau(PBateau.TraitsAnimal, 'Sturdy'));

    // Amenagements confies au bateau (Fore-and-Aft Rudder : M-1 ; Smoothing : M+1) : une seule
    // cible "M", appliquee a la voile ET aux rames - le livre ne precise pas laquelle et un
    // bateau qui n'a que l'une des deux (colonne a "-") ignore l'ajustement de toute facon.
    DeltaM := FabricationModificateurQualite(ListeCodesFittings, ConstXmlModifieBateau, 'M');
    MSail  := AjusteValeurEnTete(MSail, DeltaM);
    MOar   := AjusteValeurEnTete(MOar, DeltaM);

    Result := Crew + ';' + MSail + ';' + MOar + ';' + Man + ';' + Size + ';' + T + ';' + W;
  end;

// Un porteur recoit des objets confies (carriedby) : animal, bateau ou vehicule.
function TrappingEstPorteur(PTrapping: StructureTrapping): Boolean;
begin
  Result := (PTrapping.ProfilAnimal <> '') or (PTrapping.ProfilBateau <> '') or (PTrapping.ProfilVehicule <> '');
end;

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
