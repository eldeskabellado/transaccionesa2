object formConectar: TformConectar
  Left = 0
  Top = 0
  Caption = 'formConectar'
  ClientHeight = 299
  ClientWidth = 635
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
  object imgQR: TImage
    Left = 376
    Top = 24
    Width = 193
    Height = 169
  end
  object lblEstado: TLabel
    Left = 376
    Top = 272
    Width = 43
    Height = 13
    Caption = 'lblEstado'
  end
  object imgLogo: TImage
    Left = 16
    Top = 48
    Width = 273
    Height = 105
  end
  object lblEmpresa: TLabel
    Left = 16
    Top = 227
    Width = 89
    Height = 23
    Caption = 'lblEstado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblEstado1: TLabel
    Left = 16
    Top = 208
    Width = 102
    Height = 13
    Caption = 'Se Autoriza su uso a:'
  end
  object btnMostrarQR: TButton
    Left = 376
    Top = 208
    Width = 193
    Height = 49
    Caption = 'Mostrar QR'
    TabOrder = 0
    OnClick = btnMostrarQRClick
  end
end
