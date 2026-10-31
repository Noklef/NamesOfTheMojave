# Rules candidates

Source: FNVEdit export (`tools/data/NotM_npcs.tsv`), NPC_ records in FalloutNV.esm, all DLCs, Fallout3.esm and TaleOfTwoWastelands.esm.

## Pools (by naming style)
| Pool | Style | Used for |
|---|---|---|
| `NOTM_wasteland` | American first name + surname | most humans: civilians, gangs, NCR, BoS, Enclave, Capital Wasteland |
| `NOTM_legion` | Latin single name | Caesar's Legion |
| `NOTM_tribal` | descriptive tribal name (e.g. Follows-Chalk) | Honest Hearts tribes, Point Lookout tribals |
| `NOTM_chinese` | Chinese full name, surname first | Chinese Remnant, Anchorage Chinese soldiers |
| `NOTM_ghoul` | old pre-war names | groups that are all ghouls |

You can split a pool later (e.g. `NOTM_ncr`, `NOTM_bos`) by changing the right side of the rule and adding a `Names/<pool>/` folder.

## Included
All included groups are in `src/Config/NamesOfTheMojave/Rules.txt`, grouped by `# --- Group ---` headers. Edit that file directly.

## Undecided (your call)
Number = NPC_ records with that exact name.
- **Anchorage simulation soldiers** (NOTM_wasteland): American Soldier 18 · Strike Team Grenadier / Infantryman / Missile Unit / Sniper 24 each · Power Armored Soldier 8 · American Sniper / Launcher / Inferno Unit / Grease-Monkey 6 each · Crimson Dragoon 4. They are simulation enemies.
- **Children:** Child 7 · Mini Boomer 9 · Little Lamplighter 4.
- **Lobotomite 56** (Old World Blues): mindless, a name may not fit.
- **The Pitt Wildman 7**, **Zeta Test Subject 2**: role not clear from the data.
- **Disguised Hooker 2**: may be a quest disguise.

## Excluded
- **Unique people with several records:** Amata, Butch, Benny, Caesar, Ulysses, Dad, Jonas, Stanley, Sentinel Lyons and all other personal names. Titled people (Ranger Ericsen, Paladin Ramos, Knight Captain Gallows) also stay excluded.
- **Corpses:** Dead Prospector, Dead Settler, Dead Slave, Dead Boomer, Dead King, Burned Body, Corpse, Fiend Corpse, Crucified Slave, Crucified Trooper.
- **Holograms and robots:** Hologram, Starlet Hologram, Starlet, Y-17 Trauma Override Harness, Y-17 Animatronic Lab Skeleton.
- **Editor and test records:** raceCaucasianM01 and the other race presets, Test Liz, DrunkTestMale, DLC05TestNPC, Battlegear *, Used for Dialogue Only, Narrator.
- **Single-character titles:** The Overseer, Strange Man, The Lonesome Drifter.

## Not in this export
- **Super mutants and Nightkin are creature records (CREA)**, not NPC_. The engine skips creatures, so they get no name now. To include them: export CREA records, remove the creature check (the Rules list already limits who is named), and add a super mutant pool.
- "Novac Prospector" does not exist. Novac has "Novac Settler" (6).
