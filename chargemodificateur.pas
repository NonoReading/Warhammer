unit ChargeModificateur;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections;

Type
  // Fondation du moteur generique de bonus/malus (CONTEXT.md, chantier "inversion des
  // recherches"). Aujourd'hui, savoir si une arme a un bonus de competence oblige a
  // interroger une fonction differente par source (PersonnageCareerBonusArmeModif,
  // PersonnageTalentArmureModif, PersonnageMutationTalent...) - une fonction de plus a
  // chaque nouveau croisement source x cible.
  //
  // Avec cette structure, chaque source (Talent, Mutation, CareerBonus, equipement...)
  // porte sa propre liste de StructureModificateur, mais TOUTES au meme format : le
  // calcul boucle sur ce que le PERSONNAGE possede reellement (quelques dizaines
  // d'elements) plutot que d'interroger le catalogue complet, donc balayer plusieurs
  // sources a chaque recherche n'a pas d'impact mesurable.
  StructureModificateur = Record
        // Vocabulaire ferme : ModifyCarac / ModifySkill / ModifyWeapon / ModifArmour /
        // ModifyDamage (a ajouter). Distingue quel calcul (competence, arme, armure...)
        // ce modificateur alimente.
        TypeModif:  String;
        // Code de l'element vise : CodeAttribut, CodeCompetence, TypeArme,
        // CodeLocalisation selon TypeModif.
        Cible:      String;
        // Filtre optionnel restreignant Cible (ex. skill= de ModifyWeapon, qui limite
        // un TypeArme a une seule competence). Vide si non utilise.
        Filtre:     String;
        // Additif pour commencer (Cible += Facteur). Proportionnel/Drapeau si un cas
        // reel l'exige, meme vocabulaire que ConstFormeEffet* (chargeconstantes.pas).
        Forme:      String;
        Facteur:    Integer;
        // Code du Talent/Mutation/CareerBonus qui porte ce modificateur, pour
        // affichage/debug - pas utilise par le calcul lui-meme.
        CodeSource: String;
end;

  TListModificateur = Specialize TList<StructureModificateur>;


implementation


end.
