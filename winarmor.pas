unit WinArmor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, BCButton, ChargeArmure, GlobalFonts, ChargeConstantes,
  UnitCalcul, ChargeArmureBonus, ChargeArmureBonusModif, ChargeCompetence,
  ChargeTexte, WinFiltre, ChargeArmureSimplifie, AncrageProportionnel,
  ChargeFabrication;

type

  { TWinArmors }

  TWinArmors = class(TForm)
    AffCode: TEdit;
    AffDescription: TMemo;
    AffEmplacement: TEdit;
    AffLivre: TEdit;
    AffProtection: TEdit;
    AffType: TEdit;
    AffLib: TEdit;
    AffDisponbilite: TEdit;
    AffPrix: TEdit;
    AffEncombrement: TEdit;
    ButtonFiltre: TBCButton;
    CheckBoxSimplified: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    ImageWar: TImage;
    LabCode: TLabel;
    LabQuickArmor: TLabel;
    LabEmplacement: TLabel;
    LabBonus: TLabel;
    LabLivre: TLabel;
    LabProtection: TLabel;
    LabDisponibilite: TLabel;
    LabPrix: TLabel;
    LabType: TLabel;
    LabLib: TLabel;
    LabEncombrement: TLabel;
    LabFabIntegree: TLabel;
    TabBonus: TStringGrid;
    TabFabIntegree: TStringGrid;
    TabArmor: TStringGrid;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure CheckBoxSimplifiedClick(Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure FormResize({%H-}Sender: TObject);
    procedure TabArmorDblClick({%H-}Sender: TObject);
    procedure TabArmorSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabBonusSelection({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
    procedure TabFabIntegreeSelection({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
    procedure WinCharger();
    procedure WinVider();
  private
    Ancrage: TAncrageProportionnel;

  public

  end;

var
  WinArmors:      TWinArmors;
  FiltreLivre:    String;
  FenFiltre:      TWinFiltre;

implementation

{$R *.lfm}

{ TWinArmors }

procedure TWinArmors.FormResize(Sender: TObject);
begin
    if Ancrage <> nil then
      Ancrage.Appliquer;
end;

procedure TWinArmors.FormCreate(Sender: TObject);
  begin
    FiltreLivre := SelectWinLivre;
    CheckBoxSimplified.Checked := SelectWinQuickArmor;
    WinCharger();
    // Ancrage proportionnel, meme regle que WinRace (voir AncrageProportionnel).
    Ancrage := TAncrageProportionnel.Create(Self);
    Ancrage.Ajouter(TabArmor, 0, 0.5);
    Ancrage.Ajouter(AffCode, 0.5, 0);
    Ancrage.Ajouter(LabCode, 0.5, 0);
    Ancrage.Ajouter(LabLib, 0.5, 0);
    Ancrage.Ajouter(AffLib, 0.5, 0);
    Ancrage.Ajouter(ImageWar, 0.25, 0);
    Ancrage.Ajouter(LabType, 0.5, 0);
    Ancrage.Ajouter(AffType, 0.5, 0);
    Ancrage.Ajouter(LabPrix, 0.5, 0);
    Ancrage.Ajouter(AffPrix, 0.5, 0);
    Ancrage.Ajouter(LabEncombrement, 0.5, 0);
    Ancrage.Ajouter(AffEncombrement, 0.5, 0);
    Ancrage.Ajouter(LabProtection, 0.5, 0);
    Ancrage.Ajouter(AffProtection, 0.5, 0);
    Ancrage.Ajouter(LabDisponibilite, 0.5, 0);
    Ancrage.Ajouter(AffDisponbilite, 0.5, 0);
    Ancrage.Ajouter(LabEmplacement, 0.5, 0);
    Ancrage.Ajouter(AffEmplacement, 0.5, 0);
    Ancrage.Ajouter(TabBonus, 0.5, 0);
    Ancrage.Ajouter(LabBonus, 0.5, 0);
    Ancrage.Ajouter(TabFabIntegree, 0.5, 0);
    Ancrage.Ajouter(LabFabIntegree, 0.5, 0);
    Ancrage.Ajouter(AffDescription, 0.5, 0.5);
    Ancrage.Ajouter(LabLivre, 0.5, 0);
    Ancrage.Ajouter(AffLivre, 0.5, 0);
    Ancrage.Ajouter(Image1, 1, 0);
    Ancrage.Ajouter(Image2, 1, 0);
    Ancrage.Ajouter(Image3, 1, 0);
    Ancrage.Ajouter(ButtonFiltre, 0, 0.5);
    Ancrage.Fixer;
  end;

procedure TWinArmors.WinCharger();
var
  PArmure:           StructureArmure;
  PArmureSimplifiee: StructureArmureSimplifiee;
  NbWeap:            Integer = 0;
  IndTab:            Integer = 0;
  begin
      // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    TabArmor.RowCount      := 1;
    // on met toutes les données dans la table pour les afficher directement dans les champs
    if TabArmor.ColCount < 2 then
      begin
        TabArmor.ColCount      := 1;
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_001'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_074'),120);
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_002'),220);
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_075'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_054'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_055'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_056'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_076'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_059'));
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_128'),100);
        GridAjouteColonne(TabArmor,GetTexteLibelle('RULES-LAB_001'),100);
        // Colonne 12, cachee : fabrication D'ORIGINE (PArmure.Fabrication), lue par
        // TabArmorSelection pour remplir TabFabIntegree ci-dessous.
        GridAjouteColonne(TabArmor,'',0);
      end;
    TabArmor.ColWidths[0]  := 20;

        // on met toutes les données dans la table pour les afficher directement dans les champs
    TabBonus.RowCount      := 7;
    if TabBonus.ColCount < 2 then
      begin
        TabBonus.ColCount      := 1;
        TabBonus.ColWidths[0]  := 20;
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_002'),120);
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_072'));
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_077'),300);
      end;

        // Fabrication D'ORIGINE (Durable/Fine imprimes dans le livre sur certains objets,
        // chantier "objets a fabrication integree", CONTEXT.md 2.29) : meme moule que TabBonus
        // ci-dessus, mais lit PArmure.Fabrication au lieu de ListeBonus.
    TabFabIntegree.RowCount := 7;
    if TabFabIntegree.ColCount < 2 then
      begin
        TabFabIntegree.ColCount      := 1;
        TabFabIntegree.ColWidths[0]  := 20;
        GridAjouteColonne(TabFabIntegree,GetTexteLibelle('RULES-LAB_002'),120);
        // Colonne cachee (largeur 0, meme moule que TabBonus/LAB_072 ci-dessus) : le texte
        // COMPLET (long), affiche seulement dans AffDescription au clic sur la ligne. C'est
        // l'avoir mis ici, en clair, dans une colonne VISIBLE qui faisait deborder le tableau
        // hors de la fenetre - corrige le 23/09/2026.
        GridAjouteColonne(TabFabIntegree,GetTexteLibelle('RULES-LAB_072'));
        GridAjouteColonne(TabFabIntegree,GetTexteLibelle('RULES-LAB_077'),300);
      end;

    IndTab := 0;
    if (CheckBoxSimplified.Checked = false) then
      begin
        TabArmor.ColWidths[2]               := 120;
        for Parmure in ListArmure do
          if (Pos(ValeurGenerique,PArmure.CodeArmure) = 0) and VerifieFiltre(PArmure.Livre, FiltreLivre) then
            begin
              Inc(IndTab);
              if TabArmor.RowCount <= IndTab then
                TabArmor.RowCount := TabArmor.RowCount + 1;

              TabArmor.Cells[ 1,NbWeap+1]  := PArmure.CodeArmure;
              TabArmor.Cells[ 2,NbWeap+1]  := GetAllTexteLibelle(PArmure.TypeMateriel);
              TabArmor.Cells[ 3,NbWeap+1]  := PArmure.Libelle;
              TabArmor.Cells[ 4,NbWeap+1]  := GetAllTexteLibelle(PArmure.Emplacement);
              TabArmor.Cells[ 5,NbWeap+1]  := TraduirePrix(PArmure.Prix);
              TabArmor.Cells[ 6,NbWeap+1]  := IntToStr(PArmure.Encombrement);
              TabArmor.Cells[ 7,NbWeap+1]  := GetAllTexteLibelle(PArmure.Disponibilite);
              TabArmor.Cells[ 8,NbWeap+1]  := IntToStr(PArmure.Protection);
              TabArmor.Cells[ 9,NbWeap+1]  := PArmure.ListeBonus;
              TabArmor.Cells[10,NbWeap+1]  := GetTexteLibelle(PArmure.Livre,'','',true);
              TabArmor.Cells[11,NbWeap+1]  := PArmure.CodeArmure;
              TabArmor.Cells[12,NbWeap+1]  := PArmure.Fabrication;
              Inc(NbWeap);
           end;
        end
    else
      begin
        TabArmor.ColWidths[2]               := 0;
        for PArmureSimplifiee in ListArmureSimplifiee do
          if (Pos(ValeurGenerique,PArmureSimplifiee.CodeArmure) = 0) and VerifieFiltre(PArmureSimplifiee.Livre, FiltreLivre) then
            begin
              Inc(IndTab);
              if TabArmor.RowCount <= IndTab then
                TabArmor.RowCount := TabArmor.RowCount + 1;

              TabArmor.Cells[ 1,NbWeap+1]  := PArmureSimplifiee.CodeArmure;
              TabArmor.Cells[ 3,NbWeap+1]  := PArmureSimplifiee.Libelle;
              TabArmor.Cells[ 5,NbWeap+1]  := TraduirePrix(PArmureSimplifiee.Prix);
              TabArmor.Cells[ 6,NbWeap+1]  := IntToStr(PArmureSimplifiee.Encombrement);
              TabArmor.Cells[ 7,NbWeap+1]  := GetAllTexteLibelle(PArmureSimplifiee.Disponibilite);
              TabArmor.Cells[ 8,NbWeap+1]  := IntToStr(PArmureSimplifiee.Protection);
              TabArmor.Cells[ 9,NbWeap+1]  := PArmureSimplifiee.ListeBonus;
              TabArmor.Cells[10,NbWeap+1]  := GetTexteLibelle(PArmureSimplifiee.Livre,'','',true);
              TabArmor.Cells[11,NbWeap+1]  := PArmureSimplifiee.CodeArmure;
              Inc(NbWeap);
           end;
        end;

    //Sort
    if (CheckBoxSimplified.Checked = false) then
      TabArmor.SortColRow(true,2)
    else
      TabArmor.SortColRow(true,1);
    AdjustGridColumnsWidth(TabArmor, self.Height, false, true);
    AdjustGridColumnsWidth(TabBonus, self.Height, false, true);
    AdjustGridColumnsWidth(TabFabIntegree, self.Height, false, true);

    if FileExists(GetCurrentDir+ConstCheminLogo1) then
      ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption              := GetTexteLibelle('RULES-LAB_065');
    Labcode.Caption           := GetTexteLibelle('RULES-LAB_001');
    LabLib.Caption            := GetTexteLibelle('RULES-LAB_002');
    LabPrix.Caption           := GetTexteLibelle('RULES-LAB_054');
    LabDisponibilite.Caption  := GetTexteLibelle('RULES-LAB_056');
    LabEncombrement.Caption   := GetTexteLibelle('RULES-LAB_055');
    LabType.Caption           := GetTexteLibelle('RULES-LAB_018');
    LabEmplacement.Caption    := GetTexteLibelle('RULES-LAB_075');
    LabProtection.Caption     := GetTexteLibelle('RULES-LAB_076');
    LabBonus.Caption          := GetTexteLibelle('RULES-LAB_034');
    LabLivre.Caption          := GetTexteLibelle('RULES-LAB_128');
    LabQuickArmor.Caption     := GetTexteLibelle('RULES-LAB_149');

    // Liste vide possible depuis le toggle .INI par livre (Quick Armour desactive,
    // A FAIRE.txt "TOGGLE .INI PAR LIVRE", 22/09/2026) : RowCount = 1 (en-tete seule),
    // la ligne 1 n'existe pas - sans ce garde, range-check error au premier affichage.
    if TabArmor.RowCount > 1 then
      begin
        TabArmor.Row := 1;
        TabArmorSelection(TabArmor, 1, 1);
      end;

    KeyPreview := true;
  end;

procedure TWinArmors.ButtonFiltreClick(Sender: TObject);
begin
    SelectWinLivre      := FiltreLivre;
    WinFiltreAppelant   := ConstXmlArme;
    FenFiltre           := TWinFiltre.Create(Application);
    FenFiltre.Position  := poOwnerFormCenter;
    FenFiltre.ShowModal;
    if (ChoixWinLivre <> FiltreLivre) then
     Begin
       FiltreLivre := ChoixWinLivre;
       WinVider();
       WinCharger();
     end;
end;

procedure TWinArmors.CheckBoxSimplifiedClick(Sender: TObject);
begin
  WinVider();
  WinCharger();
end;

procedure TWinArmors.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinArmors.TabArmorDblClick(Sender: TObject);
begin
    if SelectWinArmure <> '' then
      begin
        ChoixWinArmure := TabArmor.Cells[1,TabArmor.Row];
        close;
      end;
end;

procedure TWinArmors.TabArmorSelection(Sender: TObject; aCol, aRow: Integer);
var
  ListeBonus:   String;
  NbBonus:      Integer;
  Ind:          Integer;
  I,J:          Integer;
  PArmureBonus: StructureArmureBonus;
  PArmureBonusModif: StructureArmureBonusModif;
  Bonus:        String;
  Suffixe:      String;
  CheminImage1: String;
  CheminImage2: String;
  CheminImage3: String;
  ListeFabIntegree: String;
  NbFabIntegree:    Integer;
  Fab:              String;
  CodeFab:          String;
  NiveauFab:        String;
  PFabrication:     StructureFabrication;
begin
    // renseigner les données
    AffCode.Text             := TabArmor.Cells[ 1,aRow];
    AffType.Text             := TabArmor.Cells[ 2,aRow];
    AffLib.Text              := TabArmor.Cells[ 3,aRow];
    AffEmplacement.Text      := TabArmor.Cells[ 4,aRow];
    AffPrix.Text             := TabArmor.Cells[ 5,aRow];
    AffEncombrement.Text     := TabArmor.Cells[ 6,aRow];
    AffDisponbilite.Text     := TabArmor.Cells[ 7,aRow];
    AffProtection.Text       := TabArmor.Cells[ 8,aRow];
    ListeBonus               := TabArmor.Cells[ 9,aRow];
    AffLivre.Text            := TabArmor.Cells[10,aRow];
    ListeFabIntegree         := TabArmor.Cells[12,aRow];

    if (ListeBonus <> '') and (ListeBonus <> '-') then
      NbBonus                := CountOccurrences(ListeBonus,',')+1
    else
      NbBonus                := 0;

    For I := 1 to TabBonus.ColCount -1 do
      for J := 1 to TabBonus.RowCount -1 do
        TabBonus.Cells[I, J] := '';

    For ind := 0 to NbBonus - 1 do
      begin
        Bonus := Trim(ExtractChaine(',', ListeBonus, Ind+1));
        // Une qualite peut porter un indice numerique separe par un espace (ex. "ARMOB_16 1"
        // pour Fear 1, meme convention que GetAllArmureBonusLibelle, chargearmurebonus.pas) :
        // a retirer avant ChercheArmureBonus (comparaison exacte sur le code) et reafficher
        // apres, sinon la ligne ressort vide - trouve le 11/09/2026 sur Skull Trophies (Fear).
        Suffixe := '';
        if Pos(' ', Bonus) > 0 then
          begin
            Suffixe := ' ' + Trim(ExtractStringAfter(Bonus, ' '));
            Bonus   := Trim(ExtractStringBefore(Bonus, ' '));
          end;
        PArmureBonus := ChercheArmureBonus(Bonus);
        TabBonus.Cells[1, Ind+1] := PArmureBonus.Libelle + Suffixe;
        TabBonus.Cells[2, Ind+1] := PArmureBonus.Description;
        TabBonus.Cells[3, Ind+1] := PArmureBonus.Malus;
        if TabBonus.Cells[3, Ind+1] = '' then
          // Modifier structuré (attribut name="CodeCompetence", 15/08/2026) : plus de texte
          // libre dans .Malus pour ces entrées, on reconstruit un texte lisible à partir de
          // ListArmureBonusModif (une ligne par compétence affectée, ex. plusieurs pièces
          // touchant des compétences différentes)
          for PArmureBonusModif in ListArmureBonusModif do
            if CompareRechercheValeur(PArmureBonusModif.CodeArmureBonus, PArmureBonus.CodeArmureBonus) then
              begin
                if TabBonus.Cells[3, Ind+1] <> '' then
                  TabBonus.Cells[3, Ind+1] := TabBonus.Cells[3, Ind+1] + ', ';
                TabBonus.Cells[3, Ind+1] := TabBonus.Cells[3, Ind+1]
                                             + ChercheCompetence(PArmureBonusModif.CodeCompetence).Libelle
                                             + ' ' + IntToStr(PArmureBonusModif.Valeur) + '%';
              end;
      end;

    // Fabrication D'ORIGINE (Durable/Fine imprimes sur l objet lui-meme, chantier "objets a
    // fabrication integree", CONTEXT.md 2.29) : meme moule que TabBonus ci-dessus, colonne 12
    // cachee de TabArmor au lieu de la colonne 9 (ListeBonus).
    if (ListeFabIntegree <> '') and (ListeFabIntegree <> '-') then
      NbFabIntegree           := CountOccurrences(ListeFabIntegree,',')+1
    else
      NbFabIntegree           := 0;

    For I := 1 to TabFabIntegree.ColCount -1 do
      for J := 1 to TabFabIntegree.RowCount -1 do
        TabFabIntegree.Cells[I, J] := '';

    For ind := 0 to NbFabIntegree - 1 do
      begin
        Fab       := Trim(ExtractChaine(',', ListeFabIntegree, Ind+1));
        CodeFab   := Trim(ExtractStringBefore(Fab, ' '));
        NiveauFab := Trim(ExtractStringAfter(Fab, ' '));
        PFabrication := ChercheFabrication(CodeFab);
        if PFabrication.Maximum = '1' then
          TabFabIntegree.Cells[1, Ind+1] := PFabrication.Libelle
        else
          TabFabIntegree.Cells[1, Ind+1] := PFabrication.Libelle + ' ' + NiveauFab;
        // Col 2 cachee : texte complet, pour AffDescription au clic (TabFabIntegreeSelection).
        // Col 3 visible : le resume court, seul a tenir dans la largeur du tableau.
        TabFabIntegree.Cells[2, Ind+1] := PFabrication.Description;
        TabFabIntegree.Cells[3, Ind+1] := PFabrication.Resume;
      end;

    if AffEncombrement.Text = '0' then
      begin
        LabEncombrement.Visible:= false;
        AffEncombrement.Visible:= false;
      end
    else
      begin
        LabEncombrement.Visible:= true;
        AffEncombrement.Visible:= true;
      end;

    if NbBonus = 0 then
      begin
        LabBonus.Visible       := false;
        TabBonus.Visible       := false;
      end
    else
      begin
        LabBonus.Visible      := true;
        TabBonus.Visible      := true;
      end;

    if NbFabIntegree = 0 then
      begin
        LabFabIntegree.Visible := false;
        TabFabIntegree.Visible := false;
      end
    else
      begin
        LabFabIntegree.Visible := true;
        TabFabIntegree.Visible := true;
      end;

    CheminImage1       := CheminArmureImage('1');
    CheminImage2       := CheminArmureImage('2');
    CheminImage3       := CheminArmureImage('3');
    if FileExists(CheminImage1) then
       Image1.Picture.LoadFromFile(CheminImage1)
    else
       Image1.Picture := nil;
    if FileExists(CheminImage2) then
       Image2.Picture.LoadFromFile(CheminImage2)
    else
       Image2.Picture := nil;
    if FileExists(CheminImage3) then
       Image3.Picture.LoadFromFile(CheminImage3)
    else
       Image3.Picture := nil;

    AffDescription.text := '';
    AffDescription.visible := false;
    AdjustGridColumnsWidth(TabBonus, self.Height, false, false);
    // MaxWidth=false, MEME REGLAGE QUE TabBonus juste au-dessus (pas true : bug corrige le
    // 23/09/2026, retrouve en testant - MaxWidth=true empeche le tableau de REGRANDIR apres son
    // tout premier calcul, fait par WinCharger sur un tableau encore vide avant tout chargement
    // de donnees ; il restait coince minuscule pour le reste de la session). Le resume etant
    // court (colonne cachee ci-dessus pour le texte complet), il n'y a plus de risque de
    // debordement sur les images a corriger par ce biais.
    AdjustGridColumnsWidth(TabFabIntegree, self.Height, false, false);

end;

procedure TWinArmors.TabBonusSelection(Sender: TObject; aCol, aRow: Integer);
begin
  AffDescription.Text := TabBonus.Cells[2, TabBonus.Row];
  if AffDescription.Text <> '' then
    AffDescription.visible := true
  else
    AffDescription.visible := false;
end;

procedure TWinArmors.TabFabIntegreeSelection(Sender: TObject; aCol, aRow: Integer);
begin
  AffDescription.Text := TabFabIntegree.Cells[2, TabFabIntegree.Row];
  if AffDescription.Text <> '' then
    AffDescription.visible := true
  else
    AffDescription.visible := false;
end;

Procedure TWinArmors.WinVider();
  begin
      TabArmor.Clear;
      TabArmor.RowCount:= 1;
      AffDescription.Clear;
  end;


end.

