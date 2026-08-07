#!/usr/bin/env python3
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class CatalogTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.packs = json.loads((ROOT / 'data/pack_registry.json').read_text())
        cls.features = json.loads((ROOT / 'data/feature_ledger.json').read_text())
        cls.objects = json.loads((ROOT / 'data/object_catalog.json').read_text())
        cls.aliases = json.loads((ROOT / 'data/asset_aliases.json').read_text())
        cls.assets = json.loads((ROOT / 'assets/generated/manifest.json').read_text())
        cls.visual_manifest = json.loads((ROOT / 'docs/resources/VISUAL_ASSET_MANIFEST.json').read_text())

    def test_complete_pack_ids(self):
        ids = {p['id'] for p in self.packs}
        self.assertIn('BG', ids)
        self.assertTrue({f'EP{i:02d}' for i in range(1, 12)} <= ids)
        self.assertTrue({f'SP{i:02d}' for i in range(1, 10)} <= ids)

    def test_feature_ids_unique(self):
        ids = [f['id'] for f in self.features]
        self.assertEqual(len(ids), len(set(ids)))

    def test_every_object_is_actionable(self):
        for item in self.objects:
            self.assertTrue(item['interactions'], item['id'])
            for interaction in item['interactions']:
                self.assertGreater(interaction['duration_minutes'], 0)

    def test_no_feature_contract_is_mislabeled_verified(self):
        allowed = {'engine_verified', 'implemented_unverified', 'architecture_contract', 'data_contract'}
        self.assertTrue(all(f['status'] in allowed for f in self.features))
        self.assertTrue(any(f['status'] == 'architecture_contract' for f in self.features))
        self.assertFalse(any(f['status'] == 'verified' for f in self.features))

    def test_every_pack_has_runtime_wired_slice(self):
        for pack_id in ['BG'] + [f'EP{i:02d}' for i in range(1,12)] + [f'SP{i:02d}' for i in range(1,10)]:
            rows=[f for f in self.features if f.get('pack_id')==pack_id]
            self.assertTrue(any(f['status'] in ('implemented_unverified','engine_verified') for f in rows), pack_id)

    def test_every_stuff_pack_has_actionable_content(self):
        for pack_id in [f'SP{i:02d}' for i in range(1,10)]:
            scoped=[o for o in self.objects if o.get('pack_id')==pack_id]
            self.assertTrue(scoped, pack_id)
            self.assertTrue(all(o.get('interactions') for o in scoped), pack_id)

    def test_every_catalog_asset_alias_resolves(self):
        for item in self.objects:
            asset_id=item.get('asset_id',item['id'])
            self.assertIn(asset_id,self.aliases,item['id'])
            path=ROOT/self.aliases[asset_id].replace('res://','')
            self.assertTrue(path.is_file(),item['id'])

    def test_asset_manifest_has_broader_offline_pack(self):
        self.assertGreaterEqual(len(self.assets['models']),100)
        self.assertGreaterEqual(len(self.assets['audio']),24)
        self.assertGreaterEqual(len(self.assets['textures']),7)
        self.assertGreaterEqual(len(self.objects),70)

    def test_save_schema_is_v3(self):
        text=(ROOT/'src/autoload/save_service.gd').read_text()
        match=re.search(r'const SAVE_VERSION := (\d+)',text)
        self.assertIsNotNone(match)
        self.assertEqual(int(match.group(1)),3)
        self.assertIn('parity_systems',text)

    def test_pet_and_performer_systems_are_hub_wired(self):
        hub=(ROOT/'src/core/systems/parity_system_hub.gd').read_text()
        for literal in ['PetSystem.new()','PerformerSystem.new()','"pets": pets.serialize()','"performers": performers.serialize()']:
            self.assertIn(literal,hub)

    def test_runtime_source_has_no_network_clients(self):
        bad=[]
        patterns=('HTTPRequest','HTTPClient','WebSocketPeer','ENetMultiplayerPeer','api_key','https://','http://')
        for path in (ROOT/'src').rglob('*.gd'):
            text=path.read_text(errors='ignore')
            if any(token in text for token in patterns): bad.append(str(path.relative_to(ROOT)))
        self.assertEqual(bad,[])

    def test_external_visual_candidate_lifecycle_is_explicit(self):
        allowed={'discovered','screened','rights-verified','provenance-verified','technically-verified','approval-required','approved','acquired','inspected','processed','integrated','validated','rejected','needs-human-review','unavailable','superseded','removed'}
        candidates=self.visual_manifest.get('optional_candidates',[])
        self.assertTrue(candidates)
        for candidate in candidates:
            self.assertIn(candidate.get('state'),allowed,candidate.get('resource_id'))
            self.assertTrue(str(candidate.get('source_page','')).startswith('https://'),candidate.get('resource_id'))
            self.assertNotEqual(candidate.get('technical_state'),'validated',candidate.get('resource_id'))

    def test_character_asset_plan_uses_coherent_rig_ecosystem(self):
        ids={c.get('resource_id') for c in self.visual_manifest.get('optional_candidates',[])}
        self.assertIn('quaternius-universal-base-characters',ids)
        self.assertIn('quaternius-universal-animation-library-2',ids)
        evidence=(ROOT/'docs/resources/evidence/EXTERNAL_SOURCE_EVIDENCE.md').read_text()
        self.assertIn('Universal Base Characters',evidence)
        self.assertIn('Universal Animation Library 2',evidence)

    def test_v03_feature_wiring_is_strictly_broader_than_v02_baseline(self):
        counts={status:sum(1 for f in self.features if f['status']==status) for status in {'engine_verified','implemented_unverified','architecture_contract','data_contract'}}
        self.assertGreater(counts['implemented_unverified']+counts['engine_verified'],23)
        self.assertGreater(len(self.features),169)

if __name__ == '__main__': unittest.main()
