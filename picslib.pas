unit PicsLib;

{.$DEFINE DebugPicsLib}

interface

uses SysUtils, Classes, StreamHelper;

type
  TImageFormat = (ifUnknown, ifBmp, ifPng, ifGif, ifJpg, ifTiff, ifEMF, ifPCX, ifWmf, ifXPM);

function GetImageFormat(const Fn: String): TImageFormat;
function GetImageSize(const Fn: String; out Width, Height: dword): Boolean;
function GetImageSize(const Fn: String; out Width, Height: dword; out dpiX, dpiY: Double): Boolean;
function GetImageSizeAndFormat(const Fn: String; out Width, Height: dword): TImageFormat;
function GetImageSizeAndFormat(const Fn: String; out Width, Height: dword; out dpiX, dpiY: Double): TImageFormat;

//Stream overloads do no rewind Stream.Posistion, nor do they initilize Stream.Position to zero.
function GetImageFormat(St: TStream): TImageFormat;
function GetImageSize(St: TStream; out Width, Height: dword): Boolean;
function GetImageSizeAndFormat(St: TStream; out Width, Height: dword): TImageFormat;
function GetImageSizeAndFormat(St: TStream; out Width, Height: dword; out dpiX, dpiY: Double): TImageFormat;
function GetImageSizeAndFormat(St: TStream; const ExpectedImageFormat: TImageFormat; out Width, Height: dword): TImageFormat;
function GetImageSizeAndFormat(St: TStream; const ExpectedImageFormat: TImageFormat; out Width, Height: dword; out dpiX, dpiY: Double): TImageFormat;

//just check for a specific format, don't check for all potential other supported formats
function IsImageFormat(ImgFmt: TImageFormat; St: TStream; out Width, Height: dword; out dpiX, dpiY: Double): Boolean;
function IsImageFormat(ImgFmt: TImageFormat; St: TStream; out Width, Height: dword): Boolean;
function IsImageFormat(ImgFmt: TImageFormat; St: TStream): Boolean;

function IsImageFormat(ImgFmt: TImageFormat; const Fn: String; out Width, Height: dword; out dpiX, dpiY: Double): Boolean;
function IsImageFormat(ImgFmt: TImageFormat; const Fn: String; out Width, Height: dword): Boolean;
function IsImageFormat(ImgFmt: TImageFormat; const Fn: String): Boolean;

function ExtToImageFormat(const Ext: String): TImageFormat;


implementation


function ExtToImageFormat(const Ext: String): TImageFormat;
begin
  if (CompareText(Ext,'BMP') = 0) then
  begin
    Result := ifBmp;
  end
  else if (CompareText(Ext,'GIF') = 0) then
  begin
    Result := ifGif;
  end
  else if (CompareText(Ext,'JPG') = 0)
    or (CompareText(Ext,'JPEG') = 0) then
  begin
    Result := ifJpg;
  end
  else if (CompareText(Ext,'PNG') = 0) then
  begin
    Result := ifPng;
  end
  else if (CompareText(Ext,'TIF') = 0)
    or (CompareText(Ext,'TIFF') = 0) then
  begin
    Result := ifTiff;
  end
  else if (CompareText(Ext,'EMF') = 0) then
  begin
    Result := ifEMF;
  end
  else if (CompareText(Ext,'PCX') = 0) then
  begin
    Result := ifPCX;
  end
  else if (CompareText(Ext,'WMF') = 0) then
  begin
    Result := ifPCX;
  end
  else
  begin
    Result := ifUnknown;
  end;
end;


{$include picsbmp.inc}
{$include picspng.inc}
{$include picsjpg.inc}
{$include picsgif.inc}
{$include picstiff.inc}
{$include picsemf.inc}
{$include picspcx.inc}
{$include picswmf.inc}
{$include picsxpm.inc}


