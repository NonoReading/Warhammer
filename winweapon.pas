unit WinWeapon;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, BCButton, ChargeArme, GlobalFonts, ChargeConstantes,
  ChargeCompetence, UnitCalcul, ChargeArmeBonus, ChargeTexte, WinFiltre,
  AncrageProportionnel, ChargeFabrication;

type

  { TWinWeapons }

  TWinWeapons = class(TForm)
    AffCode: TEdit;
    AffDegat: TEdit;
    AffDescription: TMemo;
    AffLivre: TEdit;
    AffMunition: TEdit;
    AffPortee: TEdit;
    AffMain: TEdit;
    AffCompetence: TEdit;
    AffLib: TEdit;
    AffDisponbilite: TEdit;
    AffPrix: TEdit;
    AffEncombrement: TEdit;
    ButtonFiltre: TBCButton;
    Image2: TImage;
    Image1: TImage;
    ImageWar: TImage;
    LabCode: TLabel;
    LabDegat: TLabel;
    LabBonus: TLabel;
    LabLivre: TLabel;
    LabMunition: TLabel;
    LabPortee: TLabel;
    LabDisponibilite: TLabel;
    LabPrix: TLabel;
    LabMain: TLabel;
    LabCompetence: TLabel;
    LabLib: TLabel;
    LabEncombrement: TLabel;
    LabFabIntegree: TLabel;
    TabBonus: TStringGrid;
    TabFabIntegree: TStringGrid;
    TabWeapon: TStringGrid;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure FormResize({%H-}Sender: TObject);
    procedure CheckCompetenceChange({%H-}Sender: TObject);
    procedure TabBonusSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabFabIntegreeSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabWeaponAfterSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TabWeaponDblClick({%H-}Sender: TObject);
    procedure WinCharger();
    Procedure WinVider();
  private
    Ancrage: TAncrageProportionnel;
    // Cree en code (pas dans le .lfm) : visible seulement depuis WinPersonnage.
    CheckCompetence: TCheckBox;
    LabCompetenceFiltre: TLabel;
    function ArmeSelonCompetences(PArme: StructureArme): Boolean;

  public

  end;

var
  WinWeapons:     TWinWeapons;
  FiltreLivre:    String;
  FenFiltre:      TWinFiltre;

implementation

{$R *.lfm}

{ TWinWeapons }

procedure TWinWeapons.WinCharger();
var
  PArme:        StructureArme;
  Code:         String;
  Code1:        String;
  Code2:        String;
  PCompetence:  StructureCompetence;
  IndTab:       integer;
