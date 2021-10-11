program AnimTest;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  AnimThread in 'AnimThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Animation ScanLine';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
