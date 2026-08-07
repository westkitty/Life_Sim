class_name ExpansionRuntimeSystem
extends Node

var state := {
	"EP01": {"visas": {}, "adventures_completed": {}, "nectar_batches": 0},
	"EP02": {"profession_jobs": {}, "inventions": 0, "sculptures": 0, "laundry_cycles": 0},
	"EP03": {"celebrity_points": {}, "gigs": {}, "club_visits": 0},
	"EP04": {"memories": {}, "prom_state": {}, "graduations": []},
	"EP05": {"pets": {}, "training": {}, "wildlife_seen": []},
	"EP06": {"gig_reputation": {}, "performances": 0, "simfest_entries": 0},
	"EP07": {"moon_day": 0, "moon_phase": "new_moon", "elixirs_brewed": 0, "duels": 0},
	"EP08": {"festival_visits": {}, "holidays": [], "exposure": {}},
	"EP09": {"enrollment": {}, "degrees": {}, "social_groups": {}},
	"EP10": {"resorts": {}, "islands_discovered": [], "dives": {}},
	"EP11": {"future_alignment": 0.0, "future_trips": {}, "plumbots": {}, "trait_chips": {}},
}

func record_interaction(profile: SimProfile, interaction: Dictionary) -> Dictionary:
	var interaction_id := String(interaction.get("id", ""))
	var special := String(interaction.get("special", ""))
	var pack_id := String(interaction.get("pack_id", ""))
	match interaction_id:
		"make_nectar": state["EP01"]["nectar_batches"] = int(state["EP01"].get("nectar_batches", 0)) + 1
		"invent": state["EP02"]["inventions"] = int(state["EP02"].get("inventions", 0)) + 1
		"sculpt": state["EP02"]["sculptures"] = int(state["EP02"].get("sculptures", 0)) + 1
		"do_laundry": state["EP02"]["laundry_cycles"] = int(state["EP02"].get("laundry_cycles", 0)) + 1
		"play_arcade": state["EP03"]["club_visits"] = int(state["EP03"].get("club_visits", 0)) + 1
		"brew_elixir": state["EP07"]["elixirs_brewed"] = int(state["EP07"].get("elixirs_brewed", 0)) + 1
		"manage_resort": _manage_resort(profile)
	if special == "memory_event":
		add_memory(profile.sim_id, String(interaction.get("name", interaction_id)))
	elif special == "festival_visit":
		var visits: Dictionary = state["EP08"]["festival_visits"]
		visits[profile.sim_id] = int(visits.get(profile.sim_id, 0)) + 1
		state["EP08"]["festival_visits"] = visits
	elif special == "university_credits":
		add_university_credits(profile.sim_id, int(interaction.get("credits", 3)), 3.0)
	elif special == "scuba_dive":
		var dives: Dictionary = state["EP10"]["dives"]
		dives[profile.sim_id] = int(dives.get(profile.sim_id, 0)) + 1
		state["EP10"]["dives"] = dives
	elif special == "future_travel":
		record_world_travel(profile, "future")
		state["EP11"]["future_alignment"] = clampf(float(state["EP11"].get("future_alignment", 0.0)) + 2.0, -100.0, 100.0)
	elif special == "dream_program":
		state["EP11"]["future_alignment"] = clampf(float(state["EP11"].get("future_alignment", 0.0)) + 0.5, -100.0, 100.0)
	elif special == "resort_management":
		_manage_resort(profile)
	elif special == "bot_charge":
		var bots: Dictionary = state["EP11"]["plumbots"]
		if bots.has(profile.sim_id):
			var bot: Dictionary = bots[profile.sim_id]
			bot["maintenance"] = 100.0
			bots[profile.sim_id] = bot
			state["EP11"]["plumbots"] = bots
	if pack_id == "EP03" or "performance" in Array(interaction.get("tags", [])):
		add_celebrity_points(profile.sim_id, 2)
	return {"pack_id": pack_id, "interaction_id": interaction_id}

func record_world_travel(profile: SimProfile, world_id: String) -> void:
	if world_id.begins_with("travel_"):
		var visas: Dictionary = state["EP01"]["visas"]
		var key := "%s:%s" % [profile.sim_id, world_id]
		visas[key] = mini(int(visas.get(key, 0)) + 1, 3)
		state["EP01"]["visas"] = visas
	elif world_id == "university":
		ensure_university_enrollment(profile.sim_id)
	elif world_id == "future":
		var trips: Dictionary = state["EP11"]["future_trips"]
		trips[profile.sim_id] = int(trips.get(profile.sim_id, 0)) + 1
		state["EP11"]["future_trips"] = trips

func add_memory(sim_id: String, title: String) -> void:
	var memories: Dictionary = state["EP04"]["memories"]
	var list: Array = Array(memories.get(sim_id, []))
	list.append({"title": title, "day": SimulationClock.current_day(), "minute": SimulationClock.current_total_minutes()})
	if list.size() > 100:
		list.pop_front()
	memories[sim_id] = list
	state["EP04"]["memories"] = memories

