# OpenLife Godot v0.3.2 (visual fix) Release Manifest

- Payload files with per-file SHA-256: **495**
- Payload bytes (excluding recursive release metadata): **7943008**
- Recursive metadata files `MANIFEST.md`, `FILE_MANIFEST.json`, and `CHECKSUMS.sha256` are listed below but excluded from their own hash inventory to avoid self-reference.
- The final ZIP receives its own external SHA-256 after packaging.

## Role summary

| Role | Files | Intended use |
|---|---:|---|
| qa | 62 | Tests, validation logs, baseline proof, and comparison evidence |
| reference | 21 | Project documentation, parity evidence, sourcing, and handoff reference |
| runtime-asset | 285 | Bundled offline runtime visual/audio asset |
| runtime-data | 6 | Runtime catalog, tuning, feature, and alias data |
| source | 121 | Godot/runtime/tooling source or root project metadata |
| release-metadata | 3 | Release manifest, per-file inventory, and checksums |

## Package file inventory

| File | Role | Status | Intended use | Notes |
|---|---|---|---|---|
| `CODEX_HANDOFF_MANIFEST.sha256` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `CODEX_TASK.md` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `LICENSE` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `OPERATIONAL_STATE.md` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `README.md` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `RELEASE_NOTES.md` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `asset-policy.json` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/build_place.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/build_place.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/build_sell.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/build_sell.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_birth.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_birth.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_promotion.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_promotion.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_relationship.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_relationship.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_skill.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/event_skill.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/festival_chime.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/festival_chime.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/load_complete.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/load_complete.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/magic_cast.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/magic_cast.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/music_build_loop.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/music_build_loop.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/music_cas_loop.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/music_cas_loop.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/music_live_loop.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/music_live_loop.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_computer.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_computer.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_cook.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_cook.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_music.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_music.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_water.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/object_water.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/portal_open.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/portal_open.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/save_complete.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/save_complete.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_cancel.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_cancel.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_click.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_click.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_confirm.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_confirm.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_money.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_money.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_notification.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/ui_notification.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/weather_thunder.wav` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/audio/weather_thunder.wav.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/manifest.json` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/alchemy_station.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/alchemy_station.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/arcade_machine.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/arcade_machine.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bathtub_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bathtub_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bed_double.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bed_double.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/birthday_cake.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/birthday_cake.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bonfire.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bonfire.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bookshelf_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bookshelf_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bot_charging_station.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/bot_charging_station.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/cafe.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/cafe.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/candy_floor_lamp.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/candy_floor_lamp.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/cat_tree.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/cat_tree.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/chess_table.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/chess_table.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/coffee_maker.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/coffee_maker.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/community_center.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/community_center.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/community_locker.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/community_locker.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/computer_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/computer_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/crib_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/crib_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/desk_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/desk_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dining_chair.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dining_chair.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dining_table.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dining_table.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dishwasher.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dishwasher.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/diving_buoy.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/diving_buoy.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dog_bed.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dog_bed.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dream_pod.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dream_pod.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dresser_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/dresser_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/drum_set.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/drum_set.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/easel_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/easel_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/festival_booth.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/festival_booth.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/fishing_sign.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/fishing_sign.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/food_truck.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/food_truck.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/fridge_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/fridge_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/future_workbench.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/future_workbench.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/garden_planter.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/garden_planter.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/gem_display.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/gem_display.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/grill_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/grill_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/guitar_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/guitar_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/gym_treadmill.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/gym_treadmill.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/highchair.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/highchair.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/horse_trough.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/horse_trough.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/hospital_rabbit_hole.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/hospital_rabbit_hole.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/hot_tub.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/hot_tub.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/house_blue.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/house_blue.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/house_founders.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/house_founders.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/house_rose.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/house_rose.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/industrial_coffee_table.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/industrial_coffee_table.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/inventing_bench.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/inventing_bench.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/karaoke_machine.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/karaoke_machine.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/kitchen_sink.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/kitchen_sink.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/kitchen_stove.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/kitchen_stove.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/laundry_washer.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/laundry_washer.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/luxury_lounge_chair.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/luxury_lounge_chair.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/mailbox_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/mailbox_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/martial_arts_dummy.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/martial_arts_dummy.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/microwave.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/microwave.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/mixology_bar.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/mixology_bar.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/movie_prop_statue.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/movie_prop_statue.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/nectar_maker.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/nectar_maker.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/park_bench.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/park_bench.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/performance_stage.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/performance_stage.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_bowl.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_bowl.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_cat.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_cat.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_dog.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_dog.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_horse.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/pet_horse.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/photo_booth.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/photo_booth.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/piano_upright.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/piano_upright.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/resort_desk.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/resort_desk.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/resort_tower.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/resort_tower.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/retro_dance_console.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/retro_dance_console.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/road_cross.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/road_cross.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/road_straight.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/road_straight.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/rock_cluster.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/rock_cluster.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sculpting_station.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sculpting_station.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/shower_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/shower_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/shrub.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/shrub.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_athletic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_athletic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_average.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_average.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_slender.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_slender.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_soft.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_adult_soft.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_avatar_reference.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_avatar_reference.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_athletic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_athletic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_average.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_average.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_slender.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_slender.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_soft.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_child_soft.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_athletic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_athletic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_average.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_average.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_slender.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_slender.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_soft.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_elder_soft.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_athletic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_athletic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_average.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_average.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_slender.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_slender.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_soft.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sim_teen_soft.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sofa_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sofa_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/spa_vanity.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/spa_vanity.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sport_car_display.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/sport_car_display.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/stereo_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/stereo_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/tattoo_chair.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/tattoo_chair.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/telescope_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/telescope_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/television_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/television_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/time_portal.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/time_portal.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/toilet_basic.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/toilet_basic.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/trash_can.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/trash_can.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/tree_deciduous.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/tree_deciduous.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/tree_pine.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/tree_pine.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/treehouse.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/treehouse.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/university_podium.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/university_podium.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/vehicle_compact.glb` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/models/vehicle_compact.glb.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/floor_tile.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/floor_tile.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/floor_wood.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/floor_wood.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/stone_paver.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/stone_paver.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/terrain_grass.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/terrain_grass.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/terrain_road.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/terrain_road.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/wallpaper_blue.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/wallpaper_blue.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/wallpaper_cream.png` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/textures/wallpaper_cream.png.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/map.svg` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/map.svg.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/mode_build.svg` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/mode_build.svg.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/mode_cas.svg` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/mode_cas.svg.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/mode_live.svg` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/mode_live.svg.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/save.svg` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `assets/generated/ui/save.svg.import` | runtime-asset | included | Bundled offline runtime visual/audio asset | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `data/asset_aliases.json` | runtime-data | included | Runtime catalog, tuning, feature, and alias data | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `data/career_catalog.json` | runtime-data | included | Runtime catalog, tuning, feature, and alias data | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `data/feature_ledger.json` | runtime-data | included | Runtime catalog, tuning, feature, and alias data | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `data/object_catalog.json` | runtime-data | included | Runtime catalog, tuning, feature, and alias data | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `data/pack_registry.json` | runtime-data | included | Runtime catalog, tuning, feature, and alias data | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `data/trait_catalog.json` | runtime-data | included | Runtime catalog, tuning, feature, and alias data | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/ADVERSARIAL_REVIEW.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/ARCHITECTURE.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/CLEAN_ROOM.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/EXPANSION_CONTRACTS.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/FEATURE_MATRIX.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/IMPROVEMENT_REPORT.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/PARITY_TARGET.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/QUICKSTART.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/REQUIREMENT_LEDGER.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/RUNTIME_TEST_CHECKLIST.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/SAVE_SCHEMA.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/SOURCES.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/ASSET_SOURCE_REPORT.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/AUDIO_ASSET_MANIFEST.json` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/CREDITS.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/THIRD_PARTY_NOTICES.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/VISUAL_ASSET_MANIFEST.json` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/evidence/EXTERNAL_SOURCE_EVIDENCE.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/evidence/README.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/unified-resource-gap-map.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `docs/resources/visual-rejections.md` | reference | included | Project documentation, parity evidence, sourcing, and handoff reference | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `icon.svg` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `project.godot` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/CODEX_BUG_SWEEP_REPORT.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/CODEX_BUG_SWEEP_SEED.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/CODEX_HANDOFF_STATIC_VALIDATION.txt` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/GODOT_RUNTIME_VALIDATION.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/VALIDATION_REPORT.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/baseline_godot_import.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/baseline_python_validation.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/final_godot_import.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/final_integration_test.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/final_smoke_test.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/full_validation.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/gui_launch.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/handoff_zip.sha256` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/codex/release_verification.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/evidence/BUG_SWEEP_REPORT.pre-codex-v0.3.0.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/evidence/OPERATIONAL_STATE.invalid-v0.3.0.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/BASELINE_PROVENANCE.md` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/baseline_asset_contact_sheet.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/baseline_asset_contact_sheet.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/baseline_asset_metrics.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/baseline_metrics.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/baseline_validation-v0.2.0.txt` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/before_after_asset_contact_sheet.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/before_after_asset_contact_sheet.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/before_after_asset_proof.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/before_after_asset_proof.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/final_asset_contact_sheet.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/final_asset_contact_sheet.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/final_asset_metrics.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/final_asset_summary.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/final_metrics.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/final_metrics_stdout.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/improvement/improvement_delta.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/operational-state-handoff-validation.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/operational-state-validation.json` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/validation-v0.3.0.txt` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/after_capture.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/after_visual_fix.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/after_visual_fix.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/before_capture.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/before_visual_fix.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/before_visual_fix.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/diagnostic.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/diagnostic_probe.png` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/diagnostic_probe.png.import` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `qa/visual/visual_scene_test.log` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `scenes/main.tscn` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/asset_library.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/asset_library.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/audio_service.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/audio_service.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/content_registry.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/content_registry.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/event_bus.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/event_bus.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/save_service.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/save_service.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/simulation_clock.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/autoload/simulation_clock.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/sim/sim_agent.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/sim/sim_agent.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/sim/sim_profile.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/sim/sim_profile.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/aging_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/aging_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/autonomy_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/autonomy_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/bill_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/bill_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/build_grid_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/build_grid_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/career_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/career_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/collecting_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/collecting_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/cooking_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/cooking_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/death_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/death_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/expansion_runtime_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/expansion_runtime_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/fishing_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/fishing_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/gardening_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/gardening_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/genealogy_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/genealogy_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/genetics_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/genetics_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/household_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/household_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/interaction_queue.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/interaction_queue.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/inventory_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/inventory_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/mode_controller.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/mode_controller.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/moodlet_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/moodlet_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/motive_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/motive_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/occult_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/occult_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/opportunity_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/opportunity_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/parity_system_hub.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/parity_system_hub.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/party_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/party_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/performer_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/performer_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/pet_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/pet_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/pregnancy_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/pregnancy_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/relationship_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/relationship_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/routing_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/routing_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/school_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/school_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/service_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/service_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/skill_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/skill_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/social_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/social_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/story_progression_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/story_progression_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/trait_tuning_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/trait_tuning_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/weather_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/weather_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/wish_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/wish_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/world_system.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/systems/world_system.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/world/interactable_object.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/world/interactable_object.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/world/world_builder.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/core/world/world_builder.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/main.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/main.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/ui/hud.gd` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `src/ui/hud.gd.uid` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/integration_test.gd` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/integration_test.gd.uid` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/integration_test.tscn` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/smoke_test.gd` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/smoke_test.gd.uid` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_capture.gd` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_capture.gd.uid` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_capture.tscn` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_diagnostic.gd` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_diagnostic.gd.uid` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_diagnostic.tscn` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_scene_test.gd` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_scene_test.gd.uid` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/godot/visual_scene_test.tscn` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/static_validate.py` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tests/test_data.py` | qa | included | Tests, validation logs, baseline proof, and comparison evidence | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/build_release.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/build_release_manifest.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/capture_improvement_metrics.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/fetch_optional_kenney_assets.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/generate_assets.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/generate_feature_matrix.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/godot_bin.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/import_optional_asset_pack.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/render_asset_contact_sheet.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/run_godot_checks.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/run_godot_smoke.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/run_validation.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `tools/validate_assets.py` | source | included | Godot/runtime/tooling source or root project metadata | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |
| `MANIFEST.md` | release-metadata | included | Human-readable complete release inventory and gates | Excluded from recursive self-hash inventory; covered by final ZIP checksum |
| `FILE_MANIFEST.json` | release-metadata | included | Machine-readable per-file release inventory | Excluded from recursive self-hash inventory; covered by final ZIP checksum |
| `CHECKSUMS.sha256` | release-metadata | included | SHA-256 list for all non-recursive payload files | Excluded from recursive self-hash inventory; covered by final ZIP checksum |

## Release gates

- **Existence:** source tree, data, assets, QA evidence, and documentation are present.
- **Version:** current release metadata is OpenLife Godot v0.3.2 (visual fix); earlier references are preserved only as explicit comparison/baseline evidence.
- **Dependencies:** runtime requires Godot 4.7.1 stable or a compatible newer Godot 4.x editor. Python is optional and used only for validation/rebuilding generated proof/assets.
- **Local-first:** no Lovable, hosted backend, API key, paid asset, account, or runtime network service is required.
- **Third-party bytes:** exact external candidate archives are not bundled or misrepresented as integrated.
- **Runtime verification:** Godot 4.7.1 headless import/parse, the smoke test and the 431-check integration suite all pass against this payload after fresh extraction; see `qa/GODOT_RUNTIME_VALIDATION.md`.
- **Full parity:** explicitly incomplete and not claimed; 100 architecture contracts and 12 data contracts remain. See `OPERATIONAL_STATE.md` and `docs/REQUIREMENT_LEDGER.md`.
