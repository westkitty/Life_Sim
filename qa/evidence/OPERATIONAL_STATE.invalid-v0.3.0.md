# Operational State: OpenLife Godot

<!-- operational-state:metadata
{
  "artifact_path": "",
  "current_baseline": {
    "identity": "Not yet established",
    "last_verified": null,
    "state": "unknown"
  },
  "last_updated": "2026-08-07T02:47:23Z",
  "linked_parent_state": null,
  "project_id": "openlife-godot",
  "project_name": "OpenLife Godot",
  "project_root": "/mnt/data/openlife-v03-work/openlife-godot",
  "schema_version": 1,
  "scope_boundaries": [
    "Project rooted at /mnt/data/openlife-v03-work/openlife-godot"
  ],
  "state_revision": 4
}
-->

## 1. Project Identity and Scope

- **Project ID:** `openlife-godot`
- **Purpose:** Preserve current operational truth for OpenLife Godot.
- **Project type:** Unclassified durable artifact project.
- **Primary root or artifact:** `/mnt/data/openlife-v03-work/openlife-godot`
- **Target environment:** Unknown until established by project evidence.
- **Canonical authority:** Explicit user instruction and project-local evidence.
- **Governed scope:** Project rooted at /mnt/data/openlife-v03-work/openlife-godot
- **Explicitly not governed:** Unrelated projects and neighboring subsystems unless explicitly linked.

## 2. Current Baseline

- **Primary artifact:** `Not yet established`
- **Baseline state:** `unknown`
- **Source/build/install identity:** Unknown unless recorded below.
- **Active default user route:** Unknown unless recorded below.
- **Delivery state:** Unknown unless recorded below.
- **Last verified baseline:** Not yet established.

## 3. Artifact Contract

Record the literal deliverable shape, file count and type, dimensions, runtime behavior, user journey, dependencies, packaging, delivery, and prohibited substitutions.

## 4. Active Invariants

Add stable `INV-###` entries for rules future work must preserve.

<!-- operational-state:entry
{
  "authority": "Explicit user instruction",
  "evidence": "Current conversation requirement",
  "id": "INV-001",
  "last_checked": "v0.3.0 candidate",
  "recheck_trigger": "Any release, parity status, feature promotion, or completion claim",
  "rule": "The long-term target is functional parity with the PC-era The Sims 3 base game plus EP01 through EP11 and SP01 through SP09; incomplete or architecture-only rows must remain visible and must not be described as parity achieved.",
  "scope": "All implementation, documentation, validation, and release claims",
  "state": "requested",
  "status": "active",
  "title": "Full Sims 3 parity remains the controlling target",
  "validation_method": "Compare feature ledger states and runtime evidence against the full parity target before any completion claim."
}
-->
### INV-001 — Full Sims 3 parity remains the controlling target

- **State:** `requested`
- **Authority:** Explicit user instruction
- **Evidence:** Current conversation requirement
- **Last Checked:** v0.3.0 candidate
- **Recheck Trigger:** Any release, parity status, feature promotion, or completion claim
- **Rule:** The long-term target is functional parity with the PC-era The Sims 3 base game plus EP01 through EP11 and SP01 through SP09; incomplete or architecture-only rows must remain visible and must not be described as parity achieved.
- **Scope:** All implementation, documentation, validation, and release claims
- **Status:** active
- **Validation Method:** Compare feature ledger states and runtime evidence against the full parity target before any completion claim.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Explicit user instruction",
  "evidence": "User rejected Lovable and required free local tooling",
  "id": "INV-002",
  "last_checked": "v0.3.0 candidate",
  "recheck_trigger": "Any dependency, integration, asset acquisition, backend, or build-system change",
  "rule": "The project must not require Lovable, subscriptions, paid APIs, hosted backends, API keys, accounts, or runtime network services.",
  "scope": "Runtime, build, assets, tooling, and delivery",
  "state": "requested",
  "status": "active",
  "title": "Project must remain free and local-first",
  "validation_method": "Scan runtime source and release dependencies for network clients, credentials, paid services, or hosted requirements."
}
-->
### INV-002 — Project must remain free and local-first

