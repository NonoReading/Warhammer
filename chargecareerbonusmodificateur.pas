unit ChargeCareerBonusModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeModificateur;

// Porteur des StructureModificateur (ChargeModificateur) que N'IMPORTE QUEL palier de
// CareerBonus peut declarer - remplace depuis le 11/09/2026 les anciennes
// ListCareerBonusCompetenceModif et ListCareerBonusArmeModif (chargemetier.pas), deux listes
// dediees quasi identiques. Niveau (champ ajoute a StructureModificateur pour cette source)
// porte le palier minimum requis, CodeSource porte le CodeBonus
// (ChargeMetier.StructureCareerBonus). ListCareerBonusAttributModif reste a part pour
// l'instant : migration separee, pas dans ce chantier (meme decision que ModifyCarac cote
// Talent, ChargeTalentModificateur).
Var
  ListCareerBonusModificateur: TListModificateur;
  NbCareerBonusModificateur:   Integer;


implementation


end.
