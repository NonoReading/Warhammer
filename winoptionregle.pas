unit WinOptionRegle;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Grids, StdCtrls, ChargeConstantes,
  ChargeOptionRegle, ChargeTexte, UnitCalcul;

type

  { TWinOptionRegle }

  // Fenetre a part listant les regles optionnelles de tous les livres charges
  // (livre / option / explication), avec case a cocher pour activer/desactiver
  // via le toggle .INI - A FAIRE.txt "TOGGLE .INI PAR LIVRE", CONTEXT.md 2.89,
  // 22/09/2026. Fenetre entierement construite en code (pas de .lfm) : plus sur
  // a ecrire a la main qu'un fichier de resource.
  TWinOptionRegle = class(TForm)
  private
    TabOption:        TStringGrid;
    MemoExplication:  TMemo;
    ButtonFermer:     TButton;
    RowIndex:         array of Integer; // ligne grille -> indice dans ListOptionRegle
    // Indices REELS des colonnes, renvoyes par GridAjouteColonne (jamais 0 : la
    // colonne fixe 0 d'une grille demarree a ColCount=1 n'est pas selectionnable au
    // clic - meme convention que TabLivre/ColLivreSel, warhammersource.pas. Ecrire
    // ou tester Col=0 rendait la case a cocher inutilisable (trouve par Nono en
    // essayant de cocher/decocher, 22/09/2026).
    ColActif:         Integer;
    ColLivre:         Integer;
    ColOption:        Integer;
    procedure TabOptionClick(Sender: TObject);
    procedure TabOptionSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure ButtonFermerClick(Sender: TObject);
    procedure WinCharger();
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  WinOptionRegles: TWinOptionRegle;

implementation

{ TWinOptionRegle }

constructor TWinOptionRegle.Create(TheOwner: TComponent);
  begin
    inherited CreateNew(TheOwner);
    Self.Caption      := GetTexteLibelle('RULES-LAB_277');
    Self.Width         := 700;
    Self.Height        := 450;
    Self.Position      := poOwnerFormCenter;

    TabOption           := TStringGrid.Create(Self);
    TabOption.Parent     := Self;
    TabOption.Left       := 8;
    TabOption.Top        := 8;
    TabOption.Width      := Self.Width - 24;
    TabOption.Height     := 220;
    TabOption.Anchors    := [akLeft, akTop, akRight, akBottom];
    TabOption.Options    := TabOption.Options + [goRowSelect] - [goRangeSelect];
    TabOption.FixedRows  := 1;
    TabOption.OnClick    := @TabOptionClick;
    TabOption.OnSelectCell := @TabOptionSelectCell;

    MemoExplication            := TMemo.Create(Self);
    MemoExplication.Parent     := Self;
    MemoExplication.Left       := 8;
    MemoExplication.Top        := TabOption.Top + TabOption.Height + 8;
    MemoExplication.Width      := Self.Width - 24;
    MemoExplication.Height     := 140;
    MemoExplication.Anchors    := [akLeft, akRight, akBottom];
    MemoExplication.ReadOnly   := true;
    MemoExplication.ScrollBars := ssVertical;

    ButtonFermer            := TButton.Create(Self);
    ButtonFermer.Parent     := Self;
    ButtonFermer.Caption    := GetTexteLibelle('RULES-LAB_280');
    ButtonFermer.Width      := 100;
    ButtonFermer.Left       := Self.Width - ButtonFermer.Width - 16;
    ButtonFermer.Top        := MemoExplication.Top + MemoExplication.Height + 8;
    ButtonFermer.Anchors    := [akRight, akBottom];
    ButtonFermer.OnClick    := @ButtonFermerClick;

    // Appel direct et unique : AfterConstruction (TCustomForm) declenche aussi
    // DoCreate/OnCreate juste apres la fin de ce constructeur - en les cumulant tous
    // les deux, WinCharger tournait DEUX fois sur la meme grille, et le 2e passage
    // replantait sur TabOption.ColCount := 1 (Columns deja active par le 1er appel,
    // EGridException "Use Columns property to add/remove columns", grids.pas:3193,
    // trouve par Nono en ouvrant la fenetre, 22/09/2026).
    WinCharger();
  end;