- **State:** `requested`
- **Authority:** Explicit user instruction
- **Evidence:** User rejected Lovable and required free local tooling
- **Last Checked:** v0.3.0 candidate
- **Recheck Trigger:** Any dependency, integration, asset acquisition, backend, or build-system change
- **Rule:** The project must not require Lovable, subscriptions, paid APIs, hosted backends, API keys, accounts, or runtime network services.
- **Scope:** Runtime, build, assets, tooling, and delivery
- **Status:** active
- **Validation Method:** Scan runtime source and release dependencies for network clients, credentials, paid services, or hosted requirements.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Operational-state policy and explicit user demand for demonstrated improvement",
  "evidence": "Godot executable remains unavailable in the current environment",
  "id": "INV-003",
  "last_checked": "v0.3.0 candidate",
  "recheck_trigger": "Any validation or completion status update",
  "rule": "Static checks, source presence, package integrity, and asset parsing must not be presented as Godot runtime verification or full gameplay parity.",
  "scope": "Validation and reporting",
  "state": "requested",
  "status": "active",
  "title": "No false verification claims",
  "validation_method": "Keep Godot runtime state unverified until an actual engine run proves the required paths."
}
-->
### INV-003 — No false verification claims

- **State:** `requested`
- **Authority:** Operational-state policy and explicit user demand for demonstrated improvement
- **Evidence:** Godot executable remains unavailable in the current environment
- **Last Checked:** v0.3.0 candidate
- **Recheck Trigger:** Any validation or completion status update
- **Rule:** Static checks, source presence, package integrity, and asset parsing must not be presented as Godot runtime verification or full gameplay parity.
- **Scope:** Validation and reporting
- **Status:** active
- **Validation Method:** Keep Godot runtime state unverified until an actual engine run proves the required paths.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Project clean-room boundary",
  "evidence": "Current release uses project-owned generated assets and separately documented external candidates",
  "id": "INV-004",
  "last_checked": "v0.3.0 candidate",
  "recheck_trigger": "Any external asset, code, content, or reference integration",
  "rule": "Do not copy proprietary The Sims 3 code, game assets, branding, or ripped content into OpenLife; use clean-room implementation and project-owned or rights-verified resources.",
  "scope": "Source, art, audio, data, documentation, and distribution",
  "state": "requested",
  "status": "active",
  "title": "Clean-room project assets and code",
  "validation_method": "Inspect manifests, notices, and source provenance before packaging."
}
-->
### INV-004 — Clean-room project assets and code

- **State:** `requested`
- **Authority:** Project clean-room boundary
- **Evidence:** Current release uses project-owned generated assets and separately documented external candidates
- **Last Checked:** v0.3.0 candidate
- **Recheck Trigger:** Any external asset, code, content, or reference integration
- **Rule:** Do not copy proprietary The Sims 3 code, game assets, branding, or ripped content into OpenLife; use clean-room implementation and project-owned or rights-verified resources.
- **Scope:** Source, art, audio, data, documentation, and distribution
- **Status:** active
- **Validation Method:** Inspect manifests, notices, and source provenance before packaging.
<!-- /operational-state:entry -->

## 5. Verified Working Behavior

Add stable `VER-###` entries only when evidence proves the required behavior through an appropriate path.

<!-- operational-state:entry
{
  "artifact_revision": "v0.3.0 candidate",
  "capability": "The v0.3.0 candidate source tree satisfies its deterministic static/source checks and data unit tests.",
  "dependencies": "Python 3 standard-library validation tools included with the project",
  "evidence": "249 static/source checks and 14 unit/data tests passed in the current environment.",
  "freshness": "current candidate",
  "id": "VER-001",
  "last_verified": "2026-08-07T02:45:00Z",
  "recheck_trigger": "Any source, data, catalog, ledger, save-schema, resource-manifest, or validation-tool change",
  "scope": "Accessible source tree and structured data",
  "state": "verified",
  "title": "Static source and data integrity checks pass",
  "verification_method": "Run tools/run_validation.py and inspect the static and unit-test sections."
}
-->
### VER-001 — Static source and data integrity checks pass

- **State:** `verified`
- **Artifact Revision:** v0.3.0 candidate
- **Capability:** The v0.3.0 candidate source tree satisfies its deterministic static/source checks and data unit tests.
- **Dependencies:** Python 3 standard-library validation tools included with the project
- **Evidence:** 249 static/source checks and 14 unit/data tests passed in the current environment.
- **Freshness:** current candidate
- **Last Verified:** 2026-08-07T02:45:00Z
- **Recheck Trigger:** Any source, data, catalog, ledger, save-schema, resource-manifest, or validation-tool change
- **Scope:** Accessible source tree and structured data
- **Verification Method:** Run tools/run_validation.py and inspect the static and unit-test sections.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "artifact_revision": "v0.3.0 candidate",
  "capability": "Bundled GLB, WAV, PNG, and SVG resources satisfy deterministic byte and manifest checks and catalog aliases resolve.",
  "dependencies": "Project asset manifests and generated asset tree",
  "evidence": "729 asset checks passed with 106 GLB, 24 WAV, 7 PNG textures, 5 SVG UI assets, and 73 catalog objects.",
  "freshness": "current candidate",
  "id": "VER-002",
  "last_verified": "2026-08-07T02:23:02Z",
  "recheck_trigger": "Any asset, alias, catalog, manifest, generator, or packaging change",
  "scope": "Bundled project-owned assets and asset manifests",
  "state": "verified",
  "title": "Bundled asset integrity and catalog resolution pass",
  "verification_method": "Run tools/validate_assets.py and inspect alias, file-format, hash, and minimum-count checks."
}
-->
### VER-002 — Bundled asset integrity and catalog resolution pass

