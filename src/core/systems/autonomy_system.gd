class_name AutonomySystem
extends Node

var autonomy_enabled := true
var autonomy_threshold := 58.0
var rng := RandomNumberGenerator.new()
var trait_tuning: TraitTuningSystem

func configure(tuning: TraitTuningSystem) -> void:
	trait_tuning = tuning

func _ready() -> void:
	rng.seed = 1904

func choose_interaction(sim: SimAgent, objects: Array) -> Dictionary:
	if not autonomy_enabled or not sim.autonomy_enabled or not sim.queue.current.is_empty() or not sim.queue.pending.is_empty():
		return {}
	var motive_id := MotiveSystem.lowest_motive(sim.motives)
	if float(sim.motives.get(motive_id, 100.0)) > autonomy_threshold:
		return _choose_idle_social_or_fun(sim, objects)
	var candidates: Array[Dictionary] = []
	for object in objects:
		if not is_instance_valid(object):
			continue
		for interaction in object.interactions:
			var effects: Dictionary = Dictionary(interaction.get("motive_effects", {}))
			if float(effects.get(motive_id, 0.0)) > 0.0:
				var candidate: Dictionary = interaction.duplicate(true)
				candidate["target_id"] = object.object_instance_id
				candidate["target_position"] = object.interaction_slot_position(sim.global_position)
				candidate["slot_candidates"] = object.interaction_slots()
				candidate["target_name"] = object.display_name
				candidate["autonomous"] = true
				var base_score := float(effects[motive_id]) - sim.global_position.distance_to(object.global_position) * 0.35
				candidate["score"] = trait_tuning.score_interaction(sim.profile, candidate, base_score) if trait_tuning != null else base_score
				candidates.append(candidate)
	if candidates.is_empty():
		return {}
	candidates.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return float(a["score"]) > float(b["score"]))
	return candidates[0]

func _choose_idle_social_or_fun(sim: SimAgent, objects: Array) -> Dictionary:
	if rng.randf() > 0.12:
		return {}
	var candidates: Array[Dictionary] = []
	for object in objects:
		if not is_instance_valid(object):
			continue
		for interaction in object.interactions:
			var effects: Dictionary = Dictionary(interaction.get("motive_effects", {}))
			if float(effects.get("fun", 0.0)) > 5.0:
				var candidate: Dictionary = interaction.duplicate(true)
				candidate["target_id"] = object.object_instance_id
				candidate["target_position"] = object.interaction_slot_position(sim.global_position)
				candidate["slot_candidates"] = object.interaction_slots()
				candidate["target_name"] = object.display_name
				candidate["autonomous"] = true
				candidates.append(candidate)
	return {} if candidates.is_empty() else candidates[rng.randi_range(0, candidates.size() - 1)]
