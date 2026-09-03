unit WinSpell;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  StdCtrls, BCButton, ChargeSort, GlobalFonts, ChargeConstantes, ChargeTalent,
  ChargeTexte, WinFiltre, UnitCalcul;

type

  { TWinSpells }

  TWinSpells = class(TForm)
    AffEffet: TMemo;
    AffNiveau: TEdit;
    AffCode: TEdit;
    AffLivre: TEdit;
    AffType: TEdit;
    AffLib: TEdit;
    AffPortee: TEdit;
    AffCible: TEdit;
    AffDuree: TEdit;
    ButtonFiltre: TBCButton;
    Image1: TImage;
    ImageWar: TImage;
    LabNiveau: TLabel;
    LabCode: TLabel;
    LabLivre: TLabel;
    LabType: TLabel;
    LabLib: TLabel;
    LabPortee: TLabel;
    LabCible: TLabel;
    LabDuree: TLabel;
    TabTalent: TStringGrid;
    TabSpell: TStringGrid;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure FormClose({%H-}Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabSpellDblClick({%H-}Sender: TObject);
    procedure TabSpellSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure WinCharger();
    procedure WinVider();
    Function SpellFiltre(PSort: StructureSort):Boolean;
  private

  public

  end;

var
  WinSpells:    TWinSpells;
  FiltreLivre:  String;
  FiltreTalent: String;
  FenFiltre:    TWinFiltre;

implementation

{$R *.lfm}

{ TWinSpells }

// Un sort est proposable si l'UN des talents qu'il cite correspond a l'UN des talents que porte
// le personnage. Le sort peut citer une FAMILLE entiere - "RULES-T0088_*" veut dire "n'importe
// quel Domaine arcanique" - alors que le personnage porte une specialisation precise, par exemple
// "RULES-T0088_FEU".
//
// Remplace, le 23/08/2026, un test qui tronquait la liste du sort a 5 caracteres des qu'elle
// contenait "_*" (ValT := copy(ValT,1,5)). Cette troncature datait d'avant les prefixes de livre,
// ou elle donnait bien "T0088" ; depuis, elle donne "RULES", present dans TOUS les codes - donc
// le test "Pos(ValT, SelectWinSort)" reussissait pour n'importe quel personnage et TOUS les sorts
// a talent generique etaient proposes a tout le monde. Symptome trouve par Nono : Kuno, pretre de
// Sigmar, se voyait offrir les sorts arcaniques en plus de ses miracles. CONTEXT.md 2.18.
//
// CompareRechercheValeur ne peut pas servir ici : VerifieRecherche compare les codes a
// l'IDENTIQUE et ne connait pas la generique "_*" (c'est ChercheTalent qui la traite a part,
// avec son repli explicite). Elle ne sait lever que le prefixe de livre.
//
// Les deux listes n'ont pas le meme separateur : le sort separe ses talents par ',' (donnees),
// ButtonSortClick construit la sienne avec des ' '. Les deux sont acceptes.
Function SortTalentAccessible(TalentsDuSort, TalentsDuPersonnage: String): Boolean;
  var
    ListeSort:  TStringList;
    ListePerso: TStringList;
    IndS:       Integer;
    IndP:       Integer;
  begin
    Result     := False;
    ListeSort  := TStringList.Create;
    ListePerso := TStringList.Create;
    try
      ExtractStrings([',', ' '], [], PChar(TalentsDuSort), ListeSort);
      ExtractStrings([',', ' '], [], PChar(TalentsDuPersonnage), ListePerso);
      for IndS := 0 to ListeSort.Count - 1 do
        for IndP := 0 to ListePerso.Count - 1 do
          begin
            // meme talent, au prefixe de livre pres
            if CompareRechercheValeur(ListeSort[IndS], ListePerso[IndP])
                or CompareRechercheValeur(ListePerso[IndP], ListeSort[IndS]) then
              Result := True
            // le sort ouvre toute une famille : on compare les familles
            else if Pos(ValeurGenerique, ListeSort[IndS]) > 0 then
              if ExtractStringBefore(ListeSort[IndS], ValeurGenerique)
                  = ExtractStringBefore(ListePerso[IndP], ValeurSousCompetence) then
                Result := True;
          end;
    finally
      ListeSort.Free;
      ListePerso.Free;
    end;
  end;

Function TWinSpells.SpellFiltre(PSort: StructureSort):Boolean;
var
  ResLivre:    Boolean = True;
  ResTalent:   Boolean = True;
begin
  if FiltreLivre <> '' then
    if not VerifieFiltre(PSort.Livre, FiltreLivre) then
      ResLivre := false;

  if filtreTalent <> '' then
    // TalentsDuSort et non PSort.ListeTalent : voir CONTEXT.md 2.39.
    if not VerifieFiltre(TalentsDuSort(PSort), filtreTalent) then
      ResTalent:= false;

  Result := (ResLivre and ResTalent);
end;

procedure TWinSpells.WinCharger();
  var
    PSort:        StructureSort;
    Nb:           Integer = 0;
    Acc:          Boolean;
  begin
      // Appeler la procédure SetGlobalFonts au démarrage du formulaire
      MiseEnFormeDesChamp(self);

      TabSpell.RowCount      := 1;
      // on met toutes les données dans la table pour les afficher directement dans les champs
      if TabSpell.ColCount < 2 then
        begin
          TabSpell.ColCount      := 1;
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_001'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_116'),20);
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_002'),250);
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_057'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_108'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_109'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_117'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_019'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_007'));
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_128'),100);
          GridAjouteColonne(TabSpell, GetTexteLibelle('LAB_001'),100);
        end;
      TabSpell.ColWidths[0]  := 20;

      Nb := 0;
      For PSort in ListSort do
        begin
          Acc   := true;

          if Pos(ValeurGenerique,PSort.CodeSort) <> 0 then
            Acc := False;

          // Le test etait ecrit DEUX FOIS a l'identique ici (lignes 122 et 125 avant le
          // 23/08/2026) ; la seconde copie ne faisait rien de plus, elle a ete retiree.
          if (SelectWinSort <> '') and not SortTalentAccessible(TalentsDuSort(PSort), SelectWinSort) then
            Acc := false;

          if Not SpellFiltre(PSort) then
            Acc := False;

          if Acc then
            begin
              Inc(Nb);
              TabSpell.RowCount       := TabSpell.RowCount + 1;
              TabSpell.Cells[ 1,Nb]   := PSort.CodeSort;
              TabSpell.Cells[ 2,Nb]   := GetTexteLibelle(PSort.TypeSort);
              TabSpell.Cells[ 3,Nb]   := PSort.Libelle;
              TabSpell.Cells[ 4,Nb]   := ReplaceTexteLibelle(PSort.Portee);
              TabSpell.Cells[ 5,Nb]   := ReplaceTexteLibelle(PSort.Cible);
              TabSpell.Cells[ 6,Nb]   := ReplaceTexteLibelle(PSort.Duree);
              TabSpell.Cells[ 7,Nb]   := PSort.Description;
              TabSpell.Cells[ 8,Nb]   := PSort.Niveau;
              // Colonne 9 = la liste COMPLETE des talents (champ du sort + DATA_SPELL_TALENT).
              // C'est elle que relit TabSpellSelection pour remplir TabTalent : en la
              // remplissant ici avec TalentsDuSort, l'affichage du detail suit sans autre
              // modification. CONTEXT.md 2.39.
              TabSpell.Cells[ 9,Nb]   := TalentsDuSort(PSort);
              TabSpell.Cells[10,Nb]   := GetTexteLibelle(PSort.Livre,'','',true);
              TabSpell.Cells[11,Nb]   := PSort.CodeSort;
           end
      end;

      TabTalent.RowCount      := 2;
      if TabTalent.ColCount < 2 then
        begin
          TabTalent.ColCount      := 1;
          TabTalent.ColWidths[0]  := 20;
          GridAjouteColonne(TabTalent, GetTexteLibelle('LAB_007'),100);
          GridAjouteColonne(TabTalent, GetTexteLibelle('LAB_001'));
        end;

      //Sort
      TabSpell.SortColRow(true,2);
      AdjustGridColumnsWidth(TabSpell, self.Height, false, true);
      AdjustGridColumnsWidth(TabTalent,self.Height, false, false);

      if FileExists(GetCurrentDir+ConstCheminLogo1) then
        ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

      Self.Caption              := GetTexteLibelle('LAB_083');
      Labcode.Caption           := GetTexteLibelle('LAB_001');
      LabLib.Caption            := GetTexteLibelle('LAB_002');
      LabType.Caption           := GetTexteLibelle('LAB_018');
      LabPortee.Caption         := GetTexteLibelle('LAB_057');
      LabCible.Caption          := GetTexteLibelle('LAB_108');
      LabDuree.Caption          := GetTexteLibelle('LAB_109');
      LabNiveau.Caption         := GetTexteLibelle('LAB_019');
      AffLivre.Caption          := GetTexteLibelle('LAB_128');
      ButtonFiltre.Caption      := GetTexteLibelle('LAB_133');

      TabSpell.Row := 1;
      TabSpellSelection(TabSpell, 1, 1);

      KeyPreview := true;
  end;