- **State:** `verified`
- **Artifact Revision:** v0.3.0 candidate
- **Capability:** Bundled GLB, WAV, PNG, and SVG resources satisfy deterministic byte and manifest checks and catalog aliases resolve.
- **Dependencies:** Project asset manifests and generated asset tree
- **Evidence:** 729 asset checks passed with 106 GLB, 24 WAV, 7 PNG textures, 5 SVG UI assets, and 73 catalog objects.
- **Freshness:** current candidate
- **Last Verified:** 2026-08-07T02:23:02Z
- **Recheck Trigger:** Any asset, alias, catalog, manifest, generator, or packaging change
- **Scope:** Bundled project-owned assets and asset manifests
- **Verification Method:** Run tools/validate_assets.py and inspect alias, file-format, hash, and minimum-count checks.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "artifact_revision": "v0.3.0 candidate versus v0.2.0 baseline",
  "capability": "The candidate improves source wiring, catalog breadth, asset breadth, geometric detail, validation coverage, and sourcing discipline relative to the frozen v0.2 baseline.",
  "dependencies": "Frozen baseline metrics/log, current candidate metrics/log, asset proof render, and source-evidence records",
  "evidence": "Source-wired rows 23 to 78; objects 34 to 73; GLB 51 to 106; faces 7892 to 37844; static checks 125 to 249; unit tests 4 to 14; asset checks 333 to 729; external candidate lifecycle/source checks added.",
  "freshness": "current candidate",
  "id": "VER-003",
  "last_verified": "2026-08-07T02:45:00Z",
  "recheck_trigger": "Any candidate metric, baseline provenance, asset generation, resource sourcing, or validation change",
  "scope": "Package/source/asset metrics and resource-governance evidence only",
  "state": "verified",
  "title": "v0.3 candidate is measurably broader than v0.2 baseline",
  "verification_method": "Run tools/capture_improvement_metrics.py, compare qa/improvement/baseline_metrics.json with final_metrics.json, and inspect before_after_asset_proof.png."
}
-->
### VER-003 — v0.3 candidate is measurably broader than v0.2 baseline

- **State:** `verified`
- **Artifact Revision:** v0.3.0 candidate versus v0.2.0 baseline
- **Capability:** The candidate improves source wiring, catalog breadth, asset breadth, geometric detail, validation coverage, and sourcing discipline relative to the frozen v0.2 baseline.
- **Dependencies:** Frozen baseline metrics/log, current candidate metrics/log, asset proof render, and source-evidence records
- **Evidence:** Source-wired rows 23 to 78; objects 34 to 73; GLB 51 to 106; faces 7892 to 37844; static checks 125 to 249; unit tests 4 to 14; asset checks 333 to 729; external candidate lifecycle/source checks added.
- **Freshness:** current candidate
- **Last Verified:** 2026-08-07T02:45:00Z
- **Recheck Trigger:** Any candidate metric, baseline provenance, asset generation, resource sourcing, or validation change
- **Scope:** Package/source/asset metrics and resource-governance evidence only
- **Verification Method:** Run tools/capture_improvement_metrics.py, compare qa/improvement/baseline_metrics.json with final_metrics.json, and inspect before_after_asset_proof.png.
<!-- /operational-state:entry -->

## 6. Known Not Working

Add stable `BRK-###` entries for confirmed failures. Keep them until repair evidence exists.

<!-- operational-state:entry
{
  "affected_user_path": "Any claim or expectation of full The Sims 3 feature parity",
  "artifact_revision": "v0.3.0 candidate",
  "evidence": "data/feature_ledger.json and docs/FEATURE_MATRIX.md",
  "id": "BRK-001",
  "observed_failure": "The feature ledger still contains 100 architecture-contract rows and 9 data-contract rows without equivalent runtime implementation and validation.",
  "required_repair": "Implement and integrate the remaining parity contracts subsystem by subsystem.",
  "required_validation": "Run each implemented path in Godot and reconcile the ledger only after behavioral evidence exists.",
  "severity": "critical",
  "state": "known-broken",
  "status": "open",
  "title": "Full Sims 3 parity is not implemented",
  "workaround": "None; use the implemented simulation shell while residual parity work remains explicit."
}
-->
### BRK-001 — Full Sims 3 parity is not implemented

