unit EntityFactory;

interface
uses
  Rtti, EntityImplementation;

type
  TEntityFactory = class(TObject)
  public
    class function getInstance(instanceClass: TClass): TEntityCrud;
  end;

implementation

{ TEntityFactory }

class function TEntityFactory.getInstance(instanceClass: TClass): TEntityCrud;
var
  ctx: TRttiContext;
  tpe: TRttiType;
  vle: TValue;
begin
  ctx := TRttiContext.Create;
  tpe := ctx.GetType(instanceClass);
  vle := tpe.GetMethod('Create').Invoke(tpe.AsInstance.MetaclassType, []);
  Result := TEntityCrud(vle.AsObject);
  ctx.Free;
end;

end.
