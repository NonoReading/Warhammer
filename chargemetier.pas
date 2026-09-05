unit ChargeMetier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ChargeConstantes, Generics.Collections, ChargeTexte, PdfUtils, FileUtil, Unitcalcul,
  ChargeRace;

Type
  StructureMetier	= Record
  	CodeMetier:	String;
  	Libelle:	String;
  	LibelleGroupe:	String;
        Description:	String;
        Livre:          String;
        CodeCompetence: String;
        // Dossier d'icones de niveau propre a ce metier, sous \PICTURES\. C'est le seul
        // recours dans WinMetier, qui affiche un metier sans savoir quelle ethnie le joue.
        // Vide = dossier generique NIV.
        DossierNiveau:  String;
        // Carriere dont celle-ci est la SUITE, vide dans la quasi-totalite des cas. Un ou
        // plusieurs codes de metier separes par SeparateurMulti. Ce champ ne dit PAS a lui
        // seul que le metier est inaccessible : c'est ChercheMinMetierNiveau > 1 qui le
        // dit. Les deux vont ensemble - un parent sans niveau minimum n'aurait aucun effet,
        // un niveau minimum sans parent rendrait le metier definitivement inatteignable.
        MetierParent:   String;
  End;

  TListMetier = specialize TList<StructureMetier>;

  // Bloc DATA_CAREER_BONUS, ajoute le 04/09/2026. Une APPARTENANCE (regiment de
  // l'Empire, ordre de chevalerie, culte) qui, sous condition d'une ethnie ET d'un
  // metier, greffe des competences et des talents supplementaires palier par palier.
  // Nations of Mankind p.6 : "All Lore Skills and Talents granted to the soldier by
  // their Regiment are treated AS IF ADDED TO THEIR CAREER".
  // Pourquoi un objet de LIVRE et pas un champ de l'ethnie ou du metier : les
  // Reiklander viennent du Rulebook, et un fanbook ne doit pas avoir a reecrire le
  // fichier du Rulebook pour leur ajouter une option. Meme raisonnement que
  // DATA_SPELL_TALENT (2.39). CONTEXT.md 2.44.
  StructureCareerBonus = Record
        CodeBonus:      String;
        Libelle:        String;
        // Metier sur lequel l'appartenance se greffe (ex. Soldier du Rulebook).
        CodeMetier:     String;
        // ETHNIE requise pour y avoir droit - ConstXmlRace ('Specie'), donc bien
        // l'ethnie et non la race. VIDE = aucune condition d'origine : c'est le cas de
        // Marienburg, que le livre dispense explicitement ("who hires anyone").
        CodeRace:       String;
        Livre:          String;
  End;

  // Un palier = "au niveau N, tu gagnes ceci". ListeCompetence et ListeTalent sont des
  // listes separees par des virgules dont chaque element garde les formes deja connues,
  // notamment A/B pour un choix entre deux (Lore (Morr or Undead)) - meme convention que
  // StructureTraitOption.ListeTalent (2.41). Un palier qui n'accorde qu'un talent laisse
  // ListeCompetence vide.
  StructureCareerBonusNiveau = Record
        CodeBonus:        String;
        CodeNiveau:       String;
        Niveau:           Integer;
        ListeCompetence:  String;
        ListeTalent:      String;
        Livre:            String;
  End;

  TListCareerBonus       = specialize TList<StructureCareerBonus>;
  TListCareerBonusNiveau = specialize TList<StructureCareerBonusNiveau>;

var
  ListMetier:     TListMetier;
  NbMetier:       Integer;
  ListCareerBonus:        TListCareerBonus;
  NbCareerBonus:          Integer;
  ListCareerBonusNiveau:  TListCareerBonusNiveau;
  NbCareerBonusNiveau:    Integer;

function chercheMetier(CodeMetier :String): StructureMetier;
Function CheminMetierImage(CodeMetier: String): String;
Function DossierNiveauMetier(CodeMetier: String): String;
Function CheminNiveauImageMetier(CodeMetier: String; Niveau: Integer): String;
Function CheminNiveauImageMetierRace(CodeMetier: String; CodeRace: String; Niveau: Integer): String;
Function EstMetierEnfantDe(CodeMetier: String; CodeParent: String): Boolean;
function ChercheCareerBonus(CodeBonus :String): StructureCareerBonus;
function NiveauxDuCareerBonus(CodeBonus :String): TListCareerBonusNiveau;
Function AppartenancesCandidates(CodeMetier: String; CodeRace: String;
                                 DejaAcquises: String): String;

