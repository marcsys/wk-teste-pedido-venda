unit ClienteEntity;

interface

uses
  EntityImplementation, Generics.Collections, FireDAC.DatS;

type
  TCliente = class(TEntityCrud)
  private
    function getCodigo: int64;
    function getNome: String;
    function getCidade: String;
    function getUf: String;
    procedure setCodigo(value: int64);
    procedure setNome(value: String);
    procedure setCidade(value: String);
    procedure setUf(value: String);
  protected
    _codigo: int64;
    _nome: String;
    _cidade: String;
    _uf: String;
  public
    property codigo: int64 read getCodigo write setCodigo;
    property nome: String read getNome write setNome;
    property cidade: String read getCidade write setCidade;
    property uf: String read getUf write setUf;
    function getTableName: String; override;
    function getIdName: String; override;
    function getId: Int64; override;
    procedure fill(row: TFDDatSRow); override;
  end;

implementation
uses
  SysUtils;

{ TCliente }

procedure TCliente.fill(row: TFDDatSRow);
begin
  _codigo := row.GetData('cod_cliente');
  _nome := row.GetData('nome_cliente');
  _cidade := row.GetData('cidade_cliente');
  _uf := row.GetData('uf_cliente');
end;

function TCliente.getCidade: String;
begin
  Result := _cidade;
end;

function TCliente.getCodigo: int64;
begin
  Result := _codigo;
end;

function TCliente.getId: Int64;
begin
  Result := _codigo;
end;

function TCliente.getIdName: String;
begin
  Result := 'cod_cliente';
end;

function TCliente.getNome: String;
begin
  Result := _nome;
end;

function TCliente.getTableName: String;
begin
  Result := 'cliente';
end;

function TCliente.getUf: String;
begin
  Result := _uf;
end;

procedure TCliente.setCidade(value: String);
begin
  _cidade := value;
end;

procedure TCliente.setCodigo(value: int64);
begin
  _codigo := value;
end;

procedure TCliente.setNome(value: String);
begin
  _nome := value;
end;

procedure TCliente.setUf(value: String);
begin
  _uf := value;
end;

end.
