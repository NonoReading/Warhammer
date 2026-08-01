# 🔧 DATA_STRUCTURE_XML.md - Complete XML Tree

**Technical structure of all XML data files**

---

## 📂 Available XML Books in DATABASE/

```
DATABASE/
├─ BOOK RULESBOOK.Xml (855 KB - CORE)
│  └─ Base game: Attributes, Skills, Talents, Races (5), Careers (64), Weapons (70), Armor (16)
│
├─ BOOK ARCHIVES OF THE EMPIRE I.Xml (supplement)
├─ BOOK ARCHIVES OF THE EMPIRE II.Xml (supplement)
├─ BOOK ARCHIVES OF THE EMPIRE III.Xml (supplement)
│  └─ Additional careers, skills, talents
│
├─ BOOK GREEN IZ BEST.Xml (Greenskins supplement)
│  └─ Orc & Goblin content
│
├─ BOOK LORDS OF NAGGAROTH.Xml (Dark Elves supplement)
│  └─ Dark Elf careers, talents, gear
│
├─ BOOK WINDS OF MAGIC.Xml (Spellcasting supplement)
│  └─ Spells by lore (Azyr, Chamon, Ghur, etc.)
│
├─ BOOK UP IN ARMS.Xml (Equipment supplement)
│  └─ Additional weapons and armor
│
├─ BOOK SEA OF CLAWS.Xml (Skaven supplement)
│  └─ Skaven races and careers
│
├─ BOOK MIDDENHEIM CITY OF THE WHITE WOLF.Xml (Region guide)
├─ BOOK SALZENMUND CITY OF SALT AND SILVER.Xml (Region guide)
│
└─ ... (other companions and guides)
```

---

## 📊 Complete Data Sections (DATA_*)

### Core Sections

```
DATA_ATTRIBUT (15 attributes)
├─ RULES-ATTR_WS (Weapon Skill)
├─ RULES-ATTR_BS (Ballistic Skill)
├─ RULES-ATTR_S (Strength)
├─ RULES-ATTR_T (Toughness)
├─ RULES-ATTR_I (Intelligence)
├─ RULES-ATTR_Ag (Agility)
├─ RULES-ATTR_Dex (Dexterity)
├─ RULES-ATTR_Int (Intelligence variant)
├─ RULES-ATTR_WP (Willpower)
├─ RULES-ATTR_Fel (Fellowship)
├─ RULES-ATTR_Fate (Fate points)
├─ RULES-ATTR_Resil (Resilience)
├─ RULES-ATTR_Wound (Wounds)
├─ RULES-ATTR_Supp (Support)
└─ RULES-ATTR_Move (Movement)
```

### Skills & Specializations

```
DATA_SKILL (295 skills total)
├─ Combat Skills
│  ├─ RULES-COMPCOMB_BASE (Melee Basic)
│  ├─ RULES-COMPCOMB_HAST (Melee Polearm)
│  ├─ RULES-COMPCOMB_ESCR (Melee Fencing)
│  ├─ RULES-COMPCOMB_FLEAU (Melee Scourge)
│  ├─ RULES-COMPCOMB_CAVAL (Melee Cavalry)
│  ├─ RULES-COMPCOMB_PARAD (Melee Parry)
│  └─ ... (Ranged Bow, Firearms, etc.)
│
├─ Social Skills
│  ├─ RULES-COMPCHARM (Charm)
│  ├─ RULES-COMPCOMM (Leadership)
│  ├─ RULES-COMPINTIM (Intimidate)
│  ├─ RULES-COMPRAGOT (Gossip)
│  ├─ RULES-COMPMARCH (Haggle)
│  └─ ... (Entertain, etc.)
│
├─ Knowledge Skills
│  ├─ RULES-COMPSAVOIR_REG (Lore: Region)
│  ├─ RULES-COMPSAVOIR_CHIM (Lore: Chemistry)
│  ├─ RULES-COMPSAVOIR_POLIT (Lore: Politics)
│  ├─ RULES-COMPSAVOIR_PLANT (Lore: Plants)
│  ├─ RULES-COMPSAVOIR_SCIENC (Lore: Science)
│  └─ ... (295 total skills)
│
└─ DATA_SKILL_SPECIALIZATION
   └─ Specialization variants of skills
```

