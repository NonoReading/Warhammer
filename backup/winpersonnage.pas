unit WinPersonnage;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}
interface


uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, ComCtrls, LCLIntf, Spin, MaskEdit, Math, BGRABitmap, BGRABitmapTypes,
  BCButton, BCLabel, ChargeConstantes, ChargeRace, ChargeRaceAttribut,
  UnitCalcul, ChargeMetier, ChargeMetierAttribut, ChargeTalent,
  ChargeMetierTalent, ChargeMetierNiveau, ChargeCompetence, ChargeLivre,
  ChargeAttributAugmentation, ChargeAttribut, ChargeCompetenceAugmentation,
  GlobalFonts, ChargeArme, ChargeArmure, ChargeMetierEquipement,
  WinMetier, UnitEquipement, WinWeapon, WinArmor, ChargeArmureSimplifie,
  ChargeSort, WinSpell, ChargeTexte, winFabrication, ChargeFabrication,
  WinTalent, WinCompetence, WinSpecialisation, ChargePersonnage,
  ChargeMetierCompetence, PdfPersonnage, Types;
type

  { TWinPersonnages }

  TTabControlDrawer = class
    procedure DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const ARect: TRect; Active: Boolean);
  end;

  TWinPersonnages = class(TForm)
    EditHairColors: TEdit;
    EditEyeColors: TEdit;
    EditHeight: TEdit;
    ButtonArme: TBCButton;
    ButtonArmure: TBCButton;
    ButtonAugmentation: TBCButton;
    ButtonDelete: TBCButton;
    ButtonFabrication: TBCButton;
    ButtonHistorique: TBCButton;
    ButtonPdf: TBCButton;
    ButtonRaceSelectionner: TBCButton;
    ButtonSauvegarde: TBCButton;
    ButtonLigneGauche: TButton;
    ButtonSort: TBCButton;
    CheckBoxCalcul: TCheckBox;
    CheckBoxQuickArmor: TCheckBox;
    CheckBoxXp: TCheckBox;
    CheckBoxPdfFeldo2p: TCheckBox;
    CheckBoxXpDiv25: TCheckBox;
    EditAge: TEdit;
    EditNeedTheoXp: TSpinEdit;
    EditNeedRealXp: TSpinEdit;
    EditTotalXp: TEdit;
    EditTotalXp25: TEdit;
    ImageBackMetier: TImage;
    ImageMetier: TImage;
    ImageRace1: TImage;
    ImageRace2: TImage;
    ImageBackRace: TImage;
    ImageSheetPage: TImage;
    ImageSheetXp: TImage;
    ImageWar: TImage;
    ImageSheetTitle: TImage;
    LabAugmentation: TBCLabel;
    LabelPdfFeldo2p: TLabel;
    LabQuickArmor: TLabel;
    LabEquipement: TBCLabel;
    LabelMetier: TBCLabel;
    LabelNeedRealXp: TEdit;
    LabelNeedTheoXp: TEdit;
    LabelRace: TBCLabel;
    LabelXp: TLabel;
    LabelXpDiv25: TEdit;
    LabEyeColors: TBCLabel;
    LabHeight: TBCLabel;
    LabTabAttribut: TBCLabel;
    LabTabAvancement: TBCLabel;
    LabTabCarriere: TBCLabel;
    LabAge: TBCLabel;
    LabTabCompetence: TBCLabel;
    LabTabExperience: TBCLabel;
    LabelCalcul: TLabel;
    LabHairColors: TBCLabel;
    LabTabNiveau: TBCLabel;
    LabTabTalent: TBCLabel;
    PageExperience: TPageControl;
    LibMetier: TEdit;
    LibRace: TEdit;
    PersonnageNom: TBCLabel;
    RadioButtonChanger: TRadioButton;
    RadioButtonRAS: TRadioButton;
    RadioButtonSuivant: TRadioButton;
    RadioGroupEvolution: TRadioGroup;
    StaticTextPersonnage: TStaticText;
    TabAugmentationMjXp: TStringGrid;
    TabLivre: TStringGrid;
    TabMJXp: TStringGrid;
    TabSheetMjCost: TTabSheet;
    TabSheetLivre: TTabSheet;
    TabSort: TStringGrid;
    TabEquipement: TStringGrid;
    TabHistorique: TStringGrid;
    TabAugmentationTalent: TStringGrid;
    TabAugmentationCompetence: TStringGrid;
    TabAugmentationAttribut: TStringGrid;
    TabExperience: TStringGrid;
    TabAvancement: TStringGrid;
    TabCarriere: TStringGrid;
    TabCompetence: TStringGrid;
    TabMetierEquipement: TStringGrid;
    TabNiveau: TStringGrid;
    TabSheetAttribut: TTabSheet;
    TabSheetCompetence: TTabSheet;
    TabSheetTalent: TTabSheet;
    TabSheetXP: TTabSheet;
    TabSheetEvolution: TTabSheet;
    TabSheetHistorique: TTabSheet;
    TabTalent: TStringGrid;
    TabAttribut: TStringGrid;
    ToggleBoxGauche: TToggleBox;
    ToggleBoxDroite: TToggleBox;

  // Générales
  procedure EditAgeKeyPress(Sender: TObject; var Key: char);
  procedure ButtonArmureClick({%H-}Sender: TObject);
  procedure ButtonArmeClick({%H-}Sender: TObject);
  procedure ButtonFabricationClick({%H-}Sender: TObject);
  procedure ButtonDeleteClick({%H-}Sender: TObject);
  procedure ButtonHistoriqueClick({%H-}Sender: TObject);
  procedure ButtonQuitterClick({%H-}Sender: TObject);
  procedure ButtonRaceSelectionnerClick({%H-}Sender: TObject);
  procedure ButtonSortClick({%H-}Sender: TObject);
  procedure CheckBoxXpDiv25Change(Sender: TObject);
  procedure CheckBoxXpDiv25Click(Sender: TObject);
  procedure ComboBoxNvMetierChange({%H-}Sender: TObject);
  procedure EditTotalXp25KeyPress(Sender: TObject; var Key: char);
  procedure EditTotalXp25KeyUp(Sender: TObject; var Key: Word;
    Shift: TShiftState);
  procedure EditTotalXpKeyPress(Sender: TObject; var Key: char);
  procedure EditTotalXpKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
    );
  procedure FormClose({%H-}Sender: TObject; var {%H-}CloseAction: TCloseAction);
  procedure FormCreate({%H-}Sender: TObject);
  procedure AjustePositionTables();
  procedure EditHeightKeyPress(Sender: TObject; var Key: char);
  procedure PageExperienceChange({%H-}Sender: TObject);
  procedure RadioButtonRASChange({%H-}Sender: TObject);
  procedure RadioButtonSuivantChange({%H-}Sender: TObject);
  procedure StaticTextPersonnageClick(Sender: TObject);
  procedure TabAttributDrawCell({%H-}Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
  procedure TabAttributSelectEditor({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer;
    var Editor: TWinControl);
  procedure TabAugmentationAttributEditingDone({%H-}Sender: TObject);
  procedure TabAugmentationAttributKeyUp({%H-}Sender: TObject; var Key: Word;
    {%H-}Shift: TShiftState);
  procedure TabAugmentationAttributMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure TabAugmentationCompetenceEditingDone({%H-}Sender: TObject);
  procedure TabAugmentationCompetenceKeyUp({%H-}Sender: TObject; var {%H-}Key: Word;
    {%H-}Shift: TShiftState);
  procedure TabAugmentationCompetenceMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure TabAugmentationTalentDblClick({%H-}Sender: TObject);
  procedure TabAugmentationTalentEditingDone({%H-}Sender: TObject);
  procedure TabAugmentationTalentKeyDown({%H-}Sender: TObject; var Key: Word;
    {%H-}Shift: TShiftState);
  procedure TabCarriereDblClick({%H-}Sender: TObject);
  procedure TabDrawCell(Sender: TObject; aCol, aRow: Integer;
    aRect: TRect; aState: TGridDrawState);
  Procedure ChargeImageNiveau(Niveau: Integer);
  function ChercherValeurParCode(const Chaine: string; const CodeRecherche: string): string;
  Procedure Initialisation();
  Procedure AugmentationAjouteXpMj(TypeDonnee: String);
  procedure CalculXpGlobal(Mode25: boolean);

  // Attribut
  procedure TabAugmentationAttributGetEditText({%H-}Sender: TObject; ACol,
    ARow: Integer; var Value: string);
  procedure TabAugmentationAttributSelectCell({%H-}Sender: TObject; {%H-}aCol,
    aRow: Integer; var {%H-}CanSelect: Boolean);
  procedure TabAugmentationAttributSelectEditor({%H-}Sender: TObject; aCol,
    aRow: Integer; var Editor: TWinControl);
  Procedure AttributInit();
  Procedure TabAugmentationAttributCalcul(ARow: Integer; var Value: string);

  // Compétences
  procedure TabAugmentationCompetenceGetEditText({%H-}Sender: TObject; ACol,
    ARow: Integer; var Value: string);
  procedure TabAugmentationCompetenceSelectCell({%H-}Sender: TObject; {%H-}aCol,
    aRow: Integer; var {%H-}CanSelect: Boolean);
  procedure TabAugmentationCompetenceSelectEditor({%H-}Sender: TObject; aCol,
    aRow: Integer; var Editor: TWinControl);
  procedure TabLivreDblClick({%H-}Sender: TObject);
  procedure TabMetierEquipementDblClick({%H-}Sender: TObject);
  procedure TabMetierEquipementSelectEditor({%H-}Sender: TObject; {%H-}aCol,
    {%H-}aRow: Integer; var Editor: TWinControl);
  procedure TabSheetMjCostContextPopup(Sender: TObject; MousePos: TPoint;
    var Handled: Boolean);
  procedure TabSortDblClick({%H-}Sender: TObject);
  procedure TabTalentDblClick({%H-}Sender: TObject);
  procedure TabAugmentationCompetenceCalcul(ARow: Integer; var Value: string);
  procedure TabAugmentationCompetenceDblClick({%H-}Sender: TObject);
  procedure TabCompetenceDblClick({%H-}Sender: TObject);

  // Talents
  procedure TalentAttribut(AttributTalent: String);
  procedure TabAugmentationTalentSelectEditor({%H-}Sender: TObject; aCol,
    aRow: Integer; var Editor: TWinControl);
  procedure TabAugmentationTalentGetEditText({%H-}Sender: TObject; ACol,
    ARow: Integer; var Value: string);
  procedure TabAugmentationTalentSelectCell({%H-}Sender: TObject; {%H-}aCol,
    aRow: Integer; var {%H-}CanSelect: Boolean);
  procedure TabAugmentationTalentCalcul(ARow: Integer; var Value: string);
  procedure TalentAsterisc();
  Procedure SortAffiche();

  // Expérience
  procedure CalculAvancement();
  function  CalculExperience(TypeXp: String; Gratuit: Integer; Total: Integer; Code:String; Tal: String): Integer;
  procedure CalculTableExperience();
  procedure CalculTotaux();
  procedure CalculXpNecessaire(ChangementClasse: Boolean);
  Function CalculXpMj(TypeDonnee: String; CodeDonnee:String): Integer;
  Function CalculTalComp(Debut: Integer; Fin: Integer; Talent:String): integer;
  Function CalculOptionXpDiv25(Xp: Integer): Integer;

  // Xml
  Function XmlDebut(TypeDonnee: string): String;
  Function XmlFin(TypeDonnee: string): String;
  Function XmlLigne(TypeDonnee: string; Valeur: String): String;
  Function XmlLigneDonnee(TypeDonnee: string; Valeur: String; Donnee: String): String;

  // Chargement
  function XmlPersonnageFichierActuel(const Directory: string): string;
  procedure XmlChargePersonnage(const FileName: string);
  procedure AfficheImageRace();
  procedure AfficheImageMetier();
  procedure NiveauMetierTalentMax();
  procedure ChargeAugmentation();
  procedure EffaceDonnee(Tableau: TStringGrid; NbLig: Integer);

  // Sauvegarde
  procedure ButtonSauvegardeClick({%H-}Sender: TObject);
  procedure MajTables();
  Procedure XmlSauvegarde();
  procedure ButtonAugmentationClick({%H-}Sender: TObject);
  procedure RadioButtonChangerChange({%H-}Sender: TObject);
  procedure CheckBoxCalculChange({%H-}Sender: TObject);
  procedure CheckBoxXpChange({%H-}Sender: TObject);
  Function VerifieLivre(ListeLivre: String; Livre: String): String;

  // PDF
  procedure ButtonPdfClick({%H-}Sender: TObject);

  //Equipement
  Procedure ChargerMetierEquipement(CodeMetier: String; NiveauMetier: Integer);
  Procedure TabEquipementAffiche();
  function XpSortCout(CodeSort: String): String;
  Procedure AfficheFabrication();
  Function ChoixNonFait(): Boolean;

  private
    FCurrentTabSheet: TTabSheet;

  public

  end;

var
  WinPersonnages: TWinPersonnages;
  // données générales en cours
  RaceEnCours:    String = '';
  RaceBlessure:   String = '';
  MetierEnCours:  String = '';
  MetierNvEnCours:String = '';
  MetierComplet:  String = '';
  WorkEnCours:    String = '';
  // gestion des images et couleurs
  picture:        TPicture;
  ListImage:      TImageList;
  Bitmap:         TBitmap;
  Path:           String;
  ColorLoc:       TColor;
  ColorList:      array of TColor;
  // attributs
  LigAttRace:     Integer = 1;
  LigAttLance:    Integer = 2;
  LigAttTalent:   Integer = 3;
  LigAttBase:     Integer = 4;
  LigAttImage:    Integer = 5;
  LigAttBonus:    Integer = 6;
  LigAttTotal:    Integer = 7;
  LigAttXp:       Integer = 8;
  LigAttActuel:   Integer = 9;
  LigAttCode:     Integer =10;
  LigAttAsterisc: Integer =11;
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
  ColAttSoc:      Integer =11;
  ColAttDestin:   Integer =12;
  ColAttResil:    Integer =13;
  ColAttBlessure: Integer =14;
  // compétences
  ColCompCode:    Integer = 1;
  ColCompImage:   Integer = 2;
  ColCompLib:     Integer = 3;
  ColCompCarac:   Integer = 4;
  ColCompAtt:     Integer = 5;
  ColComp35:      Integer = 6;
  ColComp40:      Integer = 7;
  ColCompWork:    Integer = 8;
  ColCompBonus:   Integer = 9;
  ColCompTotal:   Integer =10;
  ColCompStat:    Integer =11;
  ColCompXp:      Integer =12;
  ColCompActuel:  Integer =13;
  ColCompTravail: Integer =14;
  ColCompAsterisc:Integer =15;
  ColCompTalent:  Integer =16;
  // talent
  ColTalCode:     Integer = 1;
  ColTalLib:      Integer = 3;
  ColTalNb:       Integer = 4;
  ColTalMax:      Integer = 5;
  ColTalXp:       Integer = 6;
  ColTalAsterisk: Integer = 8;
  ColTalNbCrea:   Integer = 9;
  ColTalNbAugm:   Integer =10;

  // expérience
  LigXpTotal:     Integer = 1;
  LigXpDepense:   Integer = 2;
  LigXpRestant:   Integer = 3;
  LigXpCout:      Integer = 4;
  ColXpLib:       Integer = 1;
  ColXpDonnee:    Integer = 3;
  // augmentation attribut
  ColAugmAttCode:    Integer = 3;
  ColAugmAttActuel:  Integer = 4;
  ColAugmAttMoins5:  Integer = 5;
  ColAugmAttNouveau: Integer = 6;
  ColAugmAttPlus5:   Integer = 7;
  ColAugmAttCout:    Integer = 8;
  ColAugmAttReel:    Integer = 9;
  // augmentation compétence
  ColAugmCompCode:   Integer = 1;
  ColAugmCompLib:    Integer = 3;
  ColAugmCompActuel: Integer = 4;
  ColAugmCompMoins5: Integer = 5;
  ColAugmCompNouveau:Integer = 6;
  ColAugmCompPlus5:  Integer = 7;
  ColAugmCompCout:   Integer = 8;
  ColAugmCompSpe:    Integer = 9;
  ColAugmCompSpeSel: Integer =10;
  ColAugmCompWork:   Integer =11;
  ColAugmCompReel:   Integer =12;
  ColAugmCompTal:    Integer =13;
  ColAugmCompTri:    Integer =14;
  // augmentation talent
  ColAugmTalCode:   Integer = 1;
  ColAugmTalLib:    Integer = 3;
  ColAugmTalActuel: Integer = 4;
  ColAugmTalNouveau:Integer = 5;
  ColAugmTalCout:   Integer = 6;
  ColAugmTalSpe:    Integer = 7;
  ColAugmTalSpeSel: Integer = 8;
  ColAugmTalWork:   Integer = 9;
  ColAugmTalSort:   Integer =10;
  ColAugmTalReel:   Integer =11;
  // augmentation spéciales
  ColAugmMjXpType:  integer = 1;
  ColAugmMjXpCode:  integer = 2;
  ColAugmMjXpDebut: integer = 3;
  ColAugmMjXpFin:   integer = 4;
  ColAugmMjXpCout:  integer = 5;
  ColAugmMjXpReel:  integer = 6;
  ColAugmMjXpNew:   integer = 7;


  // Augmentation
  PreviousRowIndexA:    Integer = 0;
  PreviousRowIndexC:    Integer = 0;
  PreviousRowIndexT:    Integer = 0;
  // Li
  ListeSavAtt:    String = '';
  ListeSavComp:   String = '';
  ListeSavTal:    String = '';

  NvMetier:       String = '';
  NvNiveau:       String = '';
  NvMetierChoisi: String = '';
  AjoutMineur:    Boolean= false;

  FenMetier:          TWinMetiers;
  FenArme:            TWinWeapons;
  FenArmure:          TWinArmors;
  FenSort:            TWinSpells;
  FenFabrication:     TWinFabrications;
  FenTalent:          TWintTalent;
  FenCompetence:      TWinCompetence;
  FenSpecialisation:  TWinSpecialisations;

  NbEquipement: Integer;

  FabAjoute:    Boolean = false;

  Personnage:                 StructurePersonnage;
  PersonnageMetier:           StructurePersonnageMetier;
  PersonnageAttribut:         StructurePersonnageAttribut;
  PersonnageCompetence:       StructurePersonnageCompetence;
  PersonnageTalent:           StructurePersonnageTalent;
  PersonnageEquipement:       StructurePersonnageEquipement;
  PersonnageXpAttribut:       StructurePersonnageXpAttribut;
  PersonnageXpCompetence:     StructurePersonnageXpCompetence;
  PersonnageXpTalent:         StructurePersonnageXpTalent;
  PersonnageTalentCompetence: StructurePersonnageTalentPersonnage;

  // verrue
  PremierAjustage:            integer = 3;


implementation

{$R *.lfm}


Function TWinPersonnages.XmlDebut(TypeDonnee: string): String;
  begin
    Result := '<'+TypeDonnee+'>';
  end;

Function TWinPersonnages.XmlFin(TypeDonnee: string): String;
  begin
    Result := '</'+TypeDonnee+'>';
  end;

Function TWinPersonnages.XmlLigne(TypeDonnee: string; Valeur: String): String;
  begin
    Result := XmlDebut(TypeDonnee) + '"' + Valeur + '"' + XmlFin(TypeDonnee);
  end;

function TWinPersonnages.XmlLigneDonnee(TypeDonnee: string; Valeur: String; Donnee: String): String;
  begin
    Result := XmlDebut(TypeDonnee+' name="'+Valeur+'"') + '"' + Donnee + '"' + XmlFin(TypeDonnee);
  end;

function TWinPersonnages.XmlPersonnageFichierActuel(const Directory: string): string;
var
  SearchRec:       TSearchRec;
  HighestFileName: string;
  NbFichier:       Integer = 0;
  OrdreTri:        Integer = 9999;
begin
  HighestFileName := '';

  if FindFirst(Directory + PathDelim + '*.xml', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory) = 0 then
      begin
        // Vérifier si le fichier a l'extension .xml
        if UpperCase(ExtractFileExt(SearchRec.Name)) = UpperCase('.xml') then
        begin
          // Comparer le nom du fichier avec le nom le plus élevé trouvé jusqu'à présent
          if HighestFileName = '' then
            HighestFileName := SearchRec.Name
          else if CompareText(SearchRec.Name, HighestFileName) > 0 then
            HighestFileName := SearchRec.Name;

          // ajout de l'historique
          NbFichier := NbFichier + 1;
          if NbFichier >= TabHistorique.RowCount then
            TabHistorique.RowCount := TabHistorique.RowCount + 1;
          TabHistorique.cells[1,NbFichier] := SearchRec.Name;
          TabHistorique.cells[2,NbFichier] := Directory + PathDelim + SearchRec.Name;
          TabHistorique.cells[3,NbFichier] := IntToStr(OrdreTri - NbFichier);
        end;
      end;
      TabHistorique.SortColRow(true, 3);
    until FindNext(SearchRec) <> 0;
  end;

  if HighestFileName <> '' then
    Result := IncludeTrailingPathDelimiter(Directory) + HighestFileName
  else
    Result := '';
end;

procedure TWinPersonnages.ButtonAugmentationClick(Sender: TObject);
Var
  XpDispo:          Integer;
  CarriereComplete: Boolean;
begin
  // calculs XP disponible et état carrière
  XpDispo          := (StrToIntDef(extractnumbers(tabExperience.Cells[ColXpDonnee,LigXpRestant]),0) - StrToIntDef(extractnumbers(tabExperience.Cells[ColXpDonnee,LigXpCout]),0));
  CarriereComplete := ((TabAvancement.Cells[2,1] = CouleurOk) and (TabAvancement.Cells[2,2] = CouleurOk) and (TabAvancement.Cells[2,3] = CouleurOk));
  // calcul Xp, Métier, Nv en changement de carrière
  if radiobuttonsuivant.Checked and CarriereComplete then
    begin
      NvMetier := MetierEnCours;
      NvNiveau := IntToStr(StrToInt(MetierNvEnCours)+1);
    end
  else if radiobuttonChanger.Checked and CarriereComplete then
    begin
      NvMetier := NvMetierChoisi;
      NvNiveau := '1';
    end
  else if radiobuttonChanger.Checked and Not CarriereComplete then
    begin
      NvMetier := NvMetierChoisi;
      NvNiveau := '1';
   end
  else
    begin
      NvMetier := '';
      NvNiveau := '';
    end;

  // tests
  if radiobuttonsuivant.Checked and (MetierNvEnCours = '4') then
    ShowMEssage(GetTexteLibelle('MESS_043'))
  else if (StrToIntDef(tabExperience.Cells[ColXpDonnee,LigXpCout],0) = 0) and (tabExperience.Cells[ColXpDonnee,LigXpTotal] = EditTotalXp.Text) and not radiobuttonsuivant.Checked and not radiobuttonChanger.Checked and (NbEquipement = TabEquipement.RowCount-1) and (not FabAjoute) then
    ShowMEssage(GetTexteLibelle('MESS_024'))
  else if (XpDispo < 0) then
    ShowMEssage(GetTexteLibelle('MESS_025'))
  else if StrToIntDef(EditTotalXp.Text,0) < StrToIntDef(tabExperience.Cells[ColXpDonnee,LigXpTotal],0) then
    ShowMEssage(GetTexteLibelle('MESS_026'))
  else if radiobuttonChanger.Checked and (NvMetier = '') then
    ShowMEssage(GetTexteLibelle('MESS_027'))
  else if radiobuttonsuivant.Checked and Not CarriereComplete then
    ShowMEssage(GetTexteLibelle('MESS_028'))
  else if radiobuttonsuivant.Checked and CarriereComplete and (XpDispo < EditNeedRealXp.Value) then
    ShowMEssage(GetTexteLibelle('MESS_029')+IntToStr(EditNeedRealXp.Value))
  else if radiobuttonChanger.Checked and CarriereComplete and (XpDispo < EditNeedRealXp.Value)  then
    ShowMEssage(GetTexteLibelle('MESS_030')+IntToStr(EditNeedRealXp.Value))
  else if radiobuttonChanger.Checked and Not CarriereComplete and (XpDispo < EditNeedRealXp.Value) then
    ShowMEssage(GetTexteLibelle('MESS_031')+IntToStr(EditNeedRealXp.Value))
  else if (radiobuttonChanger.Checked or radiobuttonsuivant.Checked) and ChoixNonFait() then
    ShowMEssage(GetTexteLibelle('MESS_032'))
  else if AjoutMineur and (RechercherDansColonne(TabSort, ConstArbreAuChoix, 2) <> -1) then
    ShowMEssage(GetTexteLibelle('MESS_033'))
  else
    MajTables();
end;

procedure TWinPersonnages.ButtonPdfClick(Sender: TObject);
begin
  if (CheckBoxPdfFeldo2p.Checked = false) then
    PdfPersonnageCreation(Personnage, true)
  else
    PdfPersonnageCreationFeldo2P(Personnage);
end;

procedure TWinPersonnages.TabSortDblClick(Sender: TObject);
Var
  PSort: StructureSort;
begin
  // ouvrir les métiers
  SelectWinSort     := TabSort.Cells[3, TabSort.Row];
  FenSort           := TWinSpells.Create(Application);
  FenSort.Position  := poOwnerFormCenter;
  FenSort.ShowModal;

  if ChoixWinSort <> '' then
    begin
      pSort                         := ChercheSort(ChoixWinSort);
      TabSort.Cells[1, TabSort.Row] := PSort.CodeSort;
      TabSort.Cells[2, TabSort.Row] := PSort.Libelle;
    end;
  SelectWinSort := '';
  ChoixWinSort  := '';
end;

procedure TWinPersonnages.TabTalentDblClick(Sender: TObject);
begin
  // ouvrir les Talents
  FCurrentTabSheet    := PageExperience.ActivePage;
  SelectWinTalent     := TabTalent.Cells[ColTalCode, TabTalent.Row];
  FenTalent           := TWintTalent.Create(Application);
  FenTalent.Position  := poOwnerFormCenter;
  FenTalent.Show;
  SelectWinTalent := '';
  ChoixWinTalent  := '';
end;

procedure TWinPersonnages.ButtonSauvegardeClick(Sender: TObject);
begin
  XmlSauvegarde();
  Close;
end;

procedure TWinPersonnages.CheckBoxCalculChange(Sender: TObject);
Var
  Largeur: Integer = 0;
  Hauteur: Integer = 1;
begin
  if CheckBoxCalcul.Checked then
    Begin
      Largeur := 50;
      Hauteur := TabAttribut.DefaultRowHeight;
    end;

  TabTalent.ColWidths[5]               := Largeur;

  TabCompetence.ColWidths[ColComp35]   := Largeur;
  TabCompetence.ColWidths[ColComp40]   := Largeur;
  TabCompetence.ColWidths[ColCompWork] := Largeur;

  TabAttribut.RowHeights[LigAttRace]   := Hauteur;
  TabAttribut.RowHeights[LigAttLance]  := Hauteur;
  TabAttribut.RowHeights[LigAttTalent] := Hauteur;

  TabAttribut.ColWidths[ColAttDestin]  := Largeur;
  TabAttribut.ColWidths[ColAttResil]   := Largeur;

  TabTalent.ColWidths[9]               := Largeur;
  TabTalent.ColWidths[10]              := Largeur;

  AjustePositionTables();
end;

procedure TWinPersonnages.CheckBoxXpChange(Sender: TObject);
  Var
    Largeur: Integer = 0;
    Hauteur: Integer = 1;
  begin
    if CheckBoxXp.Checked then
      Begin
        Largeur := 50;
        Hauteur := TabAttribut.DefaultRowHeight;
      end;

    TabCompetence.ColWidths[ColCompXp] := Largeur;
    TabTalent.ColWidths[6]             := Largeur;
    TabCarriere.ColWidths[4]           := Largeur;
    TabEquipement.ColWidths[5]         := Largeur;
    TabAttribut.RowHeights[LigAttXp]   := Hauteur;

    AjustePositionTables();
  end;

procedure TWinPersonnages.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  NettoyerElementsFenetre(self);
  EffaceDonnee(TabAttribut, 12);
  EffaceDonnee(TabCompetence, 1);
  EffaceDonnee(TabTalent, 1);
  EffaceDonnee(TabCarriere, 1);
  EffaceDonnee(TabEquipement, 1);
  ListImage.Clear;
  PremierAjustage := 3;
end;

procedure TWinPersonnages.EffaceDonnee(Tableau: TStringGrid; NbLig: Integer);
  var
    I, J: Integer;
  begin
    for I := 1 to Tableau.ColCount - 1 do
      for J := 1 to Tableau.RowCount - 1 do
        Tableau.Cells[I, J] := '';
    Tableau.RowCount := NbLig;
  end;

procedure TWinPersonnages.ButtonHistoriqueClick(Sender: TObject);
begin
  EffaceDonnee(TabAttribut, 12);
  EffaceDonnee(TabCompetence, 1);
  EffaceDonnee(TabTalent, 1);
  EffaceDonnee(TabCarriere, 1);
  EffaceDonnee(TabEquipement, 1);
  AttributInit();
  XmlChargePersonnage(TabHistorique.Cells[2, TabHistorique.Row]);
end;

procedure TWinPersonnages.ButtonQuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TWinPersonnages.ButtonArmeClick(Sender: TObject);
  Var
    PArme: StructureArme;
  begin
    // ouvrir les métiers
    SelectWinArme     := ConstSelectionne;
    FenArme           := TWinWeapons.Create(Application);
    FenArme.Position  := poOwnerFormCenter;
    FenArme.ShowModal;

    if ChoixWinArme <> '' then
      begin
        pArme := ChercheArme(ChoixWinArme);
        TabEquipement.RowCount                          := TabEquipement.RowCount + 1;
        TabEquipement.Cells[0, TabEquipement.RowCount-1]:= '+';
        TabEquipement.Cells[1, TabEquipement.RowCount-1]:= IntToStr(TabEquipement.RowCount);
        TabEquipement.Cells[2, TabEquipement.RowCount-1]:= PArme.CodeArme;
        TabEquipement.Cells[3, TabEquipement.RowCount-1]:= TypeEquipWe;
        TabEquipement.Cells[4, TabEquipement.RowCount-1]:= PArme.Libelle;
        AdjustGridColumnsWidth(TabEquipement, 0, false, false);
      end;
    SelectWinArme := '';
    ChoixWinArme  := '';
end;

procedure TWinPersonnages.ButtonFabricationClick(Sender: TObject);
  begin
    if (TabEquipement.Row > 0)
      and not InList(TabEquipement.Cells[3, TabEquipement.Row],TypeSortBenediction+','+TypeSortMiracle+','+TypeSortMineur+','+TypeSortCouleur+','+TypeSortArcane+','+TypeSortChaos) then
        begin
          SelectWinFabrication     := TabEquipement.Cells[7,TabEquipement.row];
          FenFabrication           := TWinFabrications.Create(Application);
          FenFabrication.Position  := poOwnerFormCenter;
          FenFabrication.ShowModal;

          if ChoixWinFabrication <> '' then
            begin
              TabEquipement.Cells[7,TabEquipement.row] := ChoixWinFabrication;
              FabAjoute := true;
            end;

          SelectWinFabrication:= '';
          ChoixWinFabrication := '';
          AfficheFabrication();
        end;
  end;

procedure TWinPersonnages.ButtonDeleteClick(Sender: TObject);
  var
    Reponse:  Integer;
    i:        Integer;
  begin
    if (TabEquipement.Row > 0)
      and not InList(TabEquipement.Cells[3, TabEquipement.Row],TypeSortBenediction+','+TypeSortMiracle+','+TypeSortMineur+','+TypeSortCouleur+','+TypeSortArcane+','+TypeSortChaos) then
        begin
          Reponse := MessageDlg(GetTexteLibelle('MESS_039'), mtConfirmation, mbYesNo, 0);
          if Reponse = mrYes then
            begin
              // Décale les lignes suivantes vers le haut
              for i := TabEquipement.Row to TabEquipement.RowCount - 2 do
                TabEquipement.Rows[i].Assign(TabEquipement.Rows[i + 1]);

              // Supprime la dernière ligne, maintenant en double
              TabEquipement.RowCount := TabEquipement.RowCount - 1;
            end
        end;
  end;

procedure TWinPersonnages.ButtonArmureClick(Sender: TObject);
  Var
    PArmure:           StructureArmure;
    PArmureSimplifiee: StructureArmureSimplifiee;
  begin
    // ouvrir les métiers
    SelectWinQuickArmor := CheckBoxQuickArmor.Checked;
    SelectWinArmure     := ConstSelectionne;
    FenArmure           := TWinArmors.Create(Application);
    FenArmure.Position  := poOwnerFormCenter;
    FenArmure.ShowModal;

    if ChoixWinArmure <> '' then
      begin
        TabEquipement.RowCount  := TabEquipement.RowCount + 1;
        TabEquipement.Cells[0, TabEquipement.RowCount-1]:= '+';
        TabEquipement.Cells[1, TabEquipement.RowCount-1]:= IntToStr(TabEquipement.RowCount);
        if (CheckBoxQuickArmor.Checked = true) then
          begin
            PArmureSimplifiee := ChercheArmureSimplifiee(ChoixWinArmure);
            TabEquipement.Cells[2, TabEquipement.RowCount-1]:= PArmureSimplifiee.CodeArmure;
            TabEquipement.Cells[3, TabEquipement.RowCount-1]:= TypeEquipArS;
            TabEquipement.Cells[4, TabEquipement.RowCount-1]:= PArmureSimplifiee.Libelle;
          end
        else
          begin
            pArmure           := ChercheArmure(ChoixWinArmure);
            TabEquipement.RowCount                          := TabEquipement.RowCount + 1;
            TabEquipement.Cells[2, TabEquipement.RowCount-1]:= PArmure.CodeArmure;
            TabEquipement.Cells[3, TabEquipement.RowCount-1]:= TypeEquipAr;
            TabEquipement.Cells[4, TabEquipement.RowCount-1]:= PArmure.Libelle;
          end;
        AdjustGridColumnsWidth(TabEquipement, 0, false, false);
      end;
    SelectWinArmure := '';
    ChoixWinArmure  := '';
end;

procedure TWinPersonnages.EditAgeKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8, #9]) then Key := #0;
end;

procedure TWinPersonnages.ButtonRaceSelectionnerClick(Sender: TObject);
  Var
    PMetierActuel: StructureMetier;
    PMetierNv:     StructureMetier;
    ChangeClasse:  Boolean;
  begin
    pMetierActuel       := ChercheMetier(MetierEnCours);
    // ouvrir les métiers
    ButtonRaceSelectionner.Caption := GetTexteLibelle('LAB_004');
    NvMetierChoisi      := '';
    SelectWinMetierRace := RaceEnCours;
    SelectWinLivre      := Personnage.LivresAcceptes;
    FenMetier           := TWinMetiers.Create(Application);
    FenMetier.Position  := poOwnerFormCenter;
    FenMetier.ShowModal;

    if ChoixWinMetierRace <> '' then
      begin
        NvMetierChoisi := ChoixWinMetierRAce;
        pMetierNv      := ChercheMEtier(ChoixWinMetierRAce);
        ChangeClasse   := (PMetierNV.LibelleGroupe <> PMetierActuel.LibelleGroupe);
        CalculXpNecessaire(ChangeClasse);
        ButtonRaceSelectionner.Caption := PMetierNv.Libelle;
      end;

    SelectWinMetierRace:= '';
    SelectWinLivre     := '';
    ChoixWinMetierRace := '';
    ChargerMetierEquipement(NvMetierChoisi, 1);
    TabEquipementAffiche();
  end;

function TWinPersonnages.XpSortCout(CodeSort: String): String;
  Var
    PSort:  StructureSort;
    CoutXp: Integer;
    NB:     Integer = 0;
    BI:     Integer = 0;
    BFM:    Integer = 0;
    Ind:    Integer = 0;
    MaxMin: Integer = 0;
  begin
    PSort := ChercheSort(CodeSort);

    If PSort.TypeSort = TypeSortBenediction then
      // les bénédictions sont gratuites (on ne devrait jamais arriver ici, mais au cas où...)
      CoutXp := 0
    else
      begin
        // calcul des bonus pour certains calculs
        BI := Floor(StrToInt(TabAttribut.Cells[ColAttI, LigAttTotal]) / 10);
        BFM:= Floor(StrToInt(TabAttribut.Cells[ColAttFM,LigAttTotal]) / 10);

        // nombre de fois que le talent exixte
        For Ind := 1 to TabEquipement.RowCount-1 do
          If (TabEquipement.Cells[3, Ind] = PSort.TypeSort)
            or ((InList(PSort.TypeSort,TypeSortArcane+','+TypeSortCouleur))
              and (InList(TabEquipement.Cells[3, Ind],TypeSortArcane+','+TypeSortCouleur))) then
               begin
                Inc(Nb);
                if (Psort.TypeSort = TypeSortMineur) and (StrToIntDef(TabEquipement.Cells[5,ind],0) > MaxMin) then
                  MaxMin := StrToInt(TabEquipement.Cells[5,ind]);
               end;

        // selon le type de sort
        if (Psort.TypeSort = TypeSortMiracle) then
          CoutXp := 100 * (NB-1)
        else if InList(Psort.TypeSort,TypeSortArcane+','+TypeSortCouleur) then
          CoutXp := 100 * (1 + floor((NB-1) / BI))
        else if (Psort.TypeSort = TypeSortChaos) then
          CoutXp := 100
        else if (Psort.TypeSort = TypeSortMineur) then
          begin
            CoutXp := 50 * floor((NB-1) / BFM);
            if CoutXp = MaxMin then
              CoutXp := 0;
          end;
      end;

    // montant d'XP
    Result:= IntToStr(CalculOptionXpDiv25(CoutXp));
  end;

function TWinPersonnages.ChoixNonFait(): Boolean;
  var
    Ind: Integer;
    Res: Boolean = false;
  begin
    for Ind := 1 to TabMetierEquipement.Rowcount - 1 do
      if TabMetierEquipement.Cells[2, Ind] = ConstArbreAuChoix then
        Res := true;
    Result := Res;
  end;

procedure TWinPersonnages.ButtonSortClick(Sender: TObject);
  Var
    PSort:        StructureSort;
    Ind:          Integer;
    ListeTalent:  String;
  begin
    // ajouter les domaines
    ListeTalent := '';
    For Ind := 1 to TabTalent.RowCount-1 do
      case copy(TabTalent.Cells[ColTalCode, ind],1,5) of
        TalentSortDomaine:      ListeTalent := ListeTalent+' '+TabTalent.Cells[ColTalCode, ind];
      end;

    // si aucun domainge, on peut ajouter les autres
    if ListeTalent = '' then
      For Ind := 1 to TabTalent.RowCount-1 do
        case copy(TabTalent.Cells[ColTalCode, ind],1,5) of
          TalentSortMiracle:      ListeTalent := ListeTalent+' '+TabTalent.Cells[ColTalCode, ind];
          TalentSortMagieMineure: ListeTalent := ListeTalent+' '+TabTalent.Cells[ColTalCode, ind];
        end;

    if ListeTalent = '' then
      showMessage(GetTexteLibelle('MESS_037'))
    else
      begin
      SelectWinSort     := ListeTalent;
      FenSort           := TWinSpells.Create(Application);
      FenSort.Position  := poOwnerFormCenter;
      FenSort.ShowModal;
      if ChoixWinSort <> '' then
        begin
          pSort := ChercheSort(ChoixWinSort);
          if RechercherDansColonne(TabEquipement,PSort.CodeSort,2) = -1 then
            begin
              TabEquipement.RowCount                          := TabEquipement.RowCount + 1;
              TabEquipement.Cells[0, TabEquipement.RowCount-1]:= '+';
              TabEquipement.Cells[1, TabEquipement.RowCount-1]:= IntToStr(TabEquipement.RowCount);
              TabEquipement.Cells[2, TabEquipement.RowCount-1]:= PSort.CodeSort;
              TabEquipement.Cells[3, TabEquipement.RowCount-1]:= PSort.TypeSort;
              TabEquipement.Cells[4, TabEquipement.RowCount-1]:= PSort.Libelle;
              TabEquipement.Cells[5, TabEquipement.RowCount-1]:= XpSortCout(PSort.CodeSort);
              AdjustGridColumnsWidth(TabEquipement, 0, false, false);
              CalculTableExperience();
            end
          else
            ShowMEssage(GetTexteLibelle('MESS_036'));
        end;
      end;
    SelectWinSort := '';
    ChoixWinSort  := '';
end;

procedure TWinPersonnages.CalculXpGlobal(Mode25: boolean);
begin

end;

procedure TWinPersonnages.CheckBoxXpDiv25Change(Sender: TObject);
begin
  CalculXpGlobal(CheckBoxXpDiv25.Checked);
end;

procedure TWinPersonnages.CheckBoxXpDiv25Click(Sender: TObject);
begin
  EditTotalXp25.Enabled := CheckBoxXpDiv25.checked;
  EditTotalXp.Enabled   := not CheckBoxXpDiv25.checked;
end;

procedure TWinPersonnages.CalculXpNecessaire(ChangementClasse: Boolean);
  Var
    XpNeed:   Integer=0;
  Begin
    if RadioButtonSuivant.checked or RadioButtonChanger.checked then
      begin
        if RadioButtonSuivant.checked then
          XpNeed := ConstXpNouveauNiveau
        else if ((TabAvancement.Cells[2,1] = CouleurOk) and (TabAvancement.Cells[2,2] = CouleurOk) and (TabAvancement.Cells[2,3] = CouleurOk)) then
          XpNeed := ConstXpChangerMetier
        else
          XpNeed := ConstXpChangerMetierIncomplet;
        if ChangementClasse then
          XpNeed := XpNeed + ConstXpChangerClasse;
        EditNeedRealXp.MinValue  := 0;
        XpNeed:= CalculOptionXpDiv25(XpNeed);
        EditNeedRealXp.MaxValue  := XpNeed;
      end;

    EditNeedTheoXp.value     := XpNeed;
    EditNeedRealXp.value     := XpNeed;
    EditNeedTheoXp.Visible   := (XpNeed<>0);
    EditNeedRealXp.Visible   := (XpNeed<>0);
    LabelNeedTheoXp.Visible  := (XpNeed<>0);
    LabelNeedRealXp.Visible  := (XpNeed<>0);
  end;

procedure TWinPersonnages.ComboBoxNvMetierChange(Sender: TObject);
  begin
    ChargerMetierEquipement(NvMetierChoisi, 1);
    TabEquipementAffiche();
  end;

procedure TWinPersonnages.EditTotalXp25KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8, #9]) then Key := #0;
end;

procedure TWinPersonnages.EditTotalXp25KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var
    ValInt: Integer = 0 ;
  begin
    ValInt := StrToIntDef(EditTotalXp25.Text,0) * 25;
    EditTotalXp.Text := IntToStr(ValInt);
  end;

procedure TWinPersonnages.EditTotalXpKeyPress(Sender: TObject; var Key: char);
begin
    if not (Key in ['0'..'9', #8, #9]) then Key := #0;
end;

procedure TWinPersonnages.EditTotalXpKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var
    ValInt: Integer = 0 ;
  begin
    ValInt := Trunc(StrToIntDef(EditTotalXp.Text,0) / 25);
    EditTotalXp25.Text := IntToStr(ValInt);
  end;

Procedure TWinPersonnages.SortAffiche();
  var
    PSort:  StructureSort;
    Tal:    String;
    Ind:    Integer;
  begin
    EffaceDonnee(TabSort,1);
    for ind := 1 to TabAugmentationTalent.RowCount - 1 do
      if StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalNouveau, Ind], 0) > StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalActuel, Ind], 0) then
        begin
          Tal := TabAugmentationTalent.Cells[ColAugmTalCode, Ind];
          if copy(Tal,1,5) = TalentSortBenediction then
            begin
              For Psort in ListSort do
                if Pos(Tal, PSort.ListeTalent) > 0 then
                  Begin
                    TabSort.RowCount                       := TabSort.RowCount + 1;
                    TabSort.Cells[1, TabSort.RowCount-1]   := PSort.CodeSort;
                    TabSort.Cells[2, TabSort.RowCount-1]   := PSort.Libelle;
                    TabSort.Cells[3, TabSort.RowCount-1]   := Tal;
                  end;
            end
          else if copy(Tal,1,5) = TalentSortMiracle then
            begin
              TabSort.Visible                     := true;
              TabSort.RowCount                    := TabSort.RowCount + 1;
              TabSort.Cells[2,TabSort.RowCount-1] := ConstArbreAuChoix;
              TabSort.Cells[3,TabSort.RowCount-1] := Tal;
            end
        end;
    TabSort.visible := (TabSort.RowCount > 1);
    AdjustGridColumnsWidth(TabSort, PageExperience.Height, false, false);
    TabSort.Top    := TabAugmentationTalent.Top + TabAugmentationTalent.Height + 10;
  end;