begin
      // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    TabWeapon.RowCount      := 1;
    // on met toutes les données dans la table pour les afficher directement dans les champs
    if TabWeapon.ColCount < 2 then
      begin
        TabWeapon.ColCount      := 1;
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_001'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_018'),120);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_009'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_002'),200);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_053'),100);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_054'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_055'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_056'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_057'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_058'),100);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_059'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_060'));
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_128'),100);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_001'),180);
        GridAjouteColonne(TabWeapon,GetTexteLibelle('RULES-LAB_009'),100);
        // Colonne 16, cachee : fabrication D'ORIGINE (PArme.Fabrication), lue par
        // TabWeaponAfterSelection pour remplir TabFabIntegree ci-dessous.
        GridAjouteColonne(TabWeapon,'',0);
      end;
    TabWeapon.ColWidths[0]  := 20;

        // on met toutes les données dans la table pour les afficher directement dans les champs
    TabBonus.RowCount      := 7;
    If TabBonus.ColCount < 2 then
      begin
        TabBonus.ColCount      := 1;
        TabBonus.ColWidths[0]  := 20;
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_002'),100);
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_072'));
        GridAjouteColonne(TabBonus,GetTexteLibelle('RULES-LAB_073'),380);
      end;

        // Fabrication D'ORIGINE (chantier "objets a fabrication integree", CONTEXT.md 2.29) :
        // meme moule que TabBonus ci-dessus, mais lit PArme.Fabrication au lieu de ListeBonus.
    TabFabIntegree.RowCount := 7;
    If TabFabIntegree.ColCount < 2 then
      begin
        TabFabIntegree.ColCount      := 1;
        TabFabIntegree.ColWidths[0]  := 20;
        GridAjouteColonne(TabFabIntegree,GetTexteLibelle('RULES-LAB_002'),100);
        // Colonne cachee (largeur 0, meme moule que TabBonus/LAB_072 ci-dessus) : le texte
        // COMPLET (long), affiche seulement dans AffDescription au clic sur la ligne. C'est
        // l'avoir mis ici, en clair, dans une colonne VISIBLE qui faisait deborder le tableau
        // de la fenetre - corrige le 23/09/2026.
        GridAjouteColonne(TabFabIntegree,GetTexteLibelle('RULES-LAB_072'));
        GridAjouteColonne(TabFabIntegree,GetTexteLibelle('RULES-LAB_073'),380);
      end;

    IndTab := 0;
    For Parme In ListArme do
      begin
        if (Pos(ValeurGenerique,PArme.CodeArme) = 0) and VerifieFiltre(PArme.Livre, FiltreLivre) and ArmeSelonCompetences(PArme) then
          begin
            Inc(IndTab);
            if TabWeapon.RowCount <= IndTab then
              TabWeapon.RowCount := TabWeapon.RowCount + 1;

            TabWeapon.Cells[1, IndTab]   := PArme.CodeArme;
            // Le code porte son prefixe de livre (RULES-COMB_BASE_10) : tester les cinq
            // premiers caracteres du code COMPLET donnait "RULES", donc AUCUNE arme ne
            // matchait et toutes prenaient le libelle du else. Meme moule que
            // GetTypeMetierEquipement (unitcalcul.pas l.218) : decouper d'abord.
            DecoupeCodeValeur(PArme.CodeArme);
            if copy(CodeValeur,1,5) = EquipementMU then
              TabWeapon.Cells[2, IndTab] := GetTexteLibelle('RULES-LAB_060')
            else if copy(CodeValeur,1,5) = EquipementCC then
              TabWeapon.Cells[2, IndTab] := GetTexteLibelle('RULES-LAB_061')
            else
              TabWeapon.Cells[2, IndTab] := GetTexteLibelle('RULES-LAB_062');
            TabWeapon.Cells[3, IndTab]   := PArme.CodeCompetence;
            TabWeapon.Cells[4, IndTab]   := PArme.Libelle;
            TabWeapon.Cells[5, IndTab]   := IntToStr(PArme.Mains);
            TabWeapon.Cells[6, IndTab]   := TraduirePrix(PArme.Prix);
            TabWeapon.Cells[7, IndTab]   := IntToStr(PArme.Encombrement);
            TabWeapon.Cells[8, IndTab]   := GetAllTexteLibelle(PArme.Disponibilite);
            TabWeapon.Cells[9, IndTab]   := ReplaceTexteLibelle(PArme.Portee);
            TabWeapon.Cells[10,IndTab]   := ReplaceTexteLibelle(PArme.CalculDegat);
            TabWeapon.Cells[11,IndTab]   := PArme.ListeBonus;
            TabWeapon.Cells[12,IndTab]   := IntToStr(PArme.Munition);
            TabWeapon.Cells[13,IndTab]   := GetTexteLibelle(PArme.Livre,'','',true);
            TabWeapon.Cells[14,IndTab]   := PArme.CodeArme;
            TabWeapon.Cells[16,IndTab]   := PArme.Fabrication;
            Code := PArme.CodeCompetence;
            if CountOccurrences(Code,SeparateurMulti) = 1 then
              begin
                Code1                := ExtractChaine(SeparateurMulti, Code, 1);
                PCompetence          := ChercheCompetence(Code1);
                TabWeapon.Cells[15,IndTab]   := PCompetence.Libelle;
                Code2                := ExtractChaine(SeparateurMulti, Code, 2);
                PCompetence          := ChercheCompetence(Code2);
                TabWeapon.Cells[15,IndTab]   := TabWeapon.Cells[15,IndTab]+' / '+PCompetence.Libelle;
              end
            else
              begin
                PCompetence          := ChercheCompetence(Code);
                TabWeapon.Cells[15,IndTab]   := PCompetence.Libelle;
              end;
         end
    end;
    //Sort
    TabWeapon.SortColRow(true,2);
    AdjustGridColumnsWidth(TabWeapon, self.Height, false, true);
    AdjustGridColumnsWidth(TabBonus, self.Height, false, false);
    AdjustGridColumnsWidth(TabFabIntegree, self.Height, false, false);

    if FileExists(GetCurrentDir+ConstCheminLogo1) then
      ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption              := GetTexteLibelle('RULES-LAB_063');
    Labcode.Caption           := GetTexteLibelle('RULES-LAB_001');
    LabMain.Caption           := GetTexteLibelle('RULES-LAB_053');
    LabPrix.Caption           := GetTexteLibelle('RULES-LAB_054');
    LabEncombrement.Caption   := GetTexteLibelle('RULES-LAB_055');
    LabMunition.Caption       := GetTexteLibelle('RULES-LAB_112');
    LabLib.Caption            := GetTexteLibelle('RULES-LAB_002');
    LabCompetence.Caption     := GetTexteLibelle('RULES-LAB_009');
    LabPortee.Caption         := GetTexteLibelle('RULES-LAB_057');
    LabDisponibilite.Caption  := GetTexteLibelle('RULES-LAB_056');
    LabDegat.Caption          := GetTexteLibelle('RULES-LAB_058');
    LabBonus.Caption          := GetTexteLibelle('RULES-LAB_034');
    LabLivre.Caption          := GetTexteLibelle('RULES-LAB_128');
    ButtonFiltre.Caption      := GetTexteLibelle('RULES-LAB_133');
    TabWeapon.Row := 1;
    TabWeaponAfterSelection(TabWeapon, 1, 1);

    KeyPreview := true;
