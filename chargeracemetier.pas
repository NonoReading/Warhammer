unit ChargeRaceMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeMetier, Generics.Collections, ChargeTexte, ChargeRace, ChargeEspece, UnitCalcul;

Type
    StructureRaceMetier	= Record
	CodeMetier:	String;
	Chance:	        String;
	CodeRace:	String;
        Livre:          String;
End;

  TListRaceMetier = specialize TList<StructureRaceMetier>;

Var
  ListRaceMetier:   TListRaceMetier;
  NbRaceMetier:     Integer;

Function VerifieRaceMetier(RaceChoisie: String; MetierActuel: String; MetierAVerifier:String):Boolean;
Function MetierRaceCourt(MetierActuel: String):String;
Function MetierRaceNbSuivant(RaceEnCours:String; MetierEnCours: String):Integer;
Procedure CompleteRaceMetierParEspece;

implementation

// Tout métier accessible à une ethnie l'est pour toutes les ethnies de la même RACE
// (décision Nono du 20/08/2026) : un Humain de Middenheim doit pouvoir choisir un métier
// déclaré sur le Reiklander. Seule l'ACCESSIBILITE se propage, jamais la table de jet d100 :
// les entrées ajoutées le sont toujours en 'X' (éligible hors tirage), donc les fourchettes
// de dés propres à chaque région restent intactes (ChargeTabMetier exclut déjà les 'X').
//
// A appeler APRES le chargement de TOUS les livres : au moment où un livre est lu, les
// ethnies déclarées par les autres livres ne sont pas forcément encore dans ListRace
// (l'ordre de FindFirst/FindNext n'est pas garanti - voir CONTEXT.md §2.9).
//
// Deux phases : (1) développer les entrées ciblant une RACE en une entrée par ethnie,
// (2) propager l'accessibilité entre ethnies d'une même race.
Procedure CompleteRaceMetierParEspece;
  var
    Existant:     TStringList;
    AvecTirage:   TStringList;
    Donneur:      TStringList;
    NbInitial:    Integer;
    Ind:          Integer;
    PSource:      StructureRaceMetier;
    PNouveau:     StructureRaceMetier;
    PRaceSource:  StructureRace;
    PRaceCible:   StructureRace;
    EspeceSource: String;
    Cle:          String;
    CleEspece:    String;

  // Normalisation identique à DecoupeCodeValeur (UnitCalcul), mais en local : passer par
  // CompareRechercheValeur écraserait les variables globales CodeValeur/CodeRecherche,
  // dont dépendent d'autres traitements (CheminMetierImage notamment).
  Function CodeSansLivre(Code: String): String;
    begin
      if Pos(SeparateurLivre, Code) > 0 then
        Result := ExtractStringAfter(Code, SeparateurLivre)
      else
        Result := Code;
    end;

  begin
    Existant   := TStringList.Create;
    AvecTirage := TStringList.Create;
    Donneur    := TStringList.Create;
    try
      Existant.Sorted     := True;
      Existant.Duplicates := dupIgnore;
      For PSource in ListRaceMetier do
        Existant.Add(CodeSansLivre(PSource.CodeRace) + '|' + CodeSansLivre(PSource.CodeMetier));

      // ---- Phase 1 : développer les entrées qui ciblent une RACE ----
      // DATA_SPECIE_CAREER_DIRECT accepte, comme DATA_CAREER_ROLL, un code de RACE
      // (RULES-SPECIE_HUMAN) aussi bien qu'un code d'ETHNIE (RULES-RACE_HUM). Les
      // consommateurs de ListRaceMetier (winmetier, VerifieRaceMetier, ChargeTabMetier)
      // comparent tous à l'ethnie du personnage : une entrée restée en code de race ne
      // matcherait jamais, sans le moindre message. On la remplace donc ici par une
      // entrée par ethnie concernée. Ce développement doit se faire APRES le chargement
      // de tous les livres, sinon les ethnies des autres livres manqueraient à l'appel.
      NbInitial := ListRaceMetier.Count;
      For Ind := NbInitial - 1 downto 0 do
        begin
          PSource := ListRaceMetier[Ind];
          if ChercheEspece(PSource.CodeRace).CodeEspece = '' then
            continue;
          For PRaceCible in ListRace do
            if CodeSansLivre(PRaceCible.Espece) = CodeSansLivre(PSource.CodeRace) then
              begin
                Cle := CodeSansLivre(PRaceCible.CodeRace) + '|' + CodeSansLivre(PSource.CodeMetier);
                if Existant.IndexOf(Cle) < 0 then
                  begin
                    PNouveau          := PSource;
                    PNouveau.CodeRace := PRaceCible.CodeRace;
                    ListRaceMetier.Add(PNouveau);
                    inc(NbRaceMetier);
                    Existant.Add(Cle);
                  end;
              end;
          ListRaceMetier.Delete(Ind);
          dec(NbRaceMetier);
        end;

      // ---- Pré-calcul pour la phase 2 : qui a déjà une table de tirage, et qui la donne ----
      // Une ethnie qui n'a AUCUNE fourchette de dés à elle (cas du nain norse de Sea of
      // Claws, dont l'encadré p.41 ne donne que des compétences et des talents) doit
      // hériter de la table de sa RACE, et pas seulement de l'accessibilité en 'X' :
      // sans cela sa table de tirage est vide et le joueur n'a aucun métier à tirer
      // (bug trouvé au test par Nono le 25/08/2026). C'est le même principe que celui
      // déjà posé pour les règles dans ChargeRegle - "une ethnie non couverte par la
      // règle retombe sur la table par défaut" - appliqué cette fois aux ethnies.
      //
      // AvecTirage : les ethnies qui possèdent au moins une fourchette propre. Calculé
      // AVANT la phase 2, sinon la première fourchette héritée ferait basculer l'ethnie
      // dans cette liste et les suivantes repasseraient en 'X'.
      AvecTirage.Sorted     := True;
      AvecTirage.Duplicates := dupIgnore;
      For PSource in ListRaceMetier do
        if (PSource.Chance <> 'X') and (PSource.Chance <> SeparateurChance) then
          AvecTirage.Add(CodeSansLivre(PSource.CodeRace));

      // Donneur : pour chaque RACE, l'UNE de ses ethnies dont la table sera recopiée.
      // Il en faut une seule, sinon une ethnie sans table hériterait des fourchettes de
      // toutes ses soeurs à la fois et les plages se chevaucheraient (cas des Humains,
      // qui ont cinq ethnies avec chacune sa table). En cas de plusieurs candidates, on
      // retient celle qui vient du même livre que la RACE elle-même, c'est-à-dire
      // l'ethnie de référence - RULES-RACE_HUM pour les Humains, RULES-RACE_DWAR pour
      // les Nains. Choix déterministe, qui ne dépend donc pas de l'ordre de chargement
      // des livres (lequel n'est pas garanti, voir CONTEXT.md §2.9).
      For PRaceCible in ListRace do
        begin
          if AvecTirage.IndexOf(CodeSansLivre(PRaceCible.CodeRace)) < 0 then
            continue;
          CleEspece := CodeSansLivre(PRaceCible.Espece);
          if CleEspece = '' then
            continue;
          if (Donneur.Values[CleEspece] = '')
             or (PRaceCible.Livre = ChercheEspece(PRaceCible.Espece).Livre) then
            Donneur.Values[CleEspece] := CodeSansLivre(PRaceCible.CodeRace);
        end;

      // ---- Phase 2 : propager l'accessibilité entre ethnies d'une même race ----
      // borne figée avant la boucle : on ajoute dans la liste qu'on parcourt
      NbInitial := ListRaceMetier.Count;
      For Ind := 0 to NbInitial - 1 do
        begin
          PSource := ListRaceMetier[Ind];
          // une entrée explicitement indisponible ne se propage pas
          if PSource.Chance = SeparateurChance then
            continue;

          PRaceSource  := ChercheRace(PSource.CodeRace);
          EspeceSource := CodeSansLivre(PRaceSource.Espece);
          if EspeceSource = '' then
            continue;

          For PRaceCible in ListRace do
            begin
              if CodeSansLivre(PRaceCible.CodeRace) = CodeSansLivre(PSource.CodeRace) then
                continue;
              if CodeSansLivre(PRaceCible.Espece) <> EspeceSource then
                continue;

              Cle := CodeSansLivre(PRaceCible.CodeRace) + '|' + CodeSansLivre(PSource.CodeMetier);
              // garde-fou anti-doublon : ChargerLivre peut être rappelée sans vider les listes
              if Existant.IndexOf(Cle) >= 0 then
                continue;

              PNouveau          := PSource;
              PNouveau.CodeRace := PRaceCible.CodeRace;
              // L'ethnie cible n'a pas de table à elle ET la source est l'ethnie de
              // référence de la race : on lui transmet la fourchette telle quelle, donc
              // sa vraie table de tirage. Dans tous les autres cas on garde le
              // comportement d'origine, 'X' = éligible hors tirage.
              if (AvecTirage.IndexOf(CodeSansLivre(PRaceCible.CodeRace)) < 0)
                 and (Donneur.Values[CodeSansLivre(PRaceCible.Espece)] = CodeSansLivre(PSource.CodeRace)) then
                PNouveau.Chance := PSource.Chance
              else
                PNouveau.Chance := 'X';
              ListRaceMetier.Add(PNouveau);
              inc(NbRaceMetier);
              Existant.Add(Cle);
            end;
        end;
    finally
      Existant.Free;
      AvecTirage.Free;
      Donneur.Free;
    end;
  end;

