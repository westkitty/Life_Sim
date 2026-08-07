# Operational State: OpenLife Godot

<!-- operational-state:metadata
{
  "artifact_path": "",
  "current_baseline": {
    "identity": "OpenLife v0.3.1 repaired working tree at /Users/andrew/Life_Sim/OpenLife",
    "last_verified": "2026-08-06 Codex repair pass, Godot 4.7.1.stable.official.a13da4feb",
    "state": "current-baseline"
  },
  "last_updated": "2026-08-07T02:56:16Z",
  "linked_parent_state": null,
  "project_id": "openlife-godot",
  "project_name": "OpenLife Godot",
  "project_root": "/Users/andrew/Life_Sim/OpenLife",
  "schema_version": 1,
  "scope_boundaries": [
    "OpenLife Godot project extracted to /Users/andrew/Life_Sim/OpenLife",
    "Handoff archive preserved in /Users/andrew/Life_Sim"
  ],
  "state_revision": 3
}
-->

## 1. Project Identity and Scope

- **Project ID:** `openlife-godot`
- **Purpose:** Preserve current operational truth for OpenLife Godot.
- **Project type:** Unclassified durable artifact project.
- **Primary root or artifact:** `/Users/andrew/Life_Sim/OpenLife`
- **Target environment:** Unknown until established by project evidence.
- **Canonical authority:** Explicit user instruction and project-local evidence.
- **Governed scope:** Project rooted at /Users/andrew/Life_Sim/OpenLife
- **Explicitly not governed:** Unrelated projects and neighboring subsystems unless explicitly linked.

## 2. Current Baseline

- **Primary artifact:** `/Users/andrew/Life_Sim/OpenLife/project.godot` (Godot 4.7 project)
- **Baseline state:** `verified-working` for the gates listed in section 11; `incomplete` against full Sims 3 parity.
- **Source/build/install identity:** OpenLife v0.3.1 (Codex repaired). Handoff archive SHA-256 `857b6bcfd1f169e3977d3e2bff6b6ad175c69e33207f6651c733390294e3ff4f`, preserved unchanged at `/Users/andrew/Life_Sim/OpenLife_Codex_Handoff_v0.3.0.zip`.
- **Active default user route:** Open `project.godot` in Godot 4.7.1 and press F5; `scenes/main.tscn` launches the neighborhood.
- **Delivery state:** `/Users/andrew/Life_Sim/OpenLife_Godot_Codex_Fixed.zip` with `.sha256`, built from an explicit allowlist and re-verified after fresh extraction.
- **Last verified baseline:** Godot 4.7.1.stable.official.a13da4feb — import/parse clean, smoke pass, 431/431 integration checks, windowed launch clean.

## 3. Artifact Contract

- **Deliverable shape:** a directly importable Godot 4.7 project tree plus a release ZIP and external SHA-256.
- **Runtime behavior:** a single continuously loaded 3D neighborhood with five Sims across two households, motives, queued and autonomous interactions, A* routing to reachable interaction slots, Build/Buy, CAS, services, school, death, save/load with backup recovery.
- **User journey:** open `project.godot` → F5 → select a Sim → queue an interaction → watch it route and complete → Build/Buy place and sell → CAS edit and apply → save and load.
- **Dependencies:** Godot 4.7.1 stable or compatible 4.x. Python 3 is optional and used only for validation and release tooling.
- **Packaging:** allowlist-staged ZIP; manifests regenerated from the staged payload; archive membership compared exactly against the manifest.
- **Prohibited substitutions:** no Lovable, subscription, paid API, hosted backend, API key, mandatory account or runtime network service; no proprietary Sims 3 code, branding, assets or data.

## 4. Active Invariants

Add stable `INV-###` entries for rules future work must preserve.

