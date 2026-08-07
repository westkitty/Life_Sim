#!/usr/bin/env python3
"""Mandatory Godot gate: headless import/parse, smoke test, integration suite.

Static and data checks are supplemental. This script is the authority on whether
OpenLife actually parses, imports and runs, so a missing Godot executable is a
failure rather than a skip. Set ``OPENLIFE_ALLOW_NO_GODOT=1`` only when running
the supplemental checks in an environment that deliberately has no engine, and
understand that no runtime claim may be made from such a run.
"""
from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from godot_bin import find_godot, godot_version  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
# Parse/compile diagnostics that must never appear in a clean run.
FATAL_MARKERS = ("SCRIPT ERROR:", "Parse Error:", "Compile Error:")


def run(bin_path: str, args: list[str], label: str, timeout: int, headless: bool = True) -> tuple[bool, str]:
    # Visibility checks must use a real renderer: the headless dummy rasterizer
    # cannot prove that anything would actually appear on screen.
    prefix = [bin_path, "--headless"] if headless else [bin_path]
    proc = subprocess.run(
        [*prefix, "--path", str(ROOT), *args],
        text=True,
        capture_output=True,
        timeout=timeout,
    )
    output = (proc.stdout or "") + (proc.stderr or "")
    fatal = [line for line in output.splitlines() if any(m in line for m in FATAL_MARKERS)]
    ok = proc.returncode == 0 and not fatal
    print(f"\n==> GODOT {label}: {'PASS' if ok else 'FAIL'} (exit {proc.returncode})")
    if not ok:
        sys.stdout.write(output[-8000:])
    return ok, output


def main() -> int:
    bin_path = find_godot()
    if not bin_path:
        if os.environ.get("OPENLIFE_ALLOW_NO_GODOT") == "1":
            print("GODOT GATE: SKIPPED BY EXPLICIT OVERRIDE - runtime behaviour is UNVERIFIED.")
            return 0
        print("GODOT GATE: FAIL - no Godot executable found. Runtime behaviour cannot be claimed.")
        return 1
    print(f"GODOT GATE: using {bin_path} ({godot_version(bin_path)})")

    results = []
    results.append(run(bin_path, ["--import"], "import/parse", 900)[0])
    smoke_ok, smoke_out = run(bin_path, ["--script", "res://tests/godot/smoke_test.gd"], "smoke", 600)
    results.append(smoke_ok and "OPENLIFE_GODOT_SMOKE_PASS" in smoke_out)
    integration_ok, integration_out = run(bin_path, ["res://tests/godot/integration_test.tscn"], "integration", 900)
    results.append(integration_ok and "OPENLIFE_INTEGRATION_PASS" in integration_out)
    for line in integration_out.splitlines():
        if "OPENLIFE_INTEGRATION_PASS" in line:
            print(line)

    # Rendered-visibility gate. A green run above only proves the project parses,
    # imports and simulates; it says nothing about whether the world is visible.
    visual_ok, visual_out = run(
        bin_path, ["res://tests/godot/visual_scene_test.tscn"], "visual scene", 900, headless=False
    )
    results.append(visual_ok and "OPENLIFE_VISUAL_PASS" in visual_out)
    for line in visual_out.splitlines():
        if "OPENLIFE_VISUAL_PASS" in line or "VISUAL_ASSET_STATS" in line:
            print(line)

    if all(results):
        print("\nGODOT GATE: ALL RUNTIME CHECKS PASSED")
        return 0
    print("\nGODOT GATE: FAILED")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
