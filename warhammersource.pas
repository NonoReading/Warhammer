unit WarhammerSource;

{$mode objfpc}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, Forms, Graphics, ExtCtrls, StdCtrls, Grids, Dialogs,
  Controls, Buttons, BGRABitmap, BGRABitmapTypes, WinCompetence,
  ChargeCompetence, ChargeConstantes, ChargeAttribut, ChargeTalent, WinTalent,
  ChargeMetier, ChargeMetierNiveau, ChargeMetierAttribut,
  ChargeMetierCompetence, ChargeMetierTalent, WinMetier, ChargeRaceMetier,
  ChargeRace, ChargeEspece, ChargeNation, ChargeRegle, WinRaces, ChargeRaceAttribut, ChargeRaceCompetence,
  ChargeRaceTalent, GlobalFonts, WinCreation, ChargeTalentCreation,
  WinPersonnage, ChargeAttributAugmentation, ChargeCompetenceAugmentation,
  ChargeArme, WinWeapon, WinEquipement, ChargeArmeBonus, ChargeMetierEquipement, ChargeArmure,
  ChargeArmureBonus, ChargeArmureBonusTalent, WinArmor, ChargeTrapping, ChargeSort, WinSpell, ChargeTexte,
  ChargeFabrication, WinMutationCatalogue, Unitcalcul, ChargeMetierSousMetier,
  ChargeMetierRaceChoixMetier, ChargePersonnage, ChargeRaceCreation,
  ChargeTraduction, ChargeArmureSimplifie, ChargeLivre,
  ChargeTalentEffet, ChargeTalentCompetenceModif,
  ChargeTalentCompetenceAjoute, ChargeRaceCorruptionCreation,
  ChargeCorruptionTable, ChargeRaceOpinion, ChargeArmureBonusModif,
  ChargeCorruptionCompetenceModif,
  ChargeCorruptionTalent, ChargeCorruptionEquipement,
  ChargeModificateur, ChargeTalentModificateur, ChargeCareerBonusModificateur,
  ChargeArmeModificateur, ChargeArmureBonusModificateur, ChargeCorruptionModificateur,
  CustomDrawn_Common, BCButton, BCLabel, fpTTF,
  PdfPersonnage, XmlExportImport, fppdf, WinLivre;

type

  { TMenu }

  TMenu = class(TForm)
    BoutonCompetence: TImage;
    BoutonMetier: TImage;
    BoutonRace: TImage;
    BoutonTalent: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ButtonCompetence: TBCButton;
    ButtonCreation: TBCButton;
    ButtonOuvrirLivre: TBCButton;
    ButtonDisclaimerLivre: TBCButton;
    ButtonExportLivre: TBCButton;
    ButtonCreationLivre: TBCButton;
    ButtonPdf: TBCButton;
    ButtonMetier: TBCButton;
    ButtonModification: TBCButton;
    ButtonRace: TBCButton;
    TabBibliotheque: TStringGrid;   // creee dans FormCreate (Arme, Armure, Equipement, Sort...)
    ButtonTalent: TBCButton;
    ComboBoxLangue: TComboBox;
    ComboBoxVersion: TComboBox;
    ComboBoxLangueInterface: TComboBox;
    ImageFond: TImage;
    Label1: TBCLabel;
    Label2: TBCLabel;
    Label3: TBCLabel;
    Label4: TBCLabel;
    Label5: TBCLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    TabLivre: TStringGrid;
    TotLivreCompetence: TEdit;
    TotLivreTalent: TEdit;
    TotLivreRace: TEdit;
    Logo1: TImage;
    Logo2: TImage;
    TotLivreMetier: TEdit;
    Panel1: TPanel;
    TabPersonnage: TStringGrid;
    procedure BoutonCompetenceClick({%H-}Sender: TObject);
    procedure BoutonTalentClick({%H-}Sender: TObject);
    procedure ButtonArmureClick({%H-}Sender: TObject);
    procedure ButtonArmeClick({%H-}Sender: TObject);
    procedure ButtonEquipementClick({%H-}Sender: TObject);
    procedure ButtonCreationClick({%H-}Sender: TObject);
    procedure ButtonCreationLivreClick(Sender: TObject);
    procedure ButtonModificationClick({%H-}Sender: TObject);
    procedure ButtonOuvrirLivreClick({%H-}Sender: TObject);
    procedure ButtonDisclaimerLivreClick({%H-}Sender: TObject);
    procedure ButtonPdfClick({%H-}Sender: TObject);
    procedure ButtonRaceClick({%H-}Sender: TObject);
    procedure ButtonSortClick({%H-}Sender: TObject);
    procedure ButtonTalentClick({%H-}Sender: TObject);
    procedure ButtonCompetenceClick({%H-}Sender: TObject);
    procedure ButtonMetierClick({%H-}Sender: TObject);
    procedure BoutonMetierClick({%H-}Sender: TObject);
    procedure BoutonRaceClick({%H-}Sender: TObject);
    procedure ButtonXmlClick({%H-}Sender: TObject);
    procedure ChargerImage();
    procedure ComboBoxLangueSelect({%H-}Sender: TObject);
    procedure ComboBoxVersionSelect({%H-}Sender: TObject);
    procedure ComboBoxLangueInterfaceSelect({%H-}Sender: TObject);
    procedure FormActivate({%H-}Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormResize({%H-}Sender: TObject);
    procedure ChargerPersonnages();
    Procedure ChargeIni();
    procedure ChargerLivre(ForceMaJ: Boolean; ForceLivre: String);
    procedure TabLivreDblClick({%H-}Sender: TObject);
    procedure TabBibliothequeDblClick({%H-}Sender: TObject);
    procedure RemplirTabBibliotheque();
    procedure TabLivreMouseMove({%H-}Sender: TObject; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure SauveIni();
    procedure TabPersonnagePrepareCanvas(Sender: TObject; {%H-}aCol, aRow: Integer;
      {%H-}aState: TGridDrawState);
    procedure TabPersonnageSelection({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
    function XmlPersonnageFichierActuel(const Directory: string): string;
    procedure RafraichirLibellesMenu();
    procedure ChargerListeVersions();
    procedure ChargerListeLanguesInterface();
    procedure PeuplerTabLivre();
    procedure AjustePositionFenetre();
  private
    FenetreInitialisee:       Boolean;
    LargeurFenetreBase:       Integer;
    LargeurTabLivreBase:      Integer;
    LargeurTabPersonnageBase: Integer;
  public
  end;


var
  Menu:               TMenu;
  FenCompetence:      TWinCompetence;
  FenTalent:          TWintTalent;
  FenMetier:          TWinMetiers;
  FenRace:            TWinRace;
  FenCreation:        TWinCreations;
  FenPersonnage:      TWinPersonnages;
  FenArme:            TWinWeapons;
  FenArmure:          TWinArmors;
  FenSort:            TWinSpells;
  FenLivre:           TWinLivres;
  ColLivreSel:        Integer = 1;
  ColLivreLib:        Integer = 2;
  ColLivreCod:        Integer = 3;
  ColLivreOrd:        Integer = 4;
  ColLivreRac:        Integer = 5;
  ColLivreWor:        Integer = 6;
  ColLivreO_F:        Integer = 7;
  ColLivreAbr:        Integer = 8;
  ColLivreCom:        Integer = 9;
  ColLivreTal:        Integer = 10;
  ColLivreArm:        Integer = 11;
  ColLivreArU:        Integer = 12;
  ColLivreEqu:        Integer = 13;
  ColLivreSor:        Integer = 14;
  ColLivreTra:        Integer = 15;
  ColLivreChe:        Integer = 16;
  ColPersoNom:        Integer = 1;
  ColPersoWor:        Integer = 2;
  ColPersoRac:        Integer = 3;
  ColPersoNiv:        Integer = 4;
  ColPersoTXp:        Integer = 5;
  ColPersoCXp:        Integer = 6;
  ColPersoLOb:        Integer = 7;
  ColPersoLNe:        Integer = 8;


implementation

{$R *.lfm}

{ TMenu }


procedure TMenu.ChargerImage();
  var
    Bmp: TBGRABitmap;
  begin
    // récupérer les images de fond
    if FileExists(GetCurrentDir+ConstCheminLogo1) then
         Logo1.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo1);
    if FileExists(GetCurrentDir+ConstCheminLogo2) then
         Logo2.Picture.LoadFromFile(GetCurrentDir+ConstCheminLogo2);
    if FileExists(GetCurrentDir+ConstCheminBoutonRace) then
         BoutonRace.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonRace);
    if FileExists(GetCurrentDir+ConstCheminBoutonMetier) then
         BoutonMetier.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonMetier);
    if FileExists(GetCurrentDir+ConstCheminBoutonCompetence) then
         BoutonCompetence.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonCompetence);
    if FileExists(GetCurrentDir+ConstCheminBoutonTalent) then
         BoutonTalent.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonTalent);
    if FileExists(GetCurrentDir+ConstCheminBack) then
       begin
         Bmp := TBGRABitmap.Create(GetCurrentDir+ConstCheminBack);
         Bmp.ApplyGlobalOpacity(100);
         ImageFond.Picture.Bitmap.Assign(Bmp);
         Bmp.Free;
         ImageFond.Transparent := True;
         ImageFond.SendToBack;
       end;
  end;

procedure TMenu.SauveIni();
var
  FilePathLoc: String;
  MyFile:   TextFile;
  Ind:      Integer;
  Liste:    String = '';
begin
  FilePathLoc := GetCurrentDir + ConstFichierIni;
  if FileExists(FilePathLoc) then
    DeleteFile(FilePathLoc);
  // Ouverture du fichier en écriture
  AssignFile(MyFile, FilePathLoc);
  Rewrite(MyFile);

  // Écriture dans le fichier
  Writeln(MyFile, ConstIniLangue + comboboxlangue.items[ComboBoxLangue.Itemindex]);
  if ComboBoxVersion.Itemindex <> -1 then
    Writeln(MyFile, ConstIniVersion + ComboBoxVersion.items[ComboBoxVersion.Itemindex]);
  if ComboBoxLangueInterface.Itemindex <> -1 then
    Writeln(MyFile, ConstIniLangueInterface + ComboBoxLangueInterface.items[ComboBoxLangueInterface.Itemindex]);

  // Sélection de livres cochés, une ligne par édition (CONTEXT.md §2.70) : la table garde
  // en mémoire la sélection de TOUTES les éditions déjà rencontrées - on ne met à jour ici
  // que celle de l'édition active (reflétée par TabLivre en ce moment), puis on réécrit
  // TOUTE la table, sans quoi la ligne de l'autre édition serait perdue à chaque sauvegarde.
  if ComboBoxVersion.Itemindex <> -1 then
    begin
      for Ind := 1 to TabLivre.RowCount -1 do
          if TabLivre.Cells[ColLivreSel, Ind] = ConstSelectionne then
            Liste := Liste + AjouteAccolade(TabLivre.Cells[ColLivreCod, Ind]);
      ListeLivreParVersion.Values[ComboBoxVersion.items[ComboBoxVersion.Itemindex]] := Liste;
    end;
  for Ind := 0 to ListeLivreParVersion.Count - 1 do
    // Nom vide : reliquat de l'ancien format .INI à une seule ligne 'BOOK=...' (sans
    // édition), lu comme tel une seule fois à la transition - ne rien réécrire, sans quoi
    // cette ligne morte resterait indéfiniment (13/09/2026, CONTEXT.md §2.70).
    if ListeLivreParVersion.Names[Ind] <> '' then
      Writeln(MyFile, ConstIniLivre + ListeLivreParVersion.Names[Ind] + '=' + ListeLivreParVersion.ValueFromIndex[Ind]);

  // Fermeture du fichier
  CloseFile(MyFile);

end;

