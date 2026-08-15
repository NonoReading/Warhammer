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
  ChargeRace, WinRaces, ChargeRaceAttribut, ChargeRaceCompetence,
  ChargeRaceTalent, GlobalFonts, WinCreation, ChargeTalentCreation,
  WinPersonnage, ChargeAttributAugmentation, ChargeCompetenceAugmentation,
  ChargeArme, WinWeapon, ChargeArmeBonus, ChargeMetierEquipement, ChargeArmure,
  ChargeArmureBonus, WinArmor, ChargeSort, WinSpell, ChargeTexte,
  ChargeFabrication, Unitcalcul, ChargeMetierSousMetier,
  ChargeMetierRaceChoixMetier, ChargePersonnage, ChargeRaceCreation,
  ChargeTraduction, ChargeArmureSimplifie, ChargeLivre,
  ChargeTalentAttributModif, ChargeTalentCompetenceModif,
  ChargeTalentCompetenceAjoute, ChargeRaceCorruptionCreation,
  ChargeRaceOpinion, ChargeArmureBonusModif,
  CustomDrawn_Common, BCButton, BCLabel, fpTTF,
  PdfPersonnage, XmlExportImport, fppdf, WinLivre;

type

  { TMenu }

  TMenu = class(TForm)
    BoutonArme: TImage;
    BoutonArmure: TImage;
    BoutonCompetence: TImage;
    BoutonMetier: TImage;
    BoutonRace: TImage;
    BoutonSort: TImage;
    BoutonTalent: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ButtonArme: TBCButton;
    ButtonArmure: TBCButton;
    ButtonCompetence: TBCButton;
    ButtonCreation: TBCButton;
    ButtonOuvrirLivre: TBCButton;
    ButtonExportLivre: TBCButton;
    ButtonCreationLivre: TBCButton;
    ButtonPdf: TBCButton;
    ButtonMetier: TBCButton;
    ButtonModification: TBCButton;
    ButtonRace: TBCButton;
    ButtonSort: TBCButton;
    ButtonTalent: TBCButton;
    ComboBoxLangue: TComboBox;
    ImageFond: TImage;
    Label1: TBCLabel;
    Label2: TBCLabel;
    Label3: TBCLabel;
    TabLivre: TStringGrid;
    TotLivreArmure: TEdit;
    TotLivreSort: TEdit;
    TotLivreCompetence: TEdit;
    TotLivreTalent: TEdit;
    TotLivreRace: TEdit;
    Logo1: TImage;
    Logo2: TImage;
    TotLivreMetier: TEdit;
    TotLivreArme: TEdit;
    Panel1: TPanel;
    TabPersonnage: TStringGrid;
    procedure BoutonArmeClick({%H-}Sender: TObject);
    procedure BoutonArmureClick({%H-}Sender: TObject);
    procedure BoutonCompetenceClick({%H-}Sender: TObject);
    procedure BoutonSortClick({%H-}Sender: TObject);
    procedure BoutonTalentClick({%H-}Sender: TObject);
    procedure ButtonArmureClick({%H-}Sender: TObject);
    procedure ButtonArmeClick({%H-}Sender: TObject);
    procedure ButtonCreationClick({%H-}Sender: TObject);
    procedure ButtonCreationLivreClick(Sender: TObject);
    procedure ButtonModificationClick({%H-}Sender: TObject);
    procedure ButtonOuvrirLivreClick({%H-}Sender: TObject);
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
    procedure FormActivate({%H-}Sender: TObject);
    procedure FormCreate({%H-}Sender: TObject);
    procedure ChargerPersonnages();
    Procedure ChargeIni();
    procedure ChargerLivre(ForceMaJ: Boolean; ForceLivre: String);
    procedure TabLivreDblClick({%H-}Sender: TObject);
    procedure SauveIni();
    procedure TabPersonnagePrepareCanvas(Sender: TObject; {%H-}aCol, aRow: Integer;
      {%H-}aState: TGridDrawState);
    procedure TabPersonnageSelection({%H-}Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
    function XmlPersonnageFichierActuel(const Directory: string): string;
  private
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
  ColLivreChe:        Integer = 9;
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
    if FileExists(GetCurrentDir+ConstCheminBoutonArme) then
         BoutonArme.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonArme);
    if FileExists(GetCurrentDir+ConstCheminBoutonArmure) then
         BoutonArmure.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonArmure);
    if FileExists(GetCurrentDir+ConstCheminBoutonSort) then
         BoutonSort.Picture.LoadFromFile(GetCurrentDir+ConstCheminBoutonSort);
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
  for Ind := 1 to TabLivre.RowCount -1 do
      if TabLivre.Cells[ColLivreSel, Ind] = ConstSelectionne then
        Liste := Liste + AjouteAccolade(TabLivre.Cells[ColLivreCod, Ind]);
  Writeln(MyFile, ConstIniLivre + Liste);

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
  var
    Langue:   String;
  begin
    if (ComboBoxLangue.Itemindex) <> -1 then
      begin
        Langue := comboboxlangue.items[ComboBoxLangue.Itemindex];
        If Langue <> ValLangue then
          if MessageDlg(GetTexteLibelle('MESS_041')+' : '+Langue, mtConfirmation, mbYesNo, 0) = mrYes then
            begin
              SauveIni();
              Application.Terminate
            end;
      end;
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
  begin
    // récupérer la langue dans la fichier ini s'il existe
    LocLangue     := ValLangue;
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
            if pos(ConstIniLivre, Ligne) > 0 then
              ListeLivre := ExtractStringAfter(Ligne,ConstIniLivre);
          end;
        CloseFile(fichier);
      end;
    ValLangue := LocLangue;

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
    i:             Integer = 0;
    SearchResult:  TSearchRec;
    DirectoryPath: string;
    Nom:           String;
  begin
    // Raz des variables
    if ForceMaj then
      begin
        NbRace	                    := 0;
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
        NbArmeBonus	            := 0;
        NbMetierEquipement	    := 0;
        NbArmureBonus	            := 0;
        NbSort	                    := 0;
        NbFabrication	            := 0;
        NbRaceCreation	            := 0;
        NbMetierSousMetier	    := 0;
        NbMetierRaceChoixMetier	    := 0;
        NbTalentUnique	            := 0;
        NbCompetenceUnique	    := 0;
        NbArmeUnique	            := 0;
        NbTraduction                := 0;
        NbRaceCorruptionCreation    := 0;
        NbTalentAttributModif       := 0;
        NbTalentCompetenceModif     := 0;
        NbTalentCompetenceAjoute    := 0;
        NbRaceOpinion               := 0;

        // vider les données
        ListRace.Clear;
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
        ListArmeBonus.Clear;
        ListMetierEquipement.Clear;
        ListArmureBonus.Clear;
        ListSort.Clear;
        ListFabrication.Clear;
        ListRaceCreation.Clear;
        ListMetierSousMetier.Clear;
        ListMetierRaceChoixMetier.Clear;
        ListRaceCorruptionCreation.Clear;
        ListTalentAttributModif.Clear;
        ListTalentCompetenceModif.Clear;
        ListTalentCompetenceAjoute.Clear;
        ListRaceOpinion.Clear;
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
    directoryPath := GetCurrentDir + ConstCheminLivre;
    if FindFirst(directoryPath + '*.xml', faAnyFile, searchResult) = 0 then
    begin
      repeat
        Nom := XmlLivre(ExtractStringBefore(searchResult.Name,'.'));
        if (pos(AjouteAccolade(Nom), LivresCharges) > 0) and ((ForceLivre = '') or ((LivreComplet = false) and (ForceLivre = Nom))) then
          begin
            XmlImport(ExtractStringBefore(searchResult.Name, '.'), false, false);
            if (LivreNbRace > 0) or (LivreNbMetier > 0) then
              for I := 1 to TabLivre.RowCount - 1 do
                if TabLivre.Cells[ColLivreCod, I] = Nom then
                  begin
                    if LivreNbRace > 0 then
                      TabLivre.Cells[ColLivreRac, I] := IntToStr(LivreNbRace);
                    if LivreNbMetier > 0 then
                      TabLivre.Cells[ColLivreWor, I] := IntToStr(LivreNbMetier);
                    break;
                  end;
          end;
      until FindNext(searchResult) <> 0;
      FindClose(searchResult);
    end;

    // affichages des valeurs
    TotLivreRace.Text            := IntToStr(NbRace);
    TotLivreRace.Alignment       := TaCenter;
    TotLivreMetier.Text          := IntToStr(NbMetier);
    TotLivreMetier.Alignment     := TaCenter;
    TotLivreCompetence.Text      := IntToStr(NbCompetenceUnique);
    TotLivreCompetence.Alignment := TaCenter;
    TotLivreTalent.Text          := IntToStr(NbTalentUnique);
    TotLivreTalent.Alignment     := TaCenter;
    TotLivreArme.Text            := IntToStr(NbArme);
    TotLivreArme.Alignment       := TaCenter;
    TotLivreArmure.Text          := IntToStr(NbArmure);
    TotLivreArmure.Alignment     := TaCenter;
    TotLivreSort.Text            := IntToStr(NbSort);
    TotLivreSort.Alignment       := TaCenter;

    Traduit(ValLangue, '');
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
          end;
          ChargerLivre(true, '');
          ChargerPersonnages();
          SauveIni();
        end
      end
    // Si double-click sur une AUTRE colonne → ouvrir WinLivre avec le livre
    else
    begin
      // Construire le chemin : DATABASE\BOOK RULESBOOK.Xml
      BookPath := 'DATABASE\' + TabLivre.Cells[ColLivreChe, TabLivre.Row];;

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
    SearchResult:  TSearchRec;
    DirectoryPath: string;
    I:             Integer = 0;
    Ordre:         String;
    Nom:           String;
    PLivre:        StructureLivre;
  begin
       // Images du Menu
       ChargerImage();
       Randomize;

       // Charger Les données
       ChargeIni();
       ConstCheminImageRace    := '\DATABASE\PICTURES\SPECIE\';
       ConstCheminImageMetier  := '\DATABASE\PICTURES\CLASS\';
       ConstCheminImageSort    := '\DATABASE\PICTURES\SPELL\';

       // création de la base de donnée
       ListRace                     := TListRace.Create;
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
       ListArmure                   := TListArmure.Create;
       ListArmureSimplifiee         := TListArmureSimplifiee.Create;
       ListArmeBonus                := TListArmeBonus.Create;
       ListMetierEquipement         := TListMetierEquipement.Create;
       ListArmureBonus              := TListArmureBonus.Create;
       ListSort                     := TListSort.Create;
       ListFabrication              := TListFabrication.Create;
       ListRaceCreation             := TListRaceCreation.Create;
       ListMetierSousMetier         := TListMetierSousMetier.Create;
       ListMetierRaceChoixMetier    := TListMetierRaceChoixMetier.Create;
       ListTraduction               := TListTraduction.Create;
       ListLivre                    := TListLivre.Create;
       ListLivreTraduit             := TListLivreTraduit.Create;
       ListTexte                    := TListTexte.Create;
       ListRaceCorruptionCreation   := TListRaceCorruptionCreation.Create;
       ListTalentAttributModif      := TListTalentAttributModif.Create;
       ListTalentCompetenceModif    := TListTalentCompetenceModif.Create;
       ListTalentCompetenceAjoute   := TListTalentCompetenceAjoute.Create;
       ListRaceOpinion              := TListRaceOpinion.Create;
       ListArmureBonusModif         := TListArmureBonusModif.Create;

       // chercher les livres
       directoryPath := GetCurrentDir + ConstCheminLivre;
       if FindFirst(directoryPath + '*.xml', faAnyFile, searchResult) = 0 then
       begin
         repeat
           XmlImport(ExtractStringBefore(searchResult.Name, '.'), true, false);
         until FindNext(searchResult) <> 0;
       end;

       TypeEquipCC         := GetTexteLibelle('LAB_061');
       TypeEquipCT         := GetTexteLibelle('LAB_062');
       TypeEquipMU         := GetTexteLibelle('LAB_060');
       TypeEquipWe         := GetTexteLibelle('LAB_063');
       TypeEquipDI         := GetTexteLibelle('LAB_064');
       TypeEquipAR         := GetTexteLibelle('LAB_065');
       TypeEquipARS        := GetTexteLibelle('LAB_150');

       TabLivre.Clear;
       // mise en forme du tableau de création du Livre
       TabLivre.ColCount         := 1;
       TabLivre.RowCount         := 1;
       TabLivre.ColWidths[0]     := 20;
       ColLivreSel := GridAjouteColonne(TabLivre, 'S', 20, taCenter);
       ColLivreLib := GridAjouteColonne(TabLivre, GetTexteLibelle('LAB_014'), 230);
       ColLivreCod := GridAjouteColonne(TabLivre, '');
       ColLivreOrd := GridAjouteColonne(TabLivre, '');
       ColLivreRac := GridAjouteColonne(TabLivre, 'R', 30);
       ColLivreWor := GridAjouteColonne(TabLivre, 'W', 30);
       ColLivreO_F := GridAjouteColonne(TabLivre, 'B', 30);
       ColLivreAbr := GridAjouteColonne(TabLivre, 'A', 30);
       ColLivreChe := GridAjouteColonne(TabLivre, '');

       // mise en forme du tableau des personnages
       TabPersonnage.ColCount         := 1;
       TabPersonnage.RowCount         := 1;
       TabPersonnage.ColWidths[0]     := 20;
       ColPersoNom  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_014'), 100);
       ColPersoWor  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_006'), 150);
       ColPersoRac  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_042'), 200);
       ColPersoNiv  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_019'), 30, Tacenter);
       ColPersoTXp  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_035'), 30, taRightJustify);
       ColPersoCXp  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_041'), 30, taRightJustify);
       ColPersoLOb  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_128'), 150);
       ColPersoLNe  := GridAjouteColonne(TabPersonnage, GetTexteLibelle('LAB_136'), 150);

       ComboBoxLangue.Style    := csDropDownList;
       // chercher les livres
       directoryPath := GetCurrentDir + ConstCheminLivre;
       if FindFirst(directoryPath + '*.xml', faAnyFile, searchResult) = 0 then
       begin
         repeat
           Nom := XmlLivre(ExtractStringBefore(searchResult.Name,'.'));
           if Pos(AjouteAccolade(LivreLangue), ListeLangue) = 0 then
             begin
                ComboBoxLangue.Items.add(LivreLangue);
                if LivreLangue = ValLangue then
                  ComboBoxLangue.itemindex := ComboBoxLangue.items.count - 1;
                ListeLangue := ListeLangue + AjouteAccolade(LivreLangue);
             end;

           if pos(AjouteAccolade(Nom), LivresLivres) = 0 then
           begin
             Inc(i);
             if TabLivre.RowCount <= i then
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
               TabLivre.Cells[ColLivreChe, I]   := searchResult.Name;
             ListBook                 += [Nom];
           end;
         until FindNext(searchResult) <> 0;
         FindClose(searchResult);
       end;
       TabLivre.SortColRow(true,ColLivreOrd);

       // charger les livres
       ChargerLivre(false, '');

       // chargesr les personnages
       ChargerPersonnages();

       // liste des groupes de métiers
       ListGroup += ['CLASS_ACAD'];
       ListGroup += ['CLASS_BURG'];
       ListGroup += ['CLASS_COUR'];
       ListGroup += ['CLASS_PEAS'];
       ListGroup += ['CLASS_RANG'];
       ListGroup += ['CLASS_RIVE'];
       ListGroup += ['CLASS_ROGU'];
       ListGroup += ['CLASS_WARR'];

       // Appeler la procédure SetGlobalFonts au démarrage du formulaire
       MiseEnFormeDesChamp(self);

       ConstArbreAttribut          := GetTexteLibelle('LAB_008');
       ConstArbreCompetence        := GetTexteLibelle('LAB_009');
       ConstArbreTalent            := GetTexteLibelle('LAB_007');
       ConstArbreAuChoix           := GetTexteLibelle('LAB_010');
       ConstArbreMetierPossible    := GetTexteLibelle('LAB_011');
       ConstArbreRacePossible      := GetTexteLibelle('LAB_012');
       ConstArbreEquipement        := GetTexteLibelle('LAB_013');
       ConstArbreCorruption        := GetTexteLibelle('LAB_156');

       Label1.Caption              := GetTexteLibelle('LAB_082');
       ButtonCompetence.Caption    := GetTexteLibelle('LAB_009');
       ButtonTalent.Caption        := GetTexteLibelle('LAB_007');
       ButtonMetier.Caption        := GetTexteLibelle('LAB_006');
       ButtonRace.Caption          := GetTexteLibelle('LAB_042');
       ButtonArme.Caption          := GetTexteLibelle('LAB_063');
       ButtonArmure.Caption        := GetTexteLibelle('LAB_065');
       ButtonSort.Caption          := GetTexteLibelle('LAB_083');

       Label2.Caption              := GetTexteLibelle('LAB_081');
       ButtonCreation.Caption      := GetTexteLibelle('LAB_079');
       ButtonModification.Caption  := GetTexteLibelle('LAB_080');

       Label3.Caption              := GetTexteLibelle('LAB_128');

       ButtonCreationLivre.Caption := GetTexteLibelle('LAB_154');
       ButtonOuvrirLivre.Caption   := GetTexteLibelle('LAB_155');

       AdjustGridColumnsWidth(TabLivre, Self.Height, true, true, True, 0, 10);
       AdjustGridColumnsWidth(TabPersonnage, Self.Height, true, true, True, 0, 10);

     // Charger Les polices
      gTTFontCache.SearchPath.Add('C:\Windows\Fonts');
      gTTFontCache.SearchPath.Add(GetCurrentDir + ConstCheminImagePolice);
      gTTFontCache.BuildFontCache;

      ImageTmp := GetCurrentDir+'TMP.PNG';
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

procedure TMenu.BoutonCompetenceClick(Sender: TObject);
begin
  FenCompetence          := TWinCompetence.Create(Application);
  FenCompetence.Position := poOwnerFormCenter;
  FenCompetence.Show;
end;

procedure TMenu.BoutonSortClick(Sender: TObject);
begin
  FenSort          := TWinSpells.Create(Application);
  FenSort.Position := poOwnerFormCenter;
  FenSort.Show;
end;

procedure TMenu.BoutonArmeClick(Sender: TObject);
begin
  FenArme          := TWinWeapons.Create(Application);
  FenArme.Position := poOwnerFormCenter;
  FenArme.Show;
end;

procedure TMenu.BoutonArmureClick(Sender: TObject);
begin
  FenArmure          := TWinArmors.Create(Application);
  FenArmure.Position := poOwnerFormCenter;
  FenArmure.Show;
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
      ShowMessage(GetTexteLibelle('MESS_046') + TabPersonnage.Cells[ColPersoLNe, TabPersonnage.Row])
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

    // Définir le chemin du répertoire
    directoryPath := GetCurrentDir + ConstCheminPersonnage;
  end;

end.

