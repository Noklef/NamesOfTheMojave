# Checkpoint 1 — Spike test

> Historical. The spike files and `deploy.ps1 -Spike` were removed after Checkpoint 1. They are in git history up to tag `v0.1-engine`. Results: `docs/decisions.md`.

One game session, about 10 minutes. Tests which engine functions work from ESP-less text scripts.

## Install (MO2)
1. Run `.\deploy.ps1 -Spike` from the repo root.
2. In MO2, press F5 (refresh) and enable `Names of the Mojave`. Load order does not matter (no ESP).

## Run
1. Start the game. At the main menu open the console (`~`) and type `scof "NotM_spike.txt"` (quotes required: without them the dot makes the console parse it as `reference.function`). Close the console.
2. Load a save **outdoors, near 3 or more generic NPCs** (e.g. NCR troopers at Mojave Outpost or Camp McCarran, or a raider group).
3. Close the console and wait about **15 seconds** in normal gameplay.
4. Point the crosshair at several nearby NPCs. Note the names shown.
5. If possible: enter VATS on one, or talk to a friendly one. Note the name shown there.
6. **Save** to a new slot, then **load that save** and wait 15 seconds again.
7. Quit the game.

## Send back
- Short notes: names seen in crosshair, VATS, dialogue.
- Logs: nothing to send. Claude reads `NotM_spike.txt`, `jip_ln_nvse.log` and `nvse.log` from the MO2 `overwrite` folder.

## Reading the output
Every test prints `NotM Spike<n>: START` and `END`, plus:
- `PASS` / `FAIL` — the script checked its own result.
- `INFO` — raw values for analysis.

| Seen | Meaning |
|---|---|
| `FAIL did not compile` | Compile failure. `nvse.log` shows why |
| `START` without `END` | Runtime abort partway through |
| `START` … `END` with `PASS` | Works |

## Expected results
| Test | PASS looks like |
|---|---|
| 00 Versions | `INFO` lines with xNVSE / JIP / JohnnyGuitar / ShowOff versions |
| 1 Walk | `PASS n actors found` + `INFO` lines |
| 1b–1e | `INFO` lines only (base forms, ref index, ID string) |
| 2 RefName | `PASS n of n actors renamed per-ref` **and** in-game NPCs show `NotM Alpha` / `NotM Beta` |
| 2b RefNameVar | `PASS ... reads [NotM Dynamic 7]` **and** one NPC shows that name in-game |
| 3 Callback | `INFO tick 1`, `INFO tick 2`, `PASS tick 3 reached` about 2 s apart |
| 4 Seed | First load: `INFO ... CREATED`. After save + reload: `PASS ... FOUND` |
| 5 Files | `PASS INI value 42` and `PASS file read ...` |
| 6 Compile | `PASS call returned 42` |

No `NotM` lines at all: the harness did not compile. `nvse.log` shows why.

## Cleanup
Run `.\deploy.ps1` (without `-Spike`) to remove the spike files. Renames are session-only. The spike seed values stay in the save co-save; they are tiny and harmless.
