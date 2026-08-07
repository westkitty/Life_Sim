class_name MoodletSystem
extends Node

var moodlets: Dictionary = {}

func add(sim_id: String, moodlet_id: String, display_name: String, mood_value: int, duration_minutes: float, source := "system") -> void:
	var entries: Array = Array(moodlets.get(sim_id, []))
	var refreshed := false
	for index in entries.size():
		var entry: Dictionary = entries[index]
		if String(entry.get("id", "")) == moodlet_id:
			entry["remaining_minutes"] = maxf(float(entry.get("remaining_minutes", 0.0)), duration_minutes)
			entry["mood_value"] = mood_value
			entry["source"] = source
			entries[index] = entry
			refreshed = true
			break
	if not refreshed:
		entries.append({"id": moodlet_id, "name": display_name, "mood_value": mood_value, "remaining_minutes": duration_minutes, "source": source})
	moodlets[sim_id] = entries

func tick(sim_minutes: float) -> void:
	for sim_id in moodlets.keys():
		var kept: Array = []
		for entry_variant in Array(moodlets[sim_id]):
			var entry := Dictionary(entry_variant)
			entry["remaining_minutes"] = float(entry.get("remaining_minutes", 0.0)) - sim_minutes
			if float(entry["remaining_minutes"]) > 0.0:
				kept.append(entry)
		moodlets[sim_id] = kept

func total_mood(sim_id: String) -> int:
	var result := 0
	for entry_variant in Array(moodlets.get(sim_id, [])):
		result += int(Dictionary(entry_variant).get("mood_value", 0))
	return result

func entries_for(sim_id: String) -> Array:
	return Array(moodlets.get(sim_id, [])).duplicate(true)

func serialize() -> Dictionary:
	return moodlets.duplicate(true)

func deserialize(data: Dictionary) -> void:
	moodlets = data.duplicate(true)
