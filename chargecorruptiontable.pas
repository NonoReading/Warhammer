unit ChargeCorruptionTable;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeRaceCorruptionCreation, UnitCalcul,
  Generics.Collections;

Type
  // Catalogue des mutations (Physical/Mental Corruption Table), CONTEXT.md §2.7 (chantier
  // mutation). Code = code stable du livre (ex. "RULES-CORMEN_007"), pas une plage D100 :
  // le tirage D100 -> Code est décorrélé du catalogue (voir StructureCorruptionChance
  // ci-dessous), pour rester valide si un futur livre renumérote sa table de chance sans
  // toucher au catalogue (conception revue avec Nono le 17/08/2026). TypeCorruption =
  // CorruptionPhysique/CorruptionMentale (mêmes constantes que
  // StructureRaceCorruptionCreation). Effet en texte libre pour l'instant (pas d'application
  // automatique aux caractéristiques, conception validée avec Nono le 16/08/2026 - beaucoup
  // d'effets ne sont pas de simples deltas de caractéristique).
  StructureCorruptionTable = Record
	Livre:            string;
	TypeCorruption:   string;
	Code:             string;
	Libelle:          string;
	Effet:            string;
end;

  TListCorruptionTable = Specialize TList<StructureCorruptionTable>;

  // Table de chance (D100 -> Code), CONTEXT.md §2.7 - propre à chaque livre, extensible sans
  // perturber les codes déjà stockés sur les personnages existants. Chance = plage D100
  // "01-05" (le "00" final vaut 100, cas particulier à gérer au tirage).
  StructureCorruptionChance = Record
	Livre:            string;
	TypeCorruption:   string;
	Chance:           string;
	Code:             string;
end;

  TListCorruptionChance = Specialize TList<StructureCorruptionChance>;

var
  ListCorruptionTable:  TListCorruptionTable;
  nbCorruptionTable:     Integer;
  ListCorruptionChance: TListCorruptionChance;
  nbCorruptionChance:    Integer;

// Compare un jet D100 à une plage "Deb-Fin" (ex. "01-05", "96-00" - le "00" final vaut 100,
// deux d10 à 0 chacun donnent 100 en D100). Une plage "-" (pas de plage, ex.
// DATA_CORRUPTION_PHYSICAL pour les Elfes) ne matche jamais.
Function CorruptionDansPlage(Plage: String; Jet: Integer): Boolean;

// Détermine Physical ou Mental pour une race et un jet D100 donnés, via
// DATA_CORRUPTION_PHYSICAL/DATA_CORRUPTION_MENTAL (ListRaceCorruptionCreation). Renvoie ''
// si rien ne matche pour cette race (ex. Elfes, jamais Physical).
Function CorruptionTypeResultat(CodeRace: String; Jet: Integer): String;

// Cherche l'entrée du catalogue (Physical ou Mental Corruption Table, déjà déterminée) qui
// correspond à un jet D100 : d'abord la table de chance (D100 -> Code), puis le catalogue
// (Code -> Libelle/Effet). Code = '' dans le résultat si rien ne matche.
Function CorruptionTableResultat(TypeCorruption: String; Jet: Integer): StructureCorruptionTable;

// Retrouve une entrée du catalogue directement par son Code (ex. pour réafficher une mutation
// déjà stockée sur un personnage, sans repasser par un jet de dé). Résultat vide si le Code
// n'existe dans aucun livre chargé.
Function ChercheCorruptionTable(Code: String): StructureCorruptionTable;

// Une race a-t-elle une plage valide pour ce type de corruption (ex. False pour Physical chez
// les Elfes) ? Utilisé pour griser le choix direct Physical/Mental dans WinMutation (CONTEXT.md
// §2.7, mode Choix) - le mode Hasard/Résultat gère déjà ce cas via CorruptionDansPlage('-', ...)
// qui ne matche jamais, mais un choix direct contourne le jet de dé, donc doit être vérifié
// explicitement.
Function CorruptionTypeDisponible(CodeRace: String; TypeCorruption: String): Boolean;

implementation

Function CorruptionDansPlage(Plage: String; Jet: Integer): Boolean;
  var
    IndS: Integer;
    Deb, Fin: Integer;
  begin
    Result := False;
    if Plage = '-' then Exit;

    IndS := Pos(SeparateurChance, Plage);
    if IndS > 0 then
      begin
        Deb := StrToIntDef(Copy(Plage, 1, IndS - 1), 0);
        Fin := StrToIntDef(Copy(Plage, IndS + 1, Length(Plage)), 0);
        if Fin = 0 then
          Fin := 100;   // "00" final = 100
      end
    else
      begin
        Deb := StrToIntDef(Plage, 0);
        Fin := Deb;
      end;

    Result := (Jet >= Deb) and (Jet <= Fin);
  end;

Function CorruptionTypeResultat(CodeRace: String; Jet: Integer): String;
  var
    PRaceCorruptionCreation: StructureRaceCorruptionCreation;
  begin
    Result := '';
    for PRaceCorruptionCreation in ListRaceCorruptionCreation do
      if CompareRechercheValeur(CodeRace, PRaceCorruptionCreation.CodeRace) then
        if CorruptionDansPlage(PRaceCorruptionCreation.Chance, Jet) then
          begin
            Result := PRaceCorruptionCreation.TypeCorruption;
            Exit;
          end;
  end;

Function CorruptionTableResultat(TypeCorruption: String; Jet: Integer): StructureCorruptionTable;
  var
    PCorruptionChance: StructureCorruptionChance;
    PCorruptionTable:  StructureCorruptionTable;
    CodeTrouve:        String;
  begin
    Result.Livre          := '';
    Result.TypeCorruption := '';
    Result.Code           := '';
    Result.Libelle        := '';
    Result.Effet          := '';

    CodeTrouve := '';
    for PCorruptionChance in ListCorruptionChance do
      if (PCorruptionChance.TypeCorruption = TypeCorruption) and CorruptionDansPlage(PCorruptionChance.Chance, Jet) then
        begin
          CodeTrouve := PCorruptionChance.Code;
          break;
        end;

    if CodeTrouve <> '' then
      for PCorruptionTable in ListCorruptionTable do
        if CompareRechercheValeur(CodeTrouve, PCorruptionTable.Code) then
          begin
            Result := PCorruptionTable;
            break;
          end;
  end;

Function ChercheCorruptionTable(Code: String): StructureCorruptionTable;
  var
    PCorruptionTable: StructureCorruptionTable;
  begin
    // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
    // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
    // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
    // affichee deux fois. CONTEXT.md 2.17.
    Result := Default(StructureCorruptionTable);
    Result.Livre          := '';
    Result.TypeCorruption := '';
    Result.Code           := '';
    Result.Libelle        := '';
    Result.Effet          := '';

    for PCorruptionTable in ListCorruptionTable do
      if CompareRechercheValeur(Code, PCorruptionTable.Code) then
        begin
          Result := PCorruptionTable;
          break;
        end;
  end;

Function CorruptionTypeDisponible(CodeRace: String; TypeCorruption: String): Boolean;
  var
    PRaceCorruptionCreation: StructureRaceCorruptionCreation;
  begin
    Result := False;
    for PRaceCorruptionCreation in ListRaceCorruptionCreation do
      if CompareRechercheValeur(CodeRace, PRaceCorruptionCreation.CodeRace)
         and (PRaceCorruptionCreation.TypeCorruption = TypeCorruption)
         and (PRaceCorruptionCreation.Chance <> '-') then
        begin
          Result := True;
          Exit;
        end;
  end;

end.