Procedure TWinPersonnages.AttributInit();
  Begin
    tabAttribut.Cells[ColAttCC, LigAttCode]      := ConstCaracCC;
    tabAttribut.Cells[ColAttCT, LigAttCode]      := ConstCaracCT;
    tabAttribut.Cells[ColAttF, LigAttCode]       := ConstCaracF;
    tabAttribut.Cells[ColAttE, LigAttCode]       := ConstCaracE;
    tabAttribut.Cells[ColAttI, LigAttCode]       := ConstCaracI;
    tabAttribut.Cells[ColAttAgi, LigAttCode]     := ConstCaracAg;
    tabAttribut.Cells[ColAttDex, LigAttCode]     := ConstCaracDex;
    tabAttribut.Cells[ColAttInt, LigAttCode]     := ConstCaracInt;
    tabAttribut.Cells[ColAttFM, LigAttCode]      := ConstCaracFM;
    tabAttribut.Cells[ColAttSoc, LigAttCode]     := ConstCaracSoc;
    tabAttribut.Cells[ColAttDestin, LigAttCode]  := ConstCaracDestin;
    tabAttribut.Cells[ColAttResil, LigAttCode]   := ConstCaracResil;
    tabAttribut.Cells[ColAttBlessure, LigAttCode]:= ConstCaracBlessure;
  end;

procedure TWinPersonnages.Initialisation();
  var
    I:         Integer;
    Bmp:       TBGRABitmap;
    strings:   TStringList;
    Livre:     String;
    Ordre:     String;
    PLivre:    StructureLivre;
