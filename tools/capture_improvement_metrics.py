#!/usr/bin/env python3
from __future__ import annotations
import json, re, struct
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'qa' / 'improvement'
OUT.mkdir(parents=True, exist_ok=True)


def load_json(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def glb_metrics(path: Path) -> dict:
    raw = path.read_bytes()
    if len(raw) < 20 or raw[:4] != b'glTF':
        raise ValueError(f'not a GLB: {path}')
    version, total_length = struct.unpack_from('<II', raw, 4)
    if version != 2 or total_length != len(raw):
        raise ValueError(f'invalid GLB header: {path}')
    chunk_len, chunk_type = struct.unpack_from('<II', raw, 12)
    if chunk_type != 0x4E4F534A:
        raise ValueError(f'first GLB chunk is not JSON: {path}')
    doc = json.loads(raw[20:20 + chunk_len].decode('utf-8').rstrip(' \t\r\n\x00'))
    accessors = doc.get('accessors', [])
    vertices = 0
    faces = 0
    geometries = 0
    for mesh in doc.get('meshes', []):
        for primitive in mesh.get('primitives', []):
            geometries += 1
            pos = primitive.get('attributes', {}).get('POSITION')
            if isinstance(pos, int) and 0 <= pos < len(accessors):
                vertices += int(accessors[pos].get('count', 0))
            idx = primitive.get('indices')
            mode = int(primitive.get('mode', 4))
            if isinstance(idx, int) and 0 <= idx < len(accessors) and mode == 4:
                faces += int(accessors[idx].get('count', 0)) // 3
    return {
        'path': path.relative_to(ROOT).as_posix(),
        'bytes': len(raw),
        'vertices': vertices,
        'faces': faces,
        'geometries': geometries,
        'materials': len(doc.get('materials', [])),
    }


def validation_counts() -> tuple[int, int, int, str]:
    path = ROOT / 'qa' / 'validation-v0.3.0.txt'
    text = path.read_text(encoding='utf-8', errors='replace') if path.exists() else ''
    static_match = re.search(r'^PASS:\s*(\d+)', text, flags=re.MULTILINE)
    unit_match = re.search(r'^Ran\s+(\d+)\s+tests?', text, flags=re.MULTILINE)
    asset_match = re.search(r'^ASSET PASS:\s*(\d+)', text, flags=re.MULTILINE)
    runtime = 'unknown'
    smoke = re.search(r'^GODOT SMOKE:\s*(.+)$', text, flags=re.MULTILINE)
    if smoke:
        runtime = smoke.group(1).strip()
    return (
        int(static_match.group(1)) if static_match else 0,
        int(unit_match.group(1)) if unit_match else 0,
        int(asset_match.group(1)) if asset_match else 0,
        runtime,
    )

features = load_json(ROOT / 'data' / 'feature_ledger.json')
objects = load_json(ROOT / 'data' / 'object_catalog.json')
assets = load_json(ROOT / 'assets' / 'generated' / 'manifest.json')
status_counts = Counter(row['status'] for row in features)
gd_files = sorted(path for path in ROOT.rglob('*.gd') if '.godot' not in path.parts)
gd_lines = sum(len(path.read_text(encoding='utf-8').splitlines()) for path in gd_files)
model_paths = [ROOT / entry['path'].removeprefix('res://') for entry in assets.get('models', [])]
model_metrics = [glb_metrics(path) for path in model_paths]
vertices = sum(item['vertices'] for item in model_metrics)
faces = sum(item['faces'] for item in model_metrics)
geometries = sum(item['geometries'] for item in model_metrics)
materials = sum(item['materials'] for item in model_metrics)
bytes_total = sum(item['bytes'] for item in model_metrics)
static_pass, unit_pass, asset_pass, runtime_state = validation_counts()

final = {
    'release': '0.3.0-candidate',
    'feature_rows': len(features),
    'feature_statuses': dict(status_counts),
    'object_catalog_count': len(objects),
    'model_count': len(assets.get('models', [])),
    'audio_count': len(assets.get('audio', [])),
    'texture_count': len(assets.get('textures', [])),
    'ui_asset_count': len(assets.get('ui', [])),
    'gdscript_files': len(gd_files),
    'gdscript_lines': gd_lines,
    'asset_vertices_total': vertices,
    'asset_faces_total': faces,
    'asset_geometries_total': geometries,
    'asset_materials_total': materials,
    'asset_vertices_mean': vertices / len(model_metrics) if model_metrics else 0.0,
    'asset_faces_mean': faces / len(model_metrics) if model_metrics else 0.0,
    'asset_bytes_total': bytes_total,
    'static_checks_pass': static_pass,
    'unit_tests_pass': unit_pass,
    'asset_checks_pass': asset_pass,
    'runtime_engine_validation': runtime_state,
}
asset_summary = {
    'model_count': len(model_metrics),
    'vertices_total': vertices,
    'faces_total': faces,
    'geometries_total': geometries,
    'materials_total': materials,
    'bytes_total': bytes_total,
    'vertices_mean': vertices / len(model_metrics) if model_metrics else 0.0,
    'faces_mean': faces / len(model_metrics) if model_metrics else 0.0,
}
(OUT / 'final_metrics.json').write_text(json.dumps(final, indent=2) + '\n', encoding='utf-8')
(OUT / 'final_asset_metrics.json').write_text(json.dumps(model_metrics, indent=2) + '\n', encoding='utf-8')
(OUT / 'final_asset_summary.json').write_text(json.dumps(asset_summary, indent=2) + '\n', encoding='utf-8')

baseline_path = OUT / 'baseline_metrics.json'
if baseline_path.exists():
    baseline = load_json(baseline_path)
    baseline_log = OUT / 'baseline_validation-v0.2.0.txt'
    if baseline_log.exists():
        baseline_text = baseline_log.read_text(encoding='utf-8', errors='replace')
        m = re.search(r'^PASS:\s*(\d+)', baseline_text, flags=re.MULTILINE)
        if m: baseline.setdefault('static_checks_pass', int(m.group(1)))
        m = re.search(r'^Ran\s+(\d+)\s+tests?', baseline_text, flags=re.MULTILINE)
        if m: baseline.setdefault('unit_tests_pass', int(m.group(1)))
        m = re.search(r'^ASSET PASS:\s*(\d+)', baseline_text, flags=re.MULTILINE)
        if m: baseline.setdefault('asset_checks_pass', int(m.group(1)))
    keys = [
        'feature_rows', 'object_catalog_count', 'model_count', 'audio_count', 'texture_count',
        'gdscript_files', 'gdscript_lines', 'asset_vertices_total', 'asset_faces_total',
        'asset_geometries_total', 'asset_materials_total', 'asset_bytes_total',
        'static_checks_pass', 'unit_tests_pass', 'asset_checks_pass',
    ]
    delta = {'baseline_release': baseline.get('release'), 'final_release': final['release'], 'measures': {}}
    for key in keys:
        before = baseline.get(key, 0)
        after = final.get(key, 0)
        delta['measures'][key] = {
            'before': before,
            'after': after,
            'absolute_delta': after - before,
            'percent_delta': None if before == 0 else (after - before) / before * 100.0,
        }
    for status in ['implemented_unverified', 'architecture_contract', 'data_contract']:
        before = baseline.get('feature_statuses', {}).get(status, 0)
        after = final.get('feature_statuses', {}).get(status, 0)
        delta['measures'][f'feature_status:{status}'] = {
            'before': before,
            'after': after,
            'absolute_delta': after - before,
            'percent_delta': None if before == 0 else (after - before) / before * 100.0,
        }
    (OUT / 'improvement_delta.json').write_text(json.dumps(delta, indent=2) + '\n', encoding='utf-8')

print(json.dumps(final, indent=2))
