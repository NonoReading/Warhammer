unit ChargeMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeTexte, PdfUtils, FileUtil, Unitcalcul,
  ChargeRace;

Type
  StructureMetier	= Record
  	CodeMetier:	String;
  	Libelle:	String;
  	LibelleGroupe:	String;
        Description:	String;
        Livre:          String;
        CodeCompetence: String;
        // Dossier d'icones de niveau propre a ce metier, sous \PICTURES\. C'est le seul
        // recours dans WinMetier, qui affiche un metier sans savoir quelle ethnie le joue.
        // Vide = dossier generique NIV.
        DossierNiveau:  String;
        // Carriere dont celle-ci est la SUITE, vide dans la quasi-totalite des cas. Un ou
        // plusieurs codes de metier separes par SeparateurMulti. Ce champ ne dit PAS a lui
        // seul que le metier est inaccessible : c'est ChercheMinMetierNiveau > 1 qui le
        // dit. Les deux vont ensemble - un parent sans niveau minimum n'aurait aucun effet,
        // un niveau minimum sans parent rendrait le metier definitivement inatteignable.
        MetierParent:   String;
  End;

  TListMetier = specialize TList<StructureMetier>;

var
  ListMetier:     TListMetier;
  NbMetier:       Integer;

function chercheMetier(CodeMetier :String): StructureMetier;
Function CheminMetierImage(CodeMetier: String): String;
Function DossierNiveauMetier(CodeMetier: String): String;
Function CheminNiveauImageMetier(CodeMetier: String; Niveau: Integer): String;
Function CheminNiveauImageMetierRace(CodeMetier: String; CodeRace: String; Niveau: Integer): String;
Function EstMetierEnfantDe(CodeMetier: String; CodeParent: String): Boolean;

implementation


function ChercheMetier(CodeMetier :String): StructureMetier;
Var
  PMetier:  StructureMetier;
  PVide:    StructureMetier;
  Trouve:   Boolean;
Begin
  for PMetier in ListMetier do
    if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
      begin
        Result := PMetier;
        Trouve := true;
        break;
      end;
  if not trouve then
    begin
      PVide.Libelle := GetTexteLibelle('LAB_138');
      result:= PVide;
    end;
end;

Function CheminMetierImage(CodeMetier: String): String;
  var
    PMetier:        StructureMetier;
    ResTrans:     String;
    ResNormal:    String;
    Res:          String;
    Dossier:      String;
  begin
    for PMetier in ListMetier do
      if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
        Begin
          // NOM DE FICHIER = CODE COMPLET, prefixe de livre inclus. Tous les livres
          // partagent un seul dossier ; nommer les images sur le code AMPUTE (CodeValeur)
          // interdisait a deux livres d'avoir chacun leur WORK001 et forcait la numerotation
          // continue entre supplements.
          //
          Dossier   := GetCurrentDir+StringReplace(ConstCheminImageMetier, ConstLivre, PMetier.Livre, [rfReplaceAll]);
          ResTrans  := Dossier+PMetier.CodeMetier+ConstTransparent+'.PNG';
          ResNormal := Dossier+PMetier.CodeMetier+'.PNG';
          if not FileExists(ResTrans) then
            if FileExists(ResNormal) then
              if (Not TestPixelZeroZero(ResNormal)) then
                RemplacerPixelParTransparent(ResNormal,ResTrans);

          if FileExists(ResTrans) then
            Res    := ResTrans
          else
            Res    := ResNormal;

          break;
        end;
    Result := Res;
  end;

// Dossier declare par un METIER, chaine vide s'il n'en declare pas.
Function DossierNiveauMetier(CodeMetier: String): String;
  var
    PMetier:  StructureMetier;
  begin
    Result := '';
    for PMetier in ListMetier do
      if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
        begin
          Result := Trim(PMetier.DossierNiveau);
          break;
        end;
  end;

// Icone de niveau vue depuis un METIER SEUL. C'est le cas de WinMetier, qui affiche un
// metier sans savoir quelle ethnie le joue - la branche "Possible species" en liste
// souvent plusieurs.
Function CheminNiveauImageMetier(CodeMetier: String; Niveau: Integer): String;
  begin
    Result := CheminNiveauDossier(DossierNiveauMetier(CodeMetier), Niveau);
  end;

// Resolution complete pour une vue qui connait A LA FOIS le metier et l'ethnie, comme la
// fiche de personnage. LE METIER L'EMPORTE, et la raison n'est pas esthetique : un metier
// ne declare un dossier que s'il vient d'un livre, et il n'existe que si ce livre est
// charge. Sa declaration prouve donc que le supplement est actif, ce que l'ethnie seule ne
// dit pas. Si le metier ne declare rien, on retombe sur l'ethnie, puis sa race, puis le
// dossier generique.
Function CheminNiveauImageMetierRace(CodeMetier: String; CodeRace: String; Niveau: Integer): String;
  var
    Dossier: String;
  begin
    Dossier := DossierNiveauMetier(CodeMetier);
    if Dossier <> '' then
      Result := CheminNiveauDossier(Dossier, Niveau)
    else
      Result := CheminNiveauImage(CodeRace, Niveau);
  end;

// Vrai si CodeMetier declare CodeParent parmi ses carrieres parentes. Le champ MetierParent
// peut en contenir plusieurs, separees par SeparateurMulti - d'ou le decoupage plutot qu'une
// simple egalite, qui ferait repondre "non" a un metier dont le parent cherche n'est pas le
// premier de la liste.
//
// Un metier sans parent - l'immense majorite - sort immediatement : cette fonction est
// appelee sur TOUS les metiers charges a chaque ouverture de la combo.
Function EstMetierEnfantDe(CodeMetier: String; CodeParent: String): Boolean;
  var
    PMetier: StructureMetier;
    Liste:   TStringList;
    Ind:     Integer;
  begin
    Result  := false;
    if (Trim(CodeMetier) = '') or (Trim(CodeParent) = '') then
      Exit;
    PMetier := ChercheMetier(CodeMetier);
    if Trim(PMetier.MetierParent) = '' then
      Exit;
    Liste := TStringList.Create;
    try
      ExtractStrings([SeparateurMulti], [], PChar(PMetier.MetierParent), Liste);
      for Ind := 0 to Liste.Count - 1 do
        if CompareRechercheValeur(Trim(Liste[Ind]), CodeParent) then
          begin
            Result := true;
            break;
          end;
    finally
      Liste.Free;
    end;
  end;

end.
