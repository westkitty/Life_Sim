class_name PerformerSystem
extends Node

const PROFESSIONS := ["singer", "magician", "acrobat"]
var performers: Dictionary = {}
var gigs: Array[Dictionary] = []
var next_gig_index := 1

func join_profession(sim_id: String, profession_id: String) -> bool:
	if profession_id not in PROFESSIONS:
		return false
	performers[sim_id] = {"profession": profession_id, "level": 1, "experience": 0.0, "reputation": 0.0, "gigs_completed": 0}
	return true

func book_gig(sim_id: String, venue_id: String, day_index: int, hour := 19) -> String:
	if not performers.has(sim_id):
		return ""
	var gig_id := "gig_%04d" % next_gig_index
	next_gig_index += 1
	gigs.append({"id": gig_id, "sim_id": sim_id, "venue_id": venue_id, "day": day_index, "hour": hour, "status": "booked", "stage_quality": 0.5})
	return gig_id

func complete_gig(gig_id: String, performance_score := 0.65) -> Dictionary:
	for index in gigs.size():
		if String(gigs[index].get("id", "")) != gig_id:
			continue
		var gig: Dictionary = gigs[index]
		gig["status"] = "complete"
		gig["performance_score"] = clampf(performance_score, 0.0, 1.0)
		gigs[index] = gig
		var sim_id := String(gig.get("sim_id", ""))
		if performers.has(sim_id):
			var performer: Dictionary = performers[sim_id]
			performer["gigs_completed"] = int(performer.get("gigs_completed", 0)) + 1
			performer["experience"] = float(performer.get("experience", 0.0)) + performance_score * 25.0
			performer["reputation"] = clampf(float(performer.get("reputation", 0.0)) + performance_score * 5.0, -100.0, 100.0)
			performer["level"] = mini(10, 1 + int(float(performer["experience"]) / 100.0))
			performers[sim_id] = performer
		return gig.duplicate(true)
	return {}

func record_performance(sim_id: String, interaction_id: String) -> void:
	if not performers.has(sim_id):
		var profession := "singer"
		if interaction_id.contains("magic"): profession = "magician"
		elif interaction_id.contains("acrobat"): profession = "acrobat"
		join_profession(sim_id, profession)
	var performer: Dictionary = performers[sim_id]
	performer["experience"] = float(performer.get("experience", 0.0)) + 3.0
	performer["reputation"] = minf(100.0, float(performer.get("reputation", 0.0)) + 0.5)
	performers[sim_id] = performer

func serialize() -> Dictionary:
	return {"performers": performers.duplicate(true), "gigs": gigs.duplicate(true), "next_gig_index": next_gig_index}

func deserialize(data: Dictionary) -> void:
	performers = Dictionary(data.get("performers", {})).duplicate(true)
	gigs.clear()
	for entry in Array(data.get("gigs", [])):
		if entry is Dictionary:
			gigs.append(Dictionary(entry).duplicate(true))
	next_gig_index = maxi(1, int(data.get("next_gig_index", 1)))
