unit eSportBased;

{
 * @author REZ1DENT3 (������� ������, �����)
 * @copyright 2013
}

{$mode objfpc}{$H+}

{$MACRO ON}

{$WARNINGS OFF}
{$NOTES OFF}

interface

uses Classes;

Type
  eSTimer = class
   public
    t1,t2,res:int64;
    time:extended;
    STime:String[255];
    bOk:boolean;

   public
    constructor Create;
    destructor Destroy;override;

   public
    Procedure Start;inline;
    Procedure Stop;inline;
  end;

  function CSTo10(S:String;Const CS:integer):String;inline;
  function ConvertToCS(val:integer;const CS:integer):string;inline;

  procedure Windows1251ToUTF8(var Str: string);inline;
  procedure UTF8ToWindows1251(var Str: string);inline;

  procedure OEM866ToUTF8(var Str: string);inline;
  procedure UTF8ToOEM866(var Str: string);inline;

  procedure OEM866ToWindows1251(var Str: string);inline;
  procedure Windows1251ToOEM866(var Str: string);inline;

  operator ** (const a,b:Real):Real;inline;

  function Trim(Str:String):String;overload;inline;
  function UpCase(Str:String):String;overload;inline;
  function DownCase(str:string):string;inline;

  function Crypt(Const s,key:string):string;inline;                             {RUS+DownCase}
  function DeCrypt(Const s,key:string):string;inline;

  function cezar(s:String;Const i:LongInt):String;inline;

  function fibbonacci(Const a:LongWord):LongWord;inline;
  
  function KillApp(const sCapt: PChar) : boolean;

  function CmdLine(Comand:String):TStringList;
  function execute(prog, cmdLine : string):String;

  function FindFiles(Dir: string;EXT:String):TStringList;

Const
  // guid devices
  GUID_DEVINTERFACE_USB_DEVICE: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';

implementation

uses
  Windows,Process,dos,SysUtils, math;

const
  SizeA = 33;
  RusA = '��������������������������������';

function FindFiles(Dir: string;EXT:String):TStringList;
var SearchRec: TSearchRec;
begin
 result:=TStringList.Create;
 Dir:=IncludeTrailingBackslash(Dir);
 if FindFirst(Dir + '*.*', FAanyFile, SearchRec) = 0 then
  repeat
   if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
    Continue;
   if (SearchRec.Attr and faDirectory) <> 0 then
    FindFiles(Dir + SearchRec.Name,EXT)
   else if ExtractFileExt(Dir + SearchRec.Name) = EXT then
    result.add(Dir + SearchRec.Name);
  until FindNext(SearchRec) <> 0;
 FindClose(SearchRec);
end;

function CmdLine(Comand:String):TStringList;
const READ_BYTES = 2048;
var
 M: TMemoryStream;
 P: TProcess;
 n,BytesRead: LongInt;

begin
 M := TMemoryStream.Create;
 BytesRead := 0;
 P := TProcess.Create(nil);
 P.CommandLine := Comand;
 P.StartupOptions:=[suoUseShowWindow];
 P.ShowWindow:=swoHIDE;
 P.Options := [poUsePipes];
 P.Execute;
 M.SetSize(BytesRead + READ_BYTES);
 n := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
 if n > 0 then Inc(BytesRead, n)
  else Sleep(100);
 repeat
  M.SetSize(BytesRead + READ_BYTES);
  n := P.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
  if n > 0 then Inc(BytesRead, n);
 until n <= 0;
 M.SetSize(BytesRead);
 result := TStringList.Create;
 result.LoadFromStream(M);
 Comand:=result.Text;
 OEM866ToUTF8(Comand);
 result.Text:=Comand;
 P.Free;
 M.Free;
end;

function execute(prog, cmdLine : string):String;
var
 next : boolean;
 path,pathString : String;
 rCode : word;
 
 function nextPath(var pathString:String;var path:String):boolean;
 var p:integer;
 begin
 p := pos(';', pathString);
 if p = 0 then begin
  path := pathString;
  pathString := '';
 end else begin
  path := Copy(pathString, 1, p - 1);
  pathString := Copy(pathString, p + 1, 255);
 end;
 if path[length(path)] <> '\' then
  path := path + '\';
  if path = '\' then
  nextPath := false
 else
  nextPath := true;
 end;

