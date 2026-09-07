unit ChargeNation;

{$mode ObjFPC}{$H+}

interface

// Regroupement POLITIQUE/culturel d'ethnies (l'Empire, a terme Bretonnia, Kislev,
// Cathay...), sur le meme moule que ChargeEspece.pas (regroupement BIOLOGIQUE) mais un
// axe DIFFERENT : RULES-SPECIE_HUMAN (Race) reunit Reikland ET la Tilee, alors que
// "Empire" ne doit reunir que Reikland et les provinces de Nations of Mankind, pas la
// Tilee. D'ou une table a part plutot que de reutiliser Espece.
// Bloc XML DATA_NATION, declarable par n'importe quel livre (comme DATA_RACE) : une
// ethnie cite son code via la balise <Nationality>, FACULTATIVE - la plupart des
// ethnies (Nains, Elfes, Norses...) n'appartiennent a aucune nation. CONTEXT.md 2.51.

uses
  Classes, SysUtils, Generics.Collections, UnitCalcul;

Type
  StructureNation	= Record
	CodeNation:	String;
	Libelle:	String;
	Livre:		String;
  End;

  TListNation = Specialize TList<StructureNation>;

var
  ListNation:   TListNation;
  NbNation:     Integer;

Function ChercheNation(CodeNation :String): StructureNation;

implementation

Function ChercheNation(CodeNation :String): StructureNation;
Var
  PNation:  StructureNation;
Begin
  // Default() obligatoire : sans lui le record garde le contenu du PRECEDENT appel
  // quand rien n'est trouve (piege documente CONTEXT.md 2.17 ; ChercheEspece, ecrite
  // avant ce correctif, ne l'a pas - a corriger un jour, note dans A FAIRE.txt).
  Result := Default(StructureNation);
  for PNation in ListNation do
    if CompareRechercheValeur(PNation.CodeNation, CodeNation) then
      begin
        Result := PNation;
        break;
      end;
end;

end.
