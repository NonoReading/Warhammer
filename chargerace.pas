unit ChargeRace;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeTexte, PdfUtils, UnitCalcul,
  ChargeEspece;

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
        // NOMBRE de competences a choisir dans chaque colonne, a ne pas confondre avec
        // Point3/Point5 juste au-dessus qui sont la VALEUR de l'avance (3 et 5).
        // Toutes les races du livre de regles en prennent 3 et 3 ; le Skink de Lustria
        // (p.160) en prend 2 et 2, d'ou ces champs. Defaut 3 si la balise est absente.
        NbPoint3:       Integer;
        NbPoint5:       Integer;
        // Dossier d'icones de niveau propre a cette ethnie, sous \PICTURES\ (ex :
        // 'NIV_HELF'). Vide = dossier generique NIV. Voir CheminNiveauImage.
        DossierNiveau:  String;
  End;

  TListRace = Specialize TList<StructureRace>;

var
  ListRace:     TListRace;
  NbRace:       Integer;

function chercheRace(CodeRace :String): StructureRace;
Function CheminRaceImage(CodeRace: String; Indice: String): String;
Function CheminNiveauDossier(Dossier: String; Niveau: Integer): String;
Function CheminNiveauImage(CodeRace: String; Niveau: Integer): String;

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

// Chemin de l'illustration d'UNE ethnie precise, SANS aucun repli sur une autre.
// Renvoie une chaine VIDE si l'image n'existe pas - c'est ce qui permet a la fonction
// publique ci-dessous de decider s'il faut aller en chercher une ailleurs.
Function CheminRaceImageSeule(PRace: StructureRace; Indice: String): String;
  var
    Dossier:   String;
    ResTrans:  String;
    ResNormal: String;
  begin
    Result   := '';
    // Code COMPLET, avec repli sur l'ancien nom court : voir CheminMetierImage dans
    // ChargeMetier pour le raisonnement. Ici le nom porte en plus l'INDICE de
    // l'illustration - RULES-RACE_HELF1, RULES-RACE_HELF2 - qui reste a la fin.
    Dossier  := GetCurrentDir+StringReplace(ConstCheminImageRace, ConstLivre, PRace.Livre, [rfReplaceAll]);
    ResTrans := Dossier+PRace.CodeRace+Indice+ConstTransparent+'.PNG';
    ResNormal:= Dossier+PRace.CodeRace+Indice+'.PNG';
    if (not FileExists(ResTrans)) and (not FileExists(ResNormal)) then
      begin
        // DecoupeCodeValeur est appelee ICI et relue tout de suite : CodeValeur est une
        // globale, s'y fier apres un autre appel donnerait le code d'une autre entite.
        DecoupeCodeValeur(PRace.CodeRace);
        ResTrans := Dossier+CodeValeur+Indice+ConstTransparent+'.PNG';
        ResNormal:= Dossier+CodeValeur+Indice+'.PNG';
      end;

    if not FileExists(ResTrans) then
      if FileExists(ResNormal) then
        if Not TestPixelZeroZero(ResNormal) then
          RemplacerPixelParTransparent(ResNormal,ResTrans);

    if FileExists(ResTrans) then
      Result := ResTrans
    else if FileExists(ResNormal) then
      Result := ResNormal;
  end;

