unit ChargeOptionRegle;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections;

Type
  // Regle optionnelle d'un livre, activable/desactivable via le toggle .INI
  // (A FAIRE.txt "TOGGLE .INI PAR LIVRE", CONTEXT.md 2.89, 22/09/2026).
  StructureOptionRegle = record
    CodeId:      String; // id XML (ex. RULES-OPTR_01), cle de traduction
    CodeOption:  String; // code de bascule (ex. QUICKARMOUR), compare a ListeOptionDesactiveeParLivre
    Libelle:     String;
    Explication: String;
    Livre:       String;
  end;

  TListOptionRegle = specialize TList<StructureOptionRegle>;

Var
  ListOptionRegle: TListOptionRegle;
  NbOptionRegle:   Integer;

Function IndexOptionRegle(Livre, CodeId: String): Integer;

implementation

// Retrouve une entree deja chargee (ex. par la passe anglaise) pour y poser la
// traduction de la passe francaise par-dessus, au lieu d'en creer une seconde -
// CONTEXT.md 2.89, 22/09/2026.
Function IndexOptionRegle(Livre, CodeId: String): Integer;
  Var
    Ind: Integer;
  begin
    Result := -1;
    for Ind := 0 to ListOptionRegle.Count - 1 do
      if (ListOptionRegle[Ind].Livre = Livre) and (ListOptionRegle[Ind].CodeId = CodeId) then
        begin
          Result := Ind;
          break;
        end;
  end;

end.