func add_celebrity_points(sim_id: String, amount: int) -> void:
	var points: Dictionary = state["EP03"]["celebrity_points"]
	points[sim_id] = maxi(0, int(points.get(sim_id, 0)) + amount)
	state["EP03"]["celebrity_points"] = points

func celebrity_level(sim_id: String) -> int:
	var points := int(Dictionary(state["EP03"]["celebrity_points"]).get(sim_id, 0))
	return mini(5, int(floor(sqrt(float(points) / 18.0))))

func ensure_university_enrollment(sim_id: String) -> void:
	var enrollment: Dictionary = state["EP09"]["enrollment"]
	if not enrollment.has(sim_id):
		enrollment[sim_id] = {"major": "undecided", "credits": 0, "term_days": 0, "gpa": 2.0}
	state["EP09"]["enrollment"] = enrollment

func add_university_credits(sim_id: String, credits: int, grade_points := 3.0) -> void:
	ensure_university_enrollment(sim_id)
	var enrollment: Dictionary = state["EP09"]["enrollment"]
	var entry: Dictionary = enrollment[sim_id]
	entry["credits"] = int(entry.get("credits", 0)) + credits
	entry["gpa"] = clampf((float(entry.get("gpa", 2.0)) + grade_points) * 0.5, 0.0, 4.0)
	enrollment[sim_id] = entry
	state["EP09"]["enrollment"] = enrollment

func register_plumbot(sim_id: String, trait_chips: Array[String]) -> void:
	var bots: Dictionary = state["EP11"]["plumbots"]
	bots[sim_id] = {"trait_chips": trait_chips.duplicate(), "maintenance": 100.0}
	state["EP11"]["plumbots"] = bots

func set_trait_chips(sim_id: String, chips: Array[String]) -> void:
	var chips_state: Dictionary = state["EP11"]["trait_chips"]
	chips_state[sim_id] = chips.duplicate()
	state["EP11"]["trait_chips"] = chips_state
	if Dictionary(state["EP11"]["plumbots"]).has(sim_id):
		var bots: Dictionary = state["EP11"]["plumbots"]
		var bot: Dictionary = bots[sim_id]
		bot["trait_chips"] = chips.duplicate()
		bots[sim_id] = bot
		state["EP11"]["plumbots"] = bots

func advance_day(day_index: int, weather: WeatherSystem) -> void:
	var phases := ["new_moon", "waxing_crescent", "first_quarter", "waxing_gibbous", "full_moon", "waning_gibbous", "last_quarter", "waning_crescent"]
	state["EP07"]["moon_day"] = day_index
	state["EP07"]["moon_phase"] = phases[day_index % phases.size()]
	var exposure: Dictionary = state["EP08"]["exposure"]
	for sim_id in exposure.keys():
		exposure[sim_id] = maxf(0.0, float(exposure[sim_id]) - 20.0)
	state["EP08"]["exposure"] = exposure
	for sim_id in Dictionary(state["EP09"]["enrollment"]).keys():
		var enrollment: Dictionary = state["EP09"]["enrollment"]
		var entry: Dictionary = enrollment[sim_id]
		entry["term_days"] = int(entry.get("term_days", 0)) + 1
		enrollment[sim_id] = entry
		state["EP09"]["enrollment"] = enrollment

func record_weather_exposure(sim_id: String, temperature_c: float, sim_minutes: float) -> float:
	var exposure: Dictionary = state["EP08"]["exposure"]
	var value := float(exposure.get(sim_id, 0.0))
	if temperature_c <= 0.0 or temperature_c >= 32.0:
		value = minf(100.0, value + sim_minutes * 0.22)
	else:
		value = maxf(0.0, value - sim_minutes * 0.30)
	exposure[sim_id] = value
	state["EP08"]["exposure"] = exposure
	return value

func _manage_resort(profile: SimProfile) -> void:
	var resorts: Dictionary = state["EP10"]["resorts"]
	var resort_id := "resort_%s" % profile.household_id
	var entry: Dictionary = Dictionary(resorts.get(resort_id, {"owner_household_id": profile.household_id, "rating": 1.0, "revenue": 0}))
	entry["rating"] = minf(5.0, float(entry.get("rating", 1.0)) + 0.05)
	entry["revenue"] = int(entry.get("revenue", 0)) + 180
	resorts[resort_id] = entry
	state["EP10"]["resorts"] = resorts

func serialize() -> Dictionary:
	return state.duplicate(true)

func deserialize(data: Dictionary) -> void:
	for pack_id in state.keys():
		if data.has(pack_id) and data[pack_id] is Dictionary:
			state[pack_id] = Dictionary(data[pack_id]).duplicate(true)
