unit ChargeRacePhysique;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, ChargeConstantes, Generics.Collections, UnitCalcul, ChargeRace;

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

  // Noms d'une ethnie (bloc SUBCHAPTER_NAMES) : une entree de table (Partie = "First", "Forename"...,
  // Sexe = M / F / vide, Plage = tranche du de) et un modele d'assemblage ("First+Second?+End").
  StructureRaceNom              = record
    CodeRace:                   String;
    Livre:                      String;
    Partie:                     String;
    Sexe:                       String;
    Libelle:                    String;
    Plage:                      String;
  end;

  StructureRaceNomModele        = record
    CodeRace:                   String;
    Livre:                      String;
    Sexe:                       String;
    Modele:                     String;
    Noble:                      Boolean;   // modele reserve aux nobles
  end;

  TListRacePhysique = Specialize TList<StructureRacePhysique>;
  TListRaceCouleur  = Specialize TList<StructureRaceCouleur>;
  TListRaceNom      = Specialize TList<StructureRaceNom>;
  TListRaceNomModele = Specialize TList<StructureRaceNomModele>;

Var
  ListRacePhysique:   TListRacePhysique;
  ListRaceCouleur:    TListRaceCouleur;
  NbRacePhysique:     Integer;
  NbRaceCouleur:      Integer;
  ListRaceNom:        TListRaceNom;
  ListRaceNomModele:  TListRaceNomModele;
  NbRaceNom:          Integer;
  NbRaceNomModele:    Integer;

function ChercheRacePhysique(CodeRace: String): StructureRacePhysique;
function RaceSourcePhysique(CodeRace: String): String;
function LanceFormule(Formule: String; Explose: Boolean): Integer;
function TireCouleur(CodeRace: String; Yeux: Boolean; Jet: Integer): String;
function TireDetailsPhysiques(CodeRace: String; out Age: Integer; out Taille: Integer;
                              out Yeux: String; out Cheveux: String): Boolean;
function ConvertitTaille(Valeur: Integer; DeUnite, VersUnite: String): Integer;
function FormateTaille(Valeur: Integer; Unite: String): String;
function EthnieANoms(CodeRace: String): Boolean;
function RaceSourceNom(CodeRace, Partie: String): String;
function RaceANoms(CodeRace: String): Boolean;
function TireNom(CodeRace, Sexe: String; Noble: Boolean = False): String;

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

// Vrai si l'ethnie porte au moins une entree de la partie (Partie = '#' : un modele d'assemblage).
function EthnieAPartieNom(CodeRace, Partie: String): Boolean;
var
  PNom:    StructureRaceNom;
  PModele: StructureRaceNomModele;
begin
  Result := False;
  if Partie = '#' then
    begin
      for PModele in ListRaceNomModele do
        if CompareRechercheValeur(PModele.CodeRace, CodeRace) then
          Exit(True);
    end
  else
    for PNom in ListRaceNom do
      if CompareRechercheValeur(PNom.CodeRace, CodeRace) and (PNom.Partie = Partie) then
        Exit(True);
end;

// Vrai si l'ethnie porte elle-meme des donnees de noms (modele ou table), quelle qu'en soit la partie.
function EthnieANoms(CodeRace: String): Boolean;
var
  PNom: StructureRaceNom;
begin
  Result := EthnieAPartieNom(CodeRace, '#');
  if Result then
    Exit;
  for PNom in ListRaceNom do
    if CompareRechercheValeur(PNom.CodeRace, CodeRace) then
      Exit(True);
end;

// Ethnie dont on lit la partie de nom : l'ethnie elle-meme si elle la porte, sinon une ethnie de la
// meme race (Espece), en preferant celle du meme livre que l'ethnie demandee (les trois ethnies
// norses de Sea of Claws se partagent ainsi une seule liste), puis celle du livre de la race.
// Chaque partie se cherche separement : le modele et les clans peuvent venir du Rulebook, les
// prenoms d'un autre livre. '' si rien n'est trouve.
function RaceSourceNom(CodeRace, Partie: String): String;
var
  PRace, PCandidat: StructureRace;
  Espece:           String;
  LivreEthnie, LivreEspece, LivreCandidat: String;
  MemeLivreEspece:  String;
