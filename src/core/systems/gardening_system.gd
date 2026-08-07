class_name GardeningSystem
extends Node

const SPECIES := {"lettuce": 3.0, "tomato": 4.0, "apple": 6.0, "grape": 5.0, "life_fruit": 10.0}
var plants: Dictionary = {}
var next_plant_id := 1

func plant(owner_sim_id: String, species: String, position: Vector3) -> Dictionary:
	if not SPECIES.has(species):
		return {}
	var plant_id := "plant_%04d" % next_plant_id
	next_plant_id += 1
	plants[plant_id] = {"species": species, "owner_sim_id": owner_sim_id, "position": [position.x, position.y, position.z], "growth_days": 0.0, "water": 100.0, "quality": 0.0, "harvest_ready": false, "alive": true}
	return {"plant_id": plant_id, "species": species}

func tick_day() -> void:
	for plant_id in plants.keys():
		var state: Dictionary = plants[plant_id]
		if not bool(state.get("alive", true)):
			continue
		state["growth_days"] = float(state.get("growth_days", 0.0)) + 1.0
		state["water"] = float(state.get("water", 100.0)) - 20.0
		if float(state["water"]) <= 0.0:
			state["alive"] = false
		state["harvest_ready"] = float(state.get("growth_days", 0.0)) >= float(SPECIES.get(String(state.get("species", "lettuce")), 3.0))
		plants[plant_id] = state

func water(plant_id: String) -> bool:
	if not plants.has(plant_id):
		return false
	var state: Dictionary = plants[plant_id]
	state["water"] = 100.0
	plants[plant_id] = state
	return true

func harvest(plant_id: String) -> Dictionary:
	if not plants.has(plant_id):
		return {}
	var state: Dictionary = plants[plant_id]
	if not bool(state.get("harvest_ready", false)) or not bool(state.get("alive", true)):
		return {}
	state["harvest_ready"] = false
	state["growth_days"] = maxf(float(state.get("growth_days", 0.0)) - 2.0, 0.0)
	plants[plant_id] = state
	return {"id": String(state.get("species", "produce")), "name": String(state.get("species", "produce")).capitalize(), "quantity": 3, "quality": float(state.get("quality", 0.0))}

func serialize() -> Dictionary:
	return {"plants": plants.duplicate(true), "next_plant_id": next_plant_id}

func deserialize(data: Dictionary) -> void:
	plants = Dictionary(data.get("plants", {})).duplicate(true)
	next_plant_id = int(data.get("next_plant_id", 1))
