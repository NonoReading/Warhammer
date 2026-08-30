unit ChargeMetierNiveau;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, UnitCalcul;

Type
  StructureMetierNiveau	= Record
  	CodeMetier:	String;
  	NiveauMetier:	Integer;
  	Libelle:	String;
        SalaireMetier:  String;
        Livre:          String;
  End;

  TListMetierNiveau = Specialize TList<StructureMetierNiveau>;

var
  ListMetierNiveau:     TListMetierNiveau;
  NbMetierNiveau:       Integer;

function ChercheMetierNiveau(CodeMetier :String; NiveauMetier: Integer): StructureMetierNiveau;
function ChercheMaxMetierNiveau(CodeMetier :String): Integer;
function MaxNiveauMetier(): Integer;
function MaxIndiceIconeNiveau(): Integer;

implementation

function ChercheMetierNiveau(CodeMetier :String; NiveauMetier: Integer): StructureMetierNiveau;
var
  PMetierNiveau:        StructureMetierNiveau;
Begin
  For PMetierNiveau in ListMetierNiveau do
    if (CompareRechercheValeur(PMetierNiveau.CodeMetier, CodeMetier) = True) and (PMetierNiveau.NiveauMetier = NiveauMetier) then
      begin
       Result := PMetierNiveau;
       break;
      end;
end;

function ChercheMaxMetierNiveau(CodeMetier :String): Integer;
var
  PMetierNiveau:        StructureMetierNiveau;
  MaxNiveau:            Integer = 0;
Begin
  For PMetierNiveau in ListMetierNiveau do
    if (PMetierNiveau.CodeMetier = CodeMetier) and (PMetierNiveau.NiveauMetier > MaxNiveau) then
      MaxNiveau := PMetierNiveau.NiveauMetier;
  Result := MaxNiveau;
end;

// Nombre maximum de niveaux parmi TOUS les metiers charges, toutes editions confondues.
// Sert a dimensionner ce qui etait jusqu'ici fige a 4 : listes d'icones, tableaux de
// couleurs, hauteur de la grille des niveaux. Un livre qui apporte une carriere a 5 niveaux
// - le Mage de High Elf Player's Guide - fait donc grandir l'affichage tout seul, sans
// qu'aucune constante ne soit a retoucher.
//
// PLANCHER A 4 : c'est la valeur historique de toutes les carrieres du livre de base. Le
// garder evite qu'un chargement partiel, ou une liste pas encore remplie au moment ou une
// fenetre se cree, ne reduise l'affichage en dessous de ce qui a toujours existe.
function MaxNiveauMetier(): Integer;
var
  PMetierNiveau:        StructureMetierNiveau;
Begin
  Result := 4;
  if not Assigned(ListMetierNiveau) then
    Exit;
  For PMetierNiveau in ListMetierNiveau do
    if PMetierNiveau.NiveauMetier > Result then
      Result := PMetierNiveau.NiveauMetier;
end;

// Plus grand indice a charger dans les listes d'images des fenetres. C'est le plus grand
// des deux :
//   - le niveau de carriere le plus haut de la base (MaxNiveauMetier ci-dessus) ;
//   - le plus haut fichier N.PNG present dans PICTURES\NIV\.
// La seconde borne existe parce que ce dossier NE CONTIENT PAS QUE DES NIVEAUX : les
// fichiers 5, 6 et 7 y sont des pastilles de couleur - rouge, vert, gris - rangees au-dela
// du dernier niveau et utilisees comme indices d'image par les grilles. Se limiter aux
// seuls niveaux les faisait disparaitre.
// La boucle ne s'arrete PAS au premier trou : si 5 et 7 existent mais pas 6, on va bien
// jusqu'a 7, et le chargeur de chaque fenetre ajoute une image neutre pour le 6 manquant
// afin que les indices ne se decalent pas.
function MaxIndiceIconeNiveau(): Integer;
var
  Ind: Integer;
Begin
  Result := MaxNiveauMetier();
  for Ind := Result + 1 to 20 do
    if FileExists(GetCurrentDir + ConstCheminImageNiveau + IntToStr(Ind) + '.PNG') then
      Result := Ind;
end;


end.

