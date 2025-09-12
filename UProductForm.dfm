object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Gestión de Productos'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Código'
  end
  object EditCodigo: TEdit
    Left = 80
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'C-64'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 57
    Height = 13
    Caption = 'Descripción'
  end
  object EditDescripcion: TEdit
    Left = 80
    Top = 45
    Width = 209
    Height = 21
    TabOrder = 1
    Text = 'ACCESORIO DEMA S565 - GUICALLERA'
  end
  object Label3: TLabel
    Left = 16
    Top = 80
    Width = 19
    Height = 13
    Caption = 'IVA'
  end
  object EditIVA: TEdit
    Left = 80
    Top = 77
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '16%'
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 28
    Height = 13
    Caption = 'Costo'
  end
  object EditCosto: TEdit
    Left = 80
    Top = 109
    Width = 73
    Height = 21
    TabOrder = 3
    Text = '36.00'
  end
  object Label5: TLabel
    Left = 16
    Top = 144
    Width = 29
    Height = 13
    Caption = 'Precio'
  end
  object EditPrecio: TEdit
    Left = 80
    Top = 141
    Width = 73
    Height = 21
    TabOrder = 4
    Text = '909.72'
  end
  object ButtonGuardar: TButton
    Left = 200
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Guardar'
    TabOrder = 5
    OnClick = ButtonGuardarClick
  end
end