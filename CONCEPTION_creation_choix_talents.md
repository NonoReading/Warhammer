# Conception — Refonte de l'étape « choix » de WinCreation

**Établi le 06/08/2026. À implémenter lors d'une prochaine session.**

---

## Le problème

Un XML de personnage créé contenait :

```xml
<Talent name="RULES-T*">"1"</Talent>            <!-- marqueur jamais résolu -->
<Skill name="RULES-COMPMETIER_*">"5"</Skill>    <!-- 5 points sur un code générique -->
```

L'interface actuelle (groupes de `TRadioGroup` juxtaposés, pagination « 4 sur 8 ») sait **découper**
les choix multiples mais ne sait pas les **résoudre**. Elle ne peut pas non plus accueillir
proprement une liste de 15 spécialités, ni un choix en cascade.

Principe directeur retenu : *un code qui n'est pas encore un vrai code ne doit pas survivre à la
validation.*

---

## La distinction fondatrice

La ligne de partage n'est **pas** « avec ou sans spécialisation », mais **qui décide** :

| Nature | Exemples | Qui décide |
|---|---|---|
| Choix entre talents précis | `RULES-T0002/RULES-T0117` | le joueur |
| Choix d'une spécialité | `RULES-T0136_*` | le joueur |
| Talent aléatoire | `RULES-T*` | le **dé** (D100 dans `DATA_RANDOM_TALENT`) |

D'où **deux tableaux** :

- **Tableau CHOIX** — double-clic → ouvre `TWinSpecialisations`
- **Tableau ALÉATOIRE** — double-clic → lance le D100

---

## Le modèle mémoire

Source de vérité unique ; les grilles ne sont qu'un rendu. Même principe que
`Personnage.MetierTalent`, qui a fait ses preuves.

```pascal
StructureChoixCreation = record
  Origine:     String;   // 'RACE', 'METIER1'... — d'où vient la ligne
  CodeSource:  String;   // le code brut : RULES-T0002/RULES-T0117
  CodeParent:  String;   // '' si racine, sinon le CodeSource qui l'a engendrée
  CodeChoisi:  String;   // vide tant que non résolu
  Aleatoire:   Boolean;  // False = tableau Choix, True = tableau Aléatoire
  Jet:         Integer;  // résultat du D100, 0 si pas encore lancé
end;
```

`CodeParent` est la clé de la réversibilité : il permet de retrouver quelle ligne a engendré quelle
autre, donc de réinjecter un jet de dé après reconstruction.

---

## La reconstruction

Appelée **à chaque changement** dans le tableau Choix. Un seul chemin de code plutôt que six
(ajout / suppression / réordonnancement / aller-retour…).

1. Sauver les jets existants dans une liste temporaire, indexés par `CodeParent + CodeSource`
2. Vider le tableau mémoire
3. Reparcourir les racines (talents de race, talents de métier niveau 1) et les rajouter
4. Pour chaque ligne dont `CodeChoisi` est renseigné et pointe vers un code non résolu,
   ajouter la ligne fille correspondante
