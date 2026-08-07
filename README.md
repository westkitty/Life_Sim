# OpenLife

OpenLife is a free, local, clean-room Godot 4 life-simulation project whose controlling target is the complete PC-era feature surface of **The Sims 3**: base game, EP01–EP11, SP01–SP09, plus local extension hooks for world/Store-style content categories.

**v0.3.2 parses, imports, runs and visibly renders its 3D world in Godot 4.7.1, and is still not full parity.** The evidence vocabulary is intentionally strict:

- `engine_verified` — a named test in `tests/godot/` exercises the behavior in Godot 4.7.1 and asserts it (26 rows);
- `implemented_unverified` — source-wired behavior exists and its pack has an engine-exercised interaction path, but this row has no feature-specific Godot assertion (49 rows);
- `architecture_contract` — required behavior remains specified but not fully implemented (100 rows);
- `data_contract` — state exists and round-trips, but there is no reachable in-world user path (12 rows).

Runtime evidence lives in `qa/GODOT_RUNTIME_VALIDATION.md`; the repaired defect queue is in `qa/CODEX_BUG_SWEEP_REPORT.md`; rendered before/after proof is in `qa/visual/`.

## Open it

1. Install the free **Godot 4.7.1 stable** editor or a compatible newer 4.x release.
2. Extract the ZIP somewhere writable.
3. In Godot choose **Import** and select `project.godot`.
4. Let first-time GLB/WAV/PNG/SVG imports finish.
5. Press **F5**.

The release needs no account, subscription, Lovable project, hosted backend, API key, paid asset, Python runtime, or network connection to play.

## What is source-wired in v0.3.1

- continuously loaded 3D neighborhood, lots, roads, residences/community buildings and nature;
- five resident Sims across two households plus persistent pet-state simulation;
- motives, queues, AStarGrid2D routing, trait-biased autonomy and social actions;
- relationships, skills, careers, aging, households, moodlets, wishes/lifetime happiness and inventories;
- genetics, genealogy, pregnancy/birth state, school, bills, service requests and opportunities;
- collecting, gardening, fishing, cooking, parties and death/ghost state;
- seasonal weather, occult state, Story Progression and expansion runtime state;
- EP05 pet motive/state simulation (data-level only: there is no in-world pet agent, pet selection or pet UI) and EP06 performer progression state;
- scoped runtime slices for **BG + EP01–EP11 + SP01–SP09** while full residual pack parity remains explicit;
- Build/Buy grid occupancy, lot-boundary validation, 90° rotation, selling and **73 actionable objects**;
- CAS name/age/trait/genetics editing with age/body-shape avatar selection;
- local JSON save **v3** with v1/v2 migration, atomic verified replacement and `.bak` recovery;
- **106 bundled original GLB models, 24 WAV files, 7 PNG textures and 5 SVG icons**;
- stable asset aliases and a no-network local staging tool for optional verified asset packs;
- deterministic validation and before/after improvement evidence under `qa/improvement/`;
- a mandatory Godot gate (`tools/run_godot_checks.py`) plus a 431-check engine-backed integration suite (`tests/godot/integration_test.tscn`).

## Controls

| Control | Action |
|---|---|
| W / A / S / D | Pan camera |
| Q / E | Rotate camera |
| Mouse wheel | Zoom |
| Left click | Select resident/object; place armed Build/Buy object |
| Z / X | Rotate armed placement 90° |
| Escape | Cancel placement |
| Space | Pause/resume |
| HUD controls | Speed, modes, services, party, CAS and interactions |

## Assets

The release is immediately usable with the project-owned pack in `assets/generated/`. Third-party downloads are **not required**.

`docs/resources/ASSET_SOURCE_REPORT.md` records the better external candidates found during the adversarial pass, including Quaternius animation/furniture, Kenney furniture/characters/city/audio and Poly Haven material candidates. Candidates are not called integrated unless exact archive bytes have been acquired, inspected and runtime-tested.

Manual optional archives can be staged safely with:

```bash
python3 tools/import_optional_asset_pack.py /path/to/pack.zip --name "Pack Name" --source-page "https://publisher.example/item"
```

The tool performs no network access and does not alter runtime aliases.

## Validation

```bash
python3 tools/run_validation.py
```

The suite runs source/data checks, 14 unit tests, generated-asset byte/hash/alias checks, and a Godot headless smoke test when `godot4`, `godot`, or `GODOT_BIN` exists.

A `GODOT SMOKE: SKIP` result is **not** a runtime pass.

## Proof that v0.3 is better than v0.2

See:

- `docs/IMPROVEMENT_REPORT.md` — quantitative baseline → final deltas;
- `qa/improvement/before_after_asset_proof.png` — paired renders of identical v0.2/v0.3 models plus new pack/runtime assets;
- `docs/ADVERSARIAL_REVIEW.md` — 25 defects and their implemented corrections;
- `data/feature_ledger.json` — machine-readable evidence state for every tracked parity row;
- `OPERATIONAL_STATE.md` — durable verified/unverified/broken state.

## Clean-room boundary

OpenLife contains original code and project-owned generated art/audio. It does not include or extract Electronic Arts source code, meshes, textures, audio, animation, text, world packages, or other proprietary game data. Product/pack names appear only to identify the compatibility target.

## License

Original OpenLife source and project-owned bundled assets are released under the MIT License. No third-party asset bytes are bundled in v0.3.0.
