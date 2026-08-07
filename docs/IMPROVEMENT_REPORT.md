# OpenLife v0.3.0 Improvement Report

Baseline archive: `OpenLife_Godot_v0.2.0.zip`
Baseline SHA-256: `4a53f8c03be09fafe93edf1ca14625dad8ccfe04d6dba4b7fdf703e1f4445968`

## Measured delta

| Measure | v0.2.0 | v0.3.0 | Delta |
|---|---:|---:|---:|
| Runtime-wired feature rows | 23 | 78 | +239.1% |
| Architecture-only feature rows | 137 | 100 | -27.0% |
| Total tracked feature rows | 169 | 187 | +10.7% |
| Actionable Build/Buy objects | 34 | 73 | +114.7% |
| Bundled GLB models | 51 | 106 | +107.8% |
| Bundled WAV files | 9 | 24 | +166.7% |
| Bundled PNG textures | 0 | 7 | new |
| GDScript files | 28 | 49 | +75.0% |
| GDScript lines | 2,785 | 4,455 | +60.0% |
| Model vertices | 4,426 | 20,236 | +357.2% |
| Model faces | 7,892 | 37,844 | +379.5% |
| Model geometries | 240 | 657 | +173.8% |
| Model materials | 139 | 334 | +140.3% |
| Model bytes | 261,572 | 863,096 | +230.0% |
| Static checks passing | 125 | 249 | +99.2% |
| Unit tests passing | 4 | 14 | +250.0% |
| Asset checks passing | 333 | 729 | +118.9% |

## What the numbers prove

- **Executable coverage is broader:** runtime-wired ledger rows rose from 23 to 78, and architecture-only rows fell from 137 to 100. These remain `implemented_unverified` until Godot runs them; the metric proves source coverage, not gameplay verification.
- **Every pack now has a source-wired slice:** BG, EP01–EP11 and SP01–SP09 each have at least one `implemented_unverified` row. The complete residual content/behavior remains separate in the ledger.
- **Build/Buy is broader:** 34 → 73 actionable catalog objects, and every object resolves through a stable alias to a bundled GLB.
- **The asset upgrade is not just file count:** total faces increased from 7,892 to 37,844 and mean faces/model from 154.75 to 357.02. `qa/improvement/before_after_asset_proof.png` compares the same v0.2/v0.3 objects side-by-side.
- **Validation is materially stronger:** unit coverage more than triples and asset validation now checks PNG textures in addition to GLB/WAV/SVG files and catalog alias targets.

## What did not improve

- **Godot runtime evidence:** unchanged. The engine executable is unavailable in this environment, so both baseline and v0.3 remain runtime-unverified. This is deliberately not converted into a pass.
- **Full parity:** still not achieved. One hundred architecture contracts and nine data contracts remain. v0.3 is a better implementation package, not a finished clean-room clone of the entire reference game.

## Visual proof

Open `qa/improvement/before_after_asset_proof.png`. The top section pairs identical model IDs from v0.2 and v0.3; the bottom section shows new v0.3 pack/runtime assets with no v0.2 counterpart.

## Reproducibility

- `qa/improvement/baseline_metrics.json` preserves the pre-change v0.2 metrics.
- `qa/improvement/final_metrics.json` preserves the v0.3 metrics.
- `qa/improvement/baseline_asset_metrics.json` and `final_asset_metrics.json` contain per-model measurements.
- `tools/render_asset_contact_sheet.py` recreates the visual contact sheets.
- `python3 tools/run_validation.py` recreates the current static/data/asset gates and attempts the Godot smoke test.
