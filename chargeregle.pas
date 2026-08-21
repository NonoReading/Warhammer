unit ChargeRegle;

{$mode ObjFPC}{$H+}

interface

// Une REGLE est une variante optionnelle de règles apportée par un livre, que le joueur
// choisit au moment de la création (décision Nono du 20/08/2026). La première est la
// "Lustrian Class and Career Table" (Lustria p.192-193), qui remplace la table de tirage
// des métiers des pages 30-31 du livre de règles pour une campagne située en Lustria.
//
// Règles retenues avec Nono :
//  - La règle n'est PAS mémorisée dans le personnage : elle ne sert qu'à la création.
//    Une fois créé, le personnage voyage et peut apprendre un métier hors de sa règle.
//  - Elle ne retire jamais rien : son tirage remplace le d100 habituel, mais en choix
//    libre ses métiers s'AJOUTENT à ceux déjà accessibles (la table lustrienne ne liste
//    que les 64 métiers de base, elle ignore les métiers de suppléments accumulés en 'X').
//  - Une ethnie non couverte par la règle retombe sur la table par défaut.
//
// Les entrées de tirage vivent dans un bloc à plat (DATA_CAREER_ROLL) porté par le livre
// qui apporte la règle - jamais dans les <Specie> des autres livres, pour les mêmes raisons
// que DATA_SPECIE_CAREER_DIRECT (voir CONTEXT.md §2.9 et §2.10).
// CodeRace y désigne indifféremment une ETHNIE (RULES-RACE_HUM) ou une RACE
// (RULES-SPECIE_HUMAN) : la colonne "Old World Human" de Lustria couvre les cinq ethnies
// Humaines d'un coup.

uses
  Classes, SysUtils, Generics.Collections, UnitCalcul, ChargeRace;

Type
  StructureRegle	= Record
	CodeRegle:	String;
	Libelle:	String;
	Livre:		String;
  End;

  StructureRegleMetier	= Record
	CodeRegle:	String;
	CodeRace:	String;
	CodeMetier:	String;
	Chance:		String;
	Livre:		String;
  End;

  TListRegle       = Specialize TList<StructureRegle>;
  TListRegleMetier = Specialize TList<StructureRegleMetier>;

var
  ListRegle:        TListRegle;
  NbRegle:          Integer;
  ListRegleMetier:  TListRegleMetier;
  NbRegleMetier:    Integer;

Function ChercheRegle(CodeRegle :String): StructureRegle;
Function RegleCibleEthnie(CodeRegle: String; CodeRace: String): Boolean;
Function RegleMetierApplicable(PRegleMetier: StructureRegleMetier; CodeRegle: String; CodeRace: String; EthnieSeule: Boolean): Boolean;
Function RegleCouvreRace(CodeRegle: String; CodeRace: String): Boolean;

implementation

Function ChercheRegle(CodeRegle :String): StructureRegle;
Var
  PRegle:   StructureRegle;
  PVide:    StructureRegle;
  Trouve:   Boolean = false;
Begin
  for PRegle in ListRegle do
    if CompareRechercheValeur(PRegle.CodeRegle, CodeRegle) then
      begin
        Result := PRegle;
        Trouve := true;
        break;
      end;
  if not Trouve then
    Result := PVide;
end;

// Une entrée de table de tirage s'applique à une ethnie si elle porte la bonne règle ET
// qu'elle cible soit cette ethnie précisément (RULES-RACE_HUM), soit la RACE dont elle
// fait partie (RULES-SPECIE_HUMAN) - la colonne "Old World Human" de la table lustrienne
// couvre les cinq ethnies Humaines d'un coup (Lustria p.193, note 1).
//
// L'ethnie PRIME sur la race. Une même règle peut porter les deux niveaux : la table
// lustrienne a une colonne "Old World Human" (visant la RACE Humaine) ET une colonne
// "Norse" (visant les trois ETHNIES norses). Sans cette précédence, un Norse recevait
// la fusion des deux colonnes - bug trouvé au test par Nono le 21/08/2026.
// EthnieSeule vient de RegleCibleEthnie : true si la règle a au moins une entrée visant
// précisément cette ethnie, auquel cas les entrées de niveau race sont ignorées.
Function RegleMetierApplicable(PRegleMetier: StructureRegleMetier; CodeRegle: String; CodeRace: String; EthnieSeule: Boolean): Boolean;
Var
  Espece: String;
  Res:    Boolean = false;
Begin
  if CompareRechercheValeur(PRegleMetier.CodeRegle, CodeRegle) then
    begin
      if CompareRechercheValeur(PRegleMetier.CodeRace, CodeRace) then
        Res := true
      else if not EthnieSeule then
        begin
          Espece := ChercheRace(CodeRace).Espece;
          if (Espece <> '') and CompareRechercheValeur(PRegleMetier.CodeRace, Espece) then
            Res := true;
        end;
    end;
  Result := Res;
End;

// La règle a-t-elle au moins une entrée visant précisément cette ethnie ?
Function RegleCibleEthnie(CodeRegle: String; CodeRace: String): Boolean;
Var
  PRegleMetier: StructureRegleMetier;
  Res:          Boolean = false;
Begin
  if (CodeRegle <> '') and (CodeRace <> '') then
    For PRegleMetier in ListRegleMetier do
      if CompareRechercheValeur(PRegleMetier.CodeRegle, CodeRegle)
         and CompareRechercheValeur(PRegleMetier.CodeRace, CodeRace) then
        begin
          Res := true;
          break;
        end;
  Result := Res;
End;

// Une règle ne couvre pas forcément toutes les ethnies : la table lustrienne n'a pas de
// colonne Gnome, Ogre, Elfe Noir ni Peau-Verte (ni Norse, absent de la base). Dans ce cas
// l'appelant doit retomber sur la table de tirage par défaut (décision Nono du 20/08/2026).
Function RegleCouvreRace(CodeRegle: String; CodeRace: String): Boolean;
Var
  PRegleMetier: StructureRegleMetier;
  Res:          Boolean = false;
Begin
  if (CodeRegle <> '') and (CodeRace <> '') then
    For PRegleMetier in ListRegleMetier do
      if RegleMetierApplicable(PRegleMetier, CodeRegle, CodeRace, false) then
        begin
          Res := true;
          break;
        end;
  Result := Res;
End;

end.
