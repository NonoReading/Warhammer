unit ChargeTraduction;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, LazUTF8,
  ChargeAttribut, ChargeTexte, ChargeCompetence, ChargeTalent, ChargeRace,
  ChargeMetier, ChargeArme, ChargeArmeBonus, ChargeArmure, ChargeArmureBonus,
  ChargeSort, ChargeFabrication, ChargeCorruptionTable, UnitCalcul;

Type
  StructureTraduction   = record
    TypeDonnee:  string;
    Code:        string;
    Langue:      String;
    Libelle:     string;
    Description: string;
    Tests:       string;
    Resume:      string;
    Livre:       String;
  end;

  StructureLivreTraduit = record
    Livre:       String;
    Langue:      String;
  end;

   TListTraduction = Specialize TList<StructureTraduction>;
   TListLivreTraduit = Specialize TList<StructureLivreTraduit>;

   Function InitTrad(TypeDonnee: String; Code: String; Code2: String; Livre: String): StructureTraduction;
   Procedure AddTrad(PTraduction: StructureTraduction; Langue:String);
   Procedure Traduit(Langue: String; Livre: String);

var
  ListTraduction:   TListTraduction;
  ListLivreTraduit: TListLivreTraduit;
  NbTraduction:     Integer;
  NBLivreTraduit:   Integer;

implementation

Function InitTrad(TypeDonnee: String; Code: String; Code2: String; Livre: String): StructureTraduction;
  Var
    PTraduction: StructureTraduction;
  begin
    PTraduction.TypeDonnee   := TypeDonnee;
    PTraduction.Code         := Code;
    if Code2 <> '' then
      PTraduction.Code       := PTraduction.Code + ' ' + Code2;
    PTraduction.Langue       := '';
    PTraduction.Libelle      := '';
    PTraduction.Description  := '';
    PTraduction.Tests        := '';
    PTraduction.Resume       := '';
    PTraduction.Livre        := Livre;

    result := PTraduction;
  end;

Procedure AddTrad(PTraduction: StructureTraduction; Langue:String);
  Var
    PLivreTraduit: StructureLivreTraduit;
    Trouve:        Boolean = False;
  Begin
    PTraduction.Langue       := Langue;
    ListTraduction.add(PTraduction);
    inc(NbTraduction);

    For PLivreTraduit in ListLivreTraduit do
      if (PLivreTraduit.Livre = PTraduction.Livre) and (PLivreTraduit.Langue = PTraduction.Langue) then
        Trouve := true;
    if Not Trouve then
      begin
        PLivreTraduit.Livre := PTraduction.Livre;
        PLivreTraduit.Langue:= PTraduction.Langue;
        ListLivreTraduit.add(PLivreTraduit);
        inc(NBLivreTraduit);
      end;

  end;

