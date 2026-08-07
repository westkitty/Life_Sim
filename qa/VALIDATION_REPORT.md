# OpenLife v0.3.2 Validation Report

## Verdict

**Godot 4.7.1 runtime is verified. Full Sims 3 parity remains incomplete and is not claimed.**

v0.3.0's headline limitation is resolved: the project now parses, imports, launches
and passes a 431-check engine-backed integration suite. See
`qa/GODOT_RUNTIME_VALIDATION.md` for the authoritative runtime evidence and
`qa/CODEX_BUG_SWEEP_REPORT.md` for the closed defect queue.

## Deterministic checks

| Gate | Result | Evidence |
|---|---|---|
| Static/source validation | PASS | 251 checks, 0 warnings, 0 failures |
| Data/unit tests | PASS | 14 tests (invoked through `unittest discover`; the previous invocation could not import the module) |
| Asset validation | PASS | 729 checks, 0 failures |
| Catalog asset resolution | PASS | 73 actionable objects resolve through project-owned aliases |
| Pack source-wiring coverage | PASS | BG, EP01–EP11 and SP01–SP09 each have at least one `implemented_unverified` runtime slice |
| Operational-state schema | PASS | deterministic helper validation succeeds |
| Python validation tooling | PASS | project tools/tests compile under Python 3 |
| Runtime network/API dependency scan | PASS | no runtime network clients or API-key dependencies detected |
| Godot 4.7.1 headless import/parse | PASS | zero script/parse errors — `qa/codex/final_godot_import.log` |
| Godot 4.7.1 headless smoke | PASS | `OPENLIFE_GODOT_SMOKE_PASS` — `qa/codex/final_smoke_test.log` |
| Godot 4.7.1 integration suite | PASS | `OPENLIFE_INTEGRATION_PASS: 437 checks` — `qa/codex/final_integration_test.log` |
| Godot 4.7.1 visual-scene gate (real renderer) | PASS | `OPENLIFE_VISUAL_PASS: 71 checks` — `qa/visual/visual_scene_test.log` |
| Rendered screenshot acceptance | PASS | `qa/visual/after_visual_fix.png` vs `qa/visual/before_visual_fix.png` |
| Windowed main-scene launch | PASS | 420 frames, zero script errors — `qa/codex/gui_launch.log` |
| Fresh-extraction release verification | PASS | `qa/codex/release_verification.log` |
| Full parity | FAIL / incomplete | 100 architecture contracts and 12 data contracts remain |

Raw current output: `qa/validation-v0.3.0.txt`.
Baseline evidence: `qa/improvement/baseline_validation-v0.2.0.txt` and `qa/improvement/baseline_metrics.json`.

## Improvement evidence

The frozen v0.2 baseline and current v0.3 candidate show:

- runtime-wired feature rows: 23 -> 78;
- actionable objects: 34 -> 73;
- GLB models: 51 -> 106;
- model faces: 7,892 -> 37,844;
- WAV files: 9 -> 24;
- PNG textures: 0 -> 7;
- static checks: 125 -> 249;
- unit tests: 4 -> 14;
- asset checks: 333 -> 729.

Visual evidence is in `qa/improvement/before_after_asset_proof.png`.

## What this does not prove

Evidence tiers are now explicit, because the previous release conflated them:

| Tier | Meaning | Gate |
|---|---|---|
| resource exists | a file is on disk | `tools/validate_assets.py` |
| resource imports | Godot can load it | `--headless --import` |
| scene instantiates | the node tree builds | smoke test |
| render geometry exists | meshes with surfaces exist | `AssetLibrary.validate_visual_instance()` |
| render geometry is visible | visible in tree, finite transform, non-zero scale, opaque | `visual_scene_test.tscn` |
| the final scene displays it | a rendered frame shows the world | `qa/visual/after_visual_fix.png` |

A GLB path existing is never recorded as equivalent to a rendered asset.

These gates prove that the project parses, imports, launches, renders and behaves
correctly for the asserted checks. They do **not** prove:

- that the 49 `implemented_unverified` rows behave correctly — their pack has an
  engine-exercised path, but each row lacks a feature-specific assertion;
- that 100 architecture contracts or 12 data contracts are implemented — they are not;
- that visual fidelity matches any reference product;
- that The Sims 3 parity is achieved. **It is not, and it is not claimed.**

Known remaining gaps are enumerated in `qa/GODOT_RUNTIME_VALIDATION.md` under
"Limits of this evidence".
