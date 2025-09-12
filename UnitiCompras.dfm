object formiCompras: TformiCompras
  Left = 0
  Top = 0
  Caption = 'iCompras360 - Generador TP3'
  ClientHeight = 600
  ClientWidth = 800
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    Left = 0
    Top = 60
    Width = 800
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Listo para generar archivos TP3'
    Color = 15138816
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 179
  end
  object pnlControles: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = 15138816
    ParentBackground = False
    TabOrder = 0
    object lblTasa: TLabel
      Left = 16
      Top = 22
      Width = 90
      Height = 13
      Caption = 'Tasa Cambiaria:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnDetener: TSpeedButton
      Left = 232
      Top = 5
      Width = 100
      Height = 35
      Caption = 'Detener'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtTasa: TEdit
      Left = 132
      Top = 19
      Width = 80
      Height = 21
      TabOrder = 0
      Text = '29.30'
    end
  end
  object pnl1: TPanel
    Left = 200
    Top = 100
    Width = 400
    Height = 100
    BevelOuter = bvNone
    TabOrder = 1
    object btnCatalogo: TSpeedButton
      Left = 0
      Top = 0
      Width = 200
      Height = 100
      Align = alLeft
      Caption = 'Generar Cat'#225'logo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 80
    end
    object btnClientes: TSpeedButton
      Left = 200
      Top = 0
      Width = 200
      Height = 100
      Align = alLeft
      Caption = 'Generar Clientes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 80
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 73
    Width = 800
    Height = 25
    Align = alTop
    TabOrder = 2
  end
  object memoLog: TMemo
    Left = 0
    Top = 98
    Width = 800
    Height = 502
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Sistema iCompras360 - Generador TP3'
      'Listo para procesar...')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
end
