# OpenLife — Godot Runtime Validation

**Engine:** Godot 4.7.1.stable.official.a13da4feb
**Binary:** `/Applications/Godot.app/Contents/MacOS/Godot`
**Project:** `/Users/andrew/Life_Sim/OpenLife/project.godot`
**Platform:** macOS (Apple Silicon), GL Compatibility renderer

This file records what the real engine actually did. Static and data checks are
supplemental; nothing here is inferred from source reading.

## Commands

```bash
/Applications/Godot.app/Contents/MacOS/Godot --headless --import --path .
/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script res://tests/godot/smoke_test.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path . res://tests/godot/integration_test.tscn
/Applications/Godot.app/Contents/MacOS/Godot --path . --quit-after 420
python3 tools/run_validation.py
```

## Gate results

| Gate | Result | Evidence |
|---|---|---|
| Headless import / GDScript parse | **PASS** — zero `SCRIPT ERROR`, zero `Parse Error` | `qa/codex/import_pass5.log` |
| `tests/godot/smoke_test.gd` | **PASS** — `OPENLIFE_GODOT_SMOKE_PASS` | `qa/codex/smoke_pass3.log` |
| `tests/godot/integration_test.tscn` | **PASS** — `OPENLIFE_INTEGRATION_PASS: 431 checks`, 0 failures | `qa/codex/integration_pass3.log` |
| Windowed main-scene launch (420 frames, rendering + audio) | **PASS** — zero script errors | `qa/codex/gui_launch.log` |
| Python static validation | PASS — 251 checks, 0 warnings, 0 failures | `qa/codex/full_validation.log` |
| Data/unit tests | PASS — 14 tests | `qa/codex/full_validation.log` |
| Asset validation | PASS — 729 checks, 0 failures | `qa/codex/full_validation.log` |
| Fresh-extraction release verification | **PASS** | `qa/codex/release_verification.log` |
| Full Sims 3 parity | **FAIL / incomplete, by design** | 100 architecture contracts + 12 data contracts remain |

## What the integration suite proves

Each item below is one or more asserted checks in `tests/godot/integration_test.gd`.

- **Parse/import coverage** — every `.gd` under `src/` and `tests/godot/`, every
  `.tscn`, and all 100+ bundled asset aliases load through `ResourceLoader`.
- **Main scene runtime** — `main.tscn` instantiates as `OpenLifeMain`, spawns the
  default population and world, and runs ≥6 simulation minutes with motive decay.
- **Autonomy** — an urgent motive produces a choice that is a real interaction on a
  real object, resolves to a reachable route, and enqueues.
- **Routing and interaction** — the target is a perimeter access slot outside the
  object footprint on a walkable cell; the Sim completes the interaction through the
  real queue and the motive effect is applied.
- **Impossible blockers** — a sealed cell yields an empty route, interaction
  preparation fails safely, the grid recovers when blockers are removed, and house
  wall cells are impassable.
- **Socials** — a social interaction raises the stored relationship and derives a status.
- **Opportunities** — the reward credits the owning household exactly once, leaves
  other households untouched, and does not pay again on a repeat interaction.
- **Careers and wishes** — simulated work returns a positive performance delta which
  completes the career wish and pays lifetime happiness.
- **Build/Buy** — place (debits price, sets owner), rotate (quarter turn + footprint
  swap), reject overlap, reject out-of-lot, refuse community and other-household
  sales, and refund exactly half on an authorised sale.
- **Mode, speed and input policy** — Live→CAS→Apply→Live and Live→CAS→Close→Live
  restore mode, clock speed, panel visibility and music mode; speed and pause
  requests are refused outside Live; gameplay input is suppressed while a text field
  holds focus and restored on release.
- **Age geometry** — changing age stage rebuilds the collision capsule (1.6 → 1.1 → 1.6).
- **Economy/ownership coherence** — selecting a Sim switches the active household,
  HUD funds follow it, earnings credit the acting Sim's own household only, and
  households carry canonical home-lot ids registered in `WorldSystem`.
- **Services** — a scheduled maid arrives and applies a real household moodlet;
  delivery adds a real inventory item.
- **School** — rabbit-hole state during class hours, attendance accrual, homework
  interaction, `days_attended` rollover, and release outside class hours.
- **Death/ghosts** — starvation kills a Sim, records the urn/ghost entry, activates
  the ghost, and removes the Sim from both the playable roster and the household.
- **Pets** — motives decay and interactions mutate state, and the suite asserts that
  **no in-world pet agent exists**, matching the downgraded ledger evidence.
- **Pack coverage** — BG and every EP01–EP11 and SP01–SP09 pack spawns a real
  catalog object, builds a runtime interaction and runs the completion path.
- **Save/load** — clock, Sims, queues, objects, ownership, rotation, household,
  active household, world, settings, grid size, inventory, moodlets, wishes,
  genetics and parity-system state all round-trip; malformed object entries are
  rejected safely.
- **Backup recovery** — a corrupted primary slot recovers a complete payload from
  the local backup.
- **Offline-only** — no HTTP client nodes exist in the running tree, every asset
  alias resolves to a bundled local resource, and a bundled model instantiates
  without any download.

## Known benign diagnostics

`integration_test.tscn` exits via `get_tree().quit()` from inside a frame, and Godot
prints ObjectDB/RID leak counts for anything still alive at that moment. This is a
harness shutdown artifact, not a project defect:

- the windowed main-scene launch (`--quit-after 420`), which exits through the
  normal engine shutdown path, reports `1 resources still in use at exit` — clean;
- the suite explicitly frees the instantiated world and drains deferred
  `queue_free()` deletions for four frames before quitting;
- no `SCRIPT ERROR` or `Parse Error` appears in any run.

One genuine resource issue *was* found while investigating this and is fixed:
`AudioService.play()` relied solely on `AudioStreamPlayer.finished` to reclaim
one-shot players, and that signal never fires when there is no audio device, so
players accumulated for the process lifetime. A stream-length-derived timeout now
reclaims them as well.

The single `Parse JSON failed` line in the integration log is expected — it is the
corrupt-primary-save test deliberately writing invalid JSON before proving backup
recovery.

## Limits of this evidence

- 49 feature rows remain `implemented_unverified`: their pack has an
  engine-exercised interaction path, but the individual row has no feature-specific
  assertion. They are **not** promoted on the strength of a broad smoke test.
- 100 architecture contracts and 12 data contracts are not implementations.
- World travel changes state only; it does not stream a distinct playable destination.
- Career schedules, level caps and salaries remain incomplete.
- Autonomy RNG is seeded but not serialized, so autonomy choices are not guaranteed
  identical across a save/load boundary.
- **Full Sims 3 base-game + EP01–EP11 + SP01–SP09 parity is not achieved and is not claimed.**
