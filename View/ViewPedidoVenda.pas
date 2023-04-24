unit ViewPedidoVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls, Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.XPStyleActnCtrls, Vcl.StdCtrls,
  Vcl.Mask, Vcl.Buttons, Data.DB, Vcl.DBCtrls, Vcl.DBGrids, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.RegularExpressions,
  System.Classes, Vcl.Graphics, UITypes;

type
  TFormPedidoVenda = class(TForm)
    ActionManager1: TActionManager;
    ActionLoadPedido: TAction;
    ActionCancelPedido: TAction;
    ActionNewPedido: TAction;
    ActionSavePedido: TAction;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    FlowPanelRodape: TFlowPanel;
    FlowPanelVlrTotal: TFlowPanel;
    ActionSaveItem: TAction;
    DataSourceMemItensPedido: TDataSource;
    FDMemTableItensPedido: TFDMemTable;
    memSequencial: TIntegerField;
    memCodProduto: TLargeintField;
    memDscProduto: TStringField;
    memVlrUnitario: TCurrencyField;
    memQuantidade: TFloatField;
    GridPanelCliente: TGridPanel;
    FlowPanelCodCliente: TFlowPanel;
    LabelCodCliente: TLabel;
    EditCodCliente: TEdit;
    PanelDadosCliente: TPanel;
    LabelNomeCliente: TLabel;
    FlowPanelDadosItemPedido: TFlowPanel;
    LabelQuantidade: TLabel;
    LabelVlrUnitario: TLabel;
    BitBtnAdicionaItem: TBitBtn;
    GridPanelActionsPedido: TGridPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    ActionUndoPedido: TAction;
    EditCodProduto: TEdit;
    EditQuantidade: TEdit;
    EditVlrUnitario: TEdit;
    LabelDescricaoProduto: TLabel;
    memTotalPedido: TAggregateField;
    DBTextTotalPedido: TDBText;
    memVlrTotal: TCurrencyField;
    ActionGoToGrid: TAction;
    FlowPanelNumPedido: TFlowPanel;
    DBTextNumPedido: TDBText;
    memNumPedido: TLargeintField;
    ActionEditItem: TAction;
    ActionDeleteItem: TAction;
    procedure FDMemTableItensPedidoCalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure EditQuantidadeChange(Sender: TObject);
    procedure ActionGoToGridExecute(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
    procedure ActionDeleteItemExecute(Sender: TObject);
    procedure ActionEditItemExecute(Sender: TObject);
    procedure EditCodClienteChange(Sender: TObject);
  private
    regionalFormat: TFormatSettings;
    decimalRegEx: TRegEx;
    digitsRegex: TRegEx;
    function onlyDecimalReplace(value: String; toCurrency: Boolean): String;
    function getEditingItem: Boolean;
    function getInserting: Boolean;
    function getLoadingPedido: Boolean;
    procedure setEditingItem(const value: Boolean);
    procedure setInserting(const value: Boolean);
    procedure setLoadingPedido(const value: Boolean);
    procedure prepareEditing;
    procedure prepareInserting;
  protected
    _inserting: Boolean;
    _loadingPedido: Boolean;
    _editingItem: Boolean;
  public
    property isEditingitem: Boolean read getEditingItem write setEditingItem;
    property isInserting: Boolean read getInserting write setInserting;
    property isLoadingPedido: Boolean read getLoadingPedido
      write setLoadingPedido;
    function savingItemReady(out values: TArray<Variant>): Boolean;
    procedure adjustEnabling;
    procedure cleanClienteControls;
    procedure cleanProdutoControls;
    procedure resetForm;
  end;

var
  FormPedidoVenda: TFormPedidoVenda;

implementation

{$R *.dfm}

procedure TFormPedidoVenda.ActionDeleteItemExecute(Sender: TObject);
begin
  if MessageDlg('Excluir item do pedido?', TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], -1) = mrNo then
    Exit;

  FDMemTableItensPedido.Delete;
  DBGrid1Enter(Sender);
end;

procedure TFormPedidoVenda.ActionEditItemExecute(Sender: TObject);
begin
  isEditingitem := True;
end;

procedure TFormPedidoVenda.ActionGoToGridExecute(Sender: TObject);
begin
  DBGrid1.SetFocus;
end;

procedure TFormPedidoVenda.adjustEnabling;
var
  foo: TArray<Variant>;
begin
  ActionGoToGrid.Enabled := (_inserting or _loadingPedido) and
    (ActiveControl <> DBGrid1);
  ActionEditItem.Enabled := _inserting and (ActiveControl = DBGrid1) and
    (FDMemTableItensPedido.RecordCount > 0);
  ActionDeleteItem.Enabled := _inserting and (ActiveControl = DBGrid1) and
    (FDMemTableItensPedido.RecordCount > 0);
  ActionLoadPedido.Enabled := Not _inserting;
  ActionCancelPedido.Enabled := Not _inserting;
  ActionSavePedido.Enabled := _inserting;
  ActionUndoPedido.Enabled := _inserting;
  ActionNewPedido.Enabled := (EditCodCliente.Text <> '') and Not _inserting;
  EditCodProduto.ReadOnly := _editingItem = _inserting;
  EditQuantidade.ReadOnly := Not _inserting;
  EditVlrUnitario.ReadOnly := Not _inserting;
  DBGrid1.ReadOnly := Not _inserting;
  ActionSaveItem.Enabled := savingItemReady(foo);
end;

procedure TFormPedidoVenda.cleanClienteControls;
begin
  EditCodCliente.Clear;
  LabelNomeCliente.Caption := '';
  PanelDadosCliente.Caption := '';
end;

