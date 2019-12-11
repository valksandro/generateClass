unit untService;

interface

uses
  System.SysUtils,
  System.Classes,
  Datasnap.DBClient,
  untFuncoes,
  untBaseGeradora,
  System.Generics.collections;

type
  TService = class(TComponent, IGeradora)
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

function TService.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TService.getPacote: String;
begin
  Result := FPacote;
end;

function TService.getPath: String;
begin
  Result := FPath;
end;

function TService.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TService.getTabela: String;
begin
  Result := FTabela;
end;

function TService.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TService.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TService.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

procedure TService.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TService.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TService.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TService.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TService.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TService.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TService.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TService.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;

constructor TService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSlGeradora := TStringList.Create;
end;

destructor TService.Destroy;
begin
  FreeAndNil(FSlGeradora);
  if FTabelasPais <> nil then
    FreeAndNil(FTabelasPais);

  inherited;
end;

procedure TService.gerarArquivo;
var
  I: Integer;
begin
  inherited;
  FTabelaClasse := TFunc.PrimeiraLetraMaiscula(FTabela);

  FSlGeradora.Add('import ''dart:async'';');
  FSlGeradora.Add('import ''package:access.run.lite/bloc/bloc_provider.dart'';');
  FSlGeradora.Add('import ''package:access.run.lite/dao/' + FTabelaClasse.ToLower + '_dao.dart'';');
  FSlGeradora.Add('import ''package:access.run.lite/model/' + FTabelaClasse.ToLower + '_model.dart'';');
  FSlGeradora.Add('import ''package:rxdart/rxdart.dart'';');
  FSlGeradora.Add('');
  FSlGeradora.Add('class ' + FTabelaClasse + 'Bloc implements BlocBase {');
  FSlGeradora.Add('  @override');
  FSlGeradora.Add('  void dispose() {');
  FSlGeradora.Add('    _' + FTabelaClasse.ToLower + 's.close();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  ' + FTabelaClasse + 'Bloc() {');
  FSlGeradora.Add('    reset();');
  FSlGeradora.Add('    _db = ' + FTabelaClasse + 'Dao();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  final BehaviorSubject<List<' + FTabelaClasse + '>> _' + FTabelaClasse.ToLower + 's = BehaviorSubject<List<' + FTabelaClasse + '>>();');
  FSlGeradora.Add('');
  FSlGeradora.Add('  ' + FTabelaClasse + 'Dao _db;');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Stream<List<' + FTabelaClasse + '>> get ' + FTabelaClasse.ToLower + 's => _' + FTabelaClasse.ToLower + 's.stream;');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Function(List<' + FTabelaClasse + '>) get add' + FTabelaClasse + 's => _' + FTabelaClasse.ToLower + 's.sink.add;');
  FSlGeradora.Add('');
  FSlGeradora.Add('  void close() {');
  FSlGeradora.Add('    _' + FTabelaClasse.ToLower + 's.close();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  void reset() {');
  FSlGeradora.Add('    add' + FTabelaClasse + 's([]);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');

   FSlGeradora.Add('   Future<int> saveOrUpdate(' + FTabelaClasse + '  ' +TFunc.PrimeiraLetraMinuscula( FTabelaClasse)  + ') async {');
  FSlGeradora.Add('    var list = await getById( ' +TFunc.PrimeiraLetraMinuscula( FTabelaClasse)  + '.id);');
  FSlGeradora.Add('    int id;');
  FSlGeradora.Add('    if (list == null || list.length <= 0) {');
  FSlGeradora.Add('      id = await insert' + FTabelaClasse + '( ' +TFunc.PrimeiraLetraMinuscula( FTabelaClasse)  + ');');
  FSlGeradora.Add('    }else{');
  FSlGeradora.Add('      id = await update' + FTabelaClasse + '( ' +TFunc.PrimeiraLetraMinuscula( FTabelaClasse)  + ');');
  FSlGeradora.Add('    }');
  FSlGeradora.Add('');
  FSlGeradora.Add('    return id;');
  FSlGeradora.Add('');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<bool> saveList(List<' + FTabelaClasse + '> list) async {');
  FSlGeradora.Add('    assert(list != null);');
  FSlGeradora.Add('');
  FSlGeradora.Add('    try {');
  FSlGeradora.Add('      if (list.length > 0) {');
  FSlGeradora.Add('        for (var item in list) {');
  FSlGeradora.Add('          saveOrUpdate(item);');
  FSlGeradora.Add('        }');
  FSlGeradora.Add('      }');
  FSlGeradora.Add('      return true;');
  FSlGeradora.Add('    }catch(e){');
  FSlGeradora.Add('      print(e.message);');
  FSlGeradora.Add('      return false;');
  FSlGeradora.Add('    }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<List<' + FTabelaClasse + '>> get' + FTabelaClasse + '() async {');
  FSlGeradora.Add('    List list = List();');
  FSlGeradora.Add('    List<' + FTabelaClasse + '> list' + FTabelaClasse + ' = List<' + FTabelaClasse + '>();');
  FSlGeradora.Add('    list = await _db.getTable();');
  FSlGeradora.Add('    if (list.length > 0) {');
  FSlGeradora.Add('      for (var item in list) {');
  FSlGeradora.Add('        list' + FTabelaClasse + '.add(' + FTabelaClasse + '.fromJson(item));');
  FSlGeradora.Add('      }');
  FSlGeradora.Add('    }');
  FSlGeradora.Add('    return list' + FTabelaClasse + ';');
  FSlGeradora.Add('');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> insert' + FTabelaClasse + '(' + FTabelaClasse + ' ' + FTabelaClasse.ToLower + ') async {');
  FSlGeradora.Add('    int id = await _db.insert(' + FTabelaClasse.ToLower + '.toMap());');
  FSlGeradora.Add('    ' + FTabelaClasse + ' p = ' + FTabelaClasse + '(id:id,');

  FClientDataSet.First;

  while not FClientDataSet.Eof do
  begin

    if (FClientDataSet.FieldByName('NOME').AsString.ToUpper  = 'ID') then
    begin
       FClientDataSet.next;
       Continue;
    end;
    if (FClientDataSet.recNo = FClientDataSet.RecordCount) then
      FSlGeradora.Add('                  ' + FClientDataSet.FieldByName('NOME').AsString +':'  + FTabelaClasse.ToLower + '.' +  FClientDataSet.FieldByName('NOME').AsString +');')
    else
      FSlGeradora.Add('                  ' + FClientDataSet.FieldByName('NOME').AsString +':'  + FTabelaClasse.ToLower + '.' +  FClientDataSet.FieldByName('NOME').AsString +',');

    FClientDataSet.next;
  end;
  FSlGeradora.Add('');

  FSlGeradora.Add('    _' + FTabelaClasse.ToLower + 's.value.add(p);');
  FSlGeradora.Add('    add' + FTabelaClasse + 's(_' + FTabelaClasse.ToLower + 's.value);');
  FSlGeradora.Add('    return id;');
    FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> update' + FTabelaClasse + '(' + FTabelaClasse + ' ' + FTabelaClasse.ToLower + ') async {');
  FSlGeradora.Add('    return await _db.update(' + FTabelaClasse.ToLower + '.toMap(), ' + FTabelaClasse.ToLower + '.id);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> getCount() async {');
  FSlGeradora.Add('    return await _db.getCount();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<List<dynamic>> getAllTable() async {');
  FSlGeradora.Add('    return await _db.getTable();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<int> getNextId() async {');
  FSlGeradora.Add('    return await _db.getNextId();');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<void> delete' + FTabelaClasse + '(int id) async {');
  FSlGeradora.Add('    await _db.delete(id);');
  FSlGeradora.Add('    _' + FTabelaClasse.ToLower + 's.value.removeWhere((' + FTabelaClasse.ToLower + ') => ' + FTabelaClasse.ToLower + '.id == id);');
  FSlGeradora.Add('    add' + FTabelaClasse + 's(_' + FTabelaClasse.ToLower + 's.value);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('  Future<List> getById(int id) async {');
  FSlGeradora.Add('    return await _db.getById(id);');
  FSlGeradora.Add('  }');
  FSlGeradora.Add('');
  FSlGeradora.Add('');
  FSlGeradora.Add('}');
  FSlGeradora.SaveToFile(FPath + FTabelaClasse+'dao_bloc.dart');
end;

end.