- **State:** `known-broken`
- **Affected User Path:** Any claim or expectation of full The Sims 3 feature parity
- **Artifact Revision:** v0.3.0 candidate
- **Evidence:** data/feature_ledger.json and docs/FEATURE_MATRIX.md
- **Observed Failure:** The feature ledger still contains 100 architecture-contract rows and 9 data-contract rows without equivalent runtime implementation and validation.
- **Required Repair:** Implement and integrate the remaining parity contracts subsystem by subsystem.
- **Required Validation:** Run each implemented path in Godot and reconcile the ledger only after behavioral evidence exists.
- **Severity:** critical
- **Status:** open
- **Workaround:** None; use the implemented simulation shell while residual parity work remains explicit.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Project import, autonomous interaction selection, minute ticking, and interaction completion memory recording",
  "artifact_revision": "v0.3.0 downloaded release",
  "evidence": "src/core/systems/autonomy_system.gd lines 27-35 has invalid indentation; src/main.gd references nonexistent SimulationClock.day_index; src/core/systems/expansion_runtime_system.gd references nonexistent SimulationClock.day_index and SimulationClock.total_minutes",
  "id": "BRK-002",
  "observed_failure": "The source contains at least one parser-level indentation defect and invalid autoload member accesses that the Python validator did not detect.",
  "required_repair": "Correct AutonomySystem indentation/scope; replace nonexistent SimulationClock property access with explicit current-day/total-minute API or signal arguments; then parse/import all scripts with Godot.",
  "required_validation": "Godot editor/headless import must report no script parse errors, then the minute tick and one completed interaction must execute without runtime errors.",
  "severity": "critical",
  "state": "known-broken",
  "status": "open",
  "title": "Confirmed GDScript compile/runtime blockers exist in v0.3.0",
  "workaround": "None; repair before treating the project as runnable."
}
-->
### BRK-002 — Confirmed GDScript compile/runtime blockers exist in v0.3.0

- **State:** known-broken
- **Affected User Path:** Project import, autonomous interaction selection, minute ticking, and interaction completion memory recording
- **Artifact Revision:** v0.3.0 downloaded release
- **Evidence:** src/core/systems/autonomy_system.gd lines 27-35 has invalid indentation; src/main.gd references nonexistent SimulationClock.day_index; src/core/systems/expansion_runtime_system.gd references nonexistent SimulationClock.day_index and SimulationClock.total_minutes
- **Observed Failure:** The source contains at least one parser-level indentation defect and invalid autoload member accesses that the Python validator did not detect.
- **Required Repair:** Correct AutonomySystem indentation/scope; replace nonexistent SimulationClock property access with explicit current-day/total-minute API or signal arguments; then parse/import all scripts with Godot.
- **Required Validation:** Godot editor/headless import must report no script parse errors, then the minute tick and one completed interaction must execute without runtime errors.
- **Severity:** critical
- **Status:** open
- **Workaround:** None; repair before treating the project as runnable.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Walking to objects and executing interactions",
  "artifact_revision": "v0.3.0 downloaded release",
  "evidence": "RoutingSystem clears only the target center cell, falls back to direct [to_position] on no path, does not restore a solid start cell, and InteractableObject targets its own center; SimAgent collision mask excludes object layer 4.",
  "id": "BRK-003",
  "observed_failure": "Unreachable or large-footprint objects can produce invalid routes, and the fallback path can phase Sims through object/structure geometry.",
  "required_repair": "Add reachable interaction slots/perimeter targets, fail gracefully on no route, restore temporary grid edits, align collision masks/layers, and include structural blockers in navigation.",
  "required_validation": "Runtime tests for 1x1, 2x2, and large objects, blocked corridors, unreachable targets, and multiple consecutive routes with no grid mutation leakage.",
  "severity": "high",
  "state": "known-broken",
  "status": "open",
  "title": "Routing and interaction targeting can move Sims through blocked geometry",
  "workaround": "None reliable."
}
-->
### BRK-003 — Routing and interaction targeting can move Sims through blocked geometry

