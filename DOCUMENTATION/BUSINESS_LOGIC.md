# 🧠 BUSINESS_LOGIC.md - Warhammer V4 Data Relationships

**Understanding how all Warhammer data interconnects**

---

## 1️⃣ Foundation: ATTRIBUTES

**10 Base Attributes** (defined in DATA_ATTRIBUT)

```
Physical Attributes:
  ├─ WS (Weapon Skill) → Melee combat accuracy
  ├─ BS (Ballistic Skill) → Ranged combat accuracy
  ├─ S (Strength) → Damage in melee
  ├─ T (Toughness) → Hit points / wound resistance
  └─ Ag (Agility) → Dodge, attack speed

Mental Attributes:
  ├─ I (Intelligence) → Perception, analysis
  ├─ WP (Willpower) → Magic, influence, resistance
  └─ Fel (Fellowship/Charisma) → Social interactions

Special Attributes:
  ├─ Dex (Dexterity) → Fine motor control
  └─ Others (Fate, Resilience, Wounds, Supp, Move)
```

---

## 2️⃣ Race Selection: SPECIE

**Race = Starting template with:**

```
RULES-RACE_HUM (Human - Humans)
├─ Attribute Modifiers: +2d10+20 (all balanced)
├─ Innate Skills: Cool, Charm, Melee (Basic), Ranged (Bow), etc.
├─ Racial Talents: Suave/Savvy (choice), Doomed, + 3 Random
├─ Available Careers: 30+ (most open to humans)
└─ Special Rules: "Ambitious", extra fate points

RULES-RACE_DWAR (Dwarf - Dwarves)
├─ Attribute Modifiers: +T (high toughness), -Ag (low agility)
├─ Innate Skills: Melee (Polearm), Ranged (Bow), Trade (Mining), etc.
├─ Racial Talents: Dwarven talents only
├─ Available Careers: ~15 (dwarf-specific)
└─ Special Rules: Stone sense, grudge memory

RULES-RACE_HELF (High Elf)
├─ Attribute Modifiers: +Ag, -S (high agility, low strength)
├─ Innate Skills: Melee (Fencing), Ranged (Bow), Lore (Region), etc.
├─ Racial Talents: Elven talents only
├─ Available Careers: ~20 (elven careers)
└─ Special Rules: Grace, long-lived perspective
```

---

## 3️⃣ Career Progression: CAREER

**Career = 4-Level Progression Path**

```
RULES-WORK01 "Agitator"
│
├─ Level 1: "Pamphleteer"
│  ├─ Attributes Modified: +3 I (Intelligence), +2 Ag (Agility)
│  ├─ Skills Added: Charm, Gossip, Art (Writing), Trade (Printing), +5 more
│  ├─ Talents Added: Blather, Panhandle, Read/Write, Gregarious
│  └─ Salary: TIERS_BRASS 1 (lowest)
│
├─ Level 2: "Stirrer"
│  ├─ Attributes Modified: +1 BS (Ballistic Skill)
│  ├─ New Skills: Cool +1, Leadership +1
│  ├─ New Talents: Alley Cat, Argumentative, Impassioned Zeal
│  └─ Salary: TIERS_BRASS 2
│
├─ Level 3: "Troublemaker"
│  ├─ Attributes Modified: +1 WS (Weapon Skill)
│  ├─ New Skills: Athletics +1, Melee (Basic) +1
│  ├─ New Talents: Dirty Fighting, Flee!, Cat-tongued
│  └─ Salary: TIERS_BRASS 3
│
└─ Level 4: "Demagogue"
   ├─ Attributes Modified: +1 Fel (Fellowship)
   ├─ Elite Skills: Intimidate +1, Perception +1
   ├─ Final Talents: Suave, Master Orator, Schemer, Etiquette
   └─ Salary: TIERS_BRASS 5 (reward for 4 levels)

Career Class: CLASS_BURG (Urban/Burgher)
  └─ Emphasis: Social skills, negotiation, urban life
```

**Other Career Classes:**
```
CLASS_WARRIOR → Combat focus
CLASS_ACAD (Academic) → Knowledge focus
CLASS_PRIEST → Religious/Magic focus
CLASS_RANGER → Wilderness focus
```

---

## 4️⃣ Skills: SKILL

