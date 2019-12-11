unit untModel;

interface

uses
  System.SysUtils,
  System.Classes,
  Datasnap.DBClient,
  untFuncoes,
  untBaseGeradora,
  System.Generics.collections;


type

  TModel = class(TComponent, IGeradora)
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
    constructor Create(AOwner: TComponent);
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
    destructor Destroy; override;

    property Pacote: String read getPacote write setPacote;
    property Tabela: String read getTabela write setTabela;
    property TabelaClasse: String read getTabelaClasse write setTabelaClasse;
    property ClientDataSet: TClientDataSet read getClientDataSet write setClientDataSet;
    property SlGeradora: TStringList read getSlGeradora write setSlGeradora;
    property Path: String read getPath write setPath;
  end;


implementation


{ TModel }

destructor TModel.Destroy;
begin
  FreeAndNil(FSlGeradora);
  FreeAndNil(FTabelasPais);
  if FTabelasPais <> nil then
    FreeAndNil(FTabelasPais);

  inherited;
end;

constructor TModel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTabelasPais := TList<String>.Create;
  FSlGeradora  := TStringList.Create;
end;

procedure TModel.gerarArquivo;
var
  I: Integer;
begin
  inherited;
  FTabelaClasse := StringReplace(TFunc.PrimeiraLetraMaiscula(FTabela), '_', '', [rfReplaceAll,rfIgnoreCase]);


  FSlGeradora.Add('unit unt'+ FTabelaClasse + 'MDL;');
  FSlGeradora.Add('');
  FSlGeradora.Add('interface');
  FSlGeradora.Add('');
  FSlGeradora.Add('uses');
  FSlGeradora.Add('  Aurelius.Mapping.Attributes;');
  FSlGeradora.Add('');
  FSlGeradora.Add('type');
  FSlGeradora.Add('');
  FSlGeradora.Add('  [Entity]');
  FSlGeradora.Add('  [Automapping]');
  FSlGeradora.Add('  [Id(''FId'', TIdGenerator.IdentityOrSequence)]');
  FSlGeradora.Add('  [Sequence(''SEQ_'+ UpperCase(FTabelaClasse) + ''')]');
  FSlGeradora.Add('  T'+ FTabelaClasse + ' = class');
  FSlGeradora.Add('  private');

  FClientDataSet.First;


  while not FClientDataSet.Eof do
  begin
    if FClientDataSet.FieldByName('COLUMN_KEY').AsString <> 'MUL' then
      FSlGeradora.Add('    F'+ TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + ' : ' + TFunc.PrimeiraLetraMaiscula(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)) + ';');
    FClientDataSet.Next;
  end;


  FSlGeradora.Add('  public');
  FClientDataSet.First;
  while not FClientDataSet.Eof do
  begin
    if FClientDataSet.FieldByName('COLUMN_KEY').AsString <> 'MUL' then begin
      FSlGeradora.Add('    property ' + TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + ': '
                      + TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString) + ' read F' + TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + ' write F' +
                      TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + ';');
    end;
    FClientDataSet.Next;
  end;

  FSlGeradora.Add('  end;');
  FSlGeradora.Add('');
  FSlGeradora.Add(' implementation');

  FSlGeradora.Add('end.');
  CreateDir(FPath +'\model');
  CreateDir(FPath +'\MDL');
  FSlGeradora.SaveToFile(FPath +'\model\MDL\unt' + FTabelaClasse + 'MDL.pas');
  FSlGeradora.Clear;


  FSlGeradora.Add('unit untControle'+ FTabelaClasse + ';');
  FSlGeradora.Add('');
  FSlGeradora.Add('interface');
  FSlGeradora.Add('');
  FSlGeradora.Add('uses');
  FSlGeradora.Add('  unt'+ FTabelaClasse + 'MDL,');
  FSlGeradora.Add('  untBaseControle,');
  FSlGeradora.Add('  Generics.Collections,');
  FSlGeradora.Add('  unt'+ FTabelaClasse + 'DAO,');
  FSlGeradora.Add('  Vcl.Forms,');
  FSlGeradora.Add('  Vcl.StdCtrls,');
  FSlGeradora.Add('  System.Classes,');
  FSlGeradora.Add('  System.SysUtils;');
  FSlGeradora.Add('');
  FSlGeradora.Add('type');
  FSlGeradora.Add('');
  FSlGeradora.Add('    TControle'+ FTabelaClasse + ' = Class(TBaseControle<T'+ FTabelaClasse + ', T'+ FTabelaClasse + 'DAO>,  IControle<T'+ FTabelaClasse + '>)');
  FSlGeradora.Add('    private');
  FSlGeradora.Add('      F'+ FTabelaClasse + ': T'+ FTabelaClasse + ';');
  FSlGeradora.Add('    public');
  FSlGeradora.Add('     Constructor Create;');
  FSlGeradora.Add('     function Salvar(var AErro: String): Boolean;');
  FSlGeradora.Add('     function ValidarDados(var AErro: String): Boolean;');
  FSlGeradora.Add('     function GetById(AID: Integer): T'+ FTabelaClasse + ';');
  FSlGeradora.Add('     function Excluir(AID: Integer; var AErro: String): Boolean;');
  FSlGeradora.Add('     procedure Reset;');
  FSlGeradora.Add('     property '+ FTabelaClasse + ': T'+ FTabelaClasse + ' read F'+ FTabelaClasse + ' write F'+ FTabelaClasse + ';');
  FSlGeradora.Add('  end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('');
  FSlGeradora.Add(' implementation');
  FSlGeradora.Add('');
  FSlGeradora.Add('{ TControle'+ FTabelaClasse + ' }');
  FSlGeradora.Add('');
  FSlGeradora.Add('constructor TControle'+ FTabelaClasse + '.Create;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  inherited;');
  FSlGeradora.Add('  F'+ FTabelaClasse + ' := T'+ FTabelaClasse + '.Create;');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('function TControle'+ FTabelaClasse + '.Excluir(AID: Integer; var AErro: String): Boolean;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  Result := inherited Excluir(AID, AErro);');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('function TControle'+ FTabelaClasse + '.Salvar(var AErro: String): Boolean;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  if not (ValidarDados(AErro)) then Exit;');
  FSlGeradora.Add('  Result := inherited Salvar(F'+ FTabelaClasse + ', AErro);');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('function TControle'+ FTabelaClasse + '.ValidarDados(var AErro: String): Boolean;');
  FSlGeradora.Add('var');
  FSlGeradora.Add('  componente: TComponent;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  Result := True;');
  FClientDataSet.First;
  while not FClientDataSet.Eof do
  begin
    if (FClientDataSet.FieldByName('COLUMN_NAME').AsString = FClientDataSet.FieldByName('COLUMN_KEY').AsString) then begin
       FClientDataSet.Next;
       Continue;
    end;
    if FClientDataSet.FieldByName('IS_NULLABLE').AsString = 'N' then begin
      if (Pos('int', FClientDataSet.FieldByName('DATA_TYPE').AsString) > 0) or
                (Pos('number', FClientDataSet.FieldByName('DATA_TYPE').AsString) > 0) then begin
        FSlGeradora.Add('  if (F'+ FTabelaClasse + '.' + FClientDataSet.FieldByName('COLUMN_NAME').AsString + ' <= 0) then begin');
        FSlGeradora.Add('    if (Assigned(Sender)) and (Sender is TForm) then begin');
        FSlGeradora.Add('      componente := TForm(Sender).FindComponent(''edt' + FClientDataSet.FieldByName('COLUMN_NAME').AsString + ''');');
        FSlGeradora.Add('      if (Assigned(componente)) then');
        FSlGeradora.Add('        TCustomEdit(componente).SetFocus;');
        FSlGeradora.Add('    end;');

        FSlGeradora.Add('    Result := False;');
        FSlGeradora.Add('    AErro := ''O campo "'+ FClientDataSet.FieldByName('NOME_FORMULARIO').AsString + '" não pode ser menor ou igual a zero!'';');

      end else begin
        FSlGeradora.Add('  if (F'+ FTabelaClasse + '.' + FClientDataSet.FieldByName('COLUMN_NAME').AsString + '.IsEmpty) then begin');
        FSlGeradora.Add('    if (Assigned(Sender)) and (Sender is TForm) then begin');
        FSlGeradora.Add('      componente := TForm(Sender).FindComponent(''edt' + FClientDataSet.FieldByName('COLUMN_NAME').AsString + ''');');
        FSlGeradora.Add('      if (Assigned(componente)) then');
        FSlGeradora.Add('        TCustomEdit(componente).SetFocus;');
        FSlGeradora.Add('    end;');
        FSlGeradora.Add('    Result := False;');
        FSlGeradora.Add('    AErro := ''O campo "'+ FClientDataSet.FieldByName('NOME_FORMULARIO').AsString + '" não pode ser vazio!'';');
      end;
      FSlGeradora.Add('    Exit;');
      FSlGeradora.Add('  end;');
      FSlGeradora.Add('');
    end;
    FClientDataSet.Next;
  end;
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('function TControle'+ FTabelaClasse + '.GetById(AID: Integer): T'+ FTabelaClasse + ';');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  if(F'+ FTabelaClasse + ' <> nil) then');
  FSlGeradora.Add('    F'+ FTabelaClasse + '.Free;');
  FSlGeradora.Add('  F'+ FTabelaClasse + ' := T'+ FTabelaClasse + '.Create;');
  FSlGeradora.Add('');
  FSlGeradora.Add('  F'+ FTabelaClasse + ' := inherited GetById(AID);');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('procedure TControle'+ FTabelaClasse + '.Reset;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  if(F'+ FTabelaClasse + ' <> nil) then');
  FSlGeradora.Add('    F'+ FTabelaClasse + '.Free;');
  FSlGeradora.Add('  F'+ FTabelaClasse + ' := T'+ FTabelaClasse + '.Create;');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('end.');
  CreateDir(FPath +'\control');
  FSlGeradora.SaveToFile(FPath +'\control\untControle' + FTabelaClasse + '.pas');

  FSLGeradora.Clear;
  FSlGeradora.Add('unit unt'+ FTabelaClasse +'DAO;');
  FSlGeradora.Add('');
  FSlGeradora.Add('interface');
  FSlGeradora.Add('');
  FSlGeradora.Add('uses');
  FSlGeradora.Add('  untBaseDAO,');
  FSlGeradora.Add('  unt'+ FTabelaClasse +'MDL,');
  FSlGeradora.Add('  SysUtils;');
  FSlGeradora.Add('');
  FSlGeradora.Add('type');
  FSlGeradora.Add('  T'+ FTabelaClasse +'DAO = class(IDAO<T'+ FTabelaClasse +'>)');
  FSlGeradora.Add('  public');
  FSlGeradora.Add('    function Salvar(AObjeto: T'+ FTabelaClasse +'; var AErro: String): Boolean;');
  FSlGeradora.Add('    function GetById(AID: Integer): T'+ FTabelaClasse +';');
  FSlGeradora.Add('    function Excluir(AID: Integer; var AErro: String): Boolean;');
  FSlGeradora.Add('  end;');
  FSlGeradora.Add('');
  FSlGeradora.Add(' implementation');
  FSlGeradora.Add('');
  FSlGeradora.Add('');
  FSlGeradora.Add('function T'+ FTabelaClasse +'DAO.Excluir(AID: Integer; var AErro: String): Boolean;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  Result := inherited Excluir(AID, AErro);');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('');
  FSlGeradora.Add('function T'+ FTabelaClasse +'DAO.GetById(AID: Integer): T'+ FTabelaClasse +';');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  Result := inherited GetById(AID);');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('');
  FSlGeradora.Add('function T'+ FTabelaClasse +'DAO.Salvar(AObjeto: T'+ FTabelaClasse +'; var AErro: String): Boolean;');
  FSlGeradora.Add('begin');
  FSlGeradora.Add('  Result := inherited Salvar(AObjeto, AErro);');
  FSlGeradora.Add('end;');
  FSlGeradora.Add('end.');
  CreateDir(FPath +'\model');
  CreateDir(FPath +'\DAO');
  FSlGeradora.SaveToFile(FPath +'\model\DAO\unt' + FTabelaClasse + 'DAO.pas');
end;

function TModel.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TModel.getPacote: String;
begin
  Result := FPacote;
end;

function TModel.getPath: String;
begin
  Result := FPath;
end;

function TModel.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TModel.getTabela: String;
begin
  Result := FTabela;
end;

function TModel.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TModel.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TModel.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

procedure TModel.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TModel.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TModel.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TModel.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TModel.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TModel.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TModel.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TModel.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;


end.