begin
  Result := '';
  if EthnieAPartieNom(CodeRace, Partie) then
    begin
      Result := CodeRace;
      Exit;
    end;
  PRace  := ChercheRace(CodeRace);
  Espece := Trim(PRace.Espece);
  if Espece = '' then
    Exit;
  LivreEthnie     := ExtractStringBefore(CodeRace, SeparateurLivre);
  LivreEspece     := ExtractStringBefore(Espece, SeparateurLivre);
  MemeLivreEspece := '';
  for PCandidat in ListRace do
    begin
      if not CompareRechercheValeur(PCandidat.Espece, Espece) then
        continue;
      if not EthnieAPartieNom(PCandidat.CodeRace, Partie) then
        continue;
      LivreCandidat := ExtractStringBefore(PCandidat.CodeRace, SeparateurLivre);
      if LivreCandidat = LivreEthnie then
        begin
          Result := PCandidat.CodeRace;
          Exit;
        end;
      if (LivreCandidat = LivreEspece) and (MemeLivreEspece = '') then
        MemeLivreEspece := PCandidat.CodeRace;
      if Result = '' then
        Result := PCandidat.CodeRace;
    end;
  if MemeLivreEspece <> '' then
    Result := MemeLivreEspece;
end;

function RaceANoms(CodeRace: String): Boolean;
begin
  Result := RaceSourceNom(CodeRace, '#') <> '';
end;

// Borne haute d'une plage "2", "5-7" : c'est aussi la taille du de de la partie.
function BorneHautePlage(Plage: String): Integer;
var
  Tiret: Integer;
begin
  Tiret := Pos('-', Plage);
  if Tiret = 0 then
    Result := StrToIntDef(Plage, 0)
  else
    Result := StrToIntDef(Copy(Plage, Tiret + 1, MaxInt), 0);
end;

function PlageContient(Plage: String; Jet: Integer): Boolean;
var
  Tiret: Integer;
  Bas:   Integer;
begin
  Tiret := Pos('-', Plage);
  if Tiret = 0 then
    Bas := StrToIntDef(Plage, 0)
  else
    Bas := StrToIntDef(Copy(Plage, 1, Tiret - 1), 0);
  Result := (Jet >= Bas) and (Jet <= BorneHautePlage(Plage));
end;

// Coupe Texte aux Sep, sans rien interpreter (ExtractStrings traiterait les ' du modele comme
// des guillemets) ; les morceaux vides sont ignores.
procedure Decoupe(Texte: String; Sep: Char; Liste: TStringList);
var
  Debut, I: Integer;
begin
  Liste.Clear;
  Debut := 1;
  for I := 1 to Length(Texte) + 1 do
    if (I > Length(Texte)) or (Texte[I] = Sep) then
      begin
        if I > Debut then
          Liste.Add(Copy(Texte, Debut, I - Debut));
        Debut := I + 1;
      end;
end;

// "Gert(r)a" : la lettre entre parentheses est tiree a pile ou face ; "Brond(I)" -> Brond ou Brondi.
function ResoutVariantes(Nom: String): String;
var
  Ouvre, Ferme: Integer;
  Interieur:    String;
  Variantes:    TStringList;
begin
  Result := Nom;
  // "Adam/Adamar/Adhemar" : une des variantes au hasard
  if Pos('/', Result) > 0 then
    begin
      Variantes := TStringList.Create;
      try
        Decoupe(Result, '/', Variantes);
        if Variantes.Count > 0 then
          Result := Variantes[Random(Variantes.Count)];
      finally
        Variantes.Free;
      end;
    end;
  repeat
    Ouvre := Pos('(', Result);
    Ferme := Pos(')', Result);
    if (Ouvre = 0) or (Ferme < Ouvre) then
      Break;
    Interieur := Copy(Result, Ouvre + 1, Ferme - Ouvre - 1);
    if Length(Interieur) = 1 then
      Interieur := LowerCase(Interieur);
    if Random(2) = 0 then
      Interieur := '';
    Result := Copy(Result, 1, Ouvre - 1) + Interieur + Copy(Result, Ferme + 1, MaxInt);
  until False;
end;

// Tire une entree de la partie dans l'ethnie source. Sexe = M / F : ne garde que les entrees
// de ce sexe et celles sans sexe. La taille du de est la plus haute borne des entrees gardees.
function TireNomPartie(CodeRace, Partie, Sexe: String): String;
var
  Source: String;
  PNom:   StructureRaceNom;
  Maxi:   Integer;
  Jet:    Integer;
begin
  Result := '';
  Source := RaceSourceNom(CodeRace, Partie);
  if Source = '' then
    Exit;
  Maxi := 0;
  for PNom in ListRaceNom do
    if CompareRechercheValeur(PNom.CodeRace, Source) and (PNom.Partie = Partie)
       and ((PNom.Sexe = '') or (PNom.Sexe = Sexe)) and (BorneHautePlage(PNom.Plage) > Maxi) then
      Maxi := BorneHautePlage(PNom.Plage);
  if Maxi < 1 then
    Exit;
  Jet := Random(Maxi) + 1;
  for PNom in ListRaceNom do
    if CompareRechercheValeur(PNom.CodeRace, Source) and (PNom.Partie = Partie)
       and ((PNom.Sexe = '') or (PNom.Sexe = Sexe)) and PlageContient(PNom.Plage, Jet) then
      begin
        Result := ResoutVariantes(PNom.Libelle);
        Exit;
      end;
