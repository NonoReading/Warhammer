unit WinAnimal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLIntf, LCLType, Forms, Controls, Graphics, Grids, StdCtrls,
  ChargeTrapping, ChargeTexte, ChargeConstantes, GlobalFonts;

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
  ColonnesVehicule: array[0..3] of String =
    ('Motive Power', 'T', 'W', 'Strike');

function NouvelleEtiquette(Fiche: TForm; Texte: String): TLabel;
begin
  Result            := TLabel.Create(Fiche);
  Result.Parent     := Fiche;
  Result.Left       := 20;
  Result.Width      := Fiche.ClientWidth - 40;
  Result.WordWrap   := True;
  Result.Anchors    := [akTop, akLeft, akRight];
  Result.AutoSize   := True;
  Result.Caption    := Texte;
end;

// Hauteur d'un libelle a retour a la ligne, mesuree avec sa police et sa largeur reelles
// (AutoSize sous-estime la hauteur d'un libelle multi-lignes dans un formulaire construit en code).
procedure AjusteHauteur(Etiquette: TLabel);
var
  Zone: TRect;
begin
  Zone := Rect(0, 0, Etiquette.Width, 0);
  Etiquette.Canvas.Font.Assign(Etiquette.Font);
  DrawText(Etiquette.Canvas.Handle, PChar(Etiquette.Caption), -1, Zone,
    DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX);
  Etiquette.AutoSize := False;
  Etiquette.Height   := Zone.Bottom - Zone.Top + 2;
end;

// Description des traits d'un bateau, une ligne par trait connu (libelle SEAOF-BOATTRAIT_<NOM>, le niveau
// final "2" de "Sturdy 2" est ignore pour la recherche) ; vide si aucun trait n'a de libelle.
function DescriptionTraitsBateau(Traits: String): String;
var
  Trait: String;
  Cle:   String;
  Code:  String;
  Texte: String;
begin
  Result := '';
  for Trait in Traits.Split([',']) do
    begin
      Cle := Trim(Trait);
      while (Cle <> '') and (Cle[Length(Cle)] in ['0'..'9', ' ']) do
        Delete(Cle, Length(Cle), 1);
      Code  := ConstPrefixeTraitBateau + StringReplace(UpperCase(Cle), ' ', '', [rfReplaceAll]);
      Texte := GetTexteLibelle(Code);
      if (Cle <> '') and (Texte <> Code) then
        begin
          if Result <> '' then
            Result := Result + LineEnding;
          Result := Result + Trim(Trait) + ' : ' + Texte;
        end;
    end;
end;

procedure AfficheFicheAnimal(PTrapping: StructureTrapping; Charge: Integer);
var
  Fiche:   TForm;
  Grille:  TStringGrid;
  Titre:   TLabel;
  Traits:  TLabel;
  Descr:   TLabel;
  TexteDescr: String;
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
    Descr  := nil;
    Infos  := nil;

    if (PTrapping.ProfilAnimal <> '') or (PTrapping.ProfilBateau <> '') or (PTrapping.ProfilVehicule <> '') then
      begin
        if PTrapping.ProfilAnimal <> '' then
          begin
            Valeurs := PTrapping.ProfilAnimal.Split([' ']);
            NbCol   := 12;
          end
        else if PTrapping.ProfilBateau <> '' then
          begin
            Valeurs := PTrapping.ProfilBateau.Split([';']);
            NbCol   := 7;
          end
        else
          begin
            Valeurs := PTrapping.ProfilVehicule.Split([';']);
            NbCol   := 4;
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
            else if NbCol = 7 then
              Grille.Cells[Ind, 0] := ColonnesBateau[Ind]
            else
              Grille.Cells[Ind, 0] := ColonnesVehicule[Ind];
            if Ind <= High(Valeurs) then
              Grille.Cells[Ind, 1] := Valeurs[Ind];
          end;
      end;

    if PTrapping.TraitsAnimal <> '' then
      Traits := NouvelleEtiquette(Fiche, GetTexteLibelle('RULES-LAB_251') + ' : ' + PTrapping.TraitsAnimal);

    if (PTrapping.ProfilBateau <> '') and (PTrapping.TraitsAnimal <> '') then
      begin
        TexteDescr := DescriptionTraitsBateau(PTrapping.TraitsAnimal);
        if TexteDescr <> '' then
          Descr := NouvelleEtiquette(Fiche, TexteDescr);
      end;

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
    // les hauteurs se recalculent apres le changement de police (libelles a retour a la ligne)
    AjusteHauteur(Titre);
    if Traits <> nil then AjusteHauteur(Traits);
    if Descr <> nil then AjusteHauteur(Descr);
    if Infos <> nil then AjusteHauteur(Infos);

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
    if Descr <> nil then
      begin
        Descr.Top := Haut;
        Haut := Haut + Descr.Height + 15;
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
