unit WinAnimal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Grids, StdCtrls,
  ChargeTrapping, ChargeTexte, GlobalFonts;

// Fiche d'un animal, d'une monture ou d'un bateau (profil M a W, ou Crew a W pour un
// bateau, traits, capacite, prix, disponibilite). Formulaire construit en code : pas de .lfm.
// Charge : encombrement deja confie a cet animal (-1 = inconnu, rien d'affiche).
procedure AfficheFicheAnimal(PTrapping: StructureTrapping; Charge: Integer = -1);

implementation

const
  ColonnesProfil: array[0..11] of String =
    ('M', 'WS', 'BS', 'S', 'T', 'I', 'Ag', 'Dex', 'Int', 'WP', 'Fel', 'W');
  ColonnesBateau: array[0..6] of String =
    ('Crew', 'M (Sail)', 'M (Oar)', 'Man', 'Size', 'T', 'W');

function NouvelleEtiquette(Fiche: TForm; Texte: String): TLabel;
begin
  Result            := TLabel.Create(Fiche);
  Result.Parent     := Fiche;
  Result.Left       := 20;
  Result.Width      := Fiche.ClientWidth - 40;
  Result.WordWrap   := True;
  Result.Anchors    := [akTop, akLeft, akRight];
  Result.Caption    := Texte;
end;

procedure AfficheFicheAnimal(PTrapping: StructureTrapping; Charge: Integer);
var
  Fiche:   TForm;
  Grille:  TStringGrid;
  Titre:   TLabel;
  Traits:  TLabel;
  Infos:   TLabel;
  Valeurs: TStringArray;
  NbCol:   Integer;
  Ind:     Integer;
  Haut:    Integer;
  Texte:   String;
begin
  Fiche := TForm.CreateNew(Application);
  try
    Fiche.Caption     := PTrapping.Libelle;
    Fiche.Color       := clBlack;
    Fiche.Position    := poOwnerFormCenter;
    Fiche.ClientWidth := 780;

    Titre  := NouvelleEtiquette(Fiche, PTrapping.Libelle);
    Grille := nil;
    Traits := nil;
    Infos  := nil;

    if (PTrapping.ProfilAnimal <> '') or (PTrapping.ProfilBateau <> '') then
      begin
        if PTrapping.ProfilAnimal <> '' then
          begin
            Valeurs := PTrapping.ProfilAnimal.Split([' ']);
            NbCol   := 12;
          end
        else
          begin
            Valeurs := PTrapping.ProfilBateau.Split([';']);
            NbCol   := 7;
          end;
        Grille  := TStringGrid.Create(Fiche);
        Grille.Parent      := Fiche;
        Grille.Left        := 20;
        Grille.Width       := Fiche.ClientWidth - 40;
        Grille.Anchors     := [akTop, akLeft, akRight];
        Grille.ColCount    := NbCol;
        Grille.RowCount    := 2;
        Grille.FixedCols   := 0;
        Grille.FixedRows   := 1;
        Grille.ScrollBars  := ssNone;
        Grille.TabStop     := False;
        Grille.Options     := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
        Grille.DefaultColWidth := (Grille.Width - 4) div NbCol;
        for Ind := 0 to NbCol - 1 do
          begin
            if NbCol = 12 then
              Grille.Cells[Ind, 0] := ColonnesProfil[Ind]
            else
              Grille.Cells[Ind, 0] := ColonnesBateau[Ind];
            if Ind <= High(Valeurs) then
              Grille.Cells[Ind, 1] := Valeurs[Ind];
          end;
      end;

    if PTrapping.TraitsAnimal <> '' then
      Traits := NouvelleEtiquette(Fiche, GetTexteLibelle('RULES-LAB_251') + ' : ' + PTrapping.TraitsAnimal);

    Texte := '';
    if PTrapping.Prix <> '' then
      Texte := GetTexteLibelle('RULES-LAB_054') + ' : ' + TraduirePrix(PTrapping.Prix) + '     ';
    if PTrapping.Capacite <> 0 then
      Texte := Texte + GetTexteLibelle('RULES-LAB_185') + ' : ' + IntToStr(PTrapping.Capacite) + '     ';
    if Charge >= 0 then
      Texte := Texte + GetTexteLibelle('RULES-LAB_257') + ' : ' + IntToStr(Charge) + '     ';
    if PTrapping.Disponibilite <> '' then
      Texte := Texte + GetTexteLibelle('RULES-LAB_056') + ' : ' + ReplaceTexteLibelle(PTrapping.Disponibilite);
    if Texte <> '' then
      Infos := NouvelleEtiquette(Fiche, Texte);

    // police et couleurs du projet (avant la mise en page : les hauteurs en dependent)
    MiseEnFormeDesChamp(Fiche);
    Titre.Font.Size := Titre.Font.Size + 4;

    Haut := 15;
    Titre.Top := Haut;
    Haut := Haut + Titre.Height + 15;
    if Grille <> nil then
      begin
        Grille.DefaultRowHeight := Grille.Canvas.TextHeight('Wg') + 12;
        Grille.Height := 2 * Grille.DefaultRowHeight + 6;
        Grille.Top    := Haut;
        Haut := Haut + Grille.Height + 15;
      end;
    if Traits <> nil then
      begin
        Traits.Top := Haut;
        Haut := Haut + Traits.Height + 15;
      end;
    if Infos <> nil then
      begin
        Infos.Top := Haut;
        Haut := Haut + Infos.Height + 15;
      end;

    Fiche.ClientHeight := Haut;
    Fiche.ShowModal;
  finally
    Fiche.Free;
  end;
end;

end.
