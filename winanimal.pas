unit WinAnimal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Grids, StdCtrls,
  ChargeTrapping, ChargeTexte, GlobalFonts;

// Fiche d'un animal ou d'une monture (profil M a W, traits, capacite, prix,
// disponibilite). Formulaire construit en code : pas de .lfm.
procedure AfficheFicheAnimal(PTrapping: StructureTrapping);

implementation

const
  ColonnesProfil: array[0..11] of String =
    ('M', 'WS', 'BS', 'S', 'T', 'I', 'Ag', 'Dex', 'Int', 'WP', 'Fel', 'W');

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

procedure AfficheFicheAnimal(PTrapping: StructureTrapping);
var
  Fiche:   TForm;
  Grille:  TStringGrid;
  Titre:   TLabel;
  Traits:  TLabel;
  Infos:   TLabel;
  Valeurs: TStringArray;
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

    if PTrapping.ProfilAnimal <> '' then
      begin
        Valeurs := PTrapping.ProfilAnimal.Split([' ']);
        Grille  := TStringGrid.Create(Fiche);
        Grille.Parent      := Fiche;
        Grille.Left        := 20;
        Grille.Width       := Fiche.ClientWidth - 40;
        Grille.Anchors     := [akTop, akLeft, akRight];
        Grille.ColCount    := 12;
        Grille.RowCount    := 2;
        Grille.FixedCols   := 0;
        Grille.FixedRows   := 1;
        Grille.ScrollBars  := ssNone;
        Grille.TabStop     := False;
        Grille.Options     := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
        Grille.DefaultColWidth := (Grille.Width - 4) div 12;
        for Ind := 0 to 11 do
          begin
            Grille.Cells[Ind, 0] := ColonnesProfil[Ind];
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
