object Form21: TForm21
  Left = 97
  Top = 108
  Caption = 'Simulation d'#39'automatismes M.TACK Ao'#251't 2013'
  ClientHeight = 504
  ClientWidth = 897
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 504
    Align = alLeft
    TabOrder = 0
    object chkA: TCheckBox
      Left = 8
      Top = 8
      Width = 33
      Height = 25
      Caption = 'A'
      TabOrder = 0
    end
    object chkB: TCheckBox
      Left = 48
      Top = 8
      Width = 33
      Height = 25
      Caption = 'B'
      TabOrder = 1
    end
    object chkC: TCheckBox
      Left = 8
      Top = 32
      Width = 33
      Height = 25
      Caption = 'C'
      TabOrder = 2
    end
    object chkD: TCheckBox
      Left = 48
      Top = 32
      Width = 33
      Height = 25
      Caption = 'D'
      TabOrder = 3
    end
    object chkE: TCheckBox
      Left = 8
      Top = 56
      Width = 33
      Height = 25
      Caption = 'E'
      TabOrder = 4
    end
    object chkF: TCheckBox
      Left = 48
      Top = 56
      Width = 33
      Height = 25
      Caption = 'F'
      TabOrder = 5
    end
    object chkH: TCheckBox
      Left = 48
      Top = 80
      Width = 33
      Height = 25
      Caption = 'H'
      TabOrder = 6
    end
    object chkG: TCheckBox
      Left = 8
      Top = 80
      Width = 33
      Height = 25
      Caption = 'G'
      TabOrder = 7
    end
    object fscmd: TListBox
      Left = 8
      Top = 120
      Width = 73
      Height = 97
      Enabled = False
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 8
    end
  end
  object Memo1: TMemo
    Left = 112
    Top = 384
    Width = 297
    Height = 249
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
    Visible = False
  end
  object flash11: TShockwaveFlash
    Left = 384
    Top = 32
    Width = 417
    Height = 281
    TabOrder = 2
    ControlData = {
      67556655000E0000192B00000B1D000008000200000000000800000000000800
      0000000008000E000000570069006E0064006F00770000000800060000002D00
      310000000800060000002D003100000008000A00000048006900670068000000
      08000200000000000800060000002D0031000000080000000000080002000000
      0000080010000000530068006F00770041006C006C0000000800040000003000
      0000080004000000300000000800020000000000080000000000080002000000
      00000D0000000000000000000000000000000000080004000000310000000800
      0400000030000000080000000000080004000000300000000800080000006100
      6C006C00000008000C000000660061006C0073006500000008000C0000006600
      61006C0073006500000008000C00000032003300320033003200000008000C00
      00007300630061006C0065000000}
  end
  object MainMenu1: TMainMenu
    Left = 72
    Top = 8
    object Fichier1: TMenuItem
      Caption = '&Fichier'
      object Nouveau1: TMenuItem
        Caption = '&Nouveau'
        OnClick = Nouveau1Click
      end
      object Ouvrir1: TMenuItem
        Caption = '&Ouvrir'
        OnClick = Ouvrir1Click
      end
      object Enregistrersous1: TMenuItem
        Caption = '&Enregistrer sous'
        OnClick = Enregistrersous1Click
      end
      object Enregistrer1: TMenuItem
        Caption = 'E&nregistrer'
        OnClick = Enregistrer1Click
      end
      object Quitter1: TMenuItem
        Caption = '&Quitter'
        OnClick = Quitter1Click
      end
    end
    object Edition1: TMenuItem
      Caption = '&Edition'
      object Ajoutertape1: TMenuItem
        Caption = '&Ajouter '#233'tape'
        OnClick = Ajoutertape1Click
      end
      object Supprimertape1: TMenuItem
        Caption = '&Supprimer '#233'tape'
        OnClick = Supprimertape1Click
      end
    end
    object Simulation1: TMenuItem
      Caption = '&Simulation'
      object Dmarrer1: TMenuItem
        Caption = '&D'#233'marrer'
        OnClick = Dmarrer1Click
      end
      object Stopper1: TMenuItem
        Caption = '&Stopper'
        OnClick = Stopper1Click
      end
    end
    object Paramtres1: TMenuItem
      Caption = '&Param'#232'tres'
      object Associeruneanimationflash1: TMenuItem
        Caption = '&Associer une animation flash'
        OnClick = Associeruneanimationflash1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 104
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Left = 144
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 176
    Top = 8
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 104
    Top = 40
  end
end
