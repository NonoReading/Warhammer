//https://www.w3.org/Graphics/GIF/spec-gif89a.txt
type
   TGIFHeader = Packed Record
                  ID: array[0..5] of AnsiChar;
                  ScreenWidth, ScreenHeight: word;
                  Flags, // Bit 0: indicates Global Color Table is present
                         // Bit 1,2,3: Color Resolution
                         // Bit 4: Sort flag
                         // Bit 5,6,7: Size of Global Color Table
                  BackgroundColorIndex,
                  PixelAspectRatio: byte;
                end;

                TGifImageBlock = packed record
                  Left, Top, Width, Height: word;
                  Flags: byte;
                end;
const
  GifHeaderID87A = 'GIF87A';
  GifHeaderID89A = 'GIF89A';
  GifExtensionIntroducer = $21;
  GifGraphicControlLabel = $F9;  //Identifies the beginning of a Graphic Control Extension
  GifCommentLabel = $FE;         //Identifies the beginning of a Comment Extension
  GifPlainTextLabel = $01;       //Identifies the beginning of a Plain Text Extension
  GifApplicationLabel = $FF;     //Identifies the beginning of an Application Extension
  GifGraphicControlLabelBlockSize = 4;
  GifApplicationControlLabelBlockSize = 11;
  GifImageSeparator = $2C;       //Identifies the beginning of an Image Descriptor

