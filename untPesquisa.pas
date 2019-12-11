unit untPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient, Datasnap.Provider, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  Vcl.StdActns, Vcl.ExtActns, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.ActnMenus, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls, Data.FMTBcd, Data.SqlExpr, DataModule,
  vcl.themes,   System.IniFiles, untFuncoes, untBaseGeradora, System.Generics.Collections;

type
  TPesquisa = class(TComponent, IGeradora)
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

constructor TPesquisa.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSlGeradora := TStringList.Create;
end;

destructor TPesquisa.Destroy;
begin
  FreeAndNil(FSlGeradora);
  inherited;
end;

function TPesquisa.getClientDataSet: TClientDataSet;
begin
  Result := FClientDataSet;
end;

function TPesquisa.getPacote: String;
begin
  Result := FPacote;
end;

function TPesquisa.getPath: String;
begin
  Result := FPath;
end;

function TPesquisa.getSlGeradora: TStringList;
begin
  Result := FSlGeradora;
end;

function TPesquisa.getTabela: String;
begin
  Result := FTabela;
end;

function TPesquisa.getTabelaClasse: String;
begin
  Result := FTabelaClasse;
end;

function TPesquisa.getTabelasFilhas: TList<TTabelasFilhas>;
begin
  Result := FTabelasFilhas;
end;

function TPesquisa.getTabelasPais: TList<String>;
begin
  if FTabelasPais = nil then
    FTabelasPais := TList<String>.Create;
  Result := FTabelasPais;
end;

procedure TPesquisa.setClientDataSet(const Value: TClientDataSet);
begin
  FClientDataSet := Value;
end;

procedure TPesquisa.setPacote(const Value: String);
begin
  FPacote := Value;
end;

procedure TPesquisa.setPath(const Value: String);
begin
  FPath := Value;
end;

procedure TPesquisa.setSlGeradora(const Value: TStringList);
begin
  FSlGeradora := Value;
end;

procedure TPesquisa.setTabela(const Value: String);
begin
  FTabela := Value;
end;

procedure TPesquisa.setTabelaClasse(const Value: String);
begin
  FTabelaClasse := Value;
end;

procedure TPesquisa.setTabelasFilhas(const Value: TList<TTabelasFilhas>);
begin
  FTabelasFilhas := Value;
end;

procedure TPesquisa.setTabelasPais(const Value: TList<String>);
begin
  FTabelasPais := Value;
end;


