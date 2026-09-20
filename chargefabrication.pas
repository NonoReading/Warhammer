unit ChargeFabrication;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, ChargeConstantes, ChargeTexte, UnitCalcul, Generics.Collections, ChargeModificateur;

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
    Applique:           String;   // Weapon, Armour, Misc (virgules) ; vide = tous les objets
end;

  TListFabrication = specialize TList<StructureFabrication>;

Var
  ListFabrication:      TListFabrication;
  NbFabrication:        Integer;
  // Moteur generique (ChargeModificateur) cote fabrication : une qualite de fabrication (rune
  // naine, accessoire...) declare <ModifArmour name="...">n</ModifArmour> ; CodeSource = code
  // complet de la fabrication. Multiplie par son niveau ("CODE 2") au calcul.
  ListFabricationModificateur: TListModificateur;
  NbFabricationModificateur:   Integer;

function ChercheFabrication(CodeFabrication :String): StructureFabrication;
function TexteFabrication(PFabrication: StructureFabrication):String;
Function FabricationEncombrement(ListeCode :String; Var Quality: String): Integer;
// Somme, sur les qualites d'UN objet ("CODE niveau,..."), des modificateurs (TypeModif, Cible) de
// fabrication multiplies par le niveau. Rune of Cleaving (ModifyDamage CC). 20/09/2026.
Function FabricationModificateurQualite(ListeCode, TypeModif, Cible: String): Integer;
// Effets CONDITIONNELS (attribut if= du XML, stocke dans Filtre) des qualites d'UN objet, pour la
// cible CC ou CT : "Rune of Might : +3 DR contre une cible de taille superieure / Grudge Rune :
// +10% +1 DR contre ...". Chaine vide si aucun. Jamais ajoutes aux totaux. 20/09/2026.
Function FabricationEffetsConditionnels(ListeCode, Cible: String): String;
Function FabricationEstBulky(ListeCode :String): Boolean;
Function FabricationEstPractical(ListeCode :String): Boolean;
Function FabricationEstUnreliable(ListeCode :String): Boolean;
Function FabricationPortee(ListeCode :String): Integer;
Function FabricationQualitesArme(ListeCode :String): String;
procedure FabricationDetail(ListeCode :String; var BonusItem :String; var ListeBonus :String);
function QualiteDepuisCode(var CodeEquipement: String): String;
function QualiteSansMarqueur(ListeCode: String): String;

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

// Un code d equipement de metier peut porter le suffixe (Q) : on le retire du code et on renvoie la
// valeur de QualiteEquipement a poser sur l objet (le marqueur "qualite a ajouter"), '' sinon.
// Le marqueur disparait a l enregistrement du XML des qu une vraie fabrication est ajoutee.
function QualiteDepuisCode(var CodeEquipement: String): String;
  begin
    Result := '';
    if Pos(EquipementQualite, CodeEquipement) > 0 then
      begin
        CodeEquipement := Trim(StringReplace(CodeEquipement, EquipementQualite, '', [rfReplaceAll]));
        Result         := CodeQualiteAAjouter + ' 1';
      end;
  end;

// Retire le marqueur "qualite a ajouter" d'une liste de fabrications des qu'elle en contient une autre
// ("CODE VAL,CODE VAL"). Seule, elle reste : l'objet est encore a qualifier.
function QualiteSansMarqueur(ListeCode: String): String;
  var
    Morceaux: TStringList;
    Ind:      Integer;
  begin
    Result := ListeCode;
    if Pos(CodeQualiteAAjouter, ListeCode) = 0 then
      exit;
    Morceaux := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(ListeCode), Morceaux);
      if Morceaux.Count < 2 then
        exit;
      Result := '';
      for Ind := 0 to Morceaux.Count - 1 do
        if Pos(CodeQualiteAAjouter, Morceaux[Ind]) = 0 then
          begin
            if Result <> '' then
              Result := Result + ',';
            Result := Result + Trim(Morceaux[Ind]);
          end;
    finally
      Morceaux.Free;
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

