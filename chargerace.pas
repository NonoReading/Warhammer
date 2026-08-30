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

Function CheminRaceImage(CodeRace: String; Indice: String): String;
  var
    PRace:        StructureRace;
    ResTrans:     String;
    ResNormal:    String;
    Res:          String;
  begin
    for PRace in ListRace do
      if CompareRechercheValeur(PRace.CodeRace, CodeRace) then
        Begin
          ResTrans := GetCurrentDir+StringReplace(ConstCheminImageRace, ConstLivre, PRace.Livre, [rfReplaceAll])+CodeValeur+Indice+ConstTransparent+'.PNG';
          ResNormal:= GetCurrentDir+StringReplace(ConstCheminImageRace, ConstLivre, PRace.Livre, [rfReplaceAll])+CodeValeur+Indice+'.PNG';

          if not FileExists(ResTrans) then
            if FileExists(ResNormal) then
              if Not TestPixelZeroZero(ResNormal) then
                RemplacerPixelParTransparent(ResNormal,ResTrans);

          if FileExists(ResTrans) then
            Res    := ResTrans
          else
            Res    := ResNormal;
          break;
        end;
    Result := Res;
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