<!-- operational-state:entry
{
  "authority": "Explicit user instruction",
  "evidence": "Current conversation requirement",
  "id": "INV-001",
  "last_checked": "Codex handoff preparation",
  "recheck_trigger": "Any feature promotion, release, or parity claim",
  "rule": "The long-term target remains clean-room functional parity with The Sims 3 PC base game plus EP01-EP11 and SP01-SP09; unfinished contracts must remain visible and must not be called complete.",
  "scope": "Implementation, evidence, documentation, and release claims",
  "state": "requested",
  "status": "active",
  "title": "Full Sims 3 parity remains the controlling target",
  "validation_method": "Reconcile feature ledger states against actual Godot-backed evidence before any parity claim."
}
-->
### INV-001 — Full Sims 3 parity remains the controlling target

- **State:** `requested`
- **Authority:** Explicit user instruction
- **Evidence:** Current conversation requirement
- **Last Checked:** Codex handoff preparation
- **Recheck Trigger:** Any feature promotion, release, or parity claim
- **Rule:** The long-term target remains clean-room functional parity with The Sims 3 PC base game plus EP01-EP11 and SP01-SP09; unfinished contracts must remain visible and must not be called complete.
- **Scope:** Implementation, evidence, documentation, and release claims
- **Status:** active
- **Validation Method:** Reconcile feature ledger states against actual Godot-backed evidence before any parity claim.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Explicit user instruction",
  "evidence": "User rejected paid Lovable usage",
  "id": "INV-002",
  "last_checked": "Codex handoff preparation",
  "recheck_trigger": "Any dependency, backend, asset, or build-system change",
  "rule": "No Lovable, subscription, paid API, hosted backend, API key, mandatory account, or runtime network service may become required.",
  "scope": "Runtime, build, assets, tooling, and delivery",
  "state": "requested",
  "status": "active",
  "title": "Project remains free and local-first",
  "validation_method": "Inspect dependencies and runtime code for mandatory paid or network services."
}
-->
### INV-002 — Project remains free and local-first

- **State:** `requested`
- **Authority:** Explicit user instruction
- **Evidence:** User rejected paid Lovable usage
- **Last Checked:** Codex handoff preparation
- **Recheck Trigger:** Any dependency, backend, asset, or build-system change
- **Rule:** No Lovable, subscription, paid API, hosted backend, API key, mandatory account, or runtime network service may become required.
- **Scope:** Runtime, build, assets, tooling, and delivery
- **Status:** active
- **Validation Method:** Inspect dependencies and runtime code for mandatory paid or network services.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Project clean-room requirement",
  "evidence": "Existing CLEAN_ROOM documentation and user goal",
  "id": "INV-003",
  "last_checked": "Codex handoff preparation",
  "recheck_trigger": "Any external asset acquisition or parity implementation",
  "rule": "Do not copy or ship The Sims 3 proprietary code, branding, models, textures, audio, data files, or ripped assets; functional-system parity must be implemented independently.",
  "scope": "All source, assets, data, and release contents",
  "state": "requested",
  "status": "active",
  "title": "Preserve clean-room IP boundary",
  "validation_method": "Review source and asset provenance before release."
}
-->
### INV-003 — Preserve clean-room IP boundary

- **State:** `requested`
- **Authority:** Project clean-room requirement
- **Evidence:** Existing CLEAN_ROOM documentation and user goal
- **Last Checked:** Codex handoff preparation
- **Recheck Trigger:** Any external asset acquisition or parity implementation
- **Rule:** Do not copy or ship The Sims 3 proprietary code, branding, models, textures, audio, data files, or ripped assets; functional-system parity must be implemented independently.
- **Scope:** All source, assets, data, and release contents
- **Status:** active
- **Validation Method:** Review source and asset provenance before release.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Operational-state policy and prior audit findings",
  "evidence": "Static validation previously passed despite confirmed GDScript/runtime defects",
  "id": "INV-004",
  "last_checked": "Codex handoff preparation",
  "recheck_trigger": "Any claim that the project or a feature works",
  "rule": "Static checks, file presence, and package integrity are not substitutes for Godot parsing, import, runtime, and user-path validation.",
  "scope": "Validation and reporting",
  "state": "requested",
  "status": "active",
  "title": "Godot runtime evidence controls working claims",
  "validation_method": "Use a real Godot executable for parser/import/smoke/integration gates."
}
-->
### INV-004 — Godot runtime evidence controls working claims

