class_name SocialSystem
extends Node

var trait_tuning: TraitTuningSystem

const DEFINITIONS := {
	"social_chat": {"name": "Chat", "long": 8.0, "short": 12.0, "romantic": 0.0, "effects": {"social": 30, "fun": 6}, "tags": ["friendly", "social"]},
	"social_joke": {"name": "Tell Joke", "long": 6.0, "short": 16.0, "romantic": 0.0, "effects": {"social": 24, "fun": 18}, "tags": ["social", "humor"]},
	"social_compliment": {"name": "Compliment", "long": 10.0, "short": 10.0, "romantic": 1.0, "effects": {"social": 24}, "tags": ["friendly", "social"]},
	"social_hug": {"name": "Friendly Hug", "long": 9.0, "short": 14.0, "romantic": 1.0, "effects": {"social": 28}, "tags": ["friendly", "social"]},
	"social_gossip": {"name": "Gossip", "long": 2.0, "short": 12.0, "romantic": 0.0, "effects": {"social": 20, "fun": 10}, "tags": ["social", "gossip"]},
	"social_flirt": {"name": "Flirt", "long": 5.0, "short": 10.0, "romantic": 12.0, "effects": {"social": 22, "fun": 10}, "tags": ["social", "romance", "flirt"]},
	"social_argue": {"name": "Argue", "long": -8.0, "short": -18.0, "romantic": 0.0, "effects": {"social": 6, "fun": -6}, "tags": ["social", "mean"]},
	"social_try_for_baby": {"name": "Try for Baby", "long": 8.0, "short": 10.0, "romantic": 18.0, "effects": {"social": 18, "fun": 16}, "tags": ["social", "romance", "family", "baby"], "special": "try_for_baby"},
}

func configure(tuning: TraitTuningSystem) -> void:
	trait_tuning = tuning

func build_interaction(actor: SimAgent, target: SimAgent, interaction_id: String) -> Dictionary:
	if not DEFINITIONS.has(interaction_id) or actor == null or target == null:
		return {}
	var data: Dictionary = Dictionary(DEFINITIONS[interaction_id])
	var modifiers := {"long": 0.0, "short": 0.0, "romantic": 0.0}
	if trait_tuning != null:
		modifiers = trait_tuning.social_modifiers(actor.profile, interaction_id)
	return {
		"id": interaction_id,
		"name": String(data["name"]),
		"duration_minutes": 28.0,
		"target_id": target.profile.sim_id,
		"target_sim_id": target.profile.sim_id,
		"target_name": target.profile.full_name(),
		"target_position": target.global_position + Vector3(1.1, 0.0, 0.0),
		"slot_candidates": _conversation_slots(target.global_position),
		"motive_effects": Dictionary(data["effects"]).duplicate(true),
		"relationship_long": float(data["long"]) + float(modifiers.get("long", 0.0)),
		"relationship_short": float(data["short"]) + float(modifiers.get("short", 0.0)),
		"relationship_romantic": float(data["romantic"]) + float(modifiers.get("romantic", 0.0)),
		"tags": Array(data.get("tags", [])).duplicate(),
		"special": String(data.get("special", "")),
	}

func _conversation_slots(target_position: Vector3) -> Array[Vector3]:
	return [
		target_position + Vector3(1.1, 0.0, 0.0),
		target_position + Vector3(-1.1, 0.0, 0.0),
		target_position + Vector3(0.0, 0.0, 1.1),
		target_position + Vector3(0.0, 0.0, -1.1),
	]

func menu_entries() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for interaction_id in DEFINITIONS.keys():
		var data: Dictionary = Dictionary(DEFINITIONS[interaction_id])
		result.append({"id": interaction_id, "name": data["name"], "long": data["long"], "short": data["short"], "romantic": data["romantic"]})
	return result
