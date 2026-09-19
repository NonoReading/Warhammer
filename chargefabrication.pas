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
    PorteeBonus:        Integer;  // accessoire d arme : ajoute a la portee
    QualitesArme:       String;   // accessoire d arme : codes de qualites d arme ajoutees (virgules)
end;

  TListFabrication = specialize TList<StructureFabrication>;

Var
  ListFabrication:      TListFabrication;
  NbFabrication:        Integer;

function ChercheFabrication(CodeFabrication :String): StructureFabrication;
function TexteFabrication(PFabrication: StructureFabrication):String;
Function FabricationEncombrement(ListeCode :String; Var Quality: String): Integer;
Function FabricationEstBulky(ListeCode :String): Boolean;
Function FabricationEstPractical(ListeCode :String): Boolean;
Function FabricationEstUnreliable(ListeCode :String): Boolean;
Function FabricationPortee(ListeCode :String): Integer;
Function FabricationQualitesArme(ListeCode :String): String;
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
    Texte := GetTexteLibelle('RULES-LAB_118') + ' : ';
    if PFabrication.TypeQualite <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_018') + ' : ' + PFabrication.TypeQualite;
    if PFabrication.Description <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_003') + ' : ' + PFabrication.Description;
    if PFabrication.Encombrement <> 0 then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_055') + ' : ' + IntToStr(PFabrication.Encombrement);
    if PFabrication.Maximum <> '' then
      Texte  := Texte + SeparateurRetourLigne + SeparateurRetourLigne + GetTexteLibelle('RULES-LAB_111') + ' : ' + PFabrication.Maximum;
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
                // Le libelle (Q+)/(Q-) ne doit reagir qu'aux qualites qui pesent
                // reellement sur l'Encombrement - une qualite purement descriptive
                // (Fine, Practical...), Encombrement=0, affichait (Q-) a tort avant ce
                // garde-fou (TypeQualite vide comptait comme malus dans la boucle 'else').
                if PFabrication.Encombrement <> 0 then Inc(BTot);
              end
            else
              begin
                tot := tot + (PFabrication.Encombrement * (1) );
                if PFabrication.Encombrement <> 0 then Dec(BTot);
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

Function FabricationEstBulky(ListeCode :String): Boolean;
  var
    Code:         String;
    PFabrication: StructureFabrication;
    strings:      TStringList;
    IndTab:       Integer;
  begin
    Result := False;
    if not InList(ListeCode,',0') then
      begin
        strings            := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          Begin
            Code := ExtractStringBefore(Strings[IndTab],' ');
            PFabrication := ChercheFabrication(Code);
            if PFabrication.TypeQualite = FabricationBulky then
              Result := True;
          end;
        strings.Free;
      end;
  end;

Function FabricationEstPractical(ListeCode :String): Boolean;
  var
    Code:         String;
    PFabrication: StructureFabrication;
    strings:      TStringList;
    IndTab:       Integer;
  begin
    Result := False;
    if not InList(ListeCode,',0') then
      begin
        strings            := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          Begin
            Code := ExtractStringBefore(Strings[IndTab],' ');
            PFabrication := ChercheFabrication(Code);
            if PFabrication.TypeQualite = FabricationPractical then
              Result := True;
          end;
        strings.Free;
      end;
  end;

Function FabricationEstUnreliable(ListeCode :String): Boolean;
  var
    Code:         String;
    PFabrication: StructureFabrication;
    strings:      TStringList;
    IndTab:       Integer;
  begin
    Result := False;
    if not InList(ListeCode,',0') then
      begin
        strings            := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          Begin
            Code := ExtractStringBefore(Strings[IndTab],' ');
            PFabrication := ChercheFabrication(Code);
            if PFabrication.TypeQualite = FabricationUnreliable then
              Result := True;
          end;
        strings.Free;
      end;
  end;

Function FabricationPortee(ListeCode :String): Integer;
  var
    strings: TStringList;
    IndTab:  Integer;
  begin
    Result := 0;
    if not InList(ListeCode,',0') then
      begin
        strings := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          Result := Result + ChercheFabrication(ExtractStringBefore(Strings[IndTab],' ')).PorteeBonus;
        strings.Free;
      end;
  end;

Function FabricationQualitesArme(ListeCode :String): String;
  var
    strings: TStringList;
    IndTab:  Integer;
    Ajout:   String;
  begin
    Result := '';
    if not InList(ListeCode,',0') then
      begin
        strings := TStringList.Create;
        ExtractStrings([','], [], PChar(ListeCode), Strings);
        for IndTab := 0 to Strings.Count -1 do
          begin
            Ajout := ChercheFabrication(ExtractStringBefore(Strings[IndTab],' ')).QualitesArme;
            if Ajout <> '' then
              begin
                if Result <> '' then Result := Result + ',';
                Result := Result + Ajout;
              end;
          end;
        strings.Free;
      end;
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


