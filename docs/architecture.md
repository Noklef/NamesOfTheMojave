# Architecture overview

Status: Phase 1 (section 5) is implemented, and section 1 shows the current engine. Section 2 lists the weaknesses found before Phase 1; Phase 1 fixes A and E. Phases 2–3 are proposals. Details: docs/decisions.md, "Add-on format".

## 1. How it works today

```
ln_NamesOfTheMojave.txt        JIP Script Runner, every load / new game
  └─ Main.gek                  seed, INI, compile UDFs, register callbacks
       ├─ LoadRules.gek        Plugins/*.txt → allowed mod indexes
       │    └─ LoadList.gek    Rules/*.txt → "*NotM:R:<base name>" = pool list
       │                       Names/<pool>/{male,female,surname,_full}.txt → arrays
       ├─ Scan.gek             walk loaded actors → filter → PickName → SetRefName
       │    └─ PickName.gek → Hash.gek   name = f(seed, ref index, attempt)
       ├─ Tick.gek             main-loop callback: Scan on cell change + every N s
       └─ DialogName.gek       DialogMenu handler: speaker label = ref name
```

| Layer | Contents | Persists? |
|---|---|---|
| Code | 1 loader (`ln_*.txt`) and 8 UDF files (`*.gek`), compiled at load | n/a |
| Data | `Plugins/*.txt`, `Rules/*.txt`, `Names/<pool>/*.txt` | files |
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
  Rules/    00_NOTM_*.txt  50_XYZ.txt  loaded in name order; later file wins per key
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

The order follows one rule: **do breaking changes before release, and additive changes after.** When v1.0 ships, the file layout becomes a public API, because add-on authors build against it. If we move `Rules.txt` into a `Rules/` folder after release, every add-on that shipped a `Rules.txt` breaks. A new rule type, such as FormID rules, adds to the format without breaking anything, so it can come later.

### Phase 1: fix the data format (before v1.0)

Goal: every change after v1.0 is either internal or additive. An add-on built for v1.0 keeps working in every v1.x.

Each step is one commit. The steps depend on each other in this order:

| Step | Change | Why here |
|---|---|---|
| 1 | Drop-in folders. `Rules.txt` becomes `Rules/00_NOTM.txt` and `Plugins.txt` becomes `Plugins/NOTM.txt`. LoadRules reads every file in each folder, in name order. | The other steps need more than one rules file to exist. No players have the old layout yet, so no compatibility code is needed. |
| 2 | Override and disable. A later rules file replaces an earlier rule with the same key. `Name\|-` removes it. | Needs step 1, because "later file" only has meaning with several files. |
| 3 | Multi-pool and append. `Name\|A,B` draws from the merged lists. `Name\|+C` adds a pool to the rule that earlier files left. | Needs step 2, because append changes the result of the override pass. |
| 4 | `NotMSkip` opt-out. Scan skips a ref with this public aux var. | It doesn't depend on steps 1–3, but it belongs to the public contract, so it must be in v1.0. |
| 5 | Version line at load, with rule, pool and plugin counts. | Last, so the counts come from the new loader. |

The phase is done when:
- Checkpoint 3 passes with the new loader. The test adds a sample add-on folder with an override, an append and a disable.
- The README documents the format for add-on authors (Step 14).
- Then tag v1.0.0.

### Phase 2: compatibility (v1.x, when players report a need)

These changes only add to the format, so each can ship in any v1.x release.

- **FormID rules** (`FalloutNV.esm:00123ABC|pool`). Do these when the first report comes in about a translated game or a mod that renames generic NPCs. Name rules stay as they are; FormID rules are a second key type next to them.
- **Race override** (`race:Ghoul|NOTM_ghoul`). This fixes weakness D, so ghouls in mixed groups get ghoul names. It is small and can come early in v1.x.
- **Load-time measurement.** Do this before any add-on with very large lists, or when someone reports a slow load. If 5,000 lines are slow, change LoadList to read the whole file at once. The data format stays the same.

### Phase 3: optional features (only on request)

- **Custom event** (`NotM:OnNamed`). Add it when another mod author asks for it. Until then, `NotMSkip` covers the known need.
- **Pick-order setting.** You requested this for the future: full names first, or one draw from all lists. Make it an INI key first.
- **MCM.** Done before v1.0: MCM Extender reads a JSON page, so no ESP is needed. See docs/decisions.md, "MCM".
