unit ProdutoEntity;

interface
uses
  SysUtils, FireDAC.DatS, EntityImplementation;

type
  TProduto = class(TEntityCrud)
  private
    function getCodigo: int64;
    function getDescricao: String;
    function getValorVenda: Currency;
    procedure setCodigo(const Value: int64);
    procedure setDescricao(const Value: String);
    procedure setValorVenda(const Value: Currency);
  protected
    _codigo: int64;
    _descricao: String;
    _valorVenda: Currency;
  public
    property codigo: int64 read getCodigo write setCodigo;
    property descricao: String read getDescricao write setDescricao;
    property valorVenda: Currency read getValorVenda write setValorVenda;
    function getTableName: String; override;
    function getIdName: String; override;
    function getId: int64; override;
    procedure fill(row: TFDDatSRow); override;
  end;

implementation

{ TProduto }

procedure TProduto.fill(row: TFDDatSRow);
begin
  inherited;

  with row do
  begin
    _codigo := GetData('cod_produto');
    _descricao := GetData('desc_produto');
    _valorVenda := GetData('preco_venda');
  end;
end;

function TProduto.getCodigo: int64;
begin
  Result := _codigo;
end;

function TProduto.getDescricao: String;
begin
  Result := _descricao;
end;

function TProduto.getId: int64;
begin
  Result := _codigo;
end;

function TProduto.getIdName: String;
begin
  Result := 'cod_produto';
end;

function TProduto.getTableName: String;
begin
  Result := 'produto';
end;

function TProduto.getValorVenda: Currency;
begin
  Result := _valorVenda;
end;

procedure TProduto.setCodigo(const Value: int64);
begin
  _codigo := Value;
end;

procedure TProduto.setDescricao(const Value: String);
begin
  _descricao := Value;
end;

procedure TProduto.setValorVenda(const Value: Currency);
begin
  _valorVenda := Value;
end;

end.
