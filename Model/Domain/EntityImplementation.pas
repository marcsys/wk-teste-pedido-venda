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

uses ModelDataModule, Rtti, SysUtils;

{ TEntityCrud }

procedure TEntityCrud.AssignTo(Dest: TPersistent);
var
  ctx: TRttiContext;
  tpe: TRttiType;
begin
  if (Dest = nil) or (Dest.ClassType <> Self.ClassType) then
    inherited;

  ctx := TRttiContext.Create;
  tpe := ctx.GetType(Self.ClassType);

  for var propty in tpe.GetProperties do
  begin
    if propty.IsWritable And propty.IsReadable then
      propty.SetValue(Dest, propty.GetValue(Self));
  end;

  ctx.Free;
end;

constructor TEntityCrud.Create;
begin
// Apenas para garantir o construtor virtual necessário para o Assign, AssignTo
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
  Result := Format('DELETE FROM %s WHERE %s = :id', [getTableName, getIdName]);
end;

function TEntityCrud.getInsert: String;
var
  fieldName: String;
  delimitador: String;
  buffer: TStringBuilder;
begin
  delimitador := '(';
  buffer := TStringBuilder.Create;

  buffer
    .Append('INSERT INTO ')
    .Append(getTableName);


  for fieldName in getConsiderAtInsert.keys do
  begin
    buffer
      .Append(delimitador)
      .Append(fieldName);

    delimitador := ',';
  end;

  delimitador := '';
  buffer.Append(') VALUES (');

  for fieldName IN getConsiderAtInsert.keys do
  begin
    buffer
      .Append(delimitador)
      .Append(':')
      .Append(fieldName);

    delimitador := ',';
  end;

  buffer.Append(')');
  Result := buffer.ToString;
end;

function TEntityCrud.getSelect: String;
begin
  Result := Format('SELECT * FROM %s WHERE %s = :id', [getTableName, getIdName]);
end;

function TEntityCrud.getUpdate: String;
var
  fieldName: String;
  delimitador: String;
  buffer: TStringBuilder;
begin
  delimitador := '';
  buffer := TStringBuilder.Create;

  buffer
    .Append('UPDATE ')
    .Append(getTableName)
    .Append(' SET ');

  for fieldName IN getConsiderAtUpdate.keys do
  begin
    buffer
      .Append(delimitador)
      .Append(fieldName)
      .Append(' = :')
      .Append(fieldName);

    delimitador := ','
  end;

  buffer
    .Append(' WHERE ')
    .Append(getIdName)
    .Append(' = :id');

  Result := buffer.ToString;
end;

end.
