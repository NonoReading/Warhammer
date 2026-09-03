unit ChargeSort;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, UnitCalcul, Dialogs, Generics.Collections;

Type
  StructureSort       = Record
	CodeSort:	  string;
        ListeTalent:	  string;
        Libelle:	  string;
        Portee:	          string;
        Cible:	          string;
        Duree:	          string;
        Description:      string;
        Niveau:	          string;
        TypeSort:         String;
        Livre:            String;
end;

  // Bloc DATA_SPELL_TALENT, ajoute le 03/09/2026 : une ligne = "ce talent donne acces a
  // ce sort", portee par n'importe quel livre. Voir TalentsDuSort et CONTEXT.md 2.39.
  StructureSortTalent = Record
        CodeSort:         string;
        ListeTalent:      string;
        Livre:            String;
end;

  TListSort = specialize TList<StructureSort>;
  TListSortTalent = specialize TList<StructureSortTalent>;

Var
  ListSort:        TListSort;
  NbSort:          Integer;
  ListSortTalent:  TListSortTalent;
  NbSortTalent:    Integer;

function ChercheSort(CodeSort :String): StructureSort;
function TalentsDuSort(const PSort: StructureSort): String;
Function CheminSortImage(CodeTalent: String): String;

implementation


function ChercheSort(CodeSort :String): StructureSort;
  var
    PSort:        StructureSort;
  Begin
  // Sans cette ligne, Result garde le contenu du PRECEDENT appel quand rien n'est trouve
  // (une fonction Pascal renvoyant un record ne l'initialise pas). Symptomes vus le
  // 22/08/2026 : un libelle de talent recopie d'une ligne a l'autre, une competence
  // affichee deux fois. CONTEXT.md 2.17.
    Result := Default(StructureSort);
    For PSort in ListSort do
      if CompareRechercheValeur(PSort.CodeSort, CodeSort) then
         Begin
           Result := PSort;
           break;
         end;
  end;

function TalentsDuSort(const PSort: StructureSort): String;
  // SEUL point de lecture de la relation "ce talent donne acces a ce sort". Elle a deux
  // sources depuis le 03/09/2026 : le champ <Talent> du sort, et le bloc DATA_SPELL_TALENT
  // qu'un livre quelconque peut porter. Le second est purement ADDITIF, il n'efface jamais
  // le premier.
  // Motif : les benedictions RULES-BENED_* du Rulebook sont accordees par des dieux
  // introduits par d'AUTRES livres (les six dieux de Nations of Mankind). Ecrire la
  // relation dans le sort obligeait un livre a modifier le fichier d'un autre, et
  // ChercheSort ne fusionne pas deux entrees de meme code : il prend la premiere et sort.
  // CONTEXT.md 2.39.
  var
    PSortTalent:  StructureSortTalent;
    Liste:        TStringList;
    Ligne:        TStringList;
    Code:         String;
  Begin
    Liste := TStringList.Create;
    Ligne := TStringList.Create;
    try
      ExtractStrings([',', ' '], [], PChar(PSort.ListeTalent), Liste);
      For PSortTalent in ListSortTalent do
        if CompareRechercheValeur(PSortTalent.CodeSort, PSort.CodeSort) then
          Begin
            Ligne.Clear;
            ExtractStrings([',', ' '], [], PChar(PSortTalent.ListeTalent), Ligne);
            For Code in Ligne do
              if Liste.IndexOf(Code) < 0 then
                Liste.Add(Code);
          end;
      Result := '';
      For Code in Liste do
        Begin
          if Result <> '' then
            Result := Result + ',';
          Result := Result + Code;
        end;
    finally
      Ligne.Free;
      Liste.Free;
    end;
  end;

Function CheminSortImage(CodeTalent: String): String;
  var
    Res:     String;
    Cod:     String;
    Dossier: String;
  begin
    if pos(ValeurGenerique, CodeTalent) = 0 then
      Cod := CodeTalent
    else
      Cod := ExtractStringBefore(CodeTalent,'_');
    // Code COMPLET, prefixe de livre inclus : voir CheminMetierImage dans ChargeMetier.
    //
    // LA BOUCLE SUR ListBook A DISPARU, et elle ne servait deja plus a rien : elle etait
    // ecrite pour un chemin par livre, '\DATABASE\BOOKS\%BOOK%\PICTURE\SPELL\', mais
    // warhammersource l.829-831 ecrase ces constantes au demarrage par des chemins PLATS,
    // sans %BOOK%. Le StringReplace ne remplacait donc rien et la boucle refaisait N fois
    // exactement le meme test, N etant le nombre de livres charges.
    Dossier := GetCurrentDir+ConstCheminImageSort;
    Res     := Dossier+Cod+'.PNG';
    Result := res;
  end;

end.

