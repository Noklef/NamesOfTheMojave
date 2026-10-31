# Decisions

## Per-actor naming method
- `SetName`, `LNSetName`, `SetFullNameAlt`: change the **base form** → every instance renamed. Rejected.
- `SetBaseForm` (CloneForm + base swap): does not work on NPCs/creatures. Rejected.
- **JIP `SetRefName`**: name on the calling reference only. Session-only (not saved). Read back with `LNGetName`. **Chosen candidate**; confirm in spike test 2.
- Session-only is a benefit: names are re-applied on load from `hash(seed, refID)`, so nothing per-actor goes into the save.

## Script Runner constraints (research)
- Prefixes: `gr_` start, `gl_` load, `gn_` new game, `ln_` load + new game, `gs_` save, `gx_` exit, `xm_` exit to menu.
- Max 16384 bytes per text script file.
- Lambdas max 512 characters → main logic needs a real UDF (spike test 6: `CompileScript`).
- `$` operator not supported → use `(sVar)` inline expression or `LNGetName`.
- Editor IDs not resolved without JohnnyGuitar → use `GetFormFromMod`.

## Data files
- Name lists: plain text, one name per line, read with JIP `ReadStringFromFile` line by line (spike test 5).
- Settings: `Data\Config\NamesOfTheMojave.ini` via JIP `GetINIFloat` (spike test 5).

## Spike results
Pending Checkpoint 1.
