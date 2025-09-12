object FormVerCompras: TFormVerCompras
  Left = 0
  Top = 0
  Caption = 'FormVerCompras'
  ClientHeight = 331
  ClientWidth = 493
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 32
    Width = 474
    Height = 285
    DataSource = dsqfacturas
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'FTI_DOCUMENTO'
        Title.Caption = 'DOCUMENTO'
        Width = 76
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FTI_RESPONSABLE'
        Title.Caption = 'COD. PROVEEDOR'
        Width = 97
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FTI_PERSONACONTACTO'
        Title.Alignment = taCenter
        Title.Caption = 'PROVEEDOR'
        Width = 268
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 1
    Width = 105
    Height = 25
    Caption = 'Ver Compras'
    TabOrder = 1
  end
  object sqfacturas: TDBISAMQuery
    DatabaseName = 'data2'
    EngineVersion = '4.49 Build 4'
    SQL.Strings = (
      'SELECT * FROM SOPERACIONINV'
      'WHERE FTI_TIPO = :TTIPO AND FTI_RESPONSABLE = :proveedor'
      'Order By FTI_FECHAEMISION desc')
    Params = <
      item
        DataType = ftUnknown
        Name = 'TTIPO'
      end
      item
        DataType = ftUnknown
        Name = 'proveedor'
      end>
    Left = 320
    Top = 64
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'TTIPO'
      end
      item
        DataType = ftUnknown
        Name = 'proveedor'
      end>
  end
  object dsqfacturas: TDataSource
    DataSet = sqfacturas
    Left = 208
    Top = 112
  end
end
