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
        // Trait de creature (Rulebook p.338-341) : un talent qu'on ne peut pas CHOISIR.
        // Il arrive uniquement par la race (SUBCHAPTER_TALENT), jamais par un niveau de
        // metier. Le livre lui-meme fait ce pont : "Night Vision - The creature has the
        // Night Vision Talent". Voir CONTEXT.md 2.15.
        Trait:                Boolean;
        // Acces aux sorts (voir ConstXmlMagie dans chargeconstantes.pas). Renseignes sur les
        // entrees GENERIQUES (T0012_*, T0080_*, T0088_*, T0089) ; ChercheTalent les reporte
        // sur les specialisations, comme il le fait deja pour Resume.
        Magie:                Integer;
        ModeSort:             String;
        // Tarif des sorts ouverts par ce talent - voir ConstXmlXpMultiplicateur dans
        // chargeconstantes.pas pour la formule et le sens de chaque champ. Herites de
        // l'entree generique par ChercheTalent, comme Magie et ModeSort juste au-dessus.
        XpMultiplicateur:     Integer;
        XpPlancher:           Integer;
        XpDiviseur:           String;
        XpOfferts:            String;
        XpGroupe:             String;
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
function CodeTalentGenerique(CodeTalent :String): String;

implementation

function ChercheTalent(CodeTalent :String): StructureTalent;
var
  PTalent:        StructureTalent;
  code:           String;
Begin
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
  Result := Default(StructureTalent);
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
          // L'acces aux sorts est declare sur l'entree generique (T0012_*, T0080_*, T0088_*) :
          // une specialisation comme T0012_SIGMAR n'a qu'une Description, elle herite donc du
          // reste. Meme principe que Resume juste au-dessus. CONTEXT.md 2.18.
          if Result.Magie = 0 then
            Result.Magie    := PTalent.Magie;
          if Result.ModeSort = '' then
            Result.ModeSort := PTalent.ModeSort;
          // Le tarif suit le meme chemin : il est declare une fois sur la generique, et
          // toutes ses specialisations en heritent. Le multiplicateur sert de temoin -
          // une specialisation ne le renseigne jamais, donc 0 veut dire "pas declare ici"
          // et non "gratuit". Les cinq champs se reprennent ENSEMBLE : les melanger entre
          // deux entrees donnerait un tarif qui n'existe nulle part.
          if Result.XpMultiplicateur = 0 then
            begin
              Result.XpMultiplicateur := PTalent.XpMultiplicateur;
              Result.XpPlancher       := PTalent.XpPlancher;
              Result.XpDiviseur       := PTalent.XpDiviseur;
              Result.XpOfferts        := PTalent.XpOfferts;
              Result.XpGroupe         := PTalent.XpGroupe;
            end;
        end;
end;

function ListeTalent(CodeTalent :String): TStringList;
  var
    Liste:      TStringList;
    Branches:   TStringList;
    SousListe:  TStringList;
    Ind:        Integer;
    PTalent:    StructureTalent;
    Deb:        String;
  begin
    Liste := TStringList.Create;
    if Pos(SeparateurMulti, CodeTalent) > 0 then
      // choix entre plusieurs options : on aplatit chaque branche
      begin
        Branches                 := TStringList.Create;
        Branches.StrictDelimiter := True;
        Branches.Delimiter       := SeparateurMulti;
        Branches.DelimitedText   := CodeTalent;
        for Ind := 0 to Branches.Count - 1 do
          if Pos(ValeurGenerique, Branches[Ind]) > 0 then
            begin
              SousListe := ListeTalent(Branches[Ind]);
              Liste.AddStrings(SousListe);
              SousListe.Free;
            end
          else
            Liste.Add(Branches[Ind]);
        Branches.Free;
      end
    else if Pos(ValeurGenerique, CodeTalent) > 0 then
      begin
        // talent avec des spécialités
        Deb := Copy(CodeTalent, 1, Pos(ValeurGenerique, CodeTalent));
        For PTalent in ListTalent do
          if (pos(Deb, PTalent.CodeTalent) = 1) and (pos(SeparateurMulti, PTalent.codeTalent) < 1) and (PTalent.CodeTalent <> CodeTalent) then
            Liste.Add(PTalent.CodeTalent);
      end;
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

// Entree GENERIQUE dont ce talent depend : RULES-T0012_SIGMAR -> RULES-T0012_*. Un code qui
// n'est pas une specialisation se renvoie lui-meme (RULES-T0089, HELFG-T0190).
//
// La decoupe est ECRITE EXACTEMENT COMME DANS ChercheTalent ci-dessus, et ce n'est pas un
// hasard : les deux doivent designer la meme entree, sinon un talent heriterait d'un tarif
// et serait compte dans un autre groupe.
//
// Sert a identifier le GROUPE DE COMPTAGE des sorts : deux sorts dont les talents remontent
// a la meme generique se comptent ensemble. C'est ce qui fait que l'arcanique et le domaine
// partagent leur compteur sans qu'aucune donnee ne le declare - ils citent le meme talent.
function CodeTalentGenerique(CodeTalent :String): String;
Begin
  Result := CodeTalent;
  if Pos(ValeurGenerique, CodeTalent) > 0 then
    Exit;
  if Pos(ValeurSousCompetence, CodeTalent) > 0 then
    Result := ExtractStringBefore(CodeTalent, ValeurSousCompetence) + ValeurGenerique;
end;

end.

