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

  TListSort = specialize TList<StructureSort>;

Var
  ListSort:     TListSort;
  NbSort:       Integer;

function ChercheSort(CodeSort :String): StructureSort;
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

