program ClassesJava;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  untModel in 'untModel.pas',
  untFuncoes in 'untFuncoes.pas',
  untBaseGeradora in 'untBaseGeradora.pas',
  untRepository in 'untRepository.pas',
  untConverter in 'untConverter.pas',
  untXHTML in 'untXHTML.pas',
  untService in 'untService.pas',
  untCadastroBean in 'untCadastroBean.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amakrits');
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
