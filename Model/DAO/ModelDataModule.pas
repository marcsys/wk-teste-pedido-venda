unit ModelDataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr, Variants,
  FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, EntityImplementation,
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
    function ExecuteUpdate(command: String; parameters: TEntityFillParameters;
      id: int64): Boolean;
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

function TDataModulePedidoVenda.ExecuteUpdate(command: String;
  parameters: TEntityFillParameters; id: int64): Boolean;
begin
  Result := False;
  with FDCommand1 do
  begin
    CommandText.Text := command;
    fillParameters(parameters);

    if FindParam('id') <> nil then
      ParamByName('id').AsLargeInt := id;

    Execute;
    Result := RowsAffected > 0;
  end;
end;

procedure TDataModulePedidoVenda.fillParameters(params: TEntityFillParameters);
var
  Param: TEntityFillParameter;
begin
  for Param in params do
  begin
    FDCommand1.ParamByName(Param.Key).Value := Param.Value;
  end;
end;

function TDataModulePedidoVenda.getEntityInstance(const id: int64;
  const entityClass: TClass): TEntityCrud;
var
  i: Integer;
  statement: String;
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
        for i := 0 to definitions.Rows.Count - 1 do
        begin
          instance.fill(definitions.Rows[i]);
        end;
      finally
        definitions.Free;
      end;
      NextRecordSet;
    until State = TFDPhysCommandState.csPrepared;
    CloseAll;
  end;

  if instance.getId = 0 then
    Exit;

  Result := instance;
end;

function TDataModulePedidoVenda.getLastId: Variant;
begin
  with FDConnection1 do
  begin
    Result := ExecSQLScalar('SELECT LAST_INSERT_ID()');
  end;
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
