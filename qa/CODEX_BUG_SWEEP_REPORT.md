# OpenLife — Codex Bug Sweep Repair Report

**Engine of record:** Godot 4.7.1.stable.official.a13da4feb (`/Applications/Godot.app/Contents/MacOS/Godot`)
**Working project:** `/Users/andrew/Life_Sim/OpenLife`
**Handoff archive SHA-256:** `857b6bcfd1f169e3977d3e2bff6b6ad175c69e33207f6651c733390294e3ff4f`

This report closes the defect queue in `qa/CODEX_BUG_SWEEP_SEED.md`. Every "fixed"
row below is backed by a named check in `tests/godot/integration_test.gd` or by a
clean run of the real Godot parser/importer — not by static inspection.

## Baseline before any edit

| Gate | Baseline result | Evidence |
|---|---|---|
| `python3 tools/run_validation.py` | FAIL | `qa/codex/baseline_python_validation.log` — `unittest` could not import `tests.test_data`; smoke test failed to parse |
| Godot headless import/parse | FAIL | `qa/codex/baseline_godot_import.log` — 5 autoload/script parse failures, `main.gd` failed to load |
| `tests/godot/smoke_test.gd` | FAIL | parse error at `smoke_test.gd:14` before execution |

The seed sweep's central claim is confirmed: the package passed its own Python
validation while being unable to parse in Godot at all.

## Seed defect ledger — disposition

| ID | Severity | Disposition | Repair | Engine evidence |
|---|---|---|---|---|
| BUG-001 | critical | **Fixed** | `autonomy_system.gd` score/append re-indented into the positive-effect block; candidate typed explicitly | import/parse clean; `_test_autonomy_queues_legal_interaction` |
| BUG-002 | critical | **Fixed** | `main.gd` minute tick uses the `day_index` signal argument | `_test_simulation_minutes` |
| BUG-003 | critical | **Fixed** | Added `SimulationClock.current_total_minutes()` / `current_absolute_minutes()`; `expansion_runtime_system.add_memory` uses the real clock API | `_test_pack_runtime_slices` (memory log grows per completed interaction) |
| BUG-004 | high | **Fixed** | Godot import/parse + smoke + integration is now a mandatory gate (`tools/run_godot_checks.py`), wired into `tools/run_validation.py`; a missing engine is a failure, not a skip | full ladder in `qa/codex/full_validation.log` |
| BUG-005 | high | **Fixed** | Added `tests/godot/integration_test.{gd,tscn}` — 431 engine-backed checks | `OPENLIFE_INTEGRATION_PASS: 431 checks` |
| BUG-006 | high | **Fixed** | `routing_system.route()` returns an empty array on failure and no longer fabricates a straight line; `allow_partial_path` disabled; callers fail safely | `_test_impossible_blocker` |
| BUG-007 | high | **Fixed** | Start and finish solid-state relaxations are both restored after path calculation | `_test_impossible_blocker` (grid recovers after temporary blockers) |
| BUG-008 | high | **Fixed** | `InteractableObject.interaction_slots()` / `interaction_slot_position()` produce orientation-aware perimeter access cells; `prepare_interaction_route` picks the nearest **reachable** slot | `_test_routing_and_interaction_completion` (slot outside footprint, on a walkable cell) |
| BUG-009 | high | **Fixed** | Explicit layer matrix (`LAYER_GROUND/SIM/OBJECT/STRUCTURE`); Sims now mask ground + objects + architecture | import/parse clean; used throughout `_test_impossible_blocker` |
| BUG-010 | high | **Fixed** | Houses build physical perimeter walls with a doorway gap; community buildings get solid bodies; all footprints registered as routing blockers | `_test_impossible_blocker` (house wall cell impassable, ≥3 structure blockers) |
| BUG-011 | high | **Fixed** | `ModeController` is the sole authority; "Edit Selected Sim" now requests CAS mode | `_test_mode_and_input_policy` |
| BUG-012 | high | **Fixed** | Apply/Close request Live mode; panel visibility, music and prior speed are restored by the controller | `_test_mode_and_input_policy` |
| BUG-013 | high | **Fixed** | Speed and pause-toggle requests are refused outside Live mode | `_test_mode_and_input_policy` |
| BUG-014 | medium | **Fixed** | Camera/placement/pause input is suppressed while a `LineEdit`/`TextEdit` owns focus | `_test_mode_and_input_policy` (focus grab/release) |
| BUG-015 | high | **Fixed** | `ParitySystemHub.opportunity_completed` credits the owning household exactly once | `_test_opportunity_reward_pays_once` |
| BUG-016 | medium | **Fixed** | `CareerSystem.tick_work()` returns its performance delta; the minute tick feeds `WishSystem.record_career_progress` | `_test_career_wish_progression` |
| BUG-017 | high | **Fixed (implemented)** | `DeathSystem.evaluate()` implements starvation and old-age mortality; `main._check_death` removes the Sim, activates the ghost record and updates the household | `_test_death_and_ghost` |
| BUG-018 | high | **Fixed** | Canonical lot ids (`lot_founders`, `lot_neighbor_a`, `lot_community_park`, `lot_neighbor_b`) generated once, registered into `WorldSystem`, and assigned as household home lots | `_test_household_ownership_coherence` |
| BUG-019 | medium/high | **Fixed** | Selecting a Sim switches the active household; earnings credit the acting Sim's own household | `_test_household_ownership_coherence` |
| BUG-020 | medium | **Fixed** | `main.can_sell_object()` requires ownership by the active household and presence on its home lot; community property is unsellable | `_test_build_buy_place_rotate_reject_sell` |
| BUG-021 | medium | **Fixed** | Saved `grid_size` is applied before the grid/router are rebuilt | `_test_save_load_round_trip` |
| BUG-022 | medium | **Fixed** | Object entries are schema-checked before indexing; malformed rows are skipped and reported | `_test_save_load_round_trip` (malformed entries rejected safely) |
| BUG-023 | medium | **Fixed** | Verify-then-backup-then-`rename_absolute`; temp file discarded on every failure path; a failed backup aborts replacement | `_test_backup_recovery` |
| BUG-024 | medium | **Fixed** | `SimulationClock._ready()` aligns day bookkeeping, so the explicit day-0 weather roll cannot be duplicated by the first tick | import/parse + `_test_simulation_minutes` |
| BUG-025 | medium | **Fixed** | `SimAgent._apply_age_geometry()` rebuilds capsule, label height and selection marker on every profile-visual change | `_test_age_geometry` |
| BUG-026 | medium | **Fixed (implemented)** | Service arrivals apply real effects: maid/repair/babysitter moodlets, delivery inventory item | `_test_services` |
| BUG-027 | medium | **Fixed (implemented)** | `at_school` rabbit-hole state suppresses free-roaming autonomy; `advance_day()` counts attendance days and penalises unfinished homework; a `do_homework` desk interaction calls `complete_homework` | `_test_school_and_homework` |
| BUG-028 | medium | **Downgraded, honestly** | No in-world pet agent was added. `EP05-F06` (training) and `EP05-F07` (breeding) have no reachable caller and are now `data_contract`; `EP05-F02/F03/F04` remain `implemented_unverified` with proof text stating they are data-level simulations with no pet agent, selection, routing or UI | `_test_pet_data_contract` asserts pets are data-only |
| BUG-029 | medium | **Fixed** | `play_arcade` no longer increments `EP06.performances`; it records an EP03 club visit | `_test_pack_runtime_slices` (arcade does not change performance count) |
| BUG-030 | low/medium | **Fixed** | Weather RNG seed and state are serialized and restored | `_test_save_load_round_trip` (weather restored) |
| BUG-031 | low/medium | **Fixed** | `FishingSystem` owns a seeded `RandomNumberGenerator`; wall-clock time removed; RNG state serialized with backwards-compatible load | `_test_save_load_round_trip` (parity-system state restored) |
| BUG-032 | medium | **Fixed** | Release is staged from an explicit allowlist; caches, `__pycache__`, `.godot`, scratch files and user saves are excluded; manifests regenerated from the staged payload and the archive membership is compared exactly | `qa/codex/release_verification.log` |

