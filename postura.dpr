program postura;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  uAviso in 'uAviso.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Postura Certa';
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