end;

// Un modele au hasard parmi ceux de l'ethnie source pour ce sexe et cet etat (Noble) ; a defaut de
// modele du sexe, un modele sans sexe. '' si aucun.
function ChoisitModeleNom(Source, Sexe: String; Noble: Boolean): String;
var
  PModele:            StructureRaceNomModele;
  ModeleSexe, ModeleSans: String;
  NbSexe, NbSans:     Integer;
begin
  ModeleSexe := '';
  ModeleSans := '';
  NbSexe     := 0;
  NbSans     := 0;
  for PModele in ListRaceNomModele do
    if CompareRechercheValeur(PModele.CodeRace, Source) and (PModele.Noble = Noble) then
      begin
        if PModele.Sexe = Sexe then
          begin
            Inc(NbSexe);
            if Random(NbSexe) = 0 then
              ModeleSexe := PModele.Modele;
          end
        else if PModele.Sexe = '' then
          begin
            Inc(NbSans);
            if Random(NbSans) = 0 then
              ModeleSans := PModele.Modele;
          end;
      end;
  if NbSexe > 0 then
    Result := ModeleSexe
  else
    Result := ModeleSans;
end;

// Assemble un nom selon le modele de l'ethnie (celui du sexe demande, sinon celui sans sexe).
// Modele : mots separes par des espaces ; un mot = elements separes par '+' ; un element est une
// partie ("Forename"), une partie d'un sexe impose ("Forename:M"), un texte fixe ('sson') ou
// l'un de ces elements suivi de '?' (present une fois sur deux). Un mot dont une partie
// obligatoire est introuvable (livre absent) est laisse de cote. Sexe vide : tire au hasard.
function TireNom(CodeRace, Sexe: String; Noble: Boolean = False): String;
var
  Source, Modele, Mot, Element, Partie, SexePartie, Valeur, Morceau: String;
  Mots, Elements: TStringList;
  I, J, Deux: Integer;
  Facultatif, Manque: Boolean;
begin
  Result := '';
  Source := RaceSourceNom(CodeRace, '#');
  if Source = '' then
    Exit;
  if Sexe = '' then
    Sexe := IfThen(Random(2) = 0, 'M', 'F');
  // Plusieurs modeles possibles (ex. Nains : prenom du livre ou prefixe + suffixe) : un seul est
  // tire, au hasard, parmi ceux du sexe demande (a defaut, parmi ceux sans sexe). Un noble prend
  // d'abord les modeles marques noble ; sans eux (ou pour un roturier), les modeles ordinaires.
  Modele := ChoisitModeleNom(Source, Sexe, Noble);
  if (Modele = '') and Noble then
    Modele := ChoisitModeleNom(Source, Sexe, False);
  if Modele = '' then
    Exit;
  Mots     := TStringList.Create;
  Elements := TStringList.Create;
  try
    Decoupe(Modele, ' ', Mots);
    for I := 0 to Mots.Count - 1 do
      begin
        Mot    := '';
        Manque := False;
        Elements.Clear;
        Decoupe(Mots[I], '+', Elements);
        for J := 0 to Elements.Count - 1 do
          begin
            Element    := Elements[J];
            Facultatif := (Element <> '') and (Element[Length(Element)] = '?');
            if Facultatif then
              Delete(Element, Length(Element), 1);
            if Facultatif and (Random(2) = 0) then
              Continue;
            if (Length(Element) >= 2) and (Element[1] = '''') then
              Morceau := StringReplace(Copy(Element, 2, Length(Element) - 2), '_', ' ', [rfReplaceAll])
            else
              begin
                Deux       := Pos(':', Element);
                SexePartie := Sexe;
                Partie     := Element;
                if Deux > 0 then
                  begin
                    Partie     := Copy(Element, 1, Deux - 1);
                    SexePartie := Copy(Element, Deux + 1, MaxInt);
                  end;
                Valeur := TireNomPartie(CodeRace, Partie, SexePartie);
                if Valeur = '' then
                  begin
                    Manque := True;
                    Break;
                  end;
                Morceau := Valeur;
              end;
            Mot := Mot + Morceau;
          end;
        if Manque or (Mot = '') then
          Continue;
        if Result <> '' then
          Result := Result + ' ';
        Result := Result + Mot;
      end;
  finally
    Elements.Free;
    Mots.Free;
  end;
end;

end.
