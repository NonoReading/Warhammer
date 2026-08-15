unit PdfPersonnage;

{$mode ObjFPC}{$H+}
{$ModeSwitch ArrayOperators}

interface

uses
  Classes, SysUtils, fpPDF, PdfUtils, ChargeRace, ChargeMetier, ChargeMetierNiveau,
  ChargeRaceAttribut, ChargeTalent, ChargeCompetence, ChargeArme, ChargeArmure,
  ChargeArmeBonus, ChargeArmureBonus, ChargeSort, ChargeAttribut, ChargeFabrication,
  ChargeConstantes, ChargeMetierAttribut, ChargeTexte, ChargeMetierTalent,
  ChargePersonnage, ChargeArmureSimplifie, ChargeAttributAugmentation,
  ChargeCompetenceAugmentation,
  Dialogs, UnitCalcul, Math, LCLIntf;

Type
  StructureDonnee  = record
    Base:	   Integer;
    Augmentation:  Integer;
    Total:	   Integer;
end;

  // Brique 2 (tableau de données, CONTEXT.md §2.4) — types génériques pour dessiner un
  // tableau à partir de données déjà préparées, sans que le dessin ait à connaître le sens
  // métier des champs.
  //
  // Orientation : orLigne = une entrée du tableau est une ligne, ses champs sont en colonnes
  // (cas des tableaux de Compétences). orColonne = une entrée est une colonne, ses champs
  // sont empilés en lignes (cas du tableau des Caractéristiques).
  TPdfOrientationTableau = (orLigne, orColonne);

  // Police utilisée pour dessiner une valeur : spValeur = police de valeur normale de la
  // colonne (Arial, taille Tableau.Police) sauf si la colonne est EnTete (alors police
  // d'en-tête, voir TPdfColonne) ; spEnTete force la police d'en-tête (Carlson gras 10)
  // même sur une colonne qui ne l'est pas par défaut ; spAccent force une police "accent"
  // (Arial gras 8), utilisée par ex. pour le nom d'une compétence liée au métier en cours.
  TPdfStylePolice = (spValeur, spEnTete, spAccent);

  // Une valeur affichée dans une case du tableau. Valeur = '' signifie "case vide, rien
  // n'est dessiné" (ex : le niveau métier n'existe pas pour cette caractéristique).
  // Annotation est un petit texte optionnel affiché à côté de la valeur, utilisé pour le
  // bonus racial/talent (Caractéristiques) ou l'astérisque de compétence (Compétences) —
  // DessinerTableau choisit automatiquement sa position et sa taille selon l'orientation du
  // tableau, la préparation des données n'a pas à connaître ces détails de dessin.
  TPdfValeurCase = record
    Champ:      String;
    Valeur:     String;
    Grise:      Boolean;
    Annotation: String;
    Style:      TPdfStylePolice;
  end;

  // Une entrée du tableau (une caractéristique, une compétence...). Valeurs simule un
  // "enregistrement SQL" : les champs sont retrouvés par leur nom (TPdfColonne.Champ), pas
  // par position, pour que la préparation des données et la définition du tableau restent
  // indépendantes l'une de l'autre.
  TPdfEnregistrement = record
    Valeurs: array of TPdfValeurCase;
  end;
  TPdfRecordSet = array of TPdfEnregistrement;

  // Alignement du texte d'en-tête d'une colonne (orLigne uniquement) : alCentre utilise
  // PdfCentre (texte centré, taille fixe), alGauche utilise PdfEcrit (texte cadré à gauche,
  // rétréci jusqu'à Tableau.PoliceMin si besoin) — cas de la colonne "Nom".
  TPdfAlignementEntete = (alCentre, alGauche);

  // Définit une ligne (orColonne) ou une colonne (orLigne) du tableau.
  //  - Libelle : texte affiché dans la bande de libellés (orColonne) ou en en-tête de
  //    colonne (orLigne).
  //  - Champ : nom du champ à aller chercher dans chaque TPdfEnregistrement.
  //  - EnTete : la valeur de cette ligne/colonne est dessinée avec la police d'en-tête
  //    (Carlson gras) plutôt que la police de valeur normale par défaut (cas de la ligne
  //    "Code" des Caractéristiques, et des colonnes Nom/Attribut des Compétences).
  // Les champs suivants ne concernent que l'orientation orLigne :
  //  - Largeur : largeur propre de cette colonne (0 = largeur par défaut Tableau.LargeurEntree) ;
  //    permet une colonne plus large que les autres (ex : le nom d'une compétence).
  //  - FusionAvecSuivante : si vrai, le libellé de cette colonne est centré sur sa largeur ET
  //    celle de la colonne suivante, et le séparateur entre les deux ne descend qu'à partir de
  //    la première ligne de données (pas dans la bande d'en-tête) — cas de "Carac" qui chapeaute
  //    les colonnes Attribut + Valeur.
  //  - AlignementEntete : voir TPdfAlignementEntete.
  //  - DecalageValeurMin/Max : décalages ajoutés aux bords gauche/droit de la colonne pour
  //    positionner le texte d'une valeur (PdfEcrit) ; 0 = dessiné exactement dans les bords
  //    de la colonne. Chaque tableau a ses propres décalages (constatés colonne par colonne
  //    dans l'ancien code, pas de convention unique) — à renseigner à chaque définition de
  //    tableau, jamais de valeur par défaut "raisonnable" côté DessinerTableau.
  //  - DecalageEnteteMin/Max : même principe que DecalageValeurMin/Max, mais pour le texte
  //    d'en-tête d'une colonne AlignementEntete = alGauche (PdfEcrit) ; sans effet en alCentre.
  TPdfColonne = record
    Libelle:            String;
    Champ:              String;
    EnTete:             Boolean;
    Largeur:             Single;
    FusionAvecSuivante:  Boolean;
    AlignementEntete:    TPdfAlignementEntete;
    DecalageValeurMin:   Single;
    DecalageValeurMax:   Single;
    DecalageEnteteMin:   Single;
    DecalageEnteteMax:   Single;
  end;

  TPdfTableau = record
    X, Y:            Single;   // coin haut-gauche du tableau, bande de libellés incluse
    Orientation:      TPdfOrientationTableau;
    LargeurLibelles:  Single;  // largeur de la bande de libellés (orColonne)
    LargeurEntree:    Single;  // largeur par défaut d'une colonne "entrée" (orColonne) ou
                                // d'une colonne de donnée (orLigne, si Champ.Largeur = 0)
    HauteurLigne:     Single;
    Police:           Integer; // taille de police par défaut des valeurs (hors EnTete/Accent)
    Champs:           array of TPdfColonne;
    // orLigne uniquement :
    Titre:               String; // bandeau plein largeur au-dessus des en-têtes ('' = aucun)
    TitreDecalageGauche:  Single;
    PoliceMin:            Integer; // taille plancher pour le rétrécissement auto (PdfEcrit)
    NbLignesMax:          Integer; // nombre de lignes du cadre dessiné, si le tableau a une
                                    // capacité fixe supérieure au nombre d'entrées réellement
                                    // fournies (ex : grille de compétences à 28 lignes, dont
                                    // seules les premières sont remplies) ; 0 = cadre exactement
                                    // à la taille de Donnees.
  end;


Procedure PdfPersonnageCompetenceTri(ListPage: TStringList);
Function PdfPersonnageAttribut(Personnage: StructurePersonnage; Attribut: String; var Bonus: String): StructureDonnee;
Procedure PdfPersonnageCreation(Personnage: StructurePersonnage; BackGround: Boolean; DessineTexteLigne: Boolean = True);
Procedure PdfPersonnageCreationFeldo2P(Personnage: StructurePersonnage);
Function PdfPersonnageCompetence(Personnage: StructurePersonnage; Competence: String; var NivMetier: Integer): StructureDonnee;
Function PdfPersonnageTalent(Personnage: StructurePersonnage; Talent: String; Var NivMetier: Integer): StructureDonnee;
Function PdfPersonnageRemplaceBonus(Personnage: StructurePersonnage; ChW: String): String;
Function PdfPersonnageCompetenceBonus(Personnage: StructurePersonnage; CodeCompetence: String): String;
Function PdfPersonnageTalentBonus(Personnage: StructurePersonnage; CodeTalent: String): String;

// Blocs extraits de PdfPersonnageCreationFeldo2P (CONTEXT.md §2.4) — premier prototype
// de l'architecture Bloc/Tableau. PdfBlocResilience dessine le cadre partagé
// Résilience/Destin (les deux tableaux occupent une seule boîte dans ce gabarit) ET le
// contenu du côté Résilience ; PdfBlocDestin dessine uniquement le contenu du côté Destin,
// sans redessiner le cadre. Voir le commentaire sur PdfBlocResilience pour le détail.
Procedure PdfBlocResilience(PdfPage: TPDFPage; Personnage: StructurePersonnage; X, Y: Single; NbLignes: Integer; HauteurLigne: Single; MinPolice: Integer; Determine: Integer; out NbLignesPourSuite: Integer);
Procedure PdfBlocDestin(PdfPage: TPDFPage; Personnage: StructurePersonnage; XGauche, Y: Single; HauteurLigne: Single; MinPolice: Integer; Chance: Integer);

// Bloc Entête (panneau fixe en haut de la page 1 : nom, race, classe, carrière, niveau de
// carrière, voie, statut, âge/taille/cheveux/yeux). Grille à colonnes irrégulières selon la
// ligne (les séparateurs verticaux internes changent d'une ligne à l'autre) : ce n'est donc
// pas un TPdfTableau générique, juste un bloc simple comme Résilience/Destin. Renvoie le Y
// du bas du cadre, comme DessinerTableau (sans le -3 de marge, laissé à l'appelant).
Function PdfBlocEntete(PdfPage: TPDFPage; Personnage: StructurePersonnage; PRace: StructureRace; PMetier: StructureMetier; PMetierNiveau: StructureMetierNiveau; LocData: String; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer): Single;

// Bloc Ambitions (panneau fixe : titre + deux lignes "court terme"/"long terme" laissées
// vides à l'impression pour être remplies à la main — aucune donnée de Personnage,
// uniquement des libellés). Brique 1, CONTEXT.md §2.4. Renvoie le Y du bas du cadre, comme
// PdfBlocEntete (sans le -3 de marge, laissé à l'appelant).
Function PdfBlocAmbitions(PdfPage: TPDFPage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer): Single;

// Blocs Expérience / Mouvement / Corruption : trois panneaux "titre + lignes libellé/valeur"
// alignés côte à côte sur la même rangée (même Y de départ, calculé par l'appelant à partir
// du bas du bloc Résilience/Destin). Chacun ne connaît que son propre coin (XGauche/XDroite),
// brique 1, CONTEXT.md §2.4. Renvoient le Y du bas du cadre (sans le -3 de marge).
Function PdfBlocExperience(PdfPage: TPDFPage; Personnage: StructurePersonnage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer): Single;
Function PdfBlocMouvement(PdfPage: TPDFPage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer; Mouv, BonusSprint: Integer): Single;
Function PdfBlocCorruption(PdfPage: TPDFPage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer; BE, BFM, AmePure: Integer): Single;

// Brique 2 (tableau de données, CONTEXT.md §2.4) — DessinerTableau est générique : elle
// dessine le cadre et le contenu à partir de Tableau (mise en page) et Donnees (valeurs déjà
// préparées), sans rien connaître du sens métier des champs. Elle renvoie le Y du bas du
// tableau, pour que l'appelant enchaîne le bloc suivant (comme DessinDebutHautComp).
// Les deux orientations (orColonne : Caractéristiques ; orLigne : Compétences) sont
// implémentées.
Function DessinerTableau(PdfPage: TPDFPage; const Tableau: TPdfTableau; const Donnees: TPdfRecordSet): Single;

// Prototype de préparation pour le tableau des Caractéristiques : transforme les données du
// personnage (via PdfPersonnageAttribut et ListMetierAttribut) en TPdfRecordSet prêt à être
// dessiné par DessinerTableau, sans aucun calcul de position/dessin.
Function PdfPreparerRecordSetCaracteristiques(Personnage: StructurePersonnage; PMetier: StructureMetier): TPdfRecordSet;

// Prépare le tableau des compétences de base (première grille de la page, celle qui liste
// ListPage). Renvoie aussi, en paramètres out, les totaux de 5 compétences (Esquive, Calme,
// Résistance, Commandement, Intuition) réutilisés plus loin dans PdfPersonnageCreationFeldo2P
// pour un autre encart, et ListPris (la liste des codes de compétences déjà affichées, pour
// que le tableau des compétences groupées ne les propose pas une deuxième fois) — c'est le
// même calcul que faisait l'ancien code, juste extrait ici.
Function PdfPreparerRecordSetCompetencesBase(Personnage: StructurePersonnage; PMetier: StructureMetier; ListPage: TStringList; out TotalEsquive, TotalCalme, TotalResitance, TotalCommandement, TotalIntuition: Integer; out ListPris: String): TPdfRecordSet;

// Prépare le tableau des compétences groupées (deuxième grille) : d'abord les compétences de
// ListCompetence déjà augmentées et pas déjà affichées dans le tableau de base (ListPris),
// puis, tant qu'il reste de la place (CapaciteMax lignes au total), les compétences
// accessibles via le métier mais pas encore augmentées, grisées. Contrairement au tableau de
// base, ni Nom ni Attribut n'ont de police "accent" ici (toujours police de valeur normale).
// Note : corrige un bug de l'ancien code, qui utilisait par erreur une variable non
// réassignée (`Comp`, reliquat du tableau précédent) pour l'astérisque de bonus — remplacé
// ici par le code de la compétence réellement affichée sur la ligne (validé avec Nono).
Function PdfPreparerRecordSetCompetencesGroupees(Personnage: StructurePersonnage; ListPris: String; CapaciteMax: Integer): TPdfRecordSet;

implementation

Procedure PdfPersonnageCompetenceTri(ListPage: TStringList);
  var
    ListComp:    TStringList;
    ListTri:     TStringList;
    IndC:        Integer;
    Comp:        String;
    PCompetence: StructureCompetence;
  Begin
    ListComp   := TStringList.Create;
    ListTri    := TStringList.Create;

    ListComp.Add('COMPART_*');
    ListComp.Add('COMPATHL');
    ListComp.Add('COMPSUBOR');
    ListComp.Add('COMPCHARM');
    ListComp.Add('COMPANIM');
    ListComp.Add('COMPESCAL');
    ListComp.Add('COMPCALM');
    ListComp.Add('COMPRESALC');
    ListComp.Add('COMPESQU');
    ListComp.Add('COMPCOND');
    ListComp.Add('COMPRESIST');
    ListComp.Add('COMPDIVERT_*');
    ListComp.Add('COMPPARI');
    ListComp.Add('COMPRAGOT');
    ListComp.Add('COMPMARCH');
    ListComp.Add('COMPINTIM');
    ListComp.Add('COMPINTUI');
    ListComp.Add('COMPCOMM');
    ListComp.Add('COMPCOMB_BASE');
    ListComp.Add('COMPCOMB_*');
    ListComp.Add('COMPORIENT');
    ListComp.Add('COMPSURVEXT');
    ListComp.Add('COMPPRECEP');
    ListComp.Add('COMPCHEV_*');
    ListComp.Add('COMPRAMER');
    ListComp.Add('COMPDISC_*');

    // chercher les libellés
    for IndC := 0 to ListComp.count-1 do
      begin
        Comp        := ListComp[IndC];
        PCompetence := ChercheCompetence(Comp);
        ListTri.Add(PCompetence.Libelle+Separateurtabulation+PCompetence.CodeCompetence);
      end;
    ListTri.Sort;
    ListComp.Destroy;

    // ajouter dans la liste finale
    for IndC := 0 to ListTri.count-1 do
      begin
        Comp        := ExtractStringAfter(ListTri[IndC],Separateurtabulation);
        ListPage.Add(Comp);
      end;
    ListTri.Destroy;
end;

Function PdfPersonnageRemplaceBonus(Personnage: StructurePersonnage; ChW: String): String;
  Var
    Res: String;
    Donnee: StructureDonnee;
    Bonus: String;
  Begin
    Res    := ChW;
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracCC, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracCC+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracCC+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracCT, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracCT+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracCT+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracF, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracF+')',        InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracF+')',   InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracE, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracE+')',        InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracE+')',   InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracI, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracI+')',        InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracI+')',   InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracAg, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracAg+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracAg+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracDex, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracDex+')',      InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracDex+')', InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracInt, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracInt+')',      InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracInt+')', InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracFM, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracFM+')',       InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracFM+')',  InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Donnee := PdfPersonnageAttribut(Personnage, ConstCaracSoc, Bonus);
    Res    := StringReplace(Res, '('+ConstCaracSoc+')',      InttoStr(Donnee.Total), [rfIgnoreCase]);
    Res    := StringReplace(Res, '('+ConstBonusCaracSoc+')', InttoStr(floor(Donnee.Total/10)), [rfIgnoreCase]);
    Result := Res;
  end;


Function PdfPersonnageTalent(Personnage: StructurePersonnage; Talent: String; Var NivMetier: Integer): StructureDonnee;
  var
    PersonnageTalent: StructurePersonnageTalent;
    PMetierTalent:    StructureMetierTalent;
    Res:              StructureDonnee;
  begin
    Res.Base         := 0;
    Res.Augmentation := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      if CompareRechercheValeur(Talent, PersonnageTalent.CodeTalent) then
        Res.Augmentation := Res.Augmentation + PersonnageTalent.Valeur;
    For PersonnageTalent in Personnage.AugmentationTalent do
      if CompareRechercheValeur(Talent, PersonnageTalent.CodeTalent) then
        Res.Augmentation := Res.Augmentation + PersonnageTalent.Valeur;
    For PMetierTalent in ListMetierTalent do
      if CompareRechercheValeur(PMetierTalent.CodeMetier, Personnage.MetierEnCours.CodeMetier) then
        if CompareRechercheValeur(PMetierTalent.CodeTalent, Talent) then
          begin
            NivMetier := PMetierTalent.NiveauMetier;
            break;
          end
       else if Pos(ValeurGenerique, PMetierTalent.CodeTalent) > 0 then
         if Copy(PMetierTalent.CodeTalent,1,Pos(ValeurGenerique, PMetierTalent.CodeTalent)-1) = Copy(Talent,1,Pos(ValeurSousCompetence, Talent)-1) then
           begin
             NivMetier := PMetierTalent.NiveauMetier;
             break;
           end;
    Res.Total := Res.Base + Res.Augmentation;
    Result := res;
  end;


Function PdfPersonnageCompetence(Personnage: StructurePersonnage; Competence: String; Var NivMetier: Integer): StructureDonnee;
  var
    PersonnageCompetence: StructurePersonnageCompetence;
    PCompetence:          StructureCompetence;
    Res:                  StructureDonnee;
    DonneeAttribut:       StructureDonnee;
    CodeCompetence:       String;
    Bonus:                String;
  begin
    Res.Base         := 0;
    Res.Augmentation := 0;
    NivMetier        := 0;
    PCompetence      := ChercheCompetence(Competence);
    if PCompetence.SousCompetence then
      begin
        CodeCompetence := ExtractStringBefore(PCompetence.CodeCompetence, ValeurSousCompetence) + ValeurGenerique;
        PCompetence    := ChercheCompetence(CodeCompetence);
      end;
    DonneeAttribut := PdfPersonnageAttribut(Personnage, PCompetence.CodeAttribut, Bonus);
    Res.Base       := DonneeAttribut.Total;
    for PersonnageCompetence in Personnage.CreationCompetence35 do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          Res.Augmentation := Res.Augmentation + PersonnageCompetence.Valeur;
          break;
        end;
    for PersonnageCompetence in Personnage.CreationCompetence40 do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          Res.Augmentation := Res.Augmentation + PersonnageCompetence.Valeur;
          break;
        end;
    For PersonnageCompetence in Personnage.AugmentationCompetence do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          Res.Augmentation := Res.Augmentation + PersonnageCompetence.Valeur;
          break;
        end;
    For PersonnageCompetence in Personnage.MetierCompetence do
      if CompareRechercheValeur(Competence, PersonnageCompetence.CodeCompetence) then
        begin
          NivMetier := PersonnageCompetence.Valeur;
          break;
        end;
    Res.Total := Res.Base + Res.Augmentation;
    Result := res;
  end;


Function PdfPersonnageAttribut(Personnage: StructurePersonnage; Attribut: String; var Bonus: String): StructureDonnee;
  var
    PersonnageAttribut: StructurePersonnageAttribut;
    PersonnageTalent:   StructurePersonnageTalent;
    PTalent:            StructureTalent;
    Res:                StructureDonnee;
    strings:            TStringList;
    Ind:                Integer;
    Neg:                String;
    Attr:               String;
    PRaceAttribut:      StructureRaceAttribut;
  begin
    Res.Base         := 0;
    Res.Augmentation := 0;

    PRaceAttribut := ChercheRaceAttribut(Personnage.Race, Attribut);
    Res.Base      := StrToIntDef(ExtractStringAfter(PRaceAttribut.CalculRace,'+'),0);

    Bonus := '';
    for PersonnageAttribut in Personnage.CreationAttribut do
      if CompareRechercheValeur(PersonnageAttribut.CodeAttribut, Attribut) then
        begin
          Res.Base := Res.Base + PersonnageAttribut.Valeur;
          if PersonnageAttribut.Bonus <> '' then
            Bonus := PersonnageAttribut.Bonus;
          break;
        end;

    For PersonnageTalent in Personnage.CreationTalent do
      Begin
        PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
        if PTalent.Attribut <> '' then
          begin
           strings            := TStringList.Create;
           ExtractStrings([';'], [], PChar(PTalent.Attribut), Strings);
           for Ind := 0 to (Strings.count-1) Do
             begin
               if leftStr(Strings[ind],1) = '-' then
                 Neg := '-'
               else
                 Neg := '';
               Attr  := RightStr(Strings[ind],Length(Strings[ind]) - Length(Neg));
               if Attr = Attribut then
                 Res.Base := Res.Base + StrToIntDef(Neg+'5',0);
             end;
           strings.free;
          end;
      end;

    For PersonnageTalent in Personnage.AugmentationTalent do
      Begin
        PTalent := ChercheTalent(PersonnageTalent.CodeTalent);
        if PTalent.Attribut <> '' then
          begin
           strings            := TStringList.Create;
           ExtractStrings([';'], [], PChar(PTalent.Attribut), Strings);
           for Ind := 0 to (Strings.count-1) Do
             begin
               if leftStr(Strings[ind],1) = '-' then
                 Neg := '-'
               else
                 Neg := '';
               Attr  := RightStr(Strings[ind],Length(Strings[ind]) - Length(Neg));
               if Attr = Attribut then
                 Res.Base := Res.Base + StrToIntDef(Neg+'5',0);
             end;
           strings.free;
          end;
      end;

    For PersonnageAttribut in Personnage.AugmentationAttribut do
      if CompareRechercheValeur(Attribut, PersonnageAttribut.CodeAttribut) then
        Res.Augmentation := Res.Augmentation + PersonnageAttribut.Valeur;

    Res.Total := Res.Base + Res.Augmentation;
    Result := res;
  end;

