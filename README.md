# Names of the Mojave

ESP-less mod for Fallout: New Vegas (TTW). Gives generic NPCs (raiders, Fiends, NCR troopers, settlers, ...) personal names. Unique NPCs are not changed.

Status: in development.

## Requirements
- xNVSE
- JIP LN NVSE
- JohnnyGuitar NVSE
- ShowOff xNVSE

## Repository layout
| Path | Content |
|---|---|
| `src/` | Shipped files. Contents go in the game `Data\` folder (MO2: the mod folder). |
| `spike/` | Development test scripts. Not shipped. |
| `tools/` | Development tools (FNVEdit export script). Not shipped. |
| `docs/` | Design decisions and research. |

## Deploy (development)
`.\deploy.ps1` mirrors `src/` into the MO2 mod folder (default: the BeginAgain-TTW instance; override with `-Target`). Add `-Spike` to include the spike test files. MO2's `meta.ini` is kept.
