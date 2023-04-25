unit ModelDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr, Variants,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, EntityImplementation, Dialogs,
  Generics.Collections, EntityFactory;

type
  TDataModulePedidoVenda = class(TDataModule)
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;
    FDCommand1: TFDCommand;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure fillParameters(params: TEntityFillParameters);
    function ExecuteUpdate(const command: String;
      const parameters: TEntityFillParameters; const id: int64): Boolean;
  public
    function getEntityInstance(const id: int64; const entityClass: TClass)
      : TEntityCrud;
    function insertEntity(instance: TEntityCrud): Boolean;
    function updateEntity(instance: TEntityCrud): Boolean;
    function deleteEntity(instance: TEntityCrud): Boolean;
    function getLastId: Variant;
  end;

var
  DataModulePedidoVenda: TDataModulePedidoVenda;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TDataModulePedidoVenda }

procedure TDataModulePedidoVenda.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Open;
end;

procedure TDataModulePedidoVenda.DataModuleDestroy(Sender: TObject);
begin
  FDConnection1.Close;
end;

function TDataModulePedidoVenda.deleteEntity(instance: TEntityCrud): Boolean;
begin
  Result := ExecuteUpdate(instance.getDelete, TEntityFillParameters.Create,
    instance.getId);
end;

function TDataModulePedidoVenda.ExecuteUpdate(const command: String;
  const parameters: TEntityFillParameters; const id: int64): Boolean;
begin
  Result := False;
  try
    with FDCommand1 do
    begin
      CommandText.Text := command;
      fillParameters(parameters);

      if FindParam('id') <> nil then
        ParamByName('id').AsLargeInt := id;

      Execute;

      if RowsAffected = 0 then
        raise Exception.Create('A operação não surtiu o efeito esperado.');

      Result := True;
    end;
  except
    on E: Exception do
    begin
      ShowMessageFmt('Erro inesperado processando a operação:%s%s',
        [Chr(13), E.Message]);
      if FDConnection1.InTransaction then
        FDConnection1.Rollback;
    end;
  end;
end;

procedure TDataModulePedidoVenda.fillParameters(params: TEntityFillParameters);
begin
  for var Param in params do
    FDCommand1.ParamByName(Param.Key).Value := Param.Value;
end;

function TDataModulePedidoVenda.getEntityInstance(const id: int64;
  const entityClass: TClass): TEntityCrud;
var
  i: Integer;
  definitions: TFDDatSTable;
  instance: TEntityCrud;
begin
  instance := TEntityFactory.getInstance(entityClass);
  Result := nil;

  with FDCommand1 do
  begin
    CommandText.Text := instance.getSelect;
    ParamByName('id').AsLargeInt := id;
    Open;
    repeat
      definitions := Define;
      try
        Fetch(definitions);
        for i := 0 to Pred(definitions.Rows.Count) do
          instance.fill(definitions.Rows[i]);
      finally
        definitions.Free;
      end;
      NextRecordSet;
    until State = TFDPhysCommandState.csPrepared;
    CloseAll;
  end;

  if instance.getId > 0 then
    Result := instance;
end;

function TDataModulePedidoVenda.getLastId: Variant;
begin
  Result := FDConnection1.ExecSQLScalar('SELECT LAST_INSERT_ID()');
end;

function TDataModulePedidoVenda.insertEntity(instance: TEntityCrud): Boolean;
begin
  Result := ExecuteUpdate(instance.getInsert, instance.getConsiderAtInsert, -1);
end;

function TDataModulePedidoVenda.updateEntity(instance: TEntityCrud): Boolean;
begin
  Result := ExecuteUpdate(instance.getUpdate, instance.getConsiderAtUpdate,
    instance.getId);
end;

end.
