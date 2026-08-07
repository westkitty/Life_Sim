#!/usr/bin/env python3
"""Static integrity checks for the OpenLife Godot source project.

This does not replace running the project in Godot. It proves that the release
bundle is internally coherent enough to hand to the editor without missing
project files, broken res:// references, malformed catalogs, duplicate IDs, or
obvious delimiter damage in GDScript sources.
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FAILURES: list[str] = []
WARNINGS: list[str] = []
PASSES: list[str] = []


def check(condition: bool, message: str) -> None:
    (PASSES if condition else FAILURES).append(message)


def load_json(relative: str):
    path = ROOT / relative
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        FAILURES.append(f"{relative}: invalid JSON: {exc}")
        return []


def duplicate_ids(items, label: str) -> set[str]:
    seen: set[str] = set()
    duplicates: set[str] = set()
    for item in items:
        item_id = str(item.get("id", ""))
        if not item_id:
            FAILURES.append(f"{label}: item without id")
        elif item_id in seen:
            duplicates.add(item_id)
        seen.add(item_id)
    return duplicates


def strip_strings_and_comments(source: str) -> str:
    out: list[str] = []
    i = 0
    quote: str | None = None
    escaped = False
    while i < len(source):
        ch = source[i]
        if quote:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == quote:
                quote = None
            out.append(" ")
            i += 1
            continue
        if ch in ('"', "'"):
            quote = ch
            out.append(" ")
            i += 1
            continue
        if ch == "#":
            while i < len(source) and source[i] != "\n":
                out.append(" ")
                i += 1
            continue
        out.append(ch)
        i += 1
    return "".join(out)


def delimiter_errors(path: Path) -> list[str]:
    source = strip_strings_and_comments(path.read_text(encoding="utf-8"))
    pairs = {')': '(', ']': '[', '}': '{'}
    stack: list[tuple[str, int]] = []
    errors: list[str] = []
    line = 1
    for ch in source:
        if ch == "\n":
            line += 1
        elif ch in "([{":
            stack.append((ch, line))
        elif ch in ")]}":
            if not stack or stack[-1][0] != pairs[ch]:
                errors.append(f"line {line}: unmatched {ch}")
            else:
                stack.pop()
    errors.extend(f"line {line_no}: unclosed {ch}" for ch, line_no in stack)
    return errors


def main() -> int:
    required = [
        "project.godot", "scenes/main.tscn", "src/main.gd", "icon.svg",
        "src/autoload/event_bus.gd", "src/autoload/simulation_clock.gd",
        "src/autoload/content_registry.gd", "src/autoload/asset_library.gd",
        "src/autoload/audio_service.gd", "src/autoload/save_service.gd",
        "src/core/sim/sim_agent.gd", "src/ui/hud.gd",
        "data/pack_registry.json", "data/object_catalog.json",
        "data/career_catalog.json", "data/trait_catalog.json",
        "data/feature_ledger.json", "data/asset_aliases.json",
        "assets/generated/manifest.json", "asset-policy.json", "README.md", "OPERATIONAL_STATE.md",
        "src/core/systems/pet_system.gd", "src/core/systems/performer_system.gd",
        "tools/import_optional_asset_pack.py", "tools/capture_improvement_metrics.py", "docs/resources/ASSET_SOURCE_REPORT.md",
        "docs/resources/evidence/EXTERNAL_SOURCE_EVIDENCE.md",
    ]
    for relative in required:
        check((ROOT / relative).is_file(), f"required file exists: {relative}")

    packs = load_json("data/pack_registry.json")
    objects = load_json("data/object_catalog.json")
    careers = load_json("data/career_catalog.json")
    traits = load_json("data/trait_catalog.json")
    features = load_json("data/feature_ledger.json")

    check(isinstance(packs, list), "pack registry is an array")
    check(isinstance(objects, list), "object catalog is an array")
    check(isinstance(careers, list), "career catalog is an array")
    check(isinstance(traits, list), "trait catalog is an array")
    check(isinstance(features, list), "feature ledger is an array")

    for items, label in [(packs, "packs"), (objects, "objects"), (careers, "careers"), (traits, "traits"), (features, "features")]:
        check(not duplicate_ids(items, label), f"{label} have unique IDs")

    pack_ids = {item["id"] for item in packs if "id" in item}
    expansion_ids = {item["id"] for item in packs if item.get("type") == "expansion"}
    stuff_ids = {item["id"] for item in packs if item.get("type") == "stuff"}
    check(expansion_ids == {f"EP{i:02d}" for i in range(1, 12)}, "all eleven expansion contracts EP01-EP11 exist")
    check(stuff_ids == {f"SP{i:02d}" for i in range(1, 10)}, "all nine stuff-pack contracts SP01-SP09 exist")
    check("BG" in pack_ids and "STORE" in pack_ids and "WORLD" in pack_ids, "base, Store, and world-content contracts exist")

    for feature in features:
        if feature.get("pack_id") not in pack_ids:
            FAILURES.append(f"feature {feature.get('id')} references unknown pack {feature.get('pack_id')}")
        if feature.get("status") not in {"engine_verified", "implemented_unverified", "architecture_contract", "data_contract"}:
            FAILURES.append(f"feature {feature.get('id')} has invalid evidence status {feature.get('status')}")
        if feature.get("status") == "engine_verified" and "integration_test.gd" not in feature.get("proof", "") and "smoke_test.gd" not in feature.get("proof", ""):
            FAILURES.append(f"feature {feature.get('id')} claims engine_verified without naming the Godot test that proves it")
    check(any(f.get("status") == "implemented_unverified" for f in features), "feature ledger includes source-wired implementation rows")
    check(any(f.get("status") == "engine_verified" for f in features), "feature ledger includes rows proven by real Godot runtime tests")
    check(not any(f.get("status") == "verified" for f in features), "no feature row claims bare 'verified' without engine evidence")
    check(any(f.get("status") == "architecture_contract" for f in features), "unimplemented parity remains visible as architecture contracts")
    for runtime_pack in ["BG"] + [f"EP{i:02d}" for i in range(1, 12)] + [f"SP{i:02d}" for i in range(1, 10)]:
        scoped = [f for f in features if f.get("pack_id") == runtime_pack]
        check(any(f.get("status") in {"implemented_unverified", "engine_verified"} for f in scoped), f"runtime-wired slice exists for {runtime_pack}")

    motive_ids = {"hunger", "bladder", "energy", "social", "fun", "hygiene"}
    for obj in objects:
        if obj.get("pack_id", "BG") not in pack_ids:
            FAILURES.append(f"object {obj.get('id')} references unknown pack")
        interactions = obj.get("interactions", [])
        if not interactions:
            FAILURES.append(f"object {obj.get('id')} has no interactions")
        seen_interactions: set[str] = set()
        for action in interactions:
            aid = action.get("id", "")
            if not aid or aid in seen_interactions:
                FAILURES.append(f"object {obj.get('id')} has missing or duplicate interaction id {aid!r}")
            seen_interactions.add(aid)
            if float(action.get("duration_minutes", 0)) <= 0:
                FAILURES.append(f"interaction {aid} has non-positive duration")
            invalid_motives = set(action.get("motive_effects", {})) - motive_ids
            if invalid_motives:
                FAILURES.append(f"interaction {aid} has invalid motives {sorted(invalid_motives)}")
    check(len(objects) >= 70, "catalog has at least seventy actionable objects")
    check(len(careers) >= 20, "career registry covers base and expansion career families")
    check(len(traits) >= 60, "trait registry covers broad base and expansion trait space")

    aliases = load_json("data/asset_aliases.json")
    asset_manifest = load_json("assets/generated/manifest.json")
    if isinstance(aliases, dict):
        for obj in objects:
            aid = str(obj.get("asset_id", obj.get("id", "")))
            check(aid in aliases, f"object asset alias exists: {obj.get('id')}")
            if aid in aliases:
                check((ROOT / str(aliases[aid]).removeprefix("res://")).is_file(), f"object asset file exists: {obj.get('id')}")
    if isinstance(asset_manifest, dict):
        check(len(asset_manifest.get("models", [])) >= 100, "bundled generated model pack contains at least one hundred GLBs")
        check(len(asset_manifest.get("audio", [])) >= 24, "bundled generated audio pack contains at least twenty-four audio files")
        check(len(asset_manifest.get("textures", [])) >= 7, "bundled generated texture pack contains at least seven PNGs")
    check(not any(f.get("status") == "implemented_shell" for f in features), "legacy overclaiming evidence state implemented_shell is absent")

    visual_manifest = load_json('docs/resources/VISUAL_ASSET_MANIFEST.json')
    allowed_resource_states = {'discovered','screened','rights-verified','provenance-verified','technically-verified','approval-required','approved','acquired','inspected','processed','integrated','validated','rejected','needs-human-review','unavailable','superseded','removed'}
    if isinstance(visual_manifest, dict):
        candidates = visual_manifest.get('optional_candidates', [])
        check(bool(candidates), 'visual manifest preserves optional external candidates')
        for candidate in candidates:
            check(candidate.get('state') in allowed_resource_states, f"visual candidate lifecycle valid: {candidate.get('resource_id')}")
            check(str(candidate.get('source_page', '')).startswith('https://'), f"visual candidate exact source recorded: {candidate.get('resource_id')}")
        candidate_ids = {candidate.get('resource_id') for candidate in candidates}
        check('quaternius-universal-base-characters' in candidate_ids and 'quaternius-universal-animation-library-2' in candidate_ids, 'coherent Quaternius character plus animation source pair is recorded')

    # Operational-state identity and required section order.
    state_text = (ROOT / "OPERATIONAL_STATE.md").read_text(encoding="utf-8")
    metadata_match = re.search(r"<!-- operational-state:metadata\s*(\{.*?\})\s*-->", state_text, flags=re.DOTALL)
    check(metadata_match is not None, "operational state has parseable metadata block")
    if metadata_match:
        try:
            metadata = json.loads(metadata_match.group(1))
            check(metadata.get("project_id") == "openlife-godot", "operational state project identity matches")
            check(int(metadata.get("state_revision", 0)) >= 1, "operational state has a positive revision")
        except Exception as exc:
            FAILURES.append(f"operational state metadata invalid: {exc}")
    required_headings = [
        "## 1. Project Identity and Scope", "## 2. Current Baseline", "## 3. Artifact Contract",
        "## 4. Active Invariants", "## 5. Verified Working Behavior", "## 6. Known Not Working",
        "## 7. Implemented but Unverified", "## 8. Unknown or Evidence-Stale State",
        "## 9. Pending Work", "## 10. Active Decisions, Defaults, and Prohibitions",
        "## 11. Validation and Evidence Matrix", "## 12. Current Change Scope and Impact Radius",
        "## 13. Compact Revision Log",
    ]
    positions = [state_text.find(heading) for heading in required_headings]
    check(all(position >= 0 for position in positions), "operational state contains every required section")
    check(positions == sorted(positions), "operational state sections are in canonical order")

    # Project autoload configuration must point at the four control services.
    project_text = (ROOT / "project.godot").read_text(encoding="utf-8")
    for autoload_name in ["EventBus", "SimulationClock", "ContentRegistry", "AssetLibrary", "AudioService", "SaveService"]:
        check(f'{autoload_name}="*res://' in project_text, f"autoload configured: {autoload_name}")

    # Every explicit res:// reference in textual project sources must resolve.
    textual = list(ROOT.rglob("*.gd")) + [ROOT / "project.godot", ROOT / "scenes/main.tscn"]
    ref_pattern = re.compile(r"res://[A-Za-z0-9_./-]+")
    for path in textual:
        text = path.read_text(encoding="utf-8")
        for ref in ref_pattern.findall(text):
            relative = ref.removeprefix("res://")
            if not (ROOT / relative).exists():
                FAILURES.append(f"{path.relative_to(ROOT)} references missing {ref}")

    # Unique class_name declarations and simple delimiter integrity.
    class_names: dict[str, Path] = {}
    for path in ROOT.rglob("*.gd"):
        text = path.read_text(encoding="utf-8")
        for class_name in re.findall(r"^class_name\s+([A-Za-z_][A-Za-z0-9_]*)", text, flags=re.MULTILINE):
            if class_name in class_names:
                FAILURES.append(f"duplicate class_name {class_name}: {path} and {class_names[class_name]}")
            class_names[class_name] = path
        for error in delimiter_errors(path):
            FAILURES.append(f"{path.relative_to(ROOT)}: {error}")
        if "\t " in text or " \t" in text:
            WARNINGS.append(f"{path.relative_to(ROOT)} contains mixed tab/space indentation sequences")
    check(len(class_names) >= 14, "modular runtime exposes at least fourteen named Godot classes")

    # Runtime remains local-only and dependency-free.
    runtime_text = "\n".join(path.read_text(encoding="utf-8") for path in ROOT.rglob("*.gd"))
    check("http://" not in runtime_text and "https://" not in runtime_text, "runtime scripts contain no network dependency")
    check("api_key" not in runtime_text.lower(), "runtime scripts contain no API-key dependency")

    print(f"PASS: {len(PASSES)}")
    for message in PASSES:
        print(f"  + {message}")
    print(f"WARNING: {len(WARNINGS)}")
    for message in WARNINGS:
        print(f"  ! {message}")
    print(f"FAIL: {len(FAILURES)}")
    for message in FAILURES:
        print(f"  - {message}")
    return 1 if FAILURES else 0


if __name__ == "__main__":
    sys.exit(main())
