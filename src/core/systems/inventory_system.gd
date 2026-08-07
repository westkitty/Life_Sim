class_name InventorySystem
extends Node

var personal: Dictionary = {}
var household: Dictionary = {}
var shared: Array = []

func add_personal(sim_id: String, item: Dictionary) -> void:
	var items: Array = Array(personal.get(sim_id, []))
	items.append(item.duplicate(true))
	personal[sim_id] = items

func add_household(household_id: String, item: Dictionary) -> void:
	var items: Array = Array(household.get(household_id, []))
	items.append(item.duplicate(true))
	household[household_id] = items

func remove_personal(sim_id: String, item_id: String) -> Dictionary:
	var items: Array = Array(personal.get(sim_id, []))
	for index in items.size():
		var item := Dictionary(items[index])
		if String(item.get("id", "")) == item_id:
			items.remove_at(index)
			personal[sim_id] = items
			return item
	return {}

func items_for_sim(sim_id: String) -> Array:
	return Array(personal.get(sim_id, [])).duplicate(true)

func serialize() -> Dictionary:
	return {"personal": personal.duplicate(true), "household": household.duplicate(true), "shared": shared.duplicate(true)}

func deserialize(data: Dictionary) -> void:
	personal = Dictionary(data.get("personal", {})).duplicate(true)
	household = Dictionary(data.get("household", {})).duplicate(true)
	shared = Array(data.get("shared", [])).duplicate(true)
