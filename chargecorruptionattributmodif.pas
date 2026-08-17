unit ChargeCorruptionAttributModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureCorruptionAttributModif   = Record
        Livre:          string;
        CodeCorruption: string;
        CodeAttribut:   String;
        Valeur:         Integer;
end;

  TListCorruptionAttributModif = Specialize TList<StructureCorruptionAttributModif>;

Var
  ListCorruptionAttributModif:     TListCorruptionAttributModif;
  NbCorruptionAttributModif:       Integer;


implementation


end.
