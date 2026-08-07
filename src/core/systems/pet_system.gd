class_name PetSystem
extends Node

const SPECIES := ["dog", "cat", "horse"]
var pets: Dictionary = {}
var next_pet_index := 1

func register_pet(species: String, name: String, household_id: String, owner_sim_id := "") -> String:
	if species not in SPECIES:
		return ""
	var pet_id := "pet_%s_%04d" % [species, next_pet_index]
	next_pet_index += 1
	pets[pet_id] = {
		"id": pet_id,
		"species": species,
		"name": name,
		"household_id": household_id,
		"owner_sim_id": owner_sim_id,
		"age_stage": "adult",
		"age_days": 0.0,
		"traits": _default_traits(species),
		"motives": {"hunger": 82.0, "energy": 75.0, "social": 72.0, "fun": 68.0, "bladder": 80.0},
		"training": {"obedience": 0, "hunting": 0, "racing": 0, "jumping": 0},
		"relationships": {},
		"genetics": {"coat_family": species + "_natural", "size": "medium"},
	}
	return pet_id

func ensure_seed_household(household_id: String, owner_sim_id: String) -> void:
	for pet in pets.values():
		if String(Dictionary(pet).get("household_id", "")) == household_id:
			return
	register_pet("dog", "Copper", household_id, owner_sim_id)
	register_pet("cat", "Miso", household_id, owner_sim_id)
	register_pet("horse", "Juniper", household_id, owner_sim_id)

func tick(sim_minutes: float) -> void:
	for pet_id in pets.keys():
		var pet: Dictionary = pets[pet_id]
		var motives: Dictionary = pet.get("motives", {})
		for motive_id in motives.keys():
			var rate := 0.020
			if motive_id == "hunger": rate = 0.035
			elif motive_id == "energy": rate = 0.026
			motives[motive_id] = clampf(float(motives[motive_id]) - rate * sim_minutes, 0.0, 100.0)
		pet["motives"] = motives
		pet["age_days"] = float(pet.get("age_days", 0.0)) + sim_minutes / 1440.0
		pets[pet_id] = pet

func interact(pet_id: String, interaction_id: String, actor_sim_id := "") -> Dictionary:
	if not pets.has(pet_id):
		return {}
	var pet: Dictionary = pets[pet_id]
	var motives: Dictionary = pet.get("motives", {})
	var training: Dictionary = pet.get("training", {})
	match interaction_id:
		"feed_pet": motives["hunger"] = minf(100.0, float(motives.get("hunger", 50.0)) + 45.0)
		"play_pet": motives["fun"] = minf(100.0, float(motives.get("fun", 50.0)) + 28.0)
		"socialize_pet": motives["social"] = minf(100.0, float(motives.get("social", 50.0)) + 30.0)
		"train_pet": training["obedience"] = mini(10, int(training.get("obedience", 0)) + 1)
		"train_hunting": training["hunting"] = mini(10, int(training.get("hunting", 0)) + 1)
		"train_racing": training["racing"] = mini(10, int(training.get("racing", 0)) + 1)
		"train_jumping": training["jumping"] = mini(10, int(training.get("jumping", 0)) + 1)
		_: return {}
	if not actor_sim_id.is_empty():
		var relationships: Dictionary = pet.get("relationships", {})
		relationships[actor_sim_id] = minf(100.0, float(relationships.get(actor_sim_id, 0.0)) + 4.0)
		pet["relationships"] = relationships
	pet["motives"] = motives
	pet["training"] = training
	pets[pet_id] = pet
	return pet.duplicate(true)

func breed(first_pet_id: String, second_pet_id: String) -> String:
	if not pets.has(first_pet_id) or not pets.has(second_pet_id):
		return ""
	var first: Dictionary = pets[first_pet_id]
	var second: Dictionary = pets[second_pet_id]
	if String(first.get("species", "")) != String(second.get("species", "")):
		return ""
	var species := String(first.get("species", "dog"))
	var child_id := register_pet(species, "New %s" % species.capitalize(), String(first.get("household_id", "")), String(first.get("owner_sim_id", "")))
	var child: Dictionary = pets[child_id]
	child["age_stage"] = "young"
	child["genetics"] = {"coat_family": String(first.get("genetics", {}).get("coat_family", species + "_natural")), "size": String(second.get("genetics", {}).get("size", "medium"))}
	pets[child_id] = child
	return child_id

func _default_traits(species: String) -> Array[String]:
	match species:
		"dog": return ["friendly", "loyal"]
		"cat": return ["independent", "playful"]
		"horse": return ["agile", "brave"]
	return []

func serialize() -> Dictionary:
	return {"pets": pets.duplicate(true), "next_pet_index": next_pet_index}

func deserialize(data: Dictionary) -> void:
	pets = Dictionary(data.get("pets", {})).duplicate(true)
	next_pet_index = maxi(1, int(data.get("next_pet_index", 1)))
