class_name OccultSystem
extends Node

const OCCULT_TYPES: Array[String] = [
	"ghost", "mummy", "sim_bot", "vampire", "imaginary_friend", "unicorn", "genie",
	"witch", "werewolf", "fairy", "zombie", "alien", "plant_sim", "mermaid", "plumbot"
]

func add_occult(profile: SimProfile, occult_id: String) -> bool:
	if occult_id not in OCCULT_TYPES or occult_id in profile.occult_states:
		return false
	profile.occult_states.append(occult_id)
	EventBus.notify("Life state changed", "%s became a %s." % [profile.full_name(), occult_id.replace("_", " ")])
	return true

func remove_occult(profile: SimProfile, occult_id: String) -> bool:
	if occult_id not in profile.occult_states:
		return false
	profile.occult_states.erase(occult_id)
	return true

func has_occult(profile: SimProfile, occult_id: String) -> bool:
	return occult_id in profile.occult_states

func motive_decay_modifiers(profile: SimProfile) -> Dictionary:
	var modifiers := {}
	if "vampire" in profile.occult_states:
		modifiers["energy"] = 0.55
		modifiers["hunger"] = 0.8
	if "plumbot" in profile.occult_states or "sim_bot" in profile.occult_states:
		modifiers["hunger"] = 0.0
		modifiers["bladder"] = 0.0
		modifiers["hygiene"] = 0.35
	if "mermaid" in profile.occult_states:
		modifiers["hygiene"] = 1.4
	return modifiers
