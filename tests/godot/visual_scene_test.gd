extends Node

## Visual regression gate.
##
## This test exists because of a specific shipped defect: the project imported
## cleanly, every asset resolved, every static check passed, and the running game
## still showed labels instead of a world. Resource existence is NOT evidence of
## a rendered scene. This suite asserts that the *running* main scene contains
## real, visible render geometry, and that labels never outnumber the geometry
## they are supposed to annotate.
##
## Run as a scene (a real renderer is required for visibility to mean anything):
##   Godot --path . res://tests/godot/visual_scene_test.tscn

var failures: Array[String] = []
var checks := 0
var main: OpenLifeMain

func _ready() -> void:
	_run()

func _check(condition: bool, label: String) -> bool:
	checks += 1
	if not condition:
		failures.append(label)
	return condition

func _run() -> void:
	var packed: Resource = load("res://scenes/main.tscn")
	if not _check(packed is PackedScene, "main.tscn loads as PackedScene"):
		_finish()
		return
	var instance: Node = (packed as PackedScene).instantiate()
	if not _check(instance is OpenLifeMain, "main scene root is OpenLifeMain"):
		_finish()
		return
	main = instance
	add_child(main)
	for _index in 12:
		await get_tree().process_frame

	_test_camera_and_lighting()
	_test_world_terrain()
	_test_buildings()
	_test_nature()
	_test_sims_have_bodies()
	_test_objects_have_geometry()
	_test_geometry_outweighs_labels()
	_test_labels_annotate_geometry()
	_test_materials_and_textures()
	await _finish()

# ------------------------------------------------------------------ the checks

func _test_camera_and_lighting() -> void:
	var camera := get_viewport().get_camera_3d()
	if not _check(camera != null, "an active Camera3D exists"):
		return
	_check(camera.current, "the active camera is current")
	_check(camera.cull_mask & AssetLibrary.RENDER_LAYER_WORLD != 0, "camera cull mask includes the world render layer")
	_check(camera.near > 0.0 and camera.near < camera.far, "camera near/far range is sane")
	_check(camera.far >= 100.0, "camera far plane can reach across the neighborhood")
	# The camera must actually be looking at populated ground, not empty space.
	var target_distance := Vector2(camera.global_position.x, camera.global_position.z).length()
	_check(target_distance < 90.0, "camera is positioned within the world bounds")
	var lights := _nodes_of_type(main, "DirectionalLight3D")
	_check(lights.size() >= 1, "a DirectionalLight3D lights the scene")
	for light_node in lights:
		var light: DirectionalLight3D = light_node
		_check(light.is_visible_in_tree(), "directional light is visible in tree")
		_check(light.light_energy > 0.0, "directional light has non-zero energy")
	var environments := _nodes_of_type(main, "WorldEnvironment")
	if _check(environments.size() >= 1, "a WorldEnvironment is present"):
		var world_environment: WorldEnvironment = environments[0]
		_check(world_environment.environment != null, "WorldEnvironment carries an Environment resource")

func _test_world_terrain() -> void:
	var world := main.get_node_or_null("World")
	if not _check(world != null, "runtime World node exists under the main scene"):
		return
	_check(AssetLibrary.count_visible_meshes(world) >= 40, "the world contains a substantial amount of visible geometry")
	var ground := world.get_node_or_null("Ground")
	if not _check(ground != null, "Ground node exists"):
		return
	var ground_meshes := _visible_mesh_instances(ground)
	if not _check(ground_meshes.size() >= 1, "Ground has a visible MeshInstance3D"):
		return
	var aabb: AABB = ground_meshes[0].get_aabb()
	_check(aabb.size.x >= 90.0 and aabb.size.z >= 90.0, "terrain covers roughly the full 96x96 neighborhood")
	_check(absf(ground_meshes[0].global_position.y) < 2.0, "terrain sits near y=0 where the camera can see it")
	# Lots and roads must be visible too, not just bare terrain.
	for surface_name in ["NorthSouthRoad", "EastWestRoad", "FoundersLot", "CommunityPark"]:
		var node := world.get_node_or_null(surface_name)
		if _check(node != null, "world surface exists: %s" % surface_name):
			_check(_visible_mesh_instances(node).size() >= 1, "world surface renders: %s" % surface_name)

