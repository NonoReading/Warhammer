unit UnitCalcul;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math, Grids, ChargeConstantes;



function CalculBlessure(Calcul: String; Force: Integer; Endurance: Integer; ForceMentale: Integer): Integer;
function ExtractStringBefore(const AText, ASeparator: string): string;
function ExtractStringAfter(const AText, ASeparator: string): string;
function ExtractString(const Source: string; StartIndex: Integer; const Delimiter: string): string;
function FindRowByText(StringGrid: TStringGrid; const SearchText: string; ColumnIndex: Integer): Integer;
function CountOccurrences(const Text, SubText: string): Integer;
function ExtractStringBetween(const AText, ASeparator1: string; ASeparator2: string): string;
function ExtractChaine(const SubStr, S: string; Offset: Integer): String;
Function GetTypeMetierEquipement(Equip: String): String;
Function CalculDegat(Calcul: String; Force: Integer): Integer;
function RechercherDansColonne(StringGrid: TStringGrid; const Recherche: string; Colonne: Integer): Integer;
function InList(StringRech: String; ListeValeur: String): Boolean;
function MultiChaine(LigneCalcul: String): Integer;
function ChaineSur(Taille: Integer; Orig: String): String;
Procedure DebutFin(Ch: String; var Deb: Integer; var Fin: Integer);
function RemoveQuotes(const Str: string): string;
Function CompareCompetence(Valeur1: String; Valeur2: String): Boolean;
Procedure DecodeBlessure(Calcul: String);
Procedure DecoupeCodeValeur(Code: String);
Procedure DecoupeCodeRecherche(Code: String);
Function CompareRechercheValeur(ValRecherche:String; ValTrouve:String):boolean;
Function CodeSansLivre(Code: String): String;

implementation

function ExtractChaine(const SubStr, S: string; Offset: Integer): String;
Var
  Ind: Integer;
  Ext: String = '';
  Nb:  Integer = 0;
  Fin: String = '';
begin
  For Ind := 1 to Length(S) do
    begin
      Ext := copy(S, Ind, 1);
      if Ext = SubStr then
        Nb := Nb + 1
      else if (Nb >= (OffSet -1)) and (Nb < (OffSet)) then
        Fin := Fin + Ext;
      if Nb > OffSet then
        break;
    end;
  result := Fin;
end;

function PosEx(const SubStr, S: string; Offset: Integer): Integer;
var
  P: Integer;
begin
  P := Pos(SubStr, Copy(S, Offset, Length(S) - Offset + 1));
  if P > 0 then
    Result := P + Offset - 1
  else
    Result := 0;
end;


function CountOccurrences(const Text, SubText: string): Integer;
var
  Position: Integer;
begin
  Result := 0;
  Position := Pos(SubText, Text);

  while Position > 0 do
  begin
    Inc(Result);
    Position := PosEx(SubText, Text, Position + Length(SubText));
  end;
end;

function ExtractStringBetween(const AText, ASeparator1: string; ASeparator2: string): string;
var
  SeparatorPos1:Integer;
  SeparatorPos2:Integer;
  Final:        String = '';
begin
  SeparatorPos1 := Pos(ASeparator1, AText);
  if SeparatorPos1 > 0 then
    Final := Copy(AText, SeparatorPos1+Length(ASeparator1), Length(AText));

  if Final <> '' then
    begin
      SeparatorPos2 := Pos(ASeparator2, Final);
      if SeparatorPos2 > 0 then
        Final := Copy(Final, 1, SeparatorPos2 - 1);
    end;

   Result := Final;
end;

function ExtractStringBefore(const AText, ASeparator: string): string;
var
  SeparatorPos: Integer;
begin
  SeparatorPos := Pos(ASeparator, AText);
  if SeparatorPos > 0 then
    Result := Copy(AText, 1, SeparatorPos - 1)
  else
    Result := AText;
end;

function ExtractStringAfter(const AText, ASeparator: string): string;
var
  SeparatorPos: Integer;