5. Réinjecter les jets retrouvés (le dé survit à l'aller-retour)
6. Rafraîchir les deux grilles depuis le tableau mémoire

---

## Le routage entre tableaux

Le routage se fait sur **la nature du code obtenu**, pas sur le fait qu'il y ait cascade :

- `CodeChoisi` est un code concret → la ligne est résolue, rien de plus
- `CodeChoisi` vaut `RULES-T*` → engendre une ligne dans le tableau **Aléatoire**
- `CodeChoisi` est générique (`_*`) → engendre une ligne dans le tableau **Choix**

> Avec la version récursive de `ListeTalent` (voir `CONTEXT_session_20260806.md` §3), les spécialités
> remontent directement dans la liste aplatie. Le seul cas de cascade restant est donc `RULES-T*`
> apparaissant comme option d'un choix — typiquement `RULES-T0171/RULES-T*`.

---

## La règle de validation

**Une ligne du tableau Choix produit un talent, sauf si son choix pointe vers un autre tableau.**

```pascal
// tableau Choix
for chaque ligne do
  if CodeChoisi <> 'RULES-T*' then
    ajouter CodeChoisi aux talents du personnage;
  // sinon : rien — la ligne fille du tableau Aléatoire s'en charge
```

Conséquence voulue : la ligne « Destinée / Talent aléatoire » **reste visible et modifiable** dans
le tableau Choix même après avoir opté pour l'aléatoire. Elle n'est simplement pas *consommée*.

### Pourquoi la réversibilité importe

Cas réel : le joueur coche « Talent aléatoire », puis le MJ lui explique ce qu'implique de ne pas
avoir Destinée. Il doit pouvoir revenir en arrière sans recommencer la création. C'est ainsi qu'une
création de personnage se passe autour d'une table — la décision se prend souvent *après* avoir
coché.

Le jet déjà obtenu est conservé : s'il rechange d'avis, il retrouve son tirage intact
(cf. étape 5 de la reconstruction).

**Garde-fou** : valider = les deux tableaux sont entièrement remplis. Aucun `CodeChoisi` vide,
aucun `Jet` à 0.

---

## Règles WFRP4 à respecter

**Doublon au tirage** : un talent déjà possédé est refusé, on relance.

> À vérifier lors de l'implémentation : faut-il tenir compte de `Max` ? Certains talents sont
> cumulables (Âme pure, limité par la FM). Si oui, le test porte sur « déjà au maximum » plutôt que
> sur « déjà présent ».

**Ordre de résolution** : un tirage peut donner un talent que le joueur choisira ensuite
manuellement, créant un doublon a posteriori.

> **Décision prise** : ne pas bloquer. Bloquer aurait un coût pédagogique élevé (le joueur ne
> comprendrait pas pourquoi tel choix lui est interdit à cet instant) pour un cas rare. On avertit à
> la validation finale, avec la liste de tous les conflits d'un coup — plus simple à coder et moins
> intrusif. Au bout du compte, c'est le MJ qui tranche à la table.

---

## Choix d'interface

**Réutiliser `TWinSpecialisations`** plutôt qu'une déroulante dans la cellule :

- Pas de `PickList` à gérer par ligne (`Columns[i].ButtonStyle := cbsPickList` + `OnSelectEditor`) —
  c'était le point le plus pénible
- Une liste de 15 spécialités s'affiche confortablement dans une vraie fenêtre
- Le protocole existe déjà : `ChoixWinTypeFichier` / `ChoixWinTalent` / `SelectWinTalent`
- Les blocs A/B/C de WinPersonnage sont transposables presque tels quels
- **Le joueur retrouve le même geste dans les deux programmes**

Colonnes techniques (`CodeSource`, `CodeChoisi`, `CodeParent`) en largeur zéro ; colonnes visibles
pour les libellés.

> ⚠️ Attention aux `ColWidths` copiés-collés — c'est le bug qui a coûté une heure le 06/08 : la même
> colonne réglée deux fois, une grille dont la colonne visible n'était pas celle qu'on remplissait.

**À vérifier** : `TWinSpecialisations` sait-elle afficher `RULES-T*` avec un libellé parlant
(« Talent aléatoire ») plutôt que le code brut ? Les `TRadioGroup` actuels le font déjà.

---

## Ce que la refonte règle

Les cinq facettes identifiées ne sont qu'une seule question posée à cinq endroits :

| # | Point | Réglé par |
|---|---|---|
| 1 | Talent aléatoire non résolu | tableau Aléatoire + D100 |
| 2 | Spécialisation de talent à la création | tableau Choix + `TWinSpecialisations` |
| 3 | Cas mixte `RULES-T0136_*/RULES-T0077` | liste aplatie (`ListeTalent` récursive) |
| 4 | Compétences génériques avec points investis | même tableau Choix, `ChoixWinTypeFichier` compétence |
| 5 | Garde-fou de validation | « les deux tableaux sont remplis » |

---

## Piste pour plus tard

Les tableaux Choix ressemblent beaucoup à la grille d'augmentation de WinPersonnage — code, libellé,
colonne de choix, double-clic vers `TWinSpecialisations`. Il y a peut-être là matière à partager du
code entre les deux programmes, une fois les deux stabilisés.
