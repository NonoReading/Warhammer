unit WarhammerPas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFormBack }

  TFormBack = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TFormBack;

implementation

{$R *.lfm}

{ TFormBack }

procedure TFormBack.Image1Click(Sender: TObject);
begin

end;

procedure TFormBack.FormCreate(Sender: TObject);
begin

end;

end.

