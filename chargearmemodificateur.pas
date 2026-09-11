unit ChargeArmeModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUELLE arme peut
// declarer - remplace depuis le 11/09/2026 ChargeArmeAttributModif (ModifyCarac), meme
// migration que ChargeTalentModificateur/ChargeCareerBonusModificateur pour la cible
// Attribut. CodeSource porte le CodeArme.
Var
  ListArmeModificateur: TListModificateur;
  NbArmeModificateur:   Integer;


implementation


end.
