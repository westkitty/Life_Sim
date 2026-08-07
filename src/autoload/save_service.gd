extends Node

const SAVE_VERSION := 3
const DEFAULT_SLOT := "user://openlife_slot_01.json"
const BACKUP_SUFFIX := ".bak"

func save_game(state: Dictionary, path: String = DEFAULT_SLOT) -> bool:
	var envelope := {
		"save_version": SAVE_VERSION,
		"project": "OpenLife",
		"saved_at_unix": int(Time.get_unix_time_from_system()),
		"state": state,
	}
	var text := JSON.stringify(envelope, "\t")
	var temp_path := path + ".tmp"
	var temp := FileAccess.open(temp_path, FileAccess.WRITE)
	if temp == null:
		EventBus.notify("Save failed", "Could not open the temporary save file for writing.")
		return false
	temp.store_string(text)
	temp.flush()
	temp.close()

	# The staged file must parse before it is allowed anywhere near the live slot.
	var verified: Variant = JSON.parse_string(FileAccess.get_file_as_string(temp_path))
	if not verified is Dictionary:
		_discard_temp(temp_path)
		EventBus.notify("Save failed", "The temporary save did not pass JSON verification.")
		return false

	# A verified backup of the previous slot is mandatory before replacement, so
	# an interrupted write always leaves one recoverable copy behind.
	if FileAccess.file_exists(path):
		var previous := FileAccess.get_file_as_string(path)
		var backup := FileAccess.open(path + BACKUP_SUFFIX, FileAccess.WRITE)
		if backup == null:
			_discard_temp(temp_path)
			EventBus.notify("Save failed", "Could not write the backup copy, so the existing slot was left untouched.")
			return false
		backup.store_string(previous)
		backup.flush()
		backup.close()

	# Same-directory rename is the atomic replacement step: the destination is
	# never left truncated by a partial copy.
	var absolute_temp := ProjectSettings.globalize_path(temp_path)
	var absolute_path := ProjectSettings.globalize_path(path)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(absolute_path)
	var rename_error := DirAccess.rename_absolute(absolute_temp, absolute_path)
	if rename_error != OK:
		_discard_temp(temp_path)
		EventBus.notify("Save failed", "The verified save could not replace the current slot.")
		return false
	EventBus.save_completed.emit(path)
	EventBus.notify("Game saved", "The current world was written locally. The previous slot is retained as a backup when available.")
	return true

func _discard_temp(temp_path: String) -> void:
	if FileAccess.file_exists(temp_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temp_path))

func load_game(path: String = DEFAULT_SLOT) -> Dictionary:
	var loaded := _load_envelope(path)
	if loaded.is_empty() and FileAccess.file_exists(path + BACKUP_SUFFIX):
		loaded = _load_envelope(path + BACKUP_SUFFIX)
		if not loaded.is_empty():
			EventBus.notify("Backup recovered", "The primary slot was unreadable, so OpenLife restored its local backup.")
	if loaded.is_empty():
		return {}
	var version := int(loaded.get("save_version", -1))
	var state := Dictionary(loaded.get("state", {}))
	if version == 1:
		state = _migrate_v1_to_v2(state)
		state = _migrate_v2_to_v3(state)
	elif version == 2:
		state = _migrate_v2_to_v3(state)
	elif version != SAVE_VERSION:
		EventBus.notify("Load failed", "The save format version is unsupported.")
		return {}
	EventBus.load_completed.emit(path)
	EventBus.notify("Game loaded", "The local save slot was restored.")
	return state

func _load_envelope(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed is Dictionary and String(parsed.get("project", "OpenLife")) == "OpenLife":
		return Dictionary(parsed)
	return {}

func _migrate_v1_to_v2(state: Dictionary) -> Dictionary:
	var migrated := state.duplicate(true)
	if not migrated.has("settings"):
		migrated["settings"] = {"audio_enabled": true, "grid_size": 1.0}
	return migrated

func _migrate_v2_to_v3(state: Dictionary) -> Dictionary:
	var migrated := state.duplicate(true)
	if not migrated.has("parity_systems"):
		migrated["parity_systems"] = {}
	return migrated

func has_save(path: String = DEFAULT_SLOT) -> bool:
	return FileAccess.file_exists(path) or FileAccess.file_exists(path + BACKUP_SUFFIX)
