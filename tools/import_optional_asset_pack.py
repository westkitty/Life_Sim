#!/usr/bin/env python3
"""Safely stage a manually downloaded optional asset archive for OpenLife.

No network access is performed. This helper validates archive paths, records hashes,
and extracts into third_party/staging so third-party content stays separate from the
project-owned default pack until a human explicitly maps assets through aliases.
"""
from __future__ import annotations
import argparse, hashlib, json, shutil, zipfile
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
STAGING=ROOT/'third_party'/'staging'

def safe_name(value:str)->str:
    return ''.join(c.lower() if c.isalnum() else '-' for c in value).strip('-') or 'asset-pack'

def main()->None:
    ap=argparse.ArgumentParser()
    ap.add_argument('archive',type=Path)
    ap.add_argument('--name',required=True)
    ap.add_argument('--source-page',required=True)
    ap.add_argument('--license',default='CC0 1.0')
    args=ap.parse_args()
    archive=args.archive.expanduser().resolve()
    if not archive.is_file(): raise SystemExit(f'Archive not found: {archive}')
    if archive.suffix.lower()!='.zip': raise SystemExit('Only ZIP archives are accepted by this safe staging helper.')
    slug=safe_name(args.name); dest=STAGING/slug; originals=dest/'originals'
    if dest.exists(): shutil.rmtree(dest)
    originals.mkdir(parents=True)
    raw=archive.read_bytes(); digest=hashlib.sha256(raw).hexdigest()
    with zipfile.ZipFile(archive) as z:
        bad=[]
        for member in z.infolist():
            member_path=Path(member.filename)
            if member_path.is_absolute() or '..' in member_path.parts: bad.append(member.filename)
        if bad: raise SystemExit(f'Unsafe archive paths: {bad[:5]}')
        z.extractall(originals)
    copy=dest/archive.name; copy.write_bytes(raw)
    files=[str(p.relative_to(originals)) for p in originals.rglob('*') if p.is_file()]
    record={
      'name':args.name,'source_page':args.source_page,'declared_license':args.license,
      'archive_sha256':digest,'archive_bytes':len(raw),'file_count':len(files),
      'state':'acquired_unmapped','network_used':False,
      'note':'Staged only. Runtime aliases are unchanged until files are inspected and explicitly mapped.'
    }
    (dest/'acquisition.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record,indent=2))

if __name__=='__main__': main()