function MaybeGif(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  GifHeader: TGifHeader;
  ImageBlock: TGifImageBlock;
  NewPos: Int64;
  B: Byte;
  S: String;
  Buf: array[0..255] of byte; //general purpose buf for reading/consuming data

  function ConsumeGraphicControlExtension: Boolean;
  begin
    Result := False;
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Consuming Graphic Control Extension');
    {$ENDIF}
    //B := St.ReadByte;
    if not St.TryReadByte(B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Failed to read a single byte');
      {$ENDIF}
      Exit;
    end;
    if (B <> GifGraphicControlLabelBlockSize) then
    begin
    {$IFDEF DebugPicsLib}
     if IsConsole then writeln('Invalid value for blocksize');
    {$ENDIF}
    Exit; //invalid blocksize
    end;

    // Graphic Control Extension Data: 4 bytes
    if (St.Read(Buf[0],4) <> 4) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Fail to read Graphic Control Extension Data');
      {$ENDIF}
      Exit;
    end;

    //Although specs state that the Block Terminator for a Graphic Control Extension is zero bytes
    //(so, there is none), in practice you can find a NUL-byte as Block Terminator
    //So, read a byte, if it is zero consume it, if not, rewind the Position
    //If it is not zero it should be either GifExtensionIntroducer or GifImageSeparator
    //but that'll be checked in the main while loop processing blocks

    //B := St.ReadByte;
    if not St.TryReadByte(B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Failed to read a single byte');
      {$ENDIF}
      Exit;
    end;
    if (B <> 0) then
      St.Position := St.Position - 1;

    //if IsConsole then writeln('ConsumeGraphicControlExtension: B=$',B.ToHexString);
    Result := True;
  end;

  function ConsumeApplicationExtension: Boolean;
  begin
    Result := False;
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Consume Application Extension');
    {$ENDIF}
    //B := St.ReadByte;
    if not St.TryReadByte(B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Failed to read a single byte');
      {$ENDIF}
      Exit;
    end;
    if (B <> GifApplicationControlLabelBlockSize) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Illegal value for blocksize: ',B);
      {$ENDIF}
      Exit;
    end;

    //Next field is Application Identifier: 8 lower ASCII characters
    SetLength(S,8);
    if (St.Read(S[1],8) <> 8) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Fail to read Application Identifier');
      {$ENDIF}
      Exit;
    end;
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Application=',S);
    {$ENDIF}
    //3 bytes Application ID
    if (St.Read(Buf[0],3) <> 3) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Fail to read Application ID');
      {$ENDIF}
      Exit;
    end;
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('ApplicationID=',Buf[0].ToHexString,' ',Buf[1].ToHexString,' ',Buf[2].ToHexString);
    {$ENDIF}

    //Data block size
    //B := St.ReadByte;
    if not St.TryReadByte(B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Failed to read a single byte');
      {$ENDIF}
      Exit;
    end;
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Data block size=',B.ToHexString);
    {$ENDIF}

    if (St.Read(Buf[0],B) <> B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Fail to read ',B,' bytes (data block)');
      {$ENDIF}
      Exit;
    end;

    //Block Terminator
    //B := St.ReadByte;
    if not St.TryReadByte(B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Failed to read a single byte');
      {$ENDIF}
      Exit;
    end;
    if (B <> 0) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Expected Block Terminator ($00), got $',B.ToHexString);
      {$ENDIF}
      Exit;
    end;
    Result := True;
  end;

  function ConsumeCommentExtension: Boolean;
  begin
    Result := False;
  end;

  function ConsumePlainTextExtension: Boolean;
  begin
    Result := False;
  end;

begin
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeGif A');
  {$endif}
  Result := ifUnknown;
  dpiX := 0;
  dpiY := 0;
  Width := 0;
  Height := 0;
  if (St.Read(GifHeader{%H-}, SizeOf(TGifHeader)) <> SizeOf(TGifHeader)) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('Fail to read TGifHeader');
    {$endif}
    Exit;
  end;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('GifHeader.ID = ',GifHeader.ID);
  {$endif}
  if  not ((CompareText(GifHeader.ID, GifHeaderID87A)=0) or (CompareText(GifHeader.ID,GifHeaderID89A)=0)) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Found invalid GifHeader.ID: ',GifHeader.ID);
    {$ENDIF}
    Exit;
  end;

  {$IFDEF DebugPicsLib}
  writeln('GifHeader.ScreenWidth=',GifHeader.ScreenWidth);
  writeln('GifHeader.ScreenHeight',GifHeader.ScreenHeight);
  writeln('Flags: ',GifHeader.Flags.ToBinString);
  {$ENDIF}

  // Skip color map, if there is one
  if (GifHeader.Flags and %10000000) > 0 then
  begin
    {$IFDEF DebugPicsLib}
    writeln('Has Global ColorTable');
    {$ENDIF}
    //Size in bytes of colortable = 3 x 2^(Size of Global Color Table+1).
    //  = 38(1 shl (value+1))

    NewPos := St.Position +  (3 * (Int64(1) SHL ((GifHeader.Flags and %00000111 {7}) + 1)));

    if NewPos > St.Size then
    begin
      {$ifdef DebugPicsLib}
      if IsConsole then writeln('Colormap trashed');
      {$endif}
      Exit; // Color map thrashed
    end;
    St.Position := NewPos;
  end;

  {
    Skip possible Extension blocks before ImageBlock
    Extension starts with $21

    Type of extensions:
    - Graphic Control Extension:
    - Comment extension
    - Plain Text extension
    - Application extension
  }

  // Step through blocks
  while (St.Position < St.Size) do
  begin

    //B := St.ReadByte;
    if not St.TryReadByte(B) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Failed to read a single byte');
      {$ENDIF}
      Exit;
    end;

    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('First byte of block=',B.ToHexString);
    {$ENDIF}

    if not (B in ([GifExtensionIntroducer,GifImageSeparator])) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Found illegal byte: expected valid ExtensionLabel or a GifImageSeparator, got: ',B.ToHexString);
      {$ENDIF}
      Exit;
    end;


    //if (B = GifExtensionIntroducer) then
    while (B = GifExtensionIntroducer) do
    begin
      //B := St.ReadByte;
      if not St.TryReadByte(B) then
      begin
        {$IFDEF DebugPicsLib}
        if IsConsole then writeln('Failed to read a single byte');
        {$ENDIF}
        Exit;
      end;
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Found Extension with label ',B.ToHexString);
      {$ENDIF}
      //Consume Graphic Control Extensions if we find them
      //while (B = GifGraphicControlLabel) do
      if (B = GifGraphicControlLabel) then
      begin
        if not ConsumeGraphicControlExtension then
        begin
          {$IFDEF DebugPicsLib}
          if IsConsole then writeln('ConsumeGraphicControlExtension=False');
          {$ENDIF}
          Exit;
        end;
      end;

      if (B = GifApplicationLabel) then
      begin
        if not ConsumeApplicationExtension then
        begin
          {$IFDEF DebugPicsLib}
          if IsConsole then writeln('ConsumeApplicationExtension=False');
          {$ENDIF}
          Exit;
        end;

      end;

      if (B = GifCommentLabel) then
      begin
        if not ConsumeCommentExtension then
        begin
          {$IFDEF DebugPicsLib}
          if IsConsole then writeln('Comment Extension not supported yet');
          {$ENDIF}
          //Will do for now
          Width := GifHeader.ScreenWidth;
          Height := GifHeader.ScreenHeight;
          Exit(ifGif);
        end;
      end;

      if (B = GifPlainTextLabel) then
      begin
        if not ConsumePlainTextExtension  then
        begin
          {$IFDEF DebugPicsLib}
          if IsConsole then writeln('Plain Text Extension not supported yet');
          {$ENDIF}
          //Will do for now
          Width := GifHeader.ScreenWidth;
          Height := GifHeader.ScreenHeight;
          Exit(ifGif);
        end;
      end;
    end;

    if (B = GifImageSeparator) then // Image Separator - Identifies the beginning of an Image Descriptor
    begin
      // ImageBlock found
      {$IFDEF DebugPicsLib}
      writeln;writeln('Imageblock found');
      {$ENDIF}
      if (St.Read(ImageBlock{%H-}, SizeOf(TGIFImageBlock)) <> SizeOf(TGIFImageBlock)) then
      begin
        {$ifdef DebugPicsLib}
        if IsConsole then writeln('Fail to read TGIFImageBlock');
        {$endif}
        Exit;
      end;
      Width := LEToN(ImageBlock.Width);
      Height := LEToN(ImageBlock.Height);
      Result := ifGif;
      Break;
    end;
  end;

  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeGif: Result = ',Result);
  {$endif}
end;

