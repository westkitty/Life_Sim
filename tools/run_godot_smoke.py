#!/usr/bin/env python3
"""Run only the shallow Godot smoke test.

Kept as a focused entry point. The mandatory release gate is
``tools/run_godot_checks.py``, which also runs import/parse and the integration
suite; a missing engine is a failure there rather than a skip.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from godot_bin import find_godot  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
bin_path = find_godot()
if not bin_path:
    print('GODOT SMOKE: FAIL - Godot executable not found. Source remains runtime-unverified.')
    raise SystemExit(1)
print('GODOT SMOKE: using', bin_path)
proc = subprocess.run(
    [bin_path, '--headless', '--path', str(ROOT), '--script', 'res://tests/godot/smoke_test.gd'],
    text=True, capture_output=True, timeout=600,
)
print(proc.stdout, end='')
print(proc.stderr, end='', file=sys.stderr)
if proc.returncode == 0 and 'OPENLIFE_GODOT_SMOKE_PASS' not in proc.stdout:
    raise SystemExit(1)
raise SystemExit(proc.returncode)
