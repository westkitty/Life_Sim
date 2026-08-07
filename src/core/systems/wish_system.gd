class_name WishSystem
extends Node

const MAX_ACTIVE := 4
var active_wishes: Dictionary = {}
var lifetime_happiness: Dictionary = {}
var lifetime_wishes: Dictionary = {}

func ensure_sim(profile: SimProfile) -> void:
	if not active_wishes.has(profile.sim_id):
		active_wishes[profile.sim_id] = _default_wishes(profile)
	if not lifetime_happiness.has(profile.sim_id):
		lifetime_happiness[profile.sim_id] = 0
	if not lifetime_wishes.has(profile.sim_id):
		lifetime_wishes[profile.sim_id] = _default_lifetime_wish(profile)

func _default_wishes(profile: SimProfile) -> Array:
	var wishes: Array = [
		{"id": "improve_need", "name": "Take care of yourself", "points": 150, "kind": "need"},
		{"id": "socialize", "name": "Spend time with another Sim", "points": 200, "kind": "social"},
		{"id": "raise_skill", "name": "Practice a skill", "points": 250, "kind": "skill"},
	]
	if profile.career_id != "unemployed":
		wishes.append({"id": "career_progress", "name": "Make career progress", "points": 300, "kind": "career"})
	else:
		wishes.append({"id": "earn_money", "name": "Earn some money", "points": 200, "kind": "money"})
	return wishes.slice(0, MAX_ACTIVE)

func _default_lifetime_wish(profile: SimProfile) -> Dictionary:
	var focus := "master_a_skill"
	if "family_oriented" in profile.traits:
		focus = "build_a_thriving_family"
	elif "ambitious" in profile.traits:
		focus = "reach_the_top_of_a_career"
	elif "artistic" in profile.traits or "virtuoso" in profile.traits:
		focus = "become_a_celebrated_creator"
	return {"id": focus, "progress": 0.0, "target": 1.0, "completed": false}

func record_interaction(profile: SimProfile, interaction: Dictionary) -> Array[String]:
	ensure_sim(profile)
	var kinds: Array[String] = []
	if not String(interaction.get("target_sim_id", "")).is_empty():
		kinds.append("social")
	if not String(interaction.get("skill_id", "")).is_empty():
		kinds.append("skill")
	if int(interaction.get("earnings", 0)) > 0:
		kinds.append("money")
	var positive_need := false
	for value in Dictionary(interaction.get("motive_effects", {})).values():
		if float(value) >= 10.0:
			positive_need = true
	if positive_need:
		kinds.append("need")
	var completed: Array[String] = []
	var kept: Array = []
	for wish_variant in Array(active_wishes.get(profile.sim_id, [])):
		var wish := Dictionary(wish_variant)
		if String(wish.get("kind", "")) in kinds:
			lifetime_happiness[profile.sim_id] = int(lifetime_happiness.get(profile.sim_id, 0)) + int(wish.get("points", 0))
			completed.append(String(wish.get("id", "")))
		else:
			kept.append(wish)
	active_wishes[profile.sim_id] = kept
	_refill(profile)
	return completed

func record_career_progress(profile: SimProfile, amount: float) -> void:
	if amount <= 0.0:
		return
	ensure_sim(profile)
	var kept: Array = []
	for wish_variant in Array(active_wishes.get(profile.sim_id, [])):
		var wish := Dictionary(wish_variant)
		if String(wish.get("kind", "")) == "career":
			lifetime_happiness[profile.sim_id] = int(lifetime_happiness.get(profile.sim_id, 0)) + int(wish.get("points", 0))
		else:
			kept.append(wish)
	active_wishes[profile.sim_id] = kept
	_refill(profile)

func _refill(profile: SimProfile) -> void:
	var current: Array = Array(active_wishes.get(profile.sim_id, []))
	var defaults := _default_wishes(profile)
	for candidate_variant in defaults:
		if current.size() >= MAX_ACTIVE:
			break
		var candidate := Dictionary(candidate_variant)
		if not current.any(func(item: Variant) -> bool: return String(Dictionary(item).get("id", "")) == String(candidate.get("id", ""))):
			current.append(candidate)
	active_wishes[profile.sim_id] = current

func serialize() -> Dictionary:
	return {"active": active_wishes.duplicate(true), "happiness": lifetime_happiness.duplicate(true), "lifetime": lifetime_wishes.duplicate(true)}

func deserialize(data: Dictionary) -> void:
	active_wishes = Dictionary(data.get("active", {})).duplicate(true)
	lifetime_happiness = Dictionary(data.get("happiness", {})).duplicate(true)
	lifetime_wishes = Dictionary(data.get("lifetime", {})).duplicate(true)