- **State:** `requested`
- **Authority:** Operational-state policy and prior audit findings
- **Evidence:** Static validation previously passed despite confirmed GDScript/runtime defects
- **Last Checked:** Codex handoff preparation
- **Recheck Trigger:** Any claim that the project or a feature works
- **Rule:** Static checks, file presence, and package integrity are not substitutes for Godot parsing, import, runtime, and user-path validation.
- **Scope:** Validation and reporting
- **Status:** active
- **Validation Method:** Use a real Godot executable for parser/import/smoke/integration gates.
<!-- /operational-state:entry -->

## 5. Verified Working Behavior

Add stable `VER-###` entries only when evidence proves the required behavior through an appropriate path.

<!-- operational-state:entry
{
  "artifact_revision": "OpenLife v0.3.1 (Codex repaired)",
  "behavior": "The project parses, imports and launches in Godot 4.7.1, and passes a 431-check engine-backed integration suite plus the shallow smoke test.",
  "evidence": "qa/codex/final_godot_import.log; qa/codex/final_smoke_test.log; qa/codex/final_integration_test.log; qa/codex/gui_launch.log",
  "id": "VER-001",
  "last_checked": "2026-08-06 Codex repair pass",
  "recheck_trigger": "Any source, data, asset or project-setting change",
  "state": "verified-working",
  "title": "Godot 4.7.1 parse, import, launch and integration gates pass",
  "user_path": "Open project.godot in Godot 4.7.1 and press F5",
  "validation_method": "Real Godot executable: --headless --import, --script smoke_test.gd, integration_test.tscn, and a windowed 420-frame main-scene run."
}
-->
### VER-001 — Godot 4.7.1 parse, import, launch and integration gates pass

- **State:** `verified-working`
- **Artifact Revision:** OpenLife v0.3.1 (Codex repaired)
- **Behavior:** The project parses, imports and launches in Godot 4.7.1, and passes a 431-check engine-backed integration suite plus the shallow smoke test.
- **Evidence:** `qa/codex/final_godot_import.log`, `qa/codex/final_smoke_test.log`, `qa/codex/final_integration_test.log`, `qa/codex/gui_launch.log`
- **Last Checked:** 2026-08-06 Codex repair pass
- **Recheck Trigger:** Any source, data, asset or project-setting change
- **User Path:** Open `project.godot` in Godot 4.7.1 and press F5
- **Validation Method:** Real Godot executable: `--headless --import`, `--script smoke_test.gd`, `integration_test.tscn`, and a windowed 420-frame main-scene run.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "artifact_revision": "OpenLife v0.3.1 (Codex repaired)",
  "behavior": "Routing fails safely instead of phasing through blockers; interactions target reachable orientation-aware access slots; architecture blocks navigation; mode/speed/panel/input policy is centralized; economy and ownership are coherent; save/load round-trips and recovers from a corrupt primary slot.",
  "evidence": "tests/godot/integration_test.gd named checks recorded in qa/GODOT_RUNTIME_VALIDATION.md",
  "id": "VER-002",
  "last_checked": "2026-08-06 Codex repair pass",
  "recheck_trigger": "Any change to routing, world building, mode control, household economy or save code",
  "state": "verified-working",
  "title": "Confirmed defect classes are repaired and engine-tested",
  "user_path": "Live play: select a Sim, queue an interaction, build/sell, edit in CAS, save and load",
  "validation_method": "Feature-specific assertions in the Godot integration suite."
}
-->
### VER-002 — Confirmed defect classes are repaired and engine-tested

