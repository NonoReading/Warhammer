unit ChargeArmeBonusTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Talent accorde automatiquement par une qualite d'arme (ex. une capacite d'arme
  // magique "Of Rigor Wroth" -> Strike Mighty Blow), chantier "objets magiques
  // Archives II", CONTEXT.md/A FAIRE.txt. Meme moule que StructureArmureBonusTalent
  // (chargearmurebonustalent.pas), qui accorde un talent depuis une qualite d'armure
  // plutot que depuis une qualite d'arme. Pose au cas par cas dans le XML (<Talent>
  // sous <ArmeBonus>), jamais deduit d'un nom de qualite. Pas de liste stockee cote
  // personnage : PersonnageArmeBonusTalent (chargepersonnage.pas) recalcule a la volee
  // depuis Personnage.Equipement - le retrait de l'objet porte fait disparaitre le
  // talent accorde sans purge explicite a ecrire.
  StructureArmeBonusTalent   = Record
        Livre:          string;
        CodeArmeBonus:  string;
        CodeTalent:     String;
end;

  TListArmeBonusTalent = Specialize TList<StructureArmeBonusTalent>;

Var
  ListArmeBonusTalent:     TListArmeBonusTalent;
  NbArmeBonusTalent:       Integer;


implementation


end.
