unit UnitEquipement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeArme, ChargeArmure, ChargeConstantes;

Function GetTypeEquipement(CodeEquipement: String): String;

implementation

Function GetTypeEquipement(CodeEquipement: String): String;
  var
    TypEquip: String;
  begin
    case copy(CodeEquipement,1,5) of
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

