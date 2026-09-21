unit ChargeSigneAstral;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Generics.Collections, UnitCalcul, ChargeAttribut, ChargeTalent;

// Signes astraux (Archives of the Empire II p.39-50) : systeme optionnel de creation. Un signe
// se tire au d100 et donne des modificateurs de caracteristiques (+2 / -3) ou un talent.
// Le Witchling Star porte des variantes (sous-tirage d10) : chaque variante a sa plage.
// CONTEXT.md, chantier "signes astraux".
Type
  StructureSigneAstral          = record
    Livre:                      String;
    CodeSigne:                  String;
    Libelle:                    String;
    Titre:                      String;
    NomClassique:               String;
    Ascendant:                  String;
    Dates:                      String;
    Dieu:                       String;
    Apparence:                  String;
    Plage:                      String;   // tranche du d100 : "01-05", "96-00" (00 = 100)
  end;

  // Un effet d'un signe : soit un modificateur de caracteristique (CodeAttribut + Valeur),
  // soit un talent (CodeTalent). Variante = plage du sous-tirage d10, vide si le signe n'en a pas.
  StructureSigneEffet           = record
    Livre:                      String;
    CodeSigne:                  String;
    Variante:                   String;
    CodeAttribut:               String;
    Valeur:                     Integer;
    CodeTalent:                 String;
  end;

  TListSigneAstral = Specialize TList<StructureSigneAstral>;
  TListSigneEffet  = Specialize TList<StructureSigneEffet>;

Var
  ListSigneAstral:    TListSigneAstral;
  ListSigneEffet:     TListSigneEffet;
  NbSigneAstral:      Integer;
  NbSigneEffet:       Integer;

function ChercheSigneAstral(CodeSigne: String): StructureSigneAstral;
function SigneAstralPlageContient(Plage: String; Jet: Integer): Boolean;
function TireSigneAstral(out Jet: Integer): String;
function SigneAstralAttributModif(CodeSigne, Variante, Attribut: String): Integer;
function SigneAstralTireVariante(CodeSigne: String): String;
function SigneAstralTexteEffets(CodeSigne, Variante: String): String;
function SigneAstralTextePdf(CodeSigne, Variante: String): String;
function ResumeSigneAstral(CodeSigne, Variante: String): String;

implementation

// "01-05" -> 1 a 5 ; "10" -> 10 ; une borne haute a 0 vaut 100 ("96-00").
function SigneAstralPlageContient(Plage: String; Jet: Integer): Boolean;
  var
    Ind:      Integer;
    Bas:      Integer;
    Haut:     Integer;
  begin
    Ind := Pos('-', Plage);
    if Ind > 0 then
      begin
        Bas  := StrToIntDef(Copy(Plage, 1, Ind - 1), -1);
        Haut := StrToIntDef(Copy(Plage, Ind + 1, Length(Plage)), -1);
      end
    else
      begin
        Bas  := StrToIntDef(Plage, -1);
        Haut := Bas;
      end;
    if Haut = 0 then
      Haut := 100;
    Result := (Bas > 0) and (Jet >= Bas) and (Jet <= Haut);
  end;

function ChercheSigneAstral(CodeSigne: String): StructureSigneAstral;
  var
    PSigne: StructureSigneAstral;
  begin
    Result := Default(StructureSigneAstral);
    for PSigne in ListSigneAstral do
      if PSigne.CodeSigne = CodeSigne then
        begin
          Result := PSigne;
          Exit;
        end;
  end;

// Tire un d100 et renvoie le code du signe correspondant ('' si aucune table n'est chargee).
function TireSigneAstral(out Jet: Integer): String;
  var
    PSigne: StructureSigneAstral;
  begin
    Result := '';
    Jet    := Random(100) + 1;
    for PSigne in ListSigneAstral do
      if SigneAstralPlageContient(PSigne.Plage, Jet) then
        begin
          Result := PSigne.CodeSigne;
          Exit;
        end;
  end;

