unit controller;

interface

uses
  ViewPedidoVenda, ModelDataModule, System.Classes, PedidoEntity,
  ItemPedidoEntity, ClienteEntity, ProdutoEntity, SysUtils,
  Generics.Collections, Forms, Controls, Vcl.Dialogs, Data.DB,
  FireDAC.Comp.DataSet, System.UITypes;

type

  TControllerPedidoVenda = class(TObject)
  private
    pedido: TPedido;
    dataModule: TDataModulePedidoVenda;
    form: TFormPedidoVenda;
    regionalFormat: TFormatSettings;
    function mountItensPedido: TArray<TItemPedido>;
    function importCliente(codCliente: Int64): Boolean;
    function importPedido(const numero: Int64): Boolean;
    function importProduto(const codProduto: Int64): Boolean;
    procedure configureEvents;
    procedure fillMemTable;
    procedure applyPedido;
    procedure prepareEditItem;
    procedure fillClienteControls;
    procedure fillProdutoColumns(produto: TProduto);
    procedure fillProdutoControls(produto: TProduto);
    procedure ActionLoadPedidoExecute(Sender: TObject);
    procedure ActionSavePedidoExecute(Sender: TObject);
    procedure ActionNewPedidoExecute(Sender: TObject);
    procedure ActionCancelPedidoExecute(Sender: TObject);
    procedure ActionSaveItemExecute(Sender: TObject);
    procedure ActionUndoPedidoExecute(Sender: TObject);
    procedure EditCodProdutoExit(Sender: TObject);
    procedure FDMemTableItensPedidoAfterApplyUpdates(DataSet: TFDDataSet;
      AErrors: Integer);
  public
    constructor Create;
  end;

implementation

{ TControllerPedidoVenda }

procedure TControllerPedidoVenda.ActionNewPedidoExecute(Sender: TObject);
begin
  pedido := TPedido.Create;
  form.isInserting := importCliente(StrToInt64(form.EditCodCliente.Text));
end;

procedure TControllerPedidoVenda.ActionSaveItemExecute(Sender: TObject);
var
  values: TArray<Variant>;
begin
  form.savingItemReady(values);

  with form.FDMemTableItensPedido do
  begin
    if form.isEditingItem then
      Edit
    else
    begin
      Insert;
      FieldByName('codProduto').AsLargeInt := values[0];
      FieldByName('dscProduto').AsString := form.LabelDescricaoProduto.Caption;
    end;

    FieldByName('quantidade').AsFloat := values[1];
    FieldByName('vlrUnitario').AsCurrency := values[2];
    Post;
  end;

  form.isEditingItem := False;
end;

procedure TControllerPedidoVenda.ActionSavePedidoExecute(Sender: TObject);
begin
  form.FDMemTableItensPedido.ApplyUpdates;
end;

procedure TControllerPedidoVenda.ActionUndoPedidoExecute(Sender: TObject);
begin
  if (MessageDlg('Cancelar o pedido?', TMsgDlgType.mtConfirmation,
    [mbYes, mbNo], 0, mbNo) = mrNo) then
    Exit;

  form.isInserting := False;
  pedido.Free;
end;

procedure TControllerPedidoVenda.fillMemTable;
begin
  with form.FDMemTableItensPedido do
  begin
    Close;
    ReadOnly := False;
    CachedUpdates := False;
        Open;


    for var item in pedido.Items do
    begin
      Insert;
      fillProdutoColumns(item.produto);
      FieldByName('numPedido').AsLargeInt := item.numPedido;
      FieldByName('vlrUnitario').AsCurrency := item.valorUnitario;
      FieldByName('sequencial').AsLargeInt := item.sequence;
      FieldByName('quantidade').AsFloat := item.quantidade;
      Post;
    end;
    ReadOnly := True;
    First;
  end;
end;

procedure TControllerPedidoVenda.applyPedido;
begin
  pedido.Items := mountItensPedido;
  pedido.valorTotal := form.FDMemTableItensPedido.FieldByName
    ('totalPedido').Value;

  if dataModule.insertEntity(pedido) then
  begin
    pedido.numero := dataModule.getLastId;

    for var item in pedido.Items do
    begin
      item.numPedido := pedido.numero;
      dataModule.insertEntity(item);
    end;
  end;
end;

constructor TControllerPedidoVenda.Create;
begin
  Application.CreateForm(TFormPedidoVenda, form);
  Application.CreateForm(TDataModulePedidoVenda, dataModule);
  configureEvents;
end;

procedure TControllerPedidoVenda.EditCodProdutoExit(Sender: TObject);
begin
  if (Not form.isInserting) or form.isEditingItem then
    Exit;

  if form.EditCodProduto.Text = '' then
  begin
    form.cleanProdutoControls;
    Exit;
  end;

  importProduto(StrToInt64(form.EditCodProduto.Text));
end;

procedure TControllerPedidoVenda.FDMemTableItensPedidoAfterApplyUpdates
  (DataSet: TFDDataSet; AErrors: Integer);
begin
  applyPedido;
  importPedido(pedido.numero);
end;

procedure TControllerPedidoVenda.fillClienteControls;
begin
  with form do
  begin
    EditCodCliente.Text := IntToStr(pedido.cliente.codigo);
    LabelNomeCliente.Caption := pedido.cliente.nome;
    PanelDadosCliente.Caption := pedido.cliente.cidade + '/' +
      pedido.cliente.uf;

    if Trim(PanelDadosCliente.Caption) = '/' then
      PanelDadosCliente.Caption := '';
  end;
end;

