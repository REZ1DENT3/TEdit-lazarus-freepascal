unit eSportWinAPI;

{$MODE OBJFPC}{$H+}

{$ASMMODE INTEL}
{$MACRO ON}

{$WARNINGS OFF}
{$NOTES OFF}

interface

uses
    Classes,
    crt,
    {$IFDEF MSWINDOWS}
      windows,
    {$ENDIF}
    {$IFDEF UNIX}
     {$IFDEF UseCThreads}
      cthreads,
     {$ENDIF}
    {$ENDIF}
    SysUtils,
    gl,
    glext,
    eSportBased;

Type
    TESColor4f=object
      public
       r,g,b,a:single;
    end;

    TES_WinAPI = class
      public
       constructor Create;
       destructor Destroy;override;

      public
       function FullScreenWindow:boolean;
       function WindowInit(hParent : HWnd): Boolean;
       Function WinRegister: Boolean;
       function FieldInWindow:Boolean;
       Function WinCreate: HWnd;
       procedure Initialize;
       procedure InitOpenGL;
       procedure Messages;
       procedure Loop;

      public
       procedure WriteToConsole(Str:String;t:boolean = true);

      public
       msg:Windows.TMSG;
       TSError:byte;
    end;

Const YourSystem = {$IFDEF UNIX}true{$ENDIF}{$IFDEF MSWINDOWS}false{$ENDIF};
      AppName = 'eSport';

Var AMessage: Msg;
    dcWindow:hDc;
    rcWindow:HGLRC;
    clWindow:Int64;
    hWindow,hStatus,Hedit: HWnd;
    WindowClass: WndClass;
    ClRec:Boolean = False;
    Active:Boolean = True;

implementation

procedure TES_WinAPI.Loop;
begin
 while (TSError<>220) and (Active) do begin
  Messages;
 end;
end;

constructor TES_WinAPI.Create;
begin
 inherited;
 TSError:=0;
 hWindow:=0;
 dcWindow:=0;
 rcWindow:=0;
 clWindow:=0;
end;

destructor TES_WinAPI.Destroy;
begin
 TSError:=220;
 if dcWindow<>0 then
   wglMakeCurrent( dcWindow, 0 );

 if rcWindow<>0 then begin
   wglDeleteContext( rcWindow );
   CloseHandle(rcWindow);
   rcWindow:=0;
 end;

 if (hWindow<>0) and (dcWindow<>0) then
   ReleaseDC( hWindow, dcWindow );

 if (dcWindow<>0) then begin
   CloseHandle(dcWindow);
   dcWindow:=0;
 end;

 if hWindow<>0 then
   DestroyWindow( hWindow );

 if hWindow<>0 then begin
   CloseHandle( hWindow);
   hWindow:=0;
 end;
 inherited;
end;

function TES_WinAPI.FullScreenWindow:boolean;inline;
begin
 Result:=MessageBox(0,'Перейти в полноэкранный режим?','Вопрос',MB_YESNO OR MB_ICONQUESTION) <> IDNO;
end;

procedure TES_WinAPI.Messages;
begin
if Windows.PeekMessage(@msg,0,0,0,0) = true then
	begin
	Windows.GetMessage(@msg,0,0,0);
	Windows.TranslateMessage(msg);
	Windows.DispatchMessage(msg);
	end;
inherited;
end;

function WindowProc(Window: HWnd; AMessage, WParam, LParam: Longint): Longint; stdcall; export;
Var r: rect;
    StatH: Word;
    nrmenu : longint;
    c:char;

begin

 Result:=0;

 case AMessage of
  wm_create:;
  wm_paint:;
  {Alt Down}260:;
  {Alt Up}261:;
  {Key & Alt}262:;
  wm_keydown:begin
      writeln(wParam);
  end;
  wm_keyup:;
  wm_mousewheel:;
  wm_lbuttondown:;
  wm_rbuttondown:;
  wm_mbuttondown:;
  wm_lbuttonup:;
  wm_rbuttonup:;
  wm_mbuttonup:;
  wm_destroy:begin
    Active:=false;
    PostQuitMessage(0);
    Exit;
  end;
  wm_Command:Begin
    NrMenu := WParam And $FFFF;
      Case NrMenu Of
        104 : PostMessage(Window,WM_Close,0,0);
      End;
  End;
  wm_syscommand:;
  wm_size,wm_sizing,wm_move,wm_moving,WM_WINDOWPOSCHANGED,WM_WINDOWPOSCHANGING:Begin
    if HStatus<>0 then begin
      GetClientRect(HStatus,@R);
      StatH := R.Bottom-R.Top;
      GetClientRect(Window,@R);
      MoveWindow (hStatus,r.left,r.bottom-StatH,r.right,r.bottom,true);
      if HEdit<>0 then
        MoveWindow (HEdit,0,0,r.right-r.left,r.bottom-r.top-StatH,true);
    end;
  End;
 end;

 WindowProc := DefWindowProc(Window, AMessage, WParam, LParam);

end;

Function TES_WinAPI.WinRegister: Boolean;
Begin
  With WindowClass Do
    Begin
      Style := cs_hRedraw Or cs_vRedraw;
      lpfnWndProc := WndProc(@WindowProc);
      cbClsExtra := 0;
      cbWndExtra := 0;
      hInstance := system.MainInstance;
      hIcon := LoadIcon (0,idi_Application);
      hCursor := LoadCursor (0,idc_Arrow);
      hbrBackground := GetStockObject(WHITE_BRUSH);
      lpszMenuName := nil;
      lpszClassName := AppName;
    End;
  Result := RegisterClass (WindowClass)<>0;
