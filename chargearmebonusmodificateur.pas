unit ChargeArmeBonusModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUELLE qualite
// d'arme peut declarer - meme moule que ChargeArmureBonusModificateur, cote arme.
// CodeSource porte le CodeArmeBonus (pas le CodeArme : c'est la QUALITE qui porte le
// modificateur, comme "+20 WS" d'une capacite d'arme magique Archives II, pas l'arme
// elle-meme - ChargeArmeModificateur existant reste dedie aux modificateurs poses
// directement sur une arme precise). Chantier "objets magiques Archives II".
Var
  ListArmeBonusModificateur: TListModificateur;
  NbArmeBonusModificateur:   Integer;


implementation


end.
