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
    LabelTaillePieds: TLabel;
    LabelYeux:        TLabel;
    SpinEditAge:      TSpinEdit;
    SpinEditTaille:   TSpinEdit;
    procedure FormCreate({%H-}Sender: TObject);
    procedure ButtonTirerClick({%H-}Sender: TObject);
    procedure ButtonValiderClick({%H-}Sender: TObject);
    procedure ButtonAnnulerClick({%H-}Sender: TObject);
    procedure SpinEditTailleChange({%H-}Sender: TObject);
    procedure FormPaint({%H-}Sender: TObject);
  private
    procedure Tirer;
  public
  end;

var
  // Entree : ethnie du personnage et valeurs actuelles (0 / vide = pas encore definies,
  // la fenetre tire alors d'elle-meme). Sortie : valeurs validees, PhysiqueValide vrai
  // seulement si le joueur a clique sur Valider. Taille en POUCES, comme la fiche.
  PhysiqueCodeRace: String;
  PhysiqueAge:      Integer;
  PhysiqueTaille:   Integer;
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
    SpinEditTaille.Value := PhysiqueTaille;
    EditYeux.Text        := PhysiqueYeux;
    EditCheveux.Text     := PhysiqueCheveux;
    SpinEditTailleChange(nil);
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
    SpinEditTaille.Value := Taille;
    EditYeux.Text        := Yeux;
    EditCheveux.Text     := Cheveux;
  end;

procedure TWinPhysique.ButtonTirerClick(Sender: TObject);
  begin
    Tirer;
  end;

procedure TWinPhysique.SpinEditTailleChange(Sender: TObject);
  begin
    LabelTaillePieds.Caption := FormateTaille(SpinEditTaille.Value);
  end;

procedure TWinPhysique.ButtonValiderClick(Sender: TObject);
  begin
    PhysiqueAge     := SpinEditAge.Value;
    PhysiqueTaille  := SpinEditTaille.Value;
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