func _test_buildings() -> void:
	var world := main.get_node_or_null("World")
	if world == null:
		return
	var buildings := 0
	for building_name in ["FoundersHouse", "BlueHouse", "RoseHouse", "CommunityCenter", "CornerCafe", "CommunityHospital"]:
		var node := world.get_node_or_null(building_name)
		var mesh_node := node if node != null else world.get_node_or_null("%sMesh" % building_name)
		if mesh_node == null:
			failures.append("building missing entirely: %s" % building_name)
			checks += 1
			continue
		checks += 1
		var visible_meshes := _visible_mesh_instances(mesh_node)
		if visible_meshes.is_empty():
			failures.append("building has no visible geometry: %s" % building_name)
			continue
		buildings += 1
	_check(buildings >= 5, "at least five buildings render visible geometry")

func _test_nature() -> void:
	var world := main.get_node_or_null("World")
	if world == null:
		return
	var nature_meshes := 0
	for child in world.get_children():
		var child_name := String(child.name)
		if child_name.begins_with("Tree_") or child_name.begins_with("ParkShrub") or child_name.begins_with("ParkRocks"):
			nature_meshes += _visible_mesh_instances(child).size()
	_check(nature_meshes >= 12, "trees and environment dressing render visible geometry")

## The regression that shipped: a Sim existed as a floating name tag with no body.
func _test_sims_have_bodies() -> void:
	if not _check(main.sims.size() >= 5, "the default population spawned"):
		return
	for sim in main.sims:
		var body := sim.get_node_or_null("CharacterVisual")
		if not _check(body != null, "Sim %s has a CharacterVisual node" % sim.profile.sim_id):
			continue
		var meshes := _visible_mesh_instances(body)
		_check(meshes.size() >= 1, "Sim %s renders at least one visible mesh" % sim.profile.sim_id)
		if meshes.is_empty():
			continue
		var bounds := _combined_bounds(meshes)
		_check(bounds.size.y > 0.4, "Sim %s has a body with real height" % sim.profile.sim_id)
		_check(sim.global_position.y > -1.0, "Sim %s stands at or above ground level" % sim.profile.sim_id)
		var scale := sim.global_transform.basis.get_scale()
		_check(minf(scale.x, minf(scale.y, scale.z)) > 0.01, "Sim %s has a non-degenerate scale" % sim.profile.sim_id)

func _test_objects_have_geometry() -> void:
	if not _check(main.world_builder.objects.size() >= 15, "initial world objects spawned"):
		return
	var without_geometry: Array[String] = []
	for object in main.world_builder.objects:
		if _visible_mesh_instances(object).is_empty():
			without_geometry.append(object.catalog_id)
	_check(without_geometry.is_empty(),
		"every InteractableObject renders visible geometry (missing: %s)" % ", ".join(without_geometry))

## A world made of text is the exact symptom this gate protects against.
func _test_geometry_outweighs_labels() -> void:
	var visible_meshes := AssetLibrary.count_visible_meshes(main)
	var labels := _nodes_of_type(main, "Label3D").size()
	_check(visible_meshes >= 150, "the running scene contains a large amount of visible geometry (%d)" % visible_meshes)
	_check(labels == 0 or visible_meshes > labels * 3,
		"visible geometry substantially outnumbers 3D labels (%d meshes vs %d labels)" % [visible_meshes, labels])
	var surfaces := 0
	for node in _nodes_of_type(main, "MeshInstance3D"):
		var mesh_instance: MeshInstance3D = node
		if mesh_instance.mesh != null and mesh_instance.is_visible_in_tree():
			surfaces += mesh_instance.mesh.get_surface_count()
	_check(surfaces >= 150, "visible meshes expose a healthy number of surfaces (%d)" % surfaces)

