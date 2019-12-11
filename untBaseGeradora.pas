unit untBaseGeradora;

interface

uses
  System.Classes,
  Datasnap.DBClient,
  System.Generics.collections;

  type
  TTabelasFilhas = Class(TComponent)
  private
    FNome: String;
  public
    property Nome: String read FNome write FNome;
  end;

  IGeradora = interface
  ['{3B882C19-B333-441A-95C4-13A18DDF9251}']
    function getClientDataSet: TClientDataSet;
    function getPacote: String;
    function getPath: String;
    function getSlGeradora: TStringList;
    function getTabela: String;
    function getTabelaClasse: String;
    function getTabelasFilhas: TList<TTabelasFilhas>;
    function getTabelasPais: TList<String>;

    procedure setClientDataSet(const Value: TClientDataSet);
    procedure setPacote(const Value: String);
    procedure setPath(const Value: String);
    procedure setSlGeradora(const Value: TStringList);
    procedure setTabela(const Value: String);
    procedure setTabelaClasse(const Value: String);
    procedure setTabelasFilhas(const Value: TList<TTabelasFilhas>);
    procedure setTabelasPais(const Value: TList<String>);

    property Pacote: String read getPacote write setPacote;
    property Tabela: String read getTabela write setTabela;
    property TabelaClasse: String read getTabelaClasse write setTabelaClasse;
    property ClientDataSet: TClientDataSet read getClientDataSet write setClientDataSet;
    property SlGeradora: TStringList read getSlGeradora write setSlGeradora;
    property Path: String read getPath write setPath;
    property tabelasFilhas: TList<TTabelasFilhas> read getTabelasFilhas write setTabelasFilhas;
    property tabelasPais: TList<String> read getTabelasPais write setTabelasPais;
    procedure gerarArquivo;
  end;
  implementation

  initialization
end.