end;

procedure TWinWeapons.FormResize(Sender: TObject);
begin
    if Ancrage <> nil then
      Ancrage.Appliquer;
end;

// Case cochee : ne garde que les armes dont une competence (CodeCompetence, plusieurs separees par
// SeparateurMulti) figure parmi celles du personnage. Sans case ou non cochee : toutes.
function TWinWeapons.ArmeSelonCompetences(PArme: StructureArme): Boolean;
  var
    Codes:   TStringList;
    IndArme: Integer;
    IndPers: Integer;
    CodeArme: String;
  begin
    Result := True;
    if (CheckCompetence = nil) or (not CheckCompetence.Checked) then Exit;
    Result := False;
    Codes := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(SelectWinArmeCompetences), Codes);
      for IndArme := 1 to CountOccurrences(PArme.CodeCompetence, SeparateurMulti) + 1 do
        begin
          CodeArme := ExtractChaine(SeparateurMulti, PArme.CodeCompetence, IndArme);
          for IndPers := 0 to Codes.Count - 1 do
            if CompareRechercheValeur(CodeArme, Codes[IndPers]) or CompareRechercheValeur(Codes[IndPers], CodeArme) then
              begin
                Result := True;
                Exit;
              end;
        end;
    finally
      Codes.Free;
    end;
  end;

procedure TWinWeapons.CheckCompetenceChange(Sender: TObject);
  begin
    WinVider();
    WinCharger();
  end;

