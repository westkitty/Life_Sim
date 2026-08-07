class_name PartySystem
extends Node

var active_parties: Dictionary = {}
var history: Array[Dictionary] = []
var next_party_id := 1

func start_party(host_sim_id: String, guest_ids: Array[String], party_type := "house_party") -> String:
	var party_id := "party_%04d" % next_party_id
	next_party_id += 1
	active_parties[party_id] = {"host_sim_id": host_sim_id, "guest_ids": guest_ids.duplicate(), "party_type": party_type, "score": 0.0, "elapsed_minutes": 0.0, "duration_minutes": 240.0}
	return party_id

func record_social(actor_id: String, target_id: String, delta: float) -> void:
	for party_id in active_parties.keys():
		var state: Dictionary = active_parties[party_id]
		var participants: Array = Array(state.get("guest_ids", []))
		participants.append(String(state.get("host_sim_id", "")))
		if actor_id in participants and target_id in participants:
			state["score"] = float(state.get("score", 0.0)) + delta
			active_parties[party_id] = state

func tick(sim_minutes: float) -> Array[Dictionary]:
	var ended: Array[Dictionary] = []
	for party_id in active_parties.keys():
		var state: Dictionary = active_parties[party_id]
		state["elapsed_minutes"] = float(state.get("elapsed_minutes", 0.0)) + sim_minutes
		if float(state["elapsed_minutes"]) >= float(state.get("duration_minutes", 240.0)):
			state["party_id"] = party_id
			state["outcome"] = "epic" if float(state.get("score", 0.0)) >= 60.0 else ("good" if float(state.get("score", 0.0)) >= 20.0 else "flat")
			ended.append(state.duplicate(true))
	for state in ended:
		active_parties.erase(String(state.get("party_id", "")))
		history.append(state)
	return ended

func serialize() -> Dictionary:
	return {"active": active_parties.duplicate(true), "history": history.duplicate(true), "next_party_id": next_party_id}

func deserialize(data: Dictionary) -> void:
	active_parties = Dictionary(data.get("active", {})).duplicate(true)
	history.assign(Array(data.get("history", [])))
	next_party_id = int(data.get("next_party_id", 1))
