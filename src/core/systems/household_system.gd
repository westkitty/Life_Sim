class_name HouseholdSystem
extends Node

var households: Dictionary = {}
var active_household_id := "household_founders"

func create_household(household_id: String, name: String, funds: int, sim_ids: Array[String], home_lot_id := "") -> void:
	households[household_id] = {
		"id": household_id,
		"name": name,
		"funds": funds,
		"sim_ids": sim_ids,
		"home_lot_id": home_lot_id,
	}

func active_household() -> Dictionary:
	return Dictionary(households.get(active_household_id, {}))

func funds() -> int:
	return int(active_household().get("funds", 0))

func household_funds(household_id: String) -> int:
	return int(Dictionary(households.get(household_id, {})).get("funds", 0))

func home_lot_id(household_id: String) -> String:
	return String(Dictionary(households.get(household_id, {})).get("home_lot_id", ""))

func household_for_sim(sim_id: String) -> String:
	for household_id in households.keys():
		if sim_id in Array(Dictionary(households[household_id]).get("sim_ids", [])):
			return String(household_id)
	return ""

func set_active_household(household_id: String) -> bool:
	if not households.has(household_id) or household_id == active_household_id:
		return false
	active_household_id = household_id
	EventBus.household_funds_changed.emit(funds())
	return true

func change_funds(delta: int) -> bool:
	return change_household_funds(active_household_id, delta)

## Credits or debits a specific household. Only the active household's balance
## drives the HUD, but every household keeps an independent, correct balance.
func change_household_funds(household_id: String, delta: int) -> bool:
	if not households.has(household_id):
		return false
	var household: Dictionary = Dictionary(households[household_id])
	var next_funds := int(household.get("funds", 0)) + delta
	if next_funds < 0:
		return false
	household["funds"] = next_funds
	households[household_id] = household
	if household_id == active_household_id:
		EventBus.household_funds_changed.emit(next_funds)
	return true

func serialize() -> Dictionary:
	return {"households": households, "active_household_id": active_household_id}

func deserialize(data: Dictionary) -> void:
	households = Dictionary(data.get("households", {})).duplicate(true)
	active_household_id = String(data.get("active_household_id", "household_founders"))
