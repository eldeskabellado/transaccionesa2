object FormDetalleOrdenPago: TFormDetalleOrdenPago
  Left = 0
  Top = 0
  Caption = 'Detalle Orden de Pago'
  ClientHeight = 450
  ClientWidth = 1063
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1063
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 700
    object lblTitulo: TLabel
      Left = 16
      Top = 12
      Width = 155
      Height = 13
      Caption = 'Detalle de la Orden de Pago'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object DBGridDetalle: TDBGrid
    Left = 0
    Top = 41
    Width = 1063
    Height = 360
    Align = alClient
    DataSource = dsDetalle
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel2: TPanel
    Left = 0
    Top = 401
    Width = 1063
    Height = 49
    Align = alBottom
    TabOrder = 2
    ExplicitWidth = 700
    object lblTotal: TLabel
      Left = 16
      Top = 14
      Width = 59
      Height = 13
      Caption = 'Total: 0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnCerrar: TButton
      Left = 592
      Top = 8
      Width = 90
      Height = 33
      Caption = 'Cerrar'
      TabOrder = 0
      OnClick = btnCerrarClick
    end
  end
  object sqDetalle: TDBISAMQuery
    AfterOpen = sqDetalleAfterOpen
    DatabaseName = 'data2'
    EngineVersion = '4.49 Build 4'
    Params = <>
    Left = 40
    Top = 120
  end
  object dsDetalle: TDataSource
    DataSet = sqDetalle
    Left = 40
    Top = 176
  end
end