- **State:** `verified-working`
- **Artifact Revision:** OpenLife v0.3.1 (Codex repaired)
- **Behavior:** Routing fails safely instead of phasing through blockers; interactions target reachable orientation-aware access slots; architecture blocks navigation; mode/speed/panel/input policy is centralized; economy and ownership are coherent; save/load round-trips and recovers from a corrupt primary slot.
- **Evidence:** `tests/godot/integration_test.gd` named checks recorded in `qa/GODOT_RUNTIME_VALIDATION.md`
- **Last Checked:** 2026-08-06 Codex repair pass
- **Recheck Trigger:** Any change to routing, world building, mode control, household economy or save code
- **User Path:** Live play: select a Sim, queue an interaction, build/sell, edit in CAS, save and load
- **Validation Method:** Feature-specific assertions in the Godot integration suite.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "artifact_revision": "OpenLife v0.3.2 (visual fix)",
  "behavior": "The running game renders a coherent 3D neighborhood: textured terrain, roads, lots, houses, trees, furniture, visible Sims, working lighting and a correctly framed camera, with the HUD layered over the world.",
  "evidence": "qa/visual/after_visual_fix.png; qa/visual/visual_scene_test.log",
  "id": "VER-003",
  "last_checked": "2026-08-07 visual repair pass",
  "recheck_trigger": "Any change to camera, labels, materials, world building or asset instantiation",
  "state": "verified-working",
  "title": "The game visibly renders its 3D world",
  "user_path": "Press Play in Godot 4.7.1",
  "validation_method": "Rendered screenshot from a real (non-headless) renderer plus tests/godot/visual_scene_test.tscn asserting visible render geometry per Sim, per object, per building and terrain."
}
-->
### VER-003 — The game visibly renders its 3D world

- **State:** `verified-working`
- **Artifact Revision:** OpenLife v0.3.2 (visual fix)
- **Behavior:** The running game renders a coherent 3D neighborhood: textured terrain, roads, lots, houses, trees, furniture, visible Sims, working lighting and a correctly framed camera, with the HUD layered over the world.
- **Evidence:** `qa/visual/after_visual_fix.png`, `qa/visual/visual_scene_test.log`
- **Last Checked:** 2026-08-07 visual repair pass
- **Recheck Trigger:** Any change to camera, labels, materials, world building or asset instantiation
- **User Path:** Press Play in Godot 4.7.1
- **Validation Method:** Rendered screenshot from a real (non-headless) renderer plus `tests/godot/visual_scene_test.tscn` asserting visible render geometry per Sim, per object, per building and terrain.
<!-- /operational-state:entry -->

## 6. Known Not Working

Add stable `BRK-###` entries for confirmed failures. Keep them until repair evidence exists.

<!-- operational-state:entry
{
  "affected_user_path": "Opening and running the project in Godot",
  "artifact_revision": "OpenLife Codex handoff v0.3.0",
  "evidence": "Prior validation stopped at static/data/asset checks.",
  "id": "BRK-001",
  "observed_failure": "The pre-handoff environment could not execute Godot, so parser/import/runtime behavior is not proven.",
  "required_repair": "Run the real engine, fix all parser/import/runtime failures, and re-run integration tests.",
  "required_validation": "Headless import, smoke test, integration tests, and fresh-extraction release verification.",
  "severity": "critical",
  "state": "resolved",
  "status": "closed",
  "title": "Godot runtime state is unverified",
  "workaround": "None; Codex must validate with a real Godot binary."
}
-->
### BRK-001 — Godot runtime state is unverified (RESOLVED)

- **State:** `resolved`
- **Affected User Path:** Opening and running the project in Godot
- **Artifact Revision:** OpenLife Codex handoff v0.3.0
- **Evidence:** Prior validation stopped at static/data/asset checks.
- **Observed Failure:** The pre-handoff environment could not execute Godot, so parser/import/runtime behavior is not proven.
- **Required Repair:** Run the real engine, fix all parser/import/runtime failures, and re-run integration tests.
- **Required Validation:** Headless import, smoke test, integration tests, and fresh-extraction release verification.
- **Severity:** critical
- **Status:** closed — Godot 4.7.1.stable.official.a13da4feb executed import/parse, smoke, integration and a windowed launch. See VER-001.
- **Workaround:** No longer required.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Project parse, startup, interaction completion, routing, save/load, mode state, and several parity slices",
  "artifact_revision": "OpenLife Codex handoff v0.3.0",
  "evidence": "qa/CODEX_BUG_SWEEP_SEED.md",
  "id": "BRK-002",
  "observed_failure": "Independent bug sweep found a GDScript indentation/parser defect plus invalid SimulationClock member accesses and additional runtime-path defects.",
  "required_repair": "Execute and close the defect queue in qa/CODEX_BUG_SWEEP_SEED.md, beginning with parser/runtime blockers.",
  "required_validation": "Real Godot parser/import plus focused and integration tests for each affected path.",
  "severity": "critical",
  "state": "resolved",
  "status": "closed",
  "title": "Confirmed release-blocking source defects remain",
  "workaround": "None appropriate for release."
}
-->
### BRK-002 — Confirmed release-blocking source defects remain (RESOLVED)

