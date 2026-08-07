class_name BillSystem
extends Node

var balances: Dictionary = {}
var last_billed_day := -1
var billing_interval_days := 3

func assess_day(day_index: int, households: Dictionary, object_count: int) -> void:
	if day_index <= 0 or day_index == last_billed_day or day_index % billing_interval_days != 0:
		return
	last_billed_day = day_index
	for household_id in households.keys():
		var household: Dictionary = households[household_id]
		var funds := int(household.get("funds", 0))
		var assessment := maxi(75, int(round(float(funds) * 0.012)) + object_count * 2)
		balances[household_id] = int(balances.get(household_id, 0)) + assessment

func amount_due(household_id: String) -> int:
	return int(balances.get(household_id, 0))

func pay(household_id: String, amount_available: int) -> int:
	var due := amount_due(household_id)
	var payment := mini(due, maxi(amount_available, 0))
	balances[household_id] = due - payment
	return payment

func serialize() -> Dictionary:
	return {"balances": balances.duplicate(true), "last_billed_day": last_billed_day, "billing_interval_days": billing_interval_days}

func deserialize(data: Dictionary) -> void:
	balances = Dictionary(data.get("balances", {})).duplicate(true)
	last_billed_day = int(data.get("last_billed_day", -1))
	billing_interval_days = int(data.get("billing_interval_days", 3))
