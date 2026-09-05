unit WinLanceDe;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin, Dialogs, BCButton,
  GlobalFonts, ChargeTalent, ChargeConstantes, ChargeTexte,
  ChargeTalentCreation, Graphics;

type

  { TWinLanceDes }

  TWinLanceDes = class(TForm)
    ButtonAnnuler: TBCButton;
    ButtonLancer: TBCButton;
    ButtonValider: TBCButton;
    LabelInfo:     TLabel;
    SpinEditJet:   TSpinEdit;
    procedure FormCreate({%H-}Sender: TObject);
    procedure ButtonLancerClick({%H-}Sender: TObject);
    procedure ButtonValiderClick({%H-}Sender: TObject);
    procedure ButtonAnnulerClick({%H-}Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
  public
  end;

var
  WinLanceDes: TWinLanceDes;

implementation

{$R *.lfm}

procedure TWinLanceDes.FormCreate(Sender: TObject);
  begin
    MiseEnFormeDesChamp(self);
    SelectWinJet       := 0;
    SelectWinJetTalent := '';
    SpinEditJet.MinValue := 1;
    SpinEditJet.MaxValue := 100;
    SpinEditJet.MinValue := 0;
    SpinEditJet.Value    := ChoixWinJetValeur;
    LabelInfo.Caption    := GetTexteLibelle('RULES-LAB_177');
    MiseEnFormeDesChamp(self);
  end;

procedure TWinLanceDes.ButtonLancerClick(Sender: TObject);
  begin
    SpinEditJet.Value := Random(100) + 1;
  end;

procedure TWinLanceDes.ButtonValiderClick(Sender: TObject);
  var
    CodeTire: String;
    PTalent:  StructureTalent;
  begin
    if SpinEditJet.Value = 0 then
      begin
        ShowMessage(GetTexteLibelle('MESS_019'));
        Exit;
      end;

    CodeTire := TalentAleatoire(SpinEditJet.Value, ChoixWinJetRace);
    if CodeTire = '' then
      begin
        ShowMessage(GetTexteLibelle('MESS_059'));
        Exit;
      end;

    if TalentDejaPossede(CodeTire, ChoixWinJetDeja) then
      begin
        PTalent := ChercheTalent(CodeTire);
        ShowMessage(Format(GetTexteLibelle('MESS_021'), [PTalent.Libelle]));
        Exit;                                      // la fenêtre reste ouverte
      end;

    SelectWinJet       := SpinEditJet.Value;
    SelectWinJetTalent := CodeTire;
    Close;
  end;

procedure TWinLanceDes.ButtonAnnulerClick(Sender: TObject);
  begin
    SelectWinJet       := 0;
    SelectWinJetTalent := '';
    Close;
  end;

procedure TWinLanceDes.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color   := ClWhite;
  Canvas.Pen.Width   := 3;
  Canvas.Brush.Style := bsClear;
  Canvas.Rectangle(2, 2, ClientWidth - 2, ClientHeight - 2);
end;

end.
