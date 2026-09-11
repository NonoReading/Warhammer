unit ChargeCorruptionModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUELLE entree du
// catalogue de mutation (Physique/Mentale) peut declarer - remplace depuis le 11/09/2026
// ChargeCorruptionAttributModif (ModifyCarac), meme migration que
// ChargeTalentModificateur/ChargeCareerBonusModificateur pour la cible Attribut.
// CodeSource porte le Code de la mutation (StructureCorruptionTable.Code). Les pendants
// Competence/Competence-par-attribut/Armure (ModifySkill/ModifySkillAttribut/
// ModifyArmour) restent a part, portes par leurs listes dediees existantes - pas dans ce
// chantier.
Var
  ListCorruptionModificateur: TListModificateur;
  NbCorruptionModificateur:   Integer;


implementation


end.
