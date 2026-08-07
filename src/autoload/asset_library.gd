extends Node

## Project-owned asset boundary.
##
## Resolves stable asset ids through `data/asset_aliases.json` and instantiates
## models. A model is only accepted when it actually contains renderable,
## visible, sanely-sized geometry — a `PackedScene` whose root happens to be a
## `Node3D` is NOT proof that anything will appear on screen. Callers that get
## `null` are expected to build their project-owned procedural fallback, which is
## how "invisible object plus floating label" is made impossible.

const ALIAS_PATH := "res://data/asset_aliases.json"

## Rendering visibility layer for all world geometry. Kept distinct from the
## physics collision-layer constants so the two can never be confused.
const RENDER_LAYER_WORLD := 1

## Bounds smaller than this in every axis cannot be seen at gameplay distances.
const MIN_VISIBLE_EXTENT := 0.02
## Bounds larger than this are almost certainly an authoring/scale error.
const MAX_VISIBLE_EXTENT := 400.0

var aliases: Dictionary = {}
## Asset ids already reported as visually invalid, so the log stays readable.
var _reported_failures: Dictionary = {}
var _validation_stats := {"accepted": 0, "rejected": 0}

func _ready() -> void:
	_reload_aliases()

func _reload_aliases() -> void:
	aliases.clear()
	if not FileAccess.file_exists(ALIAS_PATH):
		push_warning("OpenLife asset alias table missing: %s" % ALIAS_PATH)
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(ALIAS_PATH))
	if parsed is Dictionary:
		aliases = Dictionary(parsed)
	else:
		push_warning("OpenLife asset alias table is invalid JSON.")

func path_for(asset_id: String) -> String:
	return String(aliases.get(asset_id, ""))

func has_asset(asset_id: String) -> bool:
	var path := path_for(asset_id)
	return not path.is_empty() and ResourceLoader.exists(path)

## Instantiates a model and returns it only when it is provably renderable.
## Returns null for a missing, unloadable or visually empty asset so the caller
## falls back to project-owned procedural geometry.
func instantiate_model(asset_id: String) -> Node3D:
	var path := path_for(asset_id)
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource := load(path)
	if not resource is PackedScene:
		_report_failure(asset_id, "resource is not a PackedScene")
		return null
	var instance: Node = (resource as PackedScene).instantiate()
	if not instance is Node3D:
		if instance != null:
			instance.queue_free()
		_report_failure(asset_id, "instantiated root is not a Node3D")
		return null
	var model: Node3D = instance
	var report := validate_visual_instance(model)
	if not bool(report.get("ok", false)):
		_report_failure(asset_id, String(report.get("reason", "no renderable geometry")))
		model.queue_free()
		_validation_stats["rejected"] = int(_validation_stats["rejected"]) + 1
		return null
	_prepare_for_rendering(model)
	_validation_stats["accepted"] = int(_validation_stats["accepted"]) + 1
	return model

## Inspects an instantiated model and reports measured facts about whether it
## can actually be seen. Used by the runtime, the diagnostics harness and the
## visual regression test.
func validate_visual_instance(instance: Node3D) -> Dictionary:
	var report := {
		"ok": false,
		"reason": "",
		"mesh_count": 0,
		"visible_mesh_count": 0,
		"surface_count": 0,
		"invalid_transforms": 0,
		"zero_scale_nodes": 0,
		"fully_transparent": false,
		"bounds": AABB(),
		"size": Vector3.ZERO,
	}
	if instance == null:
		report["reason"] = "instance is null"
		return report

	var meshes: Array[MeshInstance3D] = []
	_collect_mesh_instances(instance, meshes)
	report["mesh_count"] = meshes.size()
	if meshes.is_empty():
		report["reason"] = "no MeshInstance3D nodes"
		return report

	var combined := AABB()
	var have_bounds := false
	var visible_meshes := 0
	var surfaces := 0
	var invalid_transforms := 0
	var zero_scale := 0
	var opaque_surfaces := 0

	for mesh_instance in meshes:
		var mesh := mesh_instance.mesh
		if mesh == null:
			continue
		var surface_count := mesh.get_surface_count()
		if surface_count <= 0:
			continue
		surfaces += surface_count
		var transform := _relative_transform(instance, mesh_instance)
		if not _is_finite_transform(transform):
			invalid_transforms += 1
			continue
		var scale := transform.basis.get_scale()
		if minf(absf(scale.x), minf(absf(scale.y), absf(scale.z))) <= 0.00001:
			zero_scale += 1
			continue
		if not mesh_instance.visible:
			continue
		visible_meshes += 1
		if _has_opaque_surface(mesh_instance, mesh):
			opaque_surfaces += 1
		var local_bounds := transform * mesh.get_aabb()
		combined = local_bounds if not have_bounds else combined.merge(local_bounds)
		have_bounds = true

	report["visible_mesh_count"] = visible_meshes
	report["surface_count"] = surfaces
	report["invalid_transforms"] = invalid_transforms
	report["zero_scale_nodes"] = zero_scale
	report["fully_transparent"] = visible_meshes > 0 and opaque_surfaces == 0

	if surfaces == 0:
		report["reason"] = "meshes exist but contain no surfaces"
		return report
	if visible_meshes == 0:
		report["reason"] = "no visible mesh with a usable transform"
		return report
	if not have_bounds:
		report["reason"] = "could not compute bounds"
		return report

	report["bounds"] = combined
	report["size"] = combined.size
	if not _is_finite_vector(combined.position) or not _is_finite_vector(combined.size):
		report["reason"] = "bounds are not finite"
		return report
	var longest := maxf(combined.size.x, maxf(combined.size.y, combined.size.z))
	if longest < MIN_VISIBLE_EXTENT:
		report["reason"] = "bounds are degenerate (longest extent %.5f)" % longest
		return report
	if longest > MAX_VISIBLE_EXTENT:
		report["reason"] = "bounds are implausibly large (longest extent %.1f)" % longest
		return report
	if bool(report["fully_transparent"]):
		report["reason"] = "every surface material is fully transparent"
		return report

	report["ok"] = true
	return report

