# OpenLife v0.3.0 — Independent Codex-Preflight Bug Sweep

## Verdict

**Known bugs remain.** The existing Python validation passes, but it does not prove GDScript parse/import/runtime correctness. This independent sweep found release-blocking source defects that require a real Godot 4.7.x parser/runtime pass before the project can be treated as runnable.

## Coverage

Inspected: project.godot, main scene, all GDScript source files, autoload contracts, core simulation/system wiring, HUD/mode transitions, interaction/routing/build grid, household/world/lot state, save/migration logic, feature ledger, Python validators, Godot smoke test, release manifest/checksums, and ZIP contents.

Unavailable here: actual Godot executable, editor import, live scene execution, graphics/physics observation, and device-level input behavior.

## Confirmed defect ledger

### BUG-001 — AutonomySystem contains invalid indentation/scope
- Severity: critical
- Location: `src/core/systems/autonomy_system.gd:27-35`
- Evidence: `candidate["score"]` is dedented out of the positive-effect block and `candidates.append(candidate)` re-indents without a block opener.
- Impact: likely GDScript parser failure; candidate/base_score scope is also wrong.
- Repair: keep score calculation and append inside the `if float(effects.get(...)) > 0.0` block.
- Validation: Godot import/parser + autonomy runtime test.

### BUG-002 — Main minute tick references nonexistent `SimulationClock.day_index`
- Severity: critical
- Location: `src/main.gd:293-310`
- Evidence: SimulationClock exposes `current_day()` and signal argument `day_index`, but no top-level `day_index` property.
- Impact: minute simulation path errors.
- Repair: pass the `day_index` signal argument or call `SimulationClock.current_day()`.

### BUG-003 — Expansion memory path references nonexistent clock properties
- Severity: critical
- Location: `src/core/systems/expansion_runtime_system.gd:76`
- Evidence: reads `SimulationClock.day_index` and `SimulationClock.total_minutes`; neither is a declared top-level property.
- Impact: `_on_interaction_completed()` calls `add_memory()` after every completed interaction, so normal interaction completion can error.
- Repair: expose explicit clock API such as `current_total_minutes()` and use `current_day()`.

### BUG-004 — Existing static validator misses semantic indentation/parser failures
- Severity: high
- Location: `tests/static_validate.py`
- Evidence: 249 checks pass despite BUG-001 and BUG-002/003.
- Impact: green Python validation can falsely suggest Godot readiness.
- Repair: make actual Godot headless import/parser a mandatory release gate; keep Python checks supplemental.

### BUG-005 — Existing Godot smoke test is too shallow
- Severity: high
- Location: `tests/godot/smoke_test.gd`
- Evidence: only loads/instantiates, checks a few assets/pack counts/population, then exits.
- Impact: it cannot catch minute ticking, interaction completion, routing, save/load, CAS, Build/Buy, household, economy, or pack-path failures.
- Repair: add an engine-backed integration test covering core user journeys.

### BUG-006 — Routing falls back to direct movement through blockers
- Severity: high
- Location: `src/core/systems/routing_system.gd:33-55`
- Evidence: out-of-bounds/no-path cases return/append raw `to_position`.
- Impact: agents can phase through blocked geometry instead of reporting route failure.
- Repair: return a failure/empty route and make queue/interactions fail gracefully.

### BUG-007 — Routing mutates solid start cell without restoring it
- Severity: high
- Location: `routing_system.gd:40-47`
- Evidence: a solid start point is set false and never restored.
- Impact: navigation grid state can leak across routes.
- Repair: restore all temporary solid-state mutations after path calculation.

### BUG-008 — Object interactions route to object center rather than a usable slot
- Severity: high
- Location: `src/core/world/interactable_object.gd:105-117`
- Evidence: `target_position = global_position` for every interaction.
- Impact: target is often inside the occupied footprint/collider, especially large objects.
- Repair: introduce orientation-aware interaction slots/perimeter access cells and route to a reachable slot.

### BUG-009 — Physics masks allow Sims to ignore object collisions
- Severity: high
- Location: `sim_agent.gd:70-71`, `interactable_object.gd:30-31`
- Evidence: Sim mask is layer 1 only; interactable objects live on layer 4.
- Impact: route fallback can physically pass through objects.
- Repair: establish a deliberate collision-layer matrix for ground, Sims, objects, and architecture.

### BUG-010 — Houses/buildings are visual-only navigation obstacles
- Severity: high
- Location: `world_builder.gd`
- Evidence: houses/community models are added as Node3D/mesh assets, while routing blockers are populated only from BuildGrid interactable-object occupancy.
- Impact: agents can route through major structures.
- Repair: register structural footprints/colliders with navigation or migrate to a proper navigation-region solution.

### BUG-011 — CAS can open without entering CAS mode
- Severity: high
- Location: `hud.gd:194`, `hud.gd:396-397`
- Evidence: `Edit Selected Sim` directly shows the panel rather than requesting `cas` mode.
- Impact: simulation may keep running and CAS music/mode policy is bypassed.
- Repair: all CAS entry must go through the authoritative mode transition.