// Illustration d'une ethnie, avec REPLI SUR L'ETHNIE DE REFERENCE DE SA RACE.
//
// Quinze ethnies n'ont pas d'illustration propre - les onze haut-elfes de High Elf Player's
// Guide, trois naines et une humaine (releve du 31/08/2026). Plutot que de laisser un vide,
// on emprunte l'image d'une autre ethnie de la MEME RACE : un Haut Elfe de Caledor montre
// l'illustration generique des Hauts Elfes.
//
// Quelle ethnie prete son image ? Celle dont le code porte le MEME PREFIXE DE LIVRE que la
// race elle-meme. La race etant declaree par le livre de base, cela designe naturellement
// l'ethnie du Rulebook, sans avoir a ecrire "RULES" en dur - et cela continuerait de
// fonctionner si un supplement definissait un jour sa propre race. A defaut, la premiere
// ethnie de la race qui possede une image.
//
// L'INDICE EST CONSERVE : une ethnie sans image demandant l'illustration 2 recevra la 2 de
// sa reference, pas la 1. Si la reference n'a pas cet indice-la non plus, on renvoie vide,
// et l'appelant - qui teste toujours FileExists - n'affiche simplement rien.
//
// Ce repli ne peut PAS changer l'affichage d'une ethnie du livre de base : il ne se
// declenche que lorsque l'ethnie demandee n'a aucune image, ce qui n'est le cas d'aucune
// ethnie du Rulebook.
Function CheminRaceImage(CodeRace: String; Indice: String): String;
  var
    PRace:      StructureRace;
    PCandidat:  StructureRace;
    Trouve:     Boolean = false;
    Espece:     String;
    PrefixRace: String;
    Secours:    String = '';
    Chemin:     String;
  begin
    Result := '';
    for PRace in ListRace do
      if CompareRechercheValeur(PRace.CodeRace, CodeRace) then
        begin
          Trouve := true;
          break;
        end;
    if not Trouve then
      Exit;

    Result := CheminRaceImageSeule(PRace, Indice);
    if Result <> '' then
      Exit;

    Espece := Trim(PRace.Espece);
    if Espece = '' then
      Exit;
    PrefixRace := ExtractStringBefore(Espece, SeparateurLivre);

    for PCandidat in ListRace do
      begin
        if CompareRechercheValeur(PCandidat.CodeRace, PRace.CodeRace) then
          continue;
        if not CompareRechercheValeur(PCandidat.Espece, Espece) then
          continue;
        Chemin := CheminRaceImageSeule(PCandidat, Indice);
        if Chemin = '' then
          continue;
        // l'ethnie du meme livre que la race est LA reference : on s'arrete la
        if ExtractStringBefore(PCandidat.CodeRace, SeparateurLivre) = PrefixRace then
          begin
            Result := Chemin;
            Exit;
          end;
        if Secours = '' then
          Secours := Chemin;
      end;

    Result := Secours;
  end;

// Construit le chemin d'une icone de niveau a partir d'un NOM DE DOSSIER. Deux replis
// successifs sur \PICTURES\NIV\ : dossier vide, et fichier absent - une ethnie peut ne
// redefinir que quelques niveaux, et les niveaux 6 et 7 n'ont pas de version elfique.
// C'est le seul endroit qui sait fabriquer ce chemin ; ChargeMetier s'en sert aussi.
Function CheminNiveauDossier(Dossier: String; Niveau: Integer): String;
  var
    Res: String;
  begin
    // Result est affecte AVANT toute recherche, pour ne jamais renvoyer la valeur d'un
    // appel precedent (piege des fonctions Cherche*).
    Result := GetCurrentDir + ConstCheminImageNiveau + IntToStr(Niveau) + '.PNG';
    if Trim(Dossier) = '' then
      Exit;
    Res := GetCurrentDir + ConstCheminImageNiveauRacine + Trim(Dossier) + '\' + IntToStr(Niveau) + '.PNG';
    if FileExists(Res) then
      Result := Res;
  end;

// Icone de niveau vue depuis une ETHNIE : son propre dossier d'abord, celui de sa RACE
// ensuite, le dossier generique en dernier. Le repli par la race evite d'avoir a poser la
// balise sur chacune des onze ethnies d'une meme race.
Function CheminNiveauImage(CodeRace: String; Niveau: Integer): String;
  var
    PRace:      StructureRace;
    Dossier:    String = '';
    Espece:     String = '';
  begin
    for PRace in ListRace do
      if CompareRechercheValeur(PRace.CodeRace, CodeRace) then
        begin
          Dossier := Trim(PRace.DossierNiveau);
          Espece  := PRace.Espece;
          break;
        end;

    if (Dossier = '') and (Espece <> '') then
      Dossier := Trim(ChercheEspece(Espece).DossierNiveau);

    Result := CheminNiveauDossier(Dossier, Niveau);
  end;

end.

