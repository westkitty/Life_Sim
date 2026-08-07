class_name BuildGridSystem
extends Node

var grid_size := 1.0
var lots: Dictionary = {}
var occupancy: Dictionary = {}
var object_cells: Dictionary = {}

func configure_lots(definitions: Array, cell_size := 1.0) -> void:
	grid_size = maxf(float(cell_size), 0.25)
	lots.clear()
	for entry in definitions:
		if not entry is Dictionary:
			continue
		var lot_id := String(entry.get("id", ""))
		if lot_id.is_empty():
			continue
		var center_value: Variant = entry.get("center", Vector2.ZERO)
		var size_value: Variant = entry.get("size", Vector2(10.0, 10.0))
		var center := _to_vec2(center_value)
		var size := _to_vec2(size_value)
		lots[lot_id] = Rect2(center - size * 0.5, size)

func clear_occupancy() -> void:
	occupancy.clear()
	object_cells.clear()

func world_to_cell(position: Vector3) -> Vector2i:
	return Vector2i(int(round(position.x / grid_size)), int(round(position.z / grid_size)))

func cell_to_world(cell: Vector2i, y := 0.0) -> Vector3:
	return Vector3(float(cell.x) * grid_size, y, float(cell.y) * grid_size)

func snapped_position(position: Vector3) -> Vector3:
	return cell_to_world(world_to_cell(position), 0.0)

func lot_for_position(position: Vector3) -> String:
	var point := Vector2(position.x, position.z)
	for lot_id in lots.keys():
		var rect: Rect2 = lots[lot_id]
		if rect.has_point(point):
			return String(lot_id)
	return ""

func rotated_footprint(footprint: Vector2i, rotation_y: float) -> Vector2i:
	var quarter_turn := posmod(int(round(rotation_y / (PI * 0.5))), 4)
	if quarter_turn % 2 == 1:
		return Vector2i(footprint.y, footprint.x)
	return footprint

func cells_for(position: Vector3, footprint: Vector2i, rotation_y := 0.0) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var center_cell := world_to_cell(position)
	var size := rotated_footprint(footprint, rotation_y)
	var start_x := center_cell.x - int(floor(float(size.x - 1) * 0.5))
	var start_z := center_cell.y - int(floor(float(size.y - 1) * 0.5))
	for x in range(start_x, start_x + size.x):
		for z in range(start_z, start_z + size.y):
			result.append(Vector2i(x, z))
	return result

func validate_placement(position: Vector3, footprint: Vector2i, rotation_y := 0.0, ignore_object_id := "") -> Dictionary:
	var snapped := snapped_position(position)
	var lot_id := lot_for_position(snapped)
	if lot_id.is_empty():
		return {"ok": false, "reason": "Objects must be placed inside a buildable lot.", "position": snapped}
	var rect: Rect2 = lots[lot_id]
	for cell in cells_for(snapped, footprint, rotation_y):
		var world_point := cell_to_world(cell)
		if not rect.has_point(Vector2(world_point.x, world_point.z)):
			return {"ok": false, "reason": "The footprint crosses the lot boundary.", "position": snapped, "lot_id": lot_id}
		var key := _cell_key(cell)
		if occupancy.has(key) and String(occupancy[key]) != ignore_object_id:
			return {"ok": false, "reason": "That grid footprint is already occupied.", "position": snapped, "lot_id": lot_id}
	return {"ok": true, "reason": "", "position": snapped, "lot_id": lot_id}

func register_object(object_id: String, position: Vector3, footprint: Vector2i, rotation_y := 0.0) -> bool:
	var validation := validate_placement(position, footprint, rotation_y, object_id)
	if not bool(validation.get("ok", false)):
		return false
	unregister_object(object_id)
	var occupied: Array[Vector2i] = cells_for(Vector3(validation["position"]), footprint, rotation_y)
	object_cells[object_id] = occupied
	for cell in occupied:
		occupancy[_cell_key(cell)] = object_id
	return true

func unregister_object(object_id: String) -> void:
	for cell_value in Array(object_cells.get(object_id, [])):
		if not cell_value is Vector2i:
			continue
		var cell: Vector2i = cell_value
		var key := _cell_key(cell)
		if String(occupancy.get(key, "")) == object_id:
			occupancy.erase(key)
	object_cells.erase(object_id)

func is_cell_blocked(cell: Vector2i) -> bool:
	return occupancy.has(_cell_key(cell))

func occupied_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for key in occupancy.keys():
		var parts := String(key).split(":")
		if parts.size() == 2:
			result.append(Vector2i(int(parts[0]), int(parts[1])))
	return result

func serialize() -> Dictionary:
	return {"grid_size": grid_size, "occupancy": occupancy.duplicate(true), "object_cells": object_cells.duplicate(true)}

func _cell_key(cell: Vector2i) -> String:
	return "%d:%d" % [cell.x, cell.y]

func _to_vec2(value: Variant) -> Vector2:
	if value is Vector2:
		return value
	if value is Vector3:
		return Vector2(value.x, value.z)
	if value is Array and value.size() >= 2:
		return Vector2(float(value[0]), float(value[1]))
	return Vector2.ZERO