- **State:** known-broken
- **Affected User Path:** Walking to objects and executing interactions
- **Artifact Revision:** v0.3.0 downloaded release
- **Evidence:** RoutingSystem clears only the target center cell, falls back to direct [to_position] on no path, does not restore a solid start cell, and InteractableObject targets its own center; SimAgent collision mask excludes object layer 4.
- **Observed Failure:** Unreachable or large-footprint objects can produce invalid routes, and the fallback path can phase Sims through object/structure geometry.
- **Required Repair:** Add reachable interaction slots/perimeter targets, fail gracefully on no route, restore temporary grid edits, align collision masks/layers, and include structural blockers in navigation.
- **Required Validation:** Runtime tests for 1x1, 2x2, and large objects, blocked corridors, unreachable targets, and multiple consecutive routes with no grid mutation leakage.
- **Severity:** high
- **Status:** open
- **Workaround:** None reliable.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Entering/exiting Create-a-Sim, Build/Buy, map mode, pausing, and typing in UI",
  "artifact_revision": "v0.3.0 downloaded release",
  "evidence": "HUD Edit Selected Sim opens CAS directly without mode change; CAS Close only hides the panel; mode changes do not centrally own panel visibility; speed buttons call SimulationClock directly and can unpause non-live modes; camera input remains active while text fields have focus.",
  "id": "BRK-004",
  "observed_failure": "UI and simulation state can diverge: CAS can run while the game is live, CAS can remain logically active after closing, and non-live modes can be unpaused.",
  "required_repair": "Create one authoritative mode transition path that owns panel visibility, speed policy, music, and input suppression; route all CAS open/close actions through it.",
  "required_validation": "Runtime UI test covering Live->CAS->Live, Live->Build/Buy->Live, map transitions, speed rejection in non-live modes, and typing without camera movement.",
  "severity": "high",
  "state": "known-broken",
  "status": "open",
  "title": "CAS, non-live modes, and speed controls have conflicting state ownership",
  "workaround": "Use only the top mode buttons and avoid speed/input changes; still not a safe release path."
}
-->
### BRK-004 — CAS, non-live modes, and speed controls have conflicting state ownership

- **State:** known-broken
- **Affected User Path:** Entering/exiting Create-a-Sim, Build/Buy, map mode, pausing, and typing in UI
- **Artifact Revision:** v0.3.0 downloaded release
- **Evidence:** HUD Edit Selected Sim opens CAS directly without mode change; CAS Close only hides the panel; mode changes do not centrally own panel visibility; speed buttons call SimulationClock directly and can unpause non-live modes; camera input remains active while text fields have focus.
- **Observed Failure:** UI and simulation state can diverge: CAS can run while the game is live, CAS can remain logically active after closing, and non-live modes can be unpaused.
- **Required Repair:** Create one authoritative mode transition path that owns panel visibility, speed policy, music, and input suppression; route all CAS open/close actions through it.
- **Required Validation:** Runtime UI test covering Live->CAS->Live, Live->Build/Buy->Live, map transitions, speed rejection in non-live modes, and typing without camera movement.
- **Severity:** high
- **Status:** open
- **Workaround:** Use only the top mode buttons and avoid speed/input changes; still not a safe release path.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Save/load round trips, household lot ownership, and clean handoff packaging",
  "artifact_revision": "v0.3.0 downloaded release",
  "evidence": "Saved grid_size is not restored; object position arrays are indexed without length validation; household home_lot_id uses lot_founders while WorldBuilder generates founderslot/neighborlota-style IDs; every household is assigned lot_founders; ZIP contains tests/__pycache__/test_data.cpython-313.pyc and qa/all_systems_dump.txt outside FILE_MANIFEST.json.",
  "id": "BRK-005",
  "observed_failure": "Restored configuration can drift, malformed save data can cause errors, lot ownership is internally inconsistent, and release contents do not exactly match the declared payload inventory.",
  "required_repair": "Canonicalize lot IDs and household home lots, restore all saved settings, validate save shapes, make final save replacement robust, and package only intended manifest payload plus release metadata with generated cache/audit scratch excluded.",
  "required_validation": "Two consecutive save/load round trips, malformed-save fallback test, household/lot invariant checks, and final ZIP exact-content comparison against the release manifest.",
  "severity": "high",
  "state": "known-broken",
  "status": "open",
  "title": "Save/load, lot identity, and release packaging contain integrity defects",
  "workaround": "Do not rely on current release manifest as an exact list of ZIP contents."
}
-->
### BRK-005 — Save/load, lot identity, and release packaging contain integrity defects