Function FabricationModificateurQualite(ListeCode, TypeModif, Cible: String): Integer;
  var
    Liste:          TStringList;
    Element, Code:  String;
    Niveau:         Integer;
    Ind, IndModif:  Integer;
  begin
    Result := 0;
    if ListeCode = '' then Exit;
    Liste := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(ListeCode), Liste);
      for Ind := 0 to Liste.Count - 1 do
        begin
          Element := Trim(Liste[Ind]);
          Code    := Element;
          Niveau  := 1;
          if Pos(' ', Element) > 0 then
            begin
              Code   := Trim(ExtractStringBefore(Element, ' '));
              Niveau := StrToIntDef(Trim(Copy(Element, Pos(' ', Element) + 1, Length(Element))), 1);
            end;
          for IndModif := 0 to ListFabricationModificateur.Count - 1 do
            if (ListFabricationModificateur[IndModif].TypeModif = TypeModif)
               and (ListFabricationModificateur[IndModif].Filtre = '')
               and CompareRechercheValeur(ListFabricationModificateur[IndModif].CodeSource, Code)
               and CompareRechercheValeur(ListFabricationModificateur[IndModif].Cible, Cible) then
              Result := Result + ListFabricationModificateur[IndModif].Facteur * Niveau;
        end;
    finally
      Liste.Free;
    end;
  end;

Function FabricationEffetsConditionnels(ListeCode, Cible: String): String;
  var
    Liste:            TStringList;
    Element, Code:    String;
    Niveau, Degat:    Integer;
    Pourcent:         Integer;
    Condition:        String;
    Ind, IndModif:    Integer;
    Ligne:            String;
  begin
    Result := '';
    if ListeCode = '' then Exit;
    Liste := TStringList.Create;
    try
      ExtractStrings([','], [], PChar(ListeCode), Liste);
      for Ind := 0 to Liste.Count - 1 do
        begin
          Element := Trim(Liste[Ind]);
          Code    := Element;
          Niveau  := 1;
          if Pos(' ', Element) > 0 then
            begin
              Code   := Trim(ExtractStringBefore(Element, ' '));
              Niveau := StrToIntDef(Trim(Copy(Element, Pos(' ', Element) + 1, Length(Element))), 1);
            end;
          Degat     := 0;
          Pourcent  := 0;
          Condition := '';
          for IndModif := 0 to ListFabricationModificateur.Count - 1 do
            if (ListFabricationModificateur[IndModif].Filtre <> '')
               and CompareRechercheValeur(ListFabricationModificateur[IndModif].CodeSource, Code)
               and CompareRechercheValeur(ListFabricationModificateur[IndModif].Cible, Cible) then
              begin
                Condition := ListFabricationModificateur[IndModif].Filtre;
                if ListFabricationModificateur[IndModif].TypeModif = ConstXmlModifieDegat then
                  Degat := Degat + ListFabricationModificateur[IndModif].Facteur * Niveau
                else if ListFabricationModificateur[IndModif].TypeModif = ConstXmlModifieCompetence then
                  Pourcent := Pourcent + ListFabricationModificateur[IndModif].Facteur * Niveau;
              end;
          if Condition <> '' then
            begin
              Ligne := ChercheFabrication(Code).Libelle;
              // Format('%+d') n'est pas gere par FPC : signe ajoute a la main.
              if Pourcent <> 0 then
                Ligne := Ligne + ' ' + IfThen(Pourcent > 0, '+', '') + IntToStr(Pourcent) + '%';
              if Degat <> 0 then
                Ligne := Ligne + ' ' + IfThen(Degat > 0, '+', '') + IntToStr(Degat) + ' DR';
              Ligne := Ligne + ' ' + GetAllTexteLibelle(Condition);
              if Result <> '' then
                Result := Result + ' ; ';
              Result := Result + Ligne;
            end;
        end;
    finally
      Liste.Free;
    end;
  end;

end.