**Skill = Attribute-based Test Specialty**

```
Combat Skills:
  ├─ RULES-COMPCOMB_BASE "Melee (Basic)"
  │  ├─ Attribute: WS (Weapon Skill)
  │  └─ Used for: Unarmed, hand weapons, improvised
  │
  ├─ RULES-COMPCOMB_HAST "Melee (Polearm)"
  │  ├─ Attribute: WS
  │  └─ Used for: Spears, halberds, pikes
  │
  ├─ RULES-COMPCOMB_ESCR "Melee (Fencing)"
  │  ├─ Attribute: WS
  │  └─ Used for: Swords, elegant fighting
  │
  └─ RULES-COMPPROJ_ARC "Ranged (Bow)"
     ├─ Attribute: BS (Ballistic Skill)
     └─ Used for: Bows, crossbows

Social Skills:
  ├─ RULES-COMPCHARM "Charm"
  │  ├─ Attribute: Fel (Fellowship)
  │  └─ Used for: Seduction, persuasion
  │
  ├─ RULES-COMPCOMM "Leadership"
  │  ├─ Attribute: Fel
  │  └─ Used for: Commanding troops, giving orders
  │
  └─ RULES-COMPINTIM "Intimidate"
     ├─ Attribute: WP (Willpower)
     └─ Used for: Threats, fear

Knowledge Skills:
  ├─ RULES-COMPSAVOIR_REG "Lore (Region)"
  │  ├─ Attribute: I (Intelligence)
  │  └─ Used for: Geography, local knowledge
  │
  ├─ RULES-COMPSAVOIR_CHIM "Lore (Chemistry)"
  │  ├─ Attribute: I
  │  └─ Used for: Alchemy, potions
  │
  └─ RULES-COMPSAVOIR_POLIT "Lore (Politics)"
     ├─ Attribute: I
     └─ Used for: Political intrigue, court knowledge
```

---

## 5️⃣ Talents: TALENT

**Talent = Special Ability, gained via:**
- **Career** (automatic per level)
- **Race** (racial talent at start)
- **Random** (loot table pull)

```
Attribute-Modifying Talents:
  └─ RULES-T0002 "Suave"
     ├─ Linked to: RULES-ATTR_Fel (Fellowship)
     ├─ Effect: +5 permanent Fellowship bonus
     ├─ Max: 1 (can only take once)
     └─ Stacks with: Other talents

Scaling Talents (with limits):
  └─ RULES-T0005 "Pure Soul"
     ├─ Linked to: RULES-ATTR_WP (Willpower)
     ├─ Effect: Bonus Corruption resistance (max = WP value)
     └─ Max: WP times (can take multiple ranks)

Skill-Modifying Talents:
  └─ RULES-T0006 "Gunner"
     ├─ Modifies: RULES-COMPPROJPOUDRE (Ranged Firearms)
     ├─ Effect: Bonus to Firearms skill
     └─ Max: Variable

Combat Talents:
  └─ RULES-T0004 "Ambidextrous"
     ├─ Effect: -10 penalty for off-hand instead of -20
     ├─ Max: 2 ranks (second rank = no penalty)
     └─ Combat advantage
```

---

## 6️⃣ Equipment: WEAPON & ARMOR

**Weapons** (RULES-COMB_*)

```
Quarter Staff (RULES-COMB_HAST_01)
├─ Skill Required: RULES-COMPCOMB_HAST (Melee Polearm)
├─ Damage: +(Strength)+4
├─ Reach: LONG (can attack from distance)
├─ Price: 3 Shillings (cheap)
├─ Encumbrance: 2 (slightly heavy)
├─ Qualities: WEAPB04 (common), WEAPB08 (sturdy)
├─ Hands: 2 (two-handed)
└─ Ammo: None

Halberd (RULES-COMB_HAST_02)
├─ Skill Required: RULES-COMPCOMB_HAST
├─ Damage: +(Strength)+4
├─ Reach: LONG
├─ Price: 2 Crowns (expensive)
├─ Encumbrance: 3 (heavy)
├─ Qualities: WEAPB08, WEAPB30, WEAPB12 (high quality)
├─ Hands: 2
└─ Ammo: None
```

**Armors** (RULES-ARMOR_*)