type
  TMaybeFormatFunc = function(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
  TMaybeFormatFuncs = array[TImageFormat] of TMaybeFormatFunc;

const
  MaybeFormatFuncs: TMaybeFormatFuncs = (nil, @MaybeBmp, @MaybePng, @MaybeGif, @MaybeJpg, @MaybeTiff, @MaybeEMF, @MaybePcx, @MaybeWmf, @MaybeXPM);


function GetImageFormatAndDimensions(const St: TStream; const TryFirst: TImageFormat; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  ImgFormat: TImageFormat;
  StartPos: Int64;
begin
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('GetImageFormatAndDimensions: TryFirst=',TryFirst);
  if IsConsole then writeln('TryFirst = ',TryFirst);
  {$endif}
  StartPos := St.Position;
  if (TryFirst <> ifUnknown) then
    Result := MaybeFormatFuncs[TryFirst](St, Width, Height, dpiX, dpiY)
  else
    Result := ifUnknown;
  if (Result = ifUnknown) then
  begin
    for ImgFormat := Succ(Low(TImageFormat)) to High(TImageFormat) do
    begin
      {$ifdef DebugPicsLib}
      if (ImgFormat <> TryFirst) then if IsConsole then writeln('Trying ImgFormat=',ImgFormat);
      {$endif}
      St.Position := StartPos;
      if (ImgFormat <> TryFirst) then Result := MaybeFormatFuncs[ImgFormat](St, Width, Height, dpiX, dpiY);
      {$ifdef DebugPicsLib}
      if (ImgFormat <> TryFirst) then if IsConsole then writeln('Tried ImgFormat=',ImgFormat,', Result=',Result);
      {$endif}
      if (Result <> ifUnknown) then Break;
    end;
  end;
end;

function IsImageFormat(ImgFmt: TImageFormat; St: TStream; out Width, Height: dword; out dpiX, dpiY: Double): Boolean;
begin
  Result := (MaybeFormatFuncs[ImgFmt](St, Width, Height, dpiX, dpiY) = ImgFmt);
end;

function IsImageFormat(ImgFmt: TImageFormat; St: TStream; out Width, Height: dword): Boolean;
var
  dpiX, dpiY: Double;
begin
  Result := IsImageFormat(ImgFmt, St, Width, Height, dpiX, dpiY);
end;

function IsImageFormat(ImgFmt: TImageFormat; St: TStream): Boolean;
var
  Width, Height: DWord;
  dpiX, dpiY: Double;
begin
  Result := IsImageFormat(ImgFmt, St, Width, Height, dpiX, dpiY);
end;

function IsImageFormat(ImgFmt: TImageFormat; const Fn: String; out Width, Height: dword; out dpiX, dpiY: Double): Boolean;
var
  ImgStream: TFileStream;
begin
  Result := False;
  try
    ImgStream := TFileStream.Create(Fn,fmOpenRead or fmShareDenyNone);
    try
      ImgStream.Position := 0;
      Result := (MaybeFormatFuncs[ImgFmt](ImgStream, Width, Height, dpiX, dpiY) = ImgFmt);
    finally
      ImgStream.Free;
    end;
  except
     on EStreamError do Result := False;
  end;
end;

function IsImageFormat(ImgFmt: TImageFormat; const Fn: String; out Width, Height: dword): Boolean;
var
  dpiX, dpiY: Double;
begin
  Result := IsImageFormat(ImgFmt, Fn, Width, Height, dpiX, dpiY);
end;

function IsImageFormat(ImgFmt: TImageFormat; const Fn: String): Boolean;
var
  Width, Height: DWord;
  dpiX, dpiY: Double;
begin
  Result := IsImageFormat(ImgFmt, Fn, Width, Height, dpiX, dpiY);
end;

function GetImageSize(const Fn: String; out Width, Height: dword): Boolean;
var
  dpiX, dpiY: Double;
begin
  Result := (GetImageSizeAndFormat(Fn, Width, Height, dpiX, dpiY) <> ifUnknown);
end;

function GetImageSize(const Fn: String; out Width, Height: dword; out dpiX, dpiY: Double): Boolean;
begin
  Result := (GetImageSizeAndFormat(Fn, Width, Height, dpiX, dpiY) <> ifUnknown);
end;

function GetImageFormat(const Fn: String): TImageFormat;
var
  dummyWidth,dummyHeight: dword;
  dpiX, dpiY: Double;
begin
  Result := GetImageSizeAndFormat(Fn, dummyWidth, dummyHeight, dpiX, dpiY);
end;

function GetImageSizeAndFormat(const Fn: String; out Width, Height: dword): TImageFormat;
var
  dpiX, dpiY: Double;
begin
  Result := GetImageSizeAndFormat(Fn, Width, Height, dpiX, dpiY);
end;

function GetImageSizeAndFormat(const Fn: String; out Width, Height: dword; out dpiX, dpiY: Double): TImageFormat;
var
  ImgStream: TFileStream;
  ImgFormat: TImageFormat;
begin
  Width := 0;
  Height := 0;
  try
    ImgStream := TFileStream.Create(Fn,fmOpenRead or fmShareDenyNone);
    try
      ImgStream.Position := 0;
      ImgFormat := GetImageFormatAndDimensions(ImgStream, ExtToImageFormat(ExtractFileExt(Fn)), Width, Height, dpiX, dpiY);
      Result := ImgFormat;
    finally
      ImgStream.Free;
    end;
  except
     on EStreamError do Result := ifUnknown;
  end;
end;


function GetImageSize(St: TStream; out Width, Height: dword): Boolean;
var
  dpiX, dpiY: Double;
begin
  Result := (GetImageSizeAndFormat(St, ifUnknown, Width, Height, dpiX, dpiY) <> ifUnknown);
end;

function GetImageFormat(St: TStream): TImageFormat;
var
  Width, Height: dword;
  dpiX, dpiY: Double;
begin
  Result := GetImageSizeAndFormat(St, ifUnknown, Width, Height, dpiX, dpiY);
end;

function GetImageSizeAndFormat(St: TStream; out Width, Height: dword): TImageFormat;
var
  dpiX, dpiY: Double;
begin
  Result := GetImageSizeAndFormat(St, ifUnknown, Width, Height, dpiX, dpiY);
end;

function GetImageSizeAndFormat(St: TStream; out Width, Height: dword; out dpiX, dpiY: Double): TImageFormat;
begin
  Result := GetImageSizeAndFormat(St, ifUnknown, Width, Height, dpiX, dpiY);
end;

function GetImageSizeAndFormat(St: TStream; const ExpectedImageFormat: TImageFormat; out Width, Height: dword): TImageFormat;
var
  dpiX, dpiY: Double;
begin
  Result := GetImageSizeAndFormat(ST, ExpectedImageFormat, Width, Height, dpiX, dpiY);
end;

function GetImageSizeAndFormat(St: TStream; const ExpectedImageFormat: TImageFormat; out Width, Height: dword; out dpiX, dpiY: Double): TImageFormat;
var
  ImgFormat: TImageFormat;
begin
  Width := 0;
  Height := 0;
  try
    ImgFormat := GetImageFormatAndDimensions(St, ExpectedImageFormat, Width, Height, dpiX, dpiY);
    Result := ImgFormat;
  except
     on E: EStreamError do
     begin
       {$ifdef DebugPicsLib}
       if IsConsole then writeln('EStreamError: ',E.Message);
       {$endif}
       Result := ifUnknown;
     end;
  end;
end;

end.
