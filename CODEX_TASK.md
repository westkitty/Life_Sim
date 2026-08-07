You are the senior Godot integration engineer and release owner for OpenLife. Work directly on my Mac. Do not ask me questions; resolve facts from the handoff and use conservative defaults. Do not claim success without real Godot evidence.

SOURCE AND DESTINATION
- Handoff ZIP: `/Users/andrew/Life_Sim/OpenLife_Codex_Handoff_v0.3.0.zip`
- Final working project: `/Users/andrew/Life_Sim/OpenLife`
- Final fixed release: `/Users/andrew/Life_Sim/OpenLife_Godot_Codex_Fixed.zip`
- Final checksum: `/Users/andrew/Life_Sim/OpenLife_Godot_Codex_Fixed.sha256`

Preserve the handoff ZIP unchanged. If `/Users/andrew/Life_Sim/OpenLife` already exists, rename it to a timestamped backup sibling; never delete it. Extract the handoff so `project.godot` is exactly `/Users/andrew/Life_Sim/OpenLife/project.godot`.

OBJECTIVE
Turn the handoff into the strongest runnable Godot project supported by the supplied source: parse cleanly, launch the main scene, repair every confirmed defect in the supplied bug sweep, add engine-backed regression coverage, preserve the full clean-room parity target, and rebuild a clean release that passes the same Godot checks after fresh extraction.

PROTECTED CONSTRAINTS
- Long-term target remains clean-room functional parity with The Sims 3 PC base game plus EP01-EP11 and SP01-SP09. Do not claim full parity while contracts remain incomplete.
- No Lovable, subscriptions, paid APIs, hosted backend, API keys, mandatory accounts, or runtime network services.
- Do not copy or ship proprietary/ripped The Sims 3 code, branding, assets, audio, textures, models, or data.
- Do not push, publish, deploy, or delete unrelated user files.
- Keep bundled project-owned fallback assets functional even if optional third-party assets are unavailable.
- Static/Python checks are supplemental. Real Godot parser/import/runtime evidence controls working claims.

READ FIRST, IN ORDER
1. `OPERATIONAL_STATE.md`
2. `qa/CODEX_BUG_SWEEP_SEED.md` — this is the mandatory minimum defect queue; verify each item and repair it
3. `docs/REQUIREMENT_LEDGER.md`
4. `data/feature_ledger.json`
5. `qa/VALIDATION_REPORT.md`
6. `docs/RUNTIME_TEST_CHECKLIST.md`
7. `docs/PARITY_TARGET.md`
8. `docs/CLEAN_ROOM.md`
9. `docs/resources/ASSET_SOURCE_REPORT.md`
10. `project.godot`, `scenes/main.tscn`, `src/`, `data/`, `tests/`, and `tools/` as required by the failures

The preserved file `qa/evidence/OPERATIONAL_STATE.invalid-v0.3.0.md` is historical evidence only. Do not use it as active state.
Root `MANIFEST.md`, `FILE_MANIFEST.json`, and `CHECKSUMS.sha256` are v0.3.0 release evidence, not the handoff inventory; `CODEX_HANDOFF_MANIFEST.sha256` is the handoff inventory. Regenerate the release manifests only after repairs pass.

BASELINE BEFORE EDITS
Create `qa/codex/` and save concise logs there.
1. Record the handoff ZIP SHA-256.
2. Run `python3 tools/run_validation.py`.
3. Resolve a real Godot 4.7.x executable. Prefer installed Godot; use 4.7.1 stable when available. Check `/Applications/Godot.app/Contents/MacOS/Godot`, `~/Applications`, `godot4`, and `godot` before downloading anything.
4. If Godot is absent and network access is available, acquire only the official Godot release into a user-local location and verify publisher checksum metadata. Do not use third-party mirrors or require Homebrew.
5. Record `Godot --version`.
6. Run a headless editor/import parse of the whole project using flags supported by that installed Godot version.
7. Run `tests/godot/smoke_test.gd` through the real engine.
8. Preserve the earliest parser/import/runtime failure before changing code.

IMPLEMENTATION
Use one cohesive repair pass. Treat `qa/CODEX_BUG_SWEEP_SEED.md` as the minimum queue, not the maximum scope. Fix additional failures only when they are exposed by the real engine, tests, or direct adjacency to a confirmed defect.

Fail-fast priorities:
- repair the confirmed `autonomy_system.gd` indentation/parser defect;
- remove invalid `SimulationClock.day_index` / `SimulationClock.total_minutes` accesses by using a real clock API;
- make routing fail safely instead of phasing through blockers and restore temporary grid mutations;
- add reachable object interaction slots and coherent collision/navigation blockers;
- centralize CAS/Build/Buy/map mode, speed, panel, music, and text-focus input policy;
- repair opportunity payouts, career-wish wiring, lot/household ownership context, Build/Buy sale authority, save schema/atomic replacement, weather initialization, deterministic fishing/weather RNG, and age-dependent CAS geometry;
- implement real executable paths for death/ghosts, services, school/homework, and pets where feasible; otherwise downgrade their feature-ledger evidence honestly;
- remove the incorrect arcade->Showtime performance coupling;
- reconcile every `implemented_unverified` feature row against reachable Godot-backed behavior.