implementation


function ChercheMetier(CodeMetier :String): StructureMetier;
Var
  PMetier:  StructureMetier;
  PVide:    StructureMetier;
  Trouve:   Boolean;
Begin
  for PMetier in ListMetier do
    if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
      begin
        Result := PMetier;
        Trouve := true;
        break;
      end;
  if not trouve then
    begin
      PVide.Libelle := GetTexteLibelle('LAB_138');
      result:= PVide;
    end;
end;

function ChercheCareerBonus(CodeBonus :String): StructureCareerBonus;
Var
  PBonus:  StructureCareerBonus;
Begin
  // Default() obligatoire : sans lui le record garde le contenu du PRECEDENT appel
  // quand rien n'est trouve. Voir CONTEXT.md 2.17.
  Result := Default(StructureCareerBonus);
  for PBonus in ListCareerBonus do
    if CompareRechercheValeur(PBonus.CodeBonus, CodeBonus) then
      begin
        Result := PBonus;
        break;
      end;
end;

function NiveauxDuCareerBonus(CodeBonus :String): TListCareerBonusNiveau;
// Renvoie les paliers d'une appartenance, dans l'ordre du fichier. L'APPELANT est
// proprietaire de la liste rendue et doit la liberer - meme contrat que OptionsDuTrait
// (ChargeRace, 2.41).
Var
  PNiveau:  StructureCareerBonusNiveau;
Begin
  Result := TListCareerBonusNiveau.Create;
  for PNiveau in ListCareerBonusNiveau do
    if CompareRechercheValeur(PNiveau.CodeBonus, CodeBonus) then
      Result.Add(PNiveau);
end;

// Appartenances qu'on peut PROPOSER a un personnage qui entre dans une carriere.
// Les deux conditions du livre ne servent
// qu'ICI, a la saisie, jamais a la relecture d'une fiche (on garde ce qu'un regiment a
// donne meme apres l'avoir quitte). CONTEXT.md 2.44.
//
// CodeMetier   = la carriere dans laquelle on entre.
// CodeRace     = l'ETHNIE du personnage (Personnage.Race).
// DejaAcquises = le champ Appartenance de la fiche, pour ne pas reproposer un regiment
//                dont il est deja membre - le choix est cumulatif, jamais exclusif.
//
// Le resultat sort dans la forme attendue par WinSpecialisation : des codes separes par
// des virgules, comme la liste d'equipement. Chaine vide = aucun candidat, l'appelant
// n'ouvre alors aucune fenetre.
//
// Une entree dont le CodeRace est VIDE est ouverte a tous : c'est Marienburg, que le
// livre dispense de la condition d'origine ("who hires anyone").
Function AppartenancesCandidates(CodeMetier: String; CodeRace: String;
                                 DejaAcquises: String): String;
Var
  PBonus:  StructureCareerBonus;
  Acquis:  TStringList;
  Ind:     Integer;
  Trouve:  Boolean;
Begin
  Result := '';
  if Trim(CodeMetier) = '' then
    Exit;

  Acquis := TStringList.Create;
  try
    if Trim(DejaAcquises) <> '' then
      ExtractStrings([','], [], PChar(DejaAcquises), Acquis);

    for PBonus in ListCareerBonus do
      begin
        if not CompareRechercheValeur(PBonus.CodeMetier, CodeMetier) then
          continue;
        if (Trim(PBonus.CodeRace) <> '') and
           (not CompareRechercheValeur(PBonus.CodeRace, CodeRace)) then
          continue;

        Trouve := false;
        for Ind := 0 to Acquis.Count - 1 do
          if CompareRechercheValeur(Trim(Acquis[Ind]), PBonus.CodeBonus) then
            begin
              Trouve := true;
              break;
            end;
        if Trouve then
          continue;

        if Result = '' then
          Result := PBonus.CodeBonus
        else
          Result := Result + ',' + PBonus.CodeBonus;
      end;
  finally
    Acquis.Free;
  end;
End;

