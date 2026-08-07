extends SceneTree

## Shallow engine-backed smoke test.
##
## This runs through `Godot --headless --script res://tests/godot/smoke_test.gd`.
## In that mode Godot replaces the main loop, so autoload *global identifiers*
## are not registered at compile time even though the autoload nodes themselves
## exist under the scene-tree root. Autoloads are therefore resolved by node
## lookup here. The deep suite in `integration_test.tscn` runs as a normal scene
## and uses the ordinary global names.

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _autoload(node_name: String) -> Object:
	return get_root().get_node_or_null(node_name)

func _run() -> void:
	var scene: Resource = load("res://scenes/main.tscn")
	if not scene is PackedScene:
		failures.append("main scene did not load as PackedScene")
		_finish()
		return
	var main: Node = (scene as PackedScene).instantiate()
	get_root().add_child(main)
	await process_frame
	await process_frame
	if main == null:
		failures.append("main scene did not instantiate")
	var asset_library := _autoload("AssetLibrary")
	var content_registry := _autoload("ContentRegistry")
	if asset_library == null or content_registry == null:
		failures.append("project autoloads were not created")
		_finish()
		return
	if not bool(asset_library.call("has_asset", "fridge_basic")):
		failures.append("generated fridge GLB is not importable through AssetLibrary")
	if asset_library.call("audio_stream", "ui_click") == null:
		failures.append("generated UI WAV is not importable through AssetLibrary")
	if int(content_registry.call("pack_count_by_type", "expansion")) != 11:
		failures.append("expansion registry count is not 11")
	if int(content_registry.call("pack_count_by_type", "stuff")) != 9:
		failures.append("stuff-pack registry count is not 9")
	if Array(content_registry.get("objects")).size() < 30:
		failures.append("Build/Buy catalog contains fewer than 30 objects")
	if main.get("sims") == null or Array(main.get("sims")).size() < 5:
		failures.append("default neighborhood population did not initialize")
	get_root().remove_child(main)
	main.free()
	_finish()

func _finish() -> void:
	if failures.is_empty():
		print("OPENLIFE_GODOT_SMOKE_PASS")
		quit(0)
	else:
		for failure in failures:
			printerr("OPENLIFE_SMOKE_FAIL: %s" % failure)
		quit(1)
