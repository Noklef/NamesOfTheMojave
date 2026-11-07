# Names

A pool is a folder of name lists. Rules point to it by folder name (e.g. `NOTM_wasteland` → `Names/NOTM_wasteland/`). See `Rules/README.md`.

- A pool loads only when a rule uses it.
- One name per line. Lines starting with `#` are comments. Do not leave empty lines: the first empty line ends the list.
- Every file is optional, but a pool must be able to name both men and women: give it `unisex.txt`, or male and female lists (first or full names). The log warns if it cannot.

## Files

| File                               | Holds                            | Used for                                                                                                |
| ---------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `male.txt`, `female.txt`           | First names                      | By the NPC's sex                                                                                        |
| `unisex.txt`                       | First names                      | Everyone: added to the male or female list                                                              |
| `surname.txt`                      | Surnames                         | After the first name, or after the title (`Ranger Barker`). Without it, NPCs get one name (e.g. Legion) |
| `male_full.txt`, `female_full.txt` | Whole names (e.g. `Mike Dawson`) | By the NPC's sex, tried before first name + surname                                                     |

## How a name is built

1. **Rule with a title** (and Use titles on): title + surname, or title + first name if the pool has no `surname.txt`.
2. **Full name**, if the pool has full names. If the name clashes with a nearby NPC's for 4 tries, the mod switches to step 3 for more choices. A rule with a title and Use titles off skips this step. Both only if the pool has first names: a pool with full names only (e.g. `NOTM_chinese`) always uses them.
3. **First name + surname**, or the first name only if the pool has no `surname.txt`.

## The mod's pools

| Pool               | For                                              |
| ------------------ | ------------------------------------------------ |
| `NOTM_wasteland`   | NCR, gangs, civilians, Brotherhood, Enclave, ... |
| `NOTM_legion`      | Legion: Latin names                              |
| `NOTM_ghoul`       | Ghoul groups                                     |
| `NOTM_tribal`      | Honest Hearts and Point Lookout tribes           |
| `NOTM_chinese`     | Chinese Remnant and the Anchorage simulation     |
| `NOTM_supermutant` | Super mutants and Nightkin                       |
| `NOTM_swampfolk`   | Point Lookout swampfolk                          |
| `NOTM_kids`        | Children                                         |

## Changing the names

- **Your own names:** make your own pool (e.g. `Names/MY_wasteland/`) and point rules to it from your own rules file. To mix it with a mod pool, use `Name|NOTM_wasteland,MY_wasteland`. The mod's files are replaced on update, so edits to them are lost.
- **Add-ons:** ship pools with your own prefix (e.g. `Names/MYADDON_ncr/`), so they never replace the mod's.
- Changing a list mid-playthrough re-rolls the names that come from it, on the next game load (lists load once per game load).
