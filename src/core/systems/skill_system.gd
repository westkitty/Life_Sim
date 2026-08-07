class_name SkillSystem
extends Node

const MAX_LEVEL := 10

func add_progress(profile: SimProfile, skill_id: String, points: float) -> Dictionary:
	var record: Dictionary = Dictionary(profile.skills.get(skill_id, {"level": 0, "points": 0.0}))
	record["points"] = float(record.get("points", 0.0)) + maxf(points, 0.0)
	var level := int(record.get("level", 0))
	while level < MAX_LEVEL and float(record["points"]) >= points_for_next_level(level):
		record["points"] = float(record["points"]) - points_for_next_level(level)
		level += 1
		record["level"] = level
		EventBus.notify("Skill improved", "%s reached level %d in %s." % [profile.full_name(), level, skill_id.capitalize()])
	profile.skills[skill_id] = record
	return record

func points_for_next_level(level: int) -> float:
	return 100.0 + pow(float(level), 1.65) * 85.0
