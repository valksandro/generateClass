unit untRepository;

interface

uses
  System.SysUtils,
  System.Classes,
  Datasnap.DBClient,
  untFuncoes,
  untBaseGeradora,
  System.Generics.collections;

type
  TRepository = class(TComponent, IGeradora)
  private
    FPacote: String;
    FTabela: String;
    FTabelaClasse: String;
    FClientDataSet: TClientDataSet;
    FSlGeradora: TStringList;
    FPath: String;
    FTabelasPais : TList<String>;
    FTabelasFilhas: TList<TTabelasFilhas>;
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
    procedure gerarArquivo;dynamic;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property Pacote: String read getPacote write setPacote;
    property Tabela: String read getTabela write setTabela;
    property TabelaClasse: String read getTabelaClasse write setTabelaClasse;
    property ClientDataSet: TClientDataSet read getClientDataSet write setClientDataSet;
    property SlGeradora: TStringList read getSlGeradora write setSlGeradora;
    property Path: String read getPath write setPath;
  end;


implementation


{ TRepository }

constructor TRepository.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSlGeradora := TStringList.Create;
end;

destructor TRepository.Destroy;
begin
  FreeAndNil(FSlGeradora);
  if FTabelasPais <> nil then
    FreeAndNil(FTabelasPais);

  inherited;
end;

procedure TRepository.gerarArquivo;
var
  notNull: String;
begin
  inherited;
  FTabelaClasse := TFunc.PrimeiraLetraMaiscula(FTabela);

  FSlGeradora.Add('import '+ QuotedStr('package:access.run.lite/utils/database_sqflite.dart') +';');

  FSlGeradora.Add('');

  FSlGeradora.Add('class ' + FTabelaClasse + 'Dao extends DatabaseSqflite{');
  FSlGeradora.Add('');
  FSlGeradora.Add('  static const String TABLE = ' + QuotedStr(FTabelaClasse)  +';');
  FSlGeradora.Add('  static const String SELECT = ' + QuotedStr('SELECT * FROM ' + FTabelaClasse) + ';');
  FSlGeradora.Add('  static const String SELECT_COUNT = ' + QuotedStr('SELECT COUNT(*) FROM $TABLE') + ';');
  FSlGeradora.Add('  static ' + FTabelaClasse + 'Dao _instance;');
  FSlGeradora.Add('');


  FClientDataSet.First;

  while not FClientDataSet.Eof do
  begin

    FSlGeradora.Add('  final String ' + 'col' + TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('NOME').AsString) + ' = ' + QuotedStr(FClientDataSet.FieldByName('NOME').AsString) + ';');

    FClientDataSet.next;
  end;

  FSlGeradora.Add('/*');
  FClientDataSet.First;
  FSlGeradora.Add('    sqlCreate.writeln(' + QuotedStr('CREATE TABLE ' + FTabelaClasse + '(') + ');');
  while not FClientDataSet.Eof do
  begin
    if (FClientDataSet.FieldByName('NOME').AsString.ToUpper  = 'ID') then
    begin
       FSlGeradora.Add('    sqlCreate.writeln(' + QuotedStr(' id INTEGER PRIMARY KEY,') + ');');
       FClientDataSet.next;
       Continue;
    end;

    if (FClientDataSet.recNo = FClientDataSet.RecordCount) then
      FSlGeradora.Add('    sqlCreate.writeln('  + QuotedStr(' ' + FClientDataSet.FieldByName('NOME').AsString + ' ' + TFunc.retornaTipoBase(FClientDataSet.FieldByName('TIPO').AsString) + ')') + ');')
    else
      FSlGeradora.Add('    sqlCreate.writeln('  + QuotedStr(' ' + FClientDataSet.FieldByName('NOME').AsString + ' ' + TFunc.retornaTipoBase(FClientDataSet.FieldByName('TIPO').AsString) + ',') + ');');


    FClientDataSet.next;
  end;
  FSlGeradora.Add('    super.scriptScreate = sqlCreate.toString();');
  FSlGeradora.Add('  */');
  FSlGeradora.Add('');

  FSlGeradora.Add('');
  FSlGeradora.Add('  static ' + FTabelaClasse + 'Dao getInstance(){ ');
  FSlGeradora.Add('   if(_instance == null){ ');
  FSlGeradora.Add('     _instance = ' + FTabelaClasse + 'Dao();  ');
  FSlGeradora.Add('    return _instance;');
  FSlGeradora.Add('   }  ');
  FSlGeradora.Add('  ');
  FSlGeradora.Add('   return _instance;  ');
  FSlGeradora.Add(' } ');
  FSlGeradora.Add(' ');
  FClientDataSet.First;


  FSlGeradora.Add('  Future<List> getTable() async {');
  FSlGeradora.Add('    List result = await super.getTable_(TABLE);');
  FSlGeradora.Add('    return result.toList();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<List> getById(int id) async {');
  FSlGeradora.Add('    return await super.getById_(TABLE, colId, id);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> getCount() async {');
  FSlGeradora.Add('    return await super.getCount_(TABLE);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> getNextId() async {');
  FSlGeradora.Add('    return await super.getNextId_(TABLE, colId);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> insert(Map options) async {');
  FSlGeradora.Add('    return await super.insert_(TABLE, options);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> update(Map options, int id) async {');
  FSlGeradora.Add('    return await super.update_(TABLE, ''$colId = ?'', options, id);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> delete(int id) async {');
  FSlGeradora.Add('    return await super.delete_(TABLE, ''$colId = ?'', id);');
  FSlGeradora.Add('  }');

  FSlGeradora.Add('}');

  FSlGeradora.SaveToFile(FPath +FTabelaClasse+'_dao.dart');
end;


function TRepository.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TRepository.getPacote: String;
begin
  Result := FPacote;
end;

function TRepository.getPath: String;
begin
  Result := FPath;
end;

function TRepository.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TRepository.getTabela: String;
begin
  Result := FTabela;
end;

function TRepository.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TRepository.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TRepository.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

procedure TRepository.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TRepository.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TRepository.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TRepository.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TRepository.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TRepository.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TRepository.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TRepository.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;

end.