begin
  PreviousRowIndexA := 0;
  PreviousRowIndexC := 0;
  PreviousRowIndexT := 0;

  MiseEnFormeDesChamp(self);

  // charges les images des niveaux
  SetLength(ColorList, 8);
  ListImage := TImageList.Create(nil);
  For I := 0 to 7 Do
  Begin
      ChargeImageNiveau(I);
  End;

  // Logo
  if FileExists(GetCurrentDir+ConstCheminLogo1) then
      ImageWar.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);

  if FileExists(GetCurrentDir+ConstCheminSheetTitle) then
     begin
       Bmp := TBGRABitmap.Create(GetCurrentDir+ConstCheminSheetTitle);
       ImageSheetTitle.Picture.Bitmap.Assign(Bmp);
       Bmp.Free;
       ImageSheetTitle.Transparent := True;
       ImageSheetTitle.SendToBack;
     end;
  if FileExists(GetCurrentDir+ConstCheminSheetBack) then
     begin
       Bmp := TBGRABitmap.Create(GetCurrentDir+ConstCheminSheetBack);
       ImageBackRace.Picture.Bitmap.Assign(Bmp);
       ImageBackMetier.Picture.Bitmap.Assign(Bmp);
       Bmp.Free;
       ImageBackRace.Transparent := True;
       ImageBackRace.SendToBack;
       ImageBackMetier.Transparent := True;
       ImageBackMetier.SendToBack;
     end;

    if FileExists(GetCurrentDir+ConstCheminSheetPage) then
       begin
         Bmp := TBGRABitmap.Create(GetCurrentDir+ConstCheminSheetPage);
         ImageSheetPage.Picture.Bitmap.Assign(Bmp);
         Bmp.Free;
         ImageSheetPage.Transparent := True;
         ImageSheetPage.SendToBack;
       end;

    if FileExists(GetCurrentDir+ConstCheminXp) then
       begin
         Bmp := TBGRABitmap.Create(GetCurrentDir+ConstCheminXp);
         ImageSheetXp.Picture.Bitmap.Assign(Bmp);
         Bmp.Free;
         ImageSheetXp.Transparent := True;
         ImageSheetXp.SendToBack;
       end;

  // Mise en forme du tableau des attributs
  TabAttribut.Clear;
  TabAttribut.Options          := TabAttribut.Options + [goEditing, goAlwaysShowEditor];
  TabAttribut.ColCount         := 1;
  TabAttribut.RowCount         := 12;
  For I := 0 to 13 do
    begin
      if TabAttribut.Columns.Count <= I then
        TabAttribut.Columns.Add;
      if I > ColAttLib then
        begin
          TabAttribut.ColWidths[I]  := 53;
          TabAttribut.Columns[I].Alignment := taCenter;
        end;
    end;

  AttributInit();

  TabAttribut.ColWidths[0]             := 20;
  TabAttribut.ColWidths[ColAttLib]     := 100;
  TabAttribut.ColWidths[ColAttDestin]  := 0;
  TabAttribut.ColWidths[ColAttResil]   := 0;
  TabAttribut.ColWidths[ColAttBlessure]:= 0;

  TabAttribut.Cells[ColAttLib, LigAttRace]    := GetTexteLibelle('LAB_042');
  TabAttribut.Cells[ColAttLib, LigAttLance]   := GetTexteLibelle('LAB_022');
  TabAttribut.Cells[ColAttLib, LigAttTalent]  := GetTexteLibelle('LAB_007');
  TabAttribut.Cells[ColAttLib, LigAttBase]    := GetTexteLibelle('LAB_043');
  TabAttribut.Cells[ColAttLib, LigAttImage]   := GetTexteLibelle('LAB_019');
  TabAttribut.Cells[ColAttLib, LigAttBonus]   := GetTexteLibelle('LAB_040');
  TabAttribut.Cells[ColAttLib, LigAttTotal]   := GetTexteLibelle('LAB_041');
  TabAttribut.Cells[ColAttLib, LigAttXp]      := GetTexteLibelle('LAB_035');
  TabAttribut.Cells[ColAttLib, LigAttAsterisc]:= '*';

  TabAttribut.RowHeights[LigAttRace]    := 1;
  TabAttribut.RowHeights[LigAttLance]   := 1;
  TabAttribut.RowHeights[LigAttTalent]  := 1;
  TabAttribut.RowHeights[LigAttXp]      := 1;
  TabAttribut.RowHeights[LigAttImage]   := 1;
  TabAttribut.RowHeights[LigAttActuel]  := 1;
  TabAttribut.RowHeights[LigAttCode]    := 1;
  TabAttribut.RowHeights[LigAttAsterisc]:= 1;


  // Mise en forme du tableau des talents
  TabTalent.Options                  := TabTalent.Options + [goEditing, goAlwaysShowEditor];
  TabTalent.ColCount                 := 11;
  TabTalent.RowCount                 := 1;
  TabTalent.ColWidths[0]             := 20;
  TabTalent.ColWidths[ColTalCode]    := 0;                           // code talent
  TabTalent.ColWidths[2]             := 0;                           // image
  TabTalent.Cells[ColTalLib, 0]      := GetTexteLibelle('LAB_007');  // libellé talent
  TabTalent.ColWidths[ColTalLib]     := 200;
  TabTalent.Cells[ColTalNb, 0]       := GetTexteLibelle('LAB_045');  // nb talent
  TabTalent.ColWidths[ColTalNb]      := 53;
  TabTalent.Cells[ColTalMax, 0]      := GetTexteLibelle('LAB_044');  // Max Talent
  TabTalent.ColWidths[ColTalMax]     := 0;
  TabTalent.Cells[ColTalXp, 0]       := GetTexteLibelle('LAB_035');  // XP
  TabTalent.ColWidths[ColTalXp]      := 0;
  TabTalent.Cells[7, 0]              := GetTexteLibelle('LAB_016');  //
  TabTalent.ColWidths[7]             := 0;
  TabTalent.Cells[ColTalAsterisk, 0] := '*';                         // astérisque pour PDF
  TabTalent.ColWidths[ColTalAsterisk]:= 0;
  TabTalent.Cells[ColTalNbCrea, 0]   := GetTexteLibelle('LAB_079');  // nb création
  TabTalent.ColWidths[ColTalNbCrea]  := 0;
  TabTalent.Cells[ColTalNbAugm,0]    := GetTexteLibelle('LAB_103');  // nb augmentation
  TabTalent.ColWidths[ColTalNbAugm]  := 0;

  // Mise en forme du tableau des Niveaux
  TabNiveau.Options          := TabNiveau.Options + [goEditing, goAlwaysShowEditor];
  TabNiveau.ColCount         := 1;
  TabNiveau.RowCount         := 5;
  TabNiveau.ColWidths[0]     := 20;
  TabNiveau.Columns.Add;
  TabNiveau.ColWidths[1]     := 0;
  TabNiveau.Columns.Add;
  TabNiveau.Columns[1].Alignment := taCenter;
  TabNiveau.Cells[2, 0]      := GetTexteLibelle('LAB_019');
  TabNiveau.ColWidths[2]     := 40;
  TabNiveau.Columns.Add;
  TabNiveau.Cells[3, 0]      := GetTexteLibelle('LAB_046');
  TabNiveau.ColWidths[3]     := 140;

  // Mise en forme du tableau des Compétences
  TabCompetence.Options                   := TabCompetence.Options + [goEditing, goAlwaysShowEditor];
  TabCompetence.ColCount                  := 17;
  TabCompetence.RowCount                  := 1;
  TabCompetence.ColWidths[0]              := 20;
  TabCompetence.ColWidths[ColCompCode]    := 0;
  TabCompetence.Cells[ColCompImage, 0]    := GetTexteLibelle('LAB_019');
  TabCompetence.ColWidths[ColCompImage]   := 0;
  TabCompetence.Cells[ColCompLib, 0]      := GetTexteLibelle('LAB_003');
  TabCompetence.ColWidths[ColCompLib]     := 180;
  TabCompetence.Cells[ColCompCarac, 0]    := GetTexteLibelle('LAB_008');
  TabCompetence.ColWidths[ColCompCarac]   := 50;
  TabCompetence.Cells[ColCompAtt, 0]      := GetTexteLibelle('LAB_025');
  TabCompetence.ColWidths[ColCompAtt]     := 50;
  TabCompetence.Cells[ColComp35, 0]       := '3p/5p';
  TabCompetence.ColWidths[ColComp35]      := 0;
  TabCompetence.Cells[ColComp40, 0]       := '40pts';
  TabCompetence.ColWidths[ColComp40]      := 0;
  TabCompetence.Cells[ColCompWork, 0]     := GetTexteLibelle('LAB_006');
  TabCompetence.ColWidths[ColCompWork]    := 0;
  TabCompetence.Cells[ColCompBonus, 0]    := GetTexteLibelle('LAB_034');
  TabCompetence.ColWidths[ColCompBonus]   := 50;
  TabCompetence.Cells[ColCompTotal, 0]    := GetTexteLibelle('LAB_021');
  TabCompetence.ColWidths[ColCompTotal]   := 50;
  TabCompetence.Cells[ColCompStat, 0]     := 'Stat';
  TabCompetence.ColWidths[ColCompStat]    := 0;
  TabCompetence.Cells[ColCompXp, 0]       := GetTexteLibelle('LAB_035');
  TabCompetence.ColWidths[ColCompXp]      := 0;
  TabCompetence.Cells[ColCompActuel, 0]   := GetTexteLibelle('LAB_016');
  TabCompetence.ColWidths[ColCompActuel]  := 0;
  TabCompetence.Cells[ColCompTravail, 0]  := 'W';
  TabCompetence.ColWidths[ColCompTravail] := 0;
  TabCompetence.Cells[ColCompAsterisc, 0] := '*';
  TabCompetence.ColWidths[ColCompAsterisc]:= 0;
  TabCompetence.Cells[ColCompTalent, 0]   := 'Talent';
  TabCompetence.ColWidths[ColCompTalent]  := 0;

  // Mise en forme du tableau des carrières
  TabCarriere.Options                  := TabCarriere.Options + [goEditing, goAlwaysShowEditor];
  TabCarriere.ColCount                 := 5;
  TabCarriere.RowCount                 := 1;
  TabCarriere.ColWidths[0]             := 20;
  TabCarriere.Columns.Add;
  TabCarriere.ColWidths[1]             := 0;
  TabCarriere.Columns.Add;
  TabCarriere.Cells[2, 0]              := GetTexteLibelle('LAB_019');
  TabCarriere.Columns[1].Alignment     := taCenter;
  TabCarriere.ColWidths[2]             := 40;
  TabCarriere.Columns.Add;
  TabCarriere.Cells[3, 0]              := GetTexteLibelle('LAB_003');
  TabCarriere.ColWidths[3]             := 120;
  TabCarriere.Columns.Add;
  TabCarriere.Cells[4, 0]              := GetTexteLibelle('LAB_035');
  TabCarriere.ColWidths[4]             := 0;

  // Mise en forme du tableau d'état d'avancement
  TabAvancement.Options                  := TabAvancement.Options + [goEditing, goAlwaysShowEditor];
  TabAvancement.ColCount                 := 6;
  TabAvancement.RowCount                 := 4;
  TabAvancement.ColWidths[0]             := 20;
  TabAvancement.ColWidths[1]             := 0;
  TabAvancement.ColWidths[2]             := 0;
  TabAvancement.Cells[3, 0]              := GetTexteLibelle('LAB_047');
  TabAvancement.ColWidths[3]             := 100;
  TabAvancement.Cells[4, 0]              := GetTexteLibelle('LAB_048');
  TabAvancement.ColWidths[4]             := 40;
  TabAvancement.Cells[5, 0]              := GetTexteLibelle('LAB_049');
  TabAvancement.ColWidths[5]             := 40;
  TabAvancement.Cells[3, 1]              := GetTexteLibelle('LAB_008');
  TabAvancement.Cells[3, 2]              := GetTexteLibelle('LAB_009');
  TabAvancement.Cells[3, 3]              := GetTexteLibelle('LAB_007');
  TabAvancement.cells[4, 2]              := '8';        // 8 compétences
  TabAvancement.cells[4, 3]              := '1';        // 1 Talent

  // Mise en forme du tableau d'état d'avancement
  TabExperience.Options                         := TabExperience.Options + [goEditing, goAlwaysShowEditor];
  TabExperience.ColCount                        := 1;
  TabExperience.RowCount                        := 5;
  TabExperience.ColWidths[0]                    := 20;
  TabExperience.Columns.add;
  TabExperience.ColWidths[1]                    := 100;
  TabExperience.Columns.add;
  TabExperience.ColWidths[2]                    := 0;
  TabExperience.Columns.add;
  TabExperience.ColWidths[3]                    := 50;
  TabExperience.Columns[2].Alignment            := taRightJustify;
  tabExperience.Cells[ColXpLib, 0]              := GetTexteLibelle('LAB_047');
  tabExperience.Cells[ColXpLib, LigXpTotal]     := GetTexteLibelle('LAB_021');
  tabExperience.Cells[ColXpLib, LigXpDepense]   := GetTexteLibelle('LAB_050');
  tabExperience.Cells[ColXpLib, LigXpRestant]   := GetTexteLibelle('LAB_051');
  tabExperience.Cells[ColXpLib, LigXpCout]      := GetTexteLibelle('LAB_015');
  tabExperience.Cells[ColXpDonnee, 0]           := GetTexteLibelle('LAB_025');

  // Mise en forme du tableau des augmentation d'attribut
  TabAugmentationAttribut.Options                     := TabAugmentationAttribut.Options + [goEditing, goAlwaysShowEditor];
  TabAugmentationAttribut.ColCount                    := 10;
  TabAugmentationAttribut.RowCount                    := 11;
  TabAugmentationAttribut.ColWidths[0]                := 20;
  TabAugmentationAttribut.ColWidths[1]                := 0;
  TabAugmentationAttribut.Cells[1, 0]                 := GetTexteLibelle('LAB_008');
  TabAugmentationAttribut.ColWidths[2]                := 0;
  TabAugmentationAttribut.Cells[ColAugmAttCode, 0]    := GetTexteLibelle('LAB_001');
  TabAugmentationAttribut.ColWidths[ColAugmAttCode]   := 80;
  TabAugmentationAttribut.Cells[ColAugmAttActuel, 0]  := GetTexteLibelle('LAB_016');
  TabAugmentationAttribut.ColWidths[ColAugmAttActuel] := 80;
  TabAugmentationAttribut.Cells[ColAugmAttNouveau, 0] := GetTexteLibelle('LAB_017');
  TabAugmentationAttribut.ColWidths[ColAugmAttNouveau]:= 80;
  TabAugmentationAttribut.Cells[ColAugmAttMoins5, 0]  := '-5';
  TabAugmentationAttribut.ColWidths[ColAugmAttMoins5] := 50;
  TabAugmentationAttribut.Cells[ColAugmAttPlus5, 0]   := '+5';
  TabAugmentationAttribut.ColWidths[ColAugmAttPlus5]  := 50;
  TabAugmentationAttribut.Cells[ColAugmAttNouveau, 0] := GetTexteLibelle('LAB_017');
  TabAugmentationAttribut.ColWidths[ColAugmAttNouveau]:= 80;
  TabAugmentationAttribut.Cells[ColAugmAttCout, 0]    := GetTexteLibelle('LAB_015');
  TabAugmentationAttribut.ColWidths[ColAugmAttCout]   := 80;
  TabAugmentationAttribut.Cells[ColAugmAttReel, 0]    := GetTexteLibelle('LAB_139');
  TabAugmentationAttribut.ColWidths[ColAugmAttReel]   := 80;

  // Mise en forme du tableau des augmentation de Compétences
  TabAugmentationCompetence.Options                      := TabAugmentationCompetence.Options + [goEditing, goAlwaysShowEditor];
  TabAugmentationCompetence.ColCount                     := 15;
  TabAugmentationCompetence.RowCount                     := 11;
  TabAugmentationCompetence.ColWidths[0]                 := 20;
  TabAugmentationCompetence.ColWidths[ColAugmCompCode]   := 0;
  TabAugmentationCompetence.ColWidths[2]                 := 0;
  TabAugmentationCompetence.Cells[ColAugmCompLib, 0]     := GetTexteLibelle('LAB_009');
  TabAugmentationCompetence.ColWidths[ColAugmCompLib]    := 200;
  TabAugmentationCompetence.Cells[ColAugmCompActuel, 0]  := GetTexteLibelle('LAB_016');
  TabAugmentationCompetence.ColWidths[ColAugmCompActuel] := 70;
  TabAugmentationCompetence.Cells[ColAugmCompNouveau, 0] := GetTexteLibelle('LAB_019');
  TabAugmentationCompetence.ColWidths[ColAugmCompNouveau]:= 70;
  TabAugmentationCompetence.Cells[ColAugmCompMoins5, 0]  := '-5';
  TabAugmentationCompetence.ColWidths[ColAugmCompMoins5] := 50;
  TabAugmentationCompetence.Cells[ColAugmCompPlus5, 0]   := '+5';
  TabAugmentationCompetence.ColWidths[ColAugmCompPlus5]  := 50;
  TabAugmentationCompetence.Cells[ColAugmCompCout, 0]    := GetTexteLibelle('LAB_015');
  TabAugmentationCompetence.ColWidths[ColAugmCompCout]   := 70;
  TabAugmentationCompetence.Cells[ColAugmCompSpe, 0]     := GetTexteLibelle('LAB_078');
  TabAugmentationCompetence.ColWidths[ColAugmCompSpe]    := 200;
  TabAugmentationCompetence.Cells[ColAugmCompSpeSel, 0]  := 'Spé Choisie';
  TabAugmentationCompetence.ColWidths[ColAugmCompSpeSel] := 0;
  TabAugmentationCompetence.Cells[ColAugmCompWork, 0]    := 'Work';
  TabAugmentationCompetence.ColWidths[ColAugmCompWork]   := 0;
  TabAugmentationCompetence.Cells[ColAugmCompReel, 0]    := GetTexteLibelle('LAB_139');
  TabAugmentationCompetence.ColWidths[ColAugmCompReel]   := 50;
  TabAugmentationCompetence.Cells[ColAugmCompTal, 0]     := 'Talent';
  TabAugmentationCompetence.ColWidths[ColAugmCompTal]    := 0;
  TabAugmentationCompetence.Cells[ColAugmCompTri, 0]     := 'Tri';
  TabAugmentationCompetence.ColWidths[ColAugmCompTri]    := 0;

  // Mise en forme du tableau des ajout des talents
  TabAugmentationTalent.Options                     := TabAugmentationTalent.Options + [goEditing, goAlwaysShowEditor];
  TabAugmentationTalent.ColCount                    := 12;
  TabAugmentationTalent.RowCount                    := 11;
  TabAugmentationTalent.ColWidths[0]                := 20;
  TabAugmentationTalent.ColWidths[ColAugmTalCode]   := 0;
  TabAugmentationTalent.ColWidths[2]                := 0;
  TabAugmentationTalent.Cells[ColAugmTalLib, 0]     := GetTexteLibelle('LAB_007');
  TabAugmentationTalent.ColWidths[ColAugmTalLib]    := 200;
  TabAugmentationTalent.Cells[ColAugmTalActuel, 0]  := GetTexteLibelle('LAB_016');
  TabAugmentationTalent.ColWidths[ColAugmTalActuel] := 80;
  TabAugmentationTalent.Cells[ColAugmTalNouveau, 0] := GetTexteLibelle('LAB_019');
  TabAugmentationTalent.ColWidths[ColAugmTalNouveau]:= 80;
  TabAugmentationTalent.Cells[ColAugmTalCout, 0]    := GetTexteLibelle('LAB_015');
  TabAugmentationTalent.ColWidths[ColAugmTalCout]   := 80;
  TabAugmentationTalent.Cells[ColAugmTalSpe, 0]     := GetTexteLibelle('LAB_078');
  TabAugmentationTalent.ColWidths[ColAugmTalSpe]    := 200;
  TabAugmentationTalent.Cells[ColAugmTalSpeSel, 0]  := 'Spé Choisie';
  TabAugmentationTalent.ColWidths[ColAugmTalSpeSel] := 0;
  TabAugmentationTalent.Cells[ColAugmTalWork, 0]    := 'Work';
  TabAugmentationTalent.ColWidths[ColAugmTalWork]   := 0;
  TabAugmentationTalent.Cells[ColAugmTalSort, 0]    := 'Sort';
  TabAugmentationTalent.ColWidths[ColAugmTalSort]   := 0;
  TabAugmentationTalent.Cells[ColAugmTalReel, 0]    := GetTexteLibelle('LAB_139');
  TabAugmentationTalent.ColWidths[ColAugmTalReel]   := 50;

  // Mise en forme de la table des historiques
  TabHistorique.Options        := TabHistorique.Options + [goEditing, goAlwaysShowEditor];
  TabHistorique.ColCount       := 4;
  TabHistorique.RowCount       := 2;
  TabHistorique.ColWidths[0]   := 20;
  TabHistorique.Cells[1, 0]    := GetTexteLibelle('LAB_036');
  TabHistorique.ColWidths[1]   := 200;
  TabHistorique.Cells[2, 0]    := GetTexteLibelle('LAB_037');
  TabHistorique.ColWidths[2]   := 0;
  TabHistorique.Cells[3, 0]    := 'Ordre';
  TabHistorique.ColWidths[3]   := 0;

  // Mise en forme de la table des Equipements
  TabEquipement.Options        := TabEquipement.Options + [goEditing, goAlwaysShowEditor];
  TabEquipement.ColCount       := 8;
  TabEquipement.RowCount       := 2;
  TabEquipement.ColWidths[0]   := 20;
  TabEquipement.Cells[1, 0]    := GetTexteLibelle('LAB_052');
  TabEquipement.ColWidths[1]   := 0;
  TabEquipement.Cells[2, 0]    := GetTexteLibelle('LAB_001');
  TabEquipement.ColWidths[2]   := 0;
  TabEquipement.Cells[3, 0]    := GetTexteLibelle('LAB_018');
  TabEquipement.ColWidths[3]   := 200;
  TabEquipement.Cells[4, 0]    := GetTexteLibelle('LAB_003');
  TabEquipement.ColWidths[4]   := 300;
  TabEquipement.Cells[5, 0]    := GetTexteLibelle('LAB_035');
  TabEquipement.ColWidths[5]   := 0;
  TabEquipement.Cells[6, 0]    := GetTexteLibelle('LAB_120');
  TabEquipement.ColWidths[6]   := 100;
  TabEquipement.Cells[7, 0]    := '';
  TabEquipement.ColWidths[7]   := 0;

  // Mise en forme dy tableau de choix des équipement de métier
  TabMetierEquipement.Options          := TabMetierEquipement.Options + [goEditing, goAlwaysShowEditor];
  TabMetierEquipement.ColCount         := 6;
  TabMetierEquipement.RowCount         := 1;
  TabMetierEquipement.ColWidths[0]     := 30;
  TabMetierEquipement.Cells[1, 0]      := GetTexteLibelle('LAB_001');
  TabMetierEquipement.ColWidths[1]     := 0;
  TabMetierEquipement.Cells[2, 0]      := GetTexteLibelle('LAB_013');
  TabMetierEquipement.ColWidths[2]     := 200;
  TabMetierEquipement.Cells[3, 0]      := GetTexteLibelle('LAB_010');
  TabMetierEquipement.ColWidths[3]     := 0;
  TabMetierEquipement.Cells[4, 0]      := GetTexteLibelle('LAB_018');
  TabMetierEquipement.ColWidths[4]     := 0;
  TabMetierEquipement.Cells[5, 0]      := GetTexteLibelle('LAB_120');
  TabMetierEquipement.ColWidths[5]     := 100;

  // mise en forme du tableau des choix des sorts
  TabSort.Options          := TabSort.Options + [goEditing, goAlwaysShowEditor];
  TabSort.ColCount         := 4;
  TabSort.RowCount         := 1;
  TabSort.ColWidths[0]     := 30;
  TabSort.Cells[1, 0]      := GetTexteLibelle('LAB_001');
  TabSort.ColWidths[1]     := 0;
  TabSort.Cells[2, 0]      := GetTexteLibelle('LAB_002');
  TabSort.ColWidths[2]     := 400;
  TabSort.Cells[3, 0]      := GetTexteLibelle('LAB_007');
  TabSort.ColWidths[3]     := 0;

  // mise en forme du tableau de création du Livre
  TabLivre.ColCount         := 5;
  TabLivre.RowCount         := 1;
  TabLivre.ColWidths[0]     := 20;
  TabLivre.Cells[1, 0]      := ConstSelectionne;
  TabLivre.ColWidths[1]     := 20;
  TabLivre.Cells[2, 0]      := GetTexteLibelle('LAB_014');
  TabLivre.ColWidths[2]     := 230;
  TabLivre.ColWidths[3]     := 0;
  TabLivre.ColWidths[4]     := 0;

  // mise en forme des couts des augmentation spéciales (mj)
  TabAugmentationMjXp.ColCount                   := 8;
  TabAugmentationMjXp.RowCount                   := 1;
  TabAugmentationMjXp.ColWidths[0]               := 20;
  TabAugmentationMjXp.Cells[ColAugmMjXpType, 0]  := GetTexteLibelle('LAB_018');  // Type
  TabAugmentationMjXp.ColWidths[ColAugmMjXpType] := 100;
  TabAugmentationMjXp.Cells[ColAugmMjXpCode, 0]  := GetTexteLibelle('LAB_001');  // Code
  TabAugmentationMjXp.ColWidths[ColAugmMjXpCode] := 100;
  TabAugmentationMjXp.Cells[ColAugmMjXpDebut, 0] := GetTexteLibelle('LAB_141');  // Début
  TabAugmentationMjXp.ColWidths[ColAugmMjXpDebut]:= 100;
  TabAugmentationMjXp.Cells[ColAugmMjXpFin, 0]   := GetTexteLibelle('LAB_142');  // Fin
  TabAugmentationMjXp.ColWidths[ColAugmMjXpFin]  := 100;
  TabAugmentationMjXp.Cells[ColAugmMjXpCout, 0]  := GetTexteLibelle('LAB_015');  // Coût
  TabAugmentationMjXp.ColWidths[ColAugmMjXpCout] := 100;
  TabAugmentationMjXp.Cells[ColAugmMjXpReel, 0]  := GetTexteLibelle('LAB_139');  // Coût réel
  TabAugmentationMjXp.ColWidths[ColAugmMjXpReel] := 100;
  TabAugmentationMjXp.Cells[ColAugmMjXpNew, 0]   := 'N';                         // nouvelle ligne
  TabAugmentationMjXp.ColWidths[ColAugmMjXpNew]  := 0;

  strings       := TStringList.Create;
  ExtractStrings(['['], [], PChar(LivresCharges), Strings);
  for I := 0 to (Strings.count - 1) Do
    begin
      TabLivre.RowCount        := TabLivre.RowCount + 1;
      Livre                    := Strings[I];
      Livre                    := StringReplace(StringReplace(Livre, '[', '', [rfReplaceAll]), ']', '', [rfReplaceAll]);
      TabLivre.Cells[2, I+1]   := GetTexteLibelle(Livre,'','',true);
      TabLivre.Cells[3, I+1]   := Livre;
      PLivre                   := ChercheLivreLibelle(Livre);
      Ordre                    := IntToStr(PLivre.Officiel);
      TabLivre.Cells[4, I+1]   := Ordre+Livre;
    end;
  strings.free;
  TabLivre.SortColRow(true,4);

  // rendre inactif
  LibRace.ReadOnly           := True;
  LibMetier.ReadOnly         := True;
end;

procedure TWinPersonnages.FormCreate(Sender: TObject);
  var
    Chemin:    String;
  begin
    // Initialisation
    Initialisation();

    // chargement du personnage
    Chemin := XmlPersonnageFichierActuel(GetCurrentDir+ConstCheminPersonnage+NomPersonnage);
    XmlChargePersonnage(Chemin);

    KeyPreview := true;
  end;


Procedure TWinPersonnages.AfficheImageRace();
  Var
    CheminImage1:   String;
    CheminImage2:   String;
    IndTabAttribut: Integer;
    PRaceAttribut:  StructureRaceAttribut;
  begin

    if RaceEnCours <> '' then
      begin
       CheminImage1       := CheminRaceImage(RaceEnCours,'2');
       CheminImage2       := CheminRaceImage(RaceEnCours,'1');
       end
    else
      begin
        CheminImage1       := '';
        CheminImage2       := '';
      end;
    if FileExists(CheminImage1) then
       ImageRace1.Picture.LoadFromFile(CheminImage1)
    else
       ImageRace1.Picture := nil;

    if FileExists(CheminImage2) then
       ImageRace2.Picture.LoadFromFile(CheminImage2)
    else
       ImageRace2.Picture := nil;

    // ATTRIBUTS
    IndTabAttribut := 1;
    for PRaceAttribut in ListRaceAttribut do
      if CompareRechercheValeur(PRaceAttribut.CodeRace, RaceEnCours) and (IndTabAttribut < ColAttBlessure) then
        begin
          Inc(IndTabAttribut);
          if IndTabAttribut = ColAttBlessure then
            RaceBlessure := PRaceAttribut.CalculRace
          else
            if CountOccurrences(PRaceAttribut.CalculRace,'+') > 0 then
              TabAttribut.Cells[IndTabAttribut, LigAttRace] := ExtractStringAfter(PRaceAttribut.CalculRace,'+')
            else
              TabAttribut.Cells[IndTabAttribut, LigAttRace] := PRaceAttribut.CalculRace;
            end;

    Self.Caption                               := GetTexteLibelle('LAB_081');
    LabelRace.Caption                          := GetTexteLibelle('LAB_042');
    LabelMetier.Caption                        := GetTexteLibelle('LAB_006');
    LabTabAttribut.Caption                     := GetTexteLibelle('LAB_008');
    LabTabTalent.Caption                       := GetTexteLibelle('LAB_007');
    LabTabCompetence.Caption                   := GetTexteLibelle('LAB_009');
    LabTabCarriere.Caption                     := GetTexteLibelle('LAB_096');
    LabTabExperience.Caption                   := GetTexteLibelle('LAB_097');
    LabTabAvancement.Caption                   := GetTexteLibelle('LAB_098');
    LabelCalcul.Caption                        := GetTexteLibelle('LAB_020');
    LabelXp.Caption                            := GetTexteLibelle('LAB_035');
    StaticTextPersonnage.Caption               := GetTexteLibelle('LAB_081');
    LabEquipement.Caption                      := GetTexteLibelle('LAB_100');
    ButtonAugmentation.Caption                 := GetTexteLibelle('LAB_101');
    ButtonSauvegarde.Caption                   := GetTexteLibelle('LAB_102');
    LabAugmentation.Caption                    := GetTexteLibelle('LAB_103');
    TabSheetAttribut.Caption                   := GetTexteLibelle('LAB_008');
    TabSheetTalent.Caption                     := GetTexteLibelle('LAB_007');
    TabSheetCompetence.Caption                 := GetTexteLibelle('LAB_009');
    TabSheetXP.Caption                         := GetTexteLibelle('LAB_104');
    TabSheetEvolution.Caption                  := GetTexteLibelle('LAB_105');
    TabSheetHistorique.Caption                 := GetTexteLibelle('LAB_036');
    ButtonRaceSelectionner.Caption             := GetTexteLibelle('LAB_004');
    ButtonHistorique.Caption                   := GetTexteLibelle('LAB_107');
    ButtonArme.Caption                         := '+'+GetTexteLibelle('LAB_063');
    ButtonArmure.Caption                       := '+'+GetTexteLibelle('LAB_065');
    ButtonSort.Caption                         := '+'+GetTexteLibelle('LAB_083');
    LabTabNiveau.Caption                       := GetTexteLibelle('LAB_019');
    RadioButtonRAS.Caption                     := GetTexteLibelle('LAB_113');
    RadioButtonSuivant.Caption                 := GetTexteLibelle('LAB_114');
    RadioButtonChanger.Caption                 := GetTexteLibelle('LAB_115');
    ButtonFabrication.Caption                  := '+'+GetTexteLibelle('LAB_125');
    ButtonDelete.Caption                       := '-'+GetTexteLibelle('LAB_126');
    LabelNeedTheoXp.caption                    := GetTexteLibelle('LAB_131');
    LabelNeedRealXp.Caption                    := GetTexteLibelle('LAB_132');
    TabSheetLivre.Caption                      := GetTexteLibelle('LAB_128');
    TabSheetMjCost.Caption                     := GetTexteLibelle('LAB_140');
    LabQuickArmor.Caption                      := GetTexteLibelle('LAB_149');
    LabAge.Caption                             := GetTexteLibelle('RULES-PDF_MAIN4_AGE');
    LabHeight.Caption                          := GetTexteLibelle('RULES-PDF_MAIN4_HEIGHT');
    LabHairColors.Caption                      := GetTexteLibelle('RULES-PDF_MAIN4_HAIR');
    LabEyeColors.Caption                       := GetTexteLibelle('RULES-PDF_MAIN4_EYES');

    ButtonHistorique.BringToFront;

  end;

procedure TWinPersonnages.ChargeImageNiveau(Niveau: Integer);
  // pour afficher les images des niveaux
  begin
      Picture  := TPicture.Create;
      Bitmap   := TBitmap.Create;
      try
        Path   :=GetCurrentDir+ConstCheminImageNiveau+InttoStr(Niveau)+'.PNG';
        Picture.LoadFromFile(Path);
        Bitmap.Assign(Picture.graphic);
        ListImage.Add(Bitmap, nil); // Ajout de l'image au TImageList
        ColorLoc := Bitmap.Canvas.Pixels[1, 1];
        ColorList[Niveau] := ColorLoc;
      finally
        Picture.Free;
        Bitmap.Free;
      end;
  end;

