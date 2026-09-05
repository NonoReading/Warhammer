unit WinSpecialisation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, GlobalFonts,
  ChargeTalent, ChargeCompetence, UnitCalcul, ChargeConstantes, ChargeTexte,
  ChargeArme, ChargeArmure, ChargeArmureSimplifie, ChargeMetierCompetence, ChargeRace,
  ChargeMetier;

type

  { TWinSpecialisation }

  { TWinSpecialisations }

  TWinSpecialisations = class(TForm)
    TabSpecialisation: TStringGrid;
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure TabSpecialisationDblClick({%H-}Sender: TObject);
    Procedure ChargeSpecialisation(CodeGenerique: String);
    Procedure AjouteLigne(Gen: String; Code: String; Lib :string; Typ :String; SansTest :Boolean);

  private

  public

  end;

var
  WinSpecialisations: TWinSpecialisations;
  FiltreLivre:        String;

implementation

{$R *.lfm}

{ TWinSpecialisation }

Procedure TWinSpecialisations.AjouteLigne(Gen: String; Code: String; Lib :string; Typ :String; SansTest :Boolean);
// ajouter une ligne dans la table
  Begin
    if (SansTest = true) or
       ((ExtractStringBefore(Code,'_') = ExtractStringBefore(Gen,'_'))
           and (Pos(SeparateurMulti, Code) = 0)
           and (Pos(ValeurGenerique, Code) = 0)) then
      begin
        TabSpecialisation.rowcount := TabSpecialisation.rowcount + 1;
        TabSpecialisation.Cells[1, TabSpecialisation.rowcount-1] := Code;
        TabSpecialisation.Cells[2, TabSpecialisation.rowcount-1] := Lib;
        TabSpecialisation.Cells[3, TabSpecialisation.rowcount-1] := Typ;
      end;

  end;