begin
  SeparatorPos := Pos(ASeparator, AText);
  if SeparatorPos > 0 then
    Result := Copy(AText, SeparatorPos + length(ASeparator), Length(AText))
  else
    Result := AText;
end;


function ExtractString(const Source: string; StartIndex: Integer; const Delimiter: string): string;
var
  DelimiterPos, NextDelimiterPos: Integer;
begin
  DelimiterPos := Pos(Delimiter, Source);
  NextDelimiterPos := DelimiterPos;

  for StartIndex := 1 to StartIndex - 1 do
  begin
    DelimiterPos := NextDelimiterPos;
    NextDelimiterPos := PosEx(Delimiter, Source, DelimiterPos + Length(Delimiter));
    if NextDelimiterPos = 0 then
      Break;
  end;

  if DelimiterPos > 0 then
    Result := Copy(Source, DelimiterPos + Length(Delimiter), NextDelimiterPos - DelimiterPos - Length(Delimiter))
  else
    Result := '';
end;


Function CalculBlessure(Calcul: String; Force: Integer; Endurance: Integer; ForceMentale: Integer): Integer;
  var
    Indice:    Integer;
    NbElem:    Integer;
    ChCalc:    string;
    Multi:     Integer;
    ValCalc:   Integer;
    BF,BE,BFM: Integer;
    ValAtt:    Integer;
  begin
    // Blessure
    NbElem := CountOccurrences(Calcul, '+') + 1;
    ValCalc := 0;
    BF := Floor(Force/10);
    BE := Floor(Endurance/10);
    BFM:= Floor(ForceMentale/10);
    for Indice := 1 to NbElem do
      begin
        ChCalc := ExtractChaine('+', Calcul, Indice);

        if Pos('x', ChCalc) > 0 then
          begin
            Multi := StrToInt(ExtractStringBefore(ChCalc, 'x'));
            ChCalc:= ExtractStringAfter(ChCalc, 'x');
          end
        else
          begin
            Multi := 1;
          end;
        case ChCalc of
          ConstBonusCaracF: ValAtt := BF;
          ConstBonusCaracE: ValAtt := BE;
          ConstBonusCaracFM:ValAtt := BFM;
        end;
        ValCalc := ValCalc + (ValAtt * Multi);
      end;

    Result := ValCalc;
  end;


function FindRowByText(StringGrid: TStringGrid; const SearchText: string; ColumnIndex: Integer): Integer;
  var
    row: Integer;
  begin
    Result := -1; // Valeur par défaut si la recherche ne trouve pas de correspondance

    for row := 0 to StringGrid.RowCount - 1 do
    begin
      if StringGrid.Cells[ColumnIndex, row] = SearchText then
      begin
        Result := row; // Correspondance trouvée, met à jour le numéro de ligne résultat
        Break; // Sort de la boucle après avoir trouvé la première correspondance
      end;
    end;
  end;

Function GetTypeMetierEquipement(Equip: String): String;
  var
    TypeEquipement:   String;
    Debut:            String;
    Strings:          TStringList;
    Ind:              Integer;
  begin
    Strings := TStringList.create;
    ExtractStrings([SeparateurMulti], [], PChar(Equip), Strings);
    TypeEquipement := '';
    for Ind := 0 to Strings.Count - 1 do
    begin
      if TypeEquipement <> '' then
        TypeEquipement := TypeEquipement+SeparateurMulti;
      DecoupeCodeValeur(Strings[Ind]);
      Debut := copy(CodeValeur,1,5);
        case Debut of
          EquipementCC: TypeEquipement := TypeEquipement+TypeEquipCC;
          EquipementCT: TypeEquipement := TypeEquipement+TypeEquipCT;
          EquipementMu: TypeEquipement := TypeEquipement+TypeEquipMU;
          EquipementAr: TypeEquipement := TypeEquipement+TypeEquipAr;
          else          TypeEquipement := TypeEquipement+TypeEquipDi;
        end;
    end;
    Strings.free;
    Result := TypeEquipement;
  end;