Procedure PdfPersonnageCreation(Personnage: StructurePersonnage; BackGround: Boolean; DessineTexteLigne: Boolean = True);
  var
    PDFDoc:               TPDFDocument;
    PdfSection:           TPDFSection;
    PdfPage:              TPDFPage;
    PDFOption:            TPDFOptions;
    PdfFront:             Integer;
    PdfBack:              Integer;
    PdfShadow:            Integer;
    PdfChemin:            String;
    PRace:                StructureRace;
    PMetier:         StructureMetier;
    PMetierNiveau:   StructureMetierNiveau;
    PRaceAttribut:   StructureRaceAttribut;
    PTalent:         StructureTalent;
    Mouv:            Integer = 0;
    ListPage:        TStringList;
    Comp:            String;
    PCompetence:     StructureCompetence;
    ValStat:         String;
    ValBonus:        String;
    ValTotal:        String;
    DebPage:         Integer;
    NbLigne:         Integer;
    IndC:            Integer;
    ListPris:        String;
    LibComp:         String;
    BF, BE, BFM:     Integer;
    Ch:              String;
    DurACuire:       Integer = 0;
    BonusEncomb:     Integer = 0;
    Enc:             Integer;
    EncP:            Integer;
    PArme:           StructureArme;
    PArmure:         StructureArmure;
    Deg:             Integer;
    Pourcent:        String;
    EncArme:         Integer;
    EncArmure:       Integer;
    ArmureTete:      Integer;
    ArmureBras:      Integer;
    ArmureCorps:     Integer;
    ArmureJambe:     Integer;
    ArmureBouclier:  Integer = 0;
    PosProtection:   SizeInt;
    NbLoca:          Integer;
    IndLoca:         Integer;
    LocData:         String;
    NbArme:          Integer;
    NbArmure:        Integer;
    ArmeBonii:       String = '';
    ArmureBonii:     String = '';
    FabricationBonii:String = '';
    PArmureBonus:    StructureArmureBonus;
    PArmeBonus:      StructureArmeBonus;
    NbBonus:         Integer;
    TxtBonus:        String;
    IndDivers:       Integer = 0;
    PasBonus:        Boolean;
    ListMalii:       String;
    NBSort:          Integer;
    PSort:           StructureSort;
    LigneBonus:      String;
    Ind:             Integer;
    PAttribut:       StructureAttribut;
    PFabrication:    StructureFabrication;
    Quality:         String;
    Portee:          String;
    TexteRange1:     String;
    TexteRange2:     String;
    PorteMoyenne:    Integer;
    Chance:          Integer;
    Determine:       Integer;
    TBonusCC:        Integer=0;
    TBonusCT:        Integer=0;
    Val:             Integer;
    Asterisc:        String='';
    BonusSprint:     Integer=0;
    MinPolice:       Integer=5;
    DernierMetier:   String='';
    PersonnageAttribut:   StructurePersonnageAttribut;
    AttributDonnee:       StructureDonnee;
    CompetenceDonnee:     StructureDonnee;
    PersonnageTalent:     StructurePersonnagetalent;
    TalentDonnee:         StructureDonnee;
    PersonnageEquipement: StructurePersonnageEquipement;
    PersonnageMetier:     StructurePersonnageMetier;
    PArmureSimplifiee:    StructureArmureSimplifiee;
    Bidon:                Integer = 0;
    ArmureSet:            Boolean = false;
    AmePure:              Integer = 0;
    Bonus:                String;

  begin
    PdfChemin        := GetCurrentDir+ConstCheminPersonnage+Personnage.NomPersonnage+'\'+Personnage.NomPersonnage+'.PDF';

    if (Pos(AjouteAccolade(ConstXmlOptionQuickArmor),Personnage.Options) > 0) then
      ArmureSet := True;

    if FileExists(PdfChemin) then
      if not DeleteFile(PdfChemin) then
        begin
          ShowMessage(GetTexteLibelle('MESS_038'));
          exit;
        end;

    PDFDoc          := TPDFDocument.Create(nil);
    PDFOption       := [poUseImageTransparency, poCompressImages, poCompressFonts, poCompressText ];
    PDFDoc.Options  := PDFOption;
    PDFDoc.StartDocument;
    PdfSection      := PDFDoc.Sections.AddSection;

  // PAGE 1
    PdfPage         := PDFDoc.Pages.AddPage;
    PdfFontBack     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue    := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'ariali.ttf', ConstPoliceArial);
    PdfFontBold     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'arialbd.ttf', ConstPoliceArial+ConstPoliceGras);

    PdfSection.AddPage(PdfPage);
    PdfPage.PaperType:= ptA4;
    PdfPage.UnitOfMeasure := uomMillimeters;

    // Paramétrages : liste des compétences de la page 1
    ListPage       := TStringList.Create;

    PdfPersonnageCompetenceTri(ListPage);
    // charger l'image de fond
    if BackGround = true then
      begin
        PdfFront         := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfFront, ConstLangue, ValLangue, [rfReplaceAll]),false);
        PdfPage.DrawImage(0, 0, 210, 297, PdfFront);
      end;

    // gérer les lignes
    if DessineTexteLigne then
      begin
        // Écrire du texte sur la page PDF
        PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

        // Haut
          // H
        PdfPage.DrawLine(17,235,194,235,1);
        PdfPage.DrawLine(17,240,194,240,1);
        PdfPage.DrawLine(17,245,194,245,1);
        PdfPage.DrawLine(105,250,105,240,1);
        PdfPage.DrawLine(105,235,105,230,1);
          // V
        PdfPage.DrawLine(149.5,250,149.5,245,1);
        PdfPage.DrawLine(149.5,240,149.5,230,1);
        PdfPage.DrawLine(61.5,235,61.5,230,1);
          // T
        PdfPage.WriteText( 18, 246, GetTexteLibelle('PDF_MAIN1_NAME'));
        PdfPage.WriteText(106.5, 246, GetTexteLibelle('PDF_MAIN1_SPECIES'));
        PdfPage.WriteText(151.5, 246, GetTexteLibelle('PDF_MAIN1_CLASS'));

        PdfPage.WriteText( 18, 241, GetTexteLibelle('PDF_MAIN2_CAREER'));
        PdfPage.WriteText(106.5, 241, GetTexteLibelle('PDF_MAIN2_CAREERLEVEL'));

        PdfPage.WriteText( 18, 236, GetTexteLibelle('PDF_MAIN3_CAREERPATH'));
        PdfPage.WriteText(151.5, 236, GetTexteLibelle('PDF_MAIN3_STATUS'));

        PdfPage.WriteText( 18, 231, GetTexteLibelle('PDF_MAIN4_AGE'));
        PdfPage.WriteText(63, 231, GetTexteLibelle('PDF_MAIN4_HEIGHT'));
        PdfPage.WriteText(106.5, 231, GetTexteLibelle('PDF_MAIN4_HAIR'));
        PdfPage.WriteText(151.5, 231, GetTexteLibelle('PDF_MAIN4_EYES'));

        // caractéristiques
          // H
        PdfPage.DrawLine(17,219,96,219,1);
        PdfPage.DrawLine(17,214,96,214,1);
        PdfPage.DrawLine(17,207,96,207,1);
        PdfPage.DrawLine(17,200,96,200,1);
          // V
        For ind := 0 to 9 do
          PdfPage.DrawLine(31.5+(ind * 6.5),219,31.5+(ind * 6.5),193,1);
           // T
        PdfCentre(PdfPage,17,96,221,GetTexteLibelle('PDF_CHARAC1_CHARAC'));
        PdfCentre(PdfPage,31,38,215,GetTexteLibelle('SHORTATTR_WS'));

        PdfCentre(PdfPage,38,45,215, GetTexteLibelle('SHORTATTR_BS'));
        PdfCentre(PdfPage,45,51,215, GetTexteLibelle('SHORTATTR_S'));
        PdfCentre(PdfPage,51,58,215, GetTexteLibelle('SHORTATTR_T'));
        PdfCentre(PdfPage,58,64,215, GetTexteLibelle('SHORTATTR_I'));
        PdfCentre(PdfPage,64,71,215, GetTexteLibelle('SHORTATTR_Ag'));
        PdfCentre(PdfPage,71,77,215, GetTexteLibelle('SHORTATTR_Dex'));
        PdfCentre(PdfPage,78,85,215, GetTexteLibelle('SHORTATTR_Int'));
        PdfCentre(PdfPage,84,90,215, GetTexteLibelle('SHORTATTR_WP'));
        PdfCentre(PdfPage,91,97,215, GetTexteLibelle('SHORTATTR_Fel'));
        PdfPage.WriteText( 18, 209, GetTexteLibelle('PDF_CHARAC3_INITIAL'));
        PdfPage.WriteText( 18, 202, GetTexteLibelle('PDF_CHARAC3_ADVANCES'));
        PdfPage.WriteText( 18, 195, GetTexteLibelle('PDF_CHARAC3_CURRENT'));
        // Destin
          // H
        PdfPage.DrawLine(101,219,118,219,1);
        PdfPage.DrawLine(101,214,118,214,1);
          // V
        PdfPage.DrawLine(111,209,111,219,1);
          // T
        PdfCentre(PdfPage,101,118,221,GetTexteLibelle('PDF_FATE1_FATE'));
        PdfPage.WriteText(101,215,GetTexteLibelle('PDF_FATE2_FATE'));
        PdfPage.WriteText(101,210,GetTexteLibelle('PDF_FATE3_FORTUNE'));
        // Résilience
          // H
        PdfPage.DrawLine(123,219,162,219,1);
        PdfPage.DrawLine(123,214,162,214,1);
          // V
        PdfPage.DrawLine(137,209,137,219,1);
        PdfPage.DrawLine(148,209,148,219,1);
          // T
        PdfCentre(PdfPage,123,163,221,GetTexteLibelle('PDF_RESIL1_RESILIENCE'));
        PdfCentre(PdfPage,123,137,215,GetTexteLibelle('PDF_RESIL2A_RESILIENCE'));
        PdfCentre(PdfPage,137,148,215,GetTexteLibelle('PDF_RESIL2B_RESOLVE'));
        PdfCentre(PdfPage,148,162,215,GetTexteLibelle('PDF_RESIL2C_MOTIVATION'));
        // Expérience
          // H
        PdfPage.DrawLine(165,219,194,219,1);
        PdfPage.DrawLine(165,214,194,214,1);
          // V
        PdfPage.DrawLine(176,209,176,219,1);
        PdfPage.DrawLine(185,209,185,219,1);
          // T
        PdfCentre(PdfPage,165,194,221,GetTexteLibelle('PDF_XP1_EXPERIENCE'));
        PdfCentre(PdfPage,165,176,215,GetTexteLibelle('PDF_XP2A_CURRENT'));
        PdfCentre(PdfPage,176,185,215,GetTexteLibelle('PDF_XP2B_SPENT'));
        PdfCentre(PdfPage,185,194,215,GetTexteLibelle('PDF_XP2C_TOTAL'));
        // Mouvement
          // H
        PdfPage.DrawLine(101,198,194,198,1);
          // V
        PdfPage.DrawLine(121.5,198,121.5,193,1);
        PdfPage.DrawLine(132.5,198,132.5,193,1);
        PdfPage.DrawLine(149.5,198,149.5,193,1);
        PdfPage.DrawLine(164.5,198,164.5,193,1);
        PdfPage.DrawLine(181.5,198,181.5,193,1);
          // T

        PdfCentre(PdfPage,101,194,200,GetTexteLibelle('PDF_MV1_MOVEMENT'));
        PdfPage.WriteText(102,194,GetTexteLibelle('PDF_MV2A_MOVEMENT'));
        PdfPage.WriteText(133.5,194,GetTexteLibelle('PDF_MV2B_WALK'));
        PdfPage.WriteText(165.5,194,GetTexteLibelle('PDF_MV2C_RUN'));
        // Basic 1
          // H
        For Ind := 0 to 13 do
          PdfPage.DrawLine(17,181.5 - (ind * 5),72,181.5 - (ind * 5),1);
          // V
        PdfPage.DrawLine(41,181.5,41,111.5,1);
        PdfPage.DrawLine(49,176.5,49,111.5,1);
        PdfPage.DrawLine(57,181.5,57,111.5,1);
        PdfPage.DrawLine(64,181.5,64,111.5,1);
         // T
        PdfCentre(PdfPage,17,72,183.5,GetTexteLibelle('PDF_SKILLS1_BASIC'));
        PdfEcrit(PdfPage,18,41,177.5,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
        PdfCentre(PdfPage,42,57,177.5,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
        PdfCentre(PdfPage,57,64,177.5,GetTexteLibelle('PDF_SKILLS2_ADV'));
        PdfCentre(PdfPage,64,72,177.5,GetTexteLibelle('PDF_SKILLS2_SKILL'));
        // Basic 2
          // H
        For Ind := 0 to 13 do
          PdfPage.DrawLine(78,181.5 - (ind * 5),133,181.5 - (ind * 5),1);
          // V
        PdfPage.DrawLine(102,181.5,102,111.5,1);
        PdfPage.DrawLine(110,176.5,110,111.5,1);
        PdfPage.DrawLine(118,181.5,118,111.5,1);
        PdfPage.DrawLine(125,181.5,125,111.5,1);
         // T
         PdfCentre(PdfPage,78,133.5,183.5,GetTexteLibelle('PDF_SKILLS1_BASIC'));
         PdfEcrit(PdfPage,78,102,177.5,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
         PdfCentre(PdfPage,102,118,177.5,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
         PdfCentre(PdfPage,118,125,177.5,GetTexteLibelle('PDF_SKILLS2_ADV'));
         PdfCentre(PdfPage,125,133,177.5,GetTexteLibelle('PDF_SKILLS2_SKILL'));
        // Groupé
          // H
        For Ind := 0 to 1 do
          PdfPage.DrawLine(139,181.5 - (ind * 5),194,181.5 - (ind * 5),1);
          // V
        PdfPage.DrawLine(162,181.5,162,111.5,1);
        PdfPage.DrawLine(170,176.5,170,111.5,1);
        PdfPage.DrawLine(178,181.5,178,111.5,1);
        PdfPage.DrawLine(185,181.5,185,111.5,1);
          // T
        PdfCentre(PdfPage,139,194,183.5,GetTexteLibelle('PDF_SKILLS1_ADVANCED'));
        PdfEcrit(PdfPage,139,162,177.5,GetTexteLibelle('PDF_SKILLS2_NAME'),MinPolice);
        PdfCentre(PdfPage,162,178,177.5,GetTexteLibelle('PDF_SKILLS2_CHARAC'));
        PdfCentre(PdfPage,178,185,177.5,GetTexteLibelle('PDF_SKILLS2_ADV'));
        PdfCentre(PdfPage,185,194,177.5,GetTexteLibelle('PDF_SKILLS2_SKILL'));
        // Talents
          // H
        PdfPage.DrawLine(17,100,100,100,1);
        PdfPage.DrawLine(17,92,100,92,1);
          // V
        PdfPage.DrawLine(45,100,45,20,1);
        PdfPage.DrawLine(56,100,56,20,1);
          // T
        PdfCentre(PdfPage,17,100,102,GetTexteLibelle('PDF_TALENT1_TALENTS'));
        PdfPage.WriteText(18,95,GetTexteLibelle('PDF_TALENT2_TALENTNAME'));
        PdfCentre(PdfPage,45,56,96,GetTexteLibelle('PDF_TALENT2A_TAKEN'));
        PdfCentre(PdfPage,45,56,93,GetTexteLibelle('PDF_TALENT2B_TAKEN'));
        PdfPage.WriteText(58,95,GetTexteLibelle('PDF_TALENT2_DESC'));
         // Ambitions
          // H
        PdfPage.DrawLine(106,100,194,100,1);
        PdfPage.DrawLine(106,88,194,88,1);
          // T
        PdfCentre(PdfPage,106,194,102,GetTexteLibelle('PDF_AMBITION1_AMBITIONS'));
        PdfPage.WriteText(108,94,GetTexteLibelle('PDF_AMBITION2A_SHORT'));
        PdfPage.WriteText(108,91,GetTexteLibelle('PDF_AMBITION2B_SHORT'));
        PdfPage.WriteText(108,83,GetTexteLibelle('PDF_AMBITION3A_LONG'));
        PdfPage.WriteText(108,80,GetTexteLibelle('PDF_AMBITION3B_LONG'));
        // Party
          // H
        PdfPage.DrawLine(106,65,194,65,1);
        PdfPage.DrawLine(106,59,194,59,1);
        PdfPage.DrawLine(106,47,194,47,1);
        PdfPage.DrawLine(106,36,194,36,1);
          // T
        PdfCentre(PdfPage,106,194,67,GetTexteLibelle('PDF_PARTY1_PARTY'));
        PdfPage.WriteText(108,61,GetTexteLibelle('PDF_PARTY2_PARTYNAME'));
        PdfPage.WriteText(108,53,GetTexteLibelle('PDF_PARTY3A_SHORT'));
        PdfPage.WriteText(108,50,GetTexteLibelle('PDF_PARTY3B_SHORT'));
        PdfPage.WriteText(108,42,GetTexteLibelle('PDF_PARTY4A_LONG'));
        PdfPage.WriteText(108,39,GetTexteLibelle('PDF_PARTY4B_LONG'));
        PdfPage.WriteText(108,30,GetTexteLibelle('PDF_PARTY5_MEMBERS'));
      end;

    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);

    // Entête
    PRace          := ChercheRace(Personnage.Race);
    LocData        := '';
    for PersonnageMetier in Personnage.MetierAncien do
      begin
        if (DernierMetier <> PersonnageMetier.CodeMetier) then
          begin
            PMetier       := ChercheMetier(PersonnageMetier.CodeMetier);
            if Locdata <> '' then
              LocData     := LocData + ' - ';
            LocData       := LocData + PMetier.Libelle + ':';
            DernierMetier := PersonnageMetier.CodeMetier;
          end
        else if LocData <> '' then
          LocData         := LocData + ',';
         LocData          := LocData + IntToStr(PersonnageMetier.NiveauMetier);
      end;
    PMetier        := ChercheMetier(Personnage.MetierEnCours.CodeMetier);
    PMetierNiveau  := ChercheMetierNiveau(Personnage.MetierEnCours.CodeMetier, Personnage.MetierEnCours.NiveauMetier);
    PRaceAttribut  := ChercheRaceAttribut(Personnage.Race, ConstCaracMouvement);
    Mouv           := StrToInt(PRaceAttribut.CalculRace);

    Chance         := 0;
    Determine      := 0;
    For PRaceAttribut in ListRaceAttribut do
      if PRaceAttribut.CodeRace = Personnage.Race then
        case ExtractStringAfter(PRaceAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracDestin: Chance    := Chance    + StrToIntDef(PRaceAttribut.CalculRace,0);
          ConstCaracResil:  Determine := Determine + StrToIntDef(PRaceAttribut.CalculRace,0);
        end;
    for PersonnageAttribut in Personnage.CreationAttribut do
      case ExtractStringAfter(PersonnageAttribut.CodeAttribut, SeparateurLivre) of
        ConstCaracDestin: Chance    := Chance    + PersonnageAttribut.Valeur;
        ConstCaracResil:  Determine := Determine + PersonnageAttribut.Valeur;
      end;

    // chercher les Valeur d'attributs
    for Ind := 0 to 9 do
      begin
        PAttribut      := ListeAttribut[Ind];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        val            := AttributDonnee.Total;
        case ExtractStringAfter(PAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracE:  BE  := Val;
          ConstCaracF:  BF  := Val;
          ConstCaracFM: BFM := Val;
        end;
      end;

    // chercher les talents et calculer les bonus correspondants
    BonusEncomb := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:    DurACuire   := Floor(BE/10) * Val;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;
    for PersonnageTalent in Personnage.AugmentationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:    DurACuire   := Floor(BE/10) * Val;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;

    // Entête
    PdfPage.WriteText( 50, 246, Personnage.NomPersonnage);                               // Nom
    PdfPage.WriteText(118, 246, PRace.Libelle);                                      // Race
    PdfPage.WriteText(165, 246, GetTexteLibelle(PMetier.LibelleGroupe));                 // Classe
    PdfPage.WriteText( 50, 241, PMetier.Libelle);                                  // Métier
    PdfPage.WriteText(135, 241, IntToStr(Personnage.MetierEnCours.NiveauMetier)+' - '+ PMetierNiveau.Libelle);     // Niveau
    PdfPage.WriteText( 50, 236, LocData);     // Schéma
    PdfPage.WriteText(165, 236, GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' '));  // Salaire

    // Caractéristiques
    for Ind := 1 to 10 do
      begin
        PAttribut      := ListeAttribut[Ind-1];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        PdfPage.WriteText(26+(Ind*6.5), 210, IntToStr(AttributDonnee.Base));        // Base
        if AttributDonnee.Augmentation <> 0 then
          PdfPage.WriteText(26+(Ind*6.5), 203, IntToStr(AttributDonnee.Augmentation));// Bonus
        PdfPage.WriteText(26+(Ind*6.5), 195, IntToStr(AttributDonnee.Total));       // Total
        //if TabAttribut.Cells[Ind+1, LigAttAsterisc] <> '' then
        //  begin
        //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 5);
        //    PdfPage.WriteText(29+(Ind*6.5), 198, '('+TabAttribut.Cells[Ind+1, LigAttAsterisc]+')'); // Talent
        //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
        //  end;

      end;

    // Destin
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracDestin, Bonus);
    PdfPage.WriteText(115, 216, IntToStr(AttributDonnee.Total));          // Destin
    PdfPage.WriteText(115, 210, IntToStr(Chance));                        // Chance

    // Destin
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracResil, Bonus);
    PdfPage.WriteText(128, 210, IntToStr(AttributDonnee.Total));          // Résilience
    PdfPage.WriteText(142, 210, IntToStr(Determine));                     // Détermination

    // Expérience
    PdfCentre(PdfPage,165,176,210,IntToStr(Personnage.XpActuel));                      // Total Xp
    PdfCentre(PdfPage,176,185,210,IntToStr(Personnage.XpTotal - personnage.XpActuel)); // Utilisé
    PdfCentre(PdfPage,185,194,210,IntToStr(Personnage.XpTotal));                       // Restant

    // Mouvement
    PdfPage.WriteText(127, 194, IntToStr(Mouv));                              // Mouvement
    PdfPage.WriteText(157, 194, IntToStr(Mouv*2));                            // Marche
    PdfPage.WriteText(188, 194, IntToStr((Mouv + BonusSprint)*4));            // Course

    // Compétences page 1
    NbLigne := 0;
    ListPris:= '';
    for IndC := 0 to ListPage.count-1 do
      begin
        Asterisc    := '';
        Comp        := ListPage[IndC];
        PCompetence := ChercheCompetence(Comp);
        CompetenceDonnee := PdfPersonnageCompetence(Personnage, Comp, Bidon);
        ValStat     := IntToStr(CompetenceDonnee.Base);
        ValBonus    := IntToStr(CompetenceDonnee.Augmentation);
        ValTotal    := IntToStr(CompetenceDonnee.Total);
        ListPris    := ListPris + Separateurtabulation + Comp;
        //Asterisc := TabCompetence.Cells[ColCompAsterisc, IndT];

        // premier ou seconde colonne
        if IndC <= 12 then
          DebPage := 51
        else
          DebPage := 112;
        if IndC = 13 then
          NbLigne := 0;
        if ValBonus = '0' then
          ValBonus := '';
        if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
          ValBonus := ' ' + ValBonus;
        if DessineTexteLigne then
          begin
            if CompareCompetence(PCompetence.CodeCompetence,PMetier.CodeCompetence) then
              PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceArial+ConstPoliceGras, 8)
            else
              PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfEcrit(PdfPage,DebPage - 33, DebPage - 9, 173-(NbLigne*5), PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle),MinPolice);
            PAttribut                              := ChercheAttribut(PCompetence.CodeAttribut);
            PdfPage.WriteText(DebPage - 9, 173-(NbLigne*5), GetTexteLibelle(PAttribut.Resume)); // PdfPage.WriteText(DebPage - 9, 173-(NbLigne*5), GetTexteLibelle('SHORT'+PCompetence.CodeAttribut));
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          end;
        PdfPage.WriteText(DebPage,    173-(NbLigne*5), ValStat);  // Compétence Caractéristique
        PdfPage.WriteText(DebPage+7,  173-(NbLigne*5), ValBonus); // Compétence Bonus
        if Pos(ValeurGenerique, PCompetence.codeCompetence) > 0 then
          PdfPage.DrawLine(DebPage+6.5,  172-(NbLigne*5), DebPage+12.5,  176-(NbLigne*5), 1);
        PdfPage.WriteText(DebPage+14, 173-(NbLigne*5), ValTotal); // Compétence Total
        if Asterisc <> '' then
          begin
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 5);
            PdfPage.WriteText(DebPage+19, 174.5-(NbLigne*5), '('+Asterisc+')'); // Talent
            PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          end;

        NbLigne := NbLigne + 1;
      end;
    ListPage.Destroy;

    // compétences groupés et avancées
    NbLigne := 0;
    for IndC := 0 to ListCompetence.Count-1 do
      begin
        PCompetence   := ListCompetence[IndC];
        if (pos(PCompetence.CodeCompetence, ListPris) = 0) then
          begin
            CompetenceDonnee := PdfPersonnageCompetence(Personnage, PCompetence.CodeCompetence, Bidon);
            if CompetenceDonnee.Augmentation <> 0 then
            begin
              ValBonus := IntToStr(CompetenceDonnee.Augmentation);
              if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
                ValBonus := ' ' + ValBonus;
              PCompetence := ChercheCompetence(PCompetence.CodeCompetence);
              LibComp     := PCompetence.Libelle;
              if CompareCompetence(PCompetence.CodeCompetence,PMetier.CodeCompetence) then
                PdfTaillePolice(PdfPage, PdfFontBold, ConstPoliceArial+ConstPoliceGras, 6)
              else
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
              PdfEcrit(PdfPage,137, 163, 173-(NbLigne*3.5), LibComp,MinPolice);                                // Gr_Av Libellé
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
              PAttribut := ChercheAttribut(PCompetence.CodeAttribut);
              PdfPage.WriteText(163, 173-(NbLigne*3.5), PAttribut.Resume);                   // Gr_Av Attribut
              PdfPage.WriteText(172, 173-(NbLigne*3.5), IntToStr(CompetenceDonnee.Base));                 // Gr_Av Caractéristique
              PdfPage.WriteText(180, 173-(NbLigne*3.5), IntToStr(CompetenceDonnee.Augmentation));         // Gr_Av Bonus
              PdfPage.WriteText(188, 173-(NbLigne*3.5), IntToStr(CompetenceDonnee.Total));                // Gr_Av Total
              NbLigne := NbLigne + 1;
            end;
        end;
      end;

    // talents
    NbLigne := 0;
    For IndC := 0 to ListTalent.count - 1 do
      begin
        PTalent := ListTalent[IndC];
        TalentDonnee := PdfPersonnageTalent(Personnage, PTalent.CodeTalent, Bidon);
        if TalentDonnee.Total <> 0 then
        begin
          inc(NbLigne);
          PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
          PdfEcrit(PdfPage, 16, 49, 92-(NbLigne*3.5), PTalent.Libelle,MinPolice);              // Gr_Av Libellé
          PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          PdfPage.WriteText(49, 92-(NbLigne*3.5), IntToStr(TalentDonnee.Total));              // Gr_Av Attribut
          //if TabTalent.Cells[ColTalAsterisk, IndC] <> '' then
          //  begin
          //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
          //    PdfPage.WriteText(12.5, 92.5-(IndC*3.5), '('+TabTalent.Cells[ColTalAsterisk, IndC]+')');
          //    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
          //  end;
          if PTalent.SousTalent then
            PTalent := ChercheTalent(Copy(PTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
          if PTalent.Resume <> '' then
            begin
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);
              PdfEcrit(PdfPage, 58, 105, 92-(NbLigne*3.5), PTalent.Resume,MinPolice);
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end;
        end;
      end;

  // PAGE 2

    // charger l'image de fond
    PdfPage          := PDFDoc.Pages.AddPage;
    PdfFontBack      := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'ariali.ttf', ConstPoliceArial);
    PdfSection.AddPage(PdfPage);

    if BackGround = true then
      begin
        PdfBack          := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfBack, ConstLangue, ValLangue, [rfReplaceAll]),false);
        PdfPage.DrawImage(0, 0, 210, 297, PdfBack);

        PdfShadow          := PdfDoc.Images.AddFromFile(GetCurrentDir+ConstCheminPdfShadow,false);
        PdfPage.DrawImage(135, 190, 55, 72, PdfShadow);
      end;


    // gérer les lignes
    if DessineTexteLigne then
      begin
        PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

        // Armure
          // H
        PdfPage.DrawLine(17,260,134,260,1);
        for ind := 0 to 4 do
          PdfPage.DrawLine(17,254 - (ind*5),134,254 - (ind*5),1);
          // V
        PdfPage.DrawLine(50,260,50,229,1);
        PdfPage.DrawLine(72,260,72,229,1);
        PdfPage.DrawLine(79,260,79,229,1);
        PdfPage.DrawLine(89,260,89,229,1);
          // T
        PdfCentre(PdfPage,17,134,262,GetTexteLibelle('PDF_ARMOUR1_ARMOUR'));
        PdfPage.WriteText(18,255,GetTexteLibelle('PDF_ARMOUR2_NAME'));
        PdfCentre(PdfPage,50,72,255,GetTexteLibelle('PDF_ARMOUR2_LOCATIONS'));
        PdfCentre(PdfPage,72,79,255,GetTexteLibelle('PDF_ARMOUR2_ENCUMBRANCE'));
        PdfCentre(PdfPage,79,89,255,GetTexteLibelle('PDF_ARMOUR2_ARMOURPOINT'));
        PdfPage.WriteText(90,255,GetTexteLibelle('PDF_ARMOUR2_QUALITIES'));
        // Equipement
          // H
        PdfPage.DrawLine(17,218,73,218,1);
        PdfPage.DrawLine(17,212,73,212,1);
          // V
        PdfPage.DrawLine(65,218,65,136,1);
          // T
        PdfCentre(PdfPage,17,73,220,GetTexteLibelle('PDF_TRAPPING1_TRAPPINGS'));
        PdfPage.WriteText(18,213,GetTexteLibelle('PDF_TRAPPING2_NAME'));
        PdfCentre(PdfPage,65,73,213,GetTexteLibelle('PDF_TRAPPING2_ENCUMBRANCE'));
        // Psychologie
          // H
        for ind := 0 to 2 do
          PdfPage.DrawLine(77,218 - (ind * 5),134,218 - (ind * 5),1);
        // T
        PdfCentre(PdfPage,77,134,220,GetTexteLibelle('PDF_PSYCHOLOGY'));
        // Corruption
          // H
        PdfPage.DrawLine(77,192,134,192,1);
          // T
        PdfCentre(PdfPage,77,134,194,GetTexteLibelle('PDF_CORRUPTION'));
        // Points d'Armure
        PdfCentre(PdfPage,138,194,262,GetTexteLibelle('PDF_ARMOURPOINT_ARMOURPOINT'));
        PdfEncadre(PdfPage, 145, 250, false, GetTexteLibelle('PDF_ARMOURPOINT_HEAD'),'','01-09');
        PdfEncadre(PdfPage, 145, 229, false, GetTexteLibelle('PDF_ARMOURPOINT_RIGHTARM1'),GetTexteLibelle('PDF_ARMOURPOINT_RIGHTARM2'),'25-44');
        PdfEncadre(PdfPage, 145, 207.5, false, GetTexteLibelle('PDF_ARMOURPOINT_RIGHTLEG'),'','90-00');
        PdfEncadre(PdfPage, 145, 190, true, GetTexteLibelle('PDF_ARMOURPOINT_SHIELD'),'','');
        PdfEncadre(PdfPage, 184.5, 241, false, GetTexteLibelle('PDF_ARMOURPOINT_LEFTARM1'),GetTexteLibelle('PDF_ARMOURPOINT_LEFTARM2'),'10-24');
        PdfEncadre(PdfPage, 184.5, 219.5, false, GetTexteLibelle('PDF_ARMOURPOINT_BODY'),'','45-79');
        PdfEncadre(PdfPage, 184.5, 195.5, false, GetTexteLibelle('PDF_ARMOURPOINT_LEFTLEG'),'','80-89');
        // Richesse
          // H
        for ind := 0 to 2 do
          PdfPage.DrawLine(77,167 - (ind * 11),102,167 - (ind * 11),1);
          // V
        PdfPage.DrawLine(88,167,88,136,1);
          // T
        PdfCentre(PdfPage,77,102,169,GetTexteLibelle('PDF_WEALTH1_WEALTH'));
        PdfPage.WriteText(78,160,GetTexteLibelle('PDF_WEALTH2_D'));
        PdfPage.WriteText(78,149,GetTexteLibelle('PDF_WEALTH3_SS'));
        PdfPage.WriteText(78,138,GetTexteLibelle('PDF_WEALTH4_GC'));
        // Encombrement
          // H
        for ind := 0 to 4 do
          PdfPage.DrawLine(106,167 - (ind * 6.1),134,167 - (ind * 6.1),1);
          // V
        PdfPage.DrawLine(120,167,120,136,1);
          // T
        PdfCentre(PdfPage,106,134,169,GetTexteLibelle('PDF_ENCUMBRANCE1_ENCUMBRANCE'));
        PdfPage.WriteText(107,163,GetTexteLibelle('PDF_ENCUMBRANCE2_ARMOUR'));
        PdfPage.WriteText(107,157,GetTexteLibelle('PDF_ENCUMBRANCE3_WEAPONS'));
        PdfPage.WriteText(107,151,GetTexteLibelle('PDF_ENCUMBRANCE4_TRAPPINGS'));
        PdfPage.WriteText(107,144.2,GetTexteLibelle('PDF_ENCUMBRANCE5_MAXENC'));
        PdfPage.WriteText(107,137.6,GetTexteLibelle('PDF_ENCUMBRANCE6_TOTAL'));
        // Blessure
          // H
        PdfPage.DrawLine(138,167,194,167,1);
        for ind := 1 to 4 do
          PdfPage.DrawLine(138,167 - (ind * 6.1),160,167 - (ind * 6.1),1);
          // V
        PdfPage.DrawLine(152,167,152,136,1);
        PdfPage.DrawLine(160,167,160,136,1);
          // T
        PdfCentre(PdfPage,138,160,169,GetTexteLibelle('PDF_WOUNDS1_WOUNDS'));
        PdfPage.WriteText(139,163,GetTexteLibelle('PDF_WOUNDS2_SB'));
        PdfPage.WriteText(139,157,GetTexteLibelle('PDF_WOUNDS3_TBX2'));
        PdfPage.WriteText(139,151,GetTexteLibelle('PDF_WOUNDS4_WPB'));
        PdfPage.WriteText(139,144.2,GetTexteLibelle('PDF_WOUNDS5_HARDY'));
        PdfPage.WriteText(139,137.6,GetTexteLibelle('PDF_WOUNDS6_WOUNDS'));
        // Armes
          // H
        for ind := 0 to 7 do
          PdfPage.DrawLine(17,125 - (ind*5),194,125 - (ind*5),1);
          // V
        PdfPage.DrawLine(66,125,66,85,1);
        PdfPage.DrawLine(79,125,79,85,1);
        PdfPage.DrawLine(90,125,90,85,1);
        PdfPage.DrawLine(108,125,108,85,1);
        PdfPage.DrawLine(128,125,128,85,1);
          // T
        PdfCentre(PdfPage,17,194,127,GetTexteLibelle('PDF_WEAPONS1_WEAPONS'));
        PdfPage.WriteText(18,121,GetTexteLibelle('PDF_WEAPONS2_NAME'));
        PdfCentre(PdfPage,66,79,121,GetTexteLibelle('PDF_WEAPONS2_GROUP'));
        PdfCentre(PdfPage,79,90,121,GetTexteLibelle('PDF_WEAPONS2_ENCUMBRANCE'));
        PdfCentre(PdfPage,90,108,121,GetTexteLibelle('PDF_WEAPONS2_RANGE'));
        PdfCentre(PdfPage,108,128,121,GetTexteLibelle('PDF_WEAPONS2_DAMAGE'));
        PdfPage.WriteText(129,121,GetTexteLibelle('PDF_WEAPONS2_QUALITIES'));
        // Sorts
          // H
        for ind := 0 to 8 do
          PdfPage.DrawLine(17,75 - (ind*5),194,75 - (ind*5),1);
          // V
        for ind := 0 to 4 do
          PdfPage.DrawLine(55 + (ind*15),75,55 + (ind*15),30,1);
        PdfPage.DrawLine(170,35,170,30,1);
        PdfPage.DrawLine(179,35,179,30,1);
          // T
        PdfCentre(PdfPage,17,194,77,GetTexteLibelle('PDF_SPELL1_SPELL'));
        PdfPage.WriteText(18,71,GetTexteLibelle('PDF_SPELL2_NAME'));
        PdfCentre(PdfPage,55,70,71,GetTexteLibelle('PDF_SPELL2_CN'));
        PdfCentre(PdfPage,70,85,71,GetTexteLibelle('PDF_SPELL2_RANGE'));
        PdfCentre(PdfPage,85,100,71,GetTexteLibelle('PDF_SPELL2_TARGET'));
        PdfCentre(PdfPage,100,115,71,GetTexteLibelle('PDF_SPELL2_DURATION'));
        PdfPage.WriteText(116,71,GetTexteLibelle('PDF_SPELL2_EFFECT'));
        PdfPage.WriteText(171,31,GetTexteLibelle('PDF_SPELL3_SIN'));

      end;

    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);

    // afficher les blessure
    Ch := IntToStr(Floor(BF/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,163, Ch);
    Ch := IntToStr(Floor(BE/10)*2);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,157, Ch);
    Ch := IntToStr(Floor(BFM/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,150.5, Ch);
    if DurACuire > 0 then
      begin
        Ch := IntToStr(DurACuire);
        if Length(Ch) = 1 then Ch := ' '+Ch;
        PdfPage.WriteText(154,144, Ch);
      end;
    PRaceAttribut := ChercheRaceAttribut(Personnage.Race, ConstCaracBlessure);
    Ch := IntToStr(CalculBlessure(PRaceAttribut.CalculRace, BF, BE, BFM) + DurACuire);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(154,137.5, Ch);

    // afficher l'encombrement
    Ch := IntToStr(Floor(BF/10) + Floor(BE/10) + BonusEncomb);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfPage.WriteText(125,144, Ch);

    // Afficher l'équipement
    EncArme     := 0;
    EncArmure   := 0;
    ArmureBras  := 0;
    ArmureCorps := 0;
    ArmureJambe := 0;
    ArmureTete  := 0;
    NbArme      := 0;
    NbArmure    := 0;
    NbSort      := 0;
    Quality     := '';
    for PersonnageEquipement in Personnage.Equipement do
      begin
        Enc := 0;
        EncP:= 0;
        if PersonnageEquipement.TypeEquipement = TypeEquipWe then
          // gérer les armes
            begin
              TexteRange1:= '';
              TexteRange2:= '';
              PArme      := ChercheArme(PersonnageEquipement.CodeEquipement);

              Portee     := PArme.Portee;
              if Pos('(B'+ConstCaracF+')',Portee) > 0 then
                begin
                  Portee       := StringReplace(Portee, '(B'+ConstCaracF+')', IntToStr(Trunc(BF/10)), [rfReplaceAll]);;
                  PorteMoyenne := MultiChaine(Portee);
                  Portee       := IntToStr(PorteMoyenne);
                end
              else
                PorteMoyenne   := StrToIntDef(Portee,0);

              Enc        := PArme.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement, Quality);
              EncArme    := EncArme + Enc;

              Inc(NbArme);

              Pourcent := '';

              CompetenceDonnee := PdfPersonnageCompetence(Personnage, PArme.CodeCompetence, Bidon);

              Pourcent := IntToStr(CompetenceDonnee.Total);
              PasBonus := (CompetenceDonnee.Augmentation = 0);

              if pos(EquipementCT, PArme.CodeArme) > 0 then
                begin
                  TexteRange1 := '< : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/10)))+'m '+IntToStr(StrToInt(Pourcent)+40)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/2 )))+'m '+IntToStr(StrToInt(Pourcent)+20)+'%';
                  TexteRange2 := '> : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*2 )))+'m '+IntToStr(StrToInt(Pourcent)-10)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*3 )))+'m '+IntToStr(StrToInt(Pourcent)-30)+'%';
                end;

              PdfEcrit(PdfPage,18,70,121-(NbArme*5), PArme.Libelle+Quality,MinPolice);

              LigneBonus := '';

              PdfPage.WriteText(70,121-(NbArme*5), Pourcent + ' %');
              if PArme.Encombrement <> 0 then
                PdfPage.WriteText(84,121-(NbArme*5), IntToStr(Enc));
              PdfPage.WriteText(92,121-(NbArme*5), GetAllTexteLibelle(Portee));

              Deg   := CalculDegat(PArme.CalculDegat, BF);
              if pos(EquipementCC, PArme.CodeArme) > 0 then
                Deg := Deg + TBonusCC
              else if pos(EquipementCT, PArme.CodeArme) > 0 then
                Deg := Deg + TBonusCT;

              if Deg = 0 then
                PdfPage.WriteText(114,121-(NbArme*5), '-')
              else
                PdfPage.WriteText(114,121-(NbArme*5), 'DR + '+IntToStr(Deg));

              PosProtection := pos(BonusProtection, PArme.ListeBonus);
              if PosProtection > 0 then
                ArmureBouclier := StrToInt(copy(PArme.ListeBonus, PosProtection + Length(BonusProtection), 1));
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);

              if TexteRange1 <> '' then
                begin
                  PdfPage.WriteText(170,122.5-(NbArme*5), TexteRange1);
                  PdfPage.WriteText(170,120.5-(NbArme*5), TexteRange2);
                end;

              if PasBonus = false then
                begin
                  LigneBonus := PArme.Listebonus;
                  if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                    begin
                      NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                      for IndLoca := 1 to NbLoca do
                        begin
                          LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                          if pos(' ',LocData) <> 0 then
                            LocData := copy(LocData,1,Length(LocData)-2);
                          PArmeBonus := ChercheArmeBonus(LocData);
                          LigneBonus := StringReplace(LigneBonus, LocData, PArmeBonus.Libelle, [rfReplaceAll]);
                          if Pos(PArmeBonus.CodeArmeBonus, ArmeBonii) = 0 then
                           begin
                             if ArmeBonii <> '' then
                              ArmeBonii := ArmeBonii + ',';
                              ArmeBonii := ArmeBonii + PArmeBonus.CodeArmeBonus;
                           end;
                        end;
                    end;
                  FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
                  PdfPage.WriteText(132,121-(NbArme*5), LigneBonus);
                end
              else
                begin
                  PCompetence := ChercheCompetence(PArme.CodeCompetence);
                  ListMalii := 'pas ' + PCompetence.Libelle;

                  if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                    begin
                      NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                      for IndLoca := 1 to NbLoca do
                        begin
                          LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                          if pos(' ',LocData) <> 0 then
                            LocData := copy(LocData,1,Length(LocData)-2);
                          PArmeBonus := ChercheArmeBonus(LocData);
                          if PArmeBonus.PlusMoins = '-' then
                            begin
                              if Pos(PArmeBonus.Libelle, ArmeBonii) = 0 then
                                begin
                                  if ArmeBonii <> '' then ArmeBonii := ArmeBonii + ',';
                                  ArmeBonii := ArmeBonii + LocData;
                                end;
                              ListMalii  := ListMalii + ',' + PArmeBonus.Libelle;
                            end;
                        end;
                    end;
                  FabricationDetail(PersonnageEquipement.QualiteEquipement, ListMalii, FabricationBonii);
                  PdfPage.WriteText(132,121-(NbArme*5), ListMalii);
                end;
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end

          else if ((ArmureSet = false) and (PersonnageEquipement.TypeEquipement = TypeEquipAR)) or
                  ((ArmureSet = true)  and (PersonnageEquipement.TypeEquipement = TypeEquipARS)) then
            // gérer les armures
            begin
              if PersonnageEquipement.TypeEquipement = TypeEquipAR then
                begin
                  PArmure   := ChercheArmure(PersonnageEquipement.CodeEquipement);
                  Enc       := PArmure.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                end
              else
                begin
                  PArmureSimplifiee   := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
                  Enc                 := PArmureSimplifiee.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                end;

              EncP      := Enc;
              if EncP > 0 then
                EncP    := EncP - 1;
              EncArmure := EncArmure + EncP;
              NbLoca    := CountOccurrences(PArmure.Emplacement,',') + 1;
              if PersonnageEquipement.TypeEquipement = TypeEquipAR then
                For IndLoca := 1 to NbLoca do
                  begin
                    LocData := ExtractChaine(',',PArmure.Emplacement,IndLoca);
                    case LocData of
                      BonusBras:   ArmureBras  := ArmureBras  + PArmure.Protection;
                      BonusCorps:  ArmureCorps := ArmureCorps + PArmure.Protection;
                      BonusJambes: ArmureJambe := ArmureJambe + PArmure.Protection;
                      BonusTete:   ArmureTete  := ArmureTete  + PArmure.Protection;
                    end;
                  end
              else
                begin
                  ArmureBras  := ArmureBras  + PArmureSimplifiee.Protection;
                  ArmureCorps := ArmureCorps + PArmureSimplifiee.Protection;
                  ArmureJambe := ArmureJambe + PArmureSimplifiee.Protection;
                  ArmureTete  := ArmureTete  + PArmureSimplifiee.Protection;
                end;

              Inc(NBArmure);
              if PersonnageEquipement.TypeEquipement = TypeEquipAR then
                begin
                  PdfEcrit(PdfPage,18,52,255-(NbArmure*5), Parmure.Libelle+Quality,MinPolice);
                  PdfPage.WriteText(52,255-(NbArmure*5), GetAllTexteLibelle(PArmure.Emplacement));
                  PdfPage.WriteText(83.5,255-(NbArmure*5), IntToStr(PArmure.Protection));
                  LigneBonus := PArmure.Listebonus;
                end
              else
                begin
                  PdfEcrit(PdfPage,18,52,255-(NbArmure*5), ParmureSimplifiee.Libelle+Quality,MinPolice);
                  PdfPage.WriteText(83.5,255-(NbArmure*5), IntToStr(PArmureSimplifiee.Protection));
                  LigneBonus := PArmureSimplifiee.Listebonus;
                end;
              if Enc <> 0 then
                if EncP <> Enc then
                  PdfPage.WriteText(73,255-(NbArmure*5), IntToStr(EncP)+ '('+IntToStr(Enc)+')')
                else
                  PdfPage.WriteText(73,255-(NbArmure*5), IntToStr(Enc));
              if (PersonnageEquipement.TypeEquipement = TypeEquipAR) and (PArmure.ListeBonus <> '') and (PArmure.ListeBonus <> '-') or
                 (PersonnageEquipement.TypeEquipement = TypeEquipARS) and (PArmureSimplifiee.ListeBonus <> '') and (PArmureSimplifiee.ListeBonus <> '-') then
                begin
                  if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                    NbLoca  := CountOccurrences(PArmure.ListeBonus,',') + 1
                  else
                    NbLoca  := CountOccurrences(PArmureSimplifiee.ListeBonus,',') + 1;
                  for IndLoca := 1 to NbLoca do
                    begin
                      if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                        LocData := ExtractChaine(',',PArmure.ListeBonus,IndLoca)
                      else
                        LocData := ExtractChaine(',',PArmureSimplifiee.ListeBonus,IndLoca);
                      if pos(' ',LocData) <> 0 then
                        LocData := copy(LocData,1,Length(LocData)-2);
                      PArmureBonus := ChercheArmureBonus(LocData);
                      LigneBonus := StringReplace(LigneBonus, LocData, PArmureBonus.Libelle, [rfReplaceAll]);
                      if pos(LocData, ArmureBonii) = 0 then
                        begin
                          if ArmureBonii <> '' then
                           ArmureBonii := ArmureBonii + ',';
                          ArmureBonii := ArmureBonii + LocData;
                        end;
                    end;
                end;
              FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);
              PdfPage.WriteText(90,255-(NbArmure*5), LigneBonus);
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end

          else if (PersonnageEquipement.TypeEquipement = TypeEquipDI) then
            // gérer les divers
            begin
              Inc(IndDivers);
              PdfEcrit(PdfPage,18,65,212-(IndDivers*3.5), PersonnageEquipement.CodeEquipement,MinPolice);
            end

          else if PersonnageEquipement.TypeEquipement = TypeEquipSp then
            begin
              // gérer les sorts
              Inc(NbSort);
              PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
              PdfEcrit (PdfPage, 18   , 59.5,71.5-(NbSort*5), PSort.Libelle, MinPolice);
              PdfCentre(PdfPage, 59.5 , 73  ,71.5-(NbSort*5), PSort.Niveau);
              PdfCentre(PdfPage, 73   , 85.5,71.5-(NbSort*5), PdfPersonnageRemplaceBonus(Personnage, PSort.Portee));
              PdfCentre(PdfPage, 85.5 ,100  ,71.5-(NbSort*5), PdfPersonnageRemplaceBonus(Personnage, PSort.Cible));
              PdfCentre(PdfPage,101   ,117  ,71.5-(NbSort*5), PdfPersonnageRemplaceBonus(Personnage, PSort.Duree));
              PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
            end;
      end;

    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);

    NbBonus := 0;
    if ArmureBonii <> '' then
      begin
        NbLoca := CountOccurrences(ArmureBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData      := ExtractChaine(',',ArmureBonii,IndLoca);
            PArmureBonus := ChercheArmureBonus(LocData);
            TxtBonus     := PArmureBonus.Libelle+':'+PArmureBonus.Malus;
            PdfPage.WriteText(15,133+(NbBonus*2), TxtBonus);
          end;
        Inc(NbBonus);
        PdfPage.WriteText(15,133+(NbBonus*2), ' --------- ' + GetTexteLibelle('LAB_122') + ' --------- ');
      end;

    if ArmeBonii <> '' then
      begin
        NbLoca := CountOccurrences(ArmeBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',ArmeBonii,IndLoca);
            PArmeBonus  := ChercheArmeBonus(LocData);
            TxtBonus    := PArmeBonus.Libelle+':'+PArmeBonus.Resume;
            PdfPage.WriteText(15,133+(NbBonus*2), TxtBonus);
          end;
        Inc(NbBonus);
        PdfPage.WriteText(15,133+(NbBonus*2), ' ---------- ' + GetTexteLibelle('LAB_123') + ' ---------- ');
      end;

    if FabricationBonii <> '' then
      begin
        NbLoca := CountOccurrences(FabricationBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',FabricationBonii,IndLoca);
            PFabrication:= ChercheFabrication(LocData);
            TxtBonus    := PFabrication.Libelle+':'+PFabrication.Resume;
            PdfPage.WriteText(15,133+(NbBonus*2), TxtBonus);
          end;
        Inc(NbBonus);
        PdfPage.WriteText(15,133+(NbBonus*2), ' ---------- ' + GetTexteLibelle('LAB_124') + ' ---------- ');
      end;

    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);

    PdfPage.WriteText(126,163, IntToStr(EncArmure));
    PdfPage.WriteText(126,157, IntToStr(EncArme));
    PdfPage.WriteText(126,137.5, IntToStr(EncArme + EncArmure));

    if ArmureBouclier > 0 then
      PdfPage.WriteText(145, 190, IntToStr(ArmureBouclier));
    if ArmureJambe > 0 then
     begin
      PdfPage.WriteText(145, 207.5, IntToStr(ArmureJambe));
      PdfPage.WriteText(184.5, 195.5, IntToStr(ArmureJambe));
     end;
    if ArmureBras > 0 then
     begin
      PdfPage.WriteText(145, 229, IntToStr(ArmureBras));
      PdfPage.WriteText(184.5, 241, IntToStr(ArmureBras));
     end;
    if ArmureTete > 0 then
      PdfPage.WriteText(145, 250, IntToStr(Armuretete));
    if ArmureCorps > 0 then
     PdfPage.WriteText(184.5, 219.5, IntToStr(ArmureCorps));

    PDFDoc.SaveToFile(PdfChemin);
    PDFDoc.Free;

    OpenDocument(PdfChemin);
  end;

Function PdfPersonnageTalentBonus(Personnage: StructurePersonnage; CodeTalent: String): String;
var
  Indice: Integer;
  Bonus:  String = '';
begin
  For Indice := 0 to high(Personnage.CreationTalent) do
    if CompareRechercheValeur(Personnage.CreationTalent[Indice].CodeTalent, CodeTalent) then
      if Personnage.CreationTalent[Indice].Asterisque <> 0 then
        Bonus := '(' + IntToStr(Personnage.CreationTalent[Indice].Asterisque) + ')';

  For Indice := 0 to high(Personnage.AugmentationTalent) do
    if CompareRechercheValeur(Personnage.AugmentationTalent[Indice].CodeTalent, CodeTalent) then
      if Personnage.AugmentationTalent[Indice].Asterisque <> 0 then
        Bonus := '(' + IntToStr(Personnage.AugmentationTalent[Indice].Asterisque) + ')';

  Result := Bonus;
end;


Function PdfPersonnageCompetenceBonus(Personnage: StructurePersonnage; CodeCompetence: String): String;
var
  Indice: Integer;
  Bonus:  String = '';
begin
  For Indice := 0 to high(Personnage.CreationCompetence35) do
    if CompareRechercheValeur(Personnage.CreationCompetence35[Indice].CodeCompetence, CodeCompetence) then
      if Personnage.CreationCompetence35[Indice].Bonus <> '' then
        if CountOccurrences(Personnage.CreationCompetence35[Indice].Bonus, Bonus) = 0 then
          begin
            if Bonus <> '' then
              Bonus += '-';
            Bonus += Personnage.CreationCompetence35[Indice].Bonus;
          end;

  For Indice := 0 to high(Personnage.CreationCompetence40) do
    if CompareRechercheValeur(Personnage.CreationCompetence40[Indice].CodeCompetence, CodeCompetence) then
      if Personnage.CreationCompetence40[Indice].Bonus <> '' then
        if CountOccurrences(Personnage.CreationCompetence40[Indice].Bonus, Bonus) = 0 then
          begin
            if Bonus <> '' then
              Bonus += '-';
            Bonus += Personnage.CreationCompetence40[Indice].Bonus;
          end;

  For Indice := 0 to high(Personnage.AugmentationCompetence) do
    if CompareRechercheValeur(Personnage.AugmentationCompetence[Indice].CodeCompetence, CodeCompetence) then
      if Personnage.AugmentationCompetence[indice].Bonus <> '' then
        if CountOccurrences(Personnage.AugmentationCompetence[Indice].Bonus, Bonus) = 0 then
          begin
            if Bonus <> '' then
              Bonus += '-';
            Bonus += Personnage.AugmentationCompetence[Indice].Bonus;
          end;

  Result := Bonus;
end;

// Dessine le cadre partagé Résilience/Destin (4 lignes de haut, de X à X+78) et le contenu
// du côté Résilience (colonnes X à X+40). Dans le gabarit Feldo2P, Résilience et Destin
// occupent physiquement UNE SEULE boîte, avec des séparateurs internes de hauteurs
// différentes (celui à X+40 ne descend pas jusqu'à la dernière ligne, celui à X+69 saute
// la ligne de titre) — les reproduire depuis deux cadres indépendants aurait changé le
// rendu (traits en double ou manquants). C'est pourquoi le cadre est dessiné ici en entier ;
// PdfBlocDestin ne dessine que son texte/ses valeurs. À revoir si on veut un jour deux
// tableaux vraiment indépendants (cf. CONTEXT.md §2.4).
//
// NbLignesPourSuite reproduit la valeur que la boucle "for IndC := 0 to DessinNbLigRes"
// laissait dans IndC après son exécution (NbLignes + 1), utilisée par le bloc
// Expérience pour calculer sa position de départ. Valeur préservée telle quelle pour ne
// rien changer visuellement ; à vérifier si ce "+1" est voulu ou un héritage accidentel
// avant de la retoucher plus tard.
//
// NbLignes/HauteurLigne remplacent les anciennes constantes locales DessinNbLigRes/
// DessinHauteurRes de PdfPersonnageCreationFeldo2P (hors de portée dans une procédure
// séparée) — l'appelant continue de passer ses valeurs actuelles (4 et 4.4), donc rien
// ne change au rendu.
Procedure PdfBlocResilience(PdfPage: TPDFPage; Personnage: StructurePersonnage; X, Y: Single; NbLignes: Integer; HauteurLigne: Single; MinPolice: Integer; Determine: Integer; out NbLignesPourSuite: Integer);
  var
    IndC:           Integer;
    Bonus:          String;
    AttributDonnee: StructureDonnee;
  begin
    // Dessin (cadre partagé Résilience + Destin)
    PdfPage.DrawLine( X,      Y,                    X,      Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine( X+29.9, Y - HauteurLigne,      X+29.9, Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine( X+40,   Y,                     X+40,   Y - ((NbLignes-1) * HauteurLigne), 1);
    PdfPage.DrawLine( X+69,   Y - HauteurLigne,      X+69,   Y - ((NbLignes-1) * HauteurLigne), 1);
    PdfPage.DrawLine( X+78,   Y,                     X+78,   Y - (NbLignes * HauteurLigne), 1);
    for IndC := 0 to NbLignes do
      PdfPage.DrawLine(X, Y - (IndC * HauteurLigne), X+78, Y - (IndC * HauteurLigne), 1);

    // Texte Résilience
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, X+2, X+42, Y - (1 * HauteurLigne) + 1, GetTexteLibelle('PDF_RESIL1_RESILIENCE'));
    PdfEcrit (PdfPage, X+2, X+42, Y - (2 * HauteurLigne) + 1, GetTexteLibelle('PDF_RESIL2A_RESILIENCE'), MinPolice);
    PdfEcrit (PdfPage, X+2, X+42, Y - (3 * HauteurLigne) + 1, GetTexteLibelle('PDF_RESIL2B_RESOLVE'),    MinPolice);
    PdfEcrit (PdfPage, X+2, X+49, Y - (NbLignes * HauteurLigne) + 1, GetTexteLibelle('PDF_RESIL2C_MOTIVATION'), MinPolice);

    // Valeur Résilience
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracResil, Bonus);
    PdfCentre(PdfPage, X+30, X+40, Y - (2 * HauteurLigne) + 1, IntToStr(AttributDonnee.Total));   // Résilience
    PdfCentre(PdfPage, X+30, X+40, Y - (3 * HauteurLigne) + 1, IntToStr(Determine));              // Détermination

    NbLignesPourSuite := NbLignes + 1;
  end;

// Dessine le contenu (texte + valeurs) du côté Destin de la boîte Résilience/Destin.
// Ne dessine aucun cadre : il est entièrement à la charge de PdfBlocResilience (voir son
// commentaire). XGauche doit correspondre au X+40 utilisé pour appeler PdfBlocResilience
// juste avant (le bord commun entre les deux zones). HauteurLigne remplace l'ancienne
// constante locale DessinHauteurDes (même valeur, 4.4, passée par l'appelant).
Procedure PdfBlocDestin(PdfPage: TPDFPage; Personnage: StructurePersonnage; XGauche, Y: Single; HauteurLigne: Single; MinPolice: Integer; Chance: Integer);
  var
    Bonus:          String;
    AttributDonnee: StructureDonnee;
  begin
    // Texte Destin
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, XGauche+2,  XGauche+38, Y - (1 * HauteurLigne) + 1, GetTexteLibelle('PDF_FATE1_FATE'));
    PdfEcrit (PdfPage, XGauche+2,  XGauche+29, Y - (2 * HauteurLigne) + 1, GetTexteLibelle('PDF_FATE2_FATE'),    MinPolice);
    PdfEcrit (PdfPage, XGauche+2,  XGauche+29, Y - (3 * HauteurLigne) + 1, GetTexteLibelle('PDF_FATE3_FORTUNE'), MinPolice);

    // Valeur Destin
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    AttributDonnee := PdfPersonnageAttribut(Personnage, ConstCaracDestin, Bonus);
    PdfCentre(PdfPage, XGauche+29, XGauche+38, Y - (2 * HauteurLigne) + 1, IntToStr(AttributDonnee.Total));  // Destin
    PdfCentre(PdfPage, XGauche+29, XGauche+38, Y - (3 * HauteurLigne) + 1, IntToStr(Chance));                // Chance
  end;

// Dessine le panneau Entête (extrait de PdfPersonnageCreationFeldo2P, CONTEXT.md §2.4).
// Cadre à colonnes irrégulières : les séparateurs verticaux internes (52/82/114) ne sont pas
// les mêmes d'une ligne à l'autre (voir les conditions IndC = 4 / IndC <> 3 / IndC <> 2
// ci-dessous, reprises telles quelles de l'ancien code). XGauche/XDroite sont les bords du
// cadre, Y son sommet, HauteurLigne la hauteur d'une ligne et NbLignes son nombre de lignes.
Function PdfBlocEntete(PdfPage: TPDFPage; Personnage: StructurePersonnage; PRace: StructureRace; PMetier: StructureMetier; PMetierNiveau: StructureMetierNiveau; LocData: String; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer): Single;
  var
    IndC: Integer;
  begin
    // Dessin cadre
    PdfPage.DrawLine(XGauche, Y, XGauche, Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XDroite, Y, XDroite, Y - (NbLignes * HauteurLigne), 1);
    for IndC := 0 to NbLignes do
      begin
        PdfPage.DrawLine(XGauche, Y - (IndC * HauteurLigne), XDroite, Y - (IndC * HauteurLigne), 1);
        if IndC > 0 then
          begin
            if IndC = 4  then PdfPage.DrawLine( 52, Y - ((IndC-1) * HauteurLigne),  52, Y - (IndC * HauteurLigne), 1);
            if IndC <> 3 then PdfPage.DrawLine( 77, Y - ((IndC-1) * HauteurLigne),  77, Y - (IndC * HauteurLigne), 1);
            if IndC <> 2 then PdfPage.DrawLine(114, Y - ((IndC-1) * HauteurLigne), 114, Y - (IndC * HauteurLigne), 1);
          end;
      end;

    // Texte Entête
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfPage.WriteText( 21, Y - (HauteurLigne * 1) + 1, GetTexteLibelle('PDF_MAIN1_NAME'));
    PdfPage.WriteText( 78, Y - (HauteurLigne * 1) + 1, GetTexteLibelle('PDF_MAIN1_SPECIES'));
    PdfPage.WriteText(115, Y - (HauteurLigne * 1) + 1, GetTexteLibelle('PDF_MAIN1_CLASS'));
    PdfPage.WriteText( 21, Y - (HauteurLigne * 2) + 1, GetTexteLibelle('PDF_MAIN2_CAREER'));
    PdfPage.WriteText( 78, Y - (HauteurLigne * 2) + 1, GetTexteLibelle('PDF_MAIN2_CAREERLEVEL'));
    PdfPage.WriteText( 21, Y - (HauteurLigne * 3) + 1, GetTexteLibelle('PDF_MAIN3_CAREERPATH'));
    PdfPage.WriteText(115, Y - (HauteurLigne * 3) + 1, GetTexteLibelle('PDF_MAIN3_STATUS'));
    PdfPage.WriteText( 21, Y - (HauteurLigne * 4) + 1, GetTexteLibelle('PDF_MAIN4_AGE'));
    PdfPage.WriteText( 53, Y - (HauteurLigne * 4) + 1, GetTexteLibelle('PDF_MAIN4_HEIGHT'));
    PdfPage.WriteText( 78, Y - (HauteurLigne * 4) + 1, GetTexteLibelle('PDF_MAIN4_HAIR'));
    PdfPage.WriteText(115, Y - (HauteurLigne * 4) + 1, GetTexteLibelle('PDF_MAIN4_EYES'));

    // Valeur Entête
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfEcrit(PdfPage,  32,  86, Y - (HauteurLigne * 1) + 1, Personnage.NomPersonnage, MinPolice);
    PdfEcrit(PdfPage,  89, 115, Y - (HauteurLigne * 1) + 1, PRace.Libelle, MinPolice);
    PdfEcrit(PdfPage, 126, XDroite, Y - (HauteurLigne * 1) + 1, GetTexteLibelle(PMetier.LibelleGroupe), MinPolice);
    PdfEcrit(PdfPage,  32,  85, Y - (HauteurLigne * 2) + 1, PMetier.Libelle, MinPolice);
    PdfEcrit(PdfPage,  95, XDroite, Y - (HauteurLigne * 2) + 1, IntToStr(Personnage.MetierEnCours.NiveauMetier)+' - '+ PMetierNiveau.Libelle, MinPolice);
    PdfEcrit(PdfPage,  50, XDroite, Y - (HauteurLigne * 3) + 1, LocData, MinPolice);
    PdfEcrit(PdfPage, 125, XDroite, Y - (HauteurLigne * 3) + 1, GetTexteLibelle(PMetierNiveau.SalaireMetier, '', ' '), MinPolice);
    PdfEcrit(PdfPage,  32,  53, Y - (HauteurLigne * 4) + 1, IntToStr(Personnage.Age), MinPolice);
    PdfEcrit(PdfPage,  63,  78, Y - (HauteurLigne * 4) + 1, IntToStr(Personnage.Height), MinPolice);
    PdfEcrit(PdfPage,  98, 115, Y - (HauteurLigne * 4) + 1, Personnage.HairColors, MinPolice);
    PdfEcrit(PdfPage, 125, XDroite, Y - (HauteurLigne * 4) + 1, Personnage.EyeColors, MinPolice);

    Result := Y - (NbLignes * HauteurLigne);
  end;

// Dessine le panneau Ambitions (extrait de PdfPersonnageCreationFeldo2P, CONTEXT.md §2.4).
// XGauche+19.9 remplace l'ancienne constante absolue 39.9 (= 20 + 19.9, avec 20 = l'ancien
// DessinDebColG) pour que le bloc ne connaisse que son coin de départ.
Function PdfBlocAmbitions(PdfPage: TPDFPage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer): Single;
  var
    IndC: Integer;
  begin
    // Dessin cadre
    PdfPage.DrawLine(XGauche,        Y,                 XGauche,        Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XGauche + 19.9, Y - HauteurLigne,   XGauche + 19.9, Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XDroite,        Y,                 XDroite,        Y - (NbLignes * HauteurLigne), 1);
    for IndC := 0 to NbLignes do
      PdfPage.DrawLine(XGauche, Y - (IndC * HauteurLigne), XDroite, Y - (IndC * HauteurLigne), 1);

    // Texte Ambitions
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, XGauche + 2, XDroite,        Y - (1 * HauteurLigne) + 1, GetTexteLibelle('PDF_AMBITION1_AMBITIONS'));
    PdfEcrit (PdfPage, XGauche + 2, XGauche + 19.9, Y - (2 * HauteurLigne) + 1, GetTexteLibelle('PDF_AMBITION2A_SHORT')+GetTexteLibelle('PDF_AMBITION2B_SHORT'), MinPolice);
    PdfEcrit (PdfPage, XGauche + 2, XGauche + 19.9, Y - (3 * HauteurLigne) + 1, GetTexteLibelle('PDF_AMBITION3A_LONG')+GetTexteLibelle('PDF_AMBITION3B_LONG'), MinPolice);

    Result := Y - (NbLignes * HauteurLigne);
  end;

