unit WinMetier;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Grids,
  ChargeMetier, ChargeConstantes, FPImage, LCLType, ExtCtrls, StdCtrls,
  BCButton, PReport, ChargeRaceMetier, ChargeRace, ChargeMetierNiveau,
  ChargeMetierAttribut, ChargeAttribut, ChargeMetierCompetence,
  ChargeCompetence, ChargeTalent, ChargeMetierTalent, GlobalFonts,
  ChargeMetierEquipement, ChargeArme, ChargeArmure, ChargeTexte, UnitCalcul,
  ChargeMetierSousMetier, ChargeMetierRaceChoixMetier, WinFiltre,
  ChargeTalentCreation, Types, BGRABitmap, BGRABitmapTypes,
  fpPDF, LCLIntf,
  //PicsLib, PdfUtils,
  PdfMetier;
type
  TMyNodeData = class
    AdditionalData: string;
  end;

  { TWinMetiers }

  TWinMetiers = class(TForm)
    AffCode: TEdit;
    AffLib: TEdit;
    AffLivre: TEdit;
    AffMetier: TEdit;
    AffAttribut: TEdit;
    AffType: TEdit;
    ButtonFiltre: TBCButton;
    ButtonPdf: TBCButton;
    ButtonPdfAll: TBCButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    ImageClass2: TImage;
    ImageClass1: TImage;
    ImageWar: TImage;
    LabCode: TLabel;
    LabAttribut: TLabel;
    LabDescription: TLabel;
    LabLib: TLabel;
    AffDescription: TMemo;
    LabLivre: TLabel;
    PanelDescription: TPanel;
    PanelHautGauche: TPanel;
    TabAttribut: TStringGrid;
    TabMetier: TStringGrid;
    TreeViewMetier1: TTreeView;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure ButtonPdfAllClick({%H-}Sender: TObject);
    procedure ButtonPdfClick({%H-}Sender: TObject);
    procedure FormClose({%H-}Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery({%H-}Sender: TObject; var {%H-}CanClose: Boolean);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabAttributDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure TabAttributSelectEditor({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
      var Editor: TWinControl);
    procedure TabMetierDblClick({%H-}Sender: TObject);
    procedure TabMetierSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TreeViewMetier1AdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; {%H-}State: TCustomDrawState; {%H-}Stage: TCustomDrawStage;
      var {%H-}PaintImages, DefaultDraw: Boolean);
    procedure TreeViewMetier1Change({%H-}Sender: TObject; Node: TTreeNode);
    Procedure WinVider();
    Procedure WinCharger();
    Function MetierFiltre(PMEtier: StructureMetier):Boolean;
    procedure ChargeRaceMetier();
    procedure ChargeMetierAttribut(Niveau: Integer; NodeBase: TTreeNode);
    procedure ChargeMetierNiveau();
    procedure ChargeMetierCompetence(Niveau: Integer; NodeBase: TTreeNode);
    procedure ChargeMetierTalent(Niveau: Integer; NodeBase: TTreeNode);
    procedure ChargeMetierEquipement(Niveau: Integer; NodeBase: TTreeNode);
  private

  public

  end;

var
  WinMetiers:       TWinMetiers;
//  NbOcc:            Integer;
  Item:             TListItem;
  IndTab:           Integer;
  Node:             TTreeNode;
  picture:          TPicture;
  ListImage:        TImageList;
  Bitmap:           TBitmap;
  Path:             String;
  MetierEnCours:    String;
  NodeBranche:      TTreeNode;
  NodeSBrance:      TTreeNode;
  NodeSTBranche:    TTreeNode;
  NodeFeuille:      TTreeNode;
  NodeSFeuille:     TTreeNode;
  NodeSTFeuille:    TTreeNode;
  NbNiv:            Integer;
  NodeRect:         TRect;
  FrameRect:        TRect;
  TextWidth:        Integer;
  ColorLoc:         TColor;
  ColorList:        array of TColor;
  Nv:               Integer;
  NvS:              Char;
  TypeArme:         Integer = 1;
  TypeArmure:       Integer = 2;
  EquipArme:        String = '(W) ';
  EquipArmure:      String = '(P) ';
  EquipDivers:      String = '(D) ';
  FenFiltre:        TWinFiltre;
  FiltreLivre:      String;
  FiltreRace:       String;
  FiltreGroupe:     String;
  FiltreTalent:     String;
  FiltreAttribut:   String;
  CheminClass:      String;
  ForceClose:       Boolean = false;
implementation

{$R *.lfm}

{ TWinMetiers }

// Images
procedure ChargeImage(Niveau: Integer);
begin
    Picture  := TPicture.Create;
    Bitmap   := TBitmap.Create;
    try
      Path   :=GetCurrentDir+ConstCheminImageNiveau+InttoStr(Niveau)+'.PNG';
      Picture.LoadFromFile(Path);
      Bitmap.Assign(Picture.graphic);
      ListImage.Add(Bitmap, nil);
      ColorLoc := Bitmap.Canvas.Pixels[1, 1];
      ColorList[Niveau] := ColorLoc;
    finally
      Picture.Free;
      Bitmap.Free;
    end;
end;

Function TWinMetiers.MetierFiltre(PMetier: StructureMetier):Boolean;
var
  ResLivre:        Boolean = True;
  ResRace:         Boolean = True;
  ResGroupe:       Boolean = True;
  ResTalent:       Boolean = True;
  ResAttribut:     Boolean = True;
  PRaceMetier:     StructureRaceMetier;
  PMetierTalent:   StructureMetierTalent;
  PMetierAttribut: StructureMetierAttribut;
  ResOneTalent:    Boolean = True;
  ResOneAttribut:  Boolean = True;
  Strings:         TStringList;
  Ind:             Integer;
  Niv:             Integer;
begin
  if not VerifieFiltre(PMetier.Livre, FiltreLivre) then
    ResLivre := false;

  if not VerifieFiltre(Pmetier.LibelleGroupe, filtreGroupe) then
    ResGroupe:= false;

  if FiltreRace <> '' then
    begin
      ResRace := false;
      For PRaceMetier in ListRaceMetier do
        begin
          if PMetier.CodeMetier = PRaceMetier.CodeMetier then
            if VerifieFiltre(PRaceMetier.CodeRace, FiltreRace) then
              ResRace := True;
        end;
    end;

  if FiltreTalent <> '' then
      begin
        ResTalent := True;
        Strings   := TStringList.Create;
        ExtractStrings([']'], [], PChar(FiltreTalent), Strings);
        for Ind := 0 to (Strings.count-1) Do
          begin
            ResOneTalent := false;
            For PMetierTalent in ListMetierTalent do
              begin
                if PMetier.CodeMetier = PMetierTalent.CodeMetier then
                  if VerifieFiltre(PMetierTalent.CodeTalent, Strings[Ind]+']') then
                    begin
                      ResOneTalent := True;
                      break;
                    end;
              end;
            if ResOneTalent = False then
              begin
                ResTalent := False;
                break;
              end;
          end;
        Strings.free;
      end;

  if FiltreAttribut <> '' then
      begin
        ResAttribut := True;
        Strings   := TStringList.Create;
        ExtractStrings([']'], [], PChar(FiltreAttribut), Strings);
        for Ind := 0 to (Strings.count-1) Do
          begin
            ResOneAttribut := false;
            For PMetierAttribut in ListMetierAttribut do
              begin
                if (PMetier.CodeMetier = PMetierAttribut.CodeMetier) and (PMetierAttribut.NiveauMetier > 0) then
                  if PMetierAttribut.CodeAttribut = ExtractStringBefore(EnleveAccolade(Strings[Ind]),SeparateurDetail) then
                    begin
                      Niv := StrToInt(ExtractStringAfter(EnleveAccolade(Strings[Ind]),SeparateurDetail));
                      if (Niv = 0) or (PMetierAttribut.NiveauMetier = Niv) then
                        begin
                          ResOneAttribut := True;
                          break;
                        end;
                    end;
              end;
            if ResOneAttribut = False then
              begin
                ResAttribut := False;
                break;
              end;
          end;
        Strings.free;
      end;

  Result := (ResLivre and ResRace and ResGroupe and ResTalent and ResAttribut);
end;

// Création
Procedure TWinMetiers.WinCharger();
var
  PMetier:    StructureMetier;
  PAttribut:  StructureAttribut;
  Accord:     Boolean;
  LocSel:     String;
  Nb:         Integer = 0;
begin
    // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    TabMetier.RowCount := 1;
    IndTab             := 0;

    // on met toutes les données dans la table pour les afficher directement dans les champs
    if TabMetier.ColCount < 2 then
      begin
        TabMetier.ColCount     := 1;
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_002'),150);
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_039'),120);
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_128'),140);
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_001'),100);
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabMetier, GetTexteLibelle('LAB_001'));
      end;
    TabMetier.ColWidths[0] := 20;

    LocSel := SeparateurMulti + SelectWinMetier + SeparateurMulti;

    for PMEtier in ListMetier do
      begin
        Accord := true;
        if (SelectWinMetierRace <> '') and not VerifieRaceMetier(SelectWinMetierRace, '.', PMetier.CodeMetier) then
          Accord := false;
        if (SelectWinMetier <> '') and (pos(SeparateurMulti + PMetier.CodeMetier + SeparateurMulti, LocSel) = 0) then
          Accord := false;
        if not MetierFiltre(PMetier) then
          Accord := False;

        If Accord = true then
          begin
            Inc(IndTab);
            if IndTab = TabMetier.RowCount then
              TabMetier.RowCount := TabMetier.RowCount + 1;
            TabMetier.Cells[1, IndTab] := PMetier.CodeMetier;
            TabMetier.Cells[2, IndTab] := PMetier.Libelle;
            TabMetier.Cells[3, IndTab] := GetTexteLibelle(PMetier.LibelleGroupe);
            TabMetier.Cells[4, IndTab] := PMetier.Description + TexteMetierSousMetier(PMetier.CodeMetier, '') + TexteMetierRaceChoixMetier(PMetier.CodeMetier, '', '');
            TabMetier.Cells[5, IndTab] := GetTexteLibelle(PMetier.Livre,'','',true);
            TabMetier.Cells[6, IndTab] := PMetier.CodeMetier;
            TabMetier.Cells[7, IndTab] := PMetier.CodeCompetence;
            TabMetier.Cells[8, IndTab] := PMetier.LibelleGroupe;
          end;
      end;
    TabMetier.SortColRow(true,2);

    if IndTab = 0 then
      begin
        ShowMessage(GetTexteLibelle('MESS_048'));  // aucun résultat
        SelectWinLivre     := '';
        SelectWinRace      := '';
        SelectWinGroupe    := '';
        SelectWinTalent    := '';
        SelectWinAttribut  := '';
        FiltreLivre      := '';
        FiltreRace       := '';
        FiltreGroupe     := '';
        FiltreTalent     := '';
        FiltreAttribut   := '';
        ForceClose         := true;
        Close;
      end
    else
      begin
        // Mise en forme du tableau des attributs
        if TabAttribut.ColCount < 2 then
          begin
            TabAttribut.Clear;
            TabAttribut.Options          := TabAttribut.Options + [goEditing, goAlwaysShowEditor];
            TabAttribut.ColCount         := 1;
            TabAttribut.RowCount         := 3;
            TabAttribut.ColWidths[0]     := 0;
            For PAttribut in ListeAttribut do
              begin
                If Nb < 10 then
                  begin
                    TabAttribut.Columns.Add;
                    TabAttribut.Columns[Nb].Alignment       := taCenter;
                    TabAttribut.Columns[Nb].Title.Caption   := PAttribut.Resume;
                    TabAttribut.Cells[nb+1,2]               := PAttribut.CodeAttribut;
                  end;
                TabAttribut.ColWidths[Nb+1]               := 40;
                Inc(Nb);
              end;
          end;
        TabAttribut.RowHeights[1]    := 40;
        TabAttribut.RowHeights[2]    := 1;

        // charges les images des niveaux pour l'arbre
        SetLength(ColorList, 5);
        ListImage := TImageList.Create(nil);
        For IndTab := 0 to 4 Do
          Begin
            ChargeImage(IndTab);
          End;
        TreeViewMetier1.Images := ListImage;
        if FileExists(GetCurrentDir+ConstCheminLogo1) then
         ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

        Self.Caption              := GetTexteLibelle('LAB_006');
        Labcode.Caption           := GetTexteLibelle('LAB_001');
        LabLib.Caption            := GetTexteLibelle('LAB_002');
        LabAttribut.Caption       := GetTexteLibelle('LAB_008');
        LabDescription.Caption    := GetTexteLibelle('LAB_003');
        LabLivre.Caption          := GetTexteLibelle('LAB_128');
        ButtonFiltre.Caption      := GetTexteLibelle('LAB_133');
        AdjustGridColumnsWidth(TabMetier, self.Height, false, true);

        TabMetier.Row := 1;
        TabMetierSelection(TabMetier, 1, 1);

        if (SelectWinMetier <> '') then
          begin
            if Pos(SeparateurMulti,SelectWinMetier) = 0 then
              TabMetier.Visible := false;
            TabMetierSelection(self, 1,1);
          end;

        KeyPreview := true;
      end;
