unit ChargeArmeAttributModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  // Un <ModifyCarac name="CODE">VALEUR</ModifyCarac> pose directement sur une arme
  // (DATA_ARME) - meme famille et meme raisonnement que StructureTalentAttributModif
  // (chargetalentattributmodif.pas) et StructureCareerBonusAttributModif
  // (chargemetier.pas). CONTEXT.md 2.50 etape 3.
  // Volontairement Attribut seul pour l'instant, pas de pendant Competence
  // (ModifySkill) : meme limitation assumee que cote regiments/ordres, tant qu'aucune
  // arme du corpus n'en a besoin.
  StructureArmeAttributModif = Record
        Livre:         string;
        CodeArme:      string;
        CodeAttribut:  String;
        Valeur:        Integer;
end;

  TListArmeAttributModif = Specialize TList<StructureArmeAttributModif>;

Var
  ListArmeAttributModif:     TListArmeAttributModif;
  NbArmeAttributModif:       Integer;


implementation


end.
