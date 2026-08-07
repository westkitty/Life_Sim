class_name SimProfile
extends RefCounted

var sim_id: String
var first_name: String
var last_name: String
var age_stage: String
var age_days: float
var traits: Array[String]
var favorites: Dictionary
var career_id: String
var career_level: int
var career_performance: float
var skills: Dictionary
var occult_states: Array[String]
var household_id: String
var biography: String
var genetics: Dictionary

func _init(data: Dictionary = {}) -> void:
	sim_id = String(data.get("sim_id", "sim_%s" % Time.get_ticks_usec()))
	first_name = String(data.get("first_name", "New"))
	last_name = String(data.get("last_name", "Sim"))
	age_stage = String(data.get("age_stage", "young_adult"))
	age_days = float(data.get("age_days", 0.0))
	traits = _to_string_array(data.get("traits", ["friendly", "neat", "bookworm", "ambitious", "good_sense_of_humor"]))
	favorites = Dictionary(data.get("favorites", {"food": "autumn_salad", "music": "indie", "color": "green"}))
	career_id = String(data.get("career_id", "unemployed"))
	career_level = int(data.get("career_level", 0))
	career_performance = float(data.get("career_performance", 0.0))
	skills = Dictionary(data.get("skills", {})).duplicate(true)
	occult_states = _to_string_array(data.get("occult_states", []))
	household_id = String(data.get("household_id", "household_founders"))
	biography = String(data.get("biography", ""))
	genetics = Dictionary(data.get("genetics", {})).duplicate(true)
	if genetics.is_empty():
		genetics = _default_genetics(sim_id)

func full_name() -> String:
	return "%s %s" % [first_name, last_name]

func to_dict() -> Dictionary:
	return {
		"sim_id": sim_id,
		"first_name": first_name,
		"last_name": last_name,
		"age_stage": age_stage,
		"age_days": age_days,
		"traits": traits,
		"favorites": favorites,
		"career_id": career_id,
		"career_level": career_level,
		"career_performance": career_performance,
		"skills": skills,
		"occult_states": occult_states,
		"household_id": household_id,
		"biography": biography,
		"genetics": genetics.duplicate(true),
	}

static func _to_string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item in value:
			result.append(String(item))
	return result

static func _default_genetics(id_value: String) -> Dictionary:
	var seed_value: int = absi(hash(id_value))
	var skin := ["light", "warm", "medium", "deep"]
	var hair := ["black", "brown", "auburn", "blonde"]
	var eyes := ["brown", "hazel", "green", "blue"]
	var shapes := ["slender", "average", "athletic", "soft"]
	return {
		"skin_tone": skin[seed_value % skin.size()],
		"hair_color": hair[int(seed_value / 3) % hair.size()],
		"eye_color": eyes[int(seed_value / 7) % eyes.size()],
		"body_shape": shapes[int(seed_value / 11) % shapes.size()],
		"voice_pitch": 0.85 + float(seed_value % 31) / 100.0,
	}