// Dessine le panneau Expérience (titre + Total/Utilisé/Restant). Extrait de
// PdfPersonnageCreationFeldo2P, CONTEXT.md §2.4.
Function PdfBlocExperience(PdfPage: TPDFPage; Personnage: StructurePersonnage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer): Single;
  var
    IndC: Integer;
  begin
    // Dessin cadre
    PdfPage.DrawLine(XGauche,      Y,                 XGauche,      Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XGauche + 15, Y - HauteurLigne,   XGauche + 15, Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XDroite,      Y,                 XDroite,      Y - (NbLignes * HauteurLigne), 1);
    for IndC := 0 to NbLignes do
      PdfPage.DrawLine(XGauche, Y - (IndC * HauteurLigne), XDroite, Y - (IndC * HauteurLigne), 1);

    // Texte Expérience
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, XGauche + 1, XDroite,      Y - ((NbLignes - 3) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_XP1_EXPERIENCE'));
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 2) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_XP2C_TOTAL')  , MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 1) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_XP2B_SPENT') , MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ( NbLignes      * HauteurLigne) + 0.6, GetTexteLibelle('PDF_XP2A_CURRENT'), MinPolice);

    // Valeur Expérience
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 2) * HauteurLigne) + 0.6, IntToStr(Trunc(Personnage.Xp25Total)));                       // Total Xp
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 1) * HauteurLigne) + 0.6, IntToStr(Trunc(Personnage.Xp25Total - Personnage.XpActuel))); // Utilisé
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ( NbLignes      * HauteurLigne) + 0.6, IntToStr(Trunc(Personnage.XpActuel)));                        // Restant

    Result := Y - (NbLignes * HauteurLigne);
  end;