procedure TMenu.TabPersonnagePrepareCanvas(Sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  LocColor: TColor;
begin
  if aRow > 0 then
    begin
      if aRow = TStringGrid(Sender).Row then
                LocColor := ClRed
              else
                LocColor := ClBlack;
      TStringGrid(Sender).Canvas.Font.Color := LocColor;
    end;
end;

procedure TMenu.TabPersonnageSelection(Sender: TObject; aCol, aRow: Integer);
begin
  TabPersonnage.Invalidate;
end;

procedure TMenu.ComboBoxLangueSelect(Sender: TObject);
  // Changement de langue en direct, sans fermer le programme (CONTEXT.md §2.8,
  // demandé par Nono le 17/08/2026). Mécanisme calqué sur celui déjà utilisé pour changer
  // de livre actif (TabLivreDblClick -> ChargerLivre(true,'')) : vider/recharger les
  // données, puis retraduire (Traduit(ValLangue,'')). Deux différences avec le changement
  // de livre : (1) il faut aussi rafraîchir les libellés déjà posés sur le menu lui-même
  // (RafraichirLibellesMenu, voir plus bas - FormCreate ne peut pas être rappelé tel quel,
  // il ajoute des colonnes de grille à chaque appel) ; (2) certaines fenêtres doivent être
  // fermées puis rouvertes pour afficher la nouvelle langue.
  // Fiches personnage (TWinPersonnages) et assistant de création (TWinCreations) sont
  // volontairement EXCLUS de la fermeture/réouverture automatique et BLOQUENT le
  // changement de langue s'ils sont ouverts (choix de Nono) : Personnage et les records
  // associés sont des variables globales PARTAGÉES par toutes les fenêtres WinPersonnage
  // (pas un champ propre à chaque fenêtre, voir CONTEXT.md §4) - les fermer sans
  // sauvegarde risquerait de perdre une saisie non enregistrée.
  // Les autres fenêtres secondaires ouvertes (catalogues Livre/Compétence/Talent/Race/
  // Sorts/Arme/Armure/Métier) sont fermées puis rouvertes à l'identique - état minimal
  // (juste "était ouverte"), pas de position/onglet/ligne sélectionnée mémorisé (choix
  // volontairement simple, comme le reste de ce chantier).
  var
    Langue:            String;
    Ind:               Integer;
    BloqueLangue:      Boolean;
    OuvertLivre:       Boolean;
    OuvertCompetence:  Boolean;
    OuvertTalent:      Boolean;
    OuvertRace:        Boolean;
    OuvertSort:        Boolean;
    OuvertArme:        Boolean;
    OuvertArmure:      Boolean;
    OuvertMetier:      Boolean;
  begin
    if (ComboBoxLangue.Itemindex) <> -1 then
      begin
        Langue := comboboxlangue.items[ComboBoxLangue.Itemindex];
        If Langue <> ValLangue then
          begin
            BloqueLangue := false;
            for Ind := 0 to Screen.FormCount - 1 do
              if (Screen.Forms[Ind] is TWinPersonnages) or (Screen.Forms[Ind] is TWinCreations) then
                BloqueLangue := true;

            if BloqueLangue then
              ShowMessage(GetTexteLibelle('RULES-MESS_055'))
            else
              if MessageDlg(GetTexteLibelle('RULES-MESS_041')+' : '+Langue, mtConfirmation, mbYesNo, 0) = mrYes then
                begin
                  OuvertLivre      := false;
                  OuvertCompetence := false;
                  OuvertTalent     := false;
                  OuvertRace       := false;
                  OuvertSort       := false;
                  OuvertArme       := false;
                  OuvertArmure     := false;
                  OuvertMetier     := false;
                  for Ind := Screen.FormCount - 1 downto 0 do
                    begin
                      if Screen.Forms[Ind] is TWinLivres then
                        begin
                          OuvertLivre := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinCompetence then
                        begin
                          OuvertCompetence := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWintTalent then
                        begin
                          OuvertTalent := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinRace then
                        begin
                          OuvertRace := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinSpells then
                        begin
                          OuvertSort := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinWeapons then
                        begin
                          OuvertArme := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinArmors then
                        begin
                          OuvertArmure := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinMetiers then
                        begin
                          OuvertMetier := true;
                          Screen.Forms[Ind].Close;
                        end;
                    end;

                  ValLangue := Langue;
                  ChargerLivre(true, '');
                  // ChargerLivre vient d'appliquer Traduit(ValLangue,'') à TOUS les livres, y
                  // compris INTERFACE - la langue d'interface doit rester décorrélée de la
                  // langue des livres (CONTEXT.md §2.70).
                  Traduit(ValLangueInterface, ConstInterfaceBook);
                  ChargerPersonnages();
                  RafraichirLibellesMenu();
                  SauveIni();

                  if OuvertLivre then
                    begin
                      FenLivre          := TWinLivres.Create(Application);
                      FenLivre.Position := poOwnerFormCenter;
                      FenLivre.Show;
                    end;
                  if OuvertCompetence then
                    begin
                      FenCompetence          := TWinCompetence.Create(Application);
                      FenCompetence.Position := poOwnerFormCenter;
                      FenCompetence.Show;
                    end;
                  if OuvertTalent then
                    begin
                      FenTalent          := TWintTalent.Create(Application);
                      FenTalent.Position := poOwnerFormCenter;
                      FenTalent.Show;
                    end;
                  if OuvertRace then
                    begin
                      FenRace          := TWinRace.Create(Application);
                      FenRace.Position := poOwnerFormCenter;
                      FenRace.Show;
                    end;
                  if OuvertSort then
                    begin
                      FenSort          := TWinSpells.Create(Application);
                      FenSort.Position := poOwnerFormCenter;
                      FenSort.Show;
                    end;
                  if OuvertArme then
                    begin
                      FenArme          := TWinWeapons.Create(Application);
                      FenArme.Position := poOwnerFormCenter;
                      FenArme.Show;
                    end;
                  if OuvertArmure then
                    begin
                      FenArmure          := TWinArmors.Create(Application);
                      FenArmure.Position := poOwnerFormCenter;
                      FenArmure.Show;
                    end;
                  if OuvertMetier then
                    begin
                      FenMetier          := TWinMetiers.Create(Application);
                      FenMetier.Position := poOwnerFormCenter;
                      FenMetier.Show;
                    end;
                end;
          end;
      end;
  end;

procedure TMenu.ComboBoxVersionSelect(Sender: TObject);
  // Rechargement à chaud de la version WFRP4/WFRP5 (Nono, 13/09/2026, CONTEXT.md §2.70) :
  // même mécanisme que ComboBoxLangueSelect (§2.8) - bloqué si WinPersonnage/WinCreation est
  // ouvert, fenêtres catalogue fermées puis rouvertes, ConstCheminLivre/ConstCheminPersonnage
  // (Var depuis le 13/09/2026) recalculés depuis la version choisie, TabLivre rescannée
  // (PeuplerTabLivre) puis ChargerLivre/ChargerPersonnages rejoués.
  // Chemins d'images races/métiers/sorts/niveaux recalculés depuis la version ici aussi
  // (Nono, 14/09/2026, CONTEXT.md §2.70) - même correctif qu'au démarrage (FormCreate) : plus
  // figés sur WFRP4\. Reste hors périmètre (pas demandé) : images du PDF de personnage
  // (ConstCheminPdf*), toujours sous WFRP4\.
  var
    Version:           String;
    Ind:               Integer;
    BloqueVersion:     Boolean;
    OuvertLivre:       Boolean;
    OuvertCompetence:  Boolean;
    OuvertTalent:      Boolean;
    OuvertRace:        Boolean;
    OuvertSort:        Boolean;
    OuvertArme:        Boolean;
    OuvertArmure:      Boolean;
    OuvertMetier:      Boolean;
  begin
    if ComboBoxVersion.ItemIndex <> -1 then
      begin
        Version := ComboBoxVersion.Items[ComboBoxVersion.ItemIndex];
        if Version <> ValVersion then
          begin
            BloqueVersion := false;
            for Ind := 0 to Screen.FormCount - 1 do
              if (Screen.Forms[Ind] is TWinPersonnages) or (Screen.Forms[Ind] is TWinCreations) then
                BloqueVersion := true;

            if BloqueVersion then
              ShowMessage(GetTexteLibelle('RULES-MESS_062'))
            else
              if MessageDlg(GetTexteLibelle('RULES-MESS_061')+' : '+Version, mtConfirmation, mbYesNo, 0) = mrYes then
                begin
                  OuvertLivre      := false;
                  OuvertCompetence := false;
                  OuvertTalent     := false;
                  OuvertRace       := false;
                  OuvertSort       := false;
                  OuvertArme       := false;
                  OuvertArmure     := false;
                  OuvertMetier     := false;
                  for Ind := Screen.FormCount - 1 downto 0 do
                    begin
                      if Screen.Forms[Ind] is TWinLivres then
                        begin
                          OuvertLivre := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinCompetence then
                        begin
                          OuvertCompetence := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWintTalent then
                        begin
                          OuvertTalent := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinRace then
                        begin
                          OuvertRace := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinSpells then
                        begin
                          OuvertSort := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinWeapons then
                        begin
                          OuvertArme := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinArmors then
                        begin
                          OuvertArmure := true;
                          Screen.Forms[Ind].Close;
                        end
                      else if Screen.Forms[Ind] is TWinMetiers then
                        begin
                          OuvertMetier := true;
                          Screen.Forms[Ind].Close;
                        end;
                    end;

                  ValVersion             := Version;
                  ConstCheminLivre       := '\DATABASE\' + ValVersion + '\';
                  ConstCheminPersonnage  := '\SAVED_CARACTERS\' + ValVersion + '\';
                  ConstCheminImageRace   := '\DATABASE\' + ValVersion + '\PICTURES\SPECIE\';
                  ConstCheminImageMetier := '\DATABASE\' + ValVersion + '\PICTURES\CLASS\';
                  ConstCheminImageSort   := '\DATABASE\' + ValVersion + '\PICTURES\SPELL\';
                  ConstCheminImageNiveau       := '\PICTURES\' + ValVersion + '\NIV\';
                  ConstCheminImageNiveauRacine := '\PICTURES\' + ValVersion + '\';
                  // Sélection de livres cochés de la NOUVELLE édition (CONTEXT.md §2.70) -
                  // sans ce recalcul, PeuplerTabLivre() rescannait bien les livres de la
                  // nouvelle édition mais gardait la sélection de l'ancienne (ListeLivre non
                  // à jour), cochant seulement les codes qu'elle avait en commun avec
                  // l'édition précédente - les autres livres restaient affichés mais
                  // décochés, donc non chargés (symptôme relevé par Nono après le switch).
                  ListeLivre            := ListeLivreParVersion.Values[ValVersion];
                  // Rescanner TabLivre AVANT ChargerLivre : celui-ci relit la sélection
                  // depuis TabLivre.Cells[ColLivreSel,...] (ForceMaj=true) pour savoir quoi
                  // importer - sans ce rescan, TabLivre resterait affichée avec les livres
                  // de l'édition précédente (symptôme relevé par Nono en testant WFRP5).
                  PeuplerTabLivre();
                  ChargerLivre(true, '');
                  // ChargerLivre vient d'appliquer Traduit(ValLangue,'') à TOUS les livres, y
                  // compris INTERFACE - la langue d'interface doit rester décorrélée de la
                  // langue des livres (même correctif que ComboBoxLangueSelect, §2.70).
                  Traduit(ValLangueInterface, ConstInterfaceBook);
                  ChargerPersonnages();
                  RafraichirLibellesMenu();
                  SauveIni();

                  if OuvertLivre then
                    begin
                      FenLivre          := TWinLivres.Create(Application);
                      FenLivre.Position := poOwnerFormCenter;
                      FenLivre.Show;
                    end;
                  if OuvertCompetence then
                    begin
                      FenCompetence          := TWinCompetence.Create(Application);
                      FenCompetence.Position := poOwnerFormCenter;
                      FenCompetence.Show;
                    end;
                  if OuvertTalent then
                    begin
                      FenTalent          := TWintTalent.Create(Application);
                      FenTalent.Position := poOwnerFormCenter;
                      FenTalent.Show;
                    end;
                  if OuvertRace then
                    begin
                      FenRace          := TWinRace.Create(Application);
                      FenRace.Position := poOwnerFormCenter;
                      FenRace.Show;
                    end;
                  if OuvertSort then
                    begin
                      FenSort          := TWinSpells.Create(Application);
                      FenSort.Position := poOwnerFormCenter;
                      FenSort.Show;
                    end;
                  if OuvertArme then
                    begin
                      FenArme          := TWinWeapons.Create(Application);
                      FenArme.Position := poOwnerFormCenter;
                      FenArme.Show;
                    end;
                  if OuvertArmure then
                    begin
                      FenArmure          := TWinArmors.Create(Application);
                      FenArmure.Position := poOwnerFormCenter;
                      FenArmure.Show;
                    end;
                  if OuvertMetier then
                    begin
                      FenMetier          := TWinMetiers.Create(Application);
                      FenMetier.Position := poOwnerFormCenter;
                      FenMetier.Show;
                    end;
                end;
          end;
      end;
  end;

procedure TMenu.ChargerListeVersions();
  // Peuple ComboBoxVersion (Nono, 13/09/2026, CONTEXT.md §2.70) : scanne chaque
  // sous-répertoire de DATABASE\ (une version par répertoire, ex. WFRP4, futur WFRP5) et,
  // dès qu'un livre de ce répertoire porte <OFFICIAL>"0"</OFFICIAL> (le livre de règles
  // de cette version, seul à porter cette valeur - chargeconstantes.pas), lit sa balise
  // <VERSION> et arrête la recherche pour ce répertoire : inutile de lire les autres
  // livres, un seul par répertoire suffit à nommer la version.
  // Sélection : reprend la valeur du .INI (lue plus tôt dans ChargeIni, dans ValVersion)
  // si elle correspond à une version trouvée ; sinon (première ligne du .INI absente,
  // ou version disparue) se positionne sur la première ligne de la liste.
  var
    DirectoryPath: String;
    SearchDir:     TSearchRec;
    SearchFile:    TSearchRec;
    CheminFichier: String;
    Version:       String;
    ValIni:        String;
  begin
    ComboBoxVersion.Style := csDropDownList;
    ValIni     := ValVersion;
    ValVersion := '';

    DirectoryPath := GetCurrentDir + '\DATABASE\';
    if FindFirst(DirectoryPath + DirectorySeparator + '*', faDirectory, SearchDir) = 0 then
      begin
        repeat
          if ((SearchDir.Attr and faDirectory) = faDirectory) and (SearchDir.Name <> '.') and (SearchDir.Name <> '..') then
            begin
              Version := '';
              if FindFirst(DirectoryPath + SearchDir.Name + DirectorySeparator + '*.xml', faAnyFile, SearchFile) = 0 then
                begin
                  repeat
                    CheminFichier := DirectoryPath + SearchDir.Name + DirectorySeparator + SearchFile.Name;
                    if XmlLivreBalise(CheminFichier, ConstXmlOfficielLivre) = '0' then
                      begin
                        Version := XmlLivreBalise(CheminFichier, ConstXmlVersionLivre);
                        break;
                      end;
                  until FindNext(SearchFile) <> 0;
                  FindClose(SearchFile);
                end;

              if (Version <> '') and (ComboBoxVersion.Items.IndexOf(Version) = -1) then
                begin
                  ComboBoxVersion.Items.Add(Version);
                  if Version = ValIni then
                    begin
                      ComboBoxVersion.ItemIndex := ComboBoxVersion.Items.Count - 1;
                      ValVersion                := Version;
                    end;
                end;
            end;
        until FindNext(SearchDir) <> 0;
        FindClose(SearchDir);
      end;

    // Rien dans le .INI, ou valeur disparue : première ligne de la liste (Nono, 13/09/2026).
    if (ValVersion = '') and (ComboBoxVersion.Items.Count > 0) then
      begin
        ComboBoxVersion.ItemIndex := 0;
        ValVersion                := ComboBoxVersion.Items[0];
      end;
  end;

procedure TMenu.ComboBoxLangueInterfaceSelect(Sender: TObject);
  // Sélecteur de langue de l'interface (RULES-LAB_*/RULES-MESS_*, décorrélé de la langue
  // des livres - Nono, 13/09/2026, CONTEXT.md §2.70) : même principe que
  // ComboBoxVersionSelect, seule la persistance .INI est branchée ici. Le rafraîchissement
  // de l'affichage (retraduire les libellés déjà posés dans la langue choisie) est laissé
  // à Nono.
  var
    Langue: String;
  begin
    if ComboBoxLangueInterface.ItemIndex <> -1 then
      begin
        Langue := ComboBoxLangueInterface.Items[ComboBoxLangueInterface.ItemIndex];
        if Langue <> ValLangueInterface then
          begin
            ValLangueInterface := Langue;
            SauveIni();
            // Retraduire uniquement les libellés d'interface (RULES-LAB_*/RULES-MESS_*, Livre
            // = ConstInterfaceBook) et rafraîchir les captions déjà posées sur le menu -
            // affichage demandé par Nono (CONTEXT.md §2.70). Les fenêtres secondaires
            // (WinLivre, WinCompetence, ...) ne sont pas fermées/rouvertes ici, contrairement
            // au changement de langue des livres : leurs libellés RULES-LAB_*/RULES-MESS_*
            // resteront dans l'ancienne langue d'interface jusqu'à réouverture.
            Traduit(ValLangueInterface, ConstInterfaceBook);
            RafraichirLibellesMenu();
          end;
      end;
  end;

procedure TMenu.ChargerListeLanguesInterface();
  // Peuple ComboBoxLangueInterface (Nono, 13/09/2026, CONTEXT.md §2.70) : pas de scan,
  // contrairement à ChargerListeVersions - INTERFACE.Xml/INTERFACE_FRANCAIS.Xml sont à
  // emplacement fixe (ConstCheminInterface), on lit juste leur balise <language> à tour de
  // rôle (XmlLivreBalise, comme le sélecteur de version). Sélection : reprend la valeur du
  // .INI (lue plus tôt dans ChargeIni, dans ValLangueInterface) si elle correspond à une
  // langue trouvée ; sinon (première ligne du .INI absente, ou langue disparue) se
  // positionne sur la première ligne de la liste - même règle que la version.
  var
    CheminFichier: String;
    Langue:        String;
    ValIni:        String;
  begin
    ComboBoxLangueInterface.Style := csDropDownList;
    ValIni              := ValLangueInterface;
    ValLangueInterface  := '';

    CheminFichier := GetCurrentDir + ConstCheminInterface + ConstFichierInterface + '.xml';
    Langue        := XmlLivreBalise(CheminFichier, ConstXmlLanguage);
    if (Langue <> '') and (ComboBoxLangueInterface.Items.IndexOf(Langue) = -1) then
      begin
        ComboBoxLangueInterface.Items.Add(Langue);
        if Langue = ValIni then
          begin
            ComboBoxLangueInterface.ItemIndex := ComboBoxLangueInterface.Items.Count - 1;
            ValLangueInterface                := Langue;
          end;
      end;

    CheminFichier := GetCurrentDir + ConstCheminInterface + ConstFichierInterfaceFrancais + '.xml';
    Langue        := XmlLivreBalise(CheminFichier, ConstXmlLanguage);
    if (Langue <> '') and (ComboBoxLangueInterface.Items.IndexOf(Langue) = -1) then
      begin
        ComboBoxLangueInterface.Items.Add(Langue);
        if Langue = ValIni then
          begin
            ComboBoxLangueInterface.ItemIndex := ComboBoxLangueInterface.Items.Count - 1;
            ValLangueInterface                := Langue;
          end;
      end;

    // Rien dans le .INI, ou valeur disparue : première ligne de la liste (même règle que
    // la version, Nono, 13/09/2026).
    if (ValLangueInterface = '') and (ComboBoxLangueInterface.Items.Count > 0) then
      begin
        ComboBoxLangueInterface.ItemIndex := 0;
        ValLangueInterface                := ComboBoxLangueInterface.Items[0];
      end;
  end;

procedure TMenu.PeuplerTabLivre();
  // Peuple TabLivre (grille "Livres" du menu) et ComboBoxLangue en scannant ConstCheminLivre
  // (Var depuis le 13/09/2026, CONTEXT.md §2.70) - extrait de FormCreate (mécanique
  // inchangée) pour être rejouable au changement de version (ComboBoxVersionSelect), sans
  // quoi TabLivre restait figée sur les livres de l'ancienne édition après un rechargement.
  // Remise à zéro volontairement limitée à TabLivre/LivresLivres/LivresCharges (propres à
  // l'édition) : ListeLangue et ComboBoxLangue.Items ne sont PAS réinitialisés, une langue
  // déjà connue d'une édition précédente doit rester dans la liste plutôt que dupliquée.
  var
    SearchResult:  TSearchRec;
    DirectoryPath: String;
    I:             Integer;
    Ordre:         String;
    Nom:           String;
    PLivre:        StructureLivre;
  begin
    TabLivre.RowCount := 1;
    LivresLivres       := '';
    LivresCharges       := '';
    I := 0;

    DirectoryPath := GetCurrentDir + ConstCheminLivre;
    if FindFirst(DirectoryPath + '*.xml', faAnyFile, SearchResult) = 0 then
    begin
      repeat
        Nom := XmlLivre(ExtractStringBefore(SearchResult.Name,'.'));
        if Pos(AjouteAccolade(LivreLangue), ListeLangue) = 0 then
          begin
             ComboBoxLangue.Items.add(LivreLangue);
             if LivreLangue = ValLangue then
               ComboBoxLangue.itemindex := ComboBoxLangue.items.count - 1;
             ListeLangue := ListeLangue + AjouteAccolade(LivreLangue);
          end;

        if pos(AjouteAccolade(Nom), LivresLivres) = 0 then
        begin
          Inc(I);
          if TabLivre.RowCount <= I then
            TabLivre.RowCount      := TabLivre.RowCount + 1;
          if (ListeLivre = '') or (Pos(AjouteAccolade(Nom), ListeLivre) > 0) then
            begin
              TabLivre.Cells[ColLivreSel, I] := ConstSelectionne;
              LivresCharges        := LivresCharges + AjouteAccolade(Nom);
            end;
          LivresLivres                       := LivresLivres + AjouteAccolade(Nom);
          TabLivre.Cells[ColLivreLib, I]     := GetTexteLibelle(Nom,'','',true);
          TabLivre.Cells[ColLivreCod, I]     := Nom;
          PLivre                             := ChercheLivreLibelle(Nom);
          Ordre                              := IntToStr(PLivre.Officiel);
          if Ordre = '2' then
            TabLivre.Cells[ColLivreO_F, I]   := ConstLivreFacultatif
          else
            TabLivre.Cells[ColLivreO_F, I]   := ConstLivreOfficiel;
          TabLivre.Cells[ColLivreOrd, I]     := Ordre+Nom;
            TabLivre.Cells[ColLivreChe, I]   := SearchResult.Name;
          ListBook                 += [Nom];
        end;
      until FindNext(SearchResult) <> 0;
      FindClose(SearchResult);
    end;
    TabLivre.SortColRow(true,ColLivreOrd);
  end;

Procedure TMenu.RafraichirLibellesMenu();
  // Rafraîchit les libellés déjà posés sur le menu principal après un changement de
  // langue en direct (CONTEXT.md §2.8). Duplique DÉLIBÉRÉMENT un sous-ensemble de
  // FormCreate plutôt que de le rappeler : FormCreate fait aussi de la construction à
  // usage unique (GridAjouteColonne ajoute une colonne à chaque appel, les Listxxx.Create
  // fuiraient l'instance précédente, plusieurs listes/tableaux sont remplis par += donc
  // dupliqueraient leur contenu) - seul le sous-ensemble "libellé simple, sûr à
  // réécrire" est repris ici. Si un nouveau libellé est ajouté à FormCreate plus tard,
  // penser à l'ajouter aussi ici s'il doit changer avec la langue.
  var
    Ind:          Integer;
    LargeurForm:  Integer;
    HauteurForm:  Integer;
    LargeurLivre: Integer;
    HauteurLivre: Integer;
    LargeurPerso: Integer;
    HauteurPerso: Integer;
  begin
    // Filet de sécurité contre le grossissement cumulatif de la fenêtre à chaque
    // changement de langue (CONTEXT.md §2.8, bug du 18/08/2026) : malgré le
    // ScaleDpi=false plus bas, la taille continuait à dériver un peu plus à chaque appel
    // - cause exacte non identifiée avec certitude (LCL). Solution de contournement
    // proposée par Nono : mémoriser la taille de la fenêtre et des deux grilles avant
    // tout rafraîchissement, et la réimposer de force juste après, quoi qu'il se soit
    // passé entre-temps.
    LargeurForm  := Self.Width;
    HauteurForm  := Self.Height;
    LargeurLivre := TabLivre.Width;
    HauteurLivre := TabLivre.Height;
    LargeurPerso := TabPersonnage.Width;
    HauteurPerso := TabPersonnage.Height;

    TypeEquipCC         := GetTexteLibelle('RULES-LAB_061');
    TypeEquipCT         := GetTexteLibelle('RULES-LAB_062');
    TypeEquipMU         := GetTexteLibelle('RULES-LAB_060');
    TypeEquipMetierArme := TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU;
    TypeEquipWe         := GetTexteLibelle('RULES-LAB_063');
    TypeEquipDI         := GetTexteLibelle('RULES-LAB_064');
    TypeEquipAN         := GetTexteLibelle('RULES-LAB_252');
    TypeEquipAR         := GetTexteLibelle('RULES-LAB_065');
    TypeEquipARS        := GetTexteLibelle('RULES-LAB_150');

    // En-têtes de colonnes déjà créées (pas de GridAjouteColonne ici, qui ajouterait une
    // colonne de plus à chaque changement de langue - on réécrit juste le titre de la
    // colonne existante, retrouvée via les mêmes constantes d'indice que FormCreate).
    TabLivre.Columns[ColLivreLib - 1].Title.Caption := GetTexteLibelle('RULES-LAB_014');

    TabPersonnage.Columns[ColPersoNom - 1].Title.Caption := GetTexteLibelle('RULES-LAB_014');
    TabPersonnage.Columns[ColPersoWor - 1].Title.Caption := GetTexteLibelle('RULES-LAB_006');
    TabPersonnage.Columns[ColPersoRac - 1].Title.Caption := GetTexteLibelle('RULES-LAB_042');
    TabPersonnage.Columns[ColPersoNiv - 1].Title.Caption := GetTexteLibelle('RULES-LAB_019');
    TabPersonnage.Columns[ColPersoTXp - 1].Title.Caption := GetTexteLibelle('RULES-LAB_035');
    TabPersonnage.Columns[ColPersoCXp - 1].Title.Caption := GetTexteLibelle('RULES-LAB_041');
    TabPersonnage.Columns[ColPersoLOb - 1].Title.Caption := GetTexteLibelle('RULES-LAB_128');
    TabPersonnage.Columns[ColPersoLNe - 1].Title.Caption := GetTexteLibelle('RULES-LAB_136');

    // Libellés des livres eux-mêmes (une ligne par livre dans TabLivre, pas juste
    // l'en-tête de colonne) - même appel que FormCreate (ligne ~620).
    for Ind := 1 to TabLivre.RowCount - 1 do
      if TabLivre.Cells[ColLivreCod, Ind] <> '' then
        TabLivre.Cells[ColLivreLib, Ind] := GetTexteLibelle(TabLivre.Cells[ColLivreCod, Ind],'','',true);

    ConstArbreAttribut          := GetTexteLibelle('RULES-LAB_008');
    ConstArbreCompetence        := GetTexteLibelle('RULES-LAB_009');
    ConstArbreTalent            := GetTexteLibelle('RULES-LAB_007');
    ConstArbreAuChoix           := GetTexteLibelle('RULES-LAB_010');
    ConstArbreEnsemble          := GetTexteLibelle('RULES-LAB_186');
    ConstArbreMetierPossible    := GetTexteLibelle('RULES-LAB_011');
    ConstArbreRacePossible      := GetTexteLibelle('RULES-LAB_012');
    ConstArbreEquipement        := GetTexteLibelle('RULES-LAB_013');
    ConstArbreCorruption        := GetTexteLibelle('RULES-LAB_156');

    Label1.Caption              := GetTexteLibelle('RULES-LAB_082');
    ButtonCompetence.Caption    := GetTexteLibelle('RULES-LAB_009');
    ButtonTalent.Caption        := GetTexteLibelle('RULES-LAB_007');
    ButtonMetier.Caption        := GetTexteLibelle('RULES-LAB_006');
    ButtonRace.Caption          := GetTexteLibelle('RULES-LAB_042');
    RemplirTabBibliotheque();

    Label2.Caption              := GetTexteLibelle('RULES-LAB_081');
    ButtonCreation.Caption      := GetTexteLibelle('RULES-LAB_079');
    ButtonModification.Caption  := GetTexteLibelle('RULES-LAB_080');

    Label3.Caption              := GetTexteLibelle('RULES-LAB_128');

    ButtonCreationLivre.Caption := GetTexteLibelle('RULES-LAB_154');
    ButtonOuvrirLivre.Caption   := GetTexteLibelle('RULES-LAB_155');

    Label4.Caption              := GetTexteLibelle('RULES-LAB_183');
    Label5.Caption              := GetTexteLibelle('RULES-LAB_184');

    // Remettre les colonnes auto-dimensionnées à leur largeur de départ (celle donnée à
    // GridAjouteColonne dans FormCreate) avant de rappeler AdjustGridColumnsWidth : sa
    // Grid.AutoSizeColumn ne fait qu'agrandir une colonne, jamais la rétrécir - sans ce
    // reset, les tables s'élargissaient un peu plus à chaque changement de langue en
    // direct (CONTEXT.md §2.8, bug du 17/08/2026).
    TabLivre.ColWidths[ColLivreSel] := 20;
    TabLivre.ColWidths[ColLivreLib] := 230;
    TabLivre.ColWidths[ColLivreRac] := 30;
    TabLivre.ColWidths[ColLivreWor] := 30;
    TabLivre.ColWidths[ColLivreO_F] := 30;
    TabLivre.ColWidths[ColLivreAbr] := 30;
    TabLivre.ColWidths[ColLivreCom] := 30;
    TabLivre.ColWidths[ColLivreTal] := 30;
    TabLivre.ColWidths[ColLivreArm] := 30;
    TabLivre.ColWidths[ColLivreArU] := 30;
    TabLivre.ColWidths[ColLivreEqu] := 30;
    TabLivre.ColWidths[ColLivreSor] := 30;
    TabLivre.ColWidths[ColLivreTra] := 30;

    TabPersonnage.ColWidths[ColPersoNom] := 100;
    TabPersonnage.ColWidths[ColPersoWor] := 150;
    TabPersonnage.ColWidths[ColPersoRac] := 200;
    TabPersonnage.ColWidths[ColPersoNiv] := 30;
    TabPersonnage.ColWidths[ColPersoTXp] := 30;
    TabPersonnage.ColWidths[ColPersoCXp] := 30;
    TabPersonnage.ColWidths[ColPersoLOb] := 150;
    TabPersonnage.ColWidths[ColPersoLNe] := 150;

    AdjustGridColumnsWidth(TabLivre, Self.Height, true, true, True, 0, 10, ssAutoBoth, false);
    AdjustGridColumnsWidth(TabPersonnage, Self.Height, true, true, True, 0, 10, ssAutoBoth, false);

    // Réimposer la taille mémorisée au tout début, quoi qu'AdjustGridColumnsWidth ait pu
    // faire dériver entre-temps.
    Self.Width          := LargeurForm;
    Self.Height         := HauteurForm;
    TabLivre.Width       := LargeurLivre;
    TabLivre.Height      := HauteurLivre;
    TabPersonnage.Width  := LargeurPerso;
    TabPersonnage.Height := HauteurPerso;

    // Les deux AdjustGridColumnsWidth ci-dessus peuvent avoir fait deriver TabLivre/
    // TabPersonnage un instant avant la remise en place ci-dessus - Button3/
    // TabPersonnage.Left/Button1/colonne Bibliotheque (ancrage du 15/09/2026) ne sont pas
    // touches par cette fonction et pourraient donc rester calcules sur un etat
    // intermediaire perime. Reancre tout depuis l'etat final remis en place ci-dessus.
    AjustePositionFenetre();
  end;

procedure TMenu.FormActivate(Sender: TObject);
begin
  if NeedUpdate then
    begin
      ChargerPersonnages;
      NeedUpdate := false;
    end;
  if RecherchePersonnage <> '' then
    begin
      NomPersonnage         := RecherchePersonnage;
      RecherchePersonnage   := '';
      FenPersonnage         := TWinPersonnages.Create(Application);
      FenPersonnage.Position:= poOwnerFormCenter;
      FenPersonnage.Show;
    end
end;

Procedure TMenu.ChargeIni();
  var
    Ind:           Integer;
    DirectoryPath: string;
    fichier:       TextFile;
    ligne:         string;
    LocLangue:     String;
    LocVersion:    String;
    LocLangueInterface: String;
    PosEgal:       Integer;
  begin
    // récupérer la langue dans la fichier ini s'il existe
    LocLangue     := ValLangue;
    LocVersion    := '';
    LocLangueInterface := '';
    DirectoryPath := GetCurrentDir+ConstFichierIni;
    if FileExists(DirectoryPath) then
      begin
        AssignFile(fichier, DirectoryPath);
        Reset(fichier);

        while not Eof(fichier) do
          begin
            ReadLn(fichier, ligne);
            Ligne := ReplaceTilde(Ligne);
            if pos(ConstIniLangue, Ligne) > 0 then
              LocLangue := ExtractStringAfter(Ligne,ConstIniLangue);
            // BOOK<version>=<liste> - une ligne par édition (13/09/2026, CONTEXT.md §2.70) ;
            // ListeLivre (la sélection RÉSOLUE de l'édition active) n'est affectée
            // définitivement que plus tard dans FormCreate, une fois ValVersion validée par
            // ChargerListeVersions - même principe que ValVersion ci-dessous.
            if pos(ConstIniLivre, Ligne) = 1 then
              begin
                PosEgal := Pos('=', Ligne);
                if PosEgal > Length(ConstIniLivre) then
                  ListeLivreParVersion.Values[Copy(Ligne, Length(ConstIniLivre)+1, PosEgal-Length(ConstIniLivre)-1)]
                    := Copy(Ligne, PosEgal+1, MaxInt);
              end;
            if pos(ConstIniVersion, Ligne) > 0 then
              LocVersion := ExtractStringAfter(Ligne,ConstIniVersion);
            if pos(ConstIniLangueInterface, Ligne) > 0 then
              LocLangueInterface := ExtractStringAfter(Ligne,ConstIniLangueInterface);
          end;
        CloseFile(fichier);
      end;
    ValLangue  := LocLangue;
    // ValVersion n'est affectée définitivement que dans ChargerListeVersions (appelée
    // plus tard dans FormCreate, une fois ComboBoxVersion peuplé) - même ordre que la
    // langue : lecture brute du .INI ici, résolution contre la liste déroulante ensuite.
    ValVersion := LocVersion;
    // Même principe pour la langue de l'interface (RULES-LAB_*/RULES-MESS_*, CONTEXT.md
    // §2.70) : résolution définitive dans ChargerListeLanguesInterface, appelée plus tard
    // dans FormCreate, une fois ComboBoxLangueInterface peuplé.
    ValLangueInterface := LocLangueInterface;

    // retrouver la langue dans la liste déroulante
    for ind := 0 to ComboBoxLangue.items.count -1 do
      if ComboBoxLangue.items[Ind] = LocLangue then
        begin
          ComboBoxLangue.itemindex := Ind;
          ValLangue                := LocLangue; // la langue existe, on peut l'enregistrer
          break;
        end;

  end;

procedure TMenu.ChargerLivre(ForceMaJ: Boolean; ForceLivre: String);
  var
    i:                     Integer = 0;
    SearchResult:          TSearchRec;
    DirectoryPath:         string;
    Nom:                   String;
    ListeFichiersACharger: TStringList;
    ListeNomsACharger:     TStringList;
    Idx:                   Integer;
    RulesBookIndex:        Integer;

    procedure ImporterUnLivre(FileName, NomLivre: String);
      var
        J: Integer;

        procedure Pose(Col, Nb: Integer);
          begin
            if Nb > 0 then
              TabLivre.Cells[Col, J] := IntToStr(Nb);
          end;

      begin
        XmlImport(FileName, false, false);
        for J := 1 to TabLivre.RowCount - 1 do
          if TabLivre.Cells[ColLivreCod, J] = NomLivre then
            begin
              Pose(ColLivreRac, LivreNbRace);
              Pose(ColLivreWor, LivreNbMetier);
              Pose(ColLivreCom, LivreNbCompetence);
              Pose(ColLivreTal, LivreNbTalent);
              Pose(ColLivreArm, LivreNbArme);
              Pose(ColLivreArU, LivreNbArmure);
              Pose(ColLivreEqu, LivreNbTrapping);
              Pose(ColLivreSor, LivreNbSort);
              Pose(ColLivreTra, LivreNbTrait);
              break;
            end;
      end;

  begin
    // Raz des variables
    if ForceMaj then
      begin
        NbRace	                    := 0;
        NbEspece                    := 0;
        NbNation                    := 0;
        NbRegle                     := 0;
        NbRegleMetier               := 0;
        NbTalent	            := 0;
        NbCompetence	            := 0;
        NbMetierCompetence	    := 0;
        NbMetier	            := 0;
        NbMetierNiveau	            := 0;
        NbMetierAttribut	    := 0;
        NbMetierTalent	            := 0;
        NbRaceMetier	            := 0;
        NbRaceAttribut	            := 0;
        NbRaceCompetence	    := 0;
        NbRaceTalent	            := 0;
        NbTalentCreation	    := 0;
        NbArme	                    := 0;
        NbArmure	            := 0;
        NbArmureSimplifiee          := 0;
        NbArmeBonus	            := 0;
        NbMetierEquipement	    := 0;
        NbArmureBonus	            := 0;
        NbArmureBonusModif          := 0;
        NbSort	                    := 0;
        NbFabrication	            := 0;
        NbFabricationModificateur   := 0;
        NbRaceCreation	            := 0;
        NbMetierSousMetier	    := 0;
        NbMetierRaceChoixMetier	    := 0;
        NbTalentUnique	            := 0;
        NbCompetenceUnique	    := 0;
        NbArmeUnique	            := 0;
        NbTraduction                := 0;
        NbRaceCorruptionCreation    := 0;
        nbCorruptionTable           := 0;
        nbCorruptionChance          := 0;
        NbTalentEffet                := 0;
        NbTalentCompetenceModif     := 0;
        NbTalentCompetenceAjoute    := 0;
        NbTalentModificateur        := 0;
        NbArmeModificateur          := 0;
        NbArmureBonusModificateur   := 0;
        NbCorruptionModificateur    := 0;
        NbRaceOpinion               := 0;
        NbTrapping                  := 0;
        NbTrait                     := 0;
        NbTraitOption               := 0;
        NbSortTalent                := 0;
        NbCareerBonus               := 0;
        NbCareerBonusNiveau         := 0;
        NbCareerBonusModificateur   := 0;
        NbCareerBonusSpecialRule    := 0;

        // vider les données
        ListRace.Clear;
        ListEspece.Clear;
        ListNation.Clear;
        ListRegle.Clear;
        ListRegleMetier.Clear;
        ListTalent.Clear;
        ListCompetence.Clear;
        ListMetierCompetence.Clear;
        ListMetier.Clear;
        ListMetierNiveau.Clear;
        ListMetierAttribut.Clear;
        ListMetierTalent.Clear;
        ListRaceMetier.Clear;
        ListRaceAttribut.Clear;
        ListRaceCompetence.Clear;
        ListRaceTalent.Clear;
        ListTalentCreation.Clear;
        ListArme.Clear;
        ListArmure.Clear;
        ListTrapping.Clear;
        // Oubliées jusqu'au 21/08/2026 : toutes deux remplies par XmlImport comme leurs
        // voisines, mais jamais vidées ici - chaque rechargement (changement de livre actif
        // ou de langue) rajoutait donc leur contenu par-dessus l'ancien. Visible sur le PDF
        // de personnage : l'annotation d'armure s'affichait deux fois, "(4) -10% (4) -10%".
        ListArmureSimplifiee.Clear;
        ListArmeBonus.Clear;
        ListMetierEquipement.Clear;
        ListArmureBonus.Clear;
        ListArmureBonusModif.Clear;
        ListSort.Clear;
        ListSortTalent.Clear;
        ListTrait.Clear;
        ListTraitOption.Clear;
        ListCareerBonus.Clear;
        ListCareerBonusNiveau.Clear;
        ListCareerBonusModificateur.Clear;
        ListCareerBonusSpecialRule.Clear;
        ListFabrication.Clear;
        ListFabricationModificateur.Clear;
        ListRaceCreation.Clear;
        ListMetierSousMetier.Clear;
        ListMetierRaceChoixMetier.Clear;
        ListRaceCorruptionCreation.Clear;
        ListCorruptionTable.Clear;
        ListCorruptionChance.Clear;
        ListTalentEffet.Clear;
        ListTalentCompetenceModif.Clear;
        ListTalentCompetenceAjoute.Clear;
        ListRaceOpinion.Clear;
        ListCorruptionCompetenceAttributModif.Clear;
        ListCorruptionTalent.Clear;
        ListCorruptionEquipement.Clear;
        ListArmureBonusTalent.Clear;
        ListTalentModificateur.Clear;
        // ListArmeModificateur/ListArmureBonusModificateur n'avaient pas d'equivalent .Clear
        // avant leur creation (migration ModifyCarac, 11/09/2026) : rattrapage au passage,
        // meme risque de doublon au rechargement que l'oubli documente ci-dessus pour
        // ListArmureSimplifiee/ListArmeBonus le 21/08/2026.
        ListArmeModificateur.Clear;
        ListArmureBonusModificateur.Clear;
        ListCorruptionModificateur.Clear;
      end;

    // chercher les livres
    if ForceMaj or (ForceLivre <> '') then
      begin
        LivresCharges := '';
        for I := 1 to TabLivre.RowCount - 1 do
          if (TabLivre.Cells[ColLivreSel, I] = ConstSelectionne) or (TabLivre.Cells[ColLivreCod, I] = ForceLivre) then
            LivresCharges := LivresCharges + AjouteAccolade(TabLivre.Cells[ColLivreCod, I]);
      end;

    // mettre à jour les données
    // Le RULESBOOK doit être importé en premier parmi les livres à charger ici,
    // pour la même raison que dans FormCreate (voir xmlexportimport.pas /
    // ChercheRace) : un supplément (ex. BOOK LUSTRIA) peut ajouter un <Specie>
    // qui référence une race déjà définie dans le RULESBOOK.
    directoryPath          := GetCurrentDir + ConstCheminLivre;
    ListeFichiersACharger  := TStringList.Create;
    ListeNomsACharger      := TStringList.Create;
    try
      if FindFirst(directoryPath + '*.xml', faAnyFile, searchResult) = 0 then
      begin
        repeat
          Nom := XmlLivre(ExtractStringBefore(searchResult.Name,'.'));
          if (pos(AjouteAccolade(Nom), LivresCharges) > 0) and ((ForceLivre = '') or ((LivreComplet = false) and (ForceLivre = Nom))) then
            begin
              ListeFichiersACharger.Add(ExtractStringBefore(searchResult.Name, '.'));
              ListeNomsACharger.Add(Nom);
            end;
        until FindNext(searchResult) <> 0;
        FindClose(searchResult);
      end;

      RulesBookIndex := -1;
      for Idx := 0 to ListeNomsACharger.Count - 1 do
        if ListeNomsACharger[Idx] = ConstRulesBook then
          begin
            RulesBookIndex := Idx;
            break;
          end;

      if RulesBookIndex >= 0 then
        begin
          ImporterUnLivre(ListeFichiersACharger[RulesBookIndex], ListeNomsACharger[RulesBookIndex]);
          ListeFichiersACharger.Delete(RulesBookIndex);
          ListeNomsACharger.Delete(RulesBookIndex);
        end;

      for Idx := 0 to ListeFichiersACharger.Count - 1 do
        ImporterUnLivre(ListeFichiersACharger[Idx], ListeNomsACharger[Idx]);
    finally
      ListeFichiersACharger.Free;
      ListeNomsACharger.Free;
    end;

    // Tous les livres sont chargés : propager l'accessibilité des métiers entre ethnies
    // d'une même race (voir ChargeRaceMetier.CompleteRaceMetierParEspece).
    CompleteRaceMetierParEspece;

    // affichages des valeurs
    TotLivreRace.Text            := IntToStr(NbRace);
    TotLivreRace.Alignment       := TaCenter;
    TotLivreMetier.Text          := IntToStr(NbMetier);
    TotLivreMetier.Alignment     := TaCenter;
    TotLivreCompetence.Text      := IntToStr(NbCompetenceUnique);
    TotLivreCompetence.Alignment := TaCenter;
    TotLivreTalent.Text          := IntToStr(NbTalentUnique);
    TotLivreTalent.Alignment     := TaCenter;
    RemplirTabBibliotheque();

    Traduit(ValLangue, '');
  end;

procedure TMenu.TabLivreMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  // Survol de l'en-tête d'une colonne de TabLivre : le hint donne la signification de la
  // lettre. Calculé à chaque survol (GetTexteLibelle), donc suit le changement de langue.
var
  ACol, ARow: Integer;
  Texte:      String;
begin
  Texte := '';
  TabLivre.MouseToCell(X, Y, ACol, ARow);
  if ARow = 0 then
    begin
      if ACol = ColLivreSel then Texte := GetTexteLibelle('RULES-LAB_211')
      else if ACol = ColLivreRac then Texte := GetTexteLibelle('RULES-LAB_212')
      else if ACol = ColLivreWor then Texte := GetTexteLibelle('RULES-LAB_213')
      else if ACol = ColLivreO_F then Texte := GetTexteLibelle('RULES-LAB_214')
      else if ACol = ColLivreCom then Texte := GetTexteLibelle('RULES-LAB_215')
      else if ACol = ColLivreTal then Texte := GetTexteLibelle('RULES-LAB_216')
      else if ACol = ColLivreArm then Texte := GetTexteLibelle('RULES-LAB_217')
      else if ACol = ColLivreArU then Texte := GetTexteLibelle('RULES-LAB_218')
      else if ACol = ColLivreEqu then Texte := GetTexteLibelle('RULES-LAB_219')
      else if ACol = ColLivreSor then Texte := GetTexteLibelle('RULES-LAB_220')
      else if ACol = ColLivreTra then Texte := GetTexteLibelle('RULES-LAB_221');
    end;
  if TabLivre.Hint <> Texte then
    begin
      TabLivre.Hint := Texte;
      Application.CancelHint;
    end;
end;

procedure TMenu.RemplirTabBibliotheque();
  var
    PTrapping:  StructureTrapping;
    NbVehicule: Integer;
  // Tableau des categories secondaires de la Bibliotheque (Arme, Armure, Equipement, Sort) :
  // remplace les lignes bouton + total + image. Pour ajouter une categorie : une ligne ici
  // et son ouverture dans TabBibliothequeDblClick (l'ordre des lignes est le meme).
  procedure Ligne(Ind: Integer; Libelle: String; Nb: Integer);
    begin
      TabBibliotheque.Cells[0, Ind] := Libelle;
      TabBibliotheque.Cells[1, Ind] := IntToStr(Nb);
    end;
begin
  if TabBibliotheque = nil then
    exit;
  TabBibliotheque.RowCount := 7;
  TabBibliotheque.Cells[0, 0] := GetTexteLibelle('RULES-LAB_014');
  TabBibliotheque.Cells[1, 0] := GetTexteLibelle('RULES-LAB_021');
  Ligne(1, GetTexteLibelle('RULES-LAB_063'), NbArme);
  Ligne(2, GetTexteLibelle('RULES-LAB_065'), NbArmure);
  // Animaux, montures, vehicules et bateaux (theme RULES-LAB_195) : ligne a part
  NbVehicule := 0;
  for PTrapping in ListTrapping do
    if PTrapping.Theme = ThemeAnimauxVehicules then
      Inc(NbVehicule);
  Ligne(3, GetTexteLibelle('RULES-LAB_202'), NbTrapping - NbVehicule);
  Ligne(4, GetTexteLibelle(ThemeAnimauxVehicules), NbVehicule);
  Ligne(5, GetTexteLibelle('RULES-LAB_083'), NbSort);
  Ligne(6, GetTexteLibelle('RULES-LAB_172'), ListCorruptionTable.Count);
end;

procedure TMenu.TabBibliothequeDblClick(Sender: TObject);
begin
  case TabBibliotheque.Row of
    1: ButtonArmeClick(Sender);
    2: ButtonArmureClick(Sender);
    3: ButtonEquipementClick(Sender);
    4: begin
         ModeEquipements := meVehicules;
         WinEquipements  := TWinEquipements.Create(Application);
         ModeEquipements := meTout;
         WinEquipements.Position := poOwnerFormCenter;
         WinEquipements.Show;
       end;
    5: ButtonSortClick(Sender);
    6: begin
         WinMutationCat          := TWinMutationCatalogue.Create(Application);
         WinMutationCat.Position := poOwnerFormCenter;
         WinMutationCat.Show;
       end;
  end;
end;

procedure TMenu.TabLivreDblClick(Sender: TObject);
var
  BookPath: String;
begin
  if (TabLivre.Cells[ColLivreLib, TabLivre.Row] <> '') then
  begin
    ShowMessage('[' + LivreRepertoireTravail('RULES','ENGLISH') + ']' + SeparateurRetourLigne
              + '[' + LivreFichierActuel('RULES','ENGLISH') + ']');


    // Si double-click sur la PREMIÈRE colonne (sélection) → toggle + charger
    if TabLivre.Col = ColLivreSel then
      begin
        if (TabLivre.Row > 1) then
          begin
          // Comportement actuel : toggle sélection
          if TabLivre.Cells[ColLivreSel, TabLivre.Row] <> ConstSelectionne then
            TabLivre.Cells[ColLivreSel, TabLivre.Row] := ConstSelectionne
          else
          begin
            TabLivre.Cells[ColLivreSel, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreRac, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreWor, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreCom, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreTal, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreArm, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreArU, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreEqu, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreSor, TabLivre.Row] := '';
            TabLivre.Cells[ColLivreTra, TabLivre.Row] := '';
          end;
          ChargerLivre(true, '');
          ChargerPersonnages();
          SauveIni();
        end
      end
    // Si double-click sur une AUTRE colonne → ouvrir WinLivre avec le livre
    else
    begin
      // Construire le chemin : DATABASE\<version>\BOOK RULESBOOK.Xml - suit ConstCheminLivre
      // (Var depuis le 13/09/2026, CONTEXT.md §2.70) au lieu d'un littéral WFRP4 figé, sans
      // quoi le double-clic ouvrirait le mauvais livre une fois sur une autre version.
      BookPath := GetCurrentDir + ConstCheminLivre + TabLivre.Cells[ColLivreChe, TabLivre.Row];

      // Créer/Ouvrir WinLivre et charger le livre
      if not Assigned(FenLivre) then
        FenLivre := TWinLivres.Create(Application);

      FenLivre.Position := poOwnerFormCenter;
      FenLivre.ChargerXMLFile(BookPath);  // ← Charge le livre automatiquement!
      FenLivre.Show;
      FenLivre.BringToFront;
    end;
  end;
end;

procedure TMenu.FormCreate(Sender: TObject);
  Var
    SearchResult:        TSearchRec;
    DirectoryPath:       string;
    ListeFichiersLivres: TStringList;
    Idx:                 Integer;
    RulesBookIndex:      Integer;
    LargeurMinTabLivre:  Integer;
  begin
       // Images du Menu
       ChargerImage();
       Randomize;

       // Sélection de livres cochés, une par édition (Nono, 13/09/2026, CONTEXT.md §2.70) -
       // créée AVANT ChargeIni() qui la peuple depuis le .INI.
       ListeLivreParVersion := TStringList.Create;

       // Charger Les données
       ChargeIni();

       // Sélecteur de version WFRP4/WFRP5 (CONTEXT.md §2.70) : appelée ICI, avant tout
       // chargement de livre, pour que ValVersion soit validée contre les répertoires
       // DATABASE\* réellement présents au disque AVANT de calculer ConstCheminLivre/
       // ConstCheminPersonnage juste en dessous - sans quoi le programme rouvrait toujours
       // WFRP4\ au démarrage même si le .INI mémorisait WFRP5 (symptôme relevé par Nono :
       // la combo affichait bien "WFRP5" mais les données chargées restaient celles de
       // WFRP4). ChargerListeVersions ne dépend d'aucune liste créée plus bas : elle scanne
       // DATABASE\ directement via XmlLivreBalise, indépendamment de ConstCheminLivre.
       ChargerListeVersions();
       ConstCheminLivre       := '\DATABASE\' + ValVersion + '\';
       ConstCheminPersonnage  := '\SAVED_CARACTERS\' + ValVersion + '\';
       // Chemins d'images races/métiers/sorts alignés sur la version comme ConstCheminLivre
       // ci-dessus (Nono, 14/09/2026, CONTEXT.md §2.70) - ne sont plus figés sur WFRP4\ (l'un
       // d'eux, ConstCheminImageMetier, était même figé sur WFRP5\ à tort, indépendamment de
       // ValVersion). Un dossier de version pas encore garni (WFRP5\PICTURES\SPECIE\ n'existe
       // pas encore au disque) se comporte comme aujourd'hui : FileExists échoue dans
       // CheminRaceImage/CheminMetierImage/CheminSortImage, aucune image trouvée.
       ConstCheminImageRace   := '\DATABASE\' + ValVersion + '\PICTURES\SPECIE\';
       ConstCheminImageMetier := '\DATABASE\' + ValVersion + '\PICTURES\CLASS\';
       ConstCheminImageSort   := '\DATABASE\' + ValVersion + '\PICTURES\SPELL\';
       // Icones de niveau, même correctif (Nono, 14/09/2026, CONTEXT.md §2.70) - images
       // WFRP5 ajoutées par Nono sous PICTURES\WFRP5\NIV\.
       ConstCheminImageNiveau       := '\PICTURES\' + ValVersion + '\NIV\';
       ConstCheminImageNiveauRacine := '\PICTURES\' + ValVersion + '\';
       // Sélection de livres cochés de CETTE édition (résolue depuis ListeLivreParVersion,
       // peuplée par ChargeIni - CONTEXT.md §2.70) - lue par PeuplerTabLivre plus bas.
       ListeLivre             := ListeLivreParVersion.Values[ValVersion];

       // création de la base de donnée
       ListRace                     := TListRace.Create;
       ListEspece                   := TListEspece.Create;
       ListNation                   := TListNation.Create;
       ListRegle                    := TListRegle.Create;
       ListRegleMetier              := TListRegleMetier.Create;
       ListTalent                   := TListTalent.Create;
       ListCompetence               := TListCompetence.Create;
       ListMetierCompetence         := TListMetierCompetence.Create;
       ListMetier                   := TListMetier.Create;
       ListMetierNiveau             := TListMetierNiveau.Create;
       ListMetierAttribut           := TListMetierAttribut.Create;
       ListMetierTalent             := TListMetierTalent.Create;
       ListeAttribut                := TListeAttribut.Create;
       ListRaceMetier               := TListRaceMetier.Create;
       ListRaceAttribut             := TListRaceAttribut.Create;
       ListRaceCompetence           := TListRaceCompetence.Create;
       ListRaceTalent               := TListRaceTalent.Create;
       ListTalentCreation           := TListTalentCreation.Create;
       ListeAttributAugmentation    := TListeAttributAugmentation.Create;
       ListeCompetenceAugmentation  := TListeCompetenceAugmentation.Create;
       ListArme                     := TListArme.Create;
       ListArmeModificateur         := TListModificateur.Create;
       ListArmure                   := TListArmure.Create;
       ListTrapping                 := TListTrapping.Create;
       ListArmureSimplifiee         := TListArmureSimplifiee.Create;
       ListArmeBonus                := TListArmeBonus.Create;
       ListMetierEquipement         := TListMetierEquipement.Create;
       ListArmureBonus              := TListArmureBonus.Create;
       ListArmureBonusModificateur  := TListModificateur.Create;
       ListSort                     := TListSort.Create;
       ListSortTalent               := TListSortTalent.Create;
       ListTrait                    := TListTrait.Create;
       ListTraitOption              := TListTraitOption.Create;
       ListCareerBonus              := TListCareerBonus.Create;
       ListCareerBonusNiveau        := TListCareerBonusNiveau.Create;
       ListCareerBonusModificateur   := TListModificateur.Create;
       ListCareerBonusSpecialRule    := TListCareerBonusSpecialRule.Create;
       ListFabrication              := TListFabrication.Create;
       ListFabricationModificateur  := TListModificateur.Create;
       ListRaceCreation             := TListRaceCreation.Create;
       ListMetierSousMetier         := TListMetierSousMetier.Create;
       ListMetierRaceChoixMetier    := TListMetierRaceChoixMetier.Create;
       ListTraduction               := TListTraduction.Create;
       ListLivre                    := TListLivre.Create;
       ListLivreTraduit             := TListLivreTraduit.Create;
       ListTexte                    := TListTexte.Create;
       ListRaceCorruptionCreation   := TListRaceCorruptionCreation.Create;
       ListCorruptionTable          := TListCorruptionTable.Create;
       ListCorruptionChance         := TListCorruptionChance.Create;
       ListTalentEffet               := TListTalentEffet.Create;
       ListTalentCompetenceModif    := TListTalentCompetenceModif.Create;
       ListTalentCompetenceAjoute   := TListTalentCompetenceAjoute.Create;
       ListRaceOpinion              := TListRaceOpinion.Create;
       ListArmureBonusModif         := TListArmureBonusModif.Create;
       ListCorruptionModificateur   := TListModificateur.Create;
       ListCorruptionCompetenceAttributModif := TListCorruptionCompetenceAttributModif.Create;
       ListCorruptionTalent         := TListCorruptionTalent.Create;
       ListCorruptionEquipement     := TListCorruptionEquipement.Create;
       ListArmureBonusTalent        := TListArmureBonusTalent.Create;
       ListTalentModificateur       := TListModificateur.Create;

       // chercher les livres
       // Le RULESBOOK doit être chargé en premier : d'autres livres (ex. BOOK
       // LUSTRIA) peuvent ajouter des <Specie> qui référencent des races déjà
       // définies dans le RULESBOOK (voir xmlexportimport.pas / ChercheRace) ;
       // il faut donc que les vraies données du RULESBOOK soient en place avant
       // qu'un éventuel stub de supplément ne soit traité, quel que soit l'ordre
       // renvoyé par FindFirst/FindNext.
       directoryPath        := GetCurrentDir + ConstCheminLivre;
       ListeFichiersLivres  := TStringList.Create;
       try
         if FindFirst(directoryPath + '*.xml', faAnyFile, searchResult) = 0 then
         begin
           repeat
             ListeFichiersLivres.Add(ExtractStringBefore(searchResult.Name, '.'));
           until FindNext(searchResult) <> 0;
           FindClose(searchResult);
         end;

         RulesBookIndex := -1;
         for Idx := 0 to ListeFichiersLivres.Count - 1 do
           if XmlLivre(ListeFichiersLivres[Idx]) = ConstRulesBook then
             begin
               RulesBookIndex := Idx;
               break;
             end;

         if RulesBookIndex >= 0 then
           begin
             XmlImport(ListeFichiersLivres[RulesBookIndex], true, false);
             ListeFichiersLivres.Delete(RulesBookIndex);
           end;

         for Idx := 0 to ListeFichiersLivres.Count - 1 do
           XmlImport(ListeFichiersLivres[Idx], true, false);
       finally
         ListeFichiersLivres.Free;
       end;

       // Libellés/messages d'interface (RULES-LAB_*/RULES-MESS_*) : vivent dans
       // INTERFACE.Xml/INTERFACE_FRANCAIS.Xml, directement sous DATABASE\ (pas sous
       // WFRP4\/WFRP5\) pour ne pas être dupliqués entre éditions - décision de Nono le
       // 13/09/2026 (CONTEXT.md §2.70). Pas de scan : deux fichiers à emplacement fixe,
       // chargés explicitement ici (anglais d'abord, comme pour le RULESBOOK) via le
       // chemin complet plutôt que ConstCheminLivre.
       XmlImport(ConstFichierInterface, true, false,
                 GetCurrentDir + ConstCheminInterface + ConstFichierInterface + '.xml');
       XmlImport(ConstFichierInterfaceFrancais, true, false,
                 GetCurrentDir + ConstCheminInterface + ConstFichierInterfaceFrancais + '.xml');

       TypeEquipCC         := GetTexteLibelle('RULES-LAB_061');
       TypeEquipCT         := GetTexteLibelle('RULES-LAB_062');
       TypeEquipMU         := GetTexteLibelle('RULES-LAB_060');
       TypeEquipMetierArme := TypeEquipCC+','+TypeEquipCT+','+TypeEquipMU;
       TypeEquipWe         := GetTexteLibelle('RULES-LAB_063');
       TypeEquipDI         := GetTexteLibelle('RULES-LAB_064');
       TypeEquipAN         := GetTexteLibelle('RULES-LAB_252');
       TypeEquipAR         := GetTexteLibelle('RULES-LAB_065');
       TypeEquipARS        := GetTexteLibelle('RULES-LAB_150');

       TabLivre.Clear;
       // mise en forme du tableau de création du Livre
       TabLivre.ColCount         := 1;
       TabLivre.RowCount         := 1;
       TabLivre.ColWidths[0]     := 20;
       // Grille des categories secondaires (creee ici, sous les quatre boutons principaux)
       if TabBibliotheque = nil then
         begin
           TabBibliotheque              := TStringGrid.Create(Self);
           TabBibliotheque.Parent       := Self;
           TabBibliotheque.SetBounds(ButtonRace.Left, 564, ButtonRace.Width + 160,
                                     Button1.Top + Button1.Height - 564 - 16);
           TabBibliotheque.Anchors      := [akLeft];   // position et hauteur recalculees dans AjustePositionFenetre
           TabBibliotheque.ColCount     := 2;
           TabBibliotheque.FixedCols    := 0;
           TabBibliotheque.FixedRows    := 1;
           TabBibliotheque.ColWidths[0] := TabBibliotheque.Width - 90;
           TabBibliotheque.ColWidths[1] := 60;
           TabBibliotheque.Options      := TabBibliotheque.Options - [goRangeSelect] + [goRowSelect];
           TabBibliotheque.ScrollBars   := ssAutoVertical;
           TabBibliotheque.OnDblClick   := @TabBibliothequeDblClick;
         end;
       ColLivreSel := GridAjouteColonne(TabLivre, 'S', 20, taCenter);
       ColLivreLib := GridAjouteColonne(TabLivre, GetTexteLibelle('RULES-LAB_014'), 230);
       ColLivreCod := GridAjouteColonne(TabLivre, '');
       ColLivreOrd := GridAjouteColonne(TabLivre, '');
       ColLivreRac := GridAjouteColonne(TabLivre, 'R', 30);
       ColLivreWor := GridAjouteColonne(TabLivre, 'W', 30);
       ColLivreO_F := GridAjouteColonne(TabLivre, 'B', 30);
       ColLivreAbr := GridAjouteColonne(TabLivre, 'A', 30);
       ColLivreCom := GridAjouteColonne(TabLivre, 'C', 30);
       ColLivreTal := GridAjouteColonne(TabLivre, 'T', 30);
       ColLivreArm := GridAjouteColonne(TabLivre, 'Wp', 30);
       ColLivreArU := GridAjouteColonne(TabLivre, 'Ar', 30);
       ColLivreEqu := GridAjouteColonne(TabLivre, 'E', 30);
       ColLivreSor := GridAjouteColonne(TabLivre, 'Sp', 30);
       ColLivreTra := GridAjouteColonne(TabLivre, 'Tr', 30);
       ColLivreChe := GridAjouteColonne(TabLivre, '');

       // mise en forme du tableau des personnages
       TabPersonnage.ColCount         := 1;
       TabPersonnage.RowCount         := 1;
       TabPersonnage.ColWidths[0]     := 20;
       ColPersoNom  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_014'), 100);
       ColPersoWor  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_006'), 150);
       ColPersoRac  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_042'), 200);
       ColPersoNiv  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_019'), 30, Tacenter);
       ColPersoTXp  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_035'), 30, taRightJustify);
       ColPersoCXp  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_041'), 30, taRightJustify);
       ColPersoLOb  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_128'), 150);
       ColPersoLNe  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('RULES-LAB_136'), 150);

       ComboBoxLangue.Style    := csDropDownList;
       // chercher les livres
       PeuplerTabLivre();

       // sélecteur de langue de l'interface, décorrélé de la langue des livres (CONTEXT.md §2.70)
       ChargerListeLanguesInterface();

       // charger les livres
       ChargerLivre(false, '');

       // Retraduire les libellés d'interface selon ValLangueInterface : ChargerLivre vient
       // d'appliquer Traduit(ValLangue,'') à TOUS les livres, y compris INTERFACE - la langue
       // d'interface doit rester décorrélée de la langue des livres (CONTEXT.md §2.70).
       Traduit(ValLangueInterface, ConstInterfaceBook);

       // chargesr les personnages
       ChargerPersonnages();

       // liste des groupes de métiers
       // Corrige le 15/09/2026 (Nono, WinFiltre) : ces codes etaient nus (sans prefixe
       // RULES-), contrairement a PMetier.LibelleGroupe (xmlexportimport.pas:2055, lu depuis
       // <Class>"RULES-CLASS_*"</Class>). Deux consequences silencieuses, meme cause -
       // VerifieRecherche (chargeconstantes.pas:1247) exige LivreRecherche = LivreValeur : un
       // code nu ne peut jamais matcher un code prefixe, ni dans un sens ni dans l'autre :
       // 1. GetTexteLibelle(PGroupe) dans WinFiltre.ChargeGroupe (winfiltre.pas:225) ne
       //    trouvait jamais l'entree ListTexte (deplacee dans INTERFACE.Xml le 15/09/2026,
       //    mais deja prefixee RULES- avant ce deplacement) - repli sur le code brut affiche.
       // 2. VerifieFiltre(PMetier.LibelleGroupe, filtreGroupe) dans WinMetier
       //    (winmetier.pas:204) compare par sous-chaine (chargeconstantes.pas:1097) : un
       //    filtre construit sans prefixe ("{CLASS_ACAD}...") ne contient jamais
       //    "{RULES-CLASS_WARR}" - un choix PARTIEL de classes ne matchait donc plus aucun
       //    metier (choix complet = filtre vide = pas de filtrage, d'ou le symptome
       //    invisible tant que toutes les classes restent cochees).
       ListGroup += ['RULES-CLASS_ACAD'];
       ListGroup += ['RULES-CLASS_BURG'];
       ListGroup += ['RULES-CLASS_COUR'];
       ListGroup += ['RULES-CLASS_PEAS'];
       ListGroup += ['RULES-CLASS_RANG'];
       ListGroup += ['RULES-CLASS_RIVE'];
       ListGroup += ['RULES-CLASS_ROGU'];
       ListGroup += ['RULES-CLASS_WARR'];

       // Appeler la procédure SetGlobalFonts au démarrage du formulaire
       MiseEnFormeDesChamp(self);

       ConstArbreAttribut          := GetTexteLibelle('RULES-LAB_008');
       ConstArbreCompetence        := GetTexteLibelle('RULES-LAB_009');
       ConstArbreTalent            := GetTexteLibelle('RULES-LAB_007');
       ConstArbreAuChoix           := GetTexteLibelle('RULES-LAB_010');
       ConstArbreEnsemble          := GetTexteLibelle('RULES-LAB_186');
       ConstArbreMetierPossible    := GetTexteLibelle('RULES-LAB_011');
       ConstArbreRacePossible      := GetTexteLibelle('RULES-LAB_012');
       ConstArbreEquipement        := GetTexteLibelle('RULES-LAB_013');
       ConstArbreCorruption        := GetTexteLibelle('RULES-LAB_156');

       Label1.Caption              := GetTexteLibelle('RULES-LAB_082');
       ButtonCompetence.Caption    := GetTexteLibelle('RULES-LAB_009');
       ButtonTalent.Caption        := GetTexteLibelle('RULES-LAB_007');
       ButtonMetier.Caption        := GetTexteLibelle('RULES-LAB_006');
       ButtonRace.Caption          := GetTexteLibelle('RULES-LAB_042');

       Label2.Caption              := GetTexteLibelle('RULES-LAB_081');
       ButtonCreation.Caption      := GetTexteLibelle('RULES-LAB_079');
       ButtonModification.Caption  := GetTexteLibelle('RULES-LAB_080');

       Label3.Caption              := GetTexteLibelle('RULES-LAB_128');

       ButtonCreationLivre.Caption := GetTexteLibelle('RULES-LAB_154');
       ButtonOuvrirLivre.Caption   := GetTexteLibelle('RULES-LAB_155');

       Label4.Caption              := GetTexteLibelle('RULES-LAB_183');
       Label5.Caption              := GetTexteLibelle('RULES-LAB_184');

       AdjustGridColumnsWidth(TabLivre, Self.Height, true, true, True, 0, 10);
       AdjustGridColumnsWidth(TabPersonnage, Self.Height, true, true, True, 0, 10);

       // TabLivre.Width réel (colonnes sommées par AdjustGridColumnsWidth ci-dessus) peut
       // être plus étroit que les 4 boutons Livre fixes au-dessus (ButtonExportLivre/
       // OuvrirLivre/DisclaimerLivre/CreationLivre, Left=224 dans le .lfm - jamais reancrés,
       // restent dans la colonne TabLivre) : leur bord droit dépasserait alors celui de
       // TabLivre, chevauchant Button3/TabPersonnage dès que TabLivre est à cette largeur -
       // cause réelle du chevauchement signalé par Nono le 15/09/2026 (pas une histoire de
       // redimensionnement : le plancher de 300 posé plus tôt dans le .lfm était trop
       // petit, arbitraire, jamais recalé sur ces boutons). Calculé plutôt que recopié en
       // dur, pour rester juste si le .lfm bouge.
       LargeurMinTabLivre := ButtonExportLivre.Left + ButtonExportLivre.Width;
       if ButtonOuvrirLivre.Left + ButtonOuvrirLivre.Width > LargeurMinTabLivre then
         LargeurMinTabLivre := ButtonOuvrirLivre.Left + ButtonOuvrirLivre.Width;
       if ButtonDisclaimerLivre.Left + ButtonDisclaimerLivre.Width > LargeurMinTabLivre then
         LargeurMinTabLivre := ButtonDisclaimerLivre.Left + ButtonDisclaimerLivre.Width;
       if ButtonCreationLivre.Left + ButtonCreationLivre.Width > LargeurMinTabLivre then
         LargeurMinTabLivre := ButtonCreationLivre.Left + ButtonCreationLivre.Width;
       TabLivre.Constraints.MinWidth := LargeurMinTabLivre - TabLivre.Left;

       // Même piège côté TabPersonnage : ButtonPdf (seul bouton de cette colonne à ne pas
       // démarrer au bord gauche de la table, +224 dans le .lfm) déborderait à droite si
       // TabPersonnage devenait plus étroite que ButtonPdf.Left-TabPersonnage.Left+
       // ButtonPdf.Width (Nono, 15/09/2026 - même correctif que TabLivre ci-dessus).
       TabPersonnage.Constraints.MinWidth :=
         (ButtonPdf.Left - TabPersonnage.Left) + ButtonPdf.Width;

       // Ancrage de la fenêtre principale (A FAIRE.txt, demande Nono 13/09/2026) : largeur
       // de référence capturée ICI, juste après les AdjustGridColumnsWidth ci-dessus - la
       // tentative précédente (référence prise au premier OnResize réel, pour parer une
       // hypothétique mise à l'échelle DPI tardive) n'a pas résolu le chevauchement observé
       // par Nono en agrandissant et ajoutait de la complexité sans bénéfice démontré :
       // retour à une capture simple et déterministe. AjustePositionFenetre borne aussi
       // désormais TabLivre/TabPersonnage à ne jamais redescendre sous cette référence
       // (Constraints.MinWidth posée en filet de sécurité côté LCL en plus, sur les deux
       // grilles dans le .lfm).
       FenetreInitialisee       := true;
       LargeurFenetreBase       := Self.ClientWidth;
       LargeurTabLivreBase      := TabLivre.Width;
       LargeurTabPersonnageBase := TabPersonnage.Width;

     // Charger Les polices
      gTTFontCache.SearchPath.Add('C:\Windows\Fonts');
      gTTFontCache.SearchPath.Add(GetCurrentDir + ConstCheminImagePolice);
      gTTFontCache.BuildFontCache;

      ImageTmp := GetCurrentDir+'TMP.PNG';
  end;

