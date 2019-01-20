object VideoEncrypterForm: TVideoEncrypterForm
  Left = 0
  Top = 0
  Caption = 'Video Encrypter'
  ClientHeight = 477
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object LabelSubjectNumber: TLabel
    Left = 25
    Top = 25
    Width = 97
    Height = 16
    Caption = 'Subject Number:'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Font.Quality = fqDraft
    ParentColor = False
    ParentFont = False
  end
  object LabelSubjectNumberHelp: TLabel
    Left = 116
    Top = 55
    Width = 113
    Height = 16
    Caption = '(5 digits like 00001)'
    Color = clBtnFace
    ParentColor = False
  end
  object EditSubjectNumber: TEdit
    Left = 24
    Top = 48
    Width = 80
    Height = 24
    TabOrder = 0
  end
  object UploadButton: TButton
    Left = 264
    Top = 435
    Width = 108
    Height = 30
    Action = ActionUploadFiles
    Caption = '&Encrypt Files'
    TabOrder = 1
  end
  object ProgressBarUpload: TProgressBar
    Left = 24
    Top = 435
    Width = 217
    Height = 30
    ParentShowHint = False
    Smooth = True
    Step = 1
    ShowHint = False
    TabOrder = 2
  end
  object GroupBoxVideo: TGroupBox
    Left = 24
    Top = 78
    Width = 350
    Height = 250
    Caption = 'Videos:'
    TabOrder = 3
    object ListBoxVideos: TListBox
      Left = 2
      Top = 18
      Width = 346
      Height = 230
      Align = alClient
      Enabled = False
      Sorted = True
      TabOrder = 0
      OnDblClick = ListBoxVideosDblClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 26
    Top = 334
    Width = 350
    Height = 92
    Caption = 'USB Drives:'
    TabOrder = 4
    object ListBoxUSBDrives: TListBox
      Left = 2
      Top = 18
      Width = 346
      Height = 72
      Align = alClient
      Sorted = True
      TabOrder = 0
    end
  end
  object ActionList1: TActionList
    Left = 281
    Top = 27
    object ActionUploadFiles: TAction
      Caption = '&Upload Files'
      ShortCut = 16469
      OnExecute = ActionUploadFilesExecute
      OnUpdate = ActionUploadFilesUpdate
    end
    object FileOpen1: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
    end
    object FileOpen2: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
    end
    object FileOpen3: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
    end
    object FileOpen4: TFileOpen
      Caption = '...'
      Dialog.Filter = 'PDF Files|*.PDF|Word Files|*.docx;*.doc|All Files|*.*'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
    end
  end
end
