class_name CollectingSystem
extends Node

const COLLECTIBLES := {
	"iron": {"name": "Iron", "kind": "metal", "value": 25},
	"silver": {"name": "Silver", "kind": "metal", "value": 45},
	"quartz": {"name": "Quartz", "kind": "gem", "value": 55},
	"emerald": {"name": "Emerald", "kind": "gem", "value": 180},
	"monarch": {"name": "Monarch Butterfly", "kind": "insect", "value": 40},
	"rare_seed": {"name": "Rare Seed", "kind": "seed", "value": 75},
}
var collected_counts: Dictionary = {}

func collect(sim_id: String, collectible_id: String) -> Dictionary:
	if not COLLECTIBLES.has(collectible_id):
		return {}
	var key := "%s:%s" % [sim_id, collectible_id]
	collected_counts[key] = int(collected_counts.get(key, 0)) + 1
	var item: Dictionary = Dictionary(COLLECTIBLES[collectible_id]).duplicate(true)
	item["id"] = collectible_id
	item["quantity"] = 1
	return item

func serialize() -> Dictionary:
	return collected_counts.duplicate(true)

func deserialize(data: Dictionary) -> void:
	collected_counts = data.duplicate(true)
