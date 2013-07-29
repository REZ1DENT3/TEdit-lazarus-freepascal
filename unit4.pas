unit Unit4;
// Меняем кодировку с CP866 на UTF-8
{$mode objfpc}{$H+}

interface

uses
  Forms,Dialogs,StdCtrls,ExtCtrls ;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckGroup1: TCheckGroup;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;

implementation

uses SysUtils,Classes,unit1;

{$R *.lfm}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin
  if (SelectDirectoryDialog1.Execute) then
     ListBox1.Items[ListBox1.Count]:=SelectDirectoryDialog1.FileName;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TForm4.Button3Click(Sender: TObject);
var i:integer;
begin
  if FileExists(Path) then
     DeleteFile(Path);
  if FileExists('module.'+Path) then
     DeleteFile('module.'+Path);
  FS:=TFileStream.Create(Path,fmCreate);

  for i:=0 to CheckGroup1.Items.Count-1 do
     SetSett.CheckGroup[i]:=CheckGroup1.Checked[i];
  SetSett.CheckGroup[CheckGroup1.Items.Count]:=CheckBox1.Checked;
  ListBox1.Items.SaveToFile('module.'+Path);
  SetSett.Edit4Fpc:=Edit4.Text;
  SetSett.Edit3Cpp:=Edit3.Text;
  SetSett.Parametrs:=Edit1.Text;

  FS.WriteBuffer(SetSett,SizeOf(SetSett));
  FS.Destroy;
  if FileExists(Path) then
     ShowMessage('Настройки сохранены!');
end;

procedure TForm4.Button4Click(Sender: TObject);
var i:shortint;
begin
  for i:=0 to CheckGroup1.Items.Count-1 do
      if not(i in [0,1,5,6,7,8]) then
         CheckGroup1.Checked[i]:=true;
  Edit4.Text:=ExtractFilePath(Application.ExeName)+'FPC\bin\fpc %file';
end;

procedure TForm4.Button5Click(Sender: TObject);
var Str:String;
begin
  if (SelectDirectoryDialog1.Execute) then begin
     if FileExists(SelectDirectoryDialog1.FileName+'\ppcrossx64.exe') then
        Str:='\ppcrossx64'
     else if FileExists(SelectDirectoryDialog1.FileName+'\ppcrossx32.exe') then
        Str:='\ppcrossx32'
     else
        Str:='\fpc';
     Edit4.Text:=SelectDirectoryDialog1.FileName+Str+' %file';
  end;
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
  if (SelectDirectoryDialog1.Execute) then
     Edit3.Text:=SelectDirectoryDialog1.FileName+'\cpp %file';
end;

end.
