# xEdit scripts

FNVEdit scripts that export record data to a `.tsv` file, used to build the rules and name pools.

| Script | Exports | Output |
|---|---|---|
| `NotM_ExportNPCs.pas` | NPCs (`NPC_`) and factions | `NotM_npcs.tsv` (a copy is in `tools/data/`) |
| `NotM_ExportCreatures.pas` | Creatures (`CREA`), e.g. animals and super mutants | `NotM_creatures.tsv` |

## Use

1. Copy the script into FNVEdit's `Edit Scripts` folder.
2. Load the plugins, and wait for "Background Loader: finished" (it is needed for the reference counts).
3. Select the plugins to export, then right-click > Apply Script > the script.
4. The `.tsv` is written to the FNVEdit folder. Only master records are exported; overrides are skipped.

The first line of each .tsv names its columns.
