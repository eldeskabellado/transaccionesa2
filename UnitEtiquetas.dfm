object formEtiquetas: TformEtiquetas
  Left = 0
  Top = 0
  Caption = 'formEtiquetas'
  ClientHeight = 360
  ClientWidth = 468
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 280
    Width = 3
    Height = 13
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 217
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbl1: TLabel
      Left = 130
      Top = 92
      Width = 70
      Height = 23
      Caption = 'CODIGO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 8
      Top = 92
      Width = 92
      Height = 23
      Caption = 'FORMATO:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object edtCodigo: TEdit
      Left = 8
      Top = 121
      Width = 265
      Height = 31
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object btn2: TButton
      Left = 320
      Top = 124
      Width = 137
      Height = 31
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btn2Click
    end
    object rg1: TRadioGroup
      Left = -56
      Top = 179
      Width = 210
      Height = 32
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'CUADRADO'
        'RECTANGULAR')
      TabOrder = 2
      Visible = False
    end
    object rgImpresion: TRadioGroup
      Left = 8
      Top = 17
      Width = 449
      Height = 60
      Caption = 'Seleccione Opcion'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Indicidual'
        'Todas')
      ParentFont = False
      TabOrder = 3
      OnClick = rgImpresionClick
    end
  end
  object pnl21: TPanel
    Left = 0
    Top = 217
    Width = 468
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btn1: TButton
      Left = 0
      Top = 0
      Width = 468
      Height = 64
      Align = alClient
      Caption = 'IMPRIMIR'
      TabOrder = 0
      OnClick = btn1Click
    end
  end
  object btnImpTodos: TButton
    Left = 0
    Top = 281
    Width = 460
    Height = 71
    Caption = 'Imprimir'
    TabOrder = 2
    Visible = False
    OnClick = btnImpTodosClick
  end
  object repEtiquetaInventario: TfrxReport
    Version = '6.9.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45363.482666122700000000
    ReportOptions.LastChange = 45841.785017731500000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      ''
      ''
      ''
      'begin'
      'end.')
    Left = 176
    Top = 168
    Datasets = <
      item
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
      end
      item
        DataSet = fsqDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
      end
      item
        DataSet = fsqFACTOR
        DataSetName = 'fsmoneda'
      end
      item
        DataSet = fsqPresentacion
        DataSetName = 'fsqEtiqueta'
      end>
    Variables = <
      item
        Name = ' Variables'
        Value = Null
      end
      item
        Name = 'moneda'
        Value = Null
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 70.000000000000000000
      PaperHeight = 120.000000000000000000
      PaperSize = 256
      LeftMargin = 2.500000000000000000
      RightMargin = 2.500000000000000000
      TopMargin = 2.500000000000000000
      BottomMargin = 2.500000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnAfterPrint = 'Page1OnAfterPrint'
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Frame.Typ = []
        Height = 166.622140000000000000
        Top = 18.897650000000000000
        Width = 245.669450000000000000
        Stretched = True
        object fsqEtiquetaFO_PRODUCTO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 41.574830000000000000
          Top = 3.779530000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'FO_PRODUCTO'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_PRODUCTO"]')
          ParentFont = False
        end
        object fsqEtiquetaFO_DESCRIPCION: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 34.015770000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          DataField = 'FO_DESCRIPCION'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_DESCRIPCION"]')
          ParentFont = False
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 60.472480000000000000
          Width = 80.000000000000000000
          Height = 60.472480000000000000
          BarType = bcCode128
          Expression = '<fsqEtiqueta."FO_PRODUCTO">'
          Frame.Typ = []
          Rotation = 0
          ShowText = False
          TestLine = False
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ColorBar = clBlack
        end
        object fsqEtiquetaFO_MTOTOTAL: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 75.590600000000000000
          Top = 124.724490000000000000
          Width = 158.740260000000000000
          Height = 37.795300000000000000
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[<fsqEtiqueta."FO_MTOTOTAL">/100]')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 11.338590000000000000
          Top = 128.504020000000000000
          Width = 60.472480000000000000
          Height = 30.236240000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'REF')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 75.590600000000000000
        Top = 245.669450000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
        RowCount = 0
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Top = 3.779529999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'MAYOR X:')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 109.606370000000000000
          Top = 3.779529999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FO_UNDDESCARGA'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta."FO_UNDDESCARGA"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 22.677180000000000000
          Width = 241.889920000000000000
          Height = 41.574830000000000000
          DataField = 'FO_PRECIO_CALCULADO'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[detalleetiqueta."FO_PRECIO_CALCULADO"]')
          ParentFont = False
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Frame.Typ = []
        Height = 86.929190000000000000
        Top = 343.937230000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
        Filter = '<fsqEtiqueta."FO_PRODUCTO">'
        RowCount = 0
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 7.559059999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'MAYOR X:')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 117.165430000000000000
          Top = 7.559059999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FI_CAPACIDAD'
          DataSet = fsqDetalleEtiqueta2
          DataSetName = 'detalleetiqueta2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta2."FI_CAPACIDAD"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 26.456710000000000000
          Width = 238.110390000000000000
          Height = 41.574830000000000000
          DataField = 'FIC_P01PRECIOTOTALEXT'
          DataSet = fsqDetalleEtiqueta2
          DataSetName = 'detalleetiqueta2'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[detalleetiqueta2."FIC_P01PRECIOTOTALEXT"]')
          ParentFont = False
        end
      end
    end
  end
  object fsqEtiqueta: TfrxDBDataset
    UserName = 'fsqEtiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FO_PRODUCTO=FO_PRODUCTO'
      'FO_DESCRIPCION=FO_DESCRIPCION'
      'FO_UNDDESCARGA=FO_UNDDESCARGA'
      'FO_MTOTOTAL=FO_MTOTOTAL')
    DataSet = sqBuscarPresentacion
    BCDToCurrency = False
    Left = 40
    Top = 8
  end
  object frEtiqueta2: TfrxReport
    Version = '6.9.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45363.482666122700000000
    ReportOptions.LastChange = 45841.785017731500000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      ''
      ''
      ''
      'begin'
      'end.')
    Left = 360
    Top = 80
    Datasets = <
      item
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
      end
      item
        DataSet = fsqDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
      end
      item
        DataSet = fsqFACTOR
        DataSetName = 'fsmoneda'
      end
      item
        DataSet = fsqPresentacion
        DataSetName = 'fsqEtiqueta'
      end>
    Variables = <
      item
        Name = ' Variables'
        Value = Null
      end
      item
        Name = 'moneda'
        Value = ''
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 70.000000000000000000
      PaperHeight = 110.000000000000000000
      PaperSize = 256
      LeftMargin = 2.500000000000000000
      RightMargin = 2.500000000000000000
      TopMargin = 2.500000000000000000
      BottomMargin = 2.500000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnAfterPrint = 'Page1OnAfterPrint'
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Frame.Typ = []
        Height = 166.622140000000000000
        Top = 18.897650000000000000
        Width = 245.669450000000000000
        Stretched = True
        object fsqEtiquetaFO_PRODUCTO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 41.574830000000000000
          Top = 3.779530000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'FO_PRODUCTO'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_PRODUCTO"]')
          ParentFont = False
        end
        object fsqEtiquetaFO_DESCRIPCION: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 34.015770000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          DataField = 'FO_DESCRIPCION'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_DESCRIPCION"]')
          ParentFont = False
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 60.472480000000000000
          Width = 80.000000000000000000
          Height = 60.472480000000000000
          BarType = bcCode128
          Expression = '<fsqEtiqueta."FO_PRODUCTO">'
          Frame.Typ = []
          Rotation = 0
          ShowText = False
          TestLine = False
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ColorBar = clBlack
        end
        object fsqEtiquetaFO_MTOTOTAL: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 75.590600000000000000
          Top = 124.724490000000000000
          Width = 158.740260000000000000
          Height = 37.795300000000000000
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[<fsqEtiqueta."FO_MTOTOTAL">/100]')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 11.338590000000000000
          Top = 128.504020000000000000
          Width = 60.472480000000000000
          Height = 30.236240000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'REF')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 75.590600000000000000
        Top = 245.669450000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
        RowCount = 0
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Top = 3.779529999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'MAYOR X:')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 109.606370000000000000
          Top = 3.779529999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FO_UNDDESCARGA'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta."FO_UNDDESCARGA"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 22.677180000000000000
          Width = 241.889920000000000000
          Height = 41.574830000000000000
          DataField = 'FO_PRECIO_CALCULADO'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[detalleetiqueta."FO_PRECIO_CALCULADO"]')
          ParentFont = False
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Frame.Typ = []
        Height = 86.929190000000000000
        Top = 343.937230000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
        Filter = '<fsqEtiqueta."FO_PRODUCTO">'
        RowCount = 0
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 7.559059999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'MAYOR X:')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 117.165430000000000000
          Top = 7.559059999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FI_CAPACIDAD'
          DataSet = fsqDetalleEtiqueta2
          DataSetName = 'detalleetiqueta2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta2."FI_CAPACIDAD"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 26.456710000000000000
          Width = 238.110390000000000000
          Height = 41.574830000000000000
          DataField = 'FIC_P01PRECIOTOTALEXT'
          DataSet = fsqDetalleEtiqueta2
          DataSetName = 'detalleetiqueta2'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[detalleetiqueta2."FIC_P01PRECIOTOTALEXT"]')
          ParentFont = False
        end
      end
    end
  end
  object sqBuscarPresentacion: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      
        ' SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, FO_MTOTOTAL' +
        ' FROM SINVOFERTA WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA = 1 ')
    Params = <>
    Left = 244
    Top = 145
  end
  object sqTasa: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT FM_FACTOR FROM SMONEDA WHERE FM_CODE = 2')
    Params = <>
    Left = 20
    Top = 201
  end
  object repPresentaciones: TfrxReport
    Version = '6.9.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45363.482666122700000000
    ReportOptions.LastChange = 45841.785017731500000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      ''
      ''
      ''
      'begin'
      'end.')
    Left = 264
    Top = 200
    Datasets = <
      item
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
      end
      item
        DataSet = fsqDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
      end
      item
        DataSet = fsqFACTOR
        DataSetName = 'fsmoneda'
      end
      item
        DataSet = fsqPresentacion
        DataSetName = 'fsqEtiqueta'
      end>
    Variables = <
      item
        Name = ' Variables'
        Value = Null
      end
      item
        Name = 'moneda'
        Value = Null
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 70.000000000000000000
      PaperHeight = 120.000000000000000000
      PaperSize = 256
      LeftMargin = 2.500000000000000000
      RightMargin = 2.500000000000000000
      TopMargin = 2.500000000000000000
      BottomMargin = 2.500000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnAfterPrint = 'Page1OnAfterPrint'
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Frame.Typ = []
        Height = 166.622140000000000000
        Top = 18.897650000000000000
        Width = 245.669450000000000000
        Stretched = True
        object fsqEtiquetaFO_PRODUCTO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 41.574830000000000000
          Top = 3.779530000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'FO_PRODUCTO'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_PRODUCTO"]')
          ParentFont = False
        end
        object fsqEtiquetaFO_DESCRIPCION: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 34.015770000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          DataField = 'FO_DESCRIPCION'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_DESCRIPCION"]')
          ParentFont = False
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 60.472480000000000000
          Width = 80.000000000000000000
          Height = 60.472480000000000000
          BarType = bcCode128
          Expression = '<fsqEtiqueta."FO_PRODUCTO">'
          Frame.Typ = []
          Rotation = 0
          ShowText = False
          TestLine = False
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ColorBar = clBlack
        end
        object fsqEtiquetaFO_MTOTOTAL: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 75.590600000000000000
          Top = 124.724490000000000000
          Width = 158.740260000000000000
          Height = 37.795300000000000000
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[<fsqEtiqueta."FO_MTOTOTAL">/100]')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 11.338590000000000000
          Top = 128.504020000000000000
          Width = 60.472480000000000000
          Height = 30.236240000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'REF')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 75.590600000000000000
        Top = 245.669450000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
        RowCount = 0
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Top = 3.779529999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'MAYOR X:')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 109.606370000000000000
          Top = 3.779529999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FO_UNDDESCARGA'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta."FO_UNDDESCARGA"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 22.677180000000000000
          Width = 241.889920000000000000
          Height = 41.574830000000000000
          DataField = 'FO_PRECIO_CALCULADO'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[detalleetiqueta."FO_PRECIO_CALCULADO"]')
          ParentFont = False
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Frame.Typ = []
        Height = 86.929190000000000000
        Top = 343.937230000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
        Filter = '<fsqEtiqueta."FO_PRODUCTO">'
        RowCount = 0
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 7.559059999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'MAYOR X:')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 117.165430000000000000
          Top = 7.559059999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FI_CAPACIDAD'
          DataSet = fsqDetalleEtiqueta2
          DataSetName = 'detalleetiqueta2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta2."FI_CAPACIDAD"]')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 26.456710000000000000
          Width = 238.110390000000000000
          Height = 41.574830000000000000
          DataField = 'FIC_P01PRECIOTOTALEXT'
          DataSet = fsqDetalleEtiqueta2
          DataSetName = 'detalleetiqueta2'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '[detalleetiqueta2."FIC_P01PRECIOTOTALEXT"]')
          ParentFont = False
        end
      end
    end
  end
  object sqBuscarPresentacion2: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT '
      '    p.FI_CODIGO as PCODIGO,'
      '    p.FI_CODIGO as PRODUCTO_CODIGO,'
      '    p.FI_DESCRIPCION as DESCRIPCION,'
      '    p.FI_DESCRIPCION as PRODUCTO_DESCRIPCION,'
      '    p.FI_PRECIOLISTA as PRECIO,'
      '    p.FI_PRECIOLISTA as PRODUCTO_PRECIO,'
      '    p.FI_CATEGORIA as CATEGORIA,'
      '    p.FI_CATEGORIA as PRODUCTO_CATEGORIA,'
      '    p.FI_MARCA as PRODUCTO_MARCA,'
      '    p.FI_UNIDAD as PRODUCTO_UNIDAD,'
      '    p.FI_CODIGOBARRA as PRODUCTO_CODIGOBARRA,'
      '    p.FI_CAPACIDAD as PRODUCTO_CAPACIDAD,'
      '    o.FO_CODE,'
      '    o.FO_PRODUCTO,'
      '    o.FO_DESCRIPCION as FO_DESCRIPCION,'
      '    o.FO_PRECIODESC,'
      '    o.FO_MTOIMPUESTO1,'
      '    o.FO_MTOTOTAL,'
      '    o.FO_UNDDESCARGA,'
      '    o.FO_SOURCEIMP1,'
      '    o.FO_TIPOOFERTA,'
      '    o.FO_FECHAINICIO,'
      '    o.FO_FECHAFINAL'
      'FROM Sinventario p '
      
        'LEFT JOIN SinvOferta o ON p.FI_CODIGO = o.FO_PRODUCTO AND o.FO_V' +
        'ISIBLE = 1 '
      'WHERE p.FI_STATUS = 1'
      'ORDER BY p.FI_CODIGO;')
    Params = <>
    Left = 60
    Top = 113
  end
  object fsqPresentacion: TfrxDBDataset
    UserName = 'fsqEtiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FO_PRODUCTO=FO_PRODUCTO'
      'FO_DESCRIPCION=FO_DESCRIPCION'
      'FO_UNDDESCARGA=FO_UNDDESCARGA'
      'FO_MTOTOTAL=FO_MTOTOTAL')
    DataSet = sqBuscarPresentacion
    BCDToCurrency = False
    Left = 256
    Top = 8
  end
  object fsqFACTOR: TfrxDBDataset
    UserName = 'fsmoneda'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FM_FACTOR=FM_FACTOR')
    DataSet = sqTasa
    BCDToCurrency = False
    Left = 112
    Top = 16
  end
  object repEtiqueta3: TfrxReport
    Version = '6.9.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45363.482666122700000000
    ReportOptions.LastChange = 45840.356848888900000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      ''
      ''
      ''
      'begin'
      'end.')
    Left = 280
    Top = 120
    Datasets = <
      item
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
      end
      item
        DataSet = fsqEtiqueta3
        DataSetName = 'fsqEtiqueta'
      end>
    Variables = <
      item
        Name = ' Variables'
        Value = Null
      end
      item
        Name = 'moneda'
        Value = ''
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 70.000000000000000000
      PaperHeight = 70.000000000000000000
      PaperSize = 256
      LeftMargin = 2.500000000000000000
      RightMargin = 2.500000000000000000
      TopMargin = 2.500000000000000000
      BottomMargin = 2.500000000000000000
      Frame.Typ = []
      MirrorMode = []
      OnAfterPrint = 'Page1OnAfterPrint'
      OnBeforePrint = 'Page1OnBeforePrint'
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        Frame.Typ = []
        Height = 166.299320000000000000
        Top = 18.897650000000000000
        Width = 245.669450000000000000
        Stretched = True
        object fsqEtiquetaFO_PRODUCTO: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 41.574830000000000000
          Top = 3.779530000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FI_CODIGO"]')
          ParentFont = False
        end
        object fsqEtiquetaFO_DESCRIPCION: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 34.015770000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          DataField = 'FO_DESCRIPCION'
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FO_DESCRIPCION"]')
          ParentFont = False
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 60.472480000000000000
          Width = 80.000000000000000000
          Height = 52.913420000000000000
          BarType = bcCode128
          Expression = '<fsqEtiqueta."FI_CODIGO">'
          Frame.Typ = []
          Rotation = 0
          ShowText = False
          TestLine = False
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ColorBar = clBlack
        end
        object fsqEtiquetaFO_MTOTOTAL: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 75.590600000000000000
          Top = 120.944960000000000000
          Width = 158.740260000000000000
          Height = 37.795300000000000000
          DataSet = fsqPresentacion
          DataSetName = 'fsqEtiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[fsqEtiqueta."FIC_P01PRECIOTOTALEXT"]')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Left = 11.338590000000000000
          Top = 124.724490000000000000
          Width = 60.472480000000000000
          Height = 30.236240000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            'REF')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 245.669450000000000000
        Width = 245.669450000000000000
        DataSet = fsqDetalleEtiqueta
        DataSetName = 'detalleetiqueta'
        RowCount = 0
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Top = 3.779529999999990000
          Width = 105.826840000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'PRESENTACION X:')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 109.606370000000000000
          Top = 3.779529999999990000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataField = 'FI_CAPACIDAD'
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[detalleetiqueta."FI_CAPACIDAD"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 158.740260000000000000
          Top = 3.779529999999990000
          Width = 83.149660000000000000
          Height = 15.118120000000000000
          DataSet = fsqDetalleEtiqueta
          DataSetName = 'detalleetiqueta'
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haRight
          Memo.UTF8W = (
            '[detalleetiqueta."FIC_P01PRECIOTOTALEXT"]')
          ParentFont = False
        end
      end
    end
  end
  object fsqEtiqueta3: TfrxDBDataset
    UserName = 'fsqEtiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FI_CODIGO=FI_CODIGO'
      'FI_DESCRIPCION=FI_DESCRIPCION'
      'FI_STATUS=FI_STATUS'
      'FI_UNIDAD=FI_UNIDAD'
      'FI_CAPACIDAD=FI_CAPACIDAD'
      'FIC_P01PRECIOTOTALEXT=FIC_P01PRECIOTOTALEXT')
    DataSet = sqBuscarInventario
    BCDToCurrency = False
    Left = 360
    Top = 16
  end
  object sqBuscarInventario: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT '
      '    I.FI_CODIGO,'
      '    I.FI_DESCRIPCION, '
      '    I.FI_STATUS, '
      '    I.FI_UNIDAD, '
      '    I.FI_CAPACIDAD, '
      '    C.FIC_P01PRECIOTOTALEXT '
      'FROM '
      '    SINVENTARIO AS I'
      '    INNER JOIN a2InvCostosPrecios AS C'
      '        ON I.FI_CODIGO = C.FIC_CODEITEM;')
    Params = <>
    Left = 92
    Top = 225
  end
  object sqDetalleetiqueta: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, '
      '       (FO_MTOTOTAL / 100) AS FO_PRECIO_CALCULADO '
      'FROM sinvoferta '
      'WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA <> 1 '
      '  AND FO_PRODUCTO = '#39'0010'#39
      'ORDER BY FO_UNDDESCARGA')
    Params = <>
    Left = 36
    Top = 257
  end
  object fsqDetalle: TfrxDBDataset
    UserName = 'fsqEtiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FO_PRODUCTO=FO_PRODUCTO'
      'FO_DESCRIPCION=FO_DESCRIPCION'
      'FO_UNDDESCARGA=FO_UNDDESCARGA'
      'FO_MTOTOTAL=FO_MTOTOTAL')
    DataSet = sqDetalleetiqueta
    BCDToCurrency = False
    Left = 248
    Top = 256
  end
  object sqDetalleetiquetaInventario: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT I.FI_CODIGO, I.FI_DESCRIPCION, I.FI_CAPACIDAD, '
      '       C.FIC_P01PRECIOTOTALEXT '
      'FROM SINVENTARIO AS I '
      
        'INNER JOIN a2InvCostosPrecios AS C ON I.FI_CODIGO = C.FIC_CODEIT' +
        'EM '
      'WHERE I.FI_STATUS = TRUE AND I.FI_CAPACIDAD <> 1 '
      '  AND I.FI_CODIGO = '#39'0010'#39
      'ORDER BY I.FI_CAPACIDAD')
    Params = <>
    Left = 84
    Top = 153
  end
  object fsqDetalleEtiqueta: TfrxDBDataset
    UserName = 'detalleetiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FO_PRODUCTO=FO_PRODUCTO'
      'FO_DESCRIPCION=FO_DESCRIPCION'
      'FO_UNDDESCARGA=FO_UNDDESCARGA'
      'FO_PRECIO_CALCULADO=FO_PRECIO_CALCULADO')
    DataSet = sqDetalleetiqueta
    BCDToCurrency = False
    Left = 392
    Top = 168
  end
  object fsqDetalleEtiqueta2: TfrxDBDataset
    UserName = 'detalleetiqueta2'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FI_CODIGO=FI_CODIGO'
      'FI_DESCRIPCION=FI_DESCRIPCION'
      'FI_CAPACIDAD=FI_CAPACIDAD'
      'FIC_P01PRECIOTOTALEXT=FIC_P01PRECIOTOTALEXT')
    DataSet = sqDetalleetiquetaInventario
    BCDToCurrency = False
    Left = 184
    Top = 16
  end
end
