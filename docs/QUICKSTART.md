# OpenLife Godot Quick Start

## Zero-cost launch

1. Extract `OpenLife_Godot_v0.3.0.zip` somewhere writable.
2. Open Godot 4.7.1 stable.
3. Import `project.godot`.
4. Wait for first-time GLB/WAV/PNG/SVG imports.
5. Press F5.

No Python environment is required to play. Python is used only for development/QA tooling.

## Expected first-run surface

- 3D neighborhood, five resident Sims and the HUD appear.
- Object interactions can be queued and routed around occupied Build/Buy cells.
- Build/Buy snaps to a one-meter grid, rejects overlap/out-of-lot footprints, rotates with Z/X and sells for a partial refund.
- CAS can edit identity, age, trait slot 1 and genetics/body-shape fields.
- Saves use `user://openlife_slot_01.json` and preserve a `.bak` previous slot.

## Validation

```bash
python3 tools/run_validation.py
```

With a non-standard Godot binary:

```bash
GODOT_BIN=/path/to/godot python3 tools/run_godot_smoke.py
```

`GODOT SMOKE: SKIP` means runtime remains unverified.

## Optional externally sourced assets

The game does not require them. If you manually download one of the exact publisher packs listed in `docs/resources/ASSET_SOURCE_REPORT.md`, stage it without network automation:

```bash
python3 tools/import_optional_asset_pack.py ~/Downloads/pack.zip \
  --name "Pack Name" \
  --source-page "https://exact.publisher/item"
```

This extracts only after path-safety checks, records SHA-256, and deliberately leaves `data/asset_aliases.json` untouched until you inspect/map replacements.
