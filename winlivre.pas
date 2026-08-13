unit WinLivre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls, Menus,
  Dialogs, Graphics, BCButton, ChargeConstantes, ChargeTexte, ChargeCompetence, ChargeTalent, ChargeMetier, ChargeLivre, ChargeArme, ChargeArmure, ChargeRace, UnitCalcul, Grids,
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
  
  // Structure pour les attributs
  TAttributData = record
    Code: String;
    Libelle: String;
    Valeur: String;  // "2d10+20" ou "1xBATTR_S+2xBATTR_T..."
  end;
  
  PAttributData = ^TAttributData;
  TAttributDataMap = specialize TFPGMap<String, PAttributData>;
  
  // Structure pour les composants d'une formule calculée
  TFormulaComponent = record
    Coefficient: Integer;     // 1, 2, 0, etc.
    AttrCode: String;         // BATTR_S, BATTR_T, BATTR_WP
    AttrLabel: String;        // "Strength", "Toughness", etc.
  end;
  
  TFormulaComponentArray = array of TFormulaComponent;

const
  // Préfixes d'affichage de l'équipement dans l'arbre (comme dans WinMetier)
  EquipArme   = '(W) ';
  EquipArmure = '(P) ';

type
  
  // Information portée par chaque noeud du TreeView.
  // Remplace l'ancien Node.Data := Pointer(PtrInt(type)) : on garde le type
  // ET le code de l'élément, ce qui permettra de remonter vers le XML.
  TNodeInfo = class
    TypeNode: Integer;
    Code:     String;
  end;
  
  TWinLivres = class(TForm)
    // Panels
    PanelLeft: TPanel;
    PanelRight: TPanel;
    SplitterMain: TSplitter;
    
    // Left Side - TreeView
    PanelTopButtons: TPanel;
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
    LabelFormAttribut: TLabel;
    EditFormAttribut: TEdit;
    LabelFormMax: TLabel;
    EditFormMax: TEdit;
    LabelFormClasse: TLabel;
    EditFormClasse: TEdit;
    LabelFormCompPrinc: TLabel;
    EditFormCompPrinc: TEdit;
    MemoFormDesc: TMemo;
    
    // Attribute Controls (hidden until attribute selected)
    LabelFormAttrName: TLabel;
    EditFormAttrName: TEdit;
    LabelFormAttrDices: TLabel;
    EditFormAttrDices: TEdit;
    LabelFormAttrBaseValue: TLabel;
    EditFormAttrBaseValue: TEdit;
    LabelFormAttrFormula: TLabel;
    EditFormAttrFormula: TEdit;
    
    // Component Controls for calculated attributes (up to 3 components)
    LabelFormComponent1: TLabel;
    EditFormComponent1Attr: TEdit;
    EditFormComponent1Coeff: TEdit;
    LabelFormComponent2: TLabel;
    EditFormComponent2Attr: TEdit;
    EditFormComponent2Coeff: TEdit;
    LabelFormComponent3: TLabel;
    EditFormComponent3Attr: TEdit;
    EditFormComponent3Coeff: TEdit;
    
    // Skills Grid (hidden until skills section selected)
    LabelFormSkills: TLabel;
    StringGridSkills: TStringGrid;
    StringGridCareers: TStringGrid;
    StringGridRaces: TStringGrid;
    StringGridAttributs: TStringGrid;
    StringGridCompetences: TStringGrid;
    StringGridTalents: TStringGrid;
    StringGridEquipement: TStringGrid;
    StringGridDetail: TStringGrid;
    StringGridQualites: TStringGrid;
    MemoDetail: TMemo;
    StringGridRandomRace: TStringGrid;
    
    // Talents (to be created in code)
    LabelTalentsRandom: TLabel;
    TreeViewTalents: TTreeView;
    
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
    procedure InitTalentsUI();
    procedure FormShow(Sender: TObject);
    procedure ButtonChargerXMLClick(Sender: TObject);
    procedure TreeViewLivreChange(Sender: TObject; Node: TTreeNode);
    procedure GridNiveauPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
    procedure TreeViewLivreDblClick(Sender: TObject);
    procedure TreeViewLivreContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure PopupMenuTreePopup(Sender: TObject);
    procedure MenuItemAjouterClick(Sender: TObject);
    procedure MenuItemModifierClick(Sender: TObject);
    procedure MenuItemSupprimerClick(Sender: TObject);
    procedure ButtonFormValiderClick(Sender: TObject);
    procedure ButtonFormAnnulerClick(Sender: TObject);
    procedure ButtonFormSupprimerClick(Sender: TObject);
    procedure AfficherInfosLivre();

  private
    // Variables
    XMLDoc: TXMLDocument;
    RacesDataList: TRaceDataMap;
    AttributesDataList: TAttributDataMap;  // Attributs de la race actuelle
    AttributeValuesMap: TStringList;  // Map attribute codes to raw values
    MetierRacesMap: TStringList;  // CODE_METIER=CodeRace1|CodeRace2|...
    NiveauCourantAffiche: Integer;  // niveau mis en évidence dans les grilles
    RaceSkillsData: TStringList;        // Compétences de la race sélectionnée
    RaceCareersData: TStringList;       // Carrières de la race sélectionnée (Code|Valeur)
    NodeSelectionnee: TTreeNode;
    TypeNodeSelectionnee: String;  // 'CHAPITRE', 'DONNEE' ou 'ATTRIBUT'
    CodeDonneeSelectionnee: String;
    CurrentRaceCode: String;        // Store code of selected race
    CurrentAttributeValue: String;  // Store raw attribute value for display
    
    // Procédures privées
    function GetBookLabel(BookCode: String): String;
    procedure AfficherDonneeRace(ACode: String);
    procedure AfficherDonneeAttribut(ACode: String);
    procedure ParseAttributValue(Valeur: String; out AttrType: String; out Dices: String; out BaseValue: String; out SimpleValue: String; out Formula: String);
    function GetAttributLabel(CodeAttribut: String): String;
    function TranslateBATTRCode(BATTRCode: String): String;
    function ParseFormulaComponents(Formula: String): TFormulaComponentArray;
    procedure LoadAttributesForRace(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
    procedure LoadSkillsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
    procedure LoadTalentsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
    procedure LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
    // Branche Métier de niveau 1
    procedure ConstruireMetierRacesMap();
    procedure LoadMetierRacesPossibles(CareerCode: String; MetierNode: TTreeNode);
    procedure LoadMetierNiveaux(CareerElement: TDOMElement; CareerCode: String; MetierNode: TTreeNode);
    procedure LoadMetierNiveauAttributs(CareerElement: TDOMElement; Niveau: Integer; CodeNiveau: String; NodeBase: TTreeNode);
    procedure LoadMetierNiveauCompetences(CareerElement: TDOMElement; Niveau: Integer; SkillPrincipal: String; CodeNiveau: String; NodeBase: TTreeNode);
    procedure LoadMetierNiveauTalents(CareerElement: TDOMElement; Niveau: Integer; CodeNiveau: String; NodeBase: TTreeNode);
    procedure LoadMetierNiveauEquipement(CareerElement: TDOMElement; Niveau: Integer; CodeNiveau: String; NodeBase: TTreeNode);
    procedure AjouterFeuilleEquipement(NomItem: String; NodeBase: TTreeNode);
    procedure LoadSkillsForRace(RaceElement: TDOMElement; RaceCode: String);
    procedure LoadCareersForRace(RaceElement: TDOMElement);
    procedure AfficherSkillsForRace(RaceCode: String);
    procedure AfficherTalentsForRace();
    procedure AfficherCareersForRace(RaceCode: String);
    procedure AfficherRacesForMetier(CareerCode: String);
    procedure AfficherDonneeMetier(CareerCode: String);
    procedure AfficherDonneeCompetence(CodeComp, Titre: String);
    procedure ChargerBrancheSimple(ChapitreTag, ElementTag, TitreBranche: String; TypeNoeud: Integer; NodeParent: TTreeNode; Regrouper: Boolean = False);
    procedure AfficherDonneeTalent(CodeTalent, Titre: String);
    procedure AfficherDonneeEquipement(Code, TagName, Titre: String);
    procedure AfficherDonneeBonusMalus(Code, Titre: String);
    procedure AfficherDonneeSort(Code, Titre: String);
    procedure AfficherTirageRace();
    procedure AjouterLignesTalentsSort(Valeur: String);
    procedure AjouterLigneDetail(Libelle, Valeur: String; Toujours: Boolean = False);
    procedure AjouterLignesQualite(Valeur, Prefixe: String);
    function  PrefixeLivre(Code: String): String;
    function  TraduireCodesMultiples(Valeur: String): String;
    function  DecouperDegats(Degats: String; out CodeBonus, Fixe: String): Boolean;
    function  TrouverElementParId(TagName, Id: String): TDOMElement;
    procedure AfficherAttributsForNiveau(CodeNiveau: String);
    procedure AfficherCompetencesForNiveau(CodeNiveau: String);
    procedure AfficherTalentsForNiveau(CodeNiveau: String);
    procedure AfficherEquipementForNiveau(CodeNiveau: String);
    function  LibelleEquipement(NomItem: String; out TypeEquip: Char): String;
    function  TrouverCareerElement(CareerCode: String): TDOMElement;
    procedure MasquerAfficherElements(ElementType: String);
    procedure SortSkillsGrid();
    procedure ShowComponentControl(Index: Integer; AttrLabel: String; Coefficient: String);
    procedure HideComponentControls(Index: Integer);
    procedure NettoyerForm();
    procedure MasquerForm();
    procedure InitialiserControles();
    
  public
    procedure ChargerXMLFile(AFilePath: String);
  end;

var
  WinLivres: TWinLivres;
  FileName: String;        // Nom complet du fichier (ex: "BOOK RULESBOOK.Xml")
  FileCode: String;        // Nom sans extension (ex: "BOOK RULESBOOK")
implementation

{$R *.lfm}

// ✨ HELPERS TREEVIEW - gestion du TNodeInfo porté par chaque noeud

// Attache un TNodeInfo au noeud. Libère l'ancien s'il y en avait un.
procedure SetNodeInfo(Node: TTreeNode; AType: Integer; ACode: String = '');
var
  Info: TNodeInfo;
begin
  if Node = nil then Exit;
  
  if Node.Data <> nil then
    TNodeInfo(Node.Data).Free;
  
  Info          := TNodeInfo.Create;
  Info.TypeNode := AType;
  Info.Code     := ACode;
  Node.Data     := Info;
end;

// Type du noeud, ou -1 si le noeud est nil / sans info
function GetNodeType(Node: TTreeNode): Integer;
begin
  if (Node = nil) or (Node.Data = nil) then
    Result := -1
  else
    Result := TNodeInfo(Node.Data).TypeNode;
end;

// Code du noeud, ou '' si le noeud est nil / sans info
function GetNodeCode(Node: TTreeNode): String;
begin
  if (Node = nil) or (Node.Data = nil) then
    Result := ''
  else
    Result := TNodeInfo(Node.Data).Code;
end;

// Libère tous les TNodeInfo de l'arbre. À appeler AVANT Items.Clear,
// sinon les objets restent en mémoire (fuite).
procedure LibererNodesData(Tree: TTreeView);
var
  I: Integer;
begin
  if Tree = nil then Exit;
  
  for I := 0 to Tree.Items.Count - 1 do
    if Tree.Items[I].Data <> nil then
    begin
      TNodeInfo(Tree.Items[I].Data).Free;
      Tree.Items[I].Data := nil;
    end;
end;

// Lit le contenu texte d'un noeud XML : trim + suppression des guillemets.
// Le XML stocke ses valeurs sous la forme "1" ou "Agitator", guillemets compris.
// Même convention que XmlExportImport, qui fait RemoveQuotes(UTF8Encode(...)).
function ValeurXML(Node: TDOMNode): String;
begin
  Result := '';
  if Node = nil then Exit;
  
  Result := RemoveQuotes(Trim(Node.TextContent));
end;

// ✨ ÉVÉNEMENTS FORM

procedure TWinLivres.FormCreate(Sender: TObject);
begin
  RacesDataList := TRaceDataMap.Create;
  AttributesDataList := TAttributDataMap.Create;
  AttributeValuesMap := TStringList.Create;
  MetierRacesMap := TStringList.Create;
  RaceSkillsData := TStringList.Create;
  RaceCareersData := TStringList.Create;
  NodeSelectionnee := nil;
  TypeNodeSelectionnee := '';
  CodeDonneeSelectionnee := '';
  CurrentRaceCode := '';
  CurrentAttributeValue := '';
  XMLDoc := nil;
  
  // Initialiser les contrôles
  InitialiserControles();
  
  // Initialiser l'UI des talents
  InitTalentsUI();

  TreeViewLivre.ReadOnly := True;
  
  // Style
  try
    { MiseEnFormeDesChamp(Self); }  // À implémenter plus tard
  except
    // GlobalFonts non disponible, continuer sans
  end;
end;

// ========== INITIALISER L'UI DES TALENTS ==========
procedure TWinLivres.InitTalentsUI();
begin
  // Créer le label "Talents aléatoires"
  LabelTalentsRandom := TLabel.Create(Self);
  LabelTalentsRandom.Parent := Self;
  LabelTalentsRandom.Left := 430;
  LabelTalentsRandom.Top := 350;
  LabelTalentsRandom.Width := 300;
  LabelTalentsRandom.Height := 20;
  LabelTalentsRandom.Caption := '';
  LabelTalentsRandom.Visible := False;
  
  // Créer le TTreeView pour les talents
  TreeViewTalents := TTreeView.Create(Self);
  TreeViewTalents.Parent := Self;
  TreeViewTalents.Left := 430;
  TreeViewTalents.Top := 120;
  TreeViewTalents.Width := 600;
  TreeViewTalents.Height := 220;
  TreeViewTalents.Visible := False;
end;

procedure TWinLivres.FormShow(Sender: TObject);
begin
  // Afficher le bouton de chargement XML
  // (Message supprimé pour l'instant)
end;

procedure TWinLivres.InitialiserControles();
begin
  // Mettre à jour les captions pour Races
  LabelLivre.Caption := GetTexteLibelle('LAB_155');        // 'Open book'
  LabelFormCode.Caption := GetTexteLibelle('LAB_001');      // 'Code'
  LabelFormLib.Caption := GetTexteLibelle('LAB_002');       // 'Label'
  LabelFormDesc.Caption := GetTexteLibelle('LAB_003');      // 'Description'
  
  // Mettre à jour les captions pour Attributs
  LabelFormAttrName.Caption := GetTexteLibelle('LAB_008');  // 'Attribute'
  LabelFormAttrDices.Caption := GetTexteLibelle('LAB_161'); // 'Dices'
  LabelFormAttrBaseValue.Caption := GetTexteLibelle('LAB_025'); // 'Value'
  LabelFormAttrFormula.Caption := GetTexteLibelle('LAB_020'); // 'Calculation'
  LabelFormSkills.Caption := GetTexteLibelle('LAB_087');  // 'Specie's Skills'
  LabelFormCompPrinc.Caption := GetTexteLibelle('LAB_009');  // 'Compétence'
  // Libellé emprunté aux traductions PDF, faute de LAB_ dédié à 'Classe'.
  LabelFormClasse.Caption := GetTexteLibelle('PDF_MAIN1_CLASS');  // 'Classe'
  LabelFormAttribut.Caption := GetTexteLibelle('LAB_008');  // 'Attribut'
  LabelFormMax.Caption := GetTexteLibelle('LAB_044');  // 'Max'
  
  // Mettre à jour les captions pour Composants
  LabelFormComponent1.Caption := 'Component 1:';
  LabelFormComponent2.Caption := 'Component 2:';
  LabelFormComponent3.Caption := 'Component 3:';
  
  // Rendre READ-ONLY pour l'affichage
  EditFormCode.ReadOnly := True;
  EditFormLib.ReadOnly := True;
  MemoFormDesc.ReadOnly := True;
  EditFormAttrName.ReadOnly := True;
  EditFormAttrDices.ReadOnly := True;
  EditFormAttrBaseValue.ReadOnly := True;
  EditFormAttrFormula.ReadOnly := True;
  EditFormComponent1Attr.ReadOnly := True;
  EditFormComponent1Coeff.ReadOnly := True;
  EditFormComponent2Attr.ReadOnly := True;
  EditFormComponent2Coeff.ReadOnly := True;
  EditFormComponent3Attr.ReadOnly := True;
  EditFormComponent3Coeff.ReadOnly := True;
  
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

// ========== PARSE ATTRIBUTE VALUE ==========
procedure TWinLivres.ParseAttributValue(Valeur: String; out AttrType: String; out Dices: String; out BaseValue: String; out SimpleValue: String; out Formula: String);
var
  PosD10: Integer;
  PosPlus: Integer;
  DicesPart: String;
begin
  Dices := '';
  BaseValue := '';
  SimpleValue := '';
  Formula := '';
  AttrType := '';
  
  // Enlever les guillemets si présents
  if (Length(Valeur) > 0) and (Valeur[1] = '"') then
    Valeur := Copy(Valeur, 2, Length(Valeur) - 2);
  if (Length(Valeur) > 0) and (Valeur[Length(Valeur)] = '"') then
    Valeur := Copy(Valeur, 1, Length(Valeur) - 1);
  
  PosD10 := Pos('d10', Valeur);
  
  if PosD10 > 0 then
  begin
    // Type 1: Format simple avec dés: "2d10+20"
    AttrType := 'DICES';
    DicesPart := Copy(Valeur, 1, PosD10 - 1);
    Dices := DicesPart;
    
    // Chercher la partie +X après d10
    PosPlus := Pos('+', Valeur);
    if PosPlus > 0 then
      BaseValue := Copy(Valeur, PosPlus + 1, Length(Valeur))
    else
      BaseValue := '0';
  end
  else if Pos('xBATTR_', Valeur) > 0 then
  begin
    // Type 2: Format complexe avec références à attributs: "1xBATTR_S+2xBATTR_T..."
    AttrType := 'FORMULA';
    Formula := Valeur;
  end
  else
  begin
    // Type 3: Valeur fixe simple: "2", "1", "3", "4"
    AttrType := 'SIMPLE';
    SimpleValue := Valeur;
  end;
end;

// ========== TRANSLATE BATTR CODE ==========
function TWinLivres.TranslateBATTRCode(BATTRCode: String): String;
var
  AttrCode: String;
begin
  // BATTR_S → RULES-ATTR_S, etc.
  AttrCode := 'RULES-ATTR_' + Copy(BATTRCode, 7, Length(BATTRCode));
  Result := GetAttributLabel(AttrCode);
end;

// ========== PARSE FORMULA COMPONENTS ==========
function TWinLivres.ParseFormulaComponents(Formula: String): TFormulaComponentArray;
var
  Parts: TStringList;
  I: Integer;
  Part: String;
  PosX: Integer;
  Coefficient: String;
  AttrCode: String;
  Component: TFormulaComponent;
begin
  SetLength(Result, 0);
  
  // Enlever les guillemets
  if (Length(Formula) > 0) and (Formula[1] = '"') then
    Formula := Copy(Formula, 2, Length(Formula) - 2);
  if (Length(Formula) > 0) and (Formula[Length(Formula)] = '"') then
    Formula := Copy(Formula, 1, Length(Formula) - 1);
  
  // Remplacer les '+' par des séparateurs
  Formula := StringReplace(Formula, '+', '|', [rfReplaceAll]);
  Formula := StringReplace(Formula, '|', '+', [rfReplaceAll]);
  
  Parts := TStringList.Create;
  try
    ExtractStrings(['+'], [], PChar(Formula), Parts);
    
    for I := 0 to Parts.Count - 1 do
    begin
      Part := Trim(Parts[I]);
      if Part = '' then Continue;
      
      // Parser "1xBATTR_S"
      PosX := Pos('x', Part);
      if PosX > 0 then
      begin
        Coefficient := Copy(Part, 1, PosX - 1);
        AttrCode := Copy(Part, PosX + 1, Length(Part));
        
        Component.Coefficient := StrToIntDef(Coefficient, 0);
        Component.AttrCode := AttrCode;
        Component.AttrLabel := TranslateBATTRCode(AttrCode);
        
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := Component;
      end;
    end;
  finally
    Parts.Free;
  end;
end;

// ========== GET ATTRIBUTE LABEL ==========
function TWinLivres.GetAttributLabel(CodeAttribut: String): String;
var
  TextElements: TDOMNodeList;
  I: Integer;
  XMLElement: TDOMElement;
begin
  Result := CodeAttribut;  // Fallback
  
  if XMLDoc = nil then Exit;
  
  // Chercher dans DATA_LABEL
  TextElements := XMLDoc.GetElementsByTagName('Text');
  
  for I := 0 to TextElements.Count - 1 do
  begin
    XMLElement := TDOMElement(TextElements.Item[I]);
    if XMLElement.GetAttribute('name') = CodeAttribut then
    begin
      Result := XMLElement.TextContent;
      if (Length(Result) > 0) and (Result[1] = '"') and (Result[Length(Result)] = '"') then
        Result := Copy(Result, 2, Length(Result) - 2);
      Exit;
    end;
  end;
end;

// ========== LOAD ATTRIBUTES FOR RACE ==========
procedure TWinLivres.LoadAttributesForRace(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
var
  AttrChapter: TDOMNode;
  AttrElements: TDOMNodeList;
  I: Integer;
  AttrElement: TDOMElement;
  AttrCode, AttrValue: String;
  NodeAttributes, NodeAttr: TTreeNode;
  AttrData: TAttributData;
  PAttrData: PAttributData;
begin
  // Chercher la section SUBCHAPTER_ATTR
  AttrChapter := RaceElement.FindNode('SUBCHAPTER_ATTR');
  
  if AttrChapter = nil then Exit;
  
  // Créer la branche "Attributs"
  NodeAttributes := TreeViewLivre.Items.AddChild(RaceNode, GetAttributLabel('RULES-LAB_008'));
  SetNodeInfo(NodeAttributes, 0, RaceCode);  // 0 = chapitre
  
  // Récupérer tous les éléments Attribut
  AttrElements := TDOMElement(AttrChapter).GetElementsByTagName('Attribut');
  
  if AttrElements.Count > 0 then
  begin
    for I := 0 to AttrElements.Count - 1 do
    begin
      AttrElement := TDOMElement(AttrElements.Item[I]);
      AttrCode := AttrElement.GetAttribute('name');
      AttrValue := AttrElement.TextContent;
      
      if AttrCode = '' then Continue;
      
      // Créer un nœud pour cet attribut
      NodeAttr := TreeViewLivre.Items.AddChild(NodeAttributes, GetAttributLabel(AttrCode) + ': ' + AttrValue);
      SetNodeInfo(NodeAttr, 2);  // 2 = attribut
    end;
  end;
end;

// ========== LOAD SKILLS FOR RACE IN TREE ==========
procedure TWinLivres.LoadSkillsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
var
  SkillChapter: TDOMNode;
  SkillElements: TDOMNodeList;
  I: Integer;
  SkillCode, SkillDesc: String;
  NodeSkills, NodeSkill: TTreeNode;
  SkillNode: TDOMNode;
  Competence: StructureCompetence;
begin
  SkillChapter := RaceElement.FindNode('SUBCHAPTER_SKILL');
  
  if SkillChapter = nil then Exit;
  
  // Créer la branche "Compétences" (traduite)
  NodeSkills := TreeViewLivre.Items.AddChild(RaceNode, GetTexteLibelle('LAB_087'));
  SetNodeInfo(NodeSkills, 3, RaceCode);  // 3 = skills chapter
  
  // Récupérer les enfants directs de SUBCHAPTER_SKILL (pas récursif!)
  SkillElements := SkillChapter.ChildNodes;
  
  if SkillElements.Count > 0 then
  begin
    for I := 0 to SkillElements.Count - 1 do
    begin
      SkillNode := SkillElements[I];
      if SkillNode.NodeName = 'Skill' then
      begin
        SkillCode := Trim(SkillNode.TextContent);
        // Enlever les guillemets
        if (Length(SkillCode) > 0) and (SkillCode[1] = '"') then
          SkillCode := Copy(SkillCode, 2, Length(SkillCode) - 2);
        if (Length(SkillCode) > 0) and (SkillCode[Length(SkillCode)] = '"') then
          SkillCode := Copy(SkillCode, 1, Length(SkillCode) - 1);
        
        if SkillCode = '' then Continue;
        
        // Chercher dans ListCompetence
        Competence := ChercheCompetence(SkillCode);
        if Competence.CodeCompetence <> '' then
        begin
          SkillDesc := Competence.Libelle;
          
          // Créer un nœud pour cette compétence
          NodeSkill := TreeViewLivre.Items.AddChild(NodeSkills, SkillDesc);
          SetNodeInfo(NodeSkill, 4);  // 4 = skill item
          // Store code in ImageIndex for retrieval (not in Text which would overwrite the label)
          // NodeSkill.ImageIndex not used, safe to use for storage
        end;
      end;
    end;
  end;
end;

// ========== CHARGER TALENTS POUR RACE ==========
procedure TWinLivres.LoadTalentsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
var
  TalentChapter: TDOMNode;
  TalentElements: TDOMNodeList;
  I: Integer;
  TalentCode, TalentDesc: String;
  NodeTalents, NodeTalent, NodeChoice: TTreeNode;
  TalentNode: TDOMNode;
  Talent: StructureTalent;
  TalentParts: TStringList;
  J: Integer;
begin
  TalentChapter := RaceElement.FindNode('SUBCHAPTER_TALENT');
  
  if TalentChapter = nil then Exit;
  
  // Créer la branche "Talents" (traduite)
  NodeTalents := TreeViewLivre.Items.AddChild(RaceNode, GetTexteLibelle('LAB_007'));
  SetNodeInfo(NodeTalents, 5, RaceCode);  // 5 = talents chapter
  
  // Récupérer les enfants directs de SUBCHAPTER_TALENT
  TalentElements := TalentChapter.ChildNodes;
  
  if TalentElements.Count > 0 then
  begin
    TalentParts := TStringList.Create;
    try
      for I := 0 to TalentElements.Count - 1 do
      begin
        TalentNode := TalentElements[I];
        if TalentNode.NodeName = 'Talent' then
        begin
          TalentCode := Trim(TalentNode.TextContent);
          
          // Enlever les guillemets
          if (Length(TalentCode) > 0) and (TalentCode[1] = '"') then
            TalentCode := Copy(TalentCode, 2, Length(TalentCode) - 2);
          if (Length(TalentCode) > 0) and (TalentCode[Length(TalentCode)] = '"') then
            TalentCode := Copy(TalentCode, 1, Length(TalentCode) - 1);
          
          if TalentCode = '' then Continue;
          
          // CASE 1: Talent aléatoire (RULES-T*)
          if TalentCode = 'RULES-T*' then
          begin
            NodeTalent := TreeViewLivre.Items.AddChild(NodeTalents, GetTexteLibelle('LAB_085'));  // "Randomly"
            SetNodeInfo(NodeTalent, 6);  // 6 = random talent
          end
          
          // CASE 2: Choix multiple (contient "/")
          else if Pos('/', TalentCode) > 0 then
          begin
            // Créer nœud "{Au choix}"
            NodeChoice := TreeViewLivre.Items.AddChild(NodeTalents, GetTexteLibelle('LAB_127'));
            SetNodeInfo(NodeChoice, 7);  // 7 = choice node
            
            // Scinder par "/" et ajouter chaque talent
            TalentParts.Clear;
            TalentParts.StrictDelimiter := True;
            TalentParts.Delimiter := '/';
            TalentParts.DelimitedText := TalentCode;
            
            for J := 0 to TalentParts.Count - 1 do
            begin
              Talent := ChercheTalent(Trim(TalentParts[J]));
              if Talent.CodeTalent <> '' then
              begin
                NodeTalent := TreeViewLivre.Items.AddChild(NodeChoice, Talent.Libelle);
                SetNodeInfo(NodeTalent, 8);  // 8 = talent choice item
              end;
            end;
          end
          
          // CASE 3: Talent fixe (simple)
          else
          begin
            Talent := ChercheTalent(TalentCode);
            if Talent.CodeTalent <> '' then
            begin
              NodeTalent := TreeViewLivre.Items.AddChild(NodeTalents, Talent.Libelle);
              SetNodeInfo(NodeTalent, 8);  // 8 = talent item
            end;
          end;
        end;
      end;
    finally
      TalentParts.Free;
    end;
  end;
end;

// ========== CHARGER CARRIÈRES POUR RACE ==========
procedure TWinLivres.LoadCareersForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode; RaceCode: String);
var
  CareerChapter: TDOMNode;
  CareerElements: TDOMNodeList;
  I: Integer;
  CareerCode, CareerDesc, DisplayText: String;
  NodeCareers, NodeCareer: TTreeNode;
  CareerNode: TDOMNode;
  Metier: StructureMetier;
  Livre: StructureLivre;
begin
  CareerChapter := RaceElement.FindNode('SUBCHAPTER_CAREER');
  
  if CareerChapter = nil then Exit;
  
  // Créer la branche "Career" (traduite)
  NodeCareers := TreeViewLivre.Items.AddChild(RaceNode, GetTexteLibelle('LAB_006'));
  SetNodeInfo(NodeCareers, 9, RaceCode);  // 9 = careers chapter
  
  // Récupérer les enfants directs de SUBCHAPTER_CAREER
  CareerElements := CareerChapter.ChildNodes;
  
  if CareerElements.Count > 0 then
  begin
    for I := 0 to CareerElements.Count - 1 do
    begin
      CareerNode := CareerElements[I];
      if CareerNode.NodeName = 'Career' then
      begin
        CareerCode := TDOMElement(CareerNode).GetAttribute('name');
        
        if CareerCode = '' then Continue;
        
        // Chercher la carrière dans ListMetier (charge tous les livres)
        Metier := ChercheMetier(CareerCode);
        
        if Metier.CodeMetier <> '' then
        begin
          CareerDesc := Metier.Libelle;
          
          // Chercher le nom du livre via le code du livre
          Livre := ChercheLivreLibelle(Metier.Livre);
          
          // Afficher: "Nom Métier (Nom Livre)"
          if Livre.CodeLivre <> '' then
            DisplayText := CareerDesc + ' (' + GetTexteLibelle(Livre.Libelle) + ')'
          else
            DisplayText := CareerDesc + ' (' + Metier.Livre + ')';  // Fallback avec code livre
        end
        else
        begin
          CareerDesc := CareerCode;  // Fallback si métier pas trouvé
          DisplayText := CareerDesc;
        end;
        
        // Créer un nœud pour cette carrière
        NodeCareer := TreeViewLivre.Items.AddChild(NodeCareers, DisplayText);
        SetNodeInfo(NodeCareer, 13);  // 13 = career item
      end;
    end;
  end;
end;

// ========== AFFICHER DONNÉE ATTRIBUT ==========
procedure TWinLivres.AfficherDonneeAttribut(ACode: String);
var
  AttrType: String;
  Dices, BaseValue, SimpleValue, Formula: String;
  FormulaComponents: TFormulaComponentArray;
  I: Integer;
begin
  NettoyerForm();
  
  // Parser la valeur de l'attribut
  ParseAttributValue(ACode, AttrType, Dices, BaseValue, SimpleValue, Formula);
  
  // Masquer tous les contrôles de race
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  
  // Afficher selon le type d'attribut
  case AttrType of
    'SIMPLE': begin
      // Type 3: Valeur fixe (ex: "2", "1", "3", "4")
      LabelFormAttrName.Visible := False;
      EditFormAttrName.Visible := False;
      
      LabelFormAttrDices.Visible := False;
      EditFormAttrDices.Visible := False;
      LabelFormAttrBaseValue.Visible := True;
      EditFormAttrBaseValue.Visible := True;
      EditFormAttrBaseValue.Text := SimpleValue;
      LabelFormAttrBaseValue.Caption := GetTexteLibelle('LAB_025'); // 'Value'
      LabelFormAttrFormula.Visible := False;
      EditFormAttrFormula.Visible := False;
      
      for I := 1 to 3 do
        HideComponentControls(I);
    end;
    
    'DICES': begin
      // Type 1: Format avec dés (ex: "2d10+20")
      LabelFormAttrName.Visible := False;
      EditFormAttrName.Visible := False;
      
      LabelFormAttrDices.Visible := True;
      EditFormAttrDices.Visible := True;
      EditFormAttrDices.Text := Dices;
      LabelFormAttrDices.Caption := GetTexteLibelle('LAB_161'); // 'Dices'
      
      LabelFormAttrBaseValue.Visible := True;
      EditFormAttrBaseValue.Visible := True;
      EditFormAttrBaseValue.Text := BaseValue;
      LabelFormAttrBaseValue.Caption := GetTexteLibelle('LAB_025'); // 'Value'
      
      LabelFormAttrFormula.Visible := False;
      EditFormAttrFormula.Visible := False;
      
      for I := 1 to 3 do
        HideComponentControls(I);
    end;
    
    'FORMULA': begin
      // Type 2: Format calculé (ex: "1xBATTR_S+2xBATTR_T+1xBATTR_WP")
      // Afficher les composants avec label = attribut, champ = coefficient
      LabelFormAttrName.Visible := False;
      EditFormAttrName.Visible := False;
      
      // Masquer les champs simples/dices
      LabelFormAttrDices.Visible := False;
      EditFormAttrDices.Visible := False;
      LabelFormAttrBaseValue.Visible := False;
      EditFormAttrBaseValue.Visible := False;
      LabelFormAttrFormula.Visible := False;
      EditFormAttrFormula.Visible := False;
      
      // Parser et afficher les composants
      FormulaComponents := ParseFormulaComponents(Formula);
      for I := 0 to Length(FormulaComponents) - 1 do
      begin
        if I < 3 then
          ShowComponentControl(I + 1, FormulaComponents[I].AttrLabel, IntToStr(FormulaComponents[I].Coefficient));
      end;
      
      // Masquer les composants inutilisés
      for I := Length(FormulaComponents) + 1 to 3 do
        HideComponentControls(I);
    end;
  end;
  
  GroupBoxForm.Visible := True;
end;

procedure TWinLivres.ShowComponentControl(Index: Integer; AttrLabel: String; Coefficient: String);
begin
  case Index of
    1: begin
      LabelFormComponent1.Visible := True;
      EditFormComponent1Coeff.Visible := True;
      LabelFormComponent1.Caption := AttrLabel + ':';  // Label = Attribute name
      EditFormComponent1Coeff.Text := Coefficient;     // Field = just the number
      EditFormComponent1Attr.Visible := False;         // Hide the attribute field
    end;
    2: begin
      LabelFormComponent2.Visible := True;
      EditFormComponent2Coeff.Visible := True;
      LabelFormComponent2.Caption := AttrLabel + ':';
      EditFormComponent2Coeff.Text := Coefficient;
      EditFormComponent2Attr.Visible := False;
    end;
    3: begin
      LabelFormComponent3.Visible := True;
      EditFormComponent3Coeff.Visible := True;
      LabelFormComponent3.Caption := AttrLabel + ':';
      EditFormComponent3Coeff.Text := Coefficient;
      EditFormComponent3Attr.Visible := False;
    end;
  end;
end;

procedure TWinLivres.HideComponentControls(Index: Integer);
begin
  case Index of
    1: begin
      LabelFormComponent1.Visible := False;
      EditFormComponent1Attr.Visible := False;
      EditFormComponent1Coeff.Visible := False;
    end;
    2: begin
      LabelFormComponent2.Visible := False;
      EditFormComponent2Attr.Visible := False;
      EditFormComponent2Coeff.Visible := False;
    end;
    3: begin
      LabelFormComponent3.Visible := False;
      EditFormComponent3Attr.Visible := False;
      EditFormComponent3Coeff.Visible := False;
    end;
  end;
end;

// ========== BRANCHE MÉTIER (niveau 1) ==========

// Sous-branche "Races possibles" : les races dont le SUBCHAPTER_CAREER
// référence ce métier. On lit la map pré-calculée pour éviter de rebalayer
// toutes les races pour chaque métier.
procedure TWinLivres.LoadMetierRacesPossibles(CareerCode: String; MetierNode: TTreeNode);
var
  NodeBranche, NodeFeuille: TTreeNode;
  ListeCodes: TStringList;
  I, Idx: Integer;
  CodeRace, LibelleRace: String;
  PRace: PRaceData;
begin
  if MetierRacesMap = nil then Exit;
  
  // Rien à afficher si aucune race ne propose ce métier
  if MetierRacesMap.Values[CareerCode] = '' then Exit;
  
  NodeBranche := TreeViewLivre.Items.AddChild(MetierNode, ConstArbreRacePossible);
  SetNodeInfo(NodeBranche, 15, CareerCode);  // 15 = branche races possibles
  
  ListeCodes := TStringList.Create;
  try
    ListeCodes.Delimiter     := '|';
    ListeCodes.StrictDelimiter := True;
    ListeCodes.DelimitedText := MetierRacesMap.Values[CareerCode];
    
    for I := 0 to ListeCodes.Count - 1 do
    begin
      CodeRace := ListeCodes[I];
      if CodeRace = '' then Continue;
      
      // Libellé de la race depuis les données déjà chargées
      LibelleRace := CodeRace;  // fallback
      if RacesDataList <> nil then
      begin
        Idx := RacesDataList.IndexOf(CodeRace);
        if Idx >= 0 then
        begin
          PRace := RacesDataList.Data[Idx];
          if PRace <> nil then
            LibelleRace := PRace^.Libelle;
        end;
      end;
      
      NodeFeuille := TreeViewLivre.Items.AddChild(NodeBranche, LibelleRace);
      SetNodeInfo(NodeFeuille, 16, CodeRace);  // 16 = race possible
    end;
  finally
    ListeCodes.Free;
  end;
end;

// Sous-branche "Attribut" d'un niveau de métier
procedure TWinLivres.LoadMetierNiveauAttributs(CareerElement: TDOMElement; Niveau: Integer; CodeNiveau: String; NodeBase: TTreeNode);
var
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I: Integer;
  NodeBranche, NodeFeuille: TTreeNode;
  CodeAttr: String;
begin
  Chapitre := CareerElement.FindNode('SUBCHAPTER_ATTR');
  if Chapitre = nil then Exit;
  
  NodeBranche := TreeViewLivre.Items.AddChild(NodeBase, ConstArbreAttribut);
  SetNodeInfo(NodeBranche, 18, CodeNiveau);  // 18 = branche attributs du niveau
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Attribut');
  
  for I := 0 to Elements.Count - 1 do
  begin
    // On ne garde que les attributs dont la valeur correspond au niveau
    if ValeurXML(Elements.Item[I]) <> IntToStr(Niveau) then Continue;
    
    CodeAttr := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if CodeAttr = '' then Continue;
    
    NodeFeuille := TreeViewLivre.Items.AddChild(NodeBranche, GetAttributLabel(CodeAttr));
    SetNodeInfo(NodeFeuille, 19, CodeAttr);  // 19 = attribut du niveau
  end;
end;

// Sous-branche "Compétence" d'un niveau de métier.
// SkillPrincipal = le <Skill> racine du <Career>, marqué d'une étoile.
procedure TWinLivres.LoadMetierNiveauCompetences(CareerElement: TDOMElement; Niveau: Integer; SkillPrincipal: String; CodeNiveau: String; NodeBase: TTreeNode);
var
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I: Integer;
  NodeBranche, NodeFeuille: TTreeNode;
  CodeComp, LibComp: String;
  Competence: StructureCompetence;
begin
  Chapitre := CareerElement.FindNode('SUBCHAPTER_SKILL');
  if Chapitre = nil then Exit;
  
  NodeBranche := TreeViewLivre.Items.AddChild(NodeBase, ConstArbreCompetence);
  SetNodeInfo(NodeBranche, 20, CodeNiveau);  // 20 = branche compétences du niveau
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Skill');
  
  for I := 0 to Elements.Count - 1 do
  begin
    if ValeurXML(Elements.Item[I]) <> IntToStr(Niveau) then Continue;
    
    CodeComp := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if CodeComp = '' then Continue;
    
    Competence := ChercheCompetence(CodeComp);
    if Competence.CodeCompetence <> '' then
      LibComp := Competence.Libelle
    else
      LibComp := CodeComp;  // fallback si la compétence est inconnue
    
    // Étoile sur la compétence principale du métier
    if CodeComp = SkillPrincipal then
      LibComp := LibComp + ' *';
    
    NodeFeuille := TreeViewLivre.Items.AddChild(NodeBranche, LibComp);
    SetNodeInfo(NodeFeuille, 21, CodeComp);  // 21 = compétence du niveau
  end;
end;

// Sous-branche "Talent" d'un niveau de métier
procedure TWinLivres.LoadMetierNiveauTalents(CareerElement: TDOMElement; Niveau: Integer; CodeNiveau: String; NodeBase: TTreeNode);
var
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I: Integer;
  NodeBranche, NodeFeuille: TTreeNode;
  CodeTal, LibTal: String;
  Talent: StructureTalent;
begin
  Chapitre := CareerElement.FindNode('SUBCHAPTER_TALENT');
  if Chapitre = nil then Exit;
  
  NodeBranche := TreeViewLivre.Items.AddChild(NodeBase, ConstArbreTalent);
  SetNodeInfo(NodeBranche, 22, CodeNiveau);  // 22 = branche talents du niveau
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Talent');
  
  for I := 0 to Elements.Count - 1 do
  begin
    if ValeurXML(Elements.Item[I]) <> IntToStr(Niveau) then Continue;
    
    CodeTal := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if CodeTal = '' then Continue;
    
    Talent := ChercheTalent(CodeTal);
    if Talent.CodeTalent <> '' then
      LibTal := Talent.Libelle
    else
      LibTal := CodeTal;  // fallback
    
    NodeFeuille := TreeViewLivre.Items.AddChild(NodeBranche, LibTal);
    SetNodeInfo(NodeFeuille, 23, CodeTal);  // 23 = talent du niveau
  end;
end;

// Résout un nom d'équipement du XML en libellé affichable.
// TypeEquip renvoie 'W' pour une arme, 'P' pour une armure, 'D' pour du
// texte libre ("writing set"). Partagé par l'arbre et la grille.
function TWinLivres.LibelleEquipement(NomItem: String; out TypeEquip: Char): String;
var
  CodeItem, Qualite: String;
  Arme: StructureArme;
  Armure: StructureArmure;
begin
  Result    := '';
  TypeEquip := 'D';
  
  CodeItem := Trim(NomItem);
  if CodeItem = '' then Exit;
  
  // Suffixe de qualité "(Q)"
  if Pos(EquipementQualite, CodeItem) > 0 then
  begin
    CodeItem := Copy(CodeItem, 1, Length(CodeItem) - Length(EquipementQualite));
    Qualite  := GetTexteLibelle('LAB_038');  // ' de qualité'
  end
  else
    Qualite := '';
  
  if (Pos(EquipementCC, CodeItem) > 0) or
     (Pos(EquipementCT, CodeItem) > 0) or
     (Pos(EquipementMU, CodeItem) > 0) then
  begin
    // Arme (corps à corps, projectile ou munition)
    TypeEquip := 'W';
    Arme := ChercheArme(CodeItem);
    if Arme.CodeArme <> '' then
      Result := Arme.Libelle + Qualite
    else
      Result := CodeItem + Qualite;  // fallback
  end
  else if Pos(EquipementAR, CodeItem) > 0 then
  begin
    // Armure
    TypeEquip := 'P';
    Armure := ChercheArmure(CodeItem);
    if Armure.CodeArmure <> '' then
      Result := Armure.Libelle + Qualite
    else
      Result := CodeItem + Qualite;  // fallback
  end
  else
    // Texte libre : "writing set", "impressive hat", "patron"...
    Result := NomItem;
end;

// Ajoute une feuille d'équipement sous NodeBase.
procedure TWinLivres.AjouterFeuilleEquipement(NomItem: String; NodeBase: TTreeNode);
var
  NodeFeuille: TTreeNode;
  Libelle: String;
  TypeEquip: Char;
begin
  if Trim(NomItem) = '' then Exit;
  
  Libelle := LibelleEquipement(NomItem, TypeEquip);
  
  case TypeEquip of
    'W': Libelle := EquipArme + Libelle;
    'P': Libelle := EquipArmure + Libelle;
  end;
  
  NodeFeuille := TreeViewLivre.Items.AddChild(NodeBase, Libelle);
  SetNodeInfo(NodeFeuille, 25, Trim(NomItem));
end;

// Sous-branche "Equipement" d'un niveau de métier.
// Le XML mélange du texte libre ("writing set") et des codes
// ("RULES-ARMO_04"), le type se déduit du préfixe du code.
procedure TWinLivres.LoadMetierNiveauEquipement(CareerElement: TDOMElement; Niveau: Integer; CodeNiveau: String; NodeBase: TTreeNode);
var
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I, J: Integer;
  NodeBranche, NodeChoix: TTreeNode;
  NomItem: String;
  Choix: TStringList;
begin
  Chapitre := CareerElement.FindNode('SUBCHAPTER_ITEM');
  if Chapitre = nil then Exit;
  
  NodeBranche := TreeViewLivre.Items.AddChild(NodeBase, ConstArbreEquipement);
  SetNodeInfo(NodeBranche, 24, CodeNiveau);  // 24 = branche équipement du niveau
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Item');
  
  for I := 0 to Elements.Count - 1 do
  begin
    if ValeurXML(Elements.Item[I]) <> IntToStr(Niveau) then Continue;
    
    NomItem := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if NomItem = '' then Continue;
    
    if Pos(SeparateurMulti, NomItem) > 0 then
    begin
      // Choix multiple : "A/B" -> sous-branche "au choix"
      NodeChoix := TreeViewLivre.Items.AddChild(NodeBranche, ConstArbreAuChoix);
      SetNodeInfo(NodeChoix, 25);  // 25 : nœud passif, pas la branche Equipement
      
      Choix := TStringList.Create;
      try
        Choix.Delimiter       := SeparateurMulti;
        Choix.StrictDelimiter := True;
        Choix.DelimitedText   := NomItem;
        
        for J := 0 to Choix.Count - 1 do
          AjouterFeuilleEquipement(Choix[J], NodeChoix);
      finally
        Choix.Free;
      end;
    end
    else
      AjouterFeuilleEquipement(NomItem, NodeBranche);
  end;
end;

// Sous-branches "niveau" d'un métier : 1.Pamphleteer - Bronze 1, etc.
procedure TWinLivres.LoadMetierNiveaux(CareerElement: TDOMElement; CareerCode: String; MetierNode: TTreeNode);
var
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I, Niveau: Integer;
  LevelElement: TDOMElement;
  NodeNiveau: TTreeNode;
  LibNiveau, Salaire, TexteNiveau, SkillPrincipal: String;
begin
  Chapitre := CareerElement.FindNode('SUBCHAPTER_LEVEL');
  if Chapitre = nil then Exit;
  
  // Compétence principale du métier : le <Skill> direct du <Career>
  SkillPrincipal := ValeurXML(CareerElement.FindNode('Skill'));
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Level');
  
  for I := 0 to Elements.Count - 1 do
  begin
    LevelElement := TDOMElement(Elements.Item[I]);
    
    Niveau := StrToIntDef(LevelElement.GetAttribute('id'), 0);
    if Niveau = 0 then Continue;
    
    LibNiveau := ValeurXML(LevelElement.FindNode('Description'));
    Salaire   := ValeurXML(LevelElement.FindNode('Salary'));
    
    // "1.Pamphleteer - Bronze 1"
    TexteNiveau := IntToStr(Niveau) + '.' + LibNiveau;
    if Salaire <> '' then
      TexteNiveau := TexteNiveau + ' - ' + GetTexteLibelle(Salaire, '', ' ');
    
    NodeNiveau := TreeViewLivre.Items.AddChild(MetierNode, TexteNiveau);
    // Code = "CODEMETIER|niveau" pour retrouver l'élément XML plus tard
    SetNodeInfo(NodeNiveau, 17, CareerCode + '|' + IntToStr(Niveau));  // 17 = niveau
    
    LoadMetierNiveauAttributs(CareerElement, Niveau, CareerCode + '|' + IntToStr(Niveau), NodeNiveau);
    LoadMetierNiveauCompetences(CareerElement, Niveau, SkillPrincipal, CareerCode + '|' + IntToStr(Niveau), NodeNiveau);
    LoadMetierNiveauTalents(CareerElement, Niveau, CareerCode + '|' + IntToStr(Niveau), NodeNiveau);
    LoadMetierNiveauEquipement(CareerElement, Niveau, CareerCode + '|' + IntToStr(Niveau), NodeNiveau);
  end;
end;

// Construit la table métier -> races qui le proposent, en un seul balayage
// des <Specie>. Évite de rebalayer toutes les races pour chaque métier.
procedure TWinLivres.ConstruireMetierRacesMap();
var
  SpecieElements, CareerElements: TDOMNodeList;
  I, J: Integer;
  SpecieElement: TDOMElement;
  Chapitre: TDOMNode;
  CodeRace, CodeMetier, Actuel: String;
begin
  if MetierRacesMap = nil then
    MetierRacesMap := TStringList.Create;
  
  MetierRacesMap.Clear;
  
  if XMLDoc = nil then Exit;
  
  SpecieElements := XMLDoc.GetElementsByTagName('Specie');
  
  for I := 0 to SpecieElements.Count - 1 do
  begin
    SpecieElement := TDOMElement(SpecieElements.Item[I]);
    CodeRace := SpecieElement.GetAttribute('id');
    if CodeRace = '' then Continue;
    
    Chapitre := SpecieElement.FindNode('SUBCHAPTER_CAREER');
    if Chapitre = nil then Continue;
    
    CareerElements := TDOMElement(Chapitre).GetElementsByTagName('Career');
    
    for J := 0 to CareerElements.Count - 1 do
    begin
      CodeMetier := TDOMElement(CareerElements.Item[J]).GetAttribute('name');
      if CodeMetier = '' then Continue;
      
      Actuel := MetierRacesMap.Values[CodeMetier];
      if Actuel = '' then
        MetierRacesMap.Values[CodeMetier] := CodeRace
      else
        MetierRacesMap.Values[CodeMetier] := Actuel + '|' + CodeRace;
    end;
  end;
end;

// Construit une branche plate depuis un chapitre du XML.
// Sert pour DATA_SKILL, DATA_SKILL_SPECIALIZATION, DATA_TALENT et
// DATA_TALENT_SPECIALIZATION : même structure, seul le nombre de champs
// par entrée diffère, ce dont s'occupe l'affichage.
// Regrouper = True insère un niveau intermédiaire par élément mère, déduit
// du code de la spécialisation ("RULES-COMPART_CALLI" -> "RULES-COMPART_*").
procedure TWinLivres.ChargerBrancheSimple(ChapitreTag, ElementTag, TitreBranche: String; TypeNoeud: Integer; NodeParent: TTreeNode; Regrouper: Boolean = False);
var
  Chapitres, Elements: TDOMNodeList;
  I, UnderPos, Idx: Integer;
  XMLElement, MereElement: TDOMElement;
  NodeBranche, NodeFeuille, NodeMere, NodeCible: TTreeNode;
  Code, Libelle, CodeMere, LibelleMere: String;
  Meres: TStringList;
begin
  if XMLDoc = nil then Exit;
  
  Chapitres := XMLDoc.GetElementsByTagName(ChapitreTag);
  if Chapitres.Count = 0 then Exit;
  
  NodeBranche := TreeViewLivre.Items.AddChild(NodeParent, TitreBranche);
  SetNodeInfo(NodeBranche, 0);  // 0 = chapitre
  
  // On reste dans le chapitre : les éléments de même nom nichés dans les
  // SUBCHAPTER_* des races et des métiers sont ailleurs dans le document.
  Elements := TDOMElement(Chapitres.Item[0]).GetElementsByTagName(ElementTag);
  
  // Table code mère -> noeud, pour ne créer chaque mère qu'une fois
  // sans supposer que le XML soit trié.
  Meres := TStringList.Create;
  try
    Meres.Sorted := True;
    
    for I := 0 to Elements.Count - 1 do
    begin
      XMLElement := TDOMElement(Elements.Item[I]);
      
      Code := XMLElement.GetAttribute('id');
      if Code = '' then Continue;
      
      Libelle := ValeurXML(XMLElement.FindNode('Description'));
      if Libelle = '' then
        Libelle := Code;  // fallback
      
      NodeCible := NodeBranche;
      
      if Regrouper then
      begin
        UnderPos := Pos(ValeurSousCompetence, Code);
        if UnderPos > 0 then
        begin
          CodeMere := Copy(Code, 1, UnderPos - 1) + ValeurSousCompetence + '*';
          
          Idx := Meres.IndexOf(CodeMere);
          if Idx >= 0 then
            NodeCible := TTreeNode(Meres.Objects[Idx])
          else
          begin
            // Libellé de la mère depuis son propre chapitre
            LibelleMere := '';
            MereElement := TrouverElementParId(ElementTag, CodeMere);
            if MereElement <> nil then
              LibelleMere := ValeurXML(MereElement.FindNode('Description'));
            if LibelleMere = '' then
              LibelleMere := CodeMere;  // fallback
            
            NodeMere := TreeViewLivre.Items.AddChild(NodeBranche, LibelleMere);
            SetNodeInfo(NodeMere, 0, CodeMere);  // 0 = regroupement passif
            
            Meres.AddObject(CodeMere, NodeMere);
            NodeCible := NodeMere;
          end;
        end;
      end;
      
      NodeFeuille := TreeViewLivre.Items.AddChild(NodeCible, Libelle);
      SetNodeInfo(NodeFeuille, TypeNoeud, Code);
    end;
  finally
    Meres.Free;
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
  NodeEquip: TTreeNode;
  NodeTirage: TTreeNode;
  DescNode: TDOMNode;
  ExplNode: TDOMNode;
  FileName: String;
  NodeInfos: TTreeNode;
begin
  try
    // Charger le fichier XML
    ReadXMLFile(XMLDoc, AFilePath);
    
    if XMLDoc = nil then
      begin
        // ShowMessage('Erreur: Impossible de charger le XML');
        Exit;
      end;
    
    // Effacer l'arbre (libérer les TNodeInfo AVANT le Clear)
    LibererNodesData(TreeViewLivre);
    TreeViewLivre.Items.Clear;
    if RacesDataList <> nil then
      RacesDataList.Clear;
    
    FileName := ExtractFileName(AFilePath);  // "BOOK RULESBOOK.Xml"
    FileCode := Copy(FileName, 1, Length(FileName) - 4);  // "BOOK RULESBOOK"

    // Récupérer le label traduit
    NodeRoot := TreeViewLivre.Items.Add(nil, GetBookLabel(FileCode));

    // Afficher le nom complet dans LabelLivre
    LabelLivre.Caption := GetTexteLibelle('LAB_128') + ': ' + FileName;

    // Afficher dans LabelFormTitle
    LabelFormTitle.Caption := GetTexteLibelle('LAB_128') + ': ' + FileName;
    SetNodeInfo(NodeRoot, 0);  // 0 = chapitre

    // ========== INFORMATIONS DU LIVRE ==========
    NodeInfos := TreeViewLivre.Items.AddChild(NodeRoot, GetTexteLibelle('LAB_128'));
    SetNodeInfo(NodeInfos, 37);

    // ========== RACES ==========
    NodeRaces := TreeViewLivre.Items.AddChild(NodeRoot, GetTexteLibelle('LAB_042'));
    SetNodeInfo(NodeRaces, 0);
    
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
            NodeRace := TreeViewLivre.Items.AddChild(NodeRaces, RaceData.Libelle);
            SetNodeInfo(NodeRace, 1, Code);  // 1 = donnée
            
            // ========== CHARGER LES ATTRIBUTS DE CETTE RACE ==========
            LoadAttributesForRace(XMLElement, NodeRace, Code);
            
            // ========== CHARGER LES COMPÉTENCES DE CETTE RACE DANS L'ARBRE ==========
            LoadSkillsForRaceTree(XMLElement, NodeRace, Code);
            
            // ========== CHARGER LES TALENTS DE CETTE RACE DANS L'ARBRE ==========
            LoadTalentsForRaceTree(XMLElement, NodeRace, Code);
            
            // ========== CHARGER LES CARRIÈRES DE CETTE RACE DANS L'ARBRE ==========
            LoadCareersForRaceTree(XMLElement, NodeRace, Code);
          end;
      end;
    
    // ========== CARRIÈRES ==========
    // Table métier -> races possibles, construite avant la boucle
    ConstruireMetierRacesMap();
    
    NodeCareers := TreeViewLivre.Items.AddChild(NodeRoot, GetTexteLibelle('LAB_006'));
    SetNodeInfo(NodeCareers, 0);
    
    CareerElements := XMLDoc.GetElementsByTagName('Career');
    
    if CareerElements.Count > 0 then
      begin
        for I := 0 to CareerElements.Count - 1 do
          begin
            XMLElement := TDOMElement(CareerElements.Item[I]);
            
            // GetElementsByTagName ramène AUSSI les <Career name="..."> des
            // SUBCHAPTER_CAREER des races. On ne garde que les métiers racine.
            if (XMLElement.ParentNode <> nil) and
               (XMLElement.ParentNode.NodeName = 'SUBCHAPTER_CAREER') then
              Continue;
            
            Code := XMLElement.GetAttribute('id');
            
            // Ignorer les éléments sans Code valide
            if Code = '' then
              Continue;
            
            // Libellé du métier depuis le XML du livre courant
            Description := ValeurXML(XMLElement.FindNode('Description'));
            if Description = '' then
              Description := Code;  // fallback
            
            // Ajouter dans l'arbre
            NodeCareer := TreeViewLivre.Items.AddChild(NodeCareers, Description);
            SetNodeInfo(NodeCareer, 14, Code);  // 14 = métier racine
            
            // Sous-branches
            LoadMetierRacesPossibles(Code, NodeCareer);
            LoadMetierNiveaux(XMLElement, Code, NodeCareer);
          end;
      end;
    
    // ========== COMPÉTENCES ==========
    // Deux chapitres distincts dans le XML : DATA_SKILL pour les compétences,
    // DATA_SKILL_SPECIALIZATION pour les spécialisations, qui n'ont qu'un libellé.
    ChargerBrancheSimple('DATA_SKILL', 'Skill', GetTexteLibelle('LAB_009'), 26, NodeRoot);
    ChargerBrancheSimple('DATA_SKILL_SPECIALIZATION', 'Skill', GetTexteLibelle('LAB_146'), 27, NodeRoot, True);
    
    // ========== TALENTS ==========
    ChargerBrancheSimple('DATA_TALENT', 'Talent', GetTexteLibelle('LAB_007'), 28, NodeRoot);
    ChargerBrancheSimple('DATA_TALENT_SPECIALIZATION', 'Talent', GetTexteLibelle('LAB_147'), 29, NodeRoot, True);
    
    // ========== ÉQUIPEMENT ==========
    // Une branche porteuse, puis un chapitre XML par type.
    // Le "divers" n'a pas de chapitre : c'est du texte libre dans les métiers.
    NodeEquip := TreeViewLivre.Items.AddChild(NodeRoot, GetTexteLibelle('LAB_013'));
    SetNodeInfo(NodeEquip, 0);
    
    ChargerBrancheSimple('DATA_WEAPON', 'Weapon', GetTexteLibelle('LAB_063'), 30, NodeEquip);
    ChargerBrancheSimple('DATA_ARMOR',  'Armor',  GetTexteLibelle('LAB_065'), 31, NodeEquip);
    ChargerBrancheSimple('DATA_ARMOR_SIMP', 'ArmorSimp', GetTexteLibelle('LAB_149'), 33, NodeEquip);
    ChargerBrancheSimple('DATA_WEAPON_BONUS', 'BonusMalus',
                         GetTexteLibelle('LAB_125') + ' ' + GetTexteLibelle('LAB_063'), 32, NodeEquip);
    ChargerBrancheSimple('DATA_ARMOR_BONUS', 'BonusMalus',
                         GetTexteLibelle('LAB_125') + ' ' + GetTexteLibelle('LAB_065'), 34, NodeEquip);
    
    // ========== SORTS ==========
    ChargerBrancheSimple('DATA_SPELL', 'Sort', GetTexteLibelle('LAB_083'), 35, NodeRoot);
    
    // ========== TIRAGE ALÉATOIRE DE RACE ==========
    // Un seul noeud, sans enfant : il ouvre directement la table.
    if XMLDoc.GetElementsByTagName('DATA_RANDOM_SPECIE').Count > 0 then
    begin
      NodeTirage := TreeViewLivre.Items.AddChild(NodeRoot,
                      GetTexteLibelle('LAB_042') + ' ' + GetTexteLibelle('LAB_085'));
      SetNodeInfo(NodeTirage, 36);
    end;
    
    // Expand les branches principales
    NodeRoot.Expand(False);
    
    LabelFormTitle.Caption := GetTexteLibelle('LAB_128') + ': ' + FileName;
    // Message de succès supprimé pour l'instant
    // ShowMessage('✅ ' + IntToStr(SpecieElements.Count) + ' races + ' + IntToStr(CareerElements.Count) + ' carrières chargées!');
    
  except
    on E: Exception do
      // ShowMessage('Erreur: ' + E.Message);
  end;
end;

// ✨ ÉVÉNEMENTS TREEVIEW

procedure TWinLivres.TreeViewLivreChange(Sender: TObject; Node: TTreeNode);
var
  RaceCodeFound: String;
begin
  if Node = nil then Exit;
  
  NodeSelectionnee := Node;
  
  // Vérifier le type de nœud basé sur Node.Data
  case GetNodeType(Node) of
    0: begin
         // C'est un chapitre (Races, Attributes, Careers, etc.)
         TypeNodeSelectionnee := 'CHAPITRE';
         MasquerAfficherElements('');  // Masquer tous les grids
         MasquerForm();
       end;
    1: begin
         // C'est une race
         TypeNodeSelectionnee := 'DONNEE';
         CurrentRaceCode := GetNodeCode(Node);
         LabelFormTitle.Caption := GetTexteLibelle('LAB_042') + ': ' + Node.Text;
         MasquerAfficherElements('');  // Masquer tous les grids
         AfficherDonneeRace(CurrentRaceCode);
       end;
    2: begin
         // C'est un attribut
         TypeNodeSelectionnee := 'ATTRIBUT';
         // Extract raw value from "Label: Value" format
         CurrentAttributeValue := Copy(Node.Text, Pos(': ', Node.Text) + 2, Length(Node.Text));
         // Display attribute name in title
         LabelFormTitle.Caption := Copy(Node.Text, 1, Pos(': ', Node.Text) - 1);
         MasquerAfficherElements('');  // Masquer tous les grids
         AfficherDonneeAttribut(CurrentAttributeValue);
       end;
    3: begin
         // C'est une branche "Compétences de race"
         TypeNodeSelectionnee := 'CHAPITRE';
         // Afficher toutes les compétences de la race parente
         RaceCodeFound := GetNodeCode(Node);
         
         if RaceCodeFound <> '' then
         begin
           if Node.Parent <> nil then
             LabelFormTitle.Caption := GetTexteLibelle('LAB_087') + ': ' + Node.Parent.Text;
           
           AfficherSkillsForRace(RaceCodeFound);  // Appelle MasquerAfficherElements('COMPETENCE')
         end
         else
         begin
           MasquerAfficherElements('');  // Masquer tous les grids
           MasquerForm();
         end;
       end;
    4: begin
         // C'est un item "Compétence"
         TypeNodeSelectionnee := 'COMPETENCE';
         LabelFormTitle.Caption := Node.Text;
         // Pour l'instant, juste afficher le nom
         MasquerAfficherElements('');  // Masquer tous les grids
         MasquerForm();
       end;
    5: begin
         // C'est la branche "Talents"
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := GetTexteLibelle('LAB_007');
         AfficherTalentsForRace();  // Appelle MasquerAfficherElements('TALENT')
       end;
    9: begin
         // C'est la branche "Carrières de race"
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := GetTexteLibelle('LAB_006');
         
         RaceCodeFound := GetNodeCode(Node);
         
         if RaceCodeFound <> '' then
           AfficherCareersForRace(RaceCodeFound)  // Appelle MasquerAfficherElements('CARRIERE')
         else
         begin
           MasquerAfficherElements('');  // Masquer tous les grids
           MasquerForm();
         end;
       end;
    13: begin
         // C'est un item "Carrière"
         TypeNodeSelectionnee := 'CARRIERE';
         LabelFormTitle.Caption := Node.Text;
         // Pour l'instant, juste afficher le nom
         MasquerAfficherElements('');  // Masquer tous les grids
         MasquerForm();
       end;
    14: begin
         // C'est un métier de niveau 1
         TypeNodeSelectionnee := 'METIER';
         AfficherDonneeMetier(GetNodeCode(Node));
       end;
    15: begin
         // Branche "Races possibles" d'un métier
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := ConstArbreRacePossible;
         if Node.Parent <> nil then
           LabelFormTitle.Caption := ConstArbreRacePossible + ': ' + Node.Parent.Text;
         
         AfficherRacesForMetier(GetNodeCode(Node));
       end;
    18: begin
         // Branche "Attribut" d'un niveau de métier
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := ConstArbreAttribut;
         if Node.Parent <> nil then
           LabelFormTitle.Caption := ConstArbreAttribut + ': ' + Node.Parent.Text;
         
         AfficherAttributsForNiveau(GetNodeCode(Node));
       end;
    20: begin
         // Branche "Compétence" d'un niveau de métier
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := ConstArbreCompetence;
         if Node.Parent <> nil then
           LabelFormTitle.Caption := ConstArbreCompetence + ': ' + Node.Parent.Text;
         
         AfficherCompetencesForNiveau(GetNodeCode(Node));
       end;
    22: begin
         // Branche "Talent" d'un niveau de métier
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := ConstArbreTalent;
         if Node.Parent <> nil then
           LabelFormTitle.Caption := ConstArbreTalent + ': ' + Node.Parent.Text;
         
         AfficherTalentsForNiveau(GetNodeCode(Node));
       end;
    24: begin
         // Branche "Equipement" d'un niveau de métier
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := ConstArbreEquipement;
         if Node.Parent <> nil then
           LabelFormTitle.Caption := ConstArbreEquipement + ': ' + Node.Parent.Text;
         
         AfficherEquipementForNiveau(GetNodeCode(Node));
       end;
    26: begin
         // Compétence de niveau 1
         TypeNodeSelectionnee := 'COMPETENCE';
         AfficherDonneeCompetence(GetNodeCode(Node), GetTexteLibelle('LAB_009'));
       end;
    27: begin
         // Spécialisation de compétence
         TypeNodeSelectionnee := 'COMPETENCE';
         AfficherDonneeCompetence(GetNodeCode(Node), GetTexteLibelle('LAB_146'));
       end;
    28: begin
         // Talent de niveau 1
         TypeNodeSelectionnee := 'TALENT';
         AfficherDonneeTalent(GetNodeCode(Node), GetTexteLibelle('LAB_007'));
       end;
    29: begin
         // Spécialisation de talent
         TypeNodeSelectionnee := 'TALENT';
         AfficherDonneeTalent(GetNodeCode(Node), GetTexteLibelle('LAB_147'));
       end;
    30: begin
         // Arme
         TypeNodeSelectionnee := 'EQUIPEMENT';
         AfficherDonneeEquipement(GetNodeCode(Node), 'Weapon', GetTexteLibelle('LAB_063'));
       end;
    31: begin
         // Armure
         TypeNodeSelectionnee := 'EQUIPEMENT';
         AfficherDonneeEquipement(GetNodeCode(Node), 'Armor', GetTexteLibelle('LAB_065'));
       end;
    32: begin
         // Qualité d'arme
         TypeNodeSelectionnee := 'EQUIPEMENT';
         AfficherDonneeBonusMalus(GetNodeCode(Node),
                                  GetTexteLibelle('LAB_125') + ' ' + GetTexteLibelle('LAB_063'));
       end;
    33: begin
         // Armure simplifiée
         TypeNodeSelectionnee := 'EQUIPEMENT';
         AfficherDonneeEquipement(GetNodeCode(Node), 'ArmorSimp', GetTexteLibelle('LAB_149'));
       end;
    34: begin
         // Qualité d'armure
         TypeNodeSelectionnee := 'EQUIPEMENT';
         AfficherDonneeBonusMalus(GetNodeCode(Node),
                                  GetTexteLibelle('LAB_125') + ' ' + GetTexteLibelle('LAB_065'));
       end;
    35: begin
         // Sort
         TypeNodeSelectionnee := 'SORT';
         AfficherDonneeSort(GetNodeCode(Node), GetTexteLibelle('LAB_083'));
       end;
    36: begin
         // Table de tirage aléatoire de race
         TypeNodeSelectionnee := 'CHAPITRE';
         LabelFormTitle.Caption := GetTexteLibelle('LAB_042') + ' ' + GetTexteLibelle('LAB_085');
         AfficherTirageRace();
       end;
    37: begin
             // Informations du livre (bloc DATA_BOOK)
             TypeNodeSelectionnee := 'LIVRE';
             AfficherInfosLivre();
           end;
    16, 17, 19, 21, 23, 25: begin
         // Sous-branches d'un métier : races possibles, niveaux et leur contenu.
         // Affichage seul pour l'instant, la saisie viendra plus tard.
         TypeNodeSelectionnee := 'METIER';
         LabelFormTitle.Caption := Node.Text;
         MasquerAfficherElements('');  // Masquer tous les grids
         MasquerForm();
       end;
  else
    begin
      // Cas non gérés
      MasquerAfficherElements('');  // Masquer tous les grids
      MasquerForm();
    end;
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

// ========== LOAD SKILLS FOR RACE ==========
procedure TWinLivres.LoadSkillsForRace(RaceElement: TDOMElement; RaceCode: String);
var
  SkillChapter: TDOMNode;
  SkillElements: TDOMNodeList;
  I: Integer;
  SkillCode: String;
  SkillNode: TDOMNode;
begin
  RaceSkillsData.Clear;
  
  // Trouver SUBCHAPTER_SKILL
  SkillChapter := RaceElement.FindNode('SUBCHAPTER_SKILL');
  if SkillChapter = nil then Exit;
  
  if SkillChapter <> nil then
  begin
    SkillElements := SkillChapter.ChildNodes;
    
    for I := 0 to SkillElements.Count - 1 do
    begin
      SkillNode := SkillElements[I];
      if SkillNode.NodeName = 'Skill' then
      begin
        // Récupérer le code de la compétence (le texte du nœud)
        SkillCode := Trim(SkillNode.TextContent);
        // Enlever les guillemets si présents
        if (Length(SkillCode) > 0) and (SkillCode[1] = '"') then
          SkillCode := Copy(SkillCode, 2, Length(SkillCode) - 2);
        if (Length(SkillCode) > 0) and (SkillCode[Length(SkillCode)] = '"') then
          SkillCode := Copy(SkillCode, 1, Length(SkillCode) - 1);
        
        if SkillCode <> '' then
          RaceSkillsData.Add(SkillCode);
      end;
    end;
  end;
end;

// ========== LOAD CAREERS FOR RACE ==========
procedure TWinLivres.LoadCareersForRace(RaceElement: TDOMElement);
var
  CareerChapter: TDOMNode;
  CareerElements: TDOMNodeList;
  I: Integer;
  CareerCode, CareerValue: String;
  CareerNode: TDOMNode;
  CareerElement: TDOMElement;
begin
  RaceCareersData.Clear;
  
  // Trouver SUBCHAPTER_CAREER
  CareerChapter := RaceElement.FindNode('SUBCHAPTER_CAREER');
  if CareerChapter = nil then Exit;
  
  if CareerChapter <> nil then
  begin
    CareerElements := CareerChapter.ChildNodes;
    
    for I := 0 to CareerElements.Count - 1 do
    begin
      CareerNode := CareerElements[I];
      if CareerNode.NodeName = 'Career' then
      begin
        // Récupérer le code de la carrière (attribut name)
        CareerElement := TDOMElement(CareerNode);
        CareerCode := CareerElement.GetAttribute('name');
        
        // Récupérer la valeur (le texte du nœud)
        CareerValue := Trim(CareerNode.TextContent);
        // Enlever les guillemets si présents
        if (Length(CareerValue) > 0) and (CareerValue[1] = '"') then
          CareerValue := Copy(CareerValue, 2, Length(CareerValue) - 2);
        if (Length(CareerValue) > 0) and (CareerValue[Length(CareerValue)] = '"') then
          CareerValue := Copy(CareerValue, 1, Length(CareerValue) - 1);
        
        if CareerCode <> '' then
          RaceCareersData.Add(CareerCode + '|' + CareerValue);  // Format: Code|Valeur
      end;
    end;
  end;
end;

// ========== MASQUER/AFFICHER ELEMENTS - FONCTION CENTRALISEE ==========
procedure TWinLivres.MasquerAfficherElements(ElementType: String);
begin
  // Masquer tous les éléments par défaut
  LabelFormSkills.Visible := False;
  StringGridSkills.Visible := False;
  StringGridCareers.Visible := False;
  StringGridRaces.Visible := False;
  StringGridAttributs.Visible := False;
  StringGridCompetences.Visible := False;
  StringGridTalents.Visible := False;
  StringGridEquipement.Visible := False;
  StringGridDetail.Visible := False;
  StringGridQualites.Visible := False;
  MemoDetail.Visible := False;
  StringGridRandomRace.Visible := False;
  if TreeViewTalents <> nil then
    TreeViewTalents.Visible := False;
  if LabelTalentsRandom <> nil then
    LabelTalentsRandom.Visible := False;
  
  // Afficher selon le type d'élément sélectionné
  case ElementType of
    'COMPETENCE':
      begin
        // Afficher compétences (StringGridSkills)
        LabelFormSkills.Visible := True;
        StringGridSkills.Visible := True;
        // Les autres grids restent masqués
      end;
    
    'CARRIERE', 'METIER':
      begin
        // Afficher métiers (StringGridCareers)
        LabelFormSkills.Visible := True;
        StringGridCareers.Visible := True;
        // Les autres grids restent masqués
      end;
    
    'RACE':
      begin
        // Afficher les races (StringGridRaces).
        // Pas de LabelFormSkills ici : son libellé est 'Compétence de race',
        // hors sujet au-dessus d'une liste de races. Le titre vient de LabelFormTitle.
        StringGridRaces.Visible := True;
      end;
    
    'ATTRIBUT_METIER':
      begin
        // Grille des attributs d'un niveau de métier
        StringGridAttributs.Visible := True;
      end;
    
    'COMPETENCE_METIER':
      begin
        // Grille des compétences d'un niveau de métier
        StringGridCompetences.Visible := True;
      end;
    
    'TALENT_METIER':
      begin
        // Grille des talents d'un niveau de métier
        StringGridTalents.Visible := True;
      end;
    
    'EQUIPEMENT_METIER':
      begin
        // Grille de l'équipement d'un niveau de métier
        StringGridEquipement.Visible := True;
      end;
    
    'DETAIL':
      begin
        // Grille clé/valeur : détail d'une arme ou d'une armure
        StringGridDetail.Visible := True;
      end;
    
    'TIRAGE_RACE':
      begin
        // Table de tirage aléatoire de race propre au livre
        StringGridRandomRace.Visible := True;
      end;
    
    'TALENT':
      begin
        // Afficher talents (TreeViewTalents)
        if TreeViewTalents <> nil then
          TreeViewTalents.Visible := True;
        if LabelTalentsRandom <> nil then
          LabelTalentsRandom.Visible := True;
        // Les autres grids restent masqués
      end;
    
    else
      begin
        // RIEN: masquer tous les grids
        // (les Visible := False sont déjà appliqués ci-dessus)
      end;
  end;
end;

// ========== AFFICHER SKILLS FOR RACE ==========
procedure TWinLivres.AfficherSkillsForRace(RaceCode: String);
var
  RaceElement: TDOMElement;
  SpecieElements: TDOMNodeList;
  I, RowIdx: Integer;
  SkillCode: String;
  Competence: StructureCompetence;
  SkillCount, J: Integer;
  SpecList, BaseCode, SpecCode, SpecBase, FoundSkill: String;
begin
  // Afficher compétences, masquer les autres éléments
  MasquerAfficherElements('COMPETENCE');
  
  // Masquer les contrôles de race et attributs
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  LabelFormAttrName.Visible := False;
  EditFormAttrName.Visible := False;
  
  // Vider le StringGrid
  StringGridSkills.RowCount := 1;
  
  // Chercher la race dans le XML
  SpecieElements := XMLDoc.GetElementsByTagName('Specie');
  RaceElement := nil;
  
  for I := 0 to SpecieElements.Count - 1 do
  begin
    if TDOMElement(SpecieElements[I]).GetAttribute('id') = RaceCode then
    begin
      RaceElement := TDOMElement(SpecieElements[I]);
      Break;
    end;
  end;
  
  if RaceElement = nil then
    Exit;
  
  // Charger les compétences de cette race
  LoadSkillsForRace(RaceElement, RaceCode);
  
  // Afficher dans le StringGrid
  // PASS 1: Compter les compétences NON spécialisées (SousCompetence = False)
  SkillCount := 0;
  for I := 0 to ListCompetence.Count - 1 do
  begin
    if not ListCompetence[I].SousCompetence then
      Inc(SkillCount);
  end;
  
  if SkillCount > 0 then
  begin
    StringGridSkills.RowCount := SkillCount + 1;
    
    // PASS 2: Remplir le StringGrid avec les compétences NON spécialisées
    RowIdx := 1;
    for I := 0 to ListCompetence.Count - 1 do
    begin
      Competence := ListCompetence[I];
      
      // Ne garder que les compétences non-spécialisées
      if not Competence.SousCompetence then
      begin
        // Col 1: Code
        StringGridSkills.Cells[1, RowIdx] := Competence.CodeCompetence;
        // Col 2: Libellé
        StringGridSkills.Cells[2, RowIdx] := Competence.Libelle;
        
        // Col 3: Spécialisation - créer PickList des spécialisations disponibles
        SpecList := Competence.Libelle + '|';  // Ajouter la générique en premier
        BaseCode := Competence.CodeCompetence;  // ex: RULES-COMPART_*
        
        for J := 0 to ListCompetence.Count - 1 do
        begin
          // Chercher les spécialisations de cette compétence générique
          if ListCompetence[J].SousCompetence then
          begin
            // Vérifier si c'est une spécialisation de cette compétence générique
            // Ex: RULES-COMPART_PEINT est spécialisation de RULES-COMPART_*
            SpecCode := ListCompetence[J].CodeCompetence;
            // Extraire la base: enlever la partie après le dernier _
            SpecBase := Copy(SpecCode, 1, Pos('_', SpecCode) - 1) + '_*';
            
            if SpecBase = BaseCode then
            begin
              SpecList := SpecList + ListCompetence[J].Libelle + '|';
            end;
          end;
        end;
        
        // Retirer le dernier |
        if SpecList[Length(SpecList)] = '|' then
          SpecList := Copy(SpecList, 1, Length(SpecList) - 1);
        
        // Assigner la PickList à cette colonne
        StringGridSkills.Columns[2].PickList.Text := SpecList;
        
        // Chercher si la race a cette compétence générique OU une de ses spécialisations
        FoundSkill := '';
        
        // D'abord chercher la compétence générique
        if RaceSkillsData.IndexOf(BaseCode) >= 0 then
          FoundSkill := Competence.Libelle
        else
        begin
          // Sinon chercher une spécialisation
          for J := 0 to ListCompetence.Count - 1 do
          begin
            if ListCompetence[J].SousCompetence then
            begin
              SpecCode := ListCompetence[J].CodeCompetence;
              SpecBase := Copy(SpecCode, 1, Pos('_', SpecCode) - 1) + '_*';
              
              if SpecBase = BaseCode then
              begin
                if RaceSkillsData.IndexOf(SpecCode) >= 0 then
                begin
                  FoundSkill := ListCompetence[J].Libelle;
                  Break;
                end;
              end;
            end;
          end;
        end;
        
        StringGridSkills.Cells[3, RowIdx] := FoundSkill;
        
        // Col 4: Checkbox - Afficher ✓ si quelque chose est sélectionné
        if FoundSkill <> '' then
          StringGridSkills.Cells[4, RowIdx] := '✓'
        else
          StringGridSkills.Cells[4, RowIdx] := '';
        
        Inc(RowIdx);
      end;
    end;
    
    // Trier le StringGrid: Sélectionnées en premier, puis alphabétique
    SortSkillsGrid();
  end
  else
  begin
    // Si pas de compétences trouvées, masquer tout
    MasquerAfficherElements('');
  end;
  
  GroupBoxForm.Visible := False;
end;

// ========== AFFICHER TALENTS POUR RACE ==========
procedure TWinLivres.AfficherTalentsForRace();
var
  TalentNode, ChildNode, NodeTalent, ChildChoice, NodeChoice: TTreeNode;
  RandomCount, I, J: Integer;
begin
  // Afficher talents, masquer les autres éléments
  MasquerAfficherElements('TALENT');
  
  // Chercher le nœud "Talent" sélectionné ou parent
  TalentNode := nil;
  
  if NodeSelectionnee <> nil then
  begin
    // Si on a cliqué sur "Talent", c'est directement
    if Pos('Talent', NodeSelectionnee.Text) > 0 then
      TalentNode := NodeSelectionnee
    // Sinon, chercher le parent "Talent"
    else if NodeSelectionnee.Parent <> nil then
      TalentNode := NodeSelectionnee.Parent;
  end;
  
  if TalentNode = nil then
  begin
    // Pas de talents trouvés
    if LabelTalentsRandom <> nil then
      LabelTalentsRandom.Visible := False;
    if TreeViewTalents <> nil then
    begin
      LibererNodesData(TreeViewTalents);
      TreeViewTalents.Items.Clear;
    end;
    Exit;
  end;
  
  // Masquer les compétences
  LabelFormSkills.Visible := False;
  StringGridSkills.Visible := False;
  
  // Compter les talents aléatoires et remplir l'arbre
  RandomCount := 0;
  
  if TreeViewTalents <> nil then
  begin
    TreeViewTalents.Items.BeginUpdate;
    try
      LibererNodesData(TreeViewTalents);
      TreeViewTalents.Items.Clear;
      
      // Boucler sur les enfants du nœud Talent (TTreeView source)
      for I := 0 to TalentNode.Count - 1 do
      begin
        ChildNode := TalentNode.Items[I];
        
        if ChildNode <> nil then
        begin
          // CASE 1: Nœud "Choix" - afficher avec enfants
          if Pos(GetTexteLibelle('LAB_127'), ChildNode.Text) > 0 then
          begin
            NodeTalent := TreeViewTalents.Items.Add(nil, ChildNode.Text);
            SetNodeInfo(NodeTalent, 11);  // 11 = choice node
            
            // Ajouter les enfants du choix
            for J := 0 to ChildNode.Count - 1 do
            begin
              ChildChoice := ChildNode.Items[J];
              if ChildChoice <> nil then
              begin
                NodeChoice := TreeViewTalents.Items.AddChild(NodeTalent, ChildChoice.Text);
                SetNodeInfo(NodeChoice, 12);  // 12 = choice item
              end;
            end;
          end
          // CASE 2: Talent aléatoire - compter seulement (vérifier par Data)
          else if GetNodeType(ChildNode) = 6 then
            Inc(RandomCount)
          // CASE 3: Talent fixe - ajouter directement
          else
          begin
            NodeTalent := TreeViewTalents.Items.Add(nil, ChildNode.Text);
            SetNodeInfo(NodeTalent, 10);  // 10 = talent node
          end;
        end;
      end;
    finally
      TreeViewTalents.Items.EndUpdate;
    end;
  end;
  
  // Afficher le nombre de talents aléatoires
  if LabelTalentsRandom <> nil then
  begin
    if RandomCount > 0 then
    begin
      LabelTalentsRandom.Caption := GetTexteLibelle('LAB_085') + ': ' + IntToStr(RandomCount);
      LabelTalentsRandom.BringToFront;
      LabelTalentsRandom.Visible := True;
    end
    else
      LabelTalentsRandom.Visible := False;
  end;
  
  // Afficher le TreeViewTalents
  if TreeViewTalents <> nil then
  begin
    TreeViewTalents.BringToFront;
    TreeViewTalents.Visible := True;
  end;
end;

// ========== AFFICHER ATTRIBUTS D'UN NIVEAU DE MÉTIER ==========
// Les attributs de Warhammer sont un ensemble FERMÉ : les dix sont toujours
// présents dans SUBCHAPTER_ATTR, chacun portant le niveau où il est acquis
// (0 = jamais). On affiche donc la répartition complète, pas seulement le
// niveau courant, dont les lignes sont mises en évidence.
// CodeNiveau a la forme "RULES-WORK01|2".
procedure TWinLivres.AfficherAttributsForNiveau(CodeNiveau: String);
var
  CareerElement: TDOMElement;
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I, RowIdx, PipePos: Integer;
  CareerCode, CodeAttr, Valeur: String;
begin
  MasquerAfficherElements('ATTRIBUT_METIER');
  
  // Masquer les contrôles de saisie
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  GroupBoxForm.Visible := False;
  
  // Découper "CODEMETIER|niveau"
  PipePos := Pos('|', CodeNiveau);
  if PipePos = 0 then Exit;
  
  CareerCode := Copy(CodeNiveau, 1, PipePos - 1);
  NiveauCourantAffiche := StrToIntDef(Copy(CodeNiveau, PipePos + 1, Length(CodeNiveau)), 0);
  
  CareerElement := TrouverCareerElement(CareerCode);
  if CareerElement = nil then Exit;
  
  Chapitre := CareerElement.FindNode('SUBCHAPTER_ATTR');
  if Chapitre = nil then Exit;
  
  StringGridAttributs.RowCount := 1;
  
  // Col 0 = vide (réservé Lazarus), 1 = Code, 2 = Attribut, 3 = Niveau
  StringGridAttributs.Columns[0].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  StringGridAttributs.Columns[1].Title.Caption := GetTexteLibelle('LAB_008');  // Attribut
  StringGridAttributs.Columns[2].Title.Caption := GetTexteLibelle('LAB_019');  // Niv.
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Attribut');
  
  // Pas de tri : l'ordre du XML est l'ordre canonique de Warhammer
  // (CC, CT, F, E, I, Ag, Dex, Int, FM, Soc), plus parlant qu'un tri alphabétique.
  StringGridAttributs.RowCount := Elements.Count + 1;
  RowIdx := 1;
  
  for I := 0 to Elements.Count - 1 do
  begin
    CodeAttr := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if CodeAttr = '' then Continue;
    
    Valeur := ValeurXML(Elements.Item[I]);
    
    StringGridAttributs.Cells[1, RowIdx] := CodeAttr;
    StringGridAttributs.Cells[2, RowIdx] := GetAttributLabel(CodeAttr);
    StringGridAttributs.Cells[3, RowIdx] := Valeur;
    
    Inc(RowIdx);
  end;
  
  StringGridAttributs.RowCount := RowIdx;
  
  AdjustGridColumnsWidth(StringGridAttributs, 0, False, False, True, 10, 10, ssAutoBoth);
end;

// ========== AFFICHER COMPÉTENCES D'UN NIVEAU DE MÉTIER ==========
// Contrairement aux attributs, les compétences forment un ensemble OUVERT :
// une même compétence peut apparaître plusieurs fois avec des spécialisations
// différentes (Métier (Apothicaire) et Métier (Empoisonneur)). Les lignes
// viennent donc du XML et non de ListCompetence, sinon les doublons de
// spécialisation seraient impossibles à représenter.
// CodeNiveau a la forme "RULES-WORK01|2".
procedure TWinLivres.AfficherCompetencesForNiveau(CodeNiveau: String);
var
  CareerElement: TDOMElement;
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I, RowIdx, PipePos, UnderPos: Integer;
  CareerCode, CodeComp, BaseCode, SkillPrincipal: String;
  ColComp, ColSpec: String;
  Competence, Generique: StructureCompetence;
begin
  MasquerAfficherElements('COMPETENCE_METIER');
  
  // Masquer les contrôles de saisie
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  GroupBoxForm.Visible := False;
  
  // Découper "CODEMETIER|niveau"
  PipePos := Pos('|', CodeNiveau);
  if PipePos = 0 then Exit;
  
  CareerCode := Copy(CodeNiveau, 1, PipePos - 1);
  NiveauCourantAffiche := StrToIntDef(Copy(CodeNiveau, PipePos + 1, Length(CodeNiveau)), 0);
  
  CareerElement := TrouverCareerElement(CareerCode);
  if CareerElement = nil then Exit;
  
  Chapitre := CareerElement.FindNode('SUBCHAPTER_SKILL');
  if Chapitre = nil then Exit;
  
  // Compétence principale du métier, marquée d'une étoile comme dans l'arbre
  SkillPrincipal := ValeurXML(CareerElement.FindNode('Skill'));
  
  StringGridCompetences.RowCount := 1;
  
  // Col 0 = vide (réservé Lazarus)
  StringGridCompetences.Columns[0].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  StringGridCompetences.Columns[1].Title.Caption := GetTexteLibelle('LAB_009');  // Compétence
  StringGridCompetences.Columns[2].Title.Caption := GetTexteLibelle('LAB_078');  // Spécialisation
  StringGridCompetences.Columns[3].Title.Caption := GetTexteLibelle('LAB_019');  // Niv.
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Skill');
  
  // Pas de tri : l'ordre du XML groupe déjà les compétences par niveau croissant.
  StringGridCompetences.RowCount := Elements.Count + 1;
  RowIdx := 1;
  
  for I := 0 to Elements.Count - 1 do
  begin
    CodeComp := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if CodeComp = '' then Continue;
    
    Competence := ChercheCompetence(CodeComp);
    
    if Competence.CodeCompetence = '' then
    begin
      // Compétence inconnue : on montre au moins le code
      ColComp := CodeComp;
      ColSpec := '';
    end
    else if Competence.SousCompetence then
    begin
      // Spécialisation : remonter à la compétence générique "XXX_*"
      UnderPos := Pos('_', CodeComp);
      if UnderPos > 0 then
        BaseCode := Copy(CodeComp, 1, UnderPos - 1) + '_*'
      else
        BaseCode := '';
      
      Generique := ChercheCompetence(BaseCode);
      if Generique.CodeCompetence <> '' then
        ColComp := Generique.Libelle
      else
        ColComp := BaseCode;
      
      ColSpec := Competence.Libelle;
    end
    else
    begin
      // Compétence sans spécialisation
      ColComp := Competence.Libelle;
      ColSpec := '';
    end;
    
    if CodeComp = SkillPrincipal then
      ColComp := ColComp + ' *';
    
    StringGridCompetences.Cells[1, RowIdx] := CodeComp;
    StringGridCompetences.Cells[2, RowIdx] := ColComp;
    StringGridCompetences.Cells[3, RowIdx] := ColSpec;
    StringGridCompetences.Cells[4, RowIdx] := ValeurXML(Elements.Item[I]);
    
    Inc(RowIdx);
  end;
  
  StringGridCompetences.RowCount := RowIdx;
  
  AdjustGridColumnsWidth(StringGridCompetences, 0, False, False, True, 10, 10, ssAutoBoth);
end;

// ========== AFFICHER TALENTS D'UN NIVEAU DE MÉTIER ==========
// Même modèle que les compétences : ensemble ouvert, spécialisations possibles
// (RULES-T0136_* = Etiquette (au choix)), donc les lignes viennent du XML.
// CodeNiveau a la forme "RULES-WORK01|2".
procedure TWinLivres.AfficherTalentsForNiveau(CodeNiveau: String);
var
  CareerElement: TDOMElement;
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I, RowIdx, PipePos, UnderPos: Integer;
  CareerCode, CodeTal, BaseCode: String;
  ColTal, ColSpec: String;
  Talent, Generique: StructureTalent;
begin
  MasquerAfficherElements('TALENT_METIER');
  
  // Masquer les contrôles de saisie
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  GroupBoxForm.Visible := False;
  
  // Découper "CODEMETIER|niveau"
  PipePos := Pos('|', CodeNiveau);
  if PipePos = 0 then Exit;
  
  CareerCode := Copy(CodeNiveau, 1, PipePos - 1);
  NiveauCourantAffiche := StrToIntDef(Copy(CodeNiveau, PipePos + 1, Length(CodeNiveau)), 0);
  
  CareerElement := TrouverCareerElement(CareerCode);
  if CareerElement = nil then Exit;
  
  Chapitre := CareerElement.FindNode('SUBCHAPTER_TALENT');
  if Chapitre = nil then Exit;
  
  StringGridTalents.RowCount := 1;
  
  // Col 0 = vide (réservé Lazarus)
  StringGridTalents.Columns[0].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  StringGridTalents.Columns[1].Title.Caption := GetTexteLibelle('LAB_007');  // Talent
  StringGridTalents.Columns[2].Title.Caption := GetTexteLibelle('LAB_078');  // Spécialisation
  StringGridTalents.Columns[3].Title.Caption := GetTexteLibelle('LAB_019');  // Niv.
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Talent');
  
  // Pas de tri : l'ordre du XML groupe déjà les talents par niveau croissant.
  StringGridTalents.RowCount := Elements.Count + 1;
  RowIdx := 1;
  
  for I := 0 to Elements.Count - 1 do
  begin
    CodeTal := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if CodeTal = '' then Continue;
    
    Talent := ChercheTalent(CodeTal);
    
    if Talent.CodeTalent = '' then
    begin
      // Talent inconnu : on montre au moins le code
      ColTal  := CodeTal;
      ColSpec := '';
    end
    else if Talent.SousTalent then
    begin
      // Spécialisation : remonter au talent générique "XXX_*"
      UnderPos := Pos('_', CodeTal);
      if UnderPos > 0 then
        BaseCode := Copy(CodeTal, 1, UnderPos - 1) + '_*'
      else
        BaseCode := '';
      
      Generique := ChercheTalent(BaseCode);
      if Generique.CodeTalent <> '' then
        ColTal := Generique.Libelle
      else
        ColTal := BaseCode;
      
      ColSpec := Talent.Libelle;
    end
    else
    begin
      // Talent sans spécialisation
      ColTal  := Talent.Libelle;
      ColSpec := '';
    end;
    
    StringGridTalents.Cells[1, RowIdx] := CodeTal;
    StringGridTalents.Cells[2, RowIdx] := ColTal;
    StringGridTalents.Cells[3, RowIdx] := ColSpec;
    StringGridTalents.Cells[4, RowIdx] := ValeurXML(Elements.Item[I]);
    
    Inc(RowIdx);
  end;
  
  StringGridTalents.RowCount := RowIdx;
  
  AdjustGridColumnsWidth(StringGridTalents, 0, False, False, True, 10, 10, ssAutoBoth);
end;

// ========== AFFICHER ÉQUIPEMENT D'UN NIVEAU DE MÉTIER ==========
// Une ligne = une entrée <Item> du XML, comme pour les compétences et talents.
// Un choix multiple ("A/B") reste donc sur UNE ligne, ses options jointes par
// le séparateur : c'est une seule donnée à modifier plus tard, pas deux.
// CodeNiveau a la forme "RULES-WORK01|2".
procedure TWinLivres.AfficherEquipementForNiveau(CodeNiveau: String);
var
  CareerElement: TDOMElement;
  Chapitre: TDOMNode;
  Elements: TDOMNodeList;
  I, J, RowIdx, PipePos: Integer;
  CareerCode, NomItem, ColLib, ColType: String;
  TypeEquip: Char;
  Choix: TStringList;
begin
  MasquerAfficherElements('EQUIPEMENT_METIER');
  
  // Masquer les contrôles de saisie
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  GroupBoxForm.Visible := False;
  
  // Découper "CODEMETIER|niveau"
  PipePos := Pos('|', CodeNiveau);
  if PipePos = 0 then Exit;
  
  CareerCode := Copy(CodeNiveau, 1, PipePos - 1);
  NiveauCourantAffiche := StrToIntDef(Copy(CodeNiveau, PipePos + 1, Length(CodeNiveau)), 0);
  
  CareerElement := TrouverCareerElement(CareerCode);
  if CareerElement = nil then Exit;
  
  Chapitre := CareerElement.FindNode('SUBCHAPTER_ITEM');
  if Chapitre = nil then Exit;
  
  StringGridEquipement.RowCount := 1;
  
  // Col 0 = vide (réservé Lazarus)
  StringGridEquipement.Columns[0].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  StringGridEquipement.Columns[1].Title.Caption := GetTexteLibelle('LAB_018');  // Type
  StringGridEquipement.Columns[2].Title.Caption := GetTexteLibelle('LAB_013');  // Equipement
  StringGridEquipement.Columns[3].Title.Caption := GetTexteLibelle('LAB_019');  // Niv.
  
  Elements := TDOMElement(Chapitre).GetElementsByTagName('Item');
  
  StringGridEquipement.RowCount := Elements.Count + 1;
  RowIdx := 1;
  
  for I := 0 to Elements.Count - 1 do
  begin
    NomItem := TDOMElement(Elements.Item[I]).GetAttribute('name');
    if NomItem = '' then Continue;
    
    if Pos(SeparateurMulti, NomItem) > 0 then
    begin
      // Choix multiple : résoudre chaque option, les rejoindre sur une ligne
      ColLib  := '';
      ColType := ConstArbreAuChoix;
      
      Choix := TStringList.Create;
      try
        Choix.Delimiter       := SeparateurMulti;
        Choix.StrictDelimiter := True;
        Choix.DelimitedText   := NomItem;
        
        for J := 0 to Choix.Count - 1 do
        begin
          if ColLib <> '' then
            ColLib := ColLib + ' ' + SeparateurMulti + ' ';
          ColLib := ColLib + LibelleEquipement(Choix[J], TypeEquip);
        end;
      finally
        Choix.Free;
      end;
    end
    else
    begin
      ColLib := LibelleEquipement(NomItem, TypeEquip);
      
      case TypeEquip of
        'W': ColType := GetTexteLibelle('LAB_063');  // Arme
        'P': ColType := GetTexteLibelle('LAB_065');  // Armure
      else
        ColType := GetTexteLibelle('LAB_064');       // Divers
      end;
    end;
    
    StringGridEquipement.Cells[1, RowIdx] := NomItem;
    StringGridEquipement.Cells[2, RowIdx] := ColType;
    StringGridEquipement.Cells[3, RowIdx] := ColLib;
    StringGridEquipement.Cells[4, RowIdx] := ValeurXML(Elements.Item[I]);
    
    Inc(RowIdx);
  end;
  
  StringGridEquipement.RowCount := RowIdx;
  
  AdjustGridColumnsWidth(StringGridEquipement, 0, False, False, True, 10, 10, ssAutoBoth);
end;

// Met en évidence les lignes du niveau courant.
// Partagé par toutes les grilles dont la DERNIÈRE colonne est le niveau.
// OnPrepareCanvas plutôt que OnDrawCell : on ne change que le pinceau,
// la grille se dessine elle-même normalement.
procedure TWinLivres.GridNiveauPrepareCanvas(Sender: TObject; aCol, aRow: Integer; aState: TGridDrawState);
var
  Grille: TStringGrid;
begin
  if aRow < 1 then Exit;           // ligne d'en-tête
  if NiveauCourantAffiche = 0 then Exit;
  
  Grille := TStringGrid(Sender);
  if Grille.ColCount < 1 then Exit;
  
  if Grille.Cells[Grille.ColCount - 1, aRow] = IntToStr(NiveauCourantAffiche) then
    Grille.Canvas.Brush.Color := $00F0E4D8;  // fond discret
end;

// ========== AFFICHER RACES FOR METIER ==========
// Liste TOUTES les races de ListRace et coche celles qui proposent ce métier.
// Symétrique de AfficherCareersForRace, qui liste tous les métiers pour une race.
procedure TWinLivres.AfficherRacesForMetier(CareerCode: String);
var
  I, RowIdx, PipePos: Integer;
  Race: StructureRace;
  RacesDuMetier: TStringList;
  TempRacesData: TStringList;
  Ligne, Selected, Libelle, Code, LivreStr: String;
begin
  // Afficher le grid des races, masquer le reste
  MasquerAfficherElements('RACE');
  
  // Masquer les contrôles de race et attributs
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  
  if ListRace = nil then Exit;
  
  StringGridRaces.RowCount := 1;
  
  // Les colonnes sont définies dans le .lfm
  // Col 0 = vide (réservé Lazarus), 1 = Code, 2 = Libellé, 3 = Livre, 4 = Sélectionné
  StringGridRaces.Columns[0].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  StringGridRaces.Columns[1].Title.Caption := GetTexteLibelle('LAB_002');  // Libellé
  StringGridRaces.Columns[2].Title.Caption := GetTexteLibelle('LAB_128');  // Livre
  StringGridRaces.Columns[3].Title.Caption := GetTexteLibelle('LAB_004');  // Sélectionné
  
  // Codes des races qui proposent ce métier
  RacesDuMetier := TStringList.Create;
  TempRacesData := TStringList.Create;
  try
    if MetierRacesMap <> nil then
    begin
      RacesDuMetier.Delimiter       := '|';
      RacesDuMetier.StrictDelimiter := True;
      RacesDuMetier.DelimitedText   := MetierRacesMap.Values[CareerCode];
    end;
    
    // Format de tri : "Selected|Libelle|Code|Livre"
    // Selected = "0" si la race propose le métier (donc en premier), "1" sinon
    for I := 0 to ListRace.Count - 1 do
    begin
      Race := ListRace[I];
      if Race.CodeRace = '' then Continue;
      
      if RacesDuMetier.IndexOf(Race.CodeRace) >= 0 then
        Selected := '0'
      else
        Selected := '1';
      
      TempRacesData.Add(Selected + '|' + Race.Libelle + '|' + Race.CodeRace + '|' +
                        GetTexteLibelle(Race.Livre, '', '', True));
    end;
    
    // Tri : sélectionnées d'abord ("0" < "1"), puis alphabétique par libellé
    TempRacesData.Sort;
    
    StringGridRaces.RowCount := TempRacesData.Count + 1;
    RowIdx := 1;
    
    for I := 0 to TempRacesData.Count - 1 do
    begin
      // Découpage manuel : DelimitedText se comporte mal avec le pipe
      Ligne := TempRacesData[I];
      
      PipePos  := Pos('|', Ligne);
      Selected := Copy(Ligne, 1, PipePos - 1);
      Ligne    := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      PipePos  := Pos('|', Ligne);
      Libelle  := Copy(Ligne, 1, PipePos - 1);
      Ligne    := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      PipePos  := Pos('|', Ligne);
      Code     := Copy(Ligne, 1, PipePos - 1);
      LivreStr := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      StringGridRaces.Cells[1, RowIdx] := Code;
      StringGridRaces.Cells[2, RowIdx] := Libelle;
      StringGridRaces.Cells[3, RowIdx] := LivreStr;
      
      if Selected = '0' then
        StringGridRaces.Cells[4, RowIdx] := '✓'
      else
        StringGridRaces.Cells[4, RowIdx] := '';
      
      Inc(RowIdx);
    end;
  finally
    TempRacesData.Free;
    RacesDuMetier.Free;
  end;
  
  AdjustGridColumnsWidth(StringGridRaces, 0, False, False, True, 10, 10, ssAutoBoth);
  
  GroupBoxForm.Visible := False;
end;

// ========== AFFICHER CAREERS FOR RACE ==========
procedure TWinLivres.AfficherCareersForRace(RaceCode: String);
var
  RowIdx, I, J: Integer;
  Metier: StructureMetier;
  Livre: StructureLivre;
  CareerFound: Boolean;
  CareerValue: String;
  CodeLivre: String;
  TempCareersData: TStringList;
  Parts: TStringList;
  RaceElement: TDOMElement;
  SpecieElements: TDOMNodeList;
  Line: String;
  PipePos: Integer;
  Selected, Libelle, Code, LivreStr, Chance: String;
begin
  // Afficher carrières, masquer les autres éléments
  MasquerAfficherElements('CARRIERE');
  
  // Masquer les contrôles de race et attributs
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  
  // Chercher l'élément race dans le XML
  if XMLDoc = nil then Exit;
  
  RaceElement := nil;
  SpecieElements := XMLDoc.GetElementsByTagName('Specie');
  
  for I := 0 to SpecieElements.Count - 1 do
  begin
    if TDOMElement(SpecieElements[I]).GetAttribute('id') = RaceCode then
    begin
      RaceElement := TDOMElement(SpecieElements[I]);
      Break;
    end;
  end;
  
  if RaceElement = nil then Exit;
  
  // Charger les carrières de cette race
  LoadCareersForRace(RaceElement);
  
  if ListMetier = nil then Exit;
  
  // Créer le StringGrid pour les carrières
  StringGridCareers.RowCount := 1;
  
  // Les colonnes sont définies dans le .lfm
  // Col 0 = vide (réservé Lazarus)
  // Col 1 = Code
  // Col 2 = Libellé
  // Col 3 = Livre
  // Col 4 = Sélectionné
  // Col 5 = Chance
  
  // Préparer les données dans une liste temporaire pour tri
  TempCareersData := TStringList.Create;
  try
    for I := 0 to ListMetier.Count - 1 do
    begin
      Metier := ListMetier[I];
      
      // Chercher dans RaceCareersData
      CareerFound := False;
      CareerValue := '';
      for J := 0 to RaceCareersData.Count - 1 do
      begin
        if Pos(Metier.CodeMetier + '|', RaceCareersData[J]) = 1 then
        begin
          CareerFound := True;
          CareerValue := Copy(RaceCareersData[J], Length(Metier.CodeMetier) + 2, Length(RaceCareersData[J]));
          Break;
        end;
      end;
      
      // Chercher le livre
      Livre := ChercheLivreLibelle(Metier.Livre);
      if Livre.CodeLivre <> '' then
        CodeLivre := GetTexteLibelle(Livre.Libelle)
      else
        CodeLivre := Metier.Livre;
      
      // Format stockage pour tri: "Selected|Libelle|Code|Livre|CareerValue"
      // Selected = "0" pour sélectionné (viendra en premier), "1" pour non-sélectionné
      if CareerFound then
        TempCareersData.Add('0|' + Metier.Libelle + '|' + Metier.CodeMetier + '|' + CodeLivre + '|' + CareerValue)
      else
        TempCareersData.Add('1|' + Metier.Libelle + '|' + Metier.CodeMetier + '|' + CodeLivre + '|');
    end;
    
    // TRIER: D'abord sélectionnés (1 avant 0), puis alphabétique par Libellé
    TempCareersData.Sort;
    
    // Remplir le grid avec les données triées
    StringGridCareers.RowCount := TempCareersData.Count + 1;
    
    RowIdx := 1;
    for I := 0 to TempCareersData.Count - 1 do
    begin
      // Parser la ligne: "Selected|Libelle|Code|Livre|CareerValue"
      // Parsing manuel robuste (évite les problèmes avec DelimitedText)
      Line := TempCareersData[I];
      
      // Extraire Selected (premier pipe)
      PipePos := Pos('|', Line);
      Selected := Copy(Line, 1, PipePos - 1);
      Line := Copy(Line, PipePos + 1, Length(Line));
      
      // Extraire Libelle (deuxième pipe)
      PipePos := Pos('|', Line);
      Libelle := Copy(Line, 1, PipePos - 1);
      Line := Copy(Line, PipePos + 1, Length(Line));
      
      // Extraire Code (troisième pipe)
      PipePos := Pos('|', Line);
      Code := Copy(Line, 1, PipePos - 1);
      Line := Copy(Line, PipePos + 1, Length(Line));
      
      // Extraire Livre (quatrième pipe)
      PipePos := Pos('|', Line);
      LivreStr := Copy(Line, 1, PipePos - 1);
      Chance := Copy(Line, PipePos + 1, Length(Line));
      
      // Col 1: Code
      StringGridCareers.Cells[1, RowIdx] := Code;
      
      // Col 2: Libellé
      StringGridCareers.Cells[2, RowIdx] := Libelle;
      
      // Col 3: Livre
      StringGridCareers.Cells[3, RowIdx] := LivreStr;
      
      // Col 4: Sélectionné (afficher ✓ si "0" - sélectionné)
      if Selected = '0' then
        StringGridCareers.Cells[4, RowIdx] := '✓'
      else
        StringGridCareers.Cells[4, RowIdx] := '';
      
      // Col 5: Chance
      StringGridCareers.Cells[5, RowIdx] := Chance;
      
      Inc(RowIdx);
    end;
    
  finally
    TempCareersData.Free;
  end;
  
  // Ajuster automatiquement les dimensions du grid
  AdjustGridColumnsWidth(StringGridCareers, 0, False, False, true, 10, 10, ssAutoBoth);
  
  GroupBoxForm.Visible := False;
end;

// ========== SORT SKILLS GRID ==========
procedure TWinLivres.SortSkillsGrid();
type
  TSkillRow = record
    Code: String;
    Label_: String;
    Specialization: String;
    Selected: String;
  end;
  
var
  Rows: array of TSkillRow;
  I, J, LastRow: Integer;
  Temp: TSkillRow;
  IsSorted: Boolean;
  NeedSwap: Boolean;
begin
  // Obtenir le nombre de lignes (sauf l'en-tête)
  LastRow := StringGridSkills.RowCount - 1;
  
  if LastRow <= 1 then Exit;  // Rien à trier
  
  // Charger les données dans le tableau
  SetLength(Rows, LastRow);
  for I := 1 to LastRow do
  begin
    Rows[I - 1].Code := StringGridSkills.Cells[0, I];
    Rows[I - 1].Label_ := StringGridSkills.Cells[1, I];
    Rows[I - 1].Specialization := StringGridSkills.Cells[2, I];
    Rows[I - 1].Selected := StringGridSkills.Cells[4, I];
  end;
  
  // Tri à bulles: Sélectionnées (✓) en premier, puis alphabétique
  repeat
    IsSorted := True;
    for I := 0 to Length(Rows) - 2 do
    begin
      // Comparer: d'abord par Selected (✓ avant vide), puis par Label_ (alphabétique)
      NeedSwap := False;
      
      if Rows[I].Selected < Rows[I + 1].Selected then
        NeedSwap := True  // ✓ avant vide = ✓ sort en premier
      else if Rows[I].Selected = Rows[I + 1].Selected then
      begin
        // Même status, comparer par label alphabétiquement
        if AnsiCompareText(Rows[I].Label_, Rows[I + 1].Label_) > 0 then
          NeedSwap := True;
      end;
      
      if NeedSwap then
      begin
        Temp := Rows[I];
        Rows[I] := Rows[I + 1];
        Rows[I + 1] := Temp;
        IsSorted := False;
      end;
    end;
  until IsSorted;
  
  // Réafficher les données triées dans le StringGrid
  for I := 1 to LastRow do
  begin
    StringGridSkills.Cells[0, I] := Rows[I - 1].Code;
    StringGridSkills.Cells[1, I] := Rows[I - 1].Label_;
    StringGridSkills.Cells[2, I] := Rows[I - 1].Specialization;
    StringGridSkills.Cells[4, I] := Rows[I - 1].Selected;
  end;
end;

procedure TWinLivres.AfficherInfosLivre();
var
  Racine: TDOMElement;

  function LireBalise(Nom: String): String;
  var N: TDOMNode;
  begin
    Result := '';
    if Racine = nil then Exit;
    N := Racine.FindNode(Nom);
    if N <> nil then
      Result := RemoveQuotes(Trim(N.TextContent));
  end;

begin
  MasquerAfficherElements('DETAIL');
  StringGridDetail.RowCount := 1;
  if XMLDoc = nil then Exit;
  Racine := XMLDoc.DocumentElement;
  AjouterLigneDetail('CODE_BOOK', LireBalise('CODE_BOOK'), True);
  AjouterLigneDetail('BOOK',      LireBalise('BOOK'),      True);
  AjouterLigneDetail('LANGUAGE',  LireBalise('language'),  True);
  AjouterLigneDetail('VERSION',   LireBalise('VERSION'),   True);
  AjouterLigneDetail('OFFICIAL',  LireBalise('OFFICIAL'),  True);
  AjouterLigneDetail('COMPLETE',  LireBalise('COMPLETE'),  True);
  LabelFormTitle.Caption := GetTexteLibelle('LAB_128');
  GroupBoxForm.Visible := True;
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
              LabelFormTitle.Caption := GetTexteLibelle('LAB_042') + ': ' + RaceData^.Code;
              EditFormCode.Text := RaceData^.Code;
              EditFormLib.Text := RaceData^.Libelle;
              MemoFormDesc.Text := RaceData^.Description;
              CodeDonneeSelectionnee := ACode;
              
              // Afficher les contrôles de race
              LabelFormCode.Visible := True;
              EditFormCode.Visible := True;
              LabelFormLib.Visible := True;
              EditFormLib.Visible := True;
              LabelFormDesc.Visible := True;
              MemoFormDesc.Visible := True;
              
              GroupBoxForm.Visible := True;
              Exit;
            end;
        end;
    end;
  
  MasquerForm();
end;

// ========== AFFICHER DONNÉE MÉTIER ==========
// Retrouve un élément racine par son attribut id, en écartant les éléments
// de même nom nichés dans les SUBCHAPTER_*, qui eux portent un attribut name.
function TWinLivres.TrouverElementParId(TagName, Id: String): TDOMElement;
var
  Elements: TDOMNodeList;
  I: Integer;
  Element: TDOMElement;
begin
  Result := nil;
  if (XMLDoc = nil) or (Id = '') then Exit;
  
  Elements := XMLDoc.GetElementsByTagName(TagName);
  
  for I := 0 to Elements.Count - 1 do
  begin
    Element := TDOMElement(Elements.Item[I]);
    
    if Element.GetAttribute('id') = Id then
    begin
      Result := Element;
      Exit;
    end;
  end;
end;

function TWinLivres.TrouverCareerElement(CareerCode: String): TDOMElement;
begin
  Result := TrouverElementParId('Career', CareerCode);
end;

// Découpe un calcul de dégâts du type "+(BATTR_S)+5" en deux parties :
// le code du bonus d'attribut, et la valeur fixe. Renvoie True si un bonus
// est présent. Tolère l'absence de l'un ou l'autre.
function TWinLivres.DecouperDegats(Degats: String; out CodeBonus, Fixe: String): Boolean;
var
  P1, P2: Integer;
  Reste: String;
begin
  CodeBonus := '';
  Fixe      := '';
  Result    := False;
  
  Reste := Trim(Degats);
  if (Reste = '') or (Reste = '-') then
  begin
    Fixe := Reste;
    Exit;
  end;
  
  // Le bonus d'attribut est entre parenthèses
  P1 := Pos('(', Reste);
  P2 := Pos(')', Reste);
  if (P1 > 0) and (P2 > P1) then
  begin
    CodeBonus := Copy(Reste, P1 + 1, P2 - P1 - 1);
    Delete(Reste, P1, P2 - P1 + 1);
    Result := True;
  end;
  
  // Nettoyer les '+' devenus orphelins après le retrait du groupe
  while (Length(Reste) > 0) and (Reste[1] = '+') do
    Delete(Reste, 1, 1);
  
  Fixe := Trim(Reste);
end;

// ========== AFFICHER DONNÉE ÉQUIPEMENT (arme / armure) ==========

// Ajoute une ligne à la grille de détail.
// Toujours = True force l'affichage même sans valeur, pour les champs dont
// la seule présence est l'information (une qualité sans valeur associée).
procedure TWinLivres.AjouterLigneDetail(Libelle, Valeur: String; Toujours: Boolean = False);
var
  Ligne: Integer;
begin
  if (Valeur = '') and (not Toujours) then Exit;
  
  Ligne := StringGridDetail.RowCount;
  StringGridDetail.RowCount := Ligne + 1;
  StringGridDetail.Cells[1, Ligne] := Libelle;
  StringGridDetail.Cells[2, Ligne] := Valeur;
end;

// Préfixe de livre d'un code, "RULES-COMB_05" -> "RULES-".
// Les codes référencés dans les champs sont écrits sans préfixe alors que
// les id des éléments le portent.
function TWinLivres.PrefixeLivre(Code: String): String;
var
  P: Integer;
begin
  P := Pos('-', Code);
  if P > 0 then
    Result := Copy(Code, 1, P)
  else
    Result := '';
end;

// Remplit la grille des qualités. Grille séparée de la grille générale
// parce que les deux n'ont pas la même nature : la générale a une ligne fixe
// par champ du XML, celle-ci une liste variable qu'on pourra compléter.
// Format : "WEAPB18 2,WEAPB08,WEAPB27" — certaines portent une valeur,
// séparée du code par une espace.
procedure TWinLivres.AjouterLignesQualite(Valeur, Prefixe: String);
var
  Codes: TStringList;
  I, EspPos, Ligne: Integer;
  CodeQ, ValQ, LibQ: String;
  Element: TDOMElement;
begin
  StringGridQualites.RowCount := 1;
  StringGridQualites.Columns[0].Title.Caption := GetTexteLibelle('LAB_125');  // Qualité
  StringGridQualites.Columns[1].Title.Caption := GetTexteLibelle('LAB_025');  // Valeur
  
  if (Valeur = '') or (Valeur = '-') then Exit;
  
  Codes := TStringList.Create;
  try
    Codes.Delimiter       := ',';
    Codes.StrictDelimiter := True;
    Codes.DelimitedText   := Valeur;
    
    for I := 0 to Codes.Count - 1 do
    begin
      CodeQ := Trim(Codes[I]);
      if CodeQ = '' then Continue;
      
      // Valeur associée éventuelle, après une espace
      ValQ   := '';
      EspPos := Pos(' ', CodeQ);
      if EspPos > 0 then
      begin
        ValQ  := Trim(Copy(CodeQ, EspPos + 1, Length(CodeQ)));
        CodeQ := Copy(CodeQ, 1, EspPos - 1);
      end;
      
      // Libellé depuis les <BonusMalus>, qui ne sont pas des <Text>
      LibQ := CodeQ;
      Element := TrouverElementParId('BonusMalus', Prefixe + CodeQ);
      if Element <> nil then
        LibQ := ValeurXML(Element.FindNode('Description'));
      
      Ligne := StringGridQualites.RowCount;
      StringGridQualites.RowCount := Ligne + 1;
      StringGridQualites.Cells[1, Ligne] := LibQ;
      StringGridQualites.Cells[2, Ligne] := ValQ;
    end;
  finally
    Codes.Free;
  end;
end;

// Traduit une valeur de champ qui contient un ou plusieurs codes séparés
// par des virgules, par exemple Quality = "ARMOB_03,ARMOB_08".
function TWinLivres.TraduireCodesMultiples(Valeur: String): String;
var
  Codes: TStringList;
  I: Integer;
begin
  Result := '';
  if (Valeur = '') or (Valeur = '-') then
  begin
    Result := Valeur;
    Exit;
  end;
  
  Codes := TStringList.Create;
  try
    Codes.Delimiter       := ',';
    Codes.StrictDelimiter := True;
    Codes.DelimitedText   := Valeur;
    
    for I := 0 to Codes.Count - 1 do
    begin
      if Result <> '' then
        Result := Result + ', ';
      Result := Result + GetTexteLibelle(Trim(Codes[I]));
    end;
  finally
    Codes.Free;
  end;
end;

// Affiche une arme ou une armure dans la grille clé/valeur.
// Les deux ont des champs différents, on n'affiche donc que ceux présents
// dans l'élément XML plutôt qu'un formulaire figé.
procedure TWinLivres.AfficherDonneeEquipement(Code, TagName, Titre: String);
var
  Element: TDOMElement;
  Valeur, LibComp, CodeBonus, Fixe: String;
  Competence: StructureCompetence;
begin
  MasquerAfficherElements('DETAIL');
  MasquerForm();
  
  Element := TrouverElementParId(TagName, Code);
  if Element = nil then Exit;
  
  StringGridDetail.RowCount := 1;
  StringGridDetail.Columns[0].Title.Caption := GetTexteLibelle('LAB_002');  // Libellé
  StringGridDetail.Columns[1].Title.Caption := GetTexteLibelle('LAB_025');  // Valeur
  
  LabelFormTitle.Caption := Titre + ': ' + ValeurXML(Element.FindNode('Description'));
//  
  AjouterLigneDetail(GetTexteLibelle('LAB_001'), Code);                                    // Code
  AjouterLigneDetail(GetTexteLibelle('LAB_002'), ValeurXML(Element.FindNode('Description')));
  
  // Champs propres aux armes
  Valeur := ValeurXML(Element.FindNode('Skill'));
  if Valeur <> '' then
  begin
    Competence := ChercheCompetence(Valeur);
    if Competence.CodeCompetence <> '' then
      LibComp := Competence.Libelle
    else
      LibComp := Valeur;  // fallback, vaut souvent '-'
    AjouterLigneDetail(GetTexteLibelle('LAB_009'), LibComp);                               // Compétence
  end;
  
  // Dégâts : deux lignes, le bonus d'attribut et la valeur fixe
  Valeur := ValeurXML(Element.FindNode('Damage'));
  if Valeur <> '' then
  begin
    if DecouperDegats(Valeur, CodeBonus, Fixe) then
      AjouterLigneDetail(GetTexteLibelle('LAB_159') + ' - ' + GetTexteLibelle(CodeBonus), '✓')
    else
      AjouterLigneDetail(GetTexteLibelle('LAB_159') + ' - ' + GetTexteLibelle('LAB_034'), '');
    
    AjouterLigneDetail(GetTexteLibelle('LAB_159') + ' - ' + GetTexteLibelle('LAB_025'), Fixe);
  end;
  
  AjouterLigneDetail(GetTexteLibelle('LAB_057'),
                     TraduireCodesMultiples(ValeurXML(Element.FindNode('Reach'))));    // Portée
  AjouterLigneDetail(GetTexteLibelle('LAB_053'), ValeurXML(Element.FindNode('Hand')));     // Mains
  AjouterLigneDetail(GetTexteLibelle('LAB_060'), ValeurXML(Element.FindNode('Ammunition'))); // Munitions
  
  // Champs propres aux armures
  AjouterLigneDetail(GetTexteLibelle('LAB_075'),
                     TraduireCodesMultiples(ValeurXML(Element.FindNode('Location'))));     // Emplacement
  AjouterLigneDetail(GetTexteLibelle('LAB_076'), ValeurXML(Element.FindNode('ArmorPoint'))); // Protection
  AjouterLigneDetail(GetTexteLibelle('LAB_074'),
                     TraduireCodesMultiples(ValeurXML(Element.FindNode('Type'))));         // Type matériel
  
  // Champs communs
  AjouterLigneDetail(GetTexteLibelle('LAB_056'),
                     TraduireCodesMultiples(ValeurXML(Element.FindNode('Availability'))));  // Disponibilité
  AjouterLigneDetail(GetTexteLibelle('LAB_054'), ValeurXML(Element.FindNode('Price')));     // Prix
  AjouterLigneDetail(GetTexteLibelle('LAB_055'), ValeurXML(Element.FindNode('Encumbrance'))); // Encombrement
  AjouterLignesQualite(ValeurXML(Element.FindNode('Quality')), PrefixeLivre(Code));         // Qualité
  
  CodeDonneeSelectionnee := Code;
  
  AdjustGridColumnsWidth(StringGridDetail, 0, False, False, True, 10, 10, ssAutoBoth);
  
  // La grille de détail a une hauteur variable : on place celle des qualités
  // juste en dessous, une fois l'ajustement fait.
  if StringGridQualites.RowCount > 1 then
  begin
    StringGridQualites.Top := StringGridDetail.Top + StringGridDetail.Height + 15;
    AdjustGridColumnsWidth(StringGridQualites, 0, False, False, True, 10, 10, ssAutoBoth);
    StringGridQualites.Visible := True;
  end;
end;

// ========== AFFICHER TIRAGE ALÉATOIRE DE RACE ==========
// Chaque livre définit ses propres tranches de dé pour tirer une race.
// La grille part de ListRace pour montrer TOUTES les races connues, y compris
// celles que ce livre ne propose pas au tirage : on voit ainsi d'un coup d'œil
// ce qui est couvert et ce qui ne l'est pas.
procedure TWinLivres.AfficherTirageRace();
var
  Chapitres, Elements: TDOMNodeList;
  I, RowIdx, TiretPos, PipePos: Integer;
  Race: StructureRace;
  Tranches, Tri: TStringList;
  Plage, Debut, Fin, Ligne, Cle, Code, Libelle, LivreStr: String;
begin
  MasquerAfficherElements('TIRAGE_RACE');
  MasquerForm();
  
  if ListRace = nil then Exit;
  if XMLDoc = nil then Exit;
  
  StringGridRandomRace.RowCount := 1;
  StringGridRandomRace.Columns[0].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  StringGridRandomRace.Columns[1].Title.Caption := GetTexteLibelle('LAB_002');  // Libellé
  StringGridRandomRace.Columns[2].Title.Caption := GetTexteLibelle('LAB_128');  // Livre
  StringGridRandomRace.Columns[3].Title.Caption := GetTexteLibelle('LAB_141');  // Début
  StringGridRandomRace.Columns[4].Title.Caption := GetTexteLibelle('LAB_142');  // Fin
  
  // Tranches définies par ce livre : "CODE=01-90"
  Tranches := TStringList.Create;
  Tri      := TStringList.Create;
  try
    Chapitres := XMLDoc.GetElementsByTagName('DATA_RANDOM_SPECIE');
    if Chapitres.Count > 0 then
    begin
      Elements := TDOMElement(Chapitres.Item[0]).GetElementsByTagName('Specie');
      for I := 0 to Elements.Count - 1 do
      begin
        Code := TDOMElement(Elements.Item[I]).GetAttribute('name');
        if Code <> '' then
          Tranches.Values[Code] := ValeurXML(Elements.Item[I]);
      end;
    end;
    
    // Clé de tri : les races tirables d'abord, par tranche croissante,
    // puis les autres par libellé.
    for I := 0 to ListRace.Count - 1 do
    begin
      Race := ListRace[I];
      if Race.CodeRace = '' then Continue;
      
      Plage := Tranches.Values[Race.CodeRace];
      
      if Plage <> '' then
      begin
        TiretPos := Pos('-', Plage);
        if TiretPos > 0 then
        begin
          Debut := Trim(Copy(Plage, 1, TiretPos - 1));
          Fin   := Trim(Copy(Plage, TiretPos + 1, Length(Plage)));
        end
        else
        begin
          // Valeur unique : même début et même fin
          Debut := Plage;
          Fin   := Plage;
        end;
        
        // Cadrage sur 3 chiffres pour que le tri reste numérique
        Cle := '0' + Format('%.3d', [StrToIntDef(Debut, 0)]);
      end
      else
      begin
        Debut := '';
        Fin   := '';
        Cle   := '1' + Race.Libelle;
      end;
      
      Tri.Add(Cle + '|' + Race.CodeRace + '|' + Race.Libelle + '|' +
              GetTexteLibelle(Race.Livre, '', '', True) + '|' + Debut + '|' + Fin);
    end;
    
    Tri.Sort;
    
    StringGridRandomRace.RowCount := Tri.Count + 1;
    RowIdx := 1;
    
    for I := 0 to Tri.Count - 1 do
    begin
      Ligne := Tri[I];
      
      PipePos := Pos('|', Ligne);                                  // clé de tri, ignorée
      Ligne   := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      PipePos := Pos('|', Ligne);
      Code    := Copy(Ligne, 1, PipePos - 1);
      Ligne   := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      PipePos := Pos('|', Ligne);
      Libelle := Copy(Ligne, 1, PipePos - 1);
      Ligne   := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      PipePos  := Pos('|', Ligne);
      LivreStr := Copy(Ligne, 1, PipePos - 1);
      Ligne    := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      PipePos := Pos('|', Ligne);
      Debut   := Copy(Ligne, 1, PipePos - 1);
      Fin     := Copy(Ligne, PipePos + 1, Length(Ligne));
      
      StringGridRandomRace.Cells[1, RowIdx] := Code;
      StringGridRandomRace.Cells[2, RowIdx] := Libelle;
      StringGridRandomRace.Cells[3, RowIdx] := LivreStr;
      StringGridRandomRace.Cells[4, RowIdx] := Debut;
      StringGridRandomRace.Cells[5, RowIdx] := Fin;
      
      Inc(RowIdx);
    end;
  finally
    Tri.Free;
    Tranches.Free;
  end;
  
  AdjustGridColumnsWidth(StringGridRandomRace, 0, False, False, True, 10, 10, ssAutoBoth);
end;

// ========== AFFICHER DONNÉE SORT ==========
// Remplit la grille secondaire avec les talents qui donnent accès au sort.
// Même grille que les qualités d'équipement : un sort n'a pas de qualité et
// une arme n'a pas de talent, les deux usages ne se croisent jamais.
procedure TWinLivres.AjouterLignesTalentsSort(Valeur: String);
var
  Codes: TStringList;
  I, Ligne: Integer;
  CodeT, LibT: String;
  Element: TDOMElement;
begin
  StringGridQualites.RowCount := 1;
  StringGridQualites.Columns[0].Title.Caption := GetTexteLibelle('LAB_007');  // Talent
  StringGridQualites.Columns[1].Title.Caption := GetTexteLibelle('LAB_001');  // Code
  
  if Valeur = '' then Exit;
  
  Codes := TStringList.Create;
  try
    Codes.Delimiter       := ',';
    Codes.StrictDelimiter := True;
    Codes.DelimitedText   := Valeur;
    
    for I := 0 to Codes.Count - 1 do
    begin
      CodeT := Trim(Codes[I]);
      if CodeT = '' then Continue;
      
      // Les codes sont ici complets, préfixe compris
      LibT := CodeT;
      Element := TrouverElementParId('Talent', CodeT);
      if Element <> nil then
        LibT := ValeurXML(Element.FindNode('Description'));
      
      Ligne := StringGridQualites.RowCount;
      StringGridQualites.RowCount := Ligne + 1;
      StringGridQualites.Cells[1, Ligne] := LibT;
      StringGridQualites.Cells[2, Ligne] := CodeT;
    end;
  finally
    Codes.Free;
  end;
end;

procedure TWinLivres.AfficherDonneeSort(Code, Titre: String);
var
  Element: TDOMElement;
  Explication: String;
begin
  MasquerAfficherElements('DETAIL');
  MasquerForm();
  
  Element := TrouverElementParId('Sort', Code);
  if Element = nil then Exit;
  
  StringGridDetail.RowCount := 1;
  StringGridDetail.Columns[0].Title.Caption := GetTexteLibelle('LAB_002');  // Libellé
  StringGridDetail.Columns[1].Title.Caption := GetTexteLibelle('LAB_025');  // Valeur
  
  LabelFormTitle.Caption := Titre + ': ' + ValeurXML(Element.FindNode('Description'));
  
  AjouterLigneDetail(GetTexteLibelle('LAB_001'), Code);                                      // Code
  AjouterLigneDetail(GetTexteLibelle('LAB_002'), ValeurXML(Element.FindNode('Description')));
  AjouterLigneDetail(GetTexteLibelle('LAB_116'), ValeurXML(Element.FindNode('TypSpell')));    // Type de sort
  AjouterLigneDetail(GetTexteLibelle('LAB_108'), ValeurXML(Element.FindNode('Target')));      // Cible
  AjouterLigneDetail(GetTexteLibelle('LAB_109'), ValeurXML(Element.FindNode('Duration')));    // Durée
  AjouterLigneDetail(GetTexteLibelle('LAB_057'), ValeurXML(Element.FindNode('Range')));       // Portée
  AjouterLigneDetail(GetTexteLibelle('LAB_019'), ValeurXML(Element.FindNode('Level')));       // Niveau
  
  // Talents donnant accès au sort : liste variable, donc grille à part
  AjouterLignesTalentsSort(ValeurXML(Element.FindNode('Talent')));
  
  CodeDonneeSelectionnee := Code;
  
  AdjustGridColumnsWidth(StringGridDetail, 0, False, False, True, 10, 10, ssAutoBoth);
  
  if StringGridQualites.RowCount > 1 then
  begin
    StringGridQualites.Top := StringGridDetail.Top + StringGridDetail.Height + 15;
    AdjustGridColumnsWidth(StringGridQualites, 0, False, False, True, 10, 10, ssAutoBoth);
    StringGridQualites.Visible := True;
  end;
  
  // Explication sous les grilles, dont la hauteur varie
  Explication := ValeurXML(Element.FindNode('Explanation'));
  if Explication <> '' then
  begin
    MemoDetail.Text := Explication;
    
    if StringGridQualites.Visible then
      MemoDetail.Top := StringGridQualites.Top + StringGridQualites.Height + 15
    else
      MemoDetail.Top := StringGridDetail.Top + StringGridDetail.Height + 15;
    
    MemoDetail.Visible := True;
  end;
end;

// ========== AFFICHER DONNÉE QUALITÉ (BonusMalus) ==========
// Réutilise les deux emplacements libres du formulaire en changeant leur
// intitulé : une qualité n'a ni compétence ni maximum, mais un résumé et
// un modificateur. Chaque procédure d'affichage pose ses propres intitulés,
// pour qu'aucune ne dépende de l'écran précédent.
procedure TWinLivres.AfficherDonneeBonusMalus(Code, Titre: String);
var
  Element: TDOMElement;
  Valeur: String;
begin
  MasquerAfficherElements('');
  NettoyerForm();
  
  Element := TrouverElementParId('BonusMalus', Code);
  if Element = nil then
  begin
    MasquerForm();
    Exit;
  end;
  
  LabelFormTitle.Caption := Titre + ': ' + ValeurXML(Element.FindNode('Description'));
  
  EditFormCode.Text := Code;
  EditFormLib.Text  := ValeurXML(Element.FindNode('Description'));
  
  LabelFormCode.Visible := True;
  EditFormCode.Visible := True;
  LabelFormLib.Visible := True;
  EditFormLib.Visible := True;
  
  // Résumé
  Valeur := ValeurXML(Element.FindNode('Short'));
  if Valeur <> '' then
  begin
    LabelFormCompPrinc.Caption := GetTexteLibelle('LAB_073');  // 'Résumé'
    EditFormCompPrinc.Text := Valeur;
    LabelFormCompPrinc.Visible := True;
    EditFormCompPrinc.Visible := True;
  end;
  
  // Modificateur : '+' pour un bonus, '-' pour un malus
  Valeur := ValeurXML(Element.FindNode('Modifier'));
  if Valeur <> '' then
  begin
    LabelFormMax.Caption := GetTexteLibelle('LAB_034');  // 'Bonus'
    EditFormMax.Text := Valeur;
    LabelFormMax.Visible := True;
    EditFormMax.Visible := True;
  end;
  
  // Explication
  Valeur := ValeurXML(Element.FindNode('Explanation'));
  if Valeur <> '' then
  begin
    MemoFormDesc.Text := Valeur;
    LabelFormDesc.Visible := True;
    MemoFormDesc.Visible := True;
  end;
  
  CodeDonneeSelectionnee := Code;
  
  GroupBoxForm.Visible := True;
end;

// ========== AFFICHER DONNÉE TALENT ==========
// Sert pour DATA_TALENT et DATA_TALENT_SPECIALIZATION. Comme pour les
// compétences, on n'affiche que les champs réellement renseignés : certains
// talents ont un <Attribut>""</Attribut> ou un <Skill>""</Skill> vide.
procedure TWinLivres.AfficherDonneeTalent(CodeTalent, Titre: String);
var
  TalentElement: TDOMElement;
  Valeur, LibComp: String;
  Competence: StructureCompetence;
begin
  MasquerAfficherElements('');  // Masquer les grids
  NettoyerForm();
  
  TalentElement := TrouverElementParId('Talent', CodeTalent);
  if TalentElement = nil then
  begin
    MasquerForm();
    Exit;
  end;
  
  LabelFormTitle.Caption := Titre + ': ' +
                            ValeurXML(TalentElement.FindNode('Description'));
  
  EditFormCode.Text := CodeTalent;
  EditFormLib.Text  := ValeurXML(TalentElement.FindNode('Description'));
  
  LabelFormCode.Visible := True;
  EditFormCode.Visible := True;
  LabelFormLib.Visible := True;
  EditFormLib.Visible := True;
  
  // Attribut lié
  Valeur := ValeurXML(TalentElement.FindNode('Attribut'));
  if Valeur <> '' then
  begin
    EditFormAttribut.Text := GetAttributLabel(Valeur);
    LabelFormAttribut.Visible := True;
    EditFormAttribut.Visible := True;
  end;
  
  // Compétence liée
  LabelFormCompPrinc.Caption := GetTexteLibelle('LAB_009');  // 'Compétence'
  Valeur := ValeurXML(TalentElement.FindNode('Skill'));
  if Valeur <> '' then
  begin
    Competence := ChercheCompetence(Valeur);
    if Competence.CodeCompetence <> '' then
      LibComp := Competence.Libelle
    else
      LibComp := Valeur;  // fallback
    
    EditFormCompPrinc.Text := LibComp;
    LabelFormCompPrinc.Visible := True;
    EditFormCompPrinc.Visible := True;
  end;
  
  // Maximum
  LabelFormMax.Caption := GetTexteLibelle('LAB_044');  // 'Max'
  Valeur := ValeurXML(TalentElement.FindNode('Max'));
  if Valeur <> '' then
  begin
    EditFormMax.Text := Valeur;
    LabelFormMax.Visible := True;
    EditFormMax.Visible := True;
  end;
  
  // Explication
  Valeur := ValeurXML(TalentElement.FindNode('Explanation'));
  if Valeur <> '' then
  begin
    MemoFormDesc.Text := Valeur;
    LabelFormDesc.Visible := True;
    MemoFormDesc.Visible := True;
  end;
  
  CodeDonneeSelectionnee := CodeTalent;
  
  GroupBoxForm.Visible := True;
end;

// ========== AFFICHER DONNÉE COMPÉTENCE ==========
// Sert pour DATA_SKILL et DATA_SKILL_SPECIALIZATION : une spécialisation
// n'a qu'un libellé, donc on n'affiche que les champs réellement présents.
procedure TWinLivres.AfficherDonneeCompetence(CodeComp, Titre: String);
var
  SkillElement: TDOMElement;
  CodeAttr, Explication: String;
begin
  MasquerAfficherElements('');  // Masquer les grids
  NettoyerForm();
  
  SkillElement := TrouverElementParId('Skill', CodeComp);
  if SkillElement = nil then
  begin
    MasquerForm();
    Exit;
  end;
  
  LabelFormTitle.Caption := Titre + ': ' +
                            ValeurXML(SkillElement.FindNode('Description'));
  
  EditFormCode.Text := CodeComp;
  EditFormLib.Text  := ValeurXML(SkillElement.FindNode('Description'));
  
  LabelFormCode.Visible := True;
  EditFormCode.Visible := True;
  LabelFormLib.Visible := True;
  EditFormLib.Visible := True;
  
  // Attribut lié : absent des spécialisations
  CodeAttr := ValeurXML(SkillElement.FindNode('Attribut'));
  if CodeAttr <> '' then
  begin
    EditFormAttribut.Text := GetAttributLabel(CodeAttr);
    LabelFormAttribut.Visible := True;
    EditFormAttribut.Visible := True;
  end;
  
  // Explication : absente des spécialisations
  Explication := ValeurXML(SkillElement.FindNode('Explanation'));
  if Explication <> '' then
  begin
    MemoFormDesc.Text := Explication;
    LabelFormDesc.Visible := True;
    MemoFormDesc.Visible := True;
  end;
  
  CodeDonneeSelectionnee := CodeComp;
  
  GroupBoxForm.Visible := True;
end;

procedure TWinLivres.AfficherDonneeMetier(CareerCode: String);
var
  CareerElement: TDOMElement;
  Classe, CodeComp, LibComp: String;
  Competence: StructureCompetence;
begin
  MasquerAfficherElements('');  // Masquer les grids
  NettoyerForm();
  
  CareerElement := TrouverCareerElement(CareerCode);
  if CareerElement = nil then
  begin
    MasquerForm();
    Exit;
  end;
  
  LabelFormTitle.Caption := GetTexteLibelle('LAB_006') + ': ' +
                            ValeurXML(CareerElement.FindNode('Description'));
  
  EditFormCode.Text := CareerCode;
  EditFormLib.Text  := ValeurXML(CareerElement.FindNode('Description'));
  MemoFormDesc.Text := ValeurXML(CareerElement.FindNode('Explanation'));
  
  // Classe du métier : le XML porte un code (CLASS_BURG), traduit à l'affichage
  Classe := ValeurXML(CareerElement.FindNode('Class'));
  if Classe <> '' then
    EditFormClasse.Text := GetTexteLibelle(Classe)
  else
    EditFormClasse.Text := '';
  
  // Compétence principale du métier
  LabelFormCompPrinc.Caption := GetTexteLibelle('LAB_009');  // 'Compétence'
  CodeComp := ValeurXML(CareerElement.FindNode('Skill'));
  LibComp  := '';
  if CodeComp <> '' then
  begin
    Competence := ChercheCompetence(CodeComp);
    if Competence.CodeCompetence <> '' then
      LibComp := Competence.Libelle
    else
      LibComp := CodeComp;  // fallback
  end;
  EditFormCompPrinc.Text := LibComp;
  
  CodeDonneeSelectionnee := CareerCode;
  
  // Champs communs
  LabelFormCode.Visible := True;
  EditFormCode.Visible := True;
  LabelFormLib.Visible := True;
  EditFormLib.Visible := True;
  LabelFormDesc.Visible := True;
  MemoFormDesc.Visible := True;
  
  // Champs propres au métier
  LabelFormClasse.Visible := True;
  EditFormClasse.Visible := True;
  LabelFormCompPrinc.Visible := True;
  EditFormCompPrinc.Visible := True;
  
  GroupBoxForm.Visible := True;
end;

procedure TWinLivres.NettoyerForm();
begin
  EditFormCode.Clear;
  EditFormLib.Clear;
  MemoFormDesc.Clear;
  EditFormClasse.Clear;
  EditFormCompPrinc.Clear;
  EditFormAttribut.Clear;
  EditFormMax.Clear;
  EditFormAttrName.Clear;
  EditFormAttrDices.Clear;
  EditFormAttrBaseValue.Clear;
  EditFormAttrFormula.Clear;
  EditFormComponent1Attr.Clear;
  EditFormComponent1Coeff.Clear;
  EditFormComponent2Attr.Clear;
  EditFormComponent2Coeff.Clear;
  EditFormComponent3Attr.Clear;
  EditFormComponent3Coeff.Clear;
  CodeDonneeSelectionnee := '';
  
  // Hide all controls by default
  LabelFormClasse.Visible := False;
  EditFormClasse.Visible := False;
  LabelFormAttribut.Visible := False;
  EditFormAttribut.Visible := False;
  LabelFormMax.Visible := False;
  EditFormMax.Visible := False;
  LabelFormCompPrinc.Visible := False;
  EditFormCompPrinc.Visible := False;
  LabelFormCode.Visible := False;
  EditFormCode.Visible := False;
  LabelFormLib.Visible := False;
  EditFormLib.Visible := False;
  LabelFormDesc.Visible := False;
  MemoFormDesc.Visible := False;
  LabelFormAttrName.Visible := False;
  EditFormAttrName.Visible := False;
  LabelFormAttrDices.Visible := False;
  EditFormAttrDices.Visible := False;
  LabelFormAttrBaseValue.Visible := False;
  EditFormAttrBaseValue.Visible := False;
  LabelFormAttrFormula.Visible := False;
  EditFormAttrFormula.Visible := False;
  
  // Hide component controls
  LabelFormComponent1.Visible := False;
  EditFormComponent1Attr.Visible := False;
  EditFormComponent1Coeff.Visible := False;
  LabelFormComponent2.Visible := False;
  EditFormComponent2Attr.Visible := False;
  EditFormComponent2Coeff.Visible := False;
  LabelFormComponent3.Visible := False;
  EditFormComponent3Attr.Visible := False;
  EditFormComponent3Coeff.Visible := False;
  
  // Hide skills grid
  LabelFormSkills.Visible := False;
  StringGridCareers.Visible := False;
end;

procedure TWinLivres.MasquerForm();
begin
  GroupBoxForm.Visible := False;
  LabelFormSkills.Visible := False;
  StringGridCareers.Visible := False;
  
  // Vérifier avant d'accéder aux contrôles talents
  if LabelTalentsRandom <> nil then
    LabelTalentsRandom.Visible := False;
  if TreeViewTalents <> nil then
    TreeViewTalents.Visible := False;
    
  LabelFormTitle.Caption := GetTexteLibelle('LAB_004');
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
