class_name PregnancySystem
extends Node

var pregnancies: Dictionary = {}
var next_pregnancy_id := 1
const DEFAULT_TERM_MINUTES := 3.0 * 24.0 * 60.0

func try_conceive(mother: SimProfile, father: SimProfile, chance := 0.75) -> bool:
	if mother == null or father == null or mother.sim_id == father.sim_id:
		return false
	if pregnancies.has(mother.sim_id):
		return false
	var rng := RandomNumberGenerator.new()
	rng.seed = abs(hash("%s|%s|%d" % [mother.sim_id, father.sim_id, next_pregnancy_id]))
	if rng.randf() > chance:
		return false
	pregnancies[mother.sim_id] = {
		"pregnancy_id": "pregnancy_%04d" % next_pregnancy_id,
		"mother_id": mother.sim_id,
		"father_id": father.sim_id,
		"elapsed_minutes": 0.0,
		"term_minutes": DEFAULT_TERM_MINUTES,
	}
	next_pregnancy_id += 1
	return true

func tick(sim_minutes: float) -> void:
	for mother_id in pregnancies.keys():
		var data: Dictionary = pregnancies[mother_id]
		data["elapsed_minutes"] = float(data.get("elapsed_minutes", 0.0)) + sim_minutes
		pregnancies[mother_id] = data

func collect_due() -> Array[Dictionary]:
	var due: Array[Dictionary] = []
	for mother_id in pregnancies.keys():
		var data: Dictionary = pregnancies[mother_id]
		if float(data.get("elapsed_minutes", 0.0)) >= float(data.get("term_minutes", DEFAULT_TERM_MINUTES)):
			due.append(data.duplicate(true))
	for entry in due:
		pregnancies.erase(String(entry.get("mother_id", "")))
	return due

func is_pregnant(sim_id: String) -> bool:
	return pregnancies.has(sim_id)

func serialize() -> Dictionary:
	return {"pregnancies": pregnancies.duplicate(true), "next_pregnancy_id": next_pregnancy_id}

func deserialize(data: Dictionary) -> void:
	pregnancies = Dictionary(data.get("pregnancies", {})).duplicate(true)
	next_pregnancy_id = int(data.get("next_pregnancy_id", 1))
