unit ChargeCorruptionArmureModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Effets de mutation donnant des Points d'Armure (ex. "+2 Armour Points to all locations",
  // CORPHY_012/016/017) - réutilise les 4 emplacements déjà utilisés par l'armure portée
  // (BonusTete/BonusBras/BonusCorps/BonusJambes, chargeconstantes.pas), qui ne distinguent pas
  // gauche/droite (aucune pièce d'armure ni mutation n'a besoin de cette précision). Une
  // mutation touchant plusieurs emplacements aura simplement plusieurs <ModifArmour>, un par
  // emplacement concerné. CONTEXT.md §2.7, étape 8.
  StructureCorruptionArmureModif   = Record
        Livre:            string;
        CodeCorruption:   string;
        CodeLocalisation: String;
        Valeur:           Integer;
end;

  TListCorruptionArmureModif = Specialize TList<StructureCorruptionArmureModif>;

Var
  ListCorruptionArmureModif:     TListCorruptionArmureModif;
  NbCorruptionArmureModif:       Integer;


implementation


end.