### Talents & Specializations

```
DATA_TALENT (376 talents total)
├─ Attribute-Modifying
│  ├─ RULES-T0002 "Suave" → +5 Fellowship
│  ├─ RULES-T0003 "Animal Affinity" → WP-based
│  ├─ RULES-T0004 "Ambidextrous" → -10 off-hand penalty
│  └─ ... (many others)
│
├─ Combat Talents
│  ├─ RULES-T0022 "Alley Cat" → Urban combat
│  ├─ RULES-T0026 "Dirty Fighting" → fighting dirty
│  ├─ RULES-T0064 "Flee!" → escape combat
│  └─ ... (many others)
│
├─ Magical Talents
│  ├─ RULES-T0006 "Gunner" → Firearms bonus
│  ├─ RULES-T0051 "Argumentative" → debate bonus
│  └─ ... (various)
│
└─ DATA_TALENT_SPECIALIZATION
   └─ Specialized versions of talents
```

### Character Creation Templates

```
DATA_SPECIE (5 base races + extensions)
├─ RULES-RACE_HUM "Human"
│  ├─ Description language="ENGLISH"
│  ├─ Explanation (lore text)
│  ├─ OPINIONS (NPC quotes about this race)
│  ├─ SUBCHAPTER_ATTR (attribute modifiers)
│  ├─ SUBCHAPTER_SKILL (innate skills)
│  ├─ SUBCHAPTER_TALENT (racial talents)
│  └─ SUBCHAPTER_CAREER (available careers)
│
├─ RULES-RACE_DWAR "Dwarf"
├─ RULES-RACE_HALF "Halfling"
├─ RULES-RACE_HELF "High Elf"
└─ RULES-RACE_WELF "Wood Elf"

DATA_RANDOM_SPECIE
└─ Random generation tables for races
```

### Career Progression

```
DATA_CAREER (64 careers base + extensions)
├─ RULES-WORK01 "Agitator"
│  ├─ Description (career name)
│  ├─ Explanation (lore text)
│  ├─ Class (CLASS_BURG, CLASS_ACAD, etc.)
│  ├─ Skill (main skill of career)
│  │
│  ├─ SUBCHAPTER_LEVEL (4 levels)
│  │  ├─ Level 1: Pamphleteer, Salary: TIERS_BRASS 1
│  │  ├─ Level 2: Stirrer, Salary: TIERS_BRASS 2
│  │  ├─ Level 3: Troublemaker, Salary: TIERS_BRASS 3
│  │  └─ Level 4: Demagogue, Salary: TIERS_BRASS 5
│  │
│  ├─ SUBCHAPTER_ATTR (attributes modified per level)
│  │  ├─ RULES-ATTR_WS: +3
│  │  ├─ RULES-ATTR_BS: +1
│  │  └─ ... (per level breakdowns)
│  │
│  ├─ SUBCHAPTER_SKILL (skills gained)
│  │  ├─ RULES-COMPCHARM: +1
│  │  ├─ RULES-COMPMARCH: +1
│  │  └─ ... (numbered skills per level)
│  │
│  ├─ SUBCHAPTER_TALENT (talents granted)
│  │  ├─ RULES-T0010 "Blather": Level 1
│  │  ├─ RULES-T0022 "Alley Cat": Level 2
│  │  └─ ... (talents per level)
│  │
│  └─ SUBCHAPTER_ITEM (starting equipment)
│     ├─ writing set (level 1)
│     ├─ hammer and nails (level 1)
│     ├─ impressive hat (level 4)
│     └─ ... (gear per level)
│
├─ RULES-WORK02 "Apothecary"
├─ RULES-WORK03 "Artisan"
├─ ... (64 careers total)
└─ DATA_RANDOM_TALENT
   └─ Random talent tables
```