procedure TWinPersonnages.TabAttributDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
  var
    ImageIndex: Integer;
    CellWidth, CellHeight: Integer;
    MaxWidth, MaxHeight, ImageWidth, ImageHeight: Integer;
    AspectRatio: Double;
    LeftOffset, TopOffset: Integer;
    ImageRect: TRect;
    TopLeftPixelColor: TColor;
    Bitmap: TBitmap;

    CellText: string;
    TextWidth: Integer;
    TextX: Integer;
    TextY: Integer;
  begin
    if aRow = 0 then
      begin

        // Dessiner le texte de l'entête centré horizontalement et verticalement
        TabAttribut.Canvas.Font.Color := clWhite;
        TabAttribut.Canvas.Font.Style := [fsBold];
        TabAttribut.Canvas.Font.Size  := 10;
        TabAttribut.Canvas.Font.Name  := ConstPoliceArial;

        // Calculer la position x et y du texte pour l'alignement centré
        if aCol > 0 then
        begin
          // Dessiner le fond de la cellule de l'entête
          TabAttribut.Canvas.Brush.Color := clBlack;
          TabAttribut.Canvas.FillRect(aRect);
          CellText  := TabAttribut.Columns[aCol-1].Title.Caption; //TabAttribut.Cells[aCol, aRow];
          TextWidth := TabAttribut.Canvas.TextWidth(CellText);
          TextX     := aRect.Left + (aRect.Right - aRect.Left - TextWidth) div 2;
          TextY     := aRect.Top + (aRect.Bottom - aRect.Top - TabAttribut.Canvas.TextHeight(CellText)) div 2;

          // Dessiner le texte de l'entête
          TabAttribut.Canvas.TextRect(aRect, TextX, TextY, CellText);
        end;
      end
    else if (aRow = LigAttImage) then
      begin
        // Récupérer la valeur de la cellule correspondante (colonne 2)
        ImageIndex := StrToIntDef(TabAttribut.Cells[aCol, aRow], -1);

        // Vérifier que la valeur est valide et se situe dans la plage d'index d'image
        if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
        begin
          // Calculer la taille de la cellule
          CellWidth := aRect.Right - aRect.Left;
          CellHeight := aRect.Bottom - aRect.Top;

          // Calculer la taille maximale pour l'image en utilisant la taille de la cellule
          // et en ajustant l'aspect ratio de l'image
          MaxWidth := CellWidth;
          MaxHeight := CellHeight;
          ImageWidth := ListImage.Width;
          ImageHeight := ListImage.Height;
          if ImageWidth > 0 then
            begin
              AspectRatio := ImageHeight / ImageWidth;
              if ImageWidth > MaxWidth then
              begin
                ImageWidth := MaxWidth;
                ImageHeight := Round(ImageWidth * AspectRatio);
              end;
              if ImageHeight > MaxHeight then
              begin
                ImageHeight := MaxHeight;
                ImageWidth := Round(ImageHeight / AspectRatio);
              end;
            end;

            // Calculer la position de l'image pour centrer verticalement et horizontalement
          // dans la cellule
          LeftOffset:= (CellWidth - ImageWidth) div 2;
          TopOffset := (CellHeight - ImageHeight) div 2;
          ImageRect := Rect(aRect.Left + LeftOffset, aRect.Top + TopOffset, aRect.Left + LeftOffset + ImageWidth, aRect.Top + TopOffset + ImageHeight);

          // Obtenir la couleur du pixel en haut à gauche de l'image
          Bitmap := TBitmap.Create;
          try
            ListImage.GetBitmap(ImageIndex, Bitmap);
            TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
          finally
            Bitmap.Free;
          end;

          // Dessiner l'image dans la cellule avec la taille ajustée
          ListImage.Draw(TabAttribut.Canvas, ImageRect.Left, ImageRect.Top, ImageIndex);
        end
        else
          // Dessiner du texte par défaut si la valeur de l'index d'image est invalide
          TabAttribut.DefaultDrawCell(aCol, aRow, aRect, aState);
      end
    else
      begin
        // Obtenir la couleur du pixel en haut à gauche de l'image de la cellule précédente (colonne 2)
        Bitmap := TBitmap.Create;
        try
          ImageIndex := StrToIntDef(TabAttribut.Cells[aCol, LigAttImage], -1);
          if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
          begin
            ListImage.GetBitmap(ImageIndex, Bitmap);
            TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
          end
          else
            TopLeftPixelColor := clNone;
        finally
          Bitmap.Free;
        end;

        // Changer la couleur de fond de la cellule avec la couleur du pixel en haut à gauche de l'image
        if TopLeftPixelColor <> clNone then
        begin
          TabAttribut.Canvas.Brush.Color := TopLeftPixelColor;
          TabAttribut.Canvas.FillRect(aRect);
        end;

        // Changer la couleur du texte pour les colonnes 3 à 6
        TabAttribut.Canvas.Font.Color := clBlack;

        // Calculer la position x du texte pour l'alignement horizontal centré
        // en utilisant la largeur de la cellule et la largeur du texte
        CellText := TabAttribut.Cells[aCol, aRow];
        TextWidth := TabAttribut.Canvas.TextWidth(CellText);
        TextX := aRect.Left + (aRect.Right - aRect.Left - TextWidth) div 2;

        // Dessiner le texte avec l'alignement vertical centré
        TabAttribut.Canvas.FillRect(aRect);
        TabAttribut.Canvas.TextRect(aRect, TextX, aRect.Top + (aRect.Bottom - aRect.Top - TabAttribut.Canvas.TextHeight(CellText)) div 2, CellText);
      end;
  end;

Function TWinPersonnages.CalculXpMj(TypeDonnee: String; CodeDonnee:String): Integer;
  var
    IndLig:    Integer;
    Total:     Integer;
    PAttribut: StructureAttribut;
    Ajoute:    Boolean;
  begin
    Total := 0;
    For IndLig := 1 to TabAugmentationMjXp.RowCount-1 do
      begin
        if (TabAugmentationMjXp.Cells[ColAugmMjXpType, IndLig] = TypeDonnee) then
          begin
            if TypeDonnee = ConstXmlCarac then
              begin
                PAttribut  := ChercheAttribut(codeDonnee);
                Ajoute := (TabAugmentationMjXp.Cells[ColAugmMjXpCode, IndLig] = PAttribut.Resume);
              end
            else
              Ajoute := (TabAugmentationMjXp.Cells[ColAugmMjXpCode, IndLig] = CodeDonnee);

            if Ajoute then
              Total := Total
                       - StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpCout, IndLig],0)
                       + StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpReel, IndLig],0);
          end;
      end;
    if (CheckBoxXpDiv25.checked = True) then
       Total := Total * 25;
    result := total;
  end;

procedure TWinPersonnages.CalculTotaux();
  Var
    IndCol:     Integer;
    Total:      Integer = 0;
    IndLig:     Integer;
    TabAtt:     String;
    TabComp:    String;
  begin
    // Attributs
    for IndCol := 2 to TabAttribut.ColCount-1 do
      begin
        Total  := StrToIntdef(TabAttribut.Cells[IndCol, LigAttRace],0) +
                  StrToIntdef(TabAttribut.Cells[IndCol, LigAttLance],0)+
                  StrToIntdef(TabAttribut.Cells[IndCol, LigAttTalent],0);
        TabAttribut.Cells[IndCol, LigAttBase] := IntToStr(Total);
        Total  := Total +
                  StrToIntdef(TabAttribut.Cells[IndCol, LigAttBonus],0);
        TabAttribut.Cells[IndCol, LigAttTotal]:= IntToStr(Total);
      end;

    // Compétences
    for IndLig := 1 to TabCompetence.RowCount-1 do
      begin
        for IndCol := 1 to TabAttribut.Colcount-1 do
          begin
            TabAtt := TabAttribut.Cells[IndCol, LigAttcode];
            TabComp:= TabCompetence.Cells[ColCompStat, IndLig];
            if CompareRechercheValeur(TabComp, TabAtt) then
              begin
                TabCompetence.Cells[ColCompAtt, IndLig] := TabAttribut.Cells[IndCol, LigAttTotal];
                break
              end;
          end;
        TabCompetence.Cells[ColCompBonus, IndLig] := IntToStr(StrToIntDef(TabCompetence.Cells[ColComp35, IndLig],0) +
                                                              StrToIntDef(TabCompetence.Cells[ColComp40, IndLig],0) +
                                                              StrToIntDef(TabCompetence.Cells[ColCompWork, IndLig],0));
        TabCompetence.Cells[ColCompTotal, IndLig] := IntToStr(StrToIntDef(TabCompetence.Cells[ColCompBonus, IndLig],0) +
                                                              StrToIntDef(TabCompetence.Cells[ColCompAtt, IndLig],0));
      end;

  end;

procedure TWinPersonnages.TabAttributSelectEditor(Sender: TObject; aCol,
    aRow: Integer; var Editor: TWinControl);
  begin
    Editor := nil;
  end;

procedure TWinPersonnages.TabAugmentationAttributEditingDone(Sender: TObject);
  var
    Value: String;
  begin
    if TabAugmentationAttribut.Col = ColAugmAttNouveau then
      begin
        Value := TabAugmentationAttribut.Cells[ColAugmAttNouveau, TabAugmentationAttribut.Row];
        TabAugmentationAttributCalcul(TabAugmentationAttribut.Row, Value);
        TabAugmentationAttribut.Cells[ColAugmAttNouveau, TabAugmentationAttribut.Row] := Value;
      end
    else if TabAugmentationAttribut.Col = ColAugmAttReel then
      CalculTableExperience();
  end;

procedure TWinPersonnages.TabAugmentationAttributKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  Value: String = '0';
begin
  if ((Key >= 96) and (Key <= 106)) or (Key = 8) then
    if TabAugmentationAttribut.Col = ColAugmAttNouveau then
      begin
         if TabAugmentationAttribut.Cells[ColAugmAttNouveau, TabAugmentationAttribut.row] <> '' then
          Value := TabAugmentationAttribut.Cells[ColAugmAttNouveau, TabAugmentationAttribut.row];
        TabAugmentationAttributCalcul(TabAugmentationAttribut.Row, Value);
        if Value = '0' then Value := '';
        TabAugmentationAttribut.Cells[ColAugmAttNouveau, TabAugmentationAttribut.Row] := Value;
      end
    else if TabAugmentationAttribut.Col = ColAugmAttReel then
      CalculTableExperience();
end;

procedure TWinPersonnages.TabAugmentationAttributMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Nouveau: Integer = 0;
  aRow:    Integer = 0;
  aCol:    Integer = 0;
  Value:   String;
begin
  TabAugmentationAttribut.MouseToCell(X, Y, ACol, ARow);
  if (aRow > 0) and ((aCol = colAugmAttPlus5) or (aCol = ColAugmAttMoins5)) then
    begin
      Nouveau := StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttNouveau, ARow],0);
       if aCol = colAugmAttPlus5 then
         Nouveau += 5
       else if aCol = colAugmAttMoins5 then
         if (Nouveau - 5) >= StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttActuel, ARow],0) then
           Nouveau -= 5;
       Value := IntToStr(Nouveau);
       TabAugmentationAttributCalcul(ARow, Value);
       if Value = '0' then
         Value := '';
       TabAugmentationAttribut.Cells[ColAugmAttNouveau, ARow] := Value;
       CalculTableExperience();
    end;
end;

procedure TWinPersonnages.TabAugmentationCompetenceEditingDone(Sender: TObject);
  var
    Value: String;
  begin
    if TabAugmentationCompetence.Col = ColAugmCompNouveau then
      begin
        Value := TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row];
        TabAugmentationCompetenceCalcul(TabAugmentationCompetence.Row, Value);
        TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row] := Value;
      end
    else if TabAugmentationCompetence.Col = ColAugmCompReel then
      CalculTableExperience();

  end;

procedure TWinPersonnages.TabAugmentationCompetenceKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
  var
    Value: String = '0';
  begin
    if ((Key >= 96) and (Key <= 106)) or (Key = 8) then
      if TabAugmentationCompetence.Col = ColAugmCompNouveau then
        begin
          if TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row] <> '' then
            Value := TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row];
          TabAugmentationCompetenceCalcul(TabAugmentationCompetence.Row, Value);
          if Value = '0' then Value := '';
          TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row] := Value;
        end
      else if TabAugmentationCompetence.Col = ColAugmCompReel then
        CalculTableExperience();
  end;

procedure TWinPersonnages.TabAugmentationCompetenceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var
    Nouveau: Integer = 0;
    aRow:    Integer = 0;
    aCol:    Integer = 0;
    Value:   String;
  begin
    TabAugmentationCompetence.MouseToCell(X, Y, ACol, ARow);
    if (aRow > 0) and ((aCol = colAugmCompPlus5) or (aCol = ColAugmCompMoins5)) then
      begin
        Nouveau := StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompNouveau, ARow],0);
         if aCol = colAugmCompPlus5 then
           Nouveau += 5
         else if aCol = colAugmCompMoins5 then
           if (Nouveau - 5) >= StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, ARow],0) then
             Nouveau -= 5;
         Value := IntToStr(Nouveau);
         TabAugmentationCompetenceCalcul(ARow, Value);
         if Value = '0' then
           Value := '';
         TabAugmentationCompetence.Cells[ColAugmCompNouveau, ARow] := Value;
         CalculTableExperience();
      end;
  end;
procedure TWinPersonnages.TabAugmentationCompetenceDblClick(Sender: TObject);
  var
    Ind:         Integer;
    Trouve:      Boolean = false;
    PCompetence: StructureCompetence;
    Value:       String;
    Ind2:        Integer;
  begin
    if (TabAugmentationCompetence.Col = ColAugmCompSpe) and (TabAugmentationCompetence.Cells[ColAugmCompSpe, TabAugmentationCompetence.Row] = GetTexteLibelle(ConstLabSelSpe))  then
      begin
        // ajouter une spécialité
        ChoixWinTypeFichier         := ConstXmlSousChapitreCompetence;
        ChoixWinCompetence          := TabAugmentationCompetence.Cells[ColAugmCompCode, TabAugmentationCompetence.Row];
        FenSpecialisation           := TWinSpecialisations.Create(Application);
        FenSpecialisation.Position  := poOwnerFormCenter;
        FenSpecialisation.ShowModal;
        if SelectWinCompetence <> '' then
          begin
            TabAugmentationCompetence.Cells[ColAugmCompSpe, TabAugmentationCompetence.Row]    := GetTexteLibelle('LAB_130');
            TabAugmentationCompetence.Cells[ColAugmCompSpeSel, TabAugmentationCompetence.Row] := SelectWinCompetence;
            PCompetence                                                                       := ChercheCompetence(SelectWinCompetence);

            TabAugmentationCompetence.Cells[ColAugmCompLib, TabAugmentationCompetence.Row] := PCompetence.Libelle;

            // A - récupérer la valeur si la spécialisation existe déjà (AVANT tout renommage)
            for Ind := 1 to TabCompetence.RowCount - 1 do
              if TabCompetence.Cells[ColCompCode, Ind] = SelectWinCompetence then
                begin
                  Value := TabCompetence.Cells[ColCompBonus, Ind];
                  if TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row]
                     = TabAugmentationCompetence.Cells[ColAugmCompActuel, TabAugmentationCompetence.Row] then
                    TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row] := Value;
                  TabAugmentationCompetence.Cells[ColAugmCompActuel, TabAugmentationCompetence.Row] := Value;
                  Value := TabAugmentationCompetence.Cells[ColAugmCompNouveau, TabAugmentationCompetence.Row];
                  TabAugmentationCompetenceCalcul(TabAugmentationCompetence.Row, Value);
                  break;
                end;

            // B - le choix devient le code de référence de la ligne
            TabAugmentationCompetence.Cells[ColAugmCompCode, TabAugmentationCompetence.Row] := SelectWinCompetence;

            // C - propager au tableau métier (persistance)
            for Ind2 := 0 to High(Personnage.MetierCompetence) do
              if Personnage.MetierCompetence[Ind2].CodeCompetence = ChoixWinCompetence then
                begin
                  Personnage.MetierCompetence[Ind2].CodeCompetence := SelectWinCompetence;
                  break;
                end;
          end;
      end
    else if (TabAugmentationCompetence.Col = ColCompLib) and (TabAugmentationCompetence.Cells[ColAugmCompLib, TabAugmentationCompetence.Row] = GetTexteLibelle(ConstLabAdd))  then
      begin
        // ajouter une compétence
        ChoixWinTypeFichier         := ConstXmlSousChapitreCompetence;
        ChoixWinCompetence          := '';
        FenCompetence               := TWinCompetence.Create(Application);
        FenCompetence.Position      := poOwnerFormCenter;
        FenCompetence.ShowModal;
        if SelectWinCompetence <> '' then
          begin
            // vérifier que cela n'existe pas déjà dans la table
            for Ind := 1 to TabAugmentationCompetence.RowCount - 1 do
              if SelectWinCompetence = TabAugmentationCompetence.Cells[ColAugmCompCode, Ind] then
                begin
                  trouve := true;
                  break;
                end;
            if Trouve then
               ShowMessage(GetTexteLibelle('MESS_047'))  // déjà présent
            else
              begin
                // ajouter la compétence et ajouter une nouvelle ligne dans la table
                PCompetence                                                                     := ChercheCompetence(SelectWinCompetence);
                TabAugmentationCompetence.Cells[ColAugmCompCode, TabAugmentationCompetence.Row] := PCompetence.CodeCompetence;
                TabAugmentationCompetence.Cells[ColAugmCompLib, TabAugmentationCompetence.Row]  := PCompetence.Libelle;
                AugmentationAjouteXpMj(ConstXmlCompetence);
              end;
          end;
      end
    else if (TabAugmentationCompetence.Col <> ColAugmCompPlus5) and (TabAugmentationCompetence.Col <> ColAugmCompMoins5) then
      begin
        // ouvrir les compétence
        SelectWinCompetence     := TabAugmentationCompetence.Cells[ColAugmCompCode,TabAugmentationCompetence.Row];
        FenCompetence           := TWinCompetence.Create(Application);
        FenCompetence.Position  := poOwnerFormCenter;
        FenCompetence.ShowModal;
      end;
    SelectWinCompetence     := '';
  end;

procedure TWinPersonnages.TabAugmentationTalentDblClick(Sender: TObject);
  var
    PTalent: StructureTalent;
    Ind:     Integer;
    Ind2:    Integer;
    Trouve:  Boolean = false;
  begin
    if (TabAugmentationTalent.Col = ColAugmTalSpe) and (TabAugmentationTalent.Cells[ColAugmTalSpe, TabAugmentationTalent.Row] = GetTexteLibelle(ConstLabSelSpe))  then
      begin
        ChoixWinTypeFichier         := ConstXmlSousChapitreTalent;
        ChoixWinTalent              := TabAugmentationTalent.Cells[ColAugmTalCode, TabAugmentationTalent.Row];
        FenSpecialisation           := TWinSpecialisations.Create(Application);
        FenSpecialisation.Position  := poOwnerFormCenter;
        FenSpecialisation.ShowModal;
        if SelectWinTalent <> '' then
          begin
            TabAugmentationTalent.Cells[ColAugmTalSpe, TabAugmentationTalent.Row] := GetTexteLibelle('LAB_130');
            TabAugmentationTalent.Cells[ColAugmTalSpeSel, TabAugmentationTalent.Row] := SelectWinTalent;
            PTalent := ChercheTalent(SelectWinTalent);
            TabAugmentationTalent.Cells[ColAugmTalLib, TabAugmentationTalent.Row] := PTalent.Libelle;

            // A - récupérer la valeur si le talent choisi existe déjà dans la fiche
            for Ind := 1 to TabTalent.RowCount - 1 do
              if TabTalent.Cells[ColTalCode, Ind] = SelectWinTalent then
                begin
                  TabAugmentationTalent.Cells[ColAugmTalActuel, TabAugmentationTalent.Row]  := TabTalent.Cells[ColTalNb, Ind];
                  if TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.Row] = '' then
                    TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.Row] := TabTalent.Cells[ColTalNb, Ind];
                  break;
                end;

            // B - le choix devient le code de référence de la ligne
            TabAugmentationTalent.Cells[ColAugmTalCode, TabAugmentationTalent.Row] := SelectWinTalent;

            // C - propager au tableau métier (persistance)
            for Ind2 := 0 to High(Personnage.MetierTalent) do
              if Personnage.MetierTalent[Ind2].CodeTalent = ChoixWinTalent then
                begin
                  Personnage.MetierTalent[Ind2].CodeTalent := SelectWinTalent;
                  break;
                end;
          end;
      end
    else if (TabAugmentationTalent.Col = ColCompLib) and (TabAugmentationTalent.Cells[ColAugmCompLib, TabAugmentationTalent.Row] = GetTexteLibelle(ConstLabAdd))  then
      begin
        // ajouter un talent
        ChoixWinTypeFichier     := ConstXmlSousChapitreTalent;
        ChoixWinTalent          := '';
        FenTalent               := TWintTalent.Create(Application);
        FenTalent.Position      := poOwnerFormCenter;
        FenTalent.ShowModal;
        if SelectWinTalent <> '' then
          begin
            // vérifier que cela n'existe pas déjà dans la table
            for Ind := 1 to TabAugmentationTalent.RowCount - 1 do
              if SelectWinTalent = TabAugmentationTalent.Cells[ColAugmTalCode, Ind] then
                begin
                  trouve := true;
                  break;
                end;
            if Trouve then
               ShowMessage(GetTexteLibelle('MESS_047'))  // déjà présent
            else
              begin
                // ajouter le talent et ajouter une nouvelle ligne dans la table
                PTalent                                                                := ChercheTalent(SelectWinTalent);
                TabAugmentationTalent.Cells[ColAugmTalCode, TabAugmentationTalent.Row] := PTalent.CodeTalent;
                TabAugmentationTalent.Cells[ColAugmtalLib, TabAugmentationTalent.Row]  := PTalent.Libelle;
                AugmentationAjouteXpMj(ConstXmlTalent);
              end;
          end;
      end
    else
      begin
        // ouvrir les Talents
        SelectWinTalent     := TabAugmentationTalent.Cells[ColAugmTalCode, TabAugmentationTalent.Row];
        FenTalent           := TWintTalent.Create(Application);
        FenTalent.Position  := poOwnerFormCenter;
        FenTalent.ShowModal;
        ChoixWinTalent      := '';
      end;
    SelectWinTalent := '';
  end;

procedure TWinPersonnages.TabAugmentationTalentEditingDone(Sender: TObject);
  var
    Value: String;
  begin
    if TabAugmentationTalent.Col = ColAugmTalNouveau then
      begin
        Value := TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.Row];
        TabAugmentationTalentCalcul(TabAugmentationTalent.Row, Value);
        TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.Row] := Value;
      end
    else if TabAugmentationTalent.Col = ColAugmTalReel then
      CalculTableExperience();
  end;

procedure TWinPersonnages.TabAugmentationTalentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
  var
    Value: String = '0';
  begin
    if ((Key >= 96) and (Key <= 106)) or (Key = 8) then
      if TabAugmentationTalent.Col = ColAugmTalNouveau then
        begin
          SortAffiche();
          if TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.row] <> '' then
            Value := TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.row];
          TabAugmentationTalentCalcul(TabAugmentationTalent.row, Value);
          if Value = '0' then Value := '';
          TabAugmentationTalent.Cells[ColAugmTalNouveau, TabAugmentationTalent.row] := Value;
        end
      else if TabAugmentationTalent.Col = ColAugmTalReel then
        CalculTableExperience();
  end;

procedure TWinPersonnages.TabCarriereDblClick(Sender: TObject);
  begin
        // ouvrir les métiers
      SelectWinMetier     := TabCarriere.Cells[1,TabCArriere.Row];
      FenMetier           := TWinMetiers.Create(Application);
      FenMetier.Position  := poOwnerFormCenter;
      FenMetier.ShowModal;
      SelectWinMetier     := '';
  end;

procedure TWinPersonnages.TabCompetenceDblClick(Sender: TObject);
  begin
    // ouvrir les compétence
    SelectWinCompetence     := TabCompetence.Cells[1,TabCompetence.Row];
    FenCompetence           := TWinCompetence.Create(Application);
    FenCompetence.Position  := poOwnerFormCenter;
    FenCompetence.ShowModal;
    SelectWinCompetence     := '';
  end;

procedure TWinPersonnages.XmlChargePersonnage(const FileName: string);
var
  Nb:                    Integer = 1;
  IndTab:                Integer;
  NbTalent:              Integer = 0;
  NbCompetence:          Integer = 0;
  NbCarriere:            Integer = 0;
  Lig:                   Integer = 0;
  PRace:                 StructureRace;
  PTalent:               StructureTalent;
  PCompetence:           StructureCompetence;
  PMetier:               StructureMetier;
  PArme:                 StructureArme;
  PArmure:               StructureArmure;
  PArmureSimplifiee:     StructureArmureSimplifiee;
  PSort:                 StructureSort;
  PAttribut:             StructureAttribut;
  Ind:                   Integer;
  Trouve:                Boolean;

