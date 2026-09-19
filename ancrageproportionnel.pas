unit AncrageProportionnel;

// Ancrage proportionnel des fenetres de base de donnees : quand la fenetre s'elargit de
// Delta pixels, chaque controle enregistre se deplace de Delta*Deplace et s'elargit de
// Delta*Elargit. Les ancres natives Lazarus ne savent que tout donner ou rien donner a un
// controle ; ici la part est libre (0.5 = la moitie).
//   - tableau de gauche : (0, 0.5)   zone de texte de droite : (0.5, 0.5)
//   - elements du milieu : (0.5, 0)  sans zone de texte : tableau (0, 1), reste (1, 0)
// Les controles enregistres ne doivent PAS porter akRight dans le .lfm (conflit).
//
// La reference est memorisee en unites a 96 PPI et non en pixels : une fenetre dessinee en
// 120 ou 144 PPI, ou deplacee sur un ecran de DPI different, est mise a l'echelle par la LCL
// APRES FormCreate ; une reference en pixels devenait fausse (Delta negatif, controles qui
// se chevauchent a l'ouverture de WinArmure).

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms;

type
  TAncrageItem = record
    Ctrl:    TControl;
    Left0:   Double;   // unites 96 PPI
    Width0:  Double;
    Deplace: Double;
    Elargit: Double;
  end;

  { TAncrageProportionnel }

  TAncrageProportionnel = class
  private
    FForm:   TForm;
    FBase:   Double;   // ClientWidth de reference, unites 96 PPI
    FMinW:   Double;
    FMinH:   Double;
    FItems:  array of TAncrageItem;
    function Echelle: Double;
  public
    constructor Create(AForm: TForm);
    procedure Ajouter(ACtrl: TControl; ADeplace, AElargit: Double);
    procedure Fixer;      // memorise la geometrie actuelle comme reference et comme taille minimale
    procedure Appliquer;  // recalcule Left/Width depuis la reference
  end;

implementation

constructor TAncrageProportionnel.Create(AForm: TForm);
  begin
    inherited Create;
    FForm := AForm;
  end;

// pixels par unite de reference (PPI de la fenetre / 96)
function TAncrageProportionnel.Echelle: Double;
  begin
    Result := FForm.PixelsPerInch / 96;
  end;

procedure TAncrageProportionnel.Ajouter(ACtrl: TControl; ADeplace, AElargit: Double);
  begin
    SetLength(FItems, Length(FItems) + 1);
    with FItems[High(FItems)] do
      begin
        Ctrl    := ACtrl;
        Deplace := ADeplace;
        Elargit := AElargit;
      end;
  end;

procedure TAncrageProportionnel.Fixer;
  var
    i: Integer;
    E: Double;
  begin
    E := Echelle;
    FBase := FForm.ClientWidth / E;
    // taille minimale = taille de reference : en dessous, les controles se chevauchent
    FMinW := FForm.Width / E;
    FMinH := FForm.Height / E;
    for i := 0 to High(FItems) do
      begin
        FItems[i].Left0  := FItems[i].Ctrl.Left / E;
        FItems[i].Width0 := FItems[i].Ctrl.Width / E;
      end;
    Appliquer;
  end;

procedure TAncrageProportionnel.Appliquer;
  var
    i: Integer;
    E, Delta: Double;
  begin
    if FBase = 0 then Exit;
    E := Echelle;
    FForm.Constraints.MinWidth  := Round(FMinW * E);
    FForm.Constraints.MinHeight := Round(FMinH * E);
    Delta := FForm.ClientWidth / E - FBase;   // unites 96 PPI
    for i := 0 to High(FItems) do
      with FItems[i] do
        Ctrl.SetBounds(Round((Left0 + Delta * Deplace) * E), Ctrl.Top,
                       Round((Width0 + Delta * Elargit) * E), Ctrl.Height);
  end;

end.
