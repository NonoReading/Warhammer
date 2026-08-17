unit ChargeCorruptionCompetenceModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  StructureCorruptionCompetenceModif   = Record
        Livre:          string;
        CodeCorruption: string;
        CodeCompetence: String;
        Valeur:         Integer;
end;

  TListCorruptionCompetenceModif = Specialize TList<StructureCorruptionCompetenceModif>;

  // S'applique à TOUTES les compétences dont l'attribut de rattachement est CodeAttribut (ex.
  // "-20 to all Fellowship Tests", CORPHY_011) - sans modifier l'attribut lui-même (contrairement
  // à StructureCorruptionAttributModif/<ModifyCarac>). Tag XML dédié <ModifySkillAttribut> pour
  // ne pas surcharger <ModifySkill> d'un troisième sens (CONTEXT.md §2.7, étape 8).
  StructureCorruptionCompetenceAttributModif   = Record
        Livre:          string;
        CodeCorruption: string;
        CodeAttribut:   String;
        Valeur:         Integer;
end;

  TListCorruptionCompetenceAttributModif = Specialize TList<StructureCorruptionCompetenceAttributModif>;

Var
  ListCorruptionCompetenceModif:     TListCorruptionCompetenceModif;
  NbCorruptionCompetenceModif:       Integer;

  ListCorruptionCompetenceAttributModif: TListCorruptionCompetenceAttributModif;
  NbCorruptionCompetenceAttributModif:   Integer;


implementation


end.