Function VerifieRaceMetier(RaceChoisie: String; MetierActuel: String; MetierAVerifier:String):Boolean;
  var
    PRaceMetier: StructureRaceMEtier;
    Trouve:      Boolean = false;
  begin
    For PRaceMetier in ListRaceMetier do
      if CompareRechercheValeur(PRaceMetier.CodeRace, RaceChoisie) and CompareRechercheValeur(PRaceMetier.CodeMetier, MetierAVerifier) then
        begin
          if (MEtierActuel <> '') and (MetierActuel <> PRaceMetier.CodeMetier) then
            Trouve := True;
          break;
        end;
    Result := Trouve;
  end;

Function MetierRaceCourt(MetierActuel: String):String;
  var
    PRaceMetier: StructureRaceMEtier;
    PRace:       StructureRace;
    List:        String = '';
    Espece:      String;
  begin
    For PRaceMetier in ListRaceMetier do
      if CompareRechercheValeur(PRaceMetier.CodeMetier, MetierActuel) then
        begin
          PRace := chercheRace(PRaceMetier.CodeRace);
          Espece:= ChercheEspece(PRace.Espece).Libelle;
          if Pos(Espece, List) = 0 then
            begin
              if List <> '' then
                List := List + ', ';
              List := List + Espece;
            end;
        end;
    Result := List;
  end;

Function MetierRaceNbSuivant(RaceEnCours:String; MetierEnCours: String):Integer;
  var
    PRaceMetier:   StructureRaceMEtier;
    PMetier:       StructureMetier;
    TrouveMetier:  Boolean = false;
    ClasseEnCours: String;
    NbApres:       Integer = 0;

  begin
    For PRaceMetier in ListRaceMetier do
      if CompareRechercheValeur(PRaceMetier.CodeRace, RaceEnCours) then
        begin
          if not TrouveMetier then
            begin
              if CompareRechercheValeur(PRaceMetier.CodeMetier, MetierEncours) then
                begin
                  TrouveMetier  := true;
                  PMetier       := ChercheMetier(PRaceMetier.CodeMetier);
                  ClasseEnCours := PMetier.LibelleGroupe;
                end
            end
          else
            begin
              PMetier := ChercheMetier(PRaceMetier.CodeMetier);
              if PMetier.LibelleGroupe = ClasseEnCours then
                if PRaceMetier.Chance <> 'X' then
                  NbApres := NbApres + 1;
            end;
        end;
    Result := NbApres;
  end;


end.

