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
    function applyPedido: Boolean;
    procedure configureEvents;
    procedure fillMemTable;
    procedure fillClienteControls;
    procedure fillProdutoColumns(produto: TProduto);
    procedure fillProdutoControls(produto: TProduto);
    procedure ActionLoadPedidoExecute(Sender: TObject);
    procedure ActionSavePedidoExecute(Sender: TObject);
    procedure ActionNewPedidoExecute(Sender: TObject);
    procedure ActionCancelPedidoExecute(Sender: TObject);
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
      Append;
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

function TControllerPedidoVenda.applyPedido: Boolean;
begin
  pedido.Items := mountItensPedido;
  pedido.valorTotal := form.FDMemTableItensPedido.FieldByName
    ('totalPedido').Value;

  with dataModule do
  begin
    FDConnection1.StartTransaction;
    Result := insertEntity(pedido);

    if Result then
    begin
      pedido.numero := getLastId;

      for var item in pedido.Items do
      begin
        item.numPedido := pedido.numero;
        Result := insertEntity(item);
        if Not Result then
          break;
      end;
    end;

    if Result and FDConnection1.InTransaction then
      FDConnection1.Commit;
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
  with form.EditCodProduto do
  begin
    if ReadOnly then
      Exit;

    if Text = '' then
    begin
      form.cleanProdutoControls;
      Exit;
    end;

    importProduto(StrToInt64(Text));
  end;
end;

procedure TControllerPedidoVenda.FDMemTableItensPedidoAfterApplyUpdates
  (DataSet: TFDDataSet; AErrors: Integer);
begin
  if applyPedido then
    importPedido(pedido.numero);
end;

procedure TControllerPedidoVenda.fillClienteControls;
begin
  with form do
  begin
    EditCodCliente.Text := IntToStr(pedido.cliente.codigo);
    LabelNomeCliente.Caption := pedido.cliente.nome;
    PanelDadosCliente.Caption :=
      Format('%s/%s', [pedido.cliente.cidade, pedido.cliente.uf]);

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
      itemPedido.produto.codigo := FieldByName('codProduto').AsLargeInt;
      itemPedido.quantidade := FieldByName('quantidade').AsFloat;
      itemPedido.valorUnitario := FieldByName('vlrUnitario').AsCurrency;
      System.Insert(itemPedido, Result, Length(Result));
      Next;
    end;
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

  if form.FDMemTableItensPedido.State in dsEditModes then
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
  with dataModule do
  begin
    FDConnection1.StartTransaction;
    if dataModule.deleteEntity(pedido) then
    begin
      if FDConnection1.InTransaction then
        FDConnection1.Commit;
      form.isLoadingPedido := False;
      pedido.Free;
    end;
  end;
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
    if Not InputQuery('Pedido', Format('%sInforme número do pedido',
      [msgValidacao]), strNumero) then
      Exit;
    msgValidacao := 'Número inválido.' + chr(13);
  until (TryStrToInt64(Trim(strNumero), intNumero));

  importPedido(intNumero);
end;

end.
