# OpenLife Full-Parity Target

## Controlling definition

Full parity means **each user-visible and simulation-relevant function of the PC version of The Sims 3**, including the base game, all eleven expansion packs, all nine stuff packs, their cross-pack interactions, and the official world/premium-content extension points.

Parity is behavioral, not cosmetic. A similarly named button, class, or object does not pass. The required evidence is an equivalent player journey and an equivalent persistent simulation result.

## Product families

| ID | Reference product | Required feature families |
|---|---|---|
| BG | Base game | open neighborhood, households, Create-a-Sim, Build/Buy, motives, moodlets, wishes, traits, autonomy, routing, relationships, careers, skills, opportunities, aging, pregnancy, genetics, death, ghosts, services, vehicles, inventories, collecting, gardening, fishing, cooking, parties, schools, Story Progression, save/load, camera, audio, options, localization and modding hooks |
| EP01 | World Adventures | travel destinations, visas, adventures, tombs, traps, relics, nectar, photography, martial arts, mummies, vacation homes |
| EP02 | Ambitions | active professions, self-employment, inventing, sculpting, tattooing, styling, laundry, consignment and disasters |
| EP03 | Late Night | city/high-rise systems, apartments, venues, clubs, bands, celebrities, paparazzi, vampires, mixology, subways and group outings |
| EP04 | Generations | memories, imaginary friends, daycare, boarding schools, prom, graduation, pranks, punishment, weddings, midlife crisis and childhood objects |
| EP05 | Pets | pet Create-a-Sim, cats, dogs, horses, pet autonomy, training, genetics, breeding, wildlife, unicorns and equestrian systems |
| EP06 | Showtime | singer, magician and acrobat professions; venues, gigs, stage setup, SimFest, genies, DJ and karaoke systems |
| EP07 | Supernatural | witches, werewolves, fairies, zombies, expanded vampires, alchemy, lunar cycle, magic duels, supernatural services and population controls |
| EP08 | Seasons | seasons, weather, temperature, festivals, holidays, seasonal lots, snow, storms, aliens and online dating |
| EP09 | University Life | enrollment, degrees, classes, exams, dorms, roommates, social groups, protests, street art, science, smartphones, networking and PlantSims |
| EP10 | Island Paradise | boats, water routing, houseboats, resorts, diving, underwater lots, islands, lifeguards, mermaids and kraken events |
| EP11 | Into the Future | time travel, future states, descendants, plumbots, trait chips, advanced technology, bot building, dream pods and alternate futures |
| SP01-SP09 | Stuff packs | complete catalog/category integration, Create-a-Sim content, Build/Buy content, collection tags and pack filtering; proprietary assets must be replaced with original equivalents |
| STORE | Store/premium hook | local package registry, premium scripted-object API, world/lot/CAS/Build-Buy content manifests and ownership flags |
| WORLD | Downloadable worlds | world manifests, lots, residents, routing, rabbit holes, premium dependencies and save migration |

## Cross-pack parity

Every expansion must operate both independently and in combinations. Required cross-pack validation includes, at minimum:

- occult genetics, aging, death, travel and university enrollment;
- pets on houseboats, seasonal lots and travel worlds;
- weather in custom worlds, resorts, university and future destinations;
- active careers with celebrity, opportunities and Story Progression;
- Build/Buy catalog filtering across every installed content combination;
- world travel with household inventories, relationships, descendants and pending opportunities;
- save compatibility when packs are enabled, disabled, added or removed;
- routing for Sims, pets, horses, boats, elevators, subways, houseboats and hover vehicles;
- household progression while the player controls another lot, world or household.

## Evidence threshold

A feature passes only when all relevant layers pass:

1. **Data:** definitions load, validate and serialize.
2. **Simulation:** state transitions and edge conditions are deterministic enough to test.
3. **Interaction:** the player can discover, queue, cancel and complete the function.
4. **Presentation:** the interface communicates availability, cost, progress, failure and result.
5. **Persistence:** save/load preserves the state and resumes safely.
6. **Combination:** relevant pack and system interactions do not silently break it.
7. **Performance:** the behavior remains usable at target population and object counts.
8. **Content:** original replacement assets and text cover the required catalog role.

Anything below that threshold remains `Partial`, `Unverified`, or `Not implemented` regardless of how polished it looks.