procedure TControllerPedidoVenda.fillProdutoColumns(produto: TProduto);
begin
  with form.FDMemTableItensPedido do
  begin
    FieldByName('codProduto').AsLargeInt := produto.codigo;
    FieldByName('dscProduto').AsString := produto.descricao;
    FieldByName('vlrUnitario').AsCurrency := produto.valorVenda;
  end;
end;

procedure TControllerPedidoVenda.fillProdutoControls(produto: TProduto);
begin
  with form do
  begin
    EditVlrUnitario.Text := CurrToStr(produto.valorVenda, regionalFormat);
    LabelDescricaoProduto.Caption := produto.descricao;
  end;
end;

procedure TControllerPedidoVenda.configureEvents;
begin
  with form do
  begin
    FDMemTableItensPedido.AfterApplyUpdates :=
      FDMemTableItensPedidoAfterApplyUpdates;
    ActionLoadPedido.OnExecute := ActionLoadPedidoExecute;
    ActionCancelPedido.OnExecute := ActionCancelPedidoExecute;
    ActionNewPedido.OnExecute := ActionNewPedidoExecute;
    ActionSavePedido.OnExecute := ActionSavePedidoExecute;
    ActionSaveItem.OnExecute := ActionSaveItemExecute;
    ActionUndoPedido.OnExecute := ActionUndoPedidoExecute;
    EditCodProduto.OnExit := EditCodProdutoExit;
  end;
end;

function TControllerPedidoVenda.importCliente(codCliente: Int64): Boolean;
var
  cliente: TCliente;
begin
  Result := False;
  cliente := TCliente(dataModule.getEntityInstance(codCliente, TCliente));

  if cliente = nil then
  begin
    ShowMessage(Format('Cliente %d não encontrado', [codCliente]));
    Exit;
  end;

  pedido.cliente := TCliente.Create;
  pedido.cliente.Assign(cliente);
  fillClienteControls;
  Result := True;
end;

function TControllerPedidoVenda.mountItensPedido: TArray<TItemPedido>;
var
  itemPedido: TItemPedido;
begin
  Result := [];
  with form.FDMemTableItensPedido do
  begin
    First;
    while Not Eof do
    begin
      itemPedido := TItemPedido.Create;
      itemPedido.produto := TProduto.Create;
      itemPedido.produto.codigo := FieldByName('codProduto').AsLargeInt;
      itemPedido.quantidade := FieldByName('quantidade').AsFloat;
      itemPedido.valorUnitario := FieldByName('vlrUnitario').AsCurrency;
      Result := Result + [itemPedido];
      Next;
    end;
  end;
end;

procedure TControllerPedidoVenda.prepareEditItem;
begin
  with form do
  begin
    EditCodProduto.Text := FDMemTableItensPedido.FieldByName
      ('codProduto').AsString;
    EditQuantidade.Text :=
      FloatToStr(FDMemTableItensPedido.FieldByName('quantidade').AsFloat,
      regionalFormat);
    EditVlrUnitario.Text :=
      CurrToStr(FDMemTableItensPedido.FieldByName('vlrUnitario').AsCurrency,
      regionalFormat);
    LabelDescricaoProduto.Caption := FDMemTableItensPedido.FieldByName
      ('dscProduto').AsString;
    EditQuantidade.SetFocus;
    form.isEditingItem := True;
    adjustEnabling;
  end;
end;

function TControllerPedidoVenda.importPedido(const numero: Int64): Boolean;
var
  pedido: TPedido;
begin
  Result := False;
  pedido := TPedido(dataModule.getEntityInstance(numero, TPedido));
  form.isLoadingPedido := pedido <> nil;

  if Not form.isLoadingPedido then
  begin
    ShowMessage(Format('Pedido %d não encontrado', [numero]));
    Exit;
  end;

  Self.pedido := TPedido.Create;
  Self.pedido.Assign(pedido);
  fillClienteControls;
  fillMemTable;
  Result := True;
end;

function TControllerPedidoVenda.importProduto(const codProduto: Int64): Boolean;
var
  produto: TProduto;
begin
  Result := False;

  if codProduto = 0 then
    Exit;

  produto := TProduto(dataModule.getEntityInstance(codProduto, TProduto));

  if produto = nil then
  begin
    ShowMessage(Format('Produto %d não encontrado', [codProduto]));
    Exit;
  end;

  if form.FDMemTableItensPedido.State in [dsInsert, dsEdit] then
    fillProdutoColumns(produto)
  else
    fillProdutoControls(produto);

  Result := True;
end;

procedure TControllerPedidoVenda.ActionCancelPedidoExecute(Sender: TObject);
begin
  if Not form.isLoadingPedido then
    ActionLoadPedidoExecute(Sender);

  if (Not form.isLoadingPedido) or
    (MessageDlg('O pedido será excluído definitivamente. Confirma?',
    TMsgDlgType.mtConfirmation, [mbOK, mbCancel], 0, mbCancel) = mrCancel) then
    Exit;

  form.isLoadingPedido := Not dataModule.deleteEntity(pedido);

  if Not form.isLoadingPedido then
    pedido.Free;
end;

procedure TControllerPedidoVenda.ActionLoadPedidoExecute(Sender: TObject);
var
  msgValidacao: String;
  strNumero: String;
  intNumero: Int64;
begin
  msgValidacao := '';
  strNumero := '';

  repeat
    if Not InputQuery('Pedido', msgValidacao + 'Informe número do pedido',
      strNumero) then
      Exit;
    msgValidacao := 'Número inválido.' + chr(13);
  until (TryStrToInt64(Trim(strNumero), intNumero));

  importPedido(intNumero);
end;

end.
