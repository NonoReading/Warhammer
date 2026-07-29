unit ChargeRaceOpinion;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

Type
  StructureRaceOpinion = Record
    Livre:       String;      // Le livre (ex: "RULES")
    CodeRace:    String;      // La race qui donne son opinion
    TargetRace:  String;      // La race sur laquelle on donne son avis
    Citation:    String;      // La citation exacte
    Source:      String;      // Le personnage/source (ex: "Reikäger Jungling, State Soldier from Altdorf")
  End;

  TListRaceOpinion = Specialize TList<StructureRaceOpinion>;

var
  ListRaceOpinion: TListRaceOpinion;
  NbRaceOpinion:   Integer;

implementation

end.
