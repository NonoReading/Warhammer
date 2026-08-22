unit ChargeTalentArmureModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Talents donnant des Points d'Armure. Calqué sur ChargeCorruptionArmureModif (mutations,
  // CONTEXT.md §2.7 étape 8) : mêmes champs, même balise <ModifArmour name="ARMOL_XXX">,
  // mêmes 4 emplacements que l'armure portée (BonusTete/BonusBras/BonusCorps/BonusJambes,
  // chargeconstantes.pas), qui ne distinguent pas gauche/droite.
  //
  // Premier usage : le trait de créature Armour (Rating) (RULES-T0ARM, Rulebook p.338), que
  // le Skink porte en "Armour 1 (Scaly Skin)" - une peau écailleuse vaut 1 Point d'Armure sur
  // toutes les localisations. Sert aussi à la marque de Quetzl (Lustria p.151, "Armour +1"),
  // qui donne des Points d'Armure sans être une mutation. CONTEXT.md §2.15.
  //
  // La Valeur est celle d'UN niveau de talent : PersonnageTalentArmureModif la multiplie par
  // le niveau possédé, pour que "Armour (Rating)" pris au niveau 2 donne bien 2 Points.
  StructureTalentArmureModif   = Record
        Livre:            string;
        CodeTalent:       string;
        CodeLocalisation: String;
        Valeur:           Integer;
end;

  TListTalentArmureModif = Specialize TList<StructureTalentArmureModif>;

Var
  ListTalentArmureModif:     TListTalentArmureModif;
  NbTalentArmureModif:       Integer;


implementation


end.