func validation_stats() -> Dictionary:
	return _validation_stats.duplicate()

## Post-parenting check: confirms a node that is already inside the scene tree
## still has at least one mesh that is actually visible in the tree. Catches a
## hidden ancestor or a zero scale applied after instantiation.
func instance_has_visible_geometry(node: Node3D) -> bool:
	if node == null or not is_instance_valid(node):
		return false
	var meshes: Array[MeshInstance3D] = []
	_collect_mesh_instances(node, meshes)
	for mesh_instance in meshes:
		if mesh_instance.mesh == null or mesh_instance.mesh.get_surface_count() <= 0:
			continue
		if not mesh_instance.is_visible_in_tree():
			continue
		var scale := mesh_instance.global_transform.basis.get_scale() if mesh_instance.is_inside_tree() else mesh_instance.transform.basis.get_scale()
		if minf(absf(scale.x), minf(absf(scale.y), absf(scale.z))) <= 0.00001:
			continue
		return true
	return false

## Counts visible, renderable meshes beneath a node. Used by the visual
## regression test to assert the running scene contains real geometry.
func count_visible_meshes(node: Node) -> int:
	var meshes: Array[MeshInstance3D] = []
	_collect_mesh_instances(node, meshes)
	var total := 0
	for mesh_instance in meshes:
		if mesh_instance.mesh != null and mesh_instance.mesh.get_surface_count() > 0 and mesh_instance.is_visible_in_tree():
			total += 1
	return total

## Forces every mesh in an accepted model onto the world render layer and makes
## sure nothing arrives hidden from a stale authoring flag.
func _prepare_for_rendering(model: Node3D) -> void:
	model.visible = true
	var meshes: Array[MeshInstance3D] = []
	_collect_mesh_instances(model, meshes)
	for mesh_instance in meshes:
		mesh_instance.visible = true
		mesh_instance.layers = RENDER_LAYER_WORLD

func _collect_mesh_instances(node: Node, output: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		output.append(node)
	for child in node.get_children():
		_collect_mesh_instances(child, output)

## Transform of `node` relative to `root`, walking only inside the model.
func _relative_transform(root: Node3D, node: Node3D) -> Transform3D:
	var transform := Transform3D.IDENTITY
	var current: Node = node
	while current != null and current != root:
		if current is Node3D:
			transform = (current as Node3D).transform * transform
		current = current.get_parent()
	return transform

func _is_finite_transform(transform: Transform3D) -> bool:
	return _is_finite_vector(transform.origin) \
		and _is_finite_vector(transform.basis.x) \
		and _is_finite_vector(transform.basis.y) \
		and _is_finite_vector(transform.basis.z)

func _is_finite_vector(value: Vector3) -> bool:
	return is_finite(value.x) and is_finite(value.y) and is_finite(value.z)

## True when at least one surface would actually paint pixels.
func _has_opaque_surface(mesh_instance: MeshInstance3D, mesh: Mesh) -> bool:
	for surface in mesh.get_surface_count():
		var material := mesh_instance.get_active_material(surface)
		if material == null:
			return true
		if material is StandardMaterial3D:
			var standard: StandardMaterial3D = material
			if standard.albedo_color.a > 0.02:
				return true
		elif material is ORMMaterial3D:
			var orm: ORMMaterial3D = material
			if orm.albedo_color.a > 0.02:
				return true
		else:
			return true
	return false

func _report_failure(asset_id: String, reason: String) -> void:
	if _reported_failures.has(asset_id):
		return
	_reported_failures[asset_id] = reason
	push_warning("OpenLife asset '%s' has no usable visible geometry (%s); using procedural fallback." % [asset_id, reason])

func audio_stream(asset_id: String) -> AudioStream:
	var path := path_for(asset_id)
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource := load(path)
	if resource is AudioStream:
		return resource
	return null

func texture_asset(asset_id: String) -> Texture2D:
	var path := path_for(asset_id)
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	var resource := load(path)
	if resource is Texture2D:
		return resource
	return null
