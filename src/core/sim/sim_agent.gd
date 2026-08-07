class_name SimAgent
extends CharacterBody3D

signal interaction_completed(sim: SimAgent, interaction: Dictionary)

var profile: SimProfile
var motives: Dictionary = MotiveSystem.make_default()
var queue := InteractionQueue.new()
var autonomy_enabled := true
var move_speed := 3.0
var selected := false
var active_household_member := true

const SMALL_AGE_STAGES: Array[String] = ["baby", "toddler", "child"]

## Distance (metres) at which Sim name tags stop drawing, plus the fade band.
## Shorter range keeps tags from dominating neighborhood composition.
const LABEL_VISIBLE_DISTANCE := 22.0
const LABEL_FADE_MARGIN := 6.0

var _phase := "idle"
var _body_mesh: Node3D
var _name_label: Label3D
var _selection_marker: MeshInstance3D
var _collision: CollisionShape3D
var _base_y := 0.9
var _body_color := Color("#5d98ca")
var _route_points: Array[Vector3] = []
var _route_index := 0
var _anim_phase := 0.0
var _was_moving := false

func setup(data: Dictionary, body_color: Color) -> void:
	profile = SimProfile.new(data)
	_body_color = body_color
	name = profile.sim_id
	motives = Dictionary(data.get("motives", MotiveSystem.make_default())).duplicate(true)
	_build_visual(body_color)

func _build_visual(body_color: Color) -> void:
	_body_mesh = Node3D.new()
	_body_mesh.name = "CharacterVisual"
	add_child(_body_mesh)

	_populate_body_visual(body_color)

	_collision = CollisionShape3D.new()
	_collision.shape = CapsuleShape3D.new()
	add_child(_collision)

	_name_label = Label3D.new()
	_name_label.text = profile.full_name()
	# Smaller, softer labels: annotation, not debug chrome.
	_name_label.font_size = 22
	_name_label.outline_size = 4
	_name_label.modulate = Color(1.0, 1.0, 1.0, 0.88)
	_name_label.outline_modulate = Color(0.12, 0.14, 0.16, 0.75)
	_name_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	# The name tag annotates the Sim's body; it must not float alone over the
	# world or render at constant screen size from any distance.
	_name_label.no_depth_test = false
	_name_label.fixed_size = false
	_name_label.visibility_range_end = LABEL_VISIBLE_DISTANCE
	_name_label.visibility_range_end_margin = LABEL_FADE_MARGIN
	_name_label.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF
	add_child(_name_label)

	_selection_marker = MeshInstance3D.new()
	var marker_mesh := CylinderMesh.new()
	marker_mesh.top_radius = 0.55
	marker_mesh.bottom_radius = 0.55
	marker_mesh.height = 0.02
	_selection_marker.mesh = marker_mesh
	var marker_material := StandardMaterial3D.new()
	# Original OpenLife selection ring (warm amber) — not a Sims plumbob clone.
	marker_material.albedo_color = Color(0.95, 0.78, 0.32, 0.55)
	marker_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	marker_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_selection_marker.material_override = marker_material
	_selection_marker.position.y = 0.02
	_selection_marker.layers = AssetLibrary.RENDER_LAYER_WORLD
	_selection_marker.visible = false
	add_child(_selection_marker)

	_apply_age_geometry()

	collision_layer = InteractableObject.LAYER_SIM
	# Sims collide with the ground, placed objects and architecture so a route
	# fallback can never push a Sim through solid geometry.
	collision_mask = InteractableObject.LAYER_GROUND | InteractableObject.LAYER_OBJECT | InteractableObject.LAYER_STRUCTURE

