unit ChargeTexte;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, Unitcalcul, LazUTF8, ChargeLivre;

Type
  StructureTexte   = record
    Code:       string;
    Libelle:    string;
    Livre:      string;
  end;


  TListTexte = Specialize TList<StructureTexte>;

Var
  ListTexte:  TListTexte;
  NbTexte:     Integer;

function ChercheTexte(CodeTexte :String): StructureTexte;
Function GetTexteLibelle(CodeTexte :String; Lib: String = ''; Sep: String = ''; Livre: boolean = false): String;
Function GetAllTexteLibelle(CodeTexte :String): String;
Function ReplaceTexteLibelle(CodeTexte :String): String;
Function TraduirePrix(Prix: String): String;

implementation


Function ChercheTexte(CodeTexte :String): StructureTexte;
  var
    PTexte:   StructureTexte;
  Begin
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
    Result := Default(StructureTexte);
    For PTexte in ListTexte do
      if CompareRechercheValeur(PTexte.Code, CodeTexte) then
        begin
         Result := PTexte;
         break;
        end;
  end;

Function ReplaceTexteLibelle(CodeTexte :String): String;
  var
    PTexte:  StructureTexte;
    Res:     String;
    Code:    String;
  Begin
    Res := CodeTexte;
    for PTexte in ListTexte do
      begin
        if Pos(PTexte.Code, Res) > 0 then
          Res := StringReplace(Res, PTexte.Code, PTexte.Libelle, [rfReplaceAll]);
        Code := ExtractStringAfter(PTexte.Code, SeparateurLivre);
        if Pos(Code, Res) > 0 then
          Res := StringReplace(Res, Code, PTexte.Libelle, [rfReplaceAll]);
      end;

    Result := Res;
  end;

Function GetAllTexteLibelle(CodeTexte :String): String;
  Var
    strings:   TStringList;
    Ind:       Integer;
    Res:       String = '';
  begin
    strings    := TStringList.Create;
    ExtractStrings([','], [], PChar(CodeTexte), Strings);
    For Ind := 0 to Strings.Count -1 do
      begin
        if Res <> '' then Res := Res + ',';
        Res := Res + GetTexteLibelle(Strings[Ind], Strings[ind]);
      end;
    strings.Free;

    Result := Res;
  end;

Function GetTexteLibelle(CodeTexte :String; Lib: String = ''; Sep: String = ''; Livre: boolean = false): String;
  var
    PTexte:   StructureTexte;
    PLivre:   StructureLivre;
    Res:      String;
    EndTexte: String;
    strings:  TStringList;
    Ind:      Integer;
  Begin
    Res := Lib;
    if Sep <> '' then
      begin
        EndTexte  := ExtractStringAfter(CodeTexte, Sep);
        CodeTexte := ExtractStringBefore(CodeTexte, Sep);
      end;
    For PTexte in ListTexte do
      if CompareRechercheValeur(PTexte.Code, CodeTexte) then
        begin
         Res := PTexte.Libelle;
         break;
        end;
    if Res = '' then
      begin
        if Livre = false then
          Res := CodeTexte
        else
          begin
            res := '';
            strings     := TStringList.Create;
            ExtractStrings([' '], [], PChar(CodeTexte), Strings);
            for Ind := 0 to Strings.Count -1 do
              begin
                if res <> '' then
                  res := res + ' ';
                res := res + AnsiUpperCase(copy(strings[ind],1,1)) + ansilowercase(copy(strings[ind],2,length(strings[ind])));
              end;
            strings.Free;
          end;
      end;

    // Un livre NON OFFICIEL (livre de fan, <OFFICIAL> = 2) est signalé par "(F)" devant son nom,
    // pour que ça se voie sans avoir à regarder la colonne O/F (décision Nono du 21/08/2026).
    //
    // Avant, ce "(F)" était produit par le repli ci-dessus, donc par un libellé INTROUVABLE : la
    // coïncidence tenait tant que les seuls livres sans libellé étaient les deux livres de fan.
    // Elle ne tenait déjà plus - Lustria, officielle, s'affichait "(F) Book Lustria" faute de
    // libellé. La source de vérité est maintenant <OFFICIAL>, et le repli ne fait plus que
    // remettre en forme le code (BOOK GREEN IZ BEST -> Book Green Iz Best).
    //
    // Le "(F)" reprend volontairement ConstLivreFacultatif, la lettre déjà affichée dans la
    // colonne O/F du tableau des livres (warhammersource.pas) : une seule lettre à changer si
    // Nono veut un autre marqueur.
    //
    // Le test passe par RechercheTrouve : ChercheLivreLibelle n'affecte pas son Result quand elle
    // ne trouve rien, donc .Officiel vaudrait n'importe quoi (cas réel : le livre d'une armure
    // alors que ce livre n'est pas chargé).
    if Livre then
      begin
        PLivre := ChercheLivreLibelle(CodeTexte);
        if RechercheTrouve and (PLivre.Officiel = ConstLivreFanOfficiel) then
          Res := '(' + ConstLivreFacultatif + ') ' + Res;
      end;

    if Sep <> '' then
      res := Res + sep + EndTexte;
    if res = 'title' then
      res := 'Title';
    Result := Res;
  end;

// Prix stocke en codes de monnaie (ex. '4CO 5PA 3SB') -> texte dans la langue de l'interface.
// Un morceau qui n'a pas la forme <nombre><CO|PA|SB> (ex. 'Varies') est laisse tel quel.
Function TraduirePrix(Prix: String): String;
  var
    Morceaux: TStringList;
    Ind, Pos: Integer;
    Morceau, Unite, CodeLibelle, Libelle: String;
  Begin
    Result := '';
    Morceaux := TStringList.Create;
    try
      Morceaux.Delimiter       := ' ';
      Morceaux.StrictDelimiter := true;
      Morceaux.DelimitedText   := Prix;
      For Ind := 0 to Morceaux.Count - 1 do
        begin
          Morceau := Morceaux[Ind];
          Pos := Length(Morceau) - 1;
          Unite := Copy(Morceau, Pos, 2);
          if (Pos > 1) and (StrToIntDef(Copy(Morceau, 1, Pos - 1), -1) >= 0) then
            begin
              CodeLibelle := '';
              if Unite = 'CO' then CodeLibelle := 'RULES-LAB_222';
              if Unite = 'PA' then CodeLibelle := 'RULES-LAB_223';
              if Unite = 'SB' then CodeLibelle := 'RULES-LAB_224';
              if CodeLibelle <> '' then
                begin
                  Libelle := GetTexteLibelle(CodeLibelle);
                  if Libelle = CodeLibelle then
                    Libelle := Unite;
                  Morceau := Copy(Morceau, 1, Pos - 1) + ' ' + Libelle;
                end;
            end;
          if Result <> '' then
            Result := Result + ' ';
          Result := Result + Morceau;
        end;
    finally
      Morceaux.Free;
    end;
  end;

end.