// Dessine le panneau Mouvement (titre + Mouvement/Marche/Course). Extrait de
// PdfPersonnageCreationFeldo2P, CONTEXT.md §2.4.
Function PdfBlocMouvement(PdfPage: TPDFPage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer; Mouv, BonusSprint: Integer): Single;
  var
    IndC: Integer;
  begin
    // Dessin cadre
    PdfPage.DrawLine(XGauche,      Y,                 XGauche,      Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XGauche + 15, Y - HauteurLigne,   XGauche + 15, Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XDroite,      Y,                 XDroite,      Y - (NbLignes * HauteurLigne), 1);
    for IndC := 0 to NbLignes do
      PdfPage.DrawLine(XGauche, Y - (IndC * HauteurLigne), XDroite, Y - (IndC * HauteurLigne), 1);

    // Texte Mouvement
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, XGauche + 1, XDroite,      Y - ((NbLignes - 3) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_MV1_MOVEMENT'));
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 2) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_MV2A_MOVEMENT'), MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 1) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_MV2B_WALK')    , MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ( NbLignes      * HauteurLigne) + 0.6, GetTexteLibelle('PDF_MV2C_RUN')     , MinPolice);

    // Valeur Mouvement
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 2) * HauteurLigne) + 0.6, IntToStr(Mouv));
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 1) * HauteurLigne) + 0.6, IntToStr(Mouv * 2));
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ( NbLignes      * HauteurLigne) + 0.6, IntToStr((Mouv + BonusSprint) * 4));

    Result := Y - (NbLignes * HauteurLigne);
  end;