- **State:** known-broken
- **Affected User Path:** Save/load round trips, household lot ownership, and clean handoff packaging
- **Artifact Revision:** v0.3.0 downloaded release
- **Evidence:** Saved grid_size is not restored; object position arrays are indexed without length validation; household home_lot_id uses lot_founders while WorldBuilder generates founderslot/neighborlota-style IDs; every household is assigned lot_founders; ZIP contains tests/__pycache__/test_data.cpython-313.pyc and qa/all_systems_dump.txt outside FILE_MANIFEST.json.
- **Observed Failure:** Restored configuration can drift, malformed save data can cause errors, lot ownership is internally inconsistent, and release contents do not exactly match the declared payload inventory.
- **Required Repair:** Canonicalize lot IDs and household home lots, restore all saved settings, validate save shapes, make final save replacement robust, and package only intended manifest payload plus release metadata with generated cache/audit scratch excluded.
- **Required Validation:** Two consecutive save/load round trips, malformed-save fallback test, household/lot invariant checks, and final ZIP exact-content comparison against the release manifest.
- **Severity:** high
- **Status:** open
- **Workaround:** Do not rely on current release manifest as an exact list of ZIP contents.
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "affected_user_path": "Opportunities, career wishes, death/ghosts, pets, services, school, household switching, and selected expansion counters",
  "artifact_revision": "v0.3.0 downloaded release",
  "evidence": "Opportunity reward is returned but not credited; WishSystem.record_career_progress has no caller; DeathSystem.record_death/set_ghost_active have no caller; pets are persistent dictionaries without 3D agents/UI; service arrival has notification only; school days_attended/homework paths are incomplete; roster allows inactive-household Sim selection while economy remains tied to active household; play_arcade increments EP06 performances.",
  "id": "BRK-006",
  "observed_failure": "The feature ledger can describe source wiring where actual gameplay consequences are absent, incomplete, or logically incorrect.",
  "required_repair": "Either complete each user path and validate it or downgrade its feature-ledger evidence state; never leave a source-presence claim as a gameplay-completion claim.",
  "required_validation": "Feature-specific runtime tests plus ledger reconciliation for every row promoted above architecture/data contract.",
  "severity": "high",
  "state": "known-broken",
  "status": "open",
  "title": "Several source-wired parity rows lack a complete user-facing execution path",
  "workaround": "Treat these features as incomplete until Codex verifies repaired user journeys."
}
-->
### BRK-006 — Several source-wired parity rows lack a complete user-facing execution path

- **State:** known-broken
- **Affected User Path:** Opportunities, career wishes, death/ghosts, pets, services, school, household switching, and selected expansion counters
- **Artifact Revision:** v0.3.0 downloaded release
- **Evidence:** Opportunity reward is returned but not credited; WishSystem.record_career_progress has no caller; DeathSystem.record_death/set_ghost_active have no caller; pets are persistent dictionaries without 3D agents/UI; service arrival has notification only; school days_attended/homework paths are incomplete; roster allows inactive-household Sim selection while economy remains tied to active household; play_arcade increments EP06 performances.
- **Observed Failure:** The feature ledger can describe source wiring where actual gameplay consequences are absent, incomplete, or logically incorrect.
- **Required Repair:** Either complete each user path and validate it or downgrade its feature-ledger evidence state; never leave a source-presence claim as a gameplay-completion claim.
- **Required Validation:** Feature-specific runtime tests plus ledger reconciliation for every row promoted above architecture/data contract.
- **Severity:** high
- **Status:** open
- **Workaround:** Treat these features as incomplete until Codex verifies repaired user journeys.
<!-- /operational-state:entry -->

## 7. Implemented but Unverified

Add stable `UNV-###` entries for code, files, configuration, or artifact features that exist but are not proven through the required user journey.

<!-- operational-state:entry
{
  "capability": "Routing, build-grid occupancy, trait tuning, genealogy/genetics/pregnancy, school, bills, services, opportunities, collecting, gardening, fishing, cooking, parties, death, pets, performers, expansion runtime state, and pack-linked interactions are present in source and serialized state.",
  "evidence": "Source modules, parity-system hub wiring, feature ledger source_file entries, and static validation",
  "id": "UNV-001",
  "missing_evidence": "No Godot 4.7.1 runtime execution was available in this environment.",
  "scope": "v0.3 gameplay systems and interaction hooks",
  "state": "implemented-unverified",
  "status": "implemented-unverified",
  "title": "Expanded v0.3 gameplay systems are source-wired but not engine-verified",
  "validation_method": "Open project in Godot 4.7.1 and execute the bundled runtime checklist and headless smoke suite."
}
-->
### UNV-001 — Expanded v0.3 gameplay systems are source-wired but not engine-verified

- **State:** `implemented-unverified`
- **Capability:** Routing, build-grid occupancy, trait tuning, genealogy/genetics/pregnancy, school, bills, services, opportunities, collecting, gardening, fishing, cooking, parties, death, pets, performers, expansion runtime state, and pack-linked interactions are present in source and serialized state.
- **Evidence:** Source modules, parity-system hub wiring, feature ledger source_file entries, and static validation
- **Missing Evidence:** No Godot 4.7.1 runtime execution was available in this environment.
- **Scope:** v0.3 gameplay systems and interaction hooks
- **Status:** implemented-unverified
- **Validation Method:** Open project in Godot 4.7.1 and execute the bundled runtime checklist and headless smoke suite.
<!-- /operational-state:entry -->

## 8. Unknown or Evidence-Stale State

