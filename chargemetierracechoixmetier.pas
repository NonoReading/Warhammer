unit ChargeMetierRaceChoixMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeMetier,
  ChargeTexte, ChargeRace, UnitCalcul;

Type
    StructureMetierRaceChoixMetier	= Record
	CodeRace:	String;
	CodeMetier:	String;
	CodeSousMetier: String;
        Livre:          String;
End;

  TListMetierRaceChoixMetier = specialize TList<StructureMetierRaceChoixMetier>;

Var
  ListMetierRaceChoixMetier:   TListMetierRaceChoixMetier;
  NbMetierRaceChoixMetier:     Integer;

function TexteMetierRaceChoixMetier(CodeMetier: String; CodeRace: String; ListeLivre: String):String;
function ResultMetierRaceChoixMetier(CodeMetier: String; CodeRace: String; ListeLivre: String): String;

implementation

function TexteMetierRaceChoixMetier(CodeMetier: String; CodeRace: String; ListeLivre: String):String;
  Var
    PMetierRaceChoixMetier: StructureMetierRaceChoixMetier;
    Texte:             String = '';
    PMetier:           StructureMetier;
    PRace:             StructureRace;
    RaceEnCours:       String = '';
  begin
    if AvecRaceChoixMetier = true then
      For PMetierRaceChoixMetier in ListMetierRaceChoixMetier do
        if CompareRechercheValeur(PMetierRaceChoixMetier.CodeMetier, CodeMetier) and ( CompareRechercheValeur(PMetierRaceChoixMetier.CodeRace, CodeRace) or (CodeRace = '') ) and VerifieFiltre(PMetierRaceChoixMetier.Livre, ListeLivre) then
          begin
            if PMetierRaceChoixMetier.CodeRace <> RaceEnCours then
              begin
                PRace := ChercheRace(PMetierRaceChoixMetier.CodeRace);
                Texte := Texte + SeparateurRetourLigne + SeparateurRetourLigne + PRace.Libelle + SeparateurRetourLigne + GetTexteLibelle('LAB_127') + ' : ';
                RaceEnCours := PRace.CodeRace;
              end;
            PMetier := ChercheMetier(PMetierRaceChoixMetier.CodeSousMetier);
            Texte   := Texte + SeparateurRetourLigne + PMetier.Libelle;
          end;
    Result   := Texte;
  end;

function ResultMetierRaceChoixMetier(CodeMetier: String; CodeRace: String; ListeLivre: String): String;
  Var
    PMetierRaceChoixMetier: StructureMetierRaceChoixMetier;
    CodeRes:                String = '';
  begin
    CodeRes := CodeMetier;
    if AvecRaceChoixMetier = true then
      For PMetierRaceChoixMetier in ListMetierRaceChoixMetier do
        if CompareRechercheValeur(PMetierRaceChoixMetier.CodeMetier, CodeMetier) and CompareRechercheValeur(PMetierRaceChoixMetier.CodeRace, CodeRace) and VerifieFiltre(PMetierRaceChoixMetier.Livre, ListeLivre) then
            CodeRes := CodeRes + SeparateurMulti + PMetierRaceChoixMetier.CodeSousMetier;
    Result   := CodeRes;
  end;


end.

