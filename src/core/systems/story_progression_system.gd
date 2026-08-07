class_name StoryProgressionSystem
extends Node

var enabled := true
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = 3303

func advance_day(sim_agents: Array, active_household_id: String, relationship_system: RelationshipSystem) -> void:
	if not enabled:
		return
	var inactive: Array = sim_agents.filter(func(sim: SimAgent) -> bool: return sim.profile.household_id != active_household_id)
	for sim in inactive:
		_tick_inactive_sim(sim)
	if inactive.size() >= 2 and rng.randf() < 0.4:
		var first: SimAgent = inactive[rng.randi_range(0, inactive.size() - 1)]
		var second: SimAgent = inactive[rng.randi_range(0, inactive.size() - 1)]
		if first != second:
			relationship_system.adjust(first.profile.sim_id, second.profile.sim_id, rng.randf_range(-3.0, 7.0), rng.randf_range(-5.0, 10.0))

func _tick_inactive_sim(sim: SimAgent) -> void:
	for motive_id in MotiveSystem.MOTIVE_IDS:
		sim.motives[motive_id] = clampf(float(sim.motives.get(motive_id, 50.0)) + rng.randf_range(4.0, 12.0), 30.0, 100.0)
	if sim.profile.career_id != "unemployed":
		sim.profile.career_performance = clampf(sim.profile.career_performance + rng.randf_range(-2.0, 8.0), -100.0, 100.0)
