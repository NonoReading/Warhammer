// https://msdn.microsoft.com/de-de/library/windows/desktop/dd162607%28v=vs.85%29.aspx
//https://www.nationalarchives.gov.uk/PRONOM/Format/proFormatSearch.aspx?status=detailReport&id=1089&strPageToDisplay=signatures
type
  TEnhMetaHeader = packed record
     iType: DWord;   //must be 1
     nSize: DWord;
     rclBounds: TRect;
     rclFrame: TRect;
     dSignature: DWord;   // must be $464D4520  'EMF '
     nVersion: DWord;     //should be $00010000 for Microsoft Windows Enhanced Metafile 2.0 (Variation 1 and 2)
     nBytes: DWord;
     nRecords: DWord;
     nHandles: Word;
     sReserved: Word;
     nDescription: DWord;
     offDescription: DWord;
     nPalEntries: DWord;
     szlDevice: TPoint;
     szlMillimeters: TPoint;
     // more to follow
  end;

const
  EnhMetaHeaderSig = DWord($464D4520);
  EnhMetaHeaderType = DWord(1);
  EnhMetaHeaderVersion = DWord($00010000);

//Adapted form fpSpreadSheet
function MaybeEMF(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  EnhMetaHeader: TEnhMetaHeader;
begin
  Result := ifUnknown;
  if (St.Read(EnhMetaHeader{%H-}, SizeOf(TEnhMetaHeader)) <> SizeOf(TEnhMetaHeader)) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Fail to read TEnhMetaHeader');
    {$ENDIF}
    Exit;
  end;

  if (LEToN(EnhMetaHeader.dSignature) <> EnhMetaHeaderSig) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid EnhMetaHeader.dSignature: expected $',EnhMetaHeaderSig.ToHexString,', got $',EnhMetaHeader.dSignature.ToHexString);
    {$ENDIF}
    Exit;
  end;
  //Data is in little-endian
  //https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-emf/8c517124-fe82-44e6-b0b6-c64cdcbe07cb
  EnhMetaHeader.iType :=LEToN(EnhMetaHeader.iType);
  EnhMetaHeader.nVersion :=LEToN(EnhMetaHeader.nVersion);
  EnhMetaHeader.szlDevice.X :=LEToN(EnhMetaHeader.szlDevice.X);
  EnhMetaHeader.szlDevice.Y :=LEToN(EnhMetaHeader.szlDevice.Y);
  EnhMetaHeader.szlMillimeters.X :=LEToN(EnhMetaHeader.szlMillimeters.X);
  EnhMetaHeader.szlMillimeters.Y :=LEToN(EnhMetaHeader.szlMillimeters.Y);
  EnhMetaHeader.rclBounds.Left :=LEToN(EnhMetaHeader.rclBounds.Left);
  EnhMetaHeader.rclBounds.Right :=LEToN(EnhMetaHeader.rclBounds.Right);
  EnhMetaHeader.rclBounds.Top :=LEToN(EnhMetaHeader.rclBounds.Top);
  EnhMetaHeader.rclBounds.Bottom:=LEToN(EnhMetaHeader.rclBounds.Bottom);
  EnhMetaHeader.rclFrame.Left :=LEToN(EnhMetaHeader.rclFrame.Left);
  EnhMetaHeader.rclFrame.Right :=LEToN(EnhMetaHeader.rclFrame.Right);
  EnhMetaHeader.rclFrame.Top :=LEToN(EnhMetaHeader.rclFrame.Top);
  EnhMetaHeader.rclFrame.Bottom :=LEToN(EnhMetaHeader.rclFrame.Bottom);
  EnhMetaHeader.szlDevice.X := LEToN(EnhMetaHeader.szlDevice.X);
  EnhMetaHeader.szlDevice.Y := LEToN(EnhMetaHeader.szlDevice.Y);
  EnhMetaHeader.szlMillimeters.X := LEToN(EnhMetaHeader.szlMillimeters.X);
  EnhMetaHeader.szlMillimeters.Y := LEToN(EnhMetaHeader.szlMillimeters.Y);

  {$IFDEF DebugPicsLib}
  if IsConsole then writeln('EnhMetaHeader.iType           =$',EnhMetaHeader.iType.ToHexString);
  if IsConsole then writeln('EnhMetaHeader.nVersion        =$',EnhMetaHeader.nVersion.ToHexString);
  if IsConsole then writeln('EnhMetaHeader.szlDevice.X     =',EnhMetaHeader.szlDevice.X);
  if IsConsole then writeln('EnhMetaHeader.szlDevice.Y     =',EnhMetaHeader.szlDevice.Y);
  if IsConsole then writeln('EnhMetaHeader.szlMillimeters.X=',EnhMetaHeader.szlMillimeters.X);
  if IsConsole then writeln('EnhMetaHeader.szlMillimeters.Y=',EnhMetaHeader.szlMillimeters.Y);
  if IsConsole then writeln('EnhMetaHeader.rclBounds.Left  =',EnhMetaHeader.rclBounds.Left);
  if IsConsole then writeln('EnhMetaHeader.rclBounds.Right =',EnhMetaHeader.rclBounds.Right);
  if IsConsole then writeln('EnhMetaHeader.rclBounds.Top   =',EnhMetaHeader.rclBounds.Top);
  if IsConsole then writeln('EnhMetaHeader.rclBounds.Bottom=',EnhMetaHeader.rclBounds.Bottom);
  if IsConsole then writeln('EnhMetaHeader.rclFrame.Left   =',EnhMetaHeader.rclFrame.Left);
  if IsConsole then writeln('EnhMetaHeader.rclFrame.Right  =',EnhMetaHeader.rclFrame.Right);
  if IsConsole then writeln('EnhMetaHeader.rclFrame.Top    =',EnhMetaHeader.rclFrame.Top);
  if IsConsole then writeln('EnhMetaHeader.rclFrame.Bottom =',EnhMetaHeader.rclFrame.Bottom);
  {$endif}

  if (EnhMetaHeader.iType <> EnhMetaHeaderType) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Invalid value for EnhMetaHeader.iType, expected $',EnhMetaHeaderType.ToHexString,', got $',EnhMetaHeader.iType.ToHexString);
    {$ENDIF}
    Exit;
  end;
  if (EnhMetaHeader.nVersion <> EnhMetaHeaderVersion) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Found unsupported value for EnhMetaHeader.nVersion, exptected $',EnhMetaHeaderVersion.ToHexString,', got $',EnhMetaHeader.nVersion.ToHexString);
    {$ENDIF}
    Exit;
  end;

  Width := EnhMetaHeader.rclBounds.Right - EnhMetaHeader.rclBounds.Left + 1;  // in pixels
  Height := EnhMetaHeader.rclBounds.Bottom - EnhMetaHeader.rclBounds.Top + 1;

  //PPmmX := EnhMetaHeader.szlDevice.X/EnhMetaHeader.szlMillimeters.X;
  //PPmmY := EnhMetaHeader.szlDevice.Y/EnhMetaHeader.szlMillimeters.Y;
  //{$IFDEF DebugPicsLib}
  //if IsConsole then writeln('PPmmX                        =',PPmmX:4:4);
  //if IsConsole then writeln('PPmmY                        =',PPmmY:4:4);
  //{$ENDIF}

  //WidthMM := (EnhMetaHeader.rclFrame.Right - EnhMetaHeader.rclFrame.Left) / 100;  // values in rclFrame are in 0.01mm units
  //Width := Round((WidthMM) * PPmmX);
  //HeightMM := (EnhMetaHeader.rclFrame.Bottom - EnhMetaHeader.rclFrame.Top) / 100;
  //Height := Round((HeightMM) * PPmmY);
  //dpiX := PPmmX * 25.4; //(25.4 * EnhMetaHeader.szlDevice.X / EnhMetaHeader.szlMillimeters.X); //100*25.4;
  //dpiY := PPmmY * 25.4; //(25.4 * EnhMetaHeader.szlDevice.Y / EnhMetaHeader.szlMillimeters.Y); //100*25.4;
  dpiX := EnhMetaHeader.szlDevice.X / EnhMetaHeader.szlMillimeters.X * 25.4;
  dpiY := EnhMetaHeader.szlDevice.Y / EnhMetaHeader.szlMillimeters.Y * 25.4;

  Result := ifEMF;
end;