## Collision capsule, label height and selection marker all depend on the
## current age stage and are rebuilt whenever the profile visual changes.
func _apply_age_geometry() -> void:
	if profile == null:
		return
	var small := profile.age_stage in SMALL_AGE_STAGES
	if _collision != null and _collision.shape is CapsuleShape3D:
		var shape: CapsuleShape3D = _collision.shape
		shape.radius = 0.28 if small else 0.38
		shape.height = 1.1 if small else 1.6
		_base_y = shape.height * 0.5 + 0.1
		_collision.position.y = _base_y
	if _name_label != null:
		_name_label.position = Vector3(0.0, 1.9 if small else 2.55, 0.0)
	if _selection_marker != null:
		var marker_mesh := _selection_marker.mesh as CylinderMesh
		if marker_mesh != null:
			var radius := 0.45 if small else 0.65
			marker_mesh.top_radius = radius
			marker_mesh.bottom_radius = radius

func _populate_body_visual(body_color: Color) -> void:
	var stage_id := profile.age_stage
	if stage_id == "young_adult":
		stage_id = "adult"
	var shape_id := String(profile.genetics.get("body_shape", "average"))
	if shape_id not in ["slender", "average", "athletic", "soft"]:
		shape_id = "average"
	var avatar_id := "sim_%s_%s" % [stage_id, shape_id]
	var imported_avatar := AssetLibrary.instantiate_model(avatar_id)
	if imported_avatar != null:
		imported_avatar.name = "Avatar_%s" % avatar_id
		_body_mesh.add_child(imported_avatar)
		# A Sim must never exist as a bare name tag: if the imported avatar does
		# not survive parenting as visible geometry, discard it and build the
		# project-owned procedural body instead.
		if not AssetLibrary.instance_has_visible_geometry(imported_avatar):
			push_warning("OpenLife avatar '%s' produced no visible geometry after parenting; using procedural body." % avatar_id)
			_body_mesh.remove_child(imported_avatar)
			imported_avatar.queue_free()
			_build_procedural_fallback(body_color)
		else:
			_apply_individuality_tints(imported_avatar, body_color)
	else:
		_build_procedural_fallback(body_color)

func _apply_individuality_tints(root: Node, body_color: Color) -> void:
	## Recolor materials so default household Sims are not clones.
	var skin_hex := String(profile.genetics.get("skin_tone", ""))
	var hair_hex := String(profile.genetics.get("hair_color", ""))
	var skin := Color(skin_hex) if skin_hex.begins_with("#") else Color("#c99572")
	var hair := Color(hair_hex) if hair_hex.begins_with("#") else Color("#3a2a24")
	# Stable per-sim clothing variation from sim_id hash.
	var h: int = hash(profile.sim_id)
	var tops: Array = [Color("#5d98ca"), Color("#8b5a6b"), Color("#6b8f62"), Color("#c98980"), Color("#6d4f82"), Color("#4d8f93"), body_color]
	var bots: Array = [Color("#3f2d22"), Color("#252b2e"), Color("#4a5a6a"), Color("#5a4228"), Color("#2f3a48")]
	var top: Color = tops[abs(h) % tops.size()]
	var bot: Color = bots[abs(int(h / 7)) % bots.size()]
	var idx := 0
	for child in root.get_children():
		_tint_mesh_tree(child, skin, hair, top, bot, idx)
		idx += 1

func _tint_mesh_tree(node: Node, skin: Color, hair: Color, top: Color, bot: Color, part_index: int) -> void:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		var mat := StandardMaterial3D.new()
		# Heuristic: early parts are legs/torso/arms/head/hair in generator order.
		match part_index:
			0, 1:
				mat.albedo_color = bot
			2:
				mat.albedo_color = top
			3, 4:
				mat.albedo_color = skin
			5:
				mat.albedo_color = skin
			_:
				mat.albedo_color = hair
		mat.roughness = 0.78
		mi.material_override = mat
		mi.layers = AssetLibrary.RENDER_LAYER_WORLD
	for child in node.get_children():
		_tint_mesh_tree(child, skin, hair, top, bot, part_index)