// Dessine le panneau Corruption (titre + Tolérance/Volonté/Bonus/Total). Extrait de
// PdfPersonnageCreationFeldo2P, CONTEXT.md §2.4.
Function PdfBlocCorruption(PdfPage: TPDFPage; XGauche, XDroite, Y, HauteurLigne: Single; NbLignes: Integer; MinPolice: Integer; BE, BFM, AmePure: Integer): Single;
  var
    IndC: Integer;
  begin
    // Dessin cadre
    PdfPage.DrawLine(XGauche,      Y,                 XGauche,      Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XGauche + 15, Y - HauteurLigne,   XGauche + 15, Y - (NbLignes * HauteurLigne), 1);
    PdfPage.DrawLine(XDroite,      Y,                 XDroite,      Y - (NbLignes * HauteurLigne), 1);
    for IndC := 0 to NbLignes do
      PdfPage.DrawLine(XGauche, Y - (IndC * HauteurLigne), XDroite, Y - (IndC * HauteurLigne), 1);

    // Texte Corruption
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, XGauche + 1, XDroite,      Y - ((NbLignes - 4) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_CORRUPTION_TITLE'));
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 3) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_CORRUPTION_T')    , MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 2) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_CORRUPTION_WP')   , MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ((NbLignes - 1) * HauteurLigne) + 0.6, GetTexteLibelle('PDF_CORRUPTION_BONUS'), MinPolice);
    PdfEcrit (PdfPage, XGauche + 1, XGauche + 15, Y - ( NbLignes      * HauteurLigne) + 0.6, GetTexteLibelle('PDF_CORRUPTION_TOTAL'), MinPolice);

    // Valeur Corruption
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 3) * HauteurLigne) + 0.6, IntToStr(Floor(BE/10)));
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 2) * HauteurLigne) + 0.6, IntToStr(Floor(BFM/10)));
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ((NbLignes - 1) * HauteurLigne) + 0.6, IntToStr(AmePure));
    PdfCentre(PdfPage, XGauche + 15, XDroite, Y - ( NbLignes      * HauteurLigne) + 0.6, IntToStr(Floor(BE/10) + Floor(BFM/10) + AmePure));

    Result := Y - (NbLignes * HauteurLigne);
  end;

// Cherche la valeur du champ nommé Champ dans Enr. Renvoie une case vide (Valeur = '') si le
// champ n'existe pas dans cet enregistrement, plutôt qu'une erreur : cela permet à une
// préparation de ne pas renseigner un champ non pertinent pour une entrée donnée.
Function PdfChercheValeurChamp(const Enr: TPdfEnregistrement; const Champ: String): TPdfValeurCase;
  var
    Ind: Integer;
  begin
    Result.Champ      := Champ;
    Result.Valeur     := '';
    Result.Grise      := False;
    Result.Annotation := '';
    for Ind := 0 to High(Enr.Valeurs) do
      if Enr.Valeurs[Ind].Champ = Champ then
        begin
          Result := Enr.Valeurs[Ind];
          break;
        end;
  end;

Function DessinerTableau(PdfPage: TPDFPage; const Tableau: TPdfTableau; const Donnees: TPdfRecordSet): Single;
  var
    NbEntrees, NbChamps, IndE, IndC: Integer;
    XFinTableau, XCol, YHautLigne:   Single;
    ValeurCase:                      TPdfValeurCase;
    // orLigne uniquement
    XPos:           array of Single;
    NbLignesEntete: Integer;
    NbLignesTotal:  Integer;
    LigneCourante:  Integer;
    YEntete, YDonnee, XDroite: Single;
    Fusionne:       Boolean;

  // Choisit la police d'une case selon son style explicite (ValeurCase.Style) ou, à défaut,
  // celui de sa colonne (Colonne.EnTete). Partagée par les deux orientations.
  Procedure AppliquerStylePolice(const Colonne: TPdfColonne; const Valeur: TPdfValeurCase);
    var
      Style: TPdfStylePolice;
    begin
      Style := Valeur.Style;
      if (Style = spValeur) and Colonne.EnTete then
        Style := spEnTete;
      case Style of
        spEnTete: PdfTaillePolice(PdfPage, PdfFontBack,  ConstPoliceCarlson+ConstPoliceGras, 10);
        spAccent: PdfTaillePolice(PdfPage, PdfFontBold,  ConstPoliceArial+ConstPoliceGras,     8);
        else      PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, Tableau.Police);
      end;
    end;

  begin
    NbEntrees := Length(Donnees);
    NbChamps  := Length(Tableau.Champs);

    if Tableau.Orientation = orColonne then
      begin
        XFinTableau := Tableau.X + Tableau.LargeurLibelles + (NbEntrees * Tableau.LargeurEntree);

        // Cadre
        PdfPage.DrawLine(Tableau.X, Tableau.Y, XFinTableau, Tableau.Y, 1);
        PdfPage.DrawLine(Tableau.X, Tableau.Y, Tableau.X, Tableau.Y - (NbChamps * Tableau.HauteurLigne), 1);
        for IndE := 0 to NbEntrees do
          begin
            XCol := Tableau.X + Tableau.LargeurLibelles + (IndE * Tableau.LargeurEntree);
            PdfPage.DrawLine(XCol, Tableau.Y, XCol, Tableau.Y - (NbChamps * Tableau.HauteurLigne), 1);
          end;
        for IndC := 0 to NbChamps do
          PdfPage.DrawLine(Tableau.X, Tableau.Y - (IndC * Tableau.HauteurLigne), XFinTableau, Tableau.Y - (IndC * Tableau.HauteurLigne), 1);

        // Bande de libellés (à gauche)
        PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
        for IndC := 0 to NbChamps - 1 do
          PdfCentre(PdfPage, Tableau.X, Tableau.X + Tableau.LargeurLibelles, Tableau.Y - ((IndC+1) * Tableau.HauteurLigne) + 1, Tableau.Champs[IndC].Libelle);

        // Valeurs (une colonne par entrée)
        for IndE := 0 to NbEntrees - 1 do
          for IndC := 0 to NbChamps - 1 do
            begin
              ValeurCase := PdfChercheValeurChamp(Donnees[IndE], Tableau.Champs[IndC].Champ);
              if ValeurCase.Valeur = '' then
                continue;

              AppliquerStylePolice(Tableau.Champs[IndC], ValeurCase);

              if ValeurCase.Grise then
                PdfPage.SetColor(RGB(150,150,150), False);

              XCol := Tableau.X + Tableau.LargeurLibelles + (IndE * Tableau.LargeurEntree);
              PdfCentre(PdfPage, XCol, XCol + Tableau.LargeurEntree, Tableau.Y - ((IndC+1) * Tableau.HauteurLigne) + 1, ValeurCase.Valeur);

              if ValeurCase.Grise then
                PdfPage.SetColor(clBlack, False);

              if ValeurCase.Annotation <> '' then
                begin
                  YHautLigne := Tableau.Y - (IndC * Tableau.HauteurLigne);
                  PdfEcrit(PdfPage, XCol + (Tableau.LargeurEntree * 0.5) + 0.75, XCol + Tableau.LargeurEntree + 0.75, YHautLigne + 3, ValeurCase.Annotation, 4);
                end;
            end;

        Result := Tableau.Y - (NbChamps * Tableau.HauteurLigne);
      end
    else // orLigne
      begin
        // Positions X cumulées : largeur propre par colonne (Champs[i].Largeur) si
        // renseignée, sinon largeur par défaut du tableau.
        SetLength(XPos, NbChamps + 1);
        XPos[0] := Tableau.X;
        for IndC := 0 to NbChamps - 1 do
          if Tableau.Champs[IndC].Largeur > 0 then
            XPos[IndC+1] := XPos[IndC] + Tableau.Champs[IndC].Largeur
          else
            XPos[IndC+1] := XPos[IndC] + Tableau.LargeurEntree;
        XFinTableau := XPos[NbChamps];

        NbLignesEntete := 1;
        if Tableau.Titre <> '' then
          NbLignesEntete := NbLignesEntete + 1;
        // Le cadre peut avoir une capacité fixe supérieure au nombre d'entrées fournies
        // (NbLignesMax) ; les lignes au-delà de NbEntrees restent alors vides (grille sans
        // texte), seul le cadre est dessiné sur toute la capacité.
        if Tableau.NbLignesMax > 0 then
          NbLignesTotal := NbLignesEntete + Tableau.NbLignesMax
        else
          NbLignesTotal := NbLignesEntete + NbEntrees;

        // Cadre horizontal (toutes les lignes, pleine largeur)
        for IndC := 0 to NbLignesTotal do
          PdfPage.DrawLine(Tableau.X, Tableau.Y - (IndC * Tableau.HauteurLigne), XFinTableau, Tableau.Y - (IndC * Tableau.HauteurLigne), 1);

        // Cadre vertical : les bords extérieurs (0 et NbChamps) sont toujours pleine
        // hauteur ; un séparateur intérieur dont la colonne de gauche est "fusionnée avec
        // la suivante" ne descend qu'à partir de la première ligne de données (pour laisser
        // le libellé fusionné chapeauter les deux colonnes sans trait au milieu).
        for IndC := 0 to NbChamps do
          begin
            if (IndC = 0) or (IndC = NbChamps) then
              YHautLigne := Tableau.Y
            else if Tableau.Champs[IndC-1].FusionAvecSuivante then
              YHautLigne := Tableau.Y - (NbLignesEntete * Tableau.HauteurLigne)
            else if Tableau.Titre <> '' then
              YHautLigne := Tableau.Y - Tableau.HauteurLigne
            else
              YHautLigne := Tableau.Y;
            PdfPage.DrawLine(XPos[IndC], YHautLigne, XPos[IndC], Tableau.Y - (NbLignesTotal * Tableau.HauteurLigne), 1);
          end;

        LigneCourante := 0;

        // Titre (bandeau plein largeur, optionnel)
        if Tableau.Titre <> '' then
          begin
            PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
            PdfCentre(PdfPage, Tableau.X + Tableau.TitreDecalageGauche, XFinTableau, Tableau.Y - Tableau.HauteurLigne + 1, Tableau.Titre);
            LigneCourante := 1;
          end;

        // En-têtes de colonnes : une colonne "fusionnée dans" la précédente (i.e. dont la
        // précédente a FusionAvecSuivante) ne dessine rien elle-même, son libellé est porté
        // par la colonne précédente et centré sur la largeur des deux réunies.
        PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
        YEntete := Tableau.Y - ((LigneCourante+1) * Tableau.HauteurLigne) + 1;
        IndC := 0;
        while IndC < NbChamps do
          begin
            Fusionne := (IndC > 0) and Tableau.Champs[IndC-1].FusionAvecSuivante;
            if not Fusionne then
              begin
                if Tableau.Champs[IndC].FusionAvecSuivante then
                  XDroite := XPos[IndC+2]
                else
                  XDroite := XPos[IndC+1];
                if Tableau.Champs[IndC].Libelle <> '' then
                  if Tableau.Champs[IndC].AlignementEntete = alGauche then
                    PdfEcrit(PdfPage, XPos[IndC]+Tableau.Champs[IndC].DecalageEnteteMin, XDroite+Tableau.Champs[IndC].DecalageEnteteMax, YEntete, Tableau.Champs[IndC].Libelle, Tableau.PoliceMin)
                  else
                    PdfCentre(PdfPage, XPos[IndC]+1, XDroite, YEntete, Tableau.Champs[IndC].Libelle);
              end;
            Inc(IndC);
          end;

        // Valeurs (une ligne par entrée)
        for IndE := 0 to NbEntrees - 1 do
          begin
            YDonnee := Tableau.Y - ((NbLignesEntete + IndE + 1) * Tableau.HauteurLigne) + 1;
            for IndC := 0 to NbChamps - 1 do
              begin
                ValeurCase := PdfChercheValeurChamp(Donnees[IndE], Tableau.Champs[IndC].Champ);
                if ValeurCase.Valeur = '' then
                  continue;

                AppliquerStylePolice(Tableau.Champs[IndC], ValeurCase);

                if ValeurCase.Grise then
                  PdfPage.SetColor(RGB(150,150,150), False);

                PdfEcrit(PdfPage, XPos[IndC] + Tableau.Champs[IndC].DecalageValeurMin, XPos[IndC+1] + Tableau.Champs[IndC].DecalageValeurMax, YDonnee, ValeurCase.Valeur, Tableau.PoliceMin);

                if ValeurCase.Grise then
                  PdfPage.SetColor(clBlack, False);

                if ValeurCase.Annotation <> '' then
                  begin
                    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceArial, 6);
                    PdfEcrit(PdfPage, XPos[IndC+1] - 5, XPos[IndC+1] + 3.5, YDonnee + 1, ValeurCase.Annotation, 6);
                  end;
              end;
          end;

        Result := Tableau.Y - (NbLignesTotal * Tableau.HauteurLigne);
      end;
  end;

// Prépare les données du tableau des Caractéristiques (10 entrées = les 10 caractéristiques,
// dans l'ordre StructureAttribut.OrdreAttribut ; 6 champs par entrée : Code, Initial, Improv,
// Advances, Current, Bonus). Aucun dessin ici, uniquement du calcul/lecture de données.
Function PdfPreparerRecordSetCaracteristiques(Personnage: StructurePersonnage; PMetier: StructureMetier): TPdfRecordSet;
  var
    PAttribut:       StructureAttribut;
    PMetierAttribut: StructureMetierAttribut;
    AttributDonnee:  StructureDonnee;
    Bonus:           String;
    Ind:             Integer;
    NiveauMetier:    Integer;
  begin
    SetLength(Result, 10);
    for Ind := 1 to 10 do
      begin
        PAttribut      := ListeAttribut[Ind-1];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);

        SetLength(Result[Ind-1].Valeurs, 6);

        Result[Ind-1].Valeurs[0].Champ  := 'Code';
        Result[Ind-1].Valeurs[0].Valeur := GetTexteLibelle('SHORTATTR_'+ExtractStringAfter(PAttribut.CodeAttribut,'_'));

        Result[Ind-1].Valeurs[1].Champ      := 'Initial';
        Result[Ind-1].Valeurs[1].Valeur     := IntToStr(AttributDonnee.Base);
        Result[Ind-1].Valeurs[1].Annotation := Bonus;

        NiveauMetier := 0;
        For PMetierAttribut in ListMetierAttribut do
          if (PMetierAttribut.CodeMetier = PMetier.CodeMetier)
             and (PMetierAttribut.CodeAttribut = PAttribut.CodeAttribut)
             and (PMetierAttribut.NiveauMetier > 0) then
            begin
              NiveauMetier := PMetierAttribut.NiveauMetier;
              break;
            end;
        Result[Ind-1].Valeurs[2].Champ := 'Improv';
        if NiveauMetier > 0 then
          begin
            Result[Ind-1].Valeurs[2].Valeur := IntToStr(NiveauMetier);
            Result[Ind-1].Valeurs[2].Grise  := (NiveauMetier > Personnage.MetierEnCours.NiveauMetier);
          end;

        Result[Ind-1].Valeurs[3].Champ := 'Advances';
        if AttributDonnee.Augmentation <> 0 then
          Result[Ind-1].Valeurs[3].Valeur := IntToStr(AttributDonnee.Augmentation);

        Result[Ind-1].Valeurs[4].Champ  := 'Current';
        Result[Ind-1].Valeurs[4].Valeur := IntToStr(AttributDonnee.Total);

        Result[Ind-1].Valeurs[5].Champ  := 'Bonus';
        Result[Ind-1].Valeurs[5].Valeur := IntToStr(Trunc(AttributDonnee.Total/10));
      end;
  end;

// Prépare le tableau des compétences de base : une entrée par compétence de ListPage, 6
// champs (Nom, Attribut, Stat, Upg, Adv, Total). Nom et Attribut partagent le même style de
// police par ligne (en-tête, ou "accent" si la compétence appartient au métier en cours) —
// c'est le même calcul que faisait l'ancien code juste avant de dessiner.
Function PdfPreparerRecordSetCompetencesBase(Personnage: StructurePersonnage; PMetier: StructureMetier; ListPage: TStringList; out TotalEsquive, TotalCalme, TotalResitance, TotalCommandement, TotalIntuition: Integer; out ListPris: String): TPdfRecordSet;
  var
    Ind:              Integer;
    Comp:             String;
    PCompetence:      StructureCompetence;
    PAttribut:        StructureAttribut;
    CompetenceDonnee: StructureDonnee;
    NivCompMetier:    Integer;
    ValBonus:         String;
    Bonus:            String;
    StyleLigne:       TPdfStylePolice;
  begin
    TotalEsquive      := 0;
    TotalCalme        := 0;
    TotalResitance    := 0;
    TotalCommandement := 0;
    TotalIntuition    := 0;
    ListPris          := '';

    SetLength(Result, ListPage.Count);
    for Ind := 0 to ListPage.Count - 1 do
      begin
        Comp             := ListPage[Ind];
        PCompetence      := ChercheCompetence(Comp);
        CompetenceDonnee := PdfPersonnageCompetence(Personnage, Comp, NivCompMetier);
        PAttribut        := ChercheAttribut(PCompetence.CodeAttribut);
        ListPris         := ListPris + Separateurtabulation + Comp;

        case Comp of
          ConstCEsquive:      TotalEsquive      := CompetenceDonnee.Total;
          ConstCCalme:        TotalCalme        := CompetenceDonnee.Total;
          ConstCResitance:    TotalResitance    := CompetenceDonnee.Total;
          ConstCCommandement: TotalCommandement := CompetenceDonnee.Total;
          ConstCIntuition:    TotalIntuition    := CompetenceDonnee.Total;
        end;

        ValBonus := IntToStr(CompetenceDonnee.Augmentation);
        if ValBonus = '0' then
          ValBonus := '';
        if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
          ValBonus := '  ' + ValBonus;

        if CompareCompetence(PCompetence.CodeCompetence, PMetier.CodeCompetence) then
          StyleLigne := spAccent
        else
          StyleLigne := spValeur; // colonnes EnTete=True => police d'en-tête par défaut

        Bonus := PdfPersonnageCompetenceBonus(Personnage, Comp);

        SetLength(Result[Ind].Valeurs, 6);

        Result[Ind].Valeurs[0].Champ      := 'Nom';
        Result[Ind].Valeurs[0].Valeur     := PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle);
        Result[Ind].Valeurs[0].Style      := StyleLigne;
        Result[Ind].Valeurs[0].Annotation := Bonus;

        Result[Ind].Valeurs[1].Champ  := 'Attribut';
        Result[Ind].Valeurs[1].Valeur := GetTexteLibelle(PAttribut.Resume);
        Result[Ind].Valeurs[1].Style  := StyleLigne;

        Result[Ind].Valeurs[2].Champ  := 'Stat';
        Result[Ind].Valeurs[2].Valeur := IntToStr(CompetenceDonnee.Base);

        Result[Ind].Valeurs[3].Champ := 'Upg';
        if NivCompMetier > 0 then
          begin
            Result[Ind].Valeurs[3].Valeur := IntToStr(NivCompMetier);
            Result[Ind].Valeurs[3].Grise  := (NivCompMetier > Personnage.MetierEnCours.NiveauMetier);
          end;

        Result[Ind].Valeurs[4].Champ  := 'Adv';
        Result[Ind].Valeurs[4].Valeur := ValBonus;

        Result[Ind].Valeurs[5].Champ  := 'Total';
        Result[Ind].Valeurs[5].Valeur := IntToStr(CompetenceDonnee.Total);
      end;
  end;

