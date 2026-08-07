class_name WorldBuilder
extends Node

var object_counter := 0
var objects: Array[InteractableObject] = []
var world_root: Node3D
var lot_definitions: Array[Dictionary] = []
## Solid architecture footprints (world-space center/size) that must block
## navigation even though they are not Build/Buy grid occupants.
var structure_blockers: Array[Dictionary] = []
## Interior wall meshes that can be hidden for life-sim cutaway readability.
var wall_cutaway_meshes: Array[MeshInstance3D] = []
var interior_floor_meshes: Array[MeshInstance3D] = []

func build_world(parent: Node3D) -> Dictionary:
	objects.clear()
	lot_definitions.clear()
	structure_blockers.clear()
	world_root = Node3D.new()
	world_root.name = "World"
	parent.add_child(world_root)
	_create_environment()
	_create_ground()
	_create_roads()
	_create_lots_and_buildings()
	_create_nature()
	_create_interiors()
	_spawn_initial_objects()
	return {"root": world_root, "objects": objects}

func _create_environment() -> void:
	## Life-sim art foundation: warm suburban daylight, soft sky, gentle distance
	## fog, and restrained exposure so materials read as domestic rather than
	## unlit prototype geometry under a flat clear colour.
	var world_environment := WorldEnvironment.new()
	world_environment.name = "WorldEnvironment"
	var environment := Environment.new()
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color("#7eb8d8")
	sky_mat.sky_horizon_color = Color("#d9e8ef")
	sky_mat.sky_curve = 0.12
	sky_mat.ground_bottom_color = Color("#6a7a5c")
	sky_mat.ground_horizon_color = Color("#b7c4a8")
	sky_mat.ground_curve = 0.08
	sky_mat.sun_angle_max = 28.0
	sky_mat.sun_curve = 0.08
	sky.sky_material = sky_mat
	environment.background_mode = Environment.BG_SKY
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	environment.ambient_light_color = Color("#e8f0ef")
	environment.ambient_light_energy = 0.42
	environment.ambient_light_sky_contribution = 0.65
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.tonemap_exposure = 0.92
	environment.tonemap_white = 1.15
	# Soft distance fog keeps the far road from reading as infinite flat planes.
	environment.fog_enabled = true
	environment.fog_light_color = Color("#c5d6df")
	environment.fog_light_energy = 0.55
	environment.fog_density = 0.0018
	environment.fog_aerial_perspective = 0.35
	environment.fog_sky_affect = 0.35
	environment.fog_sun_scatter = 0.12
	world_environment.environment = environment
	world_root.add_child(world_environment)

	var sun := DirectionalLight3D.new()
	sun.name = "SunLight"
	# Late-morning suburban angle: readable roof planes, soft long shadows.
	sun.rotation_degrees = Vector3(-48.0, -42.0, 0.0)
	sun.light_color = Color("#fff2df")
	sun.light_energy = 1.05
	sun.shadow_enabled = true
	sun.shadow_bias = 0.04
	sun.shadow_normal_bias = 1.2
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
	sun.light_indirect_energy = 0.35
	world_root.add_child(sun)

	# Gentle fill keeps north-facing facades and furniture readable under GL Compatibility.
	var fill := DirectionalLight3D.new()
	fill.name = "FillLight"
	fill.rotation_degrees = Vector3(-28.0, 128.0, 0.0)
	fill.light_color = Color("#c8daf0")
	fill.light_energy = 0.22
	fill.shadow_enabled = false
	world_root.add_child(fill)

func _create_ground() -> void:
	var ground := StaticBody3D.new()
	ground.name = "Ground"
	ground.set_meta("is_ground", true)
	ground.collision_layer = 1
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(96.0, 0.2, 96.0)
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	# Warm suburban lawn — not neon chartreuse.
	material.albedo_color = Color("#6a8758")
	material.albedo_texture = AssetLibrary.texture_asset("terrain_grass")
	material.uv1_scale = Vector3(24.0, 24.0, 24.0)
	material.roughness = 0.95
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	mesh_instance.material_override = material
	mesh_instance.position.y = -0.1
	mesh_instance.layers = AssetLibrary.RENDER_LAYER_WORLD
	ground.add_child(mesh_instance)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(96.0, 0.2, 96.0)
	collision.shape = shape
	collision.position.y = -0.1
	ground.add_child(collision)
	world_root.add_child(ground)
	# Soft grass patches break flat neon-ground reading across the neighborhood.
	_scatter_grass_patches()

