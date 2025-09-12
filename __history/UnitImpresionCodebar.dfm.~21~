object formCodebar: TformCodebar
  Left = 0
  Top = 0
  Caption = 'formCodebar'
  ClientHeight = 115
  ClientWidth = 362
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 40
    Top = 8
    Width = 260
    Height = 23
    Alignment = taCenter
    Caption = 'Imprimir Etiquetas General'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 72
    Top = 120
    Width = 30
    Height = 23
    Alignment = taCenter
    Caption = '.....'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btn1: TButton
    Left = 120
    Top = 53
    Width = 169
    Height = 57
    Caption = 'Imprimir'
    TabOrder = 0
    OnClick = btn1Click
  end
  object frdtEtiqueta3: TfrxDBDataset
    UserName = 'Detalleetiqueta1'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FO_PRODUCTO=FO_PRODUCTO'
      'FO_DESCRIPCION=FO_DESCRIPCION'
      'FO_UNDDESCARGA=FO_UNDDESCARGA'
      'FO_MTOTOTAL=FO_MTOTOTAL')
    DataSet = SQDetEtiquetasPresentaciones1
    BCDToCurrency = False
    Left = 205
    Top = 230
  end
  object frpPresentaciones: TfrxReport
    Version = '6.9.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45363.482666122700000000
    ReportOptions.LastChange = 45842.432208946800000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      ''
      ''
      ''
      'begin'
      'end.')
    Left = 69
    Top = 62
    Datasets = <
      item
        DataSet = frdtEtiqueta3
        DataSetName = 'Detalleetiqueta1'
      end
      item
        DataSet = frdtDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
      end
      item
        DataSet = frdtInventario
        DataSetName = 'Inventario'
      end
      item
        DataSet = frdtPresentacion
        DataSetName = 'PresentacionArticulo'
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
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[PresentacionArticulo."FO_PRODUCTO"]')
          ParentFont = False
        end
        object fsqEtiquetaFO_DESCRIPCION: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 22.677180000000000000
          Width = 238.110390000000000000
          Height = 56.692950000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[PresentacionArticulo."FO_DESCRIPCION"]')
          ParentFont = False
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 86.929190000000000000
          Width = 80.000000000000000000
          Height = 34.015770000000000000
          BarType = bcCode128
          Expression = '<PresentacionArticulo."FO_PRODUCTO">'
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
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[PresentacionArticulo."FO_MTOTOTAL"]')
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
        DataSet = frdtEtiqueta3
        DataSetName = 'Detalleetiqueta1'
        RowCount = 0
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Top = 3.779530000000000000
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
          Top = 3.779530000000000000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataSet = frdtEtiqueta3
          DataSetName = 'Detalleetiqueta1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[Detalleetiqueta1."FO_UNDDESCARGA"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 22.677180000000000000
          Width = 241.889920000000000000
          Height = 41.574830000000000000
          DataField = 'FO_MTOTOTAL'
          DataSet = frdtEtiqueta3
          DataSetName = 'Detalleetiqueta1'
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
            '[Detalleetiqueta1."FO_MTOTOTAL"]')
          ParentFont = False
        end
      end
      object MasterData2: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 79.370130000000000000
        Top = 343.937230000000000000
        Width = 245.669450000000000000
        DataSet = frdtDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
        RowCount = 0
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Top = 26.456710000000000000
          Width = 238.110390000000000000
          Height = 41.574830000000000000
          DataSet = frdtDetalleEtiqueta2
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
            '[detalleetiqueta2."FIC_P01PRECIOTOTALEXT"] ')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Top = 7.559060000000000000
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
          Left = 113.385900000000000000
          Top = 7.559060000000000000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataSet = frdtDetalleEtiqueta2
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
      end
    end
  end
  object frpInventario: TfrxReport
    Version = '6.9.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45363.482666122700000000
    ReportOptions.LastChange = 45842.432208946800000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      ''
      ''
      ''
      'begin'
      'end.')
    Left = 21
    Top = 70
    Datasets = <
      item
        DataSet = frdtEtiqueta3
        DataSetName = 'Detalleetiqueta1'
      end
      item
        DataSet = frdtDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
      end
      item
        DataSet = frdtInventario
        DataSetName = 'Inventario'
      end
      item
        DataSet = frdtPresentacion
        DataSetName = 'PresentacionArticulo'
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
          Top = -3.779530000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[Inventario."FI_CODIGO"]')
          ParentFont = False
        end
        object fsqEtiquetaFO_DESCRIPCION: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 15.118120000000000000
          Width = 238.110390000000000000
          Height = 60.472480000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[Inventario."FI_DESCRIPCION"]')
          ParentFont = False
        end
        object BarCode1: TfrxBarCodeView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 79.370130000000000000
          Width = 80.000000000000000000
          Height = 41.574830000000000000
          BarType = bcCode128
          Expression = '<Inventario."FI_CODIGO">'
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
          DisplayFormat.FormatStr = '%2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -32
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[<Inventario."FIC_P01PRECIOTOTALEXT"> * 1.16]')
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
        DataSet = frdtEtiqueta3
        DataSetName = 'Detalleetiqueta1'
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
          Top = 3.779530000000000000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataSet = frdtEtiqueta3
          DataSetName = 'Detalleetiqueta1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[Detalleetiqueta1."FO_UNDDESCARGA"]')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 22.677180000000000000
          Width = 241.889920000000000000
          Height = 41.574830000000000000
          DataSet = frdtEtiqueta3
          DataSetName = 'Detalleetiqueta1'
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
            '[Detalleetiqueta1."FO_MTOTOTAL"]')
          ParentFont = False
        end
      end
      object MasterData2: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 68.031540000000000000
        Top = 343.937230000000000000
        Width = 245.669450000000000000
        DataSet = frdtDetalleEtiqueta2
        DataSetName = 'detalleetiqueta2'
        RowCount = 0
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 18.897650000000000000
          Width = 238.110390000000000000
          Height = 41.574830000000000000
          DataSet = frdtDetalleEtiqueta2
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
            '[<detalleetiqueta2."FIC_P01PRECIOTOTALEXT">]')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 117.165430000000000000
          Width = 41.574830000000000000
          Height = 15.118120000000000000
          DataSet = frdtDetalleEtiqueta2
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
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
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
      end
    end
  end
  object frdtDetalleEtiqueta2: TfrxDBDataset
    UserName = 'detalleetiqueta2'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FI_CODIGO=FI_CODIGO'
      'FI_DESCRIPCION=FI_DESCRIPCION'
      'FI_STATUS=FI_STATUS'
      'FI_UNIDAD=FI_UNIDAD'
      'FI_CAPACIDAD=FI_CAPACIDAD'
      'FIC_P01PRECIOTOTALEXT=FIC_P01PRECIOTOTALEXT')
    DataSet = SQDetalleetiquetaInventario1
    BCDToCurrency = False
    Left = 77
    Top = 22
  end
  object frdtInventario: TfrxDBDataset
    UserName = 'Inventario'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FI_CODIGO=FI_CODIGO'
      'FI_DESCRIPCION=FI_DESCRIPCION'
      'FI_STATUS=FI_STATUS'
      'FI_UNIDAD=FI_UNIDAD'
      'FI_CAPACIDAD=FI_CAPACIDAD'
      'FIC_P01PRECIOTOTALEXT=FIC_P01PRECIOTOTALEXT')
    DataSet = SQInventario1
    BCDToCurrency = False
    Left = 21
    Top = 22
  end
  object frdtPresentacion: TfrxDBDataset
    UserName = 'PresentacionArticulo'
    CloseDataSource = False
    FieldAliases.Strings = (
      'FO_PRODUCTO=FO_PRODUCTO'
      'FO_DESCRIPCION=FO_DESCRIPCION'
      'FO_UNDDESCARGA=FO_UNDDESCARGA'
      'FO_MTOTOTAL=FO_MTOTOTAL')
    DataSet = SQPresentacion1
    BCDToCurrency = False
    Left = 93
    Top = 214
  end
  object SQDetEtiquetasPresentaciones1: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, '
      '       (FO_MTOTOTAL / 110.56) AS FO_MTOTOTAL '
      'FROM sinvoferta '
      'WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA <> 1 ')
    Params = <>
    Left = 317
    Top = 126
  end
  object SQPresentacion1: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT FO_PRODUCTO, FO_DESCRIPCION, FO_UNDDESCARGA, '
      '       (FO_MTOTOTAL / 110.56) AS FO_MTOTOTAL '
      'FROM sinvoferta '
      'WHERE FO_VISIBLE = TRUE AND FO_UNDDESCARGA = 1 ')
    Params = <>
    Left = 264
    Top = 126
  end
  object SQInventario1: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT I.FI_CODIGO, I.FI_DESCRIPCION, I.FI_STATUS, '
      '       I.FI_UNIDAD, I.FI_CAPACIDAD, C.FIC_P01PRECIOTOTALEXT '
      'FROM SINVENTARIO AS I '
      
        'INNER JOIN a2InvCostosPrecios AS C ON I.FI_CODIGO = C.FIC_CODEIT' +
        'EM '
      'WHERE I.FI_STATUS = TRUE AND I.FI_CAPACIDAD = 1 ')
    Params = <>
    Left = 272
    Top = 174
  end
  object SQDetalleetiquetaInventario1: TDBISAMQuery
    Active = True
    DatabaseName = 'data2'
    EngineVersion = '4.43 Build 1'
    SQL.Strings = (
      'SELECT I.FI_CODIGO, I.FI_DESCRIPCION, I.FI_STATUS, '
      '       I.FI_UNIDAD, I.FI_CAPACIDAD, C.FIC_P01PRECIOTOTALEXT '
      'FROM SINVENTARIO AS I '
      
        'INNER JOIN a2InvCostosPrecios AS C ON I.FI_CODIGO = C.FIC_CODEIT' +
        'EM '
      'WHERE I.FI_STATUS = TRUE AND I.FI_CAPACIDAD <> 1 ')
    Params = <>
    Left = 204
    Top = 126
  end
end
