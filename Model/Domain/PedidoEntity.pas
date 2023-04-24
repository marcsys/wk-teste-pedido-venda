unit PedidoEntity;

interface

uses
  EntityImplementation, ClienteEntity, ItemPedidoEntity, Generics.Collections,
  FireDAC.DatS;

type

  TPedido = class(TEntityCrud)
  private

    function getCliente: TCliente;
    function getDataEmissao: TDateTime;
    function getNumero: int64;
    function getValorTotal: Currency;
    procedure setCliente(const Value: TCliente);
    procedure setDataEmissao(const Value: TDateTime);
    procedure setNumero(const Value: int64);
    procedure setValorTotal(const Value: Currency);
    function getItems: TArray<TItemPedido>;
    procedure setItems(const Value: TArray<TItemPedido>);
  protected
    _cliente: TCliente;
    _dataEmissao: TDateTime;
    _numero: int64;
    _valorTotal: Currency;
    _items: TArray<TItemPedido>;
  public
    constructor Create; override;
    property numero: int64 read getNumero write setNumero;
    property cliente: TCliente read getCliente write setCliente;
    property dataEmissao: TDateTime read getDataEmissao write setDataEmissao;
    property valorTotal: Currency read getValorTotal write setValorTotal;
    property Items: TArray<TItemPedido> read getItems write setItems;
    function getId: int64; override;
    function getTableName: String; override;
    function getIdName: String; override;
    function getConsiderAtInsert: TEntityFillParameters; override;
    function getSelect: String; override;
    procedure fill(row: TFDDatSRow); override;
  end;

implementation

uses
  SysUtils;

{ TPedido }

constructor TPedido.Create;
begin
  inherited;
  _cliente := TCliente.Create;
  _items := [];
end;

procedure TPedido.fill(row: TFDDatSRow);
begin
  inherited;

  if row.GetData('entity') = 'ITEM_PEDIDO' then
  begin
    var
    item := TItemPedido.Create;
    item.fill(row);
    Insert(item, _items, Length(_items));
  end
  else
  begin
    _numero := row.GetData('num_pedido');
    _dataEmissao := row.GetData('data_emissao');
    _valorTotal := row.GetData('valor_total');
    _cliente := TCliente.Create;
    _cliente.fill(row);
  end;
end;

function TPedido.getCliente: TCliente;
begin
  Result := _cliente;
end;

function TPedido.getConsiderAtInsert: TEntityFillParameters;
begin
  Result := inherited getConsiderAtInsert;
  Result.Add('cod_cliente', _cliente.codigo);
  Result.Add('valor_total', _valorTotal);
end;

function TPedido.getDataEmissao: TDateTime;
begin
  Result := _dataEmissao;
end;

function TPedido.getId: int64;
begin
  Result := _numero;
end;

function TPedido.getIdName: String;
begin
  Result := 'num_pedido';
end;

function TPedido.getItems: TArray<TItemPedido>;
begin
  Result := _items;
end;

function TPedido.getNumero: int64;
begin
  Result := _numero;
end;

function TPedido.getSelect: String;
begin
  var
  buffer := TStringBuilder.Create;
  buffer.Append('SELECT ''PEDIDO'' AS entity, ').Append('pedi.*, ')
    .Append('clie.nome_cliente, ').Append('clie.cidade_cliente, ')
    .Append('clie.uf_cliente ').Append('FROM ').Append('pedido pedi ')
    .Append('INNER JOIN cliente clie ')
    .Append('ON clie.cod_cliente = pedi.cod_cliente ')
    .Append('WHERE pedi.num_pedido = :id').Append(';')
    .Append('SELECT ''ITEM_PEDIDO'' AS entity, ').Append('itpd.*, ')
    .Append('prod.desc_produto, ').Append('prod.preco_venda ').Append('FROM ')
    .Append('item_pedido itpd ').Append('INNER JOIN produto prod ')
    .Append('ON prod.cod_produto = itpd.cod_produto ')
    .Append('WHERE itpd.num_pedido = :id');
  Result := buffer.ToString;
end;

function TPedido.getTableName: String;
begin
  Result := 'pedido';
end;

function TPedido.getValorTotal: Currency;
begin
  Result := _valorTotal;
end;

procedure TPedido.setCliente(const Value: TCliente);
begin
  _cliente := Value;
end;

procedure TPedido.setDataEmissao(const Value: TDateTime);
begin
  _dataEmissao := Value;
end;

procedure TPedido.setItems(const Value: TArray<TItemPedido>);
begin
  _items := Value;
end;

procedure TPedido.setNumero(const Value: int64);
begin
  _numero := Value;
end;

procedure TPedido.setValorTotal(const Value: Currency);
begin
  _valorTotal := Value;
end;

end.
