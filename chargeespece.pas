unit ChargeEspece;

{$mode ObjFPC}{$H+}

interface

// Vocabulaire (fixé avec Nono le 20/08/2026) :
//  - ETHNIE  = ce que le joueur choisit à la création, et ce que le reste du code
//              appelle historiquement "Race" (StructureRace / ChargeRace.pas /
//              balise XML <Specie>). Ex. "Humans (Reikland)", "Humans (Tilea)".
//  - RACE    = le regroupement au-dessus, commun à plusieurs ethnies. Ex. "Human".
//              C'est ce que cette unité gère (balise XML <Race>, bloc DATA_RACE).
// Le champ StructureRace.Espece porte le code de la RACE de chaque ethnie.
// Les noms Pascal sont volontairement laissés en "Espece" pour rester cohérents
// avec ce champ existant, alors que les balises XML disent "Race" - ne pas s'y
// laisser prendre.

uses
  Classes, SysUtils, Generics.Collections, UnitCalcul;

Type
  StructureEspece	= Record
	CodeEspece:	String;
	Libelle:	String;
	Livre:		String;
        // Dossier d'icones de niveau commun a toutes les ethnies de cette race, sous
        // \PICTURES\. Une ethnie peut le surcharger ; vide = dossier generique NIV.
        DossierNiveau:	String;
  End;

  TListEspece = Specialize TList<StructureEspece>;

var
  ListEspece:   TListEspece;
  NbEspece:     Integer;

Function ChercheEspece(CodeEspece :String): StructureEspece;

implementation

Function ChercheEspece(CodeEspece :String): StructureEspece;
Var
  PEspece:  StructureEspece;
  PVide:    StructureEspece;
  Trouve:   Boolean = false;
Begin
  for PEspece in ListEspece do
    if CompareRechercheValeur(PEspece.CodeEspece, CodeEspece) then
      begin
        Result := PEspece;
        Trouve := true;
        break;
      end;
  if not Trouve then
    Result := PVide;
end;

end.
