unit ChargeClassEquipement;

// Equipement de depart par Classe (Rulebook p.37, "Class Trappings", CONTEXT.md chantier
// "AUDIT DES TXT" Rulebook). Distinct de l'equipement de Carriere (ChargeMetierEquipement) :
// pas de niveau, une seule liste par Classe, donnee une fois a la creation en plus de
// l'equipement de la Carriere choisie (voir <Class> sur la Carriere, deja charge dans
// StructureMetier.LibelleGroupe). Memes champs que StructureMetierEquipement (moins
// NiveauMetier) pour reutiliser telle quelle la logique d'affichage de wincreation.pas.

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

Type
  StructureClassEquipement = Record
    CodeClasse:     String;
    Equipement:     String;
    TypeEquipement: String;
    Livre:          String;
    Quantite:       Integer;
    QuantiteListe:  String;
end;

  TListClassEquipement = Specialize TList<StructureClassEquipement>;

var
  ListClassEquipement: TListClassEquipement;
  NbClassEquipement:   Integer;

implementation

end.