procedure TWinSpells.FormCreate(Sender: TObject);
  Begin
      WinCharger();
  end;

procedure TWinSpells.ButtonFiltreClick(Sender: TObject);
  begin
    SelectWinLivre      := FiltreLivre;
    SelectWinTalent     := FiltreTalent;
    WinFiltreAppelant   := ConstXmlSort;
    FenFiltre           := TWinFiltre.Create(Application);
    FenFiltre.Position  := poOwnerFormCenter;
    FenFiltre.ShowModal;
    if (ChoixWinLivre <> FiltreLivre) or (ChoixWinTalent <> FiltreTalent) then
     Begin
       FiltreLivre := ChoixWinLivre;
       FiltreTalent:= ChoixWinTalent;
       WinVider();
       WinCharger();
       TabSpellSelection(TabSpell, 1,1);
     end;
  end;

procedure TWinSpells.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  begin
    WinVider();
    CloseAction := caFree;
  end;

Procedure TWinSpells.WinVider();
  begin
    TabSpell.Clear;
    TabSpell.RowCount:= 1;
  end;

procedure TWinSpells.FormKeyPress(Sender: TObject; var Key: char);
  begin
    if Key = #27 then close;
  end;

procedure TWinSpells.TabSpellDblClick(Sender: TObject);
  begin
    if SelectWinSort <> '' then
     begin
       ChoixWinSort := TabSpell.Cells[1, TabSpell.Row];
       Close;
     end;
  end;

