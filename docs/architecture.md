# Architecture overview

Status: sections 1–2 describe the current engine. Sections 3–5 are proposals, not implemented.

## 1. How it works today

```
ln_NamesOfTheMojave.txt        JIP Script Runner, every load / new game
  └─ Main.txt                  seed, INI, compile UDFs, register callbacks
       ├─ LoadRules.txt        Plugins.txt → allowed mod indexes
       │    └─ LoadList.txt    Rules.txt → "*NotM:R:<base name>" = pool
       │                       Names/<pool>/{male,female,surname,_full}.txt → arrays
       ├─ Scan.txt             walk loaded actors → filter → PickName → SetRefName
       │    └─ PickName.txt → Hash.txt   name = f(seed, ref index, attempt)
       ├─ Tick.txt             main-loop callback: Scan on cell change + every N s
       └─ DialogName.txt       DialogMenu handler: speaker label = ref name
```

| Layer | Contents | Persists? |
|---|---|---|
| Code | 9 UDF text files, compiled at load | n/a |
| Data | `Plugins.txt`, `Rules.txt`, `Names/<pool>/*.txt` | files |
| State | 1 value: `NotMSeed` on the player (JIP co-save) | save |
| Runtime | rules, pools, settings in temp `*NotM:` aux vars | rebuilt each load |

Strengths to keep:
- No ESP. Nothing goes into the save except one float. Uninstalling is clean.
- Names are derived, not stored. Cell resets and despawns need no cleanup.
- Fully data-driven: adding a group or a pool needs no code change.
- It respects other mods: Scan skips an actor whose ref name already differs from its base name.

## 2. Weaknesses for expansion (most serious first)

**A. One shared file per concern means add-ons conflict.**
- An add-on (e.g. "NCR Names") can ship its own `Names/XYZ_ncr/` folder with no conflict, because pools have a prefix.
- But to use that pool, it must change `Rules.txt`.
- To name its own NPCs, it must change `Plugins.txt`.
- To add names to `NOTM_wasteland`, it must replace `male.txt`.

All three are single files, so two add-ons overwrite each other, or overwrite our updates.

**B. Changing any list re-rolls names.** The hash returns an index, so adding or removing one line shifts every pick from that list. If a player installs an add-on mid-playthrough, every affected NPC gets a new name.

**C. Matching by display name.**
- Pros: one rule covers every record with that name. The rules port to FO3 and non-TTW games unchanged.
- Cons:
  - A translated game (German "Plünderer") matches nothing.
  - A mod that renames a generic NPC (e.g. "Fiend" → "Fiend Junkie") silently breaks the match.

**D. The pool is chosen by rule, not race.** Ghoul Wastelanders (14) and ghoul Tenpenny residents (10) get wasteland names.

**E. No version or diagnostics.** The log doesn't show the loaded version or how many rules and pools were loaded. Nexus support reports are hard to triage.

**F. Load cost with big lists has not been measured.** `LoadList` calls `ReadStringFromFile` once per line. That is fine for 200 lines. Measure a 5,000-name list before supporting add-ons that large.

## 3. Proposed target architecture

Everything becomes a drop-in folder, and rules can combine pools. No new dependency: JIP LN already provides [`GetFilesInFolder`](https://geckwiki.com/index.php/GetFilesInFolder) (alias [`GetFiles`](https://geck.uesp.net/wiki/GetFiles)) with wildcard filters.

```
Config/NamesOfTheMojave/
  Plugins/  NOTM.txt  XYZ.txt          all files merged
  Rules/    00_NOTM.txt  50_XYZ.txt    loaded in name order; later file wins per key
  Names/    NOTM_wasteland/ ...  XYZ_ncr/ ...
```

Rule syntax (backward compatible):

```
Raider|NOTM_wasteland                  as today
NCR Trooper|XYZ_ncr,NOTM_wasteland     multi-pool: lists merged into one draw
Raider|+XYZ_raiders                    append a pool to an existing rule (no override)
Ghoul Trooper|-                        disable a rule from an earlier file
```

- **Multi-pool draw:** at load, merge the listed pools into one combined array (key e.g. `XYZ_ncr,NOTM_wasteland`). Then pick as today. Each pool's weight equals its size, and full-names-first still applies. PickName needs no change; LoadRules gains the merge.
- **`+` append:** two add-ons can both extend Raiders without overwriting each other. Together, override, append and multi-pool cover "replace", "extend" and "combine". No one needs to edit another mod's pool files.
- **Opt-out for other mods:** a public aux var on a ref (e.g. `NotMSkip = 1`) makes Scan skip that actor. This is a stable contract for other authors.
- **Version line at load:** e.g. `[NotM] v1.0.0: 205 rules, 5 pools, 13 plugins`.

Later, if there is demand:
- **FormID rules** (`FalloutNV.esm:00123ABC|pool`) next to name rules. These fix localization and renamed NPCs.
- **Race override** (`race:Ghoul|NOTM_ghoul`).
- **Custom xNVSE event** (e.g. `NotM:OnNamed`), for mods that react when an NPC is named.
- **Name stability (B):** document "install name add-ons on a new game", or store assigned names per ref. Storing costs save data and gives up the "nothing in the save" strength. Document first.

## 4. Example add-on on Nexus

```
Data/Config/NamesOfTheMojave/
  Rules/50_NCRNames.txt          NCR Trooper|NCRN_ncr,NOTM_wasteland
  Names/NCRN_ncr/male_full.txt   ...
```

The add-on has two files and no conflicts with this mod or with other add-ons.

## 5. Recommended order

1. **Before v1.0:**
   - drop-in folders (`Plugins/`, `Rules/`)
   - multi-pool, plus the `+` and `-` rule prefixes
   - the version line
   - the `NotMSkip` opt-out
2. **v1.x:** FormID rules, race override, load-time measurement with a large list.
3. **When needed:** custom event, pick-order setting (INI), MCM (needs an ESP).

The file layout becomes a public API when v1.0 ships. Add-on authors build against it, so changing it later breaks their mods. Engine internals can change at any time, but fix the data format before release.
