unit ChargeTalentEffet;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  // Generalisation du case de calcul de pdfpersonnage.pas (DurACuire/BonusEncomb/TBonusCC/
  // TBonusCT/BonusSprint/AmePure) : au lieu d'un talent code en dur dans un case Pascal,
  // n'importe quel talent peut porter une ou plusieurs balises <Effet> dans son XML pour
  // agir sur une des cibles fermees connues du code (Cible). Voir A FAIRE.txt "GENERICISER
  // LE CASE DE CALCUL DES TALENTS" et CONTEXT.md.
  StructureTalentEffet = Record
        Livre:         string;
        CodeTalent:    string;
        // Vocabulaire ferme porte par le code (comme DISPO/CLASS), pas un id= de livre :
        // les noms des variables de calcul existantes (DurACuire, BonusEncomb, TBonusCC,
        // TBonusCT, BonusSprint, AmePure).
        Cible:         string;
        // Additif (Cible += Facteur * rang du talent), ProportionnelAttribut
        // (Cible += Floor(Carac/10) * rang du talent * Facteur), Drapeau (Cible := 1).
        Forme:         string;
        Facteur:       Integer;
        // Code de la caracteristique source, requis seulement pour Forme=ProportionnelAttribut.
        Carac:         string;
end;

  TListTalentEffet = Specialize TList<StructureTalentEffet>;

Var
  ListTalentEffet:     TListTalentEffet;
  NbTalentEffet:       Integer;


implementation


end.
