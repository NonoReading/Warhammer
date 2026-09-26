# Gabarit de reference pour saisir un nouveau livre (BOOK_*.Xml)

Ce fichier n'est PAS un des trois fichiers de suivi (CONTEXT.md/Log.txt/A FAIRE.txt) : c'est
une reference technique de structure XML, a consulter avant de saisir un nouveau livre au lieu
de rouvrir un livre existant pour retrouver le format a chaque fois. Extension .md volontaire
(pas .Xml) pour ne jamais etre charge comme un livre par le programme.

A METTRE A JOUR si un bloc DATA_* nouveau est rencontre, ou si un champ change de convention.

## En-tete obligatoire de tout BOOK_*.Xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<DATA_BOOK>
<CODE_BOOK>"XXXX"</CODE_BOOK>
<BOOK>"BOOK NOM EN MAJUSCULES SANS PONCTUATION"</BOOK>
<language>"ENGLISH"</language>
<VERSION>"WFRP4"</VERSION>
<OFFICIAL>"1"</OFFICIAL>       <!-- 1 = Cubicle7 officiel, 2 = fan/Community Content -->
<COMPLETE>"1"</COMPLETE>       <!-- 0 tant que la saisie n'est pas finie -->
<DISCLAIMER>"..."</DISCLAIMER> <!-- A NE JAMAIS OUBLIER (rate deux fois de suite, 26/09/2026) :
     copier le texte exact de la page de copyright du livre source (page 2 en general,
     "No part of this publication may be reproduced..." + "(c) Copyright Games Workshop
     Limited [annee]..."). Un livre existant qui n'en a pas est un oubli a corriger, pas
     un exemple a suivre. -->
<DATA_LABEL>
<Label language="ENGLISH">
<Text name="XXXX-BOOK NOM EN MAJUSCULES SANS PONCTUATION">"Titre affiche"</Text>
</Label>
<Label language="FRANCAIS">
<Text name="XXXX-BOOK NOM EN MAJUSCULES SANS PONCTUATION">"Titre affiche"</Text>
</Label>
</DATA_LABEL>
... blocs DATA_* du contenu ...
</DATA_BOOK>
```

- `CODE_BOOK` : prefixe court unique (4-6 lettres), reutilise devant chaque id (`XXXX-...`).
- Le nom du fichier peut avoir des underscores OU des espaces (les deux existent deja dans
  DATABASE/WFRP4) ; la valeur de `<BOOK>` doit correspondre exactement a l'entree ajoutee dans
  `INI.TXT` (cle `BOOKWFRP4=`, liste `[BOOK ...]` concatenee sans separateur) pour que le livre
  soit cochable dans le menu.
- Pas d'apostrophe dans `<BOOK>`/`CODE_BOOK` (aucun livre existant n'en a).

## DATA_SPELL (sorts)

```xml
<DATA_SPELL>
<Sort id="XXXX-CODE_01">
<Description language="ENGLISH">"Nom du sort"</Description>
<Explanation language="ENGLISH">"Texte integral en anglais, guillemets internes sans echappement particulier."</Explanation>
<Target>"1"</Target>                    <!-- ou "You", "AoE (BATTR_WP)m", "AoE (ATTR_WP) miles" -->
<Duration>"Instant"</Duration>          <!-- ou "(BATTR_WP) Rounds/minutes/hours", "(ATTR_WP) days", "Special" -->
<Range>"Touch"</Range>                  <!-- ou "You", "(ATTR_WP)m" -->
<Talent>"RULES-T0088_XXX"</Talent>      <!-- Talent qui donne acces (Domain Magic) ou RULES-T0089 (Minor Magic) -->
<Level>"3"</Level>                      <!-- Casting Number (CN) du livre -->
<TypSpell>"Domain Magic"</TypSpell>     <!-- ou "Minor Magic" pour les Petty Spells -->
</Sort>
</DATA_SPELL>
```

- `(ATTR_WP)` = valeur pleine de Volonte, `(BATTR_WP)` = Bonus de Volonte (meme logique pour
  les autres caracteristiques : `ATTR_S`, `BATTR_S`, etc., a verifier au cas par cas).
- Les 8 Lores arcaniques du Rulebook ont deja leur Talent, pas besoin d'en creer :
  `RULES-T0088_BETE` (Beasts), `RULES-T0088_MORT` (Death), `RULES-T0088_FEU` (Fire),
  `RULES-T0088_CIEUX` (Heavens), `RULES-T0088_METAL` (Metal), `RULES-T0088_VIE` (Life),
  `RULES-T0088_LUMIERE` (Light), `RULES-T0088_OMBRE` (Shadows). Pour une Lore qui n'existe nulle
  part encore (culte, domaine specifique), creer un `DATA_TALENT` generique dedie et y rattacher
  les sorts (convention deja utilisee : GRIM-T0203 "Arcane Magic (Warp)", etc.).
- Petty Spells : `Talent = "RULES-T0089"`, `TypSpell = "Minor Magic"`.

## DATA_TALENT (nouveau talent)

```xml
<DATA_TALENT>
<Talent id="XXXX-T0000">
<Attribut>""</Attribut>
<Description language="ENGLISH">"Nom du talent"</Description>
<Short language="ENGLISH">""</Short>
<Explanation language="ENGLISH">"Texte integral."</Explanation>
<Skill>""</Skill>
<Max>"1"</Max>
<PDF>""</PDF>
<Test language="ENGLISH">"Attribut ou competence testee, ou vide"</Test>
</Talent>
</DATA_TALENT>
```

## DATA_CAREER (nouvelle carriere)

```xml
<DATA_CAREER>
<Career id="XXXX-WORKnnn">
<Description language="ENGLISH">"Nom de la carriere"</Description>
<Explanation language="ENGLISH">"Texte integral."</Explanation>
<Skill>"RULES-COMPCOMB_BASE"</Skill>   <!-- competence "signature" utilisee ailleurs -->
<Class>"RULES-CLASS_WARR"</Class>     <!-- classe (Warrior, Academic, Rogue, etc.) -->
<SUBCHAPTER_LEVEL>
<Level id="1">
<Description language="ENGLISH">"Nom du niveau 1"</Description>
<Salary>"TIERS_BRASS 1"</Salary>
</Level>
<!-- Level id="2", "3", "4"... -->
</SUBCHAPTER_LEVEL>
<SUBCHAPTER_ATTR>
<Attribut name="RULES-ATTR_WS">"1"</Attribut>
<!-- une ligne par caracteristique, valeur = nombre d'avancees offertes -->
</SUBCHAPTER_ATTR>
<SUBCHAPTER_SKILL>
<Skill name="RULES-COMPXXX">"1"</Skill>
  <!-- commentaire = nom anglais de la competence, niveau = numero du Level qui la debloque -->
</SUBCHAPTER_SKILL>
<SUBCHAPTER_TALENT>
<Talent name="RULES-T0000">"1"</Talent>
  <!-- idem, "/" pour un choix ("RULES-T0096/RULES-T0121"), "_*" pour une famille -->
</SUBCHAPTER_TALENT>
<SUBCHAPTER_ITEM>
<Item name="Nom de l'objet ou code RULES-...">"1"</Item>
  <!-- niveau qui debloque l'objet ; repeter la ligne = plusieurs exemplaires -->
</SUBCHAPTER_ITEM>
</Career>
</DATA_CAREER>
```

## Autres blocs deja rencontres (a detailler ici la prochaine fois qu'on les utilise)

`DATA_WEAPON`, `DATA_ARMOR`, `DATA_TRAPPING`, `DATA_SPECIE_CAREER_DIRECT` (rattacher une
carriere a une Race entiere), `DATA_SPECIE_CAREER_CHOICE`, `DATA_SKILL`, `DATA_RACE`,
`DATA_SPECIE`, `DATA_NATION`, `DATA_SPELL_TALENT`. Liste complete des DATA_* existants :
voir `grep -hoE "^<DATA_[A-Z_]+>" DATABASE/WFRP4/*.Xml | sort -u`.

## Pieges connus (voir aussi A FAIRE.txt "REGLES DE METHODE")

- Les commentaires XML `<!-- ... -->` a l'interieur d'un bloc peuvent faire planter le parseur
  ou dupliquer une entree sur certains blocs (DATA_LABEL, DATA_SPECIE_CAREER_CHOICE,
  DATA_SKILL_SPECIALIZATION touches, DATA_ROLL non confirme) : mettre le commentaire de synthese
  AVANT le bloc `<DATA_...>`, pas a l'interieur, sauf sur les blocs deja verifies surs
  (DATA_RACE, DATA_RULE, DATA_CAREER_ROLL, DATA_SPECIE_CAREER_DIRECT, DATA_TALENT,
  DATA_CAREER, DATA_SPELL - tous utilises avec commentaires inline dans les livres existants).
- WinLivre ne sait pas editer `DATA_SPELL_TALENT` : saisie XML a la main uniquement.
