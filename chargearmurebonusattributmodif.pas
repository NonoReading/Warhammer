unit ChargeArmureBonusAttributModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  // Un <ModifyCarac name="CODE">VALEUR</ModifyCarac> pose sur une QUALITE d'armure
  // (DATA_ARMURE_BONUS) - meme famille que StructureArmeAttributModif
  // (chargearmeattributmodif.pas) et StructureCareerBonusAttributModif
  // (chargemetier.pas). CONTEXT.md 2.50 etape 3.
  // Le pendant Competence existe deja, sous une forme plus ancienne : voir
  // StructureArmureBonusModif (chargearmurebonusmodif.pas), qui porte un
  // <Modifier name="..."> distinct de <ModifyCarac>/<ModifySkill> - migre en vrai
  // modificateur dans le meme mouvement que l'ajout de cette unite
  // (PersonnageArmureBonusCompetenceModif, chargepersonnage.pas), sans toucher a
  // son import XML qui reste inchange.
  StructureArmureBonusAttributModif = Record
        Livre:           string;
        CodeArmureBonus: string;
        CodeAttribut:    String;
        Valeur:          Integer;
end;

  TListArmureBonusAttributModif = Specialize TList<StructureArmureBonusAttributModif>;

Var
  ListArmureBonusAttributModif:     TListArmureBonusAttributModif;
  NbArmureBonusAttributModif:       Integer;


implementation


end.