Do not paper over failures by disabling diagnostics or relaxing tests.

REQUIRED GODOT TEST COVERAGE
Create/expand tests under `tests/godot/` and prove, in the real engine:
- all scripts/resources parse/import;
- main scene instantiates and runs several simulation minutes;
- autonomy queues a legal interaction;
- a Sim routes to a reachable interaction slot, completes the interaction, and cannot cross an impossible blocker;
- social interaction changes relationship state;
- opportunity reward pays the correct household exactly once;
- career progress can advance/complete a career wish;
- Build/Buy places, rotates, rejects overlap/out-of-lot placement, and sells only authorized owned objects with correct funds;
- Live->CAS->Apply/Close->Live restores coherent clock/music/panel/input state and age changes update collider geometry;
- selected-Sim and active-household economy/ownership are coherent;
- save/load round-trip restores clock, Sims, queues, objects, ownership, rotation, household, world, settings/grid size, inventory, moodlets, wishes, genetics, and parity-system state;
- corrupt-primary save recovers a valid backup;
- services/school/death/pets are either truly executable and tested or their ledger evidence is downgraded;
- every BG/EP01-EP11/SP01-SP09 slice left source-wired has at least one engine-exercised path;
- runtime does not require internet, credentials, paid services, or external assets.

Do not promote all source-wired rows because one broad smoke test passes. Keep evidence feature-specific.

ASSET PASS — ONLY AFTER CORE RUNTIME IS GREEN
The project must remain runnable with bundled assets alone. If direct, account-free, original-publisher acquisition is available, you may improve assets using the existing asset policy and source report. Highest-value candidates are:
- Quaternius Universal Base Characters + Universal Animation Library 2 as one humanoid/animation ecosystem;
- Quaternius Ultimate House Interior Pack or Kenney Furniture Kit for coherent interiors.

For anything acquired: preserve exact source/license evidence, original filename, acquisition date, SHA-256, and untouched original; inspect before integration; reject executables, uncertain provenance, game rips, logos, or restricted material; integrate only through project-owned aliases; keep fallback assets until the replacement imports and works in Godot. If acquisition cannot be verified noninteractively, skip it rather than block the project.

VALIDATION LADDER
After the primary repair pass:
1. Python static/data/asset validation.
2. Godot headless import/parser.
3. Existing smoke test.
4. Focused tests for repaired systems.
5. Full Godot integration suite.
6. Normal main-scene launch and representative player journey when GUI observation is available.
7. Inspect changed files for collateral damage.

If anything fails, perform one focused repair pass for those concrete failures, then rerun affected checks plus the full integration gate. If a mandatory failure still remains, stop with exact evidence instead of looping or claiming completion.

STATE AND EVIDENCE
Update `OPERATIONAL_STATE.md` only from observed evidence. Keep unresolved failures visible. Create/update:
- `qa/CODEX_BUG_SWEEP_REPORT.md`
- `qa/GODOT_RUNTIME_VALIDATION.md`
- `docs/REQUIREMENT_LEDGER.md`
- `docs/FEATURE_MATRIX.md`
- `data/feature_ledger.json`
- README/release notes only where the new evidence changes them.

CLEAN RELEASE
Only if the mandatory Godot acceptance gates pass:
1. Build a fresh staging tree from an explicit intended-file allowlist/manifest; do not recursively zip the dirty working directory.
2. Exclude `.godot/`, `.git/`, `__pycache__/`, `*.pyc`, `.DS_Store`, temp/scratch files, user saves, editor caches, and unrelated logs.
3. Regenerate release manifests/checksums from the staged payload.
4. Create `/Users/andrew/Life_Sim/OpenLife_Godot_Codex_Fixed.zip` and its `.sha256`.
5. Test ZIP integrity.
6. Extract that finished ZIP into a separate temporary directory.
7. Run the Godot import/parser, smoke test, and full integration suite against the fresh extraction.
8. Only then call the archive ready.
9. Leave the working project at `/Users/andrew/Life_Sim/OpenLife` and open its `project.godot` in Godot at the end when GUI launch is available.

Do not create a misleading `Fixed` archive if mandatory runtime criteria fail.

DONE WHEN
- the original handoff ZIP is preserved;
- `/Users/andrew/Life_Sim/OpenLife/project.godot` exists;
- real Godot parser/import is clean;
- main scene launches;
- smoke + focused + integration tests pass;
- confirmed defects in `qa/CODEX_BUG_SWEEP_SEED.md` are fixed or, only for genuinely incomplete feature claims, explicitly downgraded with evidence;
- routing/collision, mode/input state, economy/ownership, and save/recovery paths are engine-tested;
- bundled assets remain sufficient offline;
- clean-room/local-first constraints remain intact;
- fresh-extracted final ZIP passes the same Godot gates;
- full parity is not falsely claimed.

FINAL REPORT
Return only:
1. handoff ZIP SHA-256;
2. Godot version/binary used;
3. project path;
4. confirmed bugs fixed and any intentionally downgraded feature claims;
5. materially changed files;
6. validation commands/results;
7. external assets actually integrated, if any, with source/license/hash;
8. final ZIP/checksum paths if acceptance passed;
9. unresolved blockers, if any.

Do not provide hidden reasoning or a long activity transcript.