### Equipment

```
DATA_WEAPON (70 weapons total)
├─ RULES-COMB_* (melee weapons)
│  ├─ RULES-COMB_HAST_01 "Quarter Staff"
│  │  ├─ Description
│  │  ├─ Skill: RULES-COMPCOMB_HAST
│  │  ├─ Damage: +(STR)+4
│  │  ├─ Reach: LONG
│  │  ├─ Price: 3/-
│  │  ├─ Encumbrance: 2
│  │  ├─ Quality: WEAPB04, WEAPB08
│  │  ├─ Hand: 2 (two-handed)
│  │  └─ Ammunition: 0
│  │
│  ├─ RULES-COMB_HAST_02 "Halberd"
│  └─ ... (many weapons)
│
├─ DATA_WEAPON_BONUS
│  └─ Weapon quality modifiers
│
└─ RULES-COMB_*
   └─ Missile weapons (bows, crossbows, firearms)

DATA_ARMOR (16 armor pieces total)
├─ RULES-ARMOR_* "Light/Medium/Heavy Armor"
│  ├─ Description
│  ├─ Protection: 1-3 points
│  ├─ Encumbrance: 1-4
│  ├─ Price: variable
│  └─ Location: Head, Torso, Limbs
│
├─ DATA_ARMOR_SIMP (simplified armor)
└─ DATA_ARMOR_BONUS (armor quality modifiers)
```

### Translations & Labels

```
DATA_LABEL (500+ translation pairs)
├─ Text name="RULES-SPECIE_HUMAN": "Human"
├─ Text name="RULES-SPECIE_DWARF": "Dwarf"
├─ Text name="RULES-SPECIE_ELF": "Elf"
├─ Text name="RULES-WORK01": "Agitator"
├─ Text name="RULES-WORK02": "Apothecary"
├─ Text name="RULES-SKILL_*": "Skill Name"
├─ Text name="RULES-ATTR_WS": "Weapon Skill"
├─ Text name="RULES-T0002": "Suave"
└─ ... (mappings for all major elements)
```

### Spells & Magic

```
DATA_SPELL (varies by supplement)
├─ Lores
│  ├─ AZYR "Winds of Heaven" (light magic)
│  ├─ CHAMON "Golden Road" (light magic)
│  ├─ GHUR "Purple Sun" (light magic)
│  ├─ HYSH "Celestial Light" (light magic)
│  ├─ AQSHY "Bright Fire" (bright magic)
│  ├─ SHYISH "Grey Wind" (bright magic)
│  ├─ ULGU "Murky Dusk" (dark magic)
│  └─ DHAR "Black Wind" (dark magic)
│
├─ Miracles
│  ├─ Sigmarite (Order priests)
│  ├─ Ulrican (War priests)
│  ├─ Taalist (Nature priests)
│  └─ ... (various religions)
│
└─ Each spell has:
   ├─ Casting Number
   ├─ Range
   ├─ Duration
   ├─ Effect description
   └─ Related talent requirements
```

### Other Sections

```
DATA_CRAFTMANSHIP
└─ Crafting and trade rules

DATA_CORRUPTION_PHYSICAL
└─ Physical mutations from chaos

DATA_CORRUPTION_MENTAL
└─ Mental corruption from chaos

DATA_ATTRIBUT_COST
└─ XP costs for attribute improvements

DATA_SKILL_COST
└─ XP costs for skill improvements

DATA_BOOK
└─ Reference to source books
```

---

## 🔍 XML Element Patterns

### Generic Element Format

```xml
<ElementType id="CODE_ID">
  <Description language="ENGLISH">Display Name</Description>
  <Explanation language="ENGLISH">Lore text / detailed description</Explanation>
  <Attribute/SubChapter elements.../>
</ElementType>
```

### Race (Specie) Format

