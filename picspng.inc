type
  TPNGHeader        = Packed Record
                        ID: array[0..7] of AnsiChar;
                        ChunkLength: dword;
                        ChunkType: array[0..3] of AnsiChar;
                        Width: dword;
                        Height: dword;
                        BitsPerPixel: byte;
                        ColorType: byte;
                        Compression: byte;
                        FilterMethod: byte;
                        CRC: dword;
                      end;

const
  PngHeaderID = #137'PNG'#13#10#26#10;
  PngChunkType = 'IHDR';

function MaybePng(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  PngHeader: TPngHeader;
begin
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybePng A');
  {$endif}
  Result := ifUnknown;
  dpiX := 0;
  dpiY := 0;
  Width := 0;
  Height := 0;
  if (St.Read(PngHeader{%H-}, SizeOf(TPngHeader)) <> SizeOf(TPngHeader)) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('Fail to read TPngHeader');
    {$endif}
    Exit;
  end;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('PNGHeader.ID= ',PNGHeader.ID);
  if IsConsole then writeln('PNGHeader.ChunkType = ',PNGHeader.ChunkType);
  {$endif}
  if (AnsiUpperCase(PNGHeader.ID) = PngHeaderID) or
     (AnsiUpperCase(PNGHeader.ChunkType) = PngChunkType) then
  begin
    //Vaues are in BigEndian format
    Width := BeToN(PNGHeader.Width);
    Height := BeToN(PNGHeader.Height);
    Result := ifPng;
  end;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybePng: Result = ',Result);
  {$endif}
end;

