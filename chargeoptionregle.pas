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

implementation

end.
