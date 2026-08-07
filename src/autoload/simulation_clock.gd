extends Node

signal minute_advanced(total_minutes: int, day_index: int, hour: int, minute: int)
signal day_advanced(day_index: int)
signal speed_changed(mode: int)

enum SpeedMode { PAUSED, NORMAL, FAST, ULTRA }

const MINUTES_PER_REAL_SECOND := {
	SpeedMode.PAUSED: 0.0,
	SpeedMode.NORMAL: 1.0,
	SpeedMode.FAST: 6.0,
	SpeedMode.ULTRA: 24.0,
}

var speed_mode: int = SpeedMode.NORMAL
var elapsed_sim_minutes: float = 0.0
var start_hour: int = 8
var _last_emitted_minute: int = -1
var _last_emitted_day: int = -1

func _ready() -> void:
	# Day bookkeeping starts already aligned with the current day so that the
	# first emitted minute cannot re-announce day 0 after explicit day-0
	# initialization performed by the main scene.
	_last_emitted_day = current_day()

func _process(delta: float) -> void:
	var rate: float = MINUTES_PER_REAL_SECOND.get(speed_mode, 0.0)
	if rate <= 0.0:
		return
	elapsed_sim_minutes += delta * rate
	var whole_minute := int(floor(elapsed_sim_minutes))
	if whole_minute == _last_emitted_minute:
		return
	for minute_index in range(_last_emitted_minute + 1, whole_minute + 1):
		if minute_index < 0:
			continue
		_emit_minute(minute_index)
	_last_emitted_minute = whole_minute

func _emit_minute(minute_index: int) -> void:
	var absolute_minutes := start_hour * 60 + minute_index
	var day_index := int(absolute_minutes / 1440)
	var hour := int(absolute_minutes / 60) % 24
	var minute := absolute_minutes % 60
	minute_advanced.emit(minute_index, day_index, hour, minute)
	if day_index != _last_emitted_day:
		_last_emitted_day = day_index
		day_advanced.emit(day_index)

func set_speed(mode: int) -> void:
	speed_mode = clampi(mode, SpeedMode.PAUSED, SpeedMode.ULTRA)
	speed_changed.emit(speed_mode)

func toggle_pause() -> void:
	set_speed(SpeedMode.NORMAL if speed_mode == SpeedMode.PAUSED else SpeedMode.PAUSED)

func current_total_minutes() -> int:
	return int(elapsed_sim_minutes)

func current_absolute_minutes() -> int:
	return start_hour * 60 + int(elapsed_sim_minutes)

func current_day() -> int:
	return int((start_hour * 60 + int(elapsed_sim_minutes)) / 1440)

func current_hour() -> int:
	return int((start_hour * 60 + int(elapsed_sim_minutes)) / 60) % 24

func current_minute() -> int:
	return (start_hour * 60 + int(elapsed_sim_minutes)) % 60

func formatted_time() -> String:
	return "Day %d  %02d:%02d" % [current_day() + 1, current_hour(), current_minute()]

func serialize() -> Dictionary:
	return {
		"elapsed_sim_minutes": elapsed_sim_minutes,
		"start_hour": start_hour,
		"speed_mode": speed_mode,
	}

func deserialize(data: Dictionary) -> void:
	elapsed_sim_minutes = float(data.get("elapsed_sim_minutes", 0.0))
	start_hour = int(data.get("start_hour", 8))
	speed_mode = int(data.get("speed_mode", SpeedMode.NORMAL))
	_last_emitted_minute = int(floor(elapsed_sim_minutes))
	_last_emitted_day = current_day()
	speed_changed.emit(speed_mode)
