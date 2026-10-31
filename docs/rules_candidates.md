# Rules candidates

Source: FNVEdit export (`tools/data/NotM_npcs.tsv`), NPC_ records in FalloutNV.esm, all DLCs, Fallout3.esm and TaleOfTwoWastelands.esm.
Number = records with that exact name. Names in Rules.txt must match the in-game name exactly.
Edit freely: delete a line to exclude it, change the pool to move it.
Status: all names under Include are in `mod/Config/NamesOfTheMojave/Rules.txt` (205 rules). Undecided names are not added.

## Proposed pools (by naming style)
| Pool | Style | Used for |
|---|---|---|
| `wasteland` | American first name + surname | most humans: civilians, gangs, NCR, BoS, Enclave, Capital Wasteland |
| `legion` | Latin single name | Caesar's Legion |
| `tribal` | descriptive tribal name (e.g. Follows-Chalk) | Honest Hearts tribes, Point Lookout tribals |
| `chinese` | Chinese first name + surname | Chinese Remnant, Anchorage Chinese soldiers |
| `ghoul` | old pre-war names | groups that are all ghouls |

You can split a pool later (e.g. `ncr`, `bos`) by changing the right side of the rule and adding a `Names/<pool>/` folder.

## Include

### FNV civilians → wasteland
Wastelander 144 (14 are ghouls) · Traveler 79 · Squatter 61 · Local 54 · New Vegas Citizen 52 · Prospector 51 · North Vegas Resident 28 · Traveling Merchant 27 · Scavenger 24 · Westside Resident 21 · NCR Prospector 18 · Refugee 18 · Caravaneer 15 · Chem Addict 13 · Patient 10 · Primm Resident 9 · Escaped Convict 9 · Wasteland Captive 9 · Hunter 8 · Sharecropper 7 · Quarry Worker 7 · Westside Militia 7 · Novac Settler 6 · Mojave Inhabitant 6 · New Vegas Resident 6 · Underpass Citizen 6 · Westside Citizen 6 · Crazed Chem Addict 6 · Goodsprings Settler 5 · Boulder City Worker 5 · Convict 4 · Junkie 4 · Beggar 3 · Destitute Traveler 3 · Rancher 3 · Man 3 · Vault 34 Dweller 3 · Drunk 2 · Merchant 2 · Missionary 2 · Drifter 1 · Vagrant 1 · Water Beggar 1

### FNV groups and services → wasteland
Followers Guard 33 · Followers Doctor 18 · Boomer 40 · Boomer Chef 3 · Injured Boomer 3 · Boomer Guard 2 · Crimson Caravan Guard 16 · Crimson Caravan Trader 4 · Gun Runner Guard 16 · Gun Runner Gunsmith 3 · Bodyguard For Hire 3 · Gunderson Hired Hand 3 · Happy Trails Caravan Guard 3 · Guard 6 · Thug 8 · Greaser 3 · Bodyguard 2 · Clinic Guard 2 · Outer Vegas Defender 2

### The Strip and Freeside → wasteland
Gambler 120 · Gomorrah Prostitute 38 · White Glove 15 · Bartender 11 · Chairman 7 · Tops Promoter 6 · Atomic Wrangler Guard 6 · Card Dealer 5 · Chairman Bodyguard 5 · Vikki And Vance Dealer 5 · Roulette Dealer 4 · Hooker 3 · Rad Pack Dancer 3 · Chairman Greeter 2 · Escort 2 · Gomorrah Dealer 2 · King Groupie 2 · Blackjack Dealer 1 · Casino Guard 1 · Security Officer 1 · White Glove Bouncer 1

### FNV gangs → wasteland
Fiend 123 · Powder Ganger 80 · Powder Ganger Bodyguard 3 · Viper Gunslinger 70 · Viper Leader 8 · Kings Gang Member 56 · Jackal Gang Member 55 · Jackal Gang Leader 17 · Great Khan 36 · Great Khan Warrior 20 · Omerta Thug 29 · Freeside Thug 17 · Westside Thug 3 · Scorpions Gang Member 7 · Van Graff Thug 9 · Mercenary 46 · NCR Mercenary 18 · Slaver 27 · Slave 16