begin

  Personnage := PersonnageXmlChargement(FileName);
  if (Pos(AjouteAccolade(ConstXmlOptionXpDiv25), Personnage.Options) > 0) then
    begin
      EditTotalXp25.Enabled     := True;
      EditTotalXp.Enabled       := False;
      CheckBoxXpDiv25.Checked   := True;
    end
  else
    begin
      EditTotalXp25.Enabled     := False;
      EditTotalXp.Enabled       := true;
    end;
  if (Pos(AjouteAccolade(ConstXmlOptionFeldo2P),Personnage.Options) > 0) then
    CheckBoxPdfFeldo2p.Checked:= True;
  if (Pos(AjouteAccolade(ConstXmlOptionQuickArmor),Personnage.Options) > 0) then
    CheckBoxQuickArmor.Checked:= True;

  // nom du joueur
  PersonnageNom.Caption     := Personnage.NomPersonnage;
  EditAge.Text              := IntToStr(Personnage.Age);
  EditHeight.Text           := IntToStr(Personnage.Height);
  EditHairColors.Text       := Personnage.HairColors;
  EditEyeColors.Text        := Personnage.EyeColors;
  if (EditTotalXp25.Enabled = True) then
    tabExperience.Cells[ColXpDonnee, LigXpTotal] := Format('%.0n',[Personnage.Xp25Total/1])+' '
  else
    tabExperience.Cells[ColXpDonnee, LigXpTotal] := Format('%.0n',[Personnage.XpTotal/1])+' ';

  // Race
  RaceEnCours               := Personnage.Race;
  PRace                     := ChercheRace(RaceEnCours);
  LibRace.Caption           := PRace.Libelle;
  AfficheImageRace();

  // Metier
  PersonnageMetier := Personnage.MetierEnCours;
  MetierEnCours    := PersonnageMetier.CodeMetier;
  MetierNvEnCours  := IntToStr(PersonnageMetier.NiveauMetier);
  PMetier          := ChercheMetier(MetierEnCours);
  LibMetier.Caption:= PMetier.Libelle;

  AfficheImageMetier();

  // Attributs
  for PersonnageAttribut in Personnage.CreationAttribut do
    begin
      Inc(Nb);
      PAttribut                               := ChercheAttribut(PersonnageAttribut.CodeAttribut);
      TabAttribut.Columns[Nb-1].Title.Caption := PAttribut.Resume;
      TabAttribut.Cells[Nb, LigAttLance]      := IntToStr(PersonnageAttribut.Valeur);
    end;

  // Lire les compétences de la sous-section COMP
  for PersonnageCompetence in Personnage.CreationCompetence35 do
    begin
      Lig  := FindRowByText(TabCompetence, PersonnageCompetence.CodeCompetence, ColCompCode);
      if Lig = -1 then
        begin
          NbCompetence            := NbCompetence + 1;
          TabCompetence.RowCount  := TabCompetence.RowCount + 1;
          Lig                     := NbCompetence;
        end;
      TabCompetence.Cells[ColCompCode , Lig] := PersonnageCompetence.CodeCompetence;
      if (CheckBoxXpDiv25.checked = true) then
        TabCompetence.Cells[ColComp35, Lig]  := IntToStr(5)
      else
        TabCompetence.Cells[ColComp35, Lig]  := IntToStr(PersonnageCompetence.Valeur);
      PCompetence                            := ChercheCompetence(TabCompetence.Cells[1, lig]);
      TabCompetence.Cells[ColCompLib, Lig]   := PCompetence.Libelle;
      TabCompetence.Cells[ColCompStat, Lig]  := PCompetence.CodeAttribut;
      PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
      TabCompetence.Cells[ColCompCarac, Lig] := PAttribut.Resume;
    end;

  // Lire les compétences de la sous-section COMP
  for PersonnageCompetence in Personnage.CreationCompetence40 do
    begin
      Lig  := FindRowByText(TabCompetence, PersonnageCompetence.CodeCompetence, ColCompCode);
      if Lig = -1 then
        begin
          NbCompetence            := NbCompetence + 1;
          TabCompetence.RowCount  := TabCompetence.RowCount + 1;
          Lig                     := NbCompetence;
        end;
      TabCompetence.Cells[ColCompCode , Lig] := PersonnageCompetence.CodeCompetence;
      TabCompetence.Cells[ColComp40, Lig]    := IntToStr(PersonnageCompetence.Valeur);
      PCompetence                            := ChercheCompetence(TabCompetence.Cells[1, lig]);
      TabCompetence.Cells[ColCompLib, Lig]   := PCompetence.Libelle;
      TabCompetence.Cells[ColCompStat, Lig]  := PCompetence.CodeAttribut;
      PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
      TabCompetence.Cells[ColCompCarac, Lig] := PAttribut.Resume;
    end;


  // Lire les talents de la sous-section TALENT
  For PersonnageTalent in Personnage.CreationTalent do
    begin
      Inc(NbTalent);
      TabTalent.RowCount              := TabTalent.RowCount + 1;
      TabTalent.Cells[ColTalCode, NbTalent]    := PersonnageTalent.CodeTalent;
      TabTalent.Cells[ColTalNb, NbTalent]    := IntToStr(StrToIntDef(TabTalent.Cells[ColTalNb, NbTalent],0) + PersonnageTalent.Valeur);
      TabTalent.Cells[ColTalNbCrea, NbTalent]    := IntToStr(PersonnageTalent.Valeur);
      PTalent                         := ChercheTalent(TabTalent.Cells[ColTalCode, NbTalent]);
      TabTalent.Cells[ColTalLib, NbTalent]    := PTalent.Libelle;
      if PTalent.SousTalent then
        PTalent                       := ChercheTalent(copy(PTalent.CodeTalent,1,5)+'_*');
      TabTalent.Cells[ColTalMax, NbTalent]    := Ptalent.MaxiTalent;
      TalentAttribut(PTalent.Attribut);
      end;

  // carrières
  for PersonnageMetier in Personnage.MetierAncien do
    begin
      Inc(NbCarriere);
      TabCarriere.RowCount             := TabCarriere.RowCount + 1;
      TabCarriere.Cells[1,NbCarriere]  := PersonnageMetier.CodeMetier;
      TabCarriere.Cells[2,NbCarriere]  := IntToStr(PersonnageMetier.NiveauMetier);
      PMetier                          := chercheMetier(PersonnageMetier.CodeMetier);
      TabCarriere.Cells[3,NbCarriere]  := PMetier.Libelle;
      TabCarriere.Cells[4,NbCarriere]  := IntToStr(CalculOptionXpDiv25(PersonnageMetier.CoutXp));
    end;

  // Augmentation

  // attribut
  For PersonnageAttribut in Personnage.AugmentationAttribut do
    For IndTab := 1 to TabAttribut.ColCount - 1 do
      if TabAttribut.Cells[IndTab, LigAttCode] = PersonnageAttribut.CodeAttribut then
        TabAttribut.Cells[IndTab, LigAttBonus] := IntToStr(PersonnageAttribut.Valeur);

  // compétence
  For PersonnageCompetence in Personnage.AugmentationCompetence do
    begin
      Lig  := FindRowByText(TabCompetence, PersonnageCompetence.CodeCompetence, ColCompCode);
      if Lig = -1 then
        begin
          NbCompetence            := NbCompetence + 1;
          TabCompetence.RowCount  := TabCompetence.RowCount + 1;
          Lig                     := NbCompetence;
        end;
      TabCompetence.Cells[ColCompCode , Lig] := PersonnageCompetence.CodeCompetence;
      TabCompetence.Cells[ColCompWork, Lig]  := IntToStr(PersonnageCompetence.Valeur);
      PCompetence                            := ChercheCompetence(TabCompetence.Cells[1, lig]);
      TabCompetence.Cells[ColCompLib, Lig]   := PCompetence.Libelle;
      TabCompetence.Cells[ColCompStat, Lig]  := PCompetence.CodeAttribut;
      PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
      TabCompetence.Cells[ColCompCarac, Lig] := PAttribut.Resume;
    end;

  // Talent
    For PersonnageTalent in Personnage.AugmentationTalent do
      begin
        Lig  := FindRowByText(TabTalent, PersonnageTalent.CodeTalent, 1);
        if Lig = -1 then
          begin
            NbTalent            := NbTalent + 1;
            TabTalent.RowCount  := TabTalent.RowCount + 1;
            Lig                 := NbTalent;
          end;
          TabTalent.Cells[ColTalCode, Lig]    := PersonnageTalent.CodeTalent;
          TabTalent.Cells[ColTalNb, Lig]    := IntToStr(StrToIntDef(TabTalent.Cells[ColTalNb, Lig],0) + PersonnageTalent.Valeur);
          TabTalent.Cells[ColTalNbAugm, Lig]   := IntToStr(PersonnageTalent.Valeur);
          PTalent                    := ChercheTalent(TabTalent.Cells[ColTalCode, Lig]);
          TabTalent.Cells[ColTalLib, Lig]    := PTalent.Libelle;
          if PTalent.SousTalent then
            PTalent                  := ChercheTalent(copy(PTalent.CodeTalent,1,5)+'_*');
          TabTalent.Cells[ColTalMax, Lig]    := Ptalent.MaxiTalent;
          TabTalent.Cells[ColTalXp, Lig]    := IntToStr(CalculExperience(ConstXmlTalent, 0, StrToIntDef(TabTalent.Cells[ColTalNbAugm, Lig],0), PersonnageTalent.CodeTalent, ''));
          TalentAttribut(PTalent.Attribut);
        end;

  // Compétence métier
  for PersonnageCompetence in Personnage.MetierCompetence do
    for Ind := 1 to TabCompetence.RowCount - 1 do
      if TabCompetence.Cells[ColCompCode, Ind] = PersonnageCompetence.CodeCompetence then
        if (TabCompetence.Cells[ColCompImage, Ind] < '1') or (IntToStr(PersonnageCompetence.Valeur) < TabCompetence.Cells[ColCompImage, Ind]) then
          TabCompetence.Cells[ColCompImage, Ind] := IntToStr(PersonnageCompetence.Valeur);

  // Competence liées à un talent
  For PersonnageTalentCompetence in Personnage.TalentCompetence do
    begin
      // vérifier si la compétence est déjà dans la table des compétences
      Trouve := false;
      For Ind := 1 to TabCompetence.RowCount - 1 do
        if TabCompetence.Cells[ColCompCode, Ind] = PersonnageTalentCompetence.CodeCompetence then
          begin
            TabCompetence.Cells[ColCompTalent, Ind] := PersonnageTalentCompetence.CodeTalent;
            Trouve := true;
            break;
          end;
       // ajouter si elle n'existe pas encore
       if not trouve then
         begin
           NbCompetence                           := NbCompetence + 1;
           TabCompetence.RowCount                 := TabCompetence.RowCount + 1;
           Ind                                    := NbCompetence;
           PCompetence                            := ChercheCompetence(PersonnageTalentCompetence.CodeCompetence);
           TabCompetence.Cells[ColCompCode , Ind] := PCompetence.CodeCompetence;
           TabCompetence.Cells[ColCompLib, Ind]   := PCompetence.Libelle;
           TabCompetence.Cells[ColCompTalent, Ind]:= PersonnageTalentCompetence.CodeTalent;
           TabCompetence.Cells[ColCompStat, Ind]  := PCompetence.CodeAttribut;
           PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
           TabCompetence.Cells[ColCompCarac, Lig] := PAttribut.Resume;
         end;
       TabCompetence.Cells[ColCompLib, Ind]       := TabCompetence.Cells[ColCompLib, Ind] + '*';
    end;

  // équipement et sorts
  NbEquipement := 0;
  TabEquipement.RowCount := 1;
  for PersonnageEquipement in Personnage.Equipement do
    begin
      Inc(NbEquipement);
      TabEquipement.RowCount                 := TabEquipement.RowCount + 1;
      TabEquipement.Cells[2, NbEquipement]   := PersonnageEquipement.CodeEquipement;
      TabEquipement.Cells[3, NbEquipement]   := TrimRight(PersonnageEquipement.TypeEquipement);
      if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipWe) then
          begin
            PArme := chercheArme(PersonnageEquipement.CodeEquipement);
            TabEquipement.Cells[4, NbEquipement]   := PArme.Libelle;
            TabEquipement.Cells[5, NbEquipement]   := PersonnageEquipement.QualiteEquipement;
          end
      else if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipAr) then
          Begin
            PArmure := ChercheArmure(PersonnageEquipement.CodeEquipement);
            TabEquipement.Cells[4, NbEquipement]   := PArmure.Libelle;
            TabEquipement.Cells[5, NbEquipement]   := PersonnageEquipement.QualiteEquipement;
          end
      else if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipArS) then
          Begin
            PArmureSimplifiee := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
            TabEquipement.Cells[4, NbEquipement]   := PArmureSimplifiee.Libelle;
            TabEquipement.Cells[5, NbEquipement]   := PersonnageEquipement.QualiteEquipement;
          end
      else if TrimRight(PersonnageEquipement.TypeEquipement) = TrimRight(TypeEquipDi) then
          Begin
            TabEquipement.Cells[4, NbEquipement]   := PersonnageEquipement.CodeEquipement;
            TabEquipement.Cells[5, NbEquipement]   := PersonnageEquipement.QualiteEquipement;
          end
      else if TrimRight(PersonnageEquipement.TypeEquipement) =TrimRight(TypeEquipSp) then
          begin
            PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
            TabEquipement.Cells[3, NbEquipement]   := PSort.TypeSort;
            TabEquipement.Cells[4, NbEquipement]   := PSort.Libelle;
            TabEquipement.Cells[5, NbEquipement]   := IntToStr(CalculOptionXpDiv25(PersonnageEquipement.CoutXp));
          end;
    end;

  // livres
  for Lig := 1 to TabLivre.RowCount - 1 do
    begin
      if (pos(ajouteaccolade(TabLivre.Cells[3, Lig]),Personnage.LivresAcceptes) > 0) or (TabLivre.Cells[3, Lig] = ConstRulesBook) then
        TabLivre.Cells[1, Lig] := ConstSelectionne
      else
        TabLivre.Cells[1, Lig] := '';
    end;

  // Augmentation Xp Mj Attribut
  Lig := 0;
  For PersonnageXpAttribut in Personnage.XpCoutAttribut do
    begin
      Inc(Lig);
      TabAugmentationMjXp.Rowcount                     := TabAugmentationMjXp.Rowcount + 1;
      TabAugmentationMjXp.Cells[ColAugmMjXpType, Lig]  := ConstXmlCarac;
      TabAugmentationMjXp.Cells[ColAugmMjXpCode, Lig]  := PersonnageXpAttribut.CodeAttribut;
      TabAugmentationMjXp.Cells[ColAugmMjXpDebut, Lig] := IntToStr(PersonnageXpAttribut.Debut);
      TabAugmentationMjXp.Cells[ColAugmMjXpFin, Lig]   := IntToStr(PersonnageXpAttribut.Fin);
      TabAugmentationMjXp.Cells[ColAugmMjXpCout, Lig]  := IntToStr(CalculExperience(ConstXmlCarac, PersonnageXpAttribut.Debut, PersonnageXpAttribut.Fin, '', ''));
      TabAugmentationMjXp.Cells[ColAugmMjXpReel, Lig]  := IntToStr(PersonnageXpAttribut.CoutXp);
    end;

  // Augmentation Xp Mj Competence
  For PersonnageXpCompetence in Personnage.XpCoutCompetence do
    begin
      Inc(Lig);
      TabAugmentationMjXp.Rowcount                     := TabAugmentationMjXp.Rowcount + 1;
      TabAugmentationMjXp.Cells[ColAugmMjXpType, Lig]  := ConstXmlCompetence;
      TabAugmentationMjXp.Cells[ColAugmMjXpCode, Lig]  := PersonnageXpCompetence.CodeCompetence;
      TabAugmentationMjXp.Cells[ColAugmMjXpDebut, Lig] := IntToStr(PersonnageXpCompetence.Debut);
      TabAugmentationMjXp.Cells[ColAugmMjXpFin, Lig]   := IntToStr(PersonnageXpCompetence.Fin);
      TabAugmentationMjXp.Cells[ColAugmMjXpCout, Lig]  := IntToStr(CalculExperience(ConstXmlCompetence, PersonnageXpCompetence.Debut, PersonnageXpCompetence.Fin, '', ''));
      TabAugmentationMjXp.Cells[ColAugmMjXpReel, Lig]  := IntToStr(PersonnageXpCompetence.CoutXp);
    end;

  // Augmentation Xp Mj Talent
  For PersonnageXpTalent in Personnage.XpCoutTalent do
    begin
      Inc(Lig);
      TabAugmentationMjXp.Rowcount                     := TabAugmentationMjXp.Rowcount + 1;
      TabAugmentationMjXp.Cells[ColAugmMjXpType, Lig]  := ConstXmlTalent;
      TabAugmentationMjXp.Cells[ColAugmMjXpCode, Lig]  := PersonnageXpTalent.CodeTalent;
      TabAugmentationMjXp.Cells[ColAugmMjXpDebut, Lig] := IntToStr(PersonnageXpTalent.Debut);
      TabAugmentationMjXp.Cells[ColAugmMjXpFin, Lig]   := IntToStr(PersonnageXpTalent.Fin);
      TabAugmentationMjXp.Cells[ColAugmMjXpCout, Lig]  := IntToStr(CalculExperience(ConstXmlTalent, PersonnageXpTalent.Debut, PersonnageXpTalent.Fin, '', ''));
      TabAugmentationMjXp.Cells[ColAugmMjXpReel, Lig]  := IntToStr(PersonnageXpTalent.CoutXp);
    end;

  AfficheImageMetier();
  TabTalent.SortColRow(true, 3);
  tabCompetence.SortColRow(true, ColCompLib);
  CalculTotaux();
  NiveauMetierTalentMax();
  tabNiveau.Cells[0, StrToInt(MetierNvEnCours)] := ConstSelectionne;
  CalculTableExperience();
  ChargeAugmentation();
  CalculAvancement();

  For Ind := 1 to TabHistorique.RowCount-1 do
    if TabHistorique.Cells[2, Ind] = FileName then
      TabHistorique.Cells[0, Ind] := ConstSelectionne
    else
      TabHistorique.Cells[0, Ind] := '';
  if TabHistorique.Cells[0, 1] = ConstSelectionne then
    begin
      ButtonAugmentation.Visible := true;
      ButtonArme.Visible := true;
      ButtonArmure.Visible := true;
      ButtonSort.Visible := true;
    end
  else
    begin
      ButtonAugmentation.Visible := false;
      ButtonArme.Visible := false;
      ButtonArmure.Visible := false;
      ButtonSort.Visible := false;
    end;
  AjoutMineur := false;
  ToggleBoxGauche.left := ToggleBoxGauche.left + 1;
  AjustePositionTables();
  AfficheFabrication();
  TalentAsterisc();
end;

Procedure TWinPersonnages.TalentAsterisc();
  var
    PTalent: StructureTalent;
    IndT:    Integer;
    IndS:    Integer;
    Strings: TStringList;
    IndA:    Integer;
    Acc:     Boolean;
  begin
    for indT := 1 to TabTalent.RowCount - 1 do
      begin
        PTalent := ChercheTalent(TabTalent.Cells[ColTalCode, IndT]);
        if PTalent.TalentPdf <> '' then
          begin
            strings    := TStringList.Create;
            ExtractStrings([','], [], PChar(PTalent.TalentPdf), Strings);
            for IndS := 0 to (Strings.count-1) Do
              begin
                if copy(Strings[Inds],1,Length(ConstDebutAttribut)) = ConstDebutAttribut then
                  begin
                    for IndA := 1 to 11 do
                      if TabAttribut.Cells[IndA, LigAttCode] = Strings[IndS] then
                        begin
                          if TabAttribut.Cells[IndA, LigAttAsterisc] <> '' then
                            TabAttribut.Cells[IndA, LigAttAsterisc] := TabAttribut.Cells[IndA, LigAttAsterisc] + ',';
                          TabAttribut.Cells[IndA, LigAttAsterisc] := IntToStr(IndT);
                          TabTalent.Cells[ColTalAsterisk, IndT]                := IntToStr(IndT);
                          break
                        end;
                  end
                else if copy(Strings[Inds],1,Length(ConstDebutCompetence)) = ConstDebutCompetence then
                  begin
                    for IndA := 1 to TabCompetence.RowCount-1 do
                      begin
                        if ExtractStringBefore(tabCompetence.Cells[ColCompCode, IndA],'_') = ExtractStringBefore(Strings[IndS], '_') then
                          begin
                            Acc := false;
                            if (tabCompetence.Cells[ColCompCode, IndA] = Strings[IndS]) then
                              Acc := True
                            else if Pos(tabCompetence.Cells[ColCompCode, IndA], ValeurGenerique) > 0 then
                              Acc := true;
                            if Acc = True then
                              Begin
                                if TabCompetence.Cells[ColCompAsterisc, IndA] <> '' then
                                  TabCompetence.Cells[ColCompAsterisc, IndA] := TabCompetence.Cells[ColCompAsterisc, IndA] + ',';
                                TabCompetence.Cells[ColCompAsterisc, IndA] := IntToStr(IndT);
                                TabTalent.Cells[ColTalAsterisk, IndT]                   := IntToStr(IndT);
                              end;
                            break;
                          end;
                      end;
                  end;
              end;
            strings.free;
          end;
      end;
  end;

procedure TWinPersonnages.RadioButtonChangerChange(Sender: TObject);
begin
  ChargerMetierEquipement('',0);
  NvMetierChoisi := '';
  ButtonRaceSelectionner.visible := RadioButtonChanger.checked;
  ButtonRaceSelectionner.BringToFront;
  CalculXpNecessaire(false);
end;


procedure TWinPersonnages.NiveauMetierTalentMax();
  var
    aRow:            Integer;
    IndAttribut:     Integer;
    PMetierTalent:   StructureMetierTalent;
  begin
    for aRow := 1 to TabTalent.RowCount-1 do
    begin
      // Niveau talent
      For PMetierTalent in ListMetierTalent do
        if CompareRechercheValeur(PMetierTalent.CodeMetier, MetierEnCours) then
          begin
            if CompareRechercheValeur(PMetierTalent.CodeTalent, TabTalent.Cells[ColTalCode, ARow]) or (copy(CodeValeur,1,5) = copy(CodeRecherche,1,5)) then
              begin
                TabTalent.Cells[2, Arow] := IntToStr(PMetierTalent.NiveauMetier);
                Break;
              end
          end;

      // Max
      if TabTalent.Cells[ColTalMax, aRow] <> '1' then
        begin
          for IndAttribut := 1 to TabAttribut.Colcount-1 do
            begin
              if '(B'+TabAttribut.Cells[IndAttribut, LigAttCode]+')' = TabTalent.Cells[ColTalMax, aRow] then
                begin
                  TabTalent.Cells[ColTalMax, aRow] := IntToStr(Floor(StrToIntDef(TabAttribut.Cells[IndAttribut, LigAttTotal],0) / 10));
                  Break;
                end;
            end;
        end;
    end;
    TabEquipementAffiche();
  end;

Procedure TWinPersonnages.AfficheImageMetier();
var
  indTabAttribut:     integer;
  PMetierAttribut:    StructureMetierAttribut;
  PMetierNiveau:      StructureMetierNiveau;
  CheminImage1:       String;
begin
  if MetierEnCours <> '' then
     CheminImage1     := CheminMetierImage(MetierEnCours)
  else
     CheminImage1     := '';

  if FileExists(CheminImage1) then
     ImageMetier.Picture.LoadFromFile(CheminImage1)
  else
     ImageMetier.Picture := nil;

  // bonus de race d'attributs
  for PMetierAttribut in ListMetierAttribut do
    if CompareRechercheValeur(PMetierAttribut.CodeMetier, MetierEnCours) then
      for IndTabAttribut := 1 to TabAttribut.ColCount -1 do
        if CompareRechercheValeur(PMetierAttribut.CodeAttribut, TabAttribut.Cells[IndTabAttribut,LigAttCode]) and (PMetierAttribut.NiveauMetier > 0) then
          TabAttribut.Cells[IndTabAttribut,LigAttImage] := IntToStr(PMetierAttribut.NiveauMetier);

  // Liste des Niveaux
  For PMetierNiveau in ListMetierNiveau do
    if CompareRechercheValeur(PMetierNiveau.CodeMetier, MetierEnCours) then
     begin
        TabNiveau.Cells[2,PMetierNiveau.NiveauMetier] := IntToStr(PMetierNiveau.NiveauMetier);
        TabNiveau.Cells[3,PMetierNiveau.NiveauMetier] := PMetierNiveau.Libelle;
     end;
end;

Procedure TwinPersonnages.TabAugmentationAttributCalcul(ARow: Integer; var Value: string);
  var
    CellValue: Integer;
    ValeurMin: Integer = 0;
    ValeurMax: Integer = 99;
    Xp:        Integer = 0;
  begin
    if TryStrToInt(Value, CellValue) then
      begin
        // Appliquer les limites minimale et maximale
        ValeurMin := StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttActuel, ARow],0);
        CellValue := Min(Max(CellValue, ValeurMin), ValeurMax);
        // Formater la valeur avec un nombre de décimales spécifié
        if StrToIntDef(Value,0) >= ValeurMin then
          begin
            Value := IntToStr(CellValue);
            Xp    := CalculExperience(ConstXmlCarac, StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttActuel, aRow],0), CellValue, '', '');
            if Xp > 0 then
              TabAugmentationAttribut.Cells[ColAugmAttCout, aRow] := IntToStr(Xp)
            else
              TabAugmentationAttribut.Cells[ColAugmAttCout, aRow] := '';
            if TabAugmentationAttribut.Cells[2, aRow] = CouleurKo then
              TabAugmentationAttribut.Cells[ColAugmAttReel, aRow]   := IntToStr(StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttCout, aRow],0) * 2)
            else
              TabAugmentationAttribut.Cells[ColAugmAttReel, aRow]   := TabAugmentationAttribut.Cells[ColAugmAttCout, aRow];
            CalculTableExperience();
          end;
      end;
  end;

procedure TWinPersonnages.TabAugmentationAttributGetEditText(Sender: TObject;
  ACol, ARow: Integer; var Value: string);
  begin
    // Vérifier si la colonne actuelle correspond à la colonne que vous souhaitez formater
    if ACol = ColAugmAttNouveau then
    begin
      TabAugmentationAttributCalcul(Arow, Value);
      PreviousRowIndexA := aRow;
    end;
  end;

procedure TWinPersonnages.TabAugmentationAttributSelectCell(Sender: TObject;
  aCol, aRow: Integer; var CanSelect: Boolean);
var
  CellValue: Integer;
  ValeurMin: Integer = 0;
  ValeurMax: Integer = 99;
  Xp:        Integer = 0;
begin
  if (aCol = ColAugmAttNouveau) and (PreviousRowIndexA > 0) then
    begin
      // Appliquer les limites minimale et maximale
      ValeurMin := StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttActuel, PreviousRowIndexA],0);
      CellValue := Min(Max(StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttNouveau, PreviousRowIndexA],0), ValeurMin), ValeurMax);
      // Formater la valeur avec un nombre de décimales spécifié
      TabAugmentationAttribut.Cells[ColAugmAttNouveau, PreviousRowIndexA] := IntToStr(CellValue);
      Xp    := CalculExperience(ConstXmlCarac, StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttActuel, PreviousRowIndexA ],0), StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttNouveau, PreviousRowIndexA ],0), '', '');
      if Xp > 0 then
        TabAugmentationAttribut.Cells[ColAugmAttCout, PreviousRowIndexA ] := IntToStr(Xp)
      else
        TabAugmentationAttribut.Cells[ColAugmAttCout, PreviousRowIndexA ] := '';
      if TabAugmentationAttribut.Cells[2, PreviousRowIndexA] = CouleurKo then
        TabAugmentationAttribut.Cells[ColAugmAttReel, PreviousRowIndexA]   := IntToStr(StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttCout, PreviousRowIndexA],0) * 2)
      else
        TabAugmentationAttribut.Cells[ColAugmAttReel, PreviousRowIndexA]   := TabAugmentationAttribut.Cells[ColAugmAttCout, PreviousRowIndexA];

      PreviousRowIndexA := aRow;
      CalculTableExperience();
    end;
end;

