unit WinLivre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls, Menus,
  Dialogs, Graphics, BCButton, ChargeConstantes,
  Generics.Collections, DOM, XMLRead, XMLWrite, FGL;

type
  // Structure pour stocker les données du XML
  TRaceData = record
    Code: String;
    Libelle: String;
    Description: String;
  end;
  
  PRaceData = ^TRaceData;
  TRaceDataMap = specialize TFPGMap<String, PRaceData>;
  
  TWinLivres = class(TForm)
    // Panels
    PanelLeft: TPanel;
    PanelRight: TPanel;
    SplitterMain: TSplitter;
    
    // Left Side - TreeView
    LabelLivre: TLabel;
    ButtonChargerXML: TBCButton;
    TreeViewLivre: TTreeView;
    
    // Right Side - Form dynamique
    LabelFormTitle: TLabel;
    ScrollBox: TScrollBox;
    GroupBoxForm: TGroupBox;
    
    // Form Controls
    LabelFormCode: TLabel;
    EditFormCode: TEdit;
    LabelFormLib: TLabel;
    EditFormLib: TEdit;
    LabelFormDesc: TLabel;
    MemoFormDesc: TMemo;
    
    // Buttons
    PanelFormButtons: TPanel;
    ButtonFormValider: TBCButton;
    ButtonFormAnnuler: TBCButton;
    ButtonFormSupprimer: TBCButton;
    
    // PopupMenu
    PopupMenuTree: TPopupMenu;
    MenuItemAjouter: TMenuItem;
    MenuItemModifier: TMenuItem;
    MenuItemSupprimer: TMenuItem;
    
    // Événements
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonChargerXMLClick(Sender: TObject);
    procedure TreeViewLivreChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewLivreDblClick(Sender: TObject);
    procedure TreeViewLivreContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure PopupMenuTreePopup(Sender: TObject);
    procedure MenuItemAjouterClick(Sender: TObject);
    procedure MenuItemModifierClick(Sender: TObject);
    procedure MenuItemSupprimerClick(Sender: TObject);
    procedure ButtonFormValiderClick(Sender: TObject);
    procedure ButtonFormAnnulerClick(Sender: TObject);
    procedure ButtonFormSupprimerClick(Sender: TObject);
    procedure ChargerXMLFile(AFilePath: String);

  private
    // Variables
    XMLDoc: TXMLDocument;
    RacesDataList: TRaceDataMap;
    NodeSelectionnee: TTreeNode;
    TypeNodeSelectionnee: String;  // 'CHAPITRE' ou 'DONNEE'
    CodeDonneeSelectionnee: String;
    
    // Procédures privées
    function GetBookLabel(BookCode: String): String;
    procedure AfficherDonneeRace(ACode: String);
    procedure NettoyerForm();
    procedure MasquerForm();
    procedure InitialiserControles();
    
  public

  end;

var
  WinLivres: TWinLivres;

implementation

{$R *.lfm}

// ✨ ÉVÉNEMENTS FORM

procedure TWinLivres.FormCreate(Sender: TObject);
begin
  RacesDataList := TRaceDataMap.Create;
  NodeSelectionnee := nil;
  TypeNodeSelectionnee := '';
  CodeDonneeSelectionnee := '';
  XMLDoc := nil;
  
  // Initialiser les contrôles
  InitialiserControles();
  
  // Style
  try
    { MiseEnFormeDesChamp(Self); }  // À implémenter plus tard
  except
    // GlobalFonts non disponible, continuer sans
  end;
end;

procedure TWinLivres.FormShow(Sender: TObject);
begin
  // Afficher le bouton de chargement XML
  // (Message supprimé pour l'instant)
end;

procedure TWinLivres.InitialiserControles();
begin
  // Mettre à jour les captions
  LabelLivre.Caption := 'Fichier XML:';
  LabelFormCode.Caption := 'Code:';
  LabelFormLib.Caption := 'Libelle:';
  LabelFormDesc.Caption := 'Description:';
  
  // Rendre READ-ONLY pour l'affichage
  EditFormCode.ReadOnly := True;
  EditFormLib.ReadOnly := True;
  MemoFormDesc.ReadOnly := True;
  
  MasquerForm();
end;

// ✨ CHARGEMENT XML

procedure TWinLivres.ButtonChargerXMLClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
    OpenDialog.InitialDir := ExtractFilePath(Application.ExeName) + 'DATABASE';
    
    if OpenDialog.Execute then
      ChargerXMLFile(OpenDialog.FileName);
  finally
    OpenDialog.Free;
  end;
