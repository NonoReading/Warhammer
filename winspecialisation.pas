unit WinSpecialisation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, GlobalFonts,
  ChargeTalent, ChargeCompetence, UnitCalcul, ChargeConstantes, ChargeTexte,
  ChargeArme, ChargeArmure, ChargeArmureSimplifie;

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
        if Pos(SeparateurMulti, CodeGenerique) > 0 then
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
            if VerifieFiltre(PTalent.Livre, FiltreLivre) then
              AjouteLigne(CodeGenerique, PTalent.CodeTalent, PTalent.Libelle, '', false);

      ConstXmlSousChapitreCompetence:      // Compétences
        for PCompetence in ListCompetence do
          if VerifieFiltre(Pcompetence.Livre, FiltreLivre) then
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
              case copy(res,1,5) of
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
        end;
        SelWinLibelle  := Lib;
        SelWinType     := Typ;
        close;
      end;
  end;

end.

