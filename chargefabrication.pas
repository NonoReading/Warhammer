unit ChargeFabrication;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, ChargeTexte, UnitCalcul, Generics.Collections;

Type
  StructureFabrication     = record
    CodeFabrication:	String;
    Libelle:            String;
    Description:	String;
    TypeQualite:        String;
    Encombrement:       Integer;
    Maximum:            String;
    Resume:             String;
    Livre:              String;
end;

  TListFabrication = specialize TList<StructureFabrication>;

Var
  ListFabrication:      TListFabrication;
  NbFabrication:        Integer;

function ChercheFabrication(CodeFabrication :String): StructureFabrication;
function TexteFabrication(PFabrication: StructureFabrication):String;
Function FabricationEncombrement(ListeCode :String; Var Quality: String): Integer;
procedure FabricationDetail(ListeCode :String; var BonusItem :String; var ListeBonus :String);

implementation

function ChercheFabrication(CodeFabrication :String): StructureFabrication;
var
  PFabrication: StructureFabrication;
Begin
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureFabrication);
  for PFabrication in ListFabrication do
    if CompareRechercheValeur(PFabrication.CodeFabrication, CodeFabrication) then
       Begin
         Result := PFabrication;
         break;
       end;
end;

function TexteFabrication(PFabrication: StructureFabrication):String;
  Var
    Texte:         String;
  begin
    Texte           := '';
    Texte := GetTexteLibelle('LAB_118') + ' : ';
    if PFabrication.TypeQualite <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_018') + ' : ' + PFabrication.TypeQualite;
    if PFabrication.Description <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_003') + ' : ' + PFabrication.Description;
    if PFabrication.Encombrement <> 0 then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_055') + ' : ' + IntToStr(PFabrication.Encombrement);
    if PFabrication.Maximum <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('LAB_111') + ' : ' + PFabrication.Maximum;
    Result   := Texte;
  end;

Function FabricationEncombrement(ListeCode :String; Var Quality: String): Integer;
  var
    Code:         String;
    PFabrication: StructureFabrication;
    strings:      TStringList;
    IndTab:       Integer;
    Tot:          Integer = 0;
    BTot:         Integer = 0;
  begin
    if not InList(ListeCode,',0') then
      begin
        strings            := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          Begin
            Code := ExtractStringBefore(Strings[IndTab],' ');
            PFabrication := ChercheFabrication(Code);
            if PFabrication.TypeQualite = FabricationBonus then
              begin
                tot := tot + (PFabrication.Encombrement * (-1) );
                Inc(BTot)
              end
            else
              begin
                tot := tot + (PFabrication.Encombrement * (1) );
                Dec(BTot);
              end;
          end;
        strings.Free;
      end;
    if Btot > 0 then
      Quality := '(Q+)'
    else if BTot < 0 then
      Quality := '(Q-)'
    else
      Quality := '';
    Result := Tot;
  end;

procedure FabricationDetail(ListeCode :String; var BonusItem :String; var ListeBonus :String);
  var
    Code:         String;
    Val:          String;
    PFabrication: StructureFabrication;
    strings:      TStringList;
    IndTab:       Integer;
  begin
    if not InList(ListeCode,',0') then
      begin
        strings            := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          Begin
            Code := ExtractStringBefore(Strings[IndTab],' ');
            Val  := ExtractStringAfter(Strings[IndTab],' ');
            PFabrication := ChercheFabrication(Code);
            if BonusItem = '-' then BonusItem := '';
            if BonusItem <> '' then BonusItem := BonusItem + ',';
            BonusItem := BonusItem + PFabrication.Libelle;
            if PFabrication.Maximum <> '1' then BonusItem := BonusItem + '('+Val+')';
            if Pos(code, ListeBonus) = 0 then
              begin
                If ListeBonus <> '' then ListeBonus := ListeBonus + ',';
                ListeBonus := ListeBonus + Code;
              end;
          end;
        strings.Free;
      end;
  end;

end.


