#!/usr/bin/env python3
"""Full OpenLife validation ladder.

Order matters: supplemental static/data/asset checks first, then the mandatory
Godot runtime gate. A green static run alone never justifies a working claim.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
commands = [
    [sys.executable, 'tests/static_validate.py'],
    # Discovery-based invocation: `-m unittest tests/test_data.py` requires the
    # tests directory to be an importable package on newer Pythons.
    [sys.executable, '-m', 'unittest', 'discover', '-s', 'tests', '-p', 'test_*.py', '-v'],
    [sys.executable, 'tools/validate_assets.py'],
    [sys.executable, 'tools/run_godot_checks.py'],
]
failed = []
for cmd in commands:
    print('\n==>', ' '.join(cmd))
    p = subprocess.run(cmd, cwd=ROOT)
    if p.returncode:
        failed.append((' '.join(cmd), p.returncode))
if failed:
    print('\nVALIDATION FAILED:', failed)
    raise SystemExit(1)
print('\nVALIDATION COMPLETE: static, data, asset and Godot runtime gates all passed.')
