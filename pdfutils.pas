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
Function PdfSupprimeGenerique(Code: String; Chaine: String): String;
procedure RedimensionneImage(inWidth: dWord; inHeigth: dWord; maxWidth: dWord; maxHeigth: dWord; out resWidth: dWord; out resHeigth: dWord);
function ColorToARGB(AColor: TColor; Transparent: Integer): TARGBColor;
Function ChargeImageArrayColorFichier(Chemin: String): TColor;
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

// Couleur d'encadrement tiree du pixel [1,1] d'une image DESIGNEE PAR SON CHEMIN. Le
// chemin peut venir du dossier d'un livre : c'est l'appelant qui l'a resolu.
// Fichier absent = gris fonce, jamais d'exception - un niveau peut ne pas avoir d'icone.
Function ChargeImageArrayColorFichier(Chemin: String): TColor;
  var
    picture:          TPicture;
    Bitmap:           TBitmap;
  begin
    Result := CouleurGrisFonce;
    if not FileExists(Chemin) then
      Exit;
    Picture  := TPicture.Create;
    Bitmap   := TBitmap.Create;
    try
      Picture.LoadFromFile(Chemin);
      Bitmap.Assign(Picture.graphic);
      Result := Bitmap.Canvas.Pixels[1, 1];
    finally
      Picture.Free;
      Bitmap.Free;
    end;
  end;

// Variante historique, sur le dossier generique.
Function ChargeImageArrayColor(Niveau: Integer): TColor;
  begin
    Result := ChargeImageArrayColorFichier(GetCurrentDir+ConstCheminImageNiveau+InttoStr(Niveau)+'.PNG');
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

// ATTENTION - CETTE FONCTION N'EST PLUS APPELEE PAR PERSONNE depuis la reecriture de
// RemplacerPixelParTransparent le 31/08/2026, qui etait son unique utilisatrice. Elle est
// conservee telle quelle en attendant que Nono decide de la supprimer, avec les trois
// variables d'unite ZeroRed / ZeroGreen / ZeroBlue plus haut.
//
// NE PAS LA REUTILISER EN L'ETAT, elle porte deux defauts signales et non corriges :
//   - avec VerifTrans = True elle ne teste PAS la transparence. Elle compare R, G et B a
//     ceux de BGRAPixelTransparent, c'est-a-dire a (0,0,0), et IGNORE l'alpha : un pixel
//     NOIR OPAQUE y repond donc "oui, je suis transparent". Sur une icone a contour noir,
//     toute propagation basee dessus fuirait par le trait ;
//   - ZeroRed / ZeroGreen / ZeroBlue ne sont plus alimentees par personne et valent donc 0.
//     Avec VerifTrans = False, cette fonction compare aujourd'hui au noir, pas au fond.
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


