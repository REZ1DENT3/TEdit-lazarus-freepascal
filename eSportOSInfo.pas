unit eSportOSInfo;

{$mode objfpc}{$H+}

{$ASMMODE INTEL}
{$MACRO ON}

{$WARNINGS OFF}
{$NOTES OFF}

interface

Type OSInfo = class
      public
       ThisOS : boolean;
       XSystem : String;
       MajorVersion: Integer;
       MinorVersion: Integer;
       BuildNumber: Integer;
       PlatformId :Integer;
       CSDVersion : String;

      public
       WindowMaxWidth:LongWord;
       WindowMaxHeight:LongWord;
       WindowWidth:LongWord;
       WindowHeight:LongWord;
       WindowPositionWidth:LongWord;
       WindowPositionHeight:LongWord;

      public
       function Discharge64:boolean;
       function Discharge32:boolean;
       function Discharge:String;
       function SysName:String;
       function GetInfo:boolean;

      public
       constructor Create;
       destructor Destroy;overload;
     end;

implementation

uses Windows,SysUtils;

function OSInfo.GetInfo:boolean;
var
   VI: TOSVersionInfo;
begin
     VI.dwOSVersionInfoSize:=sizeof(TOSVersionInfo);
     GetVersionEx(VI);

     MajorVersion:=VI.dwMajorVersion;
     MinorVersion:=VI.dwMinorVersion;
     BuildNumber:=VI.dwBuildNumber;
     PlatformId:=VI.dwPlatformId;
     CSDVersion:=VI.szCSDVersion;

     WindowMaxWidth := GetSystemMetrics(SM_CXSCREEN);
     WindowMaxHeight := GetSystemMetrics(SM_CYSCREEN);

     WindowWidth := WindowMaxWidth Div 2;
     WindowHeight := WindowMaxHeight Div 2;

     WindowPositionWidth := WindowWidth Div 2;
     WindowPositionHeight := WindowHeight Div 2;

     GetInfo:={$IFDEF MSWINDOWS}true{$ELSE UNIX}false{$ENDIF};
end;

function OSInfo.Discharge64:boolean;
begin
 if (GetProcAddress(LoadLibrary('kernel32'),'GetNativeSystemInfo')<>nil) and
   (GetProcAddress(LoadLibrary('kernel32'),'IsWow64Process')<>nil) and
   (GetProcAddress(LoadLibrary('user32'),'IsWow64Message')<>nil) then
  result:=true
 else
  result:=false;
end;

function OSInfo.Discharge32:boolean;
begin
 result:= not Discharge64;
end;

function OSInfo.Discharge:String;
begin
 if Discharge64 then
  result:='x64'
 else result:='x86';
end;

function OSInfo.SysName:String;
begin
 if ThisOS then
  result:='Windows'
 else
  result:='Unix';
end;

constructor OSInfo.Create;
begin
 ThisOS:=GetInfo;
 XSystem := SysName+' '+Discharge+' ['+IntToStr(MajorVersion)+'.'+IntToStr(MinorVersion)+
  '.'+IntToStr(BuildNumber)+'] ['+IntToStr(WindowMaxWidth)+'x'+IntToStr(WindowMaxHeight)+']';
end;

destructor OSInfo.Destroy;overload;
begin
 inherited Destroy;
end;

end.
