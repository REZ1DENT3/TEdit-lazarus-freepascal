unit unit1;

{$mode objfpc}{$H+}
{$ASMMODE INTEL}
{$MACRO ON}

//{$DEFINE DEVELOP}
{$DEFINE BUILD:='TEdit 3.20.0.7'}

{$IFDEF DEVELOP}
 {$APPTYPE CONSOLE}
{$ELSE DEVELOP}
 {$WARNINGS OFF}
 {$NOTES OFF}
{$ENDIF}

interface

uses
  Classes,SynHighlighterPas,SynHighlighterPHP,SynHighlighterBat,SynHighlighterCpp,
  SynEdit,Forms,Dialogs,ExtCtrls,ComCtrls,Menus,StdCtrls;

type

  Settings = record
   CheckGroup:array[0..19] of boolean;
   Edit3Cpp,Edit4Fpc,Parametrs:String[255];
  end;

  TRec = record
    FPath:String;
    FName:String;
    Path:String;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    FindDialog1: TFindDialog;
    LabeledEdit1: TLabeledEdit;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    MenuItem1,MenuItem10,MenuItem11,MenuItem13,MenuItem14,MenuItem15,
    MenuItem16,MenuItem17,MenuItem18,MenuItem19,MenuItem2,MenuItem20,
    MenuItem21,MenuItem22,MenuItem23,MenuItem24,MenuItem25,MenuItem26,
    MenuItem27,MenuItem28,MenuItem29,MenuItem3,MenuItem30,MenuItem31,
    MenuItem32,MenuItem33,MenuItem34,MenuItem4,MenuItem5,MenuItem6,
    MenuItem7,MenuItem8,MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    ReplaceDialog1: TReplaceDialog;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    SynBatSyn1: TSynBatSyn;
    SynCppSyn1: TSynCppSyn;
    SynEdit1: TSynEdit;
    SynFreePascalSyn1: TSynFreePascalSyn;
    SynPHPSyn1: TSynPHPSyn;
    procedure Button1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem23Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem28Click(Sender: TObject);
    procedure MenuItem29Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem30Click(Sender: TObject);
    procedure MenuItem31Click(Sender: TObject);
    procedure MenuItem32Click(Sender: TObject);
    procedure MenuItem33Click(Sender: TObject);
    procedure MenuItem34Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure AddTabSM;
    {$IFDEF DEVELOP}procedure DebugLn(Str:String);{$ENDIF}
    procedure FileName(var Str:String);
    procedure MenuItem6Click(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure SaveFile(SaveAs:boolean=false);
    function CloseProgram:boolean;
    procedure SaveConv(var Str:String;Path:String;t:boolean=true);
    function Compile(Comp:boolean=true):String;
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    function ResultPath:TRec;
  end;

Const Path = 'TEdit.cfg';

var
  Form1: TForm1;
  FS:TFileStream = nil;
  SetSett:Settings;

implementation

uses
  SysUtils,SynMemo,Controls,Unit2,Unit3,Unit4,eSportBased,eSportOSInfo;

var
  OSInf:OSInfo;
  Timer:eSTimer;

{$R *.lfm}

{ TForm1 }

function TForm1.ResultPath:TRec;
var FName,Path:String;
begin
 Path:=TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text;
 Path:=copy(Path,0,pos(ExtractFileExt(Path),Path)-1)+'.exe';
 FName:=ExtractFileName(Path);
 if Form4.CheckBox1.Checked then begin

  if Pos('-FE',UpCase(Form4.Edit1.Text))=0 then
   Path:=copy(Path,0,pos(FName,Path)-1);

  if Pos('-FE',UpCase(Form4.Edit1.Text))>0 then
   Path:=copy(UpCase(Form4.Edit1.Text)+' ',
    Pos('-FE',UpCase(Form4.Edit1.Text))+3,
     pos(' ',copy(UpCase(Form4.Edit1.Text)+' ',
      Pos('-FE',UpCase(Form4.Edit1.Text))+3,
       length(Form4.Edit1.Text)))-1);

  if Pos('-O',UpCase(Form4.Edit1.Text))>0 then begin
   FName:=copy(UpCase(Form4.Edit1.Text)+' ',
    Pos('-O',UpCase(Form4.Edit1.Text))+2,
    length(UpCase(Form4.Edit1.Text)));
   FName:=copy(FName,1,Pos(' ',FName));
  end;

  if (Path[Length(Path)]='\') or ((Path[Length(Path)]='/')) then
   delete(Path,Length(Path),1);

  {$IFDEF DEVELOP}
   DebugLn(Path+' '+ExtractFilePath(Path+'/'+FName)+' '+ExtractFileName(Path+'/'+FName));
  {$ENDIF}
 end else begin
  FName:=ExtractFileName(Path);
  Path:=ExtractFilePath(Path);
 end;
 ResultPath.FName:=FName;
 ResultPath.FPath:=Path+'/'+FName;
 ResultPath.Path:=Path+'/';
end;

{$IFDEF DEVELOP}
procedure TForm1.DebugLn(Str:String);
begin
 UTF8ToOEM866(Str);
 {$I-}writeln(Str);{$I+}
end;
{$ENDIF}

function TForm1.Compile(Comp:boolean=true):String;
var Str:String;
    i:integer;
    T:array of string;
begin
  SetLength(T,14);
  T[0]:=' -O1'; T[1]:=' -O2'; T[2]:=' -O3';
  T[3]:=' -Mfpc'; T[4]:=' -Mobjfpc'; T[5]:=' -Mdelphi';
  T[6]:=' -Mtp'; T[7]:=' -S2'; T[8]:=' -Mmacpas';
  T[9]:=' -Sc'; T[10]:=' -Sg'; T[11]:=' -Sh';
  T[12]:=' -Sx'; T[13]:=' -Si';
  if Comp then begin // FPC
      Str:=copy(Form4.Edit4.Text,0,pos('%file',Form4.Edit4.Text)-1)+' -gl -Crtoi -ap -viwn -XP -Xs -XX ';
      for i:=0 to Form4.CheckGroup1.Items.Count-1 do
          if Form4.CheckGroup1.Checked[i] then Str:=Str+T[i];
      for i:=0 to Form4.ListBox1.Items.Count-1 do
          Str+=' -Fu'+Form4.ListBox1.Items[i]+' ';
      if Form4.CheckBox1.Checked and (Form4.Edit1.Text<>'') then
         Str+=' '+trim(Form4.Edit1.Text)+' ';
      Compile:=Str;
  end else // C++
      Compile:=copy(Form4.Edit3.Text,0,pos('%file',Form4.Edit3.Text)-1);
end;

function TForm1.CloseProgram:boolean;
var R:Word;
begin
  while (PageControl1.PageCount<>0) do begin
    if not(TSynMemo(PageControl1.ActivePage.Controls[0]).Modified) or
     (trim(TSynMemo(PageControl1.ActivePage.Controls[0]).text)='') then
        PageControl1.ActivePage.Free
    else begin
        R:=MessageDLG('Внесены изменения, сохранить?',mtConfirmation,mbYesNoCancel,0);
        case R of
          6:begin                         // Yes
            Form1.SaveFile(true);
            PageControl1.ActivePage.Free;
          end;
          7:PageControl1.ActivePage.Free;       // NO
          2:CloseProgram:=false;
        end;
        if R=2 then break;        // Cancel
    end;
    if (PageControl1.PageCount=0) then CloseProgram:=true;
  end;
  {$IFDEF DEVELOP}
   Timer.Stop;
   DebugLn(Timer.STime);
   readln;
  {$ENDIF}
end;

procedure TForm1.SaveConv(var Str:String;Path:String;t:boolean=true);
begin
  case ExtractFileExt(Path) of
       '.pas','.pp','.dpr','.dpk':begin
           TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynFreePascalSyn1;
           if Form4.CheckGroup1.Checked[14] then begin
              if t then
                 UTF8ToOEM866(Str)
              else OEM866ToUTF8(Str)
           end else begin
              if t then
                 UTF8ToWindows1251(Str)
              else Windows1251ToUTF8(Str);
           end;
       end;
       '.php','.php3','.phtml':TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynPHPSyn1;
       '.c','.cpp','.h','.hpp','.hh':begin
           TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynCppSyn1;
           if t then
             UTF8ToWindows1251(Str)
           else Windows1251ToUTF8(Str);
       end;
       '.bat','.cmd':TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynBatSyn1;
  end;
end;

procedure TForm1.SaveFile(SaveAs:boolean);
var FileSave:String;
    Str:String;
begin
  if DirectoryExists(ExtractFilePath(Application.ExeName)+'Project/') then
     SaveDialog1.InitialDir:=ExtractFilePath(Application.ExeName)+'Project/';
  if (TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter<>nil) then
     SaveDialog1.Filter:=TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter.DefaultFilter;
  SaveDialog1.FileName:=PageControl1.ActivePage.Caption;
  Str:=TSynMemo(PageControl1.ActivePage.Controls[0]).Text;
  if (SaveAs) and (TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text<>'') then begin
     FileSave:=TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text;
     SaveConv(Str,FileSave);
     with TSynMemo(PageControl1.ActivePage.Controls[0]) do begin
       Lines.SaveToFile(FileSave);
       Modified := false;
     end;
     SynEdit1.Text:=Str;
     SynEdit1.Lines.SaveToFile(FileSave);
  end else if (SaveDialog1.Execute) then begin
     FileSave:=SaveDialog1.FileName;
     SaveConv(Str,FileSave);
     with TSynMemo(PageControl1.ActivePage.Controls[0]) do begin
       Lines.SaveToFile(SaveDialog1.FileName);
       Modified := false;
     end;
     SynEdit1.Text:=Str;
     SynEdit1.Lines.SaveToFile(FileSave);
     TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text:=SaveDialog1.FileName;
     FileName(FileSave);
     PageControl1.ActivePage.Caption:=FileSave;
  end;
end;

procedure TForm1.AddTabSM;
var SynMemo:TSynMemo;
    LabelEd:TLabeledEdit;
    PageCon:TTabSheet;
    Count:integer;
begin

  Count:= StrToInt(LabeledEdit1.Text)+1;

  PageCon:=PageControl1.AddTabSheet;
  PageCon.Caption:='Новый '+FloatToStr(Count);

  SynMemo:=TSynMemo.Create(self);
  LabelEd:=TLabeledEdit.Create(self);

  SynMemo.Parent:=PageCon;
  LabelEd.Parent:=PageCon;
  LabelEd.Visible:=false;
  LabelEd.Text:='';

  SynMemo.Align:=alClient;
  SynMemo.Highlighter:=nil;

  PageControl1.ActivePage:=PageCon;

  LabeledEdit1.Text:=IntToStr(Count);

  StatusBar1.SimpleText:=' Вкладка #'+LabeledEdit1.Text+' добавлена.';

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
var Str:String;
 function StrIsNoNil(Str:String):boolean;
 begin
  if (Length(Str)>0) then
   Str:=trim(Str);
  StrIsNoNil:=(Str<>'');
 end;
begin
 if (OpenDialog1.Execute) then
  if FileExists(OpenDialog1.FileName) then begin
   if StrIsNoNil(TSynMemo(PageControl1.ActivePage.Controls[0]).Text) then
    AddTabSM;

   TSynMemo(PageControl1.ActivePage.Controls[0]).Lines.LoadFromFile(OpenDialog1.FileName);
   Str:=TSynMemo(PageControl1.ActivePage.Controls[0]).Text;
   SaveConv(Str,OpenDialog1.FileName,false);
   TSynMemo(PageControl1.ActivePage.Controls[0]).Text:=Str;

   TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text:=OpenDialog1.FileName;
   Str:=OpenDialog1.FileName;
   FileName(Str);
   PageControl1.ActivePage.Caption:=Str;
  end else ShowMessage('Файл не найден!');
end;

procedure TForm1.FileName(var Str:String);
begin
  while (pos('\',Str)>0) do
   delete(Str,1,pos('\',Str));
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  SaveFile(true);
end;

procedure TForm1.ReplaceDialog1Replace(Sender: TObject);
var i:integer;
    s:string;
begin
 if pos(UpCase(ReplaceDialog1.FindText),UpCase(TSynMemo(PageControl1.ActivePage.Controls[0]).Text))>0 then begin
  s:=TSynMemo(PageControl1.ActivePage.Controls[0]).Text;
  i:=pos(UpCase(ReplaceDialog1.FindText),UpCase(s));
  delete(s,i,length(ReplaceDialog1.FindText));
  insert(ReplaceDialog1.ReplaceText,s,i);
  TSynMemo(PageControl1.ActivePage.Controls[0]).Text:=s;
 end;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  SaveFile;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var R:Word;
begin
 if not(TSynMemo(PageControl1.ActivePage.Controls[0]).Modified) or
   (trim(TSynMemo(PageControl1.ActivePage.Controls[0]).text)='') then begin
  PageControl1.ActivePage.Free;
  if (PageControl1.PageCount=0) then begin
   LabeledEdit1.Text:='0';
   AddTabSM;
  end;
  StatusBar1.SimpleText:=' Вкладка закрыта';
 end else begin
  R:=MessageDLG('Внесены изменения, сохранить?',mtConfirmation,mbYesNoCancel,0);
  case R of
   mrYes:begin
    Form1.SaveFile(true);
    PageControl1.ActivePage.Free;
    if (PageControl1.PageCount=0) then begin
     LabeledEdit1.Text:='0';
     AddTabSM;
    end;
    StatusBar1.SimpleText:=' Вкладка закрыта';
   end;
   mrNo:begin
    PageControl1.ActivePage.Free;
    if (PageControl1.PageCount=0) then begin
     LabeledEdit1.Text:='0';
     AddTabSM;
    end;
    StatusBar1.SimpleText:=' Вкладка закрыта';
   end;
  end;
 end;
end;

procedure TForm1.FormShow(Sender: TObject);
var i:shortint;
begin
 OSInf:=OSInfo.Create;
 Timer:=eSTimer.Create;
  {$IFDEF DEVELOP}
  DebugLn('- Режим разработчика -');
  Timer.Start;
  DebugLn('> '+OSInf.XSystem+' '+OSInf.CSDVersion);
  MenuItem13.Visible:=true;
  {$ENDIF}
  {$IFDEF BUILD}
    Form2.Label1.Caption:=BUILD;
  {$ELSE BUILD}
    Form2.Label1.Caption:='TEdit - FreePascal';
  {$ENDIF}
 if FileExists(Path) then begin
  FS:=TFileStream.Create(Path,fmOpenRead);
  FS.ReadBuffer(SetSett,SizeOf(SetSett));
  FS.Destroy;

  Form4.Edit3.Text:=SetSett.Edit3Cpp;
  Form4.Edit4.Text:=SetSett.Edit4Fpc;
  Form4.Edit1.Text:=SetSett.Parametrs;
  for i:=0 to Form4.CheckGroup1.Items.Count-1 do
   Form4.CheckGroup1.Checked[i]:=SetSett.CheckGroup[i];
  Form4.CheckBox1.Checked:=SetSett.CheckGroup[Form4.CheckGroup1.Items.Count];
  if FileExists('Module.'+Path) then
   Form4.ListBox1.Items.LoadFromFile('Module.'+Path);
  end else begin
   for i:=0 to Form4.CheckGroup1.Items.Count-1 do
    if not(i in [0,1,5,6,7,8]) then
     Form4.CheckGroup1.Checked[i]:=true;
   Form4.Edit4.Text:=ExtractFilePath(Application.ExeName)+'FPC\bin\fpc %file';
  end;

  ListBox1.Visible:=false;
  button1.Visible:=false;

  AddTabSM;
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=nil;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var Str,_Str:String;
    i,Len:integer;
begin
 Str:=PageControl1.ActivePage.Caption+'(';
 Str:=copy(Str,2,length(Str));
 _Str:=ListBox1.Items[ListBox1.ItemIndex];
 if pos(Str,_Str)=2 then begin
  delete(_Str,1,length(Str)+1);
  if (Pos(',',_Str)>1) and (Pos(',',_Str)<=6) then
   i:=StrToInt(Copy(_Str,1,Pos(',',_Str)-1))
  else if (Pos(')',_Str)<=6) then
   i:=StrToInt(Copy(_Str,1,Pos(')',_Str)-1));
  if i>0 then with TSynMemo(PageControl1.ActivePage.Controls[0]) do begin
   Len:=pos(trim(Lines[i-1]),Text);
   SelStart:=Len;
   SelEnd:=Len+length(trim(Lines[i-1]));
  end;
 end;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
 AddTabSM;;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
 if not TSynMemo(PageControl1.ActivePage.Controls[0]).Modified and (PageControl1.PageCount>1) then begin
  PageControl1.ActivePage.Free;
  StatusBar1.SimpleText:=' Вкладка закрыта';
 end;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
 {$IFDEF DEVELOP}
  FindDialog1.Execute;
 {$ENDIF}
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ListBox1.Visible:=false;
  Button1.Visible:=false;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
begin
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=CloseProgram;
end;

procedure TForm1.MenuItem16Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.MenuItem18Click(Sender: TObject);
var FileExeCompile,Str,FFF:String;
    i,j,k:integer;
    SSS:TStringList;
    Attribs:array of string;
begin
  SetLength(Attribs,6);
  Attribs[0]:='.o'; Attribs[1]:='.tmp'; Attribs[2]:='.a';
  Attribs[3]:='.ppu'; Attribs[4]:='.temp'; Attribs[5]:='.tpu';
  StatusBar1.SimpleText:='';
  FileExeCompile:=copy(Form4.Edit4.Text,0,pos(' %file',Form4.Edit4.Text)-1);
  if ExtractFileExt(FileExeCompile)='' then
     FileExeCompile+='.exe';
  if FileExists(FileExeCompile) then begin
   SaveFile(true);
   if FileExists(TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text) then begin
      ListBox1.Visible:=true;
      button1.Visible:=true;
      ListBox1.Items.Text:=CmdLine(Form1.Compile+' '+TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text).Text;
      Str:=TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text;
      FileName(Str);
      Str:=copy(TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text,1,
        pos(Str,TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text)-1);
      for i:=0 to Form4.ListBox1.Items.Count do
       for k:=0 to high(Attribs) do begin
        if i=Form4.ListBox1.Items.Count then begin
         SSS:=FindFiles(Str,Attribs[k]);
         ListBox1.Items.Add('rm *'+Attribs[k]+' from '+Str);
        end else begin
         SSS:=FindFiles(Form4.ListBox1.Items[i]+'\',Attribs[k]);
         ListBox1.Items.Add('rm *'+Attribs[k]+' from '+Form4.ListBox1.Items[i]);
        end;
        for j:=0 to SSS.Count-1 do
         DeleteFile(SSS[j]);
       end;
      if (Form4.CheckBox1.Checked) and (Pos('-FE',UpCase(Form4.Edit1.Text))>0) then begin
       Str:=ResultPath.Path;
       for k:=0 to high(Attribs) do begin
        SSS:=FindFiles(Str,Attribs[k]);
        for j:=0 to SSS.Count-1 do
         DeleteFile(SSS[j]);
        ListBox1.Items.Add('rm *'+Attribs[k]+' from '+Str);
       end;
      end;
   end;
   FFF:=FileExeCompile;
   FileName(FFF);
   delete(FileExeCompile,pos(FFF,FileExeCompile),length(FileExeCompile));
   FFF:=TLabeledEdit(PageControl1.ActivePage.Controls[1]).Text;
   delete(FFF,pos(ExtractFileExt(FFF),FFF),length(FFF));
   FFF+='.exe';

   if (Form4.CheckBox1.Checked) and ((Pos('-FE',UpCase(Form4.Edit1.Text))>0)or
      (Pos('-O',UpCase(Form4.Edit1.Text))>0)) then
     FFF:=ResultPath.FPath;

   if FileExists(FFF) then begin
    if FileExists(FileExeCompile+'strip.exe') then
     CmdLine('cmd /c start '+FileExeCompile+'strip.exe -s --strip-all '+FFF);
    if FileExists(FileExeCompile+'upx.exe') then
     CmdLine('cmd /c start '+FileExeCompile+'upx.exe --best --lzma -9 '+FFF);
   end;
 end else StatusBar1.SimpleText:=' Компилятор не найден.';
end;

procedure TForm1.MenuItem17Click(Sender: TObject);
var Results:TRec;
begin
   Results:=ResultPath;
   if FileExists(Results.FPath) then begin
    Results.FPath:='cmd /c start '+Results.FPath;
    UTF8ToOEM866(Results.FPath);
    CmdLine(Results.FPath);
   end;
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
begin
  StatusBar1.SimpleText:=' Синтаксис FreePascal';
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynFreePascalSyn1;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
begin
  StatusBar1.SimpleText:=' Синтаксис С++';
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynCppSyn1;
end;

procedure TForm1.MenuItem23Click(Sender: TObject);
begin
  StatusBar1.SimpleText:=' Синтаксис Bat/CMD';
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynBatSyn1;
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
begin
  StatusBar1.SimpleText:=' Синтаксис PHP';
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynPHPSyn1;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  StatusBar1.SimpleText:=' Подсветка отключена';
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=nil;
end;

procedure TForm1.MenuItem28Click(Sender: TObject);
begin
  AddTabSM;
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynPHPSyn1;
end;

procedure TForm1.MenuItem29Click(Sender: TObject);
begin
  AddTabSM;
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynCppSyn1;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  AddTabSM;
end;

procedure TForm1.MenuItem30Click(Sender: TObject);
begin
  AddTabSM;
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynBatSyn1;
end;

procedure TForm1.MenuItem31Click(Sender: TObject);
begin
  AddTabSM;
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynFreePascalSyn1;
end;

procedure TForm1.MenuItem32Click(Sender: TObject);
begin
  AddTabSM;
  TSynMemo(PageControl1.ActivePage.Controls[0]).Highlighter:=SynFreePascalSyn1;
end;

procedure TForm1.MenuItem33Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.MenuItem34Click(Sender: TObject);
begin
 {$IFDEF DEVELOP}
  ReplaceDialog1.Execute;
 {$ENDIF}
end;

end.
