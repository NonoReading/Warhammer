unit ChargeRacePhysique;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, UnitCalcul, ChargeRace;

// Details physiques d'une ethnie (bloc SUBCHAPTER_PHYSICAL de DATA_SPECIE) : formule d'age,
// formule de taille en POUCES, et tables de couleur des yeux et des cheveux (2d10).
// CONTEXT.md, chantier "details physiques par ethnie".
Type
  StructureRacePhysique         = record
    CodeRace:                   String;
    Livre:                      String;
    FormuleAge:                 String;
    FormuleTaille:              String;
    // Taille humaine : si l'un des des fait 10, on relance un de et on l'ajoute.
    TailleExplose:              Boolean;
    // Nombre de tirages sur la table des yeux (2 pour les Elfes : couleurs panachees).
    NbTirageYeux:               Integer;
  end;

  StructureRaceCouleur          = record
    CodeRace:                   String;
    Livre:                      String;
    EstYeux:                    Boolean;   // True = yeux, False = cheveux
    Libelle:                    String;    // texte anglais brut, non traduit pour l'instant
    Plage:                      String;    // "2", "5-7"...
  end;

  TListRacePhysique = Specialize TList<StructureRacePhysique>;
  TListRaceCouleur  = Specialize TList<StructureRaceCouleur>;

Var
  ListRacePhysique:   TListRacePhysique;
  ListRaceCouleur:    TListRaceCouleur;
  NbRacePhysique:     Integer;
  NbRaceCouleur:      Integer;

function ChercheRacePhysique(CodeRace: String): StructureRacePhysique;
function RaceSourcePhysique(CodeRace: String): String;
function LanceFormule(Formule: String; Explose: Boolean): Integer;
function TireCouleur(CodeRace: String; Yeux: Boolean; Jet: Integer): String;
function TireDetailsPhysiques(CodeRace: String; out Age: Integer; out Taille: Integer;
                              out Yeux: String; out Cheveux: String): Boolean;
function ConvertitTaille(Valeur: Integer; DeUnite, VersUnite: String): Integer;
function FormateTaille(Valeur: Integer; Unite: String): String;

implementation

function ChercheRacePhysique(CodeRace: String): StructureRacePhysique;
var
  PRacePhysique: StructureRacePhysique;
begin
  // Voir ChercheRaceAttribut : Result n'est pas initialise par Pascal (CONTEXT.md 2.17).
  Result := Default(StructureRacePhysique);
  for PRacePhysique in ListRacePhysique do
    if CompareRechercheValeur(PRacePhysique.CodeRace, CodeRace) then
      begin
        Result := PRacePhysique;
        break;
      end;
end;

// Code de l'ethnie dont on lit les details physiques : l'ethnie elle-meme si elle en porte,
// sinon on remonte a la race (Espece) et on emprunte ceux d'une ethnie de la meme race, celle
// du livre de la race en priorite (meme regle que CheminRaceImage). '' si rien n'est trouve.
function RaceSourcePhysique(CodeRace: String): String;
var
  PRace, PCandidat: StructureRace;
  Espece:           String;
begin
  Result := '';
  if ChercheRacePhysique(CodeRace).CodeRace <> '' then
    begin
      Result := CodeRace;
      Exit;
    end;
  PRace  := ChercheRace(CodeRace);
  Espece := Trim(PRace.Espece);
  if Espece = '' then
    Exit;
  for PCandidat in ListRace do
    begin
      if not CompareRechercheValeur(PCandidat.Espece, Espece) then
        continue;
      if ChercheRacePhysique(PCandidat.CodeRace).CodeRace = '' then
        continue;
      if Result = '' then
        Result := PCandidat.CodeRace;
      if ExtractStringBefore(PCandidat.CodeRace, SeparateurLivre) = ExtractStringBefore(Espece, SeparateurLivre) then
        begin
          Result := PCandidat.CodeRace;
          Exit;
        end;
    end;
end;

// Evalue une formule "15+10d10", "57+2d10", "51+d10" : termes separes par '+', chacun soit
// une constante, soit [N]dM. Si Explose et qu'un de montre sa valeur maximale, UN de
// supplementaire est lance et ajoute (regle du Rulebook p.40 pour la taille humaine).
function LanceFormule(Formule: String; Explose: Boolean): Integer;
var
  Termes:       TStringList;
  I, J, PosD:   Integer;
  Terme:        String;
  NbDes, Faces: Integer;
  Jet:          Integer;
  Maxi:         Boolean;