func _build_procedural_fallback(body_color: Color) -> void:
	var skin := Color("#b98261")
	var pants := body_color.darkened(0.42)
	_add_box_part(Vector3(0.74, 0.82, 0.40), Vector3(0.0, 1.32, 0.0), body_color)
	_add_sphere_part(0.30, Vector3(0.0, 2.02, 0.0), skin)
	_add_cylinder_part(0.105, 0.78, Vector3(-0.25, 0.58, 0.0), pants)
	_add_cylinder_part(0.105, 0.78, Vector3(0.25, 0.58, 0.0), pants)
	_add_cylinder_part(0.08, 0.72, Vector3(-0.48, 1.36, 0.0), skin)
	_add_cylinder_part(0.08, 0.72, Vector3(0.48, 1.36, 0.0), skin)
	var hair := SphereMesh.new()
	hair.radius = 0.31
	hair.height = 0.34
	var hair_mesh := MeshInstance3D.new()
	hair_mesh.mesh = hair
	var hair_material := StandardMaterial3D.new()
	hair_material.albedo_color = Color("#3d322d")
	hair_material.roughness = 0.85
	hair_mesh.material_override = hair_material
	hair_mesh.position = Vector3(0.0, 2.18, -0.015)
	hair_mesh.scale = Vector3(1.0, 0.55, 1.0)
	hair_mesh.layers = AssetLibrary.RENDER_LAYER_WORLD
	_body_mesh.add_child(hair_mesh)

func _add_box_part(size: Vector3, position: Vector3, color: Color) -> void:
	var part := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	part.mesh = mesh
	part.position = position
	part.material_override = _character_material(color)
	part.layers = AssetLibrary.RENDER_LAYER_WORLD
	_body_mesh.add_child(part)

func _add_sphere_part(radius: float, position: Vector3, color: Color) -> void:
	var part := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	part.mesh = mesh
	part.position = position
	part.material_override = _character_material(color)
	part.layers = AssetLibrary.RENDER_LAYER_WORLD
	_body_mesh.add_child(part)

func _add_cylinder_part(radius: float, height: float, position: Vector3, color: Color) -> void:
	var part := MeshInstance3D.new()
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	part.mesh = mesh
	part.position = position
	part.material_override = _character_material(color)
	part.layers = AssetLibrary.RENDER_LAYER_WORLD
	_body_mesh.add_child(part)

func _character_material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.74
	return material

func set_selected(value: bool) -> void:
	selected = value
	if _selection_marker:
		_selection_marker.visible = value

func enqueue_interaction(interaction: Dictionary) -> bool:
	var accepted := queue.enqueue(interaction)
	if accepted:
		EventBus.interaction_queued.emit(profile.sim_id, String(interaction.get("id", "unknown")))
	return accepted

func cancel_all_interactions() -> void:
	queue.clear()
	_phase = "idle"
	velocity = Vector3.ZERO
	_route_points.clear()
	_route_index = 0

func tick_simulation(sim_minutes: float, occult_modifiers: Dictionary = {}) -> void:
	MotiveSystem.tick(motives, sim_minutes, occult_modifiers)
	for motive_id in MotiveSystem.MOTIVE_IDS:
		EventBus.motive_changed.emit(profile.sim_id, motive_id, float(motives[motive_id]))
	if queue.current.is_empty():
		return
	if _phase != "performing":
		return
	var duration := maxf(float(queue.current.get("duration_minutes", 30.0)), 1.0)
	queue.current["progress"] = float(queue.current.get("progress", 0.0)) + sim_minutes / duration
	if float(queue.current["progress"]) >= 1.0:
		_finish_current_interaction()

func _physics_process(delta: float) -> void:
	if profile == null:
		return
	if queue.current.is_empty():
		var next := queue.begin_next()
		if not next.is_empty():
			_phase = "moving"
			_load_route(next)
			EventBus.interaction_started.emit(profile.sim_id, String(next.get("id", "unknown")))
	if queue.current.is_empty():
		_phase = "idle"
		velocity = Vector3.ZERO
		_animate_locomotion(delta, false)
		return

	if _phase == "moving":
		_move_to_current_target(delta)
		_animate_locomotion(delta, true)
	elif _phase == "performing":
		velocity = Vector3.ZERO
		_animate_interaction(delta)
	else:
		_animate_locomotion(delta, false)


