unit untPrincipal;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.DBGrids,
  Datasnap.DBClient,
  Datasnap.Provider,
  FireDAC.Comp.Client,
  FireDAC.Phys.MySQL,
  FireDAC.Comp.UI,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.CheckLst,
  Vcl.ExtCtrls,
  DataModule,
  Vcl.themes,
  System.IniFiles,
  System.Generics.Collections,
  untModel,
  untRepository,
  untConverter,
  untService,
  untCadastroBean,
  untXHTML,
  untBaseGeradora,
  untPesquisa,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.UI.Intf,
  Vcl.ImgList,
  FireDAC.Phys,
  Vcl.ToolWin,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.VCLUI.Wait,
  Vcl.Grids,
  FireDAC.Comp.DataSet, FireDAC.Phys.MySQLDef, Vcl.Buttons, System.ImageList;

type
  TfrmPrincipal = class(TForm)
    ImageList: TImageList;
    pgPrincipal: TPageControl;
    tsPrincipal: TTabSheet;
    tsConfiguracoes: TTabSheet;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    edtPacote: TEdit;
    Panel4: TPanel;
    edtPath: TEdit;
    Panel5: TPanel;
    Label1: TLabel;
    Panel6: TPanel;
    cbSkin: TComboBox;
    Panel7: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    lblPacote: TLabel;
    Panel8: TPanel;
    pnTabFilhas: TPanel;
    lbOrigem: TListBox;
    lbDestino: TListBox;
    gbMetaDados: TGroupBox;
    DBGrid1: TDBGrid;
    Splitter: TSplitter;
    SplitterTabFilhas: TSplitter;
    Panel9: TPanel;
    Memo1: TMemo;
    DataSource1: TDataSource;
    cdsDados: TClientDataSet;
    GroupBox1: TGroupBox;
    edtClasse: TEdit;
    Label3: TLabel;
    Button1: TButton;
    cdsDadosnome: TStringField;
    cdsDadostipo: TStringField;
    cdsDadosassert: TStringField;
    cdsDadosnotNull: TStringField;
    DBGrid2: TDBGrid;
    cdsTraducao: TClientDataSet;
    dsTraducao: TDataSource;
    btnTraducao: TButton;
    cdsTraducaoPortugues: TStringField;
    cdsTraducaoIngles: TStringField;
    cdsTraducaoEspanhol: TStringField;
    cdsTraducaotag: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure cbSkinChange(Sender: TObject);
    procedure chkListTabClick(Sender: TObject);
    procedure edtPacoteExit(Sender: TObject);
    procedure lbDestinoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbDestinoDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sSpeedButton1Click(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnTraducaoClick(Sender: TObject);
  private
    indexAtual: Integer;
    mapTabelasFilhas: TDictionary<String, TList<TTabelasFilhas>>;
    procedure salvarConf;
    procedure FiltrarDados(AIndex: Integer = -1);
    procedure AjustarDadosFK;
    procedure Gerar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  StartingPoint: TPoint;

implementation

{$R *.dfm}

procedure TfrmPrincipal.salvarConf;
var
  IniFile: TMemIniFile;
begin

  if not FileExists(ExtractFilePath(Application.ExeName) +
    'ConfigGeradorHangar31.ini') then
    Exit;
  try
    IniFile := TMemIniFile.Create(ExtractFilePath(Application.ExeName) +
      'ConfigGeradorHangar31.ini');

    IniFile.WriteString('skin', 'nome', cbSkin.Text);
    IniFile.WriteString('confg', 'path', edtPath.Text);
    IniFile.WriteString('confg', 'pacote', edtPacote.Text);

    IniFile.UpdateFile;
  finally
    FreeAndNil(IniFile);
  end;
end;

procedure TfrmPrincipal.sSpeedButton1Click(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
    try
      Title := 'Select Directory';
      Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
      OkButtonLabel := 'Select';
      if Execute then
        edtPath.Text := FileName;
    finally
      Free;
    end;
  salvarConf;
end;

procedure TfrmPrincipal.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btnSalvarClick(Sender: TObject);
begin
  Gerar;
end;

procedure TfrmPrincipal.btnTraducaoClick(Sender: TObject);
var
  slTraducao: TStringList;
  i, index: Integer;
  files: Array[0..2] of String;
begin
  try
    files[0] := 'en.dart';
    files[1] := 'pt.dart';
    files[2] := 'es.dart';
    slTraducao := TStringList.Create;
    cdsTraducao.First;
    i := 0;
    while (i <= 2) do begin

      slTraducao.Clear;
      slTraducao.LoadFromFile(edtPath.Text + '\' + files[i]);


      index := 1 + slTraducao.IndexOf('  ///' + UpperCase(Copy(cdsTraducaoTag.AsString, 0, 1)));

      if(i = 0) then
        slTraducao.Insert(index, '  ' + (QuotedStr(cdsTraducaoTag.AsString) + ':' + QuotedStr(cdsTraducaoIngles.AsString) + ','))
      else if (i = 1) then
        slTraducao.Insert(index, '  ' + QuotedStr(cdsTraducaoTag.AsString) + ':' + QuotedStr(cdsTraducaoPortugues.AsString) + ',')
      else
        slTraducao.Insert(index, '  ' + QuotedStr(cdsTraducaoTag.AsString) + ':' + QuotedStr(cdsTraducaoEspanhol.AsString) + ',');

      slTraducao.SaveToFile(edtPath.Text + '\' + files[i]);
      i := i + 1;

    end;
    showmessage('Tradução terminada');

  finally
    FreeAndNil(slTraducao);
  end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  Gerar;
end;

procedure TfrmPrincipal.cbSkinChange(Sender: TObject);
begin
  try
    TStyleManager.TrySetStyle(cbSkin.Text);
    salvarConf;
  except

  end;
end;

procedure TfrmPrincipal.chkListTabClick(Sender: TObject);
begin
  FiltrarDados;
  AjustarDadosFK;
end;

procedure TfrmPrincipal.AjustarDadosFK;
begin

end;

procedure TfrmPrincipal.edtPacoteExit(Sender: TObject);
begin
  salvarConf;
end;

procedure TfrmPrincipal.FiltrarDados(AIndex: Integer);
begin
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(mapTabelasFilhas);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  IniFile: TMemIniFile;
  skin: String;

begin
  if not FileExists(ExtractFilePath(Application.ExeName) +
    'ConfigGeradorHangar31.ini') then
    Exit;

  IniFile := TMemIniFile.Create(ExtractFilePath(Application.ExeName) +
    'ConfigGeradorHangar31.ini');

  edtPath.Text := LowerCase(IniFile.ReadString('confg', 'path', ''));
  edtPacote.Text := LowerCase(IniFile.ReadString('confg', 'pacote', ''));

  try
    skin := LowerCase(IniFile.ReadString('skin', 'nome', ''));
    TStyleManager.TrySetStyle(skin);
    cbSkin.ItemIndex := cbSkin.Items.IndexOf(skin);
  except
    TStyleManager.TrySetStyle('Amakrits');
  end;


  pgPrincipal.ActivePage := tsPrincipal;
end;

procedure TfrmPrincipal.lbDestinoDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  Item: String;
  PosDrop: Integer;
begin
  if Source <> Sender then
  begin
    with (Source as TListBox) do
    begin
      Item := Items[ItemIndex];
      Items.Delete(ItemIndex);
    end;
    (Sender as TListBox).Items.Add(Item);
  end
  else
    with (Sender as TListBox) do
    begin
      PosDrop := ItemAtPos(Point(X, Y), True);
      if PosDrop < 0 then
        PosDrop := Items.Count - 1;
      Items.Move(ItemIndex, PosDrop);
      ItemIndex := PosDrop;
    end;

end;

procedure TfrmPrincipal.lbDestinoDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TListBox);
end;

procedure TfrmPrincipal.Gerar;
var
  killer: TCadastroBean;
  procedure GerarArquivo(AClass: IGeradora);
  begin
    AClass.Tabela := edtClasse.Text;
    AClass.Pacote := edtPacote.Text;
    AClass.ClientDataSet := cdsDados;
    AClass.Path := edtPath.Text;
    AClass.GerarArquivo;
  end;

begin

  killer := TCadastroBean.Create(nil);
  GerarArquivo(TCadastroBean.Create(killer));
  GerarArquivo(TRepository.Create(killer));
  GerarArquivo(TService.Create(killer));

  MessageDlg('Processo finalizado com sucesso!', mtInformation, [mbOK], 0);
  FreeAndNil(killer);
end;

end.
