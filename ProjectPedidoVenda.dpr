program ProjectPedidoVenda;

uses
  Vcl.Forms,
  ViewPedidoVenda in 'View\ViewPedidoVenda.pas' {FormPedidoVenda},
  ModelDataModule in 'Model\DAO\ModelDataModule.pas' {DataModulePedidoVenda: TDataModule},
  ClienteEntity in 'Model\Domain\ClienteEntity.pas',
  ProdutoEntity in 'Model\Domain\ProdutoEntity.pas',
  PedidoEntity in 'Model\Domain\PedidoEntity.pas',
  ItemPedidoEntity in 'Model\Domain\ItemPedidoEntity.pas',
  EntityImplementation in 'Model\Domain\EntityImplementation.pas',
  controller in 'Control\controller.pas',
  EntityFactory in 'Model\Domain\EntityFactory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  var controller := TControllerPedidoVenda.Create;
  Application.Run;

end.
