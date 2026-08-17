unit WinMutation;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, Grids,
  BCButton, ChargeConstantes, ChargeTexte, GlobalFonts, ChargeCorruptionTable, UnitCalcul;

type

  { TWinMutations }

  TWinMutations = class(TForm)
    ButtonMutationEntreeValider: TBCButton;
    ButtonMutationTypeMental: TBCButton;
    ButtonMutationTypePhysical: TBCButton;
    ButtonMutationTypeValider: TBCButton;
    GroupBoxMutationEntree: TGroupBox;
    GroupBoxMutationType: TGroupBox;
    RadioButtonMutationEntreeChoix: TRadioButton;
    RadioButtonMutationEntreeResultat: TRadioButton;
    RadioButtonMutationEntreeHasard: TRadioButton;
    RadioButtonMutationTypeChoix: TRadioButton;
    RadioButtonMutationTypeHasard: TRadioButton;
    EditMutationTypeResultat: TSpinEdit;
    RadioButtonMutationTypeResultat: TRadioButton;
    EditMutationEntreeResultat: TSpinEdit;
    TabMutationChoix: TStringGrid;
    Valider: TBCButton;
    ButtonMutationAnnuler: TBCButton;
    ButtonTypeHasard: TBCButton;
    ButtonMutationResilience: TBCButton;
    ButtonMutationAccepter: TBCButton;
    ButtonEntreeHasard: TBCButton;
    LabelTypeResultat: TEdit;
    LabelEntreeLibelle: TEdit;
    MemoEntreeEffet: TMemo;
    procedure FormCreate({%H-}Sender: TObject);
    procedure ButtonMutationResilienceClick({%H-}Sender: TObject);
    procedure ButtonMutationAccepterClick({%H-}Sender: TObject);
    procedure ButtonMutationAnnulerClick({%H-}Sender: TObject);
    procedure ButtonTypeHasardClick({%H-}Sender: TObject);
    procedure ButtonEntreeHasardClick({%H-}Sender: TObject);
    procedure ValiderClick({%H-}Sender: TObject);
    // Résultat/Choix (CONTEXT.md §2.7, reste à faire de l'étape 4, ajouté le 17/08/2026)
    procedure RadioButtonMutationTypeClick({%H-}Sender: TObject);
    procedure ButtonMutationTypeValiderClick({%H-}Sender: TObject);
    procedure ButtonMutationTypePhysicalClick({%H-}Sender: TObject);
    procedure ButtonMutationTypeMentalClick({%H-}Sender: TObject);
    procedure RadioButtonMutationEntreeClick({%H-}Sender: TObject);
    procedure ButtonMutationEntreeValiderClick({%H-}Sender: TObject);
    procedure TabMutationChoixDblClick({%H-}Sender: TObject);
  private
    // type de corruption tiré à l'étape 1 (CorruptionPhysique/CorruptionMentale), nécessaire
    // à l'étape 2 (CorruptionTableResultat) - pas encore de champ existant pour ça sur le form.
    TypeCorruptionResolu: String;
    // entrée précise tirée à l'étape 2 - gardée en entier (pas juste Libelle/Effet) pour que
    // ValiderClick puisse en extraire Code, la référence stable à stocker sur le personnage
    // (CONTEXT.md §2.7, pivot catalogue/table de chance du 17/08/2026).
    EntreeResolue: StructureCorruptionTable;
    // Vrai une fois "accepter une mutation" cliqué - déverrouille le tirage Type (Résilience
    // reste possible avant, CONTEXT.md §2.7 étape 4).
    MutationAcceptee: Boolean;
    procedure UpdateSheetMutationType();
    procedure UpdateSheetMutationEntree();
    procedure AfficheTypeResolu(Jet: Integer);
    procedure AfficheEntreeResolue(Entree: StructureCorruptionTable);
    procedure RemplitTabMutationChoix();
  public

  end;

var
  WinMutations: TWinMutations;

implementation

{$R *.lfm}

