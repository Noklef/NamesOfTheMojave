# Checkpoint 2 — Engine test

One game session, about 20 minutes. Tests the naming engine with the wasteland pool:
Powder Gangers, Prospectors, Wastelanders, Travelers, Squatters, Scavengers.

## Install (MO2)
1. Run `.\deploy.ps1` from the repo root.
2. In the MO2 mod folder, open `Config\NamesOfTheMojave.ini` and set `Debug=1`.

## Run
1. At the main menu open the console and type `scof "NotM_engine.txt"`. Close the console.
2. **Load:** load a save near Goodsprings or Primm (Powder Gangers, Prospectors). Wait 5 seconds.
3. **Names:** point the crosshair at several Powder Gangers. Note 2 or 3 names and who has them.
4. **Not renamed:** check that unique NPCs (e.g. Sunny Smiles, Easy Pete, Ranger Ericsen) and animals keep their normal names.
5. **Gender:** if a female Powder Ganger or Prospector is near, check that she has a female name.
6. **VATS and dialogue:** check one named actor in VATS. Talk to a friendly named actor (e.g. a Prospector) and check the dialogue header.
7. **Cell change:** walk or fast travel to another area with generic NPCs, then come back. The names from step 3 must be the same.
8. **Reload:** save, reload that save, wait 5 seconds. The names from step 3 must be the same.
9. **Spawns:** wait near a road or a caravan route until a new Traveler or Prospector walks in. It must get a name within about 10 seconds.
10. **ShowRole:** quit, set `ShowRole=1` in the INI, start again, load the same save. Names must show as `Name (Powder Ganger)`.
11. **New game (optional, slow):** start a new game and leave Doc Mitchell's house. Powder Gangers near Goodsprings must have **different** names than in step 3.
12. Quit.

## Send back
- Short notes for each step: OK, or what you saw instead.
- Logs: nothing to send. Claude reads `NotM_engine.txt` and `nvse.log` from the MO2 `overwrite` folder.

## Reading the output
With `Debug=1` each name given prints a line:
`[NotM] <ref ID> Powder Ganger -> Mike Dawson (try 0)`
A try above 0 means the first pick was already in use nearby and was re-rolled.
An `[NotM] ERROR` or `WARN` line is a defect.