- **State:** `resolved`
- **Affected User Path:** Project parse, startup, interaction completion, routing, save/load, mode state, and several parity slices
- **Artifact Revision:** OpenLife Codex handoff v0.3.0
- **Evidence:** qa/CODEX_BUG_SWEEP_SEED.md
- **Observed Failure:** Independent bug sweep found a GDScript indentation/parser defect plus invalid SimulationClock member accesses and additional runtime-path defects.
- **Required Repair:** Execute and close the defect queue in qa/CODEX_BUG_SWEEP_SEED.md, beginning with parser/runtime blockers.
- **Required Validation:** Real Godot parser/import plus focused and integration tests for each affected path.
- **Severity:** critical
- **Status:** closed — all 32 seed defects are closed (31 repaired, 1 downgraded honestly) plus 7 engine-discovered defects. See `qa/CODEX_BUG_SWEEP_REPORT.md`.
- **Workaround:** No longer required.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Pressing Play and looking at the running game",
  "artifact_revision": "OpenLife v0.3.1 (pre visual fix)",
  "evidence": "qa/visual/before_visual_fix.png - rendered 1280x800 frame of the running project",
  "id": "BRK-003",
  "observed_failure": "The running game showed giant always-on-top name labels over an empty road junction instead of the neighborhood. Terrain and roads rendered, but the camera framed world origin and every Label3D used fixed_size plus no_depth_test, so text covered the world.",
  "required_repair": "Frame the opening camera on the active home lot, make labels depth-tested and distance-scaled, and guarantee a procedural fallback whenever an imported model yields no visible geometry.",
  "required_validation": "Rendered before/after screenshots plus a visual scene invariant test run with a real renderer.",
  "severity": "critical",
  "state": "resolved",
  "status": "closed",
  "title": "Running game showed labels instead of the 3D world",
  "workaround": "None."
}
-->
### BRK-003 — Running game showed labels instead of the 3D world (RESOLVED)

- **State:** `resolved`
- **Affected User Path:** Pressing Play and looking at the running game
- **Artifact Revision:** OpenLife v0.3.1 (pre visual fix)
- **Evidence:** `qa/visual/before_visual_fix.png` — rendered 1280x800 frame of the running project
- **Observed Failure:** The running game showed giant always-on-top name labels over an empty road junction instead of the neighborhood. Terrain and roads rendered, but the camera framed the world origin and every `Label3D` used `fixed_size` plus `no_depth_test`, so text covered the world.
- **Required Repair:** Frame the opening camera on the active home lot, make labels depth-tested and distance-scaled, and guarantee a procedural fallback whenever an imported model yields no visible geometry.
- **Required Validation:** Rendered before/after screenshots plus a visual scene invariant test run with a real renderer.
- **Severity:** critical
- **Status:** closed — `qa/visual/after_visual_fix.png` shows terrain, roads, lot, house, trees, furniture, Sims and HUD in one rendered frame; `tests/godot/visual_scene_test.tscn` passes 71 checks.
- **Workaround:** No longer required.
<!-- /operational-state:entry -->

## 7. Implemented but Unverified

Add stable `UNV-###` entries for code, files, configuration, or artifact features that exist but are not proven through the required user journey.

