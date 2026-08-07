#!/usr/bin/env python3
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
packs={x['id']:x for x in json.loads((ROOT/'data/pack_registry.json').read_text())}
features=json.loads((ROOT/'data/feature_ledger.json').read_text())
from collections import Counter
counts=Counter(f.get('status','') for f in features)
lines=['# Feature Matrix','',
'Evidence states are deliberately conservative.','',
'- `engine_verified` — a named test in `tests/godot/` exercises this feature in Godot 4.7.1 and asserts its behaviour.',
'- `implemented_unverified` — source-wired behaviour exists and the pack has at least one engine-exercised interaction path, but this row has no feature-specific Godot assertion.',
'- `architecture_contract` / `data_contract` — not implementations. A data contract stores and restores state but has no reachable in-world user path.','',
'Current totals: %d engine_verified, %d implemented_unverified, %d architecture_contract, %d data_contract, %d rows overall. Full Sims 3 parity is **not** claimed.' % (
    counts.get('engine_verified',0),counts.get('implemented_unverified',0),
    counts.get('architecture_contract',0),counts.get('data_contract',0),len(features)),'',
'| ID | Pack | Category | Feature | Evidence state | Proof |','|---|---|---|---|---|---|']
for f in features:
    pack=packs.get(f.get('pack_id'),{}).get('name',f.get('pack_id',''))
    vals=[f.get('id',''),pack,f.get('category',''),f.get('name',''),f.get('status',''),f.get('proof','')]
    vals=[str(v).replace('|','\\|').replace('\n',' ') for v in vals]
    lines.append('| '+' | '.join(vals)+' |')
(ROOT/'docs/FEATURE_MATRIX.md').write_text('\n'.join(lines)+'\n')
print('wrote',len(features),'feature rows')
