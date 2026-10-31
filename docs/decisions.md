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

Decision: the rules file maps **generic base name → pool** (`Powder Ganger|wasteland`).
- A unique NPC never matches, because its name is not in the list.
- One entry covers every gear and level variant, in every DLC.
- Planned with the ghoul and super mutant pools: race overrides the pool.
- Creatures are skipped (`GetIsCreature`).
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