end;

// ========== HELPER FUNCTION ==========
function TWinLivres.GetBookLabel(BookCode: String): String;
var
  TextElements: TDOMNodeList;
  I: Integer;
  XMLElement: TDOMElement;
  SearchCode: String;
begin
  Result := BookCode;  // Fallback si pas trouvé
  
  if XMLDoc = nil then Exit;
  
  // Construire le code de traduction
  SearchCode := 'RULES-' + BookCode;
  
  // Chercher dans DATA_LABEL
  TextElements := XMLDoc.GetElementsByTagName('Text');
  
  for I := 0 to TextElements.Count - 1 do
  begin
    XMLElement := TDOMElement(TextElements.Item[I]);
    if XMLElement.GetAttribute('name') = SearchCode then
    begin
      // Récupérer le texte et enlever les guillemets
      Result := XMLElement.TextContent;
      if (Length(Result) > 0) and (Result[1] = '"') and (Result[Length(Result)] = '"') then
        Result := Copy(Result, 2, Length(Result) - 2);
      Exit;
    end;
  end;
end;

procedure TWinLivres.ChargerXMLFile(AFilePath: String);
var
  XMLElement: TDOMElement;
  SpecieElements, CareerElements: TDOMNodeList;
  I: Integer;
  Code, Description, Explanation: String;
  RaceData: TRaceData;
  PRaceData: ^TRaceData;
  NodeRoot: TTreeNode;
  NodeRaces, NodeRace: TTreeNode;
  NodeCareers, NodeCareer: TTreeNode;
  DescNode: TDOMNode;
  ExplNode: TDOMNode;
  FileName: String;
begin
  try
    // Charger le fichier XML
    ReadXMLFile(XMLDoc, AFilePath);
    
    if XMLDoc = nil then
      begin
        // ShowMessage('Erreur: Impossible de charger le XML');
        Exit;
      end;
    
    // Effacer l'arbre
    TreeViewLivre.Items.Clear;
    if RacesDataList <> nil then
      RacesDataList.Clear;
    
    // Créer le nœud racine avec le nom traduit du livre
    FileName := ExtractFileName(AFilePath);
    // Enlever l'extension .Xml pour construire le code de traduction
    FileName := Copy(FileName, 1, Length(FileName) - 4);
    // Récupérer le label traduit depuis DATA_LABEL
    NodeRoot := TreeViewLivre.Items.Add(nil, GetBookLabel(FileName));
    NodeRoot.Data := Pointer(PtrInt(0));  // 0 = chapitre
    
    // ========== RACES ==========
    NodeRaces := TreeViewLivre.Items.AddChild(NodeRoot, 'Races');
    NodeRaces.Data := Pointer(PtrInt(0));
    
    SpecieElements := XMLDoc.GetElementsByTagName('Specie');
    
    if SpecieElements.Count > 0 then
      begin
        for I := 0 to SpecieElements.Count - 1 do
          begin
            XMLElement := TDOMElement(SpecieElements.Item[I]);
            
            // Récupérer les attributs
            Code := XMLElement.GetAttribute('id');
            
            // Ignorer les éléments sans Code valide
            if Code = '' then
              Continue;
            
            // Chercher Description et Explanation
            DescNode := XMLElement.FindNode('Description');
            ExplNode := XMLElement.FindNode('Explanation');
            
            if DescNode <> nil then
              Description := DescNode.TextContent
            else
              Description := '';
            
            if ExplNode <> nil then
              Explanation := ExplNode.TextContent
            else
              Explanation := '';
            
            // Stocker dans la liste
            RaceData.Code := Code;
            RaceData.Libelle := Description;
            RaceData.Description := Explanation;
            
            New(PRaceData);
            PRaceData^ := RaceData;
            RacesDataList.Add(Code, PRaceData);
            
            // Ajouter dans l'arbre
            NodeRace := TreeViewLivre.Items.AddChild(NodeRaces, Code);
            NodeRace.Data := Pointer(PtrInt(1));  // 1 = donnée
          end;
      end;
    
    // ========== CARRIÈRES ==========
    NodeCareers := TreeViewLivre.Items.AddChild(NodeRoot, 'Carrières');
    NodeCareers.Data := Pointer(PtrInt(0));
    
    CareerElements := XMLDoc.GetElementsByTagName('Career');
    
    if CareerElements.Count > 0 then
      begin
        for I := 0 to CareerElements.Count - 1 do
          begin
            XMLElement := TDOMElement(CareerElements.Item[I]);
            Code := XMLElement.GetAttribute('id');
            
            // Ignorer les éléments sans Code valide
            if Code = '' then
              Continue;
            
            // Ajouter dans l'arbre
            NodeCareer := TreeViewLivre.Items.AddChild(NodeCareers, Code);
            NodeCareer.Data := Pointer(PtrInt(1));
          end;
      end;
    
    // Expand les branches principales
    NodeRoot.Expand(False);
    
    LabelFormTitle.Caption := 'XML chargé: ' + FileName;
    // Message de succès supprimé pour l'instant
    // ShowMessage('✅ ' + IntToStr(SpecieElements.Count) + ' races + ' + IntToStr(CareerElements.Count) + ' carrières chargées!');
    
  except
    on E: Exception do
      // ShowMessage('Erreur: ' + E.Message);
  end;