```xml
<Specie id="RULES-RACE_HUM">
  <Description language="ENGLISH">Humans (Reikland)</Description>
  <Explanation language="ENGLISH">Lore about humans...</Explanation>
  <OPINIONS>
    <Opinion target="RULES-RACE_DWAR" source="NPC Name">
      NPC quote about dwarves...
    </Opinion>
  </OPINIONS>
  <SUBCHAPTER_ATTR>
    <Attribut name="RULES-ATTR_WS">2d10+20</Attribut>
    ... (all 15 attributes)
  </SUBCHAPTER_ATTR>
  <SUBCHAPTER_SKILL>
    <Skill>RULES-COMPCALM</Skill>
    <Skill>RULES-COMPCHARM</Skill>
    ... (innate skills)
  </SUBCHAPTER_SKILL>
  <SUBCHAPTER_TALENT>
    <Talent>RULES-T0002/T0117</Talent>
    <Talent>RULES-T*</Talent>
    ... (racial talents)
  </SUBCHAPTER_TALENT>
  <SUBCHAPTER_CAREER>
    <Career name="RULES-WORK02">01</Career>
    <Career name="RULES-WORK31">02</Career>
    ... (available careers)
  </SUBCHAPTER_CAREER>
</Specie>
```

### Career Format

```xml
<Career id="RULES-WORK01">
  <Description language="ENGLISH">Agitator</Description>
  <Explanation language="ENGLISH">Lore about agitators...</Explanation>
  <Skill>RULES-COMPCHARM</Skill>
  <Class>CLASS_BURG</Class>
  <SUBCHAPTER_LEVEL>
    <Level id="1">
      <Description language="ENGLISH">Pamphleteer</Description>
      <Salary>TIERS_BRASS 1</Salary>
    </Level>
    ... (levels 2-4)
  </SUBCHAPTER_LEVEL>
  <SUBCHAPTER_ATTR>
    <Attribut name="RULES-ATTR_WS">3</Attribut>
    <Attribut name="RULES-ATTR_I">4</Attribut>
    ... (per-level modifiers)
  </SUBCHAPTER_ATTR>
  <SUBCHAPTER_SKILL>
    <Skill name="RULES-COMPART_ECR">1</Skill>
    <Skill name="RULES-COMPCHARM">1</Skill>
    ... (skills with ranks)
  </SUBCHAPTER_SKILL>
  <SUBCHAPTER_TALENT>
    <Talent name="RULES-T0010">1</Talent>
    <Talent name="RULES-T0022">2</Talent>
    ... (talents with levels)
  </SUBCHAPTER_TALENT>
  <SUBCHAPTER_ITEM>
    <Item name="writing set">1</Item>
    <Item name="RULES-ARMO_04">2</Item>
    ... (starting equipment)
  </SUBCHAPTER_ITEM>
</Career>
```

### Talent Format

```xml
<Talent id="RULES-T0002">
  <Attribut>RULES-ATTR_Fel</Attribut>
  <ModifyCarac name="RULES-ATTR_Fel">+5</ModifyCarac>
  <Description language="ENGLISH">Suave</Description>
  <Explanation language="ENGLISH">You gain +5 Fellowship bonus...</Explanation>
  <Max>1</Max>
  <Test language="ENGLISH">Fellowship test</Test>
</Talent>
```

---

## 📝 KEY INSIGHTS FOR WINLIVRE

1. **DATA_LABEL is ESSENTIAL** → Maps CODE → "Pretty Name"
   - `RULES-RACE_HUM → "Human"`
   - `RULES-WORK01 → "Agitator"`
   - Use this for TreeView display!

2. **Each book can add content** → Extensions = new races, careers, talents
   - Must load book-specific DATA_LABEL for translations

3. **ID patterns are consistent** → Makes parsing predictable
   - `RULES-RACE_*`, `RULES-WORK*`, `RULES-SKILL_*`

4. **Relationships are coded** → Career lists available races, etc.
   - `<Career name="RULES-WORK02">01</Career>` inside `<Specie>`

5. **Hierarchical structure** → Uses SUBCHAPTER for grouping
   - Easy to navigate with TreeView

---

**This structure powers all character creation in Warhammer V4!** 🎯