Procedure Traduit(Langue: String; Livre: String);
  var
    Ind:          Integer;
    PTraduction:  StructureTraduction;
    PAttribut:    StructureAttribut;
    PTexte:       StructureTexte;
    PCompetence:  StructureCompetence;
    PTalent:      StructureTalent;
    PRace:        StructureRace;
    PMetier:      StructureMetier;
    PArme:        StructureArme;
    PArmeBonus:   StructureArmeBonus;
    PArmure:      StructureArmure;
    PArmureBonus: StructureArmureBonus;
    PSort:        StructureSort;
    PFabrication: StructureFabrication;
    PCorruptionTable: StructureCorruptionTable;
  begin
    // Pas de garde sur Langue = ConstAnglais ici : ListTexte/ListeAttribut/etc. ne sont
    // PAS rechargées avec du texte anglais frais lors d'un changement de livre/langue en
    // direct (XmlImport y est appelé avec OnlyPrimary=false, qui saute tout le bloc Texte/
    // Attribut/AttributAugmentation/CompetenceAugmentation - seul le premier chargement au
    // démarrage, avec OnlyPrimary=true, les remplit). Revenir à l'anglais doit donc, comme
    // pour toute autre langue, réappliquer explicitement les valeurs mises en cache dans
    // ListTraduction (qui contient bien des entrées Langue=ConstAnglais, ajoutées sans
    // condition par AddTrad dès le chargement initial). CONTEXT.md §2.8 (bug du 17/08/2026).
    For PTraduction in ListTraduction do
          if (PTraduction.Langue = Langue) and ((Livre = '') or (PTraduction.Livre = Livre)) then
            case PTraduction.TypeDonnee of
              ConstPAttribut:
                for Ind :=0 to ListeAttribut.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListeAttribut[Ind].CodeAttribut) then
                    begin
                      PAttribut             := ListeAttribut[Ind];
                      PAttribut.Description := PTraduction.Description;
                      PAttribut.Libelle     := PTraduction.Libelle;
                      PAttribut.Resume      := PTraduction.Resume;
                      ListeAttribut[Ind]    := PAttribut;
                    end;
              ConstPTexte:
                for Ind :=0 to ListTexte.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListTexte[Ind].Code) then
                    begin
                      PTexte             := ListTexte[Ind];
                      PTexte.Libelle     := PTraduction.Libelle;
                      ListTexte[Ind]    := PTexte;
                    end;
              ConstPCompetence:
                for Ind :=0 to ListCompetence.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListCompetence[Ind].CodeCompetence) then
                    begin
                      PCompetence             := ListCompetence[Ind];
                      PCompetence.Description := PTraduction.Description;
                      PCompetence.Libelle     := PTraduction.Libelle;
                      ListCompetence[Ind]     := PCompetence;
                    end;
              ConstPTalent:
                for Ind :=0 to ListTalent.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListTalent[Ind].CodeTalent) then
                    begin
                      PTalent             := ListTalent[Ind];
                      PTalent.Description := PTraduction.Description;
                      PTalent.Libelle     := PTraduction.Libelle;
                      PTalent.tests       := PTraduction.tests;
                      PTalent.Resume      := PTraduction.Resume;
                      ListTalent[Ind]     := PTalent;
                    end;
              ConstPRace:
                for Ind :=0 to ListRace.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListRace[Ind].CodeRace) then
                    begin
                      PRace             := ListRace[Ind];
                      PRace.Description := PTraduction.Description;
                      PRace.Libelle     := PTraduction.Libelle;
                      ListRace[Ind]     := PRace;
                    end;
              ConstPMetier:
                for Ind :=0 to ListMetier.Count - 1 do
                  if CompareRechercheValeur(ListMetier[Ind].CodeMetier, PTraduction.Code) then
                    begin
                      PMetier             := ListMetier[Ind];
                      PMetier.Description := PTraduction.Description;
                      PMetier.Libelle     := PTraduction.Libelle;
                      ListMetier[Ind]     := PMetier;
                    end;
              ConstPArme:
                for Ind :=0 to ListArme.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListArme[Ind].CodeArme) then
                    begin
                      PArme             := ListArme[Ind];
                      PArme.Libelle     := PTraduction.Libelle;
                      ListArme[Ind]     := PArme;
                    end;
              ConstPArmeBonus:
                for Ind :=0 to ListArmeBonus.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListArmeBonus[Ind].CodeArmeBonus) then
                    begin
                      PArmeBonus             := ListArmeBonus[Ind];
                      PArmeBonus.Description := PTraduction.Description;
                      PArmeBonus.Libelle     := PTraduction.Libelle;
                      PArmeBonus.Resume      := PTraduction.Resume;
                      ListArmeBonus[Ind]     := PArmeBonus;
                    end;
              ConstPArmure:
                for Ind :=0 to ListArmure.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListArmure[Ind].CodeArmure) then
                    begin
                      PArmure             := ListArmure[Ind];
                      PArmure.Libelle     := PTraduction.Libelle;
                      ListArmure[Ind]     := PArmure;
                    end;
              ConstPArmureBonus:
                for Ind :=0 to ListArmureBonus.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListArmureBonus[Ind].CodeArmureBonus) then
                    begin
                      PArmureBonus             := ListArmureBonus[Ind];
                      PArmureBonus.Description := PTraduction.Description;
                      PArmureBonus.Libelle     := PTraduction.Libelle;
                      ListArmureBonus[Ind]     := PArmureBonus;
                    end;
              ConstPSort:
                for Ind :=0 to ListSort.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListSort[Ind].CodeSort) then
                    begin
                      PSort             := ListSort[Ind];
                      PSort.Description := PTraduction.Description;
                      PSort.Libelle     := PTraduction.Libelle;
                      ListSort[Ind]     := PSort;
                    end;
              ConstPFabrication:
                for Ind :=0 to ListFabrication.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListFabrication[Ind].CodeFabrication) then
                    begin
                      PFabrication             := ListFabrication[Ind];
                      PFabrication.Description := PTraduction.Description;
                      PFabrication.Libelle     := PTraduction.Libelle;
                      PFabrication.Resume      := PTraduction.Resume;
                      ListFabrication[Ind]     := PFabrication;
                    end;
              ConstPCorruptionTable:
                // Code = code stable du catalogue (ex. "RULES-CORMEN_007", book-prefixed) depuis
                // le pivot du 17/08/2026 - CompareRechercheValeur standard, comme les autres
                // catalogues (Talents, Races, ...). Avant ce pivot, Code était une clé composée
                // TypeCorruption+Chance (plage D100), incompatible avec CompareRechercheValeur.
                for Ind :=0 to ListCorruptionTable.Count - 1 do
                  if CompareRechercheValeur(PTraduction.Code, ListCorruptionTable[Ind].Code) then
                    begin
                      PCorruptionTable         := ListCorruptionTable[Ind];
                      PCorruptionTable.Libelle := PTraduction.Libelle;
                      PCorruptionTable.Effet   := PTraduction.Description;
                      ListCorruptionTable[Ind] := PCorruptionTable;
                    end;
            end;

  end;

end.