procedure TMenu.FormResize(Sender: TObject);
  begin
    AjustePositionFenetre();
  end;

procedure TMenu.AjustePositionFenetre();
  var
    EcartTotal: Integer;
  begin
    // Un OnResize qui arriverait avant la fin de FormCreate (construction de la fenetre,
    // ex. ChargeIni qui touche Self.Width) n'a encore rien a reancrer - LargeurFenetreBase
    // n'est capturee (dans FormCreate) qu'une fois FenetreInitialisee passee a true.
    if not FenetreInitialisee then
      exit;

    EcartTotal := Self.ClientWidth - LargeurFenetreBase;

    // Nono le 15/09/2026 : les deux tables ne doivent jamais devenir plus petites que leur
    // taille de depart, quelle qu'en soit la cause (fenetre retrecie sous la reference, ou
    // ecart transitoire pendant un drag) - en dessous, elles restent a leur taille de
    // depart plutot que de se chevaucher ; c'est alors la colonne Bibliotheque a droite qui
    // sortirait progressivement du cadre visible, jamais les deux tables qui s'ecrasent
    // l'une sur l'autre.
    if EcartTotal < 0 then
      EcartTotal := 0;

    // TabLivre et TabPersonnage se partagent l'ecart moitie-moitie a l'elargissement
    // (A FAIRE.txt, demande Nono 13/09/2026). Le reste d'un ecart impair va a
    // TabPersonnage pour que la somme des deux largeurs colle exactement a EcartTotal.
    TabLivre.Width       := LargeurTabLivreBase + (EcartTotal div 2);
    TabPersonnage.Width  := LargeurTabPersonnageBase + (EcartTotal - (EcartTotal div 2));

    // Tout ce qui est place ENTRE les deux tables (Button3) et APRES (Button1 puis toute
    // la colonne Bibliotheque) est reancre en chaine a partir de la geometrie fraichement
    // recalculee ci-dessus - jamais stocke, toujours recalcule depuis l'etat courant, meme
    // principe que AjustePositionTables (winpersonnage.pas). Les ecarts fixes (6/10/8/16/
    // 64/184) sont ceux du .lfm d'origine entre chaque controle et son voisin de gauche.
    Button3.Left         := TabLivre.Left + TabLivre.Width + 6;
    TabPersonnage.Left   := Button3.Left + Button3.Width + 10;
    Button1.Left         := TabPersonnage.Left + TabPersonnage.Width + 8;

    // Meme piege que TabLivre/TabPersonnage/Button2 plus haut, cote colonne Bibliotheque :
    // son premier element (ButtonRace et les 6 autres TBCButton, +16 apres Button1) ne
    // doit jamais chevaucher Panel2/Panel3 (Version/Interface, jamais reancres, bord droit
    // fixe Panel2.Left+Panel2.Width) - releve par Nono le 15/09/2026, les deux tables pres
    // de leur minimum ramenant Button1 trop a gauche.
    if Button1.Left < (Panel2.Left + Panel2.Width) - 16 then
      Button1.Left := (Panel2.Left + Panel2.Width) - 16;

    // Libelle et boutons de la colonne Personnages, au-dessus de TabPersonnage - alignes
    // sur son bord gauche (ButtonPdf a +224 dans le .lfm d'origine), suivent donc le meme
    // decalage que la table plutot que de rester figes (Nono, 15/09/2026).
    Label2.Left             := TabPersonnage.Left;
    ButtonCreation.Left     := TabPersonnage.Left;
    ButtonModification.Left := TabPersonnage.Left;
    ButtonPdf.Left          := TabPersonnage.Left + 224;

    // Button2 (ligne separatrice horizontale au-dessus des deux tables) s'arrete pile au
    // bord droit de TabPersonnage dans le .lfm d'origine (Left=0, Width=968=432+536) -
    // grandit donc du meme ecart total que les deux tables reunies. Ne doit cependant
    // jamais finir avant Panel2/Panel3 (combos Version/Interface, jamais reancres, bord
    // droit fixe a Panel2.Left+Panel2.Width) : si TabPersonnage redescendait pres de son
    // minimum, Button2 s'arreterait sinon avant elles (Nono, 15/09/2026).
    if TabPersonnage.Left + TabPersonnage.Width > Panel2.Left + Panel2.Width then
      Button2.Width := TabPersonnage.Left + TabPersonnage.Width
    else
      Button2.Width := Panel2.Left + Panel2.Width;

    Label1.Left            := Button1.Left + 184;
    TabBibliotheque.Left   := Button1.Left + 16;
    // Meme suivi vertical que les boutons Race..Talent (Anchors [akLeft] seul : ils derivent
    // avec la hauteur de la fenetre) : le tableau reste a 129 px sous ButtonTalent (564-435
    // dans le .lfm d'origine) et descend jusqu'a 16 px du bas de la colonne (Button1).
    TabBibliotheque.Top    := ButtonTalent.Top + 129;
    TabBibliotheque.Height := (Button1.Top + Button1.Height - 16) - TabBibliotheque.Top;
    if TabBibliotheque.Height < 120 then
      TabBibliotheque.Height := 120;
    ButtonRace.Left        := Button1.Left + 16;
    ButtonMetier.Left      := Button1.Left + 16;
    ButtonCompetence.Left  := Button1.Left + 16;
    ButtonTalent.Left      := Button1.Left + 16;

    TotLivreRace.Left       := Button1.Left + 64;
    TotLivreMetier.Left     := Button1.Left + 64;
    TotLivreCompetence.Left := Button1.Left + 64;
    TotLivreTalent.Left     := Button1.Left + 64;

    BoutonRace.Left        := Button1.Left + 184;
    BoutonMetier.Left      := Button1.Left + 184;
    BoutonCompetence.Left  := Button1.Left + 184;
    BoutonTalent.Left      := Button1.Left + 184;
  end;

