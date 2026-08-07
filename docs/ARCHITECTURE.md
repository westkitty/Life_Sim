# Architecture

## Runtime shape

OpenLife uses a deterministic, data-driven simulation core hosted in Godot 4.

```text
Input and UI
    -> command construction
    -> interaction queue
    -> route/travel phase
    -> interaction execution
    -> motive, relationship, skill, career and object effects
    -> world/household/story progression
    -> notification and UI projection
    -> versioned persistence
```

## Current executable modules

| Module | Responsibility |
|---|---|
| `SimulationClock` | Four speed modes, simulated minute/day events and persisted time |
| `ContentRegistry` | Loads pack, object, career, trait and feature catalogs |
| `SaveService` | Versioned local JSON save envelope |
| `SimAgent` | Resident body, profile, motives, movement, queue and action execution |
| `MotiveSystem` | Six motives, decay, effects, lowest-motive scoring |
| `InteractionQueue` | Current action plus eight bounded pending actions |
| `AutonomySystem` | Utility selection based on motive relief, distance and idle fun |
| `RelationshipSystem` | Long-term, short-term, romantic values and derived status |
| `SkillSystem` | Nonlinear skill points and levels |
| `CareerSystem` | Assignment, performance and promotion shell |
| `AgingSystem` | Life-stage duration and transitions |
| `HouseholdSystem` | Membership, active household and funds |
| `WeatherSystem` | Season, weather roll and temperature state |
| `OccultSystem` | Multi-state occult registry and motive modifiers |
| `StoryProgressionSystem` | Daily inactive-household maintenance and relationship change |
| `WorldSystem` | Active world, lots, travel contexts and placed-object state |
| `WorldBuilder` | Primitive clean-room neighborhood and runtime catalog placement |
| `OpenLifeHUD` | Household, motives, queue, interactions, modes, catalog, CAS and travel controls |

## Required production architecture

The current shell deliberately avoids pretending that direct movement on a plane is final routing. Full parity requires the following production services:

- fixed-step simulation scheduler separated from rendering;
- hierarchical world streaming by world, lot, room and object relevance;
- navigation mesh plus portal graph for doors, stairs, elevators and lot transitions;
- specialized vehicle, horse, boat, subway and teleport route providers;
- animation state machines with route, posture, slot and social synchronization;
- object-component model for ownership, inventory, breakage, cleanliness, upgrades and scripted states;
- event-sourced opportunities, wishes, moodlets, memories and Story Progression;
- content package loader with dependency resolution and safe missing-content degradation;
- original asset pipeline for characters, clothing, morphs, hair, objects, lots, worlds, VFX and audio;
- deterministic save migrations with pack enable/disable compatibility;
- runtime profiling for large neighborhoods, long saves and expansion combinations;
- mod-facing tuning and script API that does not expose unsafe engine internals.

## Simulation cadence target

The production scheduler must maintain distinct cadences rather than updating everything every frame:

| Cadence | Work |
|---|---|
| Render frame | camera, animation interpolation, visible VFX, UI projection |
| Physics step | local movement, collision, posture/slot validation |
| Sim minute | motives, active interactions, timed moodlets, alarms |
| 5 sim minutes | autonomy reconsideration and local object scoring |
| Sim hour | career/school attendance, bills, service scheduling, plant and object decay |
| Sim day | aging, Story Progression, weather/season, pregnancies, opportunities, world cleanup |
| On demand | route planning, world travel, lot load, Build/Buy validation, genetics and save migration |

## Data ownership

Profiles own identity and durable personal state. Systems own cross-entity indexes. World objects own durable object state. The save envelope serializes IDs and values, never runtime node references.

The current shell converts `Vector3` values to arrays before JSON serialization. Production saves require a schema registry and migration chain for every version.

## v0.2 asset and state layer

`AssetLibrary` resolves stable asset IDs through `data/asset_aliases.json`. Interactable behavior therefore depends on catalog IDs rather than concrete GLB paths. `AudioService` uses the same alias layer for local WAV feedback. Bundled generated assets live under `assets/generated/`; optional third-party packs are never runtime dependencies.

New serialized runtime cores in v0.2:

- `MoodletSystem` — timed moodlet entries and mood aggregation;
- `WishSystem` — active wishes, lifetime-happiness points and lifetime-wish state;
- `InventorySystem` — personal, household and shared item stores.

Save format v2 carries those systems and presentation settings. The full routing, CAS genetics, animation, world streaming, vehicle and expansion interaction surface remains governed by the parity ledger rather than being implied by these cores.
