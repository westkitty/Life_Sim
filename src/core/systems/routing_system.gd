class_name RoutingSystem
extends Node

var world_min := Vector2i(-48, -48)
var world_size := Vector2i(97, 97)
var grid_size := 1.0
var build_grid: BuildGridSystem
## Axis-aligned world-space footprints (Rect2 in XZ) for architecture that is not
## part of the Build/Buy occupancy grid, e.g. houses and community buildings.
var structure_blockers: Array[Rect2] = []
var _astar := AStarGrid2D.new()
var _dirty := true

func configure(grid: BuildGridSystem, minimum := Vector2i(-48, -48), size := Vector2i(97, 97)) -> void:
	build_grid = grid
	world_min = minimum
	world_size = size
	grid_size = grid.grid_size if grid != null else 1.0
	_dirty = true

func set_structure_blockers(blockers: Array) -> void:
	structure_blockers.clear()
	for entry in blockers:
		if entry is Rect2:
			structure_blockers.append(entry)
		elif entry is Dictionary:
			var center: Vector3 = entry.get("center", Vector3.ZERO)
			var size: Vector3 = entry.get("size", Vector3.ONE)
			structure_blockers.append(Rect2(
				Vector2(center.x - size.x * 0.5, center.z - size.z * 0.5),
				Vector2(size.x, size.z)
			))
	_dirty = true

func mark_dirty() -> void:
	_dirty = true

func rebuild() -> void:
	_astar = AStarGrid2D.new()
	_astar.region = Rect2i(world_min, world_size)
	_astar.cell_size = Vector2(grid_size, grid_size)
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	_astar.update()
	if build_grid != null:
		for cell in build_grid.occupied_cells():
			if _astar.is_in_boundsv(cell):
				_astar.set_point_solid(cell, true)
	for rect in structure_blockers:
		for cell in _cells_for_rect(rect):
			if _astar.is_in_boundsv(cell):
				_astar.set_point_solid(cell, true)
	_dirty = false

## Returns an empty array when no legal route exists. Callers must treat an
## empty result as route failure; the router never fabricates a straight line
## through blocked geometry.
func route(from_position: Vector3, to_position: Vector3, keep_last_clear := true) -> Array[Vector3]:
	if _dirty:
		rebuild()
	var empty_route: Array[Vector3] = []
	var start := _world_to_cell(from_position)
	var finish := _world_to_cell(to_position)
	if not _astar.is_in_boundsv(start) or not _astar.is_in_boundsv(finish):
		return empty_route
	# Every temporary solid-state relaxation is restored before returning so
	# navigation state cannot leak between routing calls.
	var start_was_solid := _astar.is_point_solid(start)
	if start_was_solid:
		_astar.set_point_solid(start, false)
	var finish_was_solid := _astar.is_point_solid(finish)
	if finish_was_solid:
		_astar.set_point_solid(finish, false)
	# allow_partial_path must stay false: a partial path is exactly the
	# "walk as far as you can, then phase through" behaviour this repairs.
	var path2d: PackedVector2Array = _astar.get_point_path(start, finish, false)
	if finish_was_solid:
		_astar.set_point_solid(finish, true)
	if start_was_solid:
		_astar.set_point_solid(start, true)
	if path2d.is_empty():
		return empty_route
	var result: Array[Vector3] = []
	for point in path2d:
		result.append(Vector3(point.x, from_position.y, point.y))
	if keep_last_clear:
		result[result.size() - 1] = Vector3(to_position.x, from_position.y, to_position.z)
	return _simplify(result)

func is_reachable(from_position: Vector3, to_position: Vector3) -> bool:
	return not route(from_position, to_position).is_empty()

func is_position_blocked(position: Vector3) -> bool:
	if _dirty:
		rebuild()
	var cell := _world_to_cell(position)
	if not _astar.is_in_boundsv(cell):
		return true
	return _astar.is_point_solid(cell)

func _cells_for_rect(rect: Rect2) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var min_cell := Vector2i(int(floor(rect.position.x / grid_size)), int(floor(rect.position.y / grid_size)))
	var max_cell := Vector2i(int(ceil(rect.end.x / grid_size)), int(ceil(rect.end.y / grid_size)))
	for x in range(min_cell.x, max_cell.x + 1):
		for z in range(min_cell.y, max_cell.y + 1):
			result.append(Vector2i(x, z))
	return result

func _simplify(points: Array[Vector3]) -> Array[Vector3]:
	if points.size() < 3:
		return points
	var result: Array[Vector3] = []
	result.append(points[0])
	var previous_direction := Vector2.ZERO
	for index in range(1, points.size()):
		var delta := points[index] - points[index - 1]
		var direction := Vector2(sign(delta.x), sign(delta.z))
		if index > 1 and direction != previous_direction:
			result.append(points[index - 1])
		previous_direction = direction
	result.append(points[points.size() - 1])
	return result

func _world_to_cell(position: Vector3) -> Vector2i:
	return Vector2i(int(round(position.x / grid_size)), int(round(position.z / grid_size)))