## Labels must be attached to something visible and must not be drawn as an
## always-on-top, constant-screen-size overlay covering the world.
func _test_labels_annotate_geometry() -> void:
	var bad_depth := 0
	var bad_fixed := 0
	var orphaned := 0
	for node in _nodes_of_type(main, "Label3D"):
		var label: Label3D = node
		if label.no_depth_test:
			bad_depth += 1
		if label.fixed_size:
			bad_fixed += 1
		var owner_node := label.get_parent()
		if owner_node == null or AssetLibrary.count_visible_meshes(owner_node) == 0:
			orphaned += 1
	_check(bad_depth == 0, "no Label3D draws through world geometry (%d offenders)" % bad_depth)
	_check(bad_fixed == 0, "no Label3D renders at constant screen size regardless of distance (%d offenders)" % bad_fixed)
	_check(orphaned == 0, "no Label3D floats without visible geometry on its owner (%d offenders)" % orphaned)

func _test_materials_and_textures() -> void:
	var world := main.get_node_or_null("World")
	if world == null:
		return
	var textured_surfaces := 0
	var transparent_surfaces := 0
	for node in _nodes_of_type(world, "MeshInstance3D"):
		var mesh_instance: MeshInstance3D = node
		if mesh_instance.mesh == null or not mesh_instance.is_visible_in_tree():
			continue
		for surface in mesh_instance.mesh.get_surface_count():
			var material := mesh_instance.get_active_material(surface)
			if material is StandardMaterial3D:
				var standard: StandardMaterial3D = material
				if standard.albedo_texture != null:
					textured_surfaces += 1
				if standard.albedo_color.a <= 0.02:
					transparent_surfaces += 1
	_check(textured_surfaces >= 3, "bundled textures are applied to world surfaces (%d textured surfaces)" % textured_surfaces)
	_check(transparent_surfaces == 0, "no world surface is fully transparent (%d offenders)" % transparent_surfaces)
	var stats := AssetLibrary.validation_stats()
	print("VISUAL_ASSET_STATS accepted=%d rejected=%d" % [int(stats.get("accepted", 0)), int(stats.get("rejected", 0))])

# ------------------------------------------------------------------- utilities

func _nodes_of_type(root: Node, type_name: String) -> Array[Node]:
	var result: Array[Node] = []
	if root.is_class(type_name):
		result.append(root)
	for child in root.get_children():
		result.append_array(_nodes_of_type(child, type_name))
	return result

func _visible_mesh_instances(root: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	for node in _nodes_of_type(root, "MeshInstance3D"):
		var mesh_instance: MeshInstance3D = node
		if mesh_instance.mesh != null and mesh_instance.mesh.get_surface_count() > 0 and mesh_instance.is_visible_in_tree():
			result.append(mesh_instance)
	return result

func _combined_bounds(meshes: Array[MeshInstance3D]) -> AABB:
	var combined := AABB()
	var have := false
	for mesh_instance in meshes:
		var world_aabb := mesh_instance.global_transform * mesh_instance.get_aabb()
		combined = world_aabb if not have else combined.merge(world_aabb)
		have = true
	return combined

func _finish() -> void:
	if main != null and is_instance_valid(main):
		remove_child(main)
		main.free()
		main = null
	for _index in 4:
		await get_tree().process_frame
	if failures.is_empty():
		print("OPENLIFE_VISUAL_PASS: %d checks" % checks)
		get_tree().quit(0)
	else:
		for failure in failures:
			printerr("OPENLIFE_VISUAL_FAIL: %s" % failure)
		printerr("OPENLIFE_VISUAL_SUMMARY: %d of %d checks failed" % [failures.size(), checks])
		get_tree().quit(1)
