# OpenLife v0.3.2 Release Notes

## Purpose

Proof-driven adversarial upgrade over v0.2.0. The release prioritizes executable parity coverage, asset quality/provenance, safer local handoff and measurable evidence rather than file-count theater.

## Material changes

- Godot validation target updated from 4.6.3 to current stable 4.7.1.
- Runtime-wired feature rows increased from 23 to 78 while residual contracts remain visible.
- Added AStarGrid2D routing, Build/Buy occupancy/lot validation and trait-biased autonomy.
- Added genetics/genealogy/pregnancy, school, bills, services, opportunities, collecting, gardening, fishing, cooking, parties and death-state systems.
- Added EP05 `PetSystem` and EP06 `PerformerSystem` with persistent state.
- Guaranteed at least one source-wired slice for BG, every EP and every SP.
- Build/Buy catalog expanded from 34 to 73 actionable objects.
- Save schema upgraded from v2 to v3 to persist expanded parity systems.
- Bundled visual pack expanded from 51 to 106 GLBs and substantially increased same-object geometry detail.
- Added 7 procedural textures and expanded audio from 9 to 24 WAVs including Live/Build/CAS music loops.
- Replaced brittle automatic external-asset downloading with a no-network, hash-recorded, path-safe local staging importer.
- Added ranked asset-source report with publisher-controlled CC0 candidates, explicit lifecycle states, and a coherent Quaternius Base Characters + Universal Animation Library 2 character/animation path.
- Asset validation now includes textures.
- Unit tests increased from 4 to 14 and now include per-pack runtime-slice coverage plus external-asset lifecycle/source-plan checks.
- Added paired before/after asset proof and quantitative improvement report.

## v0.3.1 — Codex repair and engine-validation pass

v0.3.0 could not parse in Godot at all, despite passing its own Python validation.
v0.3.1 fixes that and adds the runtime evidence layer that was missing.

- All 32 defects in `qa/CODEX_BUG_SWEEP_SEED.md` are closed: 31 repaired in code, 1 (pets) resolved by an honest ledger downgrade.
- Seven further release-blocking defects that only the real engine could expose were fixed, including a reserved-word parse failure (`trait`), a `Node.add_child` signature collision, Variant type-inference parse errors, and `!is_inside_tree()` transform errors on every spawn.
- Routing now fails safely instead of phasing through blockers, restores temporary grid mutations, and targets orientation-aware interaction slots.
- Architecture (houses, community buildings) is now physical and blocks navigation, with walkable interiors through a doorway.
- A new `ModeController` centralizes mode, clock-speed, panel, music and text-focus input policy.
- Opportunity payouts, career-wish wiring, lot/household ownership, Build/Buy sale authority, atomic save replacement, save schema validation, weather initialization, and deterministic weather/fishing RNG are all repaired.
- Death/ghosts, service effects, and school attendance/homework are now genuinely executable and engine-tested. Pet rows without a reachable caller were downgraded to `data_contract`.
- New `tests/godot/integration_test.tscn` — 431 engine-backed checks. The Godot gate is now mandatory in `tools/run_validation.py`; a missing engine is a failure, not a skip.
- The release archive is built from an explicit allowlist and its membership is compared exactly against regenerated manifests.

## v0.3.2 — Visual rendering repair

The reported failure was that pressing Play showed words and UI instead of the 3D
world. A rendered baseline screenshot reproduced it exactly.

Root causes, none of which were asset-inventory problems:

- **Labels covered the world.** Every `Label3D` on Sims and objects used
  `fixed_size = true` with `no_depth_test = true`, so name tags drew at constant
  screen size, always on top, from any distance. ~25 of them filled the frame.
- **The camera framed empty space.** `camera_target` started at the world origin,
  which is the empty road junction, not the populated neighborhood.
- **The scene was overexposed.** Ambient 0.72 plus a 1.15-energy sun pushed
  light-albedo ground surfaces past clipping, so lots rendered as flat white.
- **Invisible models could pass silently.** `AssetLibrary.instantiate_model()`
  accepted any `PackedScene` whose root was a `Node3D`, so a model with no
  renderable geometry could return "successfully" and leave a floating label.

Fixes: labels are depth-tested, distance-scaled and range-limited; the opening
camera frames the active household's home lot; exposure and lot tints are
balanced and lots are textured; and `AssetLibrary` now validates mesh presence,
surfaces, visibility, finite transforms, non-zero scale, bounds and material
opacity, falling back to project-owned procedural geometry when a model cannot be
seen. Sims, objects, houses, community buildings and nature dressing all have
guaranteed visible fallbacks.

All 106 bundled GLBs were measured in-engine: 106 accepted, 0 rejected, 0
degenerate, 0 microscopic, 0 oversized, 0 fully transparent.

New permanent gate: `tests/godot/visual_scene_test.tscn` asserts that the running
scene contains real visible geometry — every Sim and every object has a visible
mesh, terrain/roads/lots/buildings render, textures are applied, and visible
geometry substantially outnumbers 3D labels. It runs with a real renderer, and it
was confirmed to fail when the original label defect is reintroduced.

## Verified in this release

Godot 4.7.1.stable.official.a13da4feb: headless import/parse clean, smoke test passes, 437/437 integration checks pass, 71/71 visual-scene checks pass with a real renderer, and a rendered screenshot (`qa/visual/after_visual_fix.png`) shows terrain, roads, lot, house, trees, furniture, Sims and HUD in one frame. The same gates pass against a fresh extraction of the shipped archive.

## Remaining limitation

Full Sims 3 parity remains **incomplete and is not claimed**. `data/feature_ledger.json` is authoritative: 100 architecture contracts and 12 data contracts remain. World travel changes state but does not stream a distinct playable destination, and career schedules/level caps/salaries are still incomplete.
