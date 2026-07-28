//https://en.wikipedia.org/wiki/PCX
type
  TPCXHeader = packed record
    FileID: Byte;                      // $0A for PCX files, $CD for SCR files
    Version: Byte;                     // 0: version 2.5; 2: 2.8 with palette; 3: 2.8 w/o palette; 5: version 3
    Encoding: Byte;                    // 0: uncompressed; 1: RLE encoded
    BitsPerPixel: Byte;
    XMin,
    YMin,
    XMax,
    YMax,                              // coordinates of the corners of the image
    HRes,                              // horizontal resolution in dpi
    VRes: Word;                        // vertical resolution in dpi
    ColorMap: array[0..16*3-1] of byte;  // color table
    Reserved,
    ColorPlanes: Byte;                 // color planes (at most 4)
    BytesPerLine,                      // number of bytes of one line of one plane
    PaletteType: Word;                 // 1: color or b&w; 2: gray scale
    Fill: array[0..57] of Byte;
  end;

const
  PcxIDPcx = Byte($0A);
  PcxIDSCR = Byte($CD);
  PcxIDS = [PcxIDPcx,PcxIDSCR];
  PcxVersions = [0..5];
  PcxEncodings = [0,1];
  PcxColorPlanes = [0,1,2,3,4];
  PcxPaletteTypes = [1,2];

//Adapted and enhanced from fpSpreadSheet
function MaybePCX(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  PcxHeader: TPCXHeader;
begin
  Result := ifUnknown;
  if (St.Read(PcxHeader{%H-}, SizeOf(TPcxHeader)) <> SizeOf(TPcxHeader)) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Fail to read TPcxHeader');
    {$ENDIF}
    Exit;
  end;
  //All values in PCX are little-endian
  PcxHeader.XMin := LEToN(PcxHeader.XMin);
  PcxHeader.YMin := LEToN(PcxHeader.YMin);
  PcxHeader.XMax := LEToN(PcxHeader.XMax);
  PcxHeader.YMax := LEToN(PcxHeader.YMax);
  PcxHeader.HRes := LEToN(PcxHeader.HRes);
  PcxHeader.VRes := LEToN(PcxHeader.VRes);
  PcxHeader.BytesPerLine := LEToN(PcxHeader.BytesPerLine);
  PcxHeader.PaletteType := LEToN(PcxHeader.BytesPerLine);
  {$IFDEF DebugPicsLib}
  if IsConsole then writeln('PcxHeader.Version=',PcxHeader.Version);
  if IsConsole then writeln('PcxHeader.Encoding=',PcxHeader.Encoding);
  if IsConsole then writeln('PcxHeader.BitsPerPixel=',PcxHeader.BitsPerPixel);
  if IsConsole then writeln('PcxHeader.XMin=',PcxHeader.XMin);
  if IsConsole then writeln('PcxHeader.YMin=',PcxHeader.YMin);
  if IsConsole then writeln('PcxHeader.XMax=',PcxHeader.XMax);
  if IsConsole then writeln('PcxHeader.YMax=',PcxHeader.YMax);
  if IsConsole then writeln('PcxHeader.HRes=',PcxHeader.HRes);
  if IsConsole then writeln('PcxHeader.VRes=',PcxHeader.VRes);
  if IsConsole then writeln('PcxHeader.Reserved=',PcxHeader.Reserved);
  if IsConsole then writeln('PcxHeader.ColorPlanes=',PcxHeader.ColorPlanes);
  if IsConsole then writeln('PcxHeader.BytesPerLine=',PcxHeader.BytesPerLine);
  if IsConsole then writeln('PcxHeader.PaletteType=',PcxHeader.PaletteType);
  {$ENDIF}
  if not (PcxHeader.FileID in PcxIDS) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for PcxHeader.FileID, expected $',PcxIDPcx.ToHexString,' or $',PcxIDSCR.ToHexString,', got $',PcxHeader.FileID.ToHexString);
    {$ENDIF}
    Exit;
  end;
  if not (PcxHeader.Version in PcxVersions) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for PcxHeader.Version, expected 0-5, got ',PcxHeader.Version);
    {$ENDIF}
    Exit;
  end;
  if not (PcxHeader.ColorPlanes in PcxColorPlanes) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for PcxHeader.ColorPlanes, expected at most 4, got ',PcxHeader.ColorPlanes);
    {$ENDIF}
    Exit;
  end;
  if not (PcxHeader.Encoding in PcxEncodings) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for PcxHeader.Encoding, expected 0 or 1, got ',PcxHeader.Encoding);
    {$ENDIF}
    Exit;
  end;
  if not (PcxHeader.PaletteType in PcxPaletteTypes) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for PcxHeader.PaletteType, expected 1 or 2, got ',PcxHeader.PaletteType);
    {$ENDIF}
    Exit;
  end;
  Width := PcxHeader.XMax - PcxHeader.XMin + 1;
  Height := PcxHeader.YMax - PcxHeader.YMin + 1;
  dpiX := PcxHeader.HRes;
  dpiY := PcxHeader.VRes;
  Result := ifPCX;
end;