### BUG-012 — Closing CAS does not leave CAS mode
- Severity: high
- Location: `hud.gd:377,394`
- Evidence: close/apply hides panel but does not request Live or restore prior mode/speed.
- Impact: UI can be hidden while current mode remains CAS and clock remains paused.
- Repair: central mode owner handles panel visibility and exit semantics.

### BUG-013 — Speed controls can violate non-live pause policy
- Severity: high
- Location: `main.gd:127`, mode handling at `417-436`
- Evidence: HUD speed signal directly calls `SimulationClock.set_speed()` regardless of mode.
- Impact: Build/Buy/CAS/map can be unpaused.
- Repair: route speed requests through a guarded controller that permits speed changes only in allowed modes.

### BUG-014 — World/camera input remains active while editing UI text
- Severity: medium
- Location: `main.gd:205-239`
- Evidence: camera actions are processed every frame without checking focused Control/text-entry state.
- Impact: typing WASD/QE/space in CAS can move/rotate/pause the world.
- Repair: suppress gameplay input while UI owns keyboard focus.

### BUG-015 — Opportunity completion reward is never credited
- Severity: high
- Location: `opportunity_system.gd`, `parity_system_hub.gd:85-116`
- Evidence: completed opportunity returns a `reward`, but the hub only posts a notification.
- Impact: advertised reward has no economy effect.
- Repair: credit the correct household exactly once and test duplicate completion protection.

### BUG-016 — Career wish progression has no caller
- Severity: medium
- Location: `wish_system.gd:67-79`
- Evidence: `record_career_progress()` occurs only at its definition in the source tree.
- Impact: career wish cannot complete through career performance.
- Repair: wire career performance/promotion deltas into WishSystem.

### BUG-017 — Death/ghost system has no gameplay caller
- Severity: high evidence-state defect
- Location: `death_system.gd`
- Evidence: `record_death()` and `set_ghost_active()` are not called elsewhere.
- Impact: feature ledger calls death/ghost state source-wired while no death path reaches it.
- Repair: implement actual death triggers/lifecycle/ghost activation or downgrade the ledger row.

### BUG-018 — Household home-lot identity is inconsistent
- Severity: high
- Location: `household_system.gd:7-14`, `world_builder.gd:74-90`, `world_system.gd`
- Evidence: every household gets `lot_founders`; WorldBuilder generates IDs like `founderslot` and `neighborlota`; WorldSystem expects `lot_founders`; `register_lot()` has no caller.
- Impact: ownership, active-lot logic, and future routing/build restrictions cannot be trusted.
- Repair: define canonical lot IDs once, register them into WorldSystem, and assign each household its real home lot.

### BUG-019 — Inactive-household Sims can be selected while economy remains active-household-only
- Severity: medium/high
- Location: `hud.gd:set_sim_roster`, `main.gd:_select_sim`, earnings/service/party handlers
- Evidence: roster contains all Sims; selecting Bell Sims does not switch `active_household_id`; earnings only credit the active household and services/parties use it.
- Impact: selected actor and economic/household context diverge.
- Repair: implement explicit household switching or restrict controllable roster to active household; keep story progression coherent.

### BUG-020 — Build/Buy selling ignores ownership/lot restrictions
- Severity: medium
- Location: `main.gd:477-489`
- Evidence: any selected InteractableObject can be sold for 50%; owner/active lot is not checked.
- Impact: initial/community/inactive-household objects can be improperly monetized.
- Repair: require ownership/edit authority and active-lot policy before selling.

### BUG-021 — Save restores most settings but not `grid_size`
- Severity: medium
- Location: `main.gd:597-601,610-645`; `ParitySystemHub.configure_world()` hardcodes `1.0`.
- Evidence: grid size is serialized but ignored during restore.
- Impact: save/load can change placement/navigation behavior.
- Repair: restore saved grid size before rebuild/configure.

### BUG-022 — Save restore trusts object position array length
- Severity: medium
- Location: `main.gd:639-640`
- Evidence: indexes `[0]`, `[1]`, `[2]` without checking size.
- Impact: malformed/older save can error instead of falling back cleanly.
- Repair: schema validation/migration before indexing; reject/recover bad entries safely.

### BUG-023 — Save replacement is not truly atomic
- Severity: medium
- Location: `save_service.gd:15-45`
- Evidence: writes temp, then separately opens/truncates destination and copies temp content; backup failure does not block overwrite and several failure paths leave temp behind.
- Impact: interrupted write can corrupt current slot despite temp staging.
- Repair: validate temp then use same-filesystem rename/replace strategy supported by Godot, preserve verified backup, clean temp on every failure path.

### BUG-024 — Weather can roll twice for day 0
- Severity: medium
- Location: `main.gd:50`, `simulation_clock.gd:19-44`
- Evidence: ready manually calls `advance_day(0)`, while first emitted minute sees `_last_emitted_day == -1` and emits `day_advanced(0)` again.
- Impact: initial weather can immediately change and duplicate notifications.
- Repair: use one initialization path and initialize day-emission bookkeeping consistently.

