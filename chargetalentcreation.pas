unit ChargeTalentCreation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeTalent, UnitCalcul;

Type
  StructureTalentCreation   = record
    CodeRace:           string;
    CodeTalent:		string;
    Chance:		string;
    Livre:              String;
end;

  TListTalentCreation = specialize TList<StructureTalentCreation>;

Var
  ListTalentCreation: TListTalentCreation;
  NbTalentCreation:   Integer;

Function DescriptionTalent(CodeTalent: String; CodeRace: String): String;

implementation

Function DescriptionTalent(CodeTalent: String; CodeRace: String): String;
  var
    PTalentCreation: StructureTalentCreation;
    Lib:             String;
    PTalent:         StructureTalent;
    Trouve:          Boolean = false;
  begin
    // libellé de base
    PTalent  := ChercheTalent(CodeTalent);
    Lib      := PTalent.Description;
    if CompareRechercheValeur(CodeTalent, TalentGenerique) then
      begin
        // Ajouter les talents génériques
        if CodeRace <> ConstCodeRaceCreationGenerique then
          For PTalentCreation in ListTalentCreation do
            if CompareRechercheValeur(PTalentCreation.CodeRace, CodeRace) then
              begin
                PTalent  := ChercheTalent(PTalentCreation.CodeTalent);
                Lib      := Lib + SeparateurRetourLigne + ' - ' + PTalentCreation.Chance + ' - ' + PTalent.Libelle;
                Trouve   := true;
              end;
        // recherche sur les données générique de RULEBOOK
        if not Trouve then
          For PTalentCreation in ListTalentCreation do
            if CompareRechercheValeur(PTalentCreation.CodeRace, ConstCodeRaceCreationGenerique) then
              begin
                PTalent  := ChercheTalent(PTalentCreation.CodeTalent);
                Lib      := Lib + SeparateurRetourLigne + ' - ' + PTalentCreation.Chance + ' - ' + PTalent.Libelle;
              end;
      end;

    // envoyer le résultat
    Result := Lib;
  end;

end.

