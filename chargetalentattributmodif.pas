unit ChargeTalentAttributModif;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  StructureTalentAttributModif = Record
        Livre:         string;
	CodeTalent:    string;
        CodeAttribut:  String;
        // Valeur entiere (avant : ValeurDonnee, texte brut recopie du XML type "+1", jamais
        // utilise que pour de l'affichage). Passage en Integer le 06/09/2026 pour permettre
        // un vrai calcul (GetAttributValeur, chargepersonnage.pas) en plus de l'annotation
        // existante (PersonnageTalentAsterisque) - meme convention que
        // StructureCorruptionAttributModif.Valeur.
        Valeur:        Integer;
end;

  TListTalentAttributModif = Specialize TList<StructureTalentAttributModif>;

Var
  ListTalentAttributModif:     TListTalentAttributModif;
  NbTalentAttributModif:       Integer;


implementation


end.

