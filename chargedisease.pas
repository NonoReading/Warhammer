unit ChargeDisease;

// Catalogue des maladies (The Litany of Pestilence, Rulebook p.186-188, CONTEXT.md chantier
// "AUDIT DES TXT" Rulebook). Consultation seule (comme ChargeCorruptionTable) : aucun effet
// mecanise, Contraction/Incubation/Duration/Symptoms en texte libre.

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

Type
  StructureDisease = Record
    Livre:       string;
    Code:        string;
    Libelle:     string;
    Contraction: string;
    Incubation:  string;
    Duration:    string;
    Symptoms:    string;
end;

  TListDisease = Specialize TList<StructureDisease>;

var
  ListDisease: TListDisease;
  nbDisease:   Integer;

implementation

end.