end;


procedure TWinMetiers.FormCreate(Sender: TObject);
begin
    FiltreLivre := SelectWinLivre;
    WinCharger();
end;

procedure TWinMetiers.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinMetiers.TabAttributDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  ImageIndex: Integer;
  CellWidth, CellHeight: Integer;
  ImageWidth, ImageHeight: Integer;
  AspectRatio: Double;
  LeftOffset, TopOffset: Integer;
  ImageRect: TRect;
  Grid: TStringGrid;
  Img: TBGRABitmap;
begin
  Grid := TStringGrid(Sender);
  if (aCol = 0) or (aRow = 0) then
    Grid.DefaultDrawCell(aCol, aRow, aRect, aState)
  else
  begin
    // Récupérer la valeur de la cellule correspondante (colonne 2)
    ImageIndex := StrToIntDef(Grid.Cells[aCol, aRow], -1);

    // Vérifier que la valeur est valide et se situe dans la plage d'index d'image
    if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
    begin
      // Calculer la taille de la cellule
      CellWidth := aRect.Right - aRect.Left;
      CellHeight := aRect.Bottom - aRect.Top;

      // Charger l'image depuis le fichier
      Img := TBGRABitmap.Create;
      try
        Img.LoadFromFile(GetCurrentDir + ConstCheminImageNiveau + IntToStr(ImageIndex) + '.png');

        // Récupérer les dimensions de l'image originale
        ImageWidth := Img.Width;
        ImageHeight := Img.Height;

        // Calculer l'aspect ratio de l'image
        AspectRatio := ImageWidth / ImageHeight;

        // Si l'aspect ratio de la cellule est plus grand que celui de l'image,
        // l'image sera limitée par la hauteur de la cellule, sinon par la largeur
        if (CellWidth / CellHeight) > AspectRatio then
        begin
          ImageWidth := Round(CellHeight * AspectRatio);
          ImageHeight := CellHeight;
        end
        else
        begin
          ImageHeight := Round(CellWidth / AspectRatio);
          ImageWidth := CellWidth;
        end;

        // Calculer les décalages pour centrer l'image
        LeftOffset := (CellWidth - ImageWidth) div 2;
        TopOffset := (CellHeight - ImageHeight) div 2;

        // Calculer le rectangle de l'image dans la cellule
        ImageRect := Rect(aRect.Left + LeftOffset, aRect.Top + TopOffset,
                          aRect.Left + LeftOffset + ImageWidth,
                          aRect.Top + TopOffset + ImageHeight);

        // Dessiner l'image dans la cellule avec la taille ajustée
        Img.Resample(ImageWidth, ImageHeight);
        Img.Draw(Grid.Canvas, ImageRect);

      finally
        Img.Free;
      end;
    end
    else
      // Dessiner du texte par défaut si la valeur de l'index d'image est invalide
      Grid.DefaultDrawCell(aCol, aRow, aRect, aState);
  end;