procedure TMenu.ButtonCompetenceClick(Sender: TObject);
  begin
    // ouvrr les compétences
    FenCompetence          := TWinCompetence.Create(Application);
    FenCompetence.Position := poOwnerFormCenter;
    FenCompetence.Show;
  end;

procedure TMenu.ButtonTalentClick(Sender: TObject);
  begin
    // ouvrir les talents
    FenTalent          := TWintTalent.Create(Application);
    FenTalent.Position := poOwnerFormCenter;
    FenTalent.Show;
  end;

procedure TMenu.ButtonRaceClick(Sender: TObject);
  begin
    // ouvrir les races
    FenRace          := TWinRace.Create(Application);
    FenRace.Position := poOwnerFormCenter;
    FenRace.Show;
  end;

procedure TMenu.ButtonSortClick(Sender: TObject);
begin
  FenSort          := TWinSpells.Create(Application);
  FenSort.Position := poOwnerFormCenter;
  FenSort.Show;
end;

procedure TMenu.ButtonCreationClick(Sender: TObject);
  begin
    // créer un personnage
    FenCreation          := TWinCreations.Create(Application);
    FenCreation.Position := poOwnerFormCenter;
    FenCreation.Show;
  end;

procedure TMenu.ButtonCreationLivreClick(Sender: TObject);
begin
  CodeLivre        := '';
  NomLivre         := '';
  FenLivre         := TWinLivres.Create(Application);
  FenLivre.Position:= poOwnerFormCenter;
  FenLivre.Show;