procedure TWinSpells.TabSpellSelection(Sender: TObject; aCol, aRow: Integer);
  Var
    PTalent:      StructureTalent;
    strings:      TStringList;
    ListeTalent:  String;
    Ind:          Integer;
    CheminImage:  String;
  begin
      // La grille peut n'avoir que sa ligne d'en-tete (aucun sort ne correspond aux talents du
      // personnage) : l'evenement de selection arrive quand meme et lisait alors une ligne
      // inexistante -> EGridException "Index Out of range". Vu le 22/08/2026 sur Kuno
      // Kreutzberg, dont les codes de talents sont enregistres SANS prefixe de livre et ne
      // matchent donc aucun sort (cause reelle, voir CONTEXT.md 2.19).
      if (aRow < 1) or (aRow >= TabSpell.RowCount) then Exit;
      AffCode.Text         := TabSpell.Cells[ 1,aRow];
      AffType.Text         := TabSpell.Cells[ 2,aRow];
      AffLib.Text          := TabSpell.Cells[ 3,aRow];
      AffPortee.Text       := TabSpell.Cells[ 4,aRow];
      AffLivre.Text        := TabSpell.Cells[10,aRow];
      if AffPortee.Text <> '' then
        Begin
          LabPortee.visible := true;
          AffPortee.visible := true;
         end
      else
        begin
          LabPortee.visible := false;
          AffPortee.visible := false;
        end;
      AffCible.Text        := TabSpell.Cells[ 5,aRow];
      if AffCible.Text <> '' then
        Begin
          LabCible.visible := true;
          AffCible.visible := true;
         end
      else
        begin
          LabCible.visible := false;
          AffCible.visible := false;
        end;
      AffDuree.Text        := TabSpell.Cells[ 6,aRow];
      if AffDuree.Text <> '' then
        Begin
          LabDuree.visible := true;
          AffDuree.visible := true;
         end
      else
        begin
          LabDuree.visible := false;
          AffDuree.visible := false;
        end;
      AffEffet.Text        := TabSpell.Cells[ 7,aRow];
      AffNiveau.Text       := TabSpell.Cells[ 8,aRow];
      if AffNiveau.Text <> '' then
        Begin
          LabNiveau.visible := true;
          AffNiveau.visible := true;
         end
      else
        begin
          LabNiveau.visible := false;
          AffNiveau.visible := false;
        end;
      ListeTalent := TabSpell.Cells[ 9,aRow];

      if ListeTalent <> '' then
        Begin
          TabTalent.visible := true;
          strings            := TStringList.Create;
          for Ind := 1 to TabTalent.RowCount - 1 do
            TabTalent.Cells[1, Ind] := '';
          ExtractStrings([','], [], PChar(ListeTalent), Strings);
          TabTalent.RowCount := Strings.Count + 1;
          For Ind := 0 to Strings.Count-1 do
            begin
              PTalent := ChercheTalent(Strings[Ind]);
              TabTalent.Cells[1,ind+1] := PTalent.Libelle;
              TabTalent.Cells[2,ind+1] := PTalent.CodeTalent;
            end;
          strings.Free;
           AdjustGridColumnsWidth(TabTalent,self.Height, false, true);
           CheminImage       := CheminSortImage(TabTalent.Cells[2,1]);
           if FileExists(CheminImage) then
              Image1.Picture.LoadFromFile(CheminImage)
           else
             Image1.Picture := nil;
         end
      else
        begin
          TabTalent.visible := false;
          Image1.Picture := nil;
        end;
      Image1.BringToFront;
      AdjustGridColumnsWidth(TabTalent,self.Height, false, false);
  end;

end.

