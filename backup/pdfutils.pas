unit PdfUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpPDF, ChargeConstantes, Math, Unitcalcul, Graphics, Controls, fpTTF,
  BGRABitmap, BGRABitmapTypes, LclIntF, LazUTF8, FPImage, FPReadPNG, FPWritePNG, FPWriteJPEG;

Procedure PdfEncadre(PdfPage: TPDFPage; X: Single; Y: Single; Bouclier: Boolean; TB1: String; TB2: String; TH: String);
Procedure PdfCentre(PdfPage: TPDFPage; Min: Single; Max: Single; Y: Single; Texte: String);
Procedure PdfEcrit(PdfPage: TPDFPage; Min: Single; Max: Single; Y: Single; Texte: String; MinPolice: Integer);
Procedure PdfTaillePolice(PdfPage: TPDFPage; IdPolice:Integer; NomPolice: String; Taille:Integer);
Procedure PdfLigneV(PdfPage: TPDFPage; PosX:Single; PosYMin:Single; PosYMax:Single; Epaisseur:Single);
Procedure PdfLigneH(PdfPage: TPDFPage; PosY:Single; PosXMin:Single; PosXMax:Single; Epaisseur:Single);
Function PdfSupprimeGenerique(Code: String; Chaine: String): String;
procedure RedimensionneImage(inWidth: dWord; inHeigth: dWord; maxWidth: dWord; maxHeigth: dWord; out resWidth: dWord; out resHeigth: dWord);
function ColorToARGB(AColor: TColor; Transparent: Integer): TARGBColor;
Function ChargeImageArrayColor(Niveau: Integer): TColor;
procedure ChargeImageTImageList(Niveau: Integer; ListImage: TImageList);
procedure RemplacerPixelParTransparent(const FileOrig: string; Const FileDest: String);
function TestCouleur(img: TBGRABitmap; x: integer;y: integer; VerifTrans: Boolean):boolean;
Function TailleTexte(Texte: String; FontTaille: Integer): TPDFFloat;
Function TestPixelZeroZero(Const Filename: String): Boolean;

implementation

Var
  ZeroRed:   integer;
  ZeroGreen: integer;
  ZeroBlue:  integer;

Procedure PdfEncadre(PdfPage: TPDFPage; X: Single; Y: Single; Bouclier: Boolean; TB1: String; TB2: String; TH: String);
  var
    Bas: Single;
  begin
    if Bouclier = false then
      begin
        PdfPage.DrawLine(X-2, Y-2, X+4, Y-2, 1);
        PdfPage.DrawLine(X-2, Y+4, X+4, Y+4, 1);
        PdfPage.DrawLine(X-2, Y-2, X-2, Y+4, 1);
        PdfPage.DrawLine(X+4, Y-2, X+4, Y+4, 1);
        Bas := 6;
      end
    else
      begin
       PdfPage.DrawLine(X-2.5, Y+2, X+1, Y+5, 1);
       PdfPage.DrawLine(X+1, Y+5, X+4.5, Y+2, 1);
       PdfPage.DrawLine(X-2.5, Y+2, X, Y-2.5, 1);
       PdfPage.DrawLine(X+4.5, Y+2, X+2, Y-2.5, 1);
       PdfPage.DrawLine(X+2, Y-2.5, X+1, Y-3.5, 1);
       PdfPage.DrawLine(X, Y-2.5, X+1, Y-3.5, 1);
       Bas := 7.5
      end;
    PdfCentre(PdfPage, X-6, X+10, Y-Bas, TB1);
    if TB2 <> '' then
      PdfCentre(PdfPage, X-8, X+10, Y-Bas-4, TB2);
    if TH <> '' then
      PdfCentre(PdfPage, X-8, X+12, Y+5, TH);
  end;

Function TailleTexte(Texte: String; FontTaille: Integer): TPDFFloat;
  var
    PosTemp:      TPDFFloat;
    lFC:          TFPFontCacheItem;
  Begin
    lFC     := gTTFontCache.Find(PdfFamilyName, PdfIsBold, PdfIsItalic);
    PosTemp := PDFTomm(lFC.TextWidth(Texte, FontTaille));
    Result  := PosTemp;
  end;