end;

procedure TMenu.ButtonArmeClick(Sender: TObject);
begin
  FenArme          := TWinWeapons.Create(Application);
  FenArme.Position := poOwnerFormCenter;
  FenArme.Show;
end;

procedure TMenu.ButtonEquipementClick(Sender: TObject);
begin
  ModeEquipements         := meHorsVehicules;
  WinEquipements          := TWinEquipements.Create(Application);
  ModeEquipements         := meTout;
  WinEquipements.Position := poOwnerFormCenter;
  WinEquipements.Show;
end;

procedure TMenu.BoutonCompetenceClick(Sender: TObject);
begin
  FenCompetence          := TWinCompetence.Create(Application);
  FenCompetence.Position := poOwnerFormCenter;
  FenCompetence.Show;
end;

procedure TMenu.BoutonTalentClick(Sender: TObject);
begin
  FenTalent          := TWintTalent.Create(Application);
  FenTalent.Position := poOwnerFormCenter;
  FenTalent.Show;
end;

procedure TMenu.ButtonArmureClick(Sender: TObject);
begin
  FenArmure          := TWinArmors.Create(Application);
  FenArmure.Position := poOwnerFormCenter;
  FenArmure.Show;
end;

procedure TMenu.ButtonModificationClick(Sender: TObject);
  begin
    // ouvrir un personnage
    if TabPersonnage.Cells[ColPersoLNe, TabPersonnage.Row] <> '' then
      ShowMessage(GetTexteLibelle('RULES-MESS_046') + TabPersonnage.Cells[ColPersoLNe, TabPersonnage.Row])
    else
      begin
      NomPersonnage         := TabPersonnage.Cells[1, TabPersonnage.Row];
      if NomPersonnage <> '' then
        begin
          FenPersonnage         := TWinPersonnages.Create(Application);
          FenPersonnage.Position:= poOwnerFormCenter;
          FenPersonnage.Show;
        end;
      end;

  end;