Procedure TWinSpecialisations.ChargeSpecialisation(CodeGenerique: String);
// ajout les données dans la table
  var
    PTalent:           StructureTalent;
    PCompetence:       StructureCompetence;
    PArme:             StructureArme;
    PArmure:           StructureArmure;
    PArmureSimplifiee: StructureArmureSimplifiee;
    Res:               String;
    NbL:               Integer;
    MaxL:              Integer;
    ListOpt:           TStringList;
  begin
    case ChoixWinTypeFichier of
      ConstXmlSousChapitreTalent:    // Talents
        // Trait d'ethnie : ses options sont proposees comme le seraient les branches
        // d'un choix A/B. Teste AVANT le Pos(SeparateurMulti), parce qu'un code de trait
        // ne contient pas de '/' et tomberait sinon dans le catalogue complet des
        // talents. Le libelle vient de la table des options. CONTEXT.md 2.41.
        if ChercheTrait(CodeGenerique).CodeTrait <> '' then
          begin
            ListOpt := OptionsDuTrait(CodeGenerique);
            for NbL := 0 to ListOpt.Count - 1 do
              AjouteLigne(CodeGenerique, ListOpt[NbL],
                          ChercheTraitOption(ListOpt[NbL]).Libelle, '', true);
            ListOpt.Free;
          end
        else if Pos(SeparateurMulti, CodeGenerique) > 0 then
          begin
            ListOpt := ListeTalent(CodeGenerique);
            for NbL := 0 to ListOpt.Count - 1 do
              begin
                PTalent := ChercheTalent(ListOpt[NbL]);
                if VerifieFiltre(PTalent.Livre, FiltreLivre) then
                  AjouteLigne(CodeGenerique, ListOpt[NbL], PTalent.Libelle, '', true);
              end;
            ListOpt.Free;
          end
        else
          for PTalent in ListTalent do
            // les traits de creature sont exclus : ils s'acquierent a la naissance par la race,
            // jamais par un choix du joueur (CONTEXT.md 2.15). C'est le SEUL endroit du
            // programme qui propose le catalogue complet - partout ailleurs les talents
            // viennent d'une table explicite (ListMetierTalent, ListRaceTalent,
            // ListTalentCreation), donc rien d'autre a filtrer.
            if VerifieFiltre(PTalent.Livre, FiltreLivre) and (not PTalent.Trait) then
              AjouteLigne(CodeGenerique, PTalent.CodeTalent, PTalent.Libelle, '', false);

      ConstXmlSousChapitreCompetence:      // Compétences
        if Pos(SeparateurMulti, CodeGenerique) > 0 then
          begin
            ListOpt := ListeMetierCompetence(CodeGenerique);
            for NbL := 0 to ListOpt.Count - 1 do
              begin
                PCompetence := ChercheCompetence(ListOpt[NbL]);
                if VerifieFiltre(PCompetence.Livre, FiltreLivre) then
                  AjouteLigne(CodeGenerique, ListOpt[NbL], PCompetence.Libelle, '', true);
              end;
            ListOpt.Free;
          end
        else
          for PCompetence in ListCompetence do
            if VerifieFiltre(PCompetence.Livre, FiltreLivre) then
              AjouteLigne(CodeGenerique, PCompetence.CodeCompetence, PCompetence.Libelle, '', false);

      ConstXmlSousChapitreArme:     // Armess
        for PArme in ListArme do
          if VerifieFiltre(PArme.Livre, FiltreLivre) then
            AjouteLigne(CodeGenerique, PArme.CodeArme, PArme.Libelle, '', false);

      ConstXmlSousChapitreArmure:   // Armures
        for PArmure in ListArmure do
          if VerifieFiltre(PArmure.Livre, FiltreLivre) then
            AjouteLigne(CodeGenerique, PArmure.CodeArmure, PArmure.Libelle, '', false);

      ConstXmlSousChapitreArmureSimp: // Set d'armure
        for PArmureSimplifiee in ListArmureSimplifiee do
          if VerifieFiltre(PArmureSimplifiee.Livre, FiltreLivre) then
            AjouteLigne(CodeGenerique, PArmureSimplifiee.CodeArmure, PArmureSimplifiee.Libelle, '', false);

      ConstXmlChapitreEquipement:   // Equipements
        begin
          MaxL                    := CountOccurrences(CodeGenerique, ',') + 1;
          For NbL := 1 to MaxL do
            begin
              Res                 := ExtractChaine(',',CodeGenerique, NbL);
              // Le code porte son prefixe de livre (RULES-COMB_BASE_01) : tester les cinq
              // premiers caracteres de Res donnait "RULES", jamais COMB_/PROJ_/MUNI_/ARMO_,
              // donc TOUT tombait dans le else et s'affichait avec son code brut en libelle
              // et "Various" en type. Meme moule que GetTypeMetierEquipement
              // (unitcalcul.pas l.218) : on decoupe d'abord, on teste CodeValeur ensuite.
              DecoupeCodeValeur(Res);
              case copy(CodeValeur,1,5) of
                EquipementCC,EquipementCT,EquipementMU:
                  begin
                    PArme         := chercheArme(res);
                    if VerifieFiltre(PArme.Livre, FiltreLivre) then
                      AjouteLigne(CodeGenerique, PArme.CodeArme, PArme.Libelle, TypeEquipWe, false);
                  end;
                EquipementAR:
                  begin
                    PArmure       := chercheArmure(res);
                    if VerifieFiltre(PArmure.Livre, FiltreLivre) then
                      AjouteLigne(CodeGenerique, PArmure.CodeArmure, PArmure.Libelle, TypeEquipAr, false);
                  end;
                else
                  begin
                    AjouteLigne(CodeGenerique, Res, Res, TypeEquipDi, true);
                  end;
              end;
            end;
        end;

      ConstXmlDataCareerBonus:      // Appartenances (regiment, ordre de chevalerie, culte)
        // CodeGenerique est ICI une liste de codes deja filtree par
        // AppartenancesCandidates (metier + ethnie + non deja acquises) - meme forme que
        // la liste d'equipement juste au-dessus. Rien n'est donc filtre a nouveau, et pas
        // davantage sur le livre : une appartenance n'existe que si son livre est charge.
        // La premiere ligne, de code VIDE, est le "aucune" : le programme ne peut pas
        // deviner qu'un soldat est un mercenaire sans regiment, il faut pouvoir le dire.
        // CONTEXT.md 2.44.
        begin
          AjouteLigne(CodeGenerique, '', GetTexteLibelle(ConstLabSansAppartenance), '', true);
          MaxL := CountOccurrences(CodeGenerique, ',') + 1;
          For NbL := 1 to MaxL do
            begin
              Res := Trim(ExtractChaine(',', CodeGenerique, NbL));
              if Res <> '' then
                AjouteLigne(CodeGenerique, Res, ChercheCareerBonus(Res).Libelle, '', true);
            end;
        end;
    end;
    AdjustGridColumnsWidth(TabSpecialisation,self.Height, true, true);
  end;