Procedure PdfEcrit(PdfPage: TPDFPage; Min: Single; Max: Single; Y: Single; Texte: String; MinPolice: Integer);
  var
    TailleTemp:   Integer = 0;
    DeuxLignes:   Boolean = false;
    Ligne1:       String;
    Ligne2:       String;
    Ligne3:       String;
    PosTemp:      TPDFFloat;
    SousTrait:    Integer;
    Diff:         Float;
    Texte2:       String;

  BEgin
    Diff := (Max - Min) * 1.15;
    PosTemp := TailleTexte(Texte, PdfFontTaille);
    if PosTemp > Diff then
      begin
        TailleTemp := PdfFontTaille - 1;
        while TailleTexte(Texte, TailleTemp)  > Diff do
          Dec(TailleTemp);

        if TailleTemp < MinPolice then
          begin
            TailleTemp := MinPolice;
            DeuxLignes := true;
          end;

        if TailleTemp <> PdfFontTaille then
          PdfPage.SetFont(PdfFontEnCours, Tailletemp);
      end;

    if DeuxLignes = true then
      begin
        SousTrait := 1;
        while TailleTexte(UTF8Copy(Texte, 1, UTF8Length(Texte) - Soustrait), TailleTemp)  > Diff do
          Inc(Soustrait);

        while (UTF8Copy(Texte, UTF8Length(Texte) - Soustrait, 1) <> ' ')
              and (UTF8Copy(Texte, UTF8Length(Texte) - Soustrait, 1) <> '|')
              and (UTF8Copy(Texte, UTF8Length(Texte) - Soustrait, 1) <> ',') do
          Inc(Soustrait);

        Ligne1 := UTF8Copy(Texte, 1, UTF8Length(Texte) - Soustrait - 1);
        Ligne2 := UTF8Copy(Texte, UTF8Length(Texte) - Soustrait, UTF8Length(Texte));
        Ligne1 := Trim(Ligne1);

        if TailleTexte(Ligne2, TailleTemp) > Diff then
          begin
            Texte2 := Ligne2;
            SousTrait := 1;

            while TailleTexte(UTF8Copy(Texte2, 1, UTF8Length(Texte2) - Soustrait), TailleTemp)  > Diff do
              Inc(Soustrait);

            while (UTF8Copy(Texte2, UTF8Length(Texte2) - Soustrait, 1) <> ' ')
                  and (UTF8Copy(Texte2, UTF8Length(Texte2) - Soustrait, 1) <> '|')
                  and (UTF8Copy(Texte2, UTF8Length(Texte2) - Soustrait, 1) <> ',') do
              Inc(Soustrait);

            Ligne2 := UTF8Copy(Texte2, 1, UTF8Length(Texte2) - Soustrait - 1);
            Ligne3 := UTF8Copy(Texte2, UTF8Length(Texte2) - Soustrait, UTF8Length(Texte2));
            Ligne2 := Trim(Ligne2);
            PdfPage.WriteText(Min, Y+1.4, Ligne1);
            PdfPage.WriteText(Min, Y, ' '+Ligne2);
            PdfPage.WriteText(Min, Y-1.4, ' '+Ligne3);
          end
        else
          begin
            PdfPage.WriteText(Min, Y+1, Ligne1);
            PdfPage.WriteText(Min, Y-1, '  '+Ligne2);
          end;
      end
    else
      PdfPage.WriteText(Min, Y, Texte);
    if TailleTemp <> PdfFontTaille then
      PdfPage.SetFont(PdfFontEnCours, PdfFontTaille);
  end;

