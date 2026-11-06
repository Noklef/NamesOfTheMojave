# Names of the Mojave

Names of the Mojave is an ESPless mod that aims to give NPCs of the wasteland unique & personal names. Things like `Powder Ganger` becomes `Henry Glover`, `Recruit Legionary` becomes `Cassius`, etc.

Unique NPC's are never touched. `Easy Pete` stays `Easy Pete` (unless you want him to).

## Why?

I could only see so many "NCR Troopers" without getting annoyed. And I thought it might be cool to give them each a random name.

## Features

- **ESP-less**: Not adding another .esp to your mod list
- **Per NPC names**: every generic NPC gets their own name, even when 50 of them share the same record
  - **Gender-aware names**
  - **Consistent**: an NPC keeps the same name for the whole playthrough, across saves and reloads. A new game gives new names
  - **No twins**: NPCs loaded at the same time get different names (a repeat only happens if a pool runs out)
- **Super mutants too**: super mutants and Nightkin get names like `Big Tony` or `Gristle`, and Point Lookout's swampfolk get backwoods names
- **Dialogue too**: the dialogue window shows the NPC's new name
- **_TTW Compatible_**: covers New Vegas, its DLCs, and the Fallout 3 side of TTW (Capital Wasteland, Anchorage, The Pitt, Point Lookout). Works on plain New Vegas too: the Fallout 3 content is skipped when it isn't installed.
- Configurable through [MCM Extender](https://www.nexusmods.com/newvegas/mods/93642) (optional) or the INI:
  - **Enabled**: off gives NPCs this mod named their original names back as you come near them
  - **Show role after name**: `Henry Glover (Powder Ganger)` instead of `Henry Glover`
  - **Scan interval**: how often to look for newly spawned NPCs (default 10 seconds)
  - **Use titles**: `Ranger Barker` for ranks the game uses (default on), or `Erik Barker` (a first name in place of the rank)
  - **Name seed** (MCM only): same seed = same names. Change it to give every generic NPC a new name
- (Currently) **287 roles** across **8 name pools** (nearly 1,500 names):
  - **Wasteland**: first + last names for NCR, gangs, civilians, Brotherhood, Enclave, and so on
  - **Legion**: Latin single names
  - **Ghoul**: names for ghoul groups
  - **Tribal**: names for the Honest Hearts and Point Lookout tribes
  - **Chinese**: for the Chinese Remnant and the Anchorage simulation
  - **Super mutant**: plain old-world names and blunt nicknames
  - **Swampfolk**: backwoods names for Point Lookout's swampfolk
  - **Kids**: first names for children
- **Add-on support**: rules and name lists are drop-in text files, so other mods can add their own NPCs without editing this one (see [Add-ons](#add-ons)).
- **Save Friendly**: almost nothing is saved, only one number (the playthrough seed). Names are worked out again each time, so uninstalling is clean.

## Requirements

- [xNVSE](https://www.nexusmods.com/newvegas/mods/67883)
- [JIP LN NVSE](https://www.nexusmods.com/newvegas/mods/58277)
- (Optional, for the settings page) [The Mod Configuration Menu](https://www.nexusmods.com/newvegas/mods/42507), [MCM Extender](https://www.nexusmods.com/newvegas/mods/93642), [UIO](https://www.nexusmods.com/newvegas/mods/57174)

## Installation

- Download the mod file on [NexusMods]()
- Install using Vortex / MO2
- Works on an existing save. Uninstalling is clean: the only thing left in your save is one number (the playthrough seed)

## Add-ons

I created this with the idea that you'd be able to create your own addons for mods that add new NPC's, or if you would like to go and change NPC's names on a whim.
I've gone ahead and created some addons for some mods i've been playing:

| Add-on                                                      | For                                                                           | Nexus Addon Link |
| ----------------------------------------------------------- | ----------------------------------------------------------------------------- | ---------------- |
| [`addons/TLD_Travelers`](addons/TLD_Travelers/)             | [The Living Desert](https://www.nexusmods.com/newvegas/mods/64623)            | N/A              |
| [`addons/Long15Reloaded`](addons/Long15Reloaded/)           | [Long 15 - NCR Expansion](https://www.nexusmods.com/newvegas/mods/94306)      | N/A              |
| [`addons/DryWellsReloaded`](addons/DryWellsReloaded/)       | [Dry Wells - Legion Expansion](https://www.nexusmods.com/newvegas/mods/88180) | N/A              |
| [`addons/AWorldOfPainRevised`](addons/AWorldOfPainRevised/) | [A World of (Less) Pain](https://www.nexusmods.com/newvegas/mods/71139)       | N/A              |
| [`addons/TheFrontier`](addons/TheFrontier/)                 | [Fallout - The Frontier](https://www.nexusmods.com/newvegas/mods/68009)       | N/A              |
| [`addons/TweaksTTW`](addons/TweaksTTW/)                     | [TweaksTTW](https://www.nexusmods.com/newvegas/mods/77934)                    | N/A              |
| [`addons/TrooperUncut`](addons/TrooperUncut/)               | [Trooper's Uncut Merge](https://www.nexusmods.com/newvegas/mods/95700)        | N/A              |
| [`addons/NewCalifornia`](addons/NewCalifornia/)             | [Fallout - New California](https://www.nexusmods.com/newvegas/mods/45138)     | N/A              |
| [`addons/FriendlyAnimals`](addons/FriendlyAnimals/)         | Brahmin and guard dogs (base games, no other mod needed)                      | N/A              |

> NOTE: These have not been thoroughly tested, so if there's bugs please raise a bug

### Add-ons: Creating your own

Want to make your own, or add names? It's all plain text. [`Config/NamesOfTheMojave/Rules/README.md`](src/Config/NamesOfTheMojave/Rules/README.md) explains the format. In short: ship a `Plugins/` file to let your mod's NPCs be named, a `Rules/` file for your generic names, and optionally your own `Names/` pools.

Other mod authors can also stop an NPC from being named by setting the public aux var `_NotMSkip` to 1 on it (the `_` makes it readable by other mods).

## Compatibility Notes

- **Mods that rename NPCs themselves**: fine. If an NPC's name already differs from its record, this mod leaves it alone.
- **Mods that add NPCs**: their NPCs aren't named unless there's an add-on for them (or they reuse a vanilla NPC record).
- **Translated games**: not supported yet. Rules match the English in-game name (`Raider`), so a German "Plünderer" won't match.
- **Changing name lists mid-playthrough** (adding names, installing an add-on) re-rolls the names that use those lists.
- **Ghouls and children in mixed groups** (e.g. ghoul Wastelanders, child Refugees) get wasteland names, because the pool is chosen by the role, not the race.

If something looks off, `NamesOfTheMojave.log` (in the game folder, or `overwrite/Root/` with MO2 Root Builder) shows a load summary (rule, pool and plugin counts), rules that add-ons replaced or removed, bad rule lines, and every NPC that was named.

## AI Disclosure:

I've won't lie, and deny the use of AI to help me develop this implementation. It's been instrumental in taking out the mundaineness of working on this (such as FNVEdit export parsing, build script generation). I've been writing the code as well as reviewing the AI's code as it's been working on it, plus not committing anything that I blindly implemented or didn't understand (outside of `Hash.gek`, as that is the only file I hands-off asked it to implement).

It's been tested in game throughout development.

AI was used in the following ways:

- Scaffolding out an initial barebones implementation
- Researching xNVSE / JIP functions, as well as examples
- Drafting and reviewing the scripts, and finding GECK / NVSE quirks (loops, string parsing, aux vars)
- Building the name lists and rules from FNVEdit exports and lore research
- Building the add-ons for other mods from FNVEdit exports
- Generating the quirky names for some of the groups
- Generating the GitHub release scripts / `build.py` script

Model used: `Claude Opus 5.5`

## Resources / Credits

- [FNVEdit](https://www.nexusmods.com/newvegas/mods/34703) for exporting NPC data
- [GECK Wiki](https://geckwiki.com/) for coming in clutch with knowledge
- [Fallout Wiki](https://fallout.fandom.com/) for lore names
- [JIP LN NVSE](https://www.nexusmods.com/newvegas/mods/58277) for the Script Runner that makes ESP-less mods possible
