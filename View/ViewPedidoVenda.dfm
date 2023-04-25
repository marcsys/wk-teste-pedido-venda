object FormPedidoVenda: TFormPedidoVenda
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pedidos'
  ClientHeight = 707
  ClientWidth = 1198
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1198
    Height = 707
    Margins.Left = 6
    Align = alClient
    BevelOuter = bvNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object LabelDescricaoProduto: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 156
      Width = 1192
      Height = 23
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 6
    end
    object DBGrid1: TDBGrid
      AlignWithMargins = True
      Left = 3
      Top = 185
      Width = 1192
      Height = 434
      Align = alClient
      Ctl3D = False
      DataSource = DataSourceMemItensPedido
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnEnter = DBGrid1Enter
      OnExit = DBGrid1Exit
      Columns = <
        item
          Expanded = False
          FieldName = 'codProduto'
          Width = 152
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dscProduto'
          Width = 597
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quantidade'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'vlrUnitario'
          Width = 137
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'vlrTotal'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Width = 150
          Visible = True
        end>
    end
    object FlowPanelRodape: TFlowPanel
      Left = 0
      Top = 622
      Width = 1198
      Height = 85
      Align = alBottom
      Alignment = taLeftJustify
      AutoSize = True
      BevelOuter = bvNone
      Padding.Left = 12
      Padding.Top = 12
      Padding.Right = 12
      Padding.Bottom = 12
      ParentBackground = False
      TabOrder = 2
      object FlowPanelNumPedido: TFlowPanel
        AlignWithMargins = True
        Left = 15
        Top = 15
        Width = 458
        Height = 55
        Margins.Right = 48
        Alignment = taLeftJustify
        AutoWrap = False
        BevelOuter = bvNone
        Caption = 'N'#186' do Pedido'
        FlowStyle = fsRightLeftTopBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object DBTextNumPedido: TDBText
          AlignWithMargins = True
          Left = 169
          Top = 3
          Width = 286
          Height = 42
          AutoSize = True
          DataField = 'numPedido'
          DataSource = DataSourceMemItensPedido
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -35
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
      end
      object FlowPanelVlrTotal: TFlowPanel
        AlignWithMargins = True
        Left = 524
        Top = 15
        Width = 532
        Height = 55
        Alignment = taLeftJustify
        AutoWrap = False
        BevelOuter = bvNone
        Caption = 'Valor total do pedido'
        FlowStyle = fsRightLeftTopBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DBTextTotalPedido: TDBText
          AlignWithMargins = True
          Left = 238
          Top = 3
          Width = 291
          Height = 42
          AutoSize = True
          DataField = 'totalPedido'
          DataSource = DataSourceMemItensPedido
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -35
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
      end
    end
    object GridPanelCliente: TGridPanel
      Left = 0
      Top = 0
      Width = 1198
      Height = 153
      Align = alTop
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 510.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = FlowPanelCodCliente
          Row = 0
        end
        item
          Column = 1
          Control = PanelDadosCliente
          Row = 0
        end
        item
          Column = 0
          Control = FlowPanelDadosItemPedido
          Row = 1
        end
        item
          Column = 1
          Control = GridPanelActionsPedido
          Row = 1
        end>
      Ctl3D = False
      ParentCtl3D = False
      RowCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      TabOrder = 0
      object FlowPanelCodCliente: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 504
        Height = 70
        Align = alClient
        AutoSize = True
        BevelOuter = bvNone
        Ctl3D = True
        FlowStyle = fsTopBottomLeftRight
        ParentCtl3D = False
        TabOrder = 0
        object LabelCodCliente: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 100
          Height = 16
          Caption = 'C'#243'digo do &Cliente'
          FocusControl = EditCodCliente
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object EditCodCliente: TEdit
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 190
          Height = 25
          Alignment = taRightJustify
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 14
          NumbersOnly = True
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnChange = EditCodClienteChange
        end
        object BitBtn4: TBitBtn
          AlignWithMargins = True
          Left = 199
          Top = 25
          Width = 117
          Height = 25
          Margins.Top = 25
          Action = ActionNewPedido
          Caption = '&Novo Pedido'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ModalResult = 4
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 1
        end
      end
      object PanelDadosCliente: TPanel
        AlignWithMargins = True
        Left = 513
        Top = 3
        Width = 682
        Height = 70
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Padding.Right = 3
        ParentFont = False
        TabOrder = 3
        VerticalAlignment = taAlignTop
        object LabelNomeCliente: TLabel
          Left = 0
          Top = 0
          Width = 679
          Height = 70
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 6
          ExplicitHeight = 23
        end
      end
      object FlowPanelDadosItemPedido: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 79
        Width = 504
        Height = 71
        Align = alClient
        BevelOuter = bvNone
        FlowStyle = fsTopBottomLeftRight
        TabOrder = 1
        object LabelCodProduto: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 105
          Height = 16
          Caption = 'C'#243'digo do &Produto'
          FocusControl = EditCodProduto
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object EditCodProduto: TEdit
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 190
          Height = 25
          Alignment = taRightJustify
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 14
          NumbersOnly = True
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
        end
        object LabelQuantidade: TLabel
          AlignWithMargins = True
          Left = 199
          Top = 3
          Width = 65
          Height = 16
          Caption = '&Quantidade'
          FocusControl = EditQuantidade
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object EditQuantidade: TEdit
          AlignWithMargins = True
          Left = 199
          Top = 26
          Width = 113
          Height = 25
          Alignment = taRightJustify
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 14
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          OnChange = EditQuantidadeChange
        end
        object LabelVlrUnitario: TLabel
          AlignWithMargins = True
          Left = 318
          Top = 3
          Width = 78
          Height = 16
          Caption = '&Valor Unit'#225'rio'
          FocusControl = EditVlrUnitario
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object EditVlrUnitario: TEdit
          Tag = 1
          AlignWithMargins = True
          Left = 318
          Top = 26
          Width = 113
          Height = 25
          Alignment = taRightJustify
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 14
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          OnChange = EditQuantidadeChange
        end
        object BitBtnAdicionaItem: TBitBtn
          AlignWithMargins = True
          Left = 437
          Top = 25
          Width = 58
          Height = 25
          Margins.Top = 25
          Margins.Bottom = 0
          Action = ActionSaveItem
          Caption = 'OK'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ModalResult = 1
          NumGlyphs = 2
          ParentFont = False
          Style = bsWin31
          TabOrder = 3
        end
      end
      object GridPanelActionsPedido: TGridPanel
        Left = 510
        Top = 76
        Width = 688
        Height = 77
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = BitBtn1
            Row = 0
          end
          item
            Column = 1
            Control = BitBtn2
            Row = 0
          end
          item
            Column = 1
            Control = BitBtn3
            Row = 1
          end
          item
            Column = 0
            Control = BitBtn5
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        TabOrder = 2
        object BitBtn1: TBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 338
          Height = 32
          Action = ActionSavePedido
          Align = alClient
          Caption = '&GRAVAR PEDIDO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkAll
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 0
        end
        object BitBtn2: TBitBtn
          AlignWithMargins = True
          Left = 347
          Top = 3
          Width = 338
          Height = 32
          Action = ActionLoadPedido
          Align = alClient
          Caption = 'CA&RREGAR PEDIDO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkHelp
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 2
        end
        object BitBtn3: TBitBtn
          AlignWithMargins = True
          Left = 347
          Top = 41
          Width = 338
          Height = 33
          Action = ActionCancelPedido
          Align = alClient
          Caption = 'C&ANCELAR PEDIDO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkCancel
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 3
        end
        object BitBtn5: TBitBtn
          AlignWithMargins = True
          Left = 3
          Top = 41
          Width = 338
          Height = 33
          Action = ActionUndoPedido
          Align = alClient
          Caption = 'DESPRE&ZAR PEDIDO'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkNo
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = ActionLoadPedido
            Caption = '&Carregar Pedido'
          end
          item
            Action = ActionCancelPedido
            Caption = 'C&ancelar Pedido'
          end
          item
            Action = ActionNewPedido
          end
          item
            Action = ActionSavePedido
            Caption = '&Gravar Pedido'
          end>
      end
      item
        Items = <
          item
            Action = ActionSavePedido
            Caption = '&Gravar Pedido'
          end
          item
            Action = ActionNewPedido
          end
          item
            Action = ActionLoadPedido
            Caption = '&Carregar Pedido'
          end
          item
            Action = ActionCancelPedido
            Caption = 'C&ancelar Pedido'
          end>
      end>
    Left = 104
    Top = 248
    StyleName = 'XP Style'
    object ActionLoadPedido: TAction
      Caption = 'Carregar Pedido'
    end
    object ActionCancelPedido: TAction
      Caption = 'Cancelar Pedido'
    end
    object ActionNewPedido: TAction
      Caption = 'Novo Pedido'
    end
    object ActionSavePedido: TAction
      Caption = 'Gravar Pedido'
    end
    object ActionSaveItem: TAction
      Caption = 'OK'
      OnExecute = ActionSaveItemExecute
    end
    object ActionUndoPedido: TAction
      Caption = 'Desprezar Pedido'
    end
    object ActionGoToGrid: TAction
      Caption = 'Foco no Grid'
      SecondaryShortCuts.Strings = (
        'Up')
      ShortCut = 40
      OnExecute = ActionGoToGridExecute
    end
    object ActionEditItem: TAction
      Caption = 'Alterar Item'
      Enabled = False
      ShortCut = 13
      OnExecute = ActionEditItemExecute
    end
    object ActionDeleteItem: TAction
      Caption = 'Excluir Item'
      Enabled = False
      ShortCut = 46
      OnExecute = ActionDeleteItemExecute
    end
  end
  object DataSourceMemItensPedido: TDataSource
    AutoEdit = False
    DataSet = FDMemTableItensPedido
    Left = 352
    Top = 248
  end
  object FDMemTableItensPedido: TFDMemTable
    OnCalcFields = FDMemTableItensPedidoCalcFields
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'bySequencial'
        Fields = 'sequencial'
      end>
    Indexes = <
      item
        Active = True
        Name = 'bySequencial'
        Fields = 'sequencial'
      end>
    AggregatesActive = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 216
    Top = 248
    object memSequencial: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldKind = fkInternalCalc
      FieldName = 'sequencial'
      Visible = False
    end
    object memCodProduto: TLargeintField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'codProduto'
    end
    object memDscProduto: TStringField
      DisplayLabel = 'Produto'
      FieldName = 'dscProduto'
      Size = 250
    end
    object memVlrUnitario: TCurrencyField
      DisplayLabel = 'Vlr. Unit'#225'rio'
      FieldName = 'vlrUnitario'
    end
    object memQuantidade: TFloatField
      DisplayLabel = 'Quantidade'
      FieldName = 'quantidade'
      EditFormat = '0.0000'
    end
    object memVlrTotal: TCurrencyField
      DisplayLabel = 'Vlr. Total'
      FieldKind = fkInternalCalc
      FieldName = 'vlrTotal'
    end
    object memNumPedido: TLargeintField
      FieldName = 'numPedido'
    end
    object memTotalPedido: TAggregateField
      FieldName = 'totalPedido'
      Visible = True
      Active = True
      currency = True
      DisplayName = ''
      Expression = 'SUM(vlrTotal)'
    end
  end
end