Procedure PdfTaillePolice(PdfPage: TPDFPage; IdPolice:Integer; NomPolice: String; Taille:Integer);
  Var
    NomFamille:       String;
  begin
    PdfFontTaille     := Taille;
    PdfFontEnCours    := IdPolice;
    PdfIsBold         := (Pos(ConstPoliceGras, NomPolice) > 0);
    PdfIsItalic       := (Pos(ConstPoliceItalique, NomPolice) > 0);
    NomFamille        := NomPolice;
    if PdfIsBold then
       NomFamille := StringReplace(NomFamille,ConstPoliceGras,'', [rfReplaceAll]);
    if PdfIsItalic then
       NomFamille := StringReplace(NomFamille,ConstPoliceItalique,'', [rfReplaceAll]);
    PdfFamilyName     := TrimRight(NomFamille);
    PdfPage.SetFont(IdPolice, PdfFontTaille);
  end;


Procedure PdfCentre(PdfPage: TPDFPage; Min: Single; Max: Single; Y: Single; Texte: String);
  var
    Ajout:        Single = 0.2;
    TailleTemp:   Integer = 0;
    Prorata:      Single;
    lFC:          TFPFontCacheItem;
    PosTemp:      TPDFFloat;
  BEgin
    lFC:= gTTFontCache.Find(PdfFamilyName, PdfIsBold, PdfIsItalic);
    PosTemp:= PDFTomm(lFC.TextWidth(Texte, PdfFontTaille));

    if PosTemp < (Max - Min) then
      Ajout := ((Max - Min - PosTemp) / 2)
    else
      begin
        Prorata    := (Max - Min) / PosTemp;
        Tailletemp := Ceil(PdfFontTaille * Prorata);
        if Tailletemp = PdfFontTaille then
          Tailletemp := Tailletemp - 1;

        PdfPage.SetFont(PdfFontEnCours, Tailletemp);
      end;

    PdfPage.WriteText( Min + Ajout, Y, Texte);
    if TailleTemp <> 0 then
      PdfPage.SetFont(PdfFontEnCours, PdfFontTaille);
  end;

Function PdfSupprimeGenerique(Code: String; Chaine: String): String;
  Begin
    if Pos(ValeurGenerique, Code) = 0 then
      Result := Chaine
    else
      Result := ExtractStringBefore(Chaine, '(');
  end;


procedure RedimensionneImage(inWidth: dWord; inHeigth: dWord; maxWidth: dWord; maxHeigth: dWord; out resWidth: dWord; out resHeigth: dWord);
  var
    Prorata: float;
  begin
    if (inWidth <> 0) and (inHeigth <> 0) and (maxWidth <> 0) and (maxHeigth <> 0) then
      begin
        if (inWidth / maxWidth) > (inHeigth / maxHeigth) then
          Prorata := (inWidth / maxWidth)
        else
          Prorata := (inHeigth / maxHeigth);
        resWidth := round(inWidth / Prorata);
        resHeigth:= round(inHeigth / Prorata);
      end
    else
      begin
        resWidth  := 0;
        resHeigth := 0;
      end;
  end;


function ColorToARGB(AColor: TColor; Transparent: Integer): TARGBColor;
type
  TColorRec = record r,g,b,a: byte; end;
  TARGBColorRec = record b,g,r,a: byte; end;
begin
  with TARGBColorRec(Result) do
  begin
    b := TColorRec(AColor).b;
    g := TColorRec(AColor).g;
    r := TColorRec(AColor).r;
    a := Transparent;
  end;
end;

Function ChargeImageArrayColor(Niveau: Integer): TColor;
  var
    picture:          TPicture;
    Bitmap:           TBitmap;
    Path:             String;
    ColorLoc:         TColor;
  begin
    Picture  := TPicture.Create;
    Bitmap   := TBitmap.Create;
    try
      Path   :=GetCurrentDir+ConstCheminImageNiveau+InttoStr(Niveau)+'.PNG';
      Picture.LoadFromFile(Path);
      Bitmap.Assign(Picture.graphic);
      ColorLoc := Bitmap.Canvas.Pixels[1, 1];
    finally
      Picture.Free;
      Bitmap.Free;
    end;
    Result := ColorLoc;
  end;

