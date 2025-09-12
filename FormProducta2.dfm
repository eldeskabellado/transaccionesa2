object FormProducta2: TFormProducta2
  Left = 0
  Top = 0
  Caption = 'Ingreso/Modificaci'#243'n de Producto'
  ClientHeight = 540
  ClientWidth = 800
  Position = poScreenCenter
  OnCreate = FormCreate
  OldCreateOrder = False

  object rgIdioma: TRadioGroup
    Left = 16
    Top = 8
    Width = 240
    Height = 49
    Caption = 'Idioma'
    Items.Strings = (
      'Espa'#241'ol'
      'Chino Tradicional')
    TabOrder = 0
  end

  object gbBasico: TGroupBox
    Left = 16
    Top = 72
    Width = 760
    Height = 130
    Caption = 'F1. B'#225'sico'
    TabOrder = 1

    object lblCodigo: TLabel
      Left = 16
      Top = 28
      Caption = 'Codigo'
    end
    object edtCodigo: TEdit
      Left = 72
      Top = 25
      Width = 120
      Height = 21
      TabOrder = 0
    end
    object lblDescripcion: TLabel
      Left = 210
      Top = 28
      Caption = 'Descripci'#243'n'
    end
    object edtDescripcion: TEdit
      Left = 288
      Top = 25
      Width = 200
      Height = 21
      TabOrder = 1
    end
    object lblCategoria: TLabel
      Left = 510
      Top = 28
      Caption = 'Categor'#237'a'
    end
    object cbCategoria: TComboBox
      Left = 576
      Top = 25
      Width = 160
      Height = 21
      TabOrder = 2
      Style = csDropDownList
    end

    object lblIVA: TLabel
      Left = 16
      Top = 65
      Caption = 'I.V.A'
    end
    object cbIVA: TComboBox
      Left = 72
      Top = 62
      Width = 60
      Height = 21
      TabOrder = 3
      Style = csDropDownList
    end

    object lblCosto: TLabel
      Left = 147
      Top = 65
      Caption = 'Costo'
    end
    object edtCosto: TEdit
      Left = 192
      Top = 62
      Width = 60
      Height = 21
      TabOrder = 4
    end

    object lblDivisaCosto: TLabel
      Left = 264
      Top = 65
      Caption = 'Divisa'
    end
    object edtDivisaCosto: TEdit
      Left = 304
      Top = 62
      Width = 60
      Height = 21
      TabOrder = 5
    end

    object lblGanancia: TLabel
      Left = 375
      Top = 65
      Caption = 'Ganancia'
    end
    object edtGanancia: TEdit
      Left = 440
      Top = 62
      Width = 60
      Height = 21
      TabOrder = 6
    end

    object lblPrecio: TLabel
      Left = 512
      Top = 65
      Caption = 'Precio'
    end
    object edtPrecio: TEdit
      Left = 560
      Top = 62
      Width = 72
      Height = 21
      TabOrder = 7
    end

    object lblDivisaPrecio: TLabel
      Left = 644
      Top = 65
      Caption = 'Divisa'
    end
    object edtDivisaPrecio: TEdit
      Left = 684
      Top = 62
      Width = 44
      Height = 21
      TabOrder = 8
    end

    object cbDivisaAuto: TCheckBox
      Left = 644
      Top = 91
      Width = 81
      Height = 17
      Caption = 'Autom'#225'tico'
      TabOrder = 9
    end

  end

  object gbMayor: TGroupBox
    Left = 16
    Top = 210
    Width = 760
    Height = 120
    Caption = 'F2. Mayor'
    TabOrder = 2

    object sgMayor: TStringGrid
      Left = 16
      Top = 20
      Width = 728
      Height = 85
      ColCount = 6
      RowCount = 5
      FixedRows = 1
      FixedCols = 0
      TabOrder = 0
      DefaultRowHeight = 20
      ColWidths = (90, 70, 70, 90, 80, 100)
    end

  end

  object gbComprar: TGroupBox
    Left = 16
    Top = 340
    Width = 760
    Height = 60
    Caption = 'F3. Comprar'
    TabOrder = 3

    object lblBulto: TLabel
      Left = 18
      Top = 28
      Caption = 'Bulto'
    end
    object edtBulto: TEdit
      Left = 58
      Top = 24
      Width = 60
      Height = 21
      TabOrder = 0
    end
    object lblCant: TLabel
      Left = 136
      Top = 28
      Caption = 'Cant.'
    end
    object edtCant: TEdit
      Left = 176
      Top = 24
      Width = 60
      Height = 21
      TabOrder = 1
    end
    object lblStock: TLabel
      Left = 254
      Top = 28
      Caption = 'Stock:'
    end
    object edtStock: TEdit
      Left = 294
      Top = 24
      Width = 60
      Height = 21
      TabOrder = 2
      ReadOnly = True
    end
  end

  object btnGuardar: TButton
    Left = 16
    Top = 420
    Width = 90
    Height = 28
    Caption = 'Guardar'
    TabOrder = 4
  end
  object btnEtiqueta: TButton
    Left = 116
    Top = 420
    Width = 120
    Height = 28
    Caption = 'Etiqueta del Precio'
    TabOrder = 5
  end
  object btnStock: TButton
    Left = 246
    Top = 420
    Width = 90
    Height = 28
    Caption = 'Stock'
    TabOrder = 6
  end
  object btnEntradas: TButton
    Left = 346
    Top = 420
    Width = 120
    Height = 28
    Caption = 'Entrante y saliente'
    TabOrder = 7
  end
  object btnBarras: TButton
    Left = 476
    Top = 420
    Width = 90
    Height = 28
    Caption = 'C.Barras'
    TabOrder = 8
  end
  object btnSupBor: TButton
    Left = 576
    Top = 420
    Width = 90
    Height = 28
    Caption = 'Sup.Borrar'
    TabOrder = 9
  end

end