procedure TWinMutations.FormCreate(Sender: TObject);
  begin
    MiseEnFormeDesChamp(self);

    Self.Caption                     := GetTexteLibelle('LAB_156');
    ButtonMutationResilience.Caption := GetTexteLibelle('LAB_167');
    ButtonMutationAccepter.Caption   := GetTexteLibelle('LAB_168');
    ButtonMutationAnnuler.Caption    := GetTexteLibelle('LAB_166');
    ButtonTypeHasard.Caption         := GetTexteLibelle('LAB_085');
    ButtonEntreeHasard.Caption       := GetTexteLibelle('LAB_085');
    Valider.Caption                  := GetTexteLibelle('LAB_086');

    // Résultat/Choix (CONTEXT.md §2.7) - mêmes clés déjà utilisées pour ce rôle dans
    // wincreation.pas (Race/Métier).
    RadioButtonMutationTypeHasard.Caption   := GetTexteLibelle('LAB_085');
    RadioButtonMutationTypeResultat.Caption := GetTexteLibelle('LAB_089');
    RadioButtonMutationTypeChoix.Caption    := GetTexteLibelle('LAB_084');
    ButtonMutationTypeValider.Caption       := GetTexteLibelle('LAB_086');
    ButtonMutationTypePhysical.Caption      := GetTexteLibelle(CorruptionPhysique);
    ButtonMutationTypeMental.Caption        := GetTexteLibelle(CorruptionMentale);
    RadioButtonMutationEntreeHasard.Caption   := GetTexteLibelle('LAB_085');
    RadioButtonMutationEntreeResultat.Caption := GetTexteLibelle('LAB_089');
    RadioButtonMutationEntreeChoix.Caption    := GetTexteLibelle('LAB_084');
    ButtonMutationEntreeValider.Caption       := GetTexteLibelle('LAB_086');

    // sortie remise à vide à chaque ouverture - ButtonMutationAnnulerClick ne fait rien
    // d'autre que Close, donc MutationChoix doit déjà être '' pour que "fermer sans choisir"
    // (ex. la croix de la fenêtre) soit traité comme une annulation par WinPersonnage.
    MutationChoix           := '';
    MutationCode            := '';
    MutationLibelle         := '';
    MutationEffet           := '';
    TypeCorruptionResolu    := '';
    EntreeResolue.Code      := '';
    EntreeResolue.Livre     := '';
    EntreeResolue.TypeCorruption := '';
    EntreeResolue.Libelle   := '';
    EntreeResolue.Effet     := '';

    LabelTypeResultat.Text     := '';
    LabelTypeResultat.Enabled  := False;
    LabelEntreeLibelle.Text    := '';
    LabelEntreeLibelle.Enabled := False;
    MemoEntreeEffet.Text       := '';
    MemoEntreeEffet.ReadOnly   := True;

    EditMutationTypeResultat.MinValue   := 0;
    EditMutationTypeResultat.MaxValue   := 100;
    EditMutationEntreeResultat.MinValue := 0;
    EditMutationEntreeResultat.MaxValue := 100;

    TabMutationChoix.ColCount     := 3;
    TabMutationChoix.RowCount     := 1;
    TabMutationChoix.ColWidths[0] := 0;   // colonne réservée, convention du projet
    TabMutationChoix.ColWidths[1] := 0;   // Code (caché, sert juste à retrouver l'entrée)
    TabMutationChoix.ColWidths[2] := 300; // Libellé (visible)

    RadioButtonMutationTypeHasard.Checked   := True;
    RadioButtonMutationEntreeHasard.Checked := True;
    MutationAcceptee                        := False;

    ButtonMutationResilience.Enabled := MutationResilienceDisponible;
    ButtonMutationAccepter.Enabled   := True;
    Valider.Enabled                  := False;
    UpdateSheetMutationType();
    UpdateSheetMutationEntree();
  end;

procedure TWinMutations.ButtonMutationResilienceClick(Sender: TObject);
  begin
    MutationChoix := 'RESILIENCE';
    Close;
  end;

procedure TWinMutations.ButtonMutationAccepterClick(Sender: TObject);
  begin
    // le choix est définitif une fois "accepter une mutation" pris - on ne revient pas en
    // arrière vers la dépense de Résilience dans la même ouverture de fenêtre.
    ButtonMutationResilience.Enabled := False;
    ButtonMutationAccepter.Enabled   := False;
    MutationAcceptee                 := True;
    UpdateSheetMutationType();
  end;

// Affichage/état communs aux trois modes (Hasard/Résultat/Choix) du tirage Type - Visible
// selon le radio-bouton coché, Enabled seulement tant que rien n'est encore résolu (une fois
// TypeCorruptionResolu connu, on n'autorise pas de retirer sans repasser par le trio de
// radio-boutons, même principe que UpdateSheetRace dans wincreation.pas).
procedure TWinMutations.UpdateSheetMutationType();
  begin
    GroupBoxMutationType.Enabled := MutationAcceptee;

    ButtonTypeHasard.Visible := RadioButtonMutationTypeHasard.Checked;
    ButtonTypeHasard.Enabled := MutationAcceptee and (TypeCorruptionResolu = '');

    EditMutationTypeResultat.Visible  := RadioButtonMutationTypeResultat.Checked;
    EditMutationTypeResultat.Enabled  := MutationAcceptee and (TypeCorruptionResolu = '');
    ButtonMutationTypeValider.Visible := RadioButtonMutationTypeResultat.Checked;
    ButtonMutationTypeValider.Enabled := MutationAcceptee and (TypeCorruptionResolu = '');

    // Choix direct - grisé si la race n'a pas cette option (ex. Physical chez les Elfes),
    // même vérification que celle que CorruptionDansPlage('-', ...) fait déjà pour Hasard/
    // Résultat, mais explicite ici puisqu'on contourne le jet de dé (CONTEXT.md §2.7).
    ButtonMutationTypePhysical.Visible := RadioButtonMutationTypeChoix.Checked;
    ButtonMutationTypePhysical.Enabled := MutationAcceptee and (TypeCorruptionResolu = '')
                                           and CorruptionTypeDisponible(MutationCodeRace, CorruptionPhysique);
    ButtonMutationTypeMental.Visible   := RadioButtonMutationTypeChoix.Checked;
    ButtonMutationTypeMental.Enabled   := MutationAcceptee and (TypeCorruptionResolu = '')
                                           and CorruptionTypeDisponible(MutationCodeRace, CorruptionMentale);
  end;

