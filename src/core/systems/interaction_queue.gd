class_name InteractionQueue
extends RefCounted

const MAX_QUEUE_SIZE := 8

var pending: Array[Dictionary] = []
var current: Dictionary = {}

func enqueue(interaction: Dictionary) -> bool:
	if pending.size() >= MAX_QUEUE_SIZE:
		return false
	pending.append(interaction.duplicate(true))
	return true

func push_front(interaction: Dictionary) -> bool:
	if pending.size() >= MAX_QUEUE_SIZE:
		return false
	pending.push_front(interaction.duplicate(true))
	return true

func begin_next() -> Dictionary:
	if not current.is_empty() or pending.is_empty():
		return current
	current = pending.pop_front()
	current["progress"] = 0.0
	return current

func finish_current() -> Dictionary:
	var finished := current.duplicate(true)
	current.clear()
	return finished

func cancel_current() -> void:
	current.clear()

func clear() -> void:
	pending.clear()
	current.clear()

func serialize() -> Dictionary:
	return {"pending": pending, "current": current}

func deserialize(data: Dictionary) -> void:
	pending.clear()
	for item in Array(data.get("pending", [])):
		if item is Dictionary:
			pending.append(Dictionary(item).duplicate(true))
	current = Dictionary(data.get("current", {})).duplicate(true)