procedure ChargeImageTImageList(Niveau: Integer; ListImage: TImageList);
  var
    picture:          TPicture;
    Bitmap:           TBitmap;
    Path:             String;
  begin
    Picture  := TPicture.Create;
    Bitmap   := TBitmap.Create;
    try
      Path   :=GetCurrentDir+ConstCheminImageNiveau+InttoStr(Niveau)+'.PNG';
      Picture.LoadFromFile(Path);
      Bitmap.Assign(Picture.graphic);
      ListImage.Add(Bitmap, nil);
    finally
      Picture.Free;
      Bitmap.Free;
    end;
  end;

function TestCouleur(img: TBGRABitmap; x: integer;y: integer; VerifTrans: Boolean):boolean;
var
  TestRed:   Integer;
  TestGreen: Integer;
  TestBlue:  Integer;
  MaxDiff:   Integer = 2000;
begin
  if VerifTrans then
    begin
      TestRed   := BGRAPixelTransparent.red;
      TestGreen := BGRAPixelTransparent.Green;
      TestBlue  := BGRAPixelTransparent.Blue;
    end
  else
    begin
      TestRed   := ZeroRed;
      TestGreen := ZeroGreen;
      TestBlue  := ZeroBlue;
    end;

  if (img.Colors[x, y].Red   = TestRed)   and // test equal
     (img.Colors[x, y].Green = TestGreen) and
     (img.Colors[x, y].Blue  = TestBlue)  then
    Result := true
  else if (VerifTrans = false) and            // test close if not test transparent
          (abs(img.Colors[x, y].Red   - TestRed)   < MaxDiff) and
          (abs(img.Colors[x, y].Green - TestGreen) < MaxDiff) and
          (abs(img.Colors[x, y].Blue  - TestBlue)  < MaxDiff) then
    Result := true
  else
    Result := false;
end;

Function TestPixelZeroZero(Const Filename: String): Boolean;
  var
    Img: TBGRABitmap;
    Res: Boolean = false;
  begin
    Img  := TBGRABitmap.Create(FileName);
  try
    Res  := (Img.GetPixel(0, 0) = BGRAPixelTransparent);
  finally
    Img.Free;
  end;
  Result := Res;
end;


procedure RemplacerPixelParTransparent(const FileOrig: string; Const FileDest: String);
var
  Img:   TBGRABitmap;
  x,y:   Integer;
  Modif: boolean;
begin
  Img := TBGRABitmap.Create(FileOrig);
  try
    ZeroRed    := img.Colors[0, 0].Red;
    ZeroGreen  := img.Colors[0, 0].Green;
    ZeroBlue   := img.Colors[0, 0].Blue;

    For x :=0 to img.Width - 1 do
      for y := 0 to img.Height - 1 do
        begin
          Modif := true;
          if not TestCouleur(Img, x, y, false) then
            Modif := false
            // test pixel itself
          else if ((x = 0) or (Y = 0)) then
            // no other test for 1st line and column
          else if TestCouleur(Img, x-1, y, true) then
            // previous x is transparent
          else if TestCouleur(Img, x, y-1, true) then
            // previous y is transparent
          else
            Modif := false;
            // the pixel isn't close to a transparent

          if Modif then
            Img.ReplaceColor(Img.GetPixel(x, y), BGRAPixelTransparent);
        end;
    Img.SaveToFile(FileDest);
  finally
    Img.Free;
  end;
end;

Procedure PdfLigneV(PdfPage: TPDFPage; PosX:Single; PosYMin:Single; PosYMax:Single; Epaisseur:Single);
begin
  PdfPage.DrawLine( PosX, PosYMin, PosX, PosYMax, Epaisseur);
end;

Procedure PdfLigneH(PdfPage: TPDFPage; PosY:Single; PosXMin:Single; PosXMax:Single; Epaisseur:Single);
begin
  PdfPage.DrawLine( PosXMin, PosY, PosXMax, PosY, Epaisseur);
end;

end.

