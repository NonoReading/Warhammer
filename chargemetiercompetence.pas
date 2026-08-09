unit ChargeMetierCompetence;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, ChargeCompetence,
  Generics.Collections;

Type
    StructureMetierCompetence	= Record
	CodeMetier:	String;
	NiveauMetier:	Integer;
	CodeCompetence:	String;
        Livre:          String;
End;

  TListMetierCompetence = Specialize TList<StructureMetierCompetence>;

Var
  ListMetierCompetence: TListMetierCompetence;
  NbMetierCompetence:   Integer;

function ChercheMetierCompetence(CodeMetier :String; CodeCompetence :String): StructureMetierCompetence;
function ChercheNiveauMetierCompetence(CodeMetier :String; CodeCompetence :String; NiveauMetier: String): String;
function ListeMetierCompetence(CodeCompetence :String): TStringList;

implementation

Function ChercheMetierCompetence(CodeMetier :String; CodeCompetence :String): StructureMetierCompetence;
Var
  PMetierCompetence: StructureMetierCompetence;
  CodeComp:          String;
  PVide:             StructureMetierCompetence;
  Trouve:            Boolean=false;
Begin
  if Pos(ValeurSousCompetence, CodeCompetence) > 0 then
    CodeComp := ExtractStringBefore(CodeCompetence, ValeurSousCompetence)+ValeurGenerique
  else
    CodeComp := CodeCompetence;

  for PMetierCompetence in ListMetierCompetence do
    if CompareRechercheValeur(PMetierCompetence.CodeMetier, CodeMetier) then
      begin
        if InList(PMetierCompetence.CodeCompetence,CodeCompetence+','+CodeComp) then
          begin
           Trouve := true;
           Result := PMetierCompetence;
           break;
          end;
        if (Pos(CodeCompetence,PMetierCompetence.CodeCompetence) > 0) or (Pos(CodeComp,PMetierCompetence.CodeCompetence) > 0) then
          begin
           Trouve := true;
           Result := PMetierCompetence;
           break;
          end;
      end;

  if not trouve then
    begin
     PVide.CodeMetier:= '';
     Result := PVide;
    end;
end;

Function ChercheNiveauMetierCompetence(CodeMetier :String; CodeCompetence :String; NiveauMetier :String): String;
Var
  PMetierCompetence: StructureMetierCompetence;
  Code:              String;
  PCompetence:       StructureCompetence;
  Deb:               String;
Begin
  Result := '';
  // test sur l'égalité pure
  For PMetierCompetence in ListMetierCompetence do
    if Pos(SeparateurMulti,PMetierCompetence.CodeCompetence) > 0 then
      begin
        code := ExtractStringBefore(PMetierCompetence.CodeCompetence, SeparateurMulti);
        if CompareRechercheValeur(PMetierCompetence.CodeMetier, CodeMetier) and (Code = CodeCompetence) then
          begin
            If (NiveauMetier = '') or (PMetierCompetence.NiveauMetier > StrToIntDef(NiveauMetier,0)) then
              Result := IntToStr(PMetierCompetence.NiveauMetier)
            else
              Result := NiveauMetier;
            break
          end;
        code := ExtractStringAfter(PMetierCompetence.CodeCompetence, SeparateurMulti);
        if CompareRechercheValeur(PMetierCompetence.CodeMetier, CodeMetier) and (Code = CodeCompetence) then
          begin
            If (NiveauMetier = '') or (PMetierCompetence.NiveauMetier > StrToIntDef(NiveauMetier,0)) then
              Result := IntToStr(PMetierCompetence.NiveauMetier)
            else
              Result := NiveauMetier;
            break
          end;
      end
    else if (PMetierCompetence.CodeMetier = CodeMetier) and (PMetierCompetence.CodeCompetence = CodeCompetence) then
      begin
        If (NiveauMetier = '') or (PMetierCompetence.NiveauMetier > StrToIntDef(NiveauMetier,0)) then
          Result := IntToStr(PMetierCompetence.NiveauMetier)
        else
          Result := NiveauMetier;
        break
      end;

  // vérifier les génériques
  if Result = '' then
    if Pos(ValeurGenerique,CodeCompetence) > 0 then
      for PMetierCompetence in ListMetierCompetence do
        begin
          Deb   := Copy(CodeCompetence,1,Pos(ValeurGenerique, PMetierCompetence.CodeCompetence)-1);
          for PCompetence in ListCompetence do
            if (pos(Deb, PCompetence.CodeCompetence) > 0) and (pos(SeparateurMulti, PCompetence.codeCompetence) < 1) and (PCompetence.CodeCompetence <> PMetierCompetence.CodeCompetence) then
              begin
                If NiveauMetier = '' then
                  Result := IntToStr(PMetierCompetence.NiveauMetier)
                else
                  Result := NiveauMetier;
                break
              end
        end
end;

function ListeMetierCompetence(CodeCompetence :String): TStringList;
  var
    Liste:             TStringList;
    PCompetence:       StructureCompetence;
    Deb:               String;
    Branches:          TStringList;
    SousListe:         TStringList;
    Ind:               Integer;
  begin
    Liste := TStringList.Create;
    if Pos(SeparateurMulti,CodeCompetence) > 0 then
      // compétence à choisir entre plusieurs options
      begin
        Branches                 := TStringList.Create;
        Branches.StrictDelimiter := True;
        Branches.Delimiter       := SeparateurMulti;
        Branches.DelimitedText   := CodeCompetence;
        for Ind := 0 to Branches.Count - 1 do
          if Pos(ValeurGenerique, Branches[Ind]) > 0 then
            begin
              SousListe := ListeMetierCompetence(Branches[Ind]);
              Liste.AddStrings(SousListe);
              SousListe.Free;
            end
          else
            Liste.Add(Branches[Ind]);
        Branches.Free;
      end
    else if Pos(ValeurGenerique,CodeCompetence) > 0 then
      begin
        // compétence avec des spécialités
        Deb   := Copy(CodeCompetence,1,Pos(ValeurGenerique, CodeCompetence));
        For PCompetence in ListCompetence do
          if (pos(Deb, PCompetence.CodeCompetence) = 1) and (pos(SeparateurMulti, PCompetence.codeCompetence) < 1) and (PCompetence.CodeCompetence <> CodeCompetence) then
            Liste.Add(PCompetence.CodeCompetence);
      end
    else
      // compétence normale
      Liste.Add(CodeCompetence);

    // Renvoyer la liste
    Result := Liste;
  end;


end.

