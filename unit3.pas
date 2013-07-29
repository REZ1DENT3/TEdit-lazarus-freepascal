unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Forms,StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation
uses SysUtils,Unit1;

{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
var Str:String[15];
begin
  Str:=trim(Edit1.Text);
  Form1.PageControl1.ActivePage.Caption:=Str;
end;

end.

