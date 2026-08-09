unit WinLanceDe;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin, Dialogs, GlobalFonts,
  ChargeTalent, ChargeConstantes, ChargeTexte, ChargeTalentCreation;

type

  { TWinLanceDes }

  TWinLanceDes = class(TForm)
    LabelInfo:     TLabel;
    SpinEditJet:   TSpinEdit;
    ButtonLancer:  TButton;
    ButtonValider: TButton;
    ButtonAnnuler: TButton;
    procedure FormCreate({%H-}Sender: TObject);
    procedure ButtonLancerClick({%H-}Sender: TObject);
    procedure ButtonValiderClick({%H-}Sender: TObject);
    procedure ButtonAnnulerClick({%H-}Sender: TObject);
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
    LabelInfo.Caption    := GetTexteLibelle('LAB_xxx');
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
        ShowMessage(GetTexteLibelle('MESS_xxx'));   // saisissez un résultat
        Exit;
      end;

    CodeTire := TalentAleatoire(SpinEditJet.Value, ChoixWinJetRace);
    if CodeTire = '' then
      begin
        ShowMessage(GetTexteLibelle('MESS_xxx'));   // aucun talent pour ce jet
        Exit;
      end;

    if ChoixWinJetDeja = nil then
          ShowMessage('Deja = nil')
        else
          ShowMessage('Deja contient ' + IntToStr(ChoixWinJetDeja.Count) + ' : ' + ChoixWinJetDeja.Text);

    if TalentDejaPossede(CodeTire, ChoixWinJetDeja) then
      begin
        PTalent := ChercheTalent(CodeTire);
        // "Vous possédez déjà <talent>, relancez"
        ShowMessage(Format(GetTexteLibelle('MESS_xxx'), [PTalent.Libelle]));
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

end.