Function PdfPreparerRecordSetCompetencesGroupees(Personnage: StructurePersonnage; ListPris: String; CapaciteMax: Integer): TPdfRecordSet;
  var
    Ind:                  Integer;
    NbLigne:              Integer;
    PCompetence:          StructureCompetence;
    PAttribut:            StructureAttribut;
    CompetenceDonnee:     StructureDonnee;
    NivCompMetier:        Integer;
    ValBonus:             String;
    Bonus:                String;
    PersonnageCompetence: StructurePersonnageCompetence;
  begin
    SetLength(Result, 0);
    NbLigne := 0;

    // Passe 1 : compétences groupées déjà augmentées, pas déjà affichées dans le tableau de base
    for Ind := 0 to ListCompetence.Count - 1 do
      begin
        PCompetence := ListCompetence[Ind];
        if pos(PCompetence.CodeCompetence, ListPris) = 0 then
          begin
            CompetenceDonnee := PdfPersonnageCompetence(Personnage, PCompetence.CodeCompetence, NivCompMetier);
            if CompetenceDonnee.Augmentation <> 0 then
              begin
                PAttribut := ChercheAttribut(PCompetence.CodeAttribut);

                ValBonus := IntToStr(CompetenceDonnee.Augmentation);
                if (StrToIntDef(ValBonus,0) >= 0) and (StrToIntDef(ValBonus,0) < 10) then
                  ValBonus := '  ' + ValBonus;

                Bonus := PdfPersonnageCompetenceBonus(Personnage, PCompetence.CodeCompetence);

                SetLength(Result, Length(Result)+1);
                SetLength(Result[High(Result)].Valeurs, 6);

                Result[High(Result)].Valeurs[0].Champ      := 'Nom';
                Result[High(Result)].Valeurs[0].Valeur     := PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle);
                Result[High(Result)].Valeurs[0].Annotation := Bonus;

                Result[High(Result)].Valeurs[1].Champ  := 'Attribut';
                Result[High(Result)].Valeurs[1].Valeur := GetTexteLibelle(PAttribut.Resume);

                Result[High(Result)].Valeurs[2].Champ  := 'Stat';
                Result[High(Result)].Valeurs[2].Valeur := IntToStr(CompetenceDonnee.Base);

                Result[High(Result)].Valeurs[3].Champ := 'Upg';
                if NivCompMetier > 0 then
                  begin
                    Result[High(Result)].Valeurs[3].Valeur := IntToStr(NivCompMetier);
                    Result[High(Result)].Valeurs[3].Grise  := (NivCompMetier > Personnage.MetierEnCours.NiveauMetier);
                  end;

                Result[High(Result)].Valeurs[4].Champ  := 'Adv';
                Result[High(Result)].Valeurs[4].Valeur := ValBonus;

                Result[High(Result)].Valeurs[5].Champ  := 'Total';
                Result[High(Result)].Valeurs[5].Valeur := IntToStr(CompetenceDonnee.Total);

                NbLigne := NbLigne + 1;
              end;
          end;
      end;

    // Passe 2 : compétences accessibles via le métier mais pas augmentées ("non prises"),
    // grisées entièrement, pour combler l'espace restant — plafonnée à CapaciteMax lignes au
    // total, comme le faisait l'ancien code (silencieusement tronqué au-delà).
    for PersonnageCompetence in Personnage.MetierCompetence do
      begin
        CompetenceDonnee := PdfPersonnageCompetence(Personnage, PersonnageCompetence.CodeCompetence, NivCompMetier);
        if (CompetenceDonnee.Augmentation = 0) and (NivCompMetier > 0) then
          if (pos(PersonnageCompetence.CodeCompetence, ListPris) = 0) and (NbLigne < CapaciteMax) then
            begin
              PCompetence := ChercheCompetence(PersonnageCompetence.CodeCompetence);
              PAttribut   := ChercheAttribut(PCompetence.CodeAttribut);

              SetLength(Result, Length(Result)+1);
              SetLength(Result[High(Result)].Valeurs, 4);

              Result[High(Result)].Valeurs[0].Champ  := 'Nom';
              Result[High(Result)].Valeurs[0].Valeur := PdfSupprimeGenerique(PCompetence.CodeCompetence, PCompetence.Libelle);
              Result[High(Result)].Valeurs[0].Grise  := True;

              Result[High(Result)].Valeurs[1].Champ  := 'Attribut';
              Result[High(Result)].Valeurs[1].Valeur := GetTexteLibelle(PAttribut.Resume);
              Result[High(Result)].Valeurs[1].Grise  := True;

              Result[High(Result)].Valeurs[2].Champ  := 'Stat';
              Result[High(Result)].Valeurs[2].Valeur := IntToStr(CompetenceDonnee.Base);
              Result[High(Result)].Valeurs[2].Grise  := True;

              Result[High(Result)].Valeurs[3].Champ  := 'Upg';
              Result[High(Result)].Valeurs[3].Valeur := IntToStr(NivCompMetier);
              Result[High(Result)].Valeurs[3].Grise  := True;
              // Adv/Total : jamais renseignés ici (Augmentation = 0 par construction),
              // comme dans l'ancien code.

              NbLigne := NbLigne + 1;
            end;
      end;
  end;

