unit untXHTML;

interface

uses
  System.SysUtils,
  System.Classes,
  Datasnap.DBClient,
  untFuncoes,
  untBaseGeradora,
  System.Generics.collections;

type
  TXHTML = class(TComponent, IGeradora)
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

function TXHTML.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TXHTML.getPacote: String;
begin
  Result := FPacote;
end;

function TXHTML.getPath: String;
begin
  Result := FPath;
end;

function TXHTML.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TXHTML.getTabela: String;
begin
  Result := FTabela;
end;

function TXHTML.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TXHTML.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TXHTML.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

procedure TXHTML.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TXHTML.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TXHTML.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TXHTML.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TXHTML.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TXHTML.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TXHTML.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TXHTML.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;

constructor TXHTML.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSlGeradora := TStringList.Create;
end;

destructor TXHTML.Destroy;
begin
  FreeAndNil(FSlGeradora);
  if FTabelasPais <> nil then
    FreeAndNil(FTabelasPais);

  inherited;
end;

procedure TXHTML.gerarArquivo;
var
  I: Integer;
  filtro: String;
  nomeCampoForm: String;
begin
  inherited;
  FTabelaClasse := StringReplace(TFunc.PrimeiraLetraMaiscula(FTabela), '_', '', [rfReplaceAll,rfIgnoreCase]);


  FClientDataSet.Locate('COLUMN_KEY', 'PRI', []);
  FSlGeradora.Add('');


  FSlGeradora.Add('<ui:composition template="/WEB-INF/template/LayoutPadrao.xhtml"');
  FSlGeradora.Add('    xmlns="http://www.w3.org/1999/xhtml"');
  FSlGeradora.Add('    xmlns:h="http://java.sun.com/jsf/html"');
  FSlGeradora.Add('    xmlns:f="http://java.sun.com/jsf/core"');
  FSlGeradora.Add('    xmlns:ui="http://java.sun.com/jsf/facelets"');
  FSlGeradora.Add('    xmlns:p="http://primefaces.org/ui"');
  FSlGeradora.Add('    xmlns:o="http://omnifaces.org/ui">');
  FSlGeradora.Add('');
  FSlGeradora.Add('    <ui:define name="titulo">#{cadastro' + FTabelaClasse + 'Bean.editando ? ''Edicao de ' + LowerCase(FTabelaClasse) + ''' : ''Novo ' + LowerCase(FTabelaClasse) + '''}</ui:define>');
  FSlGeradora.Add('');
  FSlGeradora.Add('    <ui:define name="corpo">');
  FSlGeradora.Add('    	<f:metadata>');
  FSlGeradora.Add('    		<o:viewParam name="' + LowerCase(FTabelaClasse) + '" value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelaClasse) + '}" />');
  FSlGeradora.Add('    	</f:metadata>');
  FSlGeradora.Add('');
  FSlGeradora.Add('    	<h:form>');
  FSlGeradora.Add('	    	<h1>#{cadastro' + FTabelaClasse + 'Bean.editando ? ''Edicao de ' + LowerCase(FTabelaClasse) + ''' : ''Novo ' + LowerCase(FTabelaClasse) + '''}</h1>');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:messages autoUpdate="true" closable="true" />');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:toolbar style="margin-top: 20px">');
  FSlGeradora.Add('	    		<p:toolbarGroup>');
  FSlGeradora.Add('	    			<p:button value="Novo" outcome="/' + LowerCase(FTabelaClasse) + 's/Cadastro' + FTabelaClasse + '" />');
  FSlGeradora.Add('	    			<p:commandButton value="Salvar" id="botaoSalvar"');
  FSlGeradora.Add('	    				action="#{cadastro' + FTabelaClasse + 'Bean.salvar}" update="@form" />');
  FSlGeradora.Add('	    		</p:toolbarGroup>');
  FSlGeradora.Add('	    		<p:toolbarGroup align="right">');
  FSlGeradora.Add('	    			<p:button value="Pesquisa" outcome="/' + LowerCase(FTabelaClasse) + 's/Pesquisa' + FTabelaClasse + 's" />');
  FSlGeradora.Add('	    		</p:toolbarGroup>');
  FSlGeradora.Add('	    	</p:toolbar>');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:panelGrid columns="2" id="painel" style="width: 100%; margin-top: 20px"');
  FSlGeradora.Add('	    			columnClasses="rotulo, campo">');
  FClientDataSet.First;
  while not FClientDataSet.Eof do
  begin
    if Trim(FClientDataSet.FieldByName('NOME_FORMULARIO').AsString) = EmptyWideStr then begin
      nomeCampoForm := FClientDataSet.FieldByName('COLUMN_NAME').AsString;
    end else
      nomeCampoForm := FClientDataSet.FieldByName('NOME_FORMULARIO').AsString;

    if FClientDataSet.FieldByName('APARECER_NA_PESQUISA').AsString = 'S'  then begin
      if FClientDataSet.FieldByName('MOEDA').AsString = 'S'  then begin
        FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
        FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" size="10" maxlength="10" styleClass="moeda"');
        FSlGeradora.Add('	    			value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelaClasse) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}">');
        FSlGeradora.Add('	    			<f:convertNumber maxFractionDigits="2" minFractionDigits="2" />');
        FSlGeradora.Add('	    		</p:inputText>');
      end else if Pos(UpperCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)), 'DATE') > 0 then begin
        FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
        FSlGeradora.Add('	    		<p:calendar value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelaClasse) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"	showOn="button"	pattern="dd/MM/yyyy" locale="pt_BR"/>');
        FSlGeradora.Add('');
      end else if Pos(UpperCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)), 'BLOB') > 0 then begin
        FSlGeradora.Add('	<h:panelGroup layout="block" style="padding-right: 10px">');
        FSlGeradora.Add('		<p:inputTextarea rows="10" style="width: 100%" value="#{cadastro' + FTabelaClasse + 'Bean.'+ LowerCase(FTabelaClasse) +'.' + LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"');
        FSlGeradora.Add('			"/>');
        FSlGeradora.Add('	</h:panelGroup>');
      end else if Pos(UpperCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)), 'INT') > 0 then begin
        FSlGeradora.Add('');
        FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
        FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelaClasse) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"/>');
      end else if FClientDataSet.FieldByName('CHECK_BOX').AsString = 'S' then begin
        FSlGeradora.Add('');
        FSlGeradora.Add('        <p:selectBooleanCheckbox value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelaClasse) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"/>');
        FSlGeradora.Add('        <h:outputText value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
      end else begin
        FSlGeradora.Add('');
        FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
        FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" size="'+LowerCase(FClientDataSet.FieldByName('CHAR_LENGTH').AsString)+'" maxlength="'+LowerCase(FClientDataSet.FieldByName('CHAR_LENGTH').AsString)+'" value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelaClasse) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"/>');
      end;
    end;


    FClientDataSet.Next;
  end;
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	</p:panelGrid>');
  if Assigned(FTabelasFilhas) then begin
    for I := 0 to FTabelasFilhas.Count - 1 do begin
      FSlGeradora.Add('	    	<p:spacer width="100" height="10" />');
      FSlGeradora.Add('	    	<ui:include src="/WEB-INF/template/' + LowerCase(FTabelaClasse)+ 's/'+LowerCase(FTabelasFilhas[i].Nome)+'.xhtml" />');
      FSlGeradora.Add('	    	');
    end;
  end;

  FSlGeradora.Add('    	</h:form>');
  FSlGeradora.Add('    </ui:define>');
  FSlGeradora.Add('</ui:composition>');
  FSlGeradora.Add('');
  CreateDir(FPath + '\' + LowerCase(FTabelaClasse)+'s');
  FSlGeradora.SaveToFile(FPath + '\' + LowerCase(FTabelaClasse)+ 's\Cadastro' + FTabelaClasse +'.xhtml');


  if Assigned(FTabelasFilhas) then begin
    for I := 0 to FTabelasFilhas.Count - 1 do begin
      FSlGeradora.Clear;
      FSlGeradora.Add('  <ui:composition xmlns="http://www.w3.org/1999/xhtml"');
      FSlGeradora.Add('    xmlns:h="http://java.sun.com/jsf/html"');
      FSlGeradora.Add('    xmlns:f="http://java.sun.com/jsf/core"');
      FSlGeradora.Add('    xmlns:ui="http://java.sun.com/jsf/facelets"');
      FSlGeradora.Add('    xmlns:p="http://primefaces.org/ui">');
      FSlGeradora.Add('');
      FSlGeradora.Add('	<p:fieldset legend="'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'" toggleable="true" collapsed="true"');
      FSlGeradora.Add('				toggleSpeed="500">');
      FSlGeradora.Add('');
      FSlGeradora.Add('				<h:form id="form'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'">');
      FSlGeradora.Add('					<p:toolbar style="margin-top: 20px">');
      FSlGeradora.Add('						<p:toolbarGroup align="right">');
      FSlGeradora.Add('							<p:commandButton value="Adicionar" id="botaoAdd'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'"');
      FSlGeradora.Add('								action="#{cadastro' + FTabelaClasse + 'Bean.add'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'}" update="painel'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+', '+LowerCase(FTabelasFilhas[i].Nome) +'sTable">');
      FSlGeradora.Add('								</p:commandButton>');
      FSlGeradora.Add('						</p:toolbarGroup>');
      FSlGeradora.Add('					</p:toolbar>');
      FSlGeradora.Add('');
      FSlGeradora.Add('					<p:panelGrid columns="2" id="painel'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'"');
      FSlGeradora.Add('						style="width: 100%; margin-top: 20px"');
      FSlGeradora.Add('						columnClasses="rotulo, campo">');
      FSlGeradora.Add('');

      FClientDataSet.Filtered := False;
      filtro := FClientDataSet.Filter;
      FClientDataSet.Filter := 'TABLE_NAME = ' + QuotedStr(LowerCase(FTabelasFilhas[i].Nome));
      FClientDataSet.Filtered := True;

      while not FClientDataSet.Eof do
      begin
        if Trim(FClientDataSet.FieldByName('NOME_FORMULARIO').AsString) = EmptyWideStr then begin
          nomeCampoForm := FClientDataSet.FieldByName('COLUMN_NAME').AsString;
        end else
          nomeCampoForm := FClientDataSet.FieldByName('NOME_FORMULARIO').AsString;

        if FClientDataSet.FieldByName('APARECER_NA_PESQUISA').AsString = 'S'  then begin
          if FClientDataSet.FieldByName('MOEDA').AsString = 'S'  then begin
            FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
            FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" size="10" maxlength="10" styleClass="moeda"');
            FSlGeradora.Add('	    			value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelasFilhas[i].Nome) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}">');
            FSlGeradora.Add('	    			<f:convertNumber maxFractionDigits="2" minFractionDigits="2" />');
            FSlGeradora.Add('	    		</p:inputText>');
          end else if Pos(UpperCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)), 'DATE') > 0 then begin
            FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
            FSlGeradora.Add('	    		<p:calendar value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelasFilhas[i].Nome) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"	showOn="button"	pattern="dd/MM/yyyy" locale="pt_BR"/>');
            FSlGeradora.Add('');
          end else if Pos(UpperCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)), 'BLOB') > 0 then begin
            FSlGeradora.Add('	<h:panelGroup layout="block" style="padding-right: 10px">');
            FSlGeradora.Add('		<p:inputTextarea rows="10" style="width: 100%" value="#{cadastro' + FTabelaClasse + 'Bean.'+ LowerCase(FTabelasFilhas[i].Nome) +'.' + LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"');
            FSlGeradora.Add('			"/>');
            FSlGeradora.Add('	</h:panelGroup>');
          end else if Pos(UpperCase(TFunc.retornaTipo(FClientDataSet.FieldByName('DATA_TYPE').AsString)), 'INT') > 0 then begin
            FSlGeradora.Add('');
            FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
            FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelasFilhas[i].Nome) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"/>');
          end else begin
            FSlGeradora.Add('');
            FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
            FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" size="'+LowerCase(FClientDataSet.FieldByName('CHAR_LENGTH').AsString)+'" maxlength="'+LowerCase(FClientDataSet.FieldByName('CHAR_LENGTH').AsString)+'" value="#{cadastro' + FTabelaClasse + 'Bean.' + LowerCase(FTabelasFilhas[i].Nome) + '.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}"/>');
          end;
        end;
        FClientDataSet.Next;
      end;
      FSlGeradora.Add('');
      FSlGeradora.Add('					</p:panelGrid>');
      FSlGeradora.Add('');
      FSlGeradora.Add('					<p:dataTable id="'+LowerCase(FTabelasFilhas[i].Nome) +'sTable"');
      FSlGeradora.Add('						value="#{cadastro' + TabelaClasse + 'Bean.lista'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'s}" var="'+LowerCase(FTabelasFilhas[i].Nome) +'"');
      FSlGeradora.Add('						style="margin-top: 20px"');
      FSlGeradora.Add('						emptyMessage="Nenhum '+LowerCase(FTabelasFilhas[i].Nome) +' encontrado." rows="20"');
      FSlGeradora.Add('						paginator="true" paginatorAlwaysVisible="false"');
      FSlGeradora.Add('						paginatorPosition="bottom">');

      FClientDataSet.First;

      while not FClientDataSet.Eof do
      begin
        if Trim(FClientDataSet.FieldByName('NOME_FORMULARIO').AsString) = EmptyWideStr then begin
          nomeCampoForm := FClientDataSet.FieldByName('COLUMN_NAME').AsString;
        end else
          nomeCampoForm := nomeCampoForm;

        if FClientDataSet.FieldByName('APARECER_NA_GRID').AsString = 'S'  then begin
          if FClientDataSet.FieldByName('MOEDA').AsString = 'S'  then begin
            FSlGeradora.Add('	    		<p:column headerText="'+nomeCampoForm+'" style="text-align: right; width: 120px">');
            FSlGeradora.Add('	    			<h:outputText value="#{'+LowerCase(FTabelasFilhas[i].Nome) +'.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" />');
            FSlGeradora.Add('	    				<f:convertNumber type="currency"/>');
            FSlGeradora.Add('	    			</h:outputText>');
            FSlGeradora.Add('	    		</p:column>');
          end else begin
            FSlGeradora.Add('	    		<p:column headerText="'+nomeCampoForm+'" style="text-align: center; width: 100px">');
            FSlGeradora.Add('	    			<h:outputText value="#{'+LowerCase(FTabelasFilhas[i].Nome) +'.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" />');
            FSlGeradora.Add('	    		</p:column>');
          end;
        end;
        FClientDataSet.Next;
      end;

      FSlGeradora.Add('						<p:column style="width: 100px; text-align: center">');
      FSlGeradora.Add('							<p:commandButton icon="ui-icon-trash" title="Excluir"');
      FSlGeradora.Add('								action="#{cadastro' + TabelaClasse + 'Bean.excluir'+TFunc.PrimeiraLetraMaiscula(FTabelasFilhas[i].Nome)+'}" update="'+LowerCase(FTabelasFilhas[i].Nome) +'sTable">');
      FSlGeradora.Add('								<f:setPropertyActionListener');
      FSlGeradora.Add('									target="#{cadastro' + TabelaClasse + 'Bean.'+LowerCase(FTabelasFilhas[i].Nome) +'Selecionado}"');
      FSlGeradora.Add('									value="#{'+LowerCase(FTabelasFilhas[i].Nome) +'}" />');
      FSlGeradora.Add('							</p:commandButton>');
      FSlGeradora.Add('						</p:column>');
      FSlGeradora.Add('					</p:dataTable>');
      FSlGeradora.Add('				</h:form>');
      FSlGeradora.Add('			</p:fieldset>');
      FSlGeradora.Add('');
      FSlGeradora.Add('');
      FSlGeradora.Add('</ui:composition>');
      CreateDir(FPath + '\template');
      CreateDir(FPath + '\template\' + LowerCase(FTabelaClasse)+ 's\');
      FSlGeradora.SaveToFile(FPath + '\template\' + LowerCase(FTabelaClasse)+ 's\' + LowerCase(FTabelasFilhas[i].Nome) +'.xhtml');
    end;
  end;
  FClientDataSet.Filtered := False;
  FClientDataSet.Filter   := filtro;
  FClientDataSet.Filtered := True;
end;

end.




