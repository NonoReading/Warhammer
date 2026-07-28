unit ChargeTalent;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Generics.Collections;

Type
  StructureTalent             = Record
	CodeTalent:	      string;
	Libelle:	      string;
	Tests:	              string;
	Description:          string;
	Attribut:	      string;
	MaxiTalent:	      string;
	SousTalent:	      boolean;
        Livre:                String;
        TalentPdf:            String;
        Resume:               String;
        CompAjoutee:          String;
        ModifyCarac:          String;
end;

  TListTalent = Specialize TList<StructureTalent>;

Var
  ListTalent:     TListTalent;
  NbTalent:       Integer;
  NbTalentUnique: Integer;
  TestTal:        string;
  DescTal:        string;
  AttTal:         string;
  MaxTal:         string;
  CompPdfTal:     String;
  CourtTal:       String;
  CompAjoute:     String;

function ChercheTalent(CodeTalent :String): StructureTalent;
function ListeTalent(CodeTalent :String): TStringList;
function LibelleTalent(CodeTalent :String): String;

implementation

function ChercheTalent(CodeTalent :String): StructureTalent;
var
  PTalent:        StructureTalent;
  code:           String;
Begin
  For PTalent in ListTalent do
    if CompareRechercheValeur(PTalent.CodeTalent, CodeTalent) then
      begin
       Result := PTalent;
       break;
      end;
  if PTalent.Resume = '' then
    if Pos(ValeurGenerique, CodeTalent) = 0 then
      if Pos(ValeurSousCompetence, CodeTalent) > 0 then
        begin
          code          := ExtractStringBefore(CodeTalent, ValeurSousCompetence) + ValeurGenerique;
          PTalent       := ChercheTalent(Code);
          Result.Resume := PTalent.Resume;
        end;
end;

function ListeTalent(CodeTalent :String): TStringList;
  var
    Liste:             TStringList;
    Code1:             String;
    Code2:             String;
    PTalent:           StructureTalent;
    Deb:               String;
  begin
    Liste := TStringList.Create;
    if Pos(SeparateurMulti,CodeTalent) > 0 then
      // compétence à choisir entre deux options
      begin
        code1 := ExtractStringBefore(CodeTalent, SeparateurMulti);
        Liste.Add(code1);
        code2 := ExtractStringAfter(CodeTalent, SeparateurMulti);
        Liste.Add(code2);
      end
    else if Pos(ValeurGenerique,CodeTalent) > 0 then
      begin
        // compétence avec des spécialités
        Deb   := Copy(CodeTalent,1,Pos(ValeurGenerique, CodeTalent));
        For PTalent in ListTalent do
          if (pos(Deb, PTalent.CodeTalent) = 1) and (pos(SeparateurMulti, PTalent.codeTalent) < 1) and (PTalent.CodeTalent <> CodeTalent) then
            Liste.Add(PTalent.CodeTalent);
        end
    else
      // compétence normale
      Liste.Add(CodeTalent);

    // Renvoyer la liste
    Result := Liste;
  end;

function LibelleTalent(CodeTalent :String): String;
  var
    PTalent:        StructureTalent;
    strings:        TStringList;
    Libelles:       String = '';
    Ind:            Integer;
  begin
    strings            := TStringList.Create;
    ExtractStrings([SeparateurMulti], [], PChar(CodeTalent), Strings);
    For Ind := 0 to Strings.Count - 1 do
      begin
        PTalent    := ChercheTalent(Strings[Ind]);
        if Libelles <> '' then
          Libelles := Libelles + SeparateurMulti;
        Libelles   := Libelles + PTalent.Libelle;
      end;
    strings.Free;

    Result := Libelles;
  end;

end.