end;

procedure TWinMetiers.TabAttributSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
begin
  Editor := nil;
end;

procedure TWinMetiers.TabMetierDblClick(Sender: TObject);
begin
  if SelectWinMetierRace <> '' then
   begin
     ChoixWinMetierRace := TabMetier.Cells[1, TabMetier.Row];
     Close;
   end;
end;

procedure TWinMetiers.WinVider();
Begin
  TabMetier.Clear;
  AffDescription.Clear;
  SetLength(ColorList, 0);
  DeleteData(TreeViewMetier1,TreeViewMetier1.Items.GetFirstNode);
end;

procedure TWinMetiers.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    WinVider();
    CloseAction := caFree;
end;

procedure TWinMetiers.ButtonFiltreClick(Sender: TObject);
begin
  SelectWinLivre      := FiltreLivre;
  SelectWinRace       := FiltreRace;
  SelectWinGroupe     := FiltreGroupe;
  SelectWinTalent     := FiltreTalent;
  SelectWinAttribut   := FiltreAttribut;
  WinFiltreAppelant   := ConstXmlWork;
  FenFiltre           := TWinFiltre.Create(Application);
  FenFiltre.Position  := poOwnerFormCenter;
  FenFiltre.ShowModal;
  if (ChoixWinLivre <> FiltreLivre)
     or (ChoixWinRace <> FiltreRace)
     or (ChoixWinGroupe <> FiltreGroupe)
     or (ChoixWinTalent <> FiltreTalent)
     or (ChoixWinAttribut <> FiltreAttribut) then
   Begin
     FiltreLivre      := ChoixWinLivre;
     FiltreRace       := ChoixWinRace;
     FiltreGroupe     := ChoixWinGroupe;
     FiltreTalent     := ChoixWinTalent;
     FiltreAttribut   := ChoixWinAttribut;
     WinVider();
     WinCharger();
     if not ForceClose then
       TabMetierSelection(TabMetier, 1,1);
   end;
