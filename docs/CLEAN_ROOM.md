# Clean-Room and Compatibility Boundary

OpenLife is not a redistribution, decompilation, patch, wrapper or asset extraction project.

## Allowed

- independently written code implementing general life-simulation behavior;
- original names, user interface, art, animation, sound and worlds;
- public observation of player-visible behavior;
- documented compatibility targets and pack identifiers;
- user-authored tuning and content packages;
- import tools for open formats or user-owned source material where legally permitted.

## Prohibited in this repository

- Electronic Arts source code or decompiled implementation;
- copied meshes, textures, animations, audio, text, icons, interface layouts or world data;
- proprietary package keys, bypasses or entitlement circumvention;
- misleading use of The Sims branding as the project identity;
- claims that architectural similarity establishes source-code equivalence;
- counting placeholders as parity.

## Replacement-content rule

Stuff-pack and Store parity means covering the same *functional catalog roles* with original replacement content. It does not mean copying branded or copyrighted assets.

## v0.2 bundled media

All bytes under `assets/generated/` are generated specifically for OpenLife by `tools/generate_assets.py`; no Electronic Arts or other commercial-game asset bytes are used. Optional external candidate records under `docs/resources/` contain source metadata only. No candidate archive is included unless a later release separately acquires, inspects, licenses, integrates and validates it.
