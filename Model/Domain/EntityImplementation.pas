unit EntityImplementation;

interface

uses
  Generics.Collections, FireDAC.DatS, Classes;

type
  TEntityFillParameters = TDictionary<String, Variant>;
  TEntityFillParameter = TPair<String, Variant>;

  TEntityCrud = class abstract(TPersistent)

  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create; virtual;
    function getId: int64; virtual; abstract;
    function getTableName: String; virtual; abstract;
    function getIdName: String; virtual; abstract;
    function getConsiderAtInsert: TEntityFillParameters; virtual;
    function getConsiderAtUpdate: TEntityFillParameters; virtual;
    function getSelect: String; virtual;
    function getInsert: String; virtual;
    function getUpdate: String; virtual;
    function getDelete: String; virtual;
    procedure fill(row: TFDDatSRow); virtual; abstract;

  end;

implementation

uses ModelDataModule, Rtti;

{ TEntityCrud }

procedure TEntityCrud.AssignTo(Dest: TPersistent);
var
  ctx: TRttiContext;
  tpe: TRttiType;
  vle: TValue;
begin
  if Dest.ClassType <> Self.ClassType then
    inherited;

  ctx := TRttiContext.Create;
  tpe := ctx.GetType(Self.ClassType);
  for var propty in tpe.GetProperties do
  begin
    if propty.IsWritable And propty.IsReadable then
    begin
      vle := propty.GetValue(Self);
      propty.SetValue(Dest, vle);
    end;
  end;
end;

constructor TEntityCrud.Create;
begin
//
end;

function TEntityCrud.getConsiderAtInsert: TEntityFillParameters;
begin
  Result := TEntityFillParameters.Create;
end;

function TEntityCrud.getConsiderAtUpdate: TEntityFillParameters;
begin
  Result := TEntityFillParameters.Create;
end;

function TEntityCrud.getDelete: String;
begin
  Result := 'DELETE FROM ' + getTableName + ' WHERE ' + getIdName + ' = :id';
end;

function TEntityCrud.getInsert: String;
var
  fieldName: String;
  delimitador: String;
begin
  Result := 'INSERT INTO ' + getTableName;
  delimitador := '(';

  for fieldName in getConsiderAtInsert.keys do
  begin
    Result := Result + delimitador + fieldName;
    delimitador := ',';
  end;

  Result := Result + ') VALUES (';
  delimitador := '';

  for fieldName IN getConsiderAtInsert.keys do
  begin
    Result := Result + delimitador + ':' + fieldName;
    delimitador := ',';
  end;

  Result := Result + ')';
end;

function TEntityCrud.getSelect: String;
begin
  Result := 'SELECT * FROM ' + getTableName + ' WHERE ' + getIdName + ' = :id';
end;

function TEntityCrud.getUpdate: String;
var
  fieldName: String;
  delimitador: String;
begin
  Result := 'UPDATE ' + getTableName + ' SET ';
  delimitador := '';

  for fieldName IN getConsiderAtUpdate.keys do
  begin
    Result := Result + delimitador + fieldName + ' = :' + fieldName;
    delimitador := ','
  end;

  Result := Result + ' WHERE ' + getIdName + ' = :id';
end;

end.
