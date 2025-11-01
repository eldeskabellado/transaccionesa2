object formCXP: TformCXP
  Left = 0
  Top = 0
  Caption = 'formCXP'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblProveedor: TLabel
    Left = 24
    Top = 56
    Width = 65
    Height = 13
    Caption = 'lblProveedor'
  end
  object edt1: TEdit
    Left = 24
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    OnChange = edt1Change
  end
  object btn1: TButton
    Left = 168
    Top = 22
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 96
    Width = 577
    Height = 321
    DataSource = dsqCXP
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object sqCXP: TDBISAMQuery
    Left = 536
    Top = 24
  end
  object dsqCXP: TDataSource
    Left = 568
    Top = 24
  end
end