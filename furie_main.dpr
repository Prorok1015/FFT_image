program furie_main;

uses
  Forms,
  main in 'main.pas' {Form1},
  SimpleFFT in 'SimpleFFT.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
