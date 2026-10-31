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
