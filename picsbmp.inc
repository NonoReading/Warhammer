type
  TBitmapFileHeader = Packed Record
                        ID: word;
                        FileSize: dword;
                        Reserved: dword;
                        BitmapDataOffset: dword;
                      end;

  TBitmapInfo        = Packed Record
                         BitmapHeaderSize: dword;
                         Width: Int32;
                         Height: Int32;
                         Planes: word;
                         BitsPerPixel: word;
                         Compression: dword;
                         BitmapDataSize: dword;
                         XpelsPerMeter: dword;
                         YPelsPerMeter: dword;
                         ColorsUsed: dword;
                         ColorsImportant: dword;
                       end;

const
  BmpIDWordA = Ord('B') or (Ord('M') shl 8); // $4D42
  BmpIDWordB = Ord('B') or (Ord('B') shl 8); // $4242
  BmpSupportedHeaderSizes = [$28,$0c,$f0];
  BmpSupportedBitsPerPixel = [1,4,8,16,24,32];


function MaybeBmp(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  BFH: TBitmapFileHeader;
  BInfo: TBitmapInfo;
begin
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeBmp A');
  {$endif}
  Result := ifUnknown;
  dpiX := 0;
  dpiY := 0;
  Width := 0;
  Height := 0;

  if (St.Read(BFH{%H-}, Sizeof(TBitmapFileHeader)) <> Sizeof(TBitmapFileHeader)) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('Fail to read TBitmapFileHeader');
    {$endif}
    Exit;
  end;
  if (St.Read(BInfo{%H-}, SizeOf(TBitmapInfo)) <> SizeOf(TBitmapInfo)) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('Fail to read TBitmapInfo');
    {$endif}
    Exit;
  end;
  BFH.ID := LeToN(BFH.ID);
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('BFH.ID = $',BFH.ID.ToHexString(4));
  if IsConsole then writeln('BInfo.BitmapHeaderSize = $',IntToHex(BInfo.BitmapHeaderSize,2));
  if IsConsole then writeln('BInfo.BitsPerPixel = ',BInfo.BitsPerPixel);
  {$endif}
  BInfo.BitmapHeaderSize := LeToN(BInfo.BitmapHeaderSize);
  BInfo.BitsPerPixel := LeToN(BInfo.BitsPerPixel);
  if ((BFH.ID = BmpIDWordA) or (BFH.ID = BmpIDWordB)) and
     (BInfo.BitmapHeaderSize in BmpSupportedHeaderSizes) and
     (BInfo.BitsPerPixel in BmpSupportedBitsPerPixel)then
  begin
    Width := LeToN(BInfo.Width);
    //Apparently Height can be negative (picture is stored bottum-up)
    Height := Abs(LeToN(BInfo.Height));
    Result := ifBmp;
    if BInfo.BitmapHeaderSize >= 40 then
    begin
      dpiX := LEToN(BInfo.XPelsPerMeter) * 0.0254;
      dpiY := LEToN(BInfo.YPelsPerMeter) * 0.0254;
    end;
    if dpiX = 0 then dpiX := 72;
    if dpiY = 0 then dpiY := 72;
  end;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeBmp: Result = ',Result);
  {$endif}
end;


