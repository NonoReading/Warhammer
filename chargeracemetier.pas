unit ChargeRaceMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeMetier, Generics.Collections, ChargeTexte, ChargeRace, UnitCalcul;

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

implementation

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
          Espece:= GetTexteLibelle(PRace.Espece);
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

