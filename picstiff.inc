//https://www.itu.int/itudoc/itu-t/com16/tiff-fx/docs/tiff6.pdf

type
  TTifHeader        = packed record
                        BOM: word;     // 'II' for little endian, 'MM' for big endian
                        Sig: word;     // Signature (42)
                        IFD: DWORD;    // Offset where image data begin
                      end;

  TIFD_Field        = packed record
                        Tag: word;
                        FieldType: word;
                        ValCount: DWord;
                        ValOffset: DWord;
                      end;

  TByteOrder = (boLE, boBE);  // little edian, or big endian


const
  TiffSig       = 42;
  TiffLE        = $4949;  //'II'
  TiffBE        = $4D4D;  //'MM'
  TiffTagWidth  = $0100;
  TiffTagHeight = $0101;
  TiffTagXRes   = $011A;
  TiffTagYRes   = $011B;
  TiffTagUnits  = $0128;
  TiffResUnitNone = 1;
  TiffResUnitInch = 2;
  TiffResUnitCm = 3;


{ Makes sure that the byte order of w is the same as specified by the parameter }
function FixByteOrder(w: Word; AByteOrder: TByteOrder): Word; overload;
begin
  if (AByteOrder = boLE) then
    Result := LEToN(w)
  else
    Result := BEToN(w);
  //Result := IfThen(AByteOrder = boLE, LEToN(w), BEToN(w));  I prefer readable code over shorter code...
end;

{ Makes sure that the byte order of dw is the same as specified by the parameter }
function FixByteOrder(dw: DWord; AByteOrder: TByteOrder): DWord; overload;
begin
  if (AByteOrder = boLE) then
    Result := LEToN(dw)
  else
    Result := BEToN(dw);
  //Result := IfThen(AByteOrder = boLE, LEToN(dw), BEToN(dw));
end;

//Adapted form fpSpreadSheet
function MaybeTIFF(St: TStream; out Width, Height: DWord; out dpiX, dpiY: Double): TImageFormat;
//Based upon code by By wp in:  https://forum.lazarus.freepascal.org/index.php?topic=31776.msg204204;topicseen#msg204204
var
  Header: TTifHeader = (BOM:0; Sig:0; IFD:0);
  DirEntries: Word;
  Field: TIFD_Field = (Tag:0; FieldType:0; ValCount:0; ValOffset:0);
  i: Integer;
  ByteOrder: TByteOrder;
  Num, Denom: LongInt;
  Units: Word;
  pStart, pCur: Int64;
  dpiXFound, dpiYFound: Boolean;