procedure TWinWeapons.FormCreate(Sender: TObject);
begin
    FiltreLivre := SelectWinLivre;
    // Case "selon mes competences" : seulement quand on vient de WinPersonnage. Elle prend la
    // droite du bouton de filtre, qui est retreci d autant.
    if SelectWinArmeCompetences <> '' then
      begin
        ButtonFiltre.Width := ButtonFiltre.Width - 180;
        CheckCompetence := TCheckBox.Create(Self);
        CheckCompetence.Parent   := Self;
        CheckCompetence.SetBounds(ButtonFiltre.Left + ButtonFiltre.Width + 8, ButtonFiltre.Top - 12, 170, 24);
        CheckCompetence.Caption  := GetTexteLibelle('RULES-LAB_240');
        // Cochee par defaut, avant d'affecter OnChange (la liste n'est pas encore chargee).
        CheckCompetence.Checked  := True;
        CheckCompetence.OnChange := @CheckCompetenceChange;
        // Explication sous la case.
        LabCompetenceFiltre := TLabel.Create(Self);
        LabCompetenceFiltre.Parent   := Self;
        LabCompetenceFiltre.SetBounds(CheckCompetence.Left, CheckCompetence.Top + 24, 170, 56);
        LabCompetenceFiltre.AutoSize := False;
        LabCompetenceFiltre.WordWrap := True;
        LabCompetenceFiltre.Font.Size := 8;
        LabCompetenceFiltre.Caption  := GetTexteLibelle('RULES-LAB_241');
      end;
    WinCharger();
    // Ancrage proportionnel, meme regle que WinRace (voir AncrageProportionnel).
    Ancrage := TAncrageProportionnel.Create(Self);
    Ancrage.Ajouter(TabWeapon, 0, 0.5);
    Ancrage.Ajouter(AffCode, 0.5, 0);
    Ancrage.Ajouter(LabCode, 0.5, 0);
    Ancrage.Ajouter(LabLib, 0.5, 0);
    Ancrage.Ajouter(AffLib, 0.5, 0.5);
    Ancrage.Ajouter(ImageWar, 0.25, 0);
    Ancrage.Ajouter(LabCompetence, 0.5, 0);
    Ancrage.Ajouter(AffCompetence, 0.5, 0.5);
    Ancrage.Ajouter(LabMain, 0.5, 0);
    Ancrage.Ajouter(AffMain, 0.5, 0);
    Ancrage.Ajouter(LabPrix, 0.5, 0);
    Ancrage.Ajouter(AffPrix, 0.5, 0);
    Ancrage.Ajouter(LabEncombrement, 0.5, 0);
    Ancrage.Ajouter(AffEncombrement, 0.5, 0);
    Ancrage.Ajouter(LabPortee, 0.5, 0);
    Ancrage.Ajouter(AffPortee, 0.5, 0);
    Ancrage.Ajouter(LabDisponibilite, 0.5, 0);
    Ancrage.Ajouter(AffDisponbilite, 0.5, 0);
    Ancrage.Ajouter(LabDegat, 0.5, 0);
    Ancrage.Ajouter(AffDegat, 0.5, 0);
    Ancrage.Ajouter(LabMunition, 0.5, 0);
    Ancrage.Ajouter(AffMunition, 0.5, 0);
    Ancrage.Ajouter(TabBonus, 0.5, 0);
    Ancrage.Ajouter(AffDescription, 0.5, 0.5);
    Ancrage.Ajouter(LabBonus, 0.5, 0);
    Ancrage.Ajouter(TabFabIntegree, 0.5, 0);
    Ancrage.Ajouter(LabFabIntegree, 0.5, 0);
    Ancrage.Ajouter(LabLivre, 1, 0);
    Ancrage.Ajouter(AffLivre, 1, 0);
    Ancrage.Ajouter(Image2, 1, 0);
    Ancrage.Ajouter(Image1, 1, 0);
    Ancrage.Ajouter(ButtonFiltre, 0, 0.5);
    if CheckCompetence <> nil then
      begin
        Ancrage.Ajouter(CheckCompetence, 0, 0);
        Ancrage.Ajouter(LabCompetenceFiltre, 0, 0);
      end;
    Ancrage.Fixer;
end;

procedure TWinWeapons.ButtonFiltreClick(Sender: TObject);
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

procedure TWinWeapons.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinWeapons.TabBonusSelection(Sender: TObject; aCol, aRow: Integer);
begin
    AffDescription.Text := TabBonus.Cells[2, aRow];
    if AffDescription.Text = '' then
      AffDescription.Visible := false
    else
      AffDescription.Visible := true;
end;

procedure TWinWeapons.TabFabIntegreeSelection(Sender: TObject; aCol, aRow: Integer);
begin
    AffDescription.Text := TabFabIntegree.Cells[2, aRow];
    if AffDescription.Text = '' then
      AffDescription.Visible := false
    else
      AffDescription.Visible := true;
end;

procedure TWinWeapons.TabWeaponAfterSelection(Sender: TObject; aCol,
  aRow: Integer);
var
  ListeBonus:   String;
  NbBonus:      Integer;
  Ind:          Integer;
  I,J:          Integer;
  PArmeBonus:   StructureArmeBonus;
  Bonus:        String;
  CheminImage1: String;
  CheminImage2: String;
  ListeFabIntegree: String;
  NbFabIntegree:    Integer;
  Fab:              String;
  CodeFab:          String;
  NiveauFab:        String;
  PFabrication:     StructureFabrication;
