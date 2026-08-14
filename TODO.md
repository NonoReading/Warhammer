# Warhammer — TODO / Backlog

Liste à plat, pas encore commencé. On ajoute une ligne dès qu'une idée apparaît,
sans se poser de question de structure. Quand un item passe en travail actif, il migre
vers la section "en cours" du chantier concerné dans `CONTEXT.md` (avec les détails
techniques). Quand il est fait, il disparaît d'ici et une ligne résumée part dans
`CHANGELOG.md` — il ne reste jamais indéfiniment dans les deux fichiers à la fois.

---

## WinCreation
- [ ] Nettoyer les blocs commentés (`PhaseSave`, `PageEtapesChange`, `AfficheImageRace`)
- [ ] Supprimer du `.lfm` les anciens composants (4 GroupBox, 8 radios, 3 séries spin/Valider)
- [ ] Améliorer l'affichage de `TWinLanceDes` (boutons qui débordent)

## Général
- [ ] Passe globale sur les libellés `LAB_xxx`/`MESS_xxx` (reportée)
- [ ] Coquille `LAB_130` : « Spéc**u**lation choisie » → « Spécialisation choisie »
- [ ] Appliquer `GridAjouteColonne` (déjà écrite dans `ChargeConstantes`) aux nouvelles
      grilles pour supprimer les indices en dur (⚠️ passer les grilles en mode `Columns`,
      tester avec `OnPrepareCanvas`)
- [ ] `ColAugmTalLib` trop étroite pour les libellés spécialisés
- [ ] `TabAugmentationTalentDblClick`, branche "ajouter un talent" : utilise par erreur
      les constantes compétence (`ColCompLib`, `ColAugmCompLib`) au lieu de `ColAugmTalLib`
- [ ] `VerifieRecherche` vit dans `ChargeConstantes` mais n'est appelée que depuis `UnitCalcul`
- [ ] Entrées fantômes type `<Skill id="RULES-COMPCOMB_2M/COMPCOMB_FLEAU">` : construire
      le libellé à la volée en joignant les branches par "ou" plutôt que de les supprimer
- [ ] Le menu des livres retrouve le fichier par le libellé → renommer les fichiers XML
      (supprimer les espaces) casserait le lien ; chantier isolé si besoin
- [ ] `ChargeImageNiveau`/`ColorList` locales à WinPersonnage → mutualisables dans
      `ChargeConstantes` si besoin de couleurs partagées
- [ ] Le protocole par variables globales (`ChoixWinTalent`, `SelectWinTalent`, etc.)
      grossit ; passer par des propriétés de fiche serait plus sûr (pas urgent)
- [ ] `AdjustGridColumnsWidth` appelle `ScaleFormToDesign(96)` alors que les `.lfm` sont
      en `DesignTimePPI = 120` → écart d'échelle compensé à la main par `AddHeight`/`AddWidth`

## WinLivre
- [ ] Phase ÉDITION (toggle sélection, édition chance, sauvegarde/annulation XML)
- [ ] Aide à la saisie de formules (Dégâts/Portée/Durée)

## Nouveaux chantiers (non démarrés)
- [ ] Versionning des éléments entre livres/suppléments (voir CONTEXT.md §2.3)
- [ ] Stratégie d'enregistrement/sauvegarde des données (à détailler — discussion en cours)
