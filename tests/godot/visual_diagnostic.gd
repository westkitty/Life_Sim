extends Node

## Phase 2 rendering-pipeline isolation harness.
##
## Distinguishes: renderer/camera/world failure, procedural geometry failure,
## imported GLB failure, material/texture failure, transform/scale/AABB failure,
## and runtime parenting/visibility failure.
##
## Builds an explicit scene containing a procedural box, an object GLB, a house
## GLB, a Sim GLB and a textured plane, renders it with the real renderer, and
## reports measured facts about every bundled model.
##
## Run (never headless):
##   Godot --path . res://tests/godot/visual_diagnostic.tscn -- --shot=user://diag.png

const PROBE_IDS: Array[String] = ["fridge_basic", "house_founders", "sim_adult_average", "tree_deciduous"]

var _shot_path := "user://openlife_diagnostic.png"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--shot="):
			_shot_path = argument.substr(7)
	_run()

func _run() -> void:
	_build_scene()
	for _index in 30:
		await get_tree().process_frame
	_report_probe_scene()
	_report_all_models()
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	if image != null:
		image.save_png(_shot_path)
		print("DIAG_SHOT: %s" % _shot_path)
	print("DIAG_DONE")
	get_tree().quit(0)

func _build_scene() -> void:
	var root := Node3D.new()
	root.name = "DiagnosticWorld"
	add_child(root)

	var environment := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#20303c")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#ffffff")
	env.ambient_light_energy = 0.8
	environment.environment = env
	root.add_child(environment)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50.0, -35.0, 0.0)
	sun.light_energy = 1.2
	root.add_child(sun)

	# A: procedural geometry with a bright material.
	var box := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = Vector3(2.0, 2.0, 2.0)
	box.mesh = box_mesh
	var box_material := StandardMaterial3D.new()
	box_material.albedo_color = Color(1.0, 0.25, 0.15)
	box.material_override = box_material
	box.position = Vector3(-6.0, 1.0, 0.0)
	root.add_child(box)

	# B: bundled texture on a plane.
	var plane := MeshInstance3D.new()
	var plane_mesh := PlaneMesh.new()
	plane_mesh.size = Vector2(24.0, 24.0)
	plane.mesh = plane_mesh
	var plane_material := StandardMaterial3D.new()
	plane_material.albedo_color = Color(0.9, 0.9, 0.9)
	plane_material.albedo_texture = AssetLibrary.texture_asset("terrain_grass")
	plane_material.uv1_scale = Vector3(6.0, 6.0, 6.0)
	plane.material_override = plane_material
	plane.position = Vector3(0.0, 0.0, 0.0)
	root.add_child(plane)

	# C: imported GLB probes.
	var offset := -2.0
	for asset_id in PROBE_IDS:
		var instance := AssetLibrary.instantiate_model(asset_id)
		if instance == null:
			printerr("DIAG_PROBE_NULL: %s" % asset_id)
			continue
		instance.name = "Probe_%s" % asset_id
		instance.position = Vector3(offset, 0.0, 0.0)
		root.add_child(instance)
		offset += 4.0

	var camera := Camera3D.new()
	camera.name = "DiagnosticCamera"
	camera.current = true
	camera.fov = 55.0
	camera.near = 0.05
	camera.far = 500.0
	camera.position = Vector3(2.0, 8.0, 18.0)
	root.add_child(camera)
	camera.look_at(Vector3(2.0, 1.5, 0.0), Vector3.UP)

func _report_probe_scene() -> void:
	var camera := get_viewport().get_camera_3d()
	print("DIAG_CAMERA current=%s pos=%s cull_mask=%d near=%.2f far=%.1f" % [
		camera != null, camera.global_position if camera != null else Vector3.ZERO,
		camera.cull_mask if camera != null else -1,
		camera.near if camera != null else -1.0, camera.far if camera != null else -1.0])
	for node in _descendants(self):
		if node is MeshInstance3D:
			var mesh_instance: MeshInstance3D = node
			print("DIAG_MESH %s mesh=%s surfaces=%d visible=%s layers=%d aabb=%s" % [
				mesh_instance.name, mesh_instance.mesh != null,
				mesh_instance.mesh.get_surface_count() if mesh_instance.mesh != null else 0,
				mesh_instance.is_visible_in_tree(), mesh_instance.layers,
				mesh_instance.get_aabb()])

## Measures every bundled model the same way the runtime would use it.
func _report_all_models() -> void:
	var checked := 0
	var no_mesh := 0
	var degenerate := 0
	var tiny := 0
	var huge := 0
	var transparent := 0
	var min_size := INF
	var max_size := 0.0
	for asset_id in AssetLibrary.aliases.keys():
		var path := String(AssetLibrary.aliases[asset_id])
		if not path.ends_with(".glb"):
			continue
		var instance := AssetLibrary.instantiate_model(String(asset_id))
		if instance == null:
			printerr("DIAG_MODEL_NULL: %s" % asset_id)
			continue
		add_child(instance)
		checked += 1
		var report := AssetLibrary.validate_visual_instance(instance)
		var size: Vector3 = report.get("size", Vector3.ZERO)
		var longest := maxf(size.x, maxf(size.y, size.z))
		if int(report.get("mesh_count", 0)) == 0:
			no_mesh += 1
			printerr("DIAG_NO_MESH: %s" % asset_id)
		elif not bool(report.get("ok", false)):
			degenerate += 1
			printerr("DIAG_REJECTED: %s reason=%s" % [asset_id, report.get("reason", "")])
		else:
			min_size = minf(min_size, longest)
			max_size = maxf(max_size, longest)
			if longest < 0.05:
				tiny += 1
				printerr("DIAG_TINY: %s longest=%.5f" % [asset_id, longest])
			elif longest > 60.0:
				huge += 1
				printerr("DIAG_HUGE: %s longest=%.2f" % [asset_id, longest])
		if bool(report.get("fully_transparent", false)):
			transparent += 1
			printerr("DIAG_TRANSPARENT: %s" % asset_id)
		remove_child(instance)
		instance.queue_free()
	print("DIAG_MODELS checked=%d no_mesh=%d degenerate=%d tiny=%d huge=%d transparent=%d min_longest=%.3f max_longest=%.3f" % [
		checked, no_mesh, degenerate, tiny, huge, transparent,
		0.0 if min_size == INF else min_size, max_size])

func _descendants(root: Node) -> Array[Node]:
	var result: Array[Node] = []
	for child in root.get_children():
		result.append(child)
		result.append_array(_descendants(child))
	return result