// Même principe pour le tirage Entrée précise - tout le groupe reste verrouillé tant que le
// Type n'est pas connu (TypeCorruptionResolu = ''), condition nécessaire à CorruptionTableResultat
// et à RemplitTabMutationChoix.
procedure TWinMutations.UpdateSheetMutationEntree();
  begin
    GroupBoxMutationEntree.Enabled := (TypeCorruptionResolu <> '');

    ButtonEntreeHasard.Visible := RadioButtonMutationEntreeHasard.Checked;
    ButtonEntreeHasard.Enabled := (TypeCorruptionResolu <> '') and (EntreeResolue.Code = '');

    EditMutationEntreeResultat.Visible  := RadioButtonMutationEntreeResultat.Checked;
    EditMutationEntreeResultat.Enabled  := (TypeCorruptionResolu <> '') and (EntreeResolue.Code = '');
    ButtonMutationEntreeValider.Visible := RadioButtonMutationEntreeResultat.Checked;
    ButtonMutationEntreeValider.Enabled := (TypeCorruptionResolu <> '') and (EntreeResolue.Code = '');

    TabMutationChoix.Visible := RadioButtonMutationEntreeChoix.Checked;
    if RadioButtonMutationEntreeChoix.Checked and (TypeCorruptionResolu <> '') then
      RemplitTabMutationChoix();
  end;

// Résolution du tirage Type à partir d'un jet (Hasard ou Résultat, même fonction pour les
// deux, comme TabRaceResultat dans wincreation.pas).
procedure TWinMutations.AfficheTypeResolu(Jet: Integer);
  begin
    TypeCorruptionResolu   := CorruptionTypeResultat(MutationCodeRace, Jet);
    LabelTypeResultat.Text := GetTexteLibelle(TypeCorruptionResolu);
    UpdateSheetMutationType();
    UpdateSheetMutationEntree();
  end;

procedure TWinMutations.ButtonTypeHasardClick(Sender: TObject);
  begin
    AfficheTypeResolu(Random(100) + 1);
  end;

procedure TWinMutations.ButtonMutationTypeValiderClick(Sender: TObject);
  begin
    if (EditMutationTypeResultat.Value = 0) then
      ShowMessage(GetTexteLibelle('MESS_019'))
    else
      AfficheTypeResolu(EditMutationTypeResultat.Value);
  end;

procedure TWinMutations.ButtonMutationTypePhysicalClick(Sender: TObject);
  begin
    TypeCorruptionResolu   := CorruptionPhysique;
    LabelTypeResultat.Text := GetTexteLibelle(TypeCorruptionResolu);
    UpdateSheetMutationType();
    UpdateSheetMutationEntree();
  end;

procedure TWinMutations.ButtonMutationTypeMentalClick(Sender: TObject);
  begin
    TypeCorruptionResolu   := CorruptionMentale;
    LabelTypeResultat.Text := GetTexteLibelle(TypeCorruptionResolu);
    UpdateSheetMutationType();
    UpdateSheetMutationEntree();
  end;

// Changer de mode (Hasard/Résultat/Choix) avant que Type ne soit résolu repart de zéro - et
// invalide l'Entrée déjà résolue le cas échéant, puisqu'elle dépend du Type (CONTEXT.md §2.7).
procedure TWinMutations.RadioButtonMutationTypeClick(Sender: TObject);
  begin
    TypeCorruptionResolu   := '';
    LabelTypeResultat.Text := '';

    EntreeResolue.Code           := '';
    EntreeResolue.Livre          := '';
    EntreeResolue.TypeCorruption := '';
    EntreeResolue.Libelle        := '';
    EntreeResolue.Effet          := '';
    LabelEntreeLibelle.Text      := '';
    MemoEntreeEffet.Text         := '';
    Valider.Enabled              := False;

    UpdateSheetMutationType();
    UpdateSheetMutationEntree();
  end;

