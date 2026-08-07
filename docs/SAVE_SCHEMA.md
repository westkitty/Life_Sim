# OpenLife Save Schema

## Envelope v3

```json
{
  "save_version": 3,
  "project": "OpenLife",
  "saved_at_unix": 0,
  "state": {}
}
```

`SaveService` writes a temporary local file, parses it back as JSON, preserves the previous primary slot as `.bak`, then writes the verified contents into the primary slot. If the primary cannot be loaded, the backup is attempted.

Version 1 saves migrate v1 → v2 → v3. Version 2 saves migrate v2 → v3. v3 introduces `parity_systems` rather than silently reinterpreting older data.

## Current state keys

- `clock`
- `households`
- `relationships`
- `weather`
- `world`
- `moodlets`
- `wishes`
- `inventory`
- `parity_systems`
  - `genealogy`, `pregnancy`, `school`, `bills`, `services`, `opportunities`
  - `collecting`, `gardening`, `fishing`, `cooking`, `parties`, `death`
  - `pets`, `performers`, `expansions`
- `sims`
- `objects`
- `selected_sim_id`
- `mode`
- `settings`

Vector positions are stored as numeric arrays rather than engine-specific Variant text.

## Evidence boundary

Schema/source inspection proves the serializer exists and is internally coherent. Only a Godot save → mutate → load → state-comparison journey can verify user-facing persistence behavior.
