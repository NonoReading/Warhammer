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

Function IntervalleChance(Chance: String; out Deb, Fin: Integer): Boolean;
  begin
    Chance := Trim(Chance);
    if Pos('-', Chance) > 0 then
      begin
        Deb := StrToIntDef(ExtractStringBefore(Chance, '-'), 0);
        Fin := StrToIntDef(ExtractStringAfter(Chance, '-'), 0);
      end
    else
      begin
        Deb := StrToIntDef(Chance, 0);
        Fin := Deb;
      end;
    Result := (Deb > 0) and (Fin >= Deb);
  end;


Function TalentAleatoire(Jet: Integer; CodeRace: String): String;
  var
    PTalentCreation: StructureTalentCreation;
    Deb, Fin:        Integer;
    Trouve:          Boolean = False;
  begin
    Result := '';
    // 1 - table spécifique à la race
    For PTalentCreation in ListTalentCreation do
      if CompareRechercheValeur(PTalentCreation.CodeRace, CodeRace) then
        begin
          Trouve := True;
          if IntervalleChance(PTalentCreation.Chance, Deb, Fin) and (Jet >= Deb) and (Jet <= Fin) then
            begin
              Result := PTalentCreation.CodeTalent;
              Exit;
            end;
        end;
    // 2 - repli sur la table générique du RULESBOOK
    if not Trouve then
      For PTalentCreation in ListTalentCreation do
        if CompareRechercheValeur(PTalentCreation.CodeRace, ConstCodeRaceCreationGenerique) then
          if IntervalleChance(PTalentCreation.Chance, Deb, Fin) and (Jet >= Deb) and (Jet <= Fin) then
            begin
              Result := PTalentCreation.CodeTalent;
              Exit;
            end;
  end;

Function TalentDejaPossede(Code: String; Deja: TStringList): Boolean;
  var
    Ind: Integer;
  begin
    Result := False;
    if Deja = nil then Exit;
    for Ind := 0 to Deja.Count - 1 do
      if CompareRechercheValeur(Code, Deja[Ind]) then
        begin
          Result := True;
          Exit;
        end;
  end;

end.

