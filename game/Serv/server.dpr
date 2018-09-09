program server;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MainF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainF, MainF);
  Application.Run;
end.
