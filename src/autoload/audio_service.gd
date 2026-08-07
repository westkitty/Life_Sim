extends Node

var enabled := true
var master_gain_db := -7.0
var music_gain_db := -15.0
var current_music_mode := ""
var _music_player: AudioStreamPlayer

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	add_child(_music_player)
	EventBus.notification_posted.connect(_on_notification_posted)
	EventBus.save_completed.connect(_on_save_completed)
	EventBus.load_completed.connect(_on_load_completed)

func _on_notification_posted(_title: String, _body: String) -> void:
	play("ui_notification", -12.0)

func _on_save_completed(_path: String) -> void:
	play("save_complete", -9.0)

func _on_load_completed(_path: String) -> void:
	play("load_complete", -9.0)

func play(asset_id: String, gain_offset_db := 0.0) -> void:
	if not enabled:
		return
	var stream := AssetLibrary.audio_stream(asset_id)
	if stream == null:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = master_gain_db + gain_offset_db
	add_child(player)
	player.finished.connect(player.queue_free)
	# `finished` never fires when there is no audio device (headless, or a
	# machine with sound disabled), so a one-shot player is also reclaimed by a
	# timeout derived from the stream length. Without this, one-shot players
	# accumulate for the lifetime of the process.
	# The timer callback resolves the player by instance id rather than capturing
	# the node itself: when `finished` already freed it, a captured reference
	# would be a dangling lambda capture.
	var lifetime := maxf(stream.get_length(), 0.25) + 0.5
	var player_id := player.get_instance_id()
	get_tree().create_timer(lifetime).timeout.connect(func() -> void:
		var pending := instance_from_id(player_id)
		if pending is Node and is_instance_valid(pending):
			(pending as Node).queue_free())
	player.play()

func set_music_mode(mode_id: String) -> void:
	if current_music_mode == mode_id and _music_player != null and _music_player.playing:
		return
	current_music_mode = mode_id
	if _music_player == null:
		return
	var music_tracks := {
		"live": "music_live_loop",
		"build_buy": "music_build_loop",
		"cas": "music_cas_loop",
		"map": "music_live_loop",
	}
	var asset_id := String(music_tracks.get(mode_id, "music_live_loop"))
	var stream := AssetLibrary.audio_stream(asset_id)
	if stream == null:
		return
	_music_player.stop()
	_music_player.stream = stream
	_music_player.volume_db = master_gain_db + music_gain_db
	if not _music_player.finished.is_connected(_restart_music):
		_music_player.finished.connect(_restart_music)
	if enabled:
		_music_player.play()

func _restart_music() -> void:
	if _music_player != null and enabled and not current_music_mode.is_empty():
		_music_player.play()

func set_enabled(value: bool) -> void:
	enabled = value
	if _music_player != null:
		if enabled:
			set_music_mode(current_music_mode if not current_music_mode.is_empty() else "live")
		else:
			_music_player.stop()

func set_master_gain_db(value: float) -> void:
	master_gain_db = clampf(value, -40.0, 6.0)
	if _music_player != null:
		_music_player.volume_db = master_gain_db + music_gain_db