procedure TWinPersonnages.TabAugmentationAttributSelectEditor(Sender: TObject;
  aCol, aRow: Integer; var Editor: TWinControl);
begin
  if ((aCol <> ColAugmAttNouveau) and (ACol <> ColAugmAttReel)) or (aRow = 0) or ((aCol = ColAugmAttNouveau) and (CheckBoxXpDiv25.checked = true)) then
     Editor := nil;
end;

procedure TWinPersonnages.TabAugmentationCompetenceCalcul(ARow: Integer; var Value: string);
  var
    CellValue: Integer;
    ValeurMin: Integer = 0;
    ValeurMax: Integer = 99;
    Xp:        Integer = 0;
  begin
    // Vérifier si la cellule en cours d'édition contient une valeur numérique valide
    if TryStrToInt(Value, CellValue) then
    begin
      // Appliquer les limites minimale et maximale
      ValeurMin := StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, ARow],0);
      CellValue := Min(Max(CellValue, ValeurMin), ValeurMax);
      // Formater la valeur avec un nombre de décimales spécifié
      if StrToIntDef(Value,0) >= ValeurMin then
        begin
          Value := IntToStr(CellValue);
          Xp    := CalculExperience(ConstXmlCompetence, StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, aRow],0), CellValue, '', '');
          if Xp > 0 then
            TabAugmentationCompetence.Cells[ColAugmCompCout, aRow] := IntToStr(Xp)
          else
            TabAugmentationCompetence.Cells[ColAugmCompCout, aRow] := '';
          if TabAugmentationCompetence.Cells[2, ARow] = CouleurKo then
            TabAugmentationCompetence.Cells[ColAugmCompReel, aRow]   := IntToStr(Xp * 2)
          else
            TabAugmentationCompetence.Cells[ColAugmCompReel, aRow]   := IntToStr(Xp + CalculTalComp(StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, aRow],0), CellValue, TabAugmentationCompetence.Cells[ColAugmCompTal, aRow]));
          CalculTableExperience();
        end;
    end;
  end;

procedure TWinPersonnages.TabAugmentationCompetenceGetEditText(Sender: TObject;
  ACol, ARow: Integer; var Value: string);
begin
  // Vérifier si la colonne actuelle correspond à la colonne que vous souhaitez formater
  if ACol = ColAugmCompNouveau then
  begin
    TabAugmentationCompetenceCalcul(Arow, Value);
    PreviousRowIndexC := aRow;
  end;
end;

procedure TWinPersonnages.TabAugmentationCompetenceSelectCell(Sender: TObject;
  aCol, aRow: Integer; var CanSelect: Boolean);
var
  CellValue: Integer;
  ValeurMin: Integer = 0;
  ValeurMax: Integer = 99;
  Xp:        Integer = 0;
begin
  if (aCol = ColAugmCompNouveau) and (PreviousRowIndexC > 0) then
    begin
      // Appliquer les limites minimale et maximale
      ValeurMin := StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, PreviousRowIndexC],0);
      CellValue := Min(Max(StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompNouveau, PreviousRowIndexC],0), ValeurMin), ValeurMax);
      // Formater la valeur avec un nombre de décimales spécifié
      TabAugmentationCompetence.Cells[ColAugmCompNouveau, PreviousRowIndexC] := IntToStr(CellValue);
      Xp    := CalculExperience(ConstXmlCompetence, StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, PreviousRowIndexC ],0), StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompNouveau, PreviousRowIndexC ],0), '', '');
      if Xp > 0 then
        TabAugmentationCompetence.Cells[ColAugmCompCout, PreviousRowIndexC ] := IntToStr(Xp)
      else
        TabAugmentationCompetence.Cells[ColAugmCompCout, PreviousRowIndexC ] := '';
      if TabAugmentationCompetence.Cells[2, ARow] = CouleurKo then
        TabAugmentationCompetence.Cells[ColAugmCompReel, PreviousRowIndexC]   := IntToStr(StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompCout, PreviousRowIndexC],0) * 2)
      else
        TabAugmentationCompetence.Cells[ColAugmCompReel, PreviousRowIndexC]   := IntToStr(StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompCout, PreviousRowIndexC],0)
                                                                                + CalculTalComp(StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, PreviousRowIndexC],0), CellValue, TabAugmentationCompetence.Cells[ColAugmCompTal, PreviousRowIndexC]));

      PreviousRowIndexC := aRow;
      CalculTableExperience();
    end;
end;

procedure TWinPersonnages.TabAugmentationCompetenceSelectEditor(
  Sender: TObject; aCol, aRow: Integer; var Editor: TWinControl);
begin
  if ((aCol <> ColAugmCompNouveau) and (aCol <> ColAugmCompReel))
         or (aRow = 0)
         or ((TabAugmentationCompetence.Cells[ColAugmCompSpe, aRow] = GetTexteLibelle(ConstLabSelSpe)))
         or ((TabAugmentationCompetence.Cells[ColAugmCompLib, aRow] = GetTexteLibelle(ConstLabAdd)))
         or ((aCol = ColAugmCompNouveau) and (CheckBoxXpDiv25.checked = true))
         then
     Editor := nil;
end;

procedure TWinPersonnages.TabLivreDblClick(Sender: TObject);
begin
  // cocher ou décocher le livre en cours (sauf RULESBOOK qui est en 1)
  if (TabLivre.Row > 1) then
    if TabLivre.Cells[2, TabLivre.Row] <> '' then
      if TabLivre.Cells[1, TabLivre.Row] <> ConstSelectionne then
        TabLivre.Cells[1, TabLivre.Row] := ConstSelectionne
      else
        TabLivre.Cells[1, TabLivre.Row] := '';
end;

procedure TWinPersonnages.TabMetierEquipementDblClick(Sender: TObject);
  begin
    if (TabMetierEquipement.col = 2) and (TabMetierEquipement.Cells[2, TabMetierEquipement.Row] = ConstArbreAuchoix) then
      Begin
        ChoixWinTypeFichier         := ConstXmlChapitreEquipement;
        ChoixWinEquipement          := TabMetierEquipement.Cells[3, TabMetierEquipement.Row];
        FenSpecialisation           := TWinSpecialisations.Create(Application);
        FenSpecialisation.Position  := poOwnerFormCenter;
        FenSpecialisation.ShowModal;
        if SelectWinEquipement <> '' then
          begin
            TabMetierEquipement.Cells[1, TabMetierEquipement.Row] := SelectWinEquipement;
            TabMetierEquipement.Cells[2, TabMetierEquipement.Row] := SelWinLibelle;
          end;
      end;
  end;

procedure TWinPersonnages.TabMetierEquipementSelectEditor(Sender: TObject;
  aCol, aRow: Integer; var Editor: TWinControl);
begin
  Editor := nil;
end;

procedure TWinPersonnages.TabSheetMjCostContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TWinPersonnages.TabAugmentationTalentCalcul(ARow: Integer; var Value: string);
  var
    CellValue: Integer;
    ValeurMin: Integer = 0;
    ValeurMax: Integer = 1;
    Xp:        Integer = 0;
    PTalent:   StructureTalent;
    Calcul:    String;
    Ind:       Integer;
    Carac:     String;
  begin
    // Vérifier si la cellule en cours d'édition contient une valeur numérique valide
    if TryStrToInt(Value, CellValue) then
    begin
      // Appliquer les limites minimale et maximale
      ValeurMin := StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalActuel, ARow],0);
      PTalent := ChercheTalent(TabAugmentationTalent.Cells[ColAugmTalCode, ARow]);
      if PTalent.MaxiTalent <> '' then
        if not TryStrToInt(PTalent.MaxiTalent, ValeurMax) then
          begin
            Calcul := PTalent.MaxiTalent;
            Carac  := StringReplace(ExtractStringAfter(Calcul, '(B'),')','',[rfReplaceAll]);
            For Ind := 1 to TabAttribut.ColCount - 1 do
              if (tabAttribut.Cells[Ind, LigAttCode] = Carac) then
                begin
                  ValeurMax := trunc(StrToIntDef(tabAttribut.Cells[Ind, LigAttTotal],0) / 10);
                  break;
                end;
          end;

      CellValue := Min(Max(CellValue, ValeurMin), ValeurMax);
      // Formater la valeur avec un nombre de décimales spécifié
      Value := IntToStr(CellValue);
      Xp    := CalculExperience(ConstXmlTalent, StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalActuel, aRow],0), CellValue, '', '');
      // afficher cout normal
      if Xp > 0 then
        TabAugmentationTalent.Cells[ColAugmTalCout, aRow] := IntToStr(Xp)
      else
        TabAugmentationTalent.Cells[ColAugmTalCout, aRow] := '';
      // calcul cout réel (x2)
      if TabAugmentationTalent.Cells[2, ARow] = CouleurKo then
        TabAugmentationTalent.Cells[ColAugmTalReel, aRow]   := IntToStr(StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalCout, aRow],0) * 2)
      else
        TabAugmentationTalent.Cells[ColAugmTalReel, aRow] := TabAugmentationTalent.Cells[ColAugmTalCout, aRow];
    end;
    CalculTableExperience();
  end;

procedure TWinPersonnages.TabAugmentationTalentGetEditText(Sender: TObject;
  ACol, ARow: Integer; var Value: string);
begin
  // Vérifier si la colonne actuelle correspond à la colonne que vous souhaitez formater
  if (ACol = ColAugmTalNouveau) then
    begin
      PreviousRowIndexT := aRow;
      TabAugmentationTalentCalcul(ARow, Value);
    end;
  SortAffiche();

end;

procedure TWinPersonnages.TabAugmentationTalentSelectCell(Sender: TObject;
  aCol, aRow: Integer; var CanSelect: Boolean);
var
  CellValue: Integer;
  ValeurMin: Integer = 0;
  ValeurMax: Integer = 1;
  Xp:        Integer = 0;
  Ind:       Integer = 0;
begin
  if PreviousRowIndexT > 0 then
  begin
    // Appliquer les limites minimale et maximale
    ValeurMin := StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalActuel, PreviousRowIndexT],0);
    for Ind := 1 to TabTalent.RowCount - 1 do
      if TabTalent.Cells[ColTalCode, Ind] = TabAugmentationTalent.Cells[ColAugmTalCode, PreviousRowIndexT] then
        begin
          ValeurMax := StrToIntDef(TabTalent.Cells[ColTalMax, Ind],1);
          Break;
        end;
    CellValue := Min(Max(StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalNouveau, PreviousRowIndexT],0), ValeurMin), ValeurMax);
    // Formater la valeur avec un nombre de décimales spécifié
    TabAugmentationTalent.Cells[ColAugmTalNouveau, PreviousRowIndexT] := IntToStr(CellValue);
    Xp    := CalculExperience(ConstXmlTalent, StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalActuel, PreviousRowIndexT ],0), StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalNouveau, PreviousRowIndexT ],0), '', '');
    if Xp > 0 then
      TabAugmentationTalent.Cells[ColAugmTalCout, PreviousRowIndexT ] := IntToStr(Xp)
    else
      TabAugmentationTalent.Cells[ColAugmTalCout, PreviousRowIndexT ] := '';
    // calcul cout réel (x2)
    if TabAugmentationTalent.Cells[2, ARow] = CouleurKo then
      TabAugmentationTalent.Cells[ColAugmTalReel, PreviousRowIndexT]   := IntToStr(StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalCout, PreviousRowIndexT],0) * 2)
    else
      TabAugmentationTalent.Cells[ColAugmTalReel, PreviousRowIndexT] := TabAugmentationTalent.Cells[ColAugmTalCout, PreviousRowIndexT];
    PreviousRowIndexT := aRow;
    CalculTableExperience();
  end;
end;

procedure TWinPersonnages.TabAugmentationTalentSelectEditor(Sender: TObject;
  aCol, aRow: Integer; var Editor: TWinControl);
begin
  if ((aCol <> ColAugmTalNouveau) and (aCol <> ColAugmTalReel))
         or (aRow = 0)
         or (TabAugmentationTalent.Cells[ColAugmTalLib, ARow] = GetTexteLibelle(ConstLabAdd)) then
     Editor := nil;
end;

procedure TWinPersonnages.TabDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
Var
  ImageIndex: Integer;
  CellWidth, CellHeight: Integer;
  MaxWidth, MaxHeight, ImageWidth, ImageHeight: Integer;
  AspectRatio: Double;
  LeftOffset, TopOffset: Integer;
  ImageRect: TRect;
  TopLeftPixelColor: TColor;
  Bitmap: TBitmap;

  CellText: string;
  TextWidth: Integer;
  TextX: Integer;
  TextY: integer;
  Grid:  TStringGrid;
begin
    Grid := TStringGrid(Sender);
    if (aCol > 0) then
     begin
       if aRow = 0 then
         begin
           // Dessiner le fond de la cellule de l'entête
           Grid.Canvas.Brush.Color := clBlack;
           Grid.Canvas.FillRect(aRect);

           // Dessiner le texte de l'entête centré horizontalement et verticalement
           Grid.Canvas.Font.Color := clWhite;
           Grid.Canvas.Font.Style := [fsBold];
           Grid.Canvas.Font.Size  := 10;
           Grid.Canvas.Font.Name  := ConstPoliceArial;

           // Calculer la position x et y du texte pour l'alignement centré
           if aCol > 0 then
           begin
             CellText  := Grid.Cells[aCol, aRow]; //Grid.Columns[aCol-1].Title.Caption; //
             TextWidth := Grid.Canvas.TextWidth(CellText);
             TextX     := aRect.Left + (aRect.Right - aRect.Left - TextWidth) div 2;
             TextY     := aRect.Top + (aRect.Bottom - aRect.Top - Grid.Canvas.TextHeight(CellText)) div 2;

             // Dessiner le texte de l'entête
             Grid.Canvas.TextRect(aRect, TextX, TextY, CellText);
           end;
         end
     else if (aCol = ColCompImage) then
        begin
          // Récupérer la valeur de la cellule correspondante (colonne 2)
          ImageIndex := StrToIntDef(Grid.Cells[aCol, aRow], -1);

          // Vérifier que la valeur est valide et se situe dans la plage d'index d'image
          if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
          begin
            // Calculer la taille de la cellule
            CellWidth := aRect.Right - aRect.Left;
            CellHeight := aRect.Bottom - aRect.Top;

            // Calculer la taille maximale pour l'image en utilisant la taille de la cellule
            // et en ajustant l'aspect ratio de l'image
            MaxWidth := CellWidth;
            MaxHeight := CellHeight;
            ImageWidth := ListImage.Width;
            ImageHeight := ListImage.Height;
            if ImageWidth > 0 then
            begin
              AspectRatio := ImageHeight / ImageWidth;
              if ImageWidth > MaxWidth then
              begin
                ImageWidth := MaxWidth;
                ImageHeight := Round(ImageWidth * AspectRatio);
              end;
              if ImageHeight > MaxHeight then
              begin
                ImageHeight := MaxHeight;
                ImageWidth := Round(ImageHeight / AspectRatio);
              end;
            end;

            // Calculer la position de l'image pour centrer verticalement et horizontalement
            // dans la cellule
            LeftOffset:= (CellWidth - ImageWidth) div 2;
            TopOffset := (CellHeight - ImageHeight) div 2;
            ImageRect := Rect(aRect.Left + LeftOffset, aRect.Top + TopOffset, aRect.Left + LeftOffset + ImageWidth, aRect.Top + TopOffset + ImageHeight);

            // Obtenir la couleur du pixel en haut à gauche de l'image
            Bitmap := TBitmap.Create;
            try
              ListImage.GetBitmap(ImageIndex, Bitmap);
              TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
            finally
              Bitmap.Free;
            end;

            // Dessiner l'image dans la cellule avec la taille ajustée
            ListImage.Draw(Grid.Canvas, ImageRect.Left, ImageRect.Top, ImageIndex);
          end
          else
            // Dessiner du texte par défaut si la valeur de l'index d'image est invalide
            Grid.DefaultDrawCell(aCol, aRow, aRect, aState);
        end
      else
        begin
          // Obtenir la couleur du pixel en haut à gauche de l'image de la cellule précédente (colonne 2)
          Bitmap := TBitmap.Create;
          try
            ImageIndex := StrToIntDef(Grid.Cells[ColCompImage, aRow], -1);
            if (ImageIndex >= 0) and (ImageIndex < ListImage.Count) then
            begin
              ListImage.GetBitmap(ImageIndex, Bitmap);
              TopLeftPixelColor := Bitmap.Canvas.Pixels[0, 0];
            end
            else
              TopLeftPixelColor := clNone;
          finally
            Bitmap.Free;
          end;

          // Changer la couleur de fond de la cellule avec la couleur du pixel en haut à gauche de l'image
          if TopLeftPixelColor <> clNone then
          begin
            Grid.Canvas.Brush.Color := TopLeftPixelColor;
            Grid.Canvas.FillRect(aRect);
          end;

          // Changer la couleur du texte pour les colonnes 3 à 6
          Grid.Canvas.Font.Color := clBlack;

          // Calculer la position x du texte pour l'alignement horizontal centré
          // en utilisant la largeur de la cellule et la largeur du texte
          CellText := Grid.Cells[aCol, aRow];
          TextWidth := Grid.Canvas.TextWidth(CellText);
          if ACol = 3 then
            TextX := aRect.Left + 5 //(aRect.Right - aRect.Left + 5)
          else
            TextX := aRect.Left + (aRect.Right - aRect.Left - TextWidth) div 2;

          // Dessiner le texte avec l'alignement vertical centré
          Grid.Canvas.FillRect(aRect);
          Grid.Canvas.TextRect(aRect, TextX, aRect.Top + (aRect.Bottom - aRect.Top - Grid.Canvas.TextHeight(CellText)) div 2, CellText);
        end;
      end;
  end;

procedure TWinPersonnages.TalentAttribut(AttributTalent: String);
  var
    IndTab:  Integer;
    strings: TStringList;
    Attr:    String;
    Neg:     String;
    Ind:     Integer;
  begin
    if AttributTalent <> '' then
      begin
        strings            := TStringList.Create;
        ExtractStrings([';'], [], PChar(AttributTalent), Strings);
        for Ind := 0 to (Strings.count-1) Do
          begin
            if leftStr(Strings[ind],1) = '-' then
              Neg := '-'
            else
              Neg := '';
            Attr  := RightStr(Strings[ind],Length(Strings[ind]) - Length(Neg));
            for IndTab := 1 to TabAttribut.ColCount-1 do
              begin
                if CompareRechercheValeur(Attr, TabAttribut.Cells[IndTab, LigAttCode]) then
                  begin
                    TabAttribut.Cells[IndTab, LigAttTalent] := IntToStr(STrToIntDef(TabAttribut.Cells[IndTab, LigAttTalent],0) + StrToIntDef(Neg+'5',0));
                    break;
                  end;
              end;
          end;
        strings.free;
      end;
  end;

procedure TWinPersonnages.AjustePositionTables();
  var
    StartTB:    Integer = 0;
    EditLeft:   Integer = 0;
  begin
    AdjustGridColumnsWidth(TabAttribut, 0, false, false, false, 0, 0, ssnone);
    AdjustGridColumnsWidth(TabTalent, 0, false, false);
    AdjustGridColumnsWidth(TabCarriere, 0, false, false);
    AdjustGridColumnsWidth(TabCompetence, 0, false, false);
    AdjustGridColumnsWidth(TabNiveau, 0, false, false);
    AdjustGridColumnsWidth(TabAvancement, 0, false, false);
    AdjustGridColumnsWidth(TabExperience, 0, false, false);
    AdjustGridColumnsWidth(TabEquipement, 0, false, false);
    AdjustGridColumnsWidth(TabAugmentationAttribut, PageExperience.Height - 40, false, false);
    AdjustGridColumnsWidth(TabAugmentationCompetence, PageExperience.Height - 40, false, false);
    AdjustGridColumnsWidth(TabAugmentationTalent, PageExperience.Height - 40, false, false);
    AdjustGridColumnsWidth(TabHistorique, PageExperience.Height - 40, false, false);
    AdjustGridColumnsWidth(TabSort, PageExperience.Height - 40, false, false);
    AdjustGridColumnsWidth(TabLivre, PageExperience.Height - 40, false, false);
    AdjustGridColumnsWidth(TabAugmentationMjXp, PageExperience.Height - 40, false, false);

    // Ligne 2
       // Colonne données générique
    LabAge.left               := LabTabAttribut.left;
    LabHeight.left            := LabTabAttribut.left;
    LabHairColors.left        := LabTabAttribut.left;
    LabEyeColors.left         := LabTabAttribut.left;

    LabAge.Top                := TabAttribut.Top   + TabAttribut.Height   + 3;
    LabHeight.Top             := LabAge.Top        + LabAge.Height        + 3;
    LabHairColors.Top         := LabHeight.Top     + LabHeight.Height     + 3;
    LabEyeColors.Top          := LabHairColors.Top + LabHairColors.Height + 3;

    EditLeft                  := LabTabAttribut.left + ( PremierAjustage * ( max(max(max(LabAge.Width, LabHeight.Width), LabHairColors.Width), LabEyeColors.Width) ) );
    PremierAjustage           := 1;

    EditAge.top               := LabAge.Top          + Round(LabAge.Height / 3);
    EditHeight.top            := LabHeight.Top       + Round(LabHeight.Height / 3);
    EditHairColors.top        := LabHairColors.Top   + Round(LabHairColors.Height / 3);
    EditEyeColors.top         := LabEyeColors.Top    + Round(LabEyeColors.Height / 3);

    EditAge.left              := EditLeft;
    EditHeight.left           := EditLeft;
    EditHairColors.left       := EditLeft;
    EditEyeColors.left        := EditLeft;

       // Colonne Carrière
    LabTabCarriere.Left       := EditLeft + EditAge.Width + 10;
    TabCarriere.left          := LabTabCarriere.left;
    LabTabCarriere.Top        := TabAttribut.Top + TabAttribut.Height + 10;
    TabCarriere.Top           := LabTabCarriere.Top + LabTabCarriere.Height;// + 20;

       // Colonne Expérience
    LabTabExperience.Left     := TabCarriere.left + TabCarriere.Width + 20;
    LabTabExperience.Top      := LabTabCarriere.Top;
    TabExperience.left        := LabTabExperience.left;
    TabExperience.Top         := TabCarriere.Top;

    // Ligne 3
       // Colonne Talents
    LabTabTalent.Top          := TabCarriere.Top + Max(TabCarriere.Height, TabExperience.Height) + 15;
    TabTalent.Top             := LabTabTalent.Top + LabTabTalent.Height;// + 20;
    LabTabCompetence.Top      := LabTabTalent.Top;
    TabCompetence.Top         := TabTalent.Top;

      // colonne Compétences
    TabCompetence.left        := TabTalent.left + TabTalent.Width + 40;
    LabTabCompetence.Left     := TabCompetence.left;

    if (TabCompetence.left + TabCompetence.Width) > (TabAttribut.left + TabAttribut.Width) then
      StartTB                 := TabCompetence.left + TabCompetence.Width
    else
      StartTB                 := TabAttribut.left + TabAttribut.Width;
    ToggleBoxDroite.Left      := StartTB + 10;
    PageExperience.left       := ToggleBoxDroite.Left + 20;

    LabAugmentation.Left      := ToggleBoxDroite.Left + 20;
    LabAugmentation.top       := 0;

    ButtonAugmentation.Left   := LabAugmentation.Left;
    ButtonAugmentation.Top    := LabAugmentation.Top + LabAugmentation.Height + 10;
    ButtonSauvegarde.Left     := ButtonAugmentation.Left + ButtonAugmentation.Width + 10;
    ButtonSauvegarde.Top      := ButtonAugmentation.Top;

    PageExperience.Top        := ButtonAugmentation.Top + ButtonAugmentation.Height + 10;

    // colonne 4

    StaticTextPersonnage.left := ToggleBoxGauche.left + floor((ToggleBoxdroite.left - ToggleBoxGauche.left) / 2) - floor(StaticTextPersonnage.Width / 2);
    LabEquipement.left        := ToggleBoxdroite.left + 100;
    LabEquipement.Top         := PageExperience.Top + PageExperience.Height + 50;

    ButtonLigneGauche.left    := ToggleBoxGauche.Left + 10;
    ButtonLigneGauche.Width   := ToggleBoxDroite.Left - ToggleBoxGauche.left - 10;
    ButtonPdf.Left            := ToggleBoxDroite.left - ButtonPdf.width - 10;
    CheckBoxPdfFeldo2p.Left   := ButtonPdf.Left;
    LabelPdfFeldo2p.left      := CheckBoxPdfFeldo2p.Left + CheckBoxPdfFeldo2p.width;

    ButtonSauvegarde.left     := PageExperience.left;
    ButtonSauvegarde.left     := PageExperience.left;

    TabEquipement.Left        := PageExperience.left;
    TabEquipement.Top         := LabEquipement.top + LabEquipement.Height + 10;

    ButtonArme.left           := TabEquipement.left + TabEquipement.Width + 10;
    ButtonArmure.left         := ButtonArme.left;
    ButtonFabrication.left    := ButtonArme.left;
    ButtonDelete.left         := ButtonArme.left;
    ButtonSort.left           := ButtonArme.left;
    CheckBoxQuickArmor.left   := ButtonArme.left;
    LabQuickArmor.left        := CheckBoxQuickArmor.left + CheckBoxQuickArmor.Width + 10;

    ButtonArme.Top            := TabEquipement.Top;
    CheckBoxQuickArmor.Top    := ButtonArme.Top + ButtonArme.Height + 10;
    LabQuickArmor.Top         := ButtonArme.Top + ButtonArme.Height + 10;
    ButtonArmure.Top          := CheckBoxQuickArmor.Top + CheckBoxQuickArmor.Height + 10;
    ButtonDelete.Top          := ButtonArmure.Top + ButtonArmure.Height + 10;
    ButtonFabrication.Top     := ButtonDelete.Top + ButtonDelete.Height + 10;
    ButtonSort.Top            := ButtonFabrication.Top + ButtonFabrication.Height + 10;

    ImageSheetTitle.Width     := ToggleBoxDroite.Left;
    ImageSheetPage.Width      := ToggleBoxDroite.Left;
    ImageSheetXp.Left         := ToggleBoxDroite.Left;
    ImageSheetXp.Width        := Self.Width - ToggleBoxDroite.Left;
    ImageSheetXp.Height       := Self.Height;
    AdjustGridColumnsWidth(TabCompetence, 0, false, false);

  end;

procedure TWinPersonnages.EditHeightKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8, #9]) then Key := #0;
end;

procedure TWinPersonnages.PageExperienceChange(Sender: TObject);
var
  I: Integer;
  J: Integer;
begin
  for I := 0 to PageExperience.PageCount  -1 do
    For J := TTabSheet(PageExperience.PAge[I]).ControlCount - 1 downto 0 do
      if TTabSheet(PageExperience.Page[I]).Controls[J] is TPanel then
        TPanel(TTabSheet(PageExperience.Page[I]).Controls[J]).SendToBack;
