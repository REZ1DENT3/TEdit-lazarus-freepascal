object Form1: TForm1
  Left = 248
  Height = 468
  Top = 127
  Width = 917
  Caption = 'TEdit'
  ClientHeight = 448
  ClientWidth = 917
  Menu = MainMenu1
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '1.0.8.0'
  object PageControl1: TPageControl
    Left = 0
    Height = 425
    Top = 0
    Width = 917
    Align = alClient
    MultiLine = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    Options = [nboMultiLine]
  end
  object LabeledEdit1: TLabeledEdit
    Left = 584
    Height = 23
    Top = 16
    Width = 0
    EditLabel.AnchorSideLeft.Control = LabeledEdit1
    EditLabel.AnchorSideRight.Control = LabeledEdit1
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = LabeledEdit1
    EditLabel.Left = 584
    EditLabel.Height = 16
    EditLabel.Top = -3
    EditLabel.Width = 0
    EditLabel.Caption = 'LabeledEdit1'
    EditLabel.ParentColor = False
    TabOrder = 1
    Text = '0'
    Visible = False
  end
  object ListBox1: TListBox
    Left = 64
    Height = 96
    Top = 306
    Width = 832
    Align = alCustom
    Anchors = [akLeft, akRight, akBottom]
    Items.Strings = (
      'Место для отчётов!'
    )
    ItemHeight = 15
    OnDblClick = ListBox1DblClick
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Height = 23
    Top = 425
    Width = 917
    Panels = <>
  end
  object Button1: TButton
    Left = 840
    Height = 18
    Top = 306
    Width = 56
    Anchors = [akRight, akBottom]
    Caption = 'Закрыть'
    OnClick = Button1Click
    TabOrder = 3
  end
  inline SynEdit1: TSynEdit
    Left = 16
    Height = 0
    Top = 8
    Width = 0
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Quality = fqNonAntialiased
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    Visible = False
    Gutter.Width = 57
    Gutter.MouseActions = <>
    RightGutter.Width = 0
    RightGutter.MouseActions = <>
    Keystrokes = <    
      item
        Command = ecUp
        ShortCut = 38
      end    
      item
        Command = ecSelUp
        ShortCut = 8230
      end    
      item
        Command = ecScrollUp
        ShortCut = 16422
      end    
      item
        Command = ecDown
        ShortCut = 40
      end    
      item
        Command = ecSelDown
        ShortCut = 8232
      end    
      item
        Command = ecScrollDown
        ShortCut = 16424
      end    
      item
        Command = ecLeft
        ShortCut = 37
      end    
      item
        Command = ecSelLeft
        ShortCut = 8229
      end    
      item
        Command = ecWordLeft
        ShortCut = 16421
      end    
      item
        Command = ecSelWordLeft
        ShortCut = 24613
      end    
      item
        Command = ecRight
        ShortCut = 39
      end    
      item
        Command = ecSelRight
        ShortCut = 8231
      end    
      item
        Command = ecWordRight
        ShortCut = 16423
      end    
      item
        Command = ecSelWordRight
        ShortCut = 24615
      end    
      item
        Command = ecPageDown
        ShortCut = 34
      end    
      item
        Command = ecSelPageDown
        ShortCut = 8226
      end    
      item
        Command = ecPageBottom
        ShortCut = 16418
      end    
      item
        Command = ecSelPageBottom
        ShortCut = 24610
      end    
      item
        Command = ecPageUp
        ShortCut = 33
      end    
      item
        Command = ecSelPageUp
        ShortCut = 8225
      end    
      item
        Command = ecPageTop
        ShortCut = 16417
      end    
      item
        Command = ecSelPageTop
        ShortCut = 24609
      end    
      item
        Command = ecLineStart
        ShortCut = 36
      end    
      item
        Command = ecSelLineStart
        ShortCut = 8228
      end    
      item
        Command = ecEditorTop
        ShortCut = 16420
      end    
      item
        Command = ecSelEditorTop
        ShortCut = 24612
      end    
      item
        Command = ecLineEnd
        ShortCut = 35
      end    
      item
        Command = ecSelLineEnd
        ShortCut = 8227
      end    
      item
        Command = ecEditorBottom
        ShortCut = 16419
      end    
      item
        Command = ecSelEditorBottom
        ShortCut = 24611
      end    
      item
        Command = ecToggleMode
        ShortCut = 45
      end    
      item
        Command = ecCopy
        ShortCut = 16429
      end    
      item
        Command = ecPaste
        ShortCut = 8237
      end    
      item
        Command = ecDeleteChar
        ShortCut = 46
      end    
      item
        Command = ecCut
        ShortCut = 8238
      end    
      item
        Command = ecDeleteLastChar
        ShortCut = 8
      end    
      item
        Command = ecDeleteLastChar
        ShortCut = 8200
      end    
      item
        Command = ecDeleteLastWord
        ShortCut = 16392
      end    
      item
        Command = ecUndo
        ShortCut = 32776
      end    
      item
        Command = ecRedo
        ShortCut = 40968
      end    
      item
        Command = ecLineBreak
        ShortCut = 13
      end    
      item
        Command = ecSelectAll
        ShortCut = 16449
      end    
      item
        Command = ecCopy
        ShortCut = 16451
      end    
      item
        Command = ecBlockIndent
        ShortCut = 24649
      end    
      item
        Command = ecLineBreak
        ShortCut = 16461
      end    
      item
        Command = ecInsertLine
        ShortCut = 16462
      end    
      item
        Command = ecDeleteWord
        ShortCut = 16468
      end    
      item
        Command = ecBlockUnindent
        ShortCut = 24661
      end    
      item
        Command = ecPaste
        ShortCut = 16470
      end    
      item
        Command = ecCut
        ShortCut = 16472
      end    
      item
        Command = ecDeleteLine
        ShortCut = 16473
      end    
      item
        Command = ecDeleteEOL
        ShortCut = 24665
      end    
      item
        Command = ecUndo
        ShortCut = 16474
      end    
      item
        Command = ecRedo
        ShortCut = 24666
      end    
      item
        Command = ecGotoMarker0
        ShortCut = 16432
      end    
      item
        Command = ecGotoMarker1
        ShortCut = 16433
      end    
      item
        Command = ecGotoMarker2
        ShortCut = 16434
      end    
      item
        Command = ecGotoMarker3
        ShortCut = 16435
      end    
      item
        Command = ecGotoMarker4
        ShortCut = 16436
      end    
      item
        Command = ecGotoMarker5
        ShortCut = 16437
      end    
      item
        Command = ecGotoMarker6
        ShortCut = 16438
      end    
      item
        Command = ecGotoMarker7
        ShortCut = 16439
      end    
      item
        Command = ecGotoMarker8
        ShortCut = 16440
      end    
      item
        Command = ecGotoMarker9
        ShortCut = 16441
      end    
      item
        Command = ecSetMarker0
        ShortCut = 24624
      end    
      item
        Command = ecSetMarker1
        ShortCut = 24625
      end    
      item
        Command = ecSetMarker2
        ShortCut = 24626
      end    
      item
        Command = ecSetMarker3
        ShortCut = 24627
      end    
      item
        Command = ecSetMarker4
        ShortCut = 24628
      end    
      item
        Command = ecSetMarker5
        ShortCut = 24629
      end    
      item
        Command = ecSetMarker6
        ShortCut = 24630
      end    
      item
        Command = ecSetMarker7
        ShortCut = 24631
      end    
      item
        Command = ecSetMarker8
        ShortCut = 24632
      end    
      item
        Command = ecSetMarker9
        ShortCut = 24633
      end    
      item
        Command = EcFoldLevel1
        ShortCut = 41009
      end    
      item
        Command = EcFoldLevel2
        ShortCut = 41010
      end    
      item
        Command = EcFoldLevel1
        ShortCut = 41011
      end    
      item
        Command = EcFoldLevel1
        ShortCut = 41012
      end    
      item
        Command = EcFoldLevel1
        ShortCut = 41013
      end    
      item
        Command = EcFoldLevel6
        ShortCut = 41014
      end    
      item
        Command = EcFoldLevel7
        ShortCut = 41015
      end    
      item
        Command = EcFoldLevel8
        ShortCut = 41016
      end    
      item
        Command = EcFoldLevel9
        ShortCut = 41017
      end    
      item
        Command = EcFoldLevel0
        ShortCut = 41008
      end    
      item
        Command = EcFoldCurrent
        ShortCut = 41005
      end    
      item
        Command = EcUnFoldCurrent
        ShortCut = 41003
      end    
      item
        Command = EcToggleMarkupWord
        ShortCut = 32845
      end    
      item
        Command = ecNormalSelect
        ShortCut = 24654
      end    
      item
        Command = ecColumnSelect
        ShortCut = 24643
      end    
      item
        Command = ecLineSelect
        ShortCut = 24652
      end    
      item
        Command = ecTab
        ShortCut = 9
      end    
      item
        Command = ecShiftTab
        ShortCut = 8201
      end    
      item
        Command = ecMatchBracket
        ShortCut = 24642
      end    
      item
        Command = ecColSelUp
        ShortCut = 40998
      end    
      item
        Command = ecColSelDown
        ShortCut = 41000
      end    
      item
        Command = ecColSelLeft
        ShortCut = 40997
      end    
      item
        Command = ecColSelRight
        ShortCut = 40999
      end    
      item
        Command = ecColSelPageDown
        ShortCut = 40994
      end    
      item
        Command = ecColSelPageBottom
        ShortCut = 57378
      end    
      item
        Command = ecColSelPageUp
        ShortCut = 40993
      end    
      item
        Command = ecColSelPageTop
        ShortCut = 57377
      end    
      item
        Command = ecColSelLineStart
        ShortCut = 40996
      end    
      item
        Command = ecColSelLineEnd
        ShortCut = 40995
      end    
      item
        Command = ecColSelEditorTop
        ShortCut = 57380
      end    
      item
        Command = ecColSelEditorBottom
        ShortCut = 57379
      end>
    MouseActions = <>
    MouseSelActions = <>
    VisibleSpecialChars = [vscSpace, vscTabAtLast]
    SelectedColor.BackPriority = 50
    SelectedColor.ForePriority = 50
    SelectedColor.FramePriority = 50
    SelectedColor.BoldPriority = 50
    SelectedColor.ItalicPriority = 50
    SelectedColor.UnderlinePriority = 50
    BracketHighlightStyle = sbhsBoth
    BracketMatchColor.Background = clNone
    BracketMatchColor.Foreground = clNone
    BracketMatchColor.Style = [fsBold]
    FoldedCodeColor.Background = clNone
    FoldedCodeColor.Foreground = clGray
    FoldedCodeColor.FrameColor = clGray
    MouseLinkColor.Background = clNone
    MouseLinkColor.Foreground = clBlue
    LineHighlightColor.Background = clNone
    LineHighlightColor.Foreground = clNone
    inline SynLeftGutterPartList1: TSynGutterPartList
      object SynGutterMarks1: TSynGutterMarks
        Width = 24
        MouseActions = <>
      end
      object SynGutterLineNumber1: TSynGutterLineNumber
        Width = 17
        MouseActions = <>
        MarkupInfo.Background = clBtnFace
        MarkupInfo.Foreground = clNone
        DigitCount = 2
        ShowOnlyLineNumbersMultiplesOf = 1
        ZeroStart = False
        LeadingZeros = False
      end
      object SynGutterChanges1: TSynGutterChanges
        Width = 4
        MouseActions = <>
        ModifiedColor = 59900
        SavedColor = clGreen
      end
      object SynGutterSeparator1: TSynGutterSeparator
        Width = 2
        MouseActions = <>
        MarkupInfo.Background = clWhite
        MarkupInfo.Foreground = clGray
      end
      object SynGutterCodeFolding1: TSynGutterCodeFolding
        MouseActions = <>
        MarkupInfo.Background = clNone
        MarkupInfo.Foreground = clGray
        MouseActionsExpanded = <>
        MouseActionsCollapsed = <>
      end
    end
  end
  object SynFreePascalSyn1: TSynFreePascalSyn
    DefaultFilter = 'Файлы Паскаля (*.pas,*.pp,*.dpr,*.dpk,*.inc)|*.pas;*.pp;*.dpr;*.dpk;*.inc'
    Enabled = False
    AsmAttri.Foreground = clActiveCaption
    AsmAttri.FrameEdges = sfeAround
    CommentAttri.Foreground = clBlue
    CommentAttri.FrameEdges = sfeAround
    CommentAttri.Style = [fsBold]
    IDEDirectiveAttri.Foreground = clHighlight
    IDEDirectiveAttri.FrameEdges = sfeAround
    IdentifierAttri.Foreground = clNavy
    IdentifierAttri.FrameEdges = sfeAround
    KeyAttri.Foreground = cl3DDkShadow
    KeyAttri.FrameEdges = sfeAround
    NumberAttri.Foreground = clOlive
    NumberAttri.FrameEdges = sfeAround
    SpaceAttri.Foreground = clPurple
    SpaceAttri.FrameEdges = sfeAround
    StringAttri.Foreground = clGreen
    StringAttri.FrameEdges = sfeAround
    SymbolAttri.Foreground = clBtnShadow
    SymbolAttri.FrameEdges = sfeAround
    CaseLabelAttri.Foreground = clRed
    CaseLabelAttri.FrameEdges = sfeAround
    DirectiveAttri.Foreground = clRed
    DirectiveAttri.FrameEdges = sfeAround
    DirectiveAttri.Style = [fsBold]
    CompilerMode = pcmObjFPC
    NestedComments = True
    left = 136
    top = 224
  end
  object MainMenu1: TMainMenu
    left = 136
    top = 144
    object MenuItem1: TMenuItem
      Caption = 'Файл'
      object MenuItem4: TMenuItem
        Caption = 'Создать'
        object MenuItem27: TMenuItem
          Caption = 'Pascal'
          object MenuItem31: TMenuItem
            Caption = 'Программа'
            OnClick = MenuItem31Click
          end
          object MenuItem32: TMenuItem
            Caption = 'Модуль'
            OnClick = MenuItem32Click
          end
        end
        object MenuItem28: TMenuItem
          Caption = 'PHP'
          OnClick = MenuItem28Click
        end
        object MenuItem29: TMenuItem
          Caption = 'C++'
          OnClick = MenuItem29Click
        end
        object MenuItem30: TMenuItem
          Caption = 'Cmd/Bat'
          OnClick = MenuItem30Click
        end
      end
      object MenuItem5: TMenuItem
        Caption = 'Открыть'
        ShortCut = 16463
        OnClick = MenuItem5Click
      end
      object MenuItem6: TMenuItem
        Caption = 'Сохранить'
        ShortCut = 16467
        OnClick = MenuItem6Click
      end
      object MenuItem7: TMenuItem
        Caption = 'Сохранить как'
        OnClick = MenuItem7Click
      end
      object MenuItem8: TMenuItem
        Caption = '-'
      end
      object MenuItem9: TMenuItem
        Caption = 'Выход'
        ShortCut = 16471
        OnClick = MenuItem9Click
      end
    end
    object MenuItem13: TMenuItem
      Caption = 'Правка'
      Visible = False
      object MenuItem14: TMenuItem
        Caption = 'Поиск'
        ShortCut = 16454
        OnClick = MenuItem14Click
      end
      object MenuItem34: TMenuItem
        Caption = 'Замена'
        ShortCut = 16456
        OnClick = MenuItem34Click
      end
    end
    object MenuItem15: TMenuItem
      Caption = 'Проект'
      object MenuItem17: TMenuItem
        Caption = 'Запуск'
        ShortCut = 116
        OnClick = MenuItem17Click
      end
      object MenuItem18: TMenuItem
        Caption = 'Компилировать'
        ShortCut = 119
        OnClick = MenuItem18Click
      end
    end
    object MenuItem10: TMenuItem
      Caption = 'Вкладки'
      object MenuItem11: TMenuItem
        Caption = 'Добавить'
        ShortCut = 24641
        OnClick = MenuItem11Click
      end
      object MenuItem12: TMenuItem
        Caption = 'Закрыть'
        ShortCut = 24643
        OnClick = MenuItem12Click
      end
    end
    object MenuItem20: TMenuItem
      Caption = 'Синтаксис'
      object MenuItem21: TMenuItem
        Caption = 'Free Pascal'
        ShortCut = 16496
        OnClick = MenuItem21Click
      end
      object MenuItem22: TMenuItem
        Caption = 'C++'
        ShortCut = 16497
        OnClick = MenuItem22Click
      end
      object MenuItem23: TMenuItem
        Caption = 'CMD'
        ShortCut = 16498
        OnClick = MenuItem23Click
      end
      object MenuItem24: TMenuItem
        Caption = 'PHP'
        ShortCut = 16499
        OnClick = MenuItem24Click
      end
      object MenuItem25: TMenuItem
        Caption = '-'
      end
      object MenuItem26: TMenuItem
        Caption = 'Сброс'
        ShortCut = 16507
        OnClick = MenuItem26Click
      end
    end
    object MenuItem16: TMenuItem
      Caption = 'Опции'
      OnClick = MenuItem16Click
    end
    object MenuItem19: TMenuItem
      Caption = 'О программе'
      OnClick = MenuItem19Click
    end
  end
  object PopupMenu1: TPopupMenu
    left = 224
    top = 144
    object MenuItem2: TMenuItem
      Caption = 'Добавить'
      OnClick = MenuItem2Click
    end
    object MenuItem3: TMenuItem
      Caption = 'Закрыть текущий'
      OnClick = MenuItem3Click
    end
    object MenuItem33: TMenuItem
      Caption = 'Переименовать'
      OnClick = MenuItem33Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Текстовый файл|*.txt'
    left = 304
    top = 144
  end
  object SynPHPSyn1: TSynPHPSyn
    DefaultFilter = 'Файлы PHP (*.php,*.php3,*.phtml,*.inc)|*.php;*.php3;*.phtml;*.inc'
    Enabled = False
    CommentAttri.Foreground = clGreen
    CommentAttri.FrameEdges = sfeAround
    IdentifierAttri.Foreground = clTeal
    IdentifierAttri.FrameEdges = sfeAround
    InvalidSymbolAttri.Foreground = clRed
    InvalidSymbolAttri.FrameEdges = sfeAround
    KeyAttri.Foreground = clBlue
    KeyAttri.FrameEdges = sfeAround
    NumberAttri.Foreground = clHighlight
    NumberAttri.FrameEdges = sfeAround
    SpaceAttri.Foreground = clPurple
    SpaceAttri.FrameEdges = sfeAround
    StringAttri.Foreground = clGreen
    StringAttri.FrameEdges = sfeAround
    SymbolAttri.Foreground = clRed
    SymbolAttri.FrameEdges = sfeAround
    VariableAttri.Foreground = clAppWorkspace
    VariableAttri.FrameEdges = sfeAround
    left = 224
    top = 224
  end
  object SynBatSyn1: TSynBatSyn
    DefaultFilter = 'Пакетные файлы MS-DOS (*.bat;*.cmd)|*.bat;*.cmd'
    Enabled = False
    CommentAttri.FrameEdges = sfeAround
    IdentifierAttri.FrameEdges = sfeAround
    KeyAttri.FrameEdges = sfeAround
    NumberAttri.FrameEdges = sfeAround
    SpaceAttri.FrameEdges = sfeAround
    VariableAttri.FrameEdges = sfeAround
    left = 304
    top = 224
  end
  object SynCppSyn1: TSynCppSyn
    DefaultFilter = 'Файлы C++ (*.c,*.cpp,*.h,*.hpp,*.hh)|*.c;*.cpp;*.h;*.hpp;*.hh'
    Enabled = False
    AsmAttri.FrameEdges = sfeAround
    CommentAttri.FrameEdges = sfeAround
    DirecAttri.FrameEdges = sfeAround
    IdentifierAttri.FrameEdges = sfeAround
    InvalidAttri.FrameEdges = sfeAround
    KeyAttri.FrameEdges = sfeAround
    NumberAttri.FrameEdges = sfeAround
    SpaceAttri.FrameEdges = sfeAround
    StringAttri.FrameEdges = sfeAround
    SymbolAttri.FrameEdges = sfeAround
    left = 384
    top = 224
  end
  object OpenDialog1: TOpenDialog
    left = 384
    top = 144
  end
  object FindDialog1: TFindDialog
    OnFind = FindDialog1Find
    left = 384
    top = 88
  end
  object ReplaceDialog1: TReplaceDialog
    Options = [frReplace]
    OnReplace = ReplaceDialog1Replace
    left = 304
    top = 88
  end
end
