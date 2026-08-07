# Godot Runtime Test Checklist

These checks are mandatory before promoting the current source-wired implementation from `implemented_unverified` to verified.

## Import and parse

1. Open the project in Godot 4.7.1 stable.
2. Confirm all GLB/WAV/PNG/SVG imports complete with no missing resources.
3. Run the main scene.
4. Record every parser error, debugger error and runtime exception.

## Core journey

1. Confirm neighborhood, five residents and HUD render.
2. Exercise W/A/S/D, Q/E, mouse-wheel zoom and resident switching.
3. Queue a refrigerator meal and confirm routed movement, completion and hunger effect.
4. Queue a social action and confirm relationship change.
5. Toggle one resident's autonomy and confirm trait/motive-driven queue behavior changes appropriately.
6. Exercise pause/normal/fast/ultra speeds.
7. Build/Buy: place, rotate, reject overlap/out-of-lot placement, sell and verify funds.
8. CAS: change identity/age/trait/body shape and verify HUD/visual refresh.
9. Request a service and run a party to completion.
10. Exercise collecting, gardening, fishing and cooking special hooks.
11. Create pregnancy state, advance to birth, and verify genealogy/genetics/household insertion.
12. Confirm school/bills advance across weekdays/days.
13. Exercise pet feed/play/training state and confirm it persists.
14. Use the performance stage/karaoke and confirm EP06 performer progression persists.
15. Exercise at least one runtime-wired object/hook from every EP and every SP.
16. Add occult state, travel among home/travel/university/future state, and exercise plumbot path.
17. Save, mutate, load and compare all v3 systems including pets/performers/expansions.
18. Run at ultra speed for at least ten simulated days and inspect errors/state/save integrity.

## Failure threshold

Any parser error, exception, missing resource, unrecoverable save, broken selection/interaction route, invalid placement topology or corrupted household/parity state blocks verification.
