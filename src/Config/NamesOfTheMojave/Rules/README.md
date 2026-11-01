# Rules

A rule gives actors with one generic name a name from a pool: `Generic name|pool`.

- The generic name must match the in-game name exactly (e.g. `Powder Ganger`).
- The pool is a folder in `Names/` (e.g. `NOTM_wasteland` → `Names/NOTM_wasteland/`).
- Every `.txt` file in this folder is loaded, in name order. The mod's own files start with `00_NOTM_`.
- Lines starting with `#` are comments. Do not leave empty lines: the first empty line ends the list.

## Rule forms

| Form | Effect |
|---|---|
| `Name\|pool` | Sets the rule, or replaces it if an earlier file has one. |
| `Name\|-` | Removes the rule from an earlier file. |
| `Name\|A,B` | Uses several pools. A pool is chosen first (chance by pool size), then a name from it. No spaces around commas. |

## Changing the rules

- **Your own changes:** put them in a new file that loads after the mod's files, e.g. `50_MyRules.txt`. The mod's files are replaced on update.
- **Turn off a whole group:** delete its file (e.g. `00_NOTM_FNV_Legion.txt`), or remove its rules with `Name|-` lines in your own file.
- **Add-ons:** ship your own file (e.g. `50_MyAddon.txt`) and your own pools with your own prefix (e.g. `Names/MYADDON_ncr/`).
