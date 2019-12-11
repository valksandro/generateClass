unit DataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB,
  Data.FMTBcd, Datasnap.Provider, Datasnap.DBClient, Data.Win.ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DBXMySQL, Data.SqlExpr;

type
  TDMPrincipal = class(TDataModule)
    SQLConnection1: TFDConnection;
    FDConnection1: TFDConnection;
    SQLConnection: TFDConnection;
    SQLConnection2: TSQLConnection;
  private

    { Private declarations }
  public
    PassWord:String;
    DataBase:String;
    UserName:String;
    Server:String;
    procedure confgConection;
    { Public declarations }
  end;

var
  DMPrincipal: TDMPrincipal;

implementation



{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
procedure TDMPrincipal.confgConection;
begin
  SQLConnection.Close;
  with SQLConnection do begin
   Params.Add('Database='+DataBase);
   Params.Add('User_Name='+UserName);
   Params.Add('Server='+Server);
   Params.Add('Password='+PassWord);
   Connected := True;
  end;
end;

end.
