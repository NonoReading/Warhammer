type
  TJPGHeader        = array[0..1] of Byte;

  TSOFHeader        = Packed record
                        Len: word;
                        DataPrecision: byte;
                        Height, Width: word;
                        NrComponents: byte;
                      end;

const
  JpgSOI: TJPGHeader = ($FF,$D8);  //FFD8 = StartOfImage (SOI)
  JpgStartOfSegment = $FF;


function MaybeJpg(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
//const
//  Parameterless = [$01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7];
var
  JPGHeader: TJPGHeader;
  SOFHeader: TSOFHeader;
  B, SegType: byte;
  SegSize: Word; //Thumbnail Size
  SOF_Found: boolean;
  Dummy: array[0..65532] of byte; //Max segment length
begin
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeJpg A');
  {$endif}
  Result := ifUnknown;
  dpiX := 0;
  dpiY := 0;
  Width := 0;
  Height := 0;

  if (St.Read(JPGHeader{%H-}, SizeOf(TJPGHeader)) <> SizeOf(TJPGHeader)) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('Fail to read TJPGHeader');
    {$endif}
    Exit;
  end;
  if (JPGHeader[0] <> JpgSOI[0]) or (JPGHeader[1] <> JpgSOI[1]) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('Invalid JPEGHeader: $',JPGHeader[0].ToHexString,'$',JPGHeader[0].ToHexString);
    {$endif}
    Exit;
  end;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('StartOfImage Found');
  {$endif}
  SOF_Found := False;

  //Find JFIFF and StartOfFrame (SOF) segment
  //if (St.Read(B{%H-},1) <> 1) then
  if not St.TryReadByte(B) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('MaybeJpg: Fail to read single byte (1)');
    {$endif}
    Exit;
  end;
  While (not SOF_Found) and (St.Position < St.Size) and (B = JpgStartOfSegment) do //All segments start with $FF
  begin
    //if St.Read(SegType{%H-},1) <> 1 then
    if not St.TryReadByte(SegType) then
    begin
      {$ifdef DebugPicsLib}
      if IsConsole then writeln('MaybeJpg: Fail to read SegType');
      {$endif}
      Exit;
    end;
    {$ifdef DebugPicsLib}
    if IsConsole then write('Segment Type: '+IntToHex(SegType,2)+' ');
    {$endif}
    case SegType of
      $c0,$c1,$c2 {,$c3,$c5,$c6,$c7,$c9,$ca,$cb,$cd,$ce,$cf ???}:
      begin//StartOfFrame
        {$ifdef DebugPicsLib}
        if IsConsole then write('  Found SOF');
        {$endif}
        if (St.Read(SOFHeader{%H-},SizeOf(TSOFHeader)) <> SizeOf(TSOFHeader)) then
        begin
          {$ifdef DebugPicsLib}
          if IsConsole then writeln('MaybeJpg: Fail to read TSOFHeader');
          {$endif}
          Exit;
        end;
        //Values are in BigEndian
        SOFHeader.Len := BeToN(SOFHeader.Len);
        {$ifdef DebugPicsLib}
        if IsConsole then write('  Segment Length: '+IntToStr(SOFHeader.Len),' (StartOfFrame)');
        {$endif}
        //Values are in BigEndian
        SOFHeader.Height := BeToN(SOFHeader.Height);
        SOFHeader.Width := BeTon(SOFHeader.Width);

        if (St.Read(Dummy{%H-},SOFHeader.NrComponents*3) <> SOFHeader.NrComponents*3) then
        begin
          {$ifdef DebugPicsLib}
          if IsConsole then writeln('MaybeJpg: Fail to read ',SOFHeader.NrComponents*3,' bytes');
          {$endif}
          Exit;
        end;
        Width := SOFHeader.Width;
        Height := SOFHeader.Height;
        SOF_Found := true;
      end;

      $01, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7:
      begin//Parameterless segment
        {$ifdef DebugPicsLib}
        if IsConsole then write('  Parameterless');
        {$endif}
        // Ignore
      end;
      $d9:
      begin//EndOfImage
        {$ifdef DebugPicsLib}
        if IsConsole then write('  EndOfImage');
        {$endif}
        Break;
      end;
      $da:
      begin//Start Of Scan: JPG Data
        {$ifdef DebugPicsLib}
        if IsConsole then write('  StartOfScan');
        {$endif}
        Break;
      end;
      else
      begin//Read segment into Dummy and ignore
        //The first 2 bytes represent the length of the segment
        //including the 2 length-bytes
        //Length bytes are in BigEndian format
        //if (St.Read(SegSize{%H-},SizeOf(SegSize)) <> SizeOf(SegSize)) then
        if not St.TryReadWord(SegSize) then
        begin
          {$ifdef DebugPicsLib}
          if IsConsole then writeln('MaybeJpg: Fail to read SegSize');
          {$endif}
          Exit;
        end;
        SegSize := BeTon(SegSize);
        {$ifdef DebugPicsLib}
        if IsConsole then write('  Segment Length: '+IntToStr(SegSize));
        {$endif}
        if SegSize > 2 then
        begin//Read until end of segemt
          SegSize := SegSize - 2;
          if (St.Read(Dummy,SegSize) <> SegSize) then
          begin
            {$ifdef DebugPicsLib}
            if IsConsole then writeln('MaybeJpg: Fail to read ',SegSize,' bytes');
            {$endif}
            Exit;
          end;
        end;
      end;
    end;//case
    //Lees volgende segmentbegin, B moet nu $FF zijn ...
    //if (St.Read(B,1) <> 1) then
    if not St.TryReadByte(B) then
    begin
      {$ifdef DebugPicsLib}
      if IsConsole then writeln('MaybeJpg: Fail to read SegmentStart');
      {$endif}
      Exit;
    end;
    {$ifdef DebugPicsLib}
    if IsConsole then writeln;
    {$endif}
  end;//While
  //Found all info.
  if SOF_Found then Result := ifJpg;
  {$ifdef DebugPicsLib}
  if IsConsole then begin writeln; writeln('  End of Search for markers'); writeln; end;
  if IsConsole then writeln('MaybeJpg: Result = ',Result);
  {$endif}
end;

