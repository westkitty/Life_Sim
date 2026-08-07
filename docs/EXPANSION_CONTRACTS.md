# Expansion Contracts

Each expansion is a subsystem contract, not a feature flag that merely reveals catalog objects.

## Required contract fields

Every expansion module must declare:

- pack ID and semantic version;
- dependencies and optional integrations;
- simulation services introduced or extended;
- new entity and object components;
- save-schema additions and migrations;
- user-interface routes;
- autonomy and Story Progression contributions;
- content categories and original asset requirements;
- world and lot requirements;
- cross-pack test fixtures;
- disable/remove behavior for existing saves.

## Cross-pack rule

An expansion may extend a base service but may not fork an incompatible duplicate. Examples:

- vampires, witches, mermaids and plumbots extend one life-state service;
- cats, dogs, horses and human residents share identity, routing, autonomy and relationship contracts while supplying species-specific components;
- university, travel and future destinations use one world-travel transaction;
- houseboats and resorts extend lot ownership rather than inventing unrelated persistence;
- seasonal lots and festivals use the world event scheduler;
- active professions, performance professions and lifeguards share job-event infrastructure.

## Offline replacement for retired network features

Network-dependent historical features must receive a local-first equivalent where the original service is no longer available. The local exchange hook must preserve import/export, provenance, consent and failure reporting without requiring a paid or hosted service.
