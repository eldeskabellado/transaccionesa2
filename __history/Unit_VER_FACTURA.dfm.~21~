object FormVerFactura: TFormVerFactura
  Left = 0
  Top = 0
  Caption = 'FormVerFactura'
  ClientHeight = 357
  ClientWidth = 490
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
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 40
    Height = 13
    Caption = 'FECHA: '
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 39
    Width = 474
    Height = 309
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
        Title.Caption = 'COD. CLIENTE'
        Width = 89
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FTI_PERSONACONTACTO'
        Title.Alignment = taCenter
        Title.Caption = 'CLIENTE'
        Width = 268
        Visible = True
      end>
  end
  object DateFecha: TDateTimePicker
    Left = 54
    Top = 8
    Width = 186
    Height = 21
    Date = 45020.347325833330000000
    Time = 45020.347325833330000000
    TabOrder = 1
  end
  object Button1: TButton
    Left = 246
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Ver Facturas'
    TabOrder = 2
    OnClick = Button1Click
  end
  object sqfacturas: TDBISAMQuery
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT * FROM SOPERACIONINV'
      
        'WHERE FTI_TIPO = :TTIPO AND FTI_FECHAEMISION = :Tfecha AND FTI_D' +
        'OCUMENTO <>  '#39'PENDIENTE'#39
      'Order By FTI_FECHAEMISION asc')
    Params = <
      item
        DataType = ftUnknown
        Name = 'TTIPO'
      end
      item
        DataType = ftUnknown
        Name = 'Tfecha'
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
        Name = 'Tfecha'
      end>
  end
  object dsqfacturas: TDataSource
    DataSet = sqfacturas
    Left = 208
    Top = 112
  end
  object sqscim: TDBISAMQuery
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT * FROM SAUTORIZADOS'
      
        'WHERE FCA_CODIGOAUTORIZADO = :PCODIGO AND FCA_CODIGOCLIENTE = :P' +
        'CODIGOCLIENTE')
    Params = <
      item
        DataType = ftUnknown
        Name = 'PCODIGO'
      end
      item
        DataType = ftUnknown
        Name = 'PCODIGOCLIENTE'
      end>
    Left = 320
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PCODIGO'
      end
      item
        DataType = ftUnknown
        Name = 'PCODIGOCLIENTE'
      end>
  end
end
