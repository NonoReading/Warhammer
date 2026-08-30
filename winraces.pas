unit WinRaces;

// fenêtre des races

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ComCtrls,
  StdCtrls, ExtCtrls, BCButton, ChargeRace, ChargeEspece, ChargeRaceAttribut, ChargeAttribut,
  ChargeConstantes, ChargeRaceCompetence, ChargeCompetence, UnitCalcul,
  ChargeRaceTalent, ChargeTalent, ChargeMetier, ChargeRaceMetier, ChargeMetierNiveau,
  GlobalFonts, ChargeTexte, ChargeMetierSousMetier, ChargeMetierRaceChoixMetier,
  ChargeRaceCorruptionCreation, WinFiltre, ChargeTalentCreation, PdfRace,
  ChargeRaceOpinion;  // ✨ AJOUTER OPINIONS

type
  TMyNodeData = class
    AdditionalData: string;
  end;

  { TWinRace }

  TWinRace = class(TForm)
    AffAttribut: TEdit;
    AffCode: TEdit;
    AffDescription: TMemo;
    AffLibelle: TEdit;
    AffLivre: TEdit;
    AffRace: TEdit;
    AffType: TEdit;
    ButtonFiltre: TBCButton;
    ButtonPdf: TBCButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    ImageWar: TImage;
    LabAttribut: TLabel;
    LabCode: TLabel;
    LabDescription: TLabel;
    LabLib: TLabel;
    LabLivre: TLabel;
    PanelDescription: TPanel;
    PanelHautGauche: TPanel;
    TabAttribut: TStringGrid;
    TabRace: TStringGrid;
    TreeViewRace: TTreeView;
    procedure ButtonFiltreClick({%H-}Sender: TObject);
    procedure ButtonPdfClick({%H-}Sender: TObject);
    procedure FormClose({%H-}Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery({%H-}Sender: TObject; var {%H-}CanClose: Boolean);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyPress({%H-}Sender: TObject; var Key: char);
    procedure TabRaceDblClick({%H-}Sender: TObject);
    procedure TabRaceSelection({%H-}Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure TreeViewRaceAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; {%H-}State: TCustomDrawState; {%H-}Stage: TCustomDrawStage;
      var {%H-}PaintImages, DefaultDraw: Boolean);
    procedure TreeViewRaceChange({%H-}Sender: TObject; Node: TTreeNode);
    Procedure WinVider();
    Procedure WinCharger();
    Procedure ChargeRaceAttribut();
  private

  public

  end;

var
  WinRace:        TWinRace;
  RaceEnCours:    String;
  RaceLivre:      String;
  Node:           TTreeNode;
  NodeBranche:    TTreeNode;
  NodeFeuille:    TTreeNode;
  NodeSBranche:   TTreeNode;
  NodeSFeuille:   TTreeNode;
  NbNiv:          Integer;
  picture:        TPicture;
  ListImage:      TImageList;
  Bitmap:         TBitmap;
  Path:           String;
  ColorLoc:       TColor;
  ColorList:      array of TColor;
  canvas:         TCanvas;
  TailleCh:       Integer;
  TailleSp:       Integer;
  strings:        TStringList;
  NodeRect:       TRect;
  FrameRect:      TRect;
  TextWidth:      Integer;
  Jaune:          TColor;
  Nv:             Integer;
  FenFiltre:      TWinFiltre;
  FiltreLivre:    String;
  LigAttCode:     Integer = 1;
  ColAttLib:      Integer = 1;
  ColAttCC:       Integer = 2;
  ColAttCT:       Integer = 3;
  ColAttF:        Integer = 4;
  ColAttE:        Integer = 5;
  ColAttI:        Integer = 6;
  ColAttAgi:      Integer = 7;
  ColAttDex:      Integer = 8;
  ColAttInt:      Integer = 9;
  ColAttFM:       Integer =10;

implementation

{$R *.lfm}

{ TWinRace }


// Images
procedure ChargeImage(Niveau: Integer);
begin
    Picture  := TPicture.Create;
    Bitmap   := TBitmap.Create;
    try
      // Le chemin depend desormais de l'ethnie affichee : une ethnie peut designer son
      // propre dossier d'icones via <PictureLevel>. CheminNiveauImage retombe toute seule
      // sur \PICTURES\NIV\ si l'ethnie n'en a pas, ou si l'icone y manque.
      Path   := CheminNiveauImage(RaceEnCours, Niveau);
      // Icone absente pour ce niveau : on ajoute QUAND MEME une image, neutre, sinon les
      // index de ListImage se decalent d'un cran et chaque niveau afficherait l'icone du
      // suivant. Le cas se produit des qu'un livre amene un niveau plus haut que ce que
      // PICTURES\NIV\ contient.
      if FileExists(Path) then
        begin
          Picture.LoadFromFile(Path);
          Bitmap.Assign(Picture.graphic);
          ColorLoc := Bitmap.Canvas.Pixels[1, 1];
        end
      else
        begin
          Bitmap.SetSize(8, 8);
          Bitmap.Canvas.Brush.Color := CouleurGrisFonce;
          Bitmap.Canvas.FillRect(0, 0, 8, 8);
          ColorLoc := CouleurGrisFonce;
        end;
      ListImage.Add(Bitmap, nil); // Ajout de l'image au TImageList
      ColorList[Niveau] := ColorLoc;
    finally
      Picture.Free;
      Bitmap.Free;
    end;
end;

// Recharge les icones et les couleurs de niveau pour l'ethnie couramment selectionnee.
// Appelee a l'ouverture de la fenetre, RaceEnCours etant alors vide - donc dossier
// generique - puis a chaque changement d'ethnie dans la liste.
procedure ChargeImagesNiveau();
  var
    IndNiv: Integer;
    MaxNiv: Integer;
  begin
    if not Assigned(ListImage) then
      ListImage := TImageList.Create(nil);
    ListImage.Clear;
    SetLength(ColorList, 0);
    // Dimensionne sur la donnee et non sur une constante : un livre qui apporte une
    // carriere a cinq niveaux fait grandir la liste tout seul. Voir MaxNiveauMetier.
    // Pas MaxNiveauMetier : le dossier NIV contient aussi des pastilles de couleur
    // rangees apres le dernier niveau. Voir MaxIndiceIconeNiveau.
    MaxNiv := MaxIndiceIconeNiveau();
    SetLength(ColorList, MaxNiv + 1);
    For IndNiv := 0 to MaxNiv Do
      ChargeImage(IndNiv);
  end;

procedure TWinRace.FormCreate(Sender: TObject);
  begin
    FiltreLivre := SelectWinLivre;
    WinCharger();
  end;


Procedure TWinRace.WinCharger();
Var
  PRace:   StructureRace;
  PAttribut:StructureAttribut;
  IndTab:  Integer;
  Accord:  Boolean;
  OldSp:   String = '';
  Nb:      Integer= 0;
begin
    // Appeler la procédure SetGlobalFonts au démarrage du formulaire
    MiseEnFormeDesChamp(self);

    //  TabRace.Items.Clear;
    TabRace.RowCount := 2;
    IndTab           := 0;

    // on met toutes les données dans la table pour les afficher directement dans les champs
    if TabRace.ColCount < 2 then
      begin
        TabRace.ColCount     := 1;
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_001'),40);
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_002'),155);
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_128'),110);
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_001'));
        GridAjouteColonne(TabRace, GetTexteLibelle('LAB_001'));
      end;
    TabRace.ColWidths[0] := 20;

    for PRace in ListRace do
      begin
        if ((SelectWinRace <> '') and (SelectWinRace <> ConstSelectionne) and (PRace.CodeRace <> SelectWinRace)) or not VerifieFiltre(PRace.Livre, FiltreLivre) then
          Accord := false
        else
           Accord := true;
        if Accord = true then
          begin
            Inc(IndTab);
            if TabRace.RowCount <= IndTab then
              TabRace.RowCount := TabRace.RowCount + 1;
            TabRace.Cells[1, IndTab] := ChercheEspece(PRace.Espece).Libelle;
            TabRace.Cells[2, IndTab] := PRace.CodeRace;
            TabRace.Cells[3, IndTab] := PRace.Libelle;
            TabRace.Cells[4, IndTab] := PRace.Description;
            TabRace.Cells[5, IndTab] := GetTExteLibelle(PRace.Livre,'','',true);
            TabRace.Cells[6, IndTab] := ChercheEspece(PRace.Espece).Libelle + PRace.Libelle;
            TabRace.Cells[7, IndTab] := ChercheEspece(PRace.Espece).Libelle;
          end
    end;
    TabRace.SortColRow(true,6);

    for indTab := 1 to TabRace.RowCount - 1 do
      begin
        if TabRace.Cells[1, IndTab] = OldSp then
          TabRace.Cells[1, IndTab] := '';
        OldSp := TabRace.Cells[7, IndTab];
      end;

    // Mise en forme du tableau des attributs
    if TabAttribut.ColCount < 2 then
      begin
        TabAttribut.Clear;
        TabAttribut.Options          := TabAttribut.Options + [goEditing, goAlwaysShowEditor];
        TabAttribut.ColCount         := 1;
        TabAttribut.RowCount         := 3;
        TabAttribut.ColWidths[0]     := 0;
    //    TabAttribut.Columns.Add;
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
        TabAttribut.RowHeights[2]    := 1;
      end;

    // charges les images des niveaux pour l'arbre
    ChargeImagesNiveau();
    TreeViewRace.Images := ListImage;
    if FileExists(GetCurrentDir+ConstCheminLogo1) then
     ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

    Self.Caption              := GetTexteLibelle('LAB_042');
    Labcode.Caption           := GetTexteLibelle('LAB_001');
    LabLib.Caption            := GetTexteLibelle('LAB_002');
    LabAttribut.Caption       := GetTexteLibelle('LAB_008');
    LabLivre.Caption          := GetTexteLibelle('LAB_128');
    ButtonFiltre.Caption      := GetTexteLibelle('LAB_133');

    AdjustGridColumnsWidth(TabRace, self.Height, true, true);

    TabRace.Row := 1;

    if (SelectWinRace <> '') and (SelectWinRace <> ConstSelectionne) then
      begin
        TabRace.Visible := false;
        TabRaceSelection(self, 1,1);
      end;

    KeyPreview := true;
End;

procedure TWinRace.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then close;
end;

procedure TWinRace.TabRaceDblClick(Sender: TObject);
  begin
    if SelectWinRace <> '' then
     begin
       ChoixWinRace := TabRace.Cells[2, TabRace.Row];
       Close;
     end;
  end;

Procedure TWinRace.WinVider();
  begin
      TabRace.Clear;
      TabRace.RowCount:= 1;
      AffDescription.Clear;
      SetLength(ColorList, 0);
      DeleteData(TreeViewRace,TreeViewRace.Items.GetFirstNode);
  end;

procedure TWinRace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
Begin
  WinVider();
  CloseAction := caFree
end;

procedure TWinRace.ButtonFiltreClick(Sender: TObject);
  begin
    SelectWinLivre      := FiltreLivre;
    WinFiltreAppelant   := ConstXmlRace;
    FenFiltre           := TWinFiltre.Create(Application);
    FenFiltre.Position  := poOwnerFormCenter;
    FenFiltre.ShowModal;
    if (ChoixWinLivre <> FiltreLivre) then
     Begin
       FiltreLivre := ChoixWinLivre;
       WinVider();
       WinCharger();
       TabRaceSelection(TabRace, 1,1);
     end;
  end;

procedure TWinRace.ButtonPdfClick(Sender: TObject);
begin
  PdfRaceCreation(RaceEnCours);
end;

procedure TWinRace.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
    TabRace.Clear;
    AffDescription.Clear;
    SetLength(ColorList, 0);
  end;

// Niveau 1 : charger les attributs
procedure TWinRace.ChargeRaceAttribut();
var
  PRaceAttribut: StructureRaceAttribut;
  PAttribut:     StructureAttribut;
  NodeData:      TMyNodeData;
  I:             Integer;
Begin
    NodeBranche            := TreeViewRace.Items.AddChild(Node, ConstArbreAttribut);
    NodeBranche.ImageIndex := 0;

    // le canvas permet de défini la taille d'une chaine
        // au début on veut la taille d'un espace
    canvas                 := TCanvas.Create;
    canvas.Handle          := TreeViewRace.Canvas.Handle;
    canvas.Font            := TreeViewRace.Canvas.Font;
    canvas.Font.Name       := ConstPoliceNom;
    canvas.Font.Size       := ConstPoliceTaille;
    canvas.Font.Bold       := false;
    TailleSp               := canvas.TextWidth('.');

    for I := 1 to TabAttribut.Colcount - 1 do
      TabAttribut.Cells[I, 1] := '';

    For PRaceAttribut in ListRaceAttribut do
      if PRaceAttribut.CodeRace = RaceEnCours then
        Begin
            PAttribut               := ChercheAttribut(PRaceAttribut.CodeAttribut);
            // on calcul la taille de la chaine à afficher en seconde partie de treeview
            TailleCh                := canvas.TextWidth(PAttribut.Libelle+' ');
            // on défini une taille à partir de laquelle on veut placer la seconde partie du texte
               // on la soustrait à la taille de la première chaine et on divise le tout par la taille d'un espace
            NodeFeuille             := TreeViewRace.Items.AddChild(NodeBranche, PAttribut.Libelle + ' ' +
                                          StringOfChar('.', round((160 - taillech) / TailleSp))+' '+ PRaceAttribut.CalculRace);
            NodeFeuille.ImageIndex  := 0;
            NodeData                := TMyNodeData.Create;
            NodeData.AdditionalData := PAttribut.CodeAttribut;
            NodeFeuille.Data        := NodeData;

            for I := 1 to TabAttribut.Colcount do
              if TabAttribut.Cells[I-1, 2] = PAttribut.CodeAttribut then
                TabAttribut.Cells[I-1, 1] := '+'+ExtractStringAfter(PRaceAttribut.CalculRace,'+');

        end;
    AdjustGridColumnsWidth(TabAttribut,0,false,false,false,0,0,ssnone);
end;

// Niveau 1 : charger les Competences
procedure ChargeRaceCompetence(TreeViewRace: TTreeView);
var
    PCompetence:        StructureCompetence;
    PRaceCompetence:    StructureRaceCompetence;
    NodeData:           TMyNodeData;
  Begin
    NodeBranche            := TreeViewRace.Items.AddChild(Node, ConstArbreCompetence);
    NodeBranche.ImageIndex := 0;

    // le canvas permet de défini la taille d'une chaine
        // au début on veut la taille d'un espace
    for PRaceCompetence in ListRaceCompetence do
      if PRaceCompetence.CodeRace = RaceEnCours then
        Begin
          PCompetence             := ChercheCompetence(PRaceCompetence.CodeCompetence);
          NodeSFeuille := TreeViewRace.Items.AddChild(NodeBranche, PCompetence.Libelle);
          NodeSFeuille.ImageIndex := 0;
          if Pos('_', PCompetence.CodeCompetence) > 0 then
             PCompetence          := ChercheCompetence(Copy(PRaceCompetence.CodeCompetence, 1, Pos('_', PCompetence.CodeCompetence) - 1)+'_*');
          NodeData                := TMyNodeData.Create;
          NodeData.AdditionalData := PCompetence.CodeCompetence;
          NodeSFeuille.Data       := NodeData;
        end;
end;

// Niveau 1 : charger les Talents
procedure ChargeRaceTalent(TreeViewRace: TTreeView);
Var
    PTalent:     StructureTalent;
    PRaceTalent: StructureRaceTalent;
    IndTab:      Integer;
    NodeData:    TMyNodeData;
Begin
    NodeBranche            := TreeViewRace.Items.AddChild(Node, ConstArbreTalent);
    NodeBranche.ImageIndex := 0;

    For PRaceTalent in ListRaceTalent do
      if PRaceTalent.CodeRace = RaceEnCours then
        Begin
            if pos(SeparateurMulti, PRaceTalent.CodeTalent) > 0 then
            begin
              // choix mutiple
               strings                 := TStringList.Create;
               NodeSBranche            := TreeViewRace.Items.AddChild(NodeBranche, ConstArbreAuChoix);
               NodeSBranche.ImageIndex := 0;
               ExtractStrings([SeparateurMulti], [], PChar(PRaceTalent.CodeTalent), strings);
               For IndTab := 0 to strings.Count-1 do
               Begin
                 PTalent                  := ChercheTalent(strings[indTab]);
                 NodeSFeuille             := TreeViewRace.Items.AddChild(NodeSBranche, PTalent.Libelle);
                 NodeSFeuille.ImageIndex  := 0;
                 if Pos('_', PTalent.CodeTalent) > 0 then
                    // recherche du talent générique pour récupérer les explications
                    PTalent               := ChercheTalent(Copy(PRaceTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
                 NodeData                 := TMyNodeData.Create;
                 NodeData.AdditionalData  := PTalent.codeTalent;
                 NodeSFeuille.Data        := NodeData;
               end;
               strings.Free;
            end
            else
              begin
                // choix unique
                PTalent                  := ChercheTalent(PRaceTalent.CodeTalent);
                NodeFeuille              := TreeViewRace.Items.AddChild(NodeBranche, PTalent.Libelle);
                NodeFeuille.ImageIndex   := 0;
                if Pos('_', PTalent.CodeTalent) > 0 then
                    // recherche du talent générique pour récupérer les explications
                    PTalent              := ChercheTalent(Copy(PRaceTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
                NodeData                 := TMyNodeData.Create;
                NodeData.AdditionalData  := PTalent.codeTalent;
                NodeFeuille.Data         := NodeData;
              end
        end;
end;

// Niveau 1 : charger les races
procedure ChargeRaceMetier(TreeViewRace: TTreeView);
Var
    PMetier:     StructureMetier;
    PRaceMetier: StructureRaceMetier;
    NodeData:    TMyNodeData;
Begin
    NodeBranche            := TreeViewRace.Items.AddChild(Node, ConstArbreMetierPossible);
    NodeBranche.ImageIndex := 0;
    // le canvas permet de défini la taille d'une chaine
        // au début on veut la taille d'un espace
    canvas                 := TCanvas.Create;
    canvas.Handle          := TreeViewRace.Canvas.Handle;
    canvas.Font            := TreeViewRace.Canvas.Font;
    canvas.Font.Name       := ConstPoliceNom;
    canvas.Font.Size       := ConstPoliceTaille;
    canvas.Font.Bold       := false;
    TailleSp               := canvas.TextWidth('.');

    For PRaceMetier in ListRaceMetier do
      if (PRaceMetier.CodeRace = RaceEnCours) and (PRaceMetier.Chance <> '–') then
          Begin
              PMetier  := ChercheMetier(PRaceMetier.CodeMetier);

              // on calcul la taille de la chaine à afficher en seconde partie de treeview
              TailleCh               := canvas.TextWidth(PMetier.Libelle+' ');
              // on défini une taille à partir de laquelle on veut placer la seconde partie du texte
                 // on la soustrait à la taille de la première chaine et on divise le tout par la taille d'un espace
              NodeFeuille            := TreeViewRace.Items.AddChild(NodeBranche, PMetier.Libelle + ' ' + StringOfChar('.', round((220 - taillech) / TailleSp))+' '+ PRaceMetier.Chance);
              NodeFeuille.ImageIndex := 0;
              NodeData               := TMyNodeData.Create;
              NodeData.AdditionalData:= PMetier.CodeMetier;
              NodeFeuille.Data       := NodeData;
          end;
end;

// Niveau 1 : charger les Corruption
procedure ChargeRaceCorruptionCreation(TreeViewRace: TTreeView);
var
    PRaceCorruptionCreation:    StructureRaceCorruptionCreation;
    NodeData:                   TMyNodeData;
    BrancheAjoutee:             boolean = False;
  Begin

    // le canvas permet de défini la taille d'une chaine
        // au début on veut la taille d'un espace
    for PRaceCorruptionCreation in ListRaceCorruptionCreation do
      if PRaceCorruptionCreation.CodeRace = RaceEnCours then
        Begin
          if not BrancheAjoutee then
            begin
              NodeBranche            := TreeViewRace.Items.AddChild(Node, ConstArbreCorruption);
              NodeBranche.ImageIndex := 0;
              BrancheAjoutee         := true;
            end;
          TailleCh                := canvas.TextWidth(GetTexteLibelle(PRaceCorruptionCreation.TypeCorruption)+' ');
          NodeFeuille             := TreeViewRace.Items.AddChild(NodeBranche, GetTexteLibelle(PRaceCorruptionCreation.TypeCorruption) + ' ' + StringOfChar('.', round((220 - taillech) / TailleSp))+' '+ PRaceCorruptionCreation.Chance);
          NodeSFeuille.ImageIndex := 0;
          NodeData                := TMyNodeData.Create;
          NodeData.AdditionalData := PRaceCorruptionCreation.TypeCorruption;
          NodeSFeuille.Data       := NodeData;
        end;
end;

// ========== AFFICHER LES OPINIONS D'UNE RACE ==========
function AfficherOpinionsRace(CodeRace: String): String;
var
  i: Integer;
  PRaceOpinion: StructureRaceOpinion;
  PRaceTarget: StructureRace;
  TargetLibelle: String;
  Citation: String;
  Texte: String;
begin
  Texte := '';
  
  for i := 0 to ListRaceOpinion.Count - 1 do
    begin
      PRaceOpinion := ListRaceOpinion[i];
      
      if PRaceOpinion.CodeRace = CodeRace then
        begin
          Texte := Texte + #13#10 + #13#10;
          
          // ✨ Chercher le libellé direct dans ListRace
          PRaceTarget := ChercheRace(PRaceOpinion.TargetRace);
          
          // Vérifier que on a un libellé valide (pas vide, pas "(F)")
          if (PRaceTarget.CodeRace <> '') and (PRaceTarget.Libelle <> '') and 
             (PRaceTarget.Libelle <> '(F)') then
            TargetLibelle := Trim(PRaceTarget.Libelle)
          else
            TargetLibelle := PRaceOpinion.TargetRace;  // Fallback au code
          
          Texte := Texte + ' [' + TargetLibelle + '] [' + PRaceOpinion.Source + ']' + #13#10;
          
          // ✨ Supprimer les guillemets de la citation
          Citation := PRaceOpinion.Citation;
          if (Length(Citation) > 0) and (Citation[1] = '"') then
            Citation := Copy(Citation, 2, Length(Citation) - 2);
          
          Texte := Texte + Citation;
        end;
    end;
  
  Result := Texte;
end;

procedure TWinRace.TabRaceSelection(Sender: TObject; aCol, aRow: Integer);
begin
  DeleteData(TreeViewRace,TreeViewRace.Items.GetFirstNode);
  TreeViewRace.Items.Clear;

  // ajouter la racine
  RaceEnCours     := TabRace.Cells[2,aRow];

  // Les icones de niveau peuvent etre propres a l'ethnie : on les recharge AVANT de
  // construire l'arbre, pour que les couleurs de cadre soient celles de cette ethnie.
  ChargeImagesNiveau();

  Node            := TreeViewRace.Items.Add(nil, TabRace.Cells[3,aRow]);
  Node.ImageIndex := 0;
  AffRace.Text    := TabRace.Cells[3,aRow];

  // charger les éléments
  ChargeRaceAttribut();
  ChargeRaceCompetence(TreeViewRace);
  ChargeRaceTalent(TreeViewRace);
  ChargeRaceMetier(TreeViewRace);
  ChargeRaceCorruptionCreation(TreeViewRace);

  // mise en forme
  TreeViewRace.FullExpand;
  TreeViewRace.Selected := TreeViewRace.Items.GetFirstNode;
end;

procedure TWinRace.TreeViewRaceAdvancedCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);
begin
  // mettre en forme l'arbre
  if (Node.Level in [1,2]) then
    begin
       // le premier niveau est en gras
       if (Node.Level = 1) then
             Sender.Font.Style := Sender.Font.Style + [fsBold]
       else
             Sender.Font.Style := Sender.Font.Style - [fsBold];

        // Dessiner le cadre à droite de la feuille de la feuille
        if Node.Level = 1 then
          begin
            NodeRect := Node.DisplayRect(False);
            TextWidth := Sender.Canvas.TextWidth(Node.Text);  // Largeur du texte de la feuille
            FrameRect := NodeRect;
            FrameRect.Left := FrameRect.Left + TextWidth + ((Node.Level + 1) * 29) + 5;  // Ajuster la position du cadre ici
            // Le numero de niveau se lit AVANT le point, et non sur le premier
            // caractere : "10.Archmage" commence par '1'. Les bornes viennent du
            // tableau lui-meme, donc elles suivent MaxNiveauMetier sans le rappeler.
            Nv := StrToIntDef(ExtractStringBefore(Node.Text, '.'), 0);
            if (Nv >= 1) and (Nv <= High(ColorList)) then
              ColorLoc := ColorList[Nv]
            else
              ColorLoc := CouleurGrisFonce;  // Couleur du cadre
            Sender.Canvas.brush.Color := colorloc;  // Couleur du cadre
            Sender.Canvas.Pen.Width := 1;  // Épaisseur du cadre
            Sender.Canvas.Rectangle(FrameRect);
          end
    end
  else
      begin
        Sender.Font.Style := Sender.Font.Style - [fsBold];
      end;
  DefaultDraw := True;  // Permettre le dessin par défaut

end;

procedure TWinRace.TreeViewRaceChange(Sender: TObject; Node: TTreeNode);
var
 PCompetence:        StructureCompetence;
 PAttribut:          StructureAttribut;
 PTalent:            StructureTalent;
 PMetier:            StructureMetier;
 CheminImage1:       String;
 CheminImage2:       String;
 CheminImage3:       String;
 NodeData:      TMyNodeData;
Begin
   NodeData               := TMyNodeData.Create;
 if Assigned(Node) then
    begin
      // sélection d'une ligne de l'arbre
      CheminImage1         := '';
      CheminImage2         := '';
      CheminImage3         := '';
      AffCode.Text         := '';
      AffAttribut.Text     := '';
      AffDescription.Text  := TabRace.Cells[4, TabRace.Row];
      AffDescription.Text  := AffDescription.Text + AfficherOpinionsRace(RaceEnCours);  // ✨ AJOUTER OPINIONS
      // Obtenez le texte du nœud sélectionné
      if Node <> TreeViewRace.Items.GetFirstNode then
        begin
            CheminImage2   := '';
            AffType.text   := Node.Parent.Text;
            // récupération du pointeur sur la donnée suivant le type du parent
            if Node.Parent.Text = ConstArbreMetierPossible then
              begin
                NodeData           := TMyNodeData(Node.Data);
                PMetier            := ChercheMetier(NodeData.AdditionalData);
                AffCode.Text       := PMetier.CodeMetier;
                AffLibelle.Text    := PMetier.Libelle;
                AffLivre.Text      := getTexteLibelle(PMetier.Livre,'','',true);
                CheminImage3       := CheminMetierImage(PMetier.CodeMetier);
                AffDescription.Text:= PMetier.Description;
                AffDescription.Text:= AffDescription.Text + TexteMetierSousMetier(PMetier.CodeMetier, '') + TexteMetierRaceChoixMetier(PMetier.CodeMetier, RaceEnCours, '');
              end
            else if Node.Parent.Text = ConstArbreAttribut then
              begin
                NodeData           := TMyNodeData(Node.Data);
                PAttribut          := ChercheAttribut(NodeData.AdditionalData);
                AffCode.Text       := PAttribut.CodeAttribut;
                AffLibelle.Text    := PAttribut.Libelle;
                AffLivre.Text      := getTexteLibelle(PAttribut.Livre,'','',true);
                AffDescription.Text:= PAttribut.Description;
              end
            else if Node.Parent.Text = ConstArbreCompetence then
              Begin
                NodeData           := TMyNodeData(Node.Data);
                PCompetence        := ChercheCompetence(NodeData.AdditionalData);
                AffCode.Text       := PCompetence.CodeCompetence;
                AffLibelle.Text    := PCompetence.Libelle;
                AffLivre.Text      := getTexteLibelle(PCompetence.Livre,'','',true);
                AffAttribut.Text   := GetAllTexteLibelle(PCompetence.CodeAttribut);
                AffDescription.Text:= PCompetence.Description;
              end
            else if Node.Parent.Text = ConstArbreTalent then
              Begin
                if Node.text <> ConstArbreAuchoix then
                begin
                  NodeData           := TMyNodeData(Node.Data);
                  PTalent            := ChercheTalent(Nodedata.AdditionalData);
                  AffCode.Text       := PTalent.CodeTalent;
                  AffLibelle.Text    := PTalent.Libelle;
                  AffAttribut.Text   := GetAllTexteLibelle(PTalent.Attribut);
                  AffDescription.Text:= DescriptionTalent(PTalent.CodeTalent, RaceEnCours);
                end
              end
            else if Node.Parent.Text = ConstArbreAuchoix then
              Begin
                NodeData           := TMyNodeData(Node.Data);
                PTalent            := ChercheTalent(Nodedata.AdditionalData);
                AffCode.Text       := PTalent.CodeTalent;
                AffLibelle.Text    := PTalent.Libelle;
                AffLivre.Text      := getTexteLibelle(PTalent.Livre,'','',true);
                AffAttribut.Text   := GetAllTexteLibelle(PTalent.Attribut);
                AffDescription.Text:= DescriptionTalent(PTalent.CodeTalent, RaceEnCours);
              end;
       end;
      // chargement des images
      if CheminImage3 = '' then
        begin
         CheminImage1       := CheminRaceImage(RaceEnCours,'2');
         CheminImage2       := CheminRaceImage(RaceEnCours,'1');
         end;
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

      // géer les champs à afficher ou cacher
      PanelHautGauche.visible := (AffCode.Text <> '');
      PanelDescription.visible:= (AffDescription.Text <> '');
      AffAttribut.visible     := (AffAttribut.Text <> '');
      LabAttribut.visible     := (AffAttribut.Text <> '');
 end;
end;

end.