// Somme des modificateurs de caracteristique du signe pour un Attribut. Un effet de variante ne
// compte que si sa plage est celle du sous-tirage retenu (Variante) ; un effet sans variante compte
// toujours. Calcule au vol depuis le code du signe : rien n'est stocke sur la fiche.
function SigneAstralAttributModif(CodeSigne, Variante, Attribut: String): Integer;
  var
    PEffet: StructureSigneEffet;
  begin
    Result := 0;
    if CodeSigne = '' then
      Exit;
    for PEffet in ListSigneEffet do
      if (PEffet.CodeSigne = CodeSigne) and (PEffet.CodeAttribut <> '')
         and ((PEffet.Variante = '') or (PEffet.Variante = Variante))
         and CompareRechercheValeur(PEffet.CodeAttribut, Attribut) then
        Result := Result + PEffet.Valeur;
  end;

// Sous-tirage d10 d'un signe qui porte des variantes (Witchling Star) : renvoie la plage retenue,
// vide si le signe n'en a pas.
function SigneAstralTireVariante(CodeSigne: String): String;
  var
    PEffet: StructureSigneEffet;
    Jet:    Integer;
  begin
    Result := '';
    Jet    := Random(10) + 1;
    for PEffet in ListSigneEffet do
      if (PEffet.CodeSigne = CodeSigne) and (PEffet.Variante <> '') and SigneAstralPlageContient(PEffet.Variante, Jet) then
        begin
          Result := PEffet.Variante;
          Exit;
        end;
  end;

// "Fel +2, I +2, Int -3" : les modificateurs de caracteristiques du signe (talents exclus).
function SigneAstralTexteEffets(CodeSigne, Variante: String): String;
  var
    PEffet: StructureSigneEffet;
  begin
    Result := '';
    for PEffet in ListSigneEffet do
      if (PEffet.CodeSigne = CodeSigne) and (PEffet.CodeAttribut <> '')
         and ((PEffet.Variante = '') or (PEffet.Variante = Variante)) then
        Result := Result + IfThen(Result = '', '', ', ') + ChercheAttribut(PEffet.CodeAttribut).Resume + ' '
                  + IfThen(PEffet.Valeur > 0, '+', '') + IntToStr(PEffet.Valeur);
  end;

// Texte court pour une ligne de PDF : les modificateurs, ou le titre du signe s'il n'en a pas
// (les signes a talent : le talent a deja sa propre ligne).
function SigneAstralTextePdf(CodeSigne, Variante: String): String;
  begin
    Result := SigneAstralTexteEffets(CodeSigne, Variante);
    if Result = '' then
      Result := ChercheSigneAstral(CodeSigne).Titre;
  end;

// Fiche complete d'un signe (ecran de creation, info-bulle de WinPersonnage).
function ResumeSigneAstral(CodeSigne, Variante: String): String;
  var
    PSigne:  StructureSigneAstral;
    PEffet:  StructureSigneEffet;
    PTalent: StructureTalent;
    Effets:  String;
    Talents: String;
    Libelle: String;
  begin
    Result := '';
    PSigne := ChercheSigneAstral(CodeSigne);
    if PSigne.CodeSigne = '' then
      Exit;
    Effets  := SigneAstralTexteEffets(CodeSigne, Variante);
    Talents := '';
    for PEffet in ListSigneEffet do
      if (PEffet.CodeSigne = CodeSigne) and (PEffet.CodeTalent <> '')
         and ((PEffet.Variante = '') or (PEffet.Variante = Variante)) then
        begin
          PTalent := ChercheTalent(PEffet.CodeTalent);
          Libelle := PTalent.Libelle;
          if Libelle = '' then
            Libelle := PEffet.CodeTalent;
          Talents := Talents + IfThen(Talents = '', '', ', ') + Libelle;
        end;
    Result := PSigne.Libelle + ' - ' + PSigne.Titre + LineEnding
            + PSigne.NomClassique + ' - ' + PSigne.Ascendant + ' (' + PSigne.Dates + ')' + LineEnding
            + PSigne.Dieu + ' - ' + PSigne.Apparence;
    if Effets <> '' then
      Result := Result + LineEnding + Effets;
    if Talents <> '' then
      Result := Result + LineEnding + Talents;
  end;

end.
