unit WinLivre;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls, Menus,
  Dialogs, Graphics, BCButton, ChargeConstantes, ChargeTexte, ChargeCompetence, ChargeTalent, UnitCalcul, Grids,
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
    
  private
    // Variables
    XMLDoc: TXMLDocument;
    RacesDataList: TRaceDataMap;
    AttributesDataList: TAttributDataMap;  // Attributs de la race actuelle
    AttributeValuesMap: TStringList;  // Map attribute codes to raw values
    RaceLibelleToCodeMap: TStringList;  // Map race label to code
    RaceSkillsData: TStringList;        // Compétences de la race sélectionnée
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
    procedure LoadTalentsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
    procedure LoadSkillsForRace(RaceElement: TDOMElement; RaceCode: String);
    procedure AfficherSkillsForRace(RaceCode: String);
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

// ✨ ÉVÉNEMENTS FORM

procedure TWinLivres.FormCreate(Sender: TObject);
begin
  RacesDataList := TRaceDataMap.Create;
  AttributesDataList := TAttributDataMap.Create;
  AttributeValuesMap := TStringList.Create;
  RaceLibelleToCodeMap := TStringList.Create;
  RaceSkillsData := TStringList.Create;
  NodeSelectionnee := nil;
  TypeNodeSelectionnee := '';
  CodeDonneeSelectionnee := '';
  CurrentRaceCode := '';
  CurrentAttributeValue := '';
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
  NodeAttributes.Data := Pointer(PtrInt(0));  // 0 = chapitre
  
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
      NodeAttr.Data := Pointer(PtrInt(2));  // 2 = attribut
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
  NodeSkills.Data := Pointer(PtrInt(3));  // 3 = skills chapter
  
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
          NodeSkill.Data := Pointer(PtrInt(4));  // 4 = skill item
          // Store code in ImageIndex for retrieval (not in Text which would overwrite the label)
          // NodeSkill.ImageIndex not used, safe to use for storage
        end;
      end;
    end;
  end;
end;

// ========== CHARGER TALENTS POUR RACE ==========
procedure TWinLivres.LoadTalentsForRaceTree(RaceElement: TDOMElement; RaceNode: TTreeNode);
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
  NodeTalents.Data := Pointer(PtrInt(5));  // 5 = talents chapter
  
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
            NodeTalent.Data := Pointer(PtrInt(6));  // 6 = random talent
          end
          
          // CASE 2: Choix multiple (contient "/")
          else if Pos('/', TalentCode) > 0 then
          begin
            // Créer nœud "{Au choix}"
            NodeChoice := TreeViewLivre.Items.AddChild(NodeTalents, GetTexteLibelle('LAB_127'));
            NodeChoice.Data := Pointer(PtrInt(7));  // 7 = choice node
            
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
                NodeTalent.Data := Pointer(PtrInt(8));  // 8 = talent choice item
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
              NodeTalent.Data := Pointer(PtrInt(8));  // 8 = talent item
            end;
          end;
        end;
      end;
    finally
      TalentParts.Free;
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
    
    FileName := ExtractFileName(AFilePath);  // "BOOK RULESBOOK.Xml"
    FileCode := Copy(FileName, 1, Length(FileName) - 4);  // "BOOK RULESBOOK"

    // Récupérer le label traduit
    NodeRoot := TreeViewLivre.Items.Add(nil, GetBookLabel(FileCode));

    // Afficher le nom complet dans LabelLivre
    LabelLivre.Caption := GetTexteLibelle('LAB_128') + ': ' + FileName;

    // Afficher dans LabelFormTitle
    LabelFormTitle.Caption := GetTexteLibelle('LAB_128') + ': ' + FileName;
    NodeRoot.Data := Pointer(PtrInt(0));  // 0 = chapitre
    
    // ========== RACES ==========
    NodeRaces := TreeViewLivre.Items.AddChild(NodeRoot, GetTexteLibelle('LAB_042'));
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
            NodeRace := TreeViewLivre.Items.AddChild(NodeRaces, RaceData.Libelle);
            NodeRace.Data := Pointer(PtrInt(1));  // 1 = donnée
            // Store mapping of label to code
            RaceLibelleToCodeMap.Values[RemoveQuotes(RaceData.Libelle)] := Code;
            
            // ========== CHARGER LES ATTRIBUTS DE CETTE RACE ==========
            LoadAttributesForRace(XMLElement, NodeRace, Code);
            
            // ========== CHARGER LES COMPÉTENCES DE CETTE RACE DANS L'ARBRE ==========
            LoadSkillsForRaceTree(XMLElement, NodeRace, Code);
            
            // ========== CHARGER LES TALENTS DE CETTE RACE DANS L'ARBRE ==========
            LoadTalentsForRaceTree(XMLElement, NodeRace);
          end;
      end;
    
    // ========== CARRIÈRES ==========
    NodeCareers := TreeViewLivre.Items.AddChild(NodeRoot, GetTexteLibelle('LAB_006'));
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
  CleanedLabel: String;
  RaceCodeFound: String;
