# Checkpoint 3: release test

One game session, about 30 minutes. It tests the add-on format (Phase 1), the MCM page, all five pools, and the items Checkpoint 2 did not cover (ShowRole, new game).

## Install (MO2)
1. Run `.\deploy.ps1` from the repo root.
2. In MO2, create a **separate** empty mod named `NotM Test Addon` (not inside the Names of the Mojave folder; it acts like a third-party add-on). Copy the `Config` folder from `docs/testing/test_addon/` into it, and enable the mod. It adds one rules file, `99_Test.txt`:
   - `Powder Ganger|NOTM_legion`: override. Powder Gangers get Latin names.
   - `Fiend|-`: disable. Fiends keep the name "Fiend".
   - `NCR Trooper|+NOTM_chinese`: append. Most troopers get wasteland names, and about 1 in 5 gets a Chinese name.
3. Only for the MCM steps (11–13): The Mod Configuration Menu, MCM Extender and UIO must be enabled.

## Run
1. At the main menu, open the console and type `scof "NotM_release.txt"`. Close the console.
2. **Version line:** load a save. Open the console. It must show `[NotM] Names of the Mojave 1.0.0: 205 rules, 5 pools, <n> plugins`. With the test add-on, 205 rules becomes 204, because Fiend is removed.
3. **Override:** near Goodsprings, Powder Gangers have Latin single names.
4. **Disable:** near the Vault 3 area or Freeside, Fiends keep the name "Fiend".
5. **Append:** at an NCR camp (Mojave Outpost, Camp McCarran), look at about 10 troopers. Most have wasteland names; one or two may have Chinese names.
6. **Pools:** check one or two actors for each pool:
   - Legion: Cottonwood Cove or Nipton
   - Ghoul: Underworld (TTW) or the Marked Men (Lonesome Road)
   - Tribal: Zion (Honest Hearts) or Point Lookout
   - Chinese: Anchorage simulation or the Chinese Remnant
   - Female ghouls and female tribals must get female names.
7. **Remove the add-on:** quit, disable `NotM Test Addon`, start again, load the same save. Powder Gangers have wasteland names again, and Fiends are named.
8. **Reload:** save, reload, wait 5 seconds. Note 3 names before and check that they match after.
9. **New game (slow):** start a new game and leave Doc Mitchell's house. Powder Gangers near Goodsprings have different names than in step 8.
10. **Opt-out (optional):** open the console, click a named actor that is not yet named (or reload first), type `AuxVarSetFlt "NotMSkip" 1`, then wait 15 seconds. It keeps its role name until the next load.
11. **MCM page:** open Pause menu > Mod Configuration. "Names of the Mojave" is in the list. The page shows Show role, Scan interval, Debug log, and Version `1.0.0`.
12. **MCM live change:** turn on "Show role after name" and close the menu. Walk to a new area. Newly named actors show `Name (Role)`.
13. **MCM saved:** quit, open `Config\NamesOfTheMojave.ini` in the MO2 mod folder (or `overwrite`). It has `ShowRole=1`. Set it back to 0 in the MCM.
14. Quit.

## Send back
- Short notes for each step: OK, or what you saw instead.
- Logs: nothing to send. Claude reads `NotM_release.txt` and `nvse.log` from the MO2 `overwrite` folder.