end;

procedure TWinMetiers.ButtonPdfAllClick(Sender: TObject);
var
  IndL:        Integer;
  ListeMetier: String = '';
begin
  For IndL := 1 to TabMetier.RowCount - 1 do
    begin
      if ListeMetier <> '' then ListeMetier := ListeMetier + SeparateurMulti;
      ListeMetier := ListeMetier + TabMetier.Cells[1, IndL];
    end;
  if ListeMetier <> '' then
    PdfMetierDoc(ListeMetier);
end;

procedure TWinMetiers.ButtonPdfClick(Sender: TObject);
begin
//  PdfMetierCreation(MetierEnCours);
  PdfMetierDoc(MetierEnCours);
end;

procedure TWinMetiers.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    TabMetier.Clear;
    AffDescription.Clear;
    SetLength(ColorList, 0);
    DeleteData(TreeViewMetier1,TreeViewMetier1.Items.GetFirstNode);
end;

// Niveau 1 : charger les races
procedure TWinMetiers.ChargeRaceMetier();
Var
  PRace:        StructureRace;
  PRaceMetier:  StructureRaceMetier;
  NodeData:     TMyNodeData;
Begin
    NodeBranche            := TreeViewMetier1.Items.AddChild(Node, ConstArbreRacePossible);
    NodeBranche.ImageIndex := 0;
    For PRaceMetier in ListRaceMetier do
      if PRaceMetier.CodeMetier = MetierEnCours then
        Begin
          NodeData                := TMyNodeData.Create;
          PRace                   := ChercheRace(PRaceMetier.CodeRace);
          NodeFeuille             := TreeViewMetier1.Items.AddChild(NodeBranche, PRace.Libelle);
          NodeFeuille.ImageIndex  := 0;
          NodeData.AdditionalData := PRace.CodeRace;
          NodeFeuille.Data        := NodeData;
        end;
end;

