unit Unit2;
// Меняем кодировку с CP866 на UTF-8
{$mode objfpc}{$H+}

interface

uses
  Forms,StdCtrls,ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

end.

