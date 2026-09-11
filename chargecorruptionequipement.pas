unit ChargeCorruptionEquipement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Equipement (arme ou armure) accorde automatiquement par une mutation (ex. Fleshy Tentacle),
  // cas par cas dans le XML (<Weapon>/<Armor> sous <Corruption>) - meme esprit que
  // ChargeCorruptionTalent, mais CodeEquipement pointe un code du catalogue Arme ou Armure
  // (ChercheArme/ChercheArmure) plutot qu'un Talent. EstArme distingue les deux catalogues :
  // TypeEquipWe/TypeEquipAr (chargeconstantes.pas) sont des libelles LOCALISES (charges depuis
  // un texte traduit), pas des codes fixes - pas utilisables ici, la conversion vers l'un ou
  // l'autre se fait au moment de l'affichage (PersonnageMutationEquipement, chargepersonnage.pas).
  StructureCorruptionEquipement   = Record
        Livre:            string;
        CodeCorruption:   string;
        CodeEquipement:   String;
        EstArme:          Boolean;
end;

  TListCorruptionEquipement = Specialize TList<StructureCorruptionEquipement>;

Var
  ListCorruptionEquipement:     TListCorruptionEquipement;
  NbCorruptionEquipement:       Integer;


implementation


end.
