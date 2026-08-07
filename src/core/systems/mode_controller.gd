class_name ModeController
extends Node

## Single authority for game mode, clock speed policy, mode music, CAS panel
## visibility and gameplay-input gating. Every mode/speed/panel transition must
## go through this node so UI and simulation state cannot diverge.

signal mode_changed(mode_id: String)

const MODES: Array[String] = ["live", "build_buy", "cas", "map"]
const LIVE_MODE := "live"

var current_mode := LIVE_MODE
var hud: OpenLifeHUD
## Clock speed to restore when Live mode is re-entered.
var _live_speed: int = SimulationClock.SpeedMode.NORMAL

func configure(hud_ref: OpenLifeHUD) -> void:
	hud = hud_ref

## Applies the initial Live-mode policy without re-emitting a transition.
func initialize(speed_mode: int = SimulationClock.SpeedMode.NORMAL) -> void:
	current_mode = LIVE_MODE
	_live_speed = speed_mode
	SimulationClock.set_speed(speed_mode)
	AudioService.set_music_mode(LIVE_MODE)
	if hud != null:
		hud.set_mode(LIVE_MODE)
		hud.set_cas_visible(false)

func request_mode(mode_id: String) -> bool:
	if mode_id not in MODES:
		return false
	if current_mode == LIVE_MODE and mode_id != LIVE_MODE:
		_live_speed = SimulationClock.speed_mode
	current_mode = mode_id
	if hud != null:
		hud.set_mode(mode_id)
		hud.set_cas_visible(mode_id == "cas")
	AudioService.set_music_mode(mode_id)
	if mode_id == LIVE_MODE:
		SimulationClock.set_speed(_live_speed)
	else:
		# Build/Buy, CAS and map view must never leave the simulation running.
		SimulationClock.set_speed(SimulationClock.SpeedMode.PAUSED)
	mode_changed.emit(mode_id)
	EventBus.mode_changed.emit(mode_id)
	return true

## Speed changes are only honoured in Live mode; every other mode is pinned to
## paused by policy.
func request_speed(speed_mode: int) -> bool:
	if current_mode != LIVE_MODE:
		EventBus.notify("Speed unavailable", "Return to Live mode before changing simulation speed.")
		return false
	SimulationClock.set_speed(speed_mode)
	_live_speed = SimulationClock.speed_mode
	return true

func request_pause_toggle() -> bool:
	if current_mode != LIVE_MODE:
		return false
	SimulationClock.toggle_pause()
	_live_speed = SimulationClock.speed_mode
	return true

func is_live() -> bool:
	return current_mode == LIVE_MODE

## True while a text-entry Control owns keyboard focus; gameplay keys must be
## suppressed so typing in CAS cannot pan, rotate or pause the world.
func is_text_focused() -> bool:
	var viewport := get_viewport()
	if viewport == null:
		return false
	var focused := viewport.gui_get_focus_owner()
	return focused is LineEdit or focused is TextEdit

func is_gameplay_input_allowed() -> bool:
	return not is_text_focused()

func is_placement_input_allowed() -> bool:
	return current_mode == "build_buy" and is_gameplay_input_allowed()

func serialize() -> Dictionary:
	return {"mode": current_mode, "live_speed": _live_speed}

func deserialize(data: Dictionary) -> void:
	_live_speed = int(data.get("live_speed", SimulationClock.SpeedMode.NORMAL))
	request_mode(String(data.get("mode", LIVE_MODE)))