func _create_roads() -> void:
	# Asphalt with muted grey-brown and soft edge shoulders for neighborhood readability.
	var north_south := _create_flat_box(Vector3(0.0, 0.015, 0.0), Vector3(9.0, 0.03, 96.0), Color("#4a4f56"), "NorthSouthRoad")
	var east_west := _create_flat_box(Vector3(0.0, 0.02, 0.0), Vector3(96.0, 0.04, 9.0), Color("#4a4f56"), "EastWestRoad")
	_apply_texture(north_south, "terrain_road", Vector3(2.0, 20.0, 2.0))
	_apply_texture(east_west, "terrain_road", Vector3(20.0, 2.0, 2.0))
	# Soft shoulder strips (sidewalk placeholders) frame the road before Loop 02 detailing.
	var sw_a := _create_flat_box(Vector3(-5.85, 0.028, 0.0), Vector3(1.1, 0.04, 96.0), Color("#b7b3a8"), "SidewalkNS_W")
	var sw_b := _create_flat_box(Vector3(5.85, 0.028, 0.0), Vector3(1.1, 0.04, 96.0), Color("#b7b3a8"), "SidewalkNS_E")
	var sw_c := _create_flat_box(Vector3(0.0, 0.032, -5.85), Vector3(96.0, 0.04, 1.1), Color("#b7b3a8"), "SidewalkEW_N")
	var sw_d := _create_flat_box(Vector3(0.0, 0.032, 5.85), Vector3(96.0, 0.04, 1.1), Color("#b7b3a8"), "SidewalkEW_S")
	_apply_texture(sw_a, "sidewalk", Vector3(1.0, 24.0, 1.0))
	_apply_texture(sw_b, "sidewalk", Vector3(1.0, 24.0, 1.0))
	_apply_texture(sw_c, "sidewalk", Vector3(24.0, 1.0, 1.0))
	_apply_texture(sw_d, "sidewalk", Vector3(24.0, 1.0, 1.0))
	_create_flat_box(Vector3(-5.4, 0.04, 0.0), Vector3(0.16, 0.04, 96.0), Color("#cfc7a0"), "RoadStripeA")
	_create_flat_box(Vector3(5.4, 0.04, 0.0), Vector3(0.16, 0.04, 96.0), Color("#cfc7a0"), "RoadStripeB")
	# Centre dashed line on the main cross for streetscape rhythm.
	for z in range(-40, 41, 6):
		_create_flat_box(Vector3(0.0, 0.045, float(z)), Vector3(0.18, 0.03, 2.2), Color("#d4cc9e"), "CenterDash_%d" % z)
	# Raised curb lips between asphalt and sidewalk.
	_create_curb(Vector3(-5.15, 0.05, 0.0), Vector3(0.28, 0.08, 96.0), "CurbNS_W")
	_create_curb(Vector3(5.15, 0.05, 0.0), Vector3(0.28, 0.08, 96.0), "CurbNS_E")
	_create_curb(Vector3(0.0, 0.055, -5.15), Vector3(96.0, 0.08, 0.28), "CurbEW_N")
	_create_curb(Vector3(0.0, 0.055, 5.15), Vector3(96.0, 0.08, 0.28), "CurbEW_S")

func _create_lots_and_buildings() -> void:
	_create_lot("lot_founders", Vector3(-22.0, 0.02, -22.0), Vector3(27.0, 0.04, 27.0), Color("#7a926c"), "FoundersLot", "residential")
	_create_lot("lot_neighbor_a", Vector3(22.0, 0.02, -22.0), Vector3(27.0, 0.04, 27.0), Color("#76906a"), "NeighborLotA", "residential")
	_create_lot("lot_community_park", Vector3(-22.0, 0.02, 22.0), Vector3(27.0, 0.04, 27.0), Color("#728c66"), "CommunityPark", "community")
	_create_lot("lot_neighbor_b", Vector3(22.0, 0.02, 22.0), Vector3(27.0, 0.04, 27.0), Color("#6e8862"), "NeighborLotB", "residential")
	_create_house(Vector3(-26.0, 0.0, -26.0), "house_founders", "FoundersHouse")
	_create_house(Vector3(23.0, 0.0, -25.0), "house_blue", "BlueHouse")
	_create_house(Vector3(24.0, 0.0, 25.0), "house_rose", "RoseHouse")
	_apply_texture(_create_flat_box(Vector3(-23.0, 0.03, 24.0), Vector3(18.0, 0.08, 12.0), Color("#6e8a60"), "ParkLawn"), "terrain_grass", Vector3(5.0, 5.0, 5.0))
	_create_structure("community_center", Vector3(-23.0, 0.0, 31.0), "CommunityCenter", Vector3(10.0, 6.0, 8.0), Vector3(0.65, 0.65, 0.65))
	_create_structure("cafe", Vector3(35.0, 0.0, 5.0), "CornerCafe", Vector3(8.0, 5.0, 8.0), Vector3(0.72, 0.72, 0.72))
	_create_structure("hospital_rabbit_hole", Vector3(-35.0, 0.0, 5.0), "CommunityHospital", Vector3(9.0, 6.0, 9.0), Vector3(0.68, 0.68, 0.68))
	_dress_lot_surfaces()