Add stable `UNK-###` entries for missing, conflicting, inaccessible, stale, or invalidated evidence.

<!-- operational-state:entry
{
  "decisive_check": "Run the project and qa/godot_smoke.gd under Godot 4.7.1, then execute the runtime checklist.",
  "evidence_gap": "Godot engine binary is unavailable to the current container runtime.",
  "id": "UNK-001",
  "state": "unknown",
  "status": "open",
  "title": "Godot runtime behavior remains unverified",
  "unknown_state": "The project has not been imported, parsed, launched, or exercised by an actual Godot executable in the current environment."
}
-->
### UNK-001 — Godot runtime behavior remains unverified

- **State:** `unknown`
- **Decisive Check:** Run the project and qa/godot_smoke.gd under Godot 4.7.1, then execute the runtime checklist.
- **Evidence Gap:** Godot engine binary is unavailable to the current container runtime.
- **Status:** open
- **Unknown State:** The project has not been imported, parsed, launched, or exercised by an actual Godot executable in the current environment.
<!-- /operational-state:entry -->

## 9. Pending Work

Add stable `PND-###` entries for intentionally incomplete work. Pending does not automatically mean failed.

<!-- operational-state:entry
{
  "blocks_completion": true,
  "dependency": "Godot runtime validation and subsystem-by-subsystem implementation",
  "id": "PND-001",
  "priority": "critical",
  "reason_pending": "The full The Sims 3 feature surface is substantially larger than the implemented shell.",
  "state": "pending",
  "task": "Convert the remaining architecture-contract and data-contract feature rows into real integrated systems and content while preserving current source, save, asset, and local-only invariants.",
  "title": "Implement residual full-parity contracts",
  "validation_needed": "Feature-specific runtime tests plus ledger reconciliation"
}
-->
### PND-001 — Implement residual full-parity contracts

- **State:** `pending`
- **Blocks Completion:** Yes
- **Dependency:** Godot runtime validation and subsystem-by-subsystem implementation
- **Priority:** critical
- **Reason Pending:** The full The Sims 3 feature surface is substantially larger than the implemented shell.
- **Task:** Convert the remaining architecture-contract and data-contract feature rows into real integrated systems and content while preserving current source, save, asset, and local-only invariants.
- **Validation Needed:** Feature-specific runtime tests plus ledger reconciliation
<!-- /operational-state:entry -->

## 10. Active Decisions, Defaults, and Prohibitions

Add stable `DEC-###` entries for source locks, routes, naming, packaging, style, rejected approaches, environment limits, and explicit supersessions.

<!-- operational-state:entry
{
  "authority": "Asset-governance policy and current environment limits",
  "decision": "Ship project-owned assets as the default offline set; preserve publisher-controlled CC0 candidates in the sourcing report, but do not call them integrated unless their exact downloaded files are acquired, hashed, inspected, and validated.",
  "evidence": "docs/resources/ASSET_SOURCE_REPORT.md and local asset manifests",
  "id": "DEC-001",
  "state": "requested",
  "status": "active",
  "title": "External asset candidates remain optional until exact bytes are inspected"
}
-->
### DEC-001 — External asset candidates remain optional until exact bytes are inspected

- **State:** `requested`
- **Authority:** Asset-governance policy and current environment limits
- **Decision:** Ship project-owned assets as the default offline set; preserve publisher-controlled CC0 candidates in the sourcing report, but do not call them integrated unless their exact downloaded files are acquired, hashed, inspected, and validated.
- **Evidence:** docs/resources/ASSET_SOURCE_REPORT.md and local asset manifests
- **Status:** active
<!-- /operational-state:entry -->

<!-- operational-state:entry
{
  "authority": "Current adversarial asset-sourcing review",
  "decision": "If exact external bytes are later acquired, evaluate Quaternius Universal Base Characters together with Universal Animation Library 2 before the older Mini Characters fallback because the pair shares a humanoid/retargeting ecosystem and directly addresses CAS plus locomotion/interaction animation.",
  "evidence": "docs/resources/ASSET_SOURCE_REPORT.md and docs/resources/evidence/EXTERNAL_SOURCE_EVIDENCE.md",
  "id": "DEC-002",
  "state": "requested",
  "status": "active",
  "title": "Preferred future character and animation source is one coherent rig ecosystem"
}
-->
### DEC-002 — Preferred future character and animation source is one coherent rig ecosystem

- **State:** `requested`
- **Authority:** Current adversarial asset-sourcing review
- **Decision:** If exact external bytes are later acquired, evaluate Quaternius Universal Base Characters together with Universal Animation Library 2 before the older Mini Characters fallback because the pair shares a humanoid/retargeting ecosystem and directly addresses CAS plus locomotion/interaction animation.
- **Evidence:** docs/resources/ASSET_SOURCE_REPORT.md and docs/resources/evidence/EXTERNAL_SOURCE_EVIDENCE.md
- **Status:** active
<!-- /operational-state:entry -->

