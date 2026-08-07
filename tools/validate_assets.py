#!/usr/bin/env python3
"""Standard-library validation of bundled OpenLife generated assets."""
from __future__ import annotations
import hashlib, json, struct, wave
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
errors=[]; passed=[]
def check(cond,msg): (passed if cond else errors).append(msg)
manifest=json.loads((ROOT/'assets/generated/manifest.json').read_text())
aliases=json.loads((ROOT/'data/asset_aliases.json').read_text())
objects=json.loads((ROOT/'data/object_catalog.json').read_text())
for section in ('models','audio','textures','ui'):
    check(isinstance(manifest.get(section),list),f'manifest section {section} is a list')
for item in manifest['models']:
    path=ROOT/item['path'].replace('res://','')
    check(path.is_file(),f'model exists: {item["id"]}')
    if path.is_file():
        raw=path.read_bytes(); check(raw[:4]==b'glTF',f'GLB magic valid: {item["id"]}')
        if len(raw)>=12:
            version,length=struct.unpack('<II',raw[4:12]); check(version==2 and length==len(raw),f'GLB v2 length valid: {item["id"]}')
        check(hashlib.sha256(raw).hexdigest()==item['sha256'],f'model hash matches: {item["id"]}')
for item in manifest['audio']:
    path=ROOT/item['path'].replace('res://','')
    check(path.is_file(),f'audio exists: {item["id"]}')
    if path.is_file():
        with wave.open(str(path),'rb') as w:
            check(w.getnchannels()==1,f'audio mono: {item["id"]}')
            check(w.getsampwidth()==2,f'audio 16-bit: {item["id"]}')
            check(w.getframerate()==44100,f'audio 44.1 kHz: {item["id"]}')
        check(hashlib.sha256(path.read_bytes()).hexdigest()==item['sha256'],f'audio hash matches: {item["id"]}')

for item in manifest['textures']:
    path=ROOT/item['path'].replace('res://','')
    check(path.is_file(),f'texture exists: {item["id"]}')
    if path.is_file():
        raw=path.read_bytes(); check(raw[:8]==b'\x89PNG\r\n\x1a\n',f'PNG signature valid: {item["id"]}')
        check(hashlib.sha256(raw).hexdigest()==item['sha256'],f'texture hash matches: {item["id"]}')

for item in manifest['ui']:
    path=ROOT/item['path'].replace('res://','')
    check(path.is_file(),f'UI icon exists: {item["id"]}')
    if path.is_file(): check(hashlib.sha256(path.read_bytes()).hexdigest()==item['sha256'],f'UI icon hash matches: {item["id"]}')
for obj in objects:
    aid=obj.get('asset_id',obj['id']); check(aid in aliases,f'catalog asset alias exists: {obj["id"]}')
    if aid in aliases: check((ROOT/aliases[aid].replace('res://','')).is_file(),f'catalog asset target exists: {obj["id"]}')
check(len(manifest['models'])>=100,'at least 100 bundled GLB models')
check(len(manifest['audio'])>=24,'at least 24 bundled synthesized SFX/music files')
check(len(manifest['textures'])>=7,'at least 7 bundled procedural textures')
check(len(objects)>=70,'at least 70 actionable Build/Buy catalog objects')
print(f'ASSET PASS: {len(passed)}'); print(f'ASSET FAIL: {len(errors)}')
for e in errors: print(' -',e)
raise SystemExit(1 if errors else 0)
