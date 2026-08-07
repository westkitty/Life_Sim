class_name WorldSystem
extends Node

var active_world_id := "founders_cove"
var active_lot_id := "lot_founders"
var worlds: Dictionary = {
	"founders_cove": {"type": "home", "name": "Founders Cove", "loaded": true},
	"travel_france": {"type": "travel", "name": "Champs-sur-Similaire", "loaded": false},
	"travel_egypt": {"type": "travel", "name": "Al Simhara Analog", "loaded": false},
	"travel_china": {"type": "travel", "name": "Shang Simla Analog", "loaded": false},
	"university": {"type": "university", "name": "OpenLife University", "loaded": false},
	"future": {"type": "future", "name": "Tomorrow Landing", "loaded": false},
}
var lots: Dictionary = {}
var placed_objects: Array[Dictionary] = []

func register_lot(lot_id: String, data: Dictionary) -> void:
	lots[lot_id] = data.duplicate(true)

func register_placed_object(data: Dictionary) -> void:
	placed_objects.append(data.duplicate(true))

func clear_placed_objects() -> void:
	placed_objects.clear()

func travel_to(world_id: String) -> bool:
	if not worlds.has(world_id):
		return false
	var previous_world: Dictionary = Dictionary(worlds[active_world_id])
	previous_world["loaded"] = false
	worlds[active_world_id] = previous_world
	active_world_id = world_id
	var next_world: Dictionary = Dictionary(worlds[active_world_id])
	next_world["loaded"] = true
	worlds[active_world_id] = next_world
	EventBus.notify("Travel", "Travelled to %s." % worlds[world_id]["name"])
	return true

func serialize() -> Dictionary:
	return {
		"active_world_id": active_world_id,
		"active_lot_id": active_lot_id,
		"worlds": worlds,
		"lots": lots,
		"placed_objects": placed_objects,
	}

func deserialize(data: Dictionary) -> void:
	active_world_id = String(data.get("active_world_id", "founders_cove"))
	active_lot_id = String(data.get("active_lot_id", "lot_founders"))
	worlds = Dictionary(data.get("worlds", worlds)).duplicate(true)
	lots = Dictionary(data.get("lots", {})).duplicate(true)
	var restored_objects: Array[Dictionary] = []
	for entry in Array(data.get("placed_objects", [])):
		if entry is Dictionary:
			restored_objects.append(Dictionary(entry).duplicate(true))
	placed_objects = restored_objects
