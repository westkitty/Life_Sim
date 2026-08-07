# OpenLife v0.3.0 Bug Sweep Report

## Executive summary

- Target: v0.3.0 candidate produced from the v0.2.0 release.
- Editing mode: direct local repair.
- Validation mode: deterministic source/data/asset checks plus an attempted Godot smoke route.
- Final verdict: **No unresolved confirmed bugs in inspected static scope; remaining runtime risks need Godot verification.**

## Confirmed defects found and repaired

| ID | Severity | Defect | Repair | Evidence |
|---|---|---|---|---|
| BUG-001 | high | v0.2 package had sparse runtime-wired parity coverage | expanded source-wired rows and added real system modules | feature ledger 23 -> 78 implemented-unverified rows |
| BUG-002 | high | EP05 and EP06 lacked runtime feature wiring | added pet and performer systems plus interaction/save hooks | per-pack source-wiring validation passes |
| BUG-003 | medium | most stuff packs had no executable runtime slice | added one actionable/runtime-linked object slice per SP01–SP09 | per-pack tests and object catalog |
| BUG-004 | high | routing was straight-line rather than path-based | added AStarGrid2D routing system and agent route queues | source/static validation |
| BUG-005 | high | Build/Buy lacked occupancy/topology guards | added build-grid occupancy and lot-boundary checks | source/static validation |
| BUG-006 | medium | autonomy ignored trait tuning | added trait-biased scoring | source/static validation |
| BUG-007 | medium | genetics used nondeterministic array shuffle | replaced with seeded RNG Fisher-Yates | source inspection |
| BUG-008 | medium | family/school/bills/services/opportunities and several activity systems were absent from serialized runtime state | added modular systems and ParitySystemHub serialization | source wiring and save v3 checks |
| BUG-009 | medium | save v2 lacked the expanded parity-state envelope | upgraded to save v3 with v1/v2 migration and backup recovery | save-service tests/static checks |
| BUG-010 | medium | v0.2 asset pack was too primitive and narrow | expanded and re-authored project-owned pack | GLB 51 -> 106; faces 7,892 -> 37,844; paired renders |
| BUG-011 | medium | legacy-object geometry initially changed too little in first asset pass | second geometry pass upgraded same baseline IDs | `before_after_asset_proof.png` |
| BUG-012 | medium | no texture family and sparse audio/music | added 7 PNG textures and 24 WAV including mode loops | asset validation |
| BUG-013 | medium | optional asset strategy confused discovery with integration | added rights/provenance report, stable aliases and local-only staging importer | resource docs and no-network scan |
| BUG-014 | high | SP01 chair used nonexistent `comfort` motive | changed effects to valid motives | object/catalog validation now passes |
| BUG-015 | low | release manifest generator still labeled v0.2.0 | updated generator and regenerated manifests | current `MANIFEST.md`/`FILE_MANIFEST.json` |
| BUG-016 | low | validation report still described v0.2/Godot 4.6.3 | replaced with v0.3 report and moved baseline log under improvement evidence | current QA tree |
| BUG-017 | low | visual manifest used noncanonical lifecycle state `rejected-default` | normalized to `rejected` with explicit decision reason | manifest inspection |
| BUG-018 | low | manually authored operational-state blocks failed deterministic schema rendering | regenerated state and patched through official helper | operational-state validate PASS |

## Remaining risks / blockers

- Godot 4.7.1 runtime parsing, importing, rendering and gameplay execution are unverified because an engine executable could not be obtained in this environment.
- Full reference-game parity is not implemented: 100 architecture-contract and 9 data-contract rows remain.
- External CC0 asset candidates remain `rights-verified`/`provenance-verified` but not acquired, inspected, integrated or validated.

## Resweep result

After repairs, the independent resweep found no missing `source_file` targets, no blank object interactions, no duplicate object IDs, no stale release-version claims outside intentional baseline/comparison evidence, and no runtime network/API-key dependencies. Deterministic validation remains green.
