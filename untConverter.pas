unit untConverter;


interface

uses
  System.SysUtils,
  System.Classes,
  Datasnap.DBClient,
  untFuncoes,
  untBaseGeradora,
  System.Generics.collections;


type
  TConverter = class(TComponent, IGeradora)
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

destructor TConverter.Destroy;
begin
  FreeAndNil(FSlGeradora);
  if FTabelasPais <> nil then
    FreeAndNil(FTabelasPais);

  inherited;
end;


constructor TConverter.Create(AOwner: TComponent);
begin
  inherited;
  FSlGeradora := TStringList.Create;
end;


function TConverter.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TConverter.getPacote: String;
begin
  Result := FPacote;
end;

function TConverter.getPath: String;
begin
  Result := FPath;
end;

function TConverter.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TConverter.getTabela: String;
begin
  Result := FTabela;
end;

function TConverter.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TConverter.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TConverter.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

procedure TConverter.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TConverter.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TConverter.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TConverter.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TConverter.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TConverter.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TConverter.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TConverter.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;

procedure TConverter.gerarArquivo;
begin
  inherited;
  FTabelaClasse := StringReplace(TFunc.PrimeiraLetraMaiscula(FTabela), '_', '', [rfReplaceAll,rfIgnoreCase]);

  FSlGeradora.Add('package ' + FPacote + '.converter;');
  FSlGeradora.Add('');

  ClientDataSet.Locate('COLUMN_KEY', 'PRI', []);
  FSlGeradora.Add('');
  FSlGeradora.Add('import javax.faces.component.UIComponent;');
  FSlGeradora.Add('import javax.faces.context.FacesContext;');
  FSlGeradora.Add('import javax.faces.convert.Converter;');
  FSlGeradora.Add('import javax.faces.convert.FacesConverter;');
  FSlGeradora.Add('');
  FSlGeradora.Add('import ' + FPacote + '.model.' + FTabelaClasse + ';');
  FSlGeradora.Add('import ' + FPacote + '.repository.' + FTabelaClasse + 'Repository;');
  FSlGeradora.Add('import ' + FPacote + '.util.cdi.CDIServiceLocator;');
  FSlGeradora.Add('');
  FSlGeradora.Add('@FacesConverter(forClass = ' + FTabelaClasse + '.class)');
  FSlGeradora.Add('public class ' + FTabelaClasse + 'Converter implements Converter {');
  FSlGeradora.Add('');
  FSlGeradora.Add('	//@Inject');
  FSlGeradora.Add('	private ' + FTabelaClasse + 'Repository ' + LowerCase(FTabelaClasse) + 'Repository;');
  FSlGeradora.Add('');
  FSlGeradora.Add('	public ' + FTabelaClasse + 'Converter() {');
  FSlGeradora.Add('		' + LowerCase(FTabelaClasse) + 'Repository = CDIServiceLocator.getBean(' + FTabelaClasse + 'Repository.class);');
  FSlGeradora.Add('	}');
  FSlGeradora.Add('');
  FSlGeradora.Add('	@Override');
  FSlGeradora.Add('	public Object getAsObject(FacesContext context, UIComponent component, String value) {');
  FSlGeradora.Add('		' + FTabelaClasse + ' retorno = null;');
  FSlGeradora.Add('');
  FSlGeradora.Add('		if (value != null) {');
  FSlGeradora.Add('			Long id = new Long(value);');
  FSlGeradora.Add('			retorno = ' + LowerCase(FTabelaClasse) + 'Repository.porId(id);');
  FSlGeradora.Add('		}');
  FSlGeradora.Add('');
  FSlGeradora.Add('		return retorno;');
  FSlGeradora.Add('	}');
  FSlGeradora.Add('');
  FSlGeradora.Add('	@Override');
  FSlGeradora.Add('	public String getAsString(FacesContext context, UIComponent component, Object value) {');
  FSlGeradora.Add('		if (value != null) {');
  FSlGeradora.Add('			' + FTabelaClasse + ' ' + LowerCase(FTabelaClasse) + ' = (' + FTabelaClasse + ') value;');
  FSlGeradora.Add('			return ' + LowerCase(FTabelaClasse) + '.get' +  TFunc.PrimeiraLetraMaiscula(ClientDataSet.FieldByName('COLUMN_NAME').AsString) + '() == null ? null : ' + LowerCase(FTabelaClasse) + '.get' +  TFunc.PrimeiraLetraMaiscula(ClientDataSet.FieldByName('COLUMN_NAME').AsString) + '().toString();');
  FSlGeradora.Add('		}');
  FSlGeradora.Add('');
  FSlGeradora.Add('		return "";');
  FSlGeradora.Add('	}');
  FSlGeradora.Add('');
  FSlGeradora.Add('}');
  FSlGeradora.Add('');
  CreateDir(FPath +'\converter');
  FSlGeradora.SaveToFile(FPath +'\converter\'+FTabelaClasse+'Converter.java');

  FSlGeradora.Clear;
  FSlGeradora.Add('package ' + FPacote + '.repository.filter;');

  FSlGeradora.Add('import java.io.Serializable;');
  FSlGeradora.Add('import java.util.Date;');
  FSlGeradora.Add('');
  FSlGeradora.Add('');
  FSlGeradora.Add('public class ' + FTabelaClasse + 'Filter implements Serializable {');
  FSlGeradora.Add('');
  FSlGeradora.Add('	private static final long serialVersionUID = 1L;');
  FSlGeradora.Add('');
  FClientDataSet.First;
  while not FClientDataSet.Eof do
  begin
    if FClientDataSet.FieldByName('APARECER_NA_PESQUISA').AsString = 'S'  then begin
      if Pos('Bool',TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)) > 0  then
      begin
        FSlGeradora.Add('    private '+ LowerCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)) +' '+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+';');
      end else
      begin
        FSlGeradora.Add('    private '+ TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString) +' '+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+';');
      end;
    end;
    FClientDataSet.Next;
  end;


  FClientDataSet.First;
  while not FClientDataSet.Eof do
  begin
    if FClientDataSet.FieldByName('APARECER_NA_PESQUISA').AsString = 'S'  then begin
      FSlGeradora.Add('    public '+ TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString) +' get' +  TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + '(){');
      FSlGeradora.Add('        return '+ LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString) +';');
      FSlGeradora.Add('    }');
      FSlGeradora.Add('');
      FSlGeradora.Add('    public void  set' +  TFunc.PrimeiraLetraMaiscula(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + '('+TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)+ ' ' + LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString) + '){');
      FSlGeradora.Add('        this.'+ LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString) +' = '+ LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString) +';');
      FSlGeradora.Add('    }');
    end;
    FClientDataSet.Next;
  end;

  FSlGeradora.Add('');
  FSlGeradora.Add('}');
  CreateDir(FPath +'\repository\filter');
  FSlGeradora.SaveToFile(FPath +'\repository\filter\'+FTabelaClasse+'Filter.java');

end;



end.



