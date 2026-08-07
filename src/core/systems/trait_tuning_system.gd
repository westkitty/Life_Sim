class_name TraitTuningSystem
extends Node

const RULES := {
	"ambitious": {"skills": ["logic", "charisma"], "tags": ["career", "study"], "weight": 8.0},
	"artistic": {"skills": ["painting", "sculpting", "guitar"], "tags": ["art", "music"], "weight": 11.0},
	"athletic": {"skills": ["athletic"], "tags": ["fitness"], "weight": 12.0},
	"bookworm": {"skills": ["writing", "logic"], "tags": ["books", "study"], "weight": 10.0},
	"computer_whiz": {"skills": ["logic", "writing"], "tags": ["computer", "electronics"], "weight": 12.0},
	"couch_potato": {"skills": [], "tags": ["television", "comfort"], "weight": 12.0},
	"family_oriented": {"skills": [], "tags": ["family", "baby", "social"], "weight": 12.0},
	"flirty": {"skills": [], "tags": ["romance", "flirt"], "weight": 13.0},
	"friendly": {"skills": ["charisma"], "tags": ["friendly", "social"], "weight": 10.0},
	"genius": {"skills": ["logic"], "tags": ["science", "chess", "study"], "weight": 12.0},
	"green_thumb": {"skills": ["gardening"], "tags": ["garden", "plant"], "weight": 15.0},
	"handy": {"skills": ["handiness", "inventing"], "tags": ["repair", "crafting"], "weight": 12.0},
	"loves_outdoors": {"skills": ["fishing", "gardening"], "tags": ["outdoor", "nature"], "weight": 10.0},
	"natural_cook": {"skills": ["cooking"], "tags": ["cooking", "food"], "weight": 15.0},
	"party_animal": {"skills": ["charisma"], "tags": ["party", "music", "social"], "weight": 12.0},
	"virtuoso": {"skills": ["guitar", "piano", "drums"], "tags": ["music", "performance"], "weight": 15.0},
	"angler": {"skills": ["fishing"], "tags": ["fishing"], "weight": 15.0},
	"neat": {"skills": [], "tags": ["clean", "laundry", "hygiene"], "weight": 9.0},
}

func score_interaction(profile: SimProfile, interaction: Dictionary, base_score: float) -> float:
	var score := base_score
	var tags := interaction_tags(interaction)
	var skill_id := String(interaction.get("skill_id", ""))
	for trait_id in profile.traits:
		var rule: Dictionary = Dictionary(RULES.get(trait_id, {}))
		if rule.is_empty():
			continue
		var weight := float(rule.get("weight", 0.0))
		if not skill_id.is_empty() and skill_id in Array(rule.get("skills", [])):
			score += weight
		for tag in Array(rule.get("tags", [])):
			if String(tag) in tags:
				score += weight * 0.65
	return score

func social_modifiers(actor: SimProfile, interaction_id: String) -> Dictionary:
	var result := {"long": 0.0, "short": 0.0, "romantic": 0.0}
	if interaction_id == "social_flirt" or interaction_id == "social_try_for_baby":
		if "flirty" in actor.traits:
			result["romantic"] = 5.0
		if "unflirty" in actor.traits:
			result["romantic"] = -7.0
	if interaction_id in ["social_chat", "social_compliment", "social_hug"] and "friendly" in actor.traits:
		result["long"] = 3.0
		result["short"] = 4.0
	if interaction_id == "social_joke" and "good_sense_of_humor" in actor.traits:
		result["short"] = 5.0
	if interaction_id == "social_argue" and "hot_headed" in actor.traits:
		result["short"] = -5.0
	return result

func motive_decay_modifier(profile: SimProfile, motive_id: String) -> float:
	var modifier := 1.0
	if motive_id == "energy" and "couch_potato" in profile.traits:
		modifier *= 0.90
	if motive_id == "fun" and "workaholic" in profile.traits:
		modifier *= 1.08
	if motive_id == "hygiene" and "slob" in profile.traits:
		modifier *= 0.82
	return modifier

func interaction_tags(interaction: Dictionary) -> Array[String]:
	var tags: Array[String] = []
	for tag in Array(interaction.get("tags", [])):
		tags.append(String(tag))
	var interaction_id := String(interaction.get("id", ""))
	var skill_id := String(interaction.get("skill_id", ""))
	if not skill_id.is_empty():
		tags.append(skill_id)
	for token in interaction_id.split("_"):
		if not token.is_empty():
			tags.append(token)
	return tags
