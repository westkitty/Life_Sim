# Unified Resource Gap Map — v0.3.0

| Gap | Player-facing problem | Route | Current decision | Evidence |
|---|---|---|---|---|
| VIS-01 | Early furniture/object silhouettes were too primitive to distinguish the catalog well | visual/local | substantially improved locally | 73 actionable objects resolve to project-owned GLBs; paired v0.2/v0.3 proof shows richer geometry on identical object IDs |
| VIS-02 | Neighborhood blockout lacked readable residential/community identity | visual/local | improved locally | 106 GLBs now cover houses, community buildings, roads, nature, pets, pack slices and object families |
| VIS-03 | Sims needed age/body-shape visual differentiation | bespoke/local | implemented-unverified | CAS genetics select bundled age/body-shape GLBs with procedural fallback |
| VIS-04 | Character locomotion and interaction animation remain the largest visual-production gap | visual scout | external candidate retained | Quaternius Universal Animation Library is rights/provenance verified but exact bytes were not acquired or runtime-tested |
| VIS-05 | A future art upgrade needs coherent domestic/community replacement packs rather than random one-offs | visual scout | candidates retained behind aliases | Kenney Furniture/City and Quaternius Furniture are documented in `ASSET_SOURCE_REPORT.md`; not bundled without byte-level inspection |
| VIS-06 | Higher-resolution PBR materials could increase detail but may break cohesion/performance | visual scout | rejected as default | Poly Haven wood/asphalt candidates have strong rights but conflict with current low-poly material language |
| AUD-01 | v0.2 audio coverage was sparse and lacked mode music | audio/local | improved locally | 24 project-owned WAV files include SFX plus Live/Build/CAS music loops |
| AUD-02 | A larger publisher-authored UI feedback family may be useful later | audio scout | optional candidate retained | Kenney Interface Sounds is rights/provenance verified; exact bytes not acquired or integrated |
| CODE-01 | Runtime must remain local, account-free and vendor-independent | code/local | protected | runtime source has no network/API-key dependency; optional asset importer is local-only and alias-neutral |
| QA-01 | Asset improvement needed proof rather than assertion | QA/local | resolved at package level | frozen baseline metrics, final metrics and `qa/improvement/before_after_asset_proof.png` are bundled |