## 11. Validation and Evidence Matrix

| ID | Claim or behavior | State | Evidence | Validation method | Artifact/revision | Last checked | Recheck trigger |
|---|---|---|---|---|---|---|---|

## 12. Current Change Scope and Impact Radius

- **Allowed to change:** Not yet declared.
- **Must remain unchanged:** Existing verified behavior outside the impact radius.
- **Potentially affected behavior:** Unknown until the next task is scoped.
- **Mandatory checks:** None yet selected.
- **Checks deliberately reused:** None yet selected.
- **Repair class:** Undeclared.

## 13. Compact Revision Log

### Revision 1 — 2026-08-07T02:23:02Z

- **Artifact/source identity:** `Not yet established`
- **State deltas:** Initialized operational state.
- **New evidence:** None.
- **Validation not performed:** All behavioral validation remains pending unless explicitly recorded above.

### Revision 2 — 2026-08-07T02:23:42Z

- **Artifact/source identity:** OpenLife Godot v0.3.0 candidate source tree
- **State deltas:** Added INV-001 to 4. Active Invariants; Added INV-002 to 4. Active Invariants; Added INV-003 to 4. Active Invariants; Added INV-004 to 4. Active Invariants; Added VER-001 to 5. Verified Working Behavior; Added VER-002 to 5. Verified Working Behavior; Added VER-003 to 5. Verified Working Behavior; Added BRK-001 to 6. Known Not Working; Added UNV-001 to 7. Implemented but Unverified; Added UNK-001 to 8. Unknown or Evidence-Stale State; Added PND-001 to 9. Pending Work; Added DEC-001 to 10. Active Decisions, Defaults, and Prohibitions
- **New evidence:** 229 static/source checks passed; 12 data/unit tests passed; 729 asset integrity checks passed; v0.3 source-wired parity rows increased from 23 to 78; v0.3 bundled asset coverage increased to 106 GLB, 24 WAV, 7 PNG textures, and 5 SVG UI assets
- **Newly verified behavior:** VER-001; VER-002; VER-003
- **Newly known failure:** BRK-001
- **Superseded rule:** None.
- **Validation not performed:** Godot 4.7.1 editor/headless runtime could not be executed in this environment; Full The Sims 3 behavioral parity has not been achieved or verified
- **Reason for broad revalidation:** Not applicable.
- **Summary:** Record the v0.3.0 parity, local-only, validation, asset, and runtime evidence state

### Revision 3 — 2026-08-07T02:29:26Z

- **Artifact/source identity:** OpenLife Godot v0.3.0 candidate source tree
- **State deltas:** Updated VER-001 in 5. Verified Working Behavior; Updated VER-003 in 5. Verified Working Behavior; Added DEC-002 to 10. Active Decisions, Defaults, and Prohibitions
- **New evidence:** 249 static/source checks passed; 14 data/unit tests passed; 729 asset integrity checks passed; External visual candidate lifecycle states and exact source pages are now statically checked; Quaternius Universal Base Characters plus Universal Animation Library 2 are the preferred coherent future character-animation source pair
- **Newly verified behavior:** VER-001; VER-003
- **Newly known failure:** None.
- **Superseded rule:** None.
- **Validation not performed:** Godot 4.7.1 editor/headless runtime could not be executed in this environment; Exact third-party candidate archive bytes could not be acquired for technical inspection
- **Reason for broad revalidation:** Not applicable.
- **Summary:** Refresh validation evidence and preserve the improved coherent external asset sourcing decision
### Revision 4 — 2026-08-07T02:47:23Z

- **Artifact/source identity:** OpenLife Godot v0.3.0 downloaded release
- **State deltas:** Added BRK-002 through BRK-006 from independent Codex-preflight bug sweep.
- **New evidence:** Confirmed parser/autoload member defects, routing/interaction-target defects, mode-state conflicts, save/lot/package integrity defects, and incomplete user-facing paths behind several source-wired feature rows.
- **Newly verified behavior:** None.
- **Newly known failure:** BRK-002; BRK-003; BRK-004; BRK-005; BRK-006
- **Superseded rule:** None.
- **Validation not performed:** Actual Godot import/runtime remains unavailable in this environment; fixes are not claimed until Codex runs the project in Godot.
- **Reason for broad revalidation:** Existing Python static checks passed while missing parser/runtime defects, so engine-backed validation is now mandatory for the handoff.
- **Summary:** Persist independent bug-sweep findings for the Codex assembly and repair pass.

