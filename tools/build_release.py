#!/usr/bin/env python3
"""Build the OpenLife release archive from an explicit allowlist.

The working directory is never zipped recursively. A clean staging tree is
assembled from the allowlist below, manifests are regenerated *from the staged
payload*, and the finished archive's membership is compared exactly against that
manifest. Anything present in the archive but absent from the manifest — or the
reverse — is a hard failure.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Explicit intended payload. Nothing outside this list is ever packaged.
ALLOWED_DIRS = ["assets", "data", "docs", "qa", "scenes", "src", "tests", "third_party", "tools"]
ALLOWED_ROOT_FILES = [
    "project.godot",
    "icon.svg",
    "LICENSE",
    "README.md",
    "RELEASE_NOTES.md",
    "OPERATIONAL_STATE.md",
    "asset-policy.json",
    "CODEX_TASK.md",
    "CODEX_HANDOFF_MANIFEST.sha256",
]
# Release metadata is regenerated into the staging tree, never copied from the
# working directory.
GENERATED_ROOT_FILES = ["MANIFEST.md", "FILE_MANIFEST.json", "CHECKSUMS.sha256"]

EXCLUDE_DIR_NAMES = {".godot", ".git", "__pycache__", ".idea", ".vscode", "node_modules"}
EXCLUDE_FILE_NAMES = {".DS_Store", "Thumbs.db"}
EXCLUDE_SUFFIXES = {".pyc", ".pyo", ".tmp", ".bak", ".orig", ".rej", ".swp"}
# User save data must never ship.
EXCLUDE_NAME_PARTS = ("openlife_slot_", "openlife_integration_slot")


def is_excluded(rel: Path) -> bool:
    if any(part in EXCLUDE_DIR_NAMES for part in rel.parts):
        return True
    if rel.name in EXCLUDE_FILE_NAMES:
        return True
    if rel.suffix in EXCLUDE_SUFFIXES:
        return True
    if any(part in rel.name for part in EXCLUDE_NAME_PARTS):
        return True
    return False


def collect() -> list[Path]:
    selected: list[Path] = []
    for name in ALLOWED_ROOT_FILES:
        candidate = ROOT / name
        if candidate.is_file():
            selected.append(Path(name))
        else:
            print(f"  ! allowlisted root file missing, skipped: {name}")
    for directory in ALLOWED_DIRS:
        base = ROOT / directory
        if not base.is_dir():
            print(f"  ! allowlisted directory missing, skipped: {directory}")
            continue
        for path in sorted(base.rglob("*")):
            if not path.is_file():
                continue
            rel = path.relative_to(ROOT)
            if is_excluded(rel):
                continue
            selected.append(rel)
    return sorted(set(selected))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--staging", default=str(ROOT.parent / "openlife_release_staging"))
    parser.add_argument("--zip", dest="zip_path", default=str(ROOT.parent / "OpenLife_Godot_Visual_Fixed.zip"))
    parser.add_argument("--release", default="OpenLife Godot v0.3.2 (visual fix)")
    args = parser.parse_args()

    staging = Path(args.staging).resolve()
    zip_path = Path(args.zip_path).resolve()

    print(f"Staging tree: {staging}")
    if staging.exists():
        shutil.rmtree(staging)
    payload_root = staging / "OpenLife"
    payload_root.mkdir(parents=True)

    files = collect()
    for rel in files:
        destination = payload_root / rel
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ROOT / rel, destination)
    print(f"Staged {len(files)} allowlisted payload files")

    # Regenerate manifests from the staged payload, not the working directory.
    result = subprocess.run(
        [sys.executable, str(payload_root / "tools/build_release_manifest.py"),
         "--root", str(payload_root), "--release", args.release],
        text=True, capture_output=True,
    )
    print(result.stdout.strip() or result.stderr.strip())
    if result.returncode != 0:
        print("Manifest generation failed")
        return 1

    manifest = json.loads((payload_root / "FILE_MANIFEST.json").read_text())
    expected = {entry["path"] for entry in manifest["files"]} | set(GENERATED_ROOT_FILES)

    if zip_path.exists():
        zip_path.unlink()
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(payload_root.rglob("*")):
            if path.is_file():
                archive.write(path, path.relative_to(payload_root).as_posix())

    with zipfile.ZipFile(zip_path) as archive:
        bad = archive.testzip()
        if bad is not None:
            print(f"Archive integrity failure at {bad}")
            return 1
        members = {name for name in archive.namelist() if not name.endswith("/")}

    unexpected = sorted(members - expected)
    missing = sorted(expected - members)
    if unexpected or missing:
        print("Archive membership does not match the manifest inventory.")
        for name in unexpected:
            print(f"  + unexpected in archive: {name}")
        for name in missing:
            print(f"  - missing from archive: {name}")
        return 1

    digest = hashlib.sha256(zip_path.read_bytes()).hexdigest()
    checksum_path = zip_path.with_suffix(".sha256")
    checksum_path.write_text(f"{digest}  {zip_path.name}\n")

    print(f"Archive: {zip_path} ({zip_path.stat().st_size} bytes, {len(members)} members)")
    print(f"SHA-256: {digest}")
    print(f"Checksum file: {checksum_path}")
    print("Archive membership matches the regenerated manifest exactly.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