func _create_lot(lot_id: String, position: Vector3, size: Vector3, color: Color, lot_name: String, lot_type := "residential") -> void:
	var surface := _create_flat_box(position, size, color, lot_name)
	# Textured lot surfaces keep the neighborhood from reading as flat colour and
	# prove the bundled terrain textures are actually applied at runtime.
	_apply_texture(surface, "terrain_grass", Vector3(7.0, 7.0, 7.0))
	# Subtle lot border so yard edges read against the street without neon contrast.
	var border_color := Color("#8a8474")
	var half_x := size.x * 0.5
	var half_z := size.z * 0.5
	_create_flat_box(position + Vector3(0.0, 0.015, -half_z), Vector3(size.x + 0.4, 0.03, 0.35), border_color, "%sBorderN" % lot_name)
	_create_flat_box(position + Vector3(0.0, 0.015, half_z), Vector3(size.x + 0.4, 0.03, 0.35), border_color, "%sBorderS" % lot_name)
	_create_flat_box(position + Vector3(-half_x, 0.015, 0.0), Vector3(0.35, 0.03, size.z), border_color, "%sBorderW" % lot_name)
	_create_flat_box(position + Vector3(half_x, 0.015, 0.0), Vector3(0.35, 0.03, size.z), border_color, "%sBorderE" % lot_name)
	lot_definitions.append({
		"id": lot_id,
		"name": lot_name,
		"type": lot_type,
		"center": Vector2(position.x, position.z),
		"size": Vector2(size.x, size.z),
	})

const HOUSE_SIZE := Vector3(12.0, 5.0, 9.0)
const HOUSE_WALL_THICKNESS := 0.5
const HOUSE_DOOR_WIDTH := 5.0

func _create_house(position: Vector3, asset_id: String, house_name: String) -> void:
	var instance := _add_asset(asset_id, position, house_name)
	if instance == null:
		var body := MeshInstance3D.new()
		body.name = "%sMesh" % house_name
		var body_mesh := BoxMesh.new()
		body_mesh.size = HOUSE_SIZE
		body.mesh = body_mesh
		var material := StandardMaterial3D.new()
		material.albedo_color = Color("#d9c9a4")
		material.roughness = 0.8
		body.material_override = material
		body.position = position + Vector3(0.0, HOUSE_SIZE.y * 0.5, 0.0)
		body.layers = AssetLibrary.RENDER_LAYER_WORLD
		world_root.add_child(body)
	_create_house_walls(position, house_name)

## Houses are solid architecture with a walkable interior: the perimeter walls
## are physical and block navigation, and one doorway gap on the +Z face keeps
## the interior furniture reachable.
func _create_house_walls(position: Vector3, house_name: String) -> void:
	var half_x := HOUSE_SIZE.x * 0.5
	var half_z := HOUSE_SIZE.z * 0.5
	var wall_height := HOUSE_SIZE.y
	var side_length := HOUSE_SIZE.z + HOUSE_WALL_THICKNESS
	_register_structure_body("%sWallNorth" % house_name,
		position + Vector3(0.0, 0.0, -half_z),
		Vector3(HOUSE_SIZE.x, wall_height, HOUSE_WALL_THICKNESS))
	_register_structure_body("%sWallWest" % house_name,
		position + Vector3(-half_x, 0.0, 0.0),
		Vector3(HOUSE_WALL_THICKNESS, wall_height, side_length))
	_register_structure_body("%sWallEast" % house_name,
		position + Vector3(half_x, 0.0, 0.0),
		Vector3(HOUSE_WALL_THICKNESS, wall_height, side_length))
	var segment_length := (HOUSE_SIZE.x - HOUSE_DOOR_WIDTH) * 0.5
	var segment_offset := (HOUSE_DOOR_WIDTH + segment_length) * 0.5
	_register_structure_body("%sWallSouthLeft" % house_name,
		position + Vector3(-segment_offset, 0.0, half_z),
		Vector3(segment_length, wall_height, HOUSE_WALL_THICKNESS))
	_register_structure_body("%sWallSouthRight" % house_name,
		position + Vector3(segment_offset, 0.0, half_z),
		Vector3(segment_length, wall_height, HOUSE_WALL_THICKNESS))

