class_name OpportunitySystem
extends Node

var active: Dictionary = {}
var completed: Dictionary = {}

func offer(profile: SimProfile, opportunity_id: String, title: String, interaction_ids: Array[String], reward := 250) -> bool:
	if active.has(profile.sim_id):
		return false
	active[profile.sim_id] = {"id": opportunity_id, "title": title, "interaction_ids": interaction_ids, "progress": 0, "target": maxi(interaction_ids.size(), 1), "reward": reward}
	return true

func record_interaction(profile: SimProfile, interaction: Dictionary) -> Dictionary:
	if not active.has(profile.sim_id):
		return {}
	var state: Dictionary = active[profile.sim_id]
	var valid_ids: Array = Array(state.get("interaction_ids", []))
	if not valid_ids.is_empty() and String(interaction.get("id", "")) not in valid_ids:
		return {}
	state["progress"] = int(state.get("progress", 0)) + 1
	if int(state["progress"]) >= int(state.get("target", 1)):
		active.erase(profile.sim_id)
		var list: Array = Array(completed.get(profile.sim_id, []))
		list.append(String(state.get("id", "opportunity")))
		completed[profile.sim_id] = list
		return state
	active[profile.sim_id] = state
	return {}

func serialize() -> Dictionary:
	return {"active": active.duplicate(true), "completed": completed.duplicate(true)}

func deserialize(data: Dictionary) -> void:
	active = Dictionary(data.get("active", {})).duplicate(true)
	completed = Dictionary(data.get("completed", {})).duplicate(true)
