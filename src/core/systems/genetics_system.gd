class_name GeneticsSystem
extends Node

const SKIN_TONES := ["light", "warm", "medium", "deep"]
const HAIR_COLORS := ["black", "brown", "auburn", "blonde"]
const EYE_COLORS := ["brown", "hazel", "green", "blue"]

func ensure_genetics(profile: SimProfile) -> void:
	if not profile.genetics.is_empty():
		return
	var seed_value: int = absi(hash(profile.sim_id))
	profile.genetics = {
		"skin_tone": SKIN_TONES[seed_value % SKIN_TONES.size()],
		"hair_color": HAIR_COLORS[int(seed_value / 3) % HAIR_COLORS.size()],
		"eye_color": EYE_COLORS[int(seed_value / 7) % EYE_COLORS.size()],
		"body_shape": ["slender", "average", "athletic", "soft"][int(seed_value / 11) % 4],
		"voice_pitch": 0.85 + float(seed_value % 31) / 100.0,
	}

func make_child_profile(mother: SimProfile, father: SimProfile, child_index: int) -> Dictionary:
	ensure_genetics(mother)
	ensure_genetics(father)
	var seed_value: int = absi(hash("%s|%s|%d" % [mother.sim_id, father.sim_id, child_index]))
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var inherited_traits: Array[String] = []
	var combined := mother.traits.duplicate()
	for trait_id in father.traits:
		if trait_id not in combined:
			combined.append(trait_id)
	# Deterministic Fisher-Yates shuffle using the child-specific RNG.
	for index in range(combined.size() - 1, 0, -1):
		var swap_index := rng.randi_range(0, index)
		var temporary: Variant = combined[index]
		combined[index] = combined[swap_index]
		combined[swap_index] = temporary
	for trait_id in combined:
		if inherited_traits.size() >= 2:
			break
		inherited_traits.append(String(trait_id))
	var genetics := {
		"skin_tone": _inherit_value(mother.genetics, father.genetics, "skin_tone", rng),
		"hair_color": _inherit_value(mother.genetics, father.genetics, "hair_color", rng),
		"eye_color": _inherit_value(mother.genetics, father.genetics, "eye_color", rng),
		"body_shape": _inherit_value(mother.genetics, father.genetics, "body_shape", rng),
		"voice_pitch": (float(mother.genetics.get("voice_pitch", 1.0)) + float(father.genetics.get("voice_pitch", 1.0))) * 0.5 + rng.randf_range(-0.06, 0.06),
	}
	return {
		"sim_id": "sim_child_%s_%03d" % [mother.last_name.to_lower().replace(" ", "_"), child_index],
		"first_name": ["Avery", "Rowan", "Kai", "Morgan", "Ellis", "Jordan"][seed_value % 6],
		"last_name": mother.last_name,
		"age_stage": "baby",
		"age_days": 0.0,
		"traits": inherited_traits,
		"favorites": mother.favorites.duplicate(true),
		"career_id": "unemployed",
		"career_level": 0,
		"career_performance": 0.0,
		"skills": {},
		"occult_states": _inherit_occult(mother, father, rng),
		"household_id": mother.household_id,
		"biography": "Born into the %s household." % mother.last_name,
		"genetics": genetics,
	}

func _inherit_value(first: Dictionary, second: Dictionary, key: String, rng: RandomNumberGenerator) -> Variant:
	return first.get(key) if rng.randf() < 0.5 else second.get(key)

func _inherit_occult(first: SimProfile, second: SimProfile, rng: RandomNumberGenerator) -> Array[String]:
	var pool: Array[String] = []
	for state in first.occult_states + second.occult_states:
		if state not in pool:
			pool.append(state)
	var result: Array[String] = []
	for state in pool:
		if rng.randf() < 0.45:
			result.append(state)
	return result