Procedure PdfPersonnageCreationFeldo2P(Personnage: StructurePersonnage);
  var
    PDFDoc:          TPDFDocument;
    PdfSection:      TPDFSection;
    PdfPage:         TPDFPage;
    PDFOption:       TPDFOptions;
    PdfChemin:       String;
    PRace:           StructureRace;
    PMetier:         StructureMetier;
    PMetierNiveau:   StructureMetierNiveau;
    PRaceAttribut:   StructureRaceAttribut;
    PTalent:         StructureTalent;
    PMetierAttribut: StructureMetierAttribut;
    PMetierTalent:   StructureMetierTalent;
    Mouv:            Integer = 0;
    ListPage:        TStringList;
    Comp:            String;
    PCompetence:     StructureCompetence;
    ValStat:         String;
    ValBonus:        String;
    ValTotal:        String;
    NbLigne:         Integer;
    IndC:            Integer;
    ListPris:        String;
    BF, BE, BFM:     Integer;
    Ch:              String;
    DurACuire:       Integer = 0;
    ValDurACuire:    Integer = 0;
    BonusEncomb:     Integer = 0;
    Enc:             Integer;
    EncP:            Integer;
    PArme:           StructureArme;
    PArmure:         StructureArmure;
    Deg:             Integer;
    Pourcent:        String;
    EncArme:         Integer;
    EncArmure:       Integer;
    ArmureTete:      Integer;
    ArmureBras:      Integer;
    ArmureCorps:     Integer;
    ArmureJambe:     Integer;
    ArmureBouclier:  Integer = 0;
    PosProtection:   SizeInt;
    NbLoca:          Integer;
    IndLoca:         Integer;
    LocData:         String;
    NbArme:          Integer;
    NbArmure:        Integer;
    ArmeBonii:       String = '';
    ArmureBonii:     String = '';
    FabricationBonii:String = '';
    PArmureBonus:    StructureArmureBonus;
    PArmeBonus:      StructureArmeBonus;
    NbBonus:         Integer;
    TxtBonus:        String;
    IndDivers:       Integer = 0;
    PasBonus:        Boolean;
    ListMalii:       String;
    NBSort:          Integer;
    PSort:           StructureSort;
    LigneBonus:      String;
    Ind:             Integer;
    PAttribut:       StructureAttribut;
    PFabrication:    StructureFabrication;
    Quality:         String;
    Portee:          String;
    TexteRange1:     String;
    TexteRange2:     String;
    PorteMoyenne:    Integer;
    Chance:          Integer;
    Determine:       Integer;
    TBonusCC:        Integer=0;
    TBonusCT:        Integer=0;
    Val:             Integer;
    BonusSprint:     Integer=0;
    MinPolice:       Integer=5;
    DernierMetier:   String='';
    PersonnageAttribut:      StructurePersonnageAttribut;
    AttributDonnee:          StructureDonnee;
    CompetenceDonnee:        StructureDonnee;
    PersonnageTalent:        StructurePersonnagetalent;
    TalentDonnee:            StructureDonnee;
    PersonnageEquipement:    StructurePersonnageEquipement;
    PersonnageMetier:        StructurePersonnageMetier;
    PersonnageCompetence:    StructurePersonnageCompetence;
    PArmureSimplifiee:       StructureArmureSimplifiee;
    NivCompMetier:           Integer = 0;
    NivTalMetier:            Integer = 0;
    ListeTalent:             String='';
    bidon:                   Integer=0;
    ArmureSet:               Boolean = false;
    AmePure:                 Integer=0;
    PersonnageXpAttribut:    StructurePersonnageXpAttribut;
    PersonnageXpCompetence:  StructurePersonnageXpCompetence;
    PersonnageXpTalent:      StructurePersonnageXpTalent;
    TotalXpSoustrait:        Integer = 0;
    PAttributAugmentation:   StructureAttributAugmentation;
    PCompetenceAugmentation: StructureCompetenceAugmentation;
    TotalEsquive:            Integer = 0;
    TotalCalme:              Integer = 0;
    TotalResitance:          Integer = 0;
    TotalCommandement:       Integer = 0;
    TotalIntuition:          Integer = 0;
    Bonus:                   String;
    TableauCarac:            TPdfTableau;
    DonneesCarac:            TPdfRecordSet;
    TableauComp:             TPdfTableau;
    DonneesComp:             TPdfRecordSet;
    TableauCompG:            TPdfTableau;
    DonneesCompG:            TPdfRecordSet;

    // Page 1
      // Entête
      DessinFinEntete:      Integer = 143;
      DessinDebColG:        Integer = 20;
      DessinFinColG:        Integer = 98;
      DessinDebColD:        Integer = 102;
      DessinFinColD:        Integer = 188;
      // Colonne gauche
        // Images
        PdfImgWarhammer: Integer;
        PdfImgFantasy:   Integer;
        PdfImgUbersreik: Integer;
        // Entete
        DessinDebutHautEntete:Single  = 285;
        DessinHauteurEntete:  Single  = 4.5;
        DessinNbLigEntete:    Integer = 4;
        // Caractéristiques
        DessinDebutHautCarac: Single;
        DessinHauteurCarac:   Single  = 4.6;
        DessinLargeurCarac:   Single  = 10.3;
        // Compétence
        DessinDebutHautComp:  Single;
        DessinHauteurComp:    Single  = 4.4;
        DessinNbLigComp:      Integer = 28;
        DessinLargeurComp:    Single  = 8.6;
        // Ambition
        DessinDebutHautAmb:   Single;
        DessinHauteurAmb:     Single  = 4.4;
        DessinNbLigAmb:       Integer = 3;
        // Résilience
        DessinDebutHautRes:   Single;
        DessinHauteurRes:     Single  = 4.4;
        DessinNbLigRes:       Integer = 4;
        DessinLargeurBle:     Single;
        // Destin
        DessinDebutHautDes:   Single;
        DessinHauteurDes:     Single  = 4.4;
        // Blessure
        DessinDebutHautBle:   Single;
        DessinDebutGaucheBle: Single;
        DessinHauteurBle:     Single  = 4.6;
        DessinNbLigBle:       Integer = 6;
        // Expérience
        DessinDebutHautExp:   Single;
        DessinHauteurExp:     Single = 4.4;
        DessinNbLigExp:       Integer = 3;
        DessinLargeurExp:     Single = 45;
        // Mouvement
        DessinDebutHautMou:   Single;
        DessinDebutGaucheMou: Single;
        DessinHauteurMou:     Single = 4.4;
        DessinNbLigMou:       Integer = 3;
        DessinLargeurMou:     Single = 22;
        // Corruption
        DessinDebutHautCor:   Single;
        DessinDebutGaucheCor: Single;
        DessinHauteurCor:     Single = 4.4;
        DessinNbLigCor:       Integer = 4;
        DessinLargeurCor:     Single;
      // Colonne droite
        // Compétence Groupée
        DessinDebutHautComg:  Single;
        DessinHauteurComg:    Single  = 4.4;
        DessinNbLigComg:      Integer = 26;
        DessinLargeurComg:    Single  = 9;
        // Talents
        DessinDebutHautTal:   Single;
        DessinHauteurTal:     Single  = 4.4;
        DessinNbLigTal:       Integer = 24;

    // Page 2
      // Armure
        DessinDebutHautArm:   Single;
        DessinHauteurArm:     Single = 4.4;
        DessinNbLigArm:       Integer = 6;
        DessinLargeurArm:     Single = 128;
      // Equipement
        DessinDebutHautEqu:   Single;
        DessinHauteurEqu:     Single = 4.4;
        DessinNbLigEqu:       Integer = 5;
        DessinLargeurEqu:     Single = 128;
      // Armes
        DessinDebutHautWea:   Single;
        DessinHauteurWea:     Single = 4.4;
        DessinNbLigWea:       Integer = 8;
        DessinLargeurWea:     Single = 200;
      // Sorts
        DessinDebutHautSor:   Single;
        DessinHauteurSor:     Single = 4.4;
        DessinNbLigSor:       Integer = 11;
        DessinLargeurSor:     Single = 200;
      // Explications
        DessinHauteurExl:     Single = 2.5;
      // Encombrement
        DessinDebutHautEnc:   Single;
        DessinHauteurEnc:     Single = 4.6;
        DessinNbLigEnc:       Integer = 5;
        DessinLargeurEnc:     Single = 44;
      // Compétence de combat
        DessinDebutHautComC:  Single;
        DessinHauteurComC:    Single = 4.6;
        DessinNbLigComC:      Integer = 5;
        DessinLargeurComC:    Single = 200;
        DessinDebutGaucheComC:Single;


  begin
    PdfChemin        := GetCurrentDir+ConstCheminPersonnage+Personnage.NomPersonnage+'\'+Personnage.NomPersonnage+'.PDF';

    if (Pos(AjouteAccolade(ConstXmlOptionQuickArmor),Personnage.Options) > 0) then
      ArmureSet := True;

    if FileExists(PdfChemin) then
      if not DeleteFile(PdfChemin) then
        begin
          ShowMessage(GetTexteLibelle('MESS_038'));
          exit;
        end;

    PDFDoc          := TPDFDocument.Create(nil);
    PDFOption       := [poUseImageTransparency, poCompressImages, poCompressFonts, poCompressText ];
    PDFDoc.Options  := PDFOption;
    PDFDoc.StartDocument;
    PdfSection      := PDFDoc.Sections.AddSection;

  // PAGE 1
    PdfPage         := PDFDoc.Pages.AddPage;
    PdfFontBack     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'CaslonAntique-Bold.ttf', ConstPoliceCarlson+ConstPoliceGras);
    PdfFontValue    := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'ariali.ttf', ConstPoliceArial);
    PdfFontBold     := PdfDoc.AddFont(GetCurrentDir+ConstCheminImagePolice+'arialbd.ttf', ConstPoliceArial+ConstPoliceGras);

    PdfSection.AddPage(PdfPage);
    PdfPage.PaperType:= ptA4;
    PdfPage.UnitOfMeasure := uomMillimeters;

    PdfImgWarhammer  := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfWarhammer, ConstLangue, ValLangue, [rfReplaceAll]),false);
    PdfPage.DrawImage(152, DessinDebutHautEntete - 5, 36, 5, PdfImgWarhammer);
    PdfImgFantasy    := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfRolePlay, ConstLangue, ValLangue, [rfReplaceAll]),false);
    PdfPage.DrawImage(152, DessinDebutHautEntete - 17, 36, 12, PdfImgFantasy);
    PdfImgUbersreik  := PdfDoc.Images.AddFromFile(GetCurrentDir+StringReplace(ConstCheminPdfUbersreik, ConstLangue, ValLangue, [rfReplaceAll]),false);
    PdfPage.DrawImage(152, DessinDebutHautEntete - 55, 36, 38, PdfImgUbersreik);

    // Paramétrages : liste des compétences de la page 1
    ListPage       := TStringList.Create;

    // gérer les lignes
    // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);

    // Entête
    PRace          := ChercheRace(Personnage.Race);
    LocData        := '';
    for PersonnageMetier in Personnage.MetierAncien do
      begin
        if (DernierMetier <> PersonnageMetier.CodeMetier) then
          begin
            PMetier       := ChercheMetier(PersonnageMetier.CodeMetier);
            if Locdata <> '' then
              LocData     := LocData + ' - ';
            LocData       := LocData + PMetier.Libelle + ':';
            DernierMetier := PersonnageMetier.CodeMetier;
          end
        else if LocData <> '' then
          LocData         := LocData + ',';
         LocData          := LocData + IntToStr(PersonnageMetier.NiveauMetier);
      end;
    PMetier        := ChercheMetier(Personnage.MetierEnCours.CodeMetier);
    PMetierNiveau  := ChercheMetierNiveau(Personnage.MetierEnCours.CodeMetier, Personnage.MetierEnCours.NiveauMetier);
    PRaceAttribut  := ChercheRaceAttribut(Personnage.Race, ConstCaracMouvement);
    Mouv           := StrToInt(PRaceAttribut.CalculRace);

    Chance         := 0;
    Determine      := 0;
    For PRaceAttribut in ListRaceAttribut do
      if ExtractStringAfter(PRaceAttribut.CodeRace, SeparateurChance) = Personnage.Race then
        case ExtractStringAfter(PRaceAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracDestin: Chance    := Chance    + StrToIntDef(PRaceAttribut.CalculRace,0);
          ConstCaracResil:  Determine := Determine + StrToIntDef(PRaceAttribut.CalculRace,0);
        end;
    for PersonnageAttribut in Personnage.CreationAttribut do
      case ExtractStringAfter(PersonnageAttribut.CodeAttribut, SeparateurLivre) of
        ConstCaracDestin: Chance    := Chance    + PersonnageAttribut.Valeur;
        ConstCaracResil:  Determine := Determine + PersonnageAttribut.Valeur;
      end;


    // chercher les Valeur d'attributs
    for Ind := 0 to 9 do
      begin
        PAttribut      := ListeAttribut[Ind];
        AttributDonnee := PdfPersonnageAttribut(Personnage, PAttribut.CodeAttribut, Bonus);
        val            := AttributDonnee.Total;
        case ExtractStringAfter(PAttribut.CodeAttribut, SeparateurLivre) of
          ConstCaracE:  BE  := Val;
          ConstCaracF:  BF  := Val;
          ConstCaracFM: BFM := Val;
        end;
      end;

    // chercher les talents et calculer les bonus correspondants
    BonusEncomb := 0;
    for PersonnageTalent in Personnage.CreationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:
            begin
              ValDurACuire:= Val;
              DurACuire   := Floor(BE/10) * ValDurACuire;
            end;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;
    for PersonnageTalent in Personnage.AugmentationTalent do
      begin
        Val := PersonnageTalent.Valeur;
        case ExtractStringAfter(PersonnageTalent.CodeTalent, SeparateurLivre) of
          TalentDurACuire:
            begin
              ValDurACuire:= Val;
              DurACuire   := Floor(BE/10) * ValDurACuire;
            end;
          TalentCostaud:      BonusEncomb := BonusEncomb + Val * 2;
          TalentVeloce:       Mouv        := Mouv + Val;
          TalentChanceux:     Chance      := Chance  + Val;
          TalentObstine:      Determine   := Determine + Val;
          TalentCoutPuissant: TBonusCC    := Val;
          TalenttirPrecis:    TBonusCT    := Val;
          TalentSprinteur:    BonusSprint := 1;
          TalentAmePure:      AmePure     := Val;
        end;
      end;

    // Paramétrages : liste des compétences
    ListPage       := TStringList.Create;
    PdfPersonnageCompetenceTri(ListPage);

    // Bloc Entête (extrait dans PdfBlocEntete, CONTEXT.md §2.4)
    DessinDebutHautCarac := PdfBlocEntete(PdfPage, Personnage, PRace, PMetier, PMetierNiveau, LocData,
      DessinDebColG, DessinFinEntete, DessinDebutHautEntete, DessinHauteurEntete, DessinNbLigEntete, MinPolice) - 3;

    // Tableau Caractéristiques (extrait dans DessinerTableau / PdfPreparerRecordSetCaracteristiques, CONTEXT.md §2.4)
    TableauCarac.X               := DessinDebColG;
    TableauCarac.Y               := DessinDebutHautCarac;
    TableauCarac.Orientation     := orColonne;
    TableauCarac.LargeurLibelles := 40 - DessinDebColG;
    TableauCarac.LargeurEntree   := DessinLargeurCarac;
    TableauCarac.HauteurLigne    := DessinHauteurCarac;
    TableauCarac.Police          := 9;
    SetLength(TableauCarac.Champs, 6);
    TableauCarac.Champs[0].Libelle := GetTexteLibelle('PDF_CHARAC1_CHARAC');   TableauCarac.Champs[0].Champ := 'Code';     TableauCarac.Champs[0].EnTete := True;
    TableauCarac.Champs[1].Libelle := GetTexteLibelle('PDF_CHARAC3_INITIAL');  TableauCarac.Champs[1].Champ := 'Initial';
    TableauCarac.Champs[2].Libelle := GetTexteLibelle('PDF_CHARAC3_IMPROV');   TableauCarac.Champs[2].Champ := 'Improv';
    TableauCarac.Champs[3].Libelle := GetTexteLibelle('PDF_CHARAC3_ADVANCES'); TableauCarac.Champs[3].Champ := 'Advances';
    TableauCarac.Champs[4].Libelle := GetTexteLibelle('PDF_CHARAC3_CURRENT');  TableauCarac.Champs[4].Champ := 'Current';
    TableauCarac.Champs[5].Libelle := GetTexteLibelle('PDF_CHARAC3_BONUS');    TableauCarac.Champs[5].Champ := 'Bonus';

    DonneesCarac := PdfPreparerRecordSetCaracteristiques(Personnage, PMetier);
    DessinDebutHautComp := DessinerTableau(PdfPage, TableauCarac, DonneesCarac) - 3;
    DessinDebutHautComg := DessinDebutHautComp;

    // Tableau Compétences de base (extrait dans DessinerTableau (orLigne) /
    // PdfPreparerRecordSetCompetencesBase, CONTEXT.md §2.4)
    TableauComp.X                := DessinDebColG;
    TableauComp.Y                := DessinDebutHautComp;
    TableauComp.Orientation      := orLigne;
    TableauComp.LargeurEntree    := DessinLargeurComp;
    TableauComp.HauteurLigne     := DessinHauteurComp;
    TableauComp.Police           := 9;
    TableauComp.PoliceMin        := MinPolice;
    TableauComp.Titre            := Trim(GetTexteLibelle('PDF_SKILLS1_BASIC'));
    TableauComp.TitreDecalageGauche := 15;
    TableauComp.NbLignesMax       := DessinNbLigComp - 2; // 2 lignes d'en-tête (titre + libellés)

    SetLength(TableauComp.Champs, 6);
    TableauComp.Champs[0].Libelle           := GetTexteLibelle('PDF_SKILLS2_NAME');
    TableauComp.Champs[0].Champ             := 'Nom';
    TableauComp.Champs[0].EnTete            := True;
    TableauComp.Champs[0].Largeur           := 55 - DessinDebColG;
    TableauComp.Champs[0].AlignementEntete  := alGauche;
    TableauComp.Champs[0].DecalageEnteteMin := 2;
    TableauComp.Champs[0].DecalageEnteteMax := 0;
    TableauComp.Champs[0].DecalageValeurMin := 2;
    TableauComp.Champs[0].DecalageValeurMax := 3.5;

    TableauComp.Champs[1].Libelle           := GetTexteLibelle('PDF_SKILLS2_CHARAC');
    TableauComp.Champs[1].Champ             := 'Attribut';
    TableauComp.Champs[1].EnTete            := True;
    TableauComp.Champs[1].FusionAvecSuivante:= True;
    TableauComp.Champs[1].DecalageValeurMin := 3.5;
    TableauComp.Champs[1].DecalageValeurMax := 3.5;

    TableauComp.Champs[2].Champ             := 'Stat';
    TableauComp.Champs[2].DecalageValeurMin := 3.5;
    TableauComp.Champs[2].DecalageValeurMax := 3.5;

    TableauComp.Champs[3].Libelle           := GetTexteLibelle('PDF_SKILLS2_UPG');
    TableauComp.Champs[3].Champ             := 'Upg';
    TableauComp.Champs[3].DecalageValeurMin := 3.5;
    TableauComp.Champs[3].DecalageValeurMax := 3.5;

    TableauComp.Champs[4].Libelle           := GetTexteLibelle('PDF_SKILLS2_ADV');
    TableauComp.Champs[4].Champ             := 'Adv';
    TableauComp.Champs[4].DecalageValeurMin := 3.5;
    TableauComp.Champs[4].DecalageValeurMax := 3.5;

    TableauComp.Champs[5].Libelle           := GetTexteLibelle('PDF_SKILLS2_TOTAL');
    TableauComp.Champs[5].Champ             := 'Total';
    TableauComp.Champs[5].DecalageValeurMin := 3.5;
    TableauComp.Champs[5].DecalageValeurMax := 3.5;

    DonneesComp := PdfPreparerRecordSetCompetencesBase(Personnage, PMetier, ListPage, TotalEsquive, TotalCalme, TotalResitance, TotalCommandement, TotalIntuition, ListPris);
    ListPage.Destroy;
    DessinDebutHautAmb := DessinerTableau(PdfPage, TableauComp, DonneesComp) - 3;

    // Bloc Ambitions (extrait dans PdfBlocAmbitions, CONTEXT.md §2.4)
    DessinDebutHautRes := PdfBlocAmbitions(PdfPage, DessinDebColG, DessinFinColG, DessinDebutHautAmb, DessinHauteurAmb, DessinNbLigAmb, MinPolice) - 3;
    DessinDebutHautDes := DessinDebutHautRes;

    // Bloc Résilience / Destin (extrait dans PdfBlocResilience / PdfBlocDestin, CONTEXT.md §2.4)
    PdfBlocResilience(PdfPage, Personnage, DessinDebColG, DessinDebutHautRes, DessinNbLigRes, DessinHauteurRes, MinPolice, Determine, IndC);
    PdfBlocDestin(PdfPage, Personnage, DessinDebColG + 40, DessinDebutHautDes, DessinHauteurDes, MinPolice, Chance);

    // calcul expérience
    for PersonnageXpAttribut in Personnage.XpCoutAttribut do
      begin
        TotalXpSoustrait := TotalXpSoustrait + PersonnageXpAttribut.CoutXp;
        PAttributAugmentation := ChercheAttributAugmentation(PersonnageXpAttribut.Debut, PersonnageXpAttribut.Fin);
        TotalXpSoustrait := TotalXpSoustrait - ((PersonnageXpAttribut.Fin - PersonnageXpAttribut.Debut)  * PAttributAugmentation.Cout);
      end;
    for PersonnageXpCompetence in Personnage.XpCoutCompetence do
      begin
        TotalXpSoustrait := TotalXpSoustrait + PersonnageXpCompetence.CoutXp;
        PCompetenceAugmentation := ChercheCompetenceAugmentation(PersonnageXpCompetence.Debut, PersonnageXpCompetence.Fin);
        TotalXpSoustrait := TotalXpSoustrait - ((PersonnageXpCompetence.Fin - PersonnageXpCompetence.Debut)  * PCompetenceAugmentation.Cout);
      end;
    for PersonnageXpTalent in Personnage.XpCoutTalent do
      TotalXpSoustrait := TotalXpSoustrait + PersonnageXpAttribut.CoutXp - (100 + (PersonnageXpCompetence.Fin - PersonnageXpCompetence.Debut - 1) * 100);

    // Blocs Expérience / Mouvement / Corruption (extraits dans PdfBlocExperience /
    // PdfBlocMouvement / PdfBlocCorruption, CONTEXT.md §2.4) — trois panneaux côte à côte
    // sur la même rangée, sous Résilience/Destin.
    DessinDebutHautExp   := DessinDebutHautDes - (DessinNbLigRes * DessinHauteurDes) - 3;
    DessinDebutHautMou   := DessinDebutHautExp;
    DessinDebutHautCor   := DessinDebutHautExp;
    DessinDebutGaucheMou := DessinLargeurExp + 3;
    DessinDebutGaucheCor := DessinDebutGaucheMou + DessinLargeurMou + 3;
    DessinLargeurCor     := DessinFinColG - DessinDebutGaucheCor;

    PdfBlocExperience(PdfPage, Personnage, DessinDebColG, DessinLargeurExp, DessinDebutHautExp, DessinHauteurExp, DessinNbLigExp + 1, MinPolice);
    PdfBlocMouvement(PdfPage, DessinDebutGaucheMou, DessinDebutGaucheMou + DessinLargeurMou, DessinDebutHautMou, DessinHauteurMou, DessinNbLigMou + 1, MinPolice, Mouv, BonusSprint);
    PdfBlocCorruption(PdfPage, DessinDebutGaucheCor, DessinDebutGaucheCor + DessinLargeurCor, DessinDebutHautCor, DessinHauteurCor, DessinNbLigCor + 1, MinPolice, BE, BFM, AmePure);

    // Tableau Compétences groupées (extrait dans DessinerTableau (orLigne) /
    // PdfPreparerRecordSetCompetencesGroupees, CONTEXT.md §2.4)
    TableauCompG.X                 := DessinDebColD;
    TableauCompG.Y                 := DessinDebutHautComg;
    TableauCompG.Orientation       := orLigne;
    TableauCompG.LargeurEntree     := DessinLargeurComg;
    TableauCompG.HauteurLigne      := DessinHauteurComg;
    TableauCompG.Police            := 9;
    TableauCompG.PoliceMin         := MinPolice;
    TableauCompG.Titre             := Trim(GetTexteLibelle('PDF_SKILLS1_ADVANCED'));
    TableauCompG.TitreDecalageGauche := 15;
    TableauCompG.NbLignesMax        := DessinNbLigComg - 2; // 2 lignes d'en-tête (titre + libellés)

    SetLength(TableauCompG.Champs, 6);
    TableauCompG.Champs[0].Libelle           := GetTexteLibelle('PDF_SKILLS2_NAME');
    TableauCompG.Champs[0].Champ             := 'Nom';
    TableauCompG.Champs[0].Largeur           := 143 - DessinDebColD;
    TableauCompG.Champs[0].AlignementEntete  := alGauche;
    TableauCompG.Champs[0].DecalageEnteteMin := 5;
    TableauCompG.Champs[0].DecalageEnteteMax := 5;
    TableauCompG.Champs[0].DecalageValeurMin := 3;
    TableauCompG.Champs[0].DecalageValeurMax := 0;

    TableauCompG.Champs[1].Libelle           := GetTexteLibelle('PDF_SKILLS2_CHARAC');
    TableauCompG.Champs[1].Champ             := 'Attribut';
    TableauCompG.Champs[1].FusionAvecSuivante:= True;
    TableauCompG.Champs[1].DecalageValeurMin := 2.5;
    TableauCompG.Champs[1].DecalageValeurMax := 2.5;

    TableauCompG.Champs[2].Champ             := 'Stat';
    TableauCompG.Champs[2].DecalageValeurMin := 2.5;
    TableauCompG.Champs[2].DecalageValeurMax := 2.5;

    TableauCompG.Champs[3].Libelle           := GetTexteLibelle('PDF_SKILLS2_UPG');
    TableauCompG.Champs[3].Champ             := 'Upg';
    TableauCompG.Champs[3].DecalageValeurMin := 2.5;
    TableauCompG.Champs[3].DecalageValeurMax := 2.5;

    TableauCompG.Champs[4].Libelle           := GetTexteLibelle('PDF_SKILLS2_ADV');
    TableauCompG.Champs[4].Champ             := 'Adv';
    TableauCompG.Champs[4].DecalageValeurMin := 2.5;
    TableauCompG.Champs[4].DecalageValeurMax := 2.5;

    TableauCompG.Champs[5].Libelle           := GetTexteLibelle('PDF_SKILLS2_TOTAL');
    TableauCompG.Champs[5].Champ             := 'Total';
    TableauCompG.Champs[5].DecalageValeurMin := 2.5;
    TableauCompG.Champs[5].DecalageValeurMax := 2.5;

    DonneesCompG := PdfPreparerRecordSetCompetencesGroupees(Personnage, ListPris, DessinNbLigComg - 2);
    DessinDebutHautTal := DessinerTableau(PdfPage, TableauCompG, DonneesCompG) - 3;

    // Dessin Talents
    PdfPage.DrawLine( DessinDebColD, DessinDebutHautTal, DessinDebColD, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinDebColD + 41, DessinDebutHautTal - (1 * DessinHauteurTal), DessinDebColD + 41, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinDebColD + 47, DessinDebutHautTal - (1 * DessinHauteurTal), DessinDebColD + 47, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinDebColD + 53, DessinDebutHautTal - (1 * DessinHauteurTal), DessinDebColD + 53, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    PdfPage.DrawLine( DessinFinColD, DessinDebutHautTal, DessinFinColD, DessinDebutHautTal - (DessinNbLigTal * DessinHauteurTal), 1);
    for IndC := 0 to DessinNbLigTal do
      PdfPage.DrawLine(DessinDebColD,DessinDebutHautTal - (indC * DessinHauteurTal), DessinFinColD, DessinDebutHautTal - (indC * DessinHauteurTal), 1);
    // Texte Talents
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage, DessinDebColD, DessinFinColD, DessinDebutHautTal - (1 * DessinHauteurTal) + 1, Trim(GetTexteLibelle('PDF_TALENT1_TALENTS')));
    PdfCentre(PdfPage, DessinDebColD, DessinDebColD + 40, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_TALENTNAME'));
    PdfCentre(PdfPage, DessinDebColD + 41, DessinDebColD + 47, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_UPG'));
    PdfCentre(PdfPage, DessinDebColD + 47, DessinDebColD + 51, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_LEVEL'));
    PdfCentre(PdfPage, DessinDebColD + 53, DessinFinColD, DessinDebutHautTal - (2 * DessinHauteurTal) + 1,GetTexteLibelle('PDF_TALENT2_DESC'));
    // Valeur Talents
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    NbLigne := 0;
    For IndC := 0 to ListTalent.count - 1 do
      begin
        PTalent := ListTalent[IndC];
        NivTalMetier := 0;
        TalentDonnee := PdfPersonnageTalent(Personnage, PTalent.CodeTalent, NivTalMetier);
        if TalentDonnee.Total <> 0 then
          begin
            inc(NbLigne);
            PdfEcrit(PdfPage, DessinDebColD + 2, DessinDebColD + 41, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, PTalent.Libelle, MinPolice);
            Bonus := PdfPersonnageTalentBonus(Personnage, PTalent.CodeTalent);
            // Afficher l'astérisque pour les talents
            if Bonus <> '' then
              begin
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 4);
                PdfEcrit(PdfPage, DessinDebColD + 38, DessinDebColD + 41, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 3, Bonus, 4);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
              end;
            if (NivTalMetier > 0) then
              begin
                if (NivTalMetier > Personnage.MetierEnCours.NiveauMetier) then
                  PdfPage.SetColor(RGB(150,150,150), False);
                PdfEcrit(PdfPage, DessinDebColD + 43, DessinDebColD + 47, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, IntToStr(NivTalMetier),MinPolice);
                PdfPage.SetColor(clBlack, False);
              end;
            PdfCentre(PdfPage, DessinDebColD + 47, DessinDebColD + 53, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, IntToStr(TalentDonnee.Total));
            if PTalent.SousTalent then
              PTalent := ChercheTalent(Copy(PTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
            if PTalent.Resume <> '' then
              begin
                if Length(PTalent.Resume) > 20 then
                  PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1.5, PTalent.Resume, MinPolice)
                else
                  PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 2) * DessinHauteurTal) + 1, PTalent.Resume, MinPolice);
                PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
              end;
            ListeTalent += AjouteAccolade(PTalent.CodeTalent);
          end;
      end;
    // Valeur Talents non acquis
    PdfPage.SetColor(RGB(150,150,150), False);
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
    For PMetierTalent In ListMetierTalent do
      if (PMetierTalent.CodeMetier = Personnage.MetierEnCours.CodeMetier) then
        if (PMetierTalent.NiveauMetier >= Personnage.MetierEnCours.NiveauMetier) then
          if (Pos(AjouteAccolade(PMetierTalent.CodeTalent),ListeTalent) = 0)  and (NbLigne < (DessinNbLigTal - 2)) then
            begin
              PTalent := chercheTalent(PMetierTalent.CodeTalent);
              PdfEcrit(PdfPage, DessinDebColD +  2, DessinDebColD + 41, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1, PTalent.Libelle, MinPolice);
              PdfEcrit(PdfPage, DessinDebColD + 43, DessinDebColD + 47, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1, InttoStr(PMetierTalent.NiveauMetier), MinPolice);
              if PTalent.SousTalent then
                PTalent := ChercheTalent(Copy(PTalent.CodeTalent, 1, Pos('_', PTalent.CodeTalent) - 1)+'_*');
              if PTalent.Resume <> '' then
                begin
                  if Length(PTalent.Resume) > 20 then
                    PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1.5, PTalent.Resume, MinPolice)
                  else
                    PdfEcrit(PdfPage, DessinDebColD + 54, DessinFinColD, DessinDebutHautTal - ((NbLigne + 3) * DessinHauteurTal) + 1, PTalent.Resume, MinPolice);
                  PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
                end;
              NbLigne := NbLigne + 1;
            end;
    PdfPage.SetColor(clBlack, False);


   // PAGE 2
     PdfPage         := PDFDoc.Pages.AddPage;
     PdfSection.AddPage(PdfPage);
     PdfPage.PaperType:= ptA4;
     PdfPage.UnitOfMeasure := uomMillimeters;
     PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
     // Dessin Armures
     DessinDebutHautArm := DessinDebutHautEntete;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautArm, DessinDebColG, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG +  0, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG +  0, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 34, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 34, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 53, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 53, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 62, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 62, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinDebColG + 70, DessinDebutHautArm - (1 * DessinHauteurArm), DessinDebColG + 70, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     PdfPage.DrawLine( DessinLargeurArm, DessinDebutHautArm, DessinLargeurArm, DessinDebutHautArm - ((DessinNbLigArm + 1) * DessinHauteurArm), 1);
     for IndC := 0 to (DessinNbLigArm + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautArm - (indC * DessinHauteurArm), DessinLargeurArm, DessinDebutHautArm - (indC * DessinHauteurArm), 1);
     // Texte Armure
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurArm  , DessinDebutHautArm - (1 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR1_ARMOUR'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 34, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  34, DessinDebColG + 53, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_LOCATIONS'));
     PdfCentre(PdfPage, DessinDebColG +  53, DessinDebColG + 62, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_ENCUMBRANCE'));
     PdfCentre(PdfPage, DessinDebColG +  62, DessinDebColG + 70, DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_ARMOURPOINT'));
     PdfCentre(PdfPage, DessinDebColG +  70, DessinLargeurArm  , DessinDebutHautArm - (2 * DessinHauteurArm) + 1, GetTexteLibelle('PDF_ARMOUR2_QUALITIES'));
     // Dessin Equipement
     DessinDebutHautEqu := DessinDebutHautArm - (indC * DessinHauteurArm) - 3;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautEqu, DessinDebColG, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG +   0, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG +   0, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG +  48, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG +  48, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG +  55, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG +  55, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinDebColG + 100, DessinDebutHautEqu - (1 * DessinHauteurEqu), DessinDebColG + 100, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     PdfPage.DrawLine( DessinLargeurEqu, DessinDebutHautEqu, DessinLargeurEqu, DessinDebutHautEqu - ((DessinNbLigEqu + 1) * DessinHauteurEqu), 1);
     for IndC := 0 to (DessinNbLigEqu + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautEqu - (indC * DessinHauteurEqu), DessinLargeurEqu, DessinDebutHautEqu - (indC * DessinHauteurEqu), 1);
     // Texte Equipement
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurEqu  , DessinDebutHautEqu - (1 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING1_TRAPPINGS'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 48, DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  48, DessinDebColG + 55, DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_ENCUMBRANCE'));
     PdfCentre(PdfPage, DessinDebColG +  55, DessinDebColG +100, DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_NAME'));
     PdfCentre(PdfPage, DessinDebColG + 100, DessinLargeurEqu  , DessinDebutHautEqu - (2 * DessinHauteurEqu) + 1, GetTexteLibelle('PDF_TRAPPING2_ENCUMBRANCE'));
     // Dessin Armes
     DessinDebutHautWea := DessinDebutHautEqu - (indC * DessinHauteurEqu) - 3;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautWea, DessinDebColG, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +   0, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +   0, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  45, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  45, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  64, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  64, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  71, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  71, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG +  96, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG +  96, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinDebColG + 113, DessinDebutHautWea - (1 * DessinHauteurWea), DessinDebColG + 113, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     PdfPage.DrawLine( DessinLargeurWea, DessinDebutHautWea, DessinLargeurWea, DessinDebutHautWea - ((DessinNbLigWea + 1) * DessinHauteurWea), 1);
     for IndC := 0 to (DessinNbLigWea + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautWea - (indC * DessinHauteurWea), DessinLargeurWea, DessinDebutHautWea - (indC * DessinHauteurWea), 1);
     // Texte Armes
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurWea  , DessinDebutHautWea - (1 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS1_WEAPONS'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 45, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  45, DessinDebColG + 64, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_GROUP'));
     PdfCentre(PdfPage, DessinDebColG +  64, DessinDebColG + 71, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_ENCUMBRANCE'));
     PdfCentre(PdfPage, DessinDebColG +  71, DessinDebColG + 96, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_RANGE'));
     PdfCentre(PdfPage, DessinDebColG +  96, DessinDebColG +113, DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_DAMAGE'));
     PdfCentre(PdfPage, DessinDebColG + 113, DessinLargeurWea  , DessinDebutHautWea - (2 * DessinHauteurWea) + 1, GetTexteLibelle('PDF_WEAPONS2_QUALITIES'));
     // Dessin Sorts
     DessinDebutHautSor := DessinDebutHautWea - (indC * DessinHauteurWea) - 3;
     PdfPage.DrawLine( DessinDebColG, DessinDebutHautSor, DessinDebColG, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +   0, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +   0, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  38, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  38, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  51, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  51, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  66, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  66, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  82, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  82, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinDebColG +  98, DessinDebutHautSor - (1 * DessinHauteurSor), DessinDebColG +  98, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     PdfPage.DrawLine( DessinLargeurSor, DessinDebutHautSor, DessinLargeurSor, DessinDebutHautSor - ((DessinNbLigSor + 1) * DessinHauteurSor), 1);
     for IndC := 0 to (DessinNbLigSor + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautSor - (indC * DessinHauteurSor), DessinLargeurSor, DessinDebutHautSor - (indC * DessinHauteurSor), 1);
     // Texte Sorts
     PdfCentre(PdfPage, DessinDebColG +   0, DessinLargeurSor  , DessinDebutHautSor - (1 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL1_SPELL'));
     PdfCentre(PdfPage, DessinDebColG +   0, DessinDebColG + 38, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_NAME'));
     PdfCentre(PdfPage, DessinDebColG +  38, DessinDebColG + 51, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_CN'));
     PdfCentre(PdfPage, DessinDebColG +  51, DessinDebColG + 66, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_RANGE'));
     PdfCentre(PdfPage, DessinDebColG +  66, DessinDebColG + 82, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_TARGET'));
     PdfCentre(PdfPage, DessinDebColG +  82, DessinDebColG + 98, DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_DURATION'));
     PdfCentre(PdfPage, DessinDebColG +  98, DessinLargeurSor  , DessinDebutHautSor - (2 * DessinHauteursor) + 1, GetTexteLibelle('PDF_SPELL2_EFFECT'));
     // Encombrement
     DessinDebutHautEnc := DessinDebutHautSor - (indC * DessinHauteurSor) - 3;
     PdfPage.DrawLine( DessinDebColG      , DessinDebutHautEnc                         , DessinDebColG      , DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc), 1);
     PdfPage.DrawLine( DessinDebColG +  15, DessinDebutHautEnc - (1 * DessinHauteurEnc), DessinDebColG +  15, DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc), 1);
     PdfPage.DrawLine( DessinLargeurEnc   , DessinDebutHautEnc                         , DessinLargeurEnc   , DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc), 1);
     for IndC := 0 to (DessinNbLigEnc + 1) do
       PdfPage.DrawLine(DessinDebColG,DessinDebutHautEnc - (indC * DessinHauteurEnc), DessinLargeurEnc, DessinDebutHautEnc - (indC * DessinHauteurEnc), 1);
     // Texte Encombrement
     PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
     PdfCentre(PdfPage, DessinDebColG + 1, DessinLargeurEnc  , DessinDebutHautEnc - ((DessinNbLigEnc - 4) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE1_ENCUMBRANCE'));
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 3) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE2_ARMOUR')    , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 2) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE3_WEAPONS')   , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 1) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE4_TRAPPINGS') , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc - 0) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE5_MAXENC')    , MinPolice);
     PdfEcrit(PdfPage,  DessinDebColG + 1, DessinDebColG + 15, DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc) + 0.6, GetTexteLibelle('PDF_ENCUMBRANCE6_TOTAL')     , MinPolice);

     // Valeurs Armures, Equipement, Armes
     PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
     EncArme     := 0;
     EncArmure   := 0;
     ArmureBras  := 0;
     ArmureCorps := 0;
     ArmureJambe := 0;
     ArmureTete  := 0;
     NbArme      := 0;
     NbArmure    := 0;
     NbSort      := 0;
     Quality     := '';
     for PersonnageEquipement in Personnage.Equipement do
       begin
         Enc := 0;
         EncP:= 0;
         if PersonnageEquipement.TypeEquipement = TypeEquipWe then
           // gérer les armes
             begin
               TexteRange1:= '';
               TexteRange2:= '';
               PArme      := ChercheArme(PersonnageEquipement.CodeEquipement);

               Portee     := PArme.Portee;
               if Pos('(B'+ConstCaracF+')',Portee) > 0 then
                 begin
                   Portee       := StringReplace(Portee, '(B'+ConstCaracF+')', IntToStr(Trunc(BF/10)), [rfReplaceAll]);;
                   PorteMoyenne := MultiChaine(Portee);
                   Portee       := IntToStr(PorteMoyenne);
                 end
               else
                 PorteMoyenne   := StrToIntDef(Portee,0);

               Enc        := PArme.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement, Quality);
               EncArme    := EncArme + Enc;

               Inc(NbArme);

               Pourcent := '';

               CompetenceDonnee := PdfPersonnageCompetence(Personnage, PArme.CodeCompetence, Bidon);

               Pourcent := IntToStr(CompetenceDonnee.Total);
               PasBonus := (CompetenceDonnee.Augmentation = 0);

               if pos(EquipementCT, PArme.CodeArme) > 0 then
                 begin
                   TexteRange1 := '< : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/10)))+'m '+IntToStr(StrToInt(Pourcent)+40)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne/2 )))+'m '+IntToStr(StrToInt(Pourcent)+20)+'%';
                   TexteRange2 := '> : '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*2 )))+'m '+IntToStr(StrToInt(Pourcent)-10)+'% / '+ChaineSur(3,IntToStr(Trunc(PorteMoyenne*3 )))+'m '+IntToStr(StrToInt(Pourcent)-30)+'%';
                 end;

               PdfEcrit(PdfPage, DessinDebColG +  1, DessinDebColG + 45, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, PArme.Libelle + Quality, MinPolice);

               LigneBonus := '';

               PdfCentre(PdfPage, DessinDebColG +  45, DessinDebColG + 64, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, Pourcent + ' %');
               if PArme.Encombrement <> 0 then
                 PdfCentre(PdfPage, DessinDebColG +  64, DessinDebColG + 71, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, IntToStr(Enc));
               PdfCentre(PdfPage, DessinDebColG +  71, DessinDebColG + 96, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, GetAllTexteLibelle(Portee));

               Deg   := CalculDegat(PArme.CalculDegat, BF);
               if pos(EquipementCC, PArme.CodeArme) > 0 then
                 Deg := Deg + TBonusCC
               else if pos(EquipementCT, PArme.CodeArme) > 0 then
                 Deg := Deg + TBonusCT;

               if Deg = 0 then
                 PdfCentre(PdfPage, DessinDebColG +  96, DessinDebColG + 113, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, '-')
               else
                 PdfCentre(PdfPage, DessinDebColG +  96, DessinDebColG + 113, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.6, 'DR + '+IntToStr(Deg));

               PosProtection := pos(BonusProtection, PArme.ListeBonus);
               if PosProtection > 0 then
                 ArmureBouclier := StrToInt(copy(PArme.ListeBonus, PosProtection + Length(BonusProtection), 1));
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);

               if TexteRange1 <> '' then
                 begin
                   PdfEcrit(PdfPage, DessinDebColG + 113 + 40, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, TexteRange1, MinPolice);
                   PdfEcrit(PdfPage, DessinDebColG + 113 + 40, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 0.3, TexteRange2, MinPolice);
                 end;

               if PasBonus = false then
                 begin
                   LigneBonus := PArme.Listebonus;
                   if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                     begin
                       NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                       for IndLoca := 1 to NbLoca do
                         begin
                           LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                           if pos(' ',LocData) <> 0 then
                             LocData := copy(LocData,1,Length(LocData)-2);
                           PArmeBonus := ChercheArmeBonus(LocData);
                           LigneBonus := StringReplace(LigneBonus, LocData, PArmeBonus.Libelle, [rfReplaceAll]);
                           if Pos(PArmeBonus.CodeArmeBonus, ArmeBonii) = 0 then
                            begin
                              if ArmeBonii <> '' then
                               ArmeBonii := ArmeBonii + ',';
                               ArmeBonii := ArmeBonii + PArmeBonus.CodeArmeBonus;
                            end;
                         end;
                     end;
                   FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
                   if (TexteRange1 = '') then
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, LigneBonus, MinPolice)
                   else
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinDebColG + 113 + 40, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, LigneBonus, MinPolice);
                 end
               else
                 begin
                   PCompetence := ChercheCompetence(PArme.CodeCompetence);
                   ListMalii := 'pas ' + PCompetence.Libelle;

                   if (PArme.ListeBonus <> '') and (PArme.ListeBonus <> '-') then
                     begin
                       NbLoca  := CountOccurrences(PArme.ListeBonus,',') + 1;
                       for IndLoca := 1 to NbLoca do
                         begin
                           LocData := ExtractChaine(',',PArme.ListeBonus,IndLoca);
                           if pos(' ',LocData) <> 0 then
                             LocData := copy(LocData,1,Length(LocData)-2);
                           PArmeBonus := ChercheArmeBonus(LocData);
                           if PArmeBonus.PlusMoins = '-' then
                             begin
                               if Pos(PArmeBonus.Libelle, ArmeBonii) = 0 then
                                 begin
                                   if ArmeBonii <> '' then ArmeBonii := ArmeBonii + ',';
                                   ArmeBonii := ArmeBonii + LocData;
                                 end;
                               ListMalii  := ListMalii + ',' + PArmeBonus.Libelle;
                             end;
                         end;
                     end;
                   FabricationDetail(PersonnageEquipement.QualiteEquipement, ListMalii, FabricationBonii);

                   if (TexteRange1 = '') then
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinLargeurWea, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2.3, ListMalii, MinPolice)
                   else
                     PdfEcrit(PdfPage, DessinDebColG + 113 + 1, DessinDebColG + 113 + 40, DessinDebutHautWea - ((NbArme + 2) * DessinHauteurWea) + 2, ListMalii, MinPolice);

                 end;
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
             end

         else if ((ArmureSet = false) and (PersonnageEquipement.TypeEquipement = TypeEquipAR)) or
                 ((ArmureSet = true)  and (PersonnageEquipement.TypeEquipement = TypeEquipARS)) then
             // gérer les armures
             begin
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 begin
                   PArmure    := ChercheArmure(PersonnageEquipement.CodeEquipement);
                   Enc        := PArmure.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                   NbLoca     := CountOccurrences(PArmure.Emplacement,',') + 1;
                   LigneBonus := PArmure.Listebonus;
                 end
               else
                 begin
                   PArmureSimplifiee   := ChercheArmureSimplifiee(PersonnageEquipement.CodeEquipement);
                   Enc                 := PArmureSimplifiee.Encombrement + FabricationEncombrement(PersonnageEquipement.QualiteEquipement,Quality);
                   LigneBonus          := PArmureSimplifiee.Listebonus;
                 end;

               EncP      := Enc;
               if EncP > 0 then
                 EncP    := EncP - 1;
               EncArmure := EncArmure + EncP;
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 For IndLoca := 1 to NbLoca do
                   begin
                     LocData := ExtractChaine(',',PArmure.Emplacement,IndLoca);
                     case LocData of
                       BonusBras:   ArmureBras  := ArmureBras  + PArmure.Protection;
                       BonusCorps:  ArmureCorps := ArmureCorps + PArmure.Protection;
                       BonusJambes: ArmureJambe := ArmureJambe + PArmure.Protection;
                       BonusTete:   ArmureTete  := ArmureTete  + PArmure.Protection;
                     end;
                   end
               else
                 begin
                   ArmureBras  := ArmureBras  + PArmureSimplifiee.Protection;
                   ArmureCorps := ArmureCorps + PArmureSimplifiee.Protection;
                   ArmureJambe := ArmureJambe + PArmureSimplifiee.Protection;
                   ArmureTete  := ArmureTete  + PArmureSimplifiee.Protection;
                 end;

               Inc(NBArmure);

               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 begin
                   PdfEcrit(PdfPage, DessinDebColG +  1, DessinDebColG + 34, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, Parmure.Libelle + Quality, MinPolice);
                   PdfEcrit(PdfPage, DessinDebColG + 35, DessinDebColG + 53, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, GetAllTexteLibelle(PArmure.Emplacement), MinPolice);
                 end
               else
                 PdfEcrit(PdfPage, DessinDebColG +  1, DessinDebColG + 34, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, PArmureSimplifiee.Libelle + Quality, MinPolice);
               if Enc <> 0 then
                 if EncP <> Enc then
                   PdfCentre(PdfPage, DessinDebColG + 53, DessinDebColG + 62, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(EncP)+ '('+IntToStr(Enc)+')')
                 else
                   PdfCentre(PdfPage, DessinDebColG + 53, DessinDebColG + 62, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(Enc));
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                 PdfCentre(PdfPage, DessinDebColG + 62, DessinDebColG + 70, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(PArmure.Protection))
               else
                 PdfCentre(PdfPage, DessinDebColG + 62, DessinDebColG + 70, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, IntToStr(PArmureSimplifiee.Protection));
               if (PersonnageEquipement.TypeEquipement = TypeEquipAR) and (PArmure.ListeBonus <> '') and (PArmure.ListeBonus <> '-') or
                  (PersonnageEquipement.TypeEquipement = TypeEquipARS) and (PArmureSimplifiee.ListeBonus <> '') and (PArmureSimplifiee.ListeBonus <> '-') then
                 begin
                   if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                     NbLoca  := CountOccurrences(PArmure.ListeBonus,',') + 1
                   else
                     NbLoca  := CountOccurrences(PArmureSimplifiee.ListeBonus,',') + 1;
                   for IndLoca := 1 to NbLoca do
                     begin
                       if (PersonnageEquipement.TypeEquipement = TypeEquipAR) then
                         LocData := ExtractChaine(',',PArmure.ListeBonus,IndLoca)
                       else
                         LocData := ExtractChaine(',',PArmureSimplifiee.ListeBonus,IndLoca);
                       if pos(' ',LocData) <> 0 then
                         LocData := copy(LocData,1,Length(LocData)-2);
                       PArmureBonus := ChercheArmureBonus(LocData);
                       LigneBonus := StringReplace(LigneBonus, LocData, PArmureBonus.Libelle, [rfReplaceAll]);
                       if pos(LocData, ArmureBonii) = 0 then
                         begin
                           if ArmureBonii <> '' then
                            ArmureBonii := ArmureBonii + ',';
                           ArmureBonii := ArmureBonii + LocData;
                         end;
                     end;
                 end;
               FabricationDetail(PersonnageEquipement.QualiteEquipement, LigneBonus, FabricationBonii);
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 6);
               PdfEcrit(PdfPage, DessinDebColG + 70 +1, DessinLargeurArm, DessinDebutHautArm - ((NbArmure + 2) * DessinHauteurArm) + 0.6, LigneBonus, MinPolice);
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
             end

           else if PersonnageEquipement.TypeEquipement = TypeEquipDI then
             // gérer les divers
             begin
               Inc(IndDivers);
               if (IndDivers <= (DessinNbLigEqu * 2)) then
                  begin
                    if IndDivers > (DessinNbLigEqu - 1) then
                      PdfEcrit(PdfPage, DessinDebColG +  56, DessinDebColG + 100, DessinDebutHautEqu - ((IndDivers - DessinNbLigEqu + 3) * DessinHauteurEqu) + 0.6, PersonnageEquipement.CodeEquipement, MinPolice)
                    else
                      PdfEcrit(PdfPage, DessinDebColG +   1, DessinDebColG +  48, DessinDebutHautEqu - ((IndDivers + 2) * DessinHauteurEqu) + 0.6, PersonnageEquipement.CodeEquipement, MinPolice);
                  end;
             end

           else if PersonnageEquipement.TypeEquipement = TypeEquipSp then
             begin
               // gérer les sorts
               Inc(NbSort);
               PSort := ChercheSort(PersonnageEquipement.CodeEquipement);
               PdfEcrit (PdfPage, DessinDebColG +   1, DessinDebColG + 38, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PSort.Libelle, MinPolice);
               PdfCentre(PdfPage, DessinDebColG +  38, DessinDebColG + 51, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PSort.Niveau);
               PdfCentre(PdfPage, DessinDebColG +  51, DessinDebColG + 66, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PdfPersonnageRemplaceBonus(Personnage, PSort.Portee));
               PdfCentre(PdfPage, DessinDebColG +  66, DessinDebColG + 82, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PdfPersonnageRemplaceBonus(Personnage, PSort.Cible));
               PdfCentre(PdfPage, DessinDebColG +  82, DessinDebColG + 98, DessinDebutHautSor - ((NbSort + 2) * DessinHauteurSor) + 0.6, PdfPersonnageRemplaceBonus(Personnage, PSort.Duree));
               PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 9);
             end;
       end;
        // Écrire du texte sur la page PDF
    PdfTaillePolice(PdfPage, PdfFontValue, ConstPoliceArial, 7);

    //  gérer les encombrement
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc - 3) * DessinHauteurEnc) + 0.9, IntToStr(EncArmure));
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc - 2) * DessinHauteurEnc) + 0.9, IntToStr(EncArme));
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc - 0) * DessinHauteurEnc) + 0.9, IntToStr(Floor(BF/10) + Floor(BE/10) + BonusEncomb));
    PdfCentre(PdfPage, DessinDebColG + 15, DessinLargeurEnc, DessinDebutHautEnc - ((DessinNbLigEnc + 1) * DessinHauteurEnc) + 0.9, IntToStr(EncArmure + EncArme));

    // Dessin Blessure
    DessinDebutHautBle   := DessinDebutHautEnc;
    DessinDebutGaucheBle := DessinLargeurEnc + 3;
    DessinLargeurBle     := DessinLargeurEqu;
    PdfPage.DrawLine( DessinDebutGaucheBle , DessinDebutHautBle, DessinDebutGaucheBle, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinDebutGaucheBle + 29 , DessinDebutHautBle - (4 * DessinHauteurBle), DessinDebutGaucheBle + 29, DessinDebutHautBle - (5 * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinDebutGaucheBle + 48 , DessinDebutHautBle - (1 * DessinHauteurBle), DessinDebutGaucheBle + 48, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinDebutGaucheBle + 61 , DessinDebutHautBle - (1 * DessinHauteurBle), DessinDebutGaucheBle + 61, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    PdfPage.DrawLine( DessinLargeurEqu, DessinDebutHautBle, DessinLargeurEqu, DessinDebutHautBle - (DessinNbLigBle * DessinHauteurBle), 1);
    for IndC := 0 to DessinNbLigBle do
      if (IndC < 2) or (IndC = DessinNbLigBle) then
        PdfPage.DrawLine(DessinDebutGaucheBle,DessinDebutHautBle - (indC * DessinHauteurBle), DessinLargeurBle, DessinDebutHautBle - (indC * DessinHauteurBle), 1)
      else
        PdfPage.DrawLine(DessinDebutGaucheBle,DessinDebutHautBle - (indC * DessinHauteurBle), DessinLargeurBle - 20, DessinDebutHautBle - (indC * DessinHauteurBle), 1);
    // Texte Blessure
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (1 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS1_WOUNDS'));
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (2 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BS'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (3 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BT'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (4 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_BWP'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle - 20,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS5_HARDY'),MinPolice);
    PdfEcrit(PdfPage,DessinDebutGaucheBle + 2,DessinLargeurBle,DessinDebutHautBle - (6 * DessinHauteurBle) + 1, GetTexteLibelle('PDF_WOUNDS7_Tot'),MinPolice);
    // Valeur Blessure
    Ch := IntToStr(Floor(BF/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (2 * DessinHauteurBle) + 1, Ch);
    Ch := IntToStr(Floor(BE/10)*2);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (3 * DessinHauteurBle) + 1, Ch);
    Ch := IntToStr(Floor(BFM/10));
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (4 * DessinHauteurBle) + 1, Ch);
    if DurACuire > 0 then
      begin
        Ch := IntToStr(DurACuire);
        if Length(Ch) = 1 then Ch := ' '+Ch;
        PdfCentre(PdfPage,DessinDebutGaucheBle + 29,DessinDebutGaucheBle + 48,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, IntToStr(ValDurACuire));
        PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (5 * DessinHauteurBle) + 1, Ch);
      end;
    PRaceAttribut := ChercheRaceAttribut(Personnage.Race, ConstCaracBlessure);
    Ch := IntToStr(CalculBlessure(PRaceAttribut.CalculRace, BF, BE, BFM) + DurACuire);
    if Length(Ch) = 1 then Ch := ' '+Ch;
    PdfCentre(PdfPage,DessinDebutGaucheBle + 48,DessinDebutGaucheBle + 61,DessinDebutHautBle - (6 * DessinHauteurBle) + 1, Ch);

    // Dessin Compétence de combat
    DessinDebutHautComC   := DessinDebutHautEnc;
    DessinDebutGaucheComC := DessinLargeurEqu + 3;
    PdfPage.DrawLine(DessinDebutGaucheComC    , DessinDebutHautComC,    DessinDebutGaucheComC,     DessinDebutHautComC  - (6 * DessinHauteurComC), 1);
    PdfPage.DrawLine(DessinLargeurComC - 10   , DessinDebutHautComC,    DessinLargeurComC - 10,    DessinDebutHautComC  - (6 * DessinHauteurComC), 1);
    PdfPage.DrawLine(DessinLargeurComC        , DessinDebutHautComC,    DessinLargeurComC,         DessinDebutHautComC  - (6 * DessinHauteurComC), 1);
    for IndC := 0 to (DessinNbLigComC + 1) do
      PdfPage.DrawLine(DessinDebutGaucheComC,DessinDebutHautComC - (indC * DessinHauteurComC), DessinLargeurComC, DessinDebutHautComC - (indC * DessinHauteurComC), 1);
    // Texte Compétence de combat
    PdfTaillePolice(PdfPage, PdfFontBack, ConstPoliceCarlson+ConstPoliceGras, 10);
    PdfCentre(PdfPage,DessinDebutGaucheComC,DessinLargeurComC - 10,DessinDebutHautComC - (1 * DessinHauteurComC) + 1, GetTexteLibelle('RULES-PDF_SKILLS1_BASIC'));
    PdfCentre(PdfPage,DessinLargeurComC - 10,DessinLargeurComC,DessinDebutHautComC     - (1 * DessinHauteurComC) + 1, GetTexteLibelle('RULES-PDF_SKILLS2_TOTAL'));
    PCompetence := ChercheCompetence(ConstCEsquive);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (2 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (2 * DessinHauteurComC) + 1, IntToStr(TotalEsquive));
    PCompetence := ChercheCompetence(ConstCCalme);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (3 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (3 * DessinHauteurComC) + 1, IntToStr(TotalCalme));
    PCompetence := ChercheCompetence(ConstCIntuition);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (4 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (4 * DessinHauteurComC) + 1, IntToStr(TotalIntuition));
    PCompetence := ChercheCompetence(ConstCCommandement);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (5 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (5 * DessinHauteurComC) + 1, IntToStr(TotalCommandement));
    PCompetence := ChercheCompetence(ConstCResitance);
    PdfEcrit(PdfPage ,DessinDebutGaucheComC + 1,DessinLargeurComC - 10,DessinDebutHautComC - (6 * DessinHauteurComC) + 1, PCompetence.Libelle, MinPolice);
    PdfCentre(PdfPage,DessinLargeurComC - 10   ,DessinLargeurComC, DessinDebutHautComC     - (6 * DessinHauteurComC) + 1, IntToStr(TotalResitance));

    // DessinExplication
    PdfPage.DrawLine(DessinLargeurArm + 3, DessinDebutHautArm,    DessinLargeurArm + 3, DessinDebutHautWea + 3, 1);
    PdfPage.DrawLine(DessinLargeurWea    , DessinDebutHautArm,    DessinLargeurWea    , DessinDebutHautWea + 3, 1);
    PdfPage.DrawLine(DessinLargeurArm + 3, DessinDebutHautArm,    DessinLargeurWea    , DessinDebutHautArm, 1);
    PdfPage.DrawLine(DessinLargeurArm + 3, DessinDebutHautWea + 3,DessinLargeurWea    , DessinDebutHautWea + 3, 1);

    NbBonus := 0;
    if ArmureBonii <> '' then
      begin
        Inc(NbBonus);
        Inc(NbBonus);
        PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), ' --------- ' + GetTexteLibelle('LAB_122') + ' --------- ');
        Inc(NbBonus);
        NbLoca := CountOccurrences(ArmureBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData      := ExtractChaine(',',ArmureBonii,IndLoca);
            PArmureBonus := ChercheArmureBonus(LocData);
            TxtBonus     := PArmureBonus.Libelle+':'+PArmureBonus.Malus;
            PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), TxtBonus);
          end;
      end;

    if ArmeBonii <> '' then
      begin
        Inc(NbBonus);
        Inc(NbBonus);
        PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), ' ---------- ' + GetTexteLibelle('LAB_123') + ' ---------- ');
        Inc(NbBonus);
        NbLoca := CountOccurrences(ArmeBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',ArmeBonii,IndLoca);
            PArmeBonus  := ChercheArmeBonus(LocData);
            TxtBonus    := PArmeBonus.Libelle+':'+PArmeBonus.Resume;
            PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), TxtBonus);
          end;
      end;

    if FabricationBonii <> '' then
      begin
        Inc(NbBonus);
        Inc(NbBonus);
        PdfPage.WriteText(15,DessinDebutHautArm-(NbBonus*DessinHauteurExl), ' ---------- ' + GetTexteLibelle('LAB_124') + ' ---------- ');
        Inc(NbBonus);
        NbLoca := CountOccurrences(FabricationBonii,',')+1;
        For IndLoca := 1 to NbLoca do
          begin
            Inc(NbBonus);
            LocData     := ExtractChaine(',',FabricationBonii,IndLoca);
            PFabrication:= ChercheFabrication(LocData);
            TxtBonus    := PFabrication.Libelle+':'+PFabrication.Resume;
            PdfPage.WriteText(DessinLargeurArm + 4,DessinDebutHautArm-(NbBonus*DessinHauteurExl), TxtBonus);
          end;
      end;


    PDFDoc.SaveToFile(PdfChemin);
    PDFDoc.Free;

    OpenDocument(PdfChemin);
  end;


end.

