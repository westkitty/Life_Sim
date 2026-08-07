class_name DeathSystem
extends Node

## Sim-minutes a Sim can survive at zero hunger before starving.
const STARVATION_MINUTES := 720.0
## Days spent in the elder stage before natural death becomes possible.
const ELDER_LIFESPAN_DAYS := 26.0

var deceased: Dictionary = {}
var ghosts: Dictionary = {}
var starvation_minutes: Dictionary = {}

func is_deceased(sim_id: String) -> bool:
	return deceased.has(sim_id)

## Evaluates the clean-room mortality rules for one Sim-minute and returns a
## death record when a Sim dies, otherwise an empty dictionary.
func evaluate(profile: SimProfile, motives: Dictionary, sim_minutes: float) -> Dictionary:
	if deceased.has(profile.sim_id):
		return {}
	if float(motives.get("hunger", 100.0)) <= 0.0:
		var elapsed := float(starvation_minutes.get(profile.sim_id, 0.0)) + sim_minutes
		starvation_minutes[profile.sim_id] = elapsed
		if elapsed >= STARVATION_MINUTES:
			return record_death(profile, "starvation")
	else:
		starvation_minutes[profile.sim_id] = 0.0
	if profile.age_stage == "elder" and profile.age_days >= ELDER_LIFESPAN_DAYS:
		return record_death(profile, "old_age")
	return {}

func record_death(profile: SimProfile, death_type := "old_age") -> Dictionary:
	var record := {"sim_id": profile.sim_id, "name": profile.full_name(), "death_type": death_type, "urn_id": "urn_%s" % profile.sim_id, "ghost_enabled": true}
	deceased[profile.sim_id] = record
	ghosts[profile.sim_id] = {"death_type": death_type, "active": false, "color": _ghost_color(death_type)}
	return record

func set_ghost_active(sim_id: String, active: bool) -> void:
	if ghosts.has(sim_id):
		var state: Dictionary = ghosts[sim_id]
		state["active"] = active
		ghosts[sim_id] = state

func _ghost_color(death_type: String) -> String:
	return {"fire": "#ff6a4d", "drowning": "#4aa8dd", "electrocution": "#ffd54f", "starvation": "#b59a6a", "old_age": "#e9edf2"}.get(death_type, "#c4d8e8")

func serialize() -> Dictionary:
	return {
		"deceased": deceased.duplicate(true),
		"ghosts": ghosts.duplicate(true),
		"starvation_minutes": starvation_minutes.duplicate(true),
	}

func deserialize(data: Dictionary) -> void:
	deceased = Dictionary(data.get("deceased", {})).duplicate(true)
	ghosts = Dictionary(data.get("ghosts", {})).duplicate(true)
	starvation_minutes = Dictionary(data.get("starvation_minutes", {})).duplicate(true)