procedure TMenu.ButtonOuvrirLivreClick(Sender: TObject);
  begin
    // ouvrir un livre
    CodeLivre        := TabLivre.Cells[ColLivreAbr, TabLivre.Row];
    NomLivre         := TabLivre.Cells[ColLivreCod, TabLivre.Row];
    if (NomLivre <> '') and (TabLivre.Cells[ColLivreSel, TabLivre.Row] = ConstSelectionne) then
      begin
        FenLivre         := TWinLivres.Create(Application);
        FenLivre.Position:= poOwnerFormCenter;
        FenLivre.Show;
      end;
  end;

procedure TMenu.ButtonDisclaimerLivreClick(Sender: TObject);
  var
    PLivre: StructureLivre;
  begin
    if TabLivre.Cells[ColLivreCod, TabLivre.Row] <> '' then
      begin
        PLivre := ChercheLivreLibelle(TabLivre.Cells[ColLivreCod, TabLivre.Row]);
        if PLivre.Disclaimer <> '' then
          ShowMessage(PLivre.Disclaimer)
        else
          ShowMessage('Aucun disclaimer saisi pour ce livre.');
      end;
  end;

function TMenu.XmlPersonnageFichierActuel(const Directory: string): string;
var
  SearchRec:       TSearchRec;
  HighestFileName: string;
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
        end;
      end;
    until FindNext(SearchRec) <> 0;
  end;

  if HighestFileName <> '' then
    Result := IncludeTrailingPathDelimiter(Directory) + HighestFileName
  else
    Result := '';
