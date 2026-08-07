class_name CareerSystem
extends Node

func assign_career(profile: SimProfile, career_id: String) -> void:
	profile.career_id = career_id
	profile.career_level = 1 if career_id != "unemployed" else 0
	profile.career_performance = 0.0

## Advances career performance and returns the positive performance delta so
## callers (WishSystem) can credit career-wish progress from real work.
func tick_work(profile: SimProfile, sim_minutes: float, mood: float) -> float:
	if profile.career_id == "unemployed":
		return 0.0
	var mood_factor := lerpf(0.5, 1.5, clampf(mood / 100.0, 0.0, 1.0))
	var previous := profile.career_performance
	profile.career_performance = clampf(profile.career_performance + (sim_minutes / 60.0) * 2.5 * mood_factor, -100.0, 100.0)
	var delta := profile.career_performance - previous
	if profile.career_performance >= 100.0:
		profile.career_level += 1
		profile.career_performance = 0.0
		delta = maxf(delta, 1.0)
		EventBus.notify("Promotion", "%s advanced in the %s career." % [profile.full_name(), profile.career_id.capitalize()])
	return maxf(delta, 0.0)
