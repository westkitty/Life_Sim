class_name ServiceSystem
extends Node

const SERVICE_COSTS := {"maid": 125, "repair": 100, "babysitter": 75, "fire": 0, "police": 0, "delivery": 30}
var requests: Array[Dictionary] = []
var next_request_id := 1

func request(service_id: String, household_id: String, target_position := Vector3.ZERO) -> Dictionary:
	if not SERVICE_COSTS.has(service_id):
		return {}
	var request_data := {
		"id": "service_%04d" % next_request_id,
		"service_id": service_id,
		"household_id": household_id,
		"cost": int(SERVICE_COSTS[service_id]),
		"eta_minutes": 30.0,
		"position": [target_position.x, target_position.y, target_position.z],
		"status": "scheduled",
	}
	next_request_id += 1
	requests.append(request_data)
	return request_data

func tick(sim_minutes: float) -> Array[Dictionary]:
	var arrived: Array[Dictionary] = []
	for index in range(requests.size() - 1, -1, -1):
		var data: Dictionary = requests[index]
		data["eta_minutes"] = float(data.get("eta_minutes", 0.0)) - sim_minutes
		if float(data["eta_minutes"]) <= 0.0:
			data["status"] = "arrived"
			arrived.append(data.duplicate(true))
			requests.remove_at(index)
		else:
			requests[index] = data
	return arrived

func serialize() -> Dictionary:
	return {"requests": requests.duplicate(true), "next_request_id": next_request_id}

func deserialize(data: Dictionary) -> void:
	requests.assign(Array(data.get("requests", [])))
	next_request_id = int(data.get("next_request_id", 1))
