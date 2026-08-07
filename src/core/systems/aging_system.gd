class_name AgingSystem
extends Node

const STAGE_LENGTHS := {
	"baby": 3.0,
	"toddler": 7.0,
	"child": 7.0,
	"teen": 14.0,
	"young_adult": 21.0,
	"adult": 21.0,
	"elder": 28.0,
}
const NEXT_STAGE := {
	"baby": "toddler",
	"toddler": "child",
	"child": "teen",
	"teen": "young_adult",
	"young_adult": "adult",
	"adult": "elder",
	"elder": "elder",
}

var aging_enabled := true
var lifespan_multiplier := 1.0

func tick(profile: SimProfile, sim_minutes: float) -> void:
	if not aging_enabled:
		return
	profile.age_days += sim_minutes / 1440.0
	var length := float(STAGE_LENGTHS.get(profile.age_stage, 21.0)) * lifespan_multiplier
	if profile.age_days < length:
		return
	profile.age_days = 0.0
	var previous := profile.age_stage
	profile.age_stage = String(NEXT_STAGE.get(profile.age_stage, profile.age_stage))
	if previous != profile.age_stage:
		EventBus.notify("Birthday", "%s aged from %s to %s." % [profile.full_name(), previous.capitalize(), profile.age_stage.capitalize()])

func age_up(profile: SimProfile) -> bool:
	var previous := profile.age_stage
	profile.age_stage = String(NEXT_STAGE.get(profile.age_stage, profile.age_stage))
	profile.age_days = 0.0
	if previous != profile.age_stage:
		EventBus.notify("Birthday", "%s aged from %s to %s." % [profile.full_name(), previous.capitalize(), profile.age_stage.capitalize()])
		return true
	return false