```
Light Armor
├─ Protection: 1 point
├─ Encumbrance: 1
├─ Price: Cheap
└─ Mobility: Full

Heavy Armor
├─ Protection: 3 points
├─ Encumbrance: 4
├─ Price: Expensive
└─ Mobility: Reduced
```

---

## 7️⃣ Complete Character Flow

```
STEP 1: CREATE CHARACTER
  │
  ├─ Choose RACE (RULES-RACE_HUM, etc.)
  │  ├─ Sets base attributes (2d10+20 or modified)
  │  ├─ Grants innate skills (~12 starting)
  │  ├─ Grants racial talents
  │  └─ Limits available careers
  │
  └─ Choose FIRST CAREER (RULES-WORK01 Agitator, etc.)
     ├─ Level 1 activated
     ├─ Attributes modified (+3 I, +2 Ag, etc.)
     ├─ Skills added (Charm, Gossip, Writing, +5 more)
     ├─ Talents granted (Blather, Panhandle, etc.)
     └─ Starting equipment (flyers, hammer, nails, etc.)

STEP 2: LEVEL UP (Character Advancement)
  │
  ├─ Spend 100 XP → Move to Career Level 2
  │  ├─ Attributes: +1 BS
  │  ├─ Skills: Cool +1, Leadership +1
  │  ├─ Talents: Alley Cat, Argumentative, Impassioned Zeal
  │  └─ Salary: TIERS_BRASS 2
  │
  ├─ Spend 100 XP → Move to Career Level 3
  │  ├─ Attributes: +1 WS
  │  ├─ Skills: Athletics +1, Melee +1
  │  ├─ Talents: Dirty Fighting, Flee!, etc.
  │  └─ Salary: TIERS_BRASS 3
  │
  └─ Spend 100 XP → Move to Career Level 4
     ├─ Attributes: +1 Fel
     ├─ Skills: Intimidate +1, Perception +1
     ├─ Talents: Suave, Master Orator, Schemer
     └─ Salary: TIERS_BRASS 5

STEP 3: USE IN GAME
  │
  ├─ Combat: Use Melee (Basic) skill + WS attribute + talents
  │  └─ Roll: d20 + (WS/10) + Melee Ranks + Talents - Enemy Defense
  │
  ├─ Social: Use Charm skill + Fel attribute + talents
  │  └─ Test: d20 + (Fel/10) + Charm Ranks + Talents
  │
  └─ Equipment: Buy weapons/armor matching skills
     ├─ Need "Melee (Polearm)" → Buy Spear/Halberd
     ├─ Need "Ranged (Bow)" → Buy Bow
     └─ Encumbrance limits what you carry
```

---

## 🔗 Key Relationships

| From | To | Link Type |
|------|----|---------  |
| Race | Career | Race limits which careers available |
| Career | Attributes | Each level modifies specific attributes |
| Career | Skills | Each level adds/upgrades skills |
| Career | Talents | Each level grants talents |
| Skill | Weapon | Weapon requires matching skill |
| Attribute | Test | Test result = d20 + (Attr/10) + skill |
| Talent | Attribute | Some talents modify attributes |
| Talent | Skill | Some talents modify skills |

---

## 📊 Example: "Agitator Wizard"

```
Base: Humain (RULES-RACE_HUM)
  ├─ WS: 2d10+20 = ~25
  ├─ BS: 2d10+20 = ~25
  ├─ Fel: 2d10+20 = ~25
  └─ Talents: Suave, Doomed, + 3 Random

Career L1: Agitator "Pamphleteer"
  ├─ WS: +3 I → Intelligence bonus
  ├─ Ag: +2 Agility → More dodge
  ├─ Skills: Charm, Gossip, Writing, Leadership, etc.
  └─ Talents: Blather, Panhandle, Read/Write, Gregarious

Career L2: Still Agitator "Stirrer"
  ├─ BS: +1 (ranged skill)
  ├─ New Skills: Cool +1, Leadership +1
  └─ New Talents: Alley Cat, Argumentative

Later: Switch to Career: Wizard!
  ├─ Requires: Intelligence check
  ├─ New Talents: Magic Lore, Channelling
  └─ Can now cast spells

Result: Charismatic orator who can cast spells!
```

---

**This logic underpins everything in WinLivre!** 🎯