Function CheminMetierImage(CodeMetier: String): String;
  var
    PMetier:        StructureMetier;
    ResTrans:     String;
    ResNormal:    String;
    Res:          String;
    Dossier:      String;
  begin
    for PMetier in ListMetier do
      if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
        Begin
          // NOM DE FICHIER = CODE COMPLET, prefixe de livre inclus. Tous les livres
          // partagent un seul dossier ; nommer les images sur le code AMPUTE (CodeValeur)
          // interdisait a deux livres d'avoir chacun leur WORK001 et forcait la numerotation
          // continue entre supplements.
          //
          Dossier   := GetCurrentDir+StringReplace(ConstCheminImageMetier, ConstLivre, PMetier.Livre, [rfReplaceAll]);
          ResTrans  := Dossier+PMetier.CodeMetier+ConstTransparent+'.PNG';
          ResNormal := Dossier+PMetier.CodeMetier+'.PNG';
          if not FileExists(ResTrans) then
            if FileExists(ResNormal) then
              if (Not TestPixelZeroZero(ResNormal)) then
                RemplacerPixelParTransparent(ResNormal,ResTrans);

          if FileExists(ResTrans) then
            Res    := ResTrans
          else
            Res    := ResNormal;

          break;
        end;
    Result := Res;
  end;

// Dossier declare par un METIER, chaine vide s'il n'en declare pas.
Function DossierNiveauMetier(CodeMetier: String): String;
  var
    PMetier:  StructureMetier;
  begin
    Result := '';
    for PMetier in ListMetier do
      if CompareRechercheValeur(PMetier.CodeMetier, CodeMetier) then
        begin
          Result := Trim(PMetier.DossierNiveau);
          break;
        end;
  end;

// Icone de niveau vue depuis un METIER SEUL. C'est le cas de WinMetier, qui affiche un
// metier sans savoir quelle ethnie le joue - la branche "Possible species" en liste
// souvent plusieurs.
Function CheminNiveauImageMetier(CodeMetier: String; Niveau: Integer): String;
  begin
    Result := CheminNiveauDossier(DossierNiveauMetier(CodeMetier), Niveau);
  end;

// Resolution complete pour une vue qui connait A LA FOIS le metier et l'ethnie, comme la
// fiche de personnage. LE METIER L'EMPORTE, et la raison n'est pas esthetique : un metier
// ne declare un dossier que s'il vient d'un livre, et il n'existe que si ce livre est
// charge. Sa declaration prouve donc que le supplement est actif, ce que l'ethnie seule ne
// dit pas. Si le metier ne declare rien, on retombe sur l'ethnie, puis sa race, puis le
// dossier generique.
Function CheminNiveauImageMetierRace(CodeMetier: String; CodeRace: String; Niveau: Integer): String;
  var
    Dossier: String;
  begin
    Dossier := DossierNiveauMetier(CodeMetier);
    if Dossier <> '' then
      Result := CheminNiveauDossier(Dossier, Niveau)
    else
      Result := CheminNiveauImage(CodeRace, Niveau);
  end;

// Vrai si CodeMetier declare CodeParent parmi ses carrieres parentes. Le champ MetierParent
// peut en contenir plusieurs, separees par SeparateurMulti - d'ou le decoupage plutot qu'une
// simple egalite, qui ferait repondre "non" a un metier dont le parent cherche n'est pas le
// premier de la liste.
//
// Un metier sans parent - l'immense majorite - sort immediatement : cette fonction est
// appelee sur TOUS les metiers charges a chaque ouverture de la combo.
Function EstMetierEnfantDe(CodeMetier: String; CodeParent: String): Boolean;
  var
    PMetier: StructureMetier;
    Liste:   TStringList;
    Ind:     Integer;
  begin
    Result  := false;
    if (Trim(CodeMetier) = '') or (Trim(CodeParent) = '') then
      Exit;
    PMetier := ChercheMetier(CodeMetier);
    if Trim(PMetier.MetierParent) = '' then
      Exit;
    Liste := TStringList.Create;
    try
      ExtractStrings([SeparateurMulti], [], PChar(PMetier.MetierParent), Liste);
      for Ind := 0 to Liste.Count - 1 do
        if CompareRechercheValeur(Trim(Liste[Ind]), CodeParent) then
          begin
            Result := true;
            break;
          end;
    finally
      Liste.Free;
    end;
  end;

end.