// Niveau 2 : charger les attributs
procedure TWinMetiers.ChargeMetierAttribut(Niveau: Integer; NodeBase: TTreeNode);
var
  PMetierAttribut:   StructureMetierAttribut;
  PAttribut:         StructureAttribut;
  NodeData:          TMyNodeData;
  I:                 Integer;

Begin

    NodeSBrance            := TreeViewMetier1.Items.AddChild(NodeBase, ConstArbreAttribut);
    NodeSBrance.ImageIndex := Niveau;
    For PMetierAttribut in ListMetierAttribut do
      if (PMetierAttribut.CodeMetier = MetierEnCours) and (PMetierAttribut.NiveauMetier = Niveau) then
        Begin
          NodeData                := TMyNodeData.Create;
          PAttribut               := ChercheAttribut(PMetierAttribut.CodeAttribut);
          NodeSFeuille            := TreeViewMetier1.Items.AddChild(NodeSBrance, PAttribut.Libelle);
          NodeSFeuille.ImageIndex := 0;
          NodeData.AdditionalData := PAttribut.CodeAttribut;
          NodeSFeuille.Data       := NodeData;
          for I := 1 to TabAttribut.Colcount do
            if TabAttribut.Cells[I-1, 2] = PAttribut.CodeAttribut then
              TabAttribut.Cells[I-1, 1] := IntToStr(PMetierAttribut.NiveauMetier);

        end;

    AdjustGridColumnsWidth(TabAttribut,0,false,false,false,0,0,ssnone);

end;

// Niveau 2 : charger les compétences
procedure TWinMetiers.ChargeMetierCompetence(Niveau: Integer; NodeBase: TTreeNode);
var
    PCompetence:        StructureCompetence;
    PMetierCompetence:  StructureMetierCompetence;
    NodeData:           TMyNodeData;
    LibComp:            String;
    ListOpt:            TStringList;
    IndL:               Integer;
Begin
    NodeSBrance            := TreeViewMetier1.Items.AddChild(NodeBase, ConstArbreCompetence);
    NodeSBrance.ImageIndex := Niveau;
    For PMetierCompetence in ListMetierCompetence do
      if (PMetierCompetence.CodeMetier = MetierEnCours) and (PMetierCompetence.NiveauMetier = Niveau) then
        if Pos(SeparateurMulti, PMetierCompetence.CodeCompetence) > 0 then
          Begin
            // choix multiple : une sous-branche, une feuille par option
            NodeSTBranche            := TreeViewMetier1.Items.AddChild(NodeSBrance, ConstArbreAuChoix);
            NodeSTBranche.ImageIndex := 0;
            ListOpt                  := ListeMetierCompetence(PMetierCompetence.CodeCompetence);
            for IndL := 0 to ListOpt.Count - 1 do
              begin
                NodeData                 := TMyNodeData.Create;
                PCompetence              := ChercheCompetence(ListOpt[IndL]);
                NodeSTFeuille            := TreeViewMetier1.Items.AddChild(NodeSTBranche, PCompetence.Libelle);
                NodeSTFeuille.ImageIndex := 0;
                NodeData.AdditionalData  := PCompetence.CodeCompetence;
                NodeSTFeuille.Data       := NodeData;
              end;
            ListOpt.Free;
          end
        else
          Begin
            NodeData                := TMyNodeData.Create;
            PCompetence             := ChercheCompetence(PMetierCompetence.CodeCompetence);
            LibComp                 := PCompetence.Libelle;
            if PMetierCompetence.CodeCompetence = TabMetier.Cells[7,TabMetier.Row] then
              LibComp               := LibComp + '*';
            NodeSFeuille := TreeViewMetier1.Items.AddChild(NodeSBrance, LibComp);
            NodeSFeuille.ImageIndex := 0;
            if Pos('_', PCompetence.CodeCompetence) > 0 then
               PCompetence     := ChercheCompetence(Copy(PMetierCompetence.CodeCompetence, 1, Pos('_', PCompetence.CodeCompetence) - 1)+'_*');
            NodeData.AdditionalData := PCompetence.CodeCompetence;
            NodeSFeuille.Data       := NodeData;
          end;
end;

// Niveau 2 : charger les talents
procedure TWinMetiers.ChargeMetierTalent(Niveau: Integer; NodeBase: TTreeNode);
var
  PTalent:        StructureTalent;
  PMetierTalent:  StructureMetierTalent;
  NodeData:       TMyNodeData;
