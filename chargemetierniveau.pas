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
function ChercheMinMetierNiveau(CodeMetier :String): Integer;
function MaxNiveauMetier(): Integer;
function MaxIndiceIconeNiveau(): Integer;

implementation

function ChercheMetierNiveau(CodeMetier :String; NiveauMetier: Integer): StructureMetierNiveau;
var
  PMetierNiveau:        StructureMetierNiveau;
Begin
  // Sans cette ligne, un couple metier/niveau introuvable renvoyait le contenu INDETERMINE
  // de Result - en pratique le resultat de l'appel precedent. C'est la famille de bug du
  // chantier 2.17, ou les autres Cherche* ont ete corrigees ; celle-ci avait ete oubliee.
  Result := Default(StructureMetierNiveau);
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
  // CompareRechercheValeur et non '=' : le '=' strict ignorait le prefixe de livre, alors
  // que TOUTES les autres lectures d'un code metier dans le programme sont tolerantes.
  // Aligne le 01/09/2026 sur les trois fonctions de l'unite EN MEME TEMPS - les traiter
  // separement aurait fait diverger les deux bornes d'une meme carriere.
  For PMetierNiveau in ListMetierNiveau do
    if CompareRechercheValeur(PMetierNiveau.CodeMetier, CodeMetier) and (PMetierNiveau.NiveauMetier > MaxNiveau) then
      MaxNiveau := PMetierNiveau.NiveauMetier;
  Result := MaxNiveau;
end;

// Premier niveau auquel cette carriere existe. Presque toujours 1 - mais High Elf Player's
// Guide apporte des carrieres qui ne declarent que les niveaux 3, 4 et 5 (Storm Weaver,
// Loremaster of Hoeth, Smith-priest of Vaul) : on ne les commence pas, on y arrive depuis
// le Mage. Un resultat > 1 signifie donc "carriere inaccessible a la creation, et
// inaccessible par un simple changement de carriere".
//
// AUCUNE DONNEE NOUVELLE : le minimum se lit dans les <Level> declares. Une balise
// <MinLevel> ferait doublon, avec le risque classique de la voir diverger des niveaux
// reellement presents.
//
// 0 = carriere absente de la liste. Les appelants doivent traiter ce cas AVANT de comparer,
// sinon un metier inconnu passerait pour accessible au niveau 0.
//
// Comme sa jumelle ChercheMaxMetierNiveau, elle compare avec CompareRechercheValeur : les
// deux bornes d'une meme carriere doivent se calculer de la meme facon.
function ChercheMinMetierNiveau(CodeMetier :String): Integer;
var
  PMetierNiveau:        StructureMetierNiveau;
  MinNiveau:            Integer = 0;
Begin
  For PMetierNiveau in ListMetierNiveau do
    if CompareRechercheValeur(PMetierNiveau.CodeMetier, CodeMetier) and
       ((MinNiveau = 0) or (PMetierNiveau.NiveauMetier < MinNiveau)) then
      MinNiveau := PMetierNiveau.NiveauMetier;
  Result := MinNiveau;
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
// La boucle ne s'arrete PAS au premier trou, et c'est indispensable : les pastilles sont a
// 20, 21 et 22, donc tout ce qui separe le dernier niveau de carriere du 20 est vide. Le
// chargeur de chaque fenetre ajoute une image neutre pour chaque indice manquant, afin que
// les indices ne se decalent pas.
function MaxIndiceIconeNiveau(): Integer;
var
  Ind: Integer;
Begin
  Result := MaxNiveauMetier();
  for Ind := Result + 1 to 30 do
    if FileExists(GetCurrentDir + ConstCheminImageNiveau + IntToStr(Ind) + '.PNG') then
      Result := Ind;
end;


end.

