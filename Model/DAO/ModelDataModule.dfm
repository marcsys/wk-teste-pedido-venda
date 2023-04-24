object DataModulePedidoVenda: TDataModulePedidoVenda
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 517
  Width = 888
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Users\marce\OneDrive\work\Candidatura\WK\wk-teste-pedido-vend' +
      'a\libmysql.dll'
    Left = 600
    Top = 72
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'User_Name=root'
      'Database=wk_teste_pedido_venda'
      'Password=[samuKI2]'
      'Server=127.0.0.1')
    LoginPrompt = False
    Left = 480
    Top = 72
  end
  object FDCommand1: TFDCommand
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evRowsetSize, evAutoClose, evRecordCountMode, evCursorKind]
    FetchOptions.CursorKind = ckForwardOnly
    FetchOptions.RowsetSize = 10000
    FetchOptions.AutoClose = False
    FetchOptions.RecordCountMode = cmTotal
    Left = 384
    Top = 72
  end
end