begin
  Result := 0;
  Maxi   := False;
  Termes := TStringList.Create;
  try
    ExtractStrings(['+'], [' '], PChar(Formule), Termes);
    for I := 0 to Termes.Count - 1 do
      begin
        Terme := LowerCase(Trim(Termes[I]));
        PosD  := Pos('d', Terme);
        if PosD = 0 then
          Result := Result + StrToIntDef(Terme, 0)
        else
          begin
            NbDes := StrToIntDef(Copy(Terme, 1, PosD - 1), 1);
            Faces := StrToIntDef(Copy(Terme, PosD + 1, MaxInt), 0);
            if Faces < 1 then
              Continue;
            for J := 1 to NbDes do
              begin
                Jet    := Random(Faces) + 1;
                Result := Result + Jet;
                if Jet = Faces then
                  Maxi := True;
              end;
            if Explose and Maxi then
              begin
                Result := Result + Random(Faces) + 1;
                Maxi   := False;
              end;
          end;
      end;
  finally
    Termes.Free;
  end;
end;

// Libelle de la ligne dont la plage ("2", "5-7") contient Jet, pour les yeux ou les cheveux.
function TireCouleur(CodeRace: String; Yeux: Boolean; Jet: Integer): String;
var
  PRaceCouleur: StructureRaceCouleur;
  Bas, Haut:    Integer;
  Tiret:        Integer;
begin
  Result := '';
  for PRaceCouleur in ListRaceCouleur do
    if CompareRechercheValeur(PRaceCouleur.CodeRace, CodeRace) and (PRaceCouleur.EstYeux = Yeux) then
      begin
        Tiret := Pos('-', PRaceCouleur.Plage);
        if Tiret = 0 then
          begin
            Bas  := StrToIntDef(PRaceCouleur.Plage, 0);
            Haut := Bas;
          end
        else
          begin
            Bas  := StrToIntDef(Copy(PRaceCouleur.Plage, 1, Tiret - 1), 0);
            Haut := StrToIntDef(Copy(PRaceCouleur.Plage, Tiret + 1, MaxInt), 0);
          end;
        if (Jet >= Bas) and (Jet <= Haut) then
          begin
            Result := PRaceCouleur.Libelle;
            Exit;
          end;
      end;
end;

// Tire age, taille (en pouces), yeux et cheveux d'une ethnie. Faux si l'ethnie n'a aucune
// donnee physique (rien n'est alors modifie). Les yeux des Elfes (NbTirageYeux = 2) sont
// les deux couleurs separees par " / ".
function TireDetailsPhysiques(CodeRace: String; out Age: Integer; out Taille: Integer;
                              out Yeux: String; out Cheveux: String): Boolean;
var
  PRacePhysique: StructureRacePhysique;
  I:             Integer;
  Couleur:       String;
begin
  Age     := 0;
  Taille  := 0;
  Yeux    := '';
  Cheveux := '';
  CodeRace      := RaceSourcePhysique(CodeRace);
  PRacePhysique := ChercheRacePhysique(CodeRace);
  Result := PRacePhysique.CodeRace <> '';
  if not Result then
    Exit;
  Age    := LanceFormule(PRacePhysique.FormuleAge, False);
  Taille := LanceFormule(PRacePhysique.FormuleTaille, PRacePhysique.TailleExplose);
  for I := 1 to PRacePhysique.NbTirageYeux do
    begin
      Couleur := TireCouleur(CodeRace, True, LanceFormule('2d10', False));
      if Couleur <> '' then
        begin
          if Yeux <> '' then
            Yeux := Yeux + ' / ';
          Yeux := Yeux + Couleur;
        end;
    end;
  Cheveux := TireCouleur(CodeRace, False, LanceFormule('2d10', False));
end;

// Passe une taille d'une unite a l'autre (CM / INCH, 1 pouce = 2,54 cm), arrondie a l'entier.
// Unite vide = pouces (fiches enregistrees avant l'unite par fiche).
function ConvertitTaille(Valeur: Integer; DeUnite, VersUnite: String): Integer;
begin
  if DeUnite = '' then
    DeUnite := ConstUniteInch;
  if VersUnite = '' then
    VersUnite := ConstUniteInch;
  if DeUnite = VersUnite then
    Result := Valeur
  else if VersUnite = ConstUniteCm then
    Result := Round(Valeur * 2.54)
  else
    Result := Round(Valeur / 2.54);
end;

// Taille ecrite dans SON unite : 175 cm -> 175 cm ; 69 pouces -> 5'9"
function FormateTaille(Valeur: Integer; Unite: String): String;
begin
  if Unite = ConstUniteCm then
    Result := IntToStr(Valeur) + ' cm'
  else
    Result := IntToStr(Valeur div 12) + '''' + IntToStr(Valeur mod 12) + '"';
end;

end.
