object Form1: TForm1
  Left = 739
  Top = 149
  Width = 1069
  Height = 763
  Caption = 'Form1'
  Color = clActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mainImg: TImage
    Left = 16
    Top = 24
    Width = 257
    Height = 257
  end
  object fftImg: TImage
    Left = 296
    Top = 24
    Width = 257
    Height = 257
  end
  object FilterImg: TImage
    Left = 152
    Top = 312
    Width = 257
    Height = 257
  end
  object Label5: TLabel
    Left = 592
    Top = 144
    Width = 62
    Height = 13
    Caption = 'Restore with:'
  end
  object Label3: TLabel
    Left = 592
    Top = 200
    Width = 65
    Height = 13
    Caption = 'Show Output:'
  end
  object Label1: TLabel
    Left = 824
    Top = 168
    Width = 7
    Height = 13
    Caption = 'X'
  end
  object Label2: TLabel
    Left = 872
    Top = 168
    Width = 7
    Height = 13
    Caption = 'Y'
  end
  object Label4: TLabel
    Left = 688
    Top = 168
    Width = 129
    Height = 13
    Caption = #1054#1078#1080#1076#1072#1077#1084#1099#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099':'
  end
  object Label6: TLabel
    Left = 688
    Top = 128
    Width = 119
    Height = 13
    Caption = #1053#1072#1081#1076#1077#1085#1099#1077' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099':'
  end
  object loadMainImage: TButton
    Left = 592
    Top = 64
    Width = 129
    Height = 33
    Caption = 'load image'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = loadMainImageClick
  end
  object Filter: TCheckBox
    Left = 592
    Top = 120
    Width = 73
    Height = 17
    Caption = 'Filter'
    TabOrder = 1
    OnClick = ExecDemo
  end
  object invFFT: TCheckBox
    Left = 592
    Top = 160
    Width = 73
    Height = 17
    Caption = 'InvFFT'
    TabOrder = 2
    OnClick = ExecDemo
  end
  object RBModule: TRadioButton
    Left = 592
    Top = 216
    Width = 58
    Height = 17
    Caption = 'Module'
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = ExecDemo
  end
  object RBPhase: TRadioButton
    Left = 592
    Top = 232
    Width = 58
    Height = 17
    Caption = 'Phase'
    TabOrder = 4
    OnClick = ExecDemo
  end
  object RBReal: TRadioButton
    Left = 592
    Top = 248
    Width = 58
    Height = 17
    Caption = 'Real'
    TabOrder = 5
    OnClick = ExecDemo
  end
  object RBImag: TRadioButton
    Left = 592
    Top = 264
    Width = 58
    Height = 17
    Caption = 'Imag'
    TabOrder = 6
    OnClick = ExecDemo
  end
  object HeightFilter: TLabeledEdit
    Left = 816
    Top = 120
    Width = 33
    Height = 21
    EditLabel.Width = 7
    EditLabel.Height = 13
    EditLabel.Caption = 'X'
    Enabled = False
    MaxLength = 3
    TabOrder = 7
    Text = '0'
  end
  object WidthFilter: TLabeledEdit
    Left = 856
    Top = 120
    Width = 33
    Height = 21
    EditLabel.Width = 7
    EditLabel.Height = 13
    EditLabel.Caption = 'Y'
    Enabled = False
    MaxLength = 3
    TabOrder = 8
    Text = '0'
  end
  object Dsquer: TLabeledEdit
    Left = 592
    Top = 32
    Width = 41
    Height = 21
    EditLabel.Width = 129
    EditLabel.Height = 13
    EditLabel.Caption = #1044#1083#1080#1085#1072' '#1089#1090#1086#1088#1086#1085#1099' '#1082#1074#1072#1076#1088#1072#1090#1072
    TabOrder = 9
    Text = '8'
  end
end