begin
 pathString := GetEnv('PATH');
 path := '';
 repeat
  SwapVectors;
  Exec(path + prog, cmdLine);
  SwapVectors;
  if DosError <> 0 then begin
   SwapVectors;
   Exec(path + prog + '.COM', cmdLine);
   SwapVectors;
  end;
  if DosError <> 0 then begin
   SwapVectors;
   Exec(path + prog + '.EXE', cmdLine);
   SwapVectors;
  end;
  next := nextPath(pathString, path)
 until (DosError = 0) or (next = false);
 if DosError <> 0 then begin
  execute:='Unable execute command : '+prog;
  halt(255);
 end else begin
  rCode := DosExitCode;
  if rCode <> 0 then begin
   execute:='*** Error : return code = '+IntToStr(rCode);
   halt(1);
  end;
 end;
end;

function KillApp(const sCapt: PChar) : boolean;
begin
 Result:=PostMessage(FindWindow(Nil, sCapt), WM_QUIT, 0, 0) ;
end;

function UpCase(Str:String):String;overload;inline;
var i:integer;
begin
  for i:=1 to length(str) do
    if str[i] in ['�'..'�'] then
      str[i]:=chr(ord(str[i])-32)
    else if str[i] in ['�'..' '] then
      str[i]:=chr(ord(str[i])-80)
    else if str[i] in ['a'..'z'] then
      str[i]:=chr(ord(str[i])-32);
  UpCase:=str;
end;

function DownCase(Str:String):String;inline;
var i:integer;
begin
  for i:=1 to length(str) do
    if str[i] in ['�'..'�'] then
      str[i]:=chr(ord(str[i])+32)
    else if str[i] in ['�'..'�'] then
      str[i]:=chr(ord(str[i])+80)
    else if str[i] in ['A'..'Z'] then
      str[i]:=chr(ord(str[i])+32);
  DownCase:=Str;
end;

function fibbonacci(Const a:LongWord):LongWord;
begin
  if a>2 then
    result:=fibbonacci(a-1)+fibbonacci(a-2)
  else
    result:=1;
end;

function Crypt(Const s,key:string):string;inline;
var i, P, t :integer;
    str1:string;
begin
  t:=0;
  str1:='';
  for i:=1 to length(s) do begin
    if (s[i]<>' ') then begin
      inc(t);
      if t>length(key) then
        t:=1;
      P:=pos(s[i],RusA)+pos(key[t],RusA);
      if P>SizeA then
        P:=P-SizeA;
      str1:=str1+RusA[P];
    end else str1+=' ';
  end;
  result:=str1;
end;

function DeCrypt(Const s,key:string):string;inline;
var i, P, t :integer;
    str1:string;
begin
  t:=0;
  str1:='';
  for i:=1 to length(s) do begin
    if (s[i]<>' ') then begin
      inc(t);
      if t>length(key) then
        t:=1;
      P:=pos(s[i],RusA)-pos(key[t],RusA);
      if P<=0 then
        P:=P+SizeA;
      str1:=str1+RusA[P];
    end else str1+=' ';
  end;
  result:=str1;
end;

function Trim(Str:String):String;inline;
begin
  while Str[1]=' ' do delete(Str,1,1);
  while Str[length(Str)]=' ' do delete(Str,length(Str),1);
  while Pos('  ',Str)>0 do delete(Str,Pos('  ',Str),1);
  result:=Str;
end;

operator **(const a,b:Real):Real;inline;
begin
  Result:=power(a, b);
end;

procedure Windows1251ToUTF8(var Str: string);inline;
const
  bRD0: Byte = ($C0 - $90);
  bRD1: Byte = ($F0 - $80);
var
  xCh, GStr, NStr: string;
  xL, iFor: integer;
  xChr: Char;
