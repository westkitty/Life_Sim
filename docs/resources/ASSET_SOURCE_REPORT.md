# OpenLife Asset Source Report — v0.3.0

Verification date: 2026-08-07

## Release decision

The default release remains **fully offline and self-contained**. It ships project-owned assets rather than making launch depend on third-party downloads. External candidates remain behind stable project aliases and are **not counted as integrated** until exact archive bytes are acquired, hashed, inspected, normalized and exercised in Godot.

This is deliberate. A source is only an improvement when rights, provenance, visual cohesion, technical fit and replacement cost all survive inspection.

## Bundled project-owned pack

| Family | Count | State | Why it ships |
|---|---:|---|---|
| GLB models | 106 | integrated / statically validated | Immediate offline neighborhood, Build/Buy, age/body-shape stand-ins, pets and pack slices |
| WAV audio | 24 | integrated / statically validated | UI, object, event, weather, magic and Live/Build/CAS music loops |
| PNG textures | 7 | integrated / statically validated | Ground, roads, floors, walls and paving |
| SVG UI icons | 5 | integrated / statically validated | Core mode/save surfaces |

Every Build/Buy object in `data/object_catalog.json` resolves through `data/asset_aliases.json`. Vendor paths never enter gameplay code.

## Best coherent external upgrade stack

### 1. Character + animation foundation — highest priority

**Quaternius Universal Base Characters + Universal Animation Library 2** are now the preferred external character path.

Why this pair outranks the earlier Mini Characters fallback:

- both come from the same original publisher and are CC0;
- the base-character kit is built around an animation-friendly humanoid rig and includes regular/teen proportion families plus 20 hairstyles;
- the animation library uses a universal humanoid rig and advertises 130+ animations;
- the animation library offers GLB exports and explicitly describes Godot-tested exports/retargeting;
- the two packs are designed to work together, reducing skeleton, retargeting and style drift;
- this maps directly to the largest remaining visual gap: CAS-compatible bodies plus locomotion/interaction animation.

State: **rights-verified / provenance-verified / not acquired**. Publisher-page compatibility claims are recorded, but exact bytes have not been technically inspected in this environment.

### 2. Interior replacement foundation

Preferred order:

1. **Quaternius Ultimate House Interior Pack** — 120+ coherent interior models, CC0; broadest single domestic replacement candidate.
2. **Kenney Furniture Kit** — 140 files, CC0; strong clean low-poly fallback and excellent replacement simplicity.
3. **Quaternius Furniture Pack** — smaller fallback if a narrower import is desirable.

State: rights/provenance verified; exact bytes not acquired.

### 3. Neighborhood shells

Preferred order:

1. **Kenney City Kit (Suburban)** — residential neighborhood supplement.
2. **Kenney City Kit (Commercial)** — community-lot shell supplement.

Both are publisher-controlled CC0 candidates and stylistically closer to the current pack than realistic scanned architecture.

### 4. Audio augmentation

**Kenney Interface Sounds** remains the preferred optional UI-audio family. The release does not require it because 24 project-owned WAV files already cover launch/runtime feedback.

### 5. Material sources deliberately not promoted

**Poly Haven Wood Floor** and similarly realistic PBR road materials pass rights/provenance screening but are rejected as the default style path. Their realistic shading language and high-resolution multi-map burden would make the project less coherent and heavier without solving a current gameplay problem.

## Candidate table

| Priority | Candidate | Exact publisher page | Rights | Intended role | Current decision |
|---|---|---|---|---|---|
| 1 | Quaternius Universal Base Characters | https://quaternius.com/packs/universalbasecharacters.html | CC0 | CAS-compatible humanoid body/hairstyle foundation | Preferred character source; not acquired |
| 2 | Quaternius Universal Animation Library 2 | https://quaternius.com/packs/universalanimationlibrary2.html | CC0 | Locomotion and interaction animation | Preferred animation source; not acquired |
| 3 | Quaternius Ultimate House Interior Pack | https://quaternius.com/packs/ultimatehomeinterior.html | CC0 | Broad coherent domestic interior replacement | Preferred furniture breadth; not acquired |
| 4 | Kenney Furniture Kit | https://kenney.nl/assets/furniture-kit | CC0 1.0 | Low-poly domestic furniture replacement | Strong fallback; not acquired |
| 5 | Kenney City Kit (Suburban) | https://kenney.nl/assets/city-kit-suburban | CC0 1.0 | Residential shells/streetscape | Strong neighborhood supplement; not acquired |
| 6 | Kenney City Kit (Commercial) | https://kenney.nl/assets/city-kit-commercial | CC0 1.0 | Community-lot shells | Strong community supplement; not acquired |
| 7 | Kenney Interface Sounds | https://kenney.nl/assets/interface-sounds | CC0 1.0 | Larger UI feedback family | Optional; not acquired |
| 8 | Kenney Mini Characters | https://kenney.nl/assets/mini-characters | CC0 1.0 | Temporary animated character fallback | Demoted: less suitable for final CAS direction |
| 9 | Poly Haven Wood Floor | https://polyhaven.com/a/wood_floor | CC0 | Realistic floor material | Rejected as default for style/performance fit |

Detailed observed publisher-page facts are preserved in `docs/resources/evidence/EXTERNAL_SOURCE_EVIDENCE.md`.

## Why external bytes are not silently bundled

The build environment could verify publisher pages but could not reliably materialize exact third-party archives into the project for byte-level inspection. The release therefore does **not** convert discovery into integration by assertion.

That is safer and more useful than shipping uninspected vendor archives: the project opens immediately with its own assets, and the future replacement boundary is already stable.

## Safe local import path

1. Obtain the exact archive from the publisher page.
2. Run `python3 tools/import_optional_asset_pack.py <archive.zip> --name "<pack>" --source-page "<exact URL>"`.
3. Inspect the staged original under `third_party/staging/<pack>/originals/`.
4. Preserve the archive hash and license evidence.
5. Convert only selected resources into project-supported runtime formats.
6. Map replacements through `data/asset_aliases.json` rather than vendor paths.
7. Re-run `python3 tools/run_validation.py` and then `docs/RUNTIME_TEST_CHECKLIST.md` in Godot.

The importer performs no network access, rejects unsafe ZIP paths, hashes the original archive and leaves runtime aliases unchanged until an explicit integration step.

## Residual asset gaps

The most important unresolved visual gap remains a full **rigged character-animation/CAS morphology pipeline**, followed by object interaction alignment and pet animation. The preferred Quaternius character/animation pair materially improves the sourcing plan for that gap, but it remains correctly unintegrated until exact bytes can be inspected and run.