begin
    // renseigner les données
    AffCode.Text             := TabWeapon.Cells[ 1,aRow];
    AffCompetence.Text       := TabWeapon.Cells[15,aRow];
    AffLib.Text              := TabWeapon.Cells[ 4,aRow];
    AffMain.Text             := TabWeapon.Cells[ 5,aRow];
    AffPrix.Text             := TabWeapon.Cells[ 6,aRow];
    AffEncombrement.Text     := TabWeapon.Cells[ 7,aRow];
    AffDisponbilite.Text     := TabWeapon.Cells[ 8,aRow];
    AffPortee.Text           := TabWeapon.Cells[ 9,aRow];
    AffDegat.Text            := TabWeapon.Cells[10,aRow];
    ListeBonus               := TabWeapon.Cells[11,aRow];
    AffMunition.Text         := TabWeapon.Cells[12,aRow];
    AffLivre.Text            := TabWeapon.Cells[13,aRow];
    ListeFabIntegree         := TabWeapon.Cells[16,aRow];

    if (ListeBonus <> '') and (ListeBonus <> '-') then
      NbBonus                := CountOccurrences(ListeBonus,',')+1
    else
      NbBonus                := 0;

    // TabBonus.RowCount est initialise a 7 (une fois, a l'ouverture de la fenetre) et
    // n'etait jamais agrandi ensuite : une arme avec 7 qualites ou plus (ex. Double Barrel
    // Pistol) faisait planter TabBonus.Cells[1, Ind+1] en ecrivant sur la ligne 7, hors
    // plage (EGridException Cell[Col=1 Row=7], leve par Nono le 07/09/2026 - sans rapport
    // avec le chantier ModifyWeapon en cours, CONTEXT.md/Log.txt). Meme reflexe que
    // TabWeapon.RowCount plus haut dans cette unite (l.124-125).
    if TabBonus.RowCount <= NbBonus then
      TabBonus.RowCount := NbBonus + 1;

    For I := 1 to TabBonus.ColCount -1 do
      for J := 1 to TabBonus.RowCount -1 do
        TabBonus.Cells[I, J] := '';

    For ind := 0 to NbBonus - 1 do
      begin
        Bonus := ExtractChaine(',', ListeBonus, Ind+1);
        if (copy(Bonus,length(Bonus)-1,1) = ' ') then
          if (copy(Bonus,length(Bonus),1) >= '1') then
            if (copy(Bonus,length(Bonus),1) <= '9') then
              Bonus := copy(Bonus,1,length(Bonus)-2);
        PArmeBonus := ChercheArmeBonus(Bonus);
        TabBonus.Cells[1, Ind+1] := PArmeBonus.Libelle;
        TabBonus.Cells[2, Ind+1] := PArmeBonus.Description;
        TabBonus.Cells[3, Ind+1] := PArmeBonus.Resume;
      end;

    // Fabrication D'ORIGINE (Durable/Fine imprimes sur l objet lui-meme, chantier "objets a
    // fabrication integree", CONTEXT.md 2.29) : meme moule que TabBonus ci-dessus, colonne 16
    // cachee de TabWeapon au lieu de la colonne 11 (ListeBonus).
    if (ListeFabIntegree <> '') and (ListeFabIntegree <> '-') then
      NbFabIntegree           := CountOccurrences(ListeFabIntegree,',')+1
    else
      NbFabIntegree           := 0;

    if TabFabIntegree.RowCount <= NbFabIntegree then
      TabFabIntegree.RowCount := NbFabIntegree + 1;

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

    AffDescription.Text := '';


    if AffMain.Text = '0' then
      begin
        LabMain.Visible:= false;
        AffMain.Visible:= false;
      end
    else
      begin
        LabMain.Visible:= true;
        AffMain.Visible:= true;
      end;

    if AffMunition.Text = '0' then
      begin
        LabMunition.Visible:= false;
        AffMunition.Visible:= false;
      end
    else
      begin
        LabMunition.Visible:= true;
        AffMunition.Visible:= true;
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

    CheminImage1       := CheminArmeImage(TabWeapon.Cells[3,aRow],'2');
    CheminImage2       := CheminArmeImage(TabWeapon.Cells[3,aRow],'1');
    if FileExists(CheminImage1) then
       Image1.Picture.LoadFromFile(CheminImage1)
    else
       Image1.Picture := nil;
    if FileExists(CheminImage2) then
       Image2.Picture.LoadFromFile(CheminImage2)
    else
       Image2.Picture := nil;
    Image1.BringToFront;

    AffDescription.Visible := false;
    AdjustGridColumnsWidth(TabBonus, self.Height, false, false);
    // MaxWidth=false, MEME REGLAGE QUE TabBonus (pas true : bug corrige le 23/09/2026 - avec
    // true, le tableau reste coince a la taille minuscule de son tout premier calcul, fait par
    // WinCharger avant tout chargement de donnees, et ne regrandit plus jamais).
    AdjustGridColumnsWidth(TabFabIntegree, self.Height, false, false);

end;

Procedure TWinWeapons.WinVider();
  begin
      TabWeapon.Clear;
      TabWeapon.RowCount:= 1;
      AffDescription.Clear;
  end;


procedure TWinWeapons.TabWeaponDblClick(Sender: TObject);
begin
  if SelectWinArme <> '' then
    begin
      ChoixWinArme := TabWeapon.Cells[1,TabWeapon.Row];
      close;
    end;
end;

end.