Begin
    NodeSBrance            := TreeViewMetier1.Items.AddChild(NodeBase, ConstArbreTalent);
    NodeSBrance.ImageIndex := Niveau;
    For PMetierTalent in ListMetierTalent do
      if (PMetierTalent.CodeMetier = MetierEnCours) and (PMetierTalent.NiveauMetier = Niveau) then
          Begin
              NodeData     := TMyNodeData.Create;
              PTalent      := ChercheTalent(PMetierTalent.CodeTalent);
              NodeSFeuille := TreeViewMetier1.Items.AddChild(NodeSBrance, PTalent.Libelle);
              NodeSFeuille.ImageIndex := 0;
              if Pos('_', PTalent.CodeTalent) > 0 then
                 PTalent   := ChercheTalent(Copy(PMetierTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
              NodeData.AdditionalData := PTalent.CodeTalent;
              NodeSFeuille.Data       := NodeData;
          end;
end;

// Niveau 2 : charger l'equipement
procedure TWinMetiers.ChargeMetierEquipement(Niveau: Integer; NodeBase: TTreeNode);
var
  PArme:               StructureArme;
  PArmure:             StructureArmure;
  PMetierEquipement:   StructureMetierEquipement;
  StringsI:            TStringList;
  StringsT:            TStringList;
  IndL:                Integer;
  Code:                String;
  Qualite:             String;
  NodeData:            TMyNodeData;

Begin
    NodeSBrance            := TreeViewMetier1.Items.AddChild(NodeBase, ConstArbreEquipement);
    NodeSBrance.ImageIndex := Niveau;
    for PMetierEquipement in ListMetierEquipement do
      if (PMetierEquipement.CodeMetier = MetierEnCours) and (PMetierEquipement.NiveauMetier = Niveau) then
         if pos(SeparateurMulti, PMetierEquipement.Equipement) > 0 then
            begin
              // choix mutiple
               stringsI                := TStringList.Create;
               stringsT                := TStringList.Create;
               NodeSTBranche           := TreeViewMetier1.Items.AddChild(NodeSBrance, ConstArbreAuChoix);
               NodeSTBranche.ImageIndex := 0;
               ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.Equipement), stringsI);
               ExtractStrings([SeparateurMulti], [], PChar(PMetierEquipement.TypeEquipement), stringsT);
               For IndL := 0 to 1 do
                 Begin
                   if pos(EquipementQualite, StringsT[IndL]) > 0 then
                     begin
                       Code   := copy(stringsI[IndL],1,length(stringsI[IndL]) - length(Equipementqualite));
                       Qualite:= GetTexteLibelle('LAB_038');
                     end
                   else
                     begin
                       Code   := stringsI[IndL];
                       Qualite:= '';
                     end;
                   if InList(stringsT[IndL],TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                      begin
                        PArme                    := ChercheArme(Code);
                        NodeData                 := TMyNodeData.Create;
                        NodeData.AdditionalData  := PArme.CodeArme;
                        NodeSTFeuille            := TreeViewMetier1.Items.AddChild(NodeSTBranche, EquipArme + PArme.Libelle + Qualite);
                        NodeSTFeuille.ImageIndex := 0;
                        NodeSTFeuille.Data       := NodeData;
                      end
                   else if stringsT[IndL] = TypeEquipAR then
                      begin
                        PArmure                  := ChercheArmure(Code);
                        NodeData                 := TMyNodeData.Create;
                        NodeData.AdditionalData  := PArmure.CodeArmure;
                        NodeSTFeuille            := TreeViewMetier1.Items.AddChild(NodeSTBranche, EquipArmure + PArmure.Libelle + Qualite);
                        NodeSTFeuille.ImageIndex := 0;
                        NodeSTFeuille.Data       := NodeData;
                      end
                   else if stringsT[IndL] = TypeEquipDI then
                      begin
                        NodeSTFeuille := TreeViewMetier1.Items.AddChild(NodeSTBranche, stringsI[IndL]);
                        NodeSTFeuille.ImageIndex := 0;
                      end
                   end;
               stringsI.Free;
               stringsT.Free;
            end
         else
            if InList(PMetierEquipement.TypeEquipement,TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                begin
                  if Pos(EquipementQualite, PMetierEquipement.Equipement) > 0 then
                    begin
                      Code   := copy(PMetierEquipement.Equipement,1,length(PMetierEquipement.Equipement) - length(Equipementqualite));
                      Qualite:= GetTexteLibelle('LAB_038');
                    end
                  else
                    begin
                      Code   := PMetierEquipement.Equipement;
                      Qualite:= '';
                    end;
                  PArme                   := ChercheArme(Code);
                  NodeData                := TMyNodeData.Create;
                  NodeData.AdditionalData := PArme.CodeArme;
                  NodeSFeuille            := TreeViewMetier1.Items.AddChild(NodeSBrance, EquipArme + PArme.Libelle + qualite);
                  NodeSFeuille.ImageIndex := 0;
                  NodeSFeuille.Data       := NodeData;
                end
            else if PMetierEquipement.TypeEquipement = TypeEquipAR then
                begin
                  if Pos(EquipementQualite, PMetierEquipement.Equipement) > 0 then
                    begin
                      Code   := copy(PMetierEquipement.Equipement,1,length(PMetierEquipement.Equipement) - length(Equipementqualite));
                      Qualite:= GetTexteLibelle('LAB_038');
                    end
                  else
                    begin
                      Code   := PMetierEquipement.Equipement;
                      Qualite:= '';
                    end;
                  PArmure                 := ChercheArmure(Code);
                  NodeData                := TMyNodeData.Create;
                  NodeData.AdditionalData := PArmure.CodeArmure;
                  NodeSFeuille            := TreeViewMetier1.Items.AddChild(NodeSBrance, EquipArmure + PArmure.Libelle + Qualite);
                  NodeSFeuille.ImageIndex := 0;
                  NodeSFeuille.Data       := NodeData;
                end
              else if PMetierEquipement.TypeEquipement = TypeEquipDI then
                begin
                  NodeSFeuille := TreeViewMetier1.Items.AddChild(NodeSBrance, PMetierEquipement.Equipement);
                  NodeSFeuille.ImageIndex := 0;
                end;
end;


// Niveau 1 : charger les niveaux des métiers
procedure TWinMetiers.ChargeMetierNiveau();
var
  PMetierNiveau:   StructureMetierNiveau;
  I:               Integer;
Begin
    for I := 1 to TabAttribut.Colcount - 1 do
       TabAttribut.Cells[I, 1] := '';

    for PMetierNiveau in ListMetierNiveau do
      if PMetierNiveau.CodeMetier = MetierEnCours then
        Begin
            NodeBranche := TreeViewMetier1.Items.AddChild(Node, IntToStr(PMetierNiveau.NiveauMetier)+'.'+PMetierNiveau.Libelle+' - '+GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' '));
            NodeBranche.ImageIndex := PMetierNiveau.NiveauMetier;
            ChargeMetierAttribut(PMetierNiveau.NiveauMetier,NodeBranche);
            ChargeMetierCompetence(PMetierNiveau.NiveauMetier,NodeBranche);
            ChargeMetierTalent(PMetierNiveau.NiveauMetier,NodeBranche);
            ChargeMetierEquipement(PMetierNiveau.NiveauMetier,NodeBranche);
        end;

end;

// sélectionner un métier
procedure TWinMetiers.TabMetierSelection(Sender: TObject; aCol, aRow: Integer);
  begin
      DeleteData(TreeViewMetier1,TreeViewMetier1.Items.GetFirstNode);
      TreeViewMetier1.Items.Clear;

      // ajouter la racine
      MetierEnCours   := TabMetier.Cells[1,aRow];
      Node            := TreeViewMetier1.Items.Add(nil, TabMetier.Cells[2,aRow]);
      Node.ImageIndex := 0;
      AffMetier.Text  := TabMetier.Cells[2,aRow];

      CheminClass     := GetCurrentDir + ConstCheminImageNiveau+TabMetier.Cells[8,aRow]+'.png';
      if FileExists(CheminClass) then
        begin
          ImageClass1.Picture.LoadFromFile(CheminClass);
          ImageClass2.Picture.LoadFromFile(CheminClass);
        end;

      // charger les éléments
      ChargeRaceMetier();
      ChargeMetierNiveau();
      TreeViewMetier1.FullExpand;
      TreeViewMetier1.Selected := TreeViewMetier1.Items.GetFirstNode;
  end;

// Mise en forme de l'arbre
procedure TWinMetiers.TreeViewMetier1AdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
    if (Node.Level in [1,2]) then
      begin
         if (Node.Parent.Text <> ConstArbreRacepossible) then
               Sender.Font.Style := Sender.Font.Style + [fsBold]
         else
               Sender.Font.Style := Sender.Font.Style - [fsBold];


          // Dessiner le cadre autour de la feuille
          if Node.Level = 1 then
            begin
              NodeRect       := Node.DisplayRect(False);
              TextWidth      := Sender.Canvas.TextWidth(Node.Text);  // Largeur du texte de la feuille
              FrameRect      := NodeRect;
              FrameRect.Left := FrameRect.Left + TextWidth + ((Node.Level + 1) * 29) + 5;  // Ajuster la position du cadre ici
              NvS := Node.Text[1];
              if NvS in ['1','2','3','4'] then
                begin
                  Nv := StrToInt(NvS);
                  ColorLoc := ColorList[Nv];
                end
              else
                begin
                  ColorLoc := CouleurGrisFonce;  // Couleur du cadre
                end;
              Sender.Canvas.brush.Color := colorloc;  // Couleur du cadre
              Sender.Canvas.Pen.Width   := 1;  // Épaisseur du cadre
              Sender.Canvas.Rectangle(FrameRect);
            end
      end
    else
        begin
          Sender.Font.Style := Sender.Font.Style - [fsBold];
        end;
    DefaultDraw := True;  // Permettre le dessin par défaut
end;

procedure TWinMetiers.TreeViewMetier1Change(Sender: TObject; Node: TTreeNode);
Var
  PRace:        StructureRace;
  PTalent:      StructureTalent;
  PAttribut:    StructureAttribut;
  PCompetence:  StructureCompetence;
  PArme:        StructureArme;
  PArmure:      StructureArmure;
  CheminImage1: String;
  CheminImage2: String;
  CheminImage3: String;
  NodeData:     TMyNodeData;
Begin
    NodeData := TMyNodeData.Create;
    if Assigned(Node) then
      begin
        CheminImage1         := '';
        CheminImage2         := '';
        CheminImage3         := '';
        AffCode.Text         := '';
        AffAttribut.Text     := '';
        AffDescription.Text  := TabMetier.Cells[4, TabMetier.Row];
        // Obtenez le texte du nœud sélectionné
        NodeData             := TMyNodeData(Node.Data);
        if Node <> TreeViewMetier1.Items.GetFirstNode then
          begin
            CheminImage2   := '';
            AffType.text   := Node.Parent.Text;
            if AffType.text = ConstArbreRacepossible then
                begin
                  PRace              := ChercheRace(NodeData.AdditionalData);
                  AffCode.Text       := PRace.CodeRace;
                  AffLib.Text        := PRace.Libelle;
                  AffLivre.Text      := getTexteLibelle(PRace.Livre,'','',true);
                  CheminImage1       := CheminRaceImage(PRace.CodeRace,'2');
                  CheminImage2       := CheminRaceImage(PRace.CodeRace,'1');
                  AffLivre.Text      := getTexteLibelle(PRace.Livre,'','',true);
                  AffDescription.Text:= PRAce.Description;
                end
            else if AffType.text = ConstArbreAttribut then
                begin
                  PAttribut          := ChercheAttribut(NodeData.AdditionalData);
                  AffCode.Text       := PAttribut.CodeAttribut;
                  AffLib.Text        := PAttribut.Libelle;
                  AffDescription.Text:= PAttribut.Description;
                end
            else if AffType.text = ConstArbreCompetence then
                Begin
                  if Node.Data <> nil then
                    begin
                      PCompetence        := ChercheCompetence(NodeData.AdditionalData);
                      AffCode.Text       := PCompetence.CodeCompetence;
                      AffLib.Text        := PCompetence.Libelle;
                      AffLivre.Text      := getTexteLibelle(PCompetence.Livre,'','',true);
                      AffAttribut.Text   := GetTexteLibelle(PCompetence.CodeAttribut);
                      if (PCompetence.Description = '')
                         and (Pos(ValeurSousCompetence, PCompetence.CodeCompetence) > 0) then
                        PCompetence      := ChercheCompetence(Copy(PCompetence.CodeCompetence, 1,
                                            Pos(ValeurSousCompetence, PCompetence.CodeCompetence) - 1)
                                            + ValeurGenerique);
                      AffDescription.Text:= PCompetence.Description;
                    end;
                end
            else if AffType.text = ConstArbreTalent then
                Begin
                  PTalent            := ChercheTalent(NodeData.AdditionalData);
                  AffCode.Text       := PTalent.CodeTalent;
                  AffLib.Text        := PTalent.Libelle;
                  AffLivre.Text      := getTexteLibelle(PTalent.Livre,'','',true);
                  AffAttribut.Text   := GetTExteLibelle(PTalent.Attribut);
                  AffDescription.Text:= DescriptionTalent(PTalent.CodeTalent, ConstCodeRaceCreationGenerique);
                end
            else if AffType.text = ConstArbreEquipement then
              Begin
                if Node.text <> ConstArbreAuchoix then
                begin
                  if Node.Data <> nil then
                    begin
                      if (copy(Node.text,1,Length(EquipArme)) = EquipArme) then
                        begin
                          PArme              := ChercheArme(NodeData.AdditionalData);
                          AffCode.Text       := PArme.CodeArme;
                          AffLib.Text        := PArme.Libelle;
                          AffLivre.Text      := getTexteLibelle(PArme.Livre,'','',true);
                          AffDescription.Text:= TexteArme(PArme);
                        end
                      else if (copy(Node.text,1,Length(EquipArmure)) = EquipArmure) then
                        begin
                          PArmure            := ChercheArmure(NodeData.AdditionalData);
                          AffCode.Text       := PArmure.CodeArmure;
                          AffLib.Text        := PArmure.Libelle;
                          AffLivre.Text      := getTexteLibelle(PArmure.Livre,'','',true);
                          AffDescription.Text:= TexteArmure(PArmure);
                        end;
                    end;
                end;
              end
            else if AffType.text = ConstArbreAuchoix then
              Begin
                if Node.Data <> nil then
                  if Node.Parent.Parent.Text = ConstArbreCompetence then
                    begin
                      PCompetence        := ChercheCompetence(NodeData.AdditionalData);
                      AffCode.Text       := PCompetence.CodeCompetence;
                      AffLib.Text        := PCompetence.Libelle;
                      AffLivre.Text      := getTexteLibelle(PCompetence.Livre,'','',true);
                      AffAttribut.Text   := GetTexteLibelle(PCompetence.CodeAttribut);
                      AffDescription.Text:= PCompetence.Description;
                    end
                  else
                  begin
                    PArme              := ChercheArme(NodeData.AdditionalData);
                  end;
              end;
          end;
       end;
        if CheminImage1 = '' then
           CheminImage3 := CheminMetierImage(MetierEnCours);
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
        Image1.BringToFront;
        PanelHautGauche.visible := (AffCode.Text <> '');
        PanelDescription.visible:= (AffDescription.Text <> '');
        AffAttribut.visible     := (AffAttribut.Text <> '');
        LabAttribut.visible     := (AffAttribut.Text <> '');
   end;

end.

