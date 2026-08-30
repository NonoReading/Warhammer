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
  begin
    for PMetier in ListMetier do
      if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
        Begin
          ResTrans  := GetCurrentDir+StringReplace(ConstCheminImageMetier, ConstLivre, PMetier.Livre, [rfReplaceAll])+CodeValeur+ConstTransparent+'.PNG';
          ResNormal := GetCurrentDir+StringReplace(ConstCheminImageMetier, ConstLivre, PMetier.Livre, [rfReplaceAll])+CodeValeur+'.PNG';
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

end.
