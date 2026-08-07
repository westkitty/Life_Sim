# OpenLife Style Bible

**Version:** graphics loop foundation (Loop 01+)
**Target:** stylized-realistic suburban life simulation (clean-room; not EA/Maxis IP)

## Pillars

1. **Warm suburban domestic** — sun-warmed lawns, cream architecture, soft daylight.
2. **Readable silhouettes** — deliberate forms over cubes; moderate geo detail.
3. **Material clarity** — wood, cloth, ceramic, metal, glass, paint, vegetation, asphalt, roofing must separate at neighborhood and room scale.
4. **Distinct people** — every default Sim readable by hair, skin, clothing, proportion, age.
5. **Life-sim camera** — elevated orbit, comfortable FOV (~40–46°), interiors readable via cutaway.
6. **UI serves the world** — HUD never dominates the viewport; no giant always-on debug labels.

## Color

| Role | Hex range | Notes |
|------|-----------|-------|
| Lawn | `#5a7a4a`–`#7a926c` | Warm, muted; never neon chartreuse |
| Road | `#3c4046`–`#4a4f56` | Cool grey asphalt, low chroma |
| Sidewalk | `#b0aca1`–`#c4c0b4` | Warm concrete |
| Sky top | `#7eb8d8` | Soft midday |
| Sky horizon | `#d9e8ef` | Gentle haze |
| Sun light | `#fff2df` | Warm key |
| Fill | `#c8daf0` | Cool sky bounce |
| Selection | `#f2c751` @ ~55% α | Original OpenLife ring (not plumbob) |

Saturation stays restrained; value contrast carries readability.

## Lighting

- Key: directional warm sun, late-morning angle (~−48° pitch).
- Fill: cool low-energy directional, no shadow.
- Ambient: sky contribution preferred over flat colour.
- Shadows: soft, parallel splits; bias tuned to avoid acne on GL Compatibility.
- Tonemap: filmic, exposure ~0.9, white ~1.15 — avoid blown lawns.
- Fog: very light aerial fog for depth; never milky interiors.

## Architecture

- Residential: eaves, trim, porch, windows with frames, foundation, roof materials.
- Interiors: baseboards, floor/wall material contrast, cutaway walls for camera.
- Scale: human ~1.7 m adult; door ~2.1 m; furniture domestic proportions.

## Characters

- Humanoid foundation with readable face and hair mass.
- Individuality via skin, hair, clothing silhouette, palette, age stage.
- Animation: idle + locomotion first; interaction sockets second.
- Labels: small, fade by distance; selection is a soft ground ring.

## Props & dressing

- Prefer coherent packs (Quaternius / Kenney CC0) or project-authored GLB families.
- Hero furniture upgrades before scatter props.
- Clutter must not block routing.

## UI

- Typography hierarchy, translucent panels, compact motive bars.
- Idle HUD leaves ≥60% of the viewport as world.
- Original icons/swatches; no Sims chrome clones.

## Technical

- Renderer: Godot 4.7 **GL Compatibility** (primary).
- Runtime meshes: GLB; textures 512–1024 typical (2048 only when needed).
- Aliases only: `data/asset_aliases.json` — never vendor paths in gameplay code.
- Asset policy: project-owned / CC0 / public domain; no paid, no rips, no runtime network.

## Anti-patterns

- Featureless white building boxes as final art.
- Neon lawns / untextured furniture.
- Identical Sims.
- Marketplace style soup (scan realism mixed with toy blocks).
- Giant debug labels / opaque full-screen HUD.
- Copyrighted Sims meshes, textures, plumbob, Simlish, logos.