procedure TFormPedidoVenda.cleanProdutoControls;
begin
  EditCodProduto.Clear;
  EditQuantidade.Clear;
  EditVlrUnitario.Clear;
  LabelDescricaoProduto.Caption := '';
end;

procedure TFormPedidoVenda.DBGrid1Enter(Sender: TObject);
begin
  ActionGoToGrid.Enabled := False;
  ActionEditItem.Enabled := _inserting and (FDMemTableItensPedido.RecordCount > 0);
  ActionDeleteItem.Enabled := _inserting and (FDMemTableItensPedido.RecordCount > 0);
end;

procedure TFormPedidoVenda.DBGrid1Exit(Sender: TObject);
begin
  ActionGoToGrid.Enabled := True;
  ActionEditItem.Enabled := False;
  ActionDeleteItem.Enabled := False;
end;

procedure TFormPedidoVenda.EditCodClienteChange(Sender: TObject);
begin
  ActionNewPedido.Enabled := EditCodCliente.Text <> '';
end;

procedure TFormPedidoVenda.EditQuantidadeChange(Sender: TObject);
var
  foo: TArray<Variant>;
  edit: TEdit;
begin
  edit := TEdit(Sender);
  edit.Text := onlyDecimalReplace(edit.Text, (edit.Tag = 1));
  ActionSaveItem.Enabled := savingItemReady(foo);
end;

procedure TFormPedidoVenda.FDMemTableItensPedidoCalcFields(DataSet: TDataSet);
begin
  memVlrTotal.value := memVlrUnitario.value * memQuantidade.value;
end;

procedure TFormPedidoVenda.FormCreate(Sender: TObject);
begin
  _inserting := False;
  _editingItem := False;
  _loadingPedido := False;
  decimalRegEx := TRegEx.Create('[^0-9,]', [roCompiled]);
  digitsRegex := TRegEx.Create('\D', [roCompiled]);
  regionalFormat := TFormatSettings.Create('pt-BR');
  adjustEnabling;
end;

function TFormPedidoVenda.getEditingItem: Boolean;
begin
  Result := _editingItem;
end;

function TFormPedidoVenda.getInserting: Boolean;
begin
  Result := _inserting;
end;

function TFormPedidoVenda.getLoadingPedido: Boolean;
begin
  Result := _loadingPedido;
end;

function TFormPedidoVenda.onlyDecimalReplace(value: String;
  toCurrency: Boolean): String;
var
  commaPos: Integer;
begin
  Result := decimalRegEx.Replace(value, '');
  commaPos := Pos(',', Result);

  if commaPos = 0 then
    Exit;

  if commaPos = 1 then
  begin
    Result := '0' + Result;
    commaPos := commaPos + 1;
  end;

  Result := Copy(Result, 1, commaPos) + digitsRegex.Replace
    (Copy(Result, commaPos + 1, Length(Result)), '');

  if toCurrency and ((Length(Result) - commaPos) > 2) then
    Result := Copy(Result, 1, commaPos + 2);
end;

procedure TFormPedidoVenda.prepareEditing;
begin
  EditCodProduto.Text := memCodProduto.AsString;
  EditQuantidade.Text := memQuantidade.AsString;
  EditVlrUnitario.Text := memVlrUnitario.AsString;
  LabelDescricaoProduto.Caption := memDscProduto.AsString;
  EditQuantidade.SetFocus;
end;

procedure TFormPedidoVenda.prepareInserting;
begin
  EditCodProduto.SetFocus;
  with FDMemTableItensPedido do
  begin
    Close;
    ReadOnly := False;
    CachedUpdates := True;
    Open;
  end;
end;

procedure TFormPedidoVenda.resetForm;
begin
  FDMemTableItensPedido.Close;
  EditCodCliente.SetFocus;
  cleanClienteControls;
  cleanProdutoControls;
end;

function TFormPedidoVenda.savingItemReady(out values: TArray<Variant>): Boolean;
var
  codProduto: Int64;
  quantidade: Double;
  vlrUnitario: Currency;
begin
  Result := False;

  if Not _inserting then
    Exit;

  if Not(TryStrToInt64(EditCodProduto.Text, codProduto) and (codProduto > 0))
  then
    Exit;

  if Not(TryStrToFloat(EditQuantidade.Text, quantidade, regionalFormat) and
    (quantidade > 0)) then
    Exit;

  if Not(TryStrToCurr(EditVlrUnitario.Text, vlrUnitario, regionalFormat) and
    (vlrUnitario > 0)) then
    Exit;

  Result := True;
  values := [codProduto, quantidade, vlrUnitario];
end;

procedure TFormPedidoVenda.setEditingItem(const value: Boolean);
begin
  if value then
  begin
    _inserting := True;
    _loadingPedido := False;
    if Not _editingItem then
      prepareEditing;
  end
  else
  begin
    cleanProdutoControls;
    if _editingItem then
      DBGrid1.SetFocus
    else
      EditCodProduto.SetFocus;
  end;

  _editingItem := value;
  adjustEnabling;
end;

procedure TFormPedidoVenda.setInserting(const value: Boolean);
begin
  if value then
  begin
    _loadingPedido := False;
    if Not _inserting then
      prepareInserting;
  end
  else
    resetForm;

  _inserting := value;
  _editingItem := False;
  adjustEnabling;
end;

procedure TFormPedidoVenda.setLoadingPedido(const value: Boolean);
begin

  if value then
  begin
    _editingItem := False;
    _inserting := False;
    DBGrid1.SetFocus;
  end
  else if _loadingPedido then
    resetForm;

  _loadingPedido := value;
  adjustEnabling;
end;

end.
