//https://winprotocoldoc.blob.core.windows.net/productionwindowsarchives/MS-WMF/%5bMS-WMF%5d.pdf      (page 115, section 2.3.2.3 )
//https://www.loc.gov/preservation/digital/formats/digformatspecs/WindowsMetafileFormat(wmf)Specification.pdf
type
  TBoundingBox = packed record
    Left, Top, Right, Bottom: Int16;
    //Coördinates in twips
  end;

  TWMFSpecialHeader = packed record
    Key: DWord;       // Magic number (always $9AC6CDD7)
    Handle: Word;     // Metafile HANDLE number (always 0)
    BoundingBox: TBoundingBox;
    Inch: Word;       // Number of metafile units per inch
    Reserved: DWord;  // Reserved (always 0)
    Checksum: Word;   // Checksum value for previous 10 words
  end;

const
  WmfKey = DWord($9AC6CDD7);
  WmfMetaHeaderNumber = DWord(0);
  WmfReserved = DWord(0);


//Adapted and enhanced form fpSpreadSheet
//Supports placeable WMF metafiles only
function MaybeWmf(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  WmfHeader: TWMFSpecialHeader;
  CheckSum: Word;
  Words: packed array[0..(SizeOf(TWMFSpecialHeader) div 2)-1] of Word absolute WmfHeader;
  i: Integer;
begin
  Result := ifUnknown;
  {$IFDEF DebugPicsLib}
  writeln('SizeOf(TWMFSpecialHeader)=',SizeOf(TWMFSpecialHeader));
  writeln('High(Words)=',High(Words),', SizeOf(Words)=',SizeOf(Words));
  {$ENDIF}

  if (St.Read(WmfHeader{%H-}, SizeOf(WmfHeader)) <> SizeOf(TWMFSpecialHeader)) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Fail to read TWMFSpecialHeader');
    {$ENDIF}
    Exit;
  end;
  //Values in WMF are in little-endian
  WmfHeader.Key := LEToN(WmfHeader.Key);
  WmfHeader.Handle := LEToN(WmfHeader.Handle);
  WmfHeader.BoundingBox.Left := LEToN(WmfHeader.BoundingBox.Left);
  WmfHeader.BoundingBox.Right := LEToN(WmfHeader.BoundingBox.Right);
  WmfHeader.BoundingBox.Top := LEToN(WmfHeader.BoundingBox.Top);
  WmfHeader.BoundingBox.Bottom := LEToN(WmfHeader.BoundingBox.Bottom);
  WmfHeader.Inch := LEToN(WmfHeader.Inch);
  WmfHeader.Reserved := LEToN(WmfHeader.Reserved);
  WmfHeader.Checksum := LEToN(WmfHeader.Checksum);

  {$IFDEF DebugPicsLib}
  if IsConsole then writeln('WmfHeader.Key                  = $',WmfHeader.Key.ToHexString);
  if IsConsole then writeln('WmfHeader.Handle               = $',WmfHeader.Handle.ToHexString);
  if IsConsole then writeln('WmfHeader.BoundingBox.Left     = ',WmfHeader.BoundingBox.Left);
  if IsConsole then writeln('WmfHeader.BoundingBox.Top      = ',WmfHeader.BoundingBox.Top);
  if IsConsole then writeln('WmfHeader.BoundingBox.Right    = ',WmfHeader.BoundingBox.Right);
  if IsConsole then writeln('WmfHeader.BoundingBox.Bottom   = ',WmfHeader.BoundingBox.Bottom);
  if IsConsole then writeln('WmfHeader.Inch                 = ',WmfHeader.Inch);
  if IsConsole then writeln('WmfHeader.Reserved             = $',WmfHeader.Reserved.ToHexString);
  if IsConsole then writeln('WmfHeader.Checksum             = $',WmfHeader.Checksum.ToHexString);
  {$ENDIF}

  if WmfHeader.Key <> WmfKey then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for WmfHeader.Key, expected $', WmfKey.ToHexString,', got $',WmfHeader.Key.ToHexString);
    {$ENDIF}
    Exit;
  end;
  if (WmfHeader.Handle <> WmfMetaHeaderNumber) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for WmfHeader.Handle, expected $',WmfMetaHeaderNumber.ToHexString, ', got $',WmfHeader.Handle.ToHexString);
    {$ENDIF}
    Exit;
  end;
  if (WmfHeader.Reserved <> WmfReserved) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for WmfHeader.Reserved, expected $',WmfMetaHeaderNumber.ToHexString,', got $',WmfHeader.Reserved.ToHexString);
    {$ENDIF}
    Exit;
  end;

  {
    Checksum:
    A checksum for the previous 10 16-bit values in the header. This value can be
    used to determine whether the metafile has become corrupted. The value is calculated by
    initializing the checksum to zero and then XORing it one at a time with the 10 16-bit values in the
    header.
  }
  CheckSum := 0;
  for i := Low(Words) to Pred(High(Words)) do
  begin
    CheckSum := CheckSum xor Words[i];
    {$IFDEF DebugPicsLib}
    writeln(i:2,': Words[i]=',Words[i].ToHexString,', Checskum is now ',CheckSum.ToHexString);
    {$ENDIF}
  end;

  if (WmfHeader.Checksum <> CheckSum) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Calculated Checksum error, expected $',WmfHeader.Checksum.ToHexString,', got $',CheckSum.ToHexString);
    {$ENDIF}
    Exit;
  end;

  {
    Inch:
    The number of logical units per inch used to represent the image. This value can be
    used to scale an image.
    By convention, an image is considered to be recorded at 1440 logical units (twips) per inch. Thus,
    a value of 720 specifies that the image SHOULD be rendered at twice its normal size, and a value
    of 2880 specifies that the image SHOULD be rendered at half its normal size
  }
  Width := (WmfHeader.BoundingBox.Right - WmfHeader.BoundingBox.Left);  //in Twips, a Twip is 1/1440 of an inch
  Height := (WmfHeader.BoundingBox.Bottom - WmfHeader.BoundingBox.Top);
  dpiX := WmfHeader.Inch;
  dpiY := WmfHeader.Inch;

  //WidthInches = Width/1440 in inches
  //WidthPixels = dpiX * WidthInches?? however this seems off 8016/1440*100.0=5566.6667, but expected 770 (factor 7.23)
  //Width := Round(Width*dpiX/1440);
  Result := ifWmf;

end;

{
wmf-test.wmf
WmfHeader.BoundingBox.Left     = -4008
WmfHeader.BoundingBox.Top      = -3378
WmfHeader.BoundingBox.Right    = 4008
WmfHeader.BoundingBox.Bottom   = 3378
WmfHeader.Inch                 = 1000

Irfan: 769 x 648; 20.3 x 17.1 cm; 8.01 x 6.75 inches
Paint: 770x649
}