end;

procedure TWinPersonnages.RadioButtonRASChange(Sender: TObject);
begin
  ChargerMetierEquipement('',0);
  NvMetierChoisi := '';
  TabEquipementAffiche();
  CalculXpNecessaire(false);
end;

procedure TWinPersonnages.TabEquipementAffiche();
  begin
      TabMetierEquipement.visible := ( (RadioButtonSuivant.checked) or (RadioButtonChanger.Checked) );
  end;

procedure TWinPersonnages.RadioButtonSuivantChange(Sender: TObject);
begin
  ChargerMetierEquipement(MetierEnCours, StrToInt(MetierNvEnCours) + 1);
  NvMetierChoisi := '';
  TabEquipementAffiche();
  CalculXpNecessaire(false);
end;

procedure TWinPersonnages.StaticTextPersonnageClick(Sender: TObject);
begin

end;

procedure TWinPersonnages.CalculAvancement();
  Var
    Ind:         Integer;
    Val:         Integer;
    Nb:          Integer = 0;
  begin
    TabAvancement.cells[4, 1] := IntToStr(2 + StrToInt(MetierNvEnCours));
    Val                       := 5 * StrToInt(MetierNvEnCours);

    // Attributs
    Nb := 0;
    for Ind := 1 to 11 do
        if (StrToIntDef(TabAttribut.Cells[Ind, LigAttImage],0) >= 1) and
           (StrToIntDef(TabAttribut.Cells[Ind, LigAttImage],0) <= StrToInt(MetierNvEnCours)) and
           (StrToIntDef(TabAttribut.Cells[Ind, LigAttBonus],0) >= Val) then
           Nb := Nb +1;
    For Ind := 1 to TabAugmentationAttribut.RowCount-1 do
      if TabAugmentationAttribut.Cells[2, ind] <> CouleurKo then
        if StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttNouveau, Ind],0) >= Val then
          TabAugmentationAttribut.Cells[2, ind] := CouleurOk
        else
          TabAugmentationAttribut.Cells[2, ind] := CouleurNot;

    TabAvancement.Cells[5, 1] := IntToStr(Nb);
    if Nb < StrToInt(TabAvancement.Cells[4, 1]) then
      TabAvancement.Cells[2, 1] := CouleurNot
    else
      TabAvancement.Cells[2, 1] := CouleurOk;

    // Compétences
    Nb := 0;
    for Ind := 1 to TabCompetence.RowCount-1 do
      begin
        if (StrToIntDef(TabCompetence.Cells[ColCompImage, Ind],0) >= 1) and
           (StrToIntDef(TabCompetence.Cells[ColCompImage, Ind],0) <= StrToInt(MetierNvEnCours)) and
           (StrToIntDef(TabCompetence.Cells[ColCompBonus, Ind],0) >= Val) then
           Nb := Nb +1;
      end;
    For Ind := 1 to TabAugmentationCompetence.RowCount-1 do
      if TabAugmentationCompetence.Cells[2, ind] <> CouleurKo then
        if StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompNouveau, Ind],0) >= Val then
          TabAugmentationCompetence.Cells[2, ind] := CouleurOk
        else
          TabAugmentationCompetence.Cells[2, ind] := CouleurNot;
    TabAvancement.Cells[5, 2] := IntToStr(Nb);
    if Nb < StrToInt(TabAvancement.Cells[4, 2]) then
      TabAvancement.Cells[2, 2] := CouleurNot
    else
      TabAvancement.Cells[2, 2] := CouleurOk;

    // Talents
    Nb := 0;
    for Ind := 1 to TabTalent.RowCount-1 do
        if (StrToIntDef(TabTalent.Cells[2, Ind],0) = StrToInt(MetierNvEnCours)) then
           Nb := Nb +1;
    TabAvancement.Cells[5, 3] := IntToStr(Nb);
    For Ind := 1 to TabAugmentationTalent.RowCount-1 do
      if TabAugmentationTalent.Cells[2, ind] <> CouleurKo then
        if StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalNouveau, Ind],0) >= 1 then
          TabAugmentationTalent.Cells[2, ind] := CouleurOk
        else
          TabAugmentationTalent.Cells[2, ind] := CouleurNot;
    if Nb < StrToInt(TabAvancement.Cells[4, 3]) then
      TabAvancement.Cells[2, 3] := CouleurNot
    else
      TabAvancement.Cells[2, 3] := CouleurOk;

  end;

function TWinPersonnages.CalculExperience(TypeXp: String; Gratuit: Integer; Total: Integer; Code: String; Tal: String): Integer;
  var
    Xp:                      Integer =0;
    AffecteBonus:            Integer;
    AffecteGratuit:          Integer;
    RestantBonus:            Integer;
    RestantGratuit:          Integer;
    Min:                     Integer = 0;
    Max:                     Integer = 5;
    PAttributAugmentation:   StructureAttributAugmentation;
    PCompetenceAugmentation: StructureCompetenceAugmentation;
    i:                       Integer;
  begin
    if TypeXp = ConstXmlTalent then
      Begin
        if Total > Gratuit then
          begin
            for i := gratuit to (Total-1) do
      	      Xp := Xp + 100 + (100 * i);
          end;
      end
    else
        begin
        // calcul du restant total
        RestantGratuit := Gratuit;
        RestantBonus   := Total - RestantGratuit;

        //boucle 5 par 5
        While (RestantBonus > 0) or (RestantGratuit > 0) do
          Begin
            // calculer l'affectation en gratuit
	    If RestantGratuit > 0 then
              begin
	        if RestantGratuit >= 5 then
	            AffecteGratuit := 5
	        else
	            AffecteGratuit := RestantGratuit;
                RestantGratuit     := RestantGratuit - AffecteGratuit;
              end
            else
              AffecteGratuit := 0;

            // calculer l'affectation en payant
            If AffecteGratuit < 5 then
              begin
	        if RestantBonus <= (5 - AffecteGratuit) then
	            AffecteBonus   := RestantBonus
	        else
	            AffecteBonus   := 5;
	        RestantBonus       := RestantBonus - AffecteBonus;
              end
	    else
	       AffecteBonus := 0;

            // calcul le coût en XP
            if AffecteBonus > 0 then
              begin
                case TypeXp Of
                  ConstXmlCarac:
                    begin
                      PAttributAugmentation := ChercheAttributAugmentation(Min, Max);
                      Xp := Xp + (AffecteBonus * PAttributAugmentation.Cout);
                    end;
                  ConstXmlCompetence:
                    begin
                      PCompetenceAugmentation := ChercheCompetenceAugmentation(Min, Max);
                      Xp := Xp + (AffecteBonus * PCompetenceAugmentation.Cout);
                    end;
                end;
              end;

            // augmenter les bornes
            if Min = 0 then
              Min := 1;
            Min := Min + 5;
            Max := Max + 5;
          end;
    end;

    // augmentation Xp MJ et Talent
    if (Code <> '') or (Tal <> '') then
      case TypeXp Of
        ConstXmlCarac:
          Xp := Xp + CalculXpMj(ConstXmlCarac, Code);
        ConstXmlCompetence:
          Xp := Xp + CalculXpMj(ConstXmlCompetence, Code) + CalculTalComp(Total, Gratuit, Tal);
        ConstXmlTalent:
          Xp := Xp + CalculXpMj(ConstXmlTalent, Code);
      end;
    // coût total
    result := CalculOptionXpDiv25(Xp);
  end;

procedure TWinPersonnages.CalculTableExperience();
  var
    Ind:            Integer;
    Xp:             Integer;
    Gratuit:        Integer;
    Total:          Integer;
    Depense:        Integer = 0;
    Restante:       Integer = 0;
    Augmentation:   Integer = 0;
  Begin
    // Attributs
    For Ind := 2 to TabAttribut.ColCount-1 do
      begin
        if TabAttribut.Cells[Ind, LigAttBonus] <> '' then
          begin
            Gratuit  := 0;
            Total    := StrToInt(TabAttribut.Cells[Ind, LigAttBonus]);
            Xp       := CalculExperience(ConstXmlCarac, Gratuit, Total, TabAttribut.Cells[Ind, LigAttCode], '');
            if Xp = 0 then
              TabAttribut.Cells[Ind, LigAttXp] := ''
            else
              begin
                TabAttribut.Cells[Ind, LigAttXp] := IntToStr(Xp);
                Depense := Depense + Xp;
              end;
           end;

      end;

    // Compétences
    For Ind := 1 to TabCompetence.RowCount-1 do
      begin
        if TabCompetence.Cells[ColCompBonus, Ind] <> '' then
          begin
            Gratuit   := StrToIntDef(TabCompetence.Cells[ColComp35, Ind],0) +
                         StrToIntDef(TabCompetence.Cells[ColComp40, Ind],0);
            Total     := StrToIntDef(TabCompetence.Cells[ColCompBonus, ind],0);
            Xp        := CalculExperience(ConstXmlCompetence, Gratuit, Total, TabCompetence.Cells[ColCompCode, Ind], '');
            if Xp = 0 then
              TabCompetence.Cells[ColCompXp, Ind] := ''
            else
              begin
                TabCompetence.Cells[ColCompXp, Ind] := IntToStr(Xp);
                Depense := Depense + Xp;
              end;
          end;
      end;

    // Talents
    For Ind := 1 to TabTalent.RowCount-1 do
      Begin
        //Xp := StrToIntDef(TabTalent.Cells[ColTalXp, Ind],0);
        Xp := CalculExperience(ConstXmlTalent, 0, StrToIntDef(TabTalent.Cells[ColTalNbAugm, Ind],0), TabTalent.Cells[ColTalCode, Ind], '');
        if Xp = 0 then
          TabTalent.Cells[ColTalXp, Ind] := ''
        else
          begin
            TabTalent.Cells[ColTalXp, Ind] := IntToStr(Xp);
            Depense := Depense + Xp;
          end;

      end;

    // Carrières
    For Ind := 1 to TabCarriere.RowCount-1 do
      Begin
        Xp := StrToIntDef(TabCarriere.Cells[4, Ind],0);
        if Xp > 0 then
          Depense := Depense + Xp;
      end;

    // Augmentation
      // Attribut
      For ind := 1 to TabAugmentationAttribut.RowCount-1 do
        begin
          Xp := StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttReel, Ind],0);
          if Xp > 0 then
            Augmentation := Augmentation + Xp;
        end;
      // Compétence
      For ind := 1 to TabAugmentationCompetence.RowCount-1 do
        begin
          Xp := StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompReel, Ind],0);
          if Xp > 0 then
            Augmentation := Augmentation + Xp;
        end;
      // Talents
      For ind := 1 to TabAugmentationTalent.RowCount-1 do
        begin
          Xp := StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalReel, Ind],0);
          if Xp > 0 then
            Augmentation := Augmentation + Xp;
        end;

    // Sorts
    For Ind := 1 to TabEquipement.RowCount-1 do
      begin
        Xp := StrToIntDef(TabEquipement.Cells[5, Ind],0);
        if Xp > 0 then
          if TabEquipement.Cells[0, Ind] = '+' then
            Augmentation := Augmentation + Xp
          else
            Depense      := Depense + Xp;
      end;

    // Restant Xp
    if CheckBoxXpDiv25.Checked = true then
      Restante := Personnage.Xp25Total - Depense
    else
      Restante := Personnage.XpTotal - Depense;


    // Table des XP
    tabExperience.Cells[ColXpDonnee, LigXpDepense] := Format('%.0n',[Depense/1])+' ';
    tabExperience.Cells[ColXpDonnee, LigXpRestant] := Format('%.0n',[Restante/1])+' ';
    tabExperience.Cells[ColXpDonnee, LigXpCout]    := Format('%.0n',[Augmentation/1])+' ';

    // couleur
    if (Augmentation = 0) then
      tabExperience.Cells[2, LigXpCout] := ''
    else if (Augmentation > Restante) then
      tabExperience.Cells[2, LigXpCout] := CouleurNot
    else
      tabExperience.Cells[2, LigXpCout] := CouleurOk;

  end;

Procedure TWinPersonnages.ChargeAugmentation();
  Var
    Ind:               Integer;
    NbC:               Integer;
    PTalent:           StructureTalent;
    IndT:              Integer;
    PCompetence:       StructureCompetence;
    ListComp:          TStringList;
    PAttribut:         StructureAttribut;
    Trouve:            Boolean;
    Ind2:              Integer;
  Begin
    // Attributs
    Nbc := 0;
    TabAugmentationAttribut.RowCount := StrToInt(MetierNvEnCours) + 3;
    For Ind := 2 to 11 do
      if (StrToIntDef(TabAttribut.Cells[Ind, LigAttImage],0) > 0) and (StrToIntDef(TabAttribut.Cells[Ind, LigAttImage],0) <= StrToInt(MetierNvEnCours)) then
        begin
          NbC := NbC + 1;
          if TabAugmentationAttribut.RowCount <= NbC then
            TabAugmentationAttribut.RowCount := TabAugmentationAttribut.RowCount + 1;
          TabAugmentationAttribut.Cells[1, NbC] := TabAttribut.Cells[Ind, LigAttCode];
          PAttribut := ChercheAttribut(TabAttribut.Cells[Ind, LigAttCode]);
          TabAugmentationAttribut.Cells[ColAugmAttCode, NbC]   := PAttribut.Resume;
          TabAugmentationAttribut.Cells[ColAugmAttActuel, NbC] := TabAttribut.Cells[ind, LigAttBonus];
          TabAugmentationAttribut.Cells[ColAugmAttNouveau, NbC]:= TabAttribut.Cells[ind, LigAttBonus];
          TabAugmentationAttribut.Cells[ColAugmAttMoins5, NbC] := '-';
          TabAugmentationAttribut.Cells[ColAugmAttPlus5, NbC]  := '+';
        end;
    // Attribut hors carrière
    For Ind := 2 to 11 do
      if (StrToIntDef(TabAttribut.Cells[Ind, LigAttImage],0) = 0) or (StrToIntDef(TabAttribut.Cells[Ind, LigAttImage],0) > StrToInt(MetierNvEnCours)) then
        begin
          NbC := NbC + 1;
          if TabAugmentationAttribut.RowCount <= NbC then
            TabAugmentationAttribut.RowCount := TabAugmentationAttribut.RowCount + 1;
          TabAugmentationAttribut.Cells[1, NbC] := TabAttribut.Cells[Ind, LigAttCode];
          PAttribut := ChercheAttribut(TabAttribut.Cells[Ind, LigAttCode]);
          TabAugmentationAttribut.Cells[2, Nbc]                := CouleurKo;
          TabAugmentationAttribut.Cells[ColAugmAttCode, NbC]   := PAttribut.Resume;
          TabAugmentationAttribut.Cells[ColAugmAttActuel, NbC] := TabAttribut.Cells[ind, LigAttBonus];
          TabAugmentationAttribut.Cells[ColAugmAttNouveau, NbC]:= TabAttribut.Cells[ind, LigAttBonus];
          TabAugmentationAttribut.Cells[ColAugmAttMoins5, NbC] := '-';
          TabAugmentationAttribut.Cells[ColAugmAttPlus5, NbC]  := '+';
        end;

    // Compétences
    Nbc := 0;
    ListComp := nil;
    TabAugmentationCompetence.RowCount := 1;
    For PersonnageCompetence in Personnage.MetierCompetence do
      begin
        if PersonnageCompetence.Valeur <= StrToInt(MetierNvEnCours) then
          begin
            PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
            NbC := NbC + 1;
            if TabAugmentationCompetence.RowCount <= NbC then
              TabAugmentationCompetence.RowCount     := TabAugmentationCompetence.RowCount + 1;

            TabAugmentationCompetence.Cells[ColAugmCompCode, NbC]  := PCompetence.CodeCompetence;
            TabAugmentationCompetence.Cells[ColAugmCompLib, NbC]  := PCompetence.Libelle;
            For Ind := 1 to TabCompetence.rowCount -1 do
              begin
                if CompareRechercheValeur(PCompetence.CodeCompetence, TabCompetence.Cells[ColCompCode, Ind]) then
                  begin
                    TabAugmentationCompetence.Cells[2, NbC]  := TabCompetence.Cells[ColCompImage, Ind];
                    TabAugmentationCompetence.Cells[ColAugmCompActuel, NbC]  := TabCompetence.Cells[ColCompBonus, Ind];
                    TabAugmentationCompetence.Cells[ColAugmCompNouveau, NbC]  := TabCompetence.Cells[ColCompBonus, Ind];
                    break;
                  end;
              end;
            ListComp.Free;
            ListComp := ListeMetierCompetence(PersonnageCompetence.CodeCompetence);
            if (ListComp.Count > 1) or (Pos(ValeurGenerique, PersonnageCompetence.CodeCompetence) > 0) then
              TabAugmentationCompetence.Cells[ColAugmCompSpe, NbC] := GetTexteLibelle(ConstLabSelSpe);
            TabAugmentationCompetence.Cells[ColAugmCompWork, NbC]  := TabCompetence.Cells[ColCompTravail, Ind];
            TabAugmentationCompetence.Cells[ColAugmCompTal, NbC]   := TabCompetence.Cells[ColCompTalent, Ind];
            // tri
            TabAugmentationCompetence.Cells[ColAugmCompTri, NbC]   := '0'+TabAugmentationCompetence.Cells[ColAugmCompLib, NbC];
            TabAugmentationCompetence.Cells[ColAugmCompMoins5, NbC]:= '-';
            TabAugmentationCompetence.Cells[ColAugmCompPlus5, NbC] := '+';
          end;
      end;

    // Compétences hors carrière
    For Ind2 :=1 to TabCompetence.RowCount - 1 do
      begin
        Trouve := False;
        For Ind := 1 to TabAugmentationCompetence.RowCount - 1 do
          if TabAugmentationCompetence.Cells[ColAugmCompCode, Ind] = TabCompetence.Cells[ColCompCode, Ind2] then
            begin
              Trouve := True;
              break;
            end;
        if Trouve = false then
          begin
            NbC := NbC + 1;
            if TabAugmentationCompetence.RowCount <= NbC then
              TabAugmentationCompetence.RowCount     := TabAugmentationCompetence.RowCount + 1;

            TabAugmentationCompetence.Cells[ColAugmCompCode, NbC]    := TabCompetence.Cells[ColCompCode, Ind2];
            TabAugmentationCompetence.Cells[ColAugmCompLib, NbC]     := TabCompetence.Cells[ColCompLib, Ind2];
            if TabCompetence.Cells[ColCompTalent, Ind2] = '' then
              begin
              TabAugmentationCompetence.Cells[2, NbC]                := CouleurKo;
              TabAugmentationCompetence.Cells[ColAugmCompTri, NbC]   := '1'+TabAugmentationCompetence.Cells[ColAugmCompLib, Ind2];
              end
            else
              // tri
              TabAugmentationCompetence.Cells[ColAugmCompTri, NbC]   := '0'+TabAugmentationCompetence.Cells[ColAugmCompLib, Ind2];

            TabAugmentationCompetence.Cells[ColAugmCompActuel, NbC]  := TabCompetence.Cells[ColCompBonus, Ind2];
            TabAugmentationCompetence.Cells[ColAugmCompNouveau, NbC] := TabCompetence.Cells[ColCompBonus, Ind2];
            TabAugmentationCompetence.Cells[ColAugmCompWork, NbC]    := TabCompetence.Cells[ColCompTravail, Ind2];
            TabAugmentationCompetence.Cells[ColAugmCompTal, NbC]     := TabCompetence.Cells[ColCompTalent, Ind2];
            TabAugmentationCompetence.Cells[ColAugmCompMoins5, NbC]:= '-';
            TabAugmentationCompetence.Cells[ColAugmCompPlus5, NbC] := '+';
          end;
      end;
    TabAugmentationCompetence.SortColRow(true, ColAugmComptri);

    // Compétence Ajout nouvelle
    AugmentationAjouteXpMj(ConstXmlCompetence);

    // Talents
    NbC := 0;
    For PersonnageTalent in Personnage.MetierTalent do
      if PersonnageTalent.Valeur = StrToInt(MetierNvEnCours) then
        begin
         ListComp.Free;
         ListComp := ListeTalent(PersonnageTalent.CodeTalent);
         NbC := NbC + 1;
         TabAugmentationTalent.rowCount      := TabAugmentationTalent.rowCount + 1;
         TabAugmentationTalent.Cells[ColAugmTalCode, NbC] := PersonnageTalent.CodeTalent;
         PTalent                             := ChercheTalent(PersonnageTalent.CodeTalent);
         TabAugmentationTalent.Cells[ColAugmTalLib, NbC] := PTalent.Libelle;
         if (ListComp.Count > 1) or (Pos(ValeurGenerique, PersonnageTalent.CodeTalent) > 0) then
           TabAugmentationTalent.Cells[ColAugmTalSpe, NbC]:= GetTexteLibelle(ConstLabSelSpe);
         TabAugmentationTalent.Cells[ColAugmTalWork, NbC]  := PersonnageTalent.CodeTalent;

         for IndT := 1 to TabTalent.RowCount - 1 do
           begin
             if CompareRechercheValeur(PersonnageTalent.CodeTalent, TabTalent.Cells[ColTalCode, IndT]) then
               begin
                 TabAugmentationTalent.Cells[ColAugmTalActuel, NbC]  := TabTalent.Cells[ColTalNb, IndT];
                 TabAugmentationTalent.Cells[ColAugmTalNouveau, NbC] := TabTalent.Cells[ColTalNb, IndT];
                 break;
               end
             else if (copy(TabTalent.Cells[ColTalCode, IndT],1,12) = copy(PersonnageTalent.CodeTalent,1,12)) then
               begin
                 TabAugmentationTalent.Cells[ColAugmTalCode, NbC]   := TabTalent.Cells[ColTalCode, IndT];
                 TabAugmentationTalent.Cells[ColAugmTalLib, NbC]    := TabTalent.Cells[ColTalLib, IndT];
                 TabAugmentationTalent.Cells[ColAugmTalSpe, NbC]    := '';
                 TabAugmentationTalent.Cells[ColAugmTalActuel, NbC] := TabTalent.Cells[ColTalNb, IndT];
                 TabAugmentationTalent.Cells[ColAugmTalNouveau, NbC]:= TabTalent.Cells[ColTalNb, IndT];
               end;
           end;
       end;
    // Talents hors carrière
    For Ind2 := 1 to TabTalent.RowCount - 1 do
      begin
        Trouve := False;
        For Ind := 1 to TabAugmentationTalent.RowCount - 1 do
          if TabAugmentationTalent.Cells[ColAugmCompCode, Ind] = TabTalent.Cells[ColCompCode, Ind2] then
            begin
              Trouve := True;
              break;
            end;
        if Trouve = false then
          begin
            NbC := NbC + 1;
            TabAugmentationTalent.rowCount := TabAugmentationTalent.rowCount + 1;
            TabAugmentationTalent.Cells[ColAugmTalCode, NbC]   := TabTalent.Cells[ColTalCode, Ind2];
            TabAugmentationTalent.Cells[2, NbC]                := CouleurKo;
            TabAugmentationTalent.Cells[ColAugmTalLib, NbC]    := TabTalent.Cells[ColTalLib, Ind2];
            TabAugmentationTalent.Cells[ColAugmTalSpe, NbC]    := '';
            TabAugmentationTalent.Cells[ColAugmTalActuel, NbC] := TabTalent.Cells[ColTalNb, Ind2];
            TabAugmentationTalent.Cells[ColAugmTalNouveau, NbC]:= TabTalent.Cells[ColTalNb, Ind2];
          end;
      end;
    // Compétence Ajout nouvelle
    AugmentationAjouteXpMj(ConstXmlTalent);

    // Expérience
    EditTotalXp.text   := IntToStr(Personnage.XpTotal);
    EditTotalXp25.text := IntToStr(Personnage.Xp25Total);

    ListComp.Free;
  end;

Function TWinPersonnages.VerifieLivre(ListeLivre: String; Livre: String): String;
  begin
    If Pos(AjouteAccolade(Livre), ListeLivre) > 0 then
      Result := ListeLivre
    else
      result := ListeLivre + AjouteAccolade(Livre);
  end;