// Rend transparent tout pixel proche de la couleur du coin (0,0).
//
// REECRITE LE 31/08/2026 POUR LA VITESSE. L'ancienne version appelait Img.ReplaceColor A
// L'INTERIEUR de la double boucle. ReplaceColor reparcourt l'image ENTIERE a chaque appel ;
// et comme le test de couleur avait une TOLERANCE alors que ReplaceColor exige la couleur
// EXACTE, chaque pixel d'anti-aliasing du bord survivait au remplacement, matchait quand
// meme au test suivant, et declenchait un nouveau balayage complet. Des centaines de
// balayages de l'image entiere pour une seule icone.
//
// Second cout, plus discret : img.Colors[x,y] est l'accesseur TFPColor de FPImage, qui
// convertit le pixel BGRA en quatre canaux 16 bits A CHAQUE LECTURE - et l'ancien
// TestCouleur le relisait une fois par canal, appele jusqu'a trois fois par pixel. Une
// vingtaine de conversions par pixel la ou une seule lecture suffit.
//
// Ici : un seul passage, ligne par ligne. ScanLine[y] donne un pointeur direct sur les
// pixels de la ligne, qu'on avance par Inc(p) - donc un parcours qui suit l'ordre de la
// memoire, alors que l'ancienne boucle allait en colonnes (x externe) sur des donnees
// rangees en lignes.
//
// TOLERANCE IDENTIQUE, PAS APPROCHEE : l'ancien MaxDiff valait 2000 sur l'echelle 16 bits
// de TFPColor. Un ecart de N sur 8 bits vaut exactement N*257 sur 16 bits, donc
// "diff16 < 2000" equivaut a "diff8 <= 7", c'est-a-dire au "< 8" ci-dessous.
//
// SEMANTIQUE RETENUE (choix de Nono, 31/08/2026) : tout pixel proche du fond devient
// transparent, OU QU'IL SOIT dans l'image. C'est deja ce que faisait l'ancienne version en
// pratique : ReplaceColor etant globale, elle court-circuitait la logique de propagation
// depuis les bords ecrite juste au-dessus d'elle, qui ne servait donc a rien. Les icones du
// projet sont sur fond uni. Si l'une d'elles avait un jour du fond EMPRISONNE a l'interieur
// du dessin et devant rester opaque, il faudrait un vrai remplissage par diffusion depuis
// les bords - et il faudrait alors d'abord corriger TestCouleur (voir son commentaire).
procedure RemplacerPixelParTransparent(const FileOrig: string; Const FileDest: String);
const
  Tolerance = 8;
var
  Img:  TBGRABitmap;
  Fond: TBGRAPixel;
  p:    PBGRAPixel;
  x, y: Integer;
begin
  Img := TBGRABitmap.Create(FileOrig);
  try
    if (Img.Width = 0) or (Img.Height = 0) then
      begin
        Img.SaveToFile(FileDest);
        Exit;
      end;

    Fond := Img.GetPixel(0, 0);

    // COIN DEJA TRANSPARENT : l'image arrive avec son fond detoure, il n'y a rien a enlever.
    //
    // Sortir ici n'est pas une economie, c'est une PROTECTION. Le RVB d'un pixel transparent
    // vaut (0,0,0) : sans ce test, la comparaison ci-dessous prendrait le NOIR pour la
    // couleur de fond et effacerait tous les pixels noirs de l'image, contours du dessin
    // compris. Mesure faite le 31/08/2026 sur WORK132 a WORK135, les images des carrieres du
    // lot 2 de High Elf, qui arrivent toutes avec un fond deja transparent : environ 50 % de
    // leurs pixels y passaient.
    //
    // Le garde existait deja, mais chez les APPELANTS - le "if (Not TestPixelZeroZero(...))"
    // de CheminMetierImage et de CheminRaceImage. Il est desormais AUSSI dans la routine,
    // pour qu'un troisieme appelant ecrit plus tard ne puisse pas passer a cote.
    if Fond.alpha = 0 then
      begin
        Img.SaveToFile(FileDest);
        Exit;
      end;

    for y := 0 to Img.Height - 1 do
      begin
        p := Img.ScanLine[y];
        for x := 0 to Img.Width - 1 do
          begin
            // Un pixel deja transparent n'a pas a etre re-teste : son RVB ne veut plus rien
            // dire, et le rendre transparent une seconde fois ne changerait rien.
            if (p^.alpha > 0) and
               (Abs(Integer(p^.red)   - Integer(Fond.red))   < Tolerance) and
               (Abs(Integer(p^.green) - Integer(Fond.green)) < Tolerance) and
               (Abs(Integer(p^.blue)  - Integer(Fond.blue))  < Tolerance) then
              p^ := BGRAPixelTransparent;
            Inc(p);
          end;
      end;

    // OBLIGATOIRE apres une ecriture directe via ScanLine : BGRABitmap garde une copie
    // LCL du bitmap, qu'il faut invalider pour qu'elle soit reconstruite depuis les
    // donnees qu'on vient de modifier.
    Img.InvalidateBitmap;

    Img.SaveToFile(FileDest);
  finally
    Img.Free;
  end;
end;

end.

