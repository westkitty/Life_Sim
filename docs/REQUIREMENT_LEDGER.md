# OpenLife v0.3.1 Requirement Traceability

Updated after the Codex repair and Godot engine-validation pass. Every "Pass" row
below is backed by observed evidence, not by source inspection.

| ID | Requirement | Evidence | Status |
|---|---|---|---|
| R01 | Adversarially critique the prior package. | `docs/ADVERSARIAL_REVIEW.md` (v0.2 defects) and `qa/CODEX_BUG_SWEEP_SEED.md` (32 v0.3.0 defects). | Pass |
| R02 | Implement each suggested package-quality improvement. | `qa/CODEX_BUG_SWEEP_REPORT.md`: 32/32 seed defects closed (31 repaired, 1 downgraded honestly) plus 7 engine-discovered defects. | Pass |
| R03 | Improve the asset approach, especially sourcing. | 106 project-owned GLBs, 24 WAVs, 7 PNGs, 5 SVGs; `docs/resources/ASSET_SOURCE_REPORT.md` ranks publisher-controlled CC0 candidates. External candidate bytes remain **not acquired**: non-interactive acquisition could not be verified in this session (kenney.nl returns HTTP 403 to non-browser clients; Quaternius distribution requires an interactive flow), and the project's own importer deliberately refuses automatic downloads. | Partial |
| R04 | Return the most complete package achievable without paid services. | Complete Godot source tree, data, assets, tests, docs and QA evidence; no paid or network runtime dependency. | Pass |
| R05 | Package should be plug-in/importable in Godot. | **Godot 4.7.1 headless import/parse is clean; `main.tscn` launches windowed for 420 frames with zero script errors; the same gates pass against a fresh extraction of the shipped archive.** `qa/GODOT_RUNTIME_VALIDATION.md`. | Pass |
| R06 | Demonstrate that this is an improvement over the prior release. | v0.3.0 could not parse in Godot at all (`qa/codex/baseline_godot_import.log`); v0.3.1 passes import, smoke and 431 integration checks. Feature evidence gained a stricter `engine_verified` tier. | Pass |
| R07 | Do not use Lovable, subscriptions, paid APIs or hosted runtime services. | Static network/API-key scans pass; `integration_test.gd::_test_offline_only` asserts no HTTP client nodes exist at runtime and every asset alias resolves to a bundled local resource. | Pass |
| R08 | Preserve full parity as the controlling target: base game, every feature, EP01–EP11, SP01–SP09. | Scope is fully preserved and every pack has an engine-exercised runtime slice, but 100 architecture contracts and 12 data contracts remain. | Fail (incomplete, as declared) |
| R09 | Do not hide missing work behind architecture/data rows. | Evidence states are `engine_verified` (26, each naming its test), `implemented_unverified` (49), `architecture_contract` (100), `data_contract` (12). Rows without a reachable caller were **downgraded**, not promoted. A static check rejects any `engine_verified` row that does not name the Godot test proving it. | Pass |
| R10 | Do not ask additional questions. | The repair pass ran to completion without clarification requests. | Pass |
| R11 | Preserve clean-room boundary and avoid proprietary game asset/code bytes. | All bundled assets are project-owned/generated; no Sims 3 code, branding, models, textures, audio or data files are present; no external archives were acquired. | Pass |
| R12 | Demonstrate validation rather than asserting success. | Baseline failure logs, per-stage repair logs, final gate logs and fresh-extraction verification are retained under `qa/codex/`. | Pass |
| R13 | Godot runtime evidence must control working claims. | `tools/run_godot_checks.py` is a mandatory stage of `tools/run_validation.py`; a missing Godot executable is a **failure**, not a skip. | Pass |
| R14 | Rebuild the release from a clean staging allowlist. | `tools/build_release.py` stages from an explicit allowlist, regenerates manifests from the staged payload, and fails if archive membership differs from the manifest in either direction. | Pass |

**Verdict: not complete against the ultimate full-parity requirement.** R08 remains
failed by design and is stated as such everywhere. R03 remains partial. R05, which
was the decisive unknown in v0.3.0, is now proven Pass by real engine execution.
