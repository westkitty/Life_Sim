extends Node

## Rendered-screenshot harness.
##
## Loads the real main scene, lets it render for a number of frames with the
## actual (non-dummy) renderer, then writes the viewport image to disk.
##
## Run with a real rendering driver, never `--headless`:
##   Godot --path . res://tests/godot/visual_capture.tscn -- --shot=user://x.png
##
## The output path and frame count are read from the command line so the same
## harness can capture before/after evidence without editing the script.

var _shot_path := "user://openlife_capture.png"
var _frames := 90

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--shot="):
			_shot_path = argument.substr(7)
		elif argument.begins_with("--frames="):
			_frames = maxi(int(argument.substr(9)), 5)
	_run()

func _run() -> void:
	var packed: Resource = load("res://scenes/main.tscn")
	if not packed is PackedScene:
		printerr("VISUAL_CAPTURE_FAIL: main.tscn did not load as PackedScene")
		get_tree().quit(1)
		return
	var main: Node = (packed as PackedScene).instantiate()
	add_child(main)
	for _index in _frames:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	if image == null:
		printerr("VISUAL_CAPTURE_FAIL: viewport produced no image")
		get_tree().quit(1)
		return
	var error := image.save_png(_shot_path)
	if error != OK:
		printerr("VISUAL_CAPTURE_FAIL: could not write %s (error %d)" % [_shot_path, error])
		get_tree().quit(1)
		return
	print("VISUAL_CAPTURE_OK: %s (%dx%d)" % [_shot_path, image.get_width(), image.get_height()])
	print("VISUAL_CAPTURE_NONBLACK_RATIO: %.4f" % _non_background_ratio(image))
	get_tree().quit(0)

## Rough sanity signal: fraction of sampled pixels that differ from the very
## first pixel. A frame showing only a flat clear colour scores near zero.
func _non_background_ratio(image: Image) -> float:
	var reference := image.get_pixel(0, 0)
	var total := 0
	var different := 0
	var step := 4
	for y in range(0, image.get_height(), step):
		for x in range(0, image.get_width(), step):
			total += 1
			var pixel := image.get_pixel(x, y)
			var delta := absf(pixel.r - reference.r) + absf(pixel.g - reference.g) + absf(pixel.b - reference.b)
			if delta > 0.05:
				different += 1
	return 0.0 if total == 0 else float(different) / float(total)