begin
  if Node = nil then Exit;
  
  NodeSelectionnee := Node;
  
  // Vérifier le type de nœud basé sur Node.Data
  case PtrInt(Node.Data) of
    0: begin
         // C'est un chapitre (Races, Attributes, Careers, etc.)
         TypeNodeSelectionnee := 'CHAPITRE';
         MasquerForm();
       end;
    1: begin
         // C'est une race
         TypeNodeSelectionnee := 'DONNEE';
         CurrentRaceCode := RaceLibelleToCodeMap.Values[Node.Text];
         LabelFormTitle.Caption := GetTexteLibelle('LAB_042') + ': ' + Node.Text;
         AfficherDonneeRace(CurrentRaceCode);
       end;
    2: begin
         // C'est un attribut
         TypeNodeSelectionnee := 'ATTRIBUT';
         // Extract raw value from "Label: Value" format
         CurrentAttributeValue := Copy(Node.Text, Pos(': ', Node.Text) + 2, Length(Node.Text));
         // Display attribute name in title
         LabelFormTitle.Caption := Copy(Node.Text, 1, Pos(': ', Node.Text) - 1);
         AfficherDonneeAttribut(CurrentAttributeValue);
       end;
    3: begin
         // C'est une branche "Compétences de race"
         TypeNodeSelectionnee := 'CHAPITRE';
         // Afficher toutes les compétences de la race parente
         if Node.Parent <> nil then
         begin
           // Remove quotes from Node.Parent.Text to match RaceLibelleToCodeMap keys
           CleanedLabel := StringReplace(Node.Parent.Text, '"', '', [rfReplaceAll]);
           RaceCodeFound := RaceLibelleToCodeMap.Values[CleanedLabel];
           
           LabelFormTitle.Caption := GetTexteLibelle('LAB_087') + ': ' + Node.Parent.Text;
           
           if RaceCodeFound <> '' then
             AfficherSkillsForRace(RaceCodeFound);
         end
         else
           MasquerForm();
       end;
    4: begin
         // C'est un item "Compétence"
         TypeNodeSelectionnee := 'COMPETENCE';
         LabelFormTitle.Caption := Node.Text;
         // Pour l'instant, juste afficher le nom
         MasquerForm();
       end;
  else
    MasquerForm();
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
    
    LabelFormSkills.Visible := True;
    StringGridSkills.Visible := True;
  end
  else
  begin
    LabelFormSkills.Visible := False;
    StringGridSkills.Visible := False;
  end;
  
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
    Rows[I - 1].Code := StringGridSkills.Cells[1, I];
    Rows[I - 1].Label_ := StringGridSkills.Cells[2, I];
    Rows[I - 1].Specialization := StringGridSkills.Cells[3, I];
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
        NeedSwap := True  // ✓ après vide = besoin swap
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
    StringGridSkills.Cells[1, I] := Rows[I - 1].Code;
    StringGridSkills.Cells[2, I] := Rows[I - 1].Label_;
    StringGridSkills.Cells[3, I] := Rows[I - 1].Specialization;
    StringGridSkills.Cells[4, I] := Rows[I - 1].Selected;
  end;
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

procedure TWinLivres.NettoyerForm();
begin
  EditFormCode.Clear;
  EditFormLib.Clear;
  MemoFormDesc.Clear;
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
  StringGridSkills.Visible := False;
end;

procedure TWinLivres.MasquerForm();
begin
  GroupBoxForm.Visible := False;
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