### NCR → wasteland
NCR Trooper 357 · NCR Ranger 124 · Engineer 46 · NCR Heavy Trooper 34 · NCR Veteran Ranger 33 · NCR Military Police 13 · NCR Trooper MP 9 · NCR MP 4 · NCR Ranger Veteran 3 · Injured Trooper 3 · NCR Recruit 2 · NCR Riot Control 2 · Irradiated Heavy Trooper 2 · NCR Sniper 1 · Ghoul Trooper 1

### Caesar's Legion → legion
Recruit Legionary 57 · Prime Legionary 44 · Veteran Legionary 39 · Centurion 24 · Praetorian Guard 14 · Prime Decanus 9 · Recruit Decanus 8 · Legion Explorer 8 · Veteran Decanus 7 · Legion Vexillarius 5 · Legionary Assassin 5 · Legionary Blacksmith 2 · Irradiated Legion Explorer 2 · Legionary 1 · Legionary Recruit 1 · Legion Centurion 1 · Irradiated Legionary Prime 1 · Irradiated Legionary Veteran 1

### Brotherhood of Steel → wasteland
Brotherhood of Steel Paladin 149 · Brotherhood Outcast 97 · Brotherhood of Steel Initiate 72 · Brotherhood of Steel Knight 66 · Brotherhood of Steel Scribe 20 · Brotherhood Scribe 13 · Brotherhood Scout 3

### Enclave → wasteland
Enclave Soldier 221 · Enclave Officer 28 · Enclave Scientist 13 · Enclave Hellfire Trooper 10 · Enclave Doctor 1

### Capital Wasteland (FO3) → wasteland
Raider 285 · Talon Company Merc 90 · Megaton Settler 22 · Tenpenny Resident 22 (10 are ghouls) · Regulator 21 · Rivet City Security 18 · Insane Survivor 16 · Security Guard 8 · Tenpenny Tower Resident 7 · Rock Crick Hunter 6 · Caravan Guard 5 · Child of Atom 4 · Project Purity Scientist 4 · Secretary 4 · Wasteland Settler 3 · Water Caravan Driver 3 · Caravan Trader 2 · Hitman 2 · Scientist 2 · Wasteland Junkie 2 · Wasteland Merchant 2 · Megaton Refugee 1

### The Pitt → wasteland
Pitt Raider 106 · Pitt Slave 67 · Slave Fighter 3 · Raider Fighter 2 · Slave Guard 2

### Point Lookout
Tribal 98 → tribal · Smuggler 90 → wasteland · Bandit 8 → wasteland

### Honest Hearts → tribal
Sorrows Tribal 25 · White Legs Pain-Maker 16 · White Legs Storm-Drummer 15 · White Legs Bone-Breaker 14 · Dead Horse Warrior 11 · Dead Horse Disciple of Canaan 11 · Dead Horse Stalker 10 · Dead Horse Tribal 10 · White Legs Light-Bringer 9 · White Legs Tribal 5 · Captive Sorrows Tribal 1

### Chinese → chinese
Chinese Soldier 11 · Chinese Sniper 7 · Chinese Inferno Unit 6 · Chinese Launcher 6 · Chinese Remnant Soldier 5 · Chinese Remnant Officer 5 · Chinese Remnant Sargeant 3 · Chinese Remnant Sergeant 2

### All ghouls → ghoul
Underworld Resident 21 · Marked Men Scout 22 · Marked Men Hunter 18 · Marked Men Ravager 15 · Marked Men Marauder 10 · Bright Follower 10 · Ghoul Guard 3 · Irradiated Marked Men Hunter 1 · Irradiated Marked Men Scout 1

## Undecided (your call)
- **Anchorage simulation soldiers** (wasteland): American Soldier 18 · Strike Team Grenadier / Infantryman / Missile Unit / Sniper 24 each · Power Armored Soldier 8 · American Sniper / Launcher / Inferno Unit / Grease-Monkey 6 each · Crimson Dragoon 4. They are simulation enemies.
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
