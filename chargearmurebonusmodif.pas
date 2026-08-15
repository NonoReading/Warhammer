unit ChargeArmureBonusModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureArmureBonusModif   = Record
        Livre:          string;
        CodeArmureBonus:string;
        CodeCompetence: String;
        Valeur:         Integer;
end;

  TListArmureBonusModif = Specialize TList<StructureArmureBonusModif>;

Var
  ListArmureBonusModif:     TListArmureBonusModif;
  NbArmureBonusModif:       Integer;


implementation


end.
