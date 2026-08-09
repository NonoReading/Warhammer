program WarhammerHelp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pack_powerpdf,
  lazcontrols, WarhammerSource, WinLanceDe;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMenu, Menu);
  Application.CreateForm(TWinLanceDes, Form1);
  Application.Run;
end.

