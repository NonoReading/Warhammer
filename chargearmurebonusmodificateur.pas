unit ChargeArmureBonusModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUELLE qualite
// d'armure peut declarer - remplace depuis le 11/09/2026 ChargeArmureBonusAttributModif
// (ModifyCarac), meme migration que ChargeTalentModificateur/ChargeCareerBonusModificateur
// pour la cible Attribut. CodeSource porte le CodeArmureBonus. Le pendant Competence
// (<Modifier name="...">) reste a part, porte par ChargeArmureBonusModif - pas dans ce
// chantier.
Var
  ListArmureBonusModificateur: TListModificateur;
  NbArmureBonusModificateur:   Integer;


implementation


end.