Procedure TWinPersonnages.MajTables();
  Var
    IndAugm:           Integer;
    IndActu:           Integer;
    Trouve:            Boolean;
    PTalent:           StructureTalent;
    PCompetence:       StructureCompetence;
    PAttribut:         StructureAttribut;
    PSort:             StructureSort;
    PMetierCompetence: StructureMetierCompetence;
    PMetierTalent:     StructureMetierTalent;
    CodEquip:          String;
    TypEquip:          String;
    Ind:               Integer;
  begin
    // raz table augmentation spéciales
    For IndAugm := TabAugmentationMjXp.RowCount - 1 downto 1 do
      if TabAugmentationMjXp.Cells[ColAugmMjXpNew, IndAugm] = ConstSelectionne then
        For IndActu := 1 To TabAugmentationMjXp.ColCount -1 do
          begin
            TabAugmentationMjXp.Cells[IndActu, IndAugm] := '';
            TabAugmentationMjXp.RowCount                := TabAugmentationMjXp.RowCount - 1;
          end;

    // Attribut
    Personnage.AugmentationAttribut      := [];
    for IndAugm := 1 to TabAugmentationAttribut.Rowcount-1 do
      if StrToIntDef(TabAugmentationAttribut.Cells[ColAugmAttCout, indAugm],0) > 0 then
        for IndActu := 1 to TabAttribut.ColCount-1 do
          if TabAttribut.Cells[IndActu, LigAttCode] = TabAugmentationAttribut.Cells[1, indAugm] then
            begin
              TabAttribut.Cells[IndActu, LigAttBonus]   := TabAugmentationAttribut.Cells[ColAugmAttNouveau, indAugm];
              if TabAugmentationAttribut.Cells[ColAugmAttCout, IndAugm] <> TabAugmentationAttribut.Cells[ColAugmAttReel, IndAugm] then
                begin
                  TabAugmentationMjXp.RowCount  := TabAugmentationMjXp.RowCount + 1;
                  TabAugmentationMjXp.Cells[ColAugmMjXpType, TabAugmentationMjXp.RowCount-1]  := ConstXmlCarac;
                  TabAugmentationMjXp.Cells[ColAugmMjXpCode, TabAugmentationMjXp.RowCount-1]  := TabAugmentationAttribut.Cells[ColAugmAttCode, indAugm];
                  TabAugmentationMjXp.Cells[ColAugmMjXpDebut, TabAugmentationMjXp.RowCount-1] := TabAugmentationAttribut.Cells[ColAugmAttActuel, indAugm];
                  TabAugmentationMjXp.Cells[ColAugmMjXpFin, TabAugmentationMjXp.RowCount-1]   := TabAugmentationAttribut.Cells[ColAugmAttNouveau, indAugm];
                  TabAugmentationMjXp.Cells[ColAugmMjXpCout, TabAugmentationMjXp.RowCount-1]  := TabAugmentationAttribut.Cells[ColAugmAttCout, indAugm];
                  TabAugmentationMjXp.Cells[ColAugmMjXpReel, TabAugmentationMjXp.RowCount-1]  := TabAugmentationAttribut.Cells[ColAugmAttReel, indAugm];
                  TabAugmentationMjXp.Cells[ColAugmMjXpNew, TabAugmentationMjXp.RowCount-1]   := ConstSelectionne;
                end;
              break;
            end;
    TabAugmentationAttribut.enabled := false;

    // Compétence
    for IndAugm := 1 to TabAugmentationCompetence.Rowcount-1 do
      if StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompCout, indAugm],0) > 0 then
        begin
          Trouve := false;
          for IndActu := 1 to TabCompetence.RowCount-1 do
            if TabCompetence.Cells[ColCompCode, IndActu] = TabAugmentationCompetence.Cells[ColAugmCompCode, indAugm] then
              begin
                // mettre à jour le total
                TabCompetence.Cells[ColCompWork, IndActu] := IntToStr(StrToIntDef(TabCompetence.Cells[ColCompWork, IndActu],0) +
                                                                      StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompActuel, indAugm],0));
                if TabAugmentationCompetence.Cells[ColAugmCompSpeSel, indAugm] <> '' then
                  begin
                    TabCompetence.Cells[ColCompCode, IndActu] := TabAugmentationCompetence.Cells[ColAugmCompSpeSel, indAugm];
                    TabCompetence.Cells[ColCompLib, IndActu]  := TabAugmentationCompetence.Cells[ColAugmCompLib, indAugm];
                  end;
                PCompetence := chercheCompetence(TabAugmentationCompetence.Cells[ColAugmCompCode,indAugm]);

                trouve := true;
                break;
              end;

          if not trouve then
            begin
              PCompetence := chercheCompetence(TabAugmentationCompetence.Cells[ColAugmCompCode,indAugm]);
              TabCompetence.RowCount := TabCompetence.rowCount + 1;
              TabCompetence.Cells[ColCompCode, TabCompetence.RowCount-1]  := PCompetence.CodeCompetence;
              TabCompetence.Cells[ColCompLib, TabCompetence.RowCount-1]   := PCompetence.Libelle;
              TabCompetence.Cells[ColCompWork, TabCompetence.RowCount-1]  := IntToStr(StrToIntDef(TabAugmentationCompetence.Cells[ColAugmCompNouveau, indAugm],0));
              TabCompetence.Cells[ColCompStat, TabCompetence.RowCount-1]  := PCompetence.CodeAttribut;
              PAttribut := chercheAttribut(PCompetence.CodeAttribut);
              TabCompetence.Cells[ColCompCarac, TabCompetence.RowCount-1] := GetTexteLibelle(PAttribut.Resume);
            end;

          if TabAugmentationCompetence.Cells[ColAugmCompCout, IndAugm] <> TabAugmentationCompetence.Cells[ColAugmCompReel, IndAugm] then
            begin
              TabAugmentationMjXp.RowCount  := TabAugmentationMjXp.RowCount + 1;
              TabAugmentationMjXp.Cells[ColAugmMjXpType, TabAugmentationMjXp.RowCount-1]  := ConstXmlCompetence;
              TabAugmentationMjXp.Cells[ColAugmMjXpCode, TabAugmentationMjXp.RowCount-1]  := TabAugmentationCompetence.Cells[ColAugmCompCode, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpDebut, TabAugmentationMjXp.RowCount-1] := TabAugmentationCompetence.Cells[ColAugmCompActuel, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpFin, TabAugmentationMjXp.RowCount-1]   := TabAugmentationCompetence.Cells[ColAugmCompNouveau, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpCout, TabAugmentationMjXp.RowCount-1]  := TabAugmentationCompetence.Cells[ColAugmCompCout, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpReel, TabAugmentationMjXp.RowCount-1]  := TabAugmentationCompetence.Cells[ColAugmCompReel, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpNew, TabAugmentationMjXp.RowCount-1]   := ConstSelectionne;
            end;

        end;
    TabAugmentationCompetence.enabled := false;

    // Talents
    for IndAugm := 1 to TabAugmentationTalent.Rowcount-1 do
      if StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalCout, indAugm],0) > 0 then
        begin
          Trouve := false;
          for IndActu := 1 to TabTalent.RowCount-1 do
            if TabTalent.Cells[ColCompCode, IndActu] = TabAugmentationTalent.Cells[ColAugmTalCode, indAugm] then
              begin
                TabTalent.Cells[ColTalNbAugm, IndActu] := IntToStr(StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalNouveau, indAugm],0) -
                                                                      StrToIntDef(TabTalent.Cells[ColTalNbCrea, IndActu],0));
                TabTalent.Cells[ColTalNb, IndActu] := IntToStr(StrToIntDef(TabTalent.Cells[ColTalNbCrea, IndActu],0) +
                                                                      StrToIntDef(TabTalent.Cells[ColTalNbAugm, IndActu],0));
                Trouve := True;
                break;
              end;

          if not trouve then
            begin
              if TabAugmentationTalent.Cells[ColAugmTalSpeSel,indAugm] <> '' then
                PTalent := chercheTalent(TabAugmentationTalent.Cells[ColAugmTalSpeSel,indAugm])
              else
                PTalent := chercheTalent(TabAugmentationTalent.Cells[ColAugmTalCode,indAugm]);
              TabTalent.RowCount := TabTalent.rowCount + 1;
              TabTalent.Cells[ColTalCode, TabTalent.RowCount-1]   := PTalent.CodeTalent;
              TabTalent.Cells[ColTalLib, TabTalent.RowCount-1]   := PTalent.Libelle;
              TabTalent.Cells[ColTalNb ,TabTalent.RowCount-1]   := IntToStr(StrToIntDef(TabTalent.Cells[ColTalNb ,TabTalent.RowCount-1],0) + StrToIntDef(TabAugmentationTalent.Cells[ColAugmTalNouveau, indAugm],0));
              TabTalent.Cells[ColTalNbAugm,TabTalent.RowCount-1]   := TabAugmentationTalent.Cells[ColAugmTalNouveau, indAugm];
              TabTalent.Cells[ColTalMax, TabTalent.RowCount-1]   := TabAugmentationTalent.Cells[ColAugmTalNouveau, indAugm];
            end;

          if TabAugmentationTalent.Cells[ColAugmTalCout, IndAugm] <> TabAugmentationTalent.Cells[ColAugmTalReel, IndAugm] then
            begin
              TabAugmentationMjXp.RowCount  := TabAugmentationMjXp.RowCount + 1;
              TabAugmentationMjXp.Cells[ColAugmMjXpType, TabAugmentationMjXp.RowCount-1]  := ConstXmlTalent;
              TabAugmentationMjXp.Cells[ColAugmMjXpCode, TabAugmentationMjXp.RowCount-1]  := TabAugmentationTalent.Cells[ColAugmTalCode, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpDebut, TabAugmentationMjXp.RowCount-1] := TabAugmentationTalent.Cells[ColAugmTalActuel, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpFin, TabAugmentationMjXp.RowCount-1]   := TabAugmentationTalent.Cells[ColAugmTalNouveau, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpCout, TabAugmentationMjXp.RowCount-1]  := TabAugmentationTalent.Cells[ColAugmTalCout, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpReel, TabAugmentationMjXp.RowCount-1]  := TabAugmentationTalent.Cells[ColAugmTalReel, indAugm];
              TabAugmentationMjXp.Cells[ColAugmMjXpNew, TabAugmentationMjXp.RowCount-1]   := ConstSelectionne;
            end;

        end;

    For IndAugm := 1 to TabSort.RowCount-1 do
      begin
        PSort := ChercheSort(TabSort.Cells[1, indAugm]);
        TabEquipement.RowCount                           := TabEquipement.RowCount + 1;
        TabEquipement.Cells[1, TabEquipement.RowCount-1] := '';
        TabEquipement.Cells[2, TabEquipement.RowCount-1] := PSort.CodeSort;
        TabEquipement.Cells[3, TabEquipement.RowCount-1] := PSort.TypeSort;
        TabEquipement.Cells[4, TabEquipement.RowCount-1] := PSort.Libelle;
        TabEquipement.Cells[5, TabEquipement.RowCount-1] := '0';
      end;
    TabAugmentationTalent.enabled := false;

    // Expérience
    tabExperience.Cells[ColXpDonnee,LigXpTotal] := EditTotalXp.Text;
    EditTotalXp.enabled := false;

    // évolution de carrière
      if RadioButtonSuivant.checked or RadioButtonChanger.checked then
        begin
          // carrièrere
          Personnage.MetierEnCours.NiveauMetier        := StrToInt(NvNiveau);
          Personnage.MetierEnCours.CodeMetier          := NvMetier;
          TabCarriere.Cells[4, TabCarriere.Rowcount-1] := IntToStr(EditNeedRealXp.value);

          TabCarriere.RowCount := TabCarriere.RowCount + 1;
          TabCarriere.Cells[1, TabCarriere.RowCount - 1] := NvMetier;
          TabCarriere.Cells[2, TabCarriere.RowCount - 1] := NvNiveau;

          // ancienne carrières
          Personnage.MetierAncien := [];
          for Ind := 1 to TabCarriere.Rowcount - 1 do
            begin
              PersonnageMetier.CodeMetier   := TabCarriere.Cells[1, Ind];
              PersonnageMetier.NiveauMetier := StrToIntDef(TabCarriere.Cells[2, Ind],0);
              PersonnageMetier.CoutXp       := StrToIntDef(TabCarriere.Cells[4, Ind],0);
              Personnage.MetierAncien       += [PersonnageMetier];
            end;

          // Equipement
          for Ind := 1 to TabMetierEquipement.rowCount - 1 do
            begin
              TabEquipement.RowCount := TabEquipement.RowCount + 1;
              CodEquip               := TabMetierEquipement.Cells[1,Ind];
              TypEquip               := GetTypeEquipement(CodEquip);

              TabEquipement.Cells[2, TabEquipement.RowCount-1] := CodEquip;
              TabEquipement.Cells[3, TabEquipement.RowCount-1] := TypEquip;
            end;

          // Competence
          if StrToInt(NvNiveau) = 1 then
            begin
              Personnage.MetierCompetence := [];
              for PMetierCompetence in ListMetierCompetence do
                if CompareRechercheValeur(PMetierCompetence.CodeMetier, NvMetier) then
                  begin
                    PersonnageCompetence.CodeCompetence := PMetierCompetence.CodeCompetence;
                    PersonnageCompetence.Valeur         := PMetierCompetence.NiveauMetier;
                    Personnage.MetierCompetence         += [PersonnageCompetence];
                  end;

              Personnage.MetierTalent := [];
              for PMetierTalent in ListMetierTalent do
                if CompareRechercheValeur(PMetierTalent.CodeMetier, NvMetier) then
                  begin
                    PersonnageTalent.CodeTalent := PMetierTalent.CodeTalent;
                    PersonnageTalent.Valeur     := PMetierTalent.NiveauMetier;
                    Personnage.MetierTalent     += [PersonnageTalent];
                  end;
            end;
        end;


    TabTalent.SortColRow(true, 3);
    tabCompetence.SortColRow(true, ColCompLib);
    CalculTotaux();
    NiveauMetierTalentMax();
    tabNiveau.Cells[0, StrToInt(MetierNvEnCours)] := ConstSelectionne;
    CalculAvancement();
    CalculTableExperience();

    ButtonAugmentation.visible := false;
    ButtonSauvegarde.visible   := true;
    ButtonPdf.visible          := false;
    AjustePositionTables();

    // Maj données générales
    Personnage.Age        := StrToIntDef(EditAge.Text,0);
    Personnage.Height     := StrToIntDef(EditHeight.Text,0);
    Personnage.HairColors := EditHairColors.Text;
    Personnage.EyeColors  := EditEyeColors.Text;

    // Maj personnage Attribut
    Personnage.AugmentationAttribut := [];
    For Ind := 1 to TabAttribut.Rowcount - 1 do
      if StrToIntDef(TabAttribut.Cells[Ind, LigAttBonus],0) > 0 then
        begin
          PersonnageAttribut.CodeAttribut  := TabAttribut.Cells[Ind, LigAttCode];
          PersonnageAttribut.Valeur        := StrToIntDef(TabAttribut.Cells[Ind, LigAttBonus],0);
          Personnage.AugmentationAttribut  += [PersonnageAttribut];
        end;

    // Maj personnage Compétences
    Personnage.AugmentationCompetence := [];
    For Ind := 1 to TabCompetence.Rowcount - 1 do
      if StrToIntDef(TabCompetence.Cells[ColCompWork, Ind],0) > 0 then
        begin
          PersonnageCompetence.CodeCompetence := TabCompetence.Cells[ColCompCode, Ind];
          PersonnageCompetence.Valeur         := StrToIntDef(TabCompetence.Cells[ColCompWork, Ind],0);
          Personnage.AugmentationCompetence   += [PersonnageCompetence];
        end;

    // Maj personnage Talent
    Personnage.AugmentationTalent := [];
    for Ind := 1 to TabTalent.Rowcount - 1 do
      if StrToIntDef(TabTalent.Cells[ColTalNbAugm, Ind],0) > 0 then
        begin
          PersonnageTalent.CodeTalent    := TabTalent.Cells[ColTalCode, Ind];
          PersonnageTalent.Valeur        := StrToIntDef(TabTalent.Cells[ColTalNbAugm, Ind],0);
          Personnage.AugmentationTalent  += [PersonnageTalent];
        end;

    // Maj personnage Equipement
    Personnage.Equipement := [];
    for Ind := 1 to TabEquipement.RowCount - 1 do
      begin
        PersonnageEquipement.CodeEquipement := TabEquipement.Cells[2, Ind];
        If (TabEquipement.Cells[3, Ind] = TypeSortArcane)
             or (TabEquipement.Cells[3, Ind] = TypeSortBenediction)
             or (TabEquipement.Cells[3, Ind] = TypeSortChaos)
             or (TabEquipement.Cells[3, Ind] = TypeSortCouleur)
             or (TabEquipement.Cells[3, Ind] = TypeSortMineur)
             or (TabEquipement.Cells[3, Ind] = TypeSortMiracle)
           then
          begin
            PersonnageEquipement.TypeEquipement    := TypeEquipSp;
            PersonnageEquipement.QualiteEquipement := '';
            PersonnageEquipement.CoutXp            := StrToIntDef(TabEquipement.Cells[5, Ind],0);
          end
        else
          begin
            PersonnageEquipement.TypeEquipement    := TabEquipement.Cells[3, Ind];
            PersonnageEquipement.QualiteEquipement := TabEquipement.Cells[7, Ind];
            PersonnageEquipement.CoutXp            := 0;
          end;
        Personnage.Equipement += [PersonnageEquipement];
      end;

    // Maj Augmentation Xp MJ
    Personnage.XpCoutAttribut   := [];
    Personnage.XpCoutCompetence := [];
    Personnage.XpCoutTalent     := [];
    For Ind := 1 to TabAugmentationMjXp.Rowcount -1 do
      begin
        if TabAugmentationMjXp.Cells[ColAugmMjXpType, Ind] = ConstXmlCarac then
          begin
            PersonnageXpAttribut.CodeAttribut := TabAugmentationMjXp.Cells[ColAugmMjXpCode, Ind];
            PersonnageXpAttribut.Debut        := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpDebut, Ind],0);
            PersonnageXpAttribut.Fin          := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpFin, Ind],0);
            PersonnageXpAttribut.CoutXp       := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpReel, Ind],0);
            Personnage.XpCoutAttribut         += [PersonnageXpAttribut]
          end
        else if TabAugmentationMjXp.Cells[ColAugmMjXpType, Ind] = ConstXmlCompetence then
          begin
            PersonnageXpCompetence.CodeCompetence := TabAugmentationMjXp.Cells[ColAugmMjXpCode, Ind];
            PersonnageXpCompetence.Debut          := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpDebut, Ind],0);
            PersonnageXpCompetence.Fin            := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpFin, Ind],0);
            PersonnageXpCompetence.CoutXp         := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpReel, Ind],0);
            Personnage.XpCoutCompetence           += [PersonnageXpCompetence]
          end
        else if TabAugmentationMjXp.Cells[ColAugmMjXpType, Ind] = ConstXmlTalent then
          begin
            PersonnageXpTalent.CodeTalent := TabAugmentationMjXp.Cells[ColAugmMjXpCode, Ind];
            PersonnageXpTalent.Debut      := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpDebut, Ind],0);
            PersonnageXpTalent.Fin        := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpFin, Ind],0);
            PersonnageXpTalent.CoutXp     := StrToIntDef(TabAugmentationMjXp.Cells[ColAugmMjXpReel, Ind],0);
            Personnage.XpCoutTalent       += [PersonnageXpTalent]
          end;
      end;

    // Livre
    Personnage.LivresAcceptes := '';
    for Ind := 1 to TabLivre.RowCount - 1 do
      if TabLivre.Cells[1, Ind] = ConstSelectionne then
        Personnage.LivresAcceptes += AjouteAccolade(TabLivre.Cells[3, ind]);

    // Options
    Personnage.Options := '';
    if (CheckBoxXpDiv25.Checked = true) then
      Personnage.Options += AjouteAccolade(ConstXmlOptionXpDiv25);
    if (CheckBoxPdfFeldo2p.Checked = true) then
      Personnage.Options += AjouteAccolade(ConstXmlOptionFeldo2P);
    if (CheckBoxQuickArmor.Checked = true) then
      Personnage.Options += AjouteAccolade(ConstXmlOptionQuickArmor);

    // Carrière
    if RadioButtonSuivant.checked or RadioButtonChanger.checked then
      begin
        XmlSauvegarde();
        close;
      end
    else
      CalculAvancement();

  end;


procedure TWinPersonnages.XmlSauvegarde();
  var
    fileName:       String;
    directoryPath:  String;
    TotalXp:        Integer;
    XpRestant:      Integer;
  begin

    // nouveau fichier
    directoryPath         := GetCurrentDir+ConstCheminPersonnage+NomPersonnage;
    fileName              := directoryPath + '\' + FormatDateTime('yyyymmdd', Date) + '-' + FormatDateTime('hhnnss', Time) + '.xml';
    TotalXp               := StrToIntDef(trim(tabExperience.Cells[ColXpDonnee, LigXpTotal]),0);
    XpRestant             := StrToIntDef(trim(tabExperience.Cells[ColXpDonnee, LigXpRestant]),0);
    PersonnageXmlCreation(Personnage, TotalXp, XpRestant, fileName, Personnage.NomPersonnage);
    NeedUpdate            := true;
    RecherchePersonnage   := NomPersonnage;
  end;


function TWinPersonnages.ChercherValeurParCode(const Chaine: string; const CodeRecherche: string): string;
var
  Lignes: TStringList;
  i:      Integer;
  Code:   string;
  Valeur: string;
begin
  Lignes := TStringList.Create;
  try
    // Découper la chaîne en lignes
    Lignes.Text := Chaine;

    // Parcourir les lignes
    for i := 0 to Lignes.Count - 1 do
    begin
      // Séparer le code et la valeur en utilisant la tabulation comme séparateur
      Code := Copy(Lignes[i], 1, Pos(Separateurtabulation, Lignes[i]) - 1);
      Valeur := Copy(Lignes[i], Pos(Separateurtabulation, Lignes[i]) + 1, Length(Lignes[i]));

      // Vérifier si le code correspond à celui recherché
      if SameText(Code, CodeRecherche) then
      begin
        Result := Valeur;
        Exit;
      end;
    end;
  finally
    Lignes.Free;
  end;

  // Si le code n'a pas été trouvé, renvoyer une valeur par défaut ou une chaîne vide
  Result := '';
end;

Procedure TWinPersonnages.ChargerMetierEquipement(CodeMetier: String; NiveauMetier: Integer);
  var
    NbMetierEquipementTab: Integer;
    PMetierEquipement:     StructureMetierEquipement;
    ListeCode:             String;
    Typ:                   String;
    Lib:                   String;
    Code:                  String;
    PArme:                 StructureArme;
    PArmure:               StructureArmure;
    I, J:                  Integer;
  begin
  // RAZ
  for I := 1 to TabMetierEquipement.RowCount -1 do
    For J := 1 to TabMetierEquipement.ColCount -1 do
      TabMetierEquipement.Cells[J, I] := '';
  TabMetierEquipement.Rowcount := 1;

  if CodeMetier <> '' then
   begin
    NbMetierEquipementTab        := 0;
    TabMetierEquipement.RowCount := 1;
    for PMetierEquipement in ListMetierEquipement do
      if CompareRechercheValeur(PMetierEquipement.CodeMetier, CodeMetier) and (PMetierEquipement.NiveauMetier = NiveauMetier) then
        Begin
           NbMetierEquipementTab        := NbMetierEquipementTab + 1;
           TabMetierEquipement.RowCount := NbMetierEquipementTab + 1;
           ListeCode                    := GetListeEquipement(PMetierEquipement.Equipement, PMetierEquipement.TypeEquipement);

           if Pos(',',ListeCode) > 0 then
             begin
               TabMetierEquipement.Cells[2, NbMetierEquipementTab]   := ConstArbreAuchoix;
               TabMetierEquipement.Cells[3, NbMetierEquipementTab]   := ListeCode;
             end
           else
             begin
               Code := PMetierEquipement.Equipement;
               if InList(PMetierEquipement.TypeEquipement,TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU) then
                   begin
                     PArme   := ChercheArme(Code);
                     Lib     := PArme.Libelle;
                     Typ     := TypeEquipWe;
                   end
                 else if PMetierEquipement.TypeEquipement = TypeEquipAR then
                   begin
                     PArmure := ChercheArmure(Code);
                     Lib     := PArmure.Libelle;
                     Typ     := TypeEquipAR;
                   end
                 else if PMetierEquipement.TypeEquipement = TypeEquipDI then
                   begin
                     Lib     := Code;
                     Typ     := TypeEquipDI;
                   end;
               TabMetierEquipement.Cells[1, NbMetierEquipementTab] := Code;
               TabMetierEquipement.Cells[2, NbMetierEquipementTab] := Lib;
               TabMetierEquipement.Cells[4, NbMetierEquipementTab] := Typ;
             end;

        end;
   end;
  AdjustGridColumnsWidth(TabMetierEquipement, PageExperience.Height, false, false);
end;

Procedure TWinPersonnages.AfficheFabrication();
  var
    IndTab:       Integer;
    Code:         String;
    Val:          String;
    Strings:      TStringList;
    I:            Integer;
    PFabrication: StructureFabrication;
    TextFab:      String;
  begin

    For IndTab := 1 to TabEquipement.RowCount - 1 do
      Begin
        // Ajoutez les éléments souhaités à la liste
        if InList(TabEquipement.Cells[7, IndTab],',0') then
          TabEquipement.Cells[6, IndTab] := ''
        else
          Begin
            TextFab  := '';
            strings  := TStringList.Create;
            ExtractStrings([','], [], PChar(TabEquipement.Cells[7, IndTab]), Strings);
            for I := 0 to Strings.Count -1 do
              Begin
                Code := ExtractStringBefore(Strings[I],' ');
                Val  := ExtractStringAfter(Strings[I],' ');
                PFabrication := ChercheFabrication(Code);
                if TextFab <> '' then TextFab := TextFab + ', ';
                TextFab := TextFab + PFabrication.Libelle;
                if PFabrication.Maximum <> '1' then
                  TextFab := TextFab + '('+Val+')';
              end;
            strings.free;
            TabEquipement.Cells[6, IndTab] := TextFab;
          end;
      end;
  end;

Procedure TWinPersonnages.AugmentationAjouteXpMj(TypeDonnee: String);
  begin
    // en dernière ligne de la table, renseigner une ligne avec le texte <ajouter>
    // pour permettre d'ajouter un autre talent ou compétence hors carrière
    case TypeDonnee of
      ConstXmlTalent:
        if TabAugmentationTalent.Cells[ColTalLib, TabAugmentationTalent.RowCount-1] <> GetTexteLibelle(ConstLabAdd) then
          begin
            TabAugmentationTalent.RowCount := TabAugmentationTalent.RowCount + 1;
            TabAugmentationTalent.Cells[2, TabAugmentationTalent.RowCount-1]         := CouleurKo;
            TabAugmentationTalent.Cells[ColTalLib, TabAugmentationTalent.RowCount-1] := GetTexteLibelle(ConstLabAdd);
          end;
      ConstXmlCompetence:
        if TabAugmentationCompetence.Cells[ColTalLib, TabAugmentationCompetence.RowCount-1] <> GetTexteLibelle(ConstLabAdd) then
          begin
            TabAugmentationCompetence.RowCount := TabAugmentationCompetence.RowCount + 1;
            TabAugmentationCompetence.Cells[2, TabAugmentationCompetence.RowCount-1]         := CouleurKo;
            TabAugmentationCompetence.Cells[ColTalLib, TabAugmentationCompetence.RowCount-1] := GetTexteLibelle(ConstLabAdd);
          end;
    end;
  end;

Function TWinPersonnages.CalculTalComp(Debut: Integer; Fin:Integer; Talent:String): integer;
  begin
    if (Talent <> '') and (Debut <> Fin) then
      Result := -( (Fin-Debut) * 5)
    else
      Result := 0;
  end;

Function TWinPersonnages.CalculOptionXpDiv25(Xp: Integer): Integer;
  begin
    if CheckBoxXpDiv25.checked then
      Result := trunc(Xp / 25)
    else
      Result := Xp;
  end;

var
  GTabControlDrawer: TTabControlDrawer;

procedure TTabControlDrawer.DrawTab(Control: TCustomTabControl; TabIndex: Integer;
  const ARect: TRect; Active: Boolean);
var
  CellText:     string;
  TextWidth:    Integer;
  TextX, TextY: Integer;
begin
  with Control.Canvas do
  begin
    if Active then
      Brush.Color := TColor($404040)
    else
      Brush.Color := clBlack;
    FillRect(ARect);

    Font.Color := clWhite;
    Font.Style := [fsBold];
    Font.Size  := ConstPoliceTaille;
    Font.Name  := ConstPoliceNom;

    CellText  := Control.Tabs[TabIndex];
    TextWidth := TextWidth(CellText);
    TextX     := ARect.Left + (ARect.Right - ARect.Left - TextWidth) div 2;
    TextY     := ARect.Top  + (ARect.Bottom - ARect.Top - TextHeight(CellText)) div 2;
    TextRect(ARect, TextX, TextY, CellText);
  end;
end;

end.
