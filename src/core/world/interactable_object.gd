class_name InteractableObject
extends StaticBody3D

# Deliberate collision-layer matrix shared by every physics body in OpenLife.
# 1 ground/terrain, 2 Sims, 4 placeable objects, 8 architecture/structures.
const LAYER_GROUND := 1
const LAYER_SIM := 2
const LAYER_OBJECT := 4
const LAYER_STRUCTURE := 8

## Distance (metres) at which object name labels stop drawing, plus the fade
## band leading up to it.
const LABEL_VISIBLE_DISTANCE := 22.0
const LABEL_FADE_MARGIN := 6.0

var object_instance_id: String
var catalog_id: String
var display_name: String
var category: String
var pack_id: String
var price: int
var interactions: Array[Dictionary] = []
var footprint := Vector2i.ONE
var owner_household_id := ""
var grid_size := 1.0
var _visual_root: Node3D
var _label: Label3D

func setup(data: Dictionary, instance_id_value: String, placement: Vector3) -> void:
	object_instance_id = instance_id_value
	catalog_id = String(data.get("id", "unknown_object"))
	display_name = String(data.get("name", catalog_id.capitalize()))
	category = String(data.get("category", "misc"))
	pack_id = String(data.get("pack_id", "BG"))
	price = int(data.get("price", 0))
	footprint = Vector2i(int(data.get("footprint_x", 1)), int(data.get("footprint_z", 1)))
	for entry in Array(data.get("interactions", [])):
		if entry is Dictionary:
			interactions.append(Dictionary(entry).duplicate(true))
	# Local position is used here because setup() runs before the node enters the
	# scene tree; WorldBuilder parents the object to an identity-transform root.
	position = placement
	name = object_instance_id
	_build_visual(data)
	collision_layer = LAYER_OBJECT
	collision_mask = 0

func _build_visual(data: Dictionary) -> void:
	var dimensions := Vector3(
		float(data.get("size_x", 1.2)),
		float(data.get("size_y", 1.2)),
		float(data.get("size_z", 1.2))
	)
	var asset_id := String(data.get("asset_id", catalog_id))
	var imported := AssetLibrary.instantiate_model(asset_id)
	if imported != null:
		imported.name = "Visual_%s" % asset_id
		add_child(imported)
		# An object must never exist as a bare label: if the imported model does
		# not survive parenting as visible geometry, fall back to the
		# project-owned procedural mesh.
		if AssetLibrary.instance_has_visible_geometry(imported):
			_visual_root = imported
		else:
			push_warning("OpenLife object asset '%s' produced no visible geometry after parenting; using procedural mesh." % asset_id)
			remove_child(imported)
			imported.queue_free()
	if _visual_root == null:
		_visual_root = Node3D.new()
		_visual_root.name = "FallbackVisual"
		add_child(_visual_root)
		_build_fallback_mesh(data, dimensions)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	collision.position.y = dimensions.y * 0.5
	add_child(collision)

	_label = Label3D.new()
	_label.text = display_name
	_label.font_size = 28
	_label.outline_size = 7
	_label.position = Vector3(0.0, dimensions.y + 0.35, 0.0)
	_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	# Labels must annotate visible geometry, never replace it. Depth testing lets
	# the world occlude them, distance scaling stops far-away labels filling the
	# screen, and a visibility range keeps the neighborhood readable.
	_label.no_depth_test = false
	_label.fixed_size = false
	_label.visibility_range_end = LABEL_VISIBLE_DISTANCE
	_label.visibility_range_end_margin = LABEL_FADE_MARGIN
	_label.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
	_label.modulate = Color(1.0, 1.0, 1.0, 0.92)
	add_child(_label)

func _build_fallback_mesh(data: Dictionary, dimensions: Vector3) -> void:
	var mesh_instance := MeshInstance3D.new()
	var mesh_kind := String(data.get("mesh", "box"))
	var mesh: PrimitiveMesh
	match mesh_kind:
		"cylinder":
			var cylinder := CylinderMesh.new()
			cylinder.top_radius = dimensions.x * 0.5
			cylinder.bottom_radius = dimensions.x * 0.5
			cylinder.height = dimensions.y
			mesh = cylinder
		"sphere":
			var sphere_mesh := SphereMesh.new()
			sphere_mesh.radius = dimensions.x * 0.5
			sphere_mesh.height = dimensions.y
			mesh = sphere_mesh
		_:
			var box_mesh := BoxMesh.new()
			box_mesh.size = dimensions
			mesh = box_mesh
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.from_string(String(data.get("color", "#7c8791")), Color(0.5, 0.5, 0.5))
	material.roughness = 0.68
	mesh_instance.material_override = material
	mesh_instance.position.y = dimensions.y * 0.5
	mesh_instance.layers = AssetLibrary.RENDER_LAYER_WORLD
	_visual_root.add_child(mesh_instance)

func rotate_quarter_turn(steps := 1) -> void:
	rotation.y = snappedf(rotation.y + deg_to_rad(90.0 * float(steps)), deg_to_rad(90.0))

## Orientation-aware access cells around the object footprint. Sims must stand
## on one of these rather than inside the occupied footprint/collider.
func interaction_slots() -> Array[Vector3]:
	var half_x := float(footprint.x) * grid_size * 0.5
	var half_z := float(footprint.y) * grid_size * 0.5
	var margin := maxf(grid_size, 0.75)
	var local_slots: Array[Vector3] = [
		Vector3(0.0, 0.0, half_z + margin),
		Vector3(0.0, 0.0, -(half_z + margin)),
		Vector3(half_x + margin, 0.0, 0.0),
		Vector3(-(half_x + margin), 0.0, 0.0),
	]
	var result: Array[Vector3] = []
	var basis_y := Basis(Vector3.UP, rotation.y)
	for slot in local_slots:
		var world_slot := global_position + basis_y * slot
		result.append(Vector3(world_slot.x, global_position.y, world_slot.z))
	return result

## Nearest usable access cell to the approaching Sim. Falls back to the first
## slot so an interaction never targets the interior of the footprint.
func interaction_slot_position(from_position := Vector3.ZERO) -> Vector3:
	var slots := interaction_slots()
	if slots.is_empty():
		return global_position
	var best := slots[0]
	var best_distance := from_position.distance_squared_to(best)
	for index in range(1, slots.size()):
		var distance := from_position.distance_squared_to(slots[index])
		if distance < best_distance:
			best_distance = distance
			best = slots[index]
	return best

func interaction_by_id(interaction_id: String) -> Dictionary:
	for interaction in interactions:
		if String(interaction.get("id", "")) == interaction_id:
			return interaction.duplicate(true)
	return {}

func build_runtime_interaction(interaction_id: String, actor_position := Vector3.ZERO) -> Dictionary:
	var interaction := interaction_by_id(interaction_id)
	if interaction.is_empty():
		return {}
	interaction["target_id"] = object_instance_id
	interaction["target_name"] = display_name
	interaction["target_position"] = interaction_slot_position(actor_position)
	interaction["slot_candidates"] = interaction_slots()
	interaction["pack_id"] = pack_id
	var tags: Array = Array(interaction.get("tags", []))
	if category not in tags:
		tags.append(category)
	interaction["tags"] = tags
	return interaction

func serialize() -> Dictionary:
	return {
		"instance_id": object_instance_id,
		"catalog_id": catalog_id,
		"position": [global_position.x, global_position.y, global_position.z],
		"rotation_y": rotation.y,
		"owner_household_id": owner_household_id,
	}
