unit ChargeArmureBonusTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Talent accorde automatiquement par une qualite d'objet (ex. NATIO-ARMOB_16 "Fear" ->
  // RULES-T0049 "Frightening", Skull Trophies), chantier "traits de creature",
  // CONTEXT.md/A FAIRE.txt. Meme moule que StructureCorruptionTalent
  // (chargecorruptiontalent.pas), qui accorde un talent depuis une mutation plutot que
  // depuis une qualite d'armure. Pose au cas par cas dans le XML (<Talent> sous
  // <ArmureBonus>), jamais deduit d'un nom de qualite. Pas de liste stockee cote
  // personnage : PersonnageArmureBonusTalent (chargepersonnage.pas) recalcule a la volee
  // depuis Personnage.Equipement - le retrait de l'objet porte fait disparaitre le talent
  // accorde sans purge explicite a ecrire.
  StructureArmureBonusTalent   = Record
        Livre:            string;
        CodeArmureBonus:  string;
        CodeTalent:       String;
end;

  TListArmureBonusTalent = Specialize TList<StructureArmureBonusTalent>;

Var
  ListArmureBonusTalent:     TListArmureBonusTalent;
  NbArmureBonusTalent:       Integer;


implementation


end.