func _animate_locomotion(delta: float, moving: bool) -> void:
	if _body_mesh == null:
		return
	if moving:
		_anim_phase += delta * 9.0
		var bob := sin(_anim_phase) * 0.045
		var sway := sin(_anim_phase * 0.5) * 0.04
		_body_mesh.position.y = bob
		_body_mesh.rotation.z = sway
		_body_mesh.rotation.x = sin(_anim_phase) * 0.03
		_was_moving = true
	else:
		# Settle to idle breathing
		_anim_phase += delta * 2.2
		var breath := sin(_anim_phase) * 0.012
		_body_mesh.position.y = lerpf(_body_mesh.position.y, breath, clampf(delta * 8.0, 0.0, 1.0))
		_body_mesh.rotation.z = lerpf(_body_mesh.rotation.z, 0.0, clampf(delta * 6.0, 0.0, 1.0))
		_body_mesh.rotation.x = lerpf(_body_mesh.rotation.x, 0.0, clampf(delta * 6.0, 0.0, 1.0))
		if _was_moving:
			_was_moving = false

func _animate_interaction(delta: float) -> void:
	if _body_mesh == null:
		return
	_anim_phase += delta * 4.0
	# Gentle lean / task motion toward object instead of pure spin
	_body_mesh.rotation.x = lerpf(_body_mesh.rotation.x, -0.12 + sin(_anim_phase) * 0.04, clampf(delta * 5.0, 0.0, 1.0))
	_body_mesh.position.y = lerpf(_body_mesh.position.y, 0.02, clampf(delta * 5.0, 0.0, 1.0))
	var action := String(queue.current.get("id", ""))
	if action.contains("sit") or action.contains("relax") or action.contains("watch"):
		_body_mesh.position.y = -0.25
		_body_mesh.rotation.x = 0.35
	elif action.contains("sleep") or action.contains("nap"):
		_body_mesh.position.y = -0.55
		_body_mesh.rotation.x = 1.2
	elif action.contains("cook") or action.contains("wash") or action.contains("shower"):
		_body_mesh.rotation.x = -0.2
		_body_mesh.position.y = sin(_anim_phase) * 0.03

func _move_to_current_target(_delta: float) -> void:
	var final_target := _interaction_target_position(queue.current)
	var target := final_target
	if _route_index < _route_points.size():
		target = _route_points[_route_index]
	var planar_target := Vector3(target.x, global_position.y, target.z)
	var offset := planar_target - global_position
	var distance := offset.length()
	var arrival_radius := 0.35 if _route_index < _route_points.size() - 1 else 1.15
	if distance <= arrival_radius:
		if _route_index < _route_points.size() - 1:
			_route_index += 1
			return
		velocity = Vector3.ZERO
		_phase = "performing"
		return
	var speed_scale := {0: 0.0, 1: 1.0, 2: 3.0, 3: 7.0}
	var speed_multiplier := float(speed_scale.get(SimulationClock.speed_mode, 1.0))
	velocity = offset.normalized() * move_speed * speed_multiplier
	if velocity.length_squared() > 0.001:
		look_at(global_position + velocity, Vector3.UP)
	move_and_slide()

func _load_route(interaction: Dictionary) -> void:
	_route_points.clear()
	_route_index = 0
	for value in Array(interaction.get("route_points", [])):
		if value is Vector3:
			_route_points.append(value)
		elif value is Array and value.size() >= 3:
			_route_points.append(Vector3(float(value[0]), float(value[1]), float(value[2])))
	if _route_points.is_empty():
		_route_points.append(_interaction_target_position(interaction))

func _finish_current_interaction() -> void:
	var finished := queue.finish_current()
	MotiveSystem.apply_effects(motives, Dictionary(finished.get("motive_effects", {})))
	_phase = "idle"
	velocity = Vector3.ZERO
	_route_points.clear()
	_route_index = 0
	EventBus.interaction_finished.emit(profile.sim_id, String(finished.get("id", "unknown")))
	interaction_completed.emit(self, finished)