**Result: 32 of 32 seed defects closed** — 31 repaired in code, 1 (BUG-028) resolved
by an honest evidence downgrade as the seed explicitly permits.

## Additional defects found by the real engine

These were not in the seed. The Godot parser and runtime exposed them.

| ID | Severity | Defect | Repair |
|---|---|---|---|
| CDX-001 | critical | `hud.gd:347` used `trait` as a loop variable; `trait` is a reserved word in GDScript 4.7, so `OpenLifeHUD` could not parse | renamed to `trait_entry`/`trait_data` |
| CDX-002 | critical | `GenealogySystem.add_child()` redeclared `Node.add_child` with a different signature — a parse error that broke `main.gd` | renamed to `record_birth()` |
| CDX-003 | critical | `asset_library.gd`, `audio_service.gd`, `sim_agent.gd`, `sim_profile.gd`, `genetics_system.gd`, `bill_system.gd`, `main.gd` and `smoke_test.gd` inferred variable types from Variant values, which Godot 4.7 treats as parse errors | explicit types; `abs`→`absi`, `max`→`maxi` |
| CDX-004 | high | `tests/godot/smoke_test.gd` could never run: under `--script`, autoload *global identifiers* are not registered at compile time | smoke test resolves autoloads by node lookup; the deep suite runs as a scene where globals resolve normally |
| CDX-005 | high | `SimAgent` and `InteractableObject` assigned `global_position` before entering the scene tree, emitting `!is_inside_tree()` errors for every spawn | transform assignment moved after `add_child` |
| CDX-006 | medium | `WorldSystem.deserialize()` assigned an untyped `Array` to `Array[Dictionary]`, erroring on every load | element-wise typed rebuild |
| CDX-007 | medium | `tools/run_validation.py` invoked `python -m unittest tests/test_data.py`, which fails on current Python because `tests/` is not a package | switched to `unittest discover` |

## Suspected-systems list from the seed

| Seed item | Status after this pass |
|---|---|
| World travel does not stream a distinct playable destination | Unchanged and still true. Travel remains a state contract; `BG-WORLD_TRAVEL` is `engine_verified` only for *state* persistence, not destination streaming. |
| School/work rabbit holes, schedules, max levels, salaries incomplete | School rabbit-hole state, attendance days and homework are now implemented and tested. Career schedules, level caps and salaries remain incomplete. |
| Story progression / household switching coherence | Household switching is now coherent and tested. Story progression itself remains `implemented_unverified`. |
| BuildGrid does not cover architecture/nature/roads | Architecture now registers navigation blockers. Nature and roads remain non-blocking by design. |
| RNG continuity undefined | Weather and fishing RNG are now seeded and serialized. Autonomy RNG is seeded but not yet serialized; story-progression and genetics remain hash-deterministic. |
| Several `implemented_unverified` rows should be downgraded | Done: 12 `data_contract` rows (was 9); 26 rows promoted to the new `engine_verified` state, each naming the test that proves it. |
| Full Sims 3 parity incomplete | Still incomplete and still stated as such: 100 architecture contracts and 12 data contracts remain. **Full parity is not claimed.** |
