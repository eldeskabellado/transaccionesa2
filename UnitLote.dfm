object formLotes: TformLotes
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'SELECCIONA EL LOTE'
  ClientHeight = 297
  ClientWidth = 217
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 217
    Height = 209
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 512
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 217
      Height = 209
      Align = alClient
      DataSource = dsLotes
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
          FieldName = 'FL_LOTE'
          Title.Caption = 'LOTE'
          Width = 179
          Visible = True
        end>
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 224
    Width = 217
    Height = 73
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 512
    object btnCancelar: TButton
      Left = 1
      Top = 1
      Width = 215
      Height = 71
      Align = alClient
      Caption = 'Cancelar'
      TabOrder = 0
      OnClick = btnCancelarClick
      ExplicitLeft = 192
      ExplicitTop = 16
      ExplicitWidth = 75
      ExplicitHeight = 25
    end
  end
  object sqLotes: TDBISAMQuery
    DatabaseName = 'data2'
    EngineVersion = '4.49 Build 4'
    Params = <>
    Left = 164
    Top = 237
  end
  object dsLotes: TDataSource
    DataSet = sqLotes
    Left = 104
    Top = 152
  end
end