end;

// ✨ ÉVÉNEMENTS TREEVIEW

procedure TWinLivres.TreeViewLivreChange(Sender: TObject; Node: TTreeNode);
begin
  if Node = nil then Exit;
  
  NodeSelectionnee := Node;
  
  // Vérifier si c'est un chapitre ou une donnée
  if PtrInt(Node.Data) = 0 then
    begin
      // C'est un chapitre (Races)
      TypeNodeSelectionnee := 'CHAPITRE';
      MasquerForm();
    end
  else
    begin
      // C'est une race
      TypeNodeSelectionnee := 'DONNEE';
      AfficherDonneeRace(Node.Text);  // Node.Text = le Code de la race
    end;
end;

procedure TWinLivres.TreeViewLivreDblClick(Sender: TObject);
begin
  // Pour l'instant, juste READ-ONLY
  // Double-clic ne fait rien
end;

procedure TWinLivres.TreeViewLivreContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := False;
end;

// ✨ MENU CONTEXTUEL (DÉSACTIVÉ POUR AFFICHAGE)

procedure TWinLivres.PopupMenuTreePopup(Sender: TObject);
begin
  // Tous les menus désactivés en phase affichage
  MenuItemAjouter.Enabled := False;
  MenuItemModifier.Enabled := False;
  MenuItemSupprimer.Enabled := False;
end;

procedure TWinLivres.MenuItemAjouterClick(Sender: TObject);
begin
  // À implémenter
end;

procedure TWinLivres.MenuItemModifierClick(Sender: TObject);
begin
  // À implémenter
end;

procedure TWinLivres.MenuItemSupprimerClick(Sender: TObject);
begin
  // À implémenter
end;

// ✨ AFFICHAGE DYNAMIQUE

procedure TWinLivres.AfficherDonneeRace(ACode: String);
var
  RaceData: PRaceData;
  I: Integer;
begin
  NettoyerForm();
  
  // Chercher la race dans la liste
  if RacesDataList <> nil then
    begin
      I := RacesDataList.IndexOf(ACode);
      if I >= 0 then
        begin
          RaceData := RacesDataList.Data[I];
          if RaceData <> nil then
            begin
              LabelFormTitle.Caption := 'Race: ' + RaceData^.Code;
              EditFormCode.Text := RaceData^.Code;
              EditFormLib.Text := RaceData^.Libelle;
              MemoFormDesc.Text := RaceData^.Description;
              CodeDonneeSelectionnee := ACode;
              GroupBoxForm.Visible := True;
              Exit;
            end;
        end;
    end;
  
  MasquerForm();
end;

procedure TWinLivres.NettoyerForm();
begin
  EditFormCode.Clear;
  EditFormLib.Clear;
  MemoFormDesc.Clear;
  CodeDonneeSelectionnee := '';
end;

procedure TWinLivres.MasquerForm();
begin
  GroupBoxForm.Visible := False;
  LabelFormTitle.Caption := 'Sélectionnez une donnée';
  NettoyerForm();
end;

// ✨ BOUTONS FORM (DÉSACTIVÉS POUR AFFICHAGE)

procedure TWinLivres.ButtonFormValiderClick(Sender: TObject);
begin
  // ShowMessage('Fonctionnalité d''édition non disponible en phase affichage');
end;

procedure TWinLivres.ButtonFormAnnulerClick(Sender: TObject);
begin
  MasquerForm();
  NodeSelectionnee := nil;
  TreeViewLivre.Selected := nil;
end;

procedure TWinLivres.ButtonFormSupprimerClick(Sender: TObject);
begin
  // ShowMessage('Fonctionnalité d''édition non disponible en phase affichage');
end;

end.
