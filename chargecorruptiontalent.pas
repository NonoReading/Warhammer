unit ChargeCorruptionTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Talent accorde automatiquement par une mutation (ex. Fleshy Tentacle, chantier "traits de
  // creature", CONTEXT.md/A FAIRE.txt) - meme moule que StructureCorruptionArmureModif, mais
  // pas de valeur numerique : la mutation donne le talent, pas un bonus dessus. Pose au cas par
  // cas dans le XML (<Talent> sous <Corruption>), jamais deduit d'un nom de trait. Pas de liste
  // stockee cote personnage : PersonnageMutationTalent (chargepersonnage.pas) recalcule a la
  // volee depuis Personnage.Mutations, sur le meme principe que PersonnageMutationArmureModif -
  // la cascade de suppression d'une mutation (retirer les talents qu'elle donnait) est ainsi
  // automatique, sans purge explicite a ecrire.
  StructureCorruptionTalent   = Record
        Livre:            string;
        CodeCorruption:   string;
        CodeTalent:       String;
end;

  TListCorruptionTalent = Specialize TList<StructureCorruptionTalent>;

Var
  ListCorruptionTalent:     TListCorruptionTalent;
  NbCorruptionTalent:       Integer;


implementation


end.