end;

procedure TMenu.ButtonPdfClick(Sender: TObject);
  Var
    Chemin: String;
    Personnage: StructurePersonnage;
  begin
    Chemin     := XmlPersonnageFichierActuel(GetCurrentDir+ConstCheminPersonnage+TabPersonnage.Cells[1, TabPersonnage.Row]);
    Personnage := PersonnageXmlChargement(Chemin);
    PdfPersonnageCreation(Personnage, true);
  end;

procedure TMenu.ButtonMetierClick(Sender: TObject);
  begin
    // ouvrir les métiers
    FenMetier          := TWinMetiers.Create(Application);
    FenMetier.Position := poOwnerFormCenter;
    FenMetier.Show;
  end;

procedure TMenu.BoutonMetierClick(Sender: TObject);
begin
  FenMetier          := TWinMetiers.Create(Application);
  FenMetier.Position := poOwnerFormCenter;
  FenMetier.Show;

end;

procedure TMenu.BoutonRaceClick(Sender: TObject);
begin
  FenRace          := TWinRace.Create(Application);
  FenRace.Position := poOwnerFormCenter;
  FenRace.Show;
end;

procedure TMenu.ButtonXmlClick(Sender: TObject);
var
//  Ind:    Integer;
  PLivreTraduit: StructureLivreTraduit;
