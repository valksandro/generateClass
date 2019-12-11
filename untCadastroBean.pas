unit untCadastroBean;

interface

uses
  System.SysUtils,
  System.Classes,
  Datasnap.DBClient,
  untFuncoes,
  untBaseGeradora,
  System.Generics.collections,
  Math;

type
  TCadastroBean = class(TComponent, IGeradora)
  private
    FPacote: String;
    FTabela: String;
    FTabelaClasse: String;
    FClientDataSet: TClientDataSet;
    FSlGeradora: TStringList;
    FPath: String;
    FTabelasPais: TList<String>;
    FTabelasFilhas: TList<TTabelasFilhas>;
    FTop: Integer;
    function getTop: Integer;
  public

    function getClientDataSet: TClientDataSet;
    function getPacote: String;
    function getPath: String;
    function getSlGeradora: TStringList;
    function getTabela: String;
    function getTabelaClasse: String;
    function getTabelasFilhas: TList<TTabelasFilhas>;
    function getTabelasPais: TList<String>;

    procedure setTabelasFilhas(const Value: TList<TTabelasFilhas>);
    procedure setTabelasPais(const Value: TList<String>);
    procedure setClientDataSet(const Value: TClientDataSet);
    procedure setPacote(const Value: String);
    procedure setPath(const Value: String);
    procedure setSlGeradora(const Value: TStringList);
    procedure setTabela(const Value: String);
    procedure setTabelaClasse(const Value: String);
    procedure gerarArquivo; dynamic;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Pacote: String read getPacote write setPacote;
    property Tabela: String read getTabela write setTabela;
    property TabelaClasse: String read getTabelaClasse write setTabelaClasse;
    property ClientDataSet: TClientDataSet read getClientDataSet
      write setClientDataSet;
    property SlGeradora: TStringList read getSlGeradora write setSlGeradora;
    property Path: String read getPath write setPath;
    property Top: Integer read getTop write FTop;

    { class var
      class procedure RaiseOuterException(E: Exception); static;
      class procedure ThrowOuterException(E: Exception); static; }

  end;

implementation

{ TConverter }

constructor TCadastroBean.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSlGeradora := TStringList.Create;
end;

destructor TCadastroBean.Destroy;
begin
  FreeAndNil(FSlGeradora);
  if FTabelasPais <> nil then
    FreeAndNil(FTabelasPais);
  inherited;
end;

procedure TCadastroBean.gerarArquivo;
var
  i, contObj: Integer;
  slItemUnit: TStringList;
  item, prefixo, sufixo: String;
  focus: String;
begin
  inherited;
  contObj := Math.RandomRange(1, 99);
  slItemUnit := TStringList.Create;
  FTabelaClasse := FTabela;

  FSlGeradora.Add('import ' + QuotedStr('dart:convert') + ';');
  FSlGeradora.Add('');
  FSlGeradora.Add('class ' + FTabelaClasse + ' {    ');
  FClientDataSet.First;

  while not FClientDataSet.Eof do
  begin

    FSlGeradora.Add('  final ' + TFunc.retornaTipo(FClientDataSet.FieldByName('TIPO')
      .AsString) + ' ' + FClientDataSet.FieldByName('NOME').AsString + ';');

    FClientDataSet.next;
  end;
  FSlGeradora.Add('');
  FClientDataSet.First;
  FSlGeradora.Add('  ' + FTabelaClasse + '({');
  while not FClientDataSet.Eof do
  begin

    if (FClientDataSet.recNo = FClientDataSet.RecordCount) then
      FSlGeradora.Add('                  this.' + FClientDataSet.FieldByName('NOME')
        .AsString + '});')
    else
      FSlGeradora.Add('                  this.' + FClientDataSet.FieldByName('NOME')
        .AsString + ',');

    FClientDataSet.next;
  end;
  FSlGeradora.Add('');
  FClientDataSet.First;

  while not FClientDataSet.Eof do
  begin
    if (upperCase(FClientDataSet.FieldByName('ASSERT').AsString) = 'S') then
      FSlGeradora.Add('        assert(' + FClientDataSet.FieldByName('NOME')
        .AsString + ' != null),');

    FClientDataSet.next;
  end;


  FSlGeradora.Add('  ' + FTabelaClasse + '.fromJson(json):');

  FClientDataSet.First;

  while not FClientDataSet.Eof do
  begin
    if (FClientDataSet.recNo = FClientDataSet.RecordCount) then
      FSlGeradora.Add('      ' + FClientDataSet.FieldByName('NOME').AsString +' = json[' + QuotedStr( FClientDataSet.FieldByName('NOME').AsString) +'];')
    else
      FSlGeradora.Add('      ' + FClientDataSet.FieldByName('NOME').AsString +' = json[' + QuotedStr( FClientDataSet.FieldByName('NOME').AsString) +'],');

    FClientDataSet.next;
  end;
  FSlGeradora.Add('');

  FClientDataSet.First;
  FSlGeradora.Add('  Map<String, dynamic> toMap(){');
  FSlGeradora.Add('    return {');
  while not FClientDataSet.Eof do
  begin
      FSlGeradora.Add('      "' + FClientDataSet.FieldByName('NOME').AsString +'": ' +  FClientDataSet.FieldByName('NOME').AsString +',');

    FClientDataSet.next;
  end;
  FSlGeradora.Add('    };');

  FSlGeradora.Add('  }');
  FSlGeradora.Add('');



  FClientDataSet.First;
  FSlGeradora.Add('  ' + FTabelaClasse + '.fromMap(Map<String, dynamic> map):');
  while not FClientDataSet.Eof do
  begin
    if (FClientDataSet.recNo = FClientDataSet.RecordCount) then
      FSlGeradora.Add('      this.' + FClientDataSet.FieldByName('NOME').AsString +
      ' = map["' +  FClientDataSet.FieldByName('NOME').AsString +'"];')
    else
      FSlGeradora.Add('      this.' + FClientDataSet.FieldByName('NOME').AsString +
      ' = map["' +  FClientDataSet.FieldByName('NOME').AsString +'"],');
    FClientDataSet.next;
  end;



  FSlGeradora.Add('');



  FSlGeradora.Add('}');

  FSlGeradora.SaveToFile(FPath + FTabelaClasse + '_model.dart');

end;

function TCadastroBean.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TCadastroBean.getPacote: String;
begin
  Result := FPacote;
end;

function TCadastroBean.getPath: String;
begin
  Result := FPath;
end;

function TCadastroBean.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TCadastroBean.getTabela: String;
begin
  Result := FTabela;
end;

function TCadastroBean.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TCadastroBean.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TCadastroBean.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

function TCadastroBean.getTop: Integer;
begin
  if FTop = 0 then
  begin
    Result := 26;
    FTop := 26;
  end
  else
  begin
    FTop := FTop + 28;
    Result := FTop;
  end;
end;

procedure TCadastroBean.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TCadastroBean.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TCadastroBean.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TCadastroBean.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TCadastroBean.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TCadastroBean.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TCadastroBean.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TCadastroBean.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;

end.