procedure TWinSpecialisations.FormCreate(Sender: TObject);
// initialisation
  begin
    MiseEnFormeDesChamp(self);
          // on met toutes les données dans la table pour les afficher directement dans les champs
    TabSpecialisation.RowCount      := 1;
    TabSpecialisation.ColCount      := 4;
    TabSpecialisation.ColWidths[0]  := 20;
    TabSpecialisation.Cells[1,0]    := GetTexteLibelle('LAB_002');
    TabSpecialisation.ColWidths[1]  := 200;
    TabSpecialisation.Cells[2,0]    := GetTexteLibelle(ConstLabSelSpe);
    TabSpecialisation.ColWidths[2]  := 250;
    TabSpecialisation.Cells[3,0]    := '';
    TabSpecialisation.ColWidths[3]  := 0;

    FiltreLivre := SelectWinLivre;

    case ChoixWinTypeFichier of
      ConstXmlSousChapitreTalent:       ChargeSpecialisation(ChoixWinTalent);
      ConstXmlSousChapitreCompetence:   ChargeSpecialisation(ChoixWinCompetence);
      ConstXmlSousChapitreArme:         ChargeSpecialisation(ChoixWinArme);
      ConstXmlSousChapitreArmure:       ChargeSpecialisation(ChoixWinArmure);
      ConstXmlSousChapitreArmureSimp:   ChargeSpecialisation(ChoixWinArmureSimp);
      ConstXmlChapitreEquipement:       ChargeSpecialisation(ChoixWinEquipement);
      ConstXmlDataCareerBonus:          ChargeSpecialisation(ChoixWinCareerBonus);
    end;

  end;

procedure TWinSpecialisations.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color   := ClWhite;
  Canvas.Pen.Width   := 3;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(2, 2, ClientWidth - 2, ClientHeight - 2);
end;

procedure TWinSpecialisations.TabSpecialisationDblClick(Sender: TObject);
// renvoyer le code sélectionné et fermer la fenête
  var
    Val: String;
    Lib: String;
    Typ: String;
  begin
    if TabSpecialisation.Row > 0 then
      begin
        Val := TabSpecialisation.Cells[1, TabSpecialisation.Row];
        Lib := TabSpecialisation.Cells[2, TabSpecialisation.Row];
        Typ := TabSpecialisation.Cells[3, TabSpecialisation.Row];
        case ChoixWinTypeFichier of
          ConstXmlSousChapitreTalent:     SelectWinTalent     := Val;
          ConstXmlSousChapitreCompetence: SelectWinCompetence := Val;
          ConstXmlSousChapitreArme:       SelectWinArme       := Val;
          ConstXmlSousChapitreArmure:     SelectWinArmure     := Val;
          ConstXmlSousChapitreArmureSimp: SelectWinArmureSimp := Val;
          ConstXmlChapitreEquipement:     SelectWinEquipement := Val;
          // Val vide = la ligne "aucune appartenance", et c'est une reponse valable :
          // l'appelant ne greffe rien. CONTEXT.md 2.44.
          ConstXmlDataCareerBonus:        SelectWinCareerBonus := Val;
        end;
        SelWinLibelle  := Lib;
        SelWinType     := Typ;
        close;
      end;
  end;

end.

