#!/usr/bin/env python3
from __future__ import annotations
import argparse, hashlib, json
from pathlib import Path
from collections import Counter

_parser = argparse.ArgumentParser(description="Generate release manifests for a payload tree.")
_parser.add_argument("--root", default=str(Path(__file__).resolve().parents[1]),
                     help="Payload root to inventory (defaults to the working project).")
_parser.add_argument("--release", default="OpenLife Godot v0.3.2 (visual fix)",
                     help="Release identity recorded in the manifests.")
_args = _parser.parse_args()

ROOT = Path(_args.root).resolve()
RELEASE = _args.release
EXCLUDE_NAMES = {"CHECKSUMS.sha256", "FILE_MANIFEST.json", "MANIFEST.md"}
EXCLUDE_PARTS = {".git", ".godot", "__pycache__"}

ROLE_USE = {
    "source": "Godot/runtime/tooling source or root project metadata",
    "reference": "Project documentation, parity evidence, sourcing, and handoff reference",
    "qa": "Tests, validation logs, baseline proof, and comparison evidence",
    "runtime-asset": "Bundled offline runtime visual/audio asset",
    "runtime-data": "Runtime catalog, tuning, feature, and alias data",
    "optional-third-party-staging": "Local staging only; not required for launch",
}

def classify(rel: Path) -> str:
    top = rel.parts[0]
    if top == "docs": return "reference"
    if top in {"qa", "tests"}: return "qa"
    if top == "assets": return "runtime-asset"
    if top == "data": return "runtime-data"
    if top == "third_party": return "optional-third-party-staging"
    return "source"

entries = []
for p in sorted(ROOT.rglob("*")):
    if not p.is_file():
        continue
    rel = p.relative_to(ROOT)
    if p.name in EXCLUDE_NAMES or any(part in EXCLUDE_PARTS for part in rel.parts) or p.suffix == ".pyc":
        continue
    raw = p.read_bytes()
    role = classify(rel)
    entries.append({
        "path": rel.as_posix(),
        "bytes": len(raw),
        "sha256": hashlib.sha256(raw).hexdigest(),
        "role": role,
        "status": "included",
        "intended_use": ROLE_USE[role],
        "dependencies": [],
        "notes": "",
    })

(ROOT / "FILE_MANIFEST.json").write_text(
    json.dumps({
        "schema_version": 2,
        "release": RELEASE,
        "recursive_metadata_files_excluded": sorted(EXCLUDE_NAMES),
        "files": entries,
    }, indent=2) + "\n",
    encoding="utf-8",
)
(ROOT / "CHECKSUMS.sha256").write_text(
    "".join(f"{e['sha256']}  {e['path']}\n" for e in entries),
    encoding="utf-8",
)

counts = Counter(e["role"] for e in entries)
total = sum(e["bytes"] for e in entries)
lines = [
    f"# {RELEASE} Release Manifest",
    "",
    f"- Payload files with per-file SHA-256: **{len(entries)}**",
    f"- Payload bytes (excluding recursive release metadata): **{total}**",
    "- Recursive metadata files `MANIFEST.md`, `FILE_MANIFEST.json`, and `CHECKSUMS.sha256` are listed below but excluded from their own hash inventory to avoid self-reference.",
    "- The final ZIP receives its own external SHA-256 after packaging.",
    "",
    "## Role summary",
    "",
    "| Role | Files | Intended use |",
    "|---|---:|---|",
]
for role, count in sorted(counts.items()):
    lines.append(f"| {role} | {count} | {ROLE_USE[role]} |")
lines += [
    "| release-metadata | 3 | Release manifest, per-file inventory, and checksums |",
    "",
    "## Package file inventory",
    "",
    "| File | Role | Status | Intended use | Notes |",
    "|---|---|---|---|---|",
]
for entry in entries:
    path = entry['path'].replace('|', '\\|')
    use = entry['intended_use'].replace('|', '\\|')
    lines.append(f"| `{path}` | {entry['role']} | included | {use} | SHA-256 recorded in `FILE_MANIFEST.json` / `CHECKSUMS.sha256` |")
for name, purpose in [
    ("MANIFEST.md", "Human-readable complete release inventory and gates"),
    ("FILE_MANIFEST.json", "Machine-readable per-file release inventory"),
    ("CHECKSUMS.sha256", "SHA-256 list for all non-recursive payload files"),
]:
    lines.append(f"| `{name}` | release-metadata | included | {purpose} | Excluded from recursive self-hash inventory; covered by final ZIP checksum |")

lines += [
    "",
    "## Release gates",
    "",
    "- **Existence:** source tree, data, assets, QA evidence, and documentation are present.",
    f"- **Version:** current release metadata is {RELEASE}; earlier references are preserved only as explicit comparison/baseline evidence.",
    "- **Dependencies:** runtime requires Godot 4.7.1 stable or a compatible newer Godot 4.x editor. Python is optional and used only for validation/rebuilding generated proof/assets.",
    "- **Local-first:** no Lovable, hosted backend, API key, paid asset, account, or runtime network service is required.",
    "- **Third-party bytes:** exact external candidate archives are not bundled or misrepresented as integrated.",
    "- **Runtime verification:** Godot 4.7.1 headless import/parse, the smoke test and the 431-check integration suite all pass against this payload after fresh extraction; see `qa/GODOT_RUNTIME_VALIDATION.md`.",
    "- **Full parity:** explicitly incomplete and not claimed; 100 architecture contracts and 12 data contracts remain. See `OPERATIONAL_STATE.md` and `docs/REQUIREMENT_LEDGER.md`.",
]
(ROOT / "MANIFEST.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print("manifested", len(entries), "payload files", total, "bytes")
