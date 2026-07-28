unit ChargeTexte;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, Unitcalcul, LazUTF8;

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

implementation


Function ChercheTexte(CodeTexte :String): StructureTexte;
  var
    PTexte:   StructureTexte;
  Begin
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
            res := '(F)';
            strings     := TStringList.Create;
            ExtractStrings([' '], [], PChar(CodeTexte), Strings);
            for Ind := 0 to Strings.Count -1 do
              begin

                res := res + ' ' + AnsiUpperCase(copy(strings[ind],1,1)) + ansilowercase(copy(strings[ind],2,length(strings[ind])));
              end;
            strings.Free;
          end;
      end;
    if Sep <> '' then
      res := Res + sep + EndTexte;
    if res = 'title' then
      res := 'Title';
    Result := Res;
  end;

end.