<!-- operational-state:entry
{
  "evidence": "Source files and project data exist, but feature-specific Godot runtime evidence is incomplete.",
  "id": "UNV-001",
  "missing_evidence": "Reachable user/runtime path plus engine-backed validation for each retained source-wired feature.",
  "recheck_trigger": "Codex runtime validation and any feature-ledger promotion",
  "scope": "The 49 rows still marked implemented_unverified in data/feature_ledger.json after reconciliation",
  "state": "implemented-unverified",
  "title": "Source-wired parity features require engine evidence",
  "validation_method": "Exercise each retained BG/EP/SP runtime slice in Godot and downgrade any row that lacks a real path."
}
-->
### UNV-001 — Source-wired parity features require engine evidence

- **State:** `implemented-unverified`
- **Evidence:** Source files and project data exist, but feature-specific Godot runtime evidence is incomplete.
- **Missing Evidence:** Reachable user/runtime path plus engine-backed validation for each retained source-wired feature.
- **Recheck Trigger:** Codex runtime validation and any feature-ledger promotion
- **Scope:** The 49 rows still marked `implemented_unverified` in `data/feature_ledger.json` after reconciliation. 26 rows were promoted to `engine_verified` (each naming the Godot test that proves it) and 6 rows without a reachable caller were downgraded to `data_contract`.
- **Validation Method:** Exercise each retained BG/EP/SP runtime slice in Godot and downgrade any row that lacks a real path.
<!-- /operational-state:entry -->

## 8. Unknown or Evidence-Stale State

Add stable `UNK-###` entries for missing, conflicting, inaccessible, stale, or invalidated evidence.

## 9. Pending Work

Add stable `PND-###` entries for intentionally incomplete work. Pending does not automatically mean failed.

<!-- operational-state:entry
{
  "blocks_completion": true,
  "dependency": "Godot 4.x executable and local filesystem access",
  "id": "PND-001",
  "priority": "critical",
  "reason_pending": "Requires a Mac Codex instance with access to the downloaded handoff and a real Godot executable.",
  "state": "complete",
  "task": "Extract the handoff into /Users/andrew/Life_Sim/OpenLife, repair qa/CODEX_BUG_SWEEP_SEED.md, run real Godot validation, and build a fresh tested release archive.",
  "title": "Codex repair and engine-validation pass",
  "validation_needed": "Parser/import, smoke, integration, save/routing/mode/economy tests, and fresh-extraction release test"
}
-->
### PND-001 — Codex repair and engine-validation pass (COMPLETE)

- **State:** `complete`
- **Blocks Completion:** No
- **Dependency:** Godot 4.x executable and local filesystem access
- **Priority:** critical
- **Reason Pending:** Requires a Mac Codex instance with access to the downloaded handoff and a real Godot executable.
- **Task:** Extract the handoff into /Users/andrew/Life_Sim/OpenLife, repair qa/CODEX_BUG_SWEEP_SEED.md, run real Godot validation, and build a fresh tested release archive.
- **Validation Needed:** Parser/import, smoke, integration, save/routing/mode/economy tests, and fresh-extraction release test — all performed; see VER-001 and VER-002.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "blocks_completion": true,
  "dependency": "Substantial further implementation work",
  "id": "PND-002",
  "priority": "high",
  "reason_pending": "100 architecture contracts and 12 data contracts remain unimplemented; world travel does not stream a distinct playable destination; career schedules, level caps and salaries are incomplete; pets have no in-world agent.",
  "state": "pending",
  "task": "Continue toward clean-room functional parity with The Sims 3 base game plus EP01-EP11 and SP01-SP09.",
  "title": "Full parity remains incomplete",
  "validation_needed": "Feature-specific Godot assertions for each promoted row; no row may be promoted on the strength of a broad smoke test"
}
-->
### PND-002 — Full parity remains incomplete

- **State:** `pending`
- **Blocks Completion:** Yes
- **Dependency:** Substantial further implementation work
- **Priority:** high
- **Reason Pending:** 100 architecture contracts and 12 data contracts remain unimplemented; world travel does not stream a distinct playable destination; career schedules, level caps and salaries are incomplete; pets have no in-world agent.
- **Task:** Continue toward clean-room functional parity with The Sims 3 base game plus EP01–EP11 and SP01–SP09.
- **Validation Needed:** Feature-specific Godot assertions for each promoted row; no row may be promoted on the strength of a broad smoke test.
<!-- /operational-state:entry -->