func _interaction_target_position(interaction: Dictionary) -> Vector3:
	var value: Variant = interaction.get("target_position", global_position)
	if value is Vector3:
		return value
	if value is Array and value.size() >= 3:
		return Vector3(float(value[0]), float(value[1]), float(value[2]))
	return global_position

func display_action() -> String:
	if queue.current.is_empty():
		return "Idle"
	var label := String(queue.current.get("name", queue.current.get("id", "Interaction")))
	if _phase == "moving":
		return "Going to %s" % String(queue.current.get("target_name", label))
	return "%s — %d%%" % [label, int(float(queue.current.get("progress", 0.0)) * 100.0)]

func serialize() -> Dictionary:
	var pending_serialized: Array = []
	for interaction in queue.pending:
		pending_serialized.append(_serialize_interaction(interaction))
	return {
		"profile": profile.to_dict(),
		"motives": motives,
		"position": [global_position.x, global_position.y, global_position.z],
		"rotation_y": rotation.y,
		"queue": {
			"pending": pending_serialized,
			"current": _serialize_interaction(queue.current),
		},
		"phase": _phase,
		"autonomy_enabled": autonomy_enabled,
	}

func deserialize(data: Dictionary) -> void:
	profile = SimProfile.new(Dictionary(data.get("profile", {})))
	motives = Dictionary(data.get("motives", MotiveSystem.make_default())).duplicate(true)
	var pos: Array = Array(data.get("position", [0.0, 0.0, 0.0]))
	if pos.size() >= 3:
		global_position = Vector3(float(pos[0]), float(pos[1]), float(pos[2]))
	rotation.y = float(data.get("rotation_y", 0.0))
	var queue_data: Dictionary = Dictionary(data.get("queue", {}))
	var restored_pending: Array[Dictionary] = []
	for item in Array(queue_data.get("pending", [])):
		if item is Dictionary:
			restored_pending.append(_deserialize_interaction(item))
	queue.pending = restored_pending
	queue.current = _deserialize_interaction(Dictionary(queue_data.get("current", {})))
	_phase = String(data.get("phase", "idle"))
	if not queue.current.is_empty():
		_load_route(queue.current)
	autonomy_enabled = bool(data.get("autonomy_enabled", true))
	if _name_label:
		_name_label.text = profile.full_name()
	_apply_age_geometry()

func _serialize_interaction(interaction: Dictionary) -> Dictionary:
	if interaction.is_empty():
		return {}
	var result := interaction.duplicate(true)
	var target: Variant = result.get("target_position")
	if target is Vector3:
		result["target_position"] = [target.x, target.y, target.z]
	var serialized_route: Array = []
	for point in Array(result.get("route_points", [])):
		if point is Vector3:
			serialized_route.append([point.x, point.y, point.z])
		elif point is Array:
			serialized_route.append(point)
	if not serialized_route.is_empty():
		result["route_points"] = serialized_route
	return result

func _deserialize_interaction(interaction: Dictionary) -> Dictionary:
	var result := interaction.duplicate(true)
	var target: Variant = result.get("target_position")
	if target is Array and target.size() >= 3:
		result["target_position"] = Vector3(float(target[0]), float(target[1]), float(target[2]))
	var restored_route: Array[Vector3] = []
	for point in Array(result.get("route_points", [])):
		if point is Array and point.size() >= 3:
			restored_route.append(Vector3(float(point[0]), float(point[1]), float(point[2])))
	if not restored_route.is_empty():
		result["route_points"] = restored_route
	return result

func refresh_profile_visuals() -> void:
	if _name_label and profile:
		_name_label.text = profile.full_name()
	if _body_mesh and profile:
		for child in _body_mesh.get_children():
			_body_mesh.remove_child(child)
			child.queue_free()
		_populate_body_visual(_body_color)
	_apply_age_geometry()

func refresh_visuals() -> void:
	if _body_mesh == null or profile == null:
		return
	for child in _body_mesh.get_children():
		_body_mesh.remove_child(child)
		child.queue_free()
	_populate_body_visual(_body_color)
	_apply_age_geometry()
