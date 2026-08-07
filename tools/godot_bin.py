#!/usr/bin/env python3
"""Locate a real Godot 4.x executable.

Resolution order: ``GODOT_BIN``, the standard macOS application bundles, then
``godot4``/``godot`` on ``PATH``. No download, no package manager, no network.
"""
from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

BUNDLE_CANDIDATES = [
    Path("/Applications/Godot.app/Contents/MacOS/Godot"),
    Path.home() / "Applications/Godot.app/Contents/MacOS/Godot",
]


def find_godot() -> str | None:
    env_bin = os.environ.get("GODOT_BIN", "").strip()
    if env_bin and Path(env_bin).exists():
        return env_bin
    for candidate in BUNDLE_CANDIDATES:
        if candidate.exists():
            return str(candidate)
    for name in ("godot4", "godot"):
        found = shutil.which(name)
        if found:
            return found
    return None


def godot_version(bin_path: str) -> str:
    proc = subprocess.run([bin_path, "--version"], text=True, capture_output=True, timeout=60)
    return (proc.stdout or proc.stderr).strip().splitlines()[-1] if (proc.stdout or proc.stderr) else "unknown"