## 10. Active Decisions, Defaults, and Prohibitions

Add stable `DEC-###` entries for source locks, routes, naming, packaging, style, rejected approaches, environment limits, and explicit supersessions.

<!-- operational-state:entry
{
  "authority": "Explicit user instruction",
  "decision": "The handoff archive is downloaded under /Users/andrew/Life_Sim and the extracted working project must be /Users/andrew/Life_Sim/OpenLife.",
  "evidence": "Current request",
  "id": "DEC-001",
  "recheck_trigger": "Only an explicit user path change supersedes this decision",
  "state": "requested",
  "status": "active",
  "title": "Codex working root is fixed"
}
-->
### DEC-001 — Codex working root is fixed

- **State:** `requested`
- **Authority:** Explicit user instruction
- **Decision:** The handoff archive is downloaded under /Users/andrew/Life_Sim and the extracted working project must be /Users/andrew/Life_Sim/OpenLife.
- **Evidence:** Current request
- **Recheck Trigger:** Only an explicit user path change supersedes this decision
- **Status:** active
<!-- /operational-state:entry -->

## 11. Validation and Evidence Matrix

| ID | Claim or behavior | State | Evidence | Validation method | Artifact/revision | Last checked | Recheck trigger |
|---|---|---|---|---|---|---|---|
| VER-001 | Project parses, imports and launches in Godot 4.7.1 | verified-working | `qa/codex/final_godot_import.log`, `qa/codex/gui_launch.log` | Real Godot `--headless --import` and windowed 420-frame run | v0.3.1 | 2026-08-06 | Any source/data/asset/project-setting change |
| VER-001 | Smoke test passes | verified-working | `qa/codex/final_smoke_test.log` | `--script res://tests/godot/smoke_test.gd` | v0.3.1 | 2026-08-06 | Any runtime change |
| VER-001 | Integration suite passes 431/431 | verified-working | `qa/codex/final_integration_test.log` | `res://tests/godot/integration_test.tscn` | v0.3.1 | 2026-08-06 | Any runtime change |
| VER-002 | Routing, mode/input, economy/ownership and save/recovery repairs behave correctly | verified-working | Named checks in `qa/GODOT_RUNTIME_VALIDATION.md` | Feature-specific Godot assertions | v0.3.1 | 2026-08-06 | Changes to those subsystems |
| — | Release archive passes the same gates after fresh extraction | verified-working | `qa/codex/release_verification.log` | Extract ZIP to a clean directory, then run import/smoke/integration | v0.3.1 | 2026-08-06 | Any repackage |
| UNV-001 | 49 source-wired rows behave as described | implemented-unverified | `data/feature_ledger.json` | Pack-level engine path only; no per-row assertion | v0.3.1 | 2026-08-06 | Any promotion attempt |
| PND-002 | Full Sims 3 parity | pending / not claimed | 100 architecture + 12 data contracts | Not applicable until implemented | v0.3.1 | 2026-08-06 | Any parity claim |

## 12. Current Change Scope and Impact Radius

- **Allowed to change:** `src/`, `tests/`, `tools/`, `data/`, `docs/`, `qa/` inside `/Users/andrew/Life_Sim/OpenLife`.
- **Must remain unchanged:** the preserved handoff ZIP; `qa/evidence/OPERATIONAL_STATE.invalid-v0.3.0.md`; the clean-room and local-first invariants; bundled fallback asset sufficiency.
- **Potentially affected behavior:** routing, navigation blockers, mode/speed/input policy, household economy and ownership, save schema, autonomy, and every pack runtime slice.
- **Mandatory checks:** `python3 tools/run_validation.py` (which includes the Godot gate), plus fresh-extraction verification of any rebuilt archive.
- **Checks deliberately reused:** existing Python static/data/asset validators, retained as supplemental evidence only.
- **Repair class:** Multi-subsystem defect repair plus new engine-backed regression coverage.

## 13. Compact Revision Log

### Revision 1 — 2026-08-07T02:55:46Z