### BUG-025 — CAS age changes do not update physics/label geometry
- Severity: medium
- Location: `sim_agent.gd:_build_visual`, `refresh_profile_visuals()`
- Evidence: refresh replaces body visual only; collision capsule dimensions and label position were created for the old age stage.
- Impact: adult->child/baby or reverse leaves wrong collider/label height.
- Repair: rebuild/update age-dependent collision, base/label/selection geometry when profile visual age changes.

### BUG-026 — Services schedule/arrive but do not perform service effects
- Severity: medium evidence-state defect
- Location: `service_system.gd`, `parity_system_hub.gd:75-76`
- Evidence: arrival only produces a notification.
- Impact: maid/repair/delivery/etc. user path has no actual service consequence.
- Repair: implement minimal service actors/effects or downgrade feature evidence.

### BUG-027 — School state is incomplete/dead in several fields
- Severity: medium evidence-state defect
- Location: `school_system.gd`
- Evidence: `days_attended` never increments; `complete_homework()` has no caller; students can free-roam while attendance accrues.
- Impact: school feature does not represent its claimed user path.
- Repair: day attendance transition, homework interaction, school-away/rabbit-hole state, and tests; otherwise downgrade ledger.

### BUG-028 — Pet implementation is persistent data, not an in-world pet user path
- Severity: medium evidence-state defect
- Location: `pet_system.gd`, main/world/HUD
- Evidence: pets are dictionaries; no PetAgent nodes, 3D spawn, selection, routing, or household pet UI exists.
- Impact: EP05 feature rows overstate functional pet simulation.
- Repair: add PetAgent/in-world user path or downgrade evidence to data contract.

### BUG-029 — Arcade interaction incorrectly increments Showtime performance count
- Severity: medium
- Location: `expansion_runtime_system.gd:27`
- Evidence: `play_arcade` increments `EP06.performances`.
- Impact: unrelated gameplay corrupts performance statistics/progression.
- Repair: only singer/magician/acrobat/karaoke/performance-special paths should affect performance state.

### BUG-030 — Initial/current weather RNG continuity is not serialized
- Severity: low/medium
- Location: `weather_system.gd`
- Evidence: state saves season/weather/temp but not RNG state/seed progression.
- Impact: future weather after load can diverge from uninterrupted play.
- Repair: serialize deterministic RNG state/seed/counter if deterministic continuity is a save requirement.

### BUG-031 — Fishing selection uses wall-clock time
- Severity: low/medium
- Location: `fishing_system.gd`
- Evidence: catch selection uses `Time.get_ticks_msec()/1000` rather than simulation RNG/state.
- Impact: results depend on real time and can repeat within a second; save/replay determinism is poor.
- Repair: use system-owned deterministic RNG serialized with save state.

### BUG-032 — Release ZIP contains files outside declared payload inventory
- Severity: medium release defect
- Location: shipped `OpenLife_Godot_v0.3.0.zip`
- Evidence: ZIP includes `tests/__pycache__/test_data.cpython-313.pyc` and `qa/all_systems_dump.txt`; neither appears in FILE_MANIFEST.json.
- Impact: prior exact-manifest/no-cache release claim is false; artifact is not byte-inventory clean.
- Repair: package from an allowlist/manifest or clean staging tree, not a recursive working-directory ZIP; verify exact archive membership.

## Suspected / incomplete systems requiring engine-backed adjudication

1. World travel changes state/name but does not stream a distinct playable destination world.
2. School/work rabbit-hole behavior, career schedules/workdays, maximum career levels, and salaries are incomplete.
3. Story progression and active-household switching need end-to-end coherence tests.
4. BuildGrid occupancy covers interactable objects but not all architecture/nature/roads; intended navigability needs runtime review.
5. RNG continuity across autonomy/story progression/genetics should be explicitly defined and tested.
6. Several `implemented_unverified` feature rows should be downgraded unless a real user path and Godot test proves them.
7. Full Sims 3 parity remains incomplete by the project’s own ledger (100 architecture contracts + 9 data contracts remain).

## Required validation escalation

1. Run Python static/data/asset validation as baseline only.
2. Run actual Godot headless editor/import to force GDScript/resource parsing.
3. Run existing smoke test.
4. Add one engine-backed integration suite that exercises minute ticking, a complete interaction, autonomy, routing, CAS mode transition, Build/Buy place/sell, household/economy, opportunity reward, career-wish progress, save/load round trip, backup recovery, and at least one runtime slice from every BG/EP/SP family currently marked source-wired.
5. Launch the real main scene and observe the core user journey if GUI observation is available.
6. Reconcile feature-ledger evidence states only after tests prove behavior.
7. Rebuild release from a clean staging allowlist and compare archive contents exactly against manifest/checksums.

## Final audit verdict

**Known bugs remain.** The current ZIP is a useful source package, but it is not yet safe to characterize as plug-and-play Godot-ready. Codex should use this defect set as a minimum repair queue and let the actual Godot parser/runtime discover anything this static environment could not observe.
