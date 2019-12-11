unit untFuncoes;

interface
  uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, DB, Mask, DBCtrls, Provider, DBClient,
  ADODB, ComCtrls;

type
  TFunc = Class
  private

    { Private declarations }
  public
    class function isNullable(val1: String): String; static;
    class function PrimeiraLetraMaiscula(Str: string): string; static;
    class function ifthen(clausula: boolean; val1, val2: String): String; static;
    class function retornaTipo(tipo: String): String;
    class function retornaTipoBase(tipo: String): String; static;
    class function PrimeiraLetraMinuscula(Str: string): string; static;
    { Public declarations }
  end;

implementation

class function TFunc.PrimeiraLetraMaiscula(Str: string): string;
var
  i: integer;
  esp: boolean;
begin
  for i := 1 to Length(str) do
  begin
    if i = 1 then
      str[i] := UpCase(str[i])
    else
      begin
        if i <> Length(str) then
        begin
          esp := (str[i] = ' ');
          if esp then
            str[i+1] := UpCase(str[i+1]);
        end;
      end;
  end;
  Result := Str;
end;


class function TFunc.PrimeiraLetraMinuscula(Str: string): string;
var
  i: integer;
  esp: boolean;
  st, st2: string;
begin
  for i := 1 to Length(str) do
  begin
    if i = 1 then begin
      st := LowerCase(str[i]);
    end else
      begin
         st2 := st2 + str[i];
      end;
  end;
  Result := st + st2;
end;

class function Tfunc.ifthen(clausula:boolean; val1:String; val2:String):String;
begin
  if clausula then
    result := val1
  else
    result := val2;
end;

class function Tfunc.isNullable(val1:String):String;
begin
  if UpperCase(val1) = 'YES' then
    result := 'true'
  else
    result := 'false';
end;

class function Tfunc.retornaTipo(tipo: String): String;
begin
  //int, bigint ou smallint
  if (Pos('int', tipo) > 0)
  or (Pos('serial', tipo) > 0)then
  begin
    result := 'int';
  end;

  if (Pos('double', tipo) > 0)
  or (Pos('money', tipo) > 0)
  or (Pos('number', tipo) > 0)
  or (Pos('numeric', tipo) > 0)
  or (Pos('decimal', tipo) > 0)
  or (Pos('real', tipo) > 0) then
  begin
    result := 'double';
  end;


    //char , character ou character variant
  if (Pos('char', tipo) > 0)
  or (Pos('text', tipo)> 0)
  or (Pos('long', tipo)> 0)
  or (Pos('tring', tipo)> 0)
  or (Pos('blob', tipo)> 0) then
  begin
    result := 'String';
  end;

  //boolean
  if (Pos('bool', tipo) > 0)
  or (Pos('bit', tipo) > 0) then
  begin
    result := 'bool';
  end;

  //date
  if Pos('date', tipo) > 0 then
  begin
    result := 'TDate';
  end;
end;

class function Tfunc.retornaTipoBase(tipo: String): String;
begin
  //int, bigint ou smallint
  if (Pos('int', tipo) > 0)
  or (Pos('serial', tipo) > 0)then
  begin
    result := 'INTEGER';
  end;

  if (Pos('double', tipo) > 0)
  or (Pos('money', tipo) > 0)
  or (Pos('number', tipo) > 0)
  or (Pos('numeric', tipo) > 0)
  or (Pos('decimal', tipo) > 0)
  or (Pos('real', tipo) > 0) then
  begin
    result := 'REAL';
  end;


    //char , character ou character variant
  if (Pos('char', tipo) > 0)
  or (Pos('text', tipo)> 0)
  or (Pos('long', tipo)> 0)
  or (Pos('tring', tipo)> 0)
  or (Pos('blob', tipo)> 0) then
  begin
    result := 'TEXT';
  end;

  //boolean
  if (Pos('bool', tipo) > 0)
  or (Pos('bit', tipo) > 0) then
  begin
    result := 'TEXT';
  end;

  //date
  if Pos('date', tipo) > 0 then
  begin
    result := 'TEXT';
  end;
end;



end.