- **Artifact/source identity:** `Not yet established`
- **State deltas:** Initialized operational state.
- **New evidence:** None.
- **Validation not performed:** All behavioral validation remains pending unless explicitly recorded above.

### Revision 2 — 2026-08-07T02:56:16Z

- **Artifact/source identity:** OpenLife Codex handoff v0.3.0 source tree
- **State deltas:** Updated metadata: current_baseline, scope_boundaries; Added INV-001 to 4. Active Invariants; Added INV-002 to 4. Active Invariants; Added INV-003 to 4. Active Invariants; Added INV-004 to 4. Active Invariants; Added BRK-001 to 6. Known Not Working; Added BRK-002 to 6. Known Not Working; Added UNV-001 to 7. Implemented but Unverified; Added PND-001 to 9. Pending Work; Added DEC-001 to 10. Active Decisions, Defaults, and Prohibitions
- **New evidence:** User specified /Users/andrew/Life_Sim as the handoff location; qa/CODEX_BUG_SWEEP_SEED.md contains the detailed confirmed defect queue; Godot runtime verification was unavailable before handoff
- **Newly verified behavior:** None.
- **Newly known failure:** BRK-001; BRK-002
- **Superseded rule:** None.
- **Validation not performed:** Godot parser/import/runtime validation
- **Reason for broad revalidation:** Codex must perform real Godot parsing and integration validation because static checks missed release-blocking defects.
- **Summary:** Establish the Codex handoff baseline, protected constraints, known blockers, and repair target

### Revision 3 — 2026-08-06 Codex repair and engine-validation pass

- **Artifact/source identity:** OpenLife v0.3.1 (Codex repaired) at `/Users/andrew/Life_Sim/OpenLife`
- **State deltas:** Added VER-001 and VER-002; closed BRK-001 and BRK-002; completed PND-001; added PND-002; narrowed UNV-001; populated sections 2, 3, 11 and 12.
- **New evidence:** Godot 4.7.1.stable.official.a13da4feb executed import/parse (clean), smoke test (pass), a new 431-check integration suite (pass), a windowed 420-frame main-scene launch (clean), and fresh-extraction verification of the rebuilt release archive.
- **Newly verified behavior:** VER-001, VER-002
- **Newly known failure:** None outstanding. Seven engine-discovered defects were found and repaired during the pass; all are recorded in `qa/CODEX_BUG_SWEEP_REPORT.md`.
- **Superseded rule:** None. INV-001 through INV-004 remain active and were honoured.
- **Validation not performed:** Per-row assertions for the 49 remaining `implemented_unverified` rows; any parity claim beyond the current ledger.
- **Reason for broad revalidation:** The prior release passed static validation while being unable to parse in Godot, so every runtime claim was re-established from real engine execution.
- **Summary:** Repair the confirmed defect queue, add engine-backed regression coverage, reconcile feature evidence against real runtime behaviour, and rebuild a verified release. Full Sims 3 parity remains incomplete and is not claimed.

### Revision 4 — 2026-08-07 Visual rendering repair pass

- **Artifact/source identity:** OpenLife v0.3.2 (visual fix) at `/Users/andrew/Life_Sim/OpenLife`
- **State deltas:** Added BRK-003 (recorded then resolved) and VER-003.
- **New evidence:** A rendered baseline screenshot proved the user-reported failure: giant always-on-top labels over an empty road junction. An in-engine diagnostic proved all 106 bundled GLBs contain visible, sanely-scaled, opaque geometry, so the defect was in presentation, not assets.
- **Newly verified behavior:** VER-003 — the running game renders a coherent 3D neighborhood.
- **Newly known failure:** None outstanding.
- **Superseded rule:** None.
- **Validation not performed:** Per-row visual assertions for individual parity features; full Sims 3 parity remains out of scope.
- **Reason for broad revalidation:** File existence, alias resolution, clean imports and 251 green static checks all coexisted with an unplayable-looking game, so a rendered-visibility gate was added and the QA philosophy was changed to separate "resource exists" from "geometry is visibly rendered".
- **Summary:** Fix the visual presentation path, guarantee procedural fallbacks for any model without renderable geometry, and add a permanent rendered-visibility regression gate.