func _create_structure(asset_id: String, position: Vector3, node_name: String, blocker_size: Vector3, node_scale := Vector3.ONE) -> void:
	if _add_asset(asset_id, position, node_name, node_scale) == null:
		# Community buildings must still be visible if their model is unusable.
		var shell := MeshInstance3D.new()
		shell.name = "%sMesh" % node_name
		var mesh := BoxMesh.new()
		mesh.size = blocker_size
		shell.mesh = mesh
		var material := StandardMaterial3D.new()
		material.albedo_color = Color("#c9c2b4")
		material.roughness = 0.85
		shell.material_override = material
		shell.position = position + Vector3(0.0, blocker_size.y * 0.5, 0.0)
		shell.layers = AssetLibrary.RENDER_LAYER_WORLD
		world_root.add_child(shell)
	_register_structure_body("%sBody" % node_name, position, blocker_size)

## Adds a static architecture collider on the structure layer and records the
## footprint so the router treats the building as impassable.
func _register_structure_body(body_name: String, position: Vector3, size: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = body_name
	body.collision_layer = InteractableObject.LAYER_STRUCTURE
	body.collision_mask = 0
	body.position = position + Vector3(0.0, size.y * 0.5, 0.0)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	world_root.add_child(body)
	structure_blockers.append({"center": position, "size": size})

func _create_nature() -> void:
	var tree_positions := [
		Vector3(-42, 0, -39), Vector3(-37, 0, -14), Vector3(-13, 0, -41),
		Vector3(42, 0, -39), Vector3(37, 0, -12), Vector3(13, 0, -41),
		Vector3(-42, 0, 39), Vector3(-33, 0, 13), Vector3(-13, 0, 41),
		Vector3(42, 0, 39), Vector3(33, 0, 14), Vector3(13, 0, 41)
	]
	for index in tree_positions.size():
		var tree_id := "tree_deciduous" if index % 3 != 0 else "tree_pine"
		if _add_asset(tree_id, tree_positions[index], "Tree_%02d" % index) == null:
			_create_fallback_tree(tree_positions[index])
	for index in 8:
		var angle := float(index) / 8.0 * TAU
		var shrub_position := Vector3(-23.0 + cos(angle) * 7.5, 0.0, 21.5 + sin(angle) * 4.5)
		if _add_asset("shrub", shrub_position, "ParkShrub_%02d" % index) == null:
			_create_fallback_blob(shrub_position + Vector3(0.0, 0.45, 0.0), 0.75, Color("#4f8a58"), "ParkShrubFallback_%02d" % index)
	if _add_asset("rock_cluster", Vector3(-29.0, 0.0, 18.5), "ParkRocksA") == null:
		_create_fallback_blob(Vector3(-29.0, 0.35, 18.5), 0.7, Color("#8b8b86"), "ParkRocksAFallback")
	if _add_asset("rock_cluster", Vector3(-15.5, 0.0, 27.5), "ParkRocksB", Vector3(0.8, 0.8, 0.8)) == null:
		_create_fallback_blob(Vector3(-15.5, 0.3, 27.5), 0.55, Color("#8b8b86"), "ParkRocksBFallback")

## Minimal always-visible stand-in for small nature dressing.
func _create_fallback_blob(position: Vector3, radius: float, color: Color, node_name: String) -> void:
	var blob := MeshInstance3D.new()
	blob.name = node_name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 1.8
	blob.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	blob.material_override = material
	blob.position = position
	blob.layers = AssetLibrary.RENDER_LAYER_WORLD
	world_root.add_child(blob)

func _create_fallback_tree(pos: Vector3) -> void:
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.25
	trunk_mesh.bottom_radius = 0.36
	trunk_mesh.height = 2.5
	trunk.mesh = trunk_mesh
	var trunk_material := StandardMaterial3D.new()
	trunk_material.albedo_color = Color("#71513b")
	trunk.material_override = trunk_material
	trunk.position = pos + Vector3(0.0, 1.25, 0.0)
	trunk.layers = AssetLibrary.RENDER_LAYER_WORLD
	world_root.add_child(trunk)
	var crown := MeshInstance3D.new()
	var crown_mesh := SphereMesh.new()
	crown_mesh.radius = 1.5
	crown_mesh.height = 2.5
	crown.mesh = crown_mesh
	var crown_material := StandardMaterial3D.new()
	crown_material.albedo_color = Color("#3d7d54")
	crown.material_override = crown_material
	crown.position = pos + Vector3(0.0, 3.0, 0.0)
	crown.layers = AssetLibrary.RENDER_LAYER_WORLD
	world_root.add_child(crown)

## Adds a bundled model to the world, but only accepts it once it is proven to
## be visible geometry inside the live scene tree. Returning null tells the
## caller to build its project-owned procedural fallback instead.
func _add_asset(asset_id: String, position: Vector3, node_name: String, node_scale := Vector3.ONE) -> Node3D:
	var instance := AssetLibrary.instantiate_model(asset_id)
	if instance == null:
		return null
	instance.name = node_name
	instance.position = position
	instance.scale = node_scale
	world_root.add_child(instance)
	if not AssetLibrary.instance_has_visible_geometry(instance):
		push_warning("OpenLife world asset '%s' produced no visible geometry after parenting; using procedural fallback." % asset_id)
		world_root.remove_child(instance)
		instance.queue_free()
		return null
	return instance

func _spawn_initial_objects() -> void:
	# Owner household is explicit at spawn time so Build/Buy sale authority and
	# household economy have a single source of truth. An empty owner marks
	# community property, which no household may sell.
	var placements := [
		["fridge_basic", Vector3(-29.0, 0.0, -24.0), "household_founders"],
		["toilet_basic", Vector3(-26.0, 0.0, -23.0), "household_founders"],
		["shower_basic", Vector3(-23.5, 0.0, -23.0), "household_founders"],
		["bed_double", Vector3(-27.0, 0.0, -28.5), "household_founders"],
		["sofa_basic", Vector3(-22.0, 0.0, -27.0), "household_founders"],
		["bookshelf_basic", Vector3(-19.0, 0.0, -27.0), "household_founders"],
		["computer_basic", Vector3(-19.0, 0.0, -23.0), "household_founders"],
		["desk_basic", Vector3(-24.0, 0.0, -19.0), "household_founders"],
		["stereo_basic", Vector3(-21.5, 0.0, -20.0), "household_founders"],
		["easel_basic", Vector3(-17.0, 0.0, -18.0), "household_founders"],
		["chess_table", Vector3(-26.0, 0.0, -17.0), "household_founders"],
		["grill_basic", Vector3(-19.0, 0.0, -16.0), "household_founders"],
		["telescope_basic", Vector3(-30.0, 0.0, -16.0), "household_founders"],
		["dining_table", Vector3(-24.0, 0.0, -22.0), "household_founders"],
		["dining_chair", Vector3(-23.0, 0.0, -21.0), "household_founders"],
		["dining_chair", Vector3(-25.0, 0.0, -21.0), "household_founders"],
		["dresser_basic", Vector3(-29.0, 0.0, -28.0), "household_founders"],
		["candy_floor_lamp", Vector3(-20.5, 0.0, -26.0), "household_founders"],
		["industrial_coffee_table", Vector3(-22.0, 0.0, -25.5), "household_founders"],
		["kitchen_stove", Vector3(-28.5, 0.0, -23.0), "household_founders"],
		["kitchen_sink", Vector3(-27.0, 0.0, -23.0), "household_founders"],
		["dishwasher", Vector3(-25.5, 0.0, -23.0), "household_founders"],
		["coffee_maker", Vector3(-28.5, 0.0, -21.5), "household_founders"],
		["bathtub_basic", Vector3(-24.5, 0.0, -23.5), "household_founders"],
		["spa_vanity", Vector3(-22.5, 0.0, -23.0), "household_founders"],
		["bed_double", Vector3(26.0, 0.0, -28.0), "household_bell"],
		["fridge_basic", Vector3(20.0, 0.0, -24.0), "household_bell"],
		["stereo_basic", Vector3(19.0, 0.0, -20.0), "household_bell"],
		["park_bench", Vector3(-23.0, 0.0, 23.0), ""],
		["park_bench", Vector3(-17.0, 0.0, 23.0), ""],
		["gym_treadmill", Vector3(18.0, 0.0, 18.0), ""],
		["alchemy_station", Vector3(25.0, 0.0, 18.0), ""],
		["future_workbench", Vector3(29.0, 0.0, 18.0), ""],
	]
	for placement in placements:
		var object := spawn_object(String(placement[0]), placement[1])
		if object != null:
			object.owner_household_id = String(placement[2])

func spawn_object(catalog_id: String, position: Vector3, rotation_y := 0.0) -> InteractableObject:
	var data := ContentRegistry.get_object(catalog_id)
	if data.is_empty():
		push_warning("Unknown object catalog id: %s" % catalog_id)
		return null
	object_counter += 1
	var object := InteractableObject.new()
	object.setup(data, "%s_%04d" % [catalog_id, object_counter], position)
	object.rotation.y = rotation_y
	world_root.add_child(object)
	object.global_position = position
	objects.append(object)
	return object

func remove_object(object: InteractableObject) -> void:
	if object not in objects:
		return
	objects.erase(object)
	object.queue_free()

func clear_objects() -> void:
	for object in objects:
		if is_instance_valid(object):
			object.queue_free()
	objects.clear()

func _apply_texture(mesh_instance: MeshInstance3D, asset_id: String, uv_scale := Vector3.ONE) -> void:
	if mesh_instance == null:
		return
	var texture := AssetLibrary.texture_asset(asset_id)
	if texture == null:
		return
	var material := mesh_instance.material_override as StandardMaterial3D
	if material == null:
		material = StandardMaterial3D.new()
	mesh_instance.material_override = material
	material.albedo_texture = texture
	material.uv1_scale = uv_scale



func _dress_lot_surfaces() -> void:
	## Driveways, walkways, garden beds and foundation skirts — intentional lot
	## authorship beyond flat neon lawn slabs.
	_create_driveway(Vector3(-18.5, 0.04, -20.5), Vector3(4.2, 0.05, 10.0), "FoundersDriveway")
	_create_path(Vector3(-26.0, 0.045, -21.2), Vector3(2.0, 0.04, 6.5), "FoundersWalk")
	_create_path(Vector3(-26.0, 0.045, -18.0), Vector3(8.0, 0.04, 1.6), "FoundersPorchPath")
	_create_garden_bed(Vector3(-30.5, 0.05, -22.5), Vector3(2.4, 0.08, 6.0), "FoundersGardenW")
	_create_garden_bed(Vector3(-21.5, 0.05, -30.0), Vector3(6.0, 0.08, 2.2), "FoundersGardenS")
	_create_flat_box(Vector3(-26.0, 0.06, -26.0), Vector3(12.6, 0.12, 9.6), Color("#8a8478"), "FoundersFoundation")
	_create_driveway(Vector3(18.0, 0.04, -20.0), Vector3(4.0, 0.05, 9.5), "BlueDriveway")
	_create_path(Vector3(23.0, 0.045, -20.5), Vector3(1.8, 0.04, 6.0), "BlueWalk")
	_create_garden_bed(Vector3(28.0, 0.05, -22.0), Vector3(2.2, 0.08, 5.5), "BlueGarden")
	_create_flat_box(Vector3(23.0, 0.06, -25.0), Vector3(12.6, 0.12, 9.6), Color("#868278"), "BlueFoundation")
	_create_driveway(Vector3(19.0, 0.04, 20.0), Vector3(4.0, 0.05, 9.0), "RoseDriveway")
	_create_path(Vector3(24.0, 0.045, 20.5), Vector3(1.8, 0.04, 6.0), "RoseWalk")
	_create_garden_bed(Vector3(29.0, 0.05, 22.0), Vector3(2.2, 0.08, 5.0), "RoseGarden")
	_create_flat_box(Vector3(24.0, 0.06, 25.0), Vector3(12.6, 0.12, 9.6), Color("#8a8078"), "RoseFoundation")
	_create_path(Vector3(-23.0, 0.04, 22.0), Vector3(14.0, 0.05, 1.8), "ParkPathMain")
	_create_path(Vector3(-23.0, 0.04, 26.0), Vector3(1.8, 0.05, 8.0), "ParkPathCross")
	_create_garden_bed(Vector3(-28.0, 0.05, 19.0), Vector3(3.5, 0.08, 3.5), "ParkBedA")
	_create_garden_bed(Vector3(-17.0, 0.05, 19.0), Vector3(3.5, 0.08, 3.5), "ParkBedB")
	var apron := _create_flat_box(Vector3(-23.0, 0.04, 27.5), Vector3(12.0, 0.05, 4.0), Color("#9a968c"), "CommunityApron")
	_apply_texture(apron, "sidewalk", Vector3(4.0, 2.0, 4.0))

	# Outdoor domestic dressing
	_add_asset("mailbox_basic", Vector3(-15.5, 0.0, -14.5), "FoundersMailbox")
	_add_asset("trash_bin", Vector3(-14.5, 0.0, -15.5), "FoundersTrash")
	_add_asset("fence_panel", Vector3(-34.0, 0.0, -22.0), "FoundersFenceW")
	_add_asset("fence_panel", Vector3(-34.0, 0.0, -28.0), "FoundersFenceW2")
	_add_asset("garden_planter", Vector3(-22.0, 0.0, -18.5), "FoundersPlanterA")
	_add_asset("garden_planter", Vector3(-20.0, 0.0, -18.5), "FoundersPlanterB")
	_add_asset("potted_plant", Vector3(-24.5, 0.0, -21.0), "FoundersPot")
	_add_asset("flower_bed", Vector3(-29.5, 0.0, -21.0), "FoundersFlowers")
	# Streetlights along roads
	for z in [-30.0, -15.0, 0.0, 15.0, 30.0]:
		_add_asset("streetlight", Vector3(-6.8, 0.0, z), "StreetLightW_%d" % int(z))
		_add_asset("streetlight", Vector3(6.8, 0.0, z), "StreetLightE_%d" % int(z))
	# Neighbor fences / mailboxes
	_add_asset("mailbox_basic", Vector3(16.0, 0.0, -14.0), "BlueMailbox")
	_add_asset("fence_panel", Vector3(34.0, 0.0, -22.0), "BlueFence")
	_add_asset("park_bench", Vector3(-20.0, 0.0, 20.5), "ParkBenchExtra")
	_add_asset("trash_bin", Vector3(-15.0, 0.0, 20.0), "ParkTrash")



func _create_interiors() -> void:
	## Floors, interior wall materials, and cutaway-capable wall meshes for the
	## three residential shells. Collision/routing walls remain solid.
	wall_cutaway_meshes.clear()
	interior_floor_meshes.clear()
	_create_house_interior(Vector3(-26.0, 0.0, -26.0), "Founders")
	_create_house_interior(Vector3(23.0, 0.0, -25.0), "Blue")
	_create_house_interior(Vector3(24.0, 0.0, 25.0), "Rose")

func _create_house_interior(position: Vector3, house_name: String) -> void:
	var half_x := HOUSE_SIZE.x * 0.5 - 0.35
	var half_z := HOUSE_SIZE.z * 0.5 - 0.35
	# Wood living floor + tile wet-area strip
	var living := _create_flat_box(position + Vector3(0.0, 0.03, -0.5), Vector3(HOUSE_SIZE.x - 0.9, 0.05, HOUSE_SIZE.z - 1.4), Color("#c4a07a"), "%sFloorLiving" % house_name)
	_apply_texture(living, "floor_wood", Vector3(4.0, 4.0, 4.0))
	interior_floor_meshes.append(living)
	var wet := _create_flat_box(position + Vector3(-3.0, 0.035, 2.5), Vector3(4.5, 0.05, 3.2), Color("#d5d0c6"), "%sFloorWet" % house_name)
	_apply_texture(wet, "floor_tile", Vector3(3.0, 3.0, 3.0))
	interior_floor_meshes.append(wet)
	# Interior partition (non-blocking visual only — routing uses exterior structure)
	var partition := _create_flat_box(position + Vector3(1.5, HOUSE_SIZE.y * 0.35, 0.0), Vector3(0.12, HOUSE_SIZE.y * 0.7, HOUSE_SIZE.z - 1.5), Color("#e8dcc4"), "%sPartition" % house_name)
	_apply_texture(partition, "wallpaper_cream", Vector3(2.0, 2.0, 2.0))
	wall_cutaway_meshes.append(partition)
	# Ceiling plane (subtle)
	var ceiling := _create_flat_box(position + Vector3(0.0, HOUSE_SIZE.y - 0.15, 0.0), Vector3(HOUSE_SIZE.x - 0.8, 0.08, HOUSE_SIZE.z - 0.8), Color("#f2efe6"), "%sCeiling" % house_name)
	wall_cutaway_meshes.append(ceiling)
	# Baseboards
	for z_sign in [-1.0, 1.0]:
		var base := _create_flat_box(position + Vector3(0.0, 0.12, z_sign * half_z), Vector3(HOUSE_SIZE.x - 1.0, 0.12, 0.08), Color("#d8cbb0"), "%sBaseZ%s" % [house_name, str(z_sign)])
		wall_cutaway_meshes.append(base)
	for x_sign in [-1.0, 1.0]:
		var base_x := _create_flat_box(position + Vector3(x_sign * half_x, 0.12, 0.0), Vector3(0.08, 0.12, HOUSE_SIZE.z - 1.0), Color("#d8cbb0"), "%sBaseX%s" % [house_name, str(x_sign)])
		wall_cutaway_meshes.append(base_x)
	# Accent wall paint strip
	var accent := _create_flat_box(position + Vector3(0.0, 1.8, -half_z + 0.05), Vector3(4.0, 2.2, 0.06), Color("#b7c9d4"), "%sAccentWall" % house_name)
	_apply_texture(accent, "wallpaper_blue", Vector3(2.0, 2.0, 2.0))
	wall_cutaway_meshes.append(accent)

func set_wall_cutaway(enabled: bool) -> void:
	for mesh in wall_cutaway_meshes:
		if is_instance_valid(mesh):
			mesh.visible = not enabled
	# When cutaway is on, also lower exterior shell opacity if present is handled by main.

func _scatter_grass_patches() -> void:
	var patches := [
		[Vector3(-18.0, 0.025, -8.0), Vector3(10.0, 0.03, 8.0), "terrain_grass_lush", Color("#5f8450")],
		[Vector3(16.0, 0.025, -10.0), Vector3(9.0, 0.03, 7.0), "terrain_grass_dry", Color("#7a8a55")],
		[Vector3(-14.0, 0.025, 14.0), Vector3(11.0, 0.03, 9.0), "terrain_grass_lush", Color("#5c804c")],
		[Vector3(18.0, 0.025, 12.0), Vector3(8.0, 0.03, 8.0), "terrain_grass_dry", Color("#768652")],
		[Vector3(0.0, 0.022, -32.0), Vector3(20.0, 0.03, 6.0), "terrain_grass", Color("#678456")],
	]
	for index in patches.size():
		var patch: Array = patches[index]
		var surface := _create_flat_box(patch[0], patch[1], patch[3], "GrassPatch_%02d" % index)
		_apply_texture(surface, String(patch[2]), Vector3(4.0, 4.0, 4.0))

func _create_curb(position: Vector3, size: Vector3, node_name: String) -> MeshInstance3D:
	var curb := _create_flat_box(position, size, Color("#9a968c"), node_name)
	_apply_texture(curb, "lot_edge", Vector3(2.0, 1.0, 2.0))
	return curb

func _create_driveway(position: Vector3, size: Vector3, node_name: String) -> MeshInstance3D:
	var drive := _create_flat_box(position, size, Color("#5a5a58"), node_name)
	_apply_texture(drive, "driveway", Vector3(2.0, 3.0, 2.0))
	return drive

func _create_garden_bed(position: Vector3, size: Vector3, node_name: String) -> MeshInstance3D:
	var soil := _create_flat_box(position, size, Color("#5a4228"), node_name)
	_apply_texture(soil, "garden_soil", Vector3(2.0, 2.0, 2.0))
	return soil

func _create_path(position: Vector3, size: Vector3, node_name: String) -> MeshInstance3D:
	var path := _create_flat_box(position, size, Color("#8e8878"), node_name)
	_apply_texture(path, "stone_paver", Vector3(3.0, 3.0, 3.0))
	return path

func _create_flat_box(position: Vector3, size: Vector3, color: Color, node_name: String) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = node_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	mesh_instance.material_override = material
	mesh_instance.position = position
	mesh_instance.layers = AssetLibrary.RENDER_LAYER_WORLD
	world_root.add_child(mesh_instance)
	return mesh_instance
