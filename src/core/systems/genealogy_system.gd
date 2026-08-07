class_name GenealogySystem
extends Node

var parents: Dictionary = {}
var children: Dictionary = {}
var siblings: Dictionary = {}

## Named `record_birth` rather than `add_child` because GenealogySystem extends
## Node, and redeclaring Node.add_child with a different signature is a parse
## error in GDScript 4.7.
func record_birth(child_id: String, parent_a_id: String, parent_b_id: String) -> void:
	var parent_ids: Array[String] = []
	if not parent_a_id.is_empty():
		parent_ids.append(parent_a_id)
	if not parent_b_id.is_empty() and parent_b_id != parent_a_id:
		parent_ids.append(parent_b_id)
	parents[child_id] = parent_ids
	for parent_id in parent_ids:
		var list: Array = Array(children.get(parent_id, []))
		if child_id not in list:
			list.append(child_id)
		children[parent_id] = list
	_refresh_siblings(parent_ids)

func relation_between(first_id: String, second_id: String) -> String:
	if first_id == second_id:
		return "self"
	if second_id in Array(parents.get(first_id, [])):
		return "parent"
	if second_id in Array(children.get(first_id, [])):
		return "child"
	if second_id in Array(siblings.get(first_id, [])):
		return "sibling"
	return "unrelated"

func _refresh_siblings(parent_ids: Array[String]) -> void:
	var all_children: Array[String] = []
	for parent_id in parent_ids:
		for child_id in Array(children.get(parent_id, [])):
			if String(child_id) not in all_children:
				all_children.append(String(child_id))
	for child_id in all_children:
		var list: Array[String] = []
		for sibling_id in all_children:
			if sibling_id != child_id:
				list.append(sibling_id)
		siblings[child_id] = list

func serialize() -> Dictionary:
	return {"parents": parents.duplicate(true), "children": children.duplicate(true), "siblings": siblings.duplicate(true)}

func deserialize(data: Dictionary) -> void:
	parents = Dictionary(data.get("parents", {})).duplicate(true)
	children = Dictionary(data.get("children", {})).duplicate(true)
	siblings = Dictionary(data.get("siblings", {})).duplicate(true)
