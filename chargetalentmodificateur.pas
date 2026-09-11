unit ChargeTalentModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUEL talent peut
// declarer : ModifySkill et ModifyWeapon d'abord (aujourd'hui reserves aux paliers de
// CareerBonus, chargepersonnage.pas PersonnageCareerBonusCompetenceModif/ArmeModif),
// ModifyDamage ensuite (n'existe encore pour aucune source). ModifyCarac et ModifArmour
// restent portes par ChargeTalentAttributModif/ChargeTalentArmureModif pour l'instant :
// migration separee, pas dans ce chantier.
Var
  ListTalentModificateur:   TListModificateur;
  NbTalentModificateur:     Integer;


implementation


end.
