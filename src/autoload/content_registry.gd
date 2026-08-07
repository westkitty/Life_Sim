extends Node

var packs: Array = []
var objects: Array = []
var careers: Array = []
var traits: Array = []
var features: Array = []
var _pack_lookup: Dictionary = {}
var _object_lookup: Dictionary = {}
var _career_lookup: Dictionary = {}
var _trait_lookup: Dictionary = {}

func _ready() -> void:
	reload_all()

func reload_all() -> void:
	packs = _load_array("res://data/pack_registry.json")
	objects = _load_array("res://data/object_catalog.json")
	careers = _load_array("res://data/career_catalog.json")
	traits = _load_array("res://data/trait_catalog.json")
	features = _load_array("res://data/feature_ledger.json")
	_pack_lookup = _index_by_id(packs)
	_object_lookup = _index_by_id(objects)
	_career_lookup = _index_by_id(careers)
	_trait_lookup = _index_by_id(traits)

func _load_array(path: String) -> Array:
	if not FileAccess.file_exists(path):
		push_error("Missing content file: %s" % path)
		return []
	var file := FileAccess.open(path, FileAccess.READ)
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Array:
		return parsed
	push_error("Content file is not a JSON array: %s" % path)
	return []

func _index_by_id(items: Array) -> Dictionary:
	var indexed := {}
	for item in items:
		if item is Dictionary and item.has("id"):
			indexed[String(item["id"])] = item
	return indexed

func get_pack(pack_id: String) -> Dictionary:
	return _pack_lookup.get(pack_id, {})

func get_object(object_id: String) -> Dictionary:
	return _object_lookup.get(object_id, {})

func get_career(career_id: String) -> Dictionary:
	return _career_lookup.get(career_id, {})

func get_trait(trait_id: String) -> Dictionary:
	return _trait_lookup.get(trait_id, {})

func enabled_packs() -> Array:
	return packs.filter(func(pack: Dictionary) -> bool: return bool(pack.get("enabled", true)))

func pack_count_by_type(pack_type: String) -> int:
	return packs.filter(func(pack: Dictionary) -> bool: return String(pack.get("type", "")) == pack_type).size()

func feature_status_counts() -> Dictionary:
	var counts := {}
	for feature in features:
		var status := String(feature.get("status", "unknown"))
		counts[status] = int(counts.get(status, 0)) + 1
	return counts
