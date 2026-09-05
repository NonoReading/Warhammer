unit UnitEquipement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul;

Function GetTypeEquipement(CodeEquipement: String): String;

implementation

Function GetTypeEquipement(CodeEquipement: String): String;
  var
    TypEquip: String;
  begin
    // Le code porte son prefixe de livre (RULES-COMB_BASE_10) : tester les cinq premiers
    // caracteres du code COMPLET donnait "RULES", donc tout retombait sur TypeEquipDi
    // ("Various"). Et comme ce type decide du sous-chapitre a l'export, une arme et une
    // armure repartaient dans SUBCHAPTER_MISC, ou la relecture n'a plus que le code a
    // afficher. Meme moule que GetTypeMetierEquipement (unitcalcul.pas l.218).
    DecoupeCodeValeur(CodeEquipement);
    case copy(CodeValeur,1,5) of
      EquipementCC,EquipementCT,EquipementMU:
        TypEquip := TypeEquipWe;
      EquipementAR:
        TypEquip := TypeEquipAr;
      else
        TypEquip := TypeEquipDI;
      end;
    Result := TypEquip;
  end;

end.