Function CalculDegat(Calcul: String; Force: Integer): Integer;
  var
    Indice:    Integer;
    NbElem:    Integer;
    ChCalc:    string;
    Multi:     Integer;
    ValCalc:   Integer;
    BF:        Integer;
    ValAtt:    Integer;
  begin
    // Blessure
    NbElem := CountOccurrences(Calcul, '+') + 1;
    ValCalc := 0;
    BF := Floor(Force/10);
    for Indice := 1 to NbElem do
    begin
      ChCalc := ExtractChaine('+', Calcul, Indice);
      ChCalc := StringReplace(ChCalc, '(', '', [rfReplaceAll]);
      ChCalc := StringReplace(ChCalc, ')', '', [rfReplaceAll]);

      if Pos('×', ChCalc) > 0 then
        begin
          Multi := StrToInt(ExtractStringBefore(ChCalc, '×'));
          ChCalc:= ExtractStringAfter(ChCalc, '×');
        end
      else
        begin
          Multi := 1;
        end;
      case ChCalc of
        ConstBonusCaracF:
          ValAtt := BF;
        else
          ValAtt := StrToIntDef(ChCalc,0);
      end;
      ValCalc := ValCalc + (ValAtt * Multi);
    end;

    Result := ValCalc;
  end;

function RechercherDansColonne(StringGrid: TStringGrid; const Recherche: string; Colonne: Integer): Integer;
  var
    Ligne: Integer;
  begin
    Result := -1; // Valeur de retour si la recherche n'est pas trouvée (-1 signifie "introuvable")
    for Ligne := 0 to StringGrid.RowCount - 1 do
    begin
      if CompareText(StringGrid.Cells[Colonne, Ligne], Recherche) = 0 then
      begin
        Result := Ligne; // On a trouvé la recherche à la ligne Ligne
        Break; // Sortir de la boucle une fois qu'on a trouvé la première occurrence
      end;
    end;
  end;

function InList(StringRech: String; ListeValeur: String): Boolean;
  Var
    Strings:          TStringList;
    Ind:              Integer;
    Trouve:           Boolean = false;
  Begin
    Strings := TStringList.create;
    ExtractStrings([','], [], PChar(ListeValeur), Strings);
    for ind := 0 to Strings.count - 1 do
      if StringRech = Strings[ind] then
        begin
          Trouve := true;
          Break;
        end;

    Strings.free;
    Result := Trouve;
  end;

function MultiChaine(LigneCalcul: String): integer;
  var
    Deb:   String;
    Fin:   String;
    Total: float;
    ResI:  Integer;
  begin
    ResI := StrToIntDef(LigneCalcul,0);
    if pos('X',Lignecalcul) > 0 then
      begin
        deb   := ExtractStringBefore(Lignecalcul,'X');
        fin   := ExtractStringafter(Lignecalcul,'X');
        Total := StrTointDef(deb,0) * StrTointDef(fin,0);
        resI  := Trunc(Total);
      end;
     Result := ResI;
  end;

function ChaineSur(Taille: Integer; Orig: String): String;
  var
    Res: String = '';
    Dif: Integer= 0;
  begin
    Dif := Taille - Length(Orig);
    if Dif > 0 then
      Res := StringOfChar(' ', Dif*2);
    Result := Res + Orig;

  end;

Procedure DebutFin(Ch: String; var Deb: Integer; var Fin: Integer);
  var
    IndS: integer;
  begin
    IndS := Pos(SeparateurChance, Ch);
    if IndS > 0 then
      begin
        Deb := StrToInt(Copy(Ch, 1, IndS-1));
        Fin := StrToInt(Copy(Ch, IndS+1, Length(Ch)));
      end
    else
      begin
        Deb := StrToInt(Ch);
        Fin := StrToInt(Ch);
      end;
  end;

function RemoveQuotes(const Str: string): string;
Var
  Res: String;
