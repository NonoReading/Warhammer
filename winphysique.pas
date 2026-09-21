unit WinPhysique;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin, Dialogs, BCButton,
  GlobalFonts, ChargeConstantes, ChargeRacePhysique, ChargeTexte, Graphics;

type

  { TWinPhysique }

  TWinPhysique = class(TForm)
    ButtonAnnuler:    TBCButton;
    ButtonTirer:      TBCButton;
    ButtonValider:    TBCButton;
    EditCheveux:      TEdit;
    EditYeux:         TEdit;
    LabelAge:         TLabel;
    LabelCheveux:     TLabel;
    LabelTaille:      TLabel;
    ComboBoxUnite:    TComboBox;
    LabelYeux:        TLabel;
    SpinEditAge:      TSpinEdit;
    SpinEditTaille:   TSpinEdit;
    procedure FormCreate({%H-}Sender: TObject);
    procedure ButtonTirerClick({%H-}Sender: TObject);
    procedure ButtonValiderClick({%H-}Sender: TObject);
    procedure ButtonAnnulerClick({%H-}Sender: TObject);
    procedure ComboBoxUniteChange({%H-}Sender: TObject);
    procedure FormPaint({%H-}Sender: TObject);
  private
    FUnite: String;   // unite courante de SpinEditTaille : CM ou INCH
    procedure Tirer;
  public
  end;

var
  // Entree : ethnie du personnage et valeurs actuelles (0 / vide = pas encore definies,
  // la fenetre tire alors d'elle-meme). Sortie : valeurs validees, PhysiqueValide vrai
  // seulement si le joueur a clique sur Valider. Taille dans PhysiqueUnite (CM ou INCH).
  PhysiqueCodeRace: String;
  PhysiqueAge:      Integer;
  PhysiqueTaille:   Integer;
  PhysiqueUnite:    String;   // CM ou INCH ; taille a 0 : unite par defaut de l'interface (INI)
  PhysiqueYeux:     String;
  PhysiqueCheveux:  String;
  PhysiqueValide:   Boolean;

implementation

{$R *.lfm}

procedure TWinPhysique.FormCreate(Sender: TObject);
  begin
    MiseEnFormeDesChamp(self);
    Caption                := GetTexteLibelle('RULES-LAB_266');
    LabelAge.Caption       := GetTexteLibelle('RULES-PDF_MAIN4_AGE');
    LabelTaille.Caption    := GetTexteLibelle('RULES-LAB_264');
    LabelYeux.Caption      := GetTexteLibelle('RULES-PDF_MAIN4_EYES');
    LabelCheveux.Caption   := GetTexteLibelle('RULES-PDF_MAIN4_HAIR');
    ButtonTirer.Caption    := GetTexteLibelle('RULES-LAB_263');
    ButtonValider.Caption  := GetTexteLibelle('RULES-LAB_086');
    ButtonAnnuler.Caption  := GetTexteLibelle('RULES-LAB_166');
    PhysiqueValide := False;
    SpinEditAge.Value    := PhysiqueAge;
    // Unite de la fiche si une taille existe deja, sinon celle de l'interface (INI)
    if PhysiqueTaille = 0 then
      FUnite := UniteTaille
    else if PhysiqueUnite = '' then
      FUnite := ConstUniteInch
    else
      FUnite := PhysiqueUnite;
    if FUnite = ConstUniteCm then
      ComboBoxUnite.ItemIndex := 0
    else
      ComboBoxUnite.ItemIndex := 1;
    SpinEditTaille.Value := PhysiqueTaille;
    EditYeux.Text        := PhysiqueYeux;
    EditCheveux.Text     := PhysiqueCheveux;
    // Premiere ouverture pour ce personnage : on propose directement un tirage
    if (PhysiqueAge = 0) and (PhysiqueTaille = 0) then
      Tirer;
    MiseEnFormeDesChamp(self);
  end;

procedure TWinPhysique.Tirer;
  var
    Age, Taille: Integer;
    Yeux, Cheveux: String;
  begin
    if not TireDetailsPhysiques(PhysiqueCodeRace, Age, Taille, Yeux, Cheveux) then
      begin
        ShowMessage(GetTexteLibelle('RULES-LAB_265'));
        Exit;
      end;
    SpinEditAge.Value    := Age;
    SpinEditTaille.Value := ConvertitTaille(Taille, ConstUniteInch, FUnite);
    EditYeux.Text        := Yeux;
    EditCheveux.Text     := Cheveux;
  end;

procedure TWinPhysique.ButtonTirerClick(Sender: TObject);
  begin
    Tirer;
  end;

procedure TWinPhysique.ComboBoxUniteChange(Sender: TObject);
  var
    Nouvelle: String;
  begin
    if ComboBoxUnite.ItemIndex = 0 then
      Nouvelle := ConstUniteCm
    else
      Nouvelle := ConstUniteInch;
    SpinEditTaille.Value := ConvertitTaille(SpinEditTaille.Value, FUnite, Nouvelle);
    FUnite := Nouvelle;
  end;

procedure TWinPhysique.ButtonValiderClick(Sender: TObject);
  begin
    PhysiqueAge     := SpinEditAge.Value;
    PhysiqueTaille  := SpinEditTaille.Value;
    PhysiqueUnite   := FUnite;
    PhysiqueYeux    := EditYeux.Text;
    PhysiqueCheveux := EditCheveux.Text;
    PhysiqueValide  := True;
    Close;
  end;

procedure TWinPhysique.ButtonAnnulerClick(Sender: TObject);
  begin
    PhysiqueValide := False;
    Close;
  end;

procedure TWinPhysique.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color   := ClWhite;
  Canvas.Pen.Width   := 3;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(2, 2, ClientWidth - 2, ClientHeight - 2);
end;

end.
