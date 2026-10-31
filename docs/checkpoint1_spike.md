# Checkpoint 1 — Spike test

One game session, about 10 minutes. Tests which engine functions work from ESP-less text scripts.

## Install (MO2)
1. Mod list → right-click → **Create empty mod** → name it `NotM Spike`.
2. Open it in Explorer. Copy the **contents** of the repo `spike/` folder into it (`Config/` and `NVSE/`).
3. Enable it. Load order does not matter (no ESP).

## Run
1. Start the game. At the main menu open the console (`~`) and type `scof NotM_spike.txt`. Close the console.
2. Load a save **outdoors, near 3 or more generic NPCs** (e.g. NCR troopers at Mojave Outpost or Camp McCarran, or a raider group).
3. Close the console and wait about **10 seconds** in normal gameplay.
4. Point the crosshair at several nearby NPCs. Note the names shown.
5. If possible: enter VATS on one, or talk to a friendly one. Note the name shown there.
6. **Save** to a new slot, then **load that save**.
7. Quit the game.

## Send back
- `NotM_spike.txt` — in the game folder or the MO2 `overwrite` folder.
- `jip_ln_nvse.log` — in the game folder.
- Short notes: names seen in crosshair, VATS, dialogue.

## Expected results
| Test | PASS looks like |
|---|---|
| 0 Runner | `NotM Spike0: PASS runner executed` |
| 1 Walk | Lines with ref, base (gbo), name, female flag |
| 1b/1c/1d | Base form lines, numeric ref index, ID string (informational) |
| 2 RefName | In-game: NPCs show **different** names (`NotM Alpha` / `NotM Beta`), not all the same |
| 2b RefNameVar | One NPC shows `NotM Dynamic 7`; console prints names read back |
| 3 Callback | `tick 1`, `tick 2`, `tick 3` about 2 s apart, then stops |
| 4 Seed | First load: `CREATED`. After save + reload: `FOUND` with the same number |
| 5 Files | INI value 42; lines show Mike, Sarah, Joe |
| 6 Compile | `compiled via path ...` and `call returned 42` |

A missing line for a test means that file failed to compile. `jip_ln_nvse.log` shows why.

## Cleanup
Disable `NotM Spike` after the test. Renames are session-only. The spike seed values stay in the save co-save; they are tiny and harmless.