begin
  GStr := Str;
  NStr := '';
  xL := length(Str);
  for iFor := 1 to xL do begin
      xCh := #$20;
      xChr := GStr[iFor];
    if (xChr >= #$00) and (xChr <= #$7F) then begin
        xCh := xChr;
        case ord(xChr) of
          $11: xCh := #$E2#$97#$80;
          $10: xCh := #$E2#$96#$B6;
          $1E: xCh := #$E2#$96#$B2;
          $1F: xCh := #$E2#$96#$BC;
        end;
      end
    else if (xChr >= #$C0) and (xChr <= #$EF) then
        xCh := #$D0 + chr(ord(xChr) - bRD0)
      else if (xChr >= #$F0) and (xChr <= #$FF) then
          xCh := #$D1 + chr(ord(xChr) - bRD1)
        else
          case ord(xChr) of
            $80: xCh := #$D0#$82;
            $81: xCh := #$D0#$83;
            $82: xCh := #$E2#$80#$9A;
            $83: xCh := #$D1#$93;
            $84: xCh := #$E2#$80#$0E;
            $93: xCh := #$E2#$80#$9C;
            $94: xCh := #$E2#$80#$9D;
            $AB: xCh := #$C2#$AB;
            $BB: xCh := #$C2#$BB;
            $85: xCh := #$E2#$80#$A6;
            $86: xCh := #$E2#$80#$A0;
            $87: xCh := #$E2#$80#$A1;
            $88: xCh := #$E2#$82#$AC;
            $89: xCh := #$E2#$80#$B0;
            $8A: xCh := #$D0#$89;
            $8B: xCh := #$E2#$80#$B9;
            $9B: xCh := #$E2#$80#$BA;
            $8C: xCh := #$D0#$8A;
            $8D: xCh := #$D0#$8C;
            $8E: xCh := #$D0#$8B;
            $8F: xCh := #$D0#$8F;
            $90: xCh := #$D1#$92;
            $91: xCh := #$E2#$80#$98;
            $92: xCh := #$E2#$80#$99;
            $95: xCh := #$E2#$80#$A2;
            $96: xCh := #$E2#$80#$93;
            $97: xCh := #$E2#$80#$92;
            $AD: xCh := #$E2#$80#$94;
            $99: xCh := #$E2#$84#$A2;
            $9A: xCh := #$D1#$99;
            $9C: xCh := #$D1#$9A;
            $9D: xCh := #$D1#$9C;
            $9E: xCh := #$D1#$9B;
            $9F: xCh := #$D1#$9F;
            $A1: xCh := #$D0#$8E;
            $A2: xCh := #$D1#$9E;
            $A3: xCh := #$D0#$88;
            $A4: xCh := #$C2#$A4;
            $A5: xCh := #$D2#$90;
            $A6: xCh := #$C2#$A6;
            $A7: xCh := #$C2#$A7;
            $A8: xCh := #$D0#$81;
            $A9: xCh := #$C2#$A9;
            $AA: xCh := #$D0#$84;
            $AC: xCh := #$C2#$AC;
            $AF: xCh := #$D0#$87;
            $B0: xCh := #$C2#$B0;
            $B1: xCh := #$C2#$B1;
            $B2: xCh := #$D0#$86;
            $B3: xCh := #$D1#$96;
            $B4: xCh := #$D2#$91;
            $B5: xCh := #$C2#$B5;
            $B6: xCh := #$C2#$B6;
            $B7: xCh := #$C2#$B7;
            $B8: xCh := #$D1#$91;
            $B9: xCh := #$E2#$84#$96;
            $BA: xCh := #$D1#$94;
            $BC: xCh := #$D1#$98;
            $BD: xCh := #$D0#$85;
            $BE: xCh := #$D1#$95;
            $BF: xCh := #$D1#$97;
          end;
      NStr := NStr + xCh;
    end;
  Str := NStr;
end;

procedure UTF8ToWindows1251(var Str: string);inline;
const
  bRD0: Byte = ($C0 - $90);
  bRD1: Byte = ($F0 - $80);
var
  GStr, NStr: string;
  xChr, xP: Char;
  xL, iFor: integer;
  xGr1, xGr2: Char;
  bitn: Boolean = true;
begin
  xL := length(Str);
  GStr := Str;
  NStr := '';
  for iFor := 1 to xL do
    begin
      xChr := #$20;
      xP := GStr[iFor];
      if (xP >= #$00) and (xP <= #$7F) then
        begin
          xChr := xP;
          xGr1:= #$00;
          xGr2:= #$00;
        end
      else
        if (xP = #$C2) or (xP = #$D0) or (xP = #$D1) then
          begin
            xGr1 := xP;
            xGr2 := #$00;
            bitn := true;
          end
        else
          if xP = #$E2 then
            begin
              xGr1 := xP;
              xGr2 := #$00;
              bitn := false;
            end
          else
            if (xP >= #$80) and (xP <= #$BF) then
              if (not bitn) and (xGr2 = #$00) then
                  xGr2 := xP
              else
                begin
                  if xGr2 = #$00 then
                    begin
                    if xGr1 = #$D0 then
                      if (xP >= #$90) and (xP <= #$BF) then
                        xChr := chr(ord(xP) + brD0)
                      else
                        case ord(xP) of
                          $81: xChr := #$A8;
                          $82: xChr := #$80;
                          $83: xChr := #$81;
                          $84: xChr := #$AA;
                          $85: xChr := #$BD;
                          $86: xChr := #$B2;
                          $87: xChr := #$AF;
                          $88: xChr := #$A3;
                          $89: xChr := #$8A;
                          $8A: xChr := #$8C;
                          $8B: xChr := #$8E;
                          $8C: xChr := #$8D;
                          $8E: xChr := #$A1;
                          $8F: xChr := #$8F;
                        end
                    else
                      if xGr1 = #$D1 then
                        if (xP >= #$80) and (xP <= #$8F) then
                          xChr := chr(ord(xP) + bRD1)
                        else
                          case ord(xP) of
                            $91: xChr := #$B8;
                            $92: xChr := #$90;
                            $93: xChr := #$83;
                            $94: xChr := #$BA;
                            $95: xChr := #$BE;
                            $96: xChr := #$B3;
                            $97: xChr := #$BF;
                            $98: xChr := #$BC;
                            $99: xChr := #$9A;
                            $9A: xChr := #$9C;
                            $9B: xChr := #$9E;
                            $9C: xChr := #$9D;
                            $9E: xChr := #$A2;
                            $9F: xChr := #$9F;
                          end
                      else
                        if xGr1 = #$C2 then
                          case ord(xP) of
                            $A4: xChr := xP;
                            $A6: xChr := xP;
                            $A7: xChr := xP;
                            $A9: xChr := xP;
                            $AB: xChr := xP;
                            $AC: xChr := xP;
                            $B0: xChr := xP;
                            $B1: xChr := xP;
                            $B5: xChr := xP;
                            $B6: xChr := xP;
                            $B7: xChr := xP;
                            $BB: xChr := xP;
                          end;
                    end
                  else
                    case ord(xGr2) of
                      $82: if xP = #$AC then xChr := #$88;
                      $84: case ord(xP) of
                             $A2: xChr := #$99;
                             $96: xChr := #$B9;
                           end;
                      $80: case ord(xP) of
                             $92: xChr := #$97;
                             $93: xChr := #$96;
                             $94: xChr := #$AD;
                             $98: xChr := #$91;
                             $99: xChr := #$92;
                             $9A: xChr := #$82;
                             $9C: xChr := #$93;
                             $9D: xChr := #$94;
                             $A0: xChr := #$86;
                             $A1: xChr := #$87;
                             $A2: xChr := #$95;
                             $A6: xChr := #$85;
                             $B0: xChr := #$89;
                             $B9: xChr := #$8B;
                             $BA: xChr := #$9B;
                             $0E: xChr := #$84;
                           end;
                      $96: case ord(xP) of
                             $B2: xChr := #$1E;
                             $B6: xChr := #$10;
                             $BC: xChr := #$1F;
                           end;
                      $97: case ord(xP) of
                             $80: xChr := #$11;
                           end;
                    end;
                  xGr1 := #$00;
                end;
      if xGr1 = #$00 then
        NStr := NStr + xChr;
    end;
  Str := NStr;
end;

procedure OEM866ToUTF8(var Str: string);inline;
const
  bRD0: Byte = ($90 - $80);
  bRD1: Byte = ($E0 - $80);
var
  xCh, GStr, NStr: string;
  xL, iFor: integer;
  xChr: Char;
begin
  GStr := Str;
  NStr := '';
  xL := length(Str);
  for iFor := 1 to xL do
    begin
      xCh := #$20;
      xChr := GStr[iFor];
    if (xChr >= #$00) and (xChr <= #$7F) then
      begin
        xCh := xChr;
        case ord(xChr) of
          $11: xCh := #$E2#$97#$80;
          $10: xCh := #$E2#$96#$B6;
          $1E: xCh := #$E2#$96#$B2;
          $1F: xCh := #$E2#$96#$BC;
        end;
      end
    else if (xChr >= #$80) and (xChr <= #$AF) then
        xCh := #$D0 + chr(ord(xChr) + bRD0)
      else if (xChr >= #$E0) and (xChr <= #$EF) then
          xCh := #$D1 + chr(ord(xChr) - bRD1)
        else
          case ord(xChr) of
            $B0: xCh := #$E2#$96#$91;
            $B1: xCh := #$E2#$96#$92;
            $B2: xCh := #$E2#$96#$93;
            $B3: xCh := #$E2#$94#$82;
            $B4: xCh := #$E2#$94#$A4;
            $B5: xCh := #$E2#$95#$A1;
            $B6: xCh := #$E2#$95#$A2;
            $B7: xCh := #$E2#$95#$96;
            $B8: xCh := #$E2#$95#$95;
            $B9: xCh := #$E2#$95#$A3;
            $BA: xCh := #$E2#$95#$91;
            $BB: xCh := #$E2#$95#$97;
            $BC: xCh := #$E2#$95#$9D;
            $BD: xCh := #$E2#$95#$9C;
            $BE: xCh := #$E2#$95#$9B;
            $BF: xCh := #$E2#$95#$AE;
            $C0: xCh := #$E2#$95#$B0;
            $C1: xCh := #$E2#$94#$B4;
            $C2: xCh := #$E2#$94#$AC;
            $C3: xCh := #$E2#$94#$9C;
            $C4: xCh := #$E2#$94#$80;
            $C5: xCh := #$E2#$94#$BC;
            $C6: xCh := #$E2#$95#$9E;
            $C7: xCh := #$E2#$95#$9F;
            $C8: xCh := #$E2#$95#$9A;
            $C9: xCh := #$E2#$95#$94;
            $CA: xCh := #$E2#$95#$A9;
            $CB: xCh := #$E2#$95#$A6;
            $CC: xCh := #$E2#$95#$A0;
            $CD: xCh := #$E2#$95#$90;
            $CE: xCh := #$E2#$95#$AC;
            $CF: xCh := #$E2#$95#$A7;
            $D0: xCh := #$E2#$95#$A8;
            $D1: xCh := #$E2#$95#$A4;
            $D2: xCh := #$E2#$95#$A5;
            $D3: xCh := #$E2#$95#$99;
            $D4: xCh := #$E2#$95#$98;
            $D5: xCh := #$E2#$95#$92;
            $D6: xCh := #$E2#$95#$93;
            $D7: xCh := #$E2#$95#$AB;
            $D8: xCh := #$E2#$95#$AA;
            $D9: xCh := #$E2#$95#$AF;
            $DA: xCh := #$E2#$95#$AD;
            $DB: xCh := #$E2#$96#$88;
            $DC: xCh := #$E2#$96#$84;
            $DD: xCh := #$E2#$96#$8C;
            $DE: xCh := #$E2#$96#$90;
            $DF: xCh := #$E2#$95#$80;
            $F0: xCh := #$D0#$81;
            $F1: xCh := #$D1#$91;
            $F2: xCh := #$D0#$84;
            $F3: xCh := #$D1#$94;
            $F4: xCh := #$D0#$87;
            $F5: xCh := #$D1#$97;
            $F6: xCh := #$D0#$8E;
            $F7: xCh := #$D1#$9E;
            $F8: xCh := #$C2#$B0;
            $F9: xCh := #$E2#$80#$A2;
            $FA: xCh := #$C2#$B7;
            $FB: xCh := #$E2#$8E#$B7;
            $FC: xCh := #$E2#$84#$96;
            $FD: xCh := #$C2#$A4;
            $FE: xCh := #$E2#$8E#$B7;
          end;
      NStr := NStr + xCh;
    end;
  Str := NStr;
end;

procedure UTF8ToOEM866(var Str: string); inline;
const
  bRD0: Byte = ($90 - $80);
  bRD1: Byte = ($E0 - $80);
var
  GStr, NStr: string;
  xChr, xP: Char;
  xL, iFor: integer;
  xGr1, xGr2: Char;
  bitn: Boolean = true;

begin
  xL := length(Str);
  GStr := Str;
  NStr := '';
  for iFor := 1 to xL do begin
      xChr := #$20;
      xP := GStr[iFor];
      if (xP >= #$00) and (xP <= #$7F) then
        begin
          xChr := xP;
          xGr1:= #$00;
          xGr2:= #$00;
        end
      else if (xP = #$C2) or (xP = #$D0) or (xP = #$D1) then
          begin
            xGr1 := xP;
            xGr2 := #$00;
            bitn := true;
          end
        else
          if xP = #$E2 then
            begin
              xGr1 := xP;
              xGr2 := #$00;
              bitn := false;
            end
          else if (xP >= #$80) and (xP <= #$BF) then
              if (not bitn) and (xGr2 = #$00) then
                  begin
                    xGr2 := xP;
                  end
              else
                begin
                  if xGr2 = #$00 then
                    begin
                    if xGr1 = #$D0 then
                      if (xP >= #$90) and (xP <= #$BF) then
                        xChr := chr(ord(xP) - brD0)
                      else
                        case ord(xP) of
                          $81: xChr := #$F0;
                          $84: xChr := #$F2;
                          $87: xChr := #$F4;
                          $8E: xChr := #$F6;
                        end
                    else if xGr1 = #$D1 then
                        if (xP >= #$80) and (xP <= #$8F) then
                          xChr := chr(ord(xP) + bRD1)
                        else
                          case ord(xP) of
                            $91: xChr := #$F1;
                            $94: xChr := #$F3;
                            $97: xChr := #$F5;
                            $9E: xChr := #$F7;
                          end
                      else if xGr1 = #$C2 then
                          case ord(xP) of
                            $A4: xChr := #$FD;
                            $B0: xChr := #$F8;
                            $B7: xChr := #$FA;
                          end;
                    end
                  else
                    case ord(xGr2) of
                      $8E: if xP = #$B7 then xChr := #$FE;
                      $84: if xP = #$96 then xChr := #$FC;
                      $80: if xP = #$A2 then xChr := #$F9;
                      $94: case ord(xP) of
                             $80: xChr := #$C4;
                             $82: xChr := #$B3;
                             $9C: xChr := #$C3;
                             $A4: xChr := #$B4;
                             $AC: xChr := #$C2;
                             $B4: xChr := #$C1;
                             $BC: xChr := #$C5;
                           end;
                      $95: case ord(xP) of
                             $A1: xChr := #$B5;
                             $A2: xChr := #$B6;
                             $96: xChr := #$B7;
                             $95: xChr := #$B8;
                             $A3: xChr := #$B9;
                             $91: xChr := #$BA;
                             $97: xChr := #$BB;
                             $9D: xChr := #$BC;
                             $9C: xChr := #$BD;
                             $9B: xChr := #$BE;
                             $AE: xChr := #$BF;
                             $B0: xChr := #$C0;
                             $9E: xChr := #$C6;
                             $9F: xChr := #$C7;
                             $9A: xChr := #$C8;
                             $94: xChr := #$C9;
                             $A9: xChr := #$CA;
                             $A6: xChr := #$CB;
                             $A0: xChr := #$CC;
                             $90: xChr := #$CD;
                             $AC: xChr := #$CE;
                             $A7: xChr := #$CF;
                             $A8: xChr := #$D0;
                             $A4: xChr := #$D1;
                             $A5: xChr := #$D2;
                             $99: xChr := #$D3;
                             $98: xChr := #$D4;
                             $92: xChr := #$D5;
                             $93: xChr := #$D6;
                             $AB: xChr := #$D7;
                             $AA: xChr := #$D8;
                             $AF: xChr := #$D9;
                             $AD: xChr := #$DA;
                             $80: xChr := #$DF;
                           end;
                      $96: case ord(xP) of
                             $90: xChr := #$DE;
                             $91: xChr := #$B0;
                             $92: xChr := #$B1;
                             $93: xChr := #$B2;
                             $88: xChr := #$DB;
                             $84: xChr := #$DC;
                             $8C: xChr := #$DD;
                             $B2: xChr := #$1E;
                             $B6: xChr := #$10;
                             $BC: xChr := #$1F;
                           end;
                      $97: if xP=#$80 then xChr := #$11;
                    end;
                  xGr1 := #$00;
                end;
      if xGr1 = #$00 then
        NStr := NStr + xChr;
    end;
  Str := NStr;
end;

procedure OEM866ToWindows1251(var Str: string);  inline;
const
  Ap: Byte = ($C0 - $80);
  rya: Byte = ($F0 - $E0);
var
  iFor, xL: integer;
  GStr, NStr: string;
  xCh, xChr: Char;
begin
  NStr := '';
  GStr := Str;
  xL := length(GStr);
  for iFor := 1 to xL do
    begin
      xChr := #$20;
      xCh := GStr[iFor];
      if (xCh >= #$00) and (xCh <= #$7F) then
        xChr := xCh
      else if (xCh >= #$80) and (xCh <= #$AF) then
          xChr := chr(ord(xCh) + Ap)
        else if (xCh >= #$E0) and (xCh <= #$EF) then
            xChr := chr(ord(xCh) + rya)
          else
            case ord(xCh) of
              $B0: xChr := #$A9;
              $B1: xChr := #$AE;
              $B2: xChr := #$B5;
              $B3: xChr := #$A6;
              $B4: xChr := #$A6;
              $B5: xChr := #$A6;
              $B6: xChr := #$A6;
              $B9: xChr := #$A6;
              $BA: xChr := #$A6;
              $C3: xChr := #$A6;
              $C6: xChr := #$A6;
              $C7: xChr := #$A6;
              $CC: xChr := #$A6;
              $B7: xChr := #$2B;
              $B8: xChr := #$2B;
              $BB: xChr := #$2B;
              $BC: xChr := #$2B;
              $BD: xChr := #$2B;
              $BE: xChr := #$2B;
              $BF: xChr := #$2B;
              $C0: xChr := #$2B;
              $C5: xChr := #$2B;
              $C8: xChr := #$2B;
              $C9: xChr := #$2B;
              $CE: xChr := #$2B;
              $D3: xChr := #$2B;
              $D4: xChr := #$2B;
              $D5: xChr := #$2B;
              $D6: xChr := #$2B;
              $D7: xChr := #$2B;
              $D8: xChr := #$2B;
              $D9: xChr := #$2B;
              $DA: xChr := #$2B;
              $C1: xChr := #$97;
              $C2: xChr := #$97;
              $C4: xChr := #$97;
              $CA: xChr := #$97;
              $CB: xChr := #$97;
              $CD: xChr := #$97;
              $CF: xChr := #$97;
              $D0: xChr := #$97;
              $D1: xChr := #$97;
              $D2: xChr := #$97;
              $F0: xChr := #$A8;
              $F1: xChr := #$B8;
              $F2: xChr := #$AA;
              $F3: xChr := #$BA;
              $F4: xChr := #$AF;
              $F5: xChr := #$BF;
              $F6: xChr := #$A1;
              $F7: xChr := #$A2;
              $F8: xChr := #$B0;
              $F9: xChr := #$95;
              $FA: xChr := #$B7;
              $FB: xChr := #$AC;
              $FC: xChr := #$B9;
              $FD: xChr := #$A4;
            end;
      NStr := NStr + xChr;
    end;
  Str := NStr;
end;

procedure Windows1251ToOEM866(var Str: string);inline;
const
  Ap: Byte = ($C0 - $80);
  rya: Byte = ($F0 - $E0);
var
  iFor, xL: integer;
  GStr, NStr, xChr: string;
  xCh: Char;
begin
  NStr := '';
  GStr := Str;
  xL := length(GStr);
  for iFor := 1 to xL do
    begin
      xChr := #$20;
      xCh := GStr[iFor];
      if (xCh >= #$00) and (xCh <= #$7F) then
        xChr := xCh
      else if (xCh >= #$C0) and (xCh <= #$EF) then
          xChr := chr(ord(xCh) - Ap)
        else if (xCh >= #$F0) and (xCh <= #$FF) then
            xChr := chr(ord(xCh) - rya)
          else
            case ord(xCh) of
              $82: xChr := #$2C;
              $84: xChr := #$22;
              $93: xChr := #$22;
              $94: xChr := #$22;
              $AB: xChr := #$22;
              $BB: xChr := #$22;
              $85: if xL < 254 then xChr := #$2E#$2E#$2E
                      else xChr := #$2E;
              $8B: xChr := #$3C;
              $9B: xChr := #$3E;
              $91: xChr := #$27;
              $92: xChr := #$27;
              $95: xChr := #$F9;
              $96: xChr := #$C4;
              $97: xChr := #$C4;
              $A1: xChr := #$F6;
              $A2: xChr := #$F7;
              $A3: xChr := #$4A;
              $A4: xChr := #$FD;
              $A6: xChr := #$7C;
              $A8: xChr := #$F0;
              $A9: xChr := #$B0;
              $AA: xChr := #$F2;
              $AC: xChr := #$FB;
              $AD: xChr := #$2D;
              $AE: xChr := #$C1;
              $AF: xChr := #$F4;
              $B0: xChr := #$F8;
              $B2: xChr := #$49;
              $B3: xChr := #$69;
              $B5: xChr := #$B2;
              $B7: xChr := #$FA;
              $B8: xChr := #$F1;
              $B9: xChr := #$FC;
              $BA: xChr := #$F3;
              $BC: xChr := #$6A;
              $BD: xChr := #$53;
              $BE: xChr := #$73;
              $BF: xChr := #$F5;
            end;
      NStr := NStr + xChr;
    end;
  Str := NStr;
end;

function ItoS(val:integer):string;inline;
var
  _r:string;
begin
  Str(val,_r);
  ItoS:=_r;
end;

function ConvertToCS(val:integer;const CS:integer):string;inline;
var
  _r,_r1:string;
  _m,i:integer;

begin

  _r:='';

  if CS>36 then exit;

  repeat
   _m:=val mod CS;
   val:=val div CS;
   if _m<10 then _r:=_r+ItoS(_m)
   else _r:=_r+chr(ord('A')+_m-10);
  until val=0;

  _r1:='';

  for i:=length(_r) downto 1 do
   _r1:=_r1+_r[i];

  ConvertToCS:=_r1;

end;

function CSTo10(S:String;Const CS:integer):String;inline;
var Sum,L,C:Extended;
    i:integer;
begin
 Sum:=0;
 For i:=0 To length(S)-1 do begin
  if S[length(S)-i] in ['A'..'Z'] then
     L:=ord(S[length(S)-i])-55
  else
     val(S[length(S)-i],L);
  C:=L*(CS**i);
  Sum+=trunc(C);
 end;
 Str(trunc(Sum),CSTo10);
end;

function cezar(S:String;Const i:LongInt):String;inline;
begin
 if (i<length(s)) then
  cezar:=copy(s,i+1,length(s))+copy(s,0,i)
 else
  cezar:=S;//'Error -1';
end;

{
 Procedure Check_Time;
 Var tp, pc: DWORD;
 Begin
  tp := GetThreadPriority(GetCurrentThread());
  pc := GetPriorityClass(GetCurrentProcess());
  SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_TIME_CRITICAL);
  SetPriorityClass(GetCurrentProcess(), REALTIME_PRIORITY_CLASS);
  Try
    Timer.Start;

    Timer.Stop;
  Finally
    SetThreadPriority(GetCurrentThread(), tp);
    SetPriorityClass(GetCurrentProcess(), pc);
  End
 End;
}

constructor eSTimer.Create;
begin
 inherited;
 t1:=0;
 t2:=0;
 res:=0;
 time:=-1;
 STime:='';
 bOk:=false;
end;

destructor eSTimer.Destroy;
begin
 inherited Destroy;
end;

procedure eSTimer.Start;
begin
  if (time<>-1) then Create;
  bOK := QueryPerformanceFrequency(Res);
  If bOK Then QueryPerformanceCounter(t1);
end;

procedure eSTimer.Stop;
begin
  If bOK Then begin
   QueryPerformanceCounter(t2);
   time:=(t2-t1)/Res;
   STime:=Format('Execution time: %g sec.',[time]);
  end;
end;

end.
