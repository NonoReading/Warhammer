unit ChargeTalentModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUEL talent peut
// declarer : ModifyCarac, ModifySkill, ModifyWeapon, ModifyDamage et ModifArmour passent
// tous par cette liste depuis le 11/09/2026 (moteur generique de modificateurs), les
// anciennes unites dediees par cible ont ete retirees au fur et a mesure.
Var
  ListTalentModificateur:   TListModificateur;
  NbTalentModificateur:     Integer;


implementation


end.
