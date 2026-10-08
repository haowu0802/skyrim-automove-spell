# Skyrim AutoMove Spell (SSE)

Aimed spell that places a ground marker; the player **AI-walks** there with real locomotion (works while alt-tabbed if `bAlwaysActive=1`).

## Requirements

- Skyrim Special Edition **1.7.104** (Steam) or compatible AE
- [SKSE64](https://skse.silverlock.org/) matching your runtime
- Address Library not required (Papyrus-only)

## Install (MO2)

1. Enable this mod folder (or copy `AutoMove.esp` + `Scripts/` into a mod).
2. Launch via **skse64_loader**.
3. In-game: `player.addspell <AutoMoveSpell FormID>` (load order dependent; check with `help automove 0`).

## Usage

1. Equip / cast the AutoMove aimed spell at the ground.
2. Character sheathes and walks to the marker (`PathToReference` + `SetPlayerAIDriven`).
3. Cancel: Forward / Back / Strafe / Jump.
4. For background walking: set `bAlwaysActive=1` in `Skyrim.ini` `[General]`.

Walk-only (`WalkRunPercent = 0.0` on the marker script).

## Layout

| Path | Role |
|------|------|
| `AutoMove.esp` | Spell, projectile, explosion, marker ACTI, quest |
| `Scripts/*.pex` | Compiled Papyrus |
| `Source/Scripts/*.psc` | SE CK sources |
| `Scripts/Source/*.psc` | Mirror for older tooling |

## Notes

Not related to the Nexus [Auto Move](https://www.nexusmods.com/skyrimspecialedition/mods/42845) map-marker AI mod.