begin
//  For Ind := 1 to TabLivre.RowCount - 1 do
//  XmlExportBook(TabLivre.Cells[ColLivreCod, Ind], ConstAnglais);
    if ValLangue = ConstAnglais then
      For PLivreTraduit in ListLivreTraduit do
        begin
          if PLivreTraduit.langue <> ConstAnglais then
            Traduit(PLivreTraduit.langue, PLivreTraduit.Livre);
          XmlExportBook(PLivreTraduit.Livre , PLivreTraduit.langue);
          if PLivreTraduit.langue <> ConstAnglais then
            Traduit(ConstAnglais, PLivreTraduit.Livre);
        end;
end;

procedure TMenu.ChargerPersonnages();
  var
    searchResult:  TSearchRec;
    directoryPath: string;
    i:             Integer = 0;
    Chemin:        String;
    Personnage:    StructurePersonnage;
    PMetier:       StructureMetier;
    PRace:         StructureRace;
    Livre:         String;
    LivreTab:      String;
    strings:       TStringList;
    Ind:           Integer;
    j:             Integer;
    LivreTrouve:   Boolean;
  begin
    // Remise à zéro avant rescan (13/09/2026, CONTEXT.md §2.70) : sans elle, TabPersonnage
    // ne fait qu'ajouter/écraser des lignes au fil des appels - au changement de version,
    // si le nouveau ConstCheminPersonnage pointe vers un dossier vide ou absent (cas de
    // SAVED_CARACTERS\WFRP5\ aujourd'hui), les personnages de l'édition précédente
    // restaient affichés (même symptôme que TabLivre, relevé par Nono en testant).
    TabPersonnage.RowCount := 1;
    directoryPath := GetCurrentDir + ConstCheminPersonnage;

    if FindFirst(directoryPath + DirectorySeparator + '*', faDirectory, searchResult) = 0 then
    begin
      repeat
        if ((searchResult.Attr and faDirectory) = faDirectory) and (searchResult.Name <> '.') and (searchResult.Name <> '..') then
        begin
          i                         := i + 1;
          TabPersonnage.RowCount    := i + 1;
          TabPersonnage.Cells[ColPersoNom, I] := searchResult.Name;
          Chemin     := PersonnageXmlFichierActuel(directoryPath + searchResult.Name);
          if Chemin = '' then
            begin
              // Dossier de personnage sans fichier XML dedans (creation interrompue,
              // ex. nom termine par un espace : CreateDir tronque silencieusement le
              // dossier mais l'ecriture du XML avec le nom non tronque echoue ensuite).
              // PersonnageXmlChargement('') plante sans ce garde-fou - et comme ce
              // rescan tourne a chaque demarrage, le programme ne se rouvrait plus du
              // tout tant que le dossier vide restait sur le disque. On ignore la ligne.
              i                      := i - 1;
              TabPersonnage.RowCount := i + 1;
              Continue;
            end;
          Personnage := PersonnageXmlChargement(Chemin);
          PMetier    := chercheMetier(Personnage.MetierEnCours.CodeMetier);
          PRace      := chercheRace(Personnage.Race);
          TabPersonnage.Cells[ColPersoWor, I] := PMetier.Libelle;
          TabPersonnage.Cells[ColPersoRac, I] := PRace.Libelle;
          TabPersonnage.Cells[ColPersoNiv, I] := IntToStr(Personnage.MetierEnCours.NiveauMetier);
          TabPersonnage.Cells[ColPersoTXp, I] := Format('%.0n',[Personnage.XpTotal/1]);
          TabPersonnage.Cells[ColPersoCXp, I] := Format('%.0n',[Personnage.XpActuel/1]);
          TabPersonnage.Cells[ColPersoLOb, I] := Personnage.LivresObligatoires;

          strings       := TStringList.Create;
          ExtractStrings(['['], [], PChar(Personnage.LivresObligatoires), Strings);
          for Ind := 0 to (Strings.count - 1) Do
            begin
              LivreTrouve := False;
              Livre       := Strings[ind];
              Livre       := StringReplace(StringReplace(Livre, '[', '', [rfReplaceAll]), ']', '', [rfReplaceAll]);
              For J := 1 to TabLivre.RowCount - 1 Do
                begin
                  LivreTab := TabLivre.Cells[ColLivreCod, J];
                  if (LivreTab = Livre) and (TabLivre.Cells[ColLivreSel, J] = ConstSelectionne) then
                    begin
                      LivreTrouve := True;
                      Break;
                    end;
                end;
              If LivreTrouve = false then
                TabPersonnage.Cells[ColPersoLNe, I] := TabPersonnage.Cells[ColPersoLNe, I] + AjouteAccolade(Livre);
            end;
            Strings.Free;
        end;
      until FindNext(searchResult) <> 0;
      FindClose(searchResult);
    end;
    AdjustGridColumnsWidth(TabPersonnage, Self.Height, true, true, True, 0, 0);

    // Cet AdjustGridColumnsWidth (marge 0, differente des appels marge 10 de FormCreate)
    // peut retrecir TabPersonnage.Width en dehors de tout redimensionnement de fenetre -
    // ChargerPersonnages est rappelee hors FormCreate (FormActivate, si NeedUpdate), donc
    // apres que l'ancrage de la fenetre (AjustePositionFenetre) a deja pose sa reference.
    // Sans ce rappel, TabPersonnage se retrouvait plus etroite que ce que Button1/la
    // colonne Bibliotheque attendaient - Button3/TabPersonnage.Left etc. restant calcules
    // sur l'ancienne largeur, chevauchement releve par Nono le 15/09/2026 en agrandissant
    // la fenetre (voir Log.txt). Reancre tout depuis l'etat courant, quoi que
    // AdjustGridColumnsWidth ait pu faire deriver.
    AjustePositionFenetre();

    // Définir le chemin du répertoire
    directoryPath := GetCurrentDir + ConstCheminPersonnage;
  end;

end.