begin
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeTiff A');
  {$endif}
  Result := ifUnknown;
  dpiX := 0;
  dpiY := 0;
  Width := 0;
  Height := 0;
  dpiX := 0;
  dpiY := 0;
  Units := 0;
  dpiXFound := False;
  dpiYFound := False;
  pStart := St.Position;
  if St.Read(Header, SizeOf(TTifHeader)) < SizeOf(TTifHeader) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('MaybeTiff: Fail to read TTiffHeader');
    {$endif}
    Exit;
  end;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('Header.Bom=$',Header.Bom.ToHexString);
  if IsConsole then writeln('Header.Sig=$',Header.Sig.ToHexString);
  if IsConsole then writeln('Header.IFD=$',Header.IFD.ToHexString);
  {$endif}

  if not ((Header.BOM = TiffLE) or (Header.BOM = TiffBE)) then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('MaybeTiff: invalid Header.Bom: $',Header.Bom.ToHexString);
    {$endif}
    Exit;
  end;

  if Header.BOM = TiffLE then
    ByteOrder := boLE
  else
    ByteOrder := boBE;
  if FixByteOrder(Header.Sig, ByteOrder) <> TiffSig then
  begin
    {$ifdef DebugPicsLib}
    if IsConsole then writeln('MaybeTiff: invalid Header.Sig: $',Header.Sig.ToHexString);
    {$endif}
    Exit;
  end;

  St.Position := pStart + FixByteOrder(Header.IFD, ByteOrder);
  if not St.TryReadWord(DirEntries) then
  begin
    {$IFDEF DebugPicsLib}
    if IsConsole then writeln('Fail to read DirEnries');
    {$ENDIF}
    Exit;
  end;
  DirEntries := FixByteOrder(DirEntries, ByteOrder);

  {$ifdef DebugPicsLib}
  if IsConsole then writeln('DirEntries=',DirEntries);
  {$endif}

  for i := 1 to DirEntries do
  begin
    if not (St.Read(Field, SizeOf(Field)) = SizeOf(TIFD_Field)) then
    begin
      {$IFDEF DebugPicsLib}
      if IsConsole then writeln('Fail to read TIFD_Field');
      {$ENDIF}
      Exit;
    end;
    Field.Tag := FixByteOrder(Field.Tag, ByteOrder);
    Field.ValOffset := FixByteOrder(Field.ValOffset, ByteOrder);
    Field.FieldType := FixByteOrder(Field.FieldType, ByteOrder);
    {$ifdef DebugPicsLib}
    if IsConsole then
    begin
      write('Field.Tag=$',Field.Tag.ToHexString);
      case Field.Tag OF
        $0100 : writeln(' (Width)');
        $0101 : writeln(' (Height)');
        $011A : writeln(' (XResolution)');
        $011B : writeln(' (YResolution)');
        $0128 : writeln(' (Units)');
      otherwise writeln;
      end; //case
    end;
    {$endif}
    pCur := St.Position;
    case Field.Tag OF
      TiffTagWidth: Width := Field.ValOffset;
      TiffTagHeight: Height := Field.ValOffset;
      TiffTagXRes:
        begin    // XResolution as RATIONAL value
          dpiXFound := True;
          St.Position := pStart + Field.ValOffset;
          if not St.TryReadInt32(Num) then
          begin
            {$IFDEF DebugPicsLib}
            if IsConsole then writeln('Fail to read Num');
            {$ENDIF}
            Exit;
          end;
          if not St.TryReadInt32(Denom) then
          begin
            {$IFDEF DebugPicsLib}
            if IsConsole then writeln('Fail to read Denom');
            {$ENDIF}
            Exit;
          end;
          Num := FixByteOrder(DWord(Num), ByteOrder);
          Denom := FixByteOrder(DWord(Denom), ByteOrder);
          dpiX := Num/Denom;
        end;
      TiffTagYRes:
        begin    // YResolution as RATIONAL value
          dpiYFound := True;
          St.Position := pStart + Field.ValOffset;
          if not St.TryReadInt32(Num) then
          begin
            {$IFDEF DebugPicsLib}
            if IsConsole then writeln('Fail to read Num');
            {$ENDIF}
            Exit;
          end;
          if not St.TryReadInt32(Denom) then
          begin
            {$IFDEF DebugPicsLib}
            if IsConsole then writeln('Fail to read Denom');
            {$ENDIF}
            Exit;
          end;
          Num := FixByteOrder(DWord(Num), ByteOrder);
          Denom := FixByteOrder(DWord(Denom), ByteOrder);
          dpiY := Num/Denom;
        end;
      TiffTagUnits: Units := Field.ValOffset;   // 1: non-square 2: inches, 3: cm
    end;
    //found dpiX and dpiY can be zero, so checking for > 0 is wrong
    if (Width > 0) and (Height > 0) and dpiXFound and dpiYFound and (Units > 0) then
    begin
      {$ifdef DebugPicsLib}
      if IsConsole then writeln('Found width, heigth, dpiX, dpiY and Units');
      {$endif}
      Break;
    end;
    St.Position := pCur;
  end;

  case Units of
    TiffResUnitNone:
      begin
        dpiX := 96;
        dpiY := 96;
      end;
    TiffResUnitInch: ;  // is already inches, nothing to do
    TiffResUnitCm:
      begin
        dpiX := dpiX * 2.54;
        dpiY := dpiY * 2.54;
       end;
  end;

  Result := ifTiff;
  {$ifdef DebugPicsLib}
  if IsConsole then writeln('MaybeTIFF End.');
  {$endif}
end;