procedure TWinOptionRegle.WinCharger();
  var
    POptionRegle: StructureOptionRegle;
    IndListe:     Integer;
    Row:          Integer;
  begin
    TabOption.RowCount := 1;
    // Fenetre creee une seule fois par ouverture (pas de rechargement a chaud comme
    // WinArmor/WinFiltre) : pas besoin de garder les colonnes d'un appel precedent.
    // ColCount par defaut d'un TStringGrid tout neuf est 5, jamais < 2 - le garde
    // "if ColCount < 2" ne se declenchait donc jamais, laissant les colonnes par
    // defaut a cote des 3 colonnes ajoutees (bug visuel trouve par Nono, 22/09/2026).
    TabOption.ColCount := 1;
    ColActif  := GridAjouteColonne(TabOption, GetTexteLibelle('RULES-LAB_278'), 20, taCenter);
    ColLivre  := GridAjouteColonne(TabOption, GetTexteLibelle('RULES-LAB_128'), 200);
    ColOption := GridAjouteColonne(TabOption, GetTexteLibelle('RULES-LAB_002'), 380);
    TabOption.ColWidths[0] := 8;

    SetLength(RowIndex, ListOptionRegle.Count + 1);
    Row := 0;
    for IndListe := 0 to ListOptionRegle.Count - 1 do
      begin
        POptionRegle := ListOptionRegle[IndListe];
        Inc(Row);
        TabOption.RowCount := Row + 1;
        RowIndex[Row]       := IndListe;
        if OptionDesactivee(POptionRegle.Livre, POptionRegle.CodeOption) then
          TabOption.Cells[ColActif, Row] := ''
        else
          TabOption.Cells[ColActif, Row] := ConstSelectionne;
        TabOption.Cells[ColLivre, Row]  := GetTexteLibelle(POptionRegle.Livre, '', '', true);
        TabOption.Cells[ColOption, Row] := POptionRegle.Libelle;
      end;
  end;

procedure TWinOptionRegle.TabOptionClick(Sender: TObject);
  var
    POptionRegle: StructureOptionRegle;
    Liste:        TStringList;
  begin
    if (TabOption.Row < 1) or (TabOption.Row > High(RowIndex)) then exit;
    if TabOption.Col <> ColActif then exit;

    POptionRegle := ListOptionRegle[RowIndex[TabOption.Row]];
    Liste         := TStringList.Create;
    try
      Liste.CommaText := ListeOptionDesactiveeParLivre.Values[POptionRegle.Livre];
      if TabOption.Cells[ColActif, TabOption.Row] = ConstSelectionne then
        begin
          // Actif -> desactive : ajoute le code a la liste du livre
          TabOption.Cells[ColActif, TabOption.Row] := '';
          if Liste.IndexOf(POptionRegle.CodeOption) < 0 then
            Liste.Add(POptionRegle.CodeOption);
        end
      else
        begin
          // Inactif -> reactive : retire le code de la liste du livre
          TabOption.Cells[ColActif, TabOption.Row] := ConstSelectionne;
          Liste.Delete(Liste.IndexOf(POptionRegle.CodeOption));
        end;
      ListeOptionDesactiveeParLivre.Values[POptionRegle.Livre] := Liste.CommaText;
    finally
      Liste.Free;
    end;

    // Persiste tout de suite (SauveIniOptions ne touche que les lignes OPTION du
    // .INI, chargeconstantes.pas - pas de dependance circulaire vers
    // warhammersource.pas/TMenu). Pris en compte au prochain lancement uniquement
    // (decision de Nono, 22/09/2026).
    SauveIniOptions();
  end;

procedure TWinOptionRegle.TabOptionSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
  begin
    CanSelect := true;
    if (aRow < 1) or (aRow > High(RowIndex)) then exit;
    MemoExplication.Text := ListOptionRegle[RowIndex[aRow]].Explication;
  end;

procedure TWinOptionRegle.ButtonFermerClick(Sender: TObject);
  begin
    Close;
  end;

end.
