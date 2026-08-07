class_name FishingSystem
extends Node

const FISH := {
	"minnow": {"difficulty": 1, "value": 8}, "trout": {"difficulty": 2, "value": 24},
	"salmon": {"difficulty": 4, "value": 55}, "anglerfish": {"difficulty": 7, "value": 140},
	"deathfish": {"difficulty": 10, "value": 650},
}
const DEFAULT_SEED := 771903
var catches: Dictionary = {}
## System-owned deterministic RNG. Catch selection must never depend on
## wall-clock time, so save/replay stays reproducible.
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = DEFAULT_SEED

func catch_fish(profile: SimProfile, _bait_id := "") -> Dictionary:
	var level := int(Dictionary(profile.skills.get("fishing", {})).get("level", 0))
	var eligible: Array[String] = []
	for fish_id in FISH.keys():
		if int(FISH[fish_id]["difficulty"]) <= level + 2:
			eligible.append(String(fish_id))
	if eligible.is_empty():
		eligible.append("minnow")
	var fish_id := eligible[rng.randi_range(0, eligible.size() - 1)]
	catches[fish_id] = int(catches.get(fish_id, 0)) + 1
	return {"id": fish_id, "name": fish_id.capitalize(), "quantity": 1, "value": int(FISH[fish_id]["value"]), "kind": "fish"}

func serialize() -> Dictionary:
	return {"catches": catches.duplicate(true), "rng_seed": rng.seed, "rng_state": rng.state}

func deserialize(data: Dictionary) -> void:
	# Older saves stored the catch tally as the bare dictionary.
	if data.has("catches"):
		catches = Dictionary(data.get("catches", {})).duplicate(true)
		rng.seed = int(data.get("rng_seed", DEFAULT_SEED))
		rng.state = int(data.get("rng_state", rng.state))
	else:
		catches = data.duplicate(true)
