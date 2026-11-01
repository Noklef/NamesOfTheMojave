# Decisions

## Per-actor naming method
- `SetName`, `LNSetName`, `SetFullNameAlt`: change the **base form** → every instance renamed. Rejected.
- `SetBaseForm` (CloneForm + base swap): does not work on NPCs/creatures. Rejected.
- **JIP `SetRefName`**: name on the calling reference only. Session-only (not saved). Read back with `LNGetName`. **Chosen.** Confirmed in run 3: crosshair and console show the ref name, base name unchanged.
- Gap: the dialogue menu header still shows the base name. Fix in the engine: on DialogMenu open, set the header tile to the speaker ref name (JIP UI functions).
- Session-only is a benefit: names are re-applied on load from `hash(seed, refID)`, so nothing per-actor goes into the save.

## Script Runner constraints (research)
- Prefixes: `gr_` start, `gl_` load, `gn_` new game, `ln_` load + new game, `gs_` save, `gx_` exit, `xm_` exit to menu.
- Max 16384 bytes per text script file.
- Expressions in parentheses, including inline lambdas, are capped at 512 characters (confirmed in run 2). Main logic goes in UDF files.
- `CompileScript` paths are relative to `Data\NVSE\user_defined_functions\` (same as HeatHaze-ESPLess and 3D Grenade Indicator).
- `$` operator not supported → use `(sVar)` inline expression or `LNGetName`.
- Editor IDs not resolved without JohnnyGuitar → use `GetFormFromMod`.
- `player` is a compiler keyword, not an editor ID: it works in `CompileScript` UDFs (HeatHaze-ESPLess uses it). Used for the player instead of `GetFormFromMod "FalloutNV.esm" "000014"`.
- Log file: every `[NotM]` line goes through `Log.gek` to `NamesOfTheMojave.log` only, not the console (per-NPC lines would flood it) in the game folder, or `overwrite/Root/` under MO2 Root Builder (JIP `WriteStringToFile`, which adds the line break itself). Main starts a new file on each load. JIP `ModLogPrint` does not work here: it skips scripts with no plugin (mod index 0xFF), and `CompileScript` scripts have none.
- Log levels: `Log.gek` takes `INFO`, `WARN` or `DEBUG`, a label for the kind of line. Every level is always written, so a bug report already has the full detail without a debug option. INFO: the startup line. WARN: config errors (bad rule line, no installed plugin, no rules, a pool with no male names). DEBUG: rule replaced or removed (with the file), name counts per pool, and each NPC named (pool, try; try 8 = repeat) or left unnamed. No line per skipped NPC: it would repeat for every NPC on every scan. The Debug option (INI, MCM) was removed with the console output (2026-11-01).
- Tick timer: `GetSecondsPassed` returns one frame's time, not the time since the last call (measured 2026-11-01: two calls in one tick return the same value; ~60 ticks per 10 s scan at ~190 FPS). Tick runs every 30 frames, so it adds `GetSecondsPassed * 30`.
- Reserved variable names fail to compile (e.g. `iMod`). `;` inside a string starts a comment.
- Put a command call in parentheses when an operator follows it, e.g. `(floor (x / m)) * m`, so the command cannot take the rest as its argument.
- Command arguments are 32-bit floats: exact integers only up to 2^24 (16.7M). Do large-number math with operators (64-bit) only. Engine run 1: `floor (fX / fSize)` with fX near 2^31 gave negative picks for about 37% of actors, and a negative index returns the last list entry.

## Data files
- Name lists: plain text, one name per line, read with JIP `ReadStringFromFile` line by line (spike test 5).
- Settings: `Data\Config\NamesOfTheMojave.ini` via JIP `GetINIFloat` (spike test 5).

## Spike results
Run 1 (2026-10-31): NVSE 6.49, JIP LN 57.30, JohnnyGuitar 5.28, ShowOff present.
- gl_ scripts run: both seed aux vars (private and `_` public) are in the co-save.
- No console output captured. Cause: gl_ scripts run during the load screen and prints there are lost. Fix: delay output with `CallAfter 3`.
- Spike2 compile error: `iMod` is not a valid variable name (reserved). Renamed to `iParity`.
- Spike3 compile error: `;` inside a string literal starts a comment. Do not put `;` in strings.

Run 2:
- `CallAfter 3 (begin function {} ... end)` wrapper exceeded the 512-char expression cap in 8 of 12 tests. Those did not compile, Spike2 and 2b among them, so no NPC was renamed.
- Short tests 0, 1b–1e ran and printed after load, so the delay fixes the lost output.
- 1b: leveled actors get a runtime base (`67…` form, mod index of the save); placed refs keep the real base.
- Fix: tests moved to UDF files in `user_defined_functions/NamesOfTheMojave/Spike/`. One `gl_` script compiles `RunAll.txt` and calls it with `CallAfter 3`.

Run 3: all 12 tests PASS. Checkpoint 1 complete.
- Spike2/2b: per-ref names work, base names unchanged. Dialogue header shows the base name (see gap above).
- Spike3: main-loop callback with a compiled UDF ticks in GameMode and unregisters itself.
- Spike4: private and public seeds persist across save and reload.
- Spike5: INI read works. `ReadStringFromFile` lines are 1-based with no trailing CR/LF. Past EOF returns an empty string.
- Spike6: `CompileScript` + `Call` with an argument and a return value work.
- `GetPluginVersion "ShowOffNVSE"` returns -1: wrong name. Not needed yet.

## Classification: which actors are generic (FNVEdit export, 2026-10-31)
Data: `tools/xedit/NotM_ExportNPCs.pas` over FalloutNV.esm, all DLCs, Fallout3.esm and TaleOfTwoWastelands.esm. 7102 NPC_ records.
- No ACBS flag marks unique NPCs. Respawn and No Low Level Processing are more common on generics, but not reliable.
- Generic names repeat across many records: NCR Trooper 357, Raider 285, Enclave Soldier 221, Fiend 123, Powder Ganger 80. 1038 names appear on one record only (unique NPCs).
- Leveled lists: only 2608 of 7102 records are in a leveled list, and many generics are placed directly. Not usable as the generic test alone.
- Faction: named NPCs share factions with generics. Not usable as the generic test.

Decision: the rules file maps **generic base name → pool** (`Powder Ganger|NOTM_wasteland`).
- A unique NPC never matches, because its name is not in the list.
- One entry covers every gear and level variant, in every DLC.
- Planned with the ghoul and super mutant pools: race overrides the pool.
- Creatures are skipped (first with `GetIsCreature`; since 2026-11-01 `GetFirstRef 42` returns NPCs only, so creatures never reach the loop).
- Only bases from FalloutNV.esm, the DLCs, Fallout3.esm and TaleOfTwoWastelands.esm count (mod NPCs excluded).
- Known limit: translated games need translated rule names.

## Known limits
- Duplicate re-roll depends on scan order and on which actors are loaded. An actor that needed a re-roll can get a different name after a reload. Actors without a collision keep their name.
- `ReadStringFromFile` strips a trailing CR: CRLF data files work (engine run 2, 205 rules, 67 actors named).

## Checkpoint 2 results (2026-10-31)
Run 1: LoadRules.txt failed to compile (`ar_Size aParts == 2`), no names. Fixed with parentheses.
Run 2: names given, but the float32 `floor` bug sent 35% of picks to the last list entry. Hash rewritten with operators.
Run 3 (205 rules, CRLF files): PASS.
- 67 actors named in 13 generic roles; no unique NPC renamed (Easy Pete checked in game).
- Legion pool gives Latin names, female NPCs get female names, no surname over 3 in 67.
- VATS and dialogue header show the name.
- Full restart: 27 of 27 actors seen in both sessions kept the same name.
- Not tested: ShowRole=1, new game.

## Name pools: lore names and full names (2026-10-31)
- Pools use lore names only (docs/research/lore_names.md). Drafted lists are kept by the user in `temp/Names_backup/` (not shipped).
- Per pool: `male.txt`, `female.txt`, `surname.txt`, `male_full.txt`, `female_full.txt`. All optional.
- Pick order (user choice "full names first"): attempts 0-3 pick an exact full name; attempts 4-7 mix first name + surname. A pool with only full names uses them on every attempt.
- Effect: most actors get an exact lore name, so the same full name can appear in different areas. Duplicates are only avoided among loaded actors.
- Legion, tribal and chinese: lore names plus drafted names (lore has too few). Chinese uses only full-name lists, because the surname comes first. Ghoul: pre-war lore names from FO3 and FNV.
- Future option (user request): choose the pick order (full first / shared draw) in settings. MCM needs an ESP, so INI first.

## Add-on format, Phase 1 (2026-10-31)
- Rules and plugin lists are drop-in folders: `Config/NamesOfTheMojave/Rules/*.txt` and `Plugins/*.txt`. Every `.txt` file loads. Add-ons ship their own file, so no add-on edits ours.
- Rule files are sorted by name before loading. MO2 merges folders from several mods, so the folder listing order is not guaranteed. Our files start with `00_NOTM_` (one file per group); add-ons use a higher prefix to load after them.
- Rule forms: `Name|pool` sets or replaces, `Name|-` removes, `Name|A,B` uses several pools.
- `Name|+C` (append a pool to an earlier rule) was removed before v1.0: no shipped rule used it, and it was the most complex form. To extend a rule, an add-on replaces it with `Name|A,B`, naming the earlier pools too.
- `Name|-` stays (2026-11-01): unlike `+C`, it has no other way to do it. Without it, the only ways to stop a type being named are editing or deleting core files (an update puts them back, and an add-on cannot do it) or `NotMSkip` (one NPC, script only).
- No `return` inside a `while` loop (2026-11-01): xNVSE Loops.cpp only frees a loop that ends by its condition or `break`. NameNPC runs inside Scan's loop, so it leaves its retry loop with `break` and returns after the loop.
- Multi-pool pick: first choose one pool, weighted by its total names (`*NotM:NameCount:<pool>`), then pick the name from that pool only. Reason: merging the lists would mix styles (a Chinese surname after a wasteland first name), and "full names first" would favour pools that have full-name lists.
- `NotMSkip`: other mods set this public aux var to 1 on an actor, and Scan skips it. An actor that is already named keeps its name until the next load.
- Every load prints one line: `[NotM] Names of the Mojave <version>: <n> rules, <n> pools, <n> plugins`. The version is set once in `Main.txt` (`*NotM:Version`).

## MCM (2026-10-31)
- Settings page via MCM Extender: one JSON file, `Data/MCM/NamesOfTheMojave.json`. No ESP, no new script. MCM, MCM Extender and UIO are optional; without them the INI works as before.
- Each option writes its INI key (`saveFile` is `Config/NamesOfTheMojave.ini`) and the matching temp aux var on the player (`*NotM:ShowRole`, `*NotM:ScanInterval`). Scan and Tick read those aux vars on every run, so changes apply at once without the `MCMExtUpdate` event.
- ShowRole changes only actors named after the change. Already-named actors update on the next load, because ref names are session-only.
- The version line reads `*NotM:Version`.
- Not included yet: the pick-order setting (full names first or one draw). It needs an engine change first.

## Rules split per group (2026-10-31)
- `Rules/00_NOTM.txt` is split into one file per group (e.g. `00_NOTM_FNV_Legion.txt`). A player turns off a whole group by deleting its file. The format notes moved to `Rules/README.md`, so each rules file has a 2-line header.
- No rule name appears in two of our files, so the load order between them does not matter.

## Add-ons for other mods (2026-11-01)
- The core mod covers only Fallout 3, Fallout: New Vegas, their DLCs and TTW. Support for another mod's NPCs is a separate add-on in `addons/<Mod>/`, shipped on its own. Reason: the core rules and plugin list stay free of third-party content.
- First add-on: TLD Travelers. A Plugins file allows `TLD_Travelers.esm` (its actors use its own NPC records, so the core list skips them). A rules file adds 66 TLD-only generic names to the NOTM pools.
- Rules match by name in every allowed plugin. Two TLD names (Prospector Merchant, NCR Sergeant) also exist once in vanilla, so the add-on names those two vanilla NPCs as well.
- More add-ons from a full load-order export (2026-11-01): Long 15 Reloaded, Dry Wells Reloaded, A World of Pain Revised. Chosen because each has many NPC records that already match core rules but stay unnamed until their plugin is listed. Rules skip personal names, corpse labels, names used only by corpses (editor IDs with DEAD), Lobotomites, and names whose vanilla records are dialogue or quest NPCs.

## Script file extension (2026-11-01)
- UDF scripts in `NVSE/user_defined_functions/NamesOfTheMojave/` use `.gek`. CompileScript takes the full file name, so any extension works; MCM Extender uses `.gek` the same way. Reason: scripts are clearly apart from the `.txt` data files, and editors with GECK script support highlight them.
- The loader stays `ln_NamesOfTheMojave.txt`: JIP Script Runner loads only `.txt` files from `NVSE/plugins/scripts/`.
