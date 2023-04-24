unit ItemPedidoEntity;

interface

uses
  ProdutoEntity, EntityImplementation, SysUtils, Generics.Collections,
  FireDAC.DatS;

type
  TItemPedido = class(TEntityCrud)
  private
    function getNumPedido: int64;
    function getProduto: TProduto;
    function getQuantidade: Double;
    function getSequence: int64;
    function getValorUnitario: Currency;
    function getValotTotal: Currency;
    procedure setNumPedido(const Value: int64);
    procedure setProduto(const Value: TProduto);
    procedure setQuantidade(const Value: Double);
    procedure setSequence(const Value: int64);
    procedure setValorUnitario(const Value: Currency);
  protected
    _numPedido: int64;
    _produto: TProduto;
    _quantidade: Double;
    _sequence: int64;
    _valorUnitario: Currency;
  public
    constructor Create; override;
    property sequence: int64 read getSequence write setSequence;
    property numPedido: int64 read getNumPedido write setNumPedido;
    property produto: TProduto read getProduto write setProduto;
    property quantidade: Double read getQuantidade write setQuantidade;
    property valorUnitario: Currency read getValorUnitario
      write setValorUnitario;
    property valorTotal: Currency read getValotTotal;
    function getId: int64; override;
    function getTableName: String; override;
    function getIdName: String; override;
    function getConsiderAtInsert: TEntityFillParameters; override;
    procedure fill(row: TFDDatSRow); override;
  end;

implementation

{ TItemPedido }

constructor TItemPedido.Create;
begin
  inherited;
  _produto := TProduto.Create;
end;

procedure TItemPedido.fill(row: TFDDatSRow);
begin
  inherited;

  _sequence := row.GetData('seq_item_pedido');
  _numPedido := row.GetData('num_pedido');
  _quantidade := row.GetData('quantidade');
  _valorUnitario := row.GetData('valor_unitario');
  _produto := TProduto.Create;
  _produto.fill(row);
end;

function TItemPedido.getConsiderAtInsert: TEntityFillParameters;
begin
  Result := inherited getConsiderAtInsert;
  Result.add('num_pedido', _numPedido);
  Result.add('cod_produto', _produto.codigo);
  Result.add('quantidade', _quantidade);
  Result.add('valor_unitario', _valorUnitario);
end;

function TItemPedido.getId: int64;
begin
  Result := _sequence
end;

function TItemPedido.getIdName: String;
begin
  Result := 'seq_item_pedido';
end;

function TItemPedido.getNumPedido: int64;
begin
  Result := _numPedido;
end;

function TItemPedido.getProduto: TProduto;
begin
  Result := _produto;
end;

function TItemPedido.getQuantidade: Double;
begin
  Result := _quantidade;
end;

function TItemPedido.getSequence: int64;
begin
  Result := _sequence;
end;

function TItemPedido.getTableName: String;
begin
  Result := 'item_pedido';
end;

function TItemPedido.getValorUnitario: Currency;
begin
  Result := _valorUnitario;
end;

function TItemPedido.getValotTotal: Currency;
begin
  Result := _valorUnitario * _quantidade;
end;

procedure TItemPedido.setNumPedido(const Value: int64);
begin
  _numPedido := Value;
end;

procedure TItemPedido.setProduto(const Value: TProduto);
begin
  _produto := Value;
end;

procedure TItemPedido.setQuantidade(const Value: Double);
begin
  _quantidade := Value;
end;

procedure TItemPedido.setSequence(const Value: int64);
begin
  _sequence := Value;
end;

procedure TItemPedido.setValorUnitario(const Value: Currency);
begin
  _valorUnitario := Value;
end;

end.