End;

procedure TES_WinAPI.WriteToConsole(Str:String;t:boolean = true);
begin
  if YourSystem then UTF8ToOEM866(Str)
   else Windows1251ToOEM866(Str);
  if t then
    write(Str)
  else
    writeln(Str);
end;

function TES_WinAPI.WindowInit(hParent : HWnd): Boolean;
var FunctionError : integer;
    pfd : PIXELFORMATDESCRIPTOR;
    iFormat : integer;

begin

 FunctionError := 0;
 dcWindow := GetDC( hParent );
 FillChar(pfd, sizeof(pfd), 0);

 pfd.nSize         := sizeof(pfd);
 pfd.nVersion      := 1;
 pfd.dwFlags       := PFD_SUPPORT_OPENGL OR PFD_DRAW_TO_WINDOW OR PFD_DOUBLEBUFFER;
 pfd.iPixelType    := PFD_TYPE_RGBA;
 pfd.cColorBits    := 32;
 pfd.cDepthBits    := 24;
 pfd.iLayerType    := PFD_MAIN_PLANE;

 iFormat := ChoosePixelFormat( dcWindow, @pfd );

 if (iFormat = 0) then
  FunctionError := 1;

 SetPixelFormat( dcWindow, iFormat, @pfd );

 if rcWindow=0 then begin

  rcWindow := wglCreateContext( dcWindow );

  if (rcWindow = 0) then
   FunctionError := 2;

 end;

 wglMakeCurrent( dcWindow, rcWindow );

 if FunctionError = 0 then
  WindowInit := true
 else
  WindowInit := false;

end;

Function TES_WinAPI.WinCreate: HWnd;
var hWindow2: HWnd;
Begin
  hWindow2 := CreateWindow (AppName,AppName,ws_OverlappedWindow,cw_UseDefault,cw_UseDefault,cw_UseDefault,cw_UseDefault,0,0,system.MainInstance,Nil);
  If hWindow2<>0 Then Begin
      ShowWindow(hWindow2,SW_SHOW);
      UpdateWindow(hWindow2);
  End;
  Result := hWindow2;
End;

function TES_WinAPI.FieldInWindow:Boolean;
begin

if not ClRec then
  if not WinRegister then begin
    WriteToConsole('Could not register the Application Window!',false);
    FieldInWindow := false;
    Exit;
  end else begin
    ClRec:=True;
  end;

hWindow := WinCreate;

if longint(hWindow) = 0 then begin
  WriteToConsole('Could not create Application Window!',false);
  FieldInWindow := false;
  Exit;
end;

if not WindowInit(hWindow) then begin
  WriteToConsole('Could not initialise Application Window!',false);
  FieldInWindow := false;
  Exit;
end;

FieldInWindow := true;

end;

procedure TES_WinAPI.InitOpenGL;
var
   AmbientLight : array[0..3] of glFloat = (0.5,0.5,0.5,1.0);
   DiffuseLight : array[0..3] of glFloat = (1.0,1.0,1.0,1.0);
   SpecularLight : array[0..3] of glFloat = (1.0,1.0,1.0,1.0);
   SpecularReflection : array[0..3] of glFloat = (0.4,0.4,0.4,1.0);
   LightPosition : array[0..3] of glFloat = (0,1,0,2);
   fogColor:TESColor4f = (r:0;g:0;b:0;a:1);

begin

 glEnable(GL_FOG);
 glFogi(GL_FOG_MODE, GL_LINEAR);
 glHint (GL_FOG_HINT, GL_NICEST);

 glFogf (GL_FOG_START, 300);
 glFogf (GL_FOG_END, 400);
 glFogfv(GL_FOG_COLOR, @fogColor);
 glFogf(GL_FOG_DENSITY, 0.55);

 glClearColor(0,0,0,0);
 glEnable(GL_DEPTH_TEST);
 glClearDepth(1.0);
 glDepthFunc(GL_LEQUAL);

 glEnable(GL_LINE_SMOOTH);
 glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
 glLineWidth (1.5);

 glShadeModel(GL_SMOOTH);
 glEnable(GL_TEXTURE_1D);
 glEnable(GL_TEXTURE_2D);
 glEnable(GL_TEXTURE);
 glEnable (GL_BLEND);
 glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) ;
 glEnable (GL_LINE_SMOOTH);

 glEnable(GL_LIGHTING);
 glLightfv(GL_LIGHT0,GL_AMBIENT, @AmbientLight);
 glLightfv(GL_LIGHT0,GL_DIFFUSE, @DiffuseLight);
 glLightfv(GL_LIGHT0,GL_SPECULAR, @SpecularLight);
 glEnable(GL_LIGHT0);

 glLightfv(GL_LIGHT0,GL_POSITION,@LightPosition);

 glEnable(GL_COLOR_MATERIAL);
 glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
 glMaterialfv(GL_FRONT, GL_SPECULAR, @SpecularReflection);
 glMateriali(GL_FRONT,GL_SHININESS,100);

 glDisable(GL_LIGHTING);

end;

procedure TES_WinAPI.Initialize;
begin
 if FieldInWindow then TSError:=0
   else TSError:=220;
 if TSError=0 then
    InitOpenGL;
end;

end.