begin
  Res   := StringReplace(Str, '"', '', [rfReplaceAll]);
  Res   := StringReplace(Res, '&amp;', '&', [rfReplaceAll]);
  Result:= Res;
end;

Function CompareCompetence(Valeur1: String; Valeur2: String): Boolean;
  var
    Val1,Val2:  String;
    Res:        Boolean = false;
  begin
   Val1 := Valeur1;
   Val2 := Valeur2;
   res  := (pos(Val1, Val2) > 0);

   if not Res and (pos(ValeurGenerique, Valeur2) > 0) then
     begin
       Val1 := Valeur1;
       Val2 := ExtractStringBefore(Valeur2,ValeurGenerique);
       res  := (Pos(Val2, Val1) > 0);
     end;

   if not Res and (pos(ValeurGenerique, Valeur1) > 0) then
     begin
       Val1 := ExtractStringBefore(Valeur1,ValeurGenerique);
       Val2 := Valeur2;
       res  := (Pos(Val1, Val2) > 0);
     end;

    Result := Res;
  end;

Procedure DecodeBlessure(Calcul: String);
  var
    Indice:    Integer;
    NbElem:    Integer;
    ChCalc:    string;
    Multi:     Integer;
  begin
    // Blessure
    NbElem      := CountOccurrences(Calcul, '+') + 1;
    SelectWinF  := 0;
    SelectWinE  := 0;
    SelectWinFM := 0;
    for Indice := 1 to NbElem do
      begin
        ChCalc := ExtractChaine('+', Calcul, Indice);

        if Pos('x', ChCalc) > 0 then
          begin
            Multi := StrToInt(ExtractStringBefore(ChCalc, 'x'));
            ChCalc:= ExtractStringAfter(ChCalc, 'x');
          end
        else
          begin
            Multi := 1;
          end;
        case ChCalc of
          ConstBonusCaracF: SelectWinF   := Multi;
          ConstBonusCaracE: SelectWinE   := Multi;
          ConstBonusCaracFM:SelectWinFM  := Multi;
        end;
      end;
  end;

Procedure DecoupeCodeValeur(Code: String);

  begin
       if pos(SeparateurLivre, Code) > 0 then
         begin
           LivreValeur := ExtractStringBefore(Code,SeparateurLivre);
           CodeValeur  := ExtractStringAfter(Code,SeparateurLivre);
         end
       else
         begin
           CodeValeur  := Code;
           LivreValeur := '';
         end;
  end;

Procedure DecoupeCodeRecherche(Code: String);

  begin
       if pos(SeparateurLivre, Code) > 0 then
         begin
           LivreRecherche := ExtractStringBefore(Code,SeparateurLivre);
           CodeRecherche  := ExtractStringAfter(Code,SeparateurLivre);
         end
       else
         begin
           CodeRecherche  := Code;
           LivreRecherche := '';
         end;
  end;


// Renvoie le code prive de son prefixe de livre, SANS toucher aux variables globales
// LivreValeur / CodeValeur / LivreRecherche / CodeRecherche que posent les DecoupeCode*.
// Sert aux comparaisons partielles (radical d'un talent a specialisation, par exemple),
// qui lisaient jusqu'ici l'etat laisse par le dernier appel a CompareRechercheValeur :
// un etat partage qui ne survit pas au durcissement de VerifieRecherche. CONTEXT.md 2.49.
Function CodeSansLivre(Code: String): String;
  begin
    if pos(SeparateurLivre, Code) > 0 then
      Result := ExtractStringAfter(Code, SeparateurLivre)
    else
      Result := Code;
  end;

Function CompareRechercheValeur(ValRecherche:String; ValTrouve:String):boolean;
var
  Trouve: Boolean = false;
begin
  DecoupeCodeRecherche(ValRecherche);
  DecoupeCodeValeur(ValTrouve);
  Trouve := VerifieRecherche();

  result := Trouve;
end;

end.