procedure TWinMutations.RadioButtonMutationEntreeClick(Sender: TObject);
  begin
    EntreeResolue.Code           := '';
    EntreeResolue.Livre          := '';
    EntreeResolue.TypeCorruption := '';
    EntreeResolue.Libelle        := '';
    EntreeResolue.Effet          := '';
    LabelEntreeLibelle.Text      := '';
    MemoEntreeEffet.Text         := '';
    Valider.Enabled              := False;

    UpdateSheetMutationEntree();
  end;

// Résolution du tirage Entrée à partir d'une entrée déjà déterminée (Hasard ou Résultat via
// CorruptionTableResultat) - PAS appelée depuis le double-clic de TabMutationChoix, qui est un
// choix volontaire (voir TabMutationChoixDblClick). Redirige vers le mode Choix si le tirage
// tombe sur "GM's Choice" (CorruptionChoixMJ) : ce n'est pas une mutation en soi, le MJ doit
// encore désigner l'entrée réelle (CONTEXT.md §2.7, discuté avec Nono le 17/08/2026).
procedure TWinMutations.AfficheEntreeResolue(Entree: StructureCorruptionTable);
  begin
    if CompareRechercheValeur(Entree.Code, CorruptionChoixMJ) then
      begin
        ShowMessage(GetTexteLibelle('MESS_054'));
        RadioButtonMutationEntreeChoix.Checked := True;
        UpdateSheetMutationEntree();
      end
    else
      begin
        EntreeResolue           := Entree;
        LabelEntreeLibelle.Text := EntreeResolue.Libelle;
        MemoEntreeEffet.Text    := EntreeResolue.Effet;
        Valider.Enabled         := True;
        UpdateSheetMutationEntree();
      end;
  end;

procedure TWinMutations.ButtonEntreeHasardClick(Sender: TObject);
  begin
    AfficheEntreeResolue(CorruptionTableResultat(TypeCorruptionResolu, Random(100) + 1));
  end;

procedure TWinMutations.ButtonMutationEntreeValiderClick(Sender: TObject);
  begin
    if (EditMutationEntreeResultat.Value = 0) then
      ShowMessage(GetTexteLibelle('MESS_019'))
    else
      AfficheEntreeResolue(CorruptionTableResultat(TypeCorruptionResolu, EditMutationEntreeResultat.Value));
  end;

// Liste de la table déjà résolue (Physical ou Mental) pour le mode Choix - colonne 0 réservée
// (convention du projet), colonne 1 = Code (cachée, ColWidths[1]=0 posé au FormCreate),
// colonne 2 = Libellé (visible).
procedure TWinMutations.RemplitTabMutationChoix();
  var
    PCorruptionTable: StructureCorruptionTable;
    IndLig:           Integer;
  begin
    TabMutationChoix.RowCount := 1;
    IndLig := 0;
    for PCorruptionTable in ListCorruptionTable do
      if PCorruptionTable.TypeCorruption = TypeCorruptionResolu then
        begin
          IndLig := IndLig + 1;
          TabMutationChoix.RowCount            := IndLig + 1;
          TabMutationChoix.Cells[1, IndLig]     := PCorruptionTable.Code;
          TabMutationChoix.Cells[2, IndLig]     := PCorruptionTable.Libelle;
        end;
  end;

// Choix direct volontaire dans la grille - pas de redirection "GM's Choice" ici, même si
// l'entrée choisie est justement celle-là : l'utilisateur vient de la sélectionner lui-même
// en connaissance de cause (CONTEXT.md §2.7).
procedure TWinMutations.TabMutationChoixDblClick(Sender: TObject);
  var
    Lig:    Integer;
    Code:   String;
    Entree: StructureCorruptionTable;
  begin
    Lig := TabMutationChoix.Row;
    if (Lig < 1) then Exit;
    Code := TabMutationChoix.Cells[1, Lig];
    if (Code = '') then Exit;

    Entree := ChercheCorruptionTable(Code);
    if (Entree.Code = '') then Exit;

    EntreeResolue           := Entree;
    LabelEntreeLibelle.Text := EntreeResolue.Libelle;
    MemoEntreeEffet.Text    := EntreeResolue.Effet;
    Valider.Enabled         := True;
    UpdateSheetMutationEntree();
  end;

procedure TWinMutations.ValiderClick(Sender: TObject);
  begin
    MutationChoix           := 'MUTATION';
    MutationCode            := EntreeResolue.Code;
    MutationLibelle         := EntreeResolue.Libelle;
    MutationEffet           := EntreeResolue.Effet;
    Close;
  end;

procedure TWinMutations.ButtonMutationAnnulerClick(Sender: TObject);
  begin
    MutationChoix := '';
    Close;
  end;

end.