procedure TPesquisa.gerarArquivo;
var
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
  FSlGeradora.Add('    xmlns:p="http://primefaces.org/ui">');
  FSlGeradora.Add('');
  FSlGeradora.Add('    <ui:define name="titulo">Pesquisa de '+FTabelaClasse+'s</ui:define>');
  FSlGeradora.Add('');
  FSlGeradora.Add('    <ui:define name="corpo">');
  FSlGeradora.Add('    	<h:form id="frmPesquisa">');
  FSlGeradora.Add('	    	<h1>Pesquisa de '+FTabelaClasse+'s</h1>');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:messages autoUpdate="true" closable="true" />');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:toolbar style="margin-top: 20px">');
  FSlGeradora.Add('	    		<p:toolbarGroup>');
  FSlGeradora.Add('	    			<p:commandButton value="Pesquisar" action="#{pesquisa'+FTabelaClasse+'Bean.pesquisar}"');
  FSlGeradora.Add('	    				update="@form" />');
  FSlGeradora.Add('	    		</p:toolbarGroup>');
  FSlGeradora.Add('	    		<p:toolbarGroup align="right">');
  FSlGeradora.Add('	    			<p:button value="Novo" outcome="/'+LowerCase(FTabelaClasse)+'s/Cadastro'+FTabelaClasse+'" />');
  FSlGeradora.Add('	    		</p:toolbarGroup>');
  FSlGeradora.Add('	    	</p:toolbar>');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:panelGrid columns="2" id="painel" style="width: 100%; margin-top: 20px"');
  FSlGeradora.Add('	    			columnClasses="rotulo, campo">');

  FClientDataSet.First;


  while not FClientDataSet.Eof do
  begin
    if Trim(nomeCampoForm) = EmptyWideStr then begin
      nomeCampoForm := FClientDataSet.FieldByName('COLUMN_NAME').AsString;
    end else
      nomeCampoForm := nomeCampoForm;

    if FClientDataSet.FieldByName('APARECER_NA_PESQUISA').AsString = 'S'  then begin
      FSlGeradora.Add('	    		<p:outputLabel value="'+nomeCampoForm+'" for="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'"/>');
      FSlGeradora.Add('	    		<p:inputText id="'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'" size="'+LowerCase(FClientDataSet.FieldByName('CHAR_LENGTH').AsString)+'" value="#{pesquisa' + FTabelaClasse + 'Bean.filtro.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" />');
      FSlGeradora.Add('');
    end;
    FClientDataSet.Next;
  end;

  FSlGeradora.Add('	    	</p:panelGrid>');
  FSlGeradora.Add('');


  FSlGeradora.Add('	    	<p:dataTable id="'+LowerCase(FTabelaClasse)+'sTable" value="#{pesquisa'+TFunc.PrimeiraLetraMaiscula(FTabelaClasse+'')+'Bean.'+LowerCase(FTabelaClasse)+'sFiltrados}" var="'+LowerCase(FTabelaClasse)+'"');
  FSlGeradora.Add('	    		style="margin-top: 20px" emptyMessage="Nenhum '+LowerCase(FTabelaClasse)+' encontrado." rows="20"');
  FSlGeradora.Add('	    		paginator="true" paginatorAlwaysVisible="false" paginatorPosition="bottom">');

  FClientDataSet.First;


  while not FClientDataSet.Eof do
  begin
    if Trim(nomeCampoForm) = EmptyWideStr then begin
      nomeCampoForm := FClientDataSet.FieldByName('COLUMN_NAME').AsString;
    end else
      nomeCampoForm := nomeCampoForm;
    if FClientDataSet.FieldByName('APARECER_NA_GRID').AsString = 'S'  then begin
      if FClientDataSet.FieldByName('MOEDA').AsString = 'S'  then begin
        FSlGeradora.Add('	    		<p:column headerText="'+nomeCampoForm+'" style="text-align: right; width: 120px">');
        FSlGeradora.Add('	    			<h:outputText value="#{'+LowerCase(FTabelaClasse)+'.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" />');
        FSlGeradora.Add('	    				<f:convertNumber type="currency"/>');
        FSlGeradora.Add('	    			</h:outputText>');
        FSlGeradora.Add('	    		</p:column>');
      end else begin
        FSlGeradora.Add('	    		<p:column headerText="'+nomeCampoForm+'" style="text-align: center; width: 100px">');
        FSlGeradora.Add('	    			<h:outputText value="#{'+LowerCase(FTabelaClasse)+'.'+LowerCase(FClientDataSet.FieldByName('COLUMN_NAME').AsString)+'}" />');
        FSlGeradora.Add('	    		</p:column>');
      end;
    end;
    FClientDataSet.Next;
  end;

  FSlGeradora.Add('	    		<p:column style="width: 100px; text-align: center">');
  FSlGeradora.Add('	    			<p:button outcome="/'+LowerCase(FTabelaClasse)+'s/Cadastro'+TFunc.PrimeiraLetraMaiscula(FTabelaClasse)+'" icon="ui-icon-pencil" title="Editar">');
  FSlGeradora.Add('	    				<f:param name="'+LowerCase(FTabelaClasse)+'" value="#{'+LowerCase(FTabelaClasse)+'.id}" />');
  FSlGeradora.Add('	    			</p:button>');
  FSlGeradora.Add('	    			<p:commandButton icon="ui-icon-trash" title="Excluir" oncomplete="confirmacaoExclusao.show()"');
  FSlGeradora.Add('	    					process="@this" update=":frmPesquisa:confirmacaoExclusaoDialog">');
  FSlGeradora.Add('	    				<f:setPropertyActionListener target="#{pesquisa'+TFunc.PrimeiraLetraMaiscula(FTabelaClasse)+'Bean.'+LowerCase(FTabelaClasse)+'Selecionado}"');
  FSlGeradora.Add('	    					value="#{'+LowerCase(FTabelaClasse)+'}" />');
  FSlGeradora.Add('	    			</p:commandButton>');
  FSlGeradora.Add('	    		</p:column>');
  FSlGeradora.Add('	    	</p:dataTable>');
  FSlGeradora.Add('');
  FSlGeradora.Add('	    	<p:confirmDialog header="Exclusao de produto"');
  FSlGeradora.Add('	    		message="Tem certeza que deseja excluir o(a) '+LowerCase(FTabelaClasse)+' #{pesquisa'+TFunc.PrimeiraLetraMaiscula(FTabelaClasse)+'Bean.'+LowerCase(FTabelaClasse)+'Selecionado.id}?"');
  FSlGeradora.Add('	    		widgetVar="confirmacaoExclusao"	id="confirmacaoExclusaoDialog">');
  FSlGeradora.Add('	    		<p:button value="Nao" onclick="confirmacaoExclusao.hide(); return false;" />');
  FSlGeradora.Add('	    		<p:commandButton value="Sim" oncomplete="confirmacaoExclusao.hide();"');
  FSlGeradora.Add('	    			action="#{pesquisa'+TFunc.PrimeiraLetraMaiscula(FTabelaClasse)+'Bean.excluir}" process="@this"');
  FSlGeradora.Add('	    			update=":frmPesquisa:'+LowerCase(FTabelaClasse)+'sTable" />');
  FSlGeradora.Add('	    	</p:confirmDialog>');
  FSlGeradora.Add('    	</h:form>');
  FSlGeradora.Add('    </ui:define>');
  FSlGeradora.Add('</ui:composition>');
  CreateDir(FPath + '\' + LowerCase(FTabelaClasse)+'s');
  FSlGeradora.SaveToFile(FPath + '\' + LowerCase(FTabelaClasse)+ 's\Pesquisa' + FTabelaClasse +'s.xhtml');
end;
end.
