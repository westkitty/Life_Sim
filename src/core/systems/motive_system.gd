class_name MotiveSystem
extends RefCounted

const MOTIVE_IDS: Array[String] = ["hunger", "bladder", "energy", "social", "fun", "hygiene"]
const DEFAULT_VALUES := {
	"hunger": 82.0,
	"bladder": 78.0,
	"energy": 76.0,
	"social": 72.0,
	"fun": 68.0,
	"hygiene": 80.0,
}
const DECAY_PER_SIM_HOUR := {
	"hunger": 3.6,
	"bladder": 4.2,
	"energy": 2.8,
	"social": 2.0,
	"fun": 2.4,
	"hygiene": 1.7,
}

static func make_default() -> Dictionary:
	return DEFAULT_VALUES.duplicate(true)

static func tick(motives: Dictionary, sim_minutes: float, modifiers: Dictionary = {}) -> void:
	var hours := sim_minutes / 60.0
	for motive_id in MOTIVE_IDS:
		var multiplier := float(modifiers.get(motive_id, 1.0))
		var decay := float(DECAY_PER_SIM_HOUR[motive_id]) * hours * multiplier
		motives[motive_id] = clampf(float(motives.get(motive_id, 50.0)) - decay, 0.0, 100.0)

static func apply_effects(motives: Dictionary, effects: Dictionary, scale: float = 1.0) -> void:
	for motive_id in effects.keys():
		motives[motive_id] = clampf(float(motives.get(motive_id, 50.0)) + float(effects[motive_id]) * scale, 0.0, 100.0)

static func lowest_motive(motives: Dictionary) -> String:
	var lowest_id := MOTIVE_IDS[0]
	var lowest_value := 101.0
	for motive_id in MOTIVE_IDS:
		var value := float(motives.get(motive_id, 50.0))
		if value < lowest_value:
			lowest_value = value
			lowest_id = motive_id
	return lowest_id

static func average(motives: Dictionary) -> float:
	var total := 0.0
	for motive_id in MOTIVE_IDS:
		total += float(motives.get(motive_id, 50.0))
	return total / float(MOTIVE_IDS.size())
