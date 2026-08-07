class_name WeatherSystem
extends Node

const SEASONS: Array[String] = ["spring", "summer", "autumn", "winter"]
const WEATHER_STATES: Array[String] = ["clear", "cloudy", "rain", "storm", "fog", "snow", "hail"]

var enabled := true
var season_length_days := 7
var current_season := "spring"
var current_weather := "clear"
var temperature_c := 18.0
var day_in_season := 0
var rng := RandomNumberGenerator.new()
const DEFAULT_SEED := 20260806

func _ready() -> void:
	rng.seed = DEFAULT_SEED

func advance_day(day_index: int) -> void:
	if not enabled:
		current_weather = "clear"
		return
	day_in_season = day_index % season_length_days
	current_season = SEASONS[int(day_index / season_length_days) % SEASONS.size()]
	current_weather = _roll_weather(current_season)
	temperature_c = _temperature_for(current_season) + rng.randf_range(-5.0, 5.0)
	EventBus.notify("Weather", "%s, %.0f C — %s." % [current_season.capitalize(), temperature_c, current_weather.capitalize()])

func _roll_weather(season: String) -> String:
	var roll := rng.randf()
	match season:
		"winter":
			return "snow" if roll < 0.46 else ("cloudy" if roll < 0.76 else "clear")
		"spring":
			return "rain" if roll < 0.38 else ("storm" if roll < 0.48 else "clear")
		"summer":
			return "storm" if roll < 0.18 else ("clear" if roll < 0.82 else "cloudy")
		"autumn":
			return "rain" if roll < 0.34 else ("fog" if roll < 0.52 else "cloudy")
	return "clear"

func _temperature_for(season: String) -> float:
	return {"spring": 16.0, "summer": 27.0, "autumn": 12.0, "winter": -2.0}.get(season, 18.0)

func serialize() -> Dictionary:
	return {
		"enabled": enabled,
		"season_length_days": season_length_days,
		"current_season": current_season,
		"current_weather": current_weather,
		"temperature_c": temperature_c,
		"day_in_season": day_in_season,
		# RNG continuity is part of the save contract: weather after a load must
		# follow the same sequence as uninterrupted play.
		"rng_seed": rng.seed,
		"rng_state": rng.state,
	}

func deserialize(data: Dictionary) -> void:
	enabled = bool(data.get("enabled", true))
	season_length_days = int(data.get("season_length_days", 7))
	current_season = String(data.get("current_season", "spring"))
	current_weather = String(data.get("current_weather", "clear"))
	temperature_c = float(data.get("temperature_c", 18.0))
	day_in_season = int(data.get("day_in_season", 0))
	rng.seed = int(data.get("rng_seed", DEFAULT_SEED))
	rng.state = int(data.get("rng_state", rng.state))
