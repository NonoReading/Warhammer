//https://www.xfree86.org/current/xpm.pdf
//https://en.wikipedia.org/wiki/X_PixMap

//XPM's are plain text files
const
  XpmSig = 'XPM';
  {$IFDEF DebugPicsLib}
  XpmStaticCharTextStart = 'static char * ';
  {$ENDIF}
  CommentStart = '/*';
  CommentEnd = '*/';
  WhiteSpace = [9,10,13,32];

//XPM version 3 only
function MaybeXPM(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
var
  S: String;
  CharsPerPixel, X_HotSpot, Y_HotSpot: DWord;
  nColors: Int32;
  {$IFDEF DebugPicsLib}
  nValues: Integer;
  {$ENDIF}
  C: AnsiChar;

  function Peek: Byte;
  begin
    Result := St.ReadByte;
    St.Position := St.Position - 1;
  end;

  function ConsumeWhiteSpace: Boolean;
  var
    B: Byte;
    StartPos: Int64;
  begin
    StartPos := St.Position;
    repeat
      B := St.ReadByte;
    until not (B in WhiteSPace) or (St.Position >= St.Size);
    if not (B in WhiteSpace) then St.Position := St.Position - 1;
    Result := (St.Position > StartPos);
  end;

  function FindText(const AText: String; CaseSensitive, MustHaveLeadingWhiteSpace: Boolean): Boolean;
  var
    Found: String;
    n: Int64;
  begin
    Result := False;
    if (not ConsumeWhiteSpace) and MustHaveLeadingWhiteSpace then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Expected whitespace not found');
      {$ENDIF}
      Exit;
    end;
    Found := '';
    SetLength(Found,Length(AText));
    n := St.Read(Found[1], Length(AText));
    if (n <> Length(AText)) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then
      begin
        if (n > 0) then
          SetLength(Found ,n)
        else
          Found := '';
        writeln('Fail to read ',AText,', could only read ',Length(AText),' bytes, got ',Found);
      end;
      {$ENDIF}
      Exit;
    end;
    if CaseSensitive then
      Result := (AText = Found)
    else
      Result := (CompareText(AText, Found) = 0);
  end;

  function SkipUntilChar(C: AnsiChar; CaseSensitive: Boolean = False): Boolean;
  var
    AChar: AnsiChar;
    B: Byte;
  begin
    Result := False;
    ConsumeWhiteSpace;
    if not CaseSensitive then
      C := UpCase(C);
    repeat
      B := St.ReadByte;
      AChar := AnsiChar(B);
      if not CaseSensitive then
        AChar := UpCase(AChar);
    until (AChar = C) or (B in WhiteSpace) or (St.Position > St.Size);
    Result := (AChar = C);
  end;

  function FindNextWord(out AText: String; StopChars: TSysCharSet): Boolean;
  var
    B: Byte;
  begin
    Result := False;
    ConsumeWhiteSpace;
    if St.Position >= St.Size then
      Exit;
    AText := '';
    repeat
      B := St.ReadByte;
      AText := AText + AnsiChar(B);
    until (B in WhiteSpace) or (AnsiChar(B) in StopChars) or (St.Position >= St.Size);
    if (B in WhiteSpace) or (AnsiChar(B) in StopChars) then
    begin
      St.Position := St.Position - 1;
      SetLength(AText, Length(AText) -1);
    end;
    Result := (AText <> '');
  end;

  function FindNextChar(out AChar: AnsiChar; MustHaveLeadingWhiteSpace: Boolean): Boolean;
  begin
    if (not ConsumeWhiteSpace) and MustHaveLeadingWhiteSpace then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Expected whitespace not found');
      {$ENDIF}
      Exit;
    end;
    if (St.Position >= St.Size) then
      Exit;
    Result := (St.Read(AChar{%H-}, 1) = 1);
  end;

  function FindXPMSig: Boolean;
  begin
    Result := False;
    if not FindText(CommentStart, True, False) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Start of XPM signature not found');
      {$ENDIF}
      Exit;
    end;
    if not FindText(XpmSig, False, False) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('XPM signature not found');
      {$ENDIF}
      Exit;
    end;
    if not FindText(CommentEnd, True, False) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Start of XPM signature not found');
      {$ENDIF}
      Exit;
    end;
    Result := True;
  end;

  function FindCharArrayDefinition: Boolean;
  begin
    Result := False;
    //'static' can be right after '*/', no leading whitespace required, 'char' and '*' require leading whitespace
    if not (FindText('static', True, False) and FindText('char',True,True) and (FindNextChar(C, True) and (C='*'))) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('"',XpmStaticCharTextStart,'" not found');
      {$ENDIF}
      Exit;
    end;
    if not SkipUntilChar('[') then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Could not find "["');
      {$ENDIF}
      Exit;
    end;
    if not SkipUntilChar(']') then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Could not find "]"');
      {$ENDIF}
      Exit;
    end;
    if not SkipUntilChar('=') then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Could not find "="');
      {$ENDIF}
      Exit;
    end;
    if not SkipUntilChar('{') then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Could not find "{"');
      {$ENDIF}
      Exit;
    end;
    Result := True;
  end;

  function FindValues: Boolean;
  begin
    Result := False;
    if not SkipUntilChar('"') then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Could not find quote character (")');
      {$ENDIF}
      Exit;
    end;

    if not FindNextWord(S, ['"',',']) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Unable to find Width');
      {$ENDIF}
      Exit;
    end;
    //writeln('FindNextWord -> "',S,'"');
    if not TryStrToDWord(S, Width)  or (Width > $7D000) then //Any DWord should do, but IrfanView refuses any value > $7D000
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Invalid value for Width: got ',S);
      {$ENDIF}
      Exit;
    end;

    if not FindNextWord(S, ['"',',']) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Unable to find Height');
      {$ENDIF}
      Exit;
    end;
    //writeln('FindNextWord -> "',S,'"');
    if not TryStrToDWord(S, Height) or (Height > $7D000) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Invalid value for Height: got ',S);
      {$ENDIF}
      Exit;
    end;

    if not FindNextWord(S, ['"',',']) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Unable to find nColors');
      {$ENDIF}
      Exit;
    end;
    //writeln('FindNextWord -> "',S,'"');
    if not TryStrToInt(S, nColors) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Invalid value for nColors: got ',S);
      {$ENDIF}
      Exit;
    end;

    if not FindNextWord(S, ['"',',']) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Unable to find CharsPerPixel');
      {$ENDIF}
      Exit;
    end;
    //writeln('FindNextWord -> "',S,'"');
    if not TryStrToDWord(S, CharsPerPixel) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Invalid value for CharsPerPixel: got ',S);
      {$ENDIF}
      Exit;
    end;

    ConsumeWhiteSpace;
    {$IFDEF DebugPicsLib}
    nValues := 4;
    {$ENDIF}
    if (Peek <> Byte('"')) then
    begin
      //must contain find x_hotspot and y_hotspot
      {$IFDEF DebugPicsLib}
      nValues := 6;
      {$ENDIF}

      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('there should be 6 values in this XPM');
      {$ENDIF}

      if not FindNextWord(S, ['"',',']) then
      begin
        {$IFDEF DebugPicsLib}
        if IsConsole then writeln('Unable to find X_HotSpot');
        {$ENDIF}
        Exit;
      end;
      //writeln('FindNextWord -> "',S,'"');
      if not TryStrToDWord(S, X_HotSpot) then
      begin
        {$IFDEF DebugPicsLib}
        if IsConsole then writeln('Invalid value for X_HotSpot: got ',S);
        {$ENDIF}
        Exit;
      end;
      if not FindNextWord(S, ['"',',']) then
      begin
        {$IFDEF DebugPicsLib}
        if IsConsole then writeln('Unable to find X_HotSpot');
        {$ENDIF}
        Exit;
      end;
      //writeln('FindNextWord -> "',S,'"');
      if not TryStrToDWord(S, Y_HotSpot) then
      begin
        {$IFDEF DebugPicsLib}
        if IsConsole then writeln('Invalid value for Y_HotSpot: got ',S);
        {$ENDIF}
        Exit;
      end;
    end;
    //FindNextChar already consumes whitespace
    //ConsumeWhitespace;
    if not FindNextChar(C, False) or (C <> '"') then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Could not find closing quote (") after ',nValues,' values');
      {$ENDIF}
      Exit;
    end;
    Result := True;
  end;

  function FindClosing: Boolean;
  var
    S: String;
    n, NewPos: Int64;
  begin
    //we're lazy and assume that there is not big amounts of whitespace at the end of the stream
    Result := False;
    S := '';
    NewPos := St.Size - 256;
    if (NewPos < 0) then NewPos := 0;
    St.Position := NewPos;
    SetLength(S, 256);
    n := St.Read(S[1], 256);
    if (n < 3) then
      Exit;
    SetLength(S, n);
    S := TrimRight(S);
    if (S[Length(S)] <> ';') or (Length(S) < 3) then
      Exit;
    SetLength(S, Length(S) - 1);
    S := TrimRight(S);
    if (S[Length(S)] <> '}')  or (Length(S) < 2) then
      Exit;
    SetLength(S, Length(S) - 1);
    S := TrimRight(S);
    if (S[Length(S)] <> '"') then
      Exit;
    Result := True;
  end;

begin
  Result := ifUnknown;
  dpiX := 0;
  dpiY := 0;
  Width := 0;
  Height := 0;
  S := '';
  //while moste XPM's are nicely formatted (each section etc on a new line), this is however not required.
  //whitespace shall be ignored
  if not FindXPMSig then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('XPM signature not found');
    {$ENDIF}
    Exit;
  end;

  //writeln('XPM Sig found');

  if not FindCharArrayDefinition then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('static char definition not found');
    {$ENDIF}
    Exit;
  end;

  if not FindValues then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Values (width,heigth,nColors,charsperpixel,x_hotspot,y_hotspot) not found or invalid');
    {$ENDIF}
    Exit;
  end;


  //FindNextChar already consumes whitespace
  //ConsumeWhiteSpace;
  if not FindNextChar(C, False) or (C <> ',') then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Could not find comma (,) after values');
    {$ENDIF}
    Exit;
  end;

  {$IFDEF DebugPicsLib}
  if IsConsole then writeln('Width=',Width);
  if IsConsole then writeln('Height=',Height);
  if IsConsole then writeln('nColors=',nColors);
  if IsConsole then writeln('CharsPerPixel=',CharsPerPixel);
  if (nValues = 6) then
  begin
    if IsConsole then writeln('X_HotSpot=',X_HotSpot);
    if IsConsole then writeln('Y_HotSpot=',Y_HotSpot);
  end;
  {$ENDIF}

  //ToDo? check code ends with XpmEnd
  if not FindClosing then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Could not find closing sequence ("};) at end of stream');
    {$ENDIF}
    Exit;
  end;
  Result := ifXPM;
end;
