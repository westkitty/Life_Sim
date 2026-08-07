class_name RelationshipSystem
extends Node

var relationships: Dictionary = {}

func _pair_key(sim_a: String, sim_b: String) -> String:
	var ids := [sim_a, sim_b]
	ids.sort()
	return "%s::%s" % [ids[0], ids[1]]

func get_relationship(sim_a: String, sim_b: String) -> Dictionary:
	var key := _pair_key(sim_a, sim_b)
	if not relationships.has(key):
		relationships[key] = {
			"sim_a": sim_a,
			"sim_b": sim_b,
			"long_term": 0.0,
			"short_term": 0.0,
			"romantic": 0.0,
			"status": "acquaintance",
		}
	return Dictionary(relationships[key])

func adjust(sim_a: String, sim_b: String, long_term_delta: float, short_term_delta: float, romantic_delta: float = 0.0) -> Dictionary:
	var key := _pair_key(sim_a, sim_b)
	var relation := get_relationship(sim_a, sim_b)
	relation["long_term"] = clampf(float(relation["long_term"]) + long_term_delta, -100.0, 100.0)
	relation["short_term"] = clampf(float(relation["short_term"]) + short_term_delta, -100.0, 100.0)
	relation["romantic"] = clampf(float(relation["romantic"]) + romantic_delta, 0.0, 100.0)
	relation["status"] = _derive_status(relation)
	relationships[key] = relation
	EventBus.relationship_changed.emit(sim_a, sim_b, relation["long_term"], relation["short_term"])
	return relation

func tick(sim_minutes: float) -> void:
	var decay := sim_minutes / 1440.0
	for key in relationships.keys():
		var relation: Dictionary = relationships[key]
		relation["short_term"] = move_toward(float(relation["short_term"]), 0.0, decay * 10.0)
		relationships[key] = relation

func _derive_status(relation: Dictionary) -> String:
	var long_term := float(relation.get("long_term", 0.0))
	var romantic := float(relation.get("romantic", 0.0))
	if romantic >= 70.0 and long_term >= 60.0:
		return "partner"
	if romantic >= 30.0:
		return "romantic_interest"
	if long_term >= 80.0:
		return "best_friend"
	if long_term >= 40.0:
		return "friend"
	if long_term <= -60.0:
		return "enemy"
	if long_term <= -20.0:
		return "disliked"
	return "acquaintance"

func serialize() -> Dictionary:
	return relationships.duplicate(true)

func deserialize(data: Dictionary) -> void:
	relationships = data.duplicate(true)